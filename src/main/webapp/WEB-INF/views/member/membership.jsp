<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../default/header.jsp" %>
<style>
	.membership_box{
		width: 700px;
		height: 700px;
		margin: 50px auto;
		padding-top: 1px;
		background-color: #f9f9f9;
		border-radius: 10px;
		box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
		position: relative;
	}
	.form-group{
		display: flex;
		justify-content: center;
		align-items: center;
		margin-top: 20px;
	}
	.form-group.name-group{
		margin-top: 100px;
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
		margin-top: 30px;
	}
	.form-button input[type="submit"],
	.form-button button{
		width: 110px; height: 50px;
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
	<div class="membership_box">
		<form action="register" method="post" id="registerForm">
			<div class="form-group name-group">
				<label for="name" class="form-label">이름</label>
				<input type="text" name="name" class="form-input" placeholder="이름" required>
			</div>
			<div class="form-group">
				<label for="mobile" class="form-label">전화번호</label>
				<input type="text" name="mobile" class="form-input" placeholder="전화번호" required>
			</div>
			<div class="form-group">
				<label for="id" class="form-label">아이디</label>
				<input type="text" name="id" class="form-input" placeholder="아이디" required>
				<button type="button" onclick="idCheck()">중복확인</button>
			</div>
			<div class="form-group">
				<label for="pwd" class="form-label">비밀번호</label>
				<input type="password" name="pwd" class="form-input" placeholder="비밀번호" required>
			</div>
			<div class="form-group">
				<label for="email" class="form-label">이메일</label>
				<input type="text" name="email" class="form-input" placeholder="이메일" required>
			</div>
			<div class="form-group">
				<label for="addr1" class="form-label">주소1</label>
				<div class="form-group">
					<input type="text" id="addr1" name="addr1" class="form-input addr1 readonly" placeholder="주소1" readonly>
					<button type="button" class="postBtn" onclick="daumPost()">우편번호 찾기</button>
				</div>
				
			</div>
			<div class="form-group">
				<label for="addr2" class="form-label">주소2</label>
				<input type="text" id="addr2" name="addr2" class="form-input readonly" placeholder="주소2" readonly required>
			</div>
			<div class="form-group">
				<label for="addr3" class="form-label">주소3</label>
				<input type="text" id="addr3" name="addr3" class="form-input" placeholder="주소3" required>
			</div>
			<div class="form-group form-button">
				<input type="submit" value="완료">
				<button type="button" onclick="history.back()">취소</button>
			</div>
		</form>
	</div>
</body>
<script type="text/javascript">
	let isIdChecked = false;

	function idCheck() {
		const id = document.querySelector("input[name='id']").value;
		
		if( id === "" ) {
			alert("아이디를 입력해주세요");
			return;
		}
		
		fetch("/movie/member/idCheck?id=" + id)
			.then(response => response.text())
			.then(result => {
				console.log("result : ", result);
				if( parseInt(result) === 1 ) {
					alert("이미 사용중인 아이디입니다. 다른 아이디를 입력해주세요.");
					isIdChecked = false;
				} else {
					alert("사용 가능한 아이디입니다.");
					isIdChecked = true;
				}
			})
			.catch(error => {
				console.log("에러 발생", error);
			});
	}
	
	document.getElementById("registerForm").addEventListener("submit", function(event) {
		if( !isIdChecked ) {
			alert("아이디 중복확인을 해주세요");
			event.preventDefault();
		}
	});
</script>
</html>