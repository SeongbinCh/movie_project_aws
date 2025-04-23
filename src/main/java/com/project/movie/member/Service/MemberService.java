package com.project.movie.member.Service;

import com.project.movie.member.DTO.MemberDTO;

public interface MemberService {
	public int login_chk( String id, String pwd );
	public void keepLogin( String sessionId, String id );
	public int idCheck( String id );
	public int register( MemberDTO dto );
	public Integer getMemberIdById( String id );
	public MemberDTO getMemberInfo( int memberId );
	public int updateMemberInfo( MemberDTO dto );
	public MemberDTO findByKakaoId(String kakaoId);
	public void kakaoRegister(MemberDTO dto);
	public void deleteMember(Integer memberId);
}
