package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.BookVO;
import kr.or.ddit.vo.ChatMemVO;
import kr.or.ddit.vo.ChatRoomVO;
import kr.or.ddit.vo.MemberVO;

public interface MemberService {

	public MemberVO idCheck(MemberVO vo);

	public void insertBook(BookVO vo);

	public List<BookVO> selectBook();

	public void setChatRoom(ChatRoomVO vo);

	public void setChatUser(Map<String, Object> map);

	public List<ChatRoomVO> getAllChatRoom();

	public ChatRoomVO allCheck(ChatRoomVO vo);

	public Map<String, Object> chatMemAllCheckAndInsert(ChatMemVO vo);

	public List<ChatMemVO> selectAllMem(String mem_id, String roomNo);

	public List<ChatMemVO> selectAllMem2(String roomNo);

	public void closdeChatRoom(String roomNo);

	public void closdeChatMem(String mem_id, String roomNo);

}
