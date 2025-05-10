# 📄 제품 요구사항 명세서 (PRD)

## 1. 📌 제품 개요

### 1.1 개요

서울주택공사(SH), 경기주택공사(GH)의 임대주택 공고 정보를 자동으로 수집하고 정리하여, 사용자에게 최신 정보를 빠르게 제공하는 모바일 애플리케이션. 공고에 대한 커뮤니티 기능 및 요약 정보 제공을 통해 사용자 간 정보 격차 해소.

### 1.2 플랫폼

- 안드로이드 모바일 어플리케이션 앱
- IOS 모바일 어플리케이션 앱

### 1.3 주요 사용자

- 청년/신혼부부 등 임대주택 관심자
- 임대주택 입주 대기자

## 2. 📦 기술 스택 정리

| 구성 요소 | 기술                              |
| ----- | ------------------------------- |
| 프론트엔드 | Flutter + Riverpod              |
| 백엔드   | Firebase Cloud Functions        |
| 인증    | Firebase Auth                   |
| DB    | Firebase Firestore (NoSQL)      |
| AI 요약 | OpenAI API (Functions에서 호출) |
| 푸시 알림 | Firebase Cloud Messaging (FCM)  |
| 주기 작업 | Firebase Cloud Scheduler        |
| 키 관리 | Firebase Remote Config + Google Secret Manager |
| 테스트   | Flutter + Firebase Emulator Suite |

## 3. 🛠️ 기능 명세

### 3.1 임대공고 크롤링

* **주기**: 30분마다 실행
* **대상**: SH, GH의 임대공고 목록 페이지
* **저장 항목**: 제목, 부서, 등록일, 조회수
* **새로운 임대공고 확인 시**:
  * Firestore에 저장
  * FCM을 통해 사용자에게 푸시 알림

### 3.2 임대공고 리스트

* 앱 사용자가 메인 페이지 접속 시 동작
* 각 공사 별 임대공고 데이터 가져오기
* 제목, 부서, 등록일, 조회수 표시

### 3.3 임대공고 미리보기 (AI 요약 기능)

* 앱 사용자가 임대공고 미리보기 시 동작
* 임대공고 상세 페이지 크롤링 (상세 페이지 데이터 없을 경우)
* OpenAI로 본문 요약 표시
* 요약 데이터 Firestore에 저장
* 이후 동일 임대공고는 캐싱된 요약 데이터를 보여줌

### 3.3 임대공고 상세

* 앱 사용자가 임대공고 열람 시 동작
* 임대공고 상세 페이지 크롤링 (상세 페이지 데이터 없을 경우)
* 상세 페이지 데이터 Firestore에 저장
* 이후 동일 임대공고는 캐싱된 상세 페이지 데이터를 보여줌

### 3.4 커뮤니티 기능

* **게시글**: 텍스트 본문 + 선택적 공고 참조
* **댓글**: 게시글 기준 텍스트 댓글 등록 가능
* **Firestore 컬렉션 구조**:
  * `posts`: 게시글 데이터 저장
  * `comments`: 댓글 데이터 저장
* 게시글 삭제/수정 기능

### 3.5 푸시 알림

* Cloud Functions에서 새 공고 발생 시 FCM 토픽 `"all"` 구독자에게 전송
* 메시지 내용: 공고 제목 + 요약 텍스트 일부 (있는 경우)

### 3.6 사용자 관리

* Firebase Auth로 로그인
  * 익명 또는 닉네임 설정 기반
* 내가 작성한 게시글 및 댓글 확인
* 닉네임 중복 방지 및 금칙어 필터링
* 회원 탈퇴(익명 계정 삭제) 기능

## 4. 📱 Flutter 앱 구조

### 4.1 설계 패턴

- MVVM (Model-View-ViewModel)
- Riverpod (상태 관리)

### 4.2 디렉토리

```bash
firebase
├──  functions                   # API (Cloud Functions)
lib
├── main.dart                    # 앱 엔트리 포인트
└── src
    ├── core
    │   ├── constants            # const 상수 (ex. router path)
    │   ├── enums                # enum 상수 (ex. SH | GH)
    │   ├── helpers              # 서비스 유틸
    │   ├── router               # 라우터 정의
    │   ├── services             # 공통 서비스 (ex. loading, toast)
    │   ├── theme                # 테마 관련 (ex. color, icon) 
    │   └── utils                # 공통 유틸
    ├── data
    │   ├── models               # 모델 클래스
    │   ├── providers            # repository provider
    │   ├── repositories         # 데이터 처리
    │   └── sources              # 데이터 소스
    └── ui
        ├── components           # 재사용 가능한 UI (ex. button)
        ├── pages                
        │   ├── community        # 커뮤니티 페이지
        │   ├── home             # 임대공고 리스트 페이지
        │   ├── notice           # 임대공고 상세 페이지
        │   ├── post             # 커뮤니티 게시글 상세 페이지
        │   └── profile          # 내정보 페이지
        └── widgets              # 특정 화면에서만 사용하는 위젯
```

### 4.3 페이지
* **Home**: 임대공고 리스트 페이지
  * 임대공고 리스트 표시
  * 임대공고 별 본문 요약 보기 버튼
* **Notice**: 임대공고 상세 페이지
  * 임대공고 본문 표시
* **Community**: 커뮤니티 페이지
  * 게시글 리스트 표시
* **Post**: 커뮤니티 게시글 상세 페이지
  * 게시글 본문 표시
  * 게시글 댓글 표시
  * 게시글 작성 및 수정
* **Profile**: 내정보 페이지
  * 닉네임 수정
  * 내가 작성한 게시글 보기
  * 내가 작성한 댓글 보기

### 4.4 UX/UI

* 시드컬러
  * HEX: #2CB1A3
  * RGB: rgb(44, 177, 163)

* 폰트
  * Pretendard

## 5. 🗃️ Firestore 데이터 구조

### notices (공고)

* 제목, 기관, 위치, 공고 기간, 상세 URL
* 상세 HTML 및 요약 데이터는 사용자 요청 시 저장

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

* 닉네임, 생성일, 내가 작성한 글/댓글 조회용 필드

```
/users/{uid}
  - nickname: string
  - createdAt: timestamp
```

### posts (게시글)

* 텍스트 본문 + 선택적 공고 참조

```
/posts/{postId}
  - uid: string
  - noticeId: string (optional)
  - content: string
  - createdAt: timestamp
```

### comments (댓글)

* 게시글에 대한 댓글 저장

```
/comments/{commentId}
  - postId: string
  - uid: string
  - content: string
  - createdAt: timestamp
```

## 6. 🔁 Firebase Cloud Functions 흐름 예시

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

## 7. 🧪 보안 및 기타 고려 사항

* Firestore 보안 규칙 작성 필수 (쓰기/읽기 제한)
* 요약 요청 과다 방지: 하루 요청 횟수 제한 또는 캐싱 처리
* 크롤링 중복 삽입 방지 로직 포함
* FCM 토픽 구독은 로그인 시 자동 처리
* OpenAI API Key 등 민감정보 노출 방지
* FCM 푸시 알림 opt-in/opt-out(사용자 설정) 지원

## ✅ 프로젝트 단계별 우선순위

1. 공고 크롤링 + Firestore 저장 + 리스트 출력
2. 상세페이지 크롤링 + AI 요약 함수 구현
3. 커뮤니티 기능 (게시글 및 댓글)
4. 내정보 기능 (내가 작성한 게시글 및 댓글)
5. FCM 푸시 알림
6. 보안 규칙 및 테스트 완료 후 배포
