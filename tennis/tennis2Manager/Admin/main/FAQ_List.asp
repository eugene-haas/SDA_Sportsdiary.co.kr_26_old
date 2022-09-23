<!--#include file="../dev/dist/config.asp"-->

<!--#include file="head.asp"-->

<%
    '변수 선언
    Dim iTotalCount, iTotalPage '페이지 개수, 총 페이지 
    Dim PagePerData '데이터 가져오는 개수 
    Dim BlockPage  '화면에 보이는 페이징 개수
    Dim LCnt				'Row 데이터 개수
    Dim NowPage  '현재 페이지

     'Parameter
  	NowPage = fInject(Request("i2"))  ' 현재페이지
    iSearchText = fInject(Request("i3"))
    iSearchCol = fInject(Request("i4"))

    PagePerData = global_PagePerData   ' 한화면에 출력할 갯수
    BlockPage = global_BlockPage       ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
    iDivision = "7"                    ' T:전부, 1:포토갤러리, 2:동영상갤러리, 3:질문과답변, 4:자유게시판, 5:관장님대화방, 6 : 시도지부 & 연맹 소식, 7 : FAQ
    iType = "2"  ' 1:조회, 2:총갯수

    if(Len(iSearchCol) = 0) Then iSearchCol = "S" ' T:전부, S:제목, C:내용, U:작성자
    if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어
    if(NowPage = 0) Then NowPage = 1
    
    'sql Query
    LSQL = "EXEC Community_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"

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
    'Response.End
    'JudoTitleWriteLine "iTotalPage", iTotalPage
    'JudoTitleWriteLine "iTotalCount", iTotalCount
%>


<script type="text/javascript">
	var selSearchValue = "<%=iSearchCol%>"
	var txtSearchValue = "<%=iSearchText%>"

	function PagingLink(i2){
		post_to_url('./FAQ_List.asp', { 'i2': i2, 'i3': txtSearchValue, 'i4': selSearchValue });
	}

	function fn_selSearch(){
		selSearchValue = document.getElementById('selSearch').value;
		txtSearchValue = document.getElementById('txtSearch').value;
		post_to_url('./FAQ_List.asp', { 'i2': 1, 'i3': txtSearchValue, 'i4': selSearchValue });
	}

  function ViewPagingLink(i1, i2){
		post_to_url('./FAQ_List_write.asp', { 'i1':i1 , 'i2':i2, 'i3': "<%=iSearchText%>", 'i4': "<%=iSearchCol%>", 'i5': 2});
	}

  function WriteLink(i2) {
     post_to_url('./FAQ_List_write.asp', {'i2':i2, 'i3': "<%=iSearchText%>", 'i4': "<%=iSearchCol%>", 'i5': 1});
  }

</script>
  <section>
    <div id="content">
		<!-- S: 네비게이션 -->
		<div	class="navigation_box">
			커뮤니티 > FAQ
		</div>
		<!-- E: 네비게이션 -->
    <div class="search_top community">
      <div class="search_box">
          <select id="selSearch" name="selSearch">
						<option value="S">제목</option>
						<option value="C">내용</option>
					</select>
				<input type="text" id="txtSearch" name="txtSearch" class="title_input in_2"/>

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
      </colgroup>
      <thead>
        <tr>
          <th scope="col">제목</th>         
          <th scope="col">파일여부</th>
          <th scope="col">작성날짜</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">
        <%
            iType = 1 
            LSQL = "EXEC Community_Board_Search_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"
	          'response.Write "LSQL="&LSQL&"<br>"
            'response.End
            Set LRs = DBCon4.Execute(LSQL)
            If Not (LRs.Eof Or LRs.Bof) Then
		          Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
        <tr style="cursor:pointer" onclick="javascript:ViewPagingLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>')">
          <td><%=LRs("Subject") %></td>
          <td><%=LRs("FileYN") %></a></td>
          <td><%=LRs("InsDateCv") %></a></td>
        </tr>
        <%
              LRs.MoveNext
              Loop
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
		$("#txtSearch").val('<%=iSearchText%>');
		$("#selSearch").val('<%=iSearchCol%>');
</script>

<!--#include file="footer.asp"-->
