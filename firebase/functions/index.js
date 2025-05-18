// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
const { logger } = require('firebase-functions');
const { onRequest } = require('firebase-functions/v2/https');

// The Firebase Admin SDK to access Firestore.
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, Timestamp } = require('firebase-admin/firestore');

// Crawling libraries
const axios = require('axios');
const cheerio = require('cheerio');

initializeApp();

/**
 * Define SH scraping rules
 *
 * url = https://www.i-sh.co.kr/app/lay2/program/S48T1581C563/www/brd/m_247/list.do?multi_itm_seq=2
 *
 * [SH HTML 테이블 구조]
 * <div id="listTb" class="listTable colRm">
 *   <table>
 *     <colgroup>
 *       <col style="width :10%" />
 *       <!-- 번호 -->
 *       <col style="width: auto" />
 *       <!-- 제목 -->
 *       <col style="width :160px" />
 *       <!-- 부서명 -->
 *       <col style="width :100px" />
 *       <!-- 작성일 -->
 *       <col style="width :80px" />
 *       <!-- 조회수 -->
 *     </colgroup>
 *     <thead>
 *       <tr>
 *         <th scope="col">번호</th>
 *         <!-- 번호 -->
 *         <th scope="col">제목</th>
 *         <!-- 제목 -->
 *         <th scope="col">담당부서</th>
 *         <!-- 부서명 -->
 *         <th scope="col">등록일</th>
 *         <!-- 작성일 -->
 *         <th scope="col">조회수</th>
 *         <!-- 조회수 -->
 *       </tr>
 *     </thead>
 *     <tbody>
 *       <tr>
 *         <td>1444</td>
 *         <!-- 번호 -->
 *         <td class="txtL">
 *           <a href="#" class="ellipsis icon" onclick="javascript:getDetailView('287910');return false;">
 *             <span class="icoNew">NEW</span>
 *             [골드타워] 당첨세대 주택공개 및 사전점검 안내
 *           </a>
 *         </td>
 *         <!-- 제목 -->
 *         <td>
 *           관악주거안심종합센터
 *         </td>
 *         <!-- 부서명 -->
 *         <td class="num">
 *           2025-05-07
 *         </td>
 *         <!-- 작성일 -->
 *         <td class="num">1224</td>
 *         <!-- 조회수 -->
 *       </tr>
 *     </tbody>
 *   </table>
 * </div>
 *
 * [크롤링 후 DB 저장할 데이터]
 * id : SH287910 // SH + getDetailView(287910)
 * title : [골드타워] 당첨세대 주택공개 및 사전점검 안내
 * organization : SH
 * regDate : 2025-05-07 // transform firestore Timestamp
 * hits : 1224
 * department : 관악주거안심종합센터
 */
const scrapeSh = async () => {
  const url =
    'https://www.i-sh.co.kr/app/lay2/program/S48T1581C563/www/brd/m_247/list.do?multi_itm_seq=2';
  const response = await axios.get(url);
  const $ = cheerio.load(response.data);

  const notices = [];

  // Select the table rows
  $('#listTb table tbody tr').each((index, element) => {
    const columns = $(element).find('td');
    const seq = $(columns[1]).find('a').attr('onclick').match(/\d+/)[0];
    const titleElement = $(columns[1]).clone();
    titleElement.find('.icoNew').remove(); // Remove the NEW span

    // Convert regDate to Firestore Timestamp
    // SH use date format => YYYY-MM-DD
    const regDateText = $(columns[3]).text().trim();
    const regDate = new Date(regDateText);

    const notice = {
      seq,
      id: `SH${seq}`,
      title: titleElement.text().trim(),
      organization: 'SH',
      regDate: Timestamp.fromDate(regDate),
      hits: parseInt($(columns[4]).text().trim(), 10) || 0,
      department: $(columns[2]).text().trim(),
      createdAt: Timestamp.now(),
    };
    notices.push(notice);
  });

  // Save to Firestore
  const db = getFirestore();
  const batch = db.batch();
  notices.forEach((notice) => {
    const docRef = db.collection('sh').doc(notice.id);
    batch.set(docRef, notice);
  });
  await batch.commit();

  logger.log('SH notices scraped and saved:', notices);
};

/**
 * Define GH scraping rules
 *
 * url = https://gh.or.kr/gh/announcement-of-salerental001.do?mode=list&&articleLimit=10&srCategoryId=12&article.offset=0
 *
 * [GH HTML 테이블 구조]
 * <div class="board-list-table-wrap">
 *   <table class="table board-list-table">
 *     <thead>
 *       <tr>
 *         <th class="number" scope="col">번호</th>
 *         <th class="category" scope="col">구분</th>
 *         <th class="title" scope="col">제목</th>
 *         <th class="department" scope="col">부서</th>
 *         <th class="date" scope="col">등록일</th>
 *         <th class="hit" scope="col">조회수</th>
 *         <th class="attach" scope="col">첨부파일</th>
 *       </tr>
 *     </thead>
 *     <tbody>
 *       <tr class="">
 *         <td class="number">493</td>
 *         <!-- 번호 -->
 *         <td class="category">주택</td>
 *         <!-- 구분 -->
 *         <td class="title">
 *           <div class="b-title-box">
 *             <a href="?mode=view&amp;articleNo=63563&amp;article.offset=0&amp;articleLimit=10&amp;srCategoryId=12"
 *                title="다산메트로3단지 국민임대주택(32B, 34A, 51A) 예비입주자 모집(2024.11.14.) 당첨자 발표 안내 자세히 보기">
 *               다산메트로3단지 국민임대주택(32B, 34A, 51A) 예비입주자 모집(2024.11.14.) 당첨자 발표 안내
 *             </a>
 *           </div>
 *         </td>
 *         <!-- 제목 -->
 *         <td class="department">주택공급2부</td>
 *         <!-- 부서 -->
 *         <td class="date">25.04.30</td>
 *         <!-- 등록일 -->
 *         <td class="hit">1516</td>
 *         <!-- 조회수 -->
 *         <td class="attach">-</td>
 *         <!-- 첨부파일 -->
 *       </tr>
 *     </tbody>
 *   </table>
 * </div>
 *
 * [크롤링 후 DB 저장할 데이터 예시]
 * id : GH63563 // GH + articleNo
 * title : 다산메트로3단지 국민임대주택(32B, 34A, 51A) 예비입주자 모집(2024.11.14.) 당첨자 발표 안내
 * organization : GH
 * regDate : 25.04.30 // transform firestore Timestamp
 * hits : 1516
 * department : 주택공급2부
 */
const scrapeGh = async () => {
  const url =
    'https://gh.or.kr/gh/announcement-of-salerental001.do?mode=list&&articleLimit=10&srCategoryId=12&article.offset=0';
  const response = await axios.get(url);
  const $ = cheerio.load(response.data);

  const notices = [];

  // Select the table rows
  $('.board-list-table-wrap table tbody tr').each((index, element) => {
    const columns = $(element).find('td');
    const seq = $(columns[2])
      .find('a')
      .attr('href')
      .match(/articleNo=(\d+)/)[1];

    // Convert regDate to Firestore Timestamp
    // GH use date format => YY.MM.DD
    // Convert to format => YYYY-MM-DD
    const regDateText = $(columns[4])
      .text()
      .trim()
      .replace(/\./g, '-')
      .replace(/^(\d{2})-/, '20$1-');
    const regDate = new Date(regDateText);

    const notice = {
      seq,
      id: `GH${seq}`,
      title: $(columns[2]).text().trim(),
      organization: 'GH',
      regDate: Timestamp.fromDate(regDate),
      hits: parseInt($(columns[5]).text().trim(), 10) || 0,
      department: $(columns[3]).text().trim(),
      createdAt: Timestamp.now(),
    };
    notices.push(notice);
  });

  // Save to Firestore
  const db = getFirestore();
  const batch = db.batch();
  notices.forEach((notice) => {
    const docRef = db.collection('gh').doc(notice.id);
    batch.set(docRef, notice);
  });
  await batch.commit();

  logger.log('GH notices scraped and saved:', notices);
};

exports.scrapeNotices = onRequest(
  { secrets: ['IMDAESOMUN_API_KEY'] },
  async (req, res) => {
    try {
      const apiKey = req.headers['x-imdaesomun-api-key'];
      const SECRET_KEY = process.env.IMDAESOMUN_API_KEY;

      if (apiKey !== SECRET_KEY) {
        return res.status(401).send({ error: 'Unauthorized' });
      }

      await scrapeSh();
      await scrapeGh();

      res
        .status(200)
        .send({ message: 'Notices scraped and saved successfully!' });
    } catch (error) {
      res.status(500).send({ error: 'Failed to scrape notices.' });

      logger.log('Scraped notices:', error);
    }
  },
);
