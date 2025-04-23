package com.project.movie.boxOffice.Mybatis;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface BoxOfficeMapper {
	public void insertMovie( @Param("movieName") String movieName, @Param("movieCd") String movieCd );
	public void insertShowTime( @Param("movieId") Integer movieId, @Param("movieCd") String movieCd, @Param("movieShowDate") LocalDate movieShowDate, @Param("movieShowTime") String movieShowTime );
	public Integer getMovieIdByName( @Param("movieName") String movieName );
	public List<Map<String, Object>> getMovieShowTimes( @Param("movieId") Integer movieId, @Param("date") String date );
}
