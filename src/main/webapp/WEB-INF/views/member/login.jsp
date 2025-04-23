<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<%@ include file="../default/header.jsp" %>
<style>
	.login_box{
		width: 650px;
		height: 450px;
		margin: 125px auto;
		padding-top: 100px;
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
	.form-group.id-group{
		margin-top: 70px;
	}
	.form-label{
		display: inline-block;
		width: 150px;
		text-align: left;
	}
	.form-input{
		width: 200px; height: 28px;
	}
	.form-button{
		display: flex;
		justify-content: center;
		margin-top: 30px;
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
	
	.kakao_login {
		display: flex;
		justify-content: center;
		margin-top: 20px;
	}
</style>
</head>
<body>
	<div class="login_box">
		<form action="login_chk" method="post">
			<div class="form-group id-group">
				<label for="id" class="form-label">아이디</label>
				<input type="text" name="id" class="form-input" placeholder="아이디">
			</div>
			<div class="form-group">
				<label for="pwd" class="form-label">비밀번호</label>
				<input type="password" name="pwd" class="form-input" placeholder="비밀번호">
			</div>
			<div id="naver_id_login"></div>
			<div class="form-group form-button">
				<input type="submit" value="로그인">
				<button type="button" onclick="history.back()">취소</button>
			</div>
		</form>
		<div class="kakao_login">
			<a id="kakao_login_btn"></a>
		</div>
	</div>
</body>
<script type="text/javascript">
	Kakao.init("0a09bc5e89fa94cf06b2541c136515c4");
	
	Kakao.Auth.createLoginButton({
		container: "#kakao_login_btn",
		redirectUri: "http://localhost:8080/movie/member/kakaoLogin",
		success: function(authObj) {
			var accessToken = authObj.access_token;
			
			fetch("/movie/member/kakaoLoginPost", {
				method: "POST",
				headers: { "Content-Type": "application/json" },
				body: JSON.stringify({ access_token: accessToken })
			})
			.then(response => response.json())
			.then(data => {
				if( data.success ) {
					window.location.href = "/main";
				} else {
					window.location.href = "/member/login";
				}
			})
			.catch(error => console.log("Error : ", error));
		},
		fail: function(err) {
			console.log(err);
		}
	});
</script>
</html>	