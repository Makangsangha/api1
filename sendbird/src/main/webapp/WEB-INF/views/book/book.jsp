<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<body>
	<c:if test="${not empty bvo }">
		<script type="text/javascript">
			alert("삽입 완료");
		</script>
	</c:if>
	<h2>book</h2>
	<p></p>	
	
	<input type="text" id="bookId" placeholder="책 검색 하기">
	<button id="bookBtn">검색하기</button>
	
	<form id="bookForm" action="/book" method="post">
		<input type="hidden" id='name' name="book_name">
		<input type="hidden" id='cover' name="book_cover">
		<input type="hidden" id='isbn' name="book_isbn">
		<input type="hidden" id='date' name="book_date">
		<input type="hidden" id='price' name="book_price">
		<input type="hidden" id='author' name="book_author">
		<input type="hidden" id='summary' name="book_summary">
		<input type="hidden" id='publisher' name="book_publisher">
		<input type="button" id="btn" value="제출">
	</form>
	
	<table border="1">
		<thead>
			 <tr>
				<td>책 번호</td>
				<td>책 제목</td>
				<td>책 isbn</td>
				<td>책 발행일</td>
				<td>책 가격</td>
				<td>책 작가</td>
				<td>책 내용</td>
				<td>책 출판사</td>
				<td>책 사진</td>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${bvo }" var="bvo">
				<tr>
					<td>${bvo.book_num }</td>
					<td>${bvo.book_name }</td>
					<td>${bvo.book_isbn }</td>
					<td>${bvo.book_date }</td>
					<td>${bvo.book_price }</td>
					<td>${bvo.book_author }</td>
					<td>${bvo.book_summary }</td>
					<td>${bvo.book_publisher }</td>
					<td><img src="${bvo.book_cover }" ></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</body>
<script type="text/javascript">
$(function(){
	var btn = $("#btn");
	var bookBtn = $("#bookBtn");
	
	bookBtn.on("click", function(){
		var bookId = $("#bookId").val();
		$.ajax({
			type : "get",
			url : "https://dapi.kakao.com/v3/search/book?target=title",
			data : {
				query : bookId
			},
			headers : {
				Authorization : "KakaoAK de3f93057e79cda997a80fe332c0e815"
			}
		})
		.done(function(msg){
			console.log(msg.documents[0].title);
			console.log(msg.documents[0].thumbnail);
			$("p").append("<strong id='book_name'>"+msg.documents[0].title+"</strong><br>");
			$("p").append("<img id='book_cover' src='"+msg.documents[0].thumbnail+"'/><br>");
			$("p").append("<strong id='book_author'>"+msg.documents[0].authors+"</strong><br>");
			$("p").append("<strong id='book_summary'>"+msg.documents[0].contents+"</strong><br>");
			$("p").append("<strong id='book_date'>"+msg.documents[0].datetime+"</strong><br>");		
			$("p").append("<strong id='book_isbn'>"+msg.documents[0].isbn+"</strong><br>");		
			$("p").append("<strong id='book_price'>"+msg.documents[0].price+"</strong><br>");		
			$("p").append("<strong id='book_publisher'>"+msg.documents[0].publisher+"</strong><br>");
			
			
		})
	})

	
	btn.on('click', function(){
		var book_name = $("#book_name").text();
		var book_cover = $("#book_cover").attr("src");
		var book_author = $("#book_author").text();
		var book_summary = $("#book_summary").text();
		var book_date = $("#book_date").text();
		var book_isbn = $("#book_isbn").text();
		var book_price = $("#book_price").text();
		var book_publisher = $("#book_publisher").text();
		
		$("#name").val(book_name);
		$("#cover").val(book_cover);
		$("#isbn").val(book_isbn);
		$("#date").val(book_date);
		$("#price").val(book_price);
		$("#author").val(book_author);
		$("#summary").val(book_summary);
		$("#publisher").val(book_publisher);
		
		console.log($("#name").val());
		
		$("#bookForm").submit();
	})

})
</script>

</html>