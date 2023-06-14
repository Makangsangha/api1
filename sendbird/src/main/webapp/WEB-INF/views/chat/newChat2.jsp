<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%-- #174. 웹채팅 jsp --%>
<meta charset="UTF-8">
<title>채팅</title>
</head>
<body>
<div class="container-fluid">
<div class="row">
<div class="col-md-10 offset-md-1">
   <div id="chatStatus"></div>
   <div class="my-3">
   - 상대방의 대화내용이 검정색으로 보이면 채팅에 참여한 모두에게 보여지는 것입니다.<br>
   - 상대방의 대화내용이 <span style="color: red;">붉은색</span>으로 보이면 나에게만 보여지는 1:1 귓속말 입니다.<br>
   - 1:1 채팅(귓속말)을 하시려면 예를 들어, 채팅시 보이는 172.30.1.45[이순신] ▶ ㅎㅎㅎ 에서 이순신을 클릭하시면 됩니다.
   </div>
   <h2>${user.mem_name }님 어서오세요</h2>
   <input type="text" id="to" placeholder="귓속말대상IP주소"/>
   <br/>
   ♡ 귓속말대상 : <span id="privateWho" style="font-weight: bold; color: red;"></span>
   <br>
   <button type="button" id="btnAllDialog" class="btn btn-secondary btn-sm">귓속말대화끊기</button>
   <br><br>
   현재접속자명단:<br/>
   <div id="connectingUserList" style=" max-height: 100px; overFlow: auto;"></div>
   
   <div id="chatMessage" style="max-height: 500px; overFlow: auto; margin: 20px 0;"></div>

   <input type="text"   id="message" class="form-control" placeholder="메시지 내용"/>
   <input type="button" id="btnSendMessage" class="btn btn-success btn-sm my-3" value="메시지보내기" />
   <input type="button" class="btn btn-danger btn-sm my-3 mx-3" onClick="javascript:location.href='/chatList'" value="채팅방나가기" />
</div>
</div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
<!--
// === !!! WebSocket 통신 프로그래밍은 HTML5 표준으로써 자바스크립트로 작성하는 것이다. !!! === //
// WebSocket(웹소켓)은 웹 서버로 소켓을 연결한 후 데이터를 주고 받을 수 있도록 만든 HTML5 표준이다.
// 그런데 이러한 WebSocket(웹소켓)은 HTTP 프로토콜로 소켓 연결을 하기 때문에 웹 브라우저가 이 기능을 지원하지 않으면 사용할 수 없다. 
/*
   >> 소켓(Socket)이란? 
  - 어떤 통신프로그램이 네트워크상에서 데이터를 송수신할 수 있도록 연결해주는 연결점으로써 
    IP Address와 port 번호의 조합으로 이루어진다. 
      또한 어떤 하나의 통신프로그램은 하나의 소켓(Socket)만을 가지는 것이 아니라 
      동일한 프로토콜, 동일한 IP Address, 동일한 port 번호를 가지는 수십개 혹은 수만 개의 소켓(Socket)을 가질 수 있다.

   =================================================================================================  
      클라이언트  소켓(Socket)                           서버  소켓(Socket)
      211.238.142.70:7942 ◎------------------------------------------◎  211.238.142.77:9090
      
           클라이언트는 서버인 211.238.142.77:9090 소켓으로 클라이언트 자신의 정보인 211.238.142.70:7942 을 
           보내어 연결을 시도하여 연결이 이루어지면 서버는 클라이언트의 소켓인 211.238.142.70:7942 으로 데이터를 보내면서 통신이 이루어진다.
    ================================================================================================== 
           
            소켓(Socket)은 데이터를 통신할 수 있도록 해주는 연결점이기 때문에 통신할 두 프로그램(Client, Server) 모두에 소켓이 생성되야 한다.

  Server는 특정 포트와 연결된 소켓(Server 소켓)을 가지고 서버 컴퓨터 상에서 동작하게 되는데, 
  이 Server는 소켓을 통해 Cilent측 소켓의 연결 요청이 있을 때까지 기다리고 있다(Listening 한다 라고도 표현함).
  Client 소켓에서 연결요청을 하면(올바른 port로 들어왔을 때) Server 소켓이 허락을 하여 통신을 할 수 있도록 연결(connection)되는 것이다.
*/
-->
      
    var chatRooms = {};
    var websocket;
      $(function() {

    	  var no = "${no}";
    	  $("#mycontent").css({ "background-color": "#cce0ff" });

    	  connectToChatRoom(no);

    	  var messageObj = {};

    	  websocket.onopen = function() {
    	    console.log('onopen');
    	    $("div#chatStatus").text('정보: 웹소켓에 연결이 성공됨');
    	    messageObj = {
    	      message: "<span style='color: red;'>${user.mem_name}</span>님이 채팅방에 입장했습니다",
    	      type: "all",
    	      to: "all"
    	    };

    	    websocket.send(JSON.stringify(messageObj));
    	  };

    	  websocket.onmessage = function(event) {
    	    console.log(event.data);
    	    if (event.data.substr(0, 1) == "「" && event.data.substr(event.data.length - 1) == "」") {
    	      $("div#connectingUserList").html(event.data);
    	    } else {
    	      $("div#chatMessage").append(event.data);
    	      $("div#chatMessage").append("<br>");
    	      $("div#chatMessage").scrollTop(9999999);
    	    }
    	  };

    	  var isOnlyOneDialog = false;

    	  $("#btnSendMessage").click(function() {
    	    if ($("#message").val() != "") {
    	      var messageVal = $("input#message").val();
    	      messageVal = messageVal.replace(/<script/gi, "&lt;script");

    	      messageObj = {
    	        message: messageVal,
    	        type: "all",
    	        to: "all",
    	      };

    	      var to = $("input#to").val();
    	      if (to != "") {
    	        messageObj.type = "one";
    	        messageObj.to = to;
    	      }

    	      websocket.send(JSON.stringify(messageObj));

    	      var now = new Date();
    	      var ampm = "오전 ";
    	      var hours = now.getHours();

    	      if (hours > 12) {
    	        hours = hours - 12;
    	        ampm = "오후 ";
    	      }

    	      if (hours == 0) {
    	        hours = 12;
    	      }
    	      if (hours == 12) {
    	        ampm = "오후";
    	      }

    	      var minutes = now.getMinutes();
    	      if (minutes < 10) {
    	        minutes = "0" + minutes;
    	      }

    	      var currentTime = ampm + hours + ":" + minutes;
    	      if (isOnlyOneDialog == false) {
    	        $("#chatMessage").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 15%; word-break: break-all;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>" + currentTime + "</div> <div style='clear: both;'>&nbsp;</div>");
    	      } else {
    	        $("div#chatMessage").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 15%; word-break: break-all; color:red;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>" + currentTime + "</div> <div style='clear: both;'>&nbsp;</div>");
    	      }
    	      $("#chatMessage").scrollTop(9999999);
    	      $("input#message").val("");
    	      $("input#message").focus();
    	    }
    	  });

    	  $("#message").keyup((event) => {
    	    if (event.keyCode == 13) {
    	      $("#btnSendMessage").click();
    	    }
    	  });

    	  $("button#btnAllDialog").hide();

    	  $(document).on("click", ".loginuserName", function() {
    	    var ip = $(this).prev().text();
    	    console.log(ip);
    	    $("input#to").val(ip);

    	    $("span#privateWho").text($(this).text());
    	    $("button#btnAllDialog").show();

    	    isOnlyOneDialog = true;
    	  });

    	  $("button#btnAllDialog").click(function() {
    	    $("input#to").val("");
    	    $("span#privateWho").text("");
    	    $(this).hide();

    	    isOnlyOneDialog = false;
    	  });
    	});
      
	  function connectToChatRoom(roomNo) {
	  	    var url = window.location.host;
	  	    var pathname = window.location.pathname;
	  	    var appCtx = pathname.substring(0, pathname.lastIndexOf("/"));
	  	    var root = url + appCtx;
	  	    var wsUrl = "ws://" + root + "/chatting";
	  	    
	  	    websocket = new WebSocket(wsUrl);

	  	    websocket.onopen = function() {
	  	      console.log("onopen");
	  	      $("div#chatStatus").text("정보: 웹소켓에 연결이 성공됨");

	  	      var messageObj = {
	  	        message: "<span style='color: red;'>${user.mem_name}</span>님이 채팅방에 입장했습니다",
	  	        type: "all",
	  	        to: "all"
	  	      };

	  	      websocket.send(JSON.stringify(messageObj));
	  	    };

	  	    websocket.onmessage = function(event) {
	  	      console.log(event.data);
	  	      var eventData = JSON.parse(event.data);
	  	      var receivedRoomNo = eventData.roomNo;
	  	    if (receivedRoomNo === roomNo) { 
	  	      if (event.data.substr(0, 1) == "「" && event.data.substr(event.data.length - 1) == "」") {
	  	        $("div#connectingUserList").html(event.data);
	  	      } else {
	  	        $("div#chatMessage").append(event.data);
	  	        $("div#chatMessage").append("<br>");
	  	        $("div#chatMessage").scrollTop(9999999);
	  	      }
	  	     }
	  	    };

	  	   chatRooms[roomNo] = websocket;
	  	  }
</script>