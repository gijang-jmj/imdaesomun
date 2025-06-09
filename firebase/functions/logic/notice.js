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
 * 공고 ID로 상세 조회 (SH/GH 모두 검색)
 * @param {string} noticeId
 */
async function getNoticeByIdLogic(noticeId) {
  const db = getFirestore();
  const [shDoc, ghDoc] = await Promise.all([
    db.collection('sh').doc(noticeId).get(),
    db.collection('gh').doc(noticeId).get(),
  ]);

  if (shDoc.exists) {
    return { collection: 'sh', id: shDoc.id, ...shDoc.data() };
  }

  if (ghDoc.exists) {
    return { collection: 'gh', id: ghDoc.id, ...ghDoc.data() };
  }

  return null;
}

/**
 * 최근 scrapeNotices 성공 로그의 timestamp 반환
 */
async function getLatestScrapeTsLogic() {
  const db = getFirestore();
  const [shDoc, ghDoc] = await Promise.all([
    db.collection('log').doc('sh').get(),
    db.collection('log').doc('gh').get(),
  ]);

  const shTs = shDoc.exists ? shDoc.data().timestamp : null;
  const ghTs = ghDoc.exists ? ghDoc.data().timestamp : null;

  if (shTs === null && ghTs === null) {
    return null;
  }

  return {
    sh: shTs,
    gh: ghTs,
  };
}

module.exports = {
  getShNoticesLogic,
  getGhNoticesLogic,
  getNoticeByIdLogic,
  getLatestScrapeTsLogic,
};
