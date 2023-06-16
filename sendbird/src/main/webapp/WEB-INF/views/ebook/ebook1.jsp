<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<script type="text/javascript" src="../resources/turnjs/lib/turn.js"></script>
<style type="text/css">
	body{
		background: #9988aa;
	}
	#book{
		width:2000px;
		height:1000px;
	}
	
	#book .turn-page{
		background-color:#ddd;
		background-size:50% 50%;
	}
</style>
</head>
<body>
	<div id="book">
		<div style="background-image:url('../resources/1001.png');"></div>
		<div style="background-image:url('../resources/1002.png');"></div>
		<div style="background-image:url('../resources/1003.png');"></div>
		<div style="background-image:url('../resources/1004.png');"></div>
		<div style="background-image:url('../resources/1005.png');"></div>
		<div style="background-image:url('../resources/1006.png');"></div>
		<div style="background-image:url('../resources/1007.png');"></div>
	</div>

</body>

<script type="text/javascript">
	$(window).ready(function(){
		$('#book').turn({
			display: 'basic',
			acceleration: true,
			elevation:50
		});
	});
	
	$(window).bind('keydown', function(e){
		if(e.keyCode==37)
			$("#book").turn('previous');
		else if(e.keyCode==39)
			$('#book').turn('next');
	})
</script>
</html>