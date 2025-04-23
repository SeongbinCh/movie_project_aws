package com.project.movie.community.Service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.project.movie.community.DTO.ReviewBoardDTO;
import com.project.movie.community.DTO.ReviewRepDTO;

public interface CommunityService {
	// 리뷰 게시글 관련
	public Map<String, Object> reviewBoardList( int num );
	public String writeReview( ReviewBoardDTO dto  );
	public ReviewBoardDTO reviewContent( int review_no );
	public ReviewBoardDTO getReviewContent( int review_no );
	public String reviewModify( ReviewBoardDTO dto );
	public String reviewDelete( int review_no );
	public List<ReviewBoardDTO> getUserPosts( int memberId );
	
	// 리뷰 게시글 댓글 관련
	public List<ReviewRepDTO> reviewReplyList(int review_no, int page, int size);
	public int getReviewRepCount(int write_group);
	public void addReviewReply(ReviewRepDTO dto, HttpSession session);
	public List<Integer> getReplyNoByReviewNo(int reviewNo);
	public List<ReviewRepDTO> getRepliesByReviewNo( int replyNo );
	public int getReplyCountByReviewNo( int replyNo );
	public void modifyReviewReply(ReviewRepDTO dto);
	public boolean deleteReviewReply(int reply_no);
	
	public String getMessage( String msg, String url );
}
