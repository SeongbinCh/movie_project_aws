package com.project.movie.member.Service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.movie.booking.Mybatis.BookingMapper;
import com.project.movie.community.Mybatis.CommunityMapper;
import com.project.movie.member.DTO.MemberDTO;
import com.project.movie.member.Mybatis.MemberMapper;

@Service
public class MemberServiceImpl implements MemberService{
	@Autowired CommunityMapper communitymapper;
	@Autowired BookingMapper bookingmapper;
	@Autowired MemberMapper mapper;
	@Autowired private PasswordEncoder passwordEncoder;
	
	// 로그인 확인 메서드
	public int login_chk( String id, String pwd ) {
		MemberDTO dto = mapper.login_chk( id );
		if( dto == null ) {
			return 1;
		}
		if( dto.getPwd() == null || !passwordEncoder.matches(pwd, dto.getPwd()) ) {
			return 2;
		}
		return 0;
	}
	
	// 로그인 정보 저장 메서드
	public void keepLogin( String sessionId, String id ) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put( "sessionId", sessionId );
		map.put( "id", id );
		mapper.keepLogin( map );
	}
	
	public int idCheck( String id ) {
		int count = mapper.idCheck(id);
		return count;
	}
	
	// 회원가입 처리 메서드
	public int register( MemberDTO dto ) {
		try {
			String encodedPw = passwordEncoder.encode(dto.getPwd());
			dto.setPwd(encodedPw);
			
			return mapper.register( dto );
		} catch( Exception e ) {
			e.printStackTrace();
			return 0;
		}
	}
	
	// 회원정보를 가져오는 메서드
	public MemberDTO getMemberInfo( int memberId ) {
		return mapper.getMemberInfo(memberId);
	}
	
	// 회원정보 수정 메서드
	public int updateMemberInfo( MemberDTO dto ) {
		return mapper.updateMemberInfo(dto);
	}
	
	// id로 memberId를 가져오는 메서드
	public Integer getMemberIdById( String id ) {
		return mapper.getMemberIdById(id);
	}
	
	// 카카오 계정 확인
	public MemberDTO findByKakaoId(String kakaoId) {
		return mapper.findByKakaoId(kakaoId);
	}
	
	// 카카오 회원가입
	public void kakaoRegister(MemberDTO dto) {
		mapper.kakaoRegister(dto);
	}
	
	public void deleteMember(Integer memberId) {
		bookingmapper.deleteBooking(memberId);
		communitymapper.deleteReview(memberId);
		mapper.deleteMember(memberId);
	}
}
