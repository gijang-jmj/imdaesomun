// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const { logger } = require('firebase-functions');
const { onRequest } = require('firebase-functions/v2/https');
const { getFirestore } = require('firebase-admin/firestore');
const { FieldValue } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

// The Firebase Admin SDK to access Firestore.
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

      await scrapeShNotices();
      await scrapeGhNotices();

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

      const { id } = req.query;

      if (!id) {
        return res.status(400).send({ error: 'Missing parameter.' });
      }

      const db = getFirestore();

      // sh에서 조회
      let doc = await db.collection('sh').doc(id).get();
      if (doc.exists) {
        return res
          .status(200)
          .send({ collection: 'sh', id: doc.id, ...doc.data() });
      }

      // gh에서 조회
      doc = await db.collection('gh').doc(id).get();
      if (doc.exists) {
        return res
          .status(200)
          .send({ collection: 'gh', id: doc.id, ...doc.data() });
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

      // 토큰 문서가 이미 있으면 userId만 업데이트, 없으면 새로 생성
      await tokenRef.set(
        {
          token,
          userId: userId || null,
          device: device || null,
          createdAt: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );

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
      const snapshot = await db.collection('fcm').get();
      const tokens = snapshot.docs.map((doc) => doc.id); // token이 doc id
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
