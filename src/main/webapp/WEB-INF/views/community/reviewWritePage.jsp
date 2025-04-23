<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.writeFormCs {
		display: flex;
		justify-content: center;
	    width: 600px;
	    height: 715px;
	    margin: 50px auto;
	    margin-top: 30px; 
	    padding: 20px;
	    padding-top: 50px;
	    background: #f9f9f9;
	    border-radius: 10px;
	    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
	}
	
	.form-group {
	    margin-bottom: 15px;
	}
	
	.form-label {
	    font-weight: bold;
	    display: block;
	    margin-bottom: 5px;
	}
	
	.form-control {
	    width: 420px;
	    padding: 10px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    font-size: 14px;
	}
	
	textarea.form-control {
	    height: 300px;
	}
	
	.form-submit-group {
	    display: flex;
	    justify-content: space-between;
	}
	
	.form-button input[type="submit"],
	.form-button button{
		width: 48%;
		padding: 20px;
		border: 1px solid black;
		border-radius: 0.5em;
		background-color: white;
		font-size: 14px;
	}
	.form-button input[type="submit"]:hover,
	.form-button button:hover{
		background-color: #E6E6E6;
	}
</style>
</head>
<body>
	<div class="box1">
		<div class="writeFormCs">
			<form action="reviewWriteForm" method="post">
				<div class="form-group">
	                <label for="id" class="form-label">작성자 아이디</label>
	                <input type="text" id="id" name="id" class="form-control" value="${ userId }" readonly>
	            </div>
	            <div class="form-group">
	                <label for="category" class="form-label">카테고리</label>
	                <select id="category" name="category" class="form-control">
	                	<c:forEach var="movie" items="${ dailyList }">
	                		<option value="${ movie.movieNm }">${ movie.movieNm }</option>
	                	</c:forEach>
	                </select>
	            </div>
	            <div class="form-group">
	                <label for="title" class="form-label">제목</label>
	                <input type="text" id="title" name="title" class="form-control" placeholder="제목">
	            </div>
	            <div class="form-group">
	                <label for="content" class="form-label">내용</label>
	                <textarea id="content" name="content" class="form-control" aria-label="With textarea"  placeholder="내용"></textarea>
	            </div>
	            <div class="form-group form-button">
	                <button type="submit">등록</button>
	                <button type="button" onclick="history.back()">취소</button>
	            </div>
			</form>
		</div>
	</div>
</body>
</html>