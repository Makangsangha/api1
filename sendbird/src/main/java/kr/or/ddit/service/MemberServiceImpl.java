package kr.or.ddit.service;



import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.MemberMapper;
import kr.or.ddit.vo.BookVO;
import kr.or.ddit.vo.ChatRoomVO;
import kr.or.ddit.vo.MemberVO;


@Service
public class MemberServiceImpl implements MemberService {

	@Inject
	private MemberMapper mapper;
	
	@Override
	public MemberVO idCheck(MemberVO vo) {
		return mapper.idCheck(vo);
	}

	@Override
	public void insertBook(BookVO vo) {
		mapper.insertBook(vo);
		
	}

	@Override
	public List<BookVO> selectBook() {
		return mapper.selectBook();
	}

	@Override
	public void setChatRoom(ChatRoomVO vo) {
		mapper.setChatRoom(vo);
	}

	@Override
	public void setChatUser(Map<String, Object> map) {
		mapper.setChatUser(map);
	}

	@Override
	public List<ChatRoomVO> getAllChatRoom() {
		return mapper.getAllChatRoom();
	}



}
