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
   <input type="button" class="btn btn-danger btn-sm my-3 mx-3" id="endBtn" value="채팅방나가기" />
</div>
</div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
      
      $(window).on('unload', function(){
   	    websocket.close();
      });
      
      $(function(){
          
     	  var url = window.location.host;
     	  var pathname = window.location.pathname; 
    	
    	  var appCtx = pathname.substring(0, pathname.lastIndexOf("/") );
    	  var root = url+appCtx;

    	
    	  var wsUrl = "ws://" + root + "/chatting?no=" + no;
    	  var websocket = new WebSocket(wsUrl);
    	  
    	  var no = "${no}"
    	  $("#mycontent").css({"background-color":"#cce0ff"});
    	 
    	    
	    	var messageObj = {};
	    	
			websocket.onopen = function(){
	    		console.log('onopen');
				$("div#chatStatus").text('정보: 웹소켓에 연결이 성공됨');
				messageObj = { message : "<span style='color: red;'>${user.mem_name }</span>님이 채팅방에 입장했습니다",
							   type : "all",
							   to : "all"
							};
		
	            websocket.send(JSON.stringify(messageObj));
				
			};  
			
			websocket.onmessage = function(event){
				console.log(event.data);
				if(event.data.substr(0,1)=="「" && event.data.substr(event.data.length-1)=="」") {
					$("div#connectingUserList").html(event.data);
				}
				else {
					$("div#chatMessage").append(event.data);
					$("div#chatMessage").append("<br>");
					$("div#chatMessage").scrollTop(9999999);
				}
			};
			
			$("#endBtn").on('click', function(){
				 websocket.close();
				 location.href = "/chatList"
			})
	
			var isOnlyOneDialog = false; 
			$("#btnSendMessage").click(function(){
				
				if($("#message").val() != ""){
					
	                var messageVal = $("input#message").val();
	                messageVal = messageVal.replace(/<script/gi, "&lt;script"); 
	            
	                
	                messageObj = { message : messageVal,
				       				type : "all",
									to : "all"
									};
	                
	                var to = $("input#to").val();
	                if ( to != "" ) {
	                    messageObj.type = "one";
	                    messageObj.to = to;
	                }
	                
	                websocket.send(JSON.stringify(messageObj));                
	          
	             
	                var now = new Date();
	                var ampm = "오전 ";
	                var hours = now.getHours();
	                
	                if(hours > 12) {
	                   hours = hours - 12;
	                   ampm = "오후 ";
	                }
	                
	                if(hours == 0) {
	                   hours = 12;
	                }
	                if(hours == 12){
	                	ampm = "오후"
	                }
	                
	                var minutes = now.getMinutes();
	              if(minutes < 10) {
	                 minutes = "0"+minutes;
	              }
	              
	                var currentTime = ampm + hours + ":" + minutes;
	                if(isOnlyOneDialog == false){ 
	                	$("#chatMessage").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 15%; word-break: break-all;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>"+currentTime+"</div> <div style='clear: both;'>&nbsp;</div>");                    
	                } else {
	                	$("div#chatMessage").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 15%; word-break: break-all; color:red;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>"+currentTime+"</div> <div style='clear: both;'>&nbsp;</div>");                  
	                }
	                $("#chatMessage").scrollTop(9999999);
	                $("input#message").val("");
	                $("input#message").focus();
				  }
			});
			
			$("#message").keyup((event) => {
				if(event.keyCode == 13){
					$("#btnSendMessage").click();
				}
			});
			
			
	        $("button#btnAllDialog").hide();
	        $(document).on("click",".loginuserName",function(){
	           
	            var ip = $(this).prev().text();
	            console.log(ip)
	        
	             $("input#to").val(ip); 
	             
	             $("span#privateWho").text($(this).text());
	             $("button#btnAllDialog").show();
	             
	             isOnlyOneDialog = true; 
	         });
			
	     	
	        $("button#btnAllDialog").click(function(){
	              $("input#to").val("");
	              $("span#privateWho").text("");
	              $(this).hide();
	              
	              isOnlyOneDialog = false; 
	        });
			
      });

</script>