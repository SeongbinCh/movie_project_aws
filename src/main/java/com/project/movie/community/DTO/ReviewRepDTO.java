package com.project.movie.community.DTO;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;

public class ReviewRepDTO {
	private int reply_no, write_group, depth, order_no, memberId;
	private Boolean userId;
	@JsonProperty("reviewNo")
	private int review_no;
	private Integer parent_reply_no;
	private String id, content, replyDateStr, replyTimeStr;
	@JsonFormat(pattern = "yyyy-MM-dd")
	private LocalDate reply_date;
	@JsonFormat(pattern = "HH:mm:ss")
	private LocalTime reply_time;
	
	private List<ReviewRepDTO> replies = new ArrayList<>();
	
	public int getReply_no() {
		return reply_no;
	}
	public void setReply_no(int reply_no) {
		this.reply_no = reply_no;
	}
	
	public Integer getParent_reply_no() {
		return parent_reply_no;
	}
	public void setParent_reply_no(Integer parent_reply_no) {
		this.parent_reply_no = parent_reply_no;
	}
	public int getWrite_group() {
		return write_group;
	}
	public void setWrite_group(int write_group) {
		this.write_group = write_group;
	}
	public int getDepth() {
		return depth;
	}
	public void setDepth(int depth) {
		this.depth = depth;
	}
	public int getOrder_no() {
		return order_no;
	}
	public void setOrder_no(int order_no) {
		this.order_no = order_no;
	}
	public int getReview_no() {
		return review_no;
	}
	public void setReview_no(int review_no) {
		this.review_no = review_no;
	}
	public int getMemberId() {
		return memberId;
	}
	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getReplyDateStr() {
		return replyDateStr;
	}
	public void setReplyDateStr(String replyDateStr) {
		this.replyDateStr = replyDateStr;
	}
	public String getReplyTimeStr() {
		return replyTimeStr;
	}
	public void setReplyTimeStr(String replyTimeStr) {
		this.replyTimeStr = replyTimeStr;
	}
	public LocalDate getReply_date() {
		return reply_date;
	}
	public void setReply_date(LocalDate reply_date) {
		this.reply_date = reply_date;
	}
	public LocalTime getReply_time() {
		return reply_time;
	}
	public void setReply_time(LocalTime reply_time) {
		this.reply_time = reply_time;
	}
	public Boolean getUserId() {
		return userId;
	}
	public void setUserId(Boolean userId) {
		this.userId = userId;
	}
	public List<ReviewRepDTO> getReplies() {
		return replies;
	}
	public void setReplies(List<ReviewRepDTO> replies) {
		this.replies = replies;
	}
}
