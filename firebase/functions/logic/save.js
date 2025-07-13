const { getFirestore, FieldValue } = require('firebase-admin/firestore');

/**
 * 공고 저장
 * @param {Object} params - 저장 파라미터
 * @param {string} params.noticeId - 공고 ID
 * @param {string} params.userId - 사용자 ID
 */
async function saveNoticeLogic({ noticeId, userId }) {
  const db = getFirestore();

  // 공고가 어느 컬렉션에 속하는지 확인
  const [shDoc, ghDoc, bmcDoc, ihDoc] = await Promise.all([
    db.collection('sh').doc(noticeId).get(),
    db.collection('gh').doc(noticeId).get(),
    db.collection('bmc').doc(noticeId).get(),
    db.collection('ih').doc(noticeId).get(),
  ]);

  let corporation = null;
  if (shDoc.exists) {
    corporation = 'sh';
  } else if (ghDoc.exists) {
    corporation = 'gh';
  } else if (bmcDoc.exists) {
    corporation = 'bmc';
  } else if (ihDoc.exists) {
    corporation = 'ih';
  } else {
    throw new Error('Notice not found');
  }

  const saveRef = db.collection('save').doc(`${userId}_${noticeId}`);
  await saveRef.set(
    {
      userId,
      noticeId,
      corporation,
      createdAt: FieldValue.serverTimestamp(),
    },
    { merge: true },
  );
}

/**
 * 공고 삭제
 * @param {Object} params - 삭제 파라미터
 * @param {string} params.noticeId - 공고 ID
 * @param {string} params.userId - 사용자 ID
 */
async function deleteNoticeLogic({ noticeId, userId }) {
  const db = getFirestore();
  const saveRef = db.collection('save').doc(`${userId}_${noticeId}`);
  await saveRef.delete();
}

/**
 * 공고 저장 여부 확인
 * @param {Object} params - 확인 파라미터
 * @param {string} params.noticeId - 공고 ID
 * @param {string} params.userId - 사용자 ID
 * @return {Object} 저장 여부 객체
 */
async function getNoticeSavedLogic({ noticeId, userId }) {
  const db = getFirestore();
  const saveRef = db.collection('save').doc(`${userId}_${noticeId}`);
  const doc = await saveRef.get();
  return { saved: doc.exists };
}

/**
 * 사용자가 저장한 공고 목록 조회
 * @param {Object} params - 조회 파라미터
 * @param {string} params.userId - 사용자 ID
 * @param {string} params.corporation - 기관 필터 (옵션)
 * @param {number} params.limit - 조회 개수 (기본값: 5)
 * @param {number} params.offset - 오프셋 (기본값: 0)
 * @return {Object} 저장된 공고 목록 및 메타데이터
 */
async function getSavedNoticesLogic({
  userId,
  corporation,
  limit = 5,
  offset = 0,
}) {
  // 파라미터 타입 변환 및 검증
  const limitNum = Math.max(1, Math.min(parseInt(limit, 10) || 5, 50));
  const offsetNum = Math.max(0, parseInt(offset, 10) || 0);

  const db = getFirestore();

  // 1. 전체 저장된 공고 개수 조회를 위한 쿼리들
  const totalSaveQuery = db.collection('save').where('userId', '==', userId);

  const shSaveQuery = db
    .collection('save')
    .where('userId', '==', userId)
    .where('corporation', '==', 'sh');

  const ghSaveQuery = db
    .collection('save')
    .where('userId', '==', userId)
    .where('corporation', '==', 'gh');

  const bmcSaveQuery = db
    .collection('save')
    .where('userId', '==', userId)
    .where('corporation', '==', 'bmc');

  const ihSaveQuery = db
    .collection('save')
    .where('userId', '==', userId)
    .where('corporation', '==', 'ih');

  // 병렬로 카운트 조회
  const [totalSnapshot, shSnapshot, ghSnapshot, bmcSnapshot, ihSnapshot] =
    await Promise.all([
      totalSaveQuery.get(),
      shSaveQuery.get(),
      ghSaveQuery.get(),
      bmcSaveQuery.get(),
      ihSaveQuery.get(),
    ]);

  const totalCount = totalSnapshot.size;
  const shCount = shSnapshot.size;
  const ghCount = ghSnapshot.size;
  const bmcCount = bmcSnapshot.size;
  const ihCount = ihSnapshot.size;

  // 2. corporation 필터링에 따른 데이터 조회
  let saveQuery = db.collection('save').where('userId', '==', userId);

  // corporation 필터 적용
  if (corporation) {
    saveQuery = saveQuery.where('corporation', '==', corporation);
  }

  // 정렬 및 페이지네이션 적용
  saveQuery = saveQuery
    .orderBy('createdAt', 'desc')
    .offset(offsetNum)
    .limit(limitNum);

  const saveSnapshot = await saveQuery.get();

  if (saveSnapshot.empty) {
    return {
      notices: [],
      hasMore: false,
      nextOffset: offsetNum,
      totalFetched: 0,
      totalCount,
      shCount,
      ghCount,
      bmcCount,
      ihCount,
    };
  }

  const savedNotices = saveSnapshot.docs.map((doc) => doc.data());

  // 3. 각 공고의 상세 정보를 병렬로 조회
  const noticePromises = savedNotices.map(async (saveData) => {
    const { noticeId, corporation: savedCorporation } = saveData;

    // 저장된 corporation 정보를 이용해 직접 조회
    const noticeDoc = await db.collection(savedCorporation).doc(noticeId).get();

    if (noticeDoc.exists) {
      return {
        collection: savedCorporation,
        id: noticeDoc.id,
        ...noticeDoc.data(),
      };
    }

    return null; // 공고가 삭제된 경우
  });

  const noticeResults = await Promise.all(noticePromises);

  // null 값 제거 (삭제된 공고)
  const notices = noticeResults.filter((notice) => notice !== null);

  // 4. 다음 페이지 존재 여부 확인
  let nextPageQuery = db.collection('save').where('userId', '==', userId);

  if (corporation) {
    nextPageQuery = nextPageQuery.where('corporation', '==', corporation);
  }

  nextPageQuery = nextPageQuery
    .orderBy('createdAt', 'desc')
    .offset(offsetNum + limitNum)
    .limit(1);

  const nextPageSnapshot = await nextPageQuery.get();
  const hasMore = !nextPageSnapshot.empty;

  return {
    notices,
    hasMore,
    nextOffset: offsetNum + limitNum,
    totalFetched: notices.length,
    totalCount,
    shCount,
    ghCount,
    bmcCount,
    ihCount,
  };
}

module.exports = {
  saveNoticeLogic,
  deleteNoticeLogic,
  getNoticeSavedLogic,
  getSavedNoticesLogic,
};
