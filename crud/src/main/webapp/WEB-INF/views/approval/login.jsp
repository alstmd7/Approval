<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style type="text/css">
	#loginArea{
		display: flex;
		text-align: center;
		width: 500px;
		flex-direction: column;
    	align-items: center;
    	margin: 100px auto;
    	border: 1px solid black;
    	padding: 20px;
	}
	.labels{
		width: 80px;
	}
	.rowCol{
		display: flex;
		text-align: left;
		margin: 10px 0;
	}
	.title{
		font-size: 25px;
    	font-weight: bold;
	}
</style>
<script type="text/javascript">
	$(function() {
		$("#loginBtn").click(function(e){
		      var getCheck= /^[A-Za-z0-9][A-Za-z0-9]*$/;
		      //아이디 공백 확인
		      if($("#memId").val() == ""){
		        alert("아이디 입력바람");
		        $("#memId").focus();
		        return false;
		      }
		      //아이디 유효성검사
		      if(!getCheck.test($("#memId").val())){
		        alert("형식에 맞게 입력해주세요");
		        $("#memId").focus();
		        return false;
		      }
		      //비밀번호 공백 확인
		      if($("#memPw").val() == ""){
		        alert("패스워드 입력바람");
		        $("#memPw").focus();
		        return false;
		      }
		      //비밀번호 유효성검사
		      if(!getCheck.test($("#memPw").val())){
		        alert("형식에 맞게 입력해주세요");
		        $("#memPw").focus();
		        return false;
		      }
		      $.ajax({
		            url: "login/check",
		            type: "post",	
		            data: $("#loginForm").serialize(),
		            success: function(data){
		            	if(data == "success"){
		            		location.href="main";
		            	} else if(data == "idFail"){
		            		alert("등록되지 않은 사용자입니다.");
		            	} else if(data == "pwFail"){
		            		alert("비밀번호가 일치하지 않습니다.");
		            	}
		            },
		            error: function(data){
		                alert(data);
		            }
		        });
		});
		
		$('#loginForm').on('keypress', function(e){
			if(e.keyCode == '13'){
				$('#loginBtn').click();
			}
		});
	});
</script>
<title>Insert title here</title>
</head>
<body>
	<div id="loginArea">
		<form id="loginForm">
			<div class="title">Login</div>
			<br>
			<div class="rowCol">
				<div class="labels">
					<label for="memId" >아이디 : </label>
				</div>
				<input type="text" name="memId" id="memId" placeholder="아이디를 입력하세요">
			</div>
			<div class="rowCol">
				<div class="labels">
					<label for="memPw" class="labels">비밀번호 : </label>
				</div>
				<input type="password" name="memPw" id="memPw" placeholder="비밀번호를 입력하세요">
			</div>
		</form>
		<br>
		<button id="loginBtn">로그인</button>
	</div>
</body>
</html>