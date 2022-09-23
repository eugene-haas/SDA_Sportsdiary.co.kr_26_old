<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->



</head>
<body>
<div class="l">

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">OGIO AWARD 2019</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll competitionInfo [ _content _scroll ]">
		<!-- E: main banner 01 -->

          <!-- <a href="http://rt.sportsdiary.co.kr/tnrequest/list.asp"> --><img src="http://img.sportsdiary.co.kr/images/sd/contents/bncontents.jpg"  id = "regmap"  usemap="#regmap"/><!-- </a> -->





    <!-- <a href="http://rt.sportsdiary.co.kr/tnrequest/list.asp" class="applyBtn">참가신청</a>
 -->

<%'If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then%>
<div style="background-color: #ffffff;    margin-top: 20px;padding:20px 20px 20px 20px;">
<img src="http://img.sportsdiary.co.kr/images/sd/contents/ogio_photo_title.png" >
</div>
<div style="    margin-top: 0;">
<img src="http://img.sportsdiary.co.kr/images/sd/contents/ogo.jpg" >
</div>
<!-- 대회타이틀 2<br>
이미지2<br>
 -->
<%'End if%>


  </div>





<map name="regmap">
    <area shape="rect" coords="196,9465,1082,9647" href="http://rt.sportsdiary.co.kr/tnrequest/list.asp" alt="참가신청"  target="_self" >
</map> 




  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->


<script src="/pub/js/jquery.rwdImageMaps.min.js"></script>
<script>
$(document).ready(function(e) {
	$('img[usemap]').rwdImageMaps();
	
	$('area').on('click', function() {
		//alert($(this).attr('alt') + ' clicked');
		$(this).attr('href','http://rt.sportsdiary.co.kr/tnrequest/list.asp');
	});
});
</script>

</div>
</body>
</html>
<!-- #include file="../Library/sub_config.asp" -->