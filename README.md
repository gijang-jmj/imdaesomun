# 🏠 임대소문 - 임대주택 공고 알리미

여러 공사의 임대주택 공고 정보를 간편하게 확인하고, 공고 저장 및 푸시 알림 기능을 제공하는 **비영리 모바일 애플리케이션**입니다.

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

- 임대 공고 조회
  - 서울주택공사(SH)
  - 경기주택공사(GH)
  - 인천도시공사(IH) **`new`**
  - 부산도시공사(BMC) **`new`**
- 공고 상세 확인 및 첨부파일 뷰어
- 공고 저장 기능
- 저장된 공고 업데이트 시 푸시 알림
- Firebase 기반 회원 로그인/탈퇴 기능

---

## 🛠️ 기술 스택 (Flutter)

| 항목         | 내용 |
|--------------|------|
| 프레임워크   | Flutter 3.29.2 |
| 언어         | Dart 3.7.2 |
| 아키텍처     | MVVM + Riverpod |
| 라우팅       | go_router |
| 네트워크     | dio |
| 상태 관리    | Riverpod |
| 인증         | Firebase Auth |
| DB           | Firebase Firestore |
| 푸시 알림    | Firebase Cloud Messaging (FCM) |
| 보안         | Google Secret Manager, App Check, Remote Config |
| 저장소       | flutter_secure_storage, shared_preferences |
| 기타         | webview_flutter, intl, shimmer |
| 디자인       | Figma, Pretendard 폰트 |

## 📦 백엔드 및 인프라

- Firebase Cloud Functions
- Google Cloud Scheduler (주기적 공고 크롤링)
- Google Secret Manager 키 관리
- Firestore 보안 규칙 적용

## 📬 문의

이 프로젝트에 대한 개선 제안이나 문의는 **Issues** 또는 **Pull Request**로 자유롭게 남겨주세요.  
자세한 **프로젝트 요구사항(PRD)은** 👉 [**여기**](https://github.com/gijang-jmj/imdaesomun/blob/main/docment/PRD.md)에서 확인하실 수 있어요.
