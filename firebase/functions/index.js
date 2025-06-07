// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const { logger } = require('firebase-functions');
const { onRequest } = require('firebase-functions/v2/https');
const { getFirestore } = require('firebase-admin/firestore');
const { FieldValue } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');
const { initializeApp } = require('firebase-admin/app');
const { scrapeShNotices, scrapeGhNotices } = require('./scrape');

initializeApp();

/**
 * 공고 크롤링
 */
exports.scrapeNotices = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      if (req.method !== 'POST') {
        return res.status(404).send({ error: 'Not Found' });
      }

      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      await Promise.all([scrapeShNotices(), scrapeGhNotices()]);

      res
        .status(200)
        .send({ message: 'Notices scraped and saved successfully.' });
    } catch (error) {
      res.status(500).send({ error: 'Failed to scrape notices.' });
      logger.error('Error Scraped notices:', error);
    }
  },
);

/**
 * SH 공고 가져오기
 */
exports.getShNotices = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const db = getFirestore();
      const snapshot = await db
        .collection('sh')
        .orderBy('no', 'desc')
        .limit(10)
        .get();
      const notices = snapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      res.status(200).send(notices);
    } catch (error) {
      res.status(500).send({ error: 'Failed to fetch SH notices.' });
      logger.error('[SH] Error fetching notices:', error);
    }
  },
);

/**
 * GH 공고 가져오기
 */
exports.getGhNotices = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const db = getFirestore();
      const snapshot = await db
        .collection('gh')
        .orderBy('no', 'desc')
        .limit(10)
        .get();
      const notices = snapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      res.status(200).send(notices);
    } catch (error) {
      res.status(500).send({ error: 'Failed to fetch GH notices.' });
      logger.error('[GH] Error fetching notices:', error);
    }
  },
);

/**
 * SH/GH 공고 조회
 */
exports.getNoticeById = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const { noticeId } = req.query;

      if (!noticeId) {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

      const db = getFirestore();
      const [shDoc, ghDoc] = await Promise.all([
        db.collection('sh').doc(noticeId).get(),
        db.collection('gh').doc(noticeId).get(),
      ]);

      if (shDoc.exists) {
        return res
          .status(200)
          .send({ collection: 'sh', id: shDoc.id, ...shDoc.data() });
      }

      if (ghDoc.exists) {
        return res
          .status(200)
          .send({ collection: 'gh', id: ghDoc.id, ...ghDoc.data() });
      }

      return res.status(404).send({ error: 'Notice not found.' });
    } catch (error) {
      res.status(500).send({ error: 'Failed to fetch notice.' });
      logger.error('[SH/GH] Error fetching notice by id:', error);
    }
  },
);

/**
 * FCM 토큰 등록/갱신
 * POST /registerFcmToken
 * body: { token: string, userId?: string }
 */
exports.registerFcmToken = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      if (req.method !== 'POST') {
        return res.status(404).send({ error: 'Not Found' });
      }

      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const { token, userId, device } = req.body;

      if (!token) {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

      const db = getFirestore();
      const tokenRef = db.collection('fcm').doc(token);

      // allowed가 undefined인 경우 false로 설정
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

      return res.status(200).send({ message: 'Token registered/updated.' });
    } catch (error) {
      res.status(500).send({ error: 'Failed to register token.' });
      logger.error('[Token] Error registering token:', error);
    }
  },
);

/**
 * FCM 전체 메시지 전송 (배치 처리)
 * POST /sendFcmToAll
 * body: { title: string, body: string }
 */
exports.sendFcmToAll = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      if (req.method !== 'POST') {
        return res.status(404).send({ error: 'Not Found' });
      }

      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const { title, body, data } = req.body;

      if (!title || !body) {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

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

      return res.status(200).send({
        message: 'FCM sent to all tokens.',
        successCount: numSent,
        failureCount: tokens.length - numSent,
      });
    } catch (error) {
      res.status(500).send({ error: 'Failed to send FCM.' });
      logger.error('[FCM] Error sending to all:', error);
    }
  },
);

/**
 * 최근 scrapeNotices 성공 로그의 timestamp 반환
 */
exports.getLatestScrapeTs = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const db = getFirestore();
      const [shDoc, ghDoc] = await Promise.all([
        db.collection('log').doc('sh').get(),
        db.collection('log').doc('gh').get(),
      ]);

      const shTs = shDoc.exists ? shDoc.data().timestamp : null;
      const ghTs = ghDoc.exists ? ghDoc.data().timestamp : null;

      if (shTs === null && ghTs === null) {
        return res.status(404).send({ error: 'No log found.' });
      }

      return res.status(200).send({
        sh: shTs,
        gh: ghTs,
      });
    } catch (error) {
      res.status(500).send({ error: 'Failed to fetch latest timestamp.' });
      logger.error(
        '[Log] Error fetching latest scrapeNotices timestamp:',
        error,
      );
    }
  },
);

/**
 * FCM 푸시 알림 허용 여부 조회
 * POST /getPushAllowed
 * body: { token: string }
 * return: { allowed: boolean }
 */
exports.getPushAllowed = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      if (req.method !== 'POST') {
        return res.status(404).send({ error: 'Not Found' });
      }

      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const { token } = req.body;

      if (!token) {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

      const db = getFirestore();
      const doc = await db.collection('fcm').doc(token).get();
      let allowed = false;

      if (doc.exists && doc.data().allowed !== undefined) {
        allowed = doc.data().allowed;
      }

      return res.status(200).send({ allowed });
    } catch (error) {
      res.status(500).send({ error: 'Failed to get push allowed.' });
      logger.error('[FCM] Error getting push allowed:', error);
    }
  },
);

/**
 * FCM 푸시 알림 허용 여부 설정
 * POST /setPushAllowed
 * body: { token: string, allowed: boolean }
 */
exports.setPushAllowed = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      if (req.method !== 'POST') {
        return res.status(404).send({ error: 'Not Found' });
      }

      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const { token, allowed, userId, device } = req.body;

      if (!token || typeof allowed !== 'boolean') {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

      const db = getFirestore();
      const tokenRef = db.collection('fcm').doc(token);
      const docSnap = await tokenRef.get();

      if (!docSnap.exists) {
        await registerFcmTokenLogic({ token, userId, device });
      }

      await tokenRef.set({ allowed }, { merge: true });

      return res.status(200).send({ message: 'Push allowed updated.' });
    } catch (error) {
      res.status(500).send({ error: 'Failed to update push allowed.' });
      logger.error('[FCM] Error updating push allowed:', error);
    }
  },
);

/**
 * USER 공고 저장
 * POST /saveNotice
 * body: { noticeId: string, userId: string }
 */
exports.saveNotice = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      if (req.method !== 'POST') {
        return res.status(404).send({ error: 'Not Found' });
      }

      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const { noticeId, userId } = req.body;

      if (!noticeId || !userId) {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

      const db = getFirestore();

      // 공고가 어느 컬렉션에 속하는지 확인
      const [shDoc, ghDoc] = await Promise.all([
        db.collection('sh').doc(noticeId).get(),
        db.collection('gh').doc(noticeId).get(),
      ]);

      let corporation = null;
      if (shDoc.exists) {
        corporation = 'sh';
      } else if (ghDoc.exists) {
        corporation = 'gh';
      } else {
        return res.status(404).send({ error: 'Notice not found.' });
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

      return res.status(200).send({ message: 'Notice saved.' });
    } catch (error) {
      res.status(500).send({ error: 'Failed to save notice.' });
      logger.error('[SAVE] Error saving notice:', error);
    }
  },
);

/**
 * USER 공고 삭제
 * POST /deleteNotice
 * body: { noticeId: string, userId: string }
 */
exports.deleteNotice = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      if (req.method !== 'POST') {
        return res.status(404).send({ error: 'Not Found' });
      }

      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const { noticeId, userId } = req.body;

      if (!noticeId || !userId) {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

      const db = getFirestore();
      const saveRef = db.collection('save').doc(`${userId}_${noticeId}`);
      await saveRef.delete();

      return res.status(200).send({ message: 'Notice deleted.' });
    } catch (error) {
      res.status(500).send({ error: 'Failed to delete notice.' });
      logger.error('[SAVE] Error deleting notice:', error);
    }
  },
);

/**
 * USER가 저장한 공고 여부 확인
 * GET /getNoticeSaved
 * query: { noticeId: string, userId: string }
 * return: { saved: boolean }
 */
exports.getNoticeSaved = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      if (req.method !== 'GET') {
        return res.status(404).send({ error: 'Not Found' });
      }

      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const { noticeId, userId } = req.query;

      if (!noticeId || !userId) {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

      const db = getFirestore();
      const saveRef = db.collection('save').doc(`${userId}_${noticeId}`);
      const doc = await saveRef.get();
      const saved = doc.exists;

      return res.status(200).send({ saved });
    } catch (error) {
      res.status(500).send({ error: 'Failed to check notice saved.' });
      logger.error('[SAVE] Error checking notice saved:', error);
    }
  },
);

/**
 * USER가 저장한 공고 목록 조회
 * GET /getSavedNotices
 * query: { userId: string, corporation?: string, limit?: number, offset?: number }
 * return: { notices: Array<Notice> }
 */
exports.getSavedNotices = onRequest(
  { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      if (req.method !== 'GET') {
        return res.status(404).send({ error: 'Not Found' });
      }

      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const { userId, corporation, limit = 5, offset = 0 } = req.query;

      if (!userId) {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

      // 파라미터 타입 변환 및 검증
      const limitNum = Math.max(1, Math.min(parseInt(limit, 10) || 5, 50));
      const offsetNum = Math.max(0, parseInt(offset, 10) || 0);

      const db = getFirestore();

      // 1. 전체 저장된 공고 개수 조회를 위한 쿼리들
      const totalSaveQuery = db
        .collection('save')
        .where('userId', '==', userId);

      const shSaveQuery = db
        .collection('save')
        .where('userId', '==', userId)
        .where('corporation', '==', 'sh');

      const ghSaveQuery = db
        .collection('save')
        .where('userId', '==', userId)
        .where('corporation', '==', 'gh');

      // 병렬로 카운트 조회
      const [totalSnapshot, shSnapshot, ghSnapshot] = await Promise.all([
        totalSaveQuery.get(),
        shSaveQuery.get(),
        ghSaveQuery.get(),
      ]);

      const totalCount = totalSnapshot.size;
      const shCount = shSnapshot.size;
      const ghCount = ghSnapshot.size;

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
        return res.status(200).send({
          notices: [],
          hasMore: false,
          nextOffset: offsetNum,
          totalFetched: 0,
          totalCount,
          shCount,
          ghCount,
        });
      }

      const savedNotices = saveSnapshot.docs.map((doc) => doc.data());

      // 3. 각 공고의 상세 정보를 병렬로 조회
      const noticePromises = savedNotices.map(async (saveData) => {
        const { noticeId, corporation: savedCorporation } = saveData;

        // 저장된 corporation 정보를 이용해 직접 조회
        const noticeDoc = await db
          .collection(savedCorporation)
          .doc(noticeId)
          .get();

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

      return res.status(200).send({
        notices,
        hasMore,
        nextOffset: offsetNum + limitNum,
        totalFetched: notices.length,
        totalCount,
        shCount,
        ghCount,
      });
    } catch (error) {
      res.status(500).send({ error: 'Failed to fetch saved notices.' });
      logger.error('[SAVE] Error fetching saved notices:', error);
    }
  },
);

// registerFcmToken의 내부 로직을 함수로 분리
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
