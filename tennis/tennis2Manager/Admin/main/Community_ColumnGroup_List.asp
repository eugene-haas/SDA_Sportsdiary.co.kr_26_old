<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%

  Dim iTotalCount, iTotalPage, LCnt0 '페이징
  LCnt0 = 0

  Dim LCnt, NowPage, PagePerData '리스트
  LCnt = 0

  'iDivision = "1"

	iDivision = fInject(Request("iDivision"))

	If Len(iDivision) = 0 Then
    iDivision = "2"
  End If
	
	'1 : 칼럼개설 유저
	'2 : 칼럼개설 어드민
	'10 : 칼럼유저 메인리스트

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

  LSQL = "EXEC Community_tblColumnistG_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','" & global_MainCLCnt & "','" & ipdsgroup & "','" & iDayGubun & "','" & iSearchCol2 & "','" & iSearchCol1 & "','','','','',''"
  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon5.Execute(LSQL)
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

    var selSearchValue5 = "<%=ieSearchCol2%>";

    function WriteLink(i2) {
    	post_to_url('./Community_ColumnGroup_Write.asp', { 'i2': i2, 'iType': '1', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function ReadLink(i1, i2) {
    	post_to_url('./Community_ColumnGroup_Write.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function PagingLink(i2) {
    	post_to_url('./Community_ColumnGroup_List.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function fn_selSearch() {

    	selSearchValue5 = document.getElementById('selSearch5').value;

    	selSearchValue4 = document.getElementById('selSearch4').value;
    	selSearchValue3 = document.getElementById('selSearch3').value;

      selSearchValue2 = document.getElementById('selSearch2').value;
      selSearchValue1 = document.getElementById('selSearch1').value;
      selSearchValue = document.getElementById('selSearch').value;
      txtSearchValue = document.getElementById('txtSearch').value;

      post_to_url('./Community_ColumnGroup_List.asp', { 'i2': 1, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol2': selSearchValue5, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

  </script>


   <section>
    <div id="content">

    <!-- S: 네비게이션 -->
    <div  class="navigation_box">
      메인 > 칼럼리스트 > 칼럼개설
    </div>
    <!-- E: 네비게이션 -->
    <div class="search_top community">
      <div class="search_box">

				<!-- 메인 공지 유무 -->
        <!--<input type="hidden" id="selSearch2" name="selSearch2" value="N" />-->
				<select id="selSearch2" name="selSearch2" class="title_select">
				  <option value="">전체-사용유무</option>
				  <option value="Y">Y</option>
				  <option value="N">N</option>
				</select>

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

        <select id="selSearch" name="selSearch" class="title_select">
					<option value="T">전체</option>
          <option value="S">제목</option>
          <!--<option value="C">내용</option>-->
					<option value="N">작성자</option>
        </select>

        <input type="text" id="txtSearch" name="txtSearch" class="title_input in_2"/>
       <a href="javascript:;" id="btnselSearch" name="btnselSearch" onClick="javascript:fn_selSearch();" class="btn_skyblue">검색</a>
      </div>
      <div class="btn_list right">
        <!--<input type="button" id="btnselSearch" name="btnselSearch" value="검색" onclick="javascript:fn_selSearch();" />-->
      </div>
      <br />
     <!-- 
        S : 내용 시작
     -->
    <table class="table-list news_notice_list">
      <caption>칼럼리스트</caption>
      <colgroup>
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
					<th scope="col">작성자</th>
          <th scope="col">제목</th>
					<th scope="col">사용유무</th>
          <th scope="col">작성일</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">

          <%
            ' 리스트 조회
            iType = "1"

            LSQL = "EXEC Community_tblColumnistG_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSubType & "','" & iSearchCol & "','" & iSearchText & "','" & iYear & "','" & iNoticeYN & "','" & iLoginID & "','" & global_MainNoticeCnt & "','" & ipdsgroup & "','" & iDayGubun & "','" & iSearchCol2 & "','" & iSearchCol1 & "','','','','',''"
						'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon5.Execute(LSQL)
                    
            If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
        <tr  style="cursor:pointer" onClick="javascript:ReadLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>');">
          <td><%=LRs("Num") %></td>
					<td><%=LRs("Name") %></td>
          <td><%=LRs("Subject") %></td>
					<td><%=LRs("NoticeYN") %></td>
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
          <td colspan="5">
              <div>등록된 게시물이 없습니다.</div>
            </td>
        </tr>
        <%
          End If
  
          LRs.close
          
          'DBClose4()
          Tennis_DBClose()
        %>

      </tbody>
    </table>

    <%
      if LCnt > 0 then
    %>
      <!--#include file="../dev/dist/Paging_Admin.asp"-->
    <%
      End If
    %>

    <!-- E : 내용 시작 -->
    <div class="btn_list right">
      <a href="javascript:;" onClick="javascript:WriteLink('<%=NowPage %>');" class="btn_skyblue"><span class="icon_pen">글쓰기</span></a>
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

    </script>
<!--#include file="footer.asp"-->
