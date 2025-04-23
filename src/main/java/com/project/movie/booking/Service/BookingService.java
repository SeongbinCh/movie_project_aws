package com.project.movie.booking.Service;

import java.util.List;

import com.project.movie.booking.DTO.BookingDTO;
import com.project.movie.booking.DTO.BookingListDTO;

public interface BookingService {
	public List<BookingDTO> getSeatsByMovieAndShowTime(String movieCd, Integer showtimeId);
	public boolean reservedSeats(String movieCd, Integer showtimeId, List<String> seatList, Integer memberId);
	public List<BookingListDTO> getBookingList(int memberId);
	public boolean cancelBooking(String[] seatIds);
}
