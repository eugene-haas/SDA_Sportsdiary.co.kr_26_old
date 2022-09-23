<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<%
  ' 어드민관리메뉴 코드
  RoleType = "MNM"  
%>
<!--#include file="../../include/CheckRole.asp"-->


<%

  Dim NowPage, iType

  NowPage = fInject(Request("i2"))  ' 현재페이지
  iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

  'Name = fInject(Request.cookies("UserName"))
  iUserID = fInject(Request.cookies("UserID"))
  iLoginID = decode(iUserID,0)

  ' 뷰 관련
  Dim LCnt, iAUSeq, AUSeq, InsDateCv, LoginIDYN
  LCnt = 0

  Dim sType 
  sType = iType

  ' iType은 읽기와 쓰기를 같이 쓰게 됌으로 2로 고정
  If iType = "2" Then

    iAdminMenuListIDX = fInject(Request("i1"))
    iiAdminMenuListIDX = decode(iAdminMenuListIDX,0)


    LSQL = "EXEC AdminMenu_Read_S '" & iType & "','" & NowPage & "','" & iiAdminMenuListIDX & "','" & iLoginID & "','','','','',''"
    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then

      Do Until LRs.Eof
      
          LCnt = LCnt + 1
          'AdminMenuListIDX = LRs("AdminMenuListIDX")
          RoleDetail = LRs("RoleDetail")
          RoleDetailNm = LRs("RoleDetailNm")
          RoleDetailGroup1 = LRs("RoleDetailGroup1")
          RoleDetailGroup1Nm = LRs("RoleDetailGroup1Nm")
          RoleDetailGroup2 = LRs("RoleDetailGroup2")
          RoleDetailGroup2Nm = LRs("RoleDetailGroup2Nm")
          Link = LRs("Link")
          WriteDateCv = LRs("WriteDateCv")
          LoginIDYN = LRs("LoginIDYN")
          UseYN = LRs("UseYN")

        LRs.MoveNext
      Loop

    End If
  
    LRs.close

    ' 디버깅 모드로 수정 해서 강제로 접근할 경우 체크
    If LoginIDYN = "N" Then

      response.Write "<script type='text/javascript'>alert('잘못된 접근 입니다.');location.href='/';</script>"
      'response.Write "<script type='text/javascript'>alert('글 등록이 잘 됐습니다.');</script>"
      response.End

    End If


    'LCnt1 = 0
    '
    'iiType = "4"
    '
    'LSQL = "EXEC AdminMember_Menu_S '" & iiType & "','','','" & sUserID & "','','','','',''"
    ''response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    ''response.End
    '
    'Set LRs = DBCon.Execute(LSQL)
    '
    'If Not (LRs.Eof Or LRs.Bof) Then
    '
    ' Do Until LRs.Eof
    '
    '     LCnt1 = LCnt1 + 1
    '     iRoleDetail1 = iRoleDetail1&"^"&LRs("RoleDetail")&""
    '   
    '     LRs.MoveNext
    ' Loop
    '
    'End If
    '
    'LRs.close
    
    DBClose()
  
  End If
  
%>


<script type="text/javascript">
  /**
   * left-menu 체크
   */
  var locationStr = "Admin_MenuList";  // 메뉴
  /* left-menu 체크 */

  var iType = Number("<%=iType%>");
  //var iMSeq = Number("<%=iMSeq%>");

  function Del_Link(i1, i2) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
      post_to_url('./Admin_MenuDelete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
    //post_to_url('./Admin_MenuList.asp', { 'i2': i2 });
    window.history.back();
  }

  function OK_Link() {

    // 스마트에디트 아닐때
    var theForm = document.form1;
    
    
    if (theForm.iRoleDetail.value == "") {
      alert('메뉴코드를 넣어 주세요.');
      return theForm.iRoleDetail.focus();
    }
    
    if (theForm.iRoleDetailNm.value == "") {
      alert('메뉴명을 넣어 주세요.');
      return theForm.iRoleDetailNm.focus();
    }

    if (theForm.iLink.value == "") {
      alert('메뉴링크를 넣어 주세요.');
      return theForm.iLink.focus();
    }

    if (theForm.iRoleDetailGroup1.value == "") {
      alert('대메뉴코드를 넣어 주세요.');
      return theForm.iRoleDetailGroup1.focus();
    }

    if (theForm.iRoleDetailGroup1Nm.value == "") {
      alert('대메뉴명을 넣어 주세요.');
      return theForm.iRoleDetailGroup1Nm.focus();
    }

    if (theForm.iRoleDetailGroup2.value == "") {
      alert('중메뉴코드를 넣어 주세요.');
      return theForm.iRoleDetailGroup2.focus();
    }

    if (theForm.iRoleDetailGroup2Nm.value == "") {
      alert('중메뉴명을 넣어 주세요.');
      return theForm.iRoleDetailGroup2Nm.focus();
    }
    
    if (confirm("해당 메뉴 상세내역을 저장 하시겠습니까?") == true) {
      try {
    
        theForm.method = "post";
        theForm.target = "_self";
        theForm.action = "./Admin_MenuWrite_p.asp";
        theForm.submit();
    
      } catch (e) { }
    }
    else {
    
    }

  }

</script>

  <!-- S: content -->
  <div id="content" class="admin_menu_write">

    <!-- S : 내용 시작 -->
    <div class="contents">
      <!-- S: page_title -->
      <div class="page_title clearfix">
        <h2>메뉴 상세내역</h2>
        <a href="./Admin_MenuList.asp" class="btn btn-back"><span class="ic_deco"><i class="fas fa-angle-left"></i></span>뒤로가기</a>

        <!-- S: 네비게이션 -->
        <div  class="navigation_box">
          <span class="ic_deco">
            <i class="fas fa-angle-right fa-border"></i>
          </span>
          <ul>
            <li>메뉴 관리</li>
            <li><a href="./Admin_MenuList.asp">메뉴</a></li>
            <li><a href="./Admin_MenuWrite.asp">메뉴 상세내역</a></li>
          </ul>
        </div>
        <!-- E: 네비게이션 -->

      </div>
      <!-- E: page_title -->

      <form id="form1" name="form1" action="./Admin_MenuWrite_p.asp" method="post">
        <table cellspacing="0" cellpadding="0" class="left-head view-table">

          <% If iType = "2" Then %>
          <tr>
            <th>등록일</th>
            <td colspan="2">
              <span class="con">
                <span class="regist_date"><%=WriteDateCv %><br /></span>
              </span>
            </td>
          </tr>
          <% End If %>

          <tr>
            <th>메뉴코드</th>
            <td colspan="2">
              <span class="con">
                <input type="text" id="iRoleDetail" name="iRoleDetail" value="<%=RoleDetail %>" class="in_1"/>
              </span>
            </td>
          </tr>

          <tr>
            <th>메뉴명</th>
            <td colspan="2">
              <span class="con">
                <input type="text" id="iRoleDetailNm" name="iRoleDetailNm" value="<%=RoleDetailNm %>" class="in_1"/>
              </span>
            </td>
          </tr>

          <tr class="half-line">
            <th>메뉴링크</th>
            <td colspan="2">
              <span class="con">
                <input type="text" id="iLink" name="iLink" value="<%=Link %>" class="in_1"/>
              </span>
            </td>
          </tr>

          <tr>
            <th>대메뉴코드</th>
            <td colspan="2">
              <span class="con">
                <input type="text" id="iRoleDetailGroup1" name="iRoleDetailGroup1" value="<%=RoleDetailGroup1 %>" class="in_1"/>
              </span>
            </td>
          </tr>

          <tr>
            <th>대메뉴명</th>
            <td colspan="2">
              <span class="con">
                <input type="text" id="iRoleDetailGroup1Nm" name="iRoleDetailGroup1Nm" value="<%=RoleDetailGroup1Nm %>" class="in_1"/>
              </span>
            </td>
          </tr>

          <tr>
            <th>중메뉴코드</th>
            <td colspan="2">
              <span class="con">
                <input type="text" id="iRoleDetailGroup2" name="iRoleDetailGroup2" value="<%=RoleDetailGroup2 %>" class="in_1"/>
              </span>
            </td>
          </tr>

          <tr>
            <th>중메뉴명</th>
            <td colspan="2">
              <span class="con">
                <input type="text" id="iRoleDetailGroup2Nm" name="iRoleDetailGroup2Nm" value="<%=RoleDetailGroup2Nm %>" class="in_1"/>
              </span>
            </td>
          </tr>

          <% if iType = 2 then %>
          <tr>
            <th>사용유무</th>
            <td colspan="2">
              <span class="con">
                <select id="selUseYN" name="selUseYN">
                  <option value="Y">사용중</option>
                  <% if UseYN = "N" then %>
                  <option value="N" selected>미사용</option>
                  <% else %>
                  <option value="N">미사용</option>
                  <% end if %>
                </select>
              </span>
            </td>
          </tr>
          <% end if %>

        </table>
        <div class="btn-list">
          <input type="button" id="btnOK" name="btnOK" class="btn btn-confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
          <input type="button" id="btnCC" name="btnCC" class="btn btn-cancel" value="취소" onclick="javascript: CancelLink('<%=NowPage %>');" style="cursor:pointer" />

          <input type="hidden" id="iAdminMenuListIDX" name="iAdminMenuListIDX" value="<%=iAdminMenuListIDX %>" />
          <input type="hidden" id="iType" name="iType" value="<%=iType %>" />
          <input type="hidden" id="iID" name="iID" value="<%=iUserID %>" />
          <input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
        </div>
      </form>

    </div>
    <!-- E : 내용 시작 -->
  </div>
  <!-- E: content admin_emnu_write -->

<% if sType = 2 then %>
<script type="text/javascript">

  var LCnt1 = Number("<%=LCnt1%>");

  if (LCnt1 > 0) {

    var iRoleDetail1 = "<%=iRoleDetail1%>";

    var iRoleDetail1arr = iRoleDetail1.split("^");

    //alert(iRoleDetail1);

    for (var i = 1; i < LCnt1 + 1; i++) {
      $('#chkiRoleDetail2_' + iRoleDetail1arr[i] + '').prop("checked", true);
    }

  }

</script>
<% end if %>

<!--#include file="../../include/footer.asp"-->

</html>