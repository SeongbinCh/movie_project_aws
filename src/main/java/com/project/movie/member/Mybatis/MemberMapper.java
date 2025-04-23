package com.project.movie.member.Mybatis;

import java.util.Map;

import com.project.movie.member.DTO.MemberDTO;

public interface MemberMapper {
	public MemberDTO login_chk( String id );
	public void keepLogin( Map<String, Object> map );
	public int idCheck( String id );
	public int register( MemberDTO dto );
	public int updateMemberInfo( MemberDTO dto );
	public Integer getMemberIdById( String id );
	public MemberDTO getMemberInfo( int memberId );
	public MemberDTO findByKakaoId(String kakaoId);
	public void kakaoRegister(MemberDTO dto);
	public void deleteMember(Integer memberId);
}
