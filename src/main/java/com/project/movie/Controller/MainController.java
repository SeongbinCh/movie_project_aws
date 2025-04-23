package com.project.movie.Controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.project.movie.boxOffice.Service.BoxOfficeService;

@Controller
public class MainController {
	@Autowired BoxOfficeService bos;
	
	// 메인 페이지
	@GetMapping("main")
	public String main(Model model) {
		try {
			List<Map<String, String>> top10Movies = bos.getTop10Movies();
			
			model.addAttribute("top10Movies", top10Movies);
		} catch (Exception e) {
			e.printStackTrace();
			
			model.addAttribute("mainError", "영화 정보를 불러오는 중 오류가 발생함");
		}
		
		return "main";
	}
}
