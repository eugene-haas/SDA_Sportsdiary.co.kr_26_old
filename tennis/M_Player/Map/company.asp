<!-- #include file="../include/config.asp" -->
<link rel="stylesheet" href="/front/css/side/info_map.css">
<link rel="stylesheet" href="/front/css/side/company.css">
<!-- E: config -->
<script type="text/javascript" src="//apis.daum.net/maps/maps3.js?apikey=62f6663bbf630636dc2f9ace306d2daa&libraries=services"></script>

<body class="lack-bg">
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>사업자 정보</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->
  
  <!-- S: sub -->
  <div class="sub side">
    <div class="box-list">
      <h2 class="tit-widline">사업자 정보</h2>
      <ul class="widline">
        <li>사업자명: 주식회사 위드라인</li>
        <li>대표이사: 김영석</li>
        <li >사업자번호: <%=global_companycode%></li>
        <li>사업종목: 소프트웨어개발/골프용품 유통/도소매</li>
        <li onclick="callNumber('<%=global_num3%>');">대표전화번호: <%=global_num3%></li>
        <li class="address">주소: <%=global_address%> <a href=".daum-map" class="btn-map-widline" data-toggle="collapse"><span><span class="deco-img"><i class="fa fa-map-marker" aria-hidden="true"></i></span> 지도보기 </a></li>
                  <!-- <li class="active-btn"></li> -->
        <li>
          <!-- S: 다음 지도 -->
          <!-- * Daum 지도 - 지도퍼가기 -->
          <!-- 1. 지도 노드 -->
          <div class="daum-map fold" role="menu">
            <div id="map" style="display:block; width: 100%; height: 200px; margin-top: 10px;"></div>
          </div>
          <!-- E: 다음 지도 -->
        </li>
      </ul>
    </div>
    <script>
		var container = document.getElementById('map'); // 이미지 지도를 표시할 div
		var options = {
			center: new daum.maps.LatLng(33.450701, 126.570667), // 이미지 지도의 중심좌표
			level: 3
		};

		var map = new daum.maps.Map(container, options);

		// 주소-좌표 변환 객체를 생성합니다
	 	var geocoder = new daum.maps.services.Geocoder();

		// 주소로 좌표를 검색합니다
		geocoder.addr2coord('<%=global_address%>', function(status, result) {

 	    // 정상적으로 검색이 완료됐으면
 	     if (status === daum.maps.services.Status.OK) {
 	        var coords = new daum.maps.LatLng(result.addr[0].lat, result.addr[0].lng);

 	        // 결과값으로 받은 위치를 마커로 표시합니다
 	        var marker = new daum.maps.Marker({
 	            map: map,
 	            position: coords
 	        });

 	        // 인포윈도우로 장소에 대한 설명을 표시합니다
 	        var infowindow = new daum.maps.InfoWindow({
 	            content: '<div style="width:150px; height: 50px; display:inline-block; text-align:center; padding:6px 0 0 0;">주식회사 위드라인</div>'
 	        });

 	        // infowindow.open(map, marker);

 	        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
 	        map.setCenter(coords);

		}
 	});

	</script>
    <div class="box-list">
      <h2 class="tit-sd">사업팀 정보</h2>
      <ul class="sd">
        <li>사업팀명: 스포츠다이어리 사업팀</li>
        <!-- <li>팀장: <%=global_name1%></li> -->
        <li>연락처: <strong onclick="callNumber('<%=global_num2%>');"><%=global_num2%></strong></li>
        <li>FAX: <%=global_fax%></li>
        <li>E-mail: <span><a href="mailto:<%=global_email1%>"><%=global_email1%></a></span></li>
        <li>홈페이지: <a href="http://www.sportsdiary.co.kr" target="_blank"><%=global_site%></a></li>
      </ul>
    </div>
  </div>
  <!-- E : sub -->
  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
  <script>
    $('.daum-map').addClass('collapse');
  </script>
</body>
