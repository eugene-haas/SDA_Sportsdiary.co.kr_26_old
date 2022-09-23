<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
     'Request
    Dim ReqTextSearchVal
    Dim NowPage, iYear

    NowPage = fInject(Request("i2"))  ' 현재페이지
    iYear = (Request("i3"))
    ReqTextSearchVal= fInject(Request("i4"))
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
    PagePerData = global_PagePerData   ' 한화면에 출력할 갯수
    BlockPage = global_BlockPage       ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
    iType = "1"  ' 1:개수 조회 , 2: 데이터 조회
    'sql Query
    LSQL = "EXEC Conference_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iYear &  "', '" & ReqTextSearchVal &  "', '" & iLoginID & "'"
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



<script type="text/javascript">
  function PagingLink(i2) {
     post_to_url('./International_Schedule_List.asp', { 'i2':i2 , 'i3':"<%=iYear%>",'i4': "<%=ReqTextSearchVal%>" });
  }

  function fn_selSearch()
  {
    var selectYearVal = $("#selectYear option:selected").val();
    var txtSearchVal =  $("#txtSearch").val();
    post_to_url('./International_Schedule_List.asp', { 'i2': 1 ,'i3': selectYearVal,'i4': txtSearchVal});
  }

  function ViewPagingLink(i1, i2){
		post_to_url('./International_Schedule_List_write.asp', {'i1':i1, 'i2':i2, 'i3':"<%=iYear%>",'i4': "<%=ReqTextSearchVal%>",'i5':2});
	}

  function WriteLink(i2) {
     post_to_url('./International_Schedule_List_write.asp', { 'i2':i2, 'i3':"<%=iYear%>",'i4': "<%=ReqTextSearchVal%>",'i5':1});
  }
</script>

  <section>
    <div id="content">

		<!-- S: 네비게이션 -->
		<div	class="navigation_box">
			대회정보 > 국제대회
		</div>
		<!-- E: 네비게이션 -->
    <div class="search_top community">
      <div class="search_box">
          <select id="selectYear" name="selectYear" class="title_select">
            <option value="">년도</option>
          <%
              YEARSQL = " SELECT Distinct iYear FROM Conference_Board_Tbl "
                    YEARSQL =YEARSQL+ " WHERE Division='1' AND DelYN='N' And iYear != '' "
                    YEARSQL =YEARSQL+ " ORDER BY iYear DESC"
	            'JudoTitleWriteLine "YEARSQL", YEARSQL
              'response.End
              Set YRs = Dbcon4.Execute(YEARSQL)
              IF Not(YRs.Eof Or YRs.Bof) then
                Do Until YRs.Eof
                    YRCnt = YRCnt + 1 
                  %>
                      <option value="<%=YRs("iYear")%>"> <%=YRs("iYear")%></option> 
                  <%
                  YRs.MoveNext
                Loop
              End IF
              YRs.close

              if(YRCnt = 0) Then
              %>
                <option value="<%=year(now)%>"> <%=year(now)%></option> 
              <%
              End If
          %>
          </select>

				<input type="text" id="txtSearch" name="txtSearch" placeholder="대회명 및 장소로 입력해주세요."  class="title_input in_2"/>
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
      </colgroup>
      <thead>
        <tr>
          <th scope="col">제목</th>         
          <th scope="col">장소</th>
          <th scope="col">기간</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">
          <%
            iType = "2"  ' 1:개수 조회 , 2: 데이터 조회
            'sql Query
            LSQL = "EXEC Conference_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iYear &  "', '" & ReqTextSearchVal &  "', '" & iLoginID & "'"
	          'response.Write "LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon4.Execute(LSQL)
										
            If Not (LRs.Eof Or LRs.Bof) Then
		          Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
        <tr style="cursor:pointer" onclick="javascript:ViewPagingLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>')">
        <td><%=LRs("Title") %></td>
        <td><%=LRs("Location") %></td>
        <td><%=LRs("StartDate")%> ~ <%=LRs("EndDate") %></td>
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
					<td colspan="3">
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
  $( document ).ready(function() {
		$("#txtSearch").val('<%=ReqTextSearchVal%>');
    document.getElementById("selectYear").selectedIndex = "1";
  })
</script>

<!--#include file="footer.asp"-->
