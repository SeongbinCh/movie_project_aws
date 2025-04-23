package com.project.movie.booking.Mybatis;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.project.movie.booking.DTO.BookingDTO;
import com.project.movie.booking.DTO.BookingListDTO;

@Mapper
public interface BookingMapper {
	public List<BookingDTO> getSeatsByMovieAndShowtime(@Param("movieCd") String movieCd, @Param("showtimeId") Integer showtimeId);
	public int checkSeat(@Param("movieCd") String movieCd, @Param("showtimeId") Integer showtimeId, @Param("seatId") String seatId);
	public boolean updateSeatReservation(@Param("movieCd") String movieCd, @Param("showtimeId") Integer showtimeId, @Param("seatId") String seatId, @Param("memberId") Integer memberId);
	public List<BookingListDTO> getBookingList(@Param("memberId") int memberId);
	public int cancelBooking(@Param("seatId") String seatId);
	public void deleteBooking(Integer memberId);
}
