<%@page import="com.project.movie.member.DTO.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath" value="${ pageContext.request.contextPath }"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="${ contextPath }/resources/js/daumPost.js"></script>
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
</head>
<style type="text/css">
	body, html {
		width: 100%;
		height: 100%;
		padding: 0;
		margin: 0;
		background-color: #f0f2f5;
	}
	a{
		color: black;
		text-decoration: none;
	}
	a:hover{
		color: blue;
		text-decoration: underline;
	}
	ul {
		margin: 5px;
	}
	li {
		list-style: none;
		position: relative;
	}
	li a {
		display: inline-block;
		padding: 5px 0;
		margin: 0;
		line-height: 1;
	}
	hr {
		margin: 0;
		padding: 0;
		border: none;
		border-top: 1px solid black;
	}
	.bottom-hr{
		margin-bottom: 20px;
	}
	input[type="submit"]:hover,
	button:hover {
		cursor: pointer;
	}
	
	.header, .nav {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 10px 20px;
	}
	.header ul, .nav ul {
		display: flex;
		gap: 20px;
	}
	
	.nav {
		justify-content: center; /* 메뉴를 중앙으로 정렬 */
	}
	.nav ul {
		display: flex;
		gap: 40px; /* 메뉴 항목 간격 */
	}
	
	.hover-box {
		display: none;
		position: absolute;
		top: 100%;
		left: 100%;
		transform: translateX(-50%); /* 정확한 중앙 정렬 */
		background-color: #f0f0f0;
		border: 1px solid black;
		border-radius: 0.5em;
		z-index: 10;
		padding: 20px;
		width: 200px;
		box-sizing: border-box; /* padding 포함된 너비로 설정 */
	}
	.hover-box .section h4 {
		margin-top: 5px;
		margin-bottom: 10px;
		font-size: 17px;
		font-weight: bold;
		border-bottom: 1px solid black;
		padding-bottom: 10px;
		text-align: center;
	}
	.hover-box .section a {
		display: block;
		color: black;
		margin: 5px 0;
	}
	li:hover .hover-box {
		display: block;
	}
</style>
<body>
	<div class="header">
		<div class="header_left">
			<a href="${ contextPath }/main">영화 예매 사이트</a>
		</div>
		
		<div class="header_rigth">
			<nav>
				<ul>
					<c:choose>
					    <c:when test="${not empty sessionScope.login}">
					        <li><a href="${contextPath}/member/logout">로그아웃</a></li>
					    </c:when>
					
					    <c:when test="${not empty sessionScope.kakaoId}">
					        <li><a href="${contextPath}/member/kakaoLogout">카카오 로그아웃</a></li>
					    </c:when>
					
					    <c:otherwise>
					        <li><a href="${contextPath}/member/login">로그인</a></li>
					        <li><a href="${ contextPath }/member/membership">회원가입</a></li>
					    </c:otherwise>
					</c:choose>
					<li><a href="${ contextPath }/member/mypage">마이페이지</a></li>
				</ul>
			</nav>
		</div>
	</div>
	<hr>
	<div class="nav">
		<nav>
			<ul>
				<li>
					<!-- 영화 메뉴 -->
					<a href="${ contextPath }/boxOffice/dailyOffice">영화</a>
					<div class="hover-box">
						<div class="section">
							<h4>영화</h4>
							<a href="${ contextPath }/boxOffice/dailyOffice">일일 박스오피스</a>
							<a href="${ contextPath }/boxOffice/weeklyOffice">주간 박스오피스</a>
						</div>
					</div>
				</li>
				<!-- 예매 메뉴 -->
				<li>
					<a href="${ contextPath }/booking/fastBooking">예매</a>
					<div class="hover-box">
						<div class="section">
							<h4>예매</h4>
							<a href="${ contextPath }/booking/fastBooking">빠른 예매</a>
						</div>
					</div>
				</li>
				<!-- 커뮤니티 메뉴 -->
				<li>
					<a href="${ contextPath }/community/reviewBoardList">게시판</a>
					<div class="hover-box">
						<div class="section">
							<h4>게시판</h4>
							<a href="${ contextPath }/community/reviewBoardList">리뷰 게시판</a>
						</div>
					</div>
				</li>
			</ul>
		</nav>
	</div>
	<hr>
	<div class="bottom-hr">
	</div>
</body>
<script type="text/javascript">
	function enterkey() {
	    if (window.event.keyCode == 13) {
	         document.getElementById("searchForm").submit();
	    }
	}
	
	const messages = {
	        loginMsg: "${loginMsg}",
	        loginError: "${loginError}",
	        logoutMsg: "${logoutMsg}",
	        membership: "${membership}",
	        mypageLogin: "${mypageLogin}",
	        updateSuccess: "${updateSuccess}",
	        updateFailed: "${updateFailed}",
	        movie_register: "${movie_register}",
	        seat_success: "${seat_success}",
	        seat_failed: "${seat_failed}",
	        seat_error: "${seat_error}",
	        payment_success: "${payment_success}",
	        payment_failed: "${payment_failed}",
	        payment_canceled: "${payment_canceled}",
	        cancelSuccess: "${cancelSuccess}",
	        cancelFailed: "${cancelFailed}",
	        addMovieMsg: "${addMovieMsg}",
	        deleteMsg: "${deleteMsg}"
	    };

	    for (const [key, message] of Object.entries(messages)) {
	        if (message) {
	            alert(message);
	        }
	    }

	    // 결제 성공시 처리
	    if (messages.payment_success) {
	        if (window.opener && !window.opener.closed) {
	            window.opener.location.href = "/movie/main";
	        }

	        setTimeout(() => {
	            window.close();
	        }, 100);
	    }

	    // 결제 실패나 취소시 처리
	    if (messages.payment_failed || messages.payment_canceled) {
	        window.close();
	    }
</script>
</html>