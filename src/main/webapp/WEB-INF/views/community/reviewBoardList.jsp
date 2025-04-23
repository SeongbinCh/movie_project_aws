<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.review_container {
		display: flex;
	    justify-content: center; /* 가로 중앙 정렬 */
	    margin-top: 100px;
	}
	.review_table {
		border: 1px solid black;
	    width: 100%;
	    max-width: 1200px;
	    background-color: #fff;
	    border-collapse: collapse;
	}
	
	.table_tr:hover {
	    background-color: #f4f4f4;
	}
	
	.review_table th, .review_table td {
		border: 1px solid #ccc;
		padding: 10px;
		text-align: center;
	}
	
	.review_table th {
		background-color: #f8f8f8;
	    font-weight: bold;
	}
	
	.col-1 { width: 112px; }
	.col-2 { width: 400px; }
	.col-3 { width: 200px; }
	.col-4 { width: 125px; }
	.col-5 { width: 150px; }
	.col-6 { width: 90px; }
	.col-7 { width: 75px; }
	
	.pagination-wrapper {
		display: flex;
		justify-content: center;
		width: 100%;
	}
	
	.pagination {
		display: flex;
		justify-content: center;
		align-items: center;
	}
</style>
</head>
<body>
	<div class="review_container">
		<table class="review_table">
			<colgroup>
				<col class="col-1">
				<col class="col-2">
				<col class="col-3">
				<col class="col-4">
				<col class="col-5">
				<col class="col-6">
				<col class="col-7">
			</colgroup>
			
			<thead>
				<tr>
					<th>게시글 번호</th><th>카테고리</th><th>제목</th><th>작성자 아이디</th><th>날짜</th><th>시간</th><th>조회수</th>
				</tr>
			</thead>
			
			<tbody>
				<c:if test="${ empty list }">
					<tr>
						<th colspan="7"> 작성된 글이 없습니다.</th>
					</tr>
				</c:if>
				
				<c:forEach var="dto" items="${ list }">
					<tr class="table_tr">
						<td>${ dto.review_no }</td>
						<td>${ dto.category }</td>
						<td>
							<a href="reviewContentPage?review_no=${ dto.review_no }">
								${ dto.title }
							</a>
						</td>
						<td>${ dto.id }</td>
						<td>${ dto.review_date }</td>
						<td>${ dto.review_time }</td>
						<td>${ dto.hit }</td>
					</tr>
				</c:forEach>
				
				<tr>
					<c:if test="${ not empty userId }">
						<td colspan="7" style="text-align: right; padding-right: 20px;">
							<a href="reviewWritePage">글 작성</a>
						</td>
					</c:if>
				</tr>
			
				<tr>
					<td colspan="7">
						<div class="pagination-wrapper">
							<nav aria-label="Page navigation example">
								<ul class="pagination">
									<!-- 이전 페이지 버튼 -->
									<c:choose>
										<c:when test="${ currentPage > 1 }">
											<li class="page-item">
												<a class="page-link" href="reviewBoardList?num=${ currentPage - 1 }" aria-label="Previous">
													<span aria-hidden="true">&laquo;</span>
												</a>
											</li>
										</c:when>
										<c:otherwise>
											<li class="page-item disabled">
												<span class="page-link" aria-label="Previous">
													<span aria-hidden="true">&laquo;</span>
												</span>
											</li>
										</c:otherwise>
									</c:choose>
									
									<!-- 페이지 번호 버튼 -->
									<c:forEach var="i" begin="1" end="${ repeat }">
										<li class="page-item ${ i == currentPage ? 'active' : '' }">
											<a class="page-link" href="reviewBoardList?num=${ i }">${ i }</a>
										</li>
									</c:forEach>
									
									<!-- 다음 페이지 버튼 -->
                                    <c:choose>
                                        <c:when test="${ currentPage < repeat }">
                                            <li class="page-item">
                                                <a class="page-link" href="reviewBoardList?num=${ currentPage + 1 }" aria-label="Next">
                                                    <span aria-hidden="true">&raquo;</span>
                                                </a>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item disabled">
                                                <span class="page-link" aria-label="Next">
                                                    <span aria-hidden="true">&raquo;</span>
                                                </span>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
								</ul>
							</nav>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>