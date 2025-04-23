package com.project.movie.community.Controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.movie.common.LoginSession;
import com.project.movie.community.DTO.ReviewRepDTO;
import com.project.movie.community.Service.CommunityService;
import com.project.movie.member.DTO.MemberDTO;
import com.project.movie.member.Service.MemberService;


@RestController
@RequestMapping("community")
public class CommunityRepController {
	@Autowired CommunityService cs;
	@Autowired MemberService ms;
	
	// 게시글의 댓글 리스트를 불러오는 메서드
	@GetMapping(value = "reviewReplyData/{review_no}", produces = "application/json; charset=utf-8")
	public List<ReviewRepDTO> reviewReplyData(@PathVariable int review_no,
										@RequestParam(required = false, defaultValue = "1") int page,
										@RequestParam int size,
										HttpSession session) {
		String user = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO kakaoUser = (MemberDTO) session.getAttribute("loginMember");
		
		Integer memberId = null;
		
		if (user != null) {
	        memberId = ms.getMemberIdById(user);
	    } else if (kakaoUser != null) {
	        memberId = kakaoUser.getMemberId();
	    }
		
		List<ReviewRepDTO> comments = cs.reviewReplyList(review_no, page, size);
		
		for (ReviewRepDTO comment : comments) {
	        if (memberId != null) {
	            comment.setUserId(comment.getMemberId() == memberId);
	        } else {
	            comment.setUserId(false);
	        }
	    }
		
		return comments;
	}
	
	// 게시글의 댓글 갯수를 가져오는 메서드
	@GetMapping(value = "reviewReplyCount/{review_no}", produces = "application/json; charset=utf-8")
	public int reviewReplyCount(@PathVariable int review_no) {
		return cs.getReviewRepCount(review_no);
	}
	
	// 댓글 등록 메서드
	@PostMapping(value = "addReviewReply", produces = "application/json; charset=utf-8")
	public ResponseEntity<?> addReviewReply(@RequestBody ReviewRepDTO dto, HttpSession session, RedirectAttributes rs) {
		String user = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO kakaoId = (MemberDTO) session.getAttribute("loginMember");
		
		String id = null;
		
		if( user != null ) {
			id = user;
 		} else if( kakaoId != null ) {
 			id = kakaoId.getId();
 		}
		
		if( id == null ) {
			return ResponseEntity.status(HttpServletResponse.SC_UNAUTHORIZED).body("로그인을 해주세요");
		}
		
		dto.setId(id);
		
		cs.addReviewReply(dto, session);
		return ResponseEntity.ok(Collections.singletonMap("message", "댓글이 등록되었습니다"));
	}
	
	// 댓글 수정 메서드
	@PostMapping(value = "modifyReviewReply", produces = "application/json; charset=utf-8")
	public void modifyReviewReply(@RequestBody ReviewRepDTO dto) {
		cs.modifyReviewReply(dto);
	}
	
	// 댓글 삭제 메서드
	@PostMapping(value = "deleteReviewReply", produces = "application/json; charset=utf-8")
	public Map<String, Object> deleteReviewReply(@RequestBody ReviewRepDTO dto) {
		int replyNo = dto.getReply_no();
		Map<String, Object> result = new HashMap<>();
		
		if( cs.deleteReviewReply(replyNo) ) {
			result.put("success", true);
			result.put("message", "댓글이 삭제되었습니다");
		} else {
			result.put("success", false);
			result.put("message", "대댓글이 존재하여 삭제할 수 없습니다");
		}

		return result;
	}
}
