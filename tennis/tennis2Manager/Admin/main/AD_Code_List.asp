<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<% 
	RoleType = "K001IGM"	
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

  If Len(NowPage) = 0 Then
    NowPage = 1
  End If

  if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' 검색 구분자
  if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

	if(Len(iSearchCol1) = 0) Then iSearchCol1 = "S2Y" ' OrderBy 순

  iType = "2"                      ' 1:조회, 2:총갯수

	iCode01 = ""
	iCode02 = ""
	iCode03 = ""
	iCode04 = ""

	iCode01Group = "IMGTYPE"
	iCode02Group = ""
	iCode03Group = ""
	iCode04Group = ""

	iSportsGb = "tennis"

  ' SD_AD 접속
  LSQL = "EXEC AD_tblADCode_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSportsGb & "','" & iCode01 & "','" & iCode02 & "','" & iCode03 & "','" & iCode04 & "','" & iCode01Group & "','" & iCode02Group & "','" & iCode03Group & "','" & iCode04Group & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
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

  ' SD_Tennis 접속 - 풀권한 있을때 체크 ( 일반 어드민도 사용 가능 하기 때문에 사용 안함 )
  'LSQL1 = "EXEC AdminMember_Check_S '" & iLoginID & "'"
	''response.Write "LSQL1=LSQL1=LSQL1=LSQL1=LSQL1=LSQL1=LSQL1="&LSQL1&"<br>"
  ''response.End
  '
  'Set LRs = DBCon5.Execute(LSQL1)
  'If Not (LRs.Eof Or LRs.Bof) Then
	'	Do Until LRs.Eof
  '      iAuthority = LRs("Authority")
  '    LRs.MoveNext
	'	Loop
	'End If
  'LRs.close

%>

<script type="text/javascript">

    var selSearchValue1 = "<%=iSubType%>";
    var selSearchValue2 = "<%=iNoticeYN%>";
    var selSearchValue = "<%=iSearchCol%>";
    var txtSearchValue = "<%=iSearchText%>";

    var selSearchValue3 = "<%=iDivision%>";
    var selSearchValue4 = "<%=iSearchCol1%>";

    function WriteLink(i2) {
    	post_to_url('./AD_Code_Write.asp', { 'i2': i2, 'iType': '1', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function ReadLink(i1, i2) {
    	post_to_url('./AD_Code_Write.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function PagingLink(i2) {
    	post_to_url('./AD_Code_List.asp', { 'i2': i2, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function fn_selSearch() {

    	selSearchValue4 = document.getElementById('selSearch4').value;
    	selSearchValue3 = document.getElementById('selSearch3').value;

      selSearchValue2 = document.getElementById('selSearch2').value;
      selSearchValue1 = document.getElementById('selSearch1').value;
      selSearchValue = document.getElementById('selSearch').value;
      txtSearchValue = document.getElementById('txtSearch').value;

      post_to_url('./AD_Code_List.asp', { 'i2': 1, 'iSubType': selSearchValue1, 'iNoticeYN': selSearchValue2, 'iDivision': selSearchValue3, 'iSearchCol1': selSearchValue4, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

  </script>


   <section>
    <div id="content">

    <!-- S: 네비게이션 -->
    <div  class="navigation_box">
      <div class="loaction">
        <strong>광고 관리</strong> &gt; 이미지 그룹 관리
      </div>
    </div>
    <!-- E: 네비게이션 -->
    <div class="search_top community">
      <div class="search_box sch">
				<!-- 메인 공지 유무 -->
        <!--<input type="hidden" id="selSearch2" name="selSearch2" value="N" />-->
        
        <colgroup>
          <col width="0px" />
          <col width="0px" />
          <col width="120px" />
          <col width="*" />
        </colgroup>
				<input type="hidden" id="selSearch2" name="selSearch2" value="" />
				<input type="hidden" id="selSearch3" name="selSearch3" value="0" />
				<input type="hidden" id="selSearch4" name="selSearch4" value="S2Y" />
				
				<input type="hidden" id="selSearch1" name="selSearch1" value="" />

				<select id="selSearch" name="selSearch" class="title_select">
					<option value="T">전체</option>
					<option value="C">코드</option>
					<option value="CN">코드명</option>
				</select>
				<input type="text" id="txtSearch" name="txtSearch" class="title_input in_2"/>
      </div>
      <div class="btn-right-list">
        <a href="javascript:;" id="btnselSearch" name="btnselSearch" onClick="javascript:fn_selSearch();" class="btn">검색</a>
      </div>
      <br />
     <!-- 
        S : 내용 시작
     -->
    <table class="table-list news_notice_list">
      <caption>이미지 그룹 관리 리스트</caption>
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
					<th scope="col">코드그룹</th>
          <th scope="col">코드</th>
					<th scope="col">업체명(코드명)</th>
          <th scope="col">위드라인 담당자</th>
          <th scope="col">작성일</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">

          

          <%
            ' 리스트 조회
            iType = "1"

            LSQL = "EXEC AD_tblADCode_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSportsGb & "','" & iCode01 & "','" & iCode02 & "','" & iCode03 & "','" & iCode04 & "','" & iCode01Group & "','" & iCode02Group & "','" & iCode03Group & "','" & iCode04Group & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
						'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon6.Execute(LSQL)
                    
            If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
        <tr  style="cursor:pointer" onclick="javascript:ReadLink('<%=encode(LRs("ADCodeIDX"),0) %>','<%=NowPage %>');">
          <td><%=LRs("Num") %></td>
					<td>
						<%=LRs("SportsGbNm") %>
					</td>
					<td><%=LRs("Code01") %></td>
          <td class="name">
						<span><%=LRs("Code01Name") %></span>
          </td>
          <td><%=LRs("WLSalesManager") %></td>
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
          <td colspan="6">
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

    </script>
