# 임대소문 API 명세서

## 기본 URL

`https://asia-northeast1-imdaesomun.cloudfunctions.net`

## 인증

모든 API 요청은 인증을 위한 API 키를 필요 * mobile 전용

* **헤더**: `x-imdaesomun-api-key`
* **값**: `API_KEY`

또는 Firebase App Check를 통한 인증 * web 전용

---

## 1. 공고 관련

### 1.1. 공고 크롤링 실행

* **엔드포인트**: `/scrapeNotices`
* **메서드**: `POST`
* **설명**: 
  * 전체 공사(SH, GH, BMC, IH)의 공고 크롤링
  * 새로운 공고 발생 시 구독자에게 FCM 알림 전송
* **요청 바디**: 없음
* **성공 응답** (`200`):

  ```json
  {
    "message": "Notices scraped and saved successfully.",
    "newShNotices": 1,
    "newGhNotices": 0,
    "newBmcNotices": 2,
    "newIhNotices": 0
  }
  ```
* **실패 응답** (`500`):

  ```json
  {
    "error": "Failed to scrape notices."
  }
  ```

### 1.2 \~ 1.5. 각 공사별 공고 조회

* SH 공사: `/getShNotices`

* GH 공사: `/getGhNotices`

* BMC (부산도시공사): `/getBmcNotices`

* IH (인천도시공사): `/getIhNotices`

* **메서드**: `GET`

* **설명**: 해당 공사에서 가장 최근의 공고 10건 조회

* **요청 파라미터**: 없음

* **성공 응답 예시 (`200`)**:

  ```json
  [
    {
      "id": "sh287910",
      "title": "[골드타워] 당첨세대 주택공개 및 사전점검 안내",
      "department": "관악주거안심종합센터",
      "regDate": 1746543600000,
      "hits": 1224,
      "corporation": "sh"
    }
  ]
  ```

* **실패 응답 (`500`)**:

  ```json
  {
    "error": "Failed to fetch SH notices."
  }
  ```

### 1.6. 공고 ID로 단일 조회

* **엔드포인트**: `/getNoticeById`
* **메서드**: `GET`
* **설명**: 모든 공사 콜렉션에서 단일 공고 조회
* **쿼리 파라미터**:

  * `noticeId` (필수): 공고 ID (예: `sh287910`)
* **성공 응답 (`200`)**:

  ```json
  {
    "collection": "sh",
    "id": "sh287910",
    "title": "[골드타워] 당첨세대 주택공개 및 사전점검 안내"
  }
  ```
* **오류 응답**:

  * `400`: `{ "error": "Missing parameter." }`
  * `404`: `{ "error": "Notice not found." }`
  * `500`: `{ "error": "Failed to fetch notice." }`

---

## 2. 저장된 공고 관련

### 2.1. 공고 저장

* **엔드포인트**: `/saveNotice`
* **메서드**: `POST`
* **설명**: 사용자(회원) 공고 저장 기능
* **요청 바디**:

  ```json
  {
    "noticeId": "sh287910",
    "userId": "user_firebase_uid"
  }
  ```
* **성공 응답 (`200`)**:

  ```json
  {
    "message": "Notice saved."
  }
  ```
* **오류 응답**:

  * `400`: `{ "error": "Missing parameter." }`
  * `404`: `{ "error": "Notice not found." }`
  * `500`: `{ "error": "Failed to save notice." }`

### 2.2. 공고 삭제

* **엔드포인트**: `/deleteNotice`
* **메서드**: `POST`
* **설명**: 사용자(회원)의 저장된 공고 삭제
* **요청 바디**:

  ```json
  {
    "noticeId": "sh287910",
    "userId": "user_firebase_uid"
  }
  ```
* **성공 응답 (`200`)**:

  ```json
  {
    "message": "Notice deleted."
  }
  ```

### 2.3. 공고 저장 여부 확인

* **엔드포인트**: `/getNoticeSaved`
* **메서드**: `GET`
* **쿼리 파라미터**:

  * `noticeId` (필수)
  * `userId` (필수)
* **성공 응답 (`200`)**:

  ```json
  {
    "saved": true
  }
  ```

### 2.4. 저장된 공고 목록 조회

* **엔드포인트**: `/getSavedNotices`
* **메서드**: `GET`
* **쿼리 파라미터**:

  * `userId` (필수)
  * `corporation` (선택): 필터링 용
  * `limit` (선택, 기본 10)
  * `offset` (선택, 기본 0)
* **성공 응답 (`200`)**:

  ```json
  {
    "notices": [ { "id": "sh287910", ... } ],
    "hasMore": true,
    "nextOffset": 10,
    "totalFetched": 10,
    "totalCount": 25,
    "shCount": 15,
    "ghCount": 5,
    "bmcCount": 3,
    "ihCount": 2
  }
  ```

---

## 3. FCM & 푸시 알림

### 3.1. FCM 토큰 등록

* **엔드포인트**: `/registerFcmToken`
* **메서드**: `POST`
* **설명**: 디바이스의 FCM 토큰 등록 및 갱신
* **요청 바디**:

  ```json
  {
    "token": "fcm_device_token",
    "userId": "user_firebase_uid", // 선택
    "device": "device_info_string", // 선택
    "allowed": true // 선택
  }
  ```
* **성공 응답**:

  ```json
  {
    "message": "Token registered/updated."
  }
  ```

### 3.2. 푸시 알림 허용 여부 조회

* **엔드포인트**: `/getPushAllowed`
* **메서드**: `POST`
* **요청 바디**:

  ```json
  {
    "token": "fcm_device_token"
  }
  ```
* **응답 (`200`)**:

  ```json
  {
    "allowed": true
  }
  ```

### 3.3. 푸시 알림 허용 설정

* **엔드포인트**: `/setPushAllowed`
* **메서드**: `POST`
* **요청 바디**:

  ```json
  {
    "token": "fcm_device_token",
    "allowed": false,
    "userId": "user_firebase_uid", // 선택
    "device": "device_info_string" // 선택
  }
  ```
* **응답 (`200`)**:

  ```json
  {
    "message": "Push allowed updated."
  }
  ```

### 3.4. 전체 사용자에게 FCM 전송 (관리자 전용)

* **엔드포인트**: `/sendFcmToAll`
* **메서드**: `POST`
* **요청 바디**:

  ```json
  {
    "title": "중요 공지",
    "body": "새로운 업데이트를 확인하세요.",
    "data": { "screen": "updates" } // 선택
  }
  ```
* **응답 (`200`)**:

  ```json
  {
    "message": "FCM sent to all tokens.",
    "successCount": 500,
    "failureCount": 5,
    "deletedTokens": 2
  }
  ```

---

## 4. 시스템

### 4.1. 마지막 크롤링 시간 조회

* **엔드포인트**: `/getLatestScrapeTs`
* **메서드**: `GET`
* **설명**: 각 공사별 마지막 크롤링 성공 시간 타임스탬프 반환
* **응답 (`200`)**:

  ```json
  {
    "sh": { "_seconds": 1752246000, "_nanoseconds": 0 },
    "gh": { "_seconds": 1752246000, "_nanoseconds": 0 },
    "bmc": { "_seconds": 1752246000, "_nanoseconds": 0 },
    "ih": { "_seconds": 1752246000, "_nanoseconds": 0 }
  }
  ```
