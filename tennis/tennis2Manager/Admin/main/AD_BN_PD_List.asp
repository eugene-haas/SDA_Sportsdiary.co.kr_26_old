<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
	RoleType = "K003ACM"
%>
<!--#include file="CheckRole.asp"-->

<%

  Dim iTotalCount, iTotalPage, LCnt0 '페이징
  LCnt0 = 0

  Dim LCnt, NowPage, PagePerData '리스트
  LCnt = 0

  'iDivision = "1"

	iDivision = fInject(Request("iDivision"))

	If Len(iDivision) = 0 Then
    iDivision = "0"
  End If


  'iLoginID = decode(fInject(Request.cookies(global_HP)("UserID")),0)
	iLoginID = Request.Cookies("UserID")
	iLoginID = decode(iLoginID,0)

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
  BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

	PagePerData = "50"
	BlockPage = "10"

  'Request Data
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))

	iSearchCol1 = fInject(Request("iSearchCol1"))	' S2Y : 최신순, S2C : 많이본순

	iViewYN = fInject(Request("iViewYN"))

	iCateLocate1 = fInject(Request("iCateLocate1"))
	iCateLocate2 = fInject(Request("iCateLocate2"))
	iCateLocate3 = fInject(Request("iCateLocate3"))
	iCateLocate4 = fInject(Request("iCateLocate4"))

  If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' 검색 구분자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어
	if(Len(iSearchCol1) = 0) Then iSearchCol1 = "S2Y" ' WriteDate 순
	if(Len(iImageType) = 0) Then iImageType = ""
	if(Len(iViewYN) = 0) Then iViewYN = ""
	if(Len(iLocateGb) = 0) Then iLocateGb = ""

	if(Len(iCateLocate1) = 0) Then iCateLocate1 = ""
	if(Len(iCateLocate2) = 0) Then iCateLocate2 = ""
	if(Len(iCateLocate3) = 0) Then iCateLocate3 = ""
	if(Len(iCateLocate4) = 0) Then iCateLocate4 = ""


  iType = "2"                      ' 1:조회, 2:총갯수


	iSportsGb = "tennis"

  LSQL = "EXEC AD_tblADProductLocate_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSportsGb & "','" & iCateLocate1 & "','" & iCateLocate2 & "','" & iCateLocate3 & "','" & iCateLocate4 & "','" & iViewYN & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = DBCon6.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
    Loop
  End If
  LRs.close
%>

<script type="text/javascript">

	var selSearchValue1 = "<%=iSubType%>";
	var selSearchValue2 = "<%=iNoticeYN%>";
	var selSearchValue = "<%=iSearchCol%>";
	var txtSearchValue = "<%=iSearchText%>";

	var selSearchValue3 = "<%=iDivision%>";
	var selSearchValue4 = "<%=iSearchCol1%>";

	var selSearchValue6 = "<%=iViewYN%>";

	var selSearchValue8 = "<%=iCateLocate1%>";
	var selSearchValue9 = "<%=iCateLocate2%>";
	var selSearchValue10 = "<%=iCateLocate3%>";
	var selSearchValue11 = "<%=iCateLocate4%>";

	function WriteLink(i2) {
		post_to_url('./AD_BN_PD_Write.asp', { 'i2': i2, 'iType': '1', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iViewYN': selSearchValue6, 'iCateLocate1': selSearchValue8, 'iCateLocate2': selSearchValue9, 'iCateLocate3': selSearchValue10, 'iCateLocate4': selSearchValue11 });
	}

	function ReadLink(i1, i2) {
		post_to_url('./AD_BN_PD_Write.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iViewYN': selSearchValue6, 'iCateLocate1': selSearchValue8, 'iCateLocate2': selSearchValue9, 'iCateLocate3': selSearchValue10, 'iCateLocate4': selSearchValue11 });
	}

	function PagingLink(i2) {
		post_to_url('./AD_BN_PD_List.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iViewYN': selSearchValue6, 'iCateLocate1': selSearchValue8, 'iCateLocate2': selSearchValue9, 'iCateLocate3': selSearchValue10, 'iCateLocate4': selSearchValue11 });
	}

	function fn_selSearch() {

		selSearchValue11 = document.getElementById('selSearch11').value;
		selSearchValue10 = document.getElementById('selSearch10').value;
		selSearchValue9 = document.getElementById('selSearch9').value;
		selSearchValue8 = document.getElementById('selSearch8').value;

		selSearchValue6 = document.getElementById('selSearch6').value;

		selSearchValue4 = document.getElementById('selSearch4').value;
		selSearchValue3 = document.getElementById('selSearch3').value;

		selSearchValue2 = document.getElementById('selSearch2').value;
		selSearchValue1 = document.getElementById('selSearch1').value;
		selSearchValue = document.getElementById('selSearch').value;
		txtSearchValue = document.getElementById('txtSearch').value;

		post_to_url('./AD_BN_PD_List.asp', { 'i2': 1, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iViewYN': selSearchValue6, 'iCateLocate1': selSearchValue8, 'iCateLocate2': selSearchValue9, 'iCateLocate3': selSearchValue10, 'iCateLocate4': selSearchValue11 });
	}

	function fn_CateLocate1(tvalue) {

		$('#selSearch9').html('<option value="">전체-중분류</option>');
		$('#selSearch10').html('<option value="">전체-소분류</option>');
		$('#selSearch11').html('<option value="">전체-광고순번</option>');

		var vCateLocate1 = tvalue;

		var strAjaxUrl = "./Ajax/Ad/AD_BN_PD_List_Sel1.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			async: false,
			data: {
				vCateLocate1: vCateLocate1
			},
			success: function (retDATA) {
				if (retDATA) {
					$('#selSearch9').html(retDATA);
					if (retDATA == '\r\n<option value=\"\">전체-중분류</option>\r\n') {

            fn_CateLocate4();

          }
				} else {
					$('#selSearch9').html("");
				}
			}, error: function (xhr, status, error) {
				if (error != '') {
					alert("fn_CateLocate1 : 조회중 에러발생 - 시스템관리자에게 문의하십시오!");
				}
			}
		});

	}

	function fn_CateLocate2(tvalue1) {

		$('#selSearch10').html('<option value="">전체-소분류</option>');
		$('#selSearch11').html('<option value="">전체-광고순번</option>')

		var vCateLocate1 = $('#selSearch8').val();
		var vCateLocate2 = tvalue1;

		var strAjaxUrl = "./Ajax/Ad/AD_BN_PD_List_Sel2.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			async: false,
			data: {
				vCateLocate1: vCateLocate1,
				vCateLocate2: vCateLocate2
			},
			success: function (retDATA) {
				if (retDATA) {
					$('#selSearch10').html(retDATA);
					if (retDATA == '\r\n<option value=\"\">전체-소분류</option>\r\n') {

            fn_CateLocate4();

          }
				} else {
					$('#selSearch10').html("");
				}
			}, error: function (xhr, status, error) {
				if (error != '') {
					alert("fn_CateLocate2 : 조회중 에러발생 - 시스템관리자에게 문의하십시오!");
				}
			}
		});

	}

	function fn_CateLocate3(tvalue2) {

		$('#selSearch11').html('<option value="">전체-광고순번</option>')

		var vCateLocate1 = $('#selSearch8').val();
		var vCateLocate2 = $('#selSearch9').val();
		var vCateLocate3 = tvalue2;

		var strAjaxUrl = "./Ajax/Ad/AD_BN_PD_List_Sel3.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			async: false,
			data: {
				vCateLocate1: vCateLocate1,
				vCateLocate2: vCateLocate2,
				vCateLocate3: vCateLocate3
			},
			success: function (retDATA) {
				if (retDATA) {
					$('#selSearch11').html(retDATA);
				} else {
					$('#selSearch11').html("");
				}
			}, error: function (xhr, status, error) {
				if (error != '') {
					alert("fn_CateLocate3 : 조회중 에러발생 - 시스템관리자에게 문의하십시오!");
				}
			}
		});

	}

	function fn_CateLocate4() {

		var vCateLocate1 = $('#selSearch8').val();
		var vCateLocate2 = $('#selSearch9').val();

		var strAjaxUrl = "./Ajax/Ad/AD_BN_PD_List_Sel4.asp";
		$.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',
			async: false,
			data: {
				vCateLocate1: vCateLocate1,
				vCateLocate2: vCateLocate2
			},
			success: function (retDATA) {
				if (retDATA) {
					$('#selSearch11').html(retDATA);
				} else {
					$('#selSearch11').html("");
				}
			}, error: function (xhr, status, error) {
				if (error != '') {
					alert("fn_CateLocate4 : 조회중 에러발생 - 시스템관리자에게 문의하십시오!");
				}
			}
		});

	}

</script>


   <section>
    <div id="content">

    <!-- S: 네비게이션 -->
    <div  class="navigation_box">
      <div class="loaction">
        <strong>광고 관리</strong> &gt; 광고 연결 관리
      </div>
    </div>
    <!-- E: 네비게이션 -->
    <div class="search_top community">
      <div class="search_box sch">
				<!-- 메인 공지 유무 -->
        <!--<input type="hidden" id="selSearch2" name="selSearch2" value="N" />-->
        <table class="sch-table">
        <caption>검색조건 선택 및 입력</caption>
        <colgroup>
          <col width="120px" />
					<col width="120px" />
          <col width="120px" />
          <col width="120px" />
					<col width="120px" />
					<col width="100px" />
          <col width="*" />
        </colgroup>
        <tbody>
          <tr>

						<td>

							<input type="hidden" id="selSearch2" name="selSearch2" value="" />

							<select id="selSearch8" name="selSearch8" class="title_select" onchange="javascript:fn_CateLocate1(this.options[this.selectedIndex].value);">
								<%
								  ' 리스트 조회
								  iiType = "1"
									iiDivision = "1"
									iiSearchCol = "T"
									iiSearchText = ""
									iiSearchCol1 = "S2Y"
									iiCateLocate1 = ""
									iiCateLocate2 = ""
									iiCateLocate3 = ""
									iiCateLocate4 = ""
                  iiViewYN = ""

								  LSQL = "EXEC AD_tblADLocate_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iiType & "','" & iiDivision & "','" & iSportsGb & "','" & iiCateLocate1 & "','" & iiCateLocate2 & "','" & iiCateLocate3 & "','" & iiCateLocate4 & "','" & iLocateGb & "','" & iiViewYN & "','" & iiSearchCol & "','" & iiSearchText & "','" & iiSearchCol1 & "','','','','',''"
									'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
								  'response.End

								  Set LRs = DBCon6.Execute(LSQL)

								  If Not (LRs.Eof Or LRs.Bof) Then
								%>
								<option value="">전체-대분류</option>
								<%
								    Do Until LRs.Eof
								%>
                <option value="<%=LRs("CateLocate1") %>"><%=LRs("CateLocate1Nm") %></option>
								<%
								      LRs.MoveNext
								    Loop
								%>

								<%
								    Else
								%>
								<option value="">대분류없음</option>
								<%
								  End If

								  LRs.close
								%>
              </select>

            </td>

						<td>

							<select id="selSearch9" name="selSearch9" class="title_select" onchange="javascript:fn_CateLocate2(this.options[this.selectedIndex].value);">
								<option value="">전체-중분류</option>
              </select>

            </td>

						<td>

							<select id="selSearch10" name="selSearch10" class="title_select" onchange="javascript:fn_CateLocate3(this.options[this.selectedIndex].value);">
								<option value="">전체-소분류</option>
              </select>

            </td>

						<td>

							<select id="selSearch11" name="selSearch11" class="title_select">
								<option value="">전체-광고순번</option>
              </select>

            </td>

            <td>
              <!-- Division -->
              <input type="hidden" id="selSearch3" name="selSearch3" value="0" />
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

							<select id="selSearch6" name="selSearch6" class="title_select">
								<option value="">전체-사용유무</option>
                <option value="Y">사용중</option>
                <option value="N">미사용</option>
              </select>

            </td>
            <td>
              <!-- Code 구분 -->
              <input type="hidden" id="selSearch1" name="selSearch1" value="" />

              <select id="selSearch" name="selSearch" class="title_select">
                <option value="T">전체</option>
                <option value="S">제목</option>
                <option value="PC">상품코드</option>
								<option value="PN">상품명</option>
								<option value="TW">담당자</option>
              </select>
            </td>
            <td>
              <input type="text" id="txtSearch" name="txtSearch" class="title_input in_2"/>
            </td>
          </tbody>
        </table>
      </div>
      <div class="btn-right-list">
        <a href="javascript:;" id="btnselSearch" name="btnselSearch" onclick="javascript:fn_selSearch();" class="btn">검색</a>
      </div>
      <br />
     <!--
        S : 내용 시작
     -->
    <table class="table-list news_notice_list">
      <caption>이미지 관리 리스트</caption>
      <colgroup>
        <col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
        <col width="*" />
				<col width="*" />
				<col width="*" />
				<col width="*" />
        <col width="*" />
      </colgroup>
      <thead>
        <tr>
          <th scope="col">순번</th>
					<th scope="col">대분류</th>
          <th scope="col">중분류</th>
					<th scope="col">소분류</th>
					<th scope="col">광고순번</th>
					<th scope="col">썸네일</th>
					<th scope="col">제목</th>
					<th scope="col">광고시작일</th>
					<th scope="col">광고종료일</th>
					<th scope="col">사용유무</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">

        <%
          ' 리스트 조회
          iType = "1"

          LSQL = "EXEC AD_tblADProductLocate_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSportsGb & "','" & iCateLocate1 & "','" & iCateLocate2 & "','" & iCateLocate3 & "','" & iCateLocate4 & "','" & iViewYN & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
					'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
          'response.End

          Set LRs = DBCon6.Execute(LSQL)

          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
                LCnt = LCnt + 1
        %>
        <tr  style="cursor:pointer" onclick="javascript:ReadLink('<%=encode(LRs("ProductLocateIDX"),0) %>','<%=NowPage %>');">
          <td><%=LRs("Num") %></td>
					<td>
						<%=LRs("CateLocate1Nm") %>
					</td>
					<td><%=LRs("CateLocate2Nm") %></td>
					<td><%=LRs("CateLocate3Nm") %></td>
					<td><%=LRs("CateLocate4Nm") %></td>
					<td class="thumbnail">
            <!--<img src="http://judo.sportsdiary.co.kr/ADImgR/judo/640_100_1.jpg"/>-->
            <img src="<%=global_filepathUrl_ADIMG %>/<%=LRs("ImgFileNm") %>" />
					</td>
          <td>
						<%=LRs("Title") %>
          </td>
					<td><%=LRs("DateProdS") %></td>
					<td><%=LRs("DateProdE") %></td>
          <td>
						<% if LRs("ViewYN") = "Y" then %>
						<span>사용중</span>
						<% else %>
						<span style="color:red;">미사용</span>
						<% end if %>
          </td>
        </tr>
        <%
              LRs.MoveNext
            Loop
        %>

        <%
            Else
        %>
          <!--게시판에 데이터가 없는 경우-->
        <tr>
          <td colspan="9">
              <div>등록된 게시물이 없습니다.</div>
            </td>
        </tr>
        <%
          End If

          LRs.close

          AD_DBClose()
        %>

      </tbody>
    </table>
    <div class="board-btm-list">
      <%
        if LCnt > 0 then
      %>
        <!--#include file="../dev/dist/Paging_Admin.asp"-->
      <%
        End If
      %>

      <!-- E : 내용 시작 -->
      <div class="btn_list right">
        <a href="javascript:;" onclick="javascript:WriteLink('<%=NowPage %>');" class="btn btn_skyblue"><span class="icon_pen">글쓰기</span></a>
      </div>
    </div>
    </div>
  <section>

    <p></p>

    <script type="text/javascript">

    	fn_CateLocate4();

      $("#txtSearch").val(txtSearchValue);
      $("#selSearch").val(selSearchValue);
      $("#selSearch1").val(selSearchValue1);
      $("#selSearch2").val(selSearchValue2);

      $("#selSearch3").val(selSearchValue3);
      $("#selSearch4").val(selSearchValue4);

      $("#selSearch6").val(selSearchValue6);

    	if (selSearchValue8 != "") {
    		fn_CateLocate1(selSearchValue8);
    	}
    	$("#selSearch8").val(selSearchValue8);

    	if (selSearchValue9 != "") {
    		fn_CateLocate2(selSearchValue9);
    	}
    	$("#selSearch9").val(selSearchValue9);

    	if (selSearchValue10 != "") {
    		fn_CateLocate3(selSearchValue10);
    	}
    	$("#selSearch10").val(selSearchValue10);

      $("#selSearch11").val(selSearchValue11);

    </script>
