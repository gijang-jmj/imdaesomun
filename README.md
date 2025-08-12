# 🏠 임대소문 - 임대주택 공고 알리미

여러 공사의 임대주택 공고 정보를 간편하게 확인하고, 공고 저장 및 푸시 알림 기능을 제공하는 **모바일 애플리케이션**입니다.

## 📱 앱 다운로드

<p align="left">
  <a href="https://apps.apple.com/kr/app/%EC%9E%84%EB%8C%80%EC%86%8C%EB%AC%B8/id6747034249" target="_blank">
    <img src="https://img.shields.io/badge/App%20Store-000000?style=for-the-badge&logo=apple&logoColor=white" alt="Download on the App Store"/>
  </a>
  &nbsp;
  <a href="https://play.google.com/store/apps/details?id=com.jmj.imdaesomun" target="_blank">
    <img src="https://img.shields.io/badge/Google%20Play-414141?style=for-the-badge&logo=google-play&logoColor=white" alt="Get it on Google Play"/>
  </a>
  <br/>
</p>

## 📸 실행 화면

<p align="left">
  <img src="https://github.com/user-attachments/assets/defef96d-468e-4287-8e99-bdcb18aa9b4c" alt="앱 스크린샷 1" width="200" style="margin:8px;"/>
  <img src="https://github.com/user-attachments/assets/e3727331-70b4-43ad-9461-2b3450715b63" alt="앱 스크린샷 2" width="200" style="margin:8px;"/>
  <img src="https://github.com/user-attachments/assets/ecb67f32-3f0c-4adf-8466-bd325b43f6ef" alt="앱 스크린샷 3" width="200" style="margin:8px;"/>
  <img src="https://github.com/user-attachments/assets/d0a34289-2bad-4d8b-87b1-f141e36865ab" alt="앱 스크린샷 4" width="200" style="margin:8px;"/>
</p>

## 🚀 주요 기능

- 임대 공고 조회: SH(서울), GH(경기), IH(인천), BMC(부산)
- 공고 상세 확인 및 첨부파일 인앱뷰어
- 공고 저장/삭제(즐겨찾기) 기능
- 저장된 공고 업데이트 시 푸시 알림
- Firebase 기반 회원 로그인/탈퇴 기능

## ⏱️ 개발 기간

| 단계 | 기간               |
| ---- | ------------------ |
| 설계 | 2025.05.06 ~ 05.17 |
| 구현 | 2025.05.18 ~ 06.09 |
| QA   | 2025.06.10 ~ 06.11 |
| 오픈 | 2025.06.11 ~       |

## 🛠️ 기술 스택

| 항목        | 내용                                                |
| ----------- | --------------------------------------------------- |
| 프레임워크  | Flutter 3.29.2                                      |
| 언어        | Dart 3.7.2                                          |
| 아키텍처    | MVVM + Riverpod                                     |
| 라우팅      | go_router                                           |
| 네트워크    | dio                                                 |
| 상태 관리   | Riverpod                                            |
| 인증        | Firebase Auth                                       |
| 푸시 알림   | Firebase Cloud Messaging (FCM)                      |
| 인증/보안   | Firebase Auth, Google Secret Manager, Remote Config |
| 로컬 저장소 | flutter_secure_storage, shared_preferences          |
| 기타        | webview_flutter, intl, shimmer                      |

## 📂 디렉토리 구조

```bash
imdaesomun/
├─ lib/                    # 애플리케이션 Dart 소스
│  ├─ main.dart            # 앱 엔트리
│  └─ src/
│     ├─ core/             # 코어 (전역 상수/라우팅/서비스/헬퍼/테마/유틸)
│     │  ├─ constants/     # 라우팅 경로 등 상수 정의
│     │  ├─ enums/         # 공통 열거형 (로그 타입, 공지 타입 등)
│     │  ├─ helpers/       # UI/도메인 보조 로직 (다이얼로그, 예외, 공지 가공, 사용자)
│     │  ├─ providers/     # 전역 Riverpod Provider (dio, 네비게이션, 로딩, 로그, 토스트)
│     │  ├─ router/        # go_router 설정 (AppRouter)
│     │  ├─ services/      # 외부/플랫폼 연계 Service (네트워크, 권한 등)
│     │  ├─ theme/         # 색상, 아이콘, 크기, 스타일, 테마 정의
│     │  └─ utils/         # 순수 유틸 함수 (포맷/텍스트/타이밍/검증)
│     ├─ data/             # 데이터 계층 (Model ↔ Source ↔ Repository)
│     │  ├─ models/        # Freezed + JsonSerializable 데이터 모델
│     │  ├─ providers/     # 데이터 관련 Provider (Firebase, User)
│     │  ├─ repositories/  # Repository 인터페이스 및 구현 (Notice, User)
│     │  └─ sources/       # Data Source (local / remote 분리)
│     │     ├─ local/      # SharedPreferences 등 로컬 캐시
│     │     └─ remote/     # API / Firebase 호출
│     └─ ui/               # 표현 & 화면 계층
│        ├─ components/    # 재사용 가능한 소형 위젯 (버튼, 필드, 배지, 스위치 등)
│        ├─ pages/         # 페이지 단위 (MVVM: *_view_model.dart 포함)
│        │  ├─ home/       # 홈 (HomePage + ViewModel)
│        │  ├─ notice/     # 공고 목록/상세 관련 페이지 & 상태
│        │  ├─ log/        # 로그 확인 페이지
│        │  ├─ dialog/     # 공용 다이얼로그 테스트/호출 페이지
│        │  ├─ profile/    # 프로필 (로그인/탈퇴 등)
│        │  ├─ saved/      # 저장(즐겨찾기) 공고 목록
│        │  └─ webview/    # 인앱 웹뷰 페이지
│        └─ widgets/       # 도메인/레이아웃 공용 위젯 (AppBar, Card, Nav, Toast 등 그룹 폴더)
```

### 계층 개요 (MVVM + Riverpod)

- UI (pages, components, widgets)
  - View: 페이지/위젯 구성
  - ViewModel: \*page_view_model.dart (상태/이벤트 처리 - Riverpod Notifier/Provider)
- Data
  - Model: Freezed 데이터 구조
  - Repository: 도메인 추상화 (Interface + Impl)
  - Source: remote/local 분리 (API, Firebase, 캐시)
- Core
  - Cross-cutting concerns (라우팅, 테마, 서비스, 유틸, Provider)

### 주요 흐름 예시 (공지 조회)

UI(Page) → ViewModel(Provider) → Repository → Remote Source(Dio/Firebase) → Model 변환 → ViewModel 상태 업데이트 → UI 반영

### 기타

- 토스트/로딩/네비게이션: Core providers + 전역 헬퍼로 호출 간소화
- 예외 처리: exception_helper 통해 표준화 후 UI 노출 (토스트/다이얼로그)
- 테마: app_theme.dart 단일 진입, 색상·텍스트·사이즈 분리 관리

## 📦 백엔드 및 인프라

- Firebase Functions
- Google Cloud Scheduler (공고 크롤링 크론)
- Google Secret Manager 키 관리
- Firestore 보안 규칙 적용

## 📡 API 개요 (Firebase Functions)

- https://github.com/gijang-jmj/imdaesomun-monorepo/blob/main/documents/API_SPEC.md

## 📬 문의

이 프로젝트에 대한 개선 제안이나 문의는 **Issues** 또는 **Pull Request**로 자유롭게 남겨주세요.
