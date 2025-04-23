<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.container {
	    width: 60%;
	    max-width: 700px;
	    background: #fff;
	    padding: 20px;
	    border-radius: 10px;
	    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	    text-align: center;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: center;
	    margin: 50px auto;
	}

	.movie-poster {
	    max-width: 100%;
	    border-radius: 8px;
	    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	}
	
	.movie-title {
	    font-size: 27px;
	    font-weight: bold;
	    color: #222;
	    margin-top: 15px;
	    border-bottom: 2px solid #444;
	    display: inline-block;
	    padding-bottom: 5px;
	}
	
	.movie-info {
	    margin-top: 20px;
	    font-size: 18px;
	    line-height: 1.6;
	}
	
	.movie-info p {
	    margin: 10px 0;
	}
	
	.movie-info span {
		color: #444;
	    font-weight: bold;
	}
	
</style>
</head>
<body>
    <div class="container">
        <h1 class="movie-title">${ movieInfo.movieNm } 상세 정보</h1>
        <p>
            <img src="${ posterUrl }" alt="${ movieInfo.movieNm } 포스터" class="movie-poster">
        </p>
        <div class="movie-info">
            <p><span>감독 :</span> 
                <c:forEach var="director" items="${ movieInfo.directors }">
                    ${ director.peopleNm }
                </c:forEach>
            </p>
            <p><span>배우 :</span>
                <c:forEach var="actor" items="${ movieInfo.actors }">
                    ${ actor.peopleNm }
                </c:forEach>
            </p>
            <p><span>개봉일 :</span> ${ movieInfo.openDt }</p>
            <p><span>장르 :</span> 
                <c:forEach var="genre" items="${ movieInfo.genres }">
                    ${ genre.genreNm }
                </c:forEach>
            </p>
        </div>
    </div>
    <div style="height: 30px;"></div>
</body>
</html>