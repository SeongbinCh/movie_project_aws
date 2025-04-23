<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<script src="https://js.tosspayments.com/v1/payment"></script>
<style type="text/css">
	.first_box {
		display: flex;
	    justify-content: center;
	    align-items: center;
	    height: 100vh;
	}
	.payment_box {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		border: 1px solid #ccc;
		background-color: #f2f0e4;
		width: 480px;
		height: 400px;
		border-radius: 1.5em;
		box-shadow: 0 10px 24px rgba(0, 0, 0, 0.2);
		padding: 30px;
		
	}
	
	.payment_box h2 {
		font-size: 24px;
		margin-bottom: 20px;
		color: #333;
	}
	
	.button_container {
		display: flex;
		gap: 20px;
		margin-top: 30px;
	}
	
	.kakao_Btn {
		width: 140px;
		height: 60px;
		border: none;
		border-radius: 0.7em;
		background-color: #FEE500;
		color: #3C1E1E;
		font-weight: bold;
		cursor: pointer;
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
		transition: transform 0.2s;
	}
	.toss_Btn {
		width: 140px;
		height: 60px;
		border: none;
		border-radius: 0.7em;
		background-color: #0064FF;
		color: white;
		font-weight: bold;
		cursor: pointer;
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
		transition: transform 0.2s;
	}
	.kakao_Btn:hover, .toss_Btn:hover {
		transform: scale(1.05);
	}
</style>
</head>
<body>
	<div class="first_box">
		<div class="payment_box">
			<h2>결제 방법 선택</h2>
			<div class="button_container">
				<button type="button" class="kakao_Btn" onclick="processPayment('kakao')">카카오페이</button>
				<button type="button" class="toss_Btn" onclick="processPayment('toss')">토스페이</button>
			</div>
		</div>
	</div>
	
</body>
<script type="text/javascript">
	window.onload = function() {
	    if (typeof Kakao !== 'undefined') {
	      Kakao.init("${kakaopayJavascriptKey}"); // 카카오 앱 키로 초기화
	    } else {
	      console.error("카카오 SDK 로딩 실패");
	    }
	}
	
	const tossPayments = TossPayments("${tosspayClientKey}");
	
	function requestTossPayment() {
	    const orderId = "order-" + Date.now();

	    tossPayments.requestPayment("토스페이", {
	    	amount: parseInt("${param.totalPrice}"),
	        orderId: orderId,
	        orderName: "영화 티켓 - " + "${param.movieTitle}",
	        customerName: "${sessionScope.loginMember.name}",
	        successUrl: "http://localhost:8080/movie/booking/tossSuccess"
	        + "?seats=" + encodeURIComponent("${param.seats}")
	        + "&movieCd=" + encodeURIComponent("${param.movieCd}")
	        + "&showtimeId=" + encodeURIComponent("${param.showtimeId}")
	        + "&amount=" + encodeURIComponent("${param.totalPrice}"),
	        failUrl: "http://localhost:8080/movie/booking/tossFail"
	    });
	}
	
	function processPayment(paymentType) {
		if (paymentType === "toss") {
	        requestTossPayment(); // toss 위젯 직접 실행
	        return;
	    }
		
		let formData = new FormData();
		formData.append("paymentType", paymentType);
		formData.append("movieCd", "${ param.movieCd }");
		formData.append("showtimeId", "${ param.showtimeId }");
		formData.append("seats", "${ param.seats }");
		formData.append("totalPrice", "${ param.totalPrice }");
		
		
		fetch("/movie/booking/processPayment?movieCd=" + encodeURIComponent("${param.movieCd}") + 
	            "&showtimeId=" + encodeURIComponent("${param.showtimeId}") + 
	            "&seats=" + encodeURIComponent("${param.seats}") + "&totalPrice=" + encodeURIComponent("${param.totalPrice}") + "&paymentType=" + paymentType, {
			method: "POST"
		})
		.then(response => response.json())
		.then(data => {
			if( data.success ) {
				window.location.href = data.paymentUrl;
			} else {
				alert("결제 요청 실패 : " + data.message);
			}
		})
		.catch(error => console.error("Error : ", error));
	}
</script>
</html>