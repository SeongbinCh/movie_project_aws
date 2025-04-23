package com.project.movie.community.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.project.movie.common.LoginSession;
import com.project.movie.community.DTO.ReviewBoardDTO;
import com.project.movie.community.DTO.ReviewRepDTO;
import com.project.movie.community.Mybatis.CommunityMapper;
import com.project.movie.member.Mybatis.MemberMapper;

@Service
public class CommunityServiceImpl implements CommunityService{
	@Autowired CommunityMapper communityMapper;
	@Autowired MemberMapper memberMapper;
	
	// 게시글 리스트
	public Map<String, Object> reviewBoardList( int num ) {
		int pageLetter = 10;
		int allCount = communityMapper.selectReviewBoardCount();
		int repeat = allCount / pageLetter;
		
		if( allCount % pageLetter != 0 ) {
			repeat++;
		}
		
		int start = (num -1) * pageLetter;
		int end = pageLetter;	
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("repeat", repeat);
		map.put("list", communityMapper.reviewBoardList(start, end));
		
		return map;
	}
	
	// 게시글 등록
	public String writeReview( ReviewBoardDTO dto  ) {
		int result = communityMapper.writeReviewBoard(dto);
		
		String msg = "", url = "";
		if( result == 1 ) {
			msg = "리뷰가 작성되었습니다.";
			url = "/movie/community/reviewBoardList";
		} else {
			msg = "리뷰 작성을 실패하였습니다.";
			url = "/movie/community/reviewWriteForm";
		}
		
		return this.getMessage(msg, url);
	}
	
	// 게시글 내용
	public ReviewBoardDTO reviewContent( int review_no ) {
		upReviewHit( review_no );
		return communityMapper.getReviewContent(review_no);
	}
	
	// 게시글 조회수 올리기
	public void upReviewHit( int review_no ) {
		communityMapper.upReviewHit( review_no );
	}
	
	// 리뷰 게시글 내용 가져오기
	public ReviewBoardDTO getReviewContent( int review_no ) {
		return communityMapper.getReviewContent(review_no);
	}
	
	// 게시글 수정
	public String reviewModify( ReviewBoardDTO dto ) {
		int result = communityMapper.reviewModify(dto);
		String msg = "", url = "";
		
		if( result == 1 ) {
			msg = "게시글을 수정하였습니다.";
			url = "/movie/community/reviewContentPage?review_no=" + dto.getReview_no();
		} else {
			msg = "게시글을 수정하지 못했습니다.";
			url = "/movie/community/reviewModifyPage?review_no=" + dto.getReview_no();
		}
		return this.getMessage(msg, url);
	}
	
	// 게시글 삭제
	public String reviewDelete( int review_no ) {
		int result = communityMapper.reviewDelete(review_no);
		String msg = "", url = "";
		
		if( result == 1 ) {
			msg = "게시글을 삭제하였습니다.";
			url = "/movie/community/reviewBoardList";
		} else {
			msg = "게시글을 삭제하지 못했습니다.";
			url = "/movie/community/reviewContentPage?review_no" + review_no;
		}
		return this.getMessage(msg, url);
	}
	
	public List<ReviewBoardDTO> getUserPosts( int memberId ) {
		return communityMapper.getUserPosts(memberId);
	}
	
	
	// 게시글 댓글 리스트 가져오기
	public List<ReviewRepDTO> reviewReplyList(int review_no, int page, int size) {
		int start = (page - 1) * size;
		int end = page * size;
		
		List<ReviewRepDTO> comments = communityMapper.reviewReplyList(review_no, start, end);
		
		List<ReviewRepDTO> replies = communityMapper.reviewReplyChildren(review_no);
		
		Map<Integer, List<ReviewRepDTO>> replyMap = new HashMap<>();
		for( ReviewRepDTO reply : replies ) {
			replyMap.computeIfAbsent(reply.getWrite_group(), k -> new ArrayList<>()).add(reply);
		}
		
		for( ReviewRepDTO comment : comments ) {
			if( replyMap.containsKey(comment.getWrite_group()) ) {
				comment.setReplies(replyMap.get(comment.getWrite_group()));
			}
		}
		
		return comments;
	}
	
	// 게시글 댓글 수 가져오기
	public int getReviewRepCount(int review_no) {
		return communityMapper.getReviewRepCount(review_no);
	}
	
	// 게시글 댓글 작성
	public void addReviewReply(ReviewRepDTO dto, HttpSession session) {
		String id = (String) session.getAttribute(LoginSession.LOGIN);
		dto.setId(id);
		
		Integer memberId = memberMapper.getMemberIdById(id);
		
		if( memberId != null ) {
			dto.setMemberId(memberId);
		} else {
			throw new IllegalStateException("로그인 정보가 일치하지 않습니다");
		}
		
		if( dto.getParent_reply_no() == null || dto.getParent_reply_no() == 0 ) {
			// 원댓글일 경우
			dto.setParent_reply_no(0);
			dto.setDepth(0);
			dto.setOrder_no(1);
			
			communityMapper.addReviewReply(dto);
			communityMapper.updateWriteGroup(dto.getReply_no());	
		} else {
			// 대댓글의 경우
			ReviewRepDTO parentReply = communityMapper.getParentReply(dto.getParent_reply_no());
			dto.setWrite_group(parentReply.getWrite_group());
			dto.setDepth(parentReply.getDepth() + 1);
			int orderNo = communityMapper.getMaxOrderNo(dto.getWrite_group()) + 1;
			dto.setOrder_no(orderNo);
			dto.setReview_no(parentReply.getReview_no());
			
			communityMapper.addReviewReply(dto);
		}
	}
	
	// review_no을 통해 reply_no을 가져오는 메서드
	public List<Integer> getReplyNoByReviewNo(int reviewNo) {
		return communityMapper.getReplyNoByReviewNo(reviewNo);
	}
	
	// 대댓글 리스트를 가져오는 메서드
	public List<ReviewRepDTO> getRepliesByReviewNo( int replyNo ) {
		return communityMapper.getRepliesByParent(replyNo);
	}
	
	// 대댓글 갯수를 가져오는 메서드
	public int getReplyCountByReviewNo( int replyNo ) {
		return communityMapper.getReplyCountByReviewNo(replyNo);
	}
	
	// 게시글 댓글 수정
	public void modifyReviewReply(ReviewRepDTO dto) {
		communityMapper.modifyReviewReply(dto);
	}
	
	// 게시글 댓글 삭제
	public boolean deleteReviewReply(int reply_no) {
		int replyCount = communityMapper.hasReplies(reply_no);
		if( replyCount > 0 ) {
			return false;
		}
		
		int deletedRows = communityMapper.deleteReviewReply(reply_no);
		return deletedRows > 0;
	}
	
	public String getMessage( String msg, String url ) {
		String message = "<script>alert('" + msg + "');";
		message += "location.href='" + url + "';</script>";
		
		return message;
	}
}
