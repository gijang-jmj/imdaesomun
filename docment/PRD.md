# 📄 제품 요구사항 명세서 (PRD)

## 1. 📌 제품 개요

### 1.1 개요

서울주택공사(SH), 경기주택공사(GH)의 임대주택 공고 정보를 간편하게 확인하고, 공고 저장 및 푸시 알림 기능을 제공하는 모바일 애플리케이션.

### 1.2 플랫폼

- 안드로이드 모바일 어플리케이션 앱
- IOS 모바일 어플리케이션 앱

### 1.3 주요 사용자

- 청년/신혼부부 등 임대주택 관심자
- 임대주택 입주 대기자

## 2. 📦 기술 스택

| 구성 요소 | 기술 |
| ----- | ------------------------------- |
| 프론트엔드 | Flutter + Riverpod |
| 백엔드 | Firebase Cloud Functions |
| 인증 | Firebase Auth |
| DB | Firebase Firestore (NoSQL) |
| 푸시 알림 | Firebase Cloud Messaging (FCM) |
| 주기 작업 | Google Cloud Scheduler |
| 키 관리 | Firebase Remote Config + Google Secret Manager |
| 테스트 | Flutter + Firebase Emulator Suite |
| 디자인 | Figma + UX Pilot |

## 3. 🛠️ 기능 명세

### 3.1 임대공고 크롤링

* **조건**: 30분마다 실행
* **대상**: 공사 별 임대공고 목록 페이지
* **저장 항목**: 제목, 부서, 등록일, 조회수
* **표시 항목**: -
* **기능**:
  * 공사 별 임대공고 리스트, 상세 페이지 크롤링 및 저장
  * 새로운 임대공고 발생 시 푸시 알림
* **구현 방식**:
  * Firebase Cloud Functions - 관련 API
  * Firebase Firestore - 데이터 관리
  * Firebase Cloud Messaging - 푸시 알림
  * Google Cloud Scheduler - 주기 작업

### 3.2 임대공고 리스트

* **조건**: 메인 페이지 접속 시
* **대상**: 모든 사용자
* **저장 항목**: -
* **표시 항목**: 임대공고 리스트, 순서 변경 버튼
* **기능**:
  * 공사 별 임대공고 리스팅
  * 임대공고 별 제목, 부서, 등록일, 조회수
  * 공사 리스트 순서 변경
* **구현 방식**
  * Flutter - 데이터 출력
  * Firebase Cloud Functions - 관련 API
  * Firebase Firestore - 데이터 관리

### 3.3 임대공고 상세

* **조건**: 임대공고 클릭 시
* **대상**: 모든 사용자
* **저장 항목**: 임대공고 (회원 기능)
* **표시 항목**: 임대공고 상세 내용, 공고 열기 버튼, 저장 버튼
* **기능**:
  * 임대공고 상세 페이지 내용 출력
  * 첨부파일 미리보기 웹뷰
  * 공고보기 원본링크 웹뷰
  * 공고 저장하기 (회원 기능)
* **구현 방식**
  * Flutter - 데이터 출력
  * Firebase Cloud Functions - 관련 API
  * Firebase Firestore - 데이터 관리

### 3.4 임대공고 저장 리스트

* **조건**: 저장됨 페이지 접속 시 
* **대상**: 모든 사용자
* **저장 항목**: -
* **표시 항목**: 저장된 공고 리스트, 공사 필터
* **기능**:
  * 저장된 공고 리시트 출력
  * 전체 / SH / GH 필터
  * 인피니티 스크롤
* **구현 방식**
  * Flutter - 데이터 출력
  * Firebase Cloud Functions - 관련 API
  * Firebase Firestore - 데이터 관리

### 3.5 사용자 관리

* **조건**: 내정보 페이지 접속 시
* **대상**: 로그인 사용자
* **저장 항목**: -
* **표시 항목**: -
* **기능**:
  * 로그인
  * 공고 알림
  * 닉네임 설정 기능 (회원 기능)
  * 로그아웃
  * 회원 탈퇴
* **구현 방식**
  * Flutter - 데이터 출력
  * Firebase Auth - 인증
  * Firebase Cloud Functions - 관련 API
  * Firebase Firestore - 데이터 관리

## 4. 📱 Flutter 앱 구조

### 4.1 주요 프론트엔드 스펙

- Flutter 3.29.2
- Dart 3.7.2
- Riverpod (상태 관리)
- MVVM (Model-View-ViewModel)
- Firebase 연동 (Auth, Firestore, Remote Config, Messaging)
- 주요 패키지: go_router, freezed, dio, shared_preferences, flutter_secure_storage, flutter_svg, intl, shimmer 등
- Pretendard 폰트 적용

### 4.2 디렉토리

```bash
firebase
├──  functions                   # API (Firebase Functions)
lib
├── main.dart                    # 앱 엔트리 포인트
└── src
    ├── core
    │   ├── constants            # 상수 (route path)
    │   ├── enums                # enum (log, notice)
    │   ├── helpers              # 서비스 유틸
    │   ├── providers            # 전역 프로바이더
    │   ├── router               # 라우터 설정
    │   ├── services             # 서비스 로직
    │   ├── theme                # 앱 테마
    │   └── utils                # 공통 유틸
    ├── data
    │   ├── models               # 모델 클래스
    │   ├── providers            # 데이터 프로바이더 (user)
    │   ├── repositories         # 데이터 처리
    │   └── sources
    │       ├── local            # 데이터 로컬 소스 (SharedPreferences)
    │       └── remote           # 데이터 리모트 소스 (Dio)
    └── ui
        ├── components           # 최소 단위 UI
        │   ├── badge
        │   ├── button
        │   ├── field
        │   └── switch
        ├── pages                # 페이지 단위 UI
        │   ├── dialog
        │   ├── home
        │   │   └── widgets      # 페이지 위젯
        │   ├── log
        │   ├── notice
        │   │   ├── state
        │   │   └── widgets
        │   ├── profile
        │   │   └── widgets
        │   ├── saved
        │   │   └── widgets
        │   └── webview
        └── widgets              # 공통 사용 위젯
            ├── app_bar
            ├── card
            ├── dev_tools
            ├── dialog
            ├── error
            ├── footer
            ├── loading
            ├── login
            ├── nav
            └── toast
```

### 4.3 페이지 구성
* **Nav**: 공통 바텀 네비
  * Home, Saved, Profile 구성
* **Home**: 임대공고 리스트 페이지
  * 임대공고 리스트(*3.2)
* **Notice**: 임대공고 상세 페이지
  * 임대공고 리스트(*3.3)
* **Saved**: 저장된 공고 페이지
  * 게시글 리스트(*3.4)
* **Profile**: 내정보 페이지
  * 사용자 관리(*3.5)

## 5. 🗃️ Firestore 구조

### sh, gh (공고)

SH, GH 임대공고는 각각 `/sh/{noticeId}`, `/gh/{noticeId}` 컬렉션에 저장됩니다.

```
/sh/{noticeId} 또는 /gh/{noticeId}
  - id: string           // 공고 ID (예: sh287910, gh63563)
  - seq: string          // 원본 사이트의 공고 번호
  - no: number           // 게시판 번호(목록상 번호)
  - title: string        // 공고 제목
  - department: string   // 담당 부서명
  - regDate: timestamp   // 등록일 (Firestore Timestamp)
  - hits: number         // 조회수
  - corporation: "sh" | "gh" // 공사 구분
  - createdAt: timestamp // 생성일 (Firestore serverTimestamp)
  - files: array         // 첨부파일 목록 [{ fileName, fileLink, ... }]
  - contents: array      // 상세 본문 내용 (문단별 배열)
  - link: string         // 원본 상세 페이지 링크
```

> 참고: 상세 필드 구조는 `firebase/functions/logic/scrape.js` 참고

### log (크롤링 로그)

SH, GH 크롤링 작업의 실행 로그는 각각 `/log/sh`, `/log/gh` 문서에 저장됩니다.

```
/log/{corp}
  - timestamp: timestamp   // 크롤링 실행 시각 (Firestore serverTimestamp)
  - message: string        // 로그 메시지 (예: 'SH notices scraped successfully')
```

> 참고: 크롤링 성공/실패 시점에 기록됨. 신규 공고 등 상세 내역은 별도 notice 컬렉션 참조.

### fcm (푸시 토큰)

FCM 토큰 정보는 `/fcm/{token}` 문서에 저장됩니다.

```
/fcm/{token}
  - token: string         // FCM 토큰 (문서 ID)
  - userId: string|null   // 사용자 ID (옵션)
  - device: string|null   // 디바이스 정보 (옵션)
  - allowed: boolean      // 푸시 알림 허용 여부 (최초 등록 시 false, 사용자가 허용 시 true)
  - createdAt: timestamp  // 등록/갱신 시각 (Firestore serverTimestamp)
```

> 참고: allowed=true인 토큰에만 전체 푸시 발송. 불량 토큰은 자동 삭제됨.  
> 상세 로직은 `firebase/functions/logic/fcm.js` 참고

### save (저장된 공고)

사용자가 저장한 공고 정보는 `/save/{userId_noticeId}` 문서에 저장됩니다.

```
/save/{userId_noticeId}
  - userId: string         // 사용자 ID
  - noticeId: string       // 공고 ID
  - corporation: "sh" | "gh" // 공사 구분
  - createdAt: timestamp   // 저장 시각 (Firestore serverTimestamp)
```

> 참고: 저장된 공고 목록 조회 시, 실제 공고 상세 정보는 sh/gh 컬렉션에서 병합 조회  
> 상세 로직은 `firebase/functions/logic/save.js` 참고

## 6. 🔁 Google Cloud Scheduler 흐름 예시

### 크롤링 함수

1. Google Cloud Scheduler가 30분마다 HTTP POST로 scrapeNotices 함수를 호출
2. scrapeNotices 함수에서 SH, GH 공사별 공고 목록을 각각 크롤링 (scrapeShNotices, scrapeGhNotices)
3. 각 공고별로 Firestore에 저장 (신규 공고만 newNotices로 분류)
4. 신규 공고가 있으면 FCM 전체 푸시 발송 (sendFcmToAllLogic)
5. 크롤링/저장 로그를 Firestore log 컬렉션에 기록
6. 응답: 신규 SH/GH 공고 개수 반환

> 참고: 상세 로직 구조는 `firebase/functions` 참고

## 7. 🧪 보안 사항

1. **API Key 관리**
   - 모든 서버 API는 Google Secret Manager에 저장된 API Key로 보호됨.
   - 서버 함수(`index.js`)는 매 요청마다 헤더의 API Key(`x-imdaesomun-api-key`)를 검증.

2. **클라이언트 키 수신 및 저장**
   - 클라이언트(Flutter)는 Firebase Remote Config에서 API Key를 받아옴.
   - 받은 키는 `flutter_secure_storage`에 안전하게 저장 및 관리됨.
   - 관련 코드: `ApiKeyInterceptor` (`dio_service.dart`)

3. **API Key 갱신 및 노출 대응**
   - 키가 노출되거나 변경 필요 시, Google Secret Manager에서 키를 폐기 및 신규 발급.
   - Firebase Remote Config의 API Key 값도 즉시 갱신.

4. **자동 키 갱신 로직**
   - 서버에서 키가 변경되어 401(Unauthorized) 응답이 발생하면,
   - 클라이언트의 `ApiKeyInterceptor`가 Remote Config에서 새 키를 받아와 저장 후, 요청을 자동 재시도함.

5. **보안 흐름 요약**
   - 키 노출 시: Secret Manager에서 키 폐기 및 신규 발급 → Remote Config 업데이트 → 클라이언트 자동 갱신 및 재시도
   - 키는 클라이언트에 직접 하드코딩하지 않으며, 항상 Remote Config와 Secure Storage를 통해 관리

> 관련 파일:  
> - 서버: `firebase/functions/index.js`  
> - 클라이언트: `lib/src/core/services/dio_service.dart` (ApiKeyInterceptor)

## ✅ 프로젝트 단계별 우선순위

1. 임대공고 관련 기능
2. 사용자 관리 기능
3. 푸시 관련 기능
4. 저장된 공고 관련 기능
5. API 보안 및 앱 로그
6. 테스트 완료 후 배포
