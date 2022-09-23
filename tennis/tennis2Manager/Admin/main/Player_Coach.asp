<!--#include file="../dev/dist/config.asp"-->

<!--#include file="head.asp"-->

<%
     'Request
    Dim ReqLocalVal,ReqOptionVal,ReqSearchVal
    Dim NowPage, iTP_Type
    NowPage = fInject(Request("i2")) 
    ReqLocalVal = fInject(Request("i3"))     
    ReqOptionVal = fInject(Request("i4")) 
    ReqSearchVal= fInject(Request("i5"))
    iTP_Type = "T00009" ' 1급 지도자
    if(NowPage = 0) Then NowPage = 1
  
    'JudoTitleWriteLine "ReqLocalVal", ReqLocalVal
    'JudoTitleWriteLine "ReqDivisionVal", ReqDivisionVal
    'JudoTitleWriteLine "ReqOptionVal", ReqOptionVal
    'JudoTitleWriteLine "ReqSearchVal", ReqSearchVal
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
    LSQL = "EXEC TeamPlayer_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & ReqLocalVal & "','" & ReqDivisionVal & "','" & ReqOptionVal & "','" & ReqWeightVal & "','" & ReqSearchVal & "','" & iTP_Type & "','" & iYear & "'"
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
  Dim iCType : iCType = 1
  Dim Const_iCTypeLocal : Const_iCTypeLocal = "Local" 
  Dim Const_iCTypeOption : Const_iCTypeOption = "TP_TypeOption" 
  Dim CSubType : CSubType = iTP_Type
  Dim LName,LCode,LRCnt
  Dim TName,TCode,TRCnt

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
 
  'iCType = 2
  'LSQL = "EXEC CodePropertyName_Search_Type_STR " & "'" & iCType & "','" & Const_iCTypeOption & "'" & ",'" & CSubType & "'"
  ''JudoTitleWriteLine "LSQL", LSQL
  ''Response.End
  'Set LRs = DBCon4.Execute(LSQL)
  'IF Not (LRs.Eof Or LRs.Bof) Then
  '  Do Until LRs.Eof
  '    TName = TName & "^" & LRs("Name") & ""
  '    TCode = TCode & "^" & LRs("Code") & ""
  '    TRCnt = TRCnt + 1
  '    LRs.MoveNext
  '  Loop
  'End If
  'LRs.close
  
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
     post_to_url('./Player_Coach.asp', { 'i2':i2, 'i3': "<%=ReqLocalVal%>",'i4': "", 'i5':"<%=ReqSearchVal%>"});
  }

  function fn_selSearch()
  {
    //var selectTypeOptionVal = $("#selectTypeOption option:selected").val();
    var selectLocalVal = $("#selectLocal option:selected").val();
    var txtSearchVal =  $("#txtSearch").val();
    post_to_url('./Player_Coach.asp', { 'i2': 1 , 'i3': selectLocalVal,'i4': "",'i5': txtSearchVal});
  }

  function ViewPagingLink(i1, i2){
		post_to_url('./Player_Coach_write.asp', { 'i1':i1 ,'i2':i2, 'i3': "<%=ReqLocalVal%>",'i4': "", 'i5':"<%=ReqSearchVal%>", 'i6' : 2});
	}

  function WriteLink(i2) {
     post_to_url('./Player_Coach_write.asp', { 'i2':i2, 'i3': "<%=ReqLocalVal%>",'i4': "", 'i5':"<%=ReqSearchVal%>", 'i6' : 1});
  }

</script>


  <section>
    <div id="content">

		<!-- S: 네비게이션 -->
		<div	class="navigation_box">
			팀/선수정보 > 팀/선수정보 > 1급지도자
		</div>
		<!-- E: 네비게이션 -->
    <div class="search_top community">
      <div class="search_box">
          <!--
          <select id="selectTypeOption" class="title_select">
            <option value="">구분</option>
          </select>
          -->
          <select id="selectLocal" class="title_select">
            <option value="">시/도</option>
          </select>
				<input type="text" id="txtSearch" name="txtSearch" placeholder="이름 및 자격증번호를 입력해주세요."  class="title_input in_2"/>
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
        <col width="*" />
        <col width="*" />
      </colgroup>
      <thead>
        <tr>
          <th scope="col">번호</th>         
          <th scope="col">구분</th>
          <th scope="col">이름</th>
					<th scope="col">지역</th>
					<th scope="col">자격증번호</th>
          <th scope="col">취득일</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">
          <%
            iType = "2"  ' 1:개수 조회 , 2: 데이터 조회
            'sql Query
            Dim  iMSeq, iTeamName, iLeaderName, iCoachName, iPhone, iAddress, iLocal, iLocalName, iTP_Year
            Dim iNum
            LCnt = 0
            LSQL = "EXEC TeamPlayer_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & ReqLocalVal & "','" & ReqDivisionVal & "','" & ReqOptionVal & "','" & ReqWeightVal & "','" & ReqSearchVal & "','" & iTP_Type & "','" & iYear & "'"
	          'response.Write "LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon4.Execute(LSQL)
										
            If Not (LRs.Eof Or LRs.Bof) Then
		          Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
        <tr style="cursor:pointer" onclick="javascript:ViewPagingLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>')">
          <td><%=LRs("MSeq") %></td>
					<td><%=LRs("TypeOptionName") %></td>
          <td><%=LRs("Name") %></td>
					<td><%=LRs("LocalName") %></td>
          <td><%=LRs("LicenseNum") %></a></td>
          <td><%=LRs("LicenseDate") %></td>
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

  /*
  var tName = "<%=TName%>"
  var tCode = "<%=TCode%>"
  var tRCnt = "<%=TRCnt%>"
  var tNameArr = tName.split("^");
  var tCodeArr = tCode.split("^");

  for(var ti=1; ti <= tRCnt; ti++)
  {
    $("#selectTypeOption").append("<option value=" + tCodeArr[ti] + ">" + tNameArr[ti] + "</option>");
  }
  */


</script>

<script type="text/javascript">
		$("#txtSearch").val('<%=ReqSearchVal%>');
		$("#selectLocal").val('<%=ReqLocalVal%>');
    //$("#selectTypeOption").val('<%=ReqOptionVal%>');
</script>

<!--#include file="footer.asp"-->
