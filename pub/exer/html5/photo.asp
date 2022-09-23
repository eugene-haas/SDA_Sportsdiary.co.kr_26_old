<!doctype html>
<html lang="ko">

 <head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>test</title>

<meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

<link href="/plugins/JQueryUI/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<script src="/plugins/jQuery/jQuery-2.2.0.min.js"></script><!-- jQuery 2.2.0 -->
<script src="/plugins/JQueryUI/jquery-ui.min.js"></script>


  <html>

  <head>

 </head>

 <body>

	<header>
		<h1>클린토피아</h1>
		<nav style="background:green;">
			<div>세탁서비스, 코인빨레방 , 창업안내, 이용정보 , 매장찾기, 회사소개</div>
		</nav>
	</header>


   <script>
             $(function(){
                 $('#camera').change(function(e){
                     $('#pic').attr('src', URL.createObjectURL(e.target.files[0]));
                 });
             });
   </script>
         <input type="file" id="camera" name="camera" capture="camera" accept="image/*" />
         <br/>
         <img id="pic" style="width:100%;" />





	<main>
		<section>
			메인컨텐츠 <br>
			검색<br>
		</section>

		<article style="background:orange;">
			별도의 컨텐츠
		</article>

		<article style="background:orange;">
			별도의 컨텐츠
		</article>
	</main>


	<footer style="background:red;">
		<nav>작은메뉴들....이용약관 등등</nav>
		<div>푸터다 <div>로고</div> <div>copyright</div></div>
	</footer>

 </body>




</html>
