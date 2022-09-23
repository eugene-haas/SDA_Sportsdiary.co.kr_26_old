<%
'  idx = chkInt(chkReqMethod("idx", "GET"), 1)
'  page = chkInt(chkReqMethod("page", "GET"), 1)

'  search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
'  search_first = chkInt(chkReqMethod("search_first", "POST"), 0)

'  page = iif(search_first = "1", 1, page)
'  titleidx = idx
  'request 처리##############


	nowyear = year(date)
	startyy = nowyear
	Endyy = nowyear
	startyy = CDbl(startyy) -4

	If startyy < 2019 Then
		startyy = 2019
	End if

	defaultyear = nowyear

	'원스타 승급자인 경우 gameday 보다 큰 투스타 정보를 원스타에 출력
	'tblPlayer.stateNO 상태 : 0 기본 / 1 박탈 /  원스타승급 100 승급  / 200 투스타 승급 /201( 투스타 승급박탈 )
	'sd_TennisRPoint_log.upgrade 상태 : 0 기본 / 1원스타승급(승급이후 계속 1유지) /  2투스타승급

  chkdateS  = nowyear & "-01-01"
  chkdateE  = CDbl(nowyear) + 1 & "-01-01"
  teamgb = "20104"

  LocateIDX_2 = "90"
%>
<!-- #include virtual = "/pub/query/mobile/q.record.asp" --><%'리스트, ajax 에서 같이 사용%>

 	<div id="drowarea" class="l_content m_scroll [ _content _scroll ]">
		<!-- #include virtual = "/pub/html/RookieTennis/html.mobile.searchrecordlist1.asp" --><%'리스트, ajax 에서 같이 사용%>
		<!-- <div style="font-size:1.27rem;font-weight:500;letter-spacing:-0.07rem;text-align:center;color:#7d868e;">
			결과가 없습니다.
		</div> -->
  </div>


<%'상세보기 팝업##################################%>
  <div class="l_upLayer [ _overLayer _detailLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox [ _overLayer__box ]">
      <div class="l_upLayer__wrapTit">
        <h1 class="l_upLayer__tit [ _overLayer__title ]">경기기록실</h1>
        <button class="l_upLayer__close [ _overLayer__close ]">닫기</button>
      </div>

	  <div class="l_uplayer__wrapCont playerDetail__wrap [ _overLayer__wrap ]" >
    

    <!-- S: main banner 01 -->
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
  			<!-- #include file="../../include/banner_Include.asp" -->
  			</div>
  		</div>
  	</div>
  	<%
  	  End If
  	  LRs.close
  	%>
    <!-- E: main banner 01 -->

        <!-- .s. 선수 상세 팝업 .s. -->
        <div class="playerDetail__bg">
          <p class="playerDetail__tle">SD랭킹</p>
          <div class="l_recordList__content" id="playerdetail">



          </div>
        </div>
        <!-- //e. 선수 상세 팝업 .e. -->

	  </div>



    </div>
  </div>



<%'검색팝업##################################%>
  <div class="l_upLayer [ _overLayer _searchLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox m_searching__area [ _overLayer__box ]">
      <div class="m_searchPopup__header">
        <button class="m_searchPopup__close [ _overLayer__close ]"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_popup_x_@3x.png" alt="닫기"></button>
      </div>
      <div class="l_upLayer__wrapCont m_searchPopup__cont [ _overLayer__wrap ]">

        <div class="m_searchPopup__control">
          
          <p class="m_btnPopup_title"></button>

        </div>
        <div class="m_searchPopup__panelWrap [ _sliderWrap ] s_filtering">

            <div class="m_searchPopup__panelArea m_searchPopupTab show">
              <div class="m_searchPopup__panel">
                <!-- <p class="m_searchPopup__cehckTit">기간</p>
                <div class="m_searchPopup__checkWrap">
                  <div class="m_searchPopup__checkGroup">
                  <%For i = startyy  To endyy%>
                    <input type="radio" name="search_age" id="search_age<%=i%>" value= "<%=i%>" hidden  <%If CDbl(year(date)) = i  then%>checked<%End if%>><label for="search_age0<%=i%>" onmousedown="tm.searchRecord('drowarea','<%=i%>','','')"><%=i%>년</label>
                  <%next%>
                  </div>
                </div> -->
                <div class="m_searchPopup__checkWrap">
                  <div class="m_searchPopup__checkGroup" style="position:absolute;left:-9999px;display:none;opacity:0;visibility:hidden;">
                  <%For i = startyy  To endyy%>
                    <input type="radio" name="search_age" id="search_age<%=i%>" value= "<%=i%>" hidden  <%If CDbl(year(date)) = i  then%>checked<%End if%>><label for="search_age0<%=i%>" onmousedown="tm.searchRecord('drowarea','<%=i%>','','')"><%=i%>년</label>
                  <%next%>
                  </div>
                  <div class="m_searchPopup__checkGroup">
                    <input type="radio" name="search_div_sd" id="search_div_sd2" value="20104"  hidden checked>
                    <label for="search_div_sd2" onmousedown="tm.searchRecord('drowarea','','20104','')">남자부★</label>
                    <input type="radio" name="search_div_sd" id="search_div_sd3" value="20105"  hidden>
                    <label for="search_div_sd3" onmousedown="tm.searchRecord('drowarea','','20105','')">남자부★★</label>
                  </div>
                  <div class="m_searchPopup__checkGroup">
                    <input type="radio" name="search_div_sd" id="search_div_sd0" value="20101"  hidden>
                    <label for="search_div_sd0" onmousedown="tm.searchRecord('drowarea','','20101','')">여자부★</label>
                    <input type="radio" name="search_div_sd" id="search_div_sd1" value="20102"  hidden>
                    <label for="search_div_sd1" onmousedown="tm.searchRecord('drowarea','','20102','')">여자부★★</label>
                  </div>
                </div>
              </div>
            </div>
  
  
            <div class="m_searchPopup__name m_searchPopupTab">
              <div class="m_searchPopup__panelTop">
                <input type="text" placeholder="선수명을 입력해주세요." value="" class="m_searchPopup__input s_ignore [ _searchingInput ] " id="SF1" onInput="tm.searchPlayer('searchplayerlist')" onKeyUp="keyfc()" onblur="keyfc()">
                <!-- <button type="button" class="m_searchPopup__submit [ _searching ]"  onmousedown="tm.searchPlayer('searchplayerlist')"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt="조회"></button> -->
              </div>
              
              <div class="m_searchPopup__panel" id="searchplayerlist">
              </div>
            </div>
  
          </div>
      </div>
    </div>
  </div>

  <div class="l_upLayer [ _overLayer _summaryLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox [ _overLayer__box ]">
      <div class="l_upLayer__wrapTit">
        <h1 class="l_upLayer__tit [ _overLayer__title ]">대회규정</h1>
        <button class="l_upLayer__close [ _overLayer__close ]">닫기</button>
      </div>
      <div class="l_uplayer__wrapCont [ _overLayer__wrap ]">
        <img src="http://img.sportsdiary.co.kr/images/SD/img/tennis_record_sd_@3x.jpg" alt="">
      </div>
    </div>
  </div>










  <style>
      .m_searchPopup__area{width:calc(100% - 20px);height:100vh;margin:0px 10px 0 10px;overflow:hidden;}
      .m_searchPopup__header{position:relative;height:3.1rem;}
        .m_searchPopup__close{padding-left:.5rem; padding-right:.5rem; position:absolute;width:2.27rem;height:2.27rem; top:.25rem; bottom:0; right:0.9rem; margin:auto; line-height:0;}
        .m_searchPopup__close img{pointer-events: none;}
  
      .m_searchPopup__cont{position:relative;height:calc(100vh - 2.5rem);overflow:hidden;}
  
        /* .m_searchPopup__control{background-color:#f2f2f2; display:table;width:100%;height:4.25rem;padding:1.45rem 0.7rem 0.7rem 0.7rem;border-radius:0.92rem 0.92rem 0 0;overflow:hidden;} */
        .m_searchPopup__name{padding-bottom:5rem;background-color:#fff;overflow:hidden;}
        .m_searchpopup__panelArea{}
        .m_searchPopupTab{display:none;}
        .m_searchPopupTab.show{display:block;}
        
        .m_searchPopup__control{background-color:#fff;height:4.25rem;padding:1.45rem 1.41rem 0.7rem;border-radius:0.92rem 0.92rem 0 0;overflow:hidden;}
          /* .m_searchPopup__fliter{position:relative;float:left;font-size:0;background-color:#fff;width: 3.5rem;height: 2.4rem;margin-left: 0.85rem;padding: 0.6rem 0;border-radius: 0.29rem 0 0 0.29rem;border: 1px solid #d7d5d5;border-right: none;background-position: center;background-size: 1.35rem;box-shadow: 0 0 0.7rem #ccc;}
          .m_searchPopup__fliter:before{content:"";position: absolute;left: 0;top: 0;width: 100%;height: 100%;background-color: #fff;border-radius: 0.29rem 0 0 0.29rem;}
          .m_searchPopup__fliter:after{content: "";position: absolute;left: 0;top: 0;width: 100%;height: 100%;background: url(http://img.sportsdiary.co.kr/images/SD/icon/filter_on_@3x.png) left .6rem center/auto 70% no-repeat;background-position: center;background-size: 1.35rem;}
          .m_searchPopup__fliter:hover, .m_searchPopup__fliter:focus{border: 1px solid #d7d5d5;border-right: none;box-shadow: 0 0 0.7rem #ccc;}
          .m_searchPopup__fliter.on{width:2rem;box-shadow: 0 0 0rem transparent;}
          .m_searchPopup__fliter.on:before{background-color:#ecebeb;}
          .m_searchPopup__fliter.on:after{background-image:url(http://img.sportsdiary.co.kr/images/SD/icon/filter_off_@3x.png);} */
          .m_searchPopup__input.s_ignore{margin-left:1rem;margin-right:1rem;padding: 0 0.6rem;width:calc(100% - 2rem);height:2.4rem;float:left;line-height:2.5rem;font-size:1.13rem;color:#7d868e;border:1px solid #d2dce3;letter-spacing:-0.07rem;text-decoration:none;border-radius:0.29rem;box-shadow: 0 0 0rem transparent;background-color:#ecebeb;}
          /* .m_searchPopup__input.s_ignore{margin-left:1rem;margin-right:0.7rem;padding: 0 0.6rem;width:calc(100% - 5.2rem);height:2.4rem;float:left;line-height:2.5rem;font-size:1.13rem;color:#7d868e;border:1px solid #d2dce3;letter-spacing:-0.07rem;text-decoration:none;border-radius:0.29rem;box-shadow: 0 0 0rem transparent;background-color:#ecebeb;} */
          .m_searchPopup__input.s_ignore.on{width:calc(100% - 6.7rem);}
          .m_searchPopup__input.s_ignore:focus, .m_searchPopup__input:focus{background-color:#fff;}
          .m_searchPopup__submit{padding: 0.6rem;width: 2.3rem;line-height: 0;border-radius: 0.3rem;    background-color: #3f505d;}
          .m_searchPopup__input.s_ignore, .m_searchPopup__fliter, .m_searchPopup__fliter:before{
            -webkit-transition:0.23s cubic-bezier(.08,.51,.54,1);
            -moz-transition:0.23s cubic-bezier(.08,.51,.54,1);
            -ms-transition:0.23s cubic-bezier(.08,.51,.54,1);
            transition:0.23s cubic-bezier(.08,.51,.54,1);
          }
  
          .m_searchPopup__input::-webkit-input-placeholder{color:#ccc;}
          .m_searchPopup__input:-moz-placeholder{color:#ccc;}
          .m_searchPopup__input::-moz-placeholder{color:#ccc;}
          .m_searchPopup__input:-ms-input-placeholder{color:#ccc;}
          .m_searchPopup__input::placeholder{color:#ccc;}
  
        /* .m_searchPopup__panelWrap{position:relative;display:flex;height:calc(100% - 4.25rem);width:100%;transform:translateX(0%);background-color:#fff;-webkit-flex-direction:column;flex-direction:column;
          -webkit-transition:transform 0.23s cubic-bezier(.08,.51,.54,1);
          -moz-transition:transform 0.23s cubic-bezier(.08,.51,.54,1);
          -ms-transition:transform 0.23s cubic-bezier(.08,.51,.54,1);
          transition:transform 0.23s cubic-bezier(.08,.51,.54,1);
        } */
        .m_searchPopup__panelWrap{position:relative;height:calc(100% - 4.25rem);width:100%;background-color:#fff;}
        /* .m_searchPopup__panelWrap.s_searching{transform:translateX(-100%);}
        .m_searchPopup__panelWrap.s_filtering{transform:translateX(0%);} */
  
          .m_searchPopup__panel{/* padding:1.25rem 0 0.45rem; */padding-top:0.35rem;width:100%;/* height:100%; */height:calc(100vh - 12rem);flex-shrink:0;overflow-y:scroll;overscroll-behavior:none;background-color:#fff;}
          .m_searchPopup__panelTop{padding-top:0.35rem;}
  
            /* .m_searchPopup__cehckTit{margin:0 1.41rem;font-size:1rem;color:#7d868e;letter-spacing:-0.04rem;font-weight:500;}
            .m_searchPopup__cehckTit~.m_searchPopup__cehckTit{margin-top:0.95rem;} */
            .m_searchPopup__checkWrap{font-size:0;line-height:0;white-space:nowrap;overflow-x:scroll;}
              .m_searchPopup__checkGroup label{padding:0 0.9rem;height:2.25rem;line-height:2.26rem;font-size:1.13rem;color:#7d868e;font-weight:300;letter-spacing:-0.04rem;background-color:#f9f9f9;box-shadow:0 1px 2px #e0e3e5;border-radius:1.12rem;}
              .m_searchPopup__checkGroup{margin-bottom:0.7rem;}
              .m_searchPopup__checkGroup label{display:inline-block;vertical-align:top;}
              .m_searchPopup__checkGroup label~label{margin-left:0.5rem;}
              .m_searchPopup__checkGroup input:checked+label{color:#fff;background-color:#3f505d;}
  
              .m_searchPopup__checkGroup>label:nth-of-type(1){margin-left:1.41rem;}
              .m_searchPopup__checkGroup>label:nth-last-of-type(1){margin-right:1.41rem;}
  
            .m_searchPopup__listname{padding:0 1.6rem;position:relative;width:100%;height:2.44rem;line-height:2.5rem;font-size:1.13rem;color:#7d868e;letter-spacing:-0.07rem;text-align:left;}
            .m_searchPopup__listname~.m_searchPopup__listname{margin-top: 0.16rem;}
            .m_searchPopup__listname .icon__search_add{position: absolute;/* right: 4.5rem; */right:2rem;top: -0.15rem;display: inline-block;width: 0.7rem;pointer-events: none;}
    </style>
  
    <style>
      a,button,label{-webkit-tap-highlight-color:transparent;-webkit-tap-highlight-color:rgba(0,0,0,0);}
      button{
        background-color:transparent;border:none;padding:0;margin:0;cursor:pointer;box-shadow:none;
        -webkit-text-size-adjust:none;
      }
      a,button,label,input,select,textarea,span{outline:none;}
      button::-moz-focus-inner{padding:0;border:0;}
      html{font-size:32px;}
      @media screen and (max-width:480px){html{font-size:18.4px;}}
      @media screen and (max-width:830px) and (max-height:480px){html.landscape{font-size:18.4px;}}
  
      @media screen and (max-width:375px){html{font-size:16.7px;}}
      @media screen and (max-width:820px) and (max-height:375px){html.landscape{font-size:16.7px;}}
  
      @media screen and (max-width:360px){html{font-size:16px;}}
      @media screen and (max-width:640px) and (max-height:360px){html.landscape{font-size:16px;}}
  
      @media screen and (max-width:320px){html{font-size:14.2px;}}
      @media screen and (max-width:570px) and (max-height:320px){html.landscape{font-size:14.2px;}}
      /* @media screen and (orientation:landscape){html{font-size:12px;}} */
  
      .m_recordTab__wrap{padding-top:10px;height:100%;background-color:#f2f2f2;}
      .m_recordTab__menu{position:relative;font-size:0;padding:10px 10px 0 10px;background-color:#f2f2f2;}
      .m_recordTab__item{display:inline-block;width:50%;vertical-align:top;text-align:center;}
      .m_recordTab__item:first-child{}
      .m_recordTab__txt{padding-top:0.3rem;width:100%;height:2.53rem;line-height:2.33rem;font-size:1.127rem;font-weight:500;color:#7d868e;background-color:#d5d9dc;border-left:1px solid #c8cdd0;border-bottom:1px solid #c8cdd0;border-radius:4px 4px 0 0;letter-spacing:-0.07rem;}
      .s_active .m_recordTab__txt{color:#164369;background-color:#fff;border-bottom:1px solid #fff;border-left:1px solid #fff;}
  
      .l_search__wrap{margin-top:-1px;border-top:1px solid #e1e2e3;background-color:#fff;}
        /* .l_searchInfo__box{padding-left:10px;padding-top:0.42rem;position:relative;height:2.6rem;font-size:0;} */
        .l_searchInfo__box{font-size:0;}
          .l_searchInfo__txt{padding:0 0.85rem;display:inline-block;height:1.83rem;line-height:1.9rem;font-size:1.05rem;font-weight:300;text-align:center;vertical-align:top;border-radius:0.98rem;color:#7d868e;background-color:#f9f9f9;box-shadow:0 1px 2px #e0e3e5;letter-spacing:-0.07rem;display:none;opacity:0;visibility:hidden;}
          .l_searchInfo__txt~.l_searchInfo__txt{margin-left:0.3rem;}
          .l_search__btn{padding: 0.4rem 0.5rem;position:absolute;top: 0.35rem;right: 0.65rem;width: 2.1rem;line-height:0;z-index:9;border-radius: 0.28rem;background-color: #3f505d;}
        .l_search_box{}
  
        .m_btnPopup{position:relative;display:inline-block;width:50%;height:2.81rem;line-height:2.82rem;font-size:0.99rem;color:#164369;text-align:center;font-weight:500;}
        .m_btnPopup+.m_btnPopup:before{content:"";position:absolute;top:0.77rem;left:0;width:1px;height:1.27rem;background-color:#164369;}
        .m_btnPopup .img{margin-right:0.3rem;position:relative;top:-0.1rem;display:inline-block;width:1.13rem;}
        .m_btnPopup+.m_btnPopup .img{width:0.71rem;}
        .m_btnPopup .img img{width:100%;}
        .m_btnPopup_title{font-size:1.27rem;color:#164369;font-weight:500;}
  
        .l_recordList__wrap{}
        .l_recordPrev{height:100vh;max-height:calc(100vh - 9.2rem);background-color:#f2f2f2;}
        .l_recordPrev__wrap{position:relative;height:100%;overflow:hidden;}
        .l_recordPrev__bg{margin-top:3.1rem;position:absolute;left:0;top:0;width:100%;text-align:center;}
        .l_recordPrev__bg img{width:17.18rem;}
        /* .l_recordPrev__txt{margin-top:6.8rem;position:relative;font-size:1.27rem;color:#7d868e;text-align:center;font-weight:500;letter-spacing:-0.05rem;}
        .l_recordPrev__txt span{font-size:1.41rem;color:#627c94;font-weight:700;} */
  
          .l_recordList{}
            .l_recordList__header{padding:1.27rem 15px 1.4rem;position:relative;background-color:#164369;}
              .l_recordList__tle{font-size:1.27rem;color:#fff;font-weight:700;letter-spacing:-0.09rem;}
              .l_recordList__cmt{margin-top:0.7rem;font-size:0.92rem;color:#fff;letter-spacing:-0.04rem;}
              .l_recordList__cmt span{position:relative;top:0.25rem;}
              .l_recordRank__rule{position:absolute;right:15px;top:1.2rem;width:5.35rem;height:2.11rem;line-height:2.12rem;font-size:1.13rem;color:#fff;text-align:center;border:1px solid #fff;border-radius:2px;letter-spacing:-0.04rem;}
              .l_recordRank__rule:hover, .l_recordRank__rule:focus{border:1px solid #fff;}
            .l_recordList__content{position:relative;background-color:#fff;}
            .l_recordList__content:before{content:"";position:absolute;top:-7px;left:0;width:100%;height:8px;border-radius:10px 10px 0 0;background-color:#fff;}
            .l_recordList__content ul{padding:0 1.06rem;}
            .l_recordList__content li{position:relative;height:4.1rem;font-size:0;border-bottom:1px solid #f2f2f2;overflow:hidden;}
            .l_recordList__content li>*{display:inline-block;vertical-align:top;}
            .l_recordList__content li *{letter-spacing:-0.07rem;}
            .s_nodata .l_recordList__no, .s_nodata .l_recordList__point{display:none;}
            .s_nodata .l_recordList_btn{margin:auto;width:100%;display:block;}
              .l_recordList__no{width:3.5rem;height:100%;line-height:4rem;font-size:1.7rem;color:#7d868e;font-weight:500;text-align:center;}
              .l_recordList__no.out_no{padding-top:0.4rem;line-height:1.2;font-size:1.4rem;}
              .s_ranking .l_recordList__no:after{content:"위";font-size:0.99rem;color:#7d868e;letter-spacing:-0.07rem;}
                .l_recordList_btn{width:100%;max-width:calc(100% - 10rem);height:100%;text-align:left;}
                  .l_recordList__name{position:relative;top:0.05rem;font-size:1.27rem;color:#7d868e;font-weight:500;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;pointer-events:none;}
                  .l_recordList__pos{position:relative;top:-0.15rem;font-size:0.98rem;color:#a7aeb5;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;pointer-events:none;}
              .l_recordList__point{position:absolute;top:0;right:0.3rem;width:5.5rem;font-size:1.41rem;color:#7d868e;line-height:3.95rem;text-align:right;}
            .l_recordList__btn_add{margin:-1px 10px 0;width:calc(100% - 20px);height:2.81rem;display:block;line-height:2.82rem;border-top:1px solid #ddd;color:#444;text-align:center;letter-spacing:-0.07rem;}
            .l_recordList__btn_add:focus, .l_recordList__btn_add:hover{border-top:1px solid #ddd;}
            .l_recordList__btn_add span{margin-left:0.4rem;position:relative;top:-0.1rem;display:inline-block;width:18px;line-height:2.82rem;pointer-events:none;}
            ._overLayer__backdrop._s_on{background-color:rgba(0,0,0,0.7);}
  
      /* 선수상세 */
      /* .playerDetail__wrap{       */
        /*##########*/
        /* position:absolute;top:0;left:0;width:100%;} */
  
  
        .playerDetail__bg{background-color:#3f505d;}
          .playerDetail__tle{padding:1.28rem 1rem 1.56rem;font-size:1.41rem;color:#fff;font-weight:700;letter-spacing:-0.04rem;}
          .playerDetail__bg .l_recordList__content{padding:13px 15px 0;}
            .playerDetail__header{font-size:0;line-height:0;}
            .playerDetail__header>*{display:inline-block;vertical-align:top;}
              .playerDetail__photo{width:7.04rem;height:9.01rem;background-color:#efefef;overflow:hidden;}
              .playerDetail__photo img{width:100%;}
              .playerDetail__summary{margin-left:1.05rem;width:calc(100% - 8.09rem);}
                .playerDetail__name{margin-top:0.05rem;position:relative;top:-0.25rem;line-height:1.5;font-size:1.13rem;color:#3f505d;font-weight:500;letter-spacing:-0.07rem;}
                .playerDetail__info{height:1.76rem;font-size:0;line-height:0;overflow:hidden;}
                .playerDetail__info~.playerDetail__info{border-top:1px solid #d5dce2;}
                .playerDetail__info>*{display:inline-block;height:100%;vertical-align:top;}
                .playerDetail__info.s_top_round{margin-top:0.2rem;border-radius:0.28rem 0.28rem 0 0;}
                .playerDetail__info.s_bottom_round{border-radius:0 0 0.28rem 0.28rem;}
                .playerDetail__info.s_round{margin-top:1px;border-top:none;border-radius:0.28rem;}
                  .playerDetail__txt{width:4.78rem;line-height:1.7rem;font-size:1rem;color:#fff;background-color:#164369;text-align:center;letter-spacing:-0.07rem;}
                  .playerDetail__txt2{padding-left:10px;width:calc(100% - 4.78rem);line-height:1.7rem;font-size:1rem;color:#7d868e;background-color:#edf0f4;letter-spacing:-0.06rem;}
                .s_round .playerDetail__txt{background-color:#d8752d;}
                .s_round .playerDetail__txt2{color:#d8752d;background-color:#fef6f0;}
            .playerDetail__list{margin-top:1.38rem;}
            .playerDetail__list ul{padding:0;border-top:1px solid #d5d9dc;}
            .playerDetail__list li{position:initial;height:initial;font-size:initial;overflow:initial;border-bottom:1px solid #d5d9dc;}
              .playerDetail__listwrap{width:100%;height:4.1rem;font-size:0;line-height:0;}
              .playerDetail__listwrap p{height:100%;font-size:1.06rem;color:#7d868e;vertical-align:middle;letter-spacing:-0.04rem;}
              .playerDetail__listwrap>*{display:inline-block;vertical-align:top;}
                .playerDetail__listno{width:2.82rem;line-height:4rem;font-weight:300;text-align:center;border-right:1px solid #d5d9dc;}
                .playerDetail__infos{width:calc(100% - 2.82rem);}
                .playerDetail__infos p{padding-left:0.7rem;padding-right:0.7rem;}
                  .playerDetail__infotop{height:2rem;font-size:0;line-height:0;}
                  .playerDetail__infotop p{line-height:1.6rem;font-size:1.06rem;color:#7d868e;}
                  .playerDetail__infotop>*{display:inline-block;vertical-align:top;}
                    .playerDetail__comp{padding-top:0.35rem;padding-right:0.3rem;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
                    .playerDetail__infos .playerDetail__comp{font-size:1.13rem;color:#3f505d;}
                  .playerDetail__infos .playerDetail__point{padding-right:0.8rem;padding-left:0.5rem;color:#3f505d;}
                    .playerDetail__result, .playerDetail__point{position:relative;}
                    .playerDetail__result:after, .playerDetail__point:after{content:"";position:absolute;top:0.3rem;right:0;width:1px;height:0.9rem;background-color:#d5dce2;}
                  .playerDetail__infos .playerDetail__result{width:2.95rem;}
                  .playerDetail__infos .playerDetail__pos{height:2rem;line-height:1.7rem;}
                  .playerDetail__infos .playerDetail__pos .after_dash{padding-right:0.7rem;margin-right:0.4rem;position:relative;display:inline-block;}
                  .playerDetail__infos .playerDetail__pos .after_dash:after{content:"";position:absolute;top:0.4rem;right:0;width:1px;height:0.98rem;background-color:#d5dce2;}
  </style>


  <script>
    // var btn_input=document.querySelector(".m_searchPopup__input");
    // btn_input.addEventListener("focus", function(evt){
    //   document.querySelector(".m_searchPopup__fliter").classList.add("on");
    //   document.querySelector(".m_searchPopup__input").classList.add("on");
    // },false);
    // btn_input.addEventListener("blur", function(){
    //   document.querySelector(".m_searchPopup__fliter").classList.remove("on");
    //   document.querySelector(".m_searchPopup__input").classList.remove("on");
    // },false);




    // $('._filterBtn').on('click', function(){
    //   $('._sliderWrap').addClass('s_filtering');
    //   $('._sliderWrap').removeClass('s_searching');

		// 	$('._filterBtn').removeClass('on');
		// 	$('._searchingInput').removeClass('on');
    // })
		// $('._searchingInput').on('click', function(){
		// 	$('._sliderWrap').removeClass('s_filtering');
    //   $('._sliderWrap').addClass('s_searching');

		// 	$('._filterBtn').addClass('on');
		// 	$('._searchingInput').addClass('on');
		// });

    function keyfc(){
      $('._searchName').on({
        click:function(){
          search_layer.close();
          setTimeout(function(){
            $(".l_recordList__no").each(function(no,obj){
              // 순위외 일 때
              if($(obj).html()=="순위외"){
                $(obj).addClass("out_no");
              }
              if($(obj).html()=="&nbsp;"){
                $(obj).next().next().html("");
                $(obj).parent().addClass("s_nodata");
              }
            });

            // 부서검색 맞추기(남자부, 여자부 상관없이 선수가 검색되어서. 선택하면 해당 선수의 부서로 바뀌도록 함)
            var cu_GB=$("._searchName ").eq(0).attr("onmousedown").replace(/'/g, "").split(",")[2];
            div_change.each(function(no,obj){
              if($(obj).val().match(cu_GB)!=null) $(obj).prop("checked", true);
              else $(obj).prop("checked", false);
            });
          },150);

        }
      });
    }
		// $('._panelPlayerList').on('click', '._searchName', function(evt){
		// 	search_layer.close();
		// });

		// $('._panelPlayerList').on('touchstart', function(){
		// 	$('._searchingInput').blur();
		// })

    if(window.matchMedia("(orientation:landscape)").matches){
      $("html").addClass("landscape");
    }else{
      $("html").removeClass("landscape");
    }
    window.addEventListener("orientationchange", function(){
      if(window.matchMedia("(orientation:portrait)").matches){
        $("html").addClass("landscape");
      }else{
        $("html").removeClass("landscape");
      }
    },false);

    // 부서 선택 시
    var div_change=$("input[name='search_div_sd']");
    div_change.off().on({
      "change click":function(){
        search_layer.close();
      }
    });

    // 선수 검색 시 닫기
    $("._searching").off().on({
      click:function(){
        search_layer.close();
      }
    });
  </script>


  <script>

	  var detail_layer = new OverLayer({
	    overLayer: $('._detailLayer'),
	    emptyHTML: '정보를 불러오고 있습니다.',
	    errorHTML: '',
	  })
	  // detail_layer.open();
	  // detail_layer.close();

	  var search_layer = new OverLayer({
	    overLayer: $('._searchLayer'),
	    emptyHTML: '정보를 불러오고 있습니다.',
	    errorHTML: '',
	  })

		search_layer.on('beforeOpen', function(evt){
			$('._filterBtn').removeClass('on');
			$('._searchingInput').removeClass('on');

			$('._sliderWrap').addClass('s_filtering');
			$('._sliderWrap').removeClass('s_searching');
		})

	  var summary_layer = new OverLayer({
	    overLayer: $('._summaryLayer'),
	    emptyHTML: '정보를 불러오고 있습니다.',
	    errorHTML: '',
	  })

	//  function openDetail(){
	//    detail_layer.open();
	//  }
    function openSearching(txt){
      search_layer.open();

      // 부서검색, 선수검색 텍스트
      if(txt!=null){
        $(".m_btnPopup_title").html(txt);
        $(".m_searchPopupTab").removeClass("show");
        $("#searchplayerlist").html(""); 
        $("#SF1").val("");
        if(txt=="부서검색"){
          $(".m_searchPopupTab").eq(0).addClass("show");
        }else if(txt=="선수검색"){
          $(".m_searchPopupTab").eq(1).addClass("show");
        }
      }
    }
	  function openSummary(){
	    summary_layer.open();
	  }
  </script>
