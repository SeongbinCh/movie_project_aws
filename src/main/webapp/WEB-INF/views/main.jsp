<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="default/header.jsp" %>
<style type="text/css">
	.search_input {
		display: flex;
		justify-content: center;
		margin: 30px 0 20px 0;
		width: 100%;
	}

	#searchForm {
	    display: flex;
	    width: 500px;
	    border: 1px solid #ccc;
	    border-radius: 8px;
	    background-color: #fff;
	    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
	    position: relative;
	    z-index: 1;
	}
	
	#searchInput {
	    flex: 1;
	    padding: 12px 15px;
	    border: none;
	    font-size: 16px;
	    outline: none;
	}
	
	#searchForm button {
	    padding: 12px 20px;
	    border: none;
	    background-color: #E50914;
	    color: white;
	    font-size: 16px;
	    cursor: pointer;
	    transition: background-color 0.3s;
	}
	
	#searchForm button:hover {
	    background-color: #8C060F;
	}
	
	/* 자동완성 박스도 살짝 스타일 */
	#autocompleteList {
	    position: absolute;
	    top: 100%;
	    left: 0;
	    background-color: white;
	    border: 1px solid #ccc;
	    border-top: none;
	    width: 100%;
	    max-height: 250px;
	    overflow-y: auto;
	    z-index: 1000;
	}

	#autocompleteList div {
		padding: 10px;
		cursor: pointer;
		transition: background-color 0.2s;
		color: black;
	}
	#autocompleteList div:hover {
		background-color: #f0f0f0;
	}

	.top10-movies {
		width: 90%; /* 너무 전체 꽉 채우지 않게 */
		max-width: 1500px;
		margin: 30px auto;
		background-color: #f4f4f4;
		padding: 15px 20px;
		border: 1px solid #ccc;
		border-radius: 12px;
		box-shadow: 0 8px 24px rgba(0,0,0,0.1);
	}
	
	.top10-movies h2 {
		text-align: center;
		margin-bottom: 30px;
		font-size: 24px;
	}

	.movie-container {
		width: 100%;
		overflow: hidden;
		position: relative;
	}
	
	.movie-list {
		display: flex;
		gap: 50px; /* 조금 더 넓게 */
		justify-content: center; /* 가운데 정렬 */
	}
	
	.movie-list li {
		flex: 0 0 auto;
		width: 180px;
		text-align: center;
	}
	
	.movie-list img {
		width: 100%;
		border-radius: 5px;
		transition: transform 0.3s ease;
	}
	
	.movie-list img:hover {
		transform: scale(1.1);
	}
</style>
</head>
<body>
	<div class="search_input">
			<form id="searchForm" action="${ contextPath }/boxOffice/searchMovieInfo" method="get">
				<input type="text" id="searchInput" name="movieName" placeholder="영화 제목 검색" autocomplete="off">
				<div id="autocompleteList"></div>
				<button type="submit">검색</button>
			</form>
	</div>

	<c:if test="${ not empty top10Movies }">
		<div class="top10-movies">
			<h2>인기 순위 10</h2>
			<div class="movie-container">
				<ul class="movie-list">
	            <c:forEach var="movie" items="${ top10Movies }">
	                <li>
	                    <a href="${ contextPath }/boxOffice/searchMovieInfo?movieName=${ movie.title }">
	                    	<img src="${ movie.posterUrl }" alt="Poster" />
	                    </a>
	                    <p>${ movie.title }</p>
	                </li>
	            </c:forEach>
	        </ul>
			</div>
			
		</div>
	</c:if>
	<c:if test="${ not empty mainError }">
		<div class="error">
			<p>${ mainError }</p>
		</div>
	</c:if>
</body>
<script type="text/javascript">
	const contextPath = "${pageContext.request.contextPath}";
	
	document.addEventListener("DOMContentLoaded", function() {
		const movieList = document.querySelector(".movie-list");
		const movieItems = document.querySelectorAll(".movie-list li");
		const itemWidth = movieItems[0].offsetWidth + 15;
		
		function moveMovies() {
			let firstItem = movieList.firstElementChild.cloneNode(true);
			
			movieList.style.transition = "transform 0.5s ease-in-out";
			movieList.style.transform = "translateX(-" + itemWidth + "px)";
			
			setTimeout(() => {
				movieList.appendChild(firstItem);
				movieList.removeChild(movieList.firstElementChild);
				movieList.style.transition = "none";
				movieList.style.transform = "translateX(0)";
			}, 500);
		}
		
		function startRolling() {
			interval = setInterval(moveMovies, 5000);
		}
		
		function stopRolling() {
			clearInterval(interval);
		}
		
		startRolling();
		
		movieList.addEventListener("mouseenter", stopRolling);
		movieList.addEventListener("mouseleave", startRolling);
	});
	
	document.addEventListener("DOMContentLoaded", function() {
		const input = document.getElementById("searchInput");
		const list = document.getElementById("autocompleteList");
		
		input.addEventListener("input", function() {
			const keyword = input.value;
			if( keyword.length < 2 ) {
				list.innerHTML = "";
				return;
			}
			
			const xhr = new XMLHttpRequest();
			xhr.open("GET", "/movie/boxOffice/autocomplete?query=" + encodeURIComponent(keyword), true);
			xhr.onreadystatechange = function() {
				if (xhr.readyState === 4) {
					if (xhr.status === 200) {
						const results = JSON.parse(xhr.responseText);
						console.log("자동완성 결과:", results); // ✅ 결과 확인
						list.innerHTML = "";

						results.forEach(function(title) {
							const div = document.createElement("div");
							div.textContent = title;
							div.onclick = function() {
								input.value = title;
								list.innerHTML = "";
								document.getElementById("searchForm").submit();
							};
							list.appendChild(div);
						});
					} else {
						console.error("자동완성 요청 실패. 상태코드:", xhr.status); // ✅ 에러 확인
					}
				}
			};
			xhr.send();
		});
		
		document.addEventListener("click", function(e) {
			if( !e.target.closest(".search_input") ) {
				list.innerHTML = "";
			}
		});
	});
</script>
</html>
