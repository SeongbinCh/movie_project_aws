<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.table_box {
		display: flex;
		justify-content: center;
		align-items: flex-start;
		padding-top: 50px;
		
	}

	table {
	    width: 90%;
	    border-collapse: collapse;
	    margin-top: 20px;
	    background-color: #fff;
	    border-radius: 8px;
	    overflow: hidden;
	    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
	    border: 2px solid #ccc;
	}

	th, td {
	    padding: 12px;
	    text-align: center;
	}
	
	th {
	    background-color: #222;
	    color: white;
	    font-weight: bold;
	}
	
	td {
	    border-bottom: 1px solid #ddd;
	}
	
	.table_tr:hover {
	    background-color: #f4f4f4;
	}
	
	td a {
	    text-decoration: none;
	    font-weight: bold;
	}
	
	td a:hover {
	    text-decoration: underline;
	}
	
	td[colspan="4"] {
	    text-align: center;
	    font-size: 16px;
	    font-weight: bold;
	    color: #555;
	    padding: 20px;
	}
</style>
</head>
<body>
<div class="table_box">
	<table border="1">
		<tr>
			<td>순위</td>
			<td>영화명</td>
			<td>개봉일</td>
			<td>누적관객수</td>
		</tr>
	<c:if test="${ not empty weeklyResult.boxOfficeResult.weeklyBoxOfficeList }">
	<c:forEach items="${ weeklyResult.boxOfficeResult.weeklyBoxOfficeList }" var="boxOffice">
		<tr class="table_tr">
			<td><c:out value="${ boxOffice.rank }" /></td>
			<td>
				<a href="${ contextPath }/boxOffice/searchMovieInfo?movieName=${ boxOffice.movieNm }">
					<c:out value="${ boxOffice.movieNm }" />
				</a>
			</td>
			<td><c:out value="${ boxOffice.openDt }" /></td>
			<td><c:out value="${ boxOffice.audiAcc }" /></td>
		</tr>
	</c:forEach>
	</c:if>
	<c:if test="${ empty weeklyResult.boxOfficeResult.weeklyBoxOfficeList }">
		<tr>
			<td colspan="4">조회된 결과가 없습니다.</td>
		</tr>
	</c:if>
	</table>
</div>
</body>
</html>