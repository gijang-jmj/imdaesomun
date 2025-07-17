// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const { logger } = require('firebase-functions');
const { onRequest } = require('firebase-functions/v2/https');
const { initializeApp } = require('firebase-admin/app');
const corsLib = require('cors');
const {
  scrapeShNotices,
  scrapeGhNotices,
  scrapeBmcNotices,
  scrapeIhNotices,
} = require('./logic/scrape');
const {
  validateApiKey,
  validatePostMethod,
  validateGetMethod,
} = require('./logic/utils');
const {
  registerFcmTokenLogic,
  getPushAllowedLogic,
  setPushAllowedLogic,
  sendFcmToAllLogic,
} = require('./logic/fcm');
const {
  getShNoticesLogic,
  getGhNoticesLogic,
  getBmcNoticesLogic,
  getIhNoticesLogic,
  getNoticeByIdLogic,
  getLatestScrapeTsLogic,
} = require('./logic/notice');
const {
  saveNoticeLogic,
  deleteNoticeLogic,
  getNoticeSavedLogic,
  getSavedNoticesLogic,
} = require('./logic/save');

initializeApp();

const cors = corsLib({
  origin: ['https://imdaesomun.web.app'],
  methods: ['GET', 'POST'],
  credentials: true,
});

// Helper function to wrap onRequest with CORS
const onRequestWithCors = (handler) => {
  return onRequest(
    { region: 'asia-northeast1', secrets: ['IMDAESOMUN_API_KEY'] },
    (req, res) => {
      cors(req, res, () => {
        handler(req, res);
      });
    },
  );
};

/**
 * 공고 크롤링
 */
exports.scrapeNotices = onRequestWithCors(async (req, res) => {
  try {
    if (!validatePostMethod(req, res) || !validateApiKey(req, res)) {
      return;
    }

    const [newShNotices, newGhNotices, newBmcNotices, newIhNotices] =
      await Promise.all([
        scrapeShNotices(),
        scrapeGhNotices(),
        scrapeBmcNotices(),
        scrapeIhNotices(),
      ]);

    // Send FCM for new SH notices
    if (newShNotices && newShNotices.length > 0) {
      for (const notice of newShNotices) {
        try {
          await sendFcmToAllLogic({
            title: '서울주택도시공사 새로운 공고 도착',
            body: notice.title,
            data: { noticeId: notice.id },
          });
          logger.log(`[FCM] Sent notification for SH notice: ${notice.id}`);
        } catch (fcmError) {
          logger.error(
            `[FCM] Failed to send notification for SH notice ${notice.id}:`,
            fcmError,
          );
        }
      }
    }

    // Send FCM for new GH notices
    if (newGhNotices && newGhNotices.length > 0) {
      for (const notice of newGhNotices) {
        try {
          await sendFcmToAllLogic({
            title: '경기주택도시공사 새로운 공고 도착',
            body: notice.title,
            data: { noticeId: notice.id },
          });
          logger.log(`[FCM] Sent notification for GH notice: ${notice.id}`);
        } catch (fcmError) {
          logger.error(
            `[FCM] Failed to send notification for GH notice ${notice.id}:`,
            fcmError,
          );
        }
      }
    }

    res.status(200).send({
      message: 'Notices scraped and saved successfully.',
      newShNotices: newShNotices ? newShNotices.length : 0,
      newGhNotices: newGhNotices ? newGhNotices.length : 0,
      newBmcNotices: newBmcNotices ? newBmcNotices.length : 0,
      newIhNotices: newIhNotices ? newIhNotices.length : 0,
    });
  } catch (error) {
    res.status(500).send({ error: 'Failed to scrape notices.' });
    logger.error('Error Scraped notices:', error);
  }
});

/**
 * SH 공고 가져오기
 */
exports.getShNotices = onRequestWithCors(async (req, res) => {
  try {
    if (!validateApiKey(req, res)) {
      return;
    }

    const notices = await getShNoticesLogic();
    res.status(200).send(notices);
  } catch (error) {
    res.status(500).send({ error: 'Failed to fetch SH notices.' });
    logger.error('[SH] Error fetching notices:', error);
  }
});

/**
 * GH 공고 가져오기
 */
exports.getGhNotices = onRequestWithCors(async (req, res) => {
  try {
    if (!validateApiKey(req, res)) {
      return;
    }

    const notices = await getGhNoticesLogic();
    res.status(200).send(notices);
  } catch (error) {
    res.status(500).send({ error: 'Failed to fetch GH notices.' });
    logger.error('[GH] Error fetching notices:', error);
  }
});

/**
 * BMC 공고 가져오기
 */
exports.getBmcNotices = onRequestWithCors(async (req, res) => {
  try {
    if (!validateApiKey(req, res)) {
      return;
    }

    const notices = await getBmcNoticesLogic();
    res.status(200).send(notices);
  } catch (error) {
    res.status(500).send({ error: 'Failed to fetch BMC notices.' });
    logger.error('[BMC] Error fetching notices:', error);
  }
});

/**
 * IH 공고 가져오기
 */
exports.getIhNotices = onRequestWithCors(async (req, res) => {
  try {
    if (!validateApiKey(req, res)) {
      return;
    }

    const notices = await getIhNoticesLogic();
    res.status(200).send(notices);
  } catch (error) {
    res.status(500).send({ error: 'Failed to fetch IH notices.' });
    logger.error('[IH] Error fetching notices:', error);
  }
});

/**
 * 공고 조회
 */
exports.getNoticeById = onRequestWithCors(async (req, res) => {
  try {
    if (!validateApiKey(req, res)) {
      return;
    }

    const { noticeId } = req.query;
    if (!noticeId) {
      return res.status(400).send({ error: 'Missing parameter.' });
    }

    const result = await getNoticeByIdLogic(noticeId);
    if (!result) {
      return res.status(404).send({ error: 'Notice not found.' });
    }

    return res.status(200).send(result);
  } catch (error) {
    res.status(500).send({ error: 'Failed to fetch notice.' });
    logger.error('[SH/GH] Error fetching notice by id:', error);
  }
});

/**
 * FCM 토큰 등록/갱신
 * POST /registerFcmToken
 * body: { token: string, userId?: string }
 */
exports.registerFcmToken = onRequestWithCors(async (req, res) => {
  try {
    if (!validatePostMethod(req, res) || !validateApiKey(req, res)) {
      return;
    }

    const { token, userId, device, allowed } = req.body;
    if (!token) {
      return res.status(400).send({ error: 'Missing parameter.' });
    }

    await registerFcmTokenLogic({ token, userId, device, allowed });
    return res.status(200).send({ message: 'Token registered/updated.' });
  } catch (error) {
    res.status(500).send({ error: 'Failed to register token.' });
    logger.error('[Token] Error registering token:', error);
  }
});

/**
 * FCM 전체 메시지 전송 (배치 처리)
 * POST /sendFcmToAll
 * body: { title: string, body: string }
 */
exports.sendFcmToAll = onRequestWithCors(async (req, res) => {
  try {
    if (!validatePostMethod(req, res) || !validateApiKey(req, res)) {
      return;
    }

    const { title, body, data } = req.body;
    if (!title || !body) {
      return res.status(400).send({ error: 'Missing parameter.' });
    }

    const result = await sendFcmToAllLogic({ title, body, data });
    return res.status(200).send(result);
  } catch (error) {
    res.status(500).send({ error: 'Failed to send FCM.' });
    logger.error('[FCM] Error sending to all:', error);
  }
});

/**
 * 최근 scrapeNotices 성공 로그의 timestamp 반환
 */
exports.getLatestScrapeTs = onRequestWithCors(async (req, res) => {
  try {
    if (!validateApiKey(req, res)) {
      return;
    }

    const result = await getLatestScrapeTsLogic();
    if (!result) {
      return res.status(404).send({ error: 'No log found.' });
    }

    return res.status(200).send(result);
  } catch (error) {
    res.status(500).send({ error: 'Failed to fetch latest timestamp.' });
    logger.error('[Log] Error fetching latest scrapeNotices timestamp:', error);
  }
});

/**
 * FCM 푸시 알림 허용 여부 조회
 * POST /getPushAllowed
 * body: { token: string }
 * return: { allowed: boolean }
 */
exports.getPushAllowed = onRequestWithCors(async (req, res) => {
  try {
    if (!validatePostMethod(req, res) || !validateApiKey(req, res)) {
      return;
    }

    const { token } = req.body;
    if (!token) {
      return res.status(400).send({ error: 'Missing parameter.' });
    }

    const result = await getPushAllowedLogic(token);
    return res.status(200).send(result);
  } catch (error) {
    res.status(500).send({ error: 'Failed to get push allowed.' });
    logger.error('[FCM] Error getting push allowed:', error);
  }
});

/**
 * FCM 푸시 알림 허용 여부 설정
 * POST /setPushAllowed
 * body: { token: string, allowed: boolean }
 */
exports.setPushAllowed = onRequestWithCors(async (req, res) => {
  try {
    if (!validatePostMethod(req, res) || !validateApiKey(req, res)) {
      return;
    }

    const { token, allowed, userId, device } = req.body;
    if (!token || typeof allowed !== 'boolean') {
      return res.status(400).send({ error: 'Missing parameter.' });
    }

    await setPushAllowedLogic({ token, allowed, userId, device });
    return res.status(200).send({ message: 'Push allowed updated.' });
  } catch (error) {
    res.status(500).send({ error: 'Failed to update push allowed.' });
    logger.error('[FCM] Error updating push allowed:', error);
  }
});

/**
 * USER 공고 저장
 * POST /saveNotice
 * body: { noticeId: string, userId: string }
 */
exports.saveNotice = onRequestWithCors(async (req, res) => {
  try {
    if (!validatePostMethod(req, res) || !validateApiKey(req, res)) {
      return;
    }

    const { noticeId, userId } = req.body;
    if (!noticeId || !userId) {
      return res.status(400).send({ error: 'Missing parameter.' });
    }

    await saveNoticeLogic({ noticeId, userId });
    return res.status(200).send({ message: 'Notice saved.' });
  } catch (error) {
    if (error.message === 'Notice not found') {
      return res.status(404).send({ error: 'Notice not found.' });
    }
    res.status(500).send({ error: 'Failed to save notice.' });
    logger.error('[SAVE] Error saving notice:', error);
  }
});

/**
 * USER 공고 삭제
 * POST /deleteNotice
 * body: { noticeId: string, userId: string }
 */
exports.deleteNotice = onRequestWithCors(async (req, res) => {
  try {
    if (!validatePostMethod(req, res) || !validateApiKey(req, res)) {
      return;
    }

    const { noticeId, userId } = req.body;
    if (!noticeId || !userId) {
      return res.status(400).send({ error: 'Missing parameter.' });
    }

    await deleteNoticeLogic({ noticeId, userId });
    return res.status(200).send({ message: 'Notice deleted.' });
  } catch (error) {
    res.status(500).send({ error: 'Failed to delete notice.' });
    logger.error('[SAVE] Error deleting notice:', error);
  }
});

/**
 * USER가 저장한 공고 여부 확인
 * GET /getNoticeSaved
 * query: { noticeId: string, userId: string }
 * return: { saved: boolean }
 */
exports.getNoticeSaved = onRequestWithCors(async (req, res) => {
  try {
    if (!validateGetMethod(req, res) || !validateApiKey(req, res)) {
      return;
    }

    const { noticeId, userId } = req.query;
    if (!noticeId || !userId) {
      return res.status(400).send({ error: 'Missing parameter.' });
    }

    const result = await getNoticeSavedLogic({ noticeId, userId });
    return res.status(200).send(result);
  } catch (error) {
    res.status(500).send({ error: 'Failed to check notice saved.' });
    logger.error('[SAVE] Error checking notice saved:', error);
  }
});

/**
 * USER가 저장한 공고 목록 조회
 * GET /getSavedNotices
 * query: { userId: string, corporation?: string, limit?: number, offset?: number }
 * return: { notices: Array<Notice> }
 */
exports.getSavedNotices = onRequestWithCors(async (req, res) => {
  try {
    if (!validateGetMethod(req, res) || !validateApiKey(req, res)) {
      return;
    }

    const { userId, corporation, limit = 10, offset = 0 } = req.query;
    if (!userId) {
      return res.status(400).send({ error: 'Missing parameter.' });
    }

    const result = await getSavedNoticesLogic({
      userId,
      corporation,
      limit,
      offset,
    });
    return res.status(200).send(result);
  } catch (error) {
    res.status(500).send({ error: 'Failed to fetch saved notices.' });
    logger.error('[SAVE] Error fetching saved notices:', error);
  }
});
