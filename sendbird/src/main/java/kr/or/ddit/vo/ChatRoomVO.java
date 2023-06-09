package kr.or.ddit.vo;

public class ChatRoomVO {
	private String cr_no;
	private String cr_date;
	private String cr_end_date;
	private String cr_pw;
	private String cr_name;
	private String cr_content;
	private String cr_max_user;
	private String cr_cnt_user;
	private String cr_online_user;
	
	public String getCr_max_user() {
		return cr_max_user;
	}
	public void setCr_max_user(String cr_max_user) {
		this.cr_max_user = cr_max_user;
	}
	public String getCr_cnt_user() {
		return cr_cnt_user;
	}
	public void setCr_cnt_user(String cr_cnt_user) {
		this.cr_cnt_user = cr_cnt_user;
	}
	public String getCr_online_user() {
		return cr_online_user;
	}
	public void setCr_online_user(String cr_online_user) {
		this.cr_online_user = cr_online_user;
	}
	public String getCr_no() {
		return cr_no;
	}
	public void setCr_no(String cr_no) {
		this.cr_no = cr_no;
	}
	public String getCr_date() {
		return cr_date;
	}
	public void setCr_date(String cr_date) {
		this.cr_date = cr_date;
	}
	public String getCr_end_date() {
		return cr_end_date;
	}
	public void setCr_end_date(String cr_end_date) {
		this.cr_end_date = cr_end_date;
	}
	public String getCr_pw() {
		return cr_pw;
	}
	public void setCr_pw(String cr_pw) {
		this.cr_pw = cr_pw;
	}
	public String getCr_name() {
		return cr_name;
	}
	public void setCr_name(String cr_name) {
		this.cr_name = cr_name;
	}
	public String getCr_content() {
		return cr_content;
	}
	public void setCr_content(String cr_content) {
		this.cr_content = cr_content;
	}
}
