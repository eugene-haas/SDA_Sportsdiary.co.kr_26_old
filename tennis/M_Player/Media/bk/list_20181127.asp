<!DOCTYPE html>
<html lang="ko">
<head>
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
  	'LocateIDX_2 = "10"
  	'LocateIDX_3 = "13"

  %>

  <%
    Dim iTotalCount, iTotalPage, LCnt0 '페이징
    LCnt0 = 0

    Dim LCnt, NowPage, PagePerData '리스트
    LCnt = 0


  	' 칼람개설 페이징 번호
  	iPageCnt = fInject(Request("iPageCnt"))

  	If Len(iPageCnt) = 0 Then
      iPageCnt = "1"
    End If


    'iDivision = "1"

  	iDivision = fInject(Request("iDivision"))

  	If Len(iDivision) = 0 Then
      iDivision = "1"
    End If

  	'1 : 전체 - 일반뉴스+영상뉴스
  	'2 : 일반뉴스
  	'3 : 영상뉴스
  	'12 : 컬럼리스트

    iLoginID = decode(fInject(Request.cookies(SportsGb)("UserID")),0)
  	'iLoginID = Request.Cookies("UserID")
  	'iLoginID = decode(iLoginID,0)

    NowPage = fInject(Request("i2"))  ' 현재페이지
    PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
    BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

    'Request Data
    iSubType = fInject(Request("iSubType"))
    iSearchText = fInject(Request("iSearchText"))
    iSearchCol = fInject(Request("iSearchCol"))
    iNoticeYN = fInject(Request("iNoticeYN"))

  	iSearchCol1 = fInject(Request("iSearchCol1"))	' S2Y : 최신순, S2C : 많이본순

  	ieSearchCol2 = fInject(Request("iSearchCol2")) ' ColumnistIDX
  	iSearchCol2 = decode(ieSearchCol2,0)

    If Len(NowPage) = 0 Then
      NowPage = 1
    End If

    if(Len(iSubType) = 0) Then iSubType = "" ' 구분
    if(Len(iNoticeYN) = 0) Then iNoticeYN = "" ' 구분
    if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' 검색 구분자
    if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

  	if(Len(iSearchCol1) = 0) Then iSearchCol1 = "S2Y"

  	if(Len(iSearchCol2) = 0) Then iSearchCol2 = ""

    iType = "2"                      ' 1:조회, 2:총갯수

  	ipdsgroup = ""				' 마이페이지>게시글관리 : 게시판구분
  	'iSearchCol2 = ""		' tblColumnist 컬럼리스트 그룹 IDX
  	iDayGubun = ""				' 랭킹시상식>년간,월간

    LSQL = "EXEC Community_Board_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','" & global_MainCLCnt & "','" & ipdsgroup & "','" & iDayGubun & "','" & iSearchCol2 & "','" & iSearchCol1 & "','','','','',''"
    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End

    Set LRs = DBCon4.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          iTotalCount = LRs("TOTALCNT")
          iTotalPage = LRs("TOTALPAGE")
        LRs.MoveNext
      Loop
    End If
    LRs.close

  	'DBClose4()
  %>

  <script type="text/javascript">
  	var selTotalPage = "<%=iTotalPage%>";
  	selTotalPage = Number(selTotalPage) + 1;

  	var iPageCnt = "<%=iPageCnt%>";

  	var selSearchValue1 = "<%=iSubType%>";
  	var selSearchValue2 = "<%=iNoticeYN%>";
  	var selSearchValue = "<%=iSearchCol%>";
  	var txtSearchValue = "<%=iSearchText%>";
  	var selSearchValue3 = "<%=iDivision%>";
  	var selSearchValue4 = "<%=iSearchCol1%>";
  	var selSearchValue5 = "<%=ieSearchCol2%>";


  	function ReadListLink(i1, i2) {
  		post_to_url('./view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iPageCnt': i2 });
  	}

  	function fn_selSearch() {
  		selSearchValue5 = document.getElementById('selSearch5').value;
  		selSearchValue4 = document.getElementById('selSearch4').value;
  		selSearchValue3 = document.getElementById('selSearch3').value;
  		selSearchValue2 = document.getElementById('selSearch2').value;
  		selSearchValue1 = document.getElementById('selSearch1').value;
  		selSearchValue = document.getElementById('selSearch').value;
  		txtSearchValue = document.getElementById('txtSearch').value;

  		post_to_url('./list.asp', { 'i2': 1, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
  	}

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

  </script>
</head>
<body class="sd-body">
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>SD 뉴스</h1>
    <!-- #include file="../include/sub_header_right.asp" -->
  </div>
  <!-- E: sub-header -->

  <!-- #include file = "../include/gnb.asp" -->

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
  <div class="sd-searching-box-B">
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
    <div class="selectWrap">
      <select id="selSearch3" name="selSearch3" class="category" onchange="javascript:fn_list1();">
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

          DBClose4()
        %>
      </select><span class="indicator"></span>
    </div>

    <!-- Cnt -->
    <!--<input type="hidden" id="selSearch4" name="selSearch4" value="S2Y" />-->
    <div class="selectWrap">
      <select id="selSearch4" name="selSearch4" class="ordering" onchange="javascript:fn_list1();">
        <!-- 아래 사용해도 돼나 리플레쉬 방지 위해 ajax 처리 -->
        <!--<select id="selSearch4" name="selSearch4" onchange="javascript:fn_selSearch();">-->
        <option value="S2Y">최신순</option>
        <option value="S2C">많이본순</option>
      </select><span class="indicator"></span>
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
    <!-- <input type="text" id="txtSearch" name="txtSearch" class="keyword"/>
    <a href="javascript:;" id="btnselSearch" name="btnselSearch" onClick="javascript:fn_selSearch();" class="searching">검색</a> -->
    <!-- !@# 추가 e: 검색어 -->

  </div>
  <!-- E : 조회부분 -->


  <div class="sd-main-A sd-scroll [ _sd-scroll ]">
    <div class="sd-board-box-C">
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

		<div id="plusTab" class="sd-more-wrap-A">
			<a href="javascript:;" onclick="javascript:fn_list();">
				<span class="txt">더보기</span>
				<span class="icon_more"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
			</a>
		</div>

		<div id="lastTab" class="sd-more-wrap-A" style="display:none;">
			<a href="javascript:;">
				<span class="txt">마지막</span>
				<!--<span class="icon_more"><i class="fa fa-angle-down" aria-hidden="true"></i></span>-->
			</a>
		</div>

    <!-- s: !@# -->
    <div id="empty" class="sd-empty-wrap-C">
      [<span id="emtpyKeyword" class="keyword">검색어</span>]에 대한<br /> 검색결과가 없습니다.
    </div>
    <!-- e: !@# -->
  </div>
  <!-- E: main -->


  <!-- s: !@# 추가 -->
  <div class="sd-over-layer [ _sd-over-layer ]">
    <div class="backdrop [ _sd-over-layer__backdrop ]"></div>
    <div class="content-box [ _sd-over-layer__box ]">
      <div class="title-wrap [ _sd-over-layer__titleWrap ]">
        <h1 class="title [ _sd-over-layer__title ]">SD뉴스</h1>
        <button class="btn-close [ _sd-over-layer__close ]">닫기</button>
      </div>
      <div class="content-wrap [ _sd-over-layer__contentWrap ]"></div>
    </div>
  </div>
  <!-- e: !@# -->


  <!-- #include file = '../include/bottom_menu.asp' -->
  <!-- #include file = "../include/bot_config.asp" -->
  <script type="text/javascript">

  	$("#txtSearch").val(txtSearchValue);
  	$("#selSearch").val(selSearchValue);
  	$("#selSearch1").val(selSearchValue1);
  	$("#selSearch2").val(selSearchValue2);

  	$("#selSearch3").val(selSearchValue3);
  	$("#selSearch4").val(selSearchValue4);

  	$("#selSearch5").val(selSearchValue5);

  	iPageCnt = Number(iPageCnt);

  	for (var i = 0; i < iPageCnt; i++) {
  		fn_list();
  	}

  </script>
  <script type="text/javascript">
    var historyManager = new HistoryManager();
    historyManager.setReferrer('../Main/index.asp');
    historyManager.replaceHistory('list');
    historyManager.addPopEvent(function(evt){
      if(evt.state == 'list'){
        history.replaceState('view', null, null);
        layer.close();
      }
      else
        location.href = document.referrer || historyManager.referrer;
    });

    var layer = new OverLayer({
      overLayer: $('._sd-over-layer'),
      emptyHTML: '정보를 불러오고 있습니다.',
      errorHTML: '',
    });
    layer.on('beforeOpen', function(){
      historyManager.pushHistory('view');
    });
    layer.on('beforeClose', function(){
      historyManager.pushHistory('list');
    });

    // 메인에서 넘어올때
    if(true){
      layer.empty();
      layer.open({transition:false});
    }

    $.ajax({
      url: '../Ajax/News_view.asp',
      type: 'get',
      dataType: 'html',
      data: {},
      success: function(retDATA){

        setTimeout(function(){
          layer.innerContent(retDATA);
        }, 400);

      },
      error: function(xhr, status, error){
        if (error != "") {
          alert("오류발생! - 시스템관리자에게 문의하십시오!");
          return;
        }
      }
    });


    $('#gametitlelist').on('click', 'a', function(evt){
      evt.preventDefault();
      layer.empty();
      layer.open({ title:'SD뉴스' });

      //$.ajax({
      //  url: '../Ajax/News_view.asp',
      //  type: 'get',
      //  dataType: 'html',
      //  data: {},
      //  success: function(retDATA){
      //
      //    setTimeout(function(){
      //      layer.innerContent(retDATA);
      //    }, 400);
      //
      //  },
      //  error: function(xhr, status, error){
      //    if (error != "") {
      //      alert("오류발생! - 시스템관리자에게 문의하십시오!");
      //      return;
      //    }
      //  }
      //});

      // ReadListLink(this.dataset.mseq, this.dataset.np);

    });

    function fn_ReadView(i1) {

      $.ajax({
  			url: '../Ajax/News_view.asp',
  			type: 'get',
  			dataType: 'html',
        data: {

          i1: i1

        },
  			success: function(retDATA){

          setTimeout(function(){
            layer.innerContent(retDATA);
          }, 400);

  			},
        error: function(xhr, status, error){
  				if (error != "") {
  					alert("오류발생! - News_view, 시스템관리자에게 문의하십시오!");
  					return;
  				}
  			}
      });

      // ReadListLink(this.dataset.mseq, this.dataset.np);

    }

  </script>
</body>
</html>
<% AD_DBClose() %>
