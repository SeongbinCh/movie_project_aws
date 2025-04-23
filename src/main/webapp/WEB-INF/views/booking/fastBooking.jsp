<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.first_box{
		display: flex;
		flex-direction: row;
		justify-content: center;
		height: 100vh;
	}
	
	.second_box {
		display: flex;
		flex-direction: row;
		justify-content: space-around;
		align-items: flex-start;
		width: 2500px;
		height: 700px;
		background-color: #f2f0e4;
		border: 1px solid black;
		border-radius: 1em;
		box-shadow: 0 10px 24px rgba(0, 0, 0, 0.3);
		margin: 50px auto;
		margin-left: 250px;
		padding: 10px;
		gap: 20px;
	}
	
	.title_container {
		display: flex;
		flex-direction: column;
		align-items: center;
		width: 30%;
	}
	
	.movie_title, .date_title, .time_title {
		display: flex;
		justify-content: center;
		align-items: center;
		width: 300px;
		height: 50px;
		border: 1px solid black;
		border-radius: 0.5em;
		background-color: #1C1C1C;
		color: white;
		margin-top: 15px;
	}
	
	/* 공용 컨테이너 스타일 */
	#movie_button_container, #date_button_container, #time_button_container {
		display: flex;
		flex-direction: column;
		align-items: center;
		margin-top: 25px;
		padding: 10px;
		overflow-y: auto;
		width: 300px;
		height: 550px;
	}
	
	.movie_button {
		border: 1px solid black;
		background-color: white;
		margin: 10px;
		padding: 5px;
		width: 90%;
		text-align: left;
	}
	
	.date_button {
		border: 1px solid black;
		background-color: white;
		margin: 10px;
		padding: 5px;
		width: 40%;
		text-align: center;
	}

	.time_button {
		border: 1px solid black;
		background-color: white;
		margin: 10px;
		padding: 5px;
		width: 90%;
		text-align: center;
	}
	
	.movie_button:hover, .date_button:hover, .time_button:hover {
		cursor: pointer;
		background-color: #D9D9D9;
		transform: translateY(-2px);  /* 버튼이 살짝 위로 이동 */
    	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 살짝 떠오르는 느낌 */
	}
	
	.seat_container {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
		background-color: #1C1C1C;
		color: white;
		border: 1px solid black;
		border-radius: 1em;
		box-shadow: 0 10px 24px rgba(0, 0, 0, 0.3);
		margin: 50px 70px 50px 30px;
		width: 350px;
		height: 720px;
		font-size: 16px;
	    font-weight: 600;

	}
	.seat_container > div {
		padding: 10px;
		text-align: center;
	}
	.seat_container > div:not(:last-child) {
		border-bottom: 1px solid #666;
		width: 200px;
	}

	.seat_choice {
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
	}
	
	/* 🎯 버튼 비활성화 */
	.seat_choice:disabled {
	    background-color: #333;
	    color: #909090;
	    border-color: #A8A8A8;
	}
	form {
		width: 60%;
	}
</style>
</head>
<body onload="init()">
	<div class="first_box">
		<div class="second_box">
			<div class="title_container">
		        <div class="movie_title">영화</div>
		        <div id="movie_button_container">
		            <c:forEach items="${ dailyResult.boxOfficeResult.dailyBoxOfficeList }" var="boxOffice">
		                <div class="movie_button" data-movieCd="${ boxOffice.movieCd }">
		                    ${ boxOffice.movieNm }
		                </div>
		            </c:forEach>
		        </div>
		    </div>
		
		    <div class="title_container">
		        <div class="date_title">날짜</div>
		        <div id="date_button_container">
		            <c:forEach items="${ daysInMonth }" var="day">
		                <div class="date_button">${ day }</div>
		            </c:forEach>
		        </div>
		    </div>
		
		    <div class="title_container">
		        <div class="time_title">시간</div>
		        <div id="time_button_container">
		            <div id="time_list"></div>
		        </div>
		    </div>
		</div>
		<form id="bookingForm" action="seatBooking" method="get" onsubmit="return validateInputs();">
			<div class="seat_container">
				<div id="movie_section">
					<label id="movie_label" for="movie">영화선택</label>
					<input type="hidden" id="movie" name="movie" value="${ movie }">
					<input type="hidden" id="movieCd" name="movieCd" value="${ movieCd }">
				</div>
				<div id="date_section">
					<label id="date_label" for="date">날짜선택</label>
					<input type="hidden" id="date" name="date" value="${ date }">
				</div>
				<div id="time_section">
					<label id="time_label" for="time">시간선택</label>
					<input type="hidden" id="time" name="time" value="${ time }">
				</div>
				<div id="seat_section">
					<button type="submit" class="seat_choice" disabled>좌석선택</button>
				</div>
			</div>
		</form>
	</div>
</body>
<script type="text/javascript">
	let movieInput, movieCdInput, dateInput, timeInput;
	let dateLabel;
	
	document.addEventListener("DOMContentLoaded", function() {
	    init();
	});
	function init() {
		const movieLabel = document.getElementById("movie_label");
		dateLabel = document.getElementById("date_label");
		const timeLabel = document.getElementById("time_label");
		const timeList = document.getElementById("time_list");
		let showtimeId;
		
	    document.querySelectorAll(".movie_button").forEach(button => {
	        button.addEventListener("click", function(){
	            const movieName = this.textContent.trim();
	            const movieCd = this.getAttribute("data-movieCd");
	 
	            if( !movieInput ) {
	            	movieInput = document.createElement("input");
	            	movieInput.type = "hidden";
	            	movieInput.id = "movie";
	            	movieInput.name = "movie";
	            	document.getElementById("seat_section").appendChild(movieInput);
	            }
	            
	            if( !movieCdInput ) {
	            	movieCdInput = document.createElement("input");
	            	movieCdInput.type = "hidden";
	            	movieCdInput.id = "movieCd";
	            	movieCdInput.name = "movieCd";
	            	document.getElementById("seat_section").appendChild(movieCdInput);
	            }
	            
	            movieCdInput.value = movieCd;
	            movieInput.value = movieName;
	            
	            if( dateInput ) {
	                dateInput.value = "";
	            }
	            if( timeInput ) {
	                timeInput.value = "";
	            }
	            if( dateLabel ) {
	                dateLabel.textContent = "날짜선택";
	            }
	            if( timeLabel ) {
	                timeLabel.textContent = "시간선택";
	            }
	            timeList.innerHTML = "";
	
	            validateButtonState();
	            
	            fetch("/movie/booking/updateMovie", {
	                method: "POST",
	                headers: { "Content-Type": "application/json" },
	                body: JSON.stringify({ movieName: movieName, movieCd: movieCd })
	            })
	            .then( response => response.json() )
	            .then( data => {
	                document.getElementById("movie_section").innerHTML =
	                    '<img src="' + data.moviePoster + '" alt="' + data.movieName + '" style="width:200px;" />' +
	                    '<h3>' + data.movieName + '</h3>';
	                document.getElementById("date_section").innerHTML = "날짜선택";
	            });
	            
	        });
	    });
	
	    document.querySelectorAll(".date_button").forEach(button => {
	        button.addEventListener("click", function() {
	            const selectedDay = this.textContent.trim();
	            const now = new Date();
	            const year = now.getFullYear();
	            const month = now.getMonth() + 1;
	            const formattedMonth = month < 10 ? "0" + month : month;
	            const formattedDay = String(selectedDay).padStart(2, "0");
	            const fullDate = year + "-" + formattedMonth + "-" + formattedDay;
	            
	            if( timeLabel ){
	            	timeLabel.textContent = "시간선택";
	            }
	            timeList.innerHTML = "";
	            
				if( dateLabel ) {
					dateLabel.textContent = fullDate;
				} else {
					dateLabel = document.createElement("div");
	                dateLabel.id = "date_label";
	                dateLabel.textContent = fullDate;
	                document.getElementById("seat_section").appendChild(dateLabel);
				}
				if( !dateInput ) {
					dateInput = document.createElement("input");
					dateInput.type = "hidden";
					dateInput.id = "date";
					dateInput.name = "date";
					document.getElementById("seat_section").appendChild(dateInput);
				}
				dateInput.value = fullDate;
	            validateButtonState();
				
	            fetch("/movie/booking/updateDate", {
	                method: "POST",
	                headers: { "Content-Type": "application/json" },
	                body: JSON.stringify({ fullDate })
	            })
	            .then( response => response.json() )
	            .then( data => {
	                document.getElementById("date_section").textContent = fullDate;
	                const movieName = document.getElementById("movie_section").textContent.trim();
	                if( movieName ) {
	                	const encodedMovieName = encodeURIComponent( movieName );
	                	const encodedSelectedDate = encodeURIComponent( fullDate );
	                	
	                	fetch("/movie/booking/getMovieShowTime?movieName=" + encodedMovieName + "&date=" + encodedSelectedDate)
	                	.then( response => response.json() )
	                	.then( showTimes => {
	                		const timeList = document.getElementById("time_list");
	                		timeList.innerHTML = "";
	                		
	                		showTimes.forEach( time => {
	               		        if (time.movieShowTime) {
	               	                const showtimeId = time.showtimeId;
	               	                const trimmedTime = String(time.movieShowTime).substring(0, 5);

	               	                const timeElement = document.createElement("div");
	               	                timeElement.textContent = trimmedTime;
	               	                timeElement.classList.add("time_button");
	               	                timeElement.dataset.showtimeId = showtimeId;
	               	                timeList.appendChild(timeElement);
	               	            } else {
	               	                console.error("movieShowTime 값이 없습니다:", time);
	               	            }
	                		});
	                		
	                		document.querySelectorAll(".time_button").forEach(timeButton => {
	                			timeButton.addEventListener("click", function() {
	                				const selectedTime = this.textContent.trim();
	                				const selectedShowtimeId = this.dataset.showtimeId;
	                				
	                				if(timeLabel) {
	                					timeLabel.textContent = selectedTime;
	                				}
	                                
	                                if (!timeInput) {
	                                    timeInput = document.createElement("input");
	                                    timeInput.type = "hidden";
	                                    timeInput.id = "time";
	                                    timeInput.name = "time";
	                                    document.getElementById("seat_section").appendChild(timeInput);
	                                }
	                                
	                                timeInput.value = selectedTime;
	                                
	                                let showtimeInput = document.getElementById("showtimeId");
	                                if( !showtimeInput ) {
	                                	showtimeInput = document.createElement("input");
	                                	showtimeInput.type = "hidden";
	                                	showtimeInput.id = "showtimeId";
	                                	showtimeInput.name = "showtimeId";
	                                	document.getElementById("seat_section").appendChild(showtimeInput);
	                                }
	                                showtimeInput.value = selectedShowtimeId;
	                                validateButtonState();
	                                
	                			});
	                		});
	                	} )
	                	.catch(error => console.error("시간 목록 불러오기 실패 : ", error));
	                } else {
	                	alert("영화를 먼저 선택하세요");
	                }
	            });
	        });
	    });
	    
	    function validateButtonState() {
	    	const movie = movieInput?.value.trim();
	    	const movieCdInput = document.getElementById("movieCd");
	        const movieCd = movieCdInput?.value.trim();
	    	const date = dateInput?.value.trim();
	    	const time = timeInput?.value.trim();
	    	const showtimeIdInput = document.getElementById("showtimeId");
	    	const showtimeId = showtimeIdInput?.value.trim();
			
	    	const seatButton = document.querySelector(".seat_choice");
	    	
	    	if( !movie || !movieCd || !date || !time || !showtimeId ) {
	    		seatButton.disabled = true;
	    	} else {
	    		seatButton.disabled = false;	
	    	}
	    }
	
	    const seatButton = document.querySelector(".seat_choice");
	    seatButton.addEventListener("click", function (event) {
	    	event.preventDefault();
	    	
	    	fetch("/movie/member/isLoggedIn", { method : "GET", credentials : "include" })
	    	.then(response => response.json())
	    	.then(data => {
	    		if( !data.isLoggedIn ) {
	    			alert("로그인 후 이용해주세요");
	    			window.location.href = "/movie/member/login";
	    		} else {
	    			document.getElementById("bookingForm").submit();
	    		}
	    	})
	    	.catch(error => console.error("로그인 확인 중 오류 발생 : ", error));
	    });  
	}
</script>
</html>