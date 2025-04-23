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
	
	.history-container {
	    width: 1500px;
	    height: 700px;
	    margin: 20px auto;
	    padding: 20px;
	    background-color: #f9f9f9;
	    border-radius: 10px;
	    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
	}
	
	.history-container h2 {
	    text-align: center;
	    margin-bottom: 20px;
	}
	
	.history-container table {
	    width: 100%;
	    border-collapse: collapse;
	}
	
	.history-container th, .history-container td {
	    padding: 10px;
	    text-align: center;
	    border-bottom: 1px solid #ddd;
	}
	
	button[type="button"],
	button[type="submit"] {
	    border: 1px solid #585858;
	    background-color: transparent;
	    color: #585858;
	    border-radius: 0.25rem;
	    height: 30px;
	    width: auto;
	    padding: 0 10px;
	    font-size: 14px;
	    display: inline-flex;
	    align-items: center;
	    justify-content: center;
	}

	button[type="button"]:hover,
	button[type="submit"]:hover {
	    background-color: #585858;
	    color: white;
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
		
		<div class="history-container">
			<h2>영화 예매 내역</h2>
			
			<table class="history-table">
				<thead>
					<tr>
						<th>영화 이름</th>
						<th>상영 날짜</th>
						<th>상영 시간</th>
						<th>좌석</th>
						<th>예매 취소</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="bookingList" items="${ bookingList }">
						<tr>
							<td>${ bookingList.movieName }</td>
							<td>${ bookingList.movieShowDate }</td>
							<td>${ bookingList.movieShowTime }</td>
							<td>${ bookingList.seatInfo }</td>
							<td>
								<form action="${ contextPath }/member/cancelBooking" method="post">
									<input type="hidden" name="seatInfo" value="${ bookingList.seatInfo }">
									<button type="submit">취소</button>
								</form>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>