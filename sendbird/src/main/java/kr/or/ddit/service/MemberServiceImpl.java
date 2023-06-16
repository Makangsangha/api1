package kr.or.ddit.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.MemberMapper;
import kr.or.ddit.vo.BookVO;
import kr.or.ddit.vo.ChatMemVO;
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

	@Override
	public ChatRoomVO allCheck(ChatRoomVO vo) {
		if (StringUtils.isBlank(vo.getCr_pw())) {
			vo.setCr_pw("OPEN");
		}
		ChatRoomVO rvo = mapper.allCheck(vo);

		return rvo;
	}

	@Override
	public Map<String, Object> chatMemAllCheckAndInsert(ChatMemVO vo) {
		ChatMemVO mvo = mapper.chatMemCheck(vo);
		Map<String, Object> message = new HashMap<>();
		if (mvo == null) {
			ChatRoomVO rvo = mapper.getRoomInfo(vo.getCr_no());
			if (Integer.parseInt(rvo.getCr_max_user()) <= Integer.parseInt(rvo.getCr_cnt_user())) {
				message.put("message", "채팅방의 인원이 가득 찼습니다!");
			}
		}
		return message;
	}

	@Override
	public List<ChatMemVO> selectAllMem(String mem_id, String roomNo) {
		ChatMemVO vo = new ChatMemVO();
		vo.setMem_id(mem_id);
		vo.setCr_no(roomNo);
		return mapper.selectAllMem(vo);
	}

	@Override
	public List<ChatMemVO> selectAllMem2(String roomNo) {
		return mapper.selectAllMem2(roomNo);
	}

	@Override
	public void closdeChatRoom(String roomNo) {
		mapper.closdeChatRoom(roomNo);
	}

	@Override
	public void closdeChatMem(String mem_id, String roomNo) {
		ChatMemVO vo = new ChatMemVO();
		vo.setMem_id(mem_id);
		vo.setCr_no(roomNo);
		mapper.closdeChatMem(vo);

	}

	@Override
	public void insertChatInfo(ChatMemVO vo) {
		ChatMemVO mvo = mapper.chatMemCheck(vo);
		Map<String, Object> message = new HashMap<>();
		if (mvo == null) {
			int b = mapper.insertChatMem(vo);
			int c = mapper.updateCntUser(vo.getCr_no());
			if (b < 1 || c < 1) {
				message.put("message", "서버 에러 발생!");
			} else {
				int a = mapper.updateOnline(vo);
				if (a < 1) {
					message.put("message", "서버 에러 발생!");
				}
			}
		} else {
			int d = mapper.updateOnlineUser(vo.getCr_no());
			if (d < 1) {
				message.put("message", "서버 에러 발생!");
			} else {
				int a = mapper.updateOnline(vo);
				if (a < 1) {
					message.put("message", "서버 에러 발생!");
				}
			}
		}
	}

}
