<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!-- #include file="./include/config.asp" -->
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=09d9631f067e43ba998c6c82aed9449e&libraries=services"></script>
</head>
<body>
<div class="l">

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="./include/header_back.asp" -->
      <h1 class="m_header__tit">고객 센터 </h1>
      <!-- #include file="./include/header_home.asp" -->
    </div>
  </div>

  <!-- S: sub -->
  <div class="l_content m_scroll side [ _content _scroll ]">
   

<!-- 	<div class="box-list"> -->
<!--       <h2 class="tit-widline">사업자 정보</h2> -->
<!--       <ul class="widline"> -->
<!--         <li>사업자명: 주식회사 위드라인</li> -->
<!--         <li>대표이사: 김영석</li> -->
<!--         <li >사업자번호: <%=global_companycode%></li> -->
<!--         <li>사업종목: 소프트웨어개발/골프용품 유통/도소매</li> -->
<!--         <li onclick="callNumber('<%=global_num3%>');">대표전화번호: <%=global_num3%></li> -->
<!--         <li class="address">주소: <%=global_address%> <a href=".daum-map" class="btn-map-widline" data-toggle="collapse"><span><span class="deco-img"><i class="fa fa-map-marker" aria-hidden="true"></i></span> 지도보기 </a></li> -->
<!--  -->
<!-- 		<li> -->
<!--           <div class="daum-map fold" role="menu"> -->
<!--             <div id="map" style="display:block; width: 100%; height: 200px; margin-top: 10px;"></div> -->
<!--           </div> -->
<!--         </li> -->
<!--       </ul> -->
<!--     </div> -->




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
    geocoder.addressSearch('<%=global_address%>', function(result, status) {

      // 정상적으로 검색이 완료됐으면
       if (status === daum.maps.services.Status.OK){
          var coords = new daum.maps.LatLng(result[0].y, result[0].x);


          // 결과값으로 받은 위치를 마커로 표시합니다
          var marker = new daum.maps.Marker({
              map: map,
              position: coords
          });

          // 인포윈도우로 장소에 대한 설명을 표시합니다
          var infowindow = new daum.maps.InfoWindow({
              content: '<div style="width:150px; height: 50px; display:inline-block; text-align:center;">주식회사 위드라인</div>'
          });

          // infowindow.open(map, marker);

          // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
          map.setCenter(coords);

        }
    });

    $('.daum-map').addClass('collapse');
  </script>

</div>
</body>
</html>
