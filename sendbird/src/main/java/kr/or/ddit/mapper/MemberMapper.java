package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.BookVO;
import kr.or.ddit.vo.ChatMemVO;
import kr.or.ddit.vo.ChatRoomVO;
import kr.or.ddit.vo.MemberVO;

public interface MemberMapper {

	public MemberVO idCheck(MemberVO vo);

	public void insertBook(BookVO vo);

	public List<BookVO> selectBook();

	public void setChatRoom(ChatRoomVO vo);

	public void setChatUser(Map<String, Object> map);

	public List<ChatRoomVO> getAllChatRoom();

	public ChatRoomVO allCheck(ChatRoomVO vo);

	public ChatMemVO chatMemCheck(ChatMemVO vo);

	public int insertChatMem(ChatMemVO vo);

	public int updateCntUser(String cr_no);

	public int updateOnline(ChatMemVO vo);

	public int updateOnlineUser(String cr_no);

	public ChatRoomVO getRoomInfo(String cr_no);

	public List<ChatMemVO> selectAllMem(ChatMemVO vo);

	public List<ChatMemVO> selectAllMem2(String roomNo);

	public void closdeChatRoom(String roomNo);

	public void closdeChatMem(ChatMemVO vo);

}
