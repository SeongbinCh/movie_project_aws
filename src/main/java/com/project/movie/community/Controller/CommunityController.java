package com.project.movie.community.Controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.project.movie.boxOffice.Service.BoxOfficeService;
import com.project.movie.common.LoginSession;
import com.project.movie.community.DTO.ReviewBoardDTO;
import com.project.movie.community.DTO.ReviewRepDTO;
import com.project.movie.community.Service.CommunityService;
import com.project.movie.member.DTO.MemberDTO;

@Controller
@RequestMapping("community")
public class CommunityController {
	@Autowired BoxOfficeService bs;
	@Autowired CommunityService cs;
	
	// 게시글 리스트 가져오기
	@GetMapping("/reviewBoardList")
	public String reviewBoardList( Model model, 
								HttpSession session,
								RedirectAttributes rs,
								@RequestParam( required = false, defaultValue = "1" ) int num ) {
		Map<String, Object> map = cs.reviewBoardList(num);
		int currentPage = num;
		int totalPages = (int)map.get("repeat");
		
		if( totalPages <= 0 ) {
			totalPages = 1;
		}
		
		String user = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO kakaoUser = (MemberDTO) session.getAttribute("loginMember");
		
		String userId = null;
		
		if( user != null ) {
			userId = user;
		} else if( kakaoUser != null ) {
			userId = kakaoUser.getId();
		}

		model.addAttribute("userId", userId);
		model.addAttribute("list", map.get("list"));
		model.addAttribute("repeat", totalPages);
		model.addAttribute("currentPage", currentPage);
		
		return "community/reviewBoardList";
	}
	
	// 게시글 작섬 페이지
	@GetMapping("/reviewWritePage")
	public String reviewWritePage(HttpSession session,
								RedirectAttributes rs,
								Model model) throws Exception {
		String user = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO kakaoUser = (MemberDTO) session.getAttribute("loginMember");
		
		String userId = null;
		
		if( user != null ) {
			userId = user;
		} else if( kakaoUser != null ) {
			userId = kakaoUser.getId();
		}
		
		HashMap<String, Object> dailyResult = bs.getDailyBoxOffice();
		Map<String, Object> boxOfficeResult = (Map<String, Object>) dailyResult.get("boxOfficeResult");
		List<Map<String, Object>> dailyList = (List<Map<String, Object>>) boxOfficeResult.get("dailyBoxOfficeList");

		model.addAttribute("dailyList", dailyList);
		model.addAttribute("userId", userId);
		
		return "community/reviewWritePage";
	}
	
	// 게시글 작성 메서드
	@PostMapping("/reviewWriteForm")
	public void reviewWriteForm( ReviewBoardDTO dto, HttpServletResponse res ) throws IOException {
		if( dto == null ) {
			res.sendError(HttpServletResponse.SC_BAD_REQUEST, "BoardDTO is null");
			return;
		}
		
		String msg = cs.writeReview( dto );
		
		res.setContentType("text/html; charset=utf-8");
		PrintWriter out = res.getWriter();
		out.print( msg );
	}
	
	// 게시글 상세 정보 페이지
	@GetMapping("/reviewContentPage")
	public String reviewContentPage(@RequestParam("review_no") int review_no, Model model, HttpSession session) {
		String user = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO kakaoUser = (MemberDTO) session.getAttribute("loginMember");
		
		String userId = null;
		if( user != null ) {
			userId = user;
		} else if( kakaoUser != null ) {
			userId = kakaoUser.getId();
		}
		
		ReviewBoardDTO reviewBoard = cs.reviewContent(review_no);
		
		List<Integer> replyNos = cs.getReplyNoByReviewNo(review_no);
		
		Map<Integer, List<ReviewRepDTO>> replyLists = new HashMap<>();
		
		
		for( int replyNo : replyNos ) {
			List<ReviewRepDTO> replyList = cs.getRepliesByReviewNo(replyNo);
			
			replyLists.put(replyNo, replyList);
		}
		
		model.addAttribute("userId", userId);
		model.addAttribute("dto", reviewBoard);
		model.addAttribute("review_no", review_no);
		model.addAttribute("replyLists", replyLists);
		return "community/reviewContentPage";
	}
	
	// 게시글 수정 페이지
	@GetMapping("/reviewModifyPage")
	public String reviewModifyPage(@RequestParam("review_no") int review_no, Model model) {
		model.addAttribute("dto", cs.getReviewContent(review_no));
		return "community/reviewModifyPage";
	}
	
	// 게시글 수정 메서드
	@PostMapping("reviewModify")
	public void reviewModify(ReviewBoardDTO dto,
							HttpServletResponse res) throws Exception {
		String msg = cs.reviewModify( dto );
		res.setContentType("text/html; charset=utf-8");
		
		PrintWriter out = res.getWriter();
		out.print( msg );
	}
	
	// 게시글 삭제 메서드
	@GetMapping("/reviewDelete")
	public void delete(@RequestParam("review_no") int review_no,
					HttpServletResponse res) throws Exception {
		String msg = cs.reviewDelete( review_no );
		res.setContentType("text/html; charset=utf-8");
		
		PrintWriter out = res.getWriter();
		out.print( msg );
	}
}
