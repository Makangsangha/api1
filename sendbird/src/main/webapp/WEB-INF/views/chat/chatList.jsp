<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>${user.mem_name }님 안녕하세요!</h2>
	<input type="hidden" id="mem_id" value="${user.mem_id }">
	<input type="hidden" id="mem_name" value="${user.mem_name }">
	<button id="insertChatRoom">채팅방 개설하기</button>
		<form id="insertForm"  action="/setChatRoom"  method="post"  style="display: none">
			<table border="1">
				<tr>
					<th>
						채팅방이름
					</th>
					<td>
						<input required type="text" id="cr_name" name="cr_name">
					</td>
				</tr>
				<tr>
					<th>
						채팅방 비밀번호(비밀번호를 입력하지 않으면 공개방이 됩니다.)
					</th>
					<td>
						<input type="text" id="cr_pw" name="cr_pw">
					</td>
				</tr>
				<tr>
					<th>
						채팅방 소개글
					</th>
					<td>
						<textarea required id="cr_content"  name="cr_content" rows="10" cols="10">
						</textarea>
					</td>
				</tr>
				<tr>
					<th>
						채팅방 최대 인원 (최대 10명)
					</th>
					<td>
						<input type="number" name="cr_max_user" max="10" min="2">
					</td>
				</tr>
			</table>
			<input type="button" id="chatBtn" value="만들기">
			<input type="button" id="hidBtn" value="취소">
		</form>
	<p>채팅방 목록</p>
	<div id="chatList"></div>
</body>
<script type="text/javascript">
	$(function(){
		var insertChatRoom = $("#insertChatRoom");
		var chatBtn = $("#chatBtn");
		var hidBtn = $("#hidBtn");
		var insertForm = $("#insertForm");
		var chatBtn2 = $("#chatBtn2");
		
		insertChatRoom.on('click', function(){
			insertForm.css("display", "block");	
		})
		
		chatBtn.on('click', function(){
			var insertForm = $("#insertForm");
			var cr_name = $("#cr_name").val();
			var cr_content = $("#cr_content").val();
			
			
			if(cr_name == null || cr_name.trim() == ""){
				alert("제목을 입력해주세요!");
				return false;
			}
			if(cr_content == null || cr_content.trim() == ""){
				alert("간단한 소개를 작성해주세요!");
				return false;
			}
	
			insertForm.css("display", "none");
			insertForm.submit();
			
			$("#cr_name").val("");
			$("#cr_content").val("");
			$("#cr_max_user").val("");
			$("#cr_pw").val("");	
		})
		
		hidBtn.on("click", function(){	
			insertForm.css("display", "none");
		})
	 
		$.ajax({
			type : "get",
			url : "/chatRoomList",
			contentType : "application/json; charset=utf-8",
			success : function(res){
				console.log(res)
				re = "<table border='1'>";
				$.each(res, function(index, item){
					re += "<tr><td>방 제목</td><td>"+ item.cr_name + "</td></tr>"
					re += "<tr><td>방 비밀번호 입력</td><td><input type='text' id='"+ item.cr_no+"'/></td></tr>"
					re += "<tr><td>방 소개</td><td>"+ item.cr_content + "</td></tr>"
					re += "<tr><td>방 참여 가능인원</td><td>"+ item.cr_max_user + "</td></tr>"
					re += "<tr><td>방 현재 참여인원</td><td>"+ item.cr_cnt_user + "</td></tr>"
					re += "<tr><td>지금 접속 중인 인원</td><td>"+ item.cr_online_user + "</td></tr>"
					re += "<tr><td colspan='2'><input type='button' id='chatBtn2' value='방 참여하기' data-no='"+item.cr_no+"''></td></tr>";
				});
				re +="</table>"
				
				$("#chatList").html(re);
			}
		})

		
		$(document).on('click', '#chatBtn2', function(){
			var no = $(this).data("no");
			var pw = $("[id='" + no + "']").val();

			$.ajax({
				type : "get",
				url : "/chatCheck",
				data : {
					"cr_no" : no,
					"cr_pw" : pw
				},
				contentType : "application/json; charset=utf-8",
				success : function(res){
					if(res.message!="OK"){
						alert(res.message)
						return false;
					}else{
						if(confirm("채팅방에 접속하시겠습니까?")){
							inputChat(no);
						}else{
							return false;
						}
					}
				}
			})
		})
		

	})
	

	function inputChat(no){
		var mem_id = $("#mem_id").val();
		var mem_name = $("#mem_name").val();
		alert("mem_id : " + mem_id +", mem_name :" + mem_name + ", no : " + no);
		$.ajax({
			type : "get",
			url : "/insertChat",
			data : {
				"cr_no" : no,
				"mem_id" : mem_id,
				"mem_nick" : mem_name
			},
			contentType : "application/json; charset=utf-8",
			success : function(res){
				alert(res.message)
				if(res.message == 'OK'){
					location.href = "/goChat?no="+no				
				}else{
					return false;
				}
			}
		})
	}
</script>
</html>