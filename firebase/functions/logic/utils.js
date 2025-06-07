/**
 * 공통 유틸리티 함수들
 */

/**
 * API 키 검증 미들웨어
 * @param {Object} req - Express request 객체
 * @param {Object} res - Express response 객체
 * @return {boolean} 검증 성공 여부
 */
function validateApiKey(req, res) {
  const apiKey = req.headers['x-imdaesomun-api-key'];
  const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

  if (apiKey !== SECRET_KEY) {
    res.status(401).send({ error: 'Unauthorized' });
    return false;
  }
  return true;
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
