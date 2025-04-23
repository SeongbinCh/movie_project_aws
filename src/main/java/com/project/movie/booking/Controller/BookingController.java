package com.project.movie.booking.Controller;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.movie.booking.DTO.BookingDTO;
import com.project.movie.booking.Service.BookingService;
import com.project.movie.boxOffice.Service.BoxOfficeService;
import com.project.movie.common.LoginSession;
import com.project.movie.member.DTO.MemberDTO;
import com.project.movie.member.Service.MemberService;

@Controller
@RequestMapping("/booking")
public class BookingController {
	private final BoxOfficeService bos;
	private final BookingService bks;
	private final MemberService ms;
	
	@Value("${tmdb.api.key}")
	private String tmdbApiKey;
	
	@Value("${kakaopay.admin.key}")
	private String kakaopayAdminKey;
	
	@Value("${kakaopay.javascript.key}")
	private String kakaopayJavascriptKey;
	
	@Value("${tosspay.client.key}")
	private String tosspayClientKey;
	
	@Value("${tosspay.secret.key}")
	private String tosspaySecretKey;
	
	public BookingController(BoxOfficeService bos, BookingService bks, MemberService ms) {
		this.bos = bos;
		this.bks = bks;
		this.ms = ms;
	}
	
	// 빠른 예매 첫 페이지 메서드
	@GetMapping("/fastBooking")
	public String fastBooking( Model model ) throws Exception {
		HashMap<String, Object> dailyResult = bos.getDailyBoxOffice();
		model.addAttribute("dailyResult", dailyResult);
		
		YearMonth yearMonth = YearMonth.now();
		int daysInMonth = yearMonth.lengthOfMonth();
		
		List<Integer> days = new ArrayList<>();
		for( int i=1; i<=daysInMonth; i++) {
			days.add(i);
		}
		
		model.addAttribute("daysInMonth", days);
		
		return "booking/fastBooking";
	}
	
	// 영화 선택시 선택 영화 포스터와 이름을 가져와서 선택되는 메서드
	@PostMapping("/updateMovie")
	@ResponseBody
	public Map<String, Object> updateMovie(@RequestBody Map<String, Object> request) throws Exception {
	    String movieName = (String) request.get("movieName");
	    
	    String tmdbUrl = "https://api.themoviedb.org/3/search/movie?api_key=" + tmdbApiKey + "&query=" + URLEncoder.encode(movieName, "UTF-8");
	    HttpClient client = HttpClient.newHttpClient();
	    HttpRequest httpRequest = HttpRequest.newBuilder().uri(URI.create(tmdbUrl)).GET().build();
	    HttpResponse<String> tmdbResponse = client.send(httpRequest, HttpResponse.BodyHandlers.ofString());
	    ObjectMapper mapper = new ObjectMapper();
	    HashMap<String, Object> tmdbData = mapper.readValue(tmdbResponse.body(), HashMap.class);
	    String posterPath = (String) ((HashMap<String, Object>) ((List<Object>) tmdbData.get("results")).get(0)).get("poster_path");
	    String posterUrl = "https://image.tmdb.org/t/p/w500" + posterPath;
	    
	    Map<String, Object> response = new HashMap<>();
	    response.put("movieName", movieName);
	    response.put("moviePoster", posterUrl);
	    return response;
	}

	// 날짜 선택시 해당 날짜로 선택되는 메서드
	@PostMapping("/updateDate")
	@ResponseBody
	public Map<String, String> updateDate(@RequestBody Map<String, String> request) {
		String selectedDate = request.get("fullDate");
		
		Map<String, String> response = new HashMap<>();
		response.put("selectedDate", selectedDate);
		
		return response;
	}
	
	// 시간 선택시 해당 시간으로 선택되는 메서드
	@GetMapping("/getMovieShowTime")
	@ResponseBody
	public List<Map<String, Object>> getMovieShowTime( @RequestParam String movieName, @RequestParam String date ) {
		return bos.getMovieShowTimes(movieName, date);
	}
	
	// 좌석 예매 페이지 메서드
	@GetMapping("/seatBooking")
	public String seatBooking(@RequestParam("movieCd") String movieCd,
							@RequestParam("showtimeId") Integer showtimeId,
							@RequestParam("movie") String movie,
							@RequestParam("date") String date,
							@RequestParam("time") String time,
							Model model) {
		String moviePosterUrl = "";
		String sanitizedTime = time.trim().replaceAll(",", "");
		
		List<BookingDTO> seats = bks.getSeatsByMovieAndShowTime(movieCd, showtimeId);
		
		List<Map<String, Object>> seatsData = seats.stream()
                .map(seat -> {
                    Map<String, Object> seatInfo = new HashMap<>();
                    seatInfo.put("seatId", seat.getSeatId());
                    seatInfo.put("isReserved", seat.isReserved());
                    return seatInfo;
                })
                .collect(Collectors.toList());
		
		try {
			moviePosterUrl = getMoviePoster(movie);
		} catch( Exception e ) {
			e.printStackTrace();
		}
	    
		model.addAttribute("movie", movie);
		model.addAttribute("movieCd", movieCd);
		model.addAttribute("date", date);
		model.addAttribute("time", sanitizedTime);
		model.addAttribute("moviePoster", moviePosterUrl);
		model.addAttribute("seats", seatsData);
		
		return "booking/seatBooking";
	}
	
	// 영화 포스터 가져오는 메서드
	private String getMoviePoster(String movieName) throws Exception {
		if( movieName == null || movieName.isEmpty() ) {
			return "/resources/images/12.png";
		}
		
		String searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=" + tmdbApiKey + "&query=" + URLEncoder.encode(movieName, StandardCharsets.UTF_8);
		
		HttpClient client = HttpClient.newHttpClient();
        
        try {
        	 HttpRequest searchRequest = HttpRequest.newBuilder().uri(URI.create(searchUrl)).GET().build();
             HttpResponse<String> searchResponse = client.send(searchRequest, HttpResponse.BodyHandlers.ofString());
             
             ObjectMapper objectMapper = new ObjectMapper();
             HashMap<String, Object> searchResult = objectMapper.readValue(searchResponse.body(), HashMap.class);
             List<HashMap<String, Object>> results = (List<HashMap<String, Object>>) searchResult.get("results");
             
            if( results != null && !results.isEmpty() ) {
            	String posterPath = (String) results.get(0).get("poster_path");
            	if( posterPath != null && !posterPath.isEmpty() ) {
            		return "https://image.tmdb.org/t/p/w200" + posterPath;
            	}
            }
        } catch( Exception e ) {
            e.printStackTrace();
        }
        return "/resources/images/12.png";
	}
	
	// 결제 페이지 메서드
	@GetMapping("/paymentPage")
	public String paymentPage(@RequestParam("movie") String movie,
							@RequestParam("date") String date,
							@RequestParam("time") String time,
							@RequestParam("movieCd") String movieCd,
							@RequestParam("showtimeId") String showtimeId,
							@RequestParam("seats") String seats,
							@RequestParam("totalPrice") int totalPrice,
							Model model) {
		String moviePosterUrl = "";
	    try {
	        moviePosterUrl = getMoviePoster(movie);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    List<String> seatList = Arrays.asList(seats.split(","));
	    
		model.addAttribute("movie", movie);
		model.addAttribute("date", date);
		model.addAttribute("time", time);
		model.addAttribute("movieCd", movieCd);
		model.addAttribute("showtimeId", showtimeId);
		model.addAttribute("seats", String.join(",", seatList));
	    model.addAttribute("totalPrice", totalPrice);
	    model.addAttribute("moviePoster", moviePosterUrl);
		
		return "booking/paymentPage";
	}
	
	// 결제 팝업창 페이지 메서드
	@GetMapping("paymentPopup")
	public String paymentPopup(@RequestParam("movieCd") String movieCd,
							@RequestParam("showtimeId") Integer showtimeId,
							@RequestParam("seats") String seats,
							@RequestParam("totalPrice") int totalPrice,
							Model model) {
		List<String> seatList = Arrays.asList(seats.split(","));
		
		model.addAttribute("movieCd", movieCd);
		model.addAttribute("showtimeId", showtimeId);
		model.addAttribute("seats", seatList);
		model.addAttribute("totalPrice", totalPrice);
		
		model.addAttribute("kakaopayJavascriptKey", kakaopayJavascriptKey);
		model.addAttribute("tosspayClientKey", tosspayClientKey);
		
		model.addAttribute("paymentUrl", "카카오페이 결제 URL");
		
		return "booking/paymentPopup";
	}
	
	// 결제 메서드
	@PostMapping("/processPayment")
	public ResponseEntity<Map<String, Object>> processPayment(
	        @RequestParam("paymentType") String paymentType,
	        @RequestParam("movieCd") String movieCd,
	        @RequestParam("showtimeId") Integer showtimeId,
	        @RequestParam("seats") String seats,
	        @RequestParam("totalPrice") int totalPrice,
	        HttpSession session) {

	    session.setAttribute("movieCd", movieCd);
	    session.setAttribute("showtimeId", showtimeId);
	    session.setAttribute("seats", seats);

	    if ("kakao".equals(paymentType)) {
	        return processKakaoPay(totalPrice, session);
	    } else if ("toss".equals(paymentType)) {
	        return ResponseEntity.ok(Map.of("success", true, "useTossWidget", true));
	    } else {
	        return ResponseEntity.badRequest().body(Map.of("success", false, "message", "지원하지 않는 결제 방식입니다."));
	    }
	}
	
	// 카카오페이 결제 메서드
	@PostMapping("/processKakaoPay")
	public ResponseEntity<Map<String, Object>> processKakaoPay(int totalPrice, HttpSession session) {
		String kakaoPayHost = "https://kapi.kakao.com";
		
		try {
			RestTemplate restTemplate = new RestTemplate();
			HttpHeaders headers = new HttpHeaders();
			headers.set("Authorization", "KakaoAK " + kakaopayAdminKey);
			headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
			
			MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
			params.add("cid", "TC0ONETIME");
			params.add("partner_order_id", "1234567890");
			params.add("partner_user_id", "test_user");
			params.add("item_name", "영화 티켓");
			params.add("quantity", "1");
			params.add("total_amount", String.valueOf(totalPrice));
			params.add("tax_free_amount", "0");
			params.add("approval_url", "http://localhost:8080/movie/booking/kakaoSuccess");
			params.add("cancel_url", "http://localhost:8080/movie/booking/kakaoCancel");
			params.add("fail_url", "http://localhost:8080/movie/booking/kakaoFail");
			
			HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
            ResponseEntity<Map> response = restTemplate.exchange(kakaoPayHost + "/v1/payment/ready", HttpMethod.POST, request, Map.class);

            if (response.getBody() != null && response.getBody().containsKey("next_redirect_pc_url")) {
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("success", true);
                responseData.put("paymentUrl", response.getBody().get("next_redirect_pc_url"));

                String tid = (String) response.getBody().get("tid");
                session.setAttribute("tid", tid);
                
                return ResponseEntity.ok(responseData);
            } else {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "결제 실패"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "결제 요청 중 오류 발생"));
        }
	}
	
	// 카카오페이 결제 성공 메서드
	@GetMapping("kakaoSuccess")
	public String kakaoSuccess(@RequestParam("pg_token") String pgToken,
	                           HttpSession session,
	                           RedirectAttributes res) {
	    String kakaoPayHost = "https://kapi.kakao.com";

	    String tid = (String) session.getAttribute("tid");
	    String partner_order_id = "1234567890";
	    String partner_user_id = "test_user";
	    
	    RestTemplate restTemplate = new RestTemplate();
	    HttpHeaders headers = new HttpHeaders();
	    headers.set("Authorization", "KakaoAK " + kakaopayAdminKey);
	    headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

	    MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
	    params.add("cid", "TC0ONETIME");
	    params.add("tid", tid);
	    params.add("partner_order_id", partner_order_id);
	    params.add("partner_user_id", partner_user_id);
	    params.add("pg_token", pgToken);
	    
	    HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
	    ResponseEntity<Map> response = restTemplate.exchange(kakaoPayHost + "/v1/payment/approve", HttpMethod.POST, request, Map.class);

	    if (response.getBody() != null && response.getBody().containsKey("aid")) {
	        String movieCd = (String) session.getAttribute("movieCd");
	        Integer showtimeId = (Integer) session.getAttribute("showtimeId");
	        String seats = (String) session.getAttribute("seats");
	        String id = (String) session.getAttribute(LoginSession.LOGIN);

	        if (id == null) {
	            MemberDTO kakaoUser = (MemberDTO) session.getAttribute("loginMember");
	            if (kakaoUser != null) {
	                id = kakaoUser.getId();
	            }
	        }
	        Integer memberId = ms.getMemberIdById(id);
	        List<String> seatList = Arrays.asList(seats.split(","));

	        boolean result = bks.reservedSeats(movieCd, showtimeId, seatList, memberId);
	        if (result) {
	            res.addFlashAttribute("payment_success", "결제가 성공적으로 완료되었습니다.");
	            return "redirect:/main";
	        } else {
	            res.addFlashAttribute("seat_failed", "예약 실패");
	            return "redirect:/booking/fastBooking";
	        }
	    } else {
	        res.addFlashAttribute("payment_error", "결제 승인 실패");
	        return "redirect:/booking/fastBooking";
	    }
	}

	// 카카오페이 결제 취소 메서드
	@GetMapping("kakaoCancel")
	public String kakaoCancel(RedirectAttributes res) {
	    res.addFlashAttribute("payment_canceled", "결제가 취소되었습니다.");
	    return "redirect:/booking/payment";
	}

	// 카카오페이 결제 실패 메서드
	@GetMapping("kakaoFail")
	public String kakaoFail(RedirectAttributes res) {
	    res.addFlashAttribute("payment_failed", "결제에 실패했습니다.");
	    return "redirect:/booking/payment";
	}
	
	// 토스페이 결제 성공 메서드
	@GetMapping("tossSuccess")
	public String tossSuccess(@RequestParam("paymentKey") String paymentKey,
							@RequestParam("orderId") String orderId,
							@RequestParam("amount") int amount,
							@RequestParam("seats") String seats,
	                        @RequestParam("movieCd") String movieCd,
	                        @RequestParam("showtimeId") int showtimeId,
							HttpSession session,
							RedirectAttributes res) {
		String tossUrl = "https://api.tosspayments.com/v1/payments/confirm";
		
		HttpHeaders headers = new HttpHeaders();
		String encodedKey = Base64.getEncoder().encodeToString((tosspaySecretKey + ":").getBytes(StandardCharsets.UTF_8));
		headers.set("Authorization", "Basic " + encodedKey);
		headers.setContentType(MediaType.APPLICATION_JSON);
		
		 Map<String, Object> body = new HashMap<>();
		 body.put("paymentKey", paymentKey);
		 body.put("orderId", orderId);
		 body.put("amount", amount);
		 
		 HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);
		 RestTemplate restTemplate = new RestTemplate();
		 
		 try {
		        ResponseEntity<Map> response = restTemplate.postForEntity(tossUrl, request, Map.class);

		        if (response.getStatusCode() == HttpStatus.OK && response.getBody().get("status").equals("DONE")) {
		            String id = (String) session.getAttribute(LoginSession.LOGIN);
		            
		            if (id == null) {
		                MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
		                if (loginMember != null) {
		                    id = loginMember.getId();
		                }
		            }
		            Integer memberId = ms.getMemberIdById(id);
		            List<String> seatList = Arrays.asList(seats.split(","));

		            boolean result = bks.reservedSeats(movieCd, showtimeId, seatList, memberId);

		            if (result) {
		                res.addFlashAttribute("payment_success", "결제가 성공적으로 완료되었습니다.");
		                return "redirect:/main";
		            } else {
		                res.addFlashAttribute("seat_failed", "예약 실패");
		                return "redirect:/booking/fastBooking";
		            }
		        } else {
		            res.addFlashAttribute("payment_error", "결제 승인 실패");
		            return "redirect:/booking/fastBooking";
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        res.addFlashAttribute("payment_error", "결제 승인 중 오류 발생");
		        return "redirect:/booking/fastBooking";
		    }
	}
	
	// 토스페이 결제 실패 메서드
	@GetMapping("tossFail")
	public String tossFail(RedirectAttributes rs) {
		rs.addFlashAttribute("payment_failed", "결제에 실패했습니다.");
		return "redirect:/booking/payment";
	}
}
