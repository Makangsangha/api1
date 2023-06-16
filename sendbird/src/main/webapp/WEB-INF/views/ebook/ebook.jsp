<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.6.347/pdf.min.js"></script>
<script type="text/javascript" src="../resources/turnjs/lib/turn.js"></script>
<style>
 .flipbook .next-button,.flipbook .previous-button{
	width:22px;
	height:100%;
	position:absolute;
	top:0;
	background-repeat:no-repeat;
}
.flipbook .previous-button{
	background-position:-4px center;
	left:-22px;
	-webkit-border-radius:15px 0 0 15px;
	-moz-border-radius:15px 0 0 15px;
	-ms-border-radius:15px 0 0 15px;
	-o-border-radius:15px 0 0 15px;
	border-radius:15px 0 0 15px;
}
.flipbook .next-button {
	background-position:-38px center;
	right:-22px;
	-webkit-border-radius:0 15px 15px 0;
	-moz-border-radius:0 15px 15px 0;
	-ms-border-radius:0 15px 15px 0;
	-o-border-radius:0 15px 15px 0;
	border-radius:0 15px 15px 0;
}

.flipbook .previous-button-hover{background-color:rgba(0,0,0,0.2);background-image:url('../images/pc/arrows.png');}
.flipbook .next-button-hover{background-color:rgba(0,0,0,0.2);background-image:url('../images/pc/arrows.png');}
.flipbook .even .gradient {
	position:absolute;top:0;left:0;width:100%;height:100%;
	background:-webkit-gradient(linear,left top,right top,color-stop(0.95,rgba(0,0,0,0)),color-stop(1,rgba(0,0,0,0.2)));
	background-image:-webkit-linear-gradient(left,rgba(0,0,0,0) 95%,rgba(0,0,0,0.2) 100%);
	background-image:-moz-linear-gradient(left,rgba(0,0,0,0) 95%,rgba(0,0,0,0.2) 100%);
	background-image:-ms-linear-gradient(left,rgba(0,0,0,0) 95%,rgba(0,0,0,0.2) 100%);
	background-image:-o-linear-gradient(left,rgba(0,0,0,0) 95%,rgba(0,0,0,0.2) 100%);
	background-image:linear-gradient(left,rgba(0,0,0,0) 95%,rgba(0,0,0,0.2) 100%)}
.flipbook .odd .gradient {position:absolute;top:0;left:0;width:100%;height:100%;
	background:-webkit-gradient(linear,right top,left top,color-stop(0.95,rgba(0,0,0,0)),color-stop(1,rgba(0,0,0,0.15)));
	background-image:-webkit-linear-gradient(right,rgba(0,0,0,0) 95%,rgba(0,0,0,0.15) 100%);
	background-image:-moz-linear-gradient(right,rgba(0,0,0,0) 95%,rgba(0,0,0,0.15) 100%);
	background-image:-ms-linear-gradient(right,rgba(0,0,0,0) 95%,rgba(0,0,0,0.15) 100%);
	background-image:-o-linear-gradient(right,rgba(0,0,0,0) 95%,rgba(0,0,0,0.15) 100%);
	background-image:linear-gradient(right,rgba(0,0,0,0) 95%,rgba(0,0,0,0.15) 100%)
}
</style>

<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<div class="flip_book flipbook"></div>

	<div id="controls">
		<label for="page-number">Page:</label>
		<input type="text" size="3" class="page-number"> of <span class="number-pages"></span>
	</div>
	

<script type="text/javascript">

	var numberOfPages = 0;
	var url = '../resources/libray1.pdf';

	var rendered = [];
	var firstPagesRendered = false;

	var pdf 		= null;
	var pageNum = 1;
	// 크기 조절
	var scale 	= 0.8;

	$(document).ready(function(){

		pdfjsLib.getDocument(url).promise.then(function(pdfDoc) {
			console.log(pdfDoc);
			numberOfPages = pdfDoc.numPages;
			pdf = pdfDoc;

			$('.flip_book').turn.pages = numberOfPages;

			$('.flip_book').turn({
				width: 1248,
				height: 430,
				acceleration: false,
				pages: numberOfPages,
				elevation: 50,
				gradients: !$.isTouch,
				when: {
					turning: function(e, page, view) {
						var range = $(this).turn('range', page);
						for (page = range[0]; page<=range[1]; page++) {
							addPage(page, $(this));
						};
					},
					turned: function(e, page) {
						$('.page-number').val(page);
						if (firstPagesRendered) {
							var range=$(this).turn('range', page);
							for (page=range[0]; page<=range[1]; page++) {
								if (!rendered[page]) {
									renderPage(page); rendered[page]=true;
								}
							};
						}
					}, missing : function(e, page){

						var n = numberOfPages;
						n = n > 6 ? (6 + 1) : n;
						for (var page = 1; page < n; page++){
							addPage(page, $(this));
							renderPage(page);
							rendered[page] = true;
						}
						firstPagesRendered = true;
					}
				}
			});

			$('.number-pages').html(numberOfPages);
			$('.page-number').keydown(function(e){
				var p = $('#page-number').val();
				if (e.keyCode==13) {
					$('.flip_book').turn('page', p);
					renderPage(p);
				}
			});
		});
	});

	$(document).keydown(function(e){
		if (e.target && e.target.tagName.toLowerCase()!='input'){
			if (e.keyCode==37){
				$('.flip_book').turn('previous');
			} else if (e.keyCode==39) {
				$('.flip_book').turn('next');
			}
		}
	});

	function renderPage(num) {

		pdf.getPage(num).then(function(page) {
			viewport = page.getViewport({scale : scale});

			var canvasID = 'canv' + num;
			var canvas = $('#' + canvasID)[0];

			if (canvas == null){
				return;
			}

			var context = canvas.getContext('2d');

			canvas.height = viewport.height;
			canvas.width = viewport.width;

			var renderContext = {
				canvasContext: context,
				viewport: viewport
			};

			page.render(renderContext);

			// rendering 여부 확인
			var renderTask = page.render(renderContext);
			renderTask.promise.then(function () {
				console.log(canvasID+'Page rendered');
			});

			$('.page-number').text(pageNum);
			$('.number-pages').text(pdf.numPages);
			// 플립북 pdf사이즈에 맞게 재조절
			$('.flip_book').turn('size',(canvas.width * 2), canvas.height)
		});
	}

	function addPage(page, book) {
		if (!book.turn('hasPage', page)) {
			var element = $('<div />', {'id': 'page-'+page});
			element.html('<div class="data"><canvas id="canv' + page + '"></canvas></div><div class="gradient"></div>');
			book.turn('addPage', element, page);
		}
		
	}
	pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.6.347/pdf.worker.min.js';
</script>
</body>

</html>
