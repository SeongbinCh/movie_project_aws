package com.project.movie.boxOffice.DTO;

import java.time.LocalDate;
import java.time.LocalTime;

public class BoxOfficeDTO {
	private int movieId;
	private String movieName;
	private LocalDate movieShowDate;
	private LocalTime movieShowTime;
	
	public int getMovieId() {
		return movieId;
	}
	public void setMovieId(int movieId) {
		this.movieId = movieId;
	}
	public String getMovieName() {
		return movieName;
	}
	public void setMovieName(String movieName) {
		this.movieName = movieName;
	}
	public LocalDate getMovieShowDate() {
		return movieShowDate;
	}
	public void setMovieShowDate(LocalDate movieShowDate) {
		this.movieShowDate = movieShowDate;
	}
	public LocalTime getMovieShowTime() {
		return movieShowTime;
	}
	public void setMovieShowTime(LocalTime movieShowTime) {
		this.movieShowTime = movieShowTime;
	}
}
