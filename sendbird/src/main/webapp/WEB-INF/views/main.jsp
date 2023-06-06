<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	#msgArea{
		border: 1px solid black;
		width: 80%;
		height: 100px;	
	}
</style>
</head>
<body>
	<%@ include file="./home.jsp" %>
	<h2>${user.mem_name}님 환영합니다!</h2>
	<div>
		알림
		<span id="bell">1</span>
	</div>
	<h3>공개채팅방</h3>
	<div id="msgArea"></div>
	
	<div class="whll">
		<input type="text" id="msg" placeholder="보낼 메시지 입력" class="form-control">
		<button id="btnSend" class="btn btn-primary">Send Message</button>
	</div>
	
</body>
</html>