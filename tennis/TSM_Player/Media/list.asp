<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->

  <%

    'iLIUserID = Request.Cookies("SD")("UserID")
    'iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    'iLISportsGb = SportsGb

    iLIUserID = Request.Cookies("SD")("UserID")
    iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    iLIMemberIDXd = decode(Request.Cookies(SportsGb)("MemberIDX"),0)
    iLISportsGb = SportsGb

  	LocateIDX_1 = "16"
  	LocateIDX_2 = "17"
  	'LocateIDX_3 = "13"

  %>

  <%
    Dim view, NowPage
    view = fInject(Request("i1"))
    NowPage = fInject(Request("i2"))
  %>

  <script type="text/javascript">
    var view = "<%=view%>";
    var nowPage = "<%=nowPage%>";
    var selTotalPage = 1;
  	var ipagenum = 1;
  	function fn_list() {
  		selSearchValue5 = document.getElementById('selSearch5').value;
  		selSearchValue4 = document.getElementById('selSearch4').value;
  		selSearchValue3 = document.getElementById('selSearch3').value;
  		selSearchValue2 = document.getElementById('selSearch2').value;
  		selSearchValue1 = document.getElementById('selSearch1').value;
  		selSearchValue = document.getElementById('selSearch').value;
  		txtSearchValue = document.getElementById('txtSearch').value;

  		var strAjaxUrl = "../Ajax/News_List.asp";
  		$.ajax({
  			url: strAjaxUrl,
  			type: 'POST',
  			dataType: 'html',
  			data: {
  				i2: ipagenum,
  				iSubType: selSearchValue1,
  				iNoticeYN: selSearchValue2,
  				iDivision: selSearchValue3,
  				iSearchCol1: selSearchValue4,
  				iSearchCol2: selSearchValue5,
  				iSearchCol: selSearchValue,
  				iSearchText: txtSearchValue
  			},
  			async: false,
  			success: function (retDATA) {
  				//alert(retDATA);
  				if (retDATA) {
  					$('#gametitlelist').append(retDATA);
  					ipagenum = ipagenum + 1;
  				} else {
  					//$('#divselss').html("");
  				}
  			}, error: function (xhr, status, error) {
  				if (error != "") {
  					alert("News_List, 오류발생! - 시스템관리자에게 문의하십시오!");
  					return;
  				}
  			}
  		});

  		if (ipagenum == selTotalPage) {
  			$('#plusTab').css('display', 'none');
  			$('#lastTab').css('display', 'block');
  		}
  		else {
  			$('#lastTab').css('display', 'none');
  			$('#plusTab').css('display', 'block');
  		}

  	}

  	function fn_listcnt() {

  		selSearchValue5 = document.getElementById('selSearch5').value;

  		selSearchValue4 = document.getElementById('selSearch4').value;
  		selSearchValue3 = document.getElementById('selSearch3').value;

  		selSearchValue2 = document.getElementById('selSearch2').value;
  		selSearchValue1 = document.getElementById('selSearch1').value;
  		selSearchValue = document.getElementById('selSearch').value;
  		txtSearchValue = document.getElementById('txtSearch').value;

  		var strAjaxUrl = "../Ajax/NewsCnt_List.asp";
  		$.ajax({
  			url: strAjaxUrl,
  			type: 'POST',
  			dataType: 'html',
  			data: {
  				i2: ipagenum,
  				iSubType: selSearchValue1,
  				iNoticeYN: selSearchValue2,
  				iDivision: selSearchValue3,
  				iSearchCol1: selSearchValue4,
  				iSearchCol2: selSearchValue5,
  				iSearchCol: selSearchValue,
  				iSearchText: txtSearchValue
  			},
  			async: false,
  			success: function (retDATA) {
  				//alert(retDATA);
  				if (retDATA) {
  					selTotalPage = Number(retDATA) + 1;
  				} else {
  					//$('#divselss').html("");
  				}
  			}, error: function (xhr, status, error) {
  				if (error != "") {
  					alert("NewsCnt_List, 오류발생! - 시스템관리자에게 문의하십시오!");
  					return;
  				}
  			}
  		});

  	}

  	function fn_list1() {
  		$('#gametitlelist').html("");
  		ipagenum = 1;
  		fn_listcnt();
  		fn_list();
  	}

    function fn_ReadView(i1) {
      $('#viewContent').html('');

      $.ajax({
  			url: '../Ajax/News_view.asp',
  			type: 'get',
  			dataType: 'html',
        data: {

          i1: i1

        },
  			success: function(retDATA){
          setTimeout(function(){
            $('#viewContent').html(retDATA);
            // layer.innerContent(retDATA);
          }, 400);

  			},
        error: function(xhr, status, error){
  				if (error != "") {
  					alert("오류발생! - News_view, 시스템관리자에게 문의하십시오!");
  					return;
  				}
  			}
      });
    }
  </script>
</head>
<body>
<div class="l">

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">SD 뉴스</h1>
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

    <!-- S : 조회부분 -->
    <div class="m_searchBar">
      <!--
      <span class="srch_box">
      <input type="text" class="search_box" placeholder="검색어를 입력해 주세요">
      </span>
      -->


      <!-- 메인 공지 유무 -->
      <input type="hidden" id="selSearch2" name="selSearch2" value="" />
      <!--<select id="selSearch2" name="selSearch2" class="title_select">
        <option value="">전체-공지유무</option>
        <option value="Y">Y</option>
        <option value="N">N</option>
      </select>-->

      <!-- ColumnistIDX -->
      <input type="hidden" id="selSearch5" name="selSearch5" value="" />
      <!--<select id="selSearch5" name="selSearch5" class="title_select">
      <option value="">전체-구분</option>
      <%
        '' 리스트 조회
        'iType = "1"
        '
        'LCnt1 = 0
        '
        'LSQL = "EXEC Community_tblColumnist_S '" & iType & "','" & iLoginID & "','','','','',''"
        ''response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        ''response.End
        '
        'Set LRs = DBCon5.Execute(LSQL)
        '
        'If Not (LRs.Eof Or LRs.Bof) Then
        '  Do Until LRs.Eof
        '      LCnt1 = LCnt1 + 1
        '			iColumnistIDX1 =  LRs("ColumnistIDX")
        '			ieColumnistIDX1 = encode(iColumnistIDX1,0)
        '			iSubject1 =  LRs("Subject")
      %>
      <option value="<%'=ieColumnistIDX1 %>"><%'=iSubject1 %></option>
      <%
          '  LRs.MoveNext
          'Loop
      %>

      <%
          'Else
      %>

      <%
        'End If
        '
        'LRs.close
      %>
      </select>-->

      <!-- Division -->
      <!--<input type="hidden" id="selSearch3" name="selSearch3" value="<%'=iDivision %>" />-->
      <!--<select id="selSearch3" name="selSearch3" class="title_select">
        <option value="1">전체-구분</option>
        <option value="2">일반뉴스</option>
        <option value="3">영상뉴스</option>
      </select>-->
      <div class="m_searchBar__inputWrap s_select">
        <select id="selSearch3" name="selSearch3" class="m_searchBar__select" onchange="javascript:fn_list1();">
          <!-- 아래 사용해도 돼나 리플레쉬 방지 위해 ajax 처리 -->
          <!--<select id="selSearch3" name="selSearch3" onchange="javascript:fn_selSearch();">-->
          <option value="1">전체</option>
          <%
            ' 리스트 조회
            iType1 = "1"

            LCnt1 = 0
            iCType = "MDivision"
            iCSubType = "MNews"

            LSQL = "EXEC Community_CodePropertyName_S '" & iType1 & "','" & iLoginID & "','" & iCType & "','" & iCSubType & "','','','','',''"
            'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
            'response.End

            Set LRs = DBCon4.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                  LCnt1 = LCnt1 + 1
                  iCode1 =  LRs("Code")
                  'ieCode1 = encode(iCode1,0)
                  iName1 =  LRs("Name")
          %>
          <option value="<%=iCode1 %>"><%=iName1 %></option>
          <%
                LRs.MoveNext
              Loop
          %>

          <%
            Else
          %>

          <%
            End If

            LRs.close

            'DBClose4()
          %>
        </select>
        <span class="m_searchBar__selectIndicator"></span>
      </div>

      <!-- Cnt -->
      <!--<input type="hidden" id="selSearch4" name="selSearch4" value="S2Y" />-->
      <div class="m_searchBar__inputWrap s_select">
        <select id="selSearch4" name="selSearch4" class="m_searchBar__select" onchange="javascript:fn_list1();">
          <!-- 아래 사용해도 돼나 리플레쉬 방지 위해 ajax 처리 -->
          <!--<select id="selSearch4" name="selSearch4" onchange="javascript:fn_selSearch();">-->
          <option value="S2Y">최신순</option>
          <option value="S2C">많이본순</option>
        </select>
        <span class="m_searchBar__selectIndicator"></span>
      </div>

      <!-- Code 구분 -->
      <input type="hidden" id="selSearch1" name="selSearch1" value="" />

      <!-- 검색 구분 -->
      <input type="hidden" id="selSearch" name="selSearch" value="T" />
      <!--<select id="selSearch" name="selSearch" class="title_select">
        <option value="T">전체</option>
        <option value="S">제목</option>
        <option value="C">내용</option>
        <option value="N">작성자</option>
      </select>-->

      <!-- 검색어 구분 -->
      <input type="hidden" id="txtSearch" name="txtSearch" value="" />
      <!--<input type="text" id="txtSearch" name="txtSearch" class="title_input in_2"/>-->
      <!--<a href="javascript:;" id="btnselSearch" name="btnselSearch" onClick="javascript:fn_selSearch();" class="btn_skyblue">검색</a>-->

      <!-- !@# 추가 s: 검색어 -->
      <!-- <div class="m_searchBar__inputWrap s_keyword">
        <input type="text" id="txtSearch" name="txtSearch" class="m_searchBar__keyword"/>
      </div>
      <a href="javascript:;" id="btnselSearch" name="btnselSearch" onClick="javascript:fn_selSearch();" class="m_searchBar__btnSearching">검색</a> -->
      <!-- !@# 추가 e: 검색어 -->

    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_mediaList">
      <ul id="gametitlelist">

        <!-- <li>
        	<a href="javascript:;" onclick="javascript:ReadListLink('353337','1');">
        		<div class="img">
        			<div class="mv_box">
        				<img src="/FileImg/\30[4].JPG" alt="" class="photo">
        			</div>
        		</div>

        		<div class="r_con">

              <p class="list_name">
                경기도, 2년 만에 전국체전 테니스 종합우승
              </p>

              <p class="bt_con">
                <span class="date">2018-10-18</span>
                <span class="line"></span>
                <span class="companny_name">테니스코리아</span>
        				<span class="views_number"><span>&nbsp;&nbsp;&nbsp;&nbsp;3647</span> 읽음</span>
              </p>
            </div>

        	</a>
        </li> -->

      </ul>
    </div>

		<div id="plusTab" class="m_listMore">
			<a href="javascript:;" class="m_listMore__btn" onclick="javascript:fn_list();"><span class="m_listMore__btnTxt s_more">더보기</span></a>
		</div>
		<div id="lastTab" class="m_listMore s_hidden">
			<a class="m_listMore__btn"><span class="m_listMore__btnTxt">마지막</span></a>
		</div>
  </div>

  <div class="l_upLayer [ _overLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox [ _overLayer__box ]">      
      <div class="l_upLayer__wrapTit">
        <h1 class="l_upLayer__tit [ _overLayer__title ]">SD뉴스</h1>
        <button class="l_upLayer__close [ _overLayer__close ]">닫기</button>
      </div>
      <div class="l_uplayer__wrapCont [ _overLayer__wrap ]">
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

        <div id="viewContent"></div>
      </div>
    </div>
  </div>


  <!-- #include file = '../include/bottom_menu.asp' -->
  <!-- #include file = "../include/bot_config.asp" -->

  <script type="text/javascript">
    fn_list1();

    var referrer = document.referrer || '../Main/index.asp';
    history.replaceState('list', null, null);
    window.onpopstate = function(evt){
      if(evt.state == 'list' && layer.status == 'open'){
        layer.close()
      }else{
        location.href = referrer
      }
    }

    var layer = new OverLayer({
      overLayer: $('._overLayer'),
      emptyHTML: '정보를 불러오고 있습니다.',
      errorHTML: '',
    });
    layer.on('beforeOpen', function(){history.pushState('view', null, null);});
    layer.on('beforeClose', function(){history.pushState('list', null, null);});

    $('#gametitlelist').on('click', '._view', function(evt){
      evt.preventDefault();
      layer.open({ title:'SD뉴스' });
    });

    // 메인에서 넘어올때
    if(view){
      layer.open({transition:false});
      fn_ReadView(view);
    }



  </script>

</div>
</body>
</html>
<% AD_DBClose() %>
<!-- #include file="../Library/sub_config.asp" -->