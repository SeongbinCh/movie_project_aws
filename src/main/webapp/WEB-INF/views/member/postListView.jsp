<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	.page-container {
        display: flex;
        justify-content: flex-start;
    }

	.menu{
		margin: 15px;
		width: 250px;
		height: 400px;
		border: 2px solid black;
		flex-shrink: 0;
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
	.menu > a  {
		display: flex;
		justify-content: center;
		align-items: center;
		height: 50px;
		border-bottom: 1px solid #ccc;
	}
	
	.user_menu a:hover,
	.menu > a:hover  {
		color: black;
		background-color: #ddd;
	}
	
	.postList-container {
	    width: 1500px;
	    height: 700px;
	    margin: 20px auto;
	    padding: 20px;
	    background-color: #f9f9f9;
	    border-radius: 10px;
	    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
	}
	
	.postList-container h2 {
	    text-align: center;
	    margin-bottom: 20px;
	}
	
	.postList-container table {
	    width: 100%;
	    border-collapse: collapse;
	}
	
	.postList-container th, .postList-container td {
	    padding: 10px;
	    text-align: center;
	    border-bottom: 1px solid #ddd;
	}
</style>
<%@ include file="../default/header.jsp" %>
</head>
<body>
	<div class="page-container">
		<div class="menu">
			<c:if test="${ isUser }">
				<div class="user_menu">
					<a href="${ contextPath }/member/mypageModifyView">내 정보 수정</a>
					<a href="${ contextPath }/member/bookingHistoryView">영화 예매 내역</a>
					<a href="${ contextPath }/member/postListView">등록한 게시글</a>
					<a href="${ contextPath }/member/memberDelete">회원탈퇴</a>
				</div>
			</c:if>
			<c:if test="${ isAdmin }">
				<a href="${ contextPath }/boxOffice/registerMovie">영화 정보 등록</a>
			</c:if>
		</div>
		
		<div class="postList-container">
			<h2>등록한 게시글 내역</h2>
			
			<table class="postList-table">
				<thead>
					<tr>
						<th>제목</th><th>날짜</th><th>시간</th><th>조회수</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="postList" items="${ postList }">
						<tr>
							<td><a href="${ contextPath }/community/reviewContentPage?review_no=${ postList.review_no }">${ postList.title }</a></td>
							<td>${ postList.review_date }</td>
							<td>${ postList.review_time }</td>
							<td>${ postList.hit }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>