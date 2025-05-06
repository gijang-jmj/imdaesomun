# 📄 제품 요구사항 명세서 (PRD)

## 1. 📌 제품 개요

서울주택공사(SH), 경기주택공사(GH)의 임대주택 공고 정보를 자동으로 수집하고 정리하여, 사용자에게 최신 정보를 빠르게 제공하는 모바일 애플리케이션. 공고에 대한 커뮤니티 기능 및 요약 정보 제공을 통해 사용자 간 정보 격차를 줄이고자 한다.

---

## 2. 🎯 핵심 기능 요약

| 기능     | 구현 방식                                      |
| ------ | ------------------------------------------ |
| 공고 크롤링 | Firebase Cloud Functions + Cloud Scheduler |
| AI 요약  | 사용자 요청 시 Cloud Function에서 OpenAI API 호출    |
| 데이터 저장 | Firebase Firestore (NoSQL DB)              |
| 푸시 알림  | Firebase Cloud Messaging (FCM)             |
| 로그인    | Firebase Auth (익명 또는 닉네임 기반)               |
| 커뮤니티   | Firestore 기반 게시글 및 댓글 기능 구현                |

---

## 3. 🛠️ 세부 기능 명세

### 3.1 공고 크롤링

* **주기**: 30분마다 실행
* **대상**: SH, GH의 임대 공고 목록 페이지
* **저장 항목**: 제목, 공사명, 지역, 시작일, 마감일, 링크
* **새 공고 확인 후**:

  * Firestore에 저장
  * FCM을 통해 전체 사용자에게 푸시 알림

### 3.2 상세페이지 + AI 요약

* 앱 사용자가 상세정보를 열람할 때 동작
* Cloud Function이 상세페이지 크롤링 후 OpenAI API 호출
* 요약 결과를 Firestore에 저장
* 이후 동일 공고는 캐싱된 요약 데이터를 보여줌

### 3.3 공고 리스트 UI

* Firestore의 notices 컬렉션 구독 또는 요청 기반 렌더링
* 최신순, 마감임박순 정렬 가능
* 상세페이지 접속 시 요약 출력 또는 "요약 생성" 버튼 노출

### 3.4 커뮤니티 기능

* **게시글**: 텍스트 본문 + 선택적 공고 참조
* **댓글**: 게시글 기준 텍스트 댓글 등록 가능
* **Firestore 컬렉션 구조**:

  * `posts`: 게시글 데이터 저장
  * `comments`: 댓글 데이터 저장
* 기본 신고/차단 기능은 추후 버전에 고려

### 3.5 푸시 알림

* Cloud Functions에서 새 공고 발생 시 FCM 토픽 `"all"` 구독자에게 전송
* 메시지 내용: 공고 제목 + 요약 텍스트 일부 (있는 경우)

### 3.6 사용자 관리

* Firebase Auth로 로그인

  * 익명 또는 닉네임 설정 기반
* 스크랩한 공고 리스트 Firestore의 사용자 문서에 저장 가능

---

## 4. 🗃️ Firestore 데이터 구조

### notices (공고)

```
/notices/{noticeId}
  - title: string
  - organization: "SH" | "GH"
  - location: string
  - startDate: timestamp
  - endDate: timestamp
  - url: string
  - detailHtml: string (optional)
  - summary: string (optional)
  - createdAt, updatedAt: timestamp
```

### users (사용자)

```
/users/{uid}
  - nickname: string
  - scrap: array of notice ids
  - createdAt: timestamp
```

### posts (게시글)

```
/posts/{postId}
  - uid: string
  - noticeId: string (optional)
  - content: string
  - createdAt: timestamp
```

### comments (댓글)

```
/comments/{commentId}
  - postId: string
  - uid: string
  - content: string
  - createdAt: timestamp
```

---

## 5. 🔁 Firebase Cloud Functions 흐름 예시

### 크롤링 함수

```ts
exports.crawlNotices = functions.pubsub.schedule('every 30 minutes').onRun(async () => {
  // 공고 페이지 크롤링 → 신규 여부 확인 → Firestore 저장 → FCM 전송
});
```

### AI 요약 함수

```ts
exports.summarizeNotice = functions.https.onCall(async (data, context) => {
  const { noticeId } = data;
  // detailHtml 없으면 크롤링 → OpenAI API 호출 → 요약 저장
});
```

### 푸시 알림 전송

```ts
admin.messaging().sendToTopic("all", {
  notification: {
    title: "새로운 임대 공고가 등록되었어요!",
    body: notice.title,
  },
});
```

---

## 6. 📱 Flutter 앱 구조 요약

* **HomePage**: 최신 공고 리스트 표시 (Firestore 연동)
* **NoticeDetailPage**: 상세내용 + 요약 확인 / 요약 요청 버튼
* **CommunityPage**: 게시글 및 댓글 리스트 + 작성 기능
* **ProfilePage**: 닉네임 설정, 스크랩 리스트 보기

---

## 7. 🧪 보안 및 기타 고려 사항

* Firestore 보안 규칙 작성 필수 (쓰기/읽기 제한)
* 요약 요청 과다 방지: 하루 요청 횟수 제한 또는 캐싱 처리
* 크롤링 중복 삽입 방지 로직 포함
* FCM 토픽 구독은 로그인 시 자동 처리

---

## 8. 📦 기술 스택 정리

| 구성 요소 | 기술                              |
| ----- | ------------------------------- |
| 프론트엔드 | Flutter                         |
| 백엔드   | Firebase Cloud Functions        |
| 인증    | Firebase Auth                   |
| DB    | Firebase Firestore (NoSQL)      |
| AI 요약 | OpenAI GPT API (Functions에서 호출) |
| 푸시 알림 | Firebase Cloud Messaging (FCM)  |
| 주기 작업 | Firebase Cloud Scheduler        |

---

## ✅ 프로젝트 단계별 우선순위

1. 공고 크롤링 + Firestore 저장 + 리스트 출력
2. 상세페이지 크롤링 + AI 요약 함수 구현
3. 커뮤니티 기능 (게시글/댓글)
4. FCM 푸시 알림
5. 프로필 및 스크랩 기능
6. 보안 규칙 및 테스트 완료 후 배포
