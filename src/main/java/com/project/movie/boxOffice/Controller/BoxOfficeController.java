package com.project.movie.boxOffice.Controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.movie.boxOffice.Service.BoxOfficeService;
import com.project.movie.common.LoginSession;
import com.project.movie.member.DTO.MemberDTO;

import kr.or.kobis.kobisopenapi.consumer.rest.KobisOpenAPIRestService;

@Controller
@RequestMapping("boxOffice")
public class BoxOfficeController {
	@Autowired ServletContext servletContext;
	
	private final BoxOfficeService bs;
	
	public BoxOfficeController(BoxOfficeService boxOfficeService) {
		this.bs = boxOfficeService;
	}
	
	@Value("${kofic.api.key}")
	private String koficApiKey;
	
	// 일일 박스오피스 메서드
	@GetMapping("dailyOffice")
    public String dailyOffice( Model model ) throws Exception {
		HashMap<String, Object> dailyResult = bs.getDailyBoxOffice();
        model.addAttribute("dailyResult", dailyResult);
        
        return "boxOffice/dailyOffice";
    }

	// 주간 박스오피스 메서드
	@GetMapping("weeklyOffice")
	public String weeklyOffice( Model model ) throws Exception {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -7);
		String targetDt = dateFormat.format(cal.getTime());
		
        KobisOpenAPIRestService service = new KobisOpenAPIRestService(koficApiKey);
		
        String weeklyResponse = service.getWeeklyBoxOffice(true, targetDt, "10", "0", "N", "K", "");
        
        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> weeklyResult = mapper.readValue(weeklyResponse, HashMap.class);
        model.addAttribute("weeklyResult", weeklyResult);
        
        String codeResponse = service.getComCodeList(true, "0105000000");
        HashMap<String, Object> codeResult = mapper.readValue(codeResponse, HashMap.class);
        model.addAttribute("codeResult", codeResult);
        
		return "boxOffice/weeklyOffice";
	}
	
	// 영화 정보 검색 메서드
	@GetMapping("searchMovieInfo")
	public String searchMovieInfo(@RequestParam("movieName") String movieName, Model model ) throws Exception {
		HashMap<String, Object> movieData = bs.getMovieInfo(movieName);
		
		model.addAttribute("movieInfo", movieData.get("movieInfo"));
		model.addAttribute("posterUrl", movieData.get("posterUrl"));
		
		return "boxOffice/searchMovieInfo";
	}
	
	// 자동완성 메서드
	@GetMapping("autocomplete")
	@ResponseBody
	public List<String> autocomplete(@RequestParam("query") String query) {
		return bs.getMovieTitles(query);
	}
	
	// 영화 등록 페이지 메서드
	@GetMapping("registerMovie")
	public String registerMovie(HttpSession session, Model model, RedirectAttributes rs) throws Exception {
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
		
		HashMap<String, Object> dailyResult = bs.getDailyBoxOffice();
		Map<String, Object> boxOfficeResult = (Map<String, Object>) dailyResult.get("boxOfficeResult");
		List<Map<String, Object>> dailyList = (List<Map<String, Object>>) boxOfficeResult.get("dailyBoxOfficeList");
		
		model.addAttribute("dailyList", dailyList);
		
		return "boxOffice/registerMovie";
	}
	
	// 영화 등록 메서드
	@PostMapping("register_movie")
	public String register_movie( @RequestParam("movieName") String movieName,
								@RequestParam("movieShowDate") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate movieShowDate,
								@RequestParam("movieShowTime") String movieShowTime,
								RedirectAttributes rs) throws Exception {
		bs.registerMovie(movieName, movieShowDate, movieShowTime);
		
		rs.addFlashAttribute("addMovieMsg", "영화가 등록되었습니다");
		
		return "redirect:registerMovie";
	}

}
