<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.modify_container {
		display: flex;
		justify-content: center;
		align-items: flex-start;
		height: auto;
		padding: 20px;
	}
	
	.modify_table {
		border: 1px solid black;
		width: 100%;
		max-width: 1500px;
		background-color: #fff;
		border-collapse: collapse;
		margin-top: 20px;
	}
	
	.modify_table th, .modify_table td {
		border: 1px solid #ccc;
		padding: 8px;
		text-align: center;
		font-size: 14px;
	}
	
	.modify_table th {
		background-color: #f8f8f8;
		font-weight: bold;
	}
	
	.col-1 { width: 75px; }
	.col-2 { width: 50px; }
	.col-3 { width: 125px; }
	.col-4 { width: 150px; }
	.col-5 { width: 100px; }
	.col-6 { width: 300px; }
	
	button[type="button"],
	button[type="submit"] {
		display: inline-flex;
	    align-items: center;
	    justify-content: center;
	    border: 1px solid #585858;
	    background-color: transparent;
	    color: #585858;
	    border-radius: 0.25rem;
	    height: 45px;
	    width: 100px;
	    padding: 0 10px;
	    font-size: 14px;
	}

	button[type="button"]:hover,
	button[type="submit"]:hover {
	    background-color: #585858;
	    color: white;
	}
	
	.form-input {
		width: 95%;
		height: 30px;
		padding: 4px;
		font-size: 14px;
	}
	.form-content {
		width: 95%;
		height: 200px;
		padding: 8px;
		font-size: 14px;
		resize: none;
	}
</style>
</head>
<body>
	<div class="modify_container">
		<form action="reviewModify" method="post">
			<input type="hidden" name="review_no" value="${ dto.review_no }"> 
			<table class="modify_table">
				<colgroup>
					<col class="col-1">
					<col class="col-2">
					<col class="col-3">
					<col class="col-4">
					<col class="col-5">
					<col class="col-6">
				</colgroup>
				<tr>
					<th>글번호</th><td>${ dto.review_no }</td>
					<th>작성자 아이디</th><td>${ dto.id }</td>
					<th>카테고리</th><td>${ dto.category }</td>
				</tr>
				<tr>
					<th>제목</th>
					<td colspan="5">
						<input type="text" name="title" class="form-input" value="${ dto.title }">
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="5">
						<textarea name="content" class="form-content">${ dto.content }</textarea>
					</td>
				</tr>
				<tr>
					<td colspan="6">
						<div class="form-submit">
							<button type="submit">수정</button>
							<button type="button" onclick="history.back()">이전</button>
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>