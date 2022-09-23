<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<% 
	RoleType = "AM"	
%>
<!--#include file="CheckRole.asp"-->


<%
  Dim iTotalCount, iTotalPage, LCnt0 '페이징
  LCnt0 = 0

  Dim LCnt, NowPage, PagePerData '리스트
  LCnt = 0

  iLoginID = Request.Cookies("UserID")
	'iLoginID = decode(iLoginID,0)
  iLoginID = crypt.DecryptStringENC(iLoginID)


  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
  BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

  'Request Data
	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))

  If Len(NowPage) = 0 Then
		NowPage = 1
	End If

	if(Len(iSearchCol) = 0) Then iSearchCol = "N" ' T:전부, N:성명, I:ID
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

  iType = "2"                      ' 1:조회, 2:총갯수

  LSQL = "EXEC AdminMember_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSearchCol & "','" & iSearchText & "','" & iLoginID & "','','','','',''"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon7.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
		Loop
	End If
  LRs.close


	LSQL = "EXEC AdminMember_Check_S '" & iLoginID & "'"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon7.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        iAuthority = LRs("Authority")
      LRs.MoveNext
		Loop
	End If
  LRs.close

%>

  <script type="text/javascript">

    var selSearchValue = "<%=iSearchCol%>";
    var txtSearchValue = "<%=iSearchText%>";

    function WriteLink(i2) {

      post_to_url('./Admin_Write.asp', { 'i2': i2, 'iType': '1' });

    }

    function ReadLink(i1, i2) {
      //location.href = 'cmRead.asp?i1=' + i1 + '&i2=' + i2;
      //post_to_url('./cmRead.asp', { 'i1': i1, 'i2': i2 });

      //./Community_Motion_Read.asp

      //alert(i1 + " , " + i2);
      post_to_url('./Admin_Write.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
    }

    function PagingLink(i2) {

      //location.href = 'cmList.asp?i2=' + i2;
      post_to_url('./Admin_List.asp', { 'i2': i2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function fn_selSearch() {

      selSearchValue = document.getElementById('selSearch').value;
      txtSearchValue = document.getElementById('txtSearch').value;

      post_to_url('./Admin_List.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

  </script>


   <section>
    <div id="content">

		<!-- S: 네비게이션 -->
		<div	class="navigation_box">
			어드민 관리 > 어드민 관리
		</div>
		<!-- E: 네비게이션 -->
    <div class="search_top community">
			<div class="search_box">
				<select id="selSearch" name="selSearch" class="title_select">
					<option value="N">성명</option>
					<option value="I">ID</option>
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
        <col width="*" />
        <col width="*" />
        <col width="*" />
				<col width="*" />
      </colgroup>
      <thead>
        <tr>
          <th scope="col">순번</th>         
          <th scope="col">ID</th>
          <th scope="col">성명</th>
          <th scope="col">작성일</th>
					<th scope="col">사용유무</th>
					<th scope="col">어드민권한</th>
					<!--<th scope="col">칼럼승인권한</th>-->
        </tr>
      </thead>
      <tbody id="gametitlelist">
          <%
            ' 리스트 조회
            iType = "1"

            LSQL = "EXEC AdminMember_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSearchCol & "','" & iSearchText & "','" & iLoginID & "','','','','',''"
	          'response.Write "LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon7.Execute(LSQL)
										
            If Not (LRs.Eof Or LRs.Bof) Then
		          Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
				<% if iAuthority = "F" then %>
        <tr style="cursor:pointer" onclick="javascript:ReadLink('<%=encode(LRs("AdminMemberIDX"),0) %>','<%=NowPage %>');">
				<% else %>
				<tr>
				<% end if %>
          <td><%=LRs("Num") %></td>
          <td><%=LRs("UserID") %></td>
          <td class="name">
						<%=LRs("AdminName") %>
          </td>
          <td><%=LRs("WriteDateCv") %></td>
					<td><%=LRs("UseYNName") %></td>
          <!--<td><%=LCnt %></td>-->
					<td><%=LRs("AuthorityName") %></td>
					<!--<td><%'=LRs("ColumnApprovalYN") %></td>-->
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

		<% if iAuthority = "F" then %>
    <!-- E : 내용 시작 -->
    <div class="btn_list right">
			<a href="javascript:;" onclick="javascript:WriteLink('<%=NowPage %>');" class="btn_skyblue"><span class="icon_pen">어드민 등록</span></a>
		</div>
		<% end if %>

    </div>
  <section>

    <script type="text/javascript">

      $("#txtSearch").val(txtSearchValue);
      $("#selSearch").val(selSearchValue);

    </script>
<!--#include file="footer.asp"-->
<% ADADMIN_DBClose() %>
