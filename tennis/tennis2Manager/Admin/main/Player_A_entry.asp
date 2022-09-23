<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
     'Request
    Dim ReqLocalVal,ReqDivisionVal,ReqOptionVal,ReqTextSearchVal,ReqWeightVal
    Dim NowPage, iTP_Type, iYear

    NowPage = fInject(Request("i2")) 
    ReqOptionVal = fInject(Request("i3")) 
    ReqTextSearchVal= fInject(Request("i4"))
    ReqWeightVal =  fInject(Request("i5"))
    iYear =  fInject(Request("i6"))
    iTP_Type = "T00003" ' 국가대표팀
    if(NowPage = 0) Then NowPage = 1
    'JudoTitleWriteLine "ReqLocalVal", ReqLocalVal
    'JudoTitleWriteLine "ReqDivisionVal", ReqDivisionVal
    'JudoTitleWriteLine "ReqOptionVal", ReqOptionVal
    'JudoTitleWriteLine "ReqTextSearchVal", ReqTextSearchVal
    'JudoTitleWriteLine "NowPage", NowPage
    
  	Dim iTotalCount, iTotalPage '데이터 개수, 총 페이지 
    Dim PagePerData '데이터 가져오는 개수 
    Dim BlockPage   '화면에 보이는 페이징 개수
    Dim LCnt		    'Query Row 데이터 개수
    Dim iType

    '데이터 초기화
    PagePerData = global_PagePerTeamPlayerData   ' 한화면에 출력할 갯수
    BlockPage = global_BlockPage       ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
    iType = "1"  ' 1:개수 조회 , 2: 데이터 조회
    'sql Query
    LSQL = "EXEC TeamPlayer_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & ReqLocalVal & "','" & ReqDivisionVal & "','" & ReqOptionVal & "','" & ReqWeightVal & "','" & ReqTextSearchVal & "','" & iTP_Type & "','" & iYear & "'"
    'JudoTitleWriteLine "LSQL", LSQL
    'response.end
    Set LRs = DBCon4.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
              iTotalCount = LRs("TOTALCNT")
              iTotalPage = LRs("TOTALPAGE")
          LRs.MoveNext
        Loop
    End If
    LRs.close
    'JudoTitleWriteLine "LSQL", LSQL
    'JudoTitleWriteLine "iTotalPage", iTotalPage
    'JudoTitleWriteLine "iTotalCount", iTotalCount
%>

<%
  Dim LSQL 'sqlQuery
  Dim iCType : iCType = 1
  Dim Const_iCTypeLocal,Const_iCTypeOptionDivision,Const_iCTypeTypeOptionSex
  Dim LName,LCode,LRCnt,DName,DCode,DRCnt,OName,OCode,ORCnt
  
  Const_iCTypeOptionDivision ="TP_TypeOption_Team_Division"
  Const_iCTypeWeightDivision = "WeightDivision"


  iCType = 2
  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeOptionDivision & "','" & iTP_Type & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      DRCnt = DRCnt + 1 
      DName = DName & "^" & LRs("Name") & ""
      DCode = DCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close

  WExceptCode = "W00001"
  LSQL = "EXEC CodePropertyName_Search_Type_STR " & "'" & iType & "','" & Const_iCTypeWeightDivision & "'" & ",''"
  'JudoTitleWriteLine "LSQL", LSQL
  'Response.ENd
  Set LRs = DBCon4.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
  Do Until LRs.Eof
      'IF(LRs("Code") <> WExceptCode) Then
        WRCnt = WRCnt + 1
        WName = WName & "^" & LRs("Name") & ""
        WCode = WCode & "^" & LRs("Code") & ""
      'End IF
      LRs.MoveNext
      Loop
  End If
  LRs.close

  
  Dim yearType : yearType = 2 
  LSQL = "EXEC TeamPlayer_Board_State_STR '', '" & iTP_Type & "','', '" & yearType & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      dateLRCnt = dateLRCnt + 1
      TP_Year = TP_Year + "^" + LRs("TP_Year")
      LRs.MoveNext
    Loop
  End If
  
	'JudoTitleWriteLine "TP_Year", TP_Year
  'JudoTitleWriteLine "LCode", LCode
  'JudoTitleWriteLine "LRCnt", LRCnt
  'JudoTitleWriteLine "DName", DName
  'JudoTitleWriteLine "DCode", DCode
  'JudoTitleWriteLine "DRCnt", DRCnt
  'JudoTitleWriteLine "OName", OName
  'JudoTitleWriteLine "OCode", OCode
  'JudoTitleWriteLine "ORCnt", ORCnt

%>

<script type="text/javascript">

  function PagingLink(i2) {
     post_to_url('./Player_A_entry.asp', { 'i2':i2 , 'i3':"<%=ReqOptionVal%>",'i4': "<%=ReqTextSearchVal%>",'i5': "<%=ReqWeightVal%>",'i6':"<%=iYear%>" });
  }

  function fn_selSearch()
  {
    var selectTypeOptionVal = $("#selectTypeOption option:selected").val();
    var selectOptionWeightVal = $("#selectOptionWeight option:selected").val();
    var selectYearVal = $("#selectYear option:selected").val();
    var txtSearchVal =  $("#txtSearch").val();
    post_to_url('./Player_A_entry.asp', { 'i2': 1 ,'i3': selectTypeOptionVal,'i4': txtSearchVal,'i5': selectOptionWeightVal,'i6':selectYearVal});
  }

  function ViewPagingLink(i1, i2){
		post_to_url('./Player_A_entry_write.asp', {'i1':i1, 'i2':i2, 'i3':"<%=ReqOptionVal%>",'i4': "<%=ReqTextSearchVal%>",'i5': "<%=ReqWeightVal%>",'i6':"<%=iYear%>",'i7':2});
	}

  function WriteLink(i2) {
     post_to_url('./Player_A_entry_write.asp', { 'i2':i2, 'i3':"<%=ReqOptionVal%>",'i4': "<%=ReqTextSearchVal%>",'i5': "<%=ReqWeightVal%>",'i6':"<%=iYear%>",'i7':1});
  }
</script>

  <section>
    <div id="content">

		<!-- S: 네비게이션 -->
		<div	class="navigation_box">
			팀/선수정보 > 대표팀정보 > 국가대표팀
		</div>
		<!-- E: 네비게이션 -->
    <div class="search_top community">
      <div class="search_box">
          <select id="selectTypeOption" class="title_select">
            <option value="">팀소속</option>
          </select>

          <select id="selectOptionWeight" class="title_select">
            <option value="">구분</option>
          </select>

          <select id="selectYear" class="title_select">
            <option value="">년도</option>
          </select>
				<input type="text" id="txtSearch" name="txtSearch" placeholder="이름 및 학교를 입력해주세요."  class="title_input in_2"/>
			 <a href="javascript:;" id="btnselSearch" name="btnselSearch"  onclick="javascript:fn_selSearch();" class="btn_skyblue">검색</a>
			</div>
      <div class="btn_list right">
        <!--<input type="button" id="btnselSearch" name="btnselSearch" value="검색" onclick="javascript:fn_selSearch();" />-->
		  </div>
      <br />
     <!-- 
        S : 내용 시작
     -->
    <table class="table-list">
      <caption>대회 리스트</caption>
      <colgroup>
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
          <th scope="col">팀소속</th>         
          <th scope="col">구분</th>
          <th scope="col">년도</th>
          <th scope="col">직책</th>
          <th scope="col">이름</th>
          <th scope="col">학교</th>
          <th scope="col">이미지</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">
          <%
            iType = "2"  ' 1:개수 조회 , 2: 데이터 조회
            'sql Query
            Dim  iMSeq, iTeamName, iLeaderName, iCoachName, iPhone, iAddress, iLocal, iLocalName, iTP_Year
            Dim iNum
            LCnt = 0
            LSQL = "EXEC TeamPlayer_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & ReqLocalVal & "','" & ReqDivisionVal & "','" & ReqOptionVal & "','" & ReqWeightVal & "','" & ReqTextSearchVal & "','" & iTP_Type & "','" & iYear & "'"
	          'response.Write "LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon4.Execute(LSQL)
										
            If Not (LRs.Eof Or LRs.Bof) Then
		          Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
        <tr style="cursor:pointer" onclick="javascript:ViewPagingLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>')">
          <td><%=LRs("TypeOptionName") %></td>
					<td><%=LRs("WeightName") %></td>
          <td><%=LRs("TP_Year") %></td>
          <td><%=LRs("PositionName") %></td>
          <td><%=LRs("Name") %></td>
          <td><%=LRs("School") %></td>
					<td><%=LRs("Link") %></td>
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
  
          JudoKorea_DBClose()
        %>

      </tbody>
    </table>

  
      <!--#include file="../dev/dist/judoPaging_Admin.asp"-->

    <!-- E : 내용 시작 -->
    <div class="btn_list right">
			<a href="javascript:;" onclick="javascript:WriteLink('<%=NowPage %>');" class="btn_skyblue"><span class="icon_pen">글쓰기</span></a>
		</div>


    </div>
  <section>

<script type="text/javascript">
  var dName = "<%=DName%>"
  var dCode = "<%=DCode%>"
  var dRCnt = "<%=DRCnt%>"
  var dNameArr = dName.split("^");
  var dCodeArr = dCode.split("^");

  for(var di=1; di <= dRCnt; di++)
  {
    $("#selectTypeOption").append("<option value=" + dCodeArr[di] + ">" + dNameArr[di] + "</option>");
  }

  
  var wName = "<%=WName%>"
  var wCode = "<%=WCode%>"
  var wRCnt = "<%=WRCnt%>"
  var wNameArr = wName.split("^");
  var wCodeArr = wCode.split("^");

  for(var wi=1; wi <= wRCnt; wi++)
  {
    $("#selectOptionWeight").append("<option value=" + wCodeArr[wi] + ">" + wNameArr[wi] + "</option>");
  }
  
  var dateCnt = "<%=dateLRCnt%>";
  var tp_Years = "<%=TP_Year%>";
  var tp_YearArr = tp_Years.split("^");

  if(dateCnt >= 1)
  {
    for(var datei =1 ; datei <= dateCnt; datei++)
    {
      $("#selectYear").append("<option value=" +tp_YearArr[datei] + " selected>" + tp_YearArr[datei] +"년</option>");
    }
  }
  else
  {
    var currentTime = new Date()
    $("#selectYear").append("<option value=" + currentTime.getFullYear() + " selected>" + currentTime.getFullYear()  +"년</option>");
  }



</script>

<script type="text/javascript">
		$("#txtSearch").val('<%=ReqTextSearchVal%>');
    $("#selectTypeOption").val('<%=ReqOptionVal%>');
    $("#selectOptionWeight").val('<%=ReqWeightVal%>');
    $("#selectYear").val('<%=iYear%>');
</script>

<!--#include file="footer.asp"-->
