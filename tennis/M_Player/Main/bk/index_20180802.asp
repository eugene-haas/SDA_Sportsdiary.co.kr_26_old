<!-- #include file="../include/config.asp" -->
<%
' dim MemberIDX   : MemberIDX   = decode(request.Cookies("SD")("MemberIDX"),0)
' dim PlayerReln  : PlayerReln  = decode(request.Cookies(SportsGb)("PlayerReln"),0)
' dim EnterType   : EnterType   = request.Cookies(SportsGb)("EnterType")
' dim ProductKEY  : ProductKEY  = "276387"
' dim strKey      : strKey      = "MemberIDX="&encode(MemberIDX,0)&"&SportsGb="&encode(SportsGb,0)&"&PlayerReln="&encode(PlayerReln,0)&"&ProductKEY="&encode(ProductKEY,0)&"&EnterType="&encode(EnterType,0)
  
  
  'dim valSDMAIN : valSDMAIN = encode("sd027150424",0)   '정식 오픈시 삭제처리합니다.
  
'response.Write "strKey="&strKey&"<br>"
'response.Write "SportsGb="&SportsGb&"<br>"
														  
  '  response.Write "EnterType="&EnterType&"<br>"
  '  response.Write "PlayerReln="&PlayerReln&"<br>"
  '  response.Write "ProductKEY="&ProductKEY&"<br>"
  '  response.Write strKey&"<br>"
  ' response.End()

  iMS = encode("79",0)
%>
<script type="text/javascript">
  var cateIdx = 5;
	//상단 종목 메인메뉴 URL
    function chk_TOPMenu_URL(obj){
		switch(obj) {
			case 'judo'   		: $(location).attr('href', 'http://judo.sportsdiary.co.kr/M_Player/Main/index.asp'); break;
			case 'tennis' 		: $(location).attr('href', 'http://tennis.sportsdiary.co.kr/tennis/M_Player/main/index.asp'); break;
			case 'bike' 		: $(location).attr('href', 'http://bike.sportsdiary.co.kr/bike/M_Player/main/index.asp'); break;
			//case 'badminton' 	: $(location).attr('href', 'http://badminton.sportsdiary.co.kr/badminton/m_player/calendar.asp'); break;
			default 			: $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/index.asp'); 
		}
	}

  //경기일정 데이터
  function view_match(){
    var strAjaxUrl="../ajax/Main_Match_List.asp";
    //var list   = document.getElementById("match_list");
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      
      data: {
      },
      success: function(retDATA) {
        if(retDATA) $('#match_list').html(retDATA);
      }, 
      error: function(xhr, status, error){
        if(error!=""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
          return;
        }
      }
    });
  }

  function MainViewLink() {

    var i1 = "<%=iMS%>";
    var i2 = "1";
    var selSearchValue1 = "";
    var selSearchValue2 = "";
    var selSearchValue = "T";
    var txtSearchValue = "";

    var selSearchValue3 = "1"; // iDivision -  1 : 전체 - 일반뉴스+영상뉴스
    var selSearchValue4 = "S2Y";

    var selSearchValue5 = "";

    post_to_url('../Media/view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });

  }
  
  
  //공지사항 데이터
  function view_notice(){
  
    var strAjaxUrl="../ajax/Main_Notice_List.asp";
    //var list   = document.getElementById("notice_list");
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: { },
      success: function(retDATA) {
        if(retDATA) $('#notice_list').html(retDATA);
      }, 
      error: function(xhr, status, error){
        if(error!=""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
          return;
        }
      }
    });
  }

      //현장스케치
  function btnLink(BtnId) {
      
      switch (BtnId) {

          case "sketch":

              localStorage.setItem("GameTitleIDX","6");

              if (localStorage.getItem("GameTitleIDX") == "4" || localStorage.getItem("GameTitleIDX") == "6")
              {
                url = "../result/stadium_sketch.asp";
                $(location).attr('href', url);
                break;
              }
              else
              {
                url = "javascript:alert('*2018년 2월 공식런칭*\n보다 완성된 서비스로 찾아뵙겠습니다.\n새해 복 많이 받으세요.')";
                $(location).attr('href', url);
                break;
              }

          default:
              
              break;
      }
  }
  //일반뉴스 
  function fn_LoadNews_Default(){
    var strAjaxUrl = '../Ajax/index_news_default.asp';
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: { },
      success: function (retDATA) {
        console.log(retDATA);

        if (retDATA) {
          $('#News_Default').html(retDATA);
        } else {
          $('#News_Default').html('');
        }
      }, 
      error: function (xhr, status, error) {
        if (error!='') { 
          alert('조회중 에러발생 - 시스템관리자에게 문의하십시오!'); 
          return; 
        }
      }
    });
  } 

  //영상뉴스 
  function fn_LoadNews_Media(){
    var strAjaxUrl = '../Ajax/index_news_media.asp';
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: { },
      success: function (retDATA) {
        console.log(retDATA);

        if (retDATA) {
          $('#News_Media').html(retDATA);
        } else {
          $('#News_Media').html('');
        }
      }, 
      error: function (xhr, status, error) {
        if (error!='') { 
          alert('조회중 에러발생 - 시스템관리자에게 문의하십시오!'); 
          return; 
        }
      }
    });
  } 

  //칼럼리스트
  function fn_LoadColumnist(){

    var strAjaxUrl="../ajax/index_Columnist.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',     
      data: { },
      success: function(retDATA) {

        console.log(retDATA);

        if(retDATA) $('#column_list').html(retDATA);
      }, 
      error: function(xhr, status, error){
        if(error!=""){
          alert ("오류발생! - 시스템관리자에게 문의하십시오!");     
          return;
        }
      }
    });
  }

  
  $(document).on('click','.logo', function(){
    $(location).attr('href', "../../../sdmain/index.asp");
  });
  
  $(document).on('click','.ready', function(){
    alert('해당 종목은 서비스 준비중입니다.');                          
    return;
  });

  //메인 대회정보 대진표 페이지 바로가기 설정
//tournament/Totaltourney.asp
function info_GameTitle(valIDX, valName, valEnterType) {
  localStorage.setItem("GameTitleIDX", valIDX);
  localStorage.setItem("GameTitleName", valName);
  localStorage.setItem("EnterType", valEnterType);

  $(location).attr('href','../tournament/Totaltourney.asp');
}

	
														  
  $(document).ready(function () { 

    view_match();         //대회리스트 조회
    view_notice();          //공지사항
    //fn_LoadColumnist();   //컬럼리스트
    fn_LoadNews_Default();  //일반뉴스
    fn_LoadNews_Media();    //영상뉴스
  });

      
</script>
<link rel="stylesheet" href="../css/jquery.bxslider.min.css">
<link rel="stylesheet" href="http://sdmain.sportsdiary.co.kr/sdmain/css/sd_common/sporth-common-main.css?v2.7.1">
<script src="../js/library/jquery.bxslider.min.js"></script>

<body>

<!-- S: container_body -->
<div class="sporth-common-main tenis"> 
  
  <!-- S: header --> 
  <!-- #include file = '../include/header_part_main.asp' --> 
  <!-- E: header --> 
  <!-- #include file = "../include/gnb.asp" --> 

<!-- S: main -->
<div class="main"> 
  <!-- s: main-tab -->
  <div class="main-tab">
    <ul>
      <li> <a href="http://judo.sportsdiary.co.kr/M_Player/Main/index.asp">유도</a> </li>
      <li> <a href="#" class="active">테니스</a> </li>
      <li> <a href="http://bike.sportsdiary.co.kr/bike/M_Player/main/index.asp">자전거</a> </li>
    </ul>
  </div>
  <!-- e: main-tab --> 
  
  <!-- S: main major_banner -->
  <div class="major_banner"> 
    <!-- S: banner banner_md -->
    <div class="banner banner_lg" style="background: #000"> 
      <!-- S: banner_area -->
      <div class="banner_area"> 
        <!-- 
							<a href="http://www.kkmall.co.kr/mobile/gate.asp?key=<%=encode(MemberIDX,0)%>&PlayerReln=<%=encode(PlayerReln,0)%>&EnterType=<%=encode(EnterType,0)%>&SportsGb=<%=encode(SportsGb,0)%>&ProductKEY=<%=encode(ProductKEY,0)%>">
								<img src="/ad_banner/temp/banner_md5@2x.png" alt>
							</a> 
							--> 
        <!--<a href="../Result/stadium_sketch.asp">--> 
        <!-- <a href="javascript:alert('현장스케치는 준비 중 입니다.');">
								<img src="/ad_banner/temp/banner_md5@2x.png" alt>
							</a> --> 
        <!--<a href="javascript:btnLink('sketch');">--> 
        <!--<img src="/ad_banner/temp/banner_md5@2x.png" alt>--> 
        <!-- <div style="background-color: #000"> --> 
        <a href="javascript:;" onclick="javascript:MainViewLink();"><img src="/ad_banner/temp/banner_md6@2x.png" alt=""></a> 
        <!-- </div> --> 
        
        <!--</a>--> 
      </div>
      <!-- E: banner_area --> 
    </div>
    <!-- E: banner banner_md --> 
  </div>
  <!-- E: main major_banner --> 
  
  <!-- s: board-list -->
  <div class="board-list"> 
    <!-- s: list-title -->
    <div class="list-title">
      <h2>대회일정/결과</h2>
      <a href="../Result/institute-search.asp"> <img src="../images/public/btn_more@3x.png" alt="더보기"> </a> </div>
    <!-- e: list-title -->
    <ul id="match_list">
      <!-- <li>
					<a href="#">
						<span class="l-date">D-11</span>
						<span class="r-txt">2018 고창고인돌배 생활체육전국유도대회</span>
					</a>
				</li>
				<li> -->
    </ul>
  </div>
  <!-- e: board-list --> 
  <!-- s: board-list 뉴스 -->
  <div class="board-list news-list"> 
    <!-- s: list-title -->
    <div class="list-title">
      <h2>SD 뉴스</h2>
      <a href="../Media/list.asp"> <img src="../images/public/btn_more@3x.png" alt="더보기"> </a> </div>
    <!-- e: list-title -->
    <ul id="News_Default">
      <!-- <li>
					<a href="#">
						<span class="list-txt">· 2018 하계 전국 남.녀 대학유도 연맹전 지도자상, 모범심판상</span>
					</a>
				</li> -->
    </ul>
  </div>
  <!-- e: board-list 뉴스 --> 
  <!-- s: board-list 공지사항 -->
  <div class="board-list notice-list"> 
    <!-- s: list-title -->
    <div class="list-title">
      <h2>공지사항</h2>
      <a href="../Board/notice-list.asp"> <img src="../images/public/btn_more@3x.png" alt="더보기"> </a> </div>
    <!-- e: list-title -->
    <ul id="notice_list">
      <!-- <li>
					<a href="#">
						<span class="list-txt">[필독] 2018 하계전국중고등학교 유도연맹전 겸 국제 유청소년 파견 선발대회 대진표 공지 안내 </span>
					</a>
				</li> -->
    </ul>
  </div>
  <!-- e: board-list 공지사항 --> 
  <!-- S: banner banner_md -->
  <div class="banner banner_md" style="background-color: #000"> 
    <!-- S: banner_area -->
    <div class="banner_area"> <a href="#" > <img src="/ad_banner/kkmall/kkmall_banner.jpg" alt> </a> </div>
    <!-- E: banner_area --> 
  </div>
  <!-- E: banner banner_md --> 
</div>
<!-- E: main -->

</div>

<!-- S: main_footer --> 
<!-- #include file = '../include/main_footer.asp' --> 
<!-- E: main_footer --> 

<!-- E: container_body --> 

<!-- S: bot_config --> 
<!-- #include file = "../include/bot_config.asp" --> 
<!-- E: bot_config -->

</body>
<script type="text/javascript">

  $(".bxslider").bxSlider({
    pager: true,
    auto: true,
    pause: 3000,
    width: "auto",
    autoHover: true,
  })

</script>
</html>