package kr.or.ddit.vo;

import com.google.gson.Gson;

public class MessageVO {
	private String message;
	private String type;
	private String to;
	
	
	public static MessageVO converMessage(String payload) {
		Gson gson = new Gson();
        return gson.fromJson(payload, MessageVO.class);
	}


	public String getMessage() {
		return message;
	}


	public void setMessage(String message) {
		this.message = message;
	}


	public String getType() {
		return type;
	}


	public void setType(String type) {
		this.type = type;
	}


	public String getTo() {
		return to;
	}


	public void setTo(String to) {
		this.to = to;
	}



}
