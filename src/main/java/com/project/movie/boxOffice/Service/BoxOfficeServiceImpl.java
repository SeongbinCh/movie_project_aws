package com.project.movie.boxOffice.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.project.movie.boxOffice.Mybatis.BoxOfficeMapper;

import kr.or.kobis.kobisopenapi.consumer.rest.KobisOpenAPIRestService;

@Service
public class BoxOfficeServiceImpl implements BoxOfficeService {
	@Value("${kofic.api.key}")
	private String koficApiKey;
	
	@Value("${tmdb.api.key}")
	private String tmdbApiKey;
	
	private final KobisOpenAPIRestService service;
	private List<String> movieNames = Arrays.asList("Movie 1", "Movie 2", "Movie 3", "Movie 4", "Movie 5");
	private final HttpClient client;
	private List<Map<String, String>> cachedTop10Movies = new ArrayList<>();
	private String lastUpdatedDate = null;
	
	@Autowired BoxOfficeMapper mapper;
	
	public BoxOfficeServiceImpl(@Value("${kofic.api.key}") String koficApiKey) {
		this.service = new KobisOpenAPIRestService(koficApiKey);
		this.client = HttpClient.newHttpClient();
	}
	
	// 일일 박스 오피스 가져오는 메서드
	@Override
	public HashMap<String, Object> getDailyBoxOffice() throws Exception {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String targetDt = dateFormat.format(cal.getTime());
		
		String dailyResponse = service.getDailyBoxOffice(true, targetDt, "10", "N", "K", "");
		ObjectMapper mapper = new ObjectMapper();
		
		return mapper.readValue(dailyResponse, HashMap.class);
	}
	
	// 인기 순위 10 가져오는 메서드
	public List<Map<String, String>> getTop10Movies() throws Exception {
		LocalDate today = LocalDate.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
		String targetDate = today.minusDays(1).format(formatter);
		
		if (lastUpdatedDate != null && lastUpdatedDate.equals(targetDate)) {
	        return cachedTop10Movies;
	    }

	    String apiUrl = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
	            + "?key=" + koficApiKey + "&targetDt=" + targetDate;

	    HttpClient client = HttpClient.newHttpClient();
	    HttpRequest request = HttpRequest.newBuilder().uri(URI.create(apiUrl)).GET().build();
	    HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

	    ObjectMapper mapper = new ObjectMapper();
	    HashMap<String, Object> koficResponseData = mapper.readValue(response.body(), HashMap.class);
	    HashMap<String, Object> boxOfficeResult = (HashMap<String, Object>) koficResponseData.get("boxOfficeResult");
	    List<HashMap<String, Object>> movieList = (List<HashMap<String, Object>>) boxOfficeResult.get("dailyBoxOfficeList");

	    List<Map<String, String>> topMovies = new ArrayList<>();
	    List<CompletableFuture<Void>> futures = new ArrayList<>();

	    for (int i = 0; i < Math.min(movieList.size(), 10); i++) {
	        HashMap<String, Object> movie = movieList.get(i);
	        String movieCd = (String) movie.get("movieCd");

	        CompletableFuture<Void> future = CompletableFuture.supplyAsync(() -> {
	            try {
	                String movieNm = getMovieNmFromAPI(movieCd);
	                String posterUrl = getMoviePosterUrl(movieNm);

	                Map<String, String> movieData = new HashMap<>();
	                movieData.put("title", movieNm);
	                movieData.put("posterUrl", posterUrl);
	                synchronized (topMovies) {
	                    topMovies.add(movieData);
	                }
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	            return null;
	        });

	        futures.add(future);
	    }

	    CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).join();

	    cachedTop10Movies = topMovies;
	    lastUpdatedDate = targetDate;

	    return topMovies;
	}
	
	// 외부에서 인기 순위 10을 가져오는 메서드 
	public List<Map<String, String>> fetchTop10MoviesFromApi() throws Exception {
	    LocalDate today = LocalDate.now().minusDays(1); 
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
	    String targetDate = today.format(formatter);

	    String apiUrl = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
	            + "?key=" + koficApiKey + "&targetDt=" + targetDate;

	    HttpClient client = HttpClient.newHttpClient();
	    HttpRequest request = HttpRequest.newBuilder().uri(URI.create(apiUrl)).GET().build();
	    HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

	    ObjectMapper mapper = new ObjectMapper();
	    HashMap<String, Object> koficResponseData = mapper.readValue(response.body(), HashMap.class);
	    HashMap<String, Object> boxOfficeResult = (HashMap<String, Object>) koficResponseData.get("boxOfficeResult");
	    List<HashMap<String, Object>> movieList = (List<HashMap<String, Object>>) boxOfficeResult.get("dailyBoxOfficeList");

	    List<Map<String, String>> topMovies = new ArrayList<>();
	    List<CompletableFuture<Void>> futures = new ArrayList<>();

	    for (int i = 0; i < Math.min(movieList.size(), 10); i++) {
	        HashMap<String, Object> movie = movieList.get(i);
	        String movieCd = (String) movie.get("movieCd");

	        CompletableFuture<Void> future = CompletableFuture.supplyAsync(() -> {
	            try {
	                String movieNm = getMovieNmFromAPI(movieCd);
	                String posterUrl = getMoviePosterUrl(movieNm);

	                Map<String, String> movieData = new HashMap<>();
	                movieData.put("title", movieNm);
	                movieData.put("posterUrl", posterUrl);
	                topMovies.add(movieData);
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	            return null;
	        });

	        futures.add(future);
	    }

	    CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).join();

	    return topMovies;
	}
	
	// movieCd에 해당하는 영화 제목 조회 메서드
	public String getMovieNmFromAPI(String movieCd) throws Exception {
	    String apiUrl = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieInfo.json"
	            + "?key=" + koficApiKey + "&movieCd=" + movieCd;

	    HttpClient client = HttpClient.newHttpClient();
	    HttpRequest request = HttpRequest.newBuilder().uri(URI.create(apiUrl)).GET().build();
	    HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

	    ObjectMapper mapper = new ObjectMapper();
	    HashMap<String, Object> koficResponseData = mapper.readValue(response.body(), HashMap.class);
	    HashMap<String, Object> movieInfoResult = (HashMap<String, Object>) koficResponseData.get("movieInfoResult");
	    HashMap<String, Object> movieInfo = (HashMap<String, Object>) movieInfoResult.get("movieInfo");
	    
	    return (String) movieInfo.get("movieNm");
	}
	
	// movieName에 해당하는 영화 코드 조회 메서드
	public String getMovieCdFromAPI(String movieName) throws Exception {
		KobisOpenAPIRestService service = new KobisOpenAPIRestService(koficApiKey);
		
		Map<String, String> searchParams = new HashMap<>();
		searchParams.put("movieNm", movieName);
		
		String responseJson = service.getMovieList(true, searchParams);
		
		ObjectMapper mapper = new ObjectMapper();
		HashMap<String, Object> response = mapper.readValue(responseJson, HashMap.class);
		
		List<HashMap<String, Object>> movieList =
				(List<HashMap<String, Object>>) ((HashMap<String, Object>) response.get("movieListResult")).get("movieList");
		
		if( movieList.isEmpty() ) {
			return null;
		}
		
		return (String) movieList.get(0).get("movieCd");
	}
	
	// 영화 정보 가져오는 메서드
	public HashMap<String, Object> getMovieInfo(String movieName) throws Exception {
		String movieCd = getMovieCdFromAPI(movieName);
		if( movieCd == null ) {
			throw new Exception("해당 영화의 movieCd를 찾을 수 없습니다.");
		}
		
		KobisOpenAPIRestService service = new KobisOpenAPIRestService(koficApiKey);
		String movieInfoJson = service.getMovieInfo(true, movieCd);
		
		ObjectMapper mapper = new ObjectMapper();
		HashMap<String, Object> movieInfo = mapper.readValue(movieInfoJson, HashMap.class);
		HashMap<String, Object> movieDetails = (HashMap<String, Object>) ((HashMap<String, Object>) movieInfo.get("movieInfoResult")).get("movieInfo");
		
		String posterUrl = getMoviePosterUrl(movieName);
		
		HashMap<String, Object> result = new HashMap<>();
		result.put("movieCd", movieCd);
		result.put("movieInfo", movieDetails);
		result.put("posterUrl", posterUrl);
		
		return result;
	}
	
	// 영화 포스터 url 가져오는 메서드
	public String getMoviePosterUrl(String movieName) throws Exception {
		String apiUrl = "https://api.themoviedb.org/3/search/movie?api_key=" + tmdbApiKey + "&query=" + URLEncoder.encode(movieName, "UTF-8");
		
		HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder().uri(URI.create(apiUrl)).GET().build();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        
        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> tmdbResponseData = mapper.readValue(response.body(), HashMap.class);
        List<Map<String, Object>> tmdbResults = (List<Map<String, Object>>) tmdbResponseData.get("results");
	
        if( !tmdbResults.isEmpty() ) {
        	Map<String, Object> firstResult = tmdbResults.get(0);
        	String posterPath = (String) firstResult.get("poster_path");
        	
        	if( posterPath != null && !posterPath.isEmpty() ) {
        		return "https://image.tmdb.org/t/p/w342" + posterPath;
        	}
        }
        
        return "https://csb-movie-images.s3.ap-southeast-2.amazonaws.com/default-image.png";
	}
	
	// 영화 제목 가져오는 메서드
	public List<String> getMovieTitles(String query) {
		String apiUrl = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json"
				+ "?key=" + koficApiKey
				+ "&movieNm="+ URLEncoder.encode(query, StandardCharsets.UTF_8);
		
		List<String> movieTitles = new ArrayList<>();
		
		try {
			URL url = new URL(apiUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String response = br.lines().collect(Collectors.joining());
			br.close();
			
			JSONObject json = new JSONObject(response);
			JSONArray movieList = json.getJSONObject("movieListResult").getJSONArray("movieList");
			
			for (int i = 0; i < movieList.length(); i++) {
	            JSONObject movie = movieList.getJSONObject(i);
	            movieTitles.add(movie.getString("movieNm"));
	        }
		} catch( Exception e ) {
			e.printStackTrace();
		}
		
		return movieTitles;
	}
	
	// 영화 등록 메서드
	public void registerMovie( String movieName, LocalDate movieShowDate,String movieShowTime ) throws Exception {
		Integer movieId = mapper.getMovieIdByName(movieName);
		String movieCd = getMovieCdFromAPI(movieName);
		
		if( movieCd == null ) {
			throw new Exception("해당 영화의 movieCd를 찾을 수 없습니다");
		}
		
		if( movieId == null ) {
			mapper.insertMovie(movieName, movieCd);
			movieId = mapper.getMovieIdByName(movieName);
		}
		
		mapper.insertShowTime(movieId, movieCd, movieShowDate, movieShowTime);
	}
	
	// 영화 상영시간 가져오는 메서드
	public List<Map<String, Object>> getMovieShowTimes( String movieName, String date ) {
		Integer movieId = mapper.getMovieIdByName(movieName);
		if( movieId == null ) {
			throw new IllegalArgumentException("해당 영화가 없습니다: " + movieName);
		}
		
		return mapper.getMovieShowTimes( movieId, date );
	}
}
