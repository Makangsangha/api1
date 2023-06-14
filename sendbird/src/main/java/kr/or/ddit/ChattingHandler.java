package kr.or.ddit;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import kr.or.ddit.service.MemberService;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.MessageVO;

public class ChattingHandler extends TextWebSocketHandler {

	@Inject
	private MemberService service;
	
	private Map<String, List<WebSocketSession>> chatRooms = new HashMap<>();


	public void init() throws Exception {

	}

	@Override
	public void afterConnectionEstablished(WebSocketSession wsession) throws Exception {
		Map<String, Object> a = wsession.getAttributes();
		String roomNo = a.get("no").toString();
		
		if (!chatRooms.containsKey(roomNo)) {
		    chatRooms.put(roomNo, new ArrayList<>());
		}

		List<WebSocketSession> users = chatRooms.get(roomNo);
		users.add(wsession);
		chatRooms.put(roomNo, users);
		

		// 접속자 명단

		String connectingUserName = "「";

		for (WebSocketSession webSocketSession : chatRooms.get(roomNo)) {
			Map<String, Object> map = webSocketSession.getAttributes();
			MemberVO user = (MemberVO) map.get("user");
			connectingUserName += user.getMem_name() + " ";
		}


		connectingUserName += "」";

		for (WebSocketSession webSocketSession : chatRooms.get(roomNo)) {
			webSocketSession.sendMessage(new TextMessage(connectingUserName));
		}
	}

	@Override
	protected void handleTextMessage(WebSocketSession wsession, TextMessage message) throws Exception {

		Map<String, Object> a = wsession.getAttributes();
		String roomNo = a.get("no").toString();
		
		Map<String, Object> map = wsession.getAttributes();
		MemberVO loginuser = (MemberVO) map.get("user");
		System.out.println(roomNo);
		System.out.println(loginuser.getMem_name());

		MessageVO messagevo = MessageVO.converMessage(message.getPayload());

		Date now = new Date();
		String currentTime = String.format("%tp %tl:%tM", now, now, now);

		for (WebSocketSession webSocketSession : chatRooms.get(roomNo)){
			if ("all".equals(messagevo.getType())) {
				if (!wsession.getId().equals(webSocketSession.getId())) {
					webSocketSession.sendMessage(new TextMessage("<span>" + loginuser.getMem_no()
							+ "</span>&nbsp;[<span style='font-weight:bold; cursor:pointer;' class='loginuserName'>"
							+ loginuser.getMem_name()
							+ "</span>]<br><div style='background-color: white; display: inline-block; max-width: 60%; padding: 7px; border-radius: 15%; word-break: break-all;'>"
							+ messagevo.getMessage()
							+ "</div> <div style='display: inline-block; padding: 20px 0 0 5px; font-size: 7pt;'>"
							+ currentTime + "</div> <div>&nbsp;</div>"));
				}
			} else {
				Map<String, Object> map1 = webSocketSession.getAttributes();
				MemberVO user = (MemberVO) map1.get("user");
				String to = user.getMem_no();

				if (messagevo.getTo().equals(to)) {
					webSocketSession.sendMessage(new TextMessage("<span> 귓속말" + loginuser.getMem_no()
							+ "</span>&nbsp;[<span style='font-weight:bold; cursor:pointer;' class='loginuserName'>"
							+ loginuser.getMem_name()
							+ "</span>]<br><div style='background-color: white; display: inline-block; max-width: 60%; padding: 7px; border-radius: 15%; word-break: break-all; color: red;'>"
							+ messagevo.getMessage()
							+ "</div> <div style='display: inline-block; padding: 20px 0 0 5px; font-size: 7pt;'>"
							+ currentTime + "</div> <div>&nbsp;</div>"));
					break; 
				}

			}
		}
	}

	@Override
	public void afterConnectionClosed(WebSocketSession wsession, CloseStatus status) throws Exception {
		
		Map<String, Object> map = wsession.getAttributes();
		MemberVO loginuser = (MemberVO) map.get("user");

		Map<String, Object> a = wsession.getAttributes();
		String roomNo = a.get("no").toString();
		
		List<WebSocketSession> sessions = chatRooms.get(roomNo);
		sessions.remove(wsession);
		
		chatRooms.put(roomNo, sessions);

		service.closdeChatMem(loginuser.getMem_id(), roomNo);
		service.closdeChatRoom(roomNo);
		
		if (roomNo.equals(map.get("no").toString())) {
			for (WebSocketSession webSocketSession : chatRooms.get(roomNo)) {

				if (!wsession.getId().equals(webSocketSession.getId())) {
					webSocketSession
							.sendMessage(new TextMessage(wsession.getRemoteAddress().getAddress().getHostAddress()
									+ " [<span style='font-weight:bold;'>" + loginuser.getMem_name() + "</span>]"
									+ "님이 <span style='color: red;'>퇴장</span>했습니다."));
				}

			}

			String connectingUserName = "「";

			for (WebSocketSession webSocketSession : chatRooms.get(roomNo)) {
				Map<String, Object> map2 = webSocketSession.getAttributes();
				MemberVO loginuser2 = (MemberVO) map2.get("user");

				connectingUserName += loginuser2.getMem_name() + " ";
			} 

			connectingUserName += "」";

			for (WebSocketSession webSocketSession : chatRooms.get(roomNo)) {
				webSocketSession.sendMessage(new TextMessage(connectingUserName));
			}

		}
	}

}
