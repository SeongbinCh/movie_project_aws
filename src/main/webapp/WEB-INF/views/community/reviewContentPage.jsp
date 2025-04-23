<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<%@ include file="../default/header.jsp" %>
<style type="text/css">
	.content_container {
	    display: flex;
	    justify-content: center;
	    align-items: flex-start;
	    height: auto;
	    padding: 20px;
	}
	
	.content_table {
	    border: 1px solid black;
	    width: 100%;
	    max-width: 850px;
	    background-color: #fff;
	    border-collapse: collapse;
	}
	
	.content_table th, .content_table td {
	    border: 1px solid #ccc;
	    padding: 8px;
	    text-align: center;
	    font-size: 14px;
	}
	
	.content_table th {
	    background-color: #f8f8f8;
	    font-weight: bold;
	}
	
	.col-1 { width: 125px; }
	.col-2 { width: 70px; }
	.col-3 { width: 80px; }
	.col-4 { width: 150px; }
	.col-5 { width: 80px; }
	.col-6 { width: 150px; }
	.col-7 { width: 80px; }
	.col-8 { width: 120px; }
	.col-9 { width: 80px; }
	.col-10 { width: 70px; }
	
	button[type="button"],
	button[type="submit"] {
	    border: 1px solid #585858;
	    background-color: transparent;
	    color: #585858;
	    border-radius: 0.25rem;
	    height: 30px;
	    width: auto;
	    padding: 0 10px;
	    font-size: 14px;
	    display: inline-flex;
	    align-items: center;
	    justify-content: center;
	}

	button[type="button"]:hover,
	button[type="submit"]:hover {
	    background-color: #585858;
	    color: white;
	}
	
	#reviewReplyContainer {
	    height: auto;
	    min-height: 200px;
	    padding: 15px;
	    background: #fafafa;
	    border-radius: 5px;
	}
	
	#reviewReply {
	    max-height: 300px;
	    overflow-y: auto;
	    padding: 10px;
	    border-radius: 5px;
	}
	
	.reply-input-container {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    padding: 10px 0;
	}
	
	.reply-input-container textarea {
	    flex: 1;
	    resize: none;
	    padding: 8px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    font-size: 14px;
	}
	
	.comment-list {
	    list-style: none;
	    margin: 0;
	    padding: 0;
	}
	
	.comment {
	    padding: 12px;
	    margin-bottom: 8px;
	    background-color: #f9f9f9;
	    border-radius: 5px;
	    border-left: 3px solid #ccc;
	}
	
	.comment-header {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    font-size: 14px;
	    font-weight: bold;
	    color: #444;
	}
	
	.comment-id {
	    margin-right: 10px;
	}
	
	.comment-date, .comment-time {
	    font-size: 12px;
	    color: #777;
	}
	
	.comment-content {
	    margin-top: 8px;
	    font-size: 14px;
	    color: #333;
	}
	
	.comment-buttons button {
		margin-left: 1px;
	}
	
	.reply_pagination {
	    display: flex;
	    justify-content: center;
	    padding: 10px 0;
	}
</style>
</head>
<body>
	<div class="content_container">
		<!-- 게시물글 상세 정보 -->
		<table class="content_table">
			<colgroup>
				<col class="col-1">
				<col class="col-2">
				<col class="col-3">
				<col class="col-4">
				<col class="col-5">
				<col class="col-6">
				<col class="col-7">
				<col class="col-8">
				<col class="col-9">
				<col class="col-10">
			</colgroup>
			
			<tr>
				<th>글번호</th><td>${ dto.review_no }</td>
				<th>아이디</th><td>${ dto.id }</td>
				<th>날짜</th><td>${ dto.review_date }</td>
				<th>시간</th><td>${ dto.review_time }</td>
				<th>조회수</th><td>${ dto.hit }</td>
			</tr>
			<tr>
				<th>카테고리</th><td colspan="9">${ dto.category }</td>
			</tr>
			<tr>
				<th>제목</th><td colspan="9">${ dto.title }</td>
			</tr>
			<tr>
				<th>내용</th><td colspan="9" style="height: 400px;">${ dto.content }</td>
			</tr>
			<tr>
				<td colspan="10" style="text-align: right;">
					<c:if test="${ login == dto.id }">
						<button type="button" onclick="location.href='reviewModifyPage?review_no=${ dto.review_no }'">수정</button>
						<button type="button" onclick="location.href='reviewDelete?review_no=${ dto.review_no }'">삭제</button>
					</c:if>
					<button type="button" onclick="location.href='reviewBoardList'">목록</button>
				</td>
			</tr>
			
			<!-- 댓글 -->
			<tr>
				<td id="reviewReplyContainer" colspan="10" style="text-align: center;">
					<div id="reviewReply">
						댓글이 없습니다
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="10">
					<form id="frm" class="reply-form">
						<input type="text" name="review_no" value="${ dto.review_no }" hidden="hidden"><br>
						<input type="text" id="parent_reply_no" name="parent_reply_no" hidden="hidden"><br>
						<b>작성자</b> ${ login } <br>
						
						<div class="reply-input-container">
							<textarea rows="3" cols="85" name="content" id="content" placeholder="댓글을 입력하세요"></textarea>
							<button type="button" onclick="rep()">등록</button>
						</div>
					</form>
				</td>
			</tr>
			<!-- 댓글 페이지네이션 -->
			<tr>
				<td colspan="10">
					<div class="reply_pagination">
						<nav aria-label="Page navigation example">
							<ul class="pagination" id="pagination"></ul>
						</nav>
					</div>
				</td>
			</tr>
		</table>
	</div>	
</body>
<script type="text/javascript">
	var currentPage = 1;
	var userId = "${ userId }";
	const isLogin = userId !== "";
	
	$(document).ready(function() {
		var urlParams = new URLSearchParams(window.location.search);
		currentPage = parseInt(urlParams.get("page")) || 1;
		
		loadComments(currentPage);
		loadCommentsPagination(currentPage);
	})
	
	function handleReplyButton(replyNo) {
		if( !isLogin ) {
			alert("로그인을 해주세요");
			return;
		}
		showReplyForm(replyNo);
	}
	
	function rep() {
		var formData = {
				reviewNo: $("input[name='review_no']").val(),
				content: $("#content").val(),
				parent_reply_no: $("#parent_reply_no").val() || null,
		};
		
		if (!formData.content.trim()) {
	        alert("댓글 내용을 입력해주세요.");
	        return;
	    }
		
		$.ajax({
			url: "/movie/community/addReviewReply",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify(formData),
			success: function(response) {
				alert(response.message);
				
				loadComments(currentPage);
				loadCommentsPagination();
				
				$("#content").val("");
			},
			error: function(xhr) {
				if( xhr.status === 401 ) {
					alert("로그인을 해주세요");
				} else {
					alert("댓글 등록 실패 : " + xhr.responseText);
				}
			}
		});
	}
	
	function loadComments(page = 1) {
	    var reviewNo = $("input[name='review_no']").val();
	    var size = 5;
	
	    $.ajax({
	        url: "/movie/community/reviewReplyData/" + reviewNo + "?page=" + page + "&size=" + size,
	        type: "GET",
	        success: function(response) {
	        	console.log("response : ", response);
	            var commentHtml = '';
	            var groupedComments = {};
	            
	            if (response.length === 0) {
	                commentHtml += "<p>댓글 없음</p>";
	            } else {
	                response.forEach(comment => {
	                    commentHtml += createCommentHtml(comment, false); // 부모 댓글
	                    if (comment.replies && comment.replies.length > 0) {
	                        comment.replies.forEach(reply => {
	                            commentHtml += createCommentHtml(reply, true); // 대댓글
	                        });
	                    }
	                });
	            }
		        
	            $("#reviewReplyContainer").html(commentHtml);
		        },
		        error: function(xhr, status, error) {
		            alert("댓글 불러오기 실패 : " + error);
		        }
		    });
		}
	
	function createCommentHtml(comment, isReply = false) {
	    var replyDate = comment.reply_date || "날짜 없음";
	    var replyTime = comment.reply_time || "시간 없음";
	    
	    var commentContent = comment.content || "내용 없음";
	    var paddingLeft = isReply ? "30px" : "0px";
	    var replyButtonHtml = "";
	    var modifyButton = "";
	    var deleteButton = "";
	    if( comment.depth === 0 ) {
	    	replyButtonHtml = "<button type='button' onclick='handleReplyButton(" + comment.reply_no + ")'>답글</button>";
	    }
	    
	    if( userId == comment.id ) {
	    	modifyButton = "<button type='button' onclick='showModifyForm(" + comment.reply_no + ")'>수정</button>";
	    	deleteButton = "<button type='button' onclick='replyDelete(" + comment.reply_no + ")'>삭제</button>";
	    }
	    
	    return "<ul class='comment-list' style='padding-left: " + paddingLeft + "; border-left: " + (isReply ? "1px solid #ccc" : "none") + ";'>" +
			        "<li class='comment'>" +
				        "<div class='comment-header'>" +
					        "<span class='comment-id'>" + comment.id + "</span>" +
					        "<span class='comment-date'>" + replyDate + "</span>" +
					        "<span class='comment-time'>" + replyTime + "</span>" +
				        "</div>" +
				        "<div class='comment-body' style='display: flex; justify-content: space-between; align-items: center;'>" +
				        	"<div class='comment-content' id='comment-content-" + comment.reply_no + "'>" + commentContent + "</div>" +
					        "<div class='comment-buttons'>" +
					        	replyButtonHtml + 
						        modifyButton +
					        	deleteButton +
					        "</div>" +
					    "</div>" +
				        "<div id='reply-form-" + comment.reply_no + "' style='display: none; margin-top: 10px;'></div>" +
			        "</li>" +
		        "</ul>";
	}
	
	function showReplyForm(parentReplyNo) {
	    var replyForm = $("#reply-form-" + parentReplyNo);
	    
	    if (replyForm.is(":visible")) {
	        replyForm.hide();
	    } else {
	        replyForm.html(
				"<textarea id='reply-content-" + parentReplyNo + "' name='content' placeholder='대댓글을 입력하세요' style='width: 100%; height: 60px;'></textarea>" +
		        "<button type='button' onclick='submitReply(" + parentReplyNo + ")'>등록</button>"
	        );
	        replyForm.show();
	    }
	}
	
	function submitReply(parentReplyNo) {
		var replyContent = $("#reply-content-" + parentReplyNo).val();
		
		var reviewNo = $("input[name='review_no']").val();
	    
		$.ajax({
			url: "/movie/community/addReviewReply",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify({
				parent_reply_no: parentReplyNo,
				content: replyContent,
				review_no: reviewNo
			}),
			success: function(response) {
				alert("대댓글이 등록되었습니다");
				loadComments();
			},
			error: function(xhr, status, error) {
				alert("대댓글 등록에 실패하였습니다");
			}
		});
	}
	
	function showModifyForm(replyNo) {
		var contentDiv = $("#comment-content-" + replyNo);
		
		if( contentDiv.find("textarea").length > 0 ) {
			var originalContent = contentDiv.data("originalContent");
			contentDiv.html(originalContent);
			return;
		}
		
		var commentContent = $("#comment-content-" + replyNo).text();
		contentDiv.data("originalContent", commentContent);
		
		var modifyFormHtml = 
							"<div class='comment-buttons'>" +
								"<textarea id='modify-textarea-" + replyNo + "' style='width: 650px; height: 50px;'>" + commentContent + "</textarea>" +
								"<div style='marin-top: 5px;'>" +
						        	"<button type='button' onclick='submitModify(" + replyNo + ")'>확인</button>" +
						        	"<button type='button' onclick='cancelModify(" + replyNo + ")'>취소</button>" +
						        "</div>" +
					        "</div>";
		contentDiv.html(modifyFormHtml);
	}
	
	function cancelModify(replyNo) {
		var contentDiv = $("#comment-content-" + replyNo);
		var originalContent = contentDiv.data("originalContent");
		contentDiv.html(originalContent);
	}
	
	function submitModify(replyNo) {
		var modifiedContent = $("#modify-textarea-" + replyNo).val();
		
		$.ajax({
			url: "/movie/community/modifyReviewReply",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify({ reply_no: replyNo, content: modifiedContent }),
			success: function(response) {
				alert("댓글이 수정되었습니다");
				$("#comment-content-" + replyNo).replaceWith(
		                "<div class='comment-content' id='comment-content-" + replyNo + "'>" + modifiedContent + "</div>"
		            );
			},
			error: function(xhr, status, error) {
				alert("댓글 수정 실패 : " + error);
			}
		});
	}
	
	function replyDelete(replyNo) {
		if( !confirm("정말로 삭제하시겠습니까?") ) {
			return;
		}
		
		$.ajax({
			url: "/movie/community/deleteReviewReply",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify({ reply_no : replyNo }),
			success: function(response) {
				if( response.success ) {
					alert("댓글이 삭제되었습니다");
					loadComments();
				} else {
					alert(response.message);
				}
			},
			error: function(xhr, status, error) {
				alert("댓글 삭제 실패 : " + error);
			}
		});
	}
	
	function loadCommentsPagination() {
		var reviewNo = $("input[name='review_no']").val();
		
		$.ajax({
			url: "/movie/community/reviewReplyCount/" + reviewNo,
			type: "GET",
			success: function(totalCount) {
				var pageCount = Math.ceil(totalCount / 5);
				
				var paginationHtml = '';
				
				// 이전 페이지 버튼
				if( currentPage > 1 ) {
					paginationHtml += "<li class='page-item'>" +
									"<a class='page-link' href='reviewContentPage?review_no=" + reviewNo + "&page=" + ( currentPage - 1 ) + "' aria-label='Previous'>" +
									"<span aria-hidden='true'>&laquo;</span>" +
									"</a>" +
									"</li>";
				} else {
					paginationHtml += "<li class='page-item disabled'>" +
	                				"<span class='page-link' aria-label='Previous'>" +
	                    			"<span aria-hidden='true'>&laquo;</span>" +
	                				"</span>" +
	              					"</li>";
				}
				
				// 페이지 번호 버튼
				for( var i = 1; i <= pageCount; i++ ) {
					paginationHtml += "<li class='page-item'><a class='page-link' href='#' onclick='loadComments(" + i + ")'>" + i + "</a></li>";
				}
				
				// 다음 페이지 버튼
				if (currentPage < pageCount) {
	            paginationHtml += "<li class='page-item'>" +
	                               	"<a class='page-link' href='reviewContentPage?review_no=" + reviewNo + "&page=" + (currentPage + 1) + "' aria-label='Next'>" +
	                               	"<span aria-hidden='true'>&raquo;</span>" +
	                               	"</a>" +
	                              	"</li>";
	            } else {
	                paginationHtml += "<li class='page-item disabled'>" +
	                                  	"<span class='page-link' aria-label='Next'>" +
	                                    "<span aria-hidden='true'>&raquo;</span>" +
	                                    "</span>" +
	                                  	"</li>";
	            }
				
				$("#pagination").html(paginationHtml);
			},
			error: function(xhr, status, error) {
				alert("댓글 페이징 실패 : " + error);
			}
		});
	}
</script>
</html>