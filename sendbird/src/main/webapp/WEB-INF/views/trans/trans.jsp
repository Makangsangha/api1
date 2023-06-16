<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div id="google_translate_element" class="hd_lang"></div>
<div>
<p> 여기는 번역 사이트입니다.</p>
<table>
	<tr>
		<td>
			제육볶음	
		</td>	
	</tr>
	<tr>
		<td>
			국수	
		</td>	
	</tr>
	<tr>
		<td>
			떡볶이	
		</td>	
	</tr>
	<tr>
		<td>
			불고기	
		</td>	
	</tr>
</table>
김민욱
</div>
<script>
	function googleTranslateElementInit() {
		new google.translate.TranslateElement({
			pageLanguage: 'ko',
			includedLanguages: 'ko,zh-CN,zh-TW,ja,vi,th,tl,km,my,mn,ru,en,fr,ar',
			layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
			autoDisplay: false
		}, 'google_translate_element');
	}
</script>
</body>
</html>