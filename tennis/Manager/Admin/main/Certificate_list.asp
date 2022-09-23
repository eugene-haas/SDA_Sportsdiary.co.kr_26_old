<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
     'Request
    Dim ReqLocalVal,ReqDivisionVal,ReqOptionVal,ReqTextSearchVal,ReqWeightVal
    Dim NowPage, iTP_Type, iYear

    NowPage = fInject(Request("i2")) 
    iSearchText = fInject(Request("i3"))
    iStatus =  fInject(Request("i4"))
    iStartDate = fInject(Request("i5"))
    iEndDate = fInject(Request("i6"))

    iDivision = 1 '선수증재발급
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
    iType = "2"  ' 1:개수 조회 , 2: 데이터 조회
    'sql Query
    LSQL = "EXEC Admin_OnlineService_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iStatus & "','" & iCertificationName & "','" & iStartDate & "','" & iEndDate & "','" & iLoginID & "'"
    'JudoTitleWriteLine "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL", LSQL
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
    'response.end

%>

<%
  Dim LSQL 'sqlQuery
  Dim iCType : iCType = 1
  Dim Const_iCTypeOnlineService_State
  Dim OSName,OSCode,OSRCnt
  Const_iCTypeOnlineService_State ="OnlineService_State"
  LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iCType & "','" & Const_iCTypeOnlineService_State & "','" & iTP_Type & "'"
  'JudoTitleWriteLine "LSQL", LSQL
 
  Set LRs = DBCon4.Execute(LSQL)
  IF Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      OSRCnt = OSRCnt + 1 
      OSName = OSName & "^" & LRs("Name") & ""
      OSCode = OSCode & "^" & LRs("Code") & ""
      LRs.MoveNext
    Loop
  End If
  LRs.close
  'JudoTitleWriteLine "OSRCnt", OSRCnt
  'JudoTitleWriteLine "OSCode", OSCode
  'JudoTitleWriteLine "OSName", OSName
  'response.end
%>

<script type="text/javascript">
  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

  var selectTypeOptionVal = ""
  var txtSearchVal = ""
  var startDateVal = ""
  var endDateVal = ""

  function PagingLink(i2) {
     post_to_url('./Certificate_list.asp', { 'i2':i2 , 'i3':"<%=iSearchCol%>",'i4': "<%=iSearchText%>",'i5': "<%=iStatus%>",'i6':"<%=iStartDate%>",'i7':"<%=iEndDate%>" });
  }

  function fn_selSearch()
  {
    selectTypeOptionVal = $("#selectTypeOption option:selected").val();
    txtSearchVal =  $("#txtSearch").val();
    startDateVal =  $("#selectStartDate").val();
    endDateVal =  $("#selectEndDate").val();
    post_to_url('./Certificate_list.asp', { 'i2': 1 ,'i3': txtSearchVal,'i4': selectTypeOptionVal,'i5':startDateVal,'i6':endDateVal});
  }

  function ViewPagingLink(i1, i2){
		post_to_url('./Certificate_write.asp', {'i1':i1, 'i2':i2 , 'i3':"<%=iSearchCol%>",'i4': "<%=iSearchText%>",'i5': "<%=iStatus%>",'i6':"<%=iStartDate%>",'i7':"<%=iEndDate%>",'i8' : 2 });
	}

  function WriteLink(i2) {
     post_to_url('./Certificate_write.asp', { 'i2':i2, 'i3':"<%=ReqOptionVal%>",'i4': "<%=ReqTextSearchVal%>",'i5': "<%=ReqWeightVal%>",'i6':"<%=iYear%>",'i8':1});
  }

  function fn_selSearchXls() {
    post_to_url('./Certificate_List_Xls.asp', { 'i2': 1 ,'i3': txtSearchVal,'i4': selectTypeOptionVal,'i5':startDateVal,'i6':endDateVal});
  }

  $(document).ready(function() {
    $("#txtSearch").val('<%=iSearchText%>');
    $("#selectTypeOption").val('<%=iStatus%>');
    $("#selectStartDate").val('<%=iStartDate%>');
    $("#selectEndDate").val('<%=iEndDate%>');
    
    selectTypeOptionVal = $("#selectTypeOption option:selected").val();
    txtSearchVal =  $("#txtSearch").val();
    startDateVal =  $("#selectStartDate").val();
    endDateVal =  $("#selectEndDate").val();
  });
</script>

  <section>
    <div id="content">

		<!-- S: 네비게이션 -->
		<div	class="navigation_box">
			온라인서비스 > 선수증재발급
		</div>
		<!-- E: 네비게이션 -->
    <div class="search_top community">
      <div class="search_box">
          <select id="selectTypeOption" class="title_select">
            <option value="">전체</option>
          </select>
          <span>시작 날짜</span>
          <input type="text" name="selectStartDate" id="selectStartDate"  class="in_2 date_ipt"/>
          <span>종료 날짜</span>
          <input type="text" name="selectEndDate" id="selectEndDate"  class="in_2 date_ipt"/>
				  <input type="text" id="txtSearch" name="txtSearch" placeholder="신청자 및 핸드폰으로 검색해주세요."  class="title_input in_2"/>
			    <a href="javascript:;" id="btnselSearch" name="btnselSearch"  onclick="javascript:fn_selSearch();" class="btn_skyblue">검색</a>
          <a href="javascript:;" id="btnselSearchXls" name="btnselSearchXls" onclick="javascript:fn_selSearchXls();" class="btn_green"><i class="fa fa-file-excel-o" aria-hidden="true"></i>엑셀저장</a>
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
      </colgroup>
      <thead>
        <tr>
          <th scope="col">증명서 종류</th>
          <th scope="col">상태</th>
          <th scope="col">신청날짜</th>
          <th scope="col">수령방법</th>
          <th scope="col">이름</th>
          <th scope="col">핸드폰</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">
          <%
            iType = "1"  ' 1:개수 조회 , 2: 데이터 조회
            'sql Query
            LCnt = 0
            LSQL = "EXEC Admin_OnlineService_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iStatus & "','" & iCertificationName & "','" & iStartDate & "','" & iEndDate & "','" & iLoginID & "'"
	          'response.Write "LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon4.Execute(LSQL)
										
            If Not (LRs.Eof Or LRs.Bof) Then
		          Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
        <tr style="cursor:pointer" onclick="javascript:ViewPagingLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>')">
          <td><%=LRs("CertificateName") %></td>
          <td><%=LRs("StatusName") %></td>
          <td><%=LRs("InsDateCv") %></td>
          <td><%=LRs("ReceiveType") %></td>
          <td><%=LRs("Name") %></td>
          <td>
          <%
          phoneNum = LRs("Phone")
            resultPhoneNum = ""
            if(Len(phoneNum) < 4) Then
              resultPhoneNum = phoneNum
            elseif (Len(phoneNum) < 7) Then
              resultPhoneNum = mid(phoneNum,1,3)
              resultPhoneNum = resultPhoneNum + "-"
              resultPhoneNum = resultPhoneNum + mid(phoneNum,4,(Len(phoneNum)-3))
            elseif (Len(phoneNum) < 11) Then
            resultPhoneNum = mid(phoneNum,1,3)
            resultPhoneNum = resultPhoneNum + "-"
            resultPhoneNum = resultPhoneNum + mid(phoneNum,4, 3)
            resultPhoneNum = resultPhoneNum + "-"
            resultPhoneNum = resultPhoneNum + mid(phoneNum,7,(Len(phoneNum)-3))
            else
            resultPhoneNum = mid(phoneNum,1,3)
            resultPhoneNum = resultPhoneNum + "-"
            resultPhoneNum = resultPhoneNum + mid(phoneNum,4, 4)
            resultPhoneNum = resultPhoneNum + "-"
            resultPhoneNum = resultPhoneNum + mid(phoneNum,8,(Len(phoneNum)-7))
            End If
            response.Write(resultPhoneNum)
          
          %>
          
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
			<a href="javascript:;" onclick="javascript:WriteLink('<%=NowPage %>');" class="btn_skyblue"><span class="icon_pen">신청하기</span></a>
		</div>


    </div>
  <section>

<script type="text/javascript">
  var OSName = "<%=OSName%>"
  var OSCode = "<%=OSCode%>"
  var OSRCnt = "<%=OSRCnt%>"
  var OSNameArr = OSName.split("^");
  var OSCodeArr = OSCode.split("^");
  
  for(var i=1; i <= OSRCnt; i++)
  {
    $("#selectTypeOption").append("<option value=" + OSCodeArr[i] + ">" + OSNameArr[i] + "</option>");
  }

</script>

<!--#include file="footer.asp"-->
