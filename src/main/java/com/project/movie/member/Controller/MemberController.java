package com.project.movie.member.Controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.movie.booking.DTO.BookingListDTO;
import com.project.movie.booking.Service.BookingService;
import com.project.movie.common.LoginSession;
import com.project.movie.community.DTO.ReviewBoardDTO;
import com.project.movie.community.Service.CommunityService;
import com.project.movie.member.DTO.MemberDTO;
import com.project.movie.member.Service.MemberService;

@Controller
@RequestMapping("member")
public class MemberController {
	@Autowired MemberService ms;
	@Autowired CommunityService cs;
	@Autowired BookingService bs;
	
	@Value("${kakao.client.id}")
	private String kakaoClientId;
	
	// 로그인 페이지 메서드
	@GetMapping("login")
	public String login(HttpServletRequest req, HttpSession session) {
		String referer = req.getHeader("Referer");

		if( referer != null && !referer.contains("/membership") && !referer.contains("/login")) {
			session.setAttribute("prevPage", referer);
		}
		return "member/login";
	}
	
	// 로그인 확인 메서드
	@PostMapping("login_chk")
	public String login_chk(@RequestParam String id, @RequestParam String pwd,
							HttpSession session,
							RedirectAttributes rs,
							HttpServletResponse res) {
		String adminId = "admin123";
		String adminPWD = "1234";
		
		session.removeAttribute("isAdmin");
		session.removeAttribute("isUser");
		
		if (id.equals(adminId) && pwd.equals(adminPWD)) {
			session.setAttribute("role", adminId);
			session.setAttribute("isAdmin", true);
			session.setAttribute("isUser", false);
			session.setAttribute(LoginSession.LOGIN, id);
			return "redirect:successLogin?id=" + id;
		}
		
		int result = ms.login_chk( id, pwd );
		if( result == 1 ) {
			rs.addFlashAttribute("loginError", "아이디가 존재하지 않습니다");
			return "redirect:login";
		} else if( result == 2 ) {
			rs.addFlashAttribute("loginError", "비밀번호가 틀렸습니다");
			return "redirect:login";
		}
		
		session.setAttribute("isAdmin", false);
		session.setAttribute("isUser", true);
		
		session.setAttribute( LoginSession.LOGIN, id );
		
		rs.addAttribute( "id", id );
		
		return "redirect:successLogin";
	}
	
	// 카카오 액세스 토큰을 사용해 사용자 정보를 가져오고 DB에 회원 정보가 없으면 자동 등록 후 로그인 처리하는 메서드
	@GetMapping("kakaoLoginPost")
	public String kakaoLoginPost(@RequestParam(required = false) String redirect_uri,
							HttpSession session, 
							RedirectAttributes rs) {
		String accessToken = (String) session.getAttribute("access_token");
		
		if( accessToken == null ) {
			rs.addFlashAttribute("loginError", "세션이 만료되었습니다. 다시 로그인해주세요.");
			return "redirect:/member/login";
		}
		
		String url = "https://kapi.kakao.com/v2/user/me";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", "Bearer " + accessToken);
		
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET,
											new HttpEntity<>(headers), String.class);
		
		if( response.getStatusCode().is2xxSuccessful() ) {
			String responseBody = response.getBody();
			ObjectMapper objectMapper = new ObjectMapper();
			
			try {
				JsonNode jsonNode = objectMapper.readTree(responseBody);
				
				String kakaoId = jsonNode.path("id").asText();
	            String name = jsonNode.path("kakao_account").path("name").asText("No name");
	            String phoneNumber = jsonNode.path("kakao_account").path("phone_number").asText("No phone number");
	            String email = jsonNode.path("kakao_account").path("email").asText("No email");
	            
	            MemberDTO member = ms.findByKakaoId(kakaoId);
	            
	            if( member == null ) {
	            	member = new MemberDTO();
	            	member.setKakaoId(kakaoId);
	            	member.setName(name);
	            	member.setMobile(phoneNumber);
	            	member.setEmail(email);
	            	ms.kakaoRegister(member);
	            }
	            
	            session.setAttribute("loginMember", member);
	            session.setAttribute("kakaoId", kakaoId);

	            session.setAttribute("isAdmin", false);
	    		session.setAttribute("isUser", true);
	            
				rs.addFlashAttribute("loginMsg", "카카오 로그인하였습니다");
				
				if( redirect_uri != null ) {
					return "redirect:" + redirect_uri;
				}
				return "redirect:/main";
			} catch ( Exception e ) {
				e.printStackTrace();
				rs.addFlashAttribute("loginError", "카카오 로그인 정보 파싱 오류");
				return "redirect:/member/login";
			}
		} else {
			rs.addFlashAttribute("loginError", "카카오 로그인 실패");
			return "redirect:/member/login";
		}
	}
	
	// 카카오 인가 코드를 이용해 액세스 토큰을 발급받고 사용자 정보를 세션에 저장하는 메서드
	@GetMapping("kakaoLogin")
	public String kakaoLogin(@RequestParam String code,
							HttpSession session,
							RedirectAttributes rs) throws JsonMappingException, JsonProcessingException {
		String url = "https://kauth.kakao.com/oauth/token";
		
		MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
		params.add("grant_type", "authorization_code");
		params.add("client_id", kakaoClientId);
		params.add("redirect_uri", "http://localhost:8080/movie/member/kakaoLogin");
		params.add("code", code);
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
		
		HttpEntity<MultiValueMap<String, String>> entity =  new HttpEntity<>(params, headers);
		
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
		
		if (response.getStatusCode().is2xxSuccessful()) {
	        String responseBody = response.getBody();
	        
	        try {
	            ObjectMapper objectMapper = new ObjectMapper();
	            JsonNode jsonNode = objectMapper.readTree(responseBody);
	            String accessToken = jsonNode.get("access_token").asText();
	            
	            String userInfoUrl = "https://kapi.kakao.com/v2/user/me";
	            HttpHeaders userHeaders = new HttpHeaders();
	            userHeaders.set("Authorization", "Bearer " + accessToken);
	            
	            HttpEntity<String> userEntity = new HttpEntity<>(userHeaders);
	            ResponseEntity<String> userInfoResponse = restTemplate.exchange(userInfoUrl, HttpMethod.GET, userEntity, String.class);
	            
	            if (userInfoResponse.getStatusCode().is2xxSuccessful()) {
	                String userInfo = userInfoResponse.getBody();
	                ObjectMapper userMapper = new ObjectMapper();
	                JsonNode userJson = userMapper.readTree(userInfo);
	                
	                String kakaoId = userJson.path("id").asText();  
	                String name = userJson.path("kakao_account").path("name").asText("No name");
	                String phoneNumber = userJson.path("kakao_account").path("phone_number").asText("No phone number");
	                
	                session.setAttribute("kakaoId", kakaoId);
	                session.setAttribute("name", name);
	                session.setAttribute("phoneNumber", phoneNumber);
	                session.setAttribute("access_token", accessToken);
	                rs.addFlashAttribute("loginMsg", "카카오톡 로그인 성공");
	                
	                return "redirect:/member/kakaoLoginPost";
	            } else {
	                rs.addFlashAttribute("loginError", "사용자 정보 가져오기 실패");
	                return "redirect:/member/login";
	            }
	        } catch (Exception e) {
	            rs.addFlashAttribute("loginError", "카카오 로그인 정보 파싱 오류");
	            return "redirect:/member/login";
	        }
	    } else {
	        rs.addFlashAttribute("loginError", "카카오 로그인 실패");
	        return "redirect:/member/login";
	    }
	}
	
	// 세션의 로그인 상태 확인 후 true/false를 반환하는 메서드
	@GetMapping("isLoggedIn")
	@ResponseBody
	public Map<String, Object> isLoggedIn(HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		String loginUser = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO loginKakaoUser = (MemberDTO) session.getAttribute("loginMember");
		
		response.put("isLoggedIn", loginUser != null || loginKakaoUser != null );
		return response;
	}
	
	// 로그인 성공 메서드
	@GetMapping("successLogin")
	public String successLogin(@RequestParam String id, @RequestParam String autoLogin,
							HttpSession session, HttpServletResponse res,
							RedirectAttributes redirectAttributes) {
		String prevPage = (String)session.getAttribute("prevPage");
		
		redirectAttributes.addFlashAttribute("loginMsg", "로그인하였습니다");
		
		if( prevPage != null ) {
			session.removeAttribute("prevPage");
			return "redirect:" + prevPage;
		}
		return "main";
	}
	
	// 로그아웃 메서드
	@GetMapping("logout")
	public String logout(HttpSession session,
						@CookieValue(value="loginCookie", required = false) Cookie cookie,
						HttpServletResponse res, HttpServletRequest req,
						RedirectAttributes redirectAttributes) {
		String referer = req.getHeader("Referer");
		
		if( referer != null && !referer.contains("/logout")) {
			session.setAttribute("prevPage", referer);
		}
		
		if( cookie != null ) {
			cookie.setMaxAge(0);
			res.addCookie(cookie);
			ms.keepLogin("nan", (String)session.getAttribute(LoginSession.LOGIN));
		}
		
		String prevPage = (String)req.getSession().getAttribute("prevPage");

		session.invalidate();
		
		redirectAttributes.addFlashAttribute("logoutMsg", "로그아웃하였습니다");
		
		if( prevPage != null ) {
			return "redirect:" + prevPage;
		}
		return "redirect:main";
	}
	
	// 카카오 로그아웃 메서드
	@GetMapping("kakaoLogout")
	public String kakaoLogout(HttpSession session, HttpServletRequest req, RedirectAttributes rs) {
		String referer = req.getHeader("Referer");
		
		if( referer != null && !referer.contains("/logout") ) {
			session.setAttribute("prevPage", referer);
		}
		
		String accessToken = (String) session.getAttribute("access_token");
		
		if( accessToken == null ) {
			rs.addFlashAttribute("logoutMsg", "이미 로그아웃 되어 있습니다.");
			return "redirect:/main";
		}
		
		String logoutUrl = "https://kapi.kakao.com/v1/user/logout";
		HttpHeaders headers = new HttpHeaders();
		headers.set("Authorization", "Bearer " + accessToken);
		
		RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<String> response = restTemplate.exchange(
				logoutUrl, HttpMethod.POST, new HttpEntity<>(headers), String.class);
		
		session.invalidate();
		
		rs.addFlashAttribute("logoutMsg", "카카오 로그아웃 완료");
		
		String prevPage = (String) req.getSession().getAttribute("prevPage");
		if( prevPage != null ) {
			return "redirect:" + prevPage;
		}
		
		return "redirect:/main";
	}
	
	@ResponseBody
	@GetMapping("idCheck")
	public int idCheck(@RequestParam("id") String id) {
		return ms.idCheck(id);
	}
	
	// 회원가입 페이지 메서드
	@GetMapping("membership")
	public String membership(HttpServletRequest req, HttpSession session) {
		String referer = req.getHeader("Referer");

		if( referer != null && !referer.contains("/membership") && !referer.contains("/login") ) {
			session.setAttribute("prevPage", referer);
		}
		return "member/membership";
	}
	
	// 회원가입 처리 메서드
	@PostMapping("register")
	public String register( MemberDTO dto, RedirectAttributes redirectAttributes ) {
		int result = ms.register( dto );
		if( result == 1 ) {
			redirectAttributes.addFlashAttribute("membership", "회원가입이 완료되었습니다");
			
			return "redirect:/member/login";
		}
		return "redirect:/main";
	}
	
	// 마이페이지 메서드
	@GetMapping("mypage")
	public String mypage(HttpSession session, Model model, RedirectAttributes rs) {
		Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
		Boolean isUser = (Boolean) session.getAttribute("isUser");
		
		if( isAdmin == null && isUser == null ) {
			rs.addFlashAttribute("mypageLogin", "로그인을 해주세요");
			return "redirect:login";
		}
		
		model.addAttribute("isAdmin", isAdmin);
		model.addAttribute("isUser", isUser);
		
		return "member/mypage";
	}
	
	// 마이페이지(내 정보 수정) 메서드
	@GetMapping("mypageModifyView")
	public String mypageModifyView(HttpSession session, RedirectAttributes rs, Model model) {
		Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
		Boolean isUser = (Boolean) session.getAttribute("isUser");
		
		if( isAdmin == null && isUser == null ) {
			rs.addFlashAttribute("mypageLogin", "로그인을 해주세요");
			return "redirect:login";
		}
		
		model.addAttribute("isAdmin", isAdmin);
		model.addAttribute("isUser", isUser);
		
		String user = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO kakaoUser = (MemberDTO) session.getAttribute("loginMember");
		Integer memberId = (user != null) ? ms.getMemberIdById(user) : kakaoUser.getMemberId();
		MemberDTO memberInfo = ms.getMemberInfo(memberId);
		
		model.addAttribute("memberInfo", memberInfo);
		
		return "member/mypageModifyView";
	}
	
	// 마이페이지(내 정보 수정) 처리 메서드
	@PostMapping("updateMemberInfo")
	public String updateMemberInfo(HttpSession session, RedirectAttributes rs, MemberDTO dto) {
		String user = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO kakaoUser = (MemberDTO) session.getAttribute("loginMember");
		
		if( user == null && kakaoUser == null ) {
			rs.addFlashAttribute("mypageLogin", "로그인을 해주세요");
			return "redirect:login";
		}
		
		Integer memberId = (user != null) ? ms.getMemberIdById(user) : kakaoUser.getMemberId();
		dto.setMemberId(memberId);
		
		int result = ms.updateMemberInfo(dto);
		
		if( result == 1 ) {
			rs.addFlashAttribute("updateSuccess", "정보를 수정하였습니다");
		} else {
			rs.addFlashAttribute("updateFailed", "정보를 수정하지못했습니다. 다시 시도해주세요");
		}
		
		return "redirect:/member/mypage";
	}
	
	// 마이페이지(영화 예매 내역) 메서드
	@GetMapping("bookingHistoryView")
	public String bookingHistoryView(HttpSession session, RedirectAttributes rs, Model model) {
		Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
		Boolean isUser = (Boolean) session.getAttribute("isUser");
		
		if( isAdmin == null && isUser == null ) {
			rs.addFlashAttribute("mypageLogin", "로그인을 해주세요");
			return "redirect:login";
		}
		
		model.addAttribute("isAdmin", isAdmin);
		model.addAttribute("isUser", isUser);
		
		String user = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO kakaoUser = (MemberDTO) session.getAttribute("loginMember");
		Integer memberId = (user != null) ? ms.getMemberIdById(user) : kakaoUser.getMemberId();
		List<BookingListDTO> bookingList = bs.getBookingList(memberId);
		
		model.addAttribute("bookingList", bookingList);
	
		return "member/bookingHistoryView";
	}
	
	// 마이페이지(영화 예매 내역) 취소 메서드
	@PostMapping("cancelBooking")
	public String cancelBooking(@RequestParam("seatInfo") String seatInfo, RedirectAttributes rs) {
		String seatIds[] = seatInfo.split(", ");
		
		try {
			boolean isCancelled = bs.cancelBooking(seatIds);
			if( isCancelled ) {
				rs.addFlashAttribute("cancelSuccess", "예매가 취소되었습니다");
			} else {
				rs.addFlashAttribute("cancelFailed", "예매 취소를 실패하였습니다");
			}
		} catch ( Exception e ) {
			rs.addFlashAttribute("cancelFailed", "예매 취소 중 오류가 발생했습니다");
		}
		
		return "redirect:/member/bookingHistoryView";
	}
	
	// 마이페이지(게시글 등록 내역) 메서드
	@GetMapping("postListView")
	public String postListView(HttpSession session, RedirectAttributes rs, Model model) {
		Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
		Boolean isUser = (Boolean) session.getAttribute("isUser");
		
		if( isAdmin == null && isUser == null ) {
			rs.addFlashAttribute("mypageLogin", "로그인을 해주세요");
			return "redirect:login";
		}
		
		model.addAttribute("isAdmin", isAdmin);
		model.addAttribute("isUser", isUser);
		
		String user = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO kakaoUser = (MemberDTO) session.getAttribute("loginMember");
		Integer memberId = (user != null) ? ms.getMemberIdById(user) : kakaoUser.getMemberId();
		
		List<ReviewBoardDTO> postList = cs.getUserPosts(memberId);
		
		model.addAttribute("postList", postList);
		
		return "member/postListView";
	}
	
	@GetMapping("memberDelete")
	public String memberDelete(HttpSession session, RedirectAttributes rs) {
		String user = (String) session.getAttribute(LoginSession.LOGIN);
		MemberDTO kakaoUser = (MemberDTO) session.getAttribute("loginMember");
		
		if( user != null && kakaoUser != null ) {
			rs.addFlashAttribute("loginError", "로그인을 해주세요");
			return "redirect:/member/login";
		}
		
		Integer memberId = (user != null) ? ms.getMemberIdById(user) : kakaoUser.getMemberId();
		
		ms.deleteMember(memberId);
		rs.addFlashAttribute("deleteMsg", "회원탈퇴하였습니다");
		session.invalidate();
	
		return "redirect:/main";
	}
}
