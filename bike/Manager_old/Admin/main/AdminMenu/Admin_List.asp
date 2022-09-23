<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<% 
  RoleType = "AM" 
%>
<!--#include file="../../include/CheckRole.asp"-->


<%
  Dim iTotalCount, iTotalPage, LCnt0 '페이징
  LCnt0 = 0

  Dim LCnt, NowPage, PagePerData '리스트
  LCnt = 0

  iLoginID = Request.Cookies("UserID")
  iLoginID = decode(iLoginID,0)

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
  
  Set LRs = DBCon.Execute(LSQL)
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
  
  Set LRs = DBCon.Execute(LSQL)
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
    <!-- S: content -->
    <div id="content" class="admin_list">
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>어드민</h2>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>어드민 관리</li>
            <li><a href="./Admin_List.asp">어드민</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->
      
    <div class="search_top">
      <div class="search_box">
        <select id="selSearch" name="selSearch" class="title_select">
          <option value="N">성명</option>
          <option value="I">ID</option>
        </select>
        <input type="text" id="txtSearch" name="txtSearch" placeholder="검색어를 입력해 주세요." class="ipt-word">
        <a href="javascript:;" id="btnselSearch" name="btnselSearch" onclick="javascript:fn_selSearch();" class="btn btn-search">검색</a>
        <% if iAuthority = "F" then %>
        <a href="javascript:;" onclick="javascript:WriteLink('<%=NowPage %>');" class="btn">어드민 등록</a>
        <% end if %>
      </div>

    <div class="total_count"><span>전체: <%=iTotalCount%></span>, <span><%=NowPage%> page /
    <%=iTotalPage%> pages
    </span></div>
     <!-- 
        S : 내용 시작
     -->
    <table class="table-list">
      <caption class="sr-only">관리자 리스트</caption>
      <thead>
        <tr>
          <th>순번</th>
          <th>ID</th>
          <th>성명</th>
          <th>작성일</th>
          <th>사용유무</th>
          <th>어드민권한</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">
          <%
            ' 리스트 조회
            iType = "1"

            LSQL = "EXEC AdminMember_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSearchCol & "','" & iSearchText & "','" & iLoginID & "','','','','',''"
            'response.Write "LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon.Execute(LSQL)
                    
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
          <% if LRs("UseYN") = "Y" then %>
					<td><%=LRs("UseYNName") %></td>
          <% else %>
					<td style="color:red;"><%=LRs("UseYNName") %></td>
					<% end if %>
					<td><%=LRs("AuthorityName") %></td>
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
          <td colspan="4">
              <div>등록된 게시물이 없습니다.</div>
            </td>
        </tr>
        <%
          End If
  
          LRs.close
  
          DBClose()
        %>

      </tbody>
    </table>

    <%
      if LCnt > 0 then
    %>
      <!-- S: page_index -->
      <div class="page_index">
        <!--#include file="../../dev/dist/judoPaging_Admin.asp"-->
      </div>
      <!-- E: page_index -->
    <%
      End If
    %>

    

    </div>
    <!-- E: community -->


    <script type="text/javascript">

      $("#txtSearch").val(txtSearchValue);
      $("#selSearch").val(selSearchValue);

    </script>

  </div>
  <!-- E: content -->
<!--#include file="../../include/footer.asp"-->