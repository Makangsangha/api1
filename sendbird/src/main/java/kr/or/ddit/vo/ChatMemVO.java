package kr.or.ddit.vo;

public class ChatMemVO {
	private String mem_id;
	private String cr_no;
	private String mem_nick;
	private String online_check;
	private String cr_master;
	
	public String getMem_id() {
		return mem_id;
	}
	public void setMem_id(String mem_id) {
		this.mem_id = mem_id;
	}
	public String getCr_no() {
		return cr_no;
	}
	public void setCr_no(String cr_no) {
		this.cr_no = cr_no;
	}
	public String getMem_nick() {
		return mem_nick;
	}
	public void setMem_nick(String mem_nick) {
		this.mem_nick = mem_nick;
	}
	public String getOnline_check() {
		return online_check;
	}
	public void setOnline_check(String online_check) {
		this.online_check = online_check;
	}
	public String getCr_master() {
		return cr_master;
	}
	public void setCr_master(String cr_master) {
		this.cr_master = cr_master;
	}
}
