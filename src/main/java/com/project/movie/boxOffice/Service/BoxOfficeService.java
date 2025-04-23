package com.project.movie.boxOffice.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface BoxOfficeService {
	public HashMap<String, Object> getDailyBoxOffice() throws Exception;
	public List<Map<String, String>> getTop10Movies() throws Exception;
	public HashMap<String, Object> getMovieInfo(String movieName) throws Exception;
	public String getMoviePosterUrl(String movieName) throws Exception;
	public List<String> getMovieTitles(String query);
	public void registerMovie( String movieName, LocalDate movieShowDate,String movieShowTime ) throws Exception;
	public List<Map<String, Object>> getMovieShowTimes(String movieName, String date);
}
