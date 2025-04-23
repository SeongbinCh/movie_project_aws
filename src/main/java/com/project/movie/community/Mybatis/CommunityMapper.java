package com.project.movie.community.Mybatis;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.movie.community.DTO.ReviewBoardDTO;
import com.project.movie.community.DTO.ReviewRepDTO;

@Mapper
public interface CommunityMapper {
	// 게시글 관련
	public List<ReviewBoardDTO> reviewBoardList(@Param("s") int start, @Param("e") int end);
	public int selectReviewBoardCount();
	public int writeReviewBoard( ReviewBoardDTO dto );
	public ReviewBoardDTO getReviewContent( int review_no );
	public void upReviewHit( int review_no );
	public int reviewModify( ReviewBoardDTO dto );
	public int reviewDelete( int review_no );
	public List<ReviewBoardDTO> getUserPosts(@Param("memberId") int memberId);
	public void deleteReview(Integer memberId);
	
	// 게시글 댓글 관련
	public List<ReviewRepDTO> reviewReplyList( @Param("review_no") int review_no, @Param("s") int start, @Param("e") int end );
	public int getReviewRepCount( @Param("review_no") int review_no );
	public List<ReviewRepDTO> reviewReplyChildren(@Param("review_no") int review_no);
	public ReviewRepDTO getParentReply(@Param("parent_reply_no") int parent_reply_no);
	public int getMaxOrderNo(@Param("write_group") int write_group);
	public List<ReviewRepDTO> getRepliesByParent(int parent_reply_no);
	public List<Integer> getReplyNoByReviewNo(int reviewNo);
	
	// 게시글 대댓글 관련
	public List<ReviewRepDTO> getRepliesbyReviewNo(int reply_no);
	public int getReplyCountByReviewNo(int reply_no);
		
	public void addReviewReply( ReviewRepDTO dto );
	public void updateWriteGroup( int reply_no );
	public void modifyReviewReply( ReviewRepDTO dto );
	public int deleteReviewReply(@Param("reply_no") int reply_no );
	public int hasReplies(@Param("reply_no") int replyNo);
}
