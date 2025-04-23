<%@page import="java.util.HashMap"%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@page import="kr.or.kobis.kobisopenapi.consumer.rest.KobisOpenAPIRestService"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
</head>
<style type="text/css">
	.table_box {
		display: flex;
		justify-content: center;  /* 가로 중앙 */
		align-items: center;      /* 세로 중앙 */
		padding-top: 75px;         /* 화면 전체 높이 */
	}

	table {
	    width: 90%;
	    border-collapse: collapse;
	    margin: 0 auto;
	    background-color: #fff;
	    border-radius: 8px;
	    overflow: hidden;
	    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
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
<body>
<div class="table_box">
	<table border="1">
		<tr>
			<td>순위</td>
			<td>영화명</td>
			<td>개봉일</td>
			<td>누적관객수</td>
		</tr>
	<c:if test="${ not empty dailyResult.boxOfficeResult.dailyBoxOfficeList }">
	<c:forEach items="${ dailyResult.boxOfficeResult.dailyBoxOfficeList }" var="boxOffice">
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
	<c:if test="${ empty dailyResult.boxOfficeResult.dailyBoxOfficeList }">
		<tr>
			<td colspan="4">조회된 결과가 없습니다.</td>
		</tr>
	</c:if>
	</table>
</div>
</body>
</html>