package com.project.movie.community.DTO;

import java.time.LocalDate;
import java.time.LocalTime;

public class ReviewBoardDTO {
	private int review_no;
	private long hit;
	private String id, title, content, category;
	private LocalDate review_date;
	private LocalTime review_time;
	
	public int getReview_no() {
		return review_no;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public void setReview_no(int review_no) {
		this.review_no = review_no;
	}
	public long getHit() {
		return hit;
	}
	public void setHit(long hit) {
		this.hit = hit;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public LocalTime getReview_time() {
		return review_time;
	}
	public void setReview_time(LocalTime review_time) {
		this.review_time = review_time;
	}
	public LocalDate getReview_date() {
		return review_date;
	}
	public void setReview_date(LocalDate review_date) {
		this.review_date = review_date;
	}
}
