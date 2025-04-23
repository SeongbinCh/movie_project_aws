<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.page-container {
        display: flex;
        justify-content: flex-start;
    }

	.menu{
		margin: 15px;
		width: 250px;
		height: 400px;
		border: 2px solid black;
		flex-shrink: 0;
	}
	
	.user_menu {
		display: flex;
		flex-direction: column;
		width: 100%;
		text-align: center;
		margin-top: 10px;
		gap: 5px;
	}
	
	.user_menu a,
	.menu > a {
		display: flex;
		justify-content: center;
		align-items: center;
		height: 50px;
		border-bottom: 1px solid #ccc;
	}
	
	.user_menu a:hover,
	.menu > a:hover  {
		color: black;
		background-color: #ddd;
	}
	
	.modify-box {
		width: 775px;
	    height: 600px;
	    margin: 20px auto;
	    padding-top: 100px;
	    background-color: #f9f9f9;
	    border-radius: 10px;
	    box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
	}
	
	.form-group{
		display: flex;
		justify-content: center;
		align-items: center;
		margin-top: 20px;
	}
	.form-group.name-group{
		margin-top: 75px;
	}
	.form-label{
		display: inline-block;
		text-align: left;
		width: 150px;
	}
	.form-input{
		border: 1px solid #ccc;
		border-radius: 0.5em;
		width: 250px; height: 30px;
	}
	.form-button{
		display: flex;
		justify-content: center;
		margin-top: 40px;
		gap: 20px;
	}
	.form-button input[type="submit"],
	.form-button button{
		width: 120px; height: 50px;
		margin-right: 20px;
		border: 1px solid black;
		border-radius: 0.5em;
		background-color: white;
	}
	.form-button input[type="submit"]:hover,
	.form-button button:hover{
		background-color: #E6E6E6;
	}
	.postBtn{
		height: 33px;
		line-height: 30px;
		margin-left: 20px;
	}
	.addr1{
		width: 130px;
	}
	.readonly{
		border: 1px solid #ccc;
		border-radius: 0.5em;
		background-color: #f0f0f0;
	}
</style>
</head>
<body>
	<div class="page-container">
		<div class="menu">
			<c:if test="${ isUser }">
				<div class="user_menu">
					<a href="${ contextPath }/member/mypageModifyView">내 정보 수정</a>
					<a href="${ contextPath }/member/bookingHistoryView">영화 예매 내역</a>
					<a href="${ contextPath }/member/postListView">등록한 게시글</a>
					<a href="${ contextPath }/member/memberDelete">회원탈퇴</a>
				</div>
			</c:if>
			<c:if test="${ isAdmin }">
				<a href="${ contextPath }/boxOffice/registerMovie">영화 정보 등록</a>
			</c:if>
		</div>
	
		<div class="modify-box">
			<form action="${ contextPath }/member/updateMemberInfo" method="post">
				<div class="modify-container">
					<div class="form-group">
						<label for="name" class="form-label">이름</label>
						<input type="text" id="name" name="name" class="form-input" value="${ memberInfo.name }" readonly>
					</div>
					<div class="form-group">
						<label for="name" class="form-label">전화번호</label>
						<input type="text" id="mobile" name="mobile" class="form-input" value="${ memberInfo.mobile }">
					</div>
					<div class="form-group">
						<label for="name" class="form-label">이메일</label>
						<input type="text" id="email" name="email" class="form-input" value="${ memberInfo.email }">
					</div>
					<div class="form-group">
						<label for="addr1" class="form-label">주소1</label>
						<div class="form-group">
							<input type="text" id="addr1" name="addr1" class="form-input addr1 readonly" value="${ memberInfo.addr1 }" readonly>
							<button type="button" class="postBtn" onclick="daumPost()">우편번호 찾기</button>
						</div>
					</div>
					<div class="form-group">
						<label for="addr2" class="form-label">주소2</label>
						<input type="text" id="addr2" name="addr2" class="form-input readonly" value="${ memberInfo.addr2 }" readonly>
					</div>
					<div class="form-group">
						<label for="addr3" class="form-label">주소3</label>
						<input type="text" id="addr3" name="addr3" class="form-input" value="${ memberInfo.addr3 }">
					</div>
					<div class="form-group form-button">
						<input type="submit" value="완료">
						<button type="button" onclick="history.back()">취소</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
</html>