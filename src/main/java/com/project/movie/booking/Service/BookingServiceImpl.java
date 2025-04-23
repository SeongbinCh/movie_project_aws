package com.project.movie.booking.Service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.project.movie.booking.DTO.BookingDTO;
import com.project.movie.booking.DTO.BookingListDTO;
import com.project.movie.booking.Mybatis.BookingMapper;

@Service
public class BookingServiceImpl  implements BookingService{
	@Autowired
	private BookingMapper mapper;
	
	// movieCd와 showtimeId에 해당하는 좌석 목록 조회
	public List<BookingDTO> getSeatsByMovieAndShowTime(String movieCd, Integer showtimeId) {
		return mapper.getSeatsByMovieAndShowtime(movieCd, showtimeId);
	}
	
	// 좌석 예약
	@Transactional
	public boolean reservedSeats(String movieCd, Integer showtimeId, List<String> seatList, Integer memberId) {
		for( String seatId : seatList ) {
			int count = mapper.checkSeat( movieCd, showtimeId, seatId );
			if( count > 0 ) {
				return false;
			}
		}
		
		for( String seatId : seatList ) {
			boolean result = mapper.updateSeatReservation( movieCd, showtimeId, seatId, memberId );
		}
		return true;
	}
	
	// 예매한 목록 조회
	public List<BookingListDTO> getBookingList(int memberId) {
		return mapper.getBookingList(memberId);
	}
	
	// 예매 취소
	public boolean cancelBooking(String[] seatIds) {
		int result = 0;
		for( String seatId : seatIds ) {
			result += mapper.cancelBooking(seatId);
		}
		
		return result == seatIds.length;
	}
}
