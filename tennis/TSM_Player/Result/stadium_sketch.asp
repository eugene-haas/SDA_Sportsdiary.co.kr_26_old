<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->

  <%
      dim GameTitleIDX : GameTitleIDX = fInject(request("GameTitleIDX"))
      dim SiteGubun : SiteGubun = fInject(request("SiteGubun")) 'SD랭킹테니스인지 구분



      dim CSQL, CRs
      dim TeamGbIDX
      dim top_index : top_index = 3

      IF GameTitleIDX <> "" Then
		  If sitegubun = "S" Then 'SD 테니스라면
		  CSQL =  "EXEC SD_RookieTennis.dbo.Stadium_Sketch_select_list @GameTitleIDX = '"&GameTitleIDX&"'"
		  Else
		  CSQL =  "EXEC Stadium_Sketch_select_list @GameTitleIDX = '"&GameTitleIDX&"'"
		  End if
		  SET CRs = DBCon4.Execute(CSQL)
          IF Not(CRs.Eof OR CRs.Bof) Then
              TeamGbIDX = CRs("TeamGbIDX")
          Else
              Response.write "<script>"
              response.write "    alert('일치하는 정보가 없습니다.'); "
              response.write "    history.back();"
              response.write "</script>"
              response.end
          End IF
              CRs.close
          SET CRs = Nothing
      Else
          Response.write "<script>"
          response.write "    alert('잘못된 접근입니다. 확인 후 이용하세요.'); "
          response.write "    history.back();"
          response.write "</script>"
          response.end
      End IF
  %>

  <%

    iLIUserID = Request.Cookies("SD")("UserID")
    iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    iLISportsGb = SportsGb

  	LocateIDX_1 = "69"
  	LocateIDX_2 = "70"
  	'LocateIDX_3 = "13"

  %>

  <link rel="stylesheet" href="http://sdmain.sportsdiary.co.kr/sdmain/css/library/swiper.min.css">
  <script src="http://sdmain.sportsdiary.co.kr/sdmain/js/library/swiper.min.js"></script>

  <script type="text/javascript">
    // get gameTitle
    function Fnd_GameTitle_Info(valIDX, valGubun){
      var strAjaxUrl = '../Ajax/stadium_sketch_FndGameTitle.asp';

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          GameTitleIDX  : valIDX,
		  SiteGubun : valGubun
        },
        success: function(retDATA) {

          if(retDATA){
            var strcut = retDATA.split('|');

            if (strcut[0]=='TRUE') {
              $('#txt_GameTitle').html(strcut[1]);
            }
            else{
              var msg = '';

              switch(strcut[1]){
                case '99' : msg='일치하는 정보가 없습니다. 확인 후 이용하세요.'; break;
                    default : msg='일치하는 정보가 없습니다. 확인 후 이용하세요.'; //200
                }
                alert(msg);
                return;
            }
          }
        },
        error: function (xhr, status, error) {
          if(error) {
            alert ('조회중 에러발생 - 시스템관리자에게 문의하십시오!'+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
            return;
          }
        }
      });
    }

    // get team select
    function Fnd_TeamGb_open(GameTitleIDX,r_TeamGbIDX,Top_index, sitegubun){
      //alert(r_TeamGbIDX);
      if (Top_index == undefined || Top_index == '' ){ Top_index = 3 }

      //1. 처음 데이터 불러올때 셀렉트 선택 데이터 불러옴
      var strAjaxUrl = "../Ajax/stadium_sketch_Team_select.asp";

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        async: false,
        data: {
          GameTitleIDX  : GameTitleIDX ,
          r_TeamGbIDX   : r_TeamGbIDX,
		  SiteGubun : sitegubun
        },
        success: function(retDATA){

          document.getElementById("TeamGb").innerHTML = retDATA;

        },

        error: function (xhr, status, error) {
          if(error) {
            alert ('조회중 에러발생 - 시스템관리자에게 문의하십시오!'+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
            return;
          }
        }

      });
    }

    // get img list
    function fn_List(np, callback){

      var selTeamGbIDX = document.getElementById("TeamGb").value;

      if (selTeamGbIDX == 0) { selTeamGbIDX = ""; }

      var strAjaxUrl = "../Json/stadium_sketch.asp";

      $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
          NowPage : np,
          GameTitleIDX  : GameTitleIDX,
          TeamGbIDX   : selTeamGbIDX,
		  SiteGubun : '<%=sitegubun%>'
        },
        success: function(retDATA){
          if(callback) callback(retDATA);
        },
        error: function(xhr, status, error){
          if(error != ""){
            alert("오류발생! - 시스템관리자에게 문의하십시오!");
            return;
          }
        }
      });
    }
  </script>
</head>
<body>
<div class="l">
  <input type="hidden" id="top_index" name="top_index" value="<%=top_index%>">
  <input type="hidden" id="r_TeamGbIDX" name="r_TeamGbIDX" value="">

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">현장스케치</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>

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
    %>
    <div class="major_banner">
      <div class="banner banner_<%=LRs("LocateGb")%> carousel">
    	  <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
    		<!-- #include file="../include/banner_Include.asp" -->
    		</div>
    	</div>
    </div>
    <%
      End If
      LRs.close
    %>
    <!-- E: main banner 01 -->
  </div>

  <!-- S: main -->
  <div class="l_content m_scroll stadium_sketch [ _content _scroll ]">
    <div class="sd_subTit">
      <h2 id="txt_GameTitle" class="sd_subTit__tit"></h2>
    </div>

    <div class="sd-select-wrap-A" id="TeamGb_Select_Div">
    	<select id="TeamGb" name="TeamGb" onchange="listInit();"></select>
    </div>

    <div class="sd_photoList">
      <div id="List"></div>
      <div><button id="More" class="sd_photoList__more" onclick="listMore();">더보기</button></div>
    </div>

  </div>

  <!-- layer photo viewer -->
  <div class="l_upLayer [ _overLayer ]" >
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox [ _overLayer__box ]">
      <div class="l_upLayer__wrapTit">
        <h1 class="l_upLayer__tit [ _overLayer__title ]">현장스케치</h1>
        <button class="l_upLayer__close [ _overLayer__close ]">닫기</button>
      </div>
      <div class="l_uplayer__wrapCont sd_photoViewer [ _overLayer__wrap ]">

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
        %>
        <div class="major_banner">
          <div class="banner banner_<%=LRs("LocateGb")%> carousel">
        	  <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
        		<!-- #include file="../include/banner_Include.asp" -->
        		</div>
        	</div>
        </div>
        <%
          End If
          LRs.close
        %>
        <!-- E: main banner 02 -->

        <div class="sd_photoViewer__swiper [ _photoViewer__swiper swiper-container  ]">
          <div class="[ swiper-wrapper ]"></div>

<!-- 					<div class="swiper-button-prev"></div> -->
<!-- 					<div class="swiper-button-next"></div> -->
        </div>
        <a href="" class="sd_photoViewer__download [ _download ]" download="download">다운로드</a>
        <div class="sd_photoViewer__info">
          <p>* 스포츠다이어리의 모든 이미지는 저작권의 보호를 받고 있습니다. 개인적인 용도외에 상업적인 용도 또는 무단 도용을 금하고 있습니다.</p>
          <p>* 아이폰 및 안드로이드 기종에 따라 다운로드가 일부 제한적일 수 있습니다.</p>
          <p>* 해당 이미지는 다운로드 시 고화질로 보실 수 있습니다.</p>
        </div>
      </div>
    </div>
  </div>

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
  <script>
    var GameTitleIDX = '<%=GameTitleIDX%>';
	  var sitegubun = "<%=sitegubun%>";
    var pageCnt = 1;
    var listLength = 16;
    var imgList = [];

    var $list = $('#List');
    var $listItem = $('._listItem');
    var $more = $('#More');
    var $donwload = $('._download');
    var $swiperWarpper = $('.swiper-wrapper');



    Fnd_TeamGb_open('<%=GameTitleIDX%>','','','<%=SiteGubun%>');
    Fnd_GameTitle_Info('<%=GameTitleIDX%>','<%=SiteGubun%>');



    fn_List(pageCnt, appendList);




    function listInit(){
      $more.css({'display':'none'});
      pageCnt = 1;
      imgList = [];

      swiper_viewer.removeAllSlides();

      fn_List(pageCnt, appendList);
      $more.css({'display':'block'});
    }

    function listMore(){
      pageCnt++;
      fn_List(pageCnt, appendList);
    }

    function appendList(retDATA){
      if(retDATA == '') return;

      var data = JSON.parse(retDATA);
      var totalCnt = data[0]['cnt'];
      var imgs = data[0]['links'];
      var html = '';

      if(pageCnt == 1){
        $list.html('');
        $more.css({'display':'block'});
      }

      if(Math.ceil(totalCnt/listLength) == pageCnt){
        $more.css({'display': 'none'});
      }

      if(pageCnt == 1){
        var slides = [];
        for(var i=0; i<totalCnt; i++){
          slides.push('<div class="sd_photoViewer__slide [ swiper-slide ]"><img src="http://img.sportsdiary.co.kr/sdapp/empty.png"/ class="sd_photoViewer__img"></div>');
        }
        swiper_viewer.appendSlide(slides);

      }

      imgs.forEach(function(item, index){
        var gIndex = (index + ((pageCnt-1)*listLength));

        if($listItem.length != 0){
          var $clone = $listItem.clone(true)
          $clone.find('img').attr('src', (global_SSUrl_TN_script + item.link));
          $list.append($clone);
        }
        else $list.append('<span class="sd_photoList__item"><span class="sd_photoList__itemInner"><img src="' + (global_SSUrl_TN_script + item.link) + '" data-no="' + gIndex +'" tabIndex="-1" class="sd-photoList__img"  onclick="viewer_open.call(this);"></span></span>');

        swiper_viewer.slides[gIndex].getElementsByTagName('img')[0].src = global_SSUrl_TN_script + item.link;
        imgList.push(global_SSUrl_script + item.link)
      });
    }

    function viewer_open(){
      layer_viewer.open();
      swiper_viewer.updateAutoHeight();
      swiper_viewer.slideTo(this.dataset.no, 0);

      $donwload.attr('href', imgList[swiper_viewer.activeIndex]);

    }

    var referrer = document.referrer || './institute-search.asp';
    history.replaceState('list', null, null);
    window.onpopstate = function(evt){
      if(evt.state == 'list' && layer_viewer.status == 'open')
        layer.close();
      else{
        location.href = referrer
      }
    }

    var layer_viewer = new OverLayer({
      overLayer: $('._overLayer'),
      emptyHTML: '정보를 불러오고 있습니다.',
      errorHTML: '',
    });
    layer_viewer.on('beforeOpen', function(){ history.pushState('view', null, null); });
    layer_viewer.on('beforeClose', function(){ history.pushState('list', null, null); });

    var swiper_viewer = new Swiper('._photoViewer__swiper');
    swiper_viewer.on('slideChange', function(){
      $('[data-no="'+swiper_viewer.activeIndex+'"]').focus();

      setTimeout(function(){
        $swiperWarpper.css({'height':'100%'});
        swiper_viewer.updateAutoHeight();
      },1);

//      var swiperPageNo = Math.floor(swiper_viewer.activeIndex/listLength);
//      if((swiper_viewer.activeIndex%16) == 0 && (pageCnt == swiperPageNo)){
//        listMore();
//      }
      $donwload.attr('href', imgList[swiper_viewer.activeIndex]);
    });

    if(/iPhone|iPad|iPod/i.test(navigator.userAgent)){ $donwload.remove(); }


  </script>

</div>
</body>
</html>
