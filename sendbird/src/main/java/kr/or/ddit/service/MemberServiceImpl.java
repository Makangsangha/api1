package kr.or.ddit.service;



import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.MemberMapper;
import kr.or.ddit.vo.MemberVO;


@Service
public class MemberServiceImpl implements MemberService {

	@Inject
	private MemberMapper mapper;
	
	@Override
	public MemberVO idCheck(MemberVO vo) {
		return mapper.idCheck(vo);
	}

}
