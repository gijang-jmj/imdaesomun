// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const { logger } = require('firebase-functions');
const { onRequest } = require('firebase-functions/v2/https');
const { getFirestore } = require('firebase-admin/firestore');

// The Firebase Admin SDK to access Firestore.
const { initializeApp } = require('firebase-admin/app');
const { scrapeShNotices, scrapeGhNotices } = require('./scrape');

initializeApp();

/**
 * 공고 크롤링
 */
exports.scrapeNotices = onRequest(
  { secrets: ['IMDAESOMUN_API_KEY'] },
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
  { secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const db = getFirestore();
      const snapshot = await db.collection('sh').orderBy('no', 'desc').get();
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
  { secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      const db = getFirestore();
      const snapshot = await db.collection('gh').orderBy('no', 'desc').get();
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
