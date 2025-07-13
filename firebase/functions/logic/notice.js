const { getFirestore } = require('firebase-admin/firestore');

/**
 * SH 공고 목록 조회
 */
async function getShNoticesLogic() {
  const db = getFirestore();
  const snapshot = await db
    .collection('sh')
    .orderBy('createdAt', 'desc')
    .limit(10)
    .get();

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

/**
 * GH 공고 목록 조회
 */
async function getGhNoticesLogic() {
  const db = getFirestore();
  const snapshot = await db
    .collection('gh')
    .orderBy('createdAt', 'desc')
    .limit(10)
    .get();

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

/**
 * BMC 공고 목록 조회
 */
async function getBmcNoticesLogic() {
  const db = getFirestore();
  const snapshot = await db
    .collection('bmc')
    .orderBy('createdAt', 'desc')
    .limit(10)
    .get();

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

/**
 * IH 공고 목록 조회
 */
async function getIhNoticesLogic() {
  const db = getFirestore();
  const snapshot = await db
    .collection('ih')
    .orderBy('createdAt', 'desc')
    .limit(10)
    .get();

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
}

/**
 * 공고 ID로 상세 조회 (전체 검색)
 * @param {string} noticeId
 */
async function getNoticeByIdLogic(noticeId) {
  const db = getFirestore();
  const [shDoc, ghDoc, bmcDoc, ihDoc] = await Promise.all([
    db.collection('sh').doc(noticeId).get(),
    db.collection('gh').doc(noticeId).get(),
    db.collection('bmc').doc(noticeId).get(),
    db.collection('ih').doc(noticeId).get(),
  ]);

  if (shDoc.exists) {
    return { collection: 'sh', id: shDoc.id, ...shDoc.data() };
  }

  if (ghDoc.exists) {
    return { collection: 'gh', id: ghDoc.id, ...ghDoc.data() };
  }

  if (bmcDoc.exists) {
    return { collection: 'bmc', id: bmcDoc.id, ...bmcDoc.data() };
  }

  if (ihDoc.exists) {
    return { collection: 'ih', id: ihDoc.id, ...ihDoc.data() };
  }

  return null;
}

/**
 * 최근 scrapeNotices 성공 로그의 timestamp 반환
 */
async function getLatestScrapeTsLogic() {
  const db = getFirestore();
  const [shDoc, ghDoc, bmcDoc, ihDoc] = await Promise.all([
    db.collection('log').doc('sh').get(),
    db.collection('log').doc('gh').get(),
    db.collection('log').doc('bmc').get(),
    db.collection('log').doc('ih').get(),
  ]);

  const shTs = shDoc.exists ? shDoc.data().timestamp : null;
  const ghTs = ghDoc.exists ? ghDoc.data().timestamp : null;
  const bmcTs = bmcDoc.exists ? bmcDoc.data().timestamp : null;
  const ihTs = ihDoc.exists ? ihDoc.data().timestamp : null;

  if (shTs === null && ghTs === null && bmcTs === null && ihTs === null) {
    return null;
  }

  return {
    sh: shTs,
    gh: ghTs,
    bmc: bmcTs,
    ih: ihTs,
  };
}

module.exports = {
  getShNoticesLogic,
  getGhNoticesLogic,
  getBmcNoticesLogic,
  getIhNoticesLogic,
  getNoticeByIdLogic,
  getLatestScrapeTsLogic,
};
