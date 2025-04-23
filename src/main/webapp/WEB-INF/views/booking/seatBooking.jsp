<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.box {
		display: flex;
		height: 100vh;
	}
	.second_box {
	    display: flex;
	    flex-direction: column;
	    justify-content: center;
	    align-items: center;
	    width: 1300px;
	    height: 650px;
	    background-color: #f2f0e4;
	    border: 1px solid black;
		border-radius: 1em;
		box-shadow: 0 10px 24px rgba(0, 0, 0, 0.3);
	    margin: 50px auto;
	    margin-left: 100px;
	    padding: 10px;
	    gap: 20px;
	}
	
	.person_item {
		display: flex;
		align-items: center;
		margin-bottom: 10px;
	}
	
	.person_item span {
	    margin-right: 20px;  /* : 뒤에 여유 공간 추가 */
	}
	
	.person_box {
		display: flex;
		gap: 10px;
	}
	
	.person-option {
		width: 40px;
	    height: 40px;
	    display: flex;
	    justify-content: center;
	    align-items: center;
	    border: 2px solid #ccc;
	    background-color: #f2f0e4;
	    cursor: pointer;
	    font-size: 16px;
	    font-weight: 600;
	    border-radius: 5px;
	    transition: background-color 0.3s;
	}
	
	.person-option:hover {
	    background-color: #f2f0e4;
	}
	
	.person-option.selected {
	    background-color: #E50914;
	    color: white;
	}
	
	.person-option.disabled {
	    background-color: #D3D3D3;
	    color: #777;
	    cursor: not-allowed;
	}
	
	.selected-seat {
	    background-color: #E50914;
	    color: white;
	    cursor: pointer;
	}
	
	#seat_map {
		display: flex;
		flex-direction: column;
		gap: 5px;
		margin-top: 20px;
	}
	
	.row {
		display: flex;
		gap: 5px;
	}
	
	.seat {
		width: 35px;
		height: 35px;
		border: 1px solid black;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		margin: 3px;
		background-color: white;
		cursor: pointer;
	}
	.selected {
		background-color: red;
		color: white;
	}
	.reserved {
		background-color: #D3D3D3;
		pointer-events: none;
		color: white;
	}
	
	/* 선택된 정보 div */
	.seat_container {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		border: 1px solid black;
		border-radius: 1em;
		box-shadow: 0 10px 24px rgba(0, 0, 0, 0.3);
		width: 20%;
		height: 70%;
		margin: 50px 70px 50px 30px;
		color: white;
		background-color: #1d1d1c;
	}
	
	.seat_container > div {
		padding: 10px;
		text-align: center;
		font-size: 16px;
	    font-weight: 600;
	}
	
	.seat_container > div:not(:last-child) {
		border-bottom: 1px solid #666;
		width: 200px;
	}
	
	/* 결제 버튼 */
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
		margin-top: 10px;
		font-size: 16px;
	    font-weight: 600;
	}
</style>
</head>
<body onload="initializeSeatSelection()">
	<% String showtimeId = request.getParameter("showtimeId"); 
    request.setAttribute("showtimeId", showtimeId); %>

	<div class="box">
		<div class="second_box">
			<div id="person_selector">
				<div class="person_item">
					<span>청소년 &nbsp; : </span>
					<div class="person_box" id="teen-box">
						<div class="person-option" data-person="0">0</div>
	                    <div class="person-option" data-person="1">1</div>
	                    <div class="person-option" data-person="2">2</div>
	                    <div class="person-option" data-person="3">3</div>
	                    <div class="person-option" data-person="4">4</div>
	                    <div class="person-option" data-person="5">5</div>
	                    <div class="person-option" data-person="6">6</div>
	                    <div class="person-option" data-person="7">7</div>
	                    <div class="person-option" data-person="8">8</div>
					</div>
				</div>
				<div class="person_item">
					<span>&nbsp; &nbsp;성인 &nbsp; : </span>
					<div class="person_box" id="adult-box">
	                    <div class="person-option" data-person="0">0</div>
	                    <div class="person-option" data-person="1">1</div>
	                    <div class="person-option" data-person="2">2</div>
	                    <div class="person-option" data-person="3">3</div>
	                    <div class="person-option" data-person="4">4</div>
	                    <div class="person-option" data-person="5">5</div>
	                    <div class="person-option" data-person="6">6</div>
	                    <div class="person-option" data-person="7">7</div>
	                    <div class="person-option" data-person="8">8</div>
	                </div>
				</div>
			</div>
			<div id="seat_map">
	            <!-- 좌석들이 여기서 동적으로 생성됩니다 -->
	        </div>
		</div>
		<div class="seat_container">
			<div id="moviePoster_section"><img src="${ moviePoster }" alt="movie Poster" /></div>
			<div id="movie_section">${ movie }</div>
			<div id="date_section">${ date }</div>
			<div id="time_section">${ time }</div>
			<div id="price_section">총 가격 : <span id="total_price">0원</span></div>
			<div id="seat_section">좌석선택</div>
			<form action="${ contextPath }/booking/paymentPage" method="GET" id="paymentForm">
				<input type="hidden" name="movie" value="${ movie }">
				<input type="hidden" name="date" value="${ date }">
				<input type="hidden" name="time" value="${ time }">
				<input type="hidden" name="totalPrice" id="totalPriceInput" value="0">
				<input type="hidden" name="movieCd" value="${ movieCd }">
				<input type="hidden" name="showtimeId" value="${ showtimeId }">
				<input type="hidden" name="seats" id="selectedSeatsInput" value="">
				<button type="submit" class="payment_btn">결제</button>
			</form>
		</div>
	</div>
</body>
<script type="text/javascript">
	const seatsData = <%= new com.google.gson.Gson().toJson(request.getAttribute("seats")) %>;
	
	const youthPrice = 9000;
    const adultPrice = 12000;
    let youthCount = 0;
    let adultCount = 0;
    let totalPrice = 0;
	
	document.addEventListener("DOMContentLoaded", function() {
	    initializeSeatSelection();
	});
	
	function initializeSeatSelection() {
		// 좌석 맵과 선택한 좌석을 표시할 영역
		const seatMap = document.getElementById("seat_map");
		const selectedSeatsDisplay = document.getElementById("seat_section");
		const rows = ["A", "B", "C", "D", "E", "F", "G"];
		const cols = 13;
		const maxSeats = 0;
		
		let teenCount = 0;
	    let adultCount = 0;
	    let maxTeenCount = 0;
	    let maxAdultCount = 0;
	    
	    
		
		seatMap.innerHTML = "";
		
		// 좌석 생성
		rows.forEach( row => {
			const rowDiv = document.createElement("div");
			rowDiv.classList.add("row");
			
			for( let col = 1; col <= cols; col++ ) {
				const seatId = row + col;
				
				const seat = document.createElement("div");
				seat.classList.add("seat");
				seat.dataset.seat = seatId;
				seat.textContent = seatId;
				
				const seatData = seatsData.find( seatData => seatData.seatId == seatId );
				if( seatData && seatData.isReserved ){
				 	seat.classList.add("reserved");
				} else {
					seat.addEventListener("click", () => toggleSeatSelection( seat ));
				}
				
				rowDiv.appendChild( seat );
			}
			
			seatMap.appendChild( rowDiv );
		} );
		
		
		// 좌석 선택/해제
		function toggleSeatSelection( seat ) {
			const selectedSeats = document.querySelectorAll(".seat.selected");
			const totalSelectedCount = selectedSeats.length;
	        const maxSelectableSeats = maxTeenCount + maxAdultCount;
			
			if( seat.classList.contains("selected") ) {
				seat.classList.remove("selected");
				updateSelectedSeats();
			} else {
				if( totalSelectedCount < maxSelectableSeats ) {
		            seat.classList.add("selected");
		            updateSelectedSeats();
		        } else {
		            alert("최대 " + maxSelectableSeats + "명까지 선택 가능합니다");
		            
		        }
			}
			
		}
		
		function setSelectedCount(count, type) {
	        if( type === "teen" ) {
	            youthCount = count;
	            maxTeenCount = count;
	        } else if( type === "adult" ) {
	            adultCount = count;
	            maxAdultCount = count;
	        }

	        const options = document.querySelectorAll("#" + type + "-box .person-option");

	        options.forEach(option => {
	            const personCount = parseInt(option.dataset.person, 10);

	            if( personCount === count ) {
	                option.classList.add("selected");
	            } else {
	                option.classList.remove("selected");
	            }
	        });

	        updateTotalPrice();
	    }
		
		const teenBox = document.getElementById("teen-box");
		const adultBox = document.getElementById("adult-box");
		
		teenBox.addEventListener("click", (e) => {
			if( e.target.classList.contains("person-option") ) {
				const count = parseInt(e.target.dataset.person, 10);
				setSelectedCount(count, 'teen');
			}
		});
		
		adultBox.addEventListener("click", (e) => {
	        if( e.target.classList.contains("person-option") ) {
	        	const count = parseInt(e.target.dataset.person, 10);
	            setSelectedCount(count, 'adult');
	        }
	    });
		
		function updateSelectedSeats() {
			const selectedSeats = Array.from(document.querySelectorAll(".seat.selected"))
			.map(seat => seat.dataset.seat);
			
			if( selectedSeats.length > 0 ) {
				selectedSeatsDisplay.textContent = "선택한 좌석 : " + selectedSeats.join(", ");
			} else {
				selectedSeatsDisplay.textContent = "좌석 선택";
			}
			
			document.getElementById("selectedSeatsInput").value = selectedSeats.join(",");
		}
		
	    document.getElementById("paymentForm").addEventListener("submit", function(event) {
	        const selectedSeats = document.getElementById("selectedSeatsInput").value;

	        if( !selectedSeats ) {
	            alert("좌석을 선택해주세요.");
	            event.preventDefault();
	            return false;
	        }
	    });
		
		function updateTotalPrice() {
			totalPrice = (youthCount * youthPrice) + (adultCount * adultPrice);
			document.getElementById("total_price").innerText = totalPrice.toLocaleString() + "원";
			document.getElementById("totalPriceInput").value = totalPrice;
		}
	}
</script>
</html>