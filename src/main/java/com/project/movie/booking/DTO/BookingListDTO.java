package com.project.movie.booking.DTO;

public class BookingListDTO {
	private String movieName, movieShowDate, movieShowTime, seatInfo;
	
	public BookingListDTO() {}
	
	public BookingListDTO(String movieName, String seatInfo, String movieShowDate, String movieShowTime) {
	        this.movieName = movieName;
	        this.seatInfo = seatInfo;
	        this.movieShowDate = movieShowDate;
	        this.movieShowTime = movieShowTime;
	}
	
	public String getMovieName() {
		return movieName;
	}
	public void setMovieName(String movieName) {
		this.movieName = movieName;
	}
	public String getMovieShowTime() {
		return movieShowTime;
	}
	public void setMovieShowTime(String movieShowTime) {
		this.movieShowTime = movieShowTime;
	}
	public String getSeatInfo() {
		return seatInfo;
	}
	public void setSeatInfo(String seatInfo) {
		this.seatInfo = seatInfo;
	}
	public String getMovieShowDate() {
		return movieShowDate;
	}
	public void setMovieShowDate(String movieShowDate) {
		this.movieShowDate = movieShowDate;
	}
	
	public String toString() {
        return "BookingListDTO [movieName=" + movieName + ", seatInfo=" + seatInfo 
            + ", movieShowDate=" + movieShowDate + ", movieShowTime=" + movieShowTime + "]";
    }
}
