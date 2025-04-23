# 🎬 영화 예매 사이트

## 💻 프로젝트 소개
신입 백엔드 개발자를 위한 포트폴리오 프로젝트로, 실사용 가능한 영화 예매 시스템을 구현하였습니다. 영화 예매, 결제, 게시판, 마이페이지 등 다양한 기능을 포함하고 있으며, 관리자 기능까지 포함된 전체적인 서비스 흐름을 경험할 수 있습니다.

## 🛠️ 사용 기술 스택
- **Back-End**: Java, Spring MVC, MyBatis
- **Front-End**: JSP, HTML, CSS, JavaScript
- **Database**: Oracle (SQL Developer 사용)
- **API**: TMDB API, KOFIC API, 카카오페이, 토스페이먼츠
- **개발환경**: STS 3 (Spring Tool Suite)

## ⚙️ 주요 기능

### 🔐 회원 기능
- 로그인 / 로그아웃 / 회원가입
- 로그인 전 페이지 기억 후 로그인 시 해당 페이지로 리다이렉트
- 회원 탈퇴
- 마이페이지
  - 내 정보 수정
  - 예매 내역 확인 및 취소<p>
    <img src="https://github.com/user-attachments/assets/89ad747c-3020-4cef-8d35-49f779235bc2" width="700" height="300">
  - 내가 작성한 게시글 목록<p>
    <img src="https://github.com/user-attachments/assets/b8f073cc-00b3-4696-884f-2bfcc9e89ac5" width="700" height="300">

### 🎥 영화 기능
- TMDB / KOFIC API를 통해 영화 정보 불러오기
- 일일 박스오피스 / 주간 박스오피스<p>
  <img src="https://github.com/user-attachments/assets/82998a71-ca41-4ae1-9713-9e01fc193566" width="700" height="300">
- 영화 상세 정보 페이지
- 인기 TOP10 롤링 배너
- 영화 검색 (자동완성 기능 포함)<p>
  <img src="https://github.com/user-attachments/assets/5148e582-6ff3-4876-92cd-5d174ee2be5b" width="700" height="300">

### 🎟️ 예매 기능
- FastBooking: 영화, 날짜, 시간 선택<p>
  <img src="https://github.com/user-attachments/assets/56f67f6b-5a63-4185-b251-e256ec3de768" width="700" height="300">
- 좌석 선택 → 인원 수 선택 (성인/청소년)<p>
  <img src="https://github.com/user-attachments/assets/eb23a69f-f1e1-4ec5-9da5-7f5862132382" width="700" height="300">
- 결제: 카카오페이 / 토스페이 연동<p>
  <img src="https://github.com/user-attachments/assets/4e80bbc3-a0c2-41b9-bfe1-59a7f4fd4724" width="600" height="450">
- 예매 완료 후 메인 화면으로 이동

### 📝 게시판
- 게시글 CRUD
- 카테고리 별 구분<p>
  <img src="https://github.com/user-attachments/assets/e4b66055-bcce-42a0-9dc0-66eaa582250c" width="700" height="300">
- 조회수, 댓글 / 대댓글 기능<p>
  <img src="https://github.com/user-attachments/assets/08d404d9-98b9-4cc3-b655-292db075feb3" width="450" height="400">

### 💼 관리자 기능
- 마이페이지에서 관리자만 영화 등록 가능

## 📌 예외 처리
- 로그인 상태에 따른 기능 접근 제한<br>
  - 게시글 리스트에서 로그인한 상태일 경우에만 글쓰기 버튼 노출
  - 비로그인 상태에서 마이페이지 접근 시 로그인 알림창 출력 후 로그인 페이지로 이동
  - 예매 과정 중, 영화/날짜/시간 선택 후 좌석 선택 버튼 클릭 시 비로그인 상태라면 로그인 알림창 출력 후 로그인 페이지로 이동
  - 댓글 및 대댓글 작성 시 비로그인 상태일 경우 로그인 알림창 출력

## ✍️ 느낀점 및 회고
프로젝트를 진행하면서 외부 API 사용법에 대해 많은 것을 배울 수 있었습니다.
API마다 필수 파라미터나 요청 방식이 다르고, 같은 API라도 어떻게 활용하느냐에 따라 구현 방식이 달라진다는 점이 흥미로웠습니다.

또한, 혼자 프로젝트를 진행하다 보니 메서드마다 역할을 명확하게 설명해두는 것이 얼마나 중요한지 느꼈습니다.
이름이 비슷한 메서드가 많아질수록 헷갈릴 수 있었고, 주석을 통해 기능을 명확히 설명하는 습관이 필요하다는 것을 다시 한 번 실감했습니다.

---
