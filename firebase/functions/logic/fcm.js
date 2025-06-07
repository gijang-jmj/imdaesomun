const { getFirestore, FieldValue } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

/**
 * FCM 토큰 등록/갱신 로직
 * @param {Object} params - 토큰 등록 파라미터
 * @param {string} params.token - FCM 토큰
 * @param {string} params.userId - 사용자 ID (옵션)
 * @param {string} params.device - 디바이스 정보 (옵션)
 */
async function registerFcmTokenLogic({ token, userId, device }) {
  const db = getFirestore();
  const tokenRef = db.collection('fcm').doc(token);
  const docSnap = await tokenRef.get();

  const dataToSet = {
    token,
    userId: userId || null,
    device: device || null,
    createdAt: FieldValue.serverTimestamp(),
    ...((!docSnap.exists || docSnap.data().allowed === undefined) && {
      allowed: false,
    }),
  };

  await tokenRef.set(dataToSet, { merge: true });
}

/**
 * FCM 푸시 알림 허용 여부 조회
 * @param {string} token - FCM 토큰
 * @return {Object} 허용 여부 객체
 */
async function getPushAllowedLogic(token) {
  const db = getFirestore();
  const doc = await db.collection('fcm').doc(token).get();
  let allowed = false;

  if (doc.exists && doc.data().allowed !== undefined) {
    allowed = doc.data().allowed;
  }

  return { allowed };
}

/**
 * FCM 푸시 알림 허용 여부 설정
 * @param {Object} params - 설정 파라미터
 * @param {string} params.token - FCM 토큰
 * @param {boolean} params.allowed - 허용 여부
 * @param {string} params.userId - 사용자 ID (옵션)
 * @param {string} params.device - 디바이스 정보 (옵션)
 */
async function setPushAllowedLogic({ token, allowed, userId, device }) {
  const db = getFirestore();
  const tokenRef = db.collection('fcm').doc(token);
  const docSnap = await tokenRef.get();

  if (!docSnap.exists) {
    await registerFcmTokenLogic({ token, userId, device });
  }

  await tokenRef.set({ allowed }, { merge: true });
}

/**
 * FCM 전체 메시지 전송 (배치 처리)
 * @param {Object} params - 메시지 파라미터
 * @param {string} params.title - 메시지 제목
 * @param {string} params.body - 메시지 내용
 * @param {Object} params.data - 추가 데이터 (옵션)
 * @return {Object} 전송 결과
 */
async function sendFcmToAllLogic({ title, body, data }) {
  const db = getFirestore();
  const snapshot = await db
    .collection('fcm')
    .where('allowed', '==', true)
    .get();

  const tokens = snapshot.docs.map((doc) => doc.id);
  const messaging = getMessaging();
  const BATCH_SIZE = 500;
  const messageBatches = [];

  for (let i = 0; i < tokens.length; i += BATCH_SIZE) {
    messageBatches.push(tokens.slice(i, i + BATCH_SIZE));
  }

  let numSent = 0;
  await Promise.all(
    messageBatches.map(async (batch) => {
      const message = {
        tokens: batch,
        notification: {
          title,
          body,
        },
        data,
      };
      const response = await messaging.sendEachForMulticast(message);
      numSent += response.successCount;
    }),
  );

  return {
    message: 'FCM sent to all tokens.',
    successCount: numSent,
    failureCount: tokens.length - numSent,
  };
}

module.exports = {
  registerFcmTokenLogic,
  getPushAllowedLogic,
  setPushAllowedLogic,
  sendFcmToAllLogic,
};
