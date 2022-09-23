<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
	RoleType = "K002IM"
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

	'PagePerData = "2"
	'BlockPage = "2"

  'Request Data
  iSearchText = fInject(Request("iSearchText"))
  iSearchCol = fInject(Request("iSearchCol"))

	iSearchCol1 = fInject(Request("iSearchCol1"))	' S2Y : 최신순, S2C : 많이본순

	iImageType = fInject(Request("iImageType"))
	iViewYN = fInject(Request("iViewYN"))
	iLocateGb = fInject(Request("iLocateGb"))

  If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' 검색 구분자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어
	if(Len(iSearchCol1) = 0) Then iSearchCol1 = "S2Y" ' WriteDate 순
	if(Len(iImageType) = 0) Then iImageType = ""
	if(Len(iViewYN) = 0) Then iViewYN = ""
	if(Len(iLocateGb) = 0) Then iLocateGb = ""


  iType = "2"                      ' 1:조회, 2:총갯수


	iSportsGb = "tennis"

  LSQL = "EXEC AD_tblADImageInfo_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSportsGb & "','" & iImageType & "','" & iLocateGb & "','" & iViewYN & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
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

    var selSearchValue5 = "<%=iImageType%>";
    var selSearchValue6 = "<%=iViewYN%>";
    var selSearchValue7 = "<%=iLocateGb%>";

    function WriteLink(i2) {
    	post_to_url('./AD_BN_IMG_Write.asp', { 'i2': i2, 'iType': '1', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iImageType': selSearchValue5, 'iViewYN': selSearchValue6, 'iLocateGb': selSearchValue7 });
    }

    function ReadLink(i1, i2) {
    	post_to_url('./AD_BN_IMG_Write.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iImageType': selSearchValue5, 'iViewYN': selSearchValue6, 'iLocateGb': selSearchValue7 });
    }

    function PagingLink(i2) {
    	post_to_url('./AD_BN_IMG_List.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iImageType': selSearchValue5, 'iViewYN': selSearchValue6, 'iLocateGb': selSearchValue7 });
    }

    function fn_selSearch() {

    	selSearchValue7 = document.getElementById('selSearch7').value;
    	selSearchValue6 = document.getElementById('selSearch6').value;
    	selSearchValue5 = document.getElementById('selSearch5').value;

    	selSearchValue4 = document.getElementById('selSearch4').value;
    	selSearchValue3 = document.getElementById('selSearch3').value;

      selSearchValue2 = document.getElementById('selSearch2').value;
      selSearchValue1 = document.getElementById('selSearch1').value;
      selSearchValue = document.getElementById('selSearch').value;
      txtSearchValue = document.getElementById('txtSearch').value;

      post_to_url('./AD_BN_IMG_List.asp', { 'i2': 1, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'iImageType': selSearchValue5, 'iViewYN': selSearchValue6, 'iLocateGb': selSearchValue7 });
    }

  </script>


   <section>
    <div id="content">

    <!-- S: 네비게이션 -->
    <div  class="navigation_box">
      <div class="loaction">
        <strong>광고 관리</strong> &gt; 이미지 관리
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
          <col width="*" />
        </colgroup>
        <tbody>
          <tr>
<!--             <th scope="row"><label for="competition-name-2">신청일자</label></th> -->
<!--             <td><input type="date" name="WriteDate" id="WriteDate" value="<%=WriteDate%>"></td>            -->
            <td scope="row">
							<input type="hidden" id="selSearch2" name="selSearch2" value="" />
              <!--<select id="selSearch2" name="selSearch2" class="title_select">
                <option value="">전체-공지유무</option>
                <option value="Y">Y</option>
                <option value="N">N</option>
              </select>-->

							<select id="selSearch5" name="selSearch5" class="title_select">
								<%
								  ' 리스트 조회
								  iiType = "1"
									iiDivision = "1"

								  LSQL = "EXEC AD_tblADCode_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iiType & "','" & iiDivision & "','" & iSportsGb & "','" & iCode01 & "','" & iCode02 & "','" & iCode03 & "','" & iCode04 & "','" & iCode01Group & "','" & iCode02Group & "','" & iCode03Group & "','" & iCode04Group & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
									'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
								  'response.End

								  Set LRs = DBCon6.Execute(LSQL)

								  If Not (LRs.Eof Or LRs.Bof) Then
								%>
								<option value="">전체-그룹</option>
								<%
								    Do Until LRs.Eof
								%>
                <option value="<%=LRs("Code01") %>">[<%=LRs("SportsGbNm") %>] <%=LRs("Code01Name") %></option>
								<%
								      LRs.MoveNext
								    Loop
								%>

								<%
								    Else
								%>
								<option value="">그룹없음</option>
								<%
								  End If

								  LRs.close
								%>
              </select>

            </td>

						<td>

							<select id="selSearch6" name="selSearch6" class="title_select">
								<option value="">전체-사용유무</option>
                <option value="Y">사용중</option>
                <option value="N">미사용</option>
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

							<select id="selSearch7" name="selSearch7" class="title_select">
								<%
								  ' 리스트 조회
								  iiType = "1"
									iiDivision = "2"
									iiCode01Group = "LOCATEGBTYPE"

								  LSQL = "EXEC AD_tblADCode_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iiType & "','" & iiDivision & "','" & iSportsGb & "','" & iCode01 & "','" & iCode02 & "','" & iCode03 & "','" & iCode04 & "','" & iiCode01Group & "','" & iCode02Group & "','" & iCode03Group & "','" & iCode04Group & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
									'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
								  'response.End

								  Set LRs = DBCon6.Execute(LSQL)

								  If Not (LRs.Eof Or LRs.Bof) Then
								%>
								<option value="">전체-크기</option>
								<%
								    Do Until LRs.Eof
								%>
                <option value="<%=LRs("Code01") %>"><%=LRs("Code01Name") %></option>
								<%
								      LRs.MoveNext
								    Loop
								%>

								<%
								    Else
								%>
								<option value="">크기없음</option>
								<%
								  End If

								  LRs.close
								%>
              </select>

            </td>
            <td>
              <!-- Code 구분 -->
              <input type="hidden" id="selSearch1" name="selSearch1" value="" />

              <select id="selSearch" name="selSearch" class="title_select">
                <option value="T">전체</option>
                <option value="S">제목</option>
                <option value="F">파일명</option>
              </select>
            </td>
            <td>
              <input type="text" id="txtSearch" name="txtSearch" class="title_input in_2"/>
            </td>
          </tbody>
        </table>
      </div>
      <div class="btn-right-list">
        <a href="javascript:;" id="btnselSearch" name="btnselSearch" onClick="javascript:fn_selSearch();" class="btn">검색</a>
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
      </colgroup>
      <thead>
        <tr>
          <th scope="col">순번</th>
					<th scope="col">그룹명</th>
					<th scope="col">썸네일</th>
          <th scope="col">제목</th>
					<th scope="col">파일명</th>
					<th scope="col">사용유무</th>
          <th scope="col">크기</th>
          <th scope="col">작성일</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">

        <%
          ' 리스트 조회
          iType = "1"

          LSQL = "EXEC AD_tblADImageInfo_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSportsGb & "','" & iImageType & "','" & iLocateGb & "','" & iViewYN & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
					'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
          'response.End

          Set LRs = DBCon6.Execute(LSQL)

          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
                LCnt = LCnt + 1
        %>
        <tr  style="cursor:pointer" onClick="javascript:ReadLink('<%=encode(LRs("ImageInfoIDX"),0) %>','<%=NowPage %>');">
          <td><%=LRs("Num") %></td>
					<td>
						<%=LRs("ImageTypeNm") %>
					</td>
					<td class="thumbnail">
            <!--<img src="http://judo.sportsdiary.co.kr/ADImgR/judo/640_100_1.jpg" / >-->
            <img src="<%=global_filepathUrl_ADIMG %>/<%=LRs("ImgFileNm") %>" />
					</td>
					<td class="name"><span><%=LRs("Subject") %></span></td>
          <td>
						<%=LRs("ImgFileNm") %>
          </td>
          <td>
						<% if LRs("ViewYN") = "Y" then %>
						<span>사용중</span>
						<% else %>
						<span style="color:red;">미사용</span>
						<% end if %>
          </td>
					<td>
						<%=LRs("LocateGbNm") %>
					</td>
					<td><%=LRs("InsDateCv") %></td>
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
          <td colspan="7">
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

      $("#txtSearch").val(txtSearchValue);
      $("#selSearch").val(selSearchValue);
      $("#selSearch1").val(selSearchValue1);
      $("#selSearch2").val(selSearchValue2);

      $("#selSearch3").val(selSearchValue3);
      $("#selSearch4").val(selSearchValue4);

      $("#selSearch5").val(selSearchValue5);
      $("#selSearch6").val(selSearchValue6);
      $("#selSearch7").val(selSearchValue7);

    </script>
