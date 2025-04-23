<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.menu{
		margin: 15px;
		width: 250px;
		height: 400px;
		border: 2px solid black;
	}
	
	.user_menu {
		display: flex;
		flex-direction: column;
		width: 100%;
		text-align: center;
		margin-top: 10px;
		gap: 5px;
	}
	
	.user_menu a,
	.menu > a {
		display: flex;
		justify-content: center;
		align-items: center;
		height: 50px;
		border-bottom: 1px solid #ccc;
	}
	
	.user_menu a:hover,
	.menu > a:hover {
		color: black;
		background-color: #ddd;
	}
</style>
</head>
<body>
<div class="menu">
	<c:choose>
		<c:when test="${ isUser }">
			<div class="user_menu">
				<a href="${ contextPath }/member/mypageModifyView">내 정보 수정</a>
				<a href="${ contextPath }/member/bookingHistoryView">영화 예매 내역</a>
				<a href="${ contextPath }/member/postListView">등록한 게시글</a>
				<a href="${ contextPath }/member/memberDelete">회원탈퇴</a>
			</div>
		</c:when>
		<c:when test="${ isAdmin }">
			<a href="${ contextPath }/boxOffice/registerMovie">영화 정보 등록</a>
		</c:when>
	</c:choose>
</div>
</body>
</html>