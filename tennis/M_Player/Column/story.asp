<!-- #include file="../include/config.asp" -->

<%
  Dim iTotalCount, iTotalPage, LCnt0 '페이징
  LCnt0 = 0

  Dim LCnt, NowPage, PagePerData '리스트
  LCnt = 0

	TSubject = fInject(Request("TSubject"))

	If Len(TSubject) = 0 Then
    TSubject = "SD칼럼"
  End If

	' 칼람개설 페이징 번호
	iPageCnt = fInject(Request("iPageCnt"))

	If Len(iPageCnt) = 0 Then
    iPageCnt = "1"
  End If

	' 칼람리스트 페이징 번호
	iSPageCnt = fInject(Request("iSPageCnt"))

	If Len(iSPageCnt) = 0 Then
    iSPageCnt = "1"
  End If

  'iDivision = "1"

	' 컬럼개설 리스트에서 넘어 오는건 1임으로 그냥 12로 고정 시킴
	' 예는 테이블도 틀리고 12임
	'iDivision = fInject(Request("iDivision"))

	'If Len(iDivision) = 0 Then
  '  iDivision = "12"
  'End If

	iDivision = "13" '13은 DB에서 12로 바뀜

	'1 : 전체 - 일반뉴스+영상뉴스
	'2 : 일반뉴스
	'3 : 영상뉴스
	'12 : 컬럼리스트 - 어드민
	'13 : 칼럼리스트 - 유저

  'iLoginID = decode(fInject(Request.cookies(global_HP)("UserID")),0)
	iLoginID = Request.Cookies("UserID")
	iLoginID = decode(iLoginID,0)

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

	DBClose4()
%>

<script type="text/javascript">

	// 더보기, 마지막 구분
	var selTotalPage = "<%=iTotalPage%>";
	selTotalPage = Number(selTotalPage) + 1;

	var selSearchValue1 = "<%=iSubType%>";
	var selSearchValue2 = "<%=iNoticeYN%>";
	var selSearchValue = "<%=iSearchCol%>";
	var txtSearchValue = "<%=iSearchText%>";

	var selSearchValue3 = "<%=iDivision%>";
	var selSearchValue4 = "<%=iSearchCol1%>";

	var selSearchValue5 = "<%=ieSearchCol2%>";

	var iSPageCnt = "<%=iSPageCnt%>";
	var iPageCnt = "<%=iPageCnt%>";


	function TopListLink(i2) {
		var lselSearchValue5 = "";
		post_to_url('./list.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': lselSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iPageCnt': i2 });
	}

	function ReadListLink(i1, i2, TSubject) {
		post_to_url('./view.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'TSubject': TSubject, 'iPageCnt': iPageCnt, 'iSPageCnt': i2 });
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

		var strAjaxUrl = "../Ajax/Column_List.asp";
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
					alert("오류발생! - 시스템관리자에게 문의하십시오!");
					return;
				}
			}
		});

		if (ipagenum == selTotalPage) {
			$('#plusTab').css('display', 'none');
			$('#lastTab').css('display', 'block');
		}

	}

</script>

  <body>
    <!-- S: sub-header -->
    <div class="sd-header sd-header-sub">
      <!-- #include file="../include/sub_header_arrow.asp" -->
      <h1><%=TSubject%></h1>
      <!-- #include file="../include/sub_header_gnb.asp" -->
    </div>
    <!-- #include file = "../include/gnb.asp" -->
    <!-- E: sub-header -->

    <!-- S: container_body -->
    <div class="part_main tennis_part">

      <!-- S: main -->
      <div class="main">

        <!--
        <span class="srch_box">
        <input type="text" class="search_box" placeholder="검색어를 입력해 주세요">
        </span>
        -->
        

				<!-- S : 조회부분 -->
				<div class="search_box">

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
					<input type="hidden" id="selSearch3" name="selSearch3" value="<%=iDivision %>" />
					<!--<select id="selSearch3" name="selSearch3" class="title_select">
					  <option value="1">전체-구분</option>
					  <option value="2">일반뉴스</option>
					  <option value="3">영상뉴스</option>
					</select>-->

					<!-- Cnt -->
					<input type="hidden" id="selSearch4" name="selSearch4" value="S2Y" />
					<!--<select id="selSearch4" name="selSearch4" class="title_select">
					  <option value="S2Y">최신순</option>
					  <option value="S2C">많이본순</option>
					</select>-->

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
				</div>
				<!-- E : 조회부분 -->

        <!-- s: 칼럼스토리 시작 -->
				<div class="column_story_page">
					<ul id="gametitlelist">

					</ul>
					<div class="more_btn">
						<a href="javascript:;" onclick="javascript:TopListLink('<%=iPageCnt %>');">전체 칼럼니스트 목록</a>
					</div>
					<div id="plusTab" class="mored_btn">
						<a href="javascript:;" onclick="javascript:fn_list();">
							<span class="txt">더보기</span>
							<span class="icon_more"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
						</a>
					</div>
					<div id="lastTab" class="mored_btn" style="display:none;">
						<a href="javascript:;">
							<span class="txt">마지막</span>
							<span class="icon_more"><i class="fa fa-angle-down" aria-hidden="true"></i></span>
						</a>
					</div>
				</div>
				<!-- e: 칼럼스토리 시작 -->
      </div>
      <!-- E: main -->


      <!-- S: main_footer -->
      <!-- #include file = '../include/main_footer.asp' -->
      <!-- E: main_footer -->

    </div>
    <!-- E: container_body -->

    <!-- S: bot_config -->
    <!-- #include file = "../include/bot_config.asp" -->
    <!-- E: bot_config -->
  </body>


<script type="text/javascript">

	$("#txtSearch").val(txtSearchValue);
	$("#selSearch").val(selSearchValue);
	$("#selSearch1").val(selSearchValue1);
	$("#selSearch2").val(selSearchValue2);

	$("#selSearch3").val(selSearchValue3);
	$("#selSearch4").val(selSearchValue4);

	$("#selSearch5").val(selSearchValue5);

	iSPageCnt = Number(iSPageCnt);

	for (var i = 0; i < iSPageCnt; i++) {
		fn_list();
	}

</script>

</html>
