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

      // allowed가 undefined인 경우 true로 설정
      const docSnap = await tokenRef.get();
      const dataToSet = {
        token,
        userId: userId || null,
        device: device || null,
        createdAt: FieldValue.serverTimestamp(),
        ...((!docSnap.exists || docSnap.data().allowed === undefined) && {
          allowed: true,
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
      let allowed = true;

      if (doc.exists) {
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

      const { token, allowed } = req.body;

      if (!token || typeof allowed !== 'boolean') {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

      const db = getFirestore();
      await db.collection('fcm').doc(token).set({ allowed }, { merge: true });

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
      const saveRef = db.collection('save').doc(`${userId}_${noticeId}`);
      await saveRef.set(
        {
          userId,
          noticeId,
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

      // 1. 전체 저장된 공고 개수 조회를 위한 쿼리
      const totalSaveQuery = db
        .collection('save')
        .where('userId', '==', userId);

      const totalSaveSnapshot = await totalSaveQuery.get();
      const allSavedNoticeIds = totalSaveSnapshot.docs.map(
        (doc) => doc.data().noticeId,
      );

      // 2. 저장된 공고 ID들을 가져오기 (페이지네이션 적용)
      const saveQuery = db
        .collection('save')
        .where('userId', '==', userId)
        .orderBy('createdAt', 'desc')
        .offset(offsetNum)
        .limit(limitNum);

      const saveSnapshot = await saveQuery.get();

      // 3. 전체 저장된 공고의 sh/gh 분류를 위한 조회
      const allNoticePromises = allSavedNoticeIds.map(async (noticeId) => {
        const [shDoc, ghDoc] = await Promise.all([
          db.collection('sh').doc(noticeId).get(),
          db.collection('gh').doc(noticeId).get(),
        ]);

        if (shDoc.exists) {
          return 'sh';
        }
        if (ghDoc.exists) {
          return 'gh';
        }
        return null; // 공고가 삭제된 경우
      });

      const allNoticeTypes = await Promise.all(allNoticePromises);
      const validNoticeTypes = allNoticeTypes.filter((type) => type !== null);

      // 카운트 계산
      const totalCount = validNoticeTypes.length;
      const shCount = validNoticeTypes.filter((type) => type === 'sh').length;
      const ghCount = validNoticeTypes.filter((type) => type === 'gh').length;

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

      const noticeIds = saveSnapshot.docs.map((doc) => doc.data().noticeId);

      // 4. 각 공고의 상세 정보를 병렬로 조회
      const noticePromises = noticeIds.map(async (noticeId) => {
        const [shDoc, ghDoc] = await Promise.all([
          db.collection('sh').doc(noticeId).get(),
          db.collection('gh').doc(noticeId).get(),
        ]);

        if (shDoc.exists) {
          const data = { collection: 'sh', id: shDoc.id, ...shDoc.data() };
          // corporation 필터 적용
          if (corporation && data.collection !== corporation) {
            return null;
          }
          return data;
        }

        if (ghDoc.exists) {
          const data = { collection: 'gh', id: ghDoc.id, ...ghDoc.data() };
          // corporation 필터 적용
          if (corporation && data.collection !== corporation) {
            return null;
          }
          return data;
        }

        return null; // 공고가 삭제된 경우
      });

      const noticeResults = await Promise.all(noticePromises);

      // null 값 제거 및 corporation 필터링된 결과 처리
      const notices = noticeResults.filter((notice) => notice !== null);

      // 다음 페이지 존재 여부 확인을 위한 추가 쿼리
      const nextPageQuery = db
        .collection('save')
        .where('userId', '==', userId)
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
