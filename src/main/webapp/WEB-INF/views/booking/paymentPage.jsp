<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.first_box {
		display: flex;
		justify-content: center;
		height: 100vh;
	}
	.payment_container {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		border: 1px solid black;
		border-radius: 1em;
		width: 500px;
		height: 800px;
		color: white;
		background-color: #1d1d1c;
		box-shadow: 0 10px 24px rgba(0, 0, 0, 0.3);
	}
	.payment_container > div {
		padding: 10px;
		text-align: center;
		font-size: 16px;
	    font-weight: 600;
	}
	.payment_container > div:not(:last-child) {
		border-bottom: 1px solid #666;
		width: 200px;
	}
	.payment_btn {
		display: inline-block;
	    border: 2px solid #E50914;
	    border-radius: 0.5em;
	    color: white;
	    background-color: #E50914;
	    text-align: center;
	    width: 100px;
	    height: 80px;
	    line-height: 60px;
	    font-size: 16px;
	    font-weight: 600;
	    margin-top: 10px;
	}
</style>
</head>
<body>
	<div class="first_box">
		<div class="payment_container">
			<h2>결제 페이지</h2>
			<div><img src="${ moviePoster }" alt="Movie Poster" /></div>
			<div>영화 : ${ movie }</div>
			<div>날짜 : ${ date }</div>
			<div>시간 : ${ time }</div>
			<div>총 금액 : ${ totalPrice }원</div>
			<div>선택한 좌석 : ${ seats }</div>
			
			<button type="button" class="payment_btn" onclick="openPaymentPopup()">결제</button>
		</div>
	</div>
</body>
<script type="text/javascript">
	var movieCd = "${ movieCd }";
	var showtimeId = "${ showtimeId }";
	var seats = "${ seats }";

	function openPaymentPopup() {
		let encodedSeats = encodeURIComponent(seats);
		let encodedTotalPrice = encodeURIComponent("${totalPrice}");
		let url = "/movie/booking/paymentPopup?movieCd=" + movieCd + "&showtimeId=" + showtimeId + "&seats=" + encodedSeats + "&totalPrice=" + encodedTotalPrice;
	    
	    let popup = window.open(url, "paymentPopup", "width=600, height=800");
		
		if( popup == null ) {
			alert("팝업이 차단되었습니다. 팝업 차단을 해제해주세요.");
		}
	}
</script>
</html>