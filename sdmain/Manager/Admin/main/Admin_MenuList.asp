
<!--#include file="../dev/dist/config.asp"-->

<!-- S: head -->
<!-- #include file="../include/head.asp" -->
<!-- E: head -->

<% 
	RoleType = "MNM"	
%>
<!--#include file="CheckRole.asp"-->

<div class="content">
  <!-- S: left-gnb -->
  <!-- #include file="../include/left-gnb.asp" -->
  <!-- E: left-gnb -->

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
  
  	if(Len(iSearchCol) = 0) Then iSearchCol = "C" ' C:코드
  	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어
  
    iType = "2"                      ' 1:조회, 2:총갯수
  
    LSQL = "EXEC AdminMenu_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSearchCol & "','" & iSearchText & "','" & iLoginID & "','','','','',''"
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

      post_to_url('./Admin_MenuWrite.asp', { 'i2': i2, 'iType': '1' });

    }

    function ReadLink(i1, i2) {
      //location.href = 'cmRead.asp?i1=' + i1 + '&i2=' + i2;
      //post_to_url('./cmRead.asp', { 'i1': i1, 'i2': i2 });

      //./Community_Motion_Read.asp

      //alert(i1 + " , " + i2);
      post_to_url('./Admin_MenuWrite.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
    }

    function PagingLink(i2) {

      //location.href = 'cmList.asp?i2=' + i2;
      post_to_url('./Admin_MenuList.asp', { 'i2': i2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function fn_selSearch() {

      selSearchValue = document.getElementById('selSearch').value;
      txtSearchValue = document.getElementById('txtSearch').value;

      post_to_url('./Admin_MenuList.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

  </script>


  <!-- S: right-content -->
  <div class="right-content">
    <!-- S: navigation -->
    <div class="navigation">
      <i class="fas fa-home"></i>
      <i class="fas fa-chevron-right"></i>
      <span>어드민관리</span>
      <i class="fas fa-chevron-right"></i>
      <span>메뉴관리</span>
    </div>
    <!-- E: navigation -->
    <!-- S: pd-15 -->
    <div class="pd-30">
      <!-- S: sub-content -->
      <div class="sub-content">
        <!-- S: search-box -->
        <div class="box-shadow">
          <div class="search-box-1">
            <!--<select name="" id="">
              <option value="">2018</option>
              <option value="">2017</option>
            </select>
            <select name="" id="">
              <option value="">대회선택</option>
            </select>
            <select name="" id="">
              <option value="">종목선택</option>
            </select>-->
            <select id="selSearch" name="selSearch">
				    	<option value="C">코드값</option>
				    	<option value="CN">코드명</option>
				    	<option value="G1">대메뉴명</option>
				    	<option value="G2">중메뉴명</option>
				    </select>
            <input type="text" id="txtSearch" name="txtSearch" style="width:400px;">
            <a href="javascript:;" id="btnselSearch" name="btnselSearch" onclick="javascript:fn_selSearch();" class="btn btn-primary search-btn">검색</a>
          </div>
        </div>
        <!-- E: search-box -->
        <!-- S: Admin_MenuList -->
        <div class="Admin_MenuList">
          <!-- S: all-list-number -->
          <div class="all-list-number">
            <span class="l-txt">
              전체<span class="red-font font-bold"><%=iTotalCount %></span>건
            </span>
          </div>
          <!-- E: all-list-number -->
          <!-- S: table-box -->
          <div class="table-box basic-table-box">
            <table cellspacing="0" cellpadding="0">
              <tr>
                <th>순번</th>         
                <th>메뉴코드</th>
                <th>메뉴명</th>
					      <th>메뉴링크</th>
                <th>대메뉴코드</th>
					      <th>대메뉴명</th>
					      <th>중메뉴코드</th>
					      <th>중메뉴명</th>
					      <th>사용유무</th>
              </tr>

              <%
                ' 리스트 조회
                iType = "1"

                LSQL = "EXEC AdminMenu_S '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iSearchCol & "','" & iSearchText & "','" & iLoginID & "','','','','',''"
	              'response.Write "LSQL="&LSQL&"<br>"
                'response.End
  
                Set LRs = DBCon7.Execute(LSQL)
				        		
                If Not (LRs.Eof Or LRs.Bof) Then
		              Do Until LRs.Eof
                      LCnt = LCnt + 1
                      AdminMenuListIDX = LRs("AdminMenuListIDX")
              %>
				      <% if iAuthority = "F" then %>
              <tr style="cursor:pointer" onclick="javascript:ReadLink('<%=crypt.EncryptStringENC(AdminMenuListIDX) %>','<%=NowPage %>');">
				      <% else %>
				      <tr>
				      <% end if %>
                <td>
                  <span><%=LRs("Num") %></span>
                </td>
                <td class="text-left">
                  <span><%=LRs("RoleDetail") %></span>
                </td>
                <td class="text-left">
                  <span><%=LRs("RoleDetailNm") %></span>
                </td>
                <td class="text-left">
                  <span><%=LRs("Link") %></span>
                </td>
                <td>
                  <span><%=LRs("RoleDetailGroup1") %></span>
                </td>
                <td>
                  <span><%=LRs("RoleDetailGroup1Nm") %></span>
                </td>
                <td>
                  <span><%=LRs("RoleDetailGroup2") %></span>
                </td>
                <td>
                  <span><%=LRs("RoleDetailGroup2Nm") %></span>
                </td>
                <td>
                  <span><%=LRs("UseYNName") %></span>
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
				      	<td colspan="9">
				      		<div>등록된 게시물이 없습니다.</div>
				      	</td>
				      </tr>
              <%
                End If
  
                LRs.close
              %>

            </table>
          </div>
          <!-- E: table-box -->

          <% if iAuthority = "F" then %>
          <!-- S: bt-btn-box -->
          <div class="bt-btn-box txt-right">
            <a href="javascript:;" onclick="javascript:WriteLink('<%=NowPage %>');" class="btn btn-primary">등록</a>
          </div>
          <!-- E: bt-btn-box -->
          <% end if %>


          <!-- S: paging -->
          <%
		      	if iTotalCount > 0 then
		      %>
            <!--#include file="../dev/dist/Paging_TAdmin.asp"-->
		      <%
		      	End If
		      %>
          <!-- E: paging -->


        </div>
        <!-- E: Admin_MenuList -->
      </div>
      <!-- E: sub-content -->
    </div>
    <!-- E: pd-15 -->
  </div>
  <!-- E: right-content -->

</div>

<script type="text/javascript">

  $("#txtSearch").val(txtSearchValue);
  $("#selSearch").val(selSearchValue);

</script>

<!-- S: 환불모달 -->
<!-- #include file="../include/modal/refund_modal.asp" -->
<!-- E: 환불모달 -->
<!-- S: footer -->
<!-- #include file="../include/footer.asp" -->
<!-- E: footer -->
<% ADADMIN_DBClose() %>