const { logger } = require('firebase-functions');
const { getFirestore } = require('firebase-admin/firestore');
const { FieldValue } = require('firebase-admin/firestore');

// Crawling libraries
const https = require('https');
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
 * id : sh287910 // sh + getDetailView(287910)
 * seq : 287910 // getDetailView(287910)
 * no : 1444
 * title : [골드타워] 당첨세대 주택공개 및 사전점검 안내
 * department : 관악주거안심종합센터
 * regDate : 2025-05-07 // transform firestore Timestamp
 * hits : 1224
 * corporation : sh
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

      logger.log(`[SH] seq: ${seq} / no: ${no}`);

      const detail = await scrapeShNoticeDetail(seq);

      const notice = {
        id: `sh${seq}`,
        seq,
        no,
        title: titleElement.text().trim(),
        department,
        regDate,
        hits,
        corporation: 'sh',
        createdAt: FieldValue.serverTimestamp(),
        ...detail,
      };
      notices.push(notice);
    }

    // Check for new notices and save to Firestore
    const db = getFirestore();
    const batch = db.batch();
    const newNotices = [];

    for (const notice of notices) {
      const docRef = db.collection('sh').doc(notice.id);
      const docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // This is a new notice
        newNotices.push(notice);
      }

      batch.set(docRef, notice);
    }

    await batch.commit();

    await db.collection('log').doc('sh').set({
      timestamp: FieldValue.serverTimestamp(),
      message: 'SH notices scraped successfully',
    });

    logger.log('[SH] Notices scraped and saved!');
    return newNotices;
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
    .each((_, element) => {
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
  const contentTarget = $('tr').find('td.cont').first();
  if (contentTarget.length) {
    contentTarget.children().each((_, el) => {
      const text = $(el).text().trim();
      if (text) contents.push(text);
    });
  }
  if (!contents.length) {
    contents.push(contentTarget.text().trim());
  }

  return {
    files,
    contents,
    link: url,
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
 * id : gh63563 // gh + articleNo
 * seq : 63563 // articleNo
 * no : 493
 * title : 다산메트로3단지 국민임대주택(32B, 34A, 51A) 예비입주자 모집(2024.11.14.) 당첨자 발표 안내
 * department : 주택공급2부
 * regDate : 2025-04-30 // transform firestore Timestamp
 * hits : 1516
 * corporation : gh
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

      logger.log(`[GH] seq: ${seq} / no: ${no}`);

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
        createdAt: FieldValue.serverTimestamp(),
        ...detail,
      };
      notices.push(notice);
    }

    // Check for new notices and save to Firestore
    const db = getFirestore();
    const batch = db.batch();
    const newNotices = [];

    for (const notice of notices) {
      const docRef = db.collection('gh').doc(notice.id);
      const docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // This is a new notice
        newNotices.push(notice);
      }

      batch.set(docRef, notice);
    }

    await batch.commit();

    await db.collection('log').doc('gh').set({
      timestamp: FieldValue.serverTimestamp(),
      message: 'GH notices scraped successfully',
    });

    logger.log('[GH] Notices scraped and saved!');
    return newNotices;
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
  $('.download-file-list-wrap ul li').each((_, element) => {
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
  const contentTarget = $('.fr-view').first();
  if (contentTarget.length) {
    contentTarget.children().each((_, el) => {
      const text = $(el).text().trim();
      if (text) contents.push(text);
    });
  }
  if (!contents.length) {
    contents.push(contentTarget.text().trim());
  }

  return {
    files,
    contents,
    link: url,
  };
};

/**
 * Define BMC scraping rules
 *
 * url = https://gh.or.kr/gh/announcement-of-salerental001.do?mode=list&&articleLimit=10&srCategoryId=12&article.offset=0
 *
 * [BMC HTML 테이블 구조]
<table class="bod_list" style="width:100%; border-collapse:collapse; font-family:sans-serif;">
  <caption style="caption-side:top; text-align:left; font-weight:bold; padding:10px 0;">
    임대공고 목록 (번호, 제목, 파일, 작성자, 작성일, 조회)
  </caption>
  <thead style="background-color:#f2f2f2;">
    <tr>
      <th style="border:1px solid #ddd; padding:8px;">번호</th>
      <th style="border:1px solid #ddd; padding:8px;">제목</th>
      <th style="border:1px solid #ddd; padding:8px;">파일</th>
      <th style="border:1px solid #ddd; padding:8px;">작성자</th>
      <th style="border:1px solid #ddd; padding:8px;">작성일</th>
      <th style="border:1px solid #ddd; padding:8px;">조회</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="border:1px solid #ddd; padding:8px; text-align:center;">259</td>
      <td style="border:1px solid #ddd; padding:8px;">
        <a href="#" onclick="goTo.view('list','708002','769','0702000000'); return false;" style="color:#007BFF; text-decoration:none;">
          2025년 남부민풀리페 순환임대 하반기 입주자모집(자격완화) 공고
        </a>
      </td>
      <td style="border:1px solid #ddd; padding:8px; text-align:center;">
        <img src="/common/img/board/pdf.gif" alt="PDF 파일" style="margin-right:4px;">
        <img src="/common/img/board/hwp.gif" alt="한글 파일">
      </td>
      <td style="border:1px solid #ddd; padding:8px; text-align:center;">복지사업처</td>
      <td style="border:1px solid #ddd; padding:8px; text-align:center;">2025-07-11</td>
      <td style="border:1px solid #ddd; padding:8px; text-align:center;">372</td>
    </tr>
  </tbody>
</table>
 *
 * [크롤링 후 DB 저장할 데이터 예시]
 * id : bmc708002 // bmc + 708002(onclick="goTo.view('list','708002','769','0702000000');)
 * seq : 708002 // 708002(onclick="goTo.view('list','708002','769','0702000000');)
 * no : 259
 * title : 2025년 남부민풀리페 순환임대 하반기 입주자모집(자격완화) 공고
 * department : 복지사업처
 * regDate : 2025-07-11 // transform firestore Timestamp
 * hits : 372
 * corporation : bmc
 */
const scrapeBmcNotices = async () => {
  try {
    const url = `https://www.bmc.busan.kr/bmc/bbs/list.do?ptIdx=769&mId=0702000000`;
    const agent = new https.Agent({
      rejectUnauthorized: false, // 인증서 검증 비활성화
    });
    const response = await axios.get(url, {
      httpsAgent: agent,
    });
    const $ = cheerio.load(response.data);

    const notices = [];
    const rows = $('.bod_list tbody tr').toArray();

    for (const element of rows) {
      const columns = $(element).find('td');
      const no = parseInt($(columns[0]).text().trim(), 10);

      // Skip header or notice rows that don't have a number
      if (isNaN(no)) {
        continue;
      }

      const title = $(columns[1]).find('a').text().trim();
      const department = $(columns[3]).text().trim();
      const regDateText = $(columns[4]).text().trim();
      const regDate = dayjs(regDateText, 'YYYY-MM-DD').valueOf();
      const hits = parseInt($(columns[5]).text().trim(), 10) || 0;

      const onclickAttr = $(columns[1]).find('a').attr('onclick');
      const onclickParts = onclickAttr.split("'");
      const seq = onclickParts[3];

      logger.log(`[BMC] seq: ${seq} / no: ${no}`);

      const detail = await scrapeBmcNoticeDetail(seq);

      const notice = {
        id: `bmc${seq}`,
        seq,
        no,
        title,
        department,
        regDate,
        hits,
        corporation: 'bmc',
        createdAt: FieldValue.serverTimestamp(),
        ...detail,
      };
      notices.push(notice);
    }

    // Check for new notices and save to Firestore
    const db = getFirestore();
    const batch = db.batch();
    const newNotices = [];

    for (const notice of notices) {
      const docRef = db.collection('bmc').doc(notice.id);
      const docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // This is a new notice
        newNotices.push(notice);
      }

      batch.set(docRef, notice);
    }

    await batch.commit();

    await db.collection('log').doc('bmc').set({
      timestamp: FieldValue.serverTimestamp(),
      message: 'BMC notices scraped successfully',
    });

    logger.log('[BMC] Notices scraped and saved!');
    return newNotices;
  } catch (error) {
    logger.error('[BMC] Error scraping notices!', error);
    throw error;
  }
};

const scrapeBmcNoticeDetail = async (seq) => {
  const url = `https://www.bmc.busan.kr/bmc/bbs/view.do?bIdx=${seq}&ptIdx=769&mId=0702000000`;
  const agent = new https.Agent({
    rejectUnauthorized: false, // 인증서 검증 비활성화
  });
  const response = await axios.get(url, {
    httpsAgent: agent,
  });
  const $ = cheerio.load(response.data);

  // extract files
  const files = [];

  $('a[onclick*="fn_egov_preview"]').each((_, el) => {
    const onclick = $(el).attr('onclick');
    const m = onclick.match(/fn_egov_preview\(\s*([\s\S]*?)\s*\);/);
    if (!m) return;

    const args = m[1]
      .split(/,(?=(?:[^']*'[^']*')*[^']*$)/)
      .map((s) => s.trim().replace(/^'|'$/g, ''));

    if (args.length !== 5) return;

    const [atchFileId, fileSn, streFileNm, fileStreCours, orignlFileNm] = args;

    files.push({
      fileName: orignlFileNm,
      fileLink:
        `https://www.bmc.busan.kr/sn3hcvConvert.jsp` +
        `?atchFileId=${encodeURIComponent(atchFileId)}` +
        `&fileSn=${fileSn}` +
        `&streFileNm=${encodeURIComponent(streFileNm)}` +
        `&fileStreCours=${encodeURIComponent(fileStreCours)}`,
    });
  });

  // extract contents
  const contents = [];
  const contentTarget = $('.view_cont .mT10').first();
  if (contentTarget.length) {
    contentTarget.children().each((_, el) => {
      const text = $(el).text().trim();
      if (text) contents.push(text);
    });
  }
  if (!contents.length) {
    contents.push(contentTarget.text().trim());
  }

  return {
    files,
    contents,
    link: url,
  };
};

/**
 * Define IH scraping rules
 *
 * url = https://gh.or.kr/gh/announcement-of-salerental001.do?mode=list&&articleLimit=10&srCategoryId=12&article.offset=0
 *
 * [IH HTML 테이블 구조]
<div class="board_list">
  <ul class="generalList">
    <li>
      <p class="title" title="제목">
        <a href="/main/bbs/bbsMsgDetail.do?msg_seq=4053&amp;cate1=general&amp;bcd=notice&amp;pgdiv=general">
          2025년 iH 기존주택 매입임대(일반형) 예비입주자 선정결과 안내(중구)
        </a>
      </p>
      <div class="writer_info">
        <ul>
          <li class="file">
            <a href="/main/bbs/bbsMsgFileDownCompress.do?bcd=notice&amp;msg_seq=4053">
              <img src="/share/images/program/ic_file.gif" alt="1._2025_매입임대(일반형)_예비입주자_선정_명단(중구).xlsx 다운받기">
            </a>
          </li>
          <li class="center" title="공지사항">일반임대</li>
          <li class="center" title="작성일">2025.07.10</li>
          <li class="writer" title="작성자">주거복지처</li>
        </ul>
      </div>
    </li>
  </ul>
</div>
 *
 * [크롤링 후 DB 저장할 데이터 예시]
 * id : ih4053 // ih + 4053(<a href="/main/bbs/bbsMsgDetail.do?msg_seq=4053&amp;cate1=general&amp;bcd=notice&amp;pgdiv=general">)
 * seq : 4053 // 4053(<a href="/main/bbs/bbsMsgDetail.do?msg_seq=4053&amp;cate1=general&amp;bcd=notice&amp;pgdiv=general">)
 * no : 4053
 * title : 2025년 iH 기존주택 매입임대(일반형) 예비입주자 선정결과 안내(중구)
 * department : 주거복지처
 * regDate : 2025.07.10 // transform firestore Timestamp
 * hits : 0
 * corporation : ih
 */
const scrapeIhNotices = async () => {
  try {
    const url = 'https://www.ih.co.kr/main/sale_lease/notice.jsp';
    const response = await axios.get(url);
    const $ = cheerio.load(response.data);

    const notices = [];
    const rows = $('ul.generalList > li').toArray();

    for (const element of rows) {
      // msg_seq 파라미터가 들어있는 a 태그만 선택
      const link = $(element).find('a[href*="msg_seq="]').first();
      if (!link.length) continue; // 파일·빈 행 건너뛰기

      const href = link.attr('href').trim();
      const title = link.text().trim();

      // seq 파싱
      const seq = new URLSearchParams(href.split('?')[1]).get('msg_seq');
      if (!seq) continue;

      // 부서
      const department = $(element)
        .find('.writer_info li.writer[title="작성자"]')
        .text()
        .trim();

      // 작성일
      const regDateText = $(element)
        .find('.writer_info li.center[title="작성일"]')
        .text()
        .trim();
      const regDate = dayjs(regDateText, 'YYYY.MM.DD').valueOf();

      logger.log(`[IH] seq: ${seq} / no: -`);

      const detail = await scrapeIhNoticeDetail(seq);

      const notice = {
        id: `ih${seq}`,
        seq,
        no: parseInt(seq, 10), // Use seq as no
        title,
        department,
        regDate,
        corporation: 'ih',
        createdAt: FieldValue.serverTimestamp(),
        ...detail,
      };
      notices.push(notice);
    }

    // Check for new notices and save to Firestore
    const db = getFirestore();
    const batch = db.batch();
    const newNotices = [];

    for (const notice of notices) {
      const docRef = db.collection('ih').doc(notice.id);
      const docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // This is a new notice
        newNotices.push(notice);
      }

      batch.set(docRef, notice);
    }

    await batch.commit();

    await db.collection('log').doc('ih').set({
      timestamp: FieldValue.serverTimestamp(),
      message: 'IH notices scraped successfully',
    });

    logger.log('[IH] Notices scraped and saved!');
    return newNotices;
  } catch (error) {
    logger.error('[IH] Error scraping notices!', error);
    throw error;
  }
};

const scrapeIhNoticeDetail = async (seq) => {
  const url = `https://www.ih.co.kr/main/bbs/bbsMsgDetail.do?msg_seq=${seq}&cate1=general&bcd=notice&pgdiv=general`;
  const response = await axios.get(url);
  const $ = cheerio.load(response.data);

  // extract hits
  const hits = parseInt(
    $('.data_list dl dt')
      .filter((i, el) => $(el).text().trim() === '조회수')
      .next('dd')
      .text()
      .replace(/,/g, ''),
    10,
  );

  // extract files
  const files = [];
  $('.add_file li').each((i, el) => {
    const fileName = $(el).find('a').first().text().trim();
    const fileLink = $(el).find('a.btn_preview').attr('href');

    files.push({
      fileName,
      fileLink: `https://www.ih.co.kr${fileLink}`,
    });
  });

  // extract contents
  const contents = [];
  const contentTarget = $('.con .detail').first();
  if (contentTarget.length) {
    contentTarget.children().each((_, el) => {
      const text = $(el).text().trim();
      if (text) contents.push(text);
    });
  }
  if (!contents.length && contentTarget.length) {
    contents.push(contentTarget.text().trim());
  }

  return {
    hits,
    files,
    contents,
    link: url,
  };
};

module.exports = {
  scrapeShNotices,
  scrapeGhNotices,
  scrapeBmcNotices,
  scrapeIhNotices,
};
