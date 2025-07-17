const { getAppCheck } = require('firebase-admin/app-check');

/**
 * 공통 유틸리티 함수들
 */

/**
 * 요청 검증 유틸리티 (API Key 또는 App Check 둘 중 하나 통과 시 허용)
 * @param {Object} req - Express request 객체
 * @param {Object} res - Express response 객체
 * @return {Promise<boolean>} 검증 성공 여부
 */
async function validateApiKey(req, res) {
  const apiKey = req.headers['x-imdaesomun-api-key'];
  const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

  // API Key가 있는데 SECRET_KEY와 일치하지 않는 경우
  if (apiKey && apiKey !== SECRET_KEY) {
    res.status(401).send({ error: 'Unauthorized' });
    return false;
  }

  // API Key 검증
  if (apiKey && apiKey === SECRET_KEY) {
    return true;
  }

  // Firebase App Check 검증
  const appCheckToken = req.headers['x-firebase-appcheck'];

  if (!appCheckToken) {
    res
      .status(403)
      .send({ error: 'Missing App Check token or invalid API Key' });
    return false;
  }

  try {
    await getAppCheck().verifyToken(appCheckToken);
    return true;
  } catch (err) {
    console.error('App Check verification failed:', err);
    res.status(403).send({ error: 'Invalid App Check token' });
    return false;
  }
}

/**
 * POST 메소드 검증
 * @param {Object} req - Express request 객체
 * @param {Object} res - Express response 객체
 * @return {boolean} 검증 성공 여부
 */
function validatePostMethod(req, res) {
  if (req.method !== 'POST') {
    res.status(404).send({ error: 'Not Found' });
    return false;
  }
  return true;
}

/**
 * GET 메소드 검증
 * @param {Object} req - Express request 객체
 * @param {Object} res - Express response 객체
 * @return {boolean} 검증 성공 여부
 */
function validateGetMethod(req, res) {
  if (req.method !== 'GET') {
    res.status(404).send({ error: 'Not Found' });
    return false;
  }
  return true;
}

module.exports = {
  validateApiKey,
  validatePostMethod,
  validateGetMethod,
};
