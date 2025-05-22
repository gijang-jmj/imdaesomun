const { logger } = require('firebase-functions');
const { getFirestore } = require('firebase-admin/firestore');

// Crawling libraries
const axios = require('axios');
const cheerio = require('cheerio');
const dayjs = require('dayjs');
const customParseFormat = require('dayjs/plugin/customParseFormat');
dayjs.extend(customParseFormat);

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
 * corporation : SH
 * regDate : 2025-05-07 // transform firestore Timestamp
 * hits : 1224
 * department : 관악주거안심종합센터
 */
const scrapeShNotices = async () => {
  try {
    const url =
      'https://www.i-sh.co.kr/app/lay2/program/S48T1581C563/www/brd/m_247/list.do?multi_itm_seq=2';
    const response = await axios.get(url);
    const $ = cheerio.load(response.data);

    const notices = [];
    const rows = $('#listTb table tbody tr').toArray();

    // Select the table rows
    for (const element of rows) {
      const columns = $(element).find('td');
      const no = parseInt($(columns[0]).text().trim(), 10) || 0;
      const titleElement = $(columns[1]).clone();
      titleElement.find('.icoNew').remove(); // Remove the NEW span
      const department = $(columns[2]).text().trim();
      const regDateText = $(columns[3]).text().trim();
      const regDate = dayjs(regDateText).valueOf();
      const hits = parseInt($(columns[4]).text().trim(), 10) || 0;

      // Extract the article number from the onclick attribute
      const seq = $(columns[1]).find('a').attr('onclick').match(/\d+/)[0];

      logger.log(`seq: ${seq} / no: ${no}`);

      const detail = await scrapeShNoticeDetail(seq);

      const notice = {
        id: `sh${seq}`,
        seq,
        no,
        title: titleElement.text().trim(),
        regDate,
        hits,
        department,
        corporation: 'sh',
        createdAt: Date.now(),
        ...detail,
      };
      notices.push(notice);
    }

    // Save to Firestore
    const db = getFirestore();
    const batch = db.batch();
    notices.forEach((notice) => {
      const docRef = db.collection('sh').doc(notice.id);
      batch.set(docRef, notice);
    });
    await batch.commit();

    logger.log('[SH] Notices scraped and saved!');
  } catch (error) {
    logger.error('[SH] Error scraping notices!');
    throw error;
  }
};

const scrapeShNoticeDetail = async (seq) => {
  const url = `https://www.i-sh.co.kr/app/lay2/program/S48T1581C563/www/brd/m_247/view.do?seq=${seq}`;
  const response = await axios.get(url);
  const $ = cheerio.load(response.data);

  // extract files
  const files = [];
  $('#fileControl')
    .closest('tr')
    .each((index, element) => {
      const fileName = $(element).find('a.btnAttach').text().trim();
      const previewLink = $(element).find('a.icoView').attr('href');

      if (fileName && previewLink) {
        files.push({
          fileName,
          fileLink: `https://www.i-sh.co.kr${previewLink}`,
        });
      }
    });

  // extract contents
  const contents = [];
  $('tr')
    .filter((_, el) => $(el).find('td.cont').length > 0)
    .find('td.cont')
    .find('p')
    .each((_, el) => {
      const text = $(el)
        .text()
        .replace(/\u00A0/g, '')
        .replace(/\s+/g, ' ')
        .trim();
      if (text) contents.push(text);
    });

  return {
    files,
    contents,
    link: `https://www.i-sh.co.kr/app/lay2/program/S48T1581C563/www/brd/m_247/view.do?seq=${seq}`,
  };
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
 * corporation : GH
 * regDate : 25.04.30 // transform firestore Timestamp
 * hits : 1516
 * department : 주택공급2부
 */
const scrapeGhNotices = async () => {
  try {
    const url =
      'https://gh.or.kr/gh/announcement-of-salerental001.do?mode=list&&articleLimit=10&srCategoryId=12&article.offset=0';
    const response = await axios.get(url);
    const $ = cheerio.load(response.data);

    const notices = [];
    const rows = $('.board-list-table-wrap table tbody tr').toArray();

    // Select the table rows
    for (const element of rows) {
      const columns = $(element).find('td');
      const no = parseInt($(columns[0]).text().trim(), 10) || 0;
      const title = $(columns[2]).text().trim();
      const department = $(columns[3]).text().trim();
      const regDateText = $(columns[4]).text().trim();
      const regDate = dayjs(regDateText, 'YY.MM.DD').valueOf();
      const hits = parseInt($(columns[5]).text().trim(), 10) || 0;

      // Extract the article number from the link
      const seq = $(columns[2])
        .find('a')
        .attr('href')
        .match(/articleNo=(\d+)/)[1];

      logger.log(`seq: ${seq} / no: ${no}`);

      const detail = await scrapeGhNoticeDetail(seq);

      const notice = {
        id: `gh${seq}`,
        seq,
        no,
        title,
        department,
        regDate,
        hits,
        corporation: 'gh',
        createdAt: Date.now(),
        ...detail,
      };
      notices.push(notice);
    }

    // Save to Firestore
    const db = getFirestore();
    const batch = db.batch();
    notices.forEach((notice) => {
      const docRef = db.collection('gh').doc(notice.id);
      batch.set(docRef, notice);
    });
    await batch.commit();

    logger.log('[GH] Notices scraped and saved!');
  } catch (error) {
    logger.error('[GH] Error scraping notices!');
    throw error;
  }
};

const scrapeGhNoticeDetail = async (seq) => {
  const url = `https://gh.or.kr/gh/announcement-of-salerental001.do?mode=view&articleNo=${seq}`;
  const response = await axios.get(url);
  const $ = cheerio.load(response.data);

  // extract files
  const files = [];
  $('.download-file-list-wrap ul li').each((index, element) => {
    const fileName = $(element).find('.fileNm').text().trim();
    const fileId = $(element).find('button').attr('data-id');

    if (fileName && fileId) {
      files.push({
        fileName,
        fileLink: 'https://gh.or.kr/gh/conv.do',
        fileId,
      });
    }
  });

  // extract contents
  const contents = [];
  $('.fr-view')
    .first()
    .find('p')
    .each((_, el) => {
      const text = $(el)
        .text()
        .replace(/\u00A0/g, '')
        .replace(/\s+/g, ' ')
        .trim();
      if (text) contents.push(text);
    });

  return {
    files,
    contents,
    link: `https://gh.or.kr/gh/announcement-of-salerental001.do?mode=view&articleNo=${seq}`,
  };
};

module.exports = { scrapeShNotices, scrapeGhNotices };
