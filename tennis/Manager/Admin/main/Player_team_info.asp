<!--#include file="../dev/dist/config.asp"-->

<!--#include file="head.asp"-->

<%
     'Request
    Dim ReqLocalVal,ReqDivisionVal,ReqOptionVal,ReqTeamNameVal,ReqWeightVal
    Dim NowPage, iTP_Type
    NowPage = fInject(Request("i1")) 
    ReqLocalVal = fInject(Request("i2"))     
    ReqDivisionVal = fInject(Request("i3")) 
    ReqOptionVal = fInject(Request("i4")) 
    ReqTeamNameVal= fInject(Request("i5"))

    iTP_Type = "T00001" ' 팀정보

    if(NowPage = 0) Then NowPage = 1
  
    'JudoTitleWriteLine "ReqLocalVal", ReqLocalVal
    'JudoTitleWriteLine "ReqDivisionVal", ReqDivisionVal
    'JudoTitleWriteLine "ReqOptionVal", ReqOptionVal
    'JudoTitleWriteLine "ReqTeamNameVal", ReqTeamNameVal
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
    LSQL = "EXEC TeamPlayer_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & ReqLocalVal & "','" & ReqDivisionVal & "','" & ReqOptionVal & "','" & ReqWeightVal & "','" & ReqTeamNameVal & "','" & iTP_Type & "','" & iYear & "'"

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
  Dim Const_iCTypeLocal,Const_iCTypeDivision,Const_iCTypeTypeOptionSex
  Dim LName,LCode,LRCnt,DName,DCode,DRCnt,OName,OCode,ORCnt
  Const_iCTypeLocal = "Local" 
  Const_iCTypeDivision ="TP_Division"
  Const_iCTypeTypeOptionSex = "TP_TypeOption_Team_Sex"
  
  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeLocal & "','" & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      LRCnt = LRCnt + 1
      LName = LName & "^" & LRs("Name") & ""
      LCode = LCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close

  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeTypeOptionSex & "','" & "'"
  'JudoTitleWriteLine "LSQL", LSQL
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      ORCnt = ORCnt + 1
      OName = OName & "^" & LRs("Name") & ""
      OCode = OCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close

  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeDivision & "','" & "'"
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

  function PagingLink(i1) {
     post_to_url('./Player_team_info.asp', { 'i1':i1 , 'i2':"<%=ReqLocalVal%>",'i3': "<%=ReqDivisionVal%>",'i4': "<%=ReqOptionVal%>",'i5': "<%=ReqTeamNameVal%>"});
  }

  function fn_selSearch()
  {
    var selectLocalVal = $("#selectLocal option:selected").val();
    var selectDivisionVal = $("#selectDivision option:selected").val();
    var selectOptionSex = $("#selectOptionSex option:selected").val();
    var txtSearchVal =  $("#txtSearch").val();

    post_to_url('./Player_team_info.asp', { 'i1': 1 , 'i2': selectLocalVal,'i3': selectDivisionVal,'i4': selectOptionSex,'i5': txtSearchVal});
  }

  function ViewPagingLink(i1, i2){
		post_to_url('./Player_team_info_write.asp', { 'i1':i1 , 'i2':"<%=ReqLocalVal%>",'i3': "<%=ReqDivisionVal%>",'i4': "<%=ReqOptionVal%>",'i5': "<%=ReqTeamNameVal%>",'i6': i2, 'i7': 2});
	}

  function WriteLink(i1) {
     post_to_url('./Player_team_info_write.asp', { 'i1':i1 , 'i2':"<%=ReqLocalVal%>",'i3': "<%=ReqDivisionVal%>",'i4': "<%=ReqOptionVal%>",'i5': "<%=ReqTeamNameVal%>", 'i7': 1});
  }



</script>


  <section>
    <div id="content">

		<!-- S: 네비게이션 -->
		<div	class="navigation_box">
			팀/선수정보 > 팀/선수정보 > 팀정보
		</div>
		<!-- E: 네비게이션 -->
    <div class="search_top community">
      <div class="search_box">
          <select id="selectLocal" class="title_select">
            <option value="">시/도</option>
          </select>
          
          <select id="selectDivision" class="title_select">
            <option value="">구분</option>
          </select>

          <select id="selectOptionSex" class="title_select">
            <option value="">성별</option>
          </select>
				<input type="text" id="txtSearch" name="txtSearch" placeholder="팀명을 입력해주세요."  class="title_input in_2"/>

			 <a href="javascript:;" id="btnselSearch" name="btnselSearch" onclick="javascript:fn_selSearch();" class="btn_skyblue">검색</a>
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
      </colgroup>
      <thead>
        <tr>
          <th scope="col">지역</th>         
          <th scope="col">구분</th>
					<th scope="col">성별</th>
					<th scope="col">팀명</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">
          <%
            iType = "2"  ' 1:개수 조회 , 2: 데이터 조회
            'sql Query
            Dim  iMSeq, iTeamName, iLeaderName, iCoachName, iPhone, iAddress, iLocal, iLocalName, iTP_Year
            Dim iNum
            LCnt = 0
            LSQL = "EXEC TeamPlayer_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & ReqLocalVal & "','" & ReqDivisionVal & "','" & ReqOptionVal & "','" & ReqWeightVal & "','" & ReqTeamNameVal & "','" & iTP_Type & "','" & iYear & "'"
	          'response.Write "LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon4.Execute(LSQL)
										
            If Not (LRs.Eof Or LRs.Bof) Then
		          Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
        <tr  style="cursor:pointer" onclick="javascript:ViewPagingLink('<%=NowPage %>','<%=encode(LRs("MSeq"),0) %>')">
          <td><%=LRs("LocalName") %></td>
					<td><%=LRs("DivisionName") %></td>
					<td><%=LRs("TypeOptionName") %></td>
          <td><%=LRs("TeamName") %></a></td>
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
  var lName = "<%=LName%>"
  var lCode = "<%=LCode%>"
  var lRCnt = "<%=LRCnt%>"
  var lNameArr = lName.split("^");
  var lCodeArr = lCode.split("^");

  for(var li=1; li <= lRCnt; li++)
  {
    $("#selectLocal").append("<option value=" + lCodeArr[li] + ">" + lNameArr[li] + "</option>");
  }

  var dName = "<%=DName%>"
  var dCode = "<%=DCode%>"
  var dRCnt = "<%=DRCnt%>"
  var dNameArr = dName.split("^");
  var dCodeArr = dCode.split("^");

  for(var di=1; di <= dRCnt; di++)
  {
    $("#selectDivision").append("<option value=" + dCodeArr[di] + ">" + dNameArr[di] + "</option>");
  }

  var oName = "<%=OName%>"
  var oCode = "<%=OCode%>"
  var oRCnt = "<%=ORCnt%>"
  var oNameArr = oName.split("^");
  var oCodeArr = oCode.split("^");

  for(var oi=1; oi <= oRCnt; oi++)
  {
    $("#selectOptionSex").append("<option value=" + oCodeArr[oi] + ">" + oNameArr[oi] + "</option>");
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

    $("#selectYear").append("<option value=" + currentTime.getFullYear() + " selected>" + currentTime.getFullYear() +"년</option>");
  }
</script>

<script type="text/javascript">
		$("#txtSearch").val('<%=ReqTeamNameVal%>');
		$("#selectLocal").val('<%=ReqLocalVal%>');
    $("#selectDivision").val('<%=ReqDivisionVal%>');
    $("#selectOptionSex").val('<%=ReqOptionVal%>');
</script>

<!--#include file="footer.asp"-->
