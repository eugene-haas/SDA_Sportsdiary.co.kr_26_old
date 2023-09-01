<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->
  <!-- #include file="../Library/sub_config.asp" -->
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
  <%

    'iLIUserID = Request.Cookies("SD")("UserID")
    'iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    'iLISportsGb = SportsGb

    iLIUserID = Request.Cookies("SD")("UserID")
    iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    iLIMemberIDXd = decode(Request.Cookies(SportsGb)("MemberIDX"),0)
    iLISportsGb = SportsGb

  	LocateIDX_1 = "9"
  	LocateIDX_2 = "10"
  	LocateIDX_3 = "11"

  %>
  <script type="text/javascript">
    var cateIdx = 5;

    //상단 종목 메인메뉴 URL
    function chk_TOPMenu_URL(obj){
      switch(obj){
        case 'judo'      : $(location).attr('href', 'http://judo.sportsdiary.co.kr/M_Player/Main/index.asp'); break;
        case 'tennis'    : $(location).attr('href', 'http://tennis.sportsdiary.co.kr/tennis/M_Player/main/index.asp'); break;
        case 'bike'      : $(location).attr('href', 'http://bike.sportsdiary.co.kr/bike/M_Player/main/index.asp'); break;
        case 'badminton' : $(location).attr('href', 'http://bmapp.sportsdiary.co.kr/badminton/M_player/page/institute-schedule.asp'); break;
        case 'riding'  : $(location).attr('href', 'http://riding.sportsdiary.co.kr/m_player/main/index.asp'); break;
        case 'swim'  : $(location).attr('href', 'http://sw.sportsdiary.co.kr/main/index.asp'); break;
        default 			   : $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/index.asp');
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

    //sd뉴스로 이동
    function MainMediaViewLink(i1, i2){
      post_to_url('../Media/list.asp', { 'i1': i1, 'i2': i2 });
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

    $(document).ready(function(){

      view_match();         //대회리스트 조회
      view_notice();          //공지사항
      //fn_LoadColumnist();   //컬럼리스트
      fn_LoadNews_Default();  //일반뉴스
      fn_LoadNews_Media();    //영상뉴스

    });
  </script>
</head>
<body>
<div class="l m_bg_f2f2f2">

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header">
      <!-- #include file = '../include/header_back.asp' -->
      <a href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp" class="m_header__logo">
        <img src="http://img.sportsdiary.co.kr//images/SD/logo/logo_@3x.png" class="m_header__logoImg" alt="스포츠다이어리">
      </a>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>

    <div class="m_mainTab">
      <ul>
        <li class="m_mainTab__item"> <a href="javascript:chk_TOPMenu_URL('badminton');" class="m_mainTab__rink">배드민턴</a> </li>
        <li class="m_mainTab__item"> <a href="javascript:chk_TOPMenu_URL('judo');" class="m_mainTab__rink">유도</a> </li>
        <li class="m_mainTab__item"> <a href="#" class="m_mainTab__rink s_active">테니스</a> </li>
        <li class="m_mainTab__item"> <a href="javascript:chk_TOPMenu_URL('riding');" class="m_mainTab__rink">승마</a> </li>
        <!-- <li class="m_mainTab__item"> <a href="javascript:chk_TOPMenu_URL('bike');" class="m_mainTab__rink">자전거</a> </li> -->
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('swim');" class="m_mainTab__rink">수영</a> </li>
      </ul>
    </div>

  </div>


  <!-- S: main -->
  <div class="l_content m_scroll [ _content _scroll ]">

    <!-- S: main banner 01 -->
    <%
      imType = "1"
      imSportsGb = "tennis"
      imLocateIDX = LocateIDX_1

      LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"
      'response.Write "LSQL="&LSQL&"<br>"
      'response.End

      Set LRs = DBCon6.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
	  If lrs("result") = "Yes" then
	%>
  	<div class="major_banner">
  	  <div class="banner banner_<%=LRs("LocateGb")%> carousel">
  		  <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
  			<!-- #include file="../include/banner_Include.asp" -->
  			</div>
  		</div>
  	</div>
  	<%
	  End if
  	  End If
  	  LRs.close
  	%>
    <!-- E: main banner 01 -->

    <!-- s: board-list -->
    <div class="m_board">
      <!-- s: list-title -->
      <h3 class="m_board__tit">대회일정/결과<a href="../Result/institute-search.asp" class="m_board__moreBtn">더보기</a></h3>
      <!-- e: list-title -->

      <ul id="match_list" class="m_list">
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

    <!-- s: 경기기록실 -->
  <!--  <div class="m_recordBoard" style="margin:0;padding:0;">
      <a href="../Record/record_kata.asp" class="m_recordBoard__link">
			&lt;!&ndash;
        <h3 class="m_recordBoard__tit">경기기록실 <span class="m_recordBoard__more"> 더보기 </span> </h3>
        <p class="m_recordBoard__txt">
          궁금했던 경기 정보를<br>
          알기 힘들었다면?
        </p>
			&ndash;&gt;
				<img src="http://img.sportsdiary.co.kr/sdapp/main/tennis_stats.jpg" alt="경기기록실"/>
      </a>
    </div>
    -->

     <div class="m_recordBoard container__tennis-banner" style="margin:0;padding:0;">
          <a href="../Record/record_kata.asp" class="m_recordBoard__link">
    				<img src="http://img.sportsdiary.co.kr/sdapp/main/tennis_stats.jpg" alt="경기기록실"/>
          </a>
          <a href="https://moryeohan.co.kr/index.html" class="m_recordBoard__link" target="_blank">
            <img src="http://img.sportsdiary.co.kr/sdapp/main/damgum.png" alt="담금"/>
          </a>
        </div>
    <!-- e: 경기기록실 -->

    <!-- s: board-list 뉴스 -->
    <div class="m_board news-list">
      <!-- s: list-title -->
      <h3 class="m_board__tit">SD 뉴스<a href="javascript:;" onclick="MainMediaViewLink('','')"  class="m_board__moreBtn"> </a></h3>
      <!-- e: list-title -->

      <ul id="News_Default" class="m_list">
        <!-- <li>
    			<a href="#">
    				<span class="list-txt">· 2018 하계 전국 남.녀 대학유도 연맹전 지도자상, 모범심판상</span>
    			</a>
    		</li> -->
      </ul>
      <ul id="News_Media" class="m_movieList"></ul>
    </div>
    <!-- e: board-list 뉴스 -->

    <!-- S: main banner 02 -->
    <%
      imType = "1"
      imSportsGb = "tennis"
      imLocateIDX = LocateIDX_2

      LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"
      'response.Write "LSQL="&LSQL&"<br>"
      'response.End

      Set LRs = DBCon6.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
 	  If lrs("result") = "Yes" then
    %>
  	<div class="major_banner">
  	  <div class="banner banner_<%=LRs("LocateGb")%> carousel">
  		  <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
  			<!-- #include file="../include/banner_Include.asp" -->
  			</div>
  		</div>
  	</div>
  	<%
	  End if
  	  End If
  	  LRs.close
  	%>
    <!-- E: main banner 02 -->

    <!-- s: board-list 공지사항 -->
    <div class="m_board s_last">
      <!-- s: list-title -->
      <h3 class="m_board__tit">공지사항 <a href="../Board/notice-list.asp" class="m_board__moreBtn">더보기</a></h3>
      <!-- e: list-title -->

      <ul id="notice_list" class="m_list">
        <!-- <li>
  					<a href="#">
  						<span class="list-txt">[필독] 2018 하계전국중고등학교 유도연맹전 겸 국제 유청소년 파견 선발대회 대진표 공지 안내 </span>
  					</a>
  				</li> -->
      </ul>
    </div>
    <!-- e: board-list 공지사항 -->

    <!-- S: main banner 03 -->
    <%
      imType = "1"
      imSportsGb = "tennis"
      imLocateIDX = LocateIDX_3

      LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"
      'response.Write "LSQL="&LSQL&"<br>"
      'response.End

      Set LRs = DBCon6.Execute(LSQL)

	  If Not (LRs.Eof Or LRs.Bof) Then
	  If lrs("result") = "Yes" then
    %>
  	<div class="major_banner">
  	  <div class="banner banner_<%=LRs("LocateGb")%> carousel">
  		  <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
  			<!-- #include file="../include/banner_Include.asp" -->
  			</div>
  		</div>
  	</div>
  	<%
	  End if
  	  End If
  	  LRs.close
  	%>
    <!-- E: main banner 03 -->

    <!-- #include file = '../include/footer.asp' -->
  </div>
  <!-- E: main -->



  <%
    Set mallobj_mp =  JSON.Parse("{}")
    Call mallobj_mp.Set("M_MIDX", iLIMemberIDXG ) '로그인이 필요없이 이동할때 0
    Call mallobj_mp.Set("M_PR", "R" ) 'R: 선수 S:예비후보선수, L:지도자, A,B,Z:보호자, D:일반
    Call mallobj_mp.Set("M_SGB", iLISportsGb )

    'Call mallobj_mp.Set("M_BNKEY", iProductLocateIDX ) '베너URL 찾아서 보냄 상품코드가 있을시는 ? ...
    Call mallobj_mp.Set("M_BNKEY", "http://tennis.sportsdiary.co.kr/tennis/m_player/result/rookieTennis_info.asp" ) ' 주소 불러서 보내기. 돼는지는 테스트 해야 함, 20181030 JH 수정완료

    strjson_mp = JSON.stringify(mallobj_mp)
    'malljsondata_mp = strjson_mp
    malljsondata_mp = mallencode(strjson_mp,0)

    MALLURL_MP = "http://www.sdamall.co.kr/pub/"

    iSDMallYN_mp = "N"
    iLink_mp = "http://tennis.sportsdiary.co.kr/tennis/m_player/result/rookieTennis_info.asp"

    iLinkType = "1"
  %>

  <% 'if (CDate(date) >= "2018-11-12") and (CDate(date) <= "2018-11-19") and (Request.Cookies("SD")("UserName") = "이인규") then %>
  <% 'if (CDate(date) >= "2018-11-08") and (CDate(date)&"-"&Hour(Now)&"-"&Minute(Now) <= "2018-11-09-14-0") then %>
  <%if false then%>
  <!-- S: popup layer -->
  <div class="[ _overLayer _popupLayer ]">
    <div class="backdrop [ _overLayer__backdrop ]"></div>
    <div class="[ _overLayer__box ]">
      <div class="m_popupLayer [ _overLayer__wrap ]">

        <!--<a href="http://sdmain.sportsdiary.co.kr/sdmain/login.asp"> <img src="http://img.sportsdiary.co.kr/sdapp/ad_banner/banner_main_popup@2x.jpg"/></a>-->
        <% if (IPHONEYN() = "0") then %>
          <% if iSDMallYN_mp = "Y" and iLIMemberIDXG <> "" then %>
          <a href="<%=MALLURL_mp%>tube.asp?p=<%=Server.URLEncode(malljsondata_mp)%>" class="m_popupLayer__wrap" target="_blank" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=encode("273", 0) %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');"><img src="http://img.sportsdiary.co.kr/images/etc/rookieTennis_popup@3x.jpg" alt="" class="m_popupLayer__img" /></a>
          <% elseif iSDMallYN_mp = "Y" and iLIMemberIDXG = "" then %>
          <a href="<%=MALLURL_mp%>tube.asp?p=<%=Server.URLEncode(malljsondata_mp)%>" class="m_popupLayer__wrap" target="_blank" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=encode("273", 0) %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');"><img src=".http://img.sportsdiary.co.kr/images/etc/rookieTennis_popup@3x.jpg" alt="" class="m_popupLayer__img" /></a>
          <% else %>
          <a href="<%=iLink_mp %>" class="m_popupLayer__wrap" <% if iLinkType = "2" then %>target="_blank"<% end if %> onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=encode("273", 0) %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');"><img src="http://img.sportsdiary.co.kr/images/etc/rookieTennis_popup@3x.jpg" class="m_popupLayer__img" alt="" /></a>
          <% end if %>
        <% else %>
          <% if iSDMallYN_mp = "Y" and iLIMemberIDXG <> "" then %>
          <a href="javascript:;" class="m_popupLayer__wrap" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=encode("273", 0) %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');alert('sportsdiary://urlblank=<%=MALLURL_mp%>tube.asp?p=<%=Server.URLEncode(malljsondata_mp)%>');"><img src="http://img.sportsdiary.co.kr/images/etc/rookieTennis_popup@3x.jpg" alt="" class="m_popupLayer__img" /></a>
          <% elseif iSDMallYN_mp = "Y" and iLIMemberIDXG = "" then %>
          <a href="javascript:;" class="m_popupLayer__wrap" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=encode("273", 0) %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');alert('sportsdiary://urlblank=<%=MALLURL_mp%>tube.asp?p=<%=Server.URLEncode(malljsondata_mp)%>');"><img src="http://img.sportsdiary.co.kr/images/etc/rookieTennis_popup@3x.jpg" alt="" class="m_popupLayer__img" /></a>
          <% else %>
          <a href="javascript:;" class="m_popupLayer__wrap" onclick="javascript:fn_ADLOG('<%=iLISportsGb %>','<%=encode("273", 0) %>','<%=iLIUserID %>','<%=iLIMemberIDX %>');javascript:fn_mclicklink('<%=iLinkType %>','<%=iLink_mp %>');"><img src="http://img.sportsdiary.co.kr/images/etc/rookieTennis_popup@3x.jpg" alt="" class="m_popupLayer__img" /></a>
          <% end if %>
        <% end if %>
        <%'Hour(Now)&"-"&Minute(Now)
          'response.Write iSDMallYN_mp&", "&iLIMemberIDXG
        %>

        <div class="m_popupLayer__ctrl">
          <button class="m_popupLayer__btn s_today [ _notToday ]">오늘 하루 보지 않기</button>
          <button class="m_popupLayer__btn s_close [ _overLayer__close ]">닫기</button>
        </div>

      </div>
    </div>
  </div>
  <!-- E: popup layer  -->
  <% 'end if %>
  <script>
    if(getCookie("te_popup") != "done"){
      var popupLayer = new OverLayer({
        overLayer: $('._popupLayer'),
        transition: false
      });
      popupLayer.open();
      $('._notToday').on('click', function(evt){
        setCookie('te_popup', 'done', 1, '.sportsdiary.co.kr');
        popupLayer.close();
      });
    }
  </script>
  <%end if%>



  <!-- #include file = "../include/bottom_menu.asp" -->
  <!-- #include file = "../include/bot_config.asp" -->

</div>
</body>
</html>
<% AD_DBClose() %>
