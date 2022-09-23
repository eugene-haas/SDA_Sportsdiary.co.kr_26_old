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
  
    Dim NowPage, iType

    NowPage = fInject(Request("i2"))  ' 현재페이지
    iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

	  iUserID = fInject(Request.cookies("UserID"))
	  'iLoginID = decode(iUserID,0)
    iLoginID = crypt.DecryptStringENC(iUserID)

    ' 뷰 관련
    Dim LCnt, iAUSeq, AUSeq, InsDateCv, LoginIDYN
    LCnt = 0

	  Dim sType 
	  sType = iType

	  ' iType은 읽기와 쓰기를 같이 쓰게 됌으로 2로 고정
    If iType = "2" Then

      iAdminMenuListIDX = fInject(Request("i1"))
      'iiAdminMenuListIDX = decode(iAdminMenuListIDX,0)
      iiAdminMenuListIDX = crypt.DecryptStringENC(iAdminMenuListIDX)


      LSQL = "EXEC AdminMenu_Read_S '" & iType & "','" & NowPage & "','" & iiAdminMenuListIDX & "','" & iLoginID & "','','','','',''"
	    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
      'response.End
    
      Set LRs = DBCon7.Execute(LSQL)

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
        response.End

      End If
    
    End If
    
  %>

  <script type="text/javascript">

    var iType = Number("<%=iType%>");
    //var iMSeq = Number("<%=iMSeq%>");
  
    function Del_Link(i1, i2) {
      if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
        post_to_url('./Admin_MenuDelete_p.asp', { 'i1': i1, 'i2': i2 });
      }
      //else {
      //}
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

      if (confirm("해당 메뉴를 저장 하시겠습니까?") == true) {
        //  try {

        theForm.method = "post";
        theForm.target = "_self";
        theForm.action = "./Admin_MenuWrite_p.asp";
        theForm.submit();

        //  } catch (e) { }
        //}
        //else {
        //
        //}

      }

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
      <!--<i class="fas fa-chevron-right"></i>
      <span>등록</span>-->
    </div>
    <!-- E: navigation -->
    <!-- S: pd-15 -->
    <div class="pd-30">
      <!-- S: sub-content -->
      <div class="sub-content">
        
        <!-- S: Admin_MenuList_write -->
        <div class="Admin_MenuList_write">
          <!-- S: box-shadow -->
          <div class="box-shadow">
            <!-- S: table-box -->
            <div class="table-box basic-write">

              <form id="form1" name="form1" action="./Admin_MenuWrite_p.asp" method="post">
              <table cellspacing="0" cellpadding="0">
                
                <!--<tr>
                  <th>대회명</th>
                  <td>
                    <select name="" id="">
                      <option value="">스포츠 양양</option>
                    </select>
                  </td>
                </tr>-->
                
                <% If iType = "2" Then %>
                <tr>
                  <th>등록일</th>
                  <td>
                    <%=WriteDateCv %>
                  </td>
                </tr>
                <% End If %>

                <tr>
                  <th>메뉴코드</th>
                  <td>
                      <input type="text" placeholder="메뉴코드를 입력하세요" id="iRoleDetail" name="iRoleDetail" value="<%=RoleDetail %>" class="in-style-1" />
                  </td>
									<th>메뉴명</th>
                  <td>
                      <input type="text" placeholder="아이디를 입력하세요" id="iRoleDetailNm" name="iRoleDetailNm" value="<%=RoleDetailNm %>" class="in-style-1" />
                  </td>
                </tr>

                <tr>
                  <th>메뉴링크</th>
                  <td>
                      <input type="text" placeholder="비밀번호를 입력하세요" id="iLink" name="iLink" value="<%=Link %>" class="in-style-1" />
                  </td>
                  <th>대메뉴코드</th>
                  <td>
                      <input type="text" placeholder="비밀번호를 입력하세요" id="iRoleDetailGroup1" name="iRoleDetailGroup1" value="<%=RoleDetailGroup1 %>" class="in-style-1" />
                  </td>
                </tr>

                <tr>
                  <th>대메뉴명</th>
                  <td>
                      <input type="text" placeholder="비밀번호를 입력하세요" id="iRoleDetailGroup1Nm" name="iRoleDetailGroup1Nm" value="<%=RoleDetailGroup1Nm %>" class="in-style-1" />
                  </td>
                  <th>중메뉴코드</th>
                  <td>
                      <input type="text" placeholder="비밀번호를 입력하세요" id="iRoleDetailGroup2" name="iRoleDetailGroup2" value="<%=RoleDetailGroup2 %>" class="in-style-1" />
                  </td>
                </tr>

                <tr>
                  <th>중메뉴명</th>
                  <td>
                      <input type="text" placeholder="비밀번호를 입력하세요" id="iRoleDetailGroup2Nm" name="iRoleDetailGroup2Nm" value="<%=RoleDetailGroup2Nm %>" class="in-style-1" />
                  </td>
									<th></th>
                  <td>
                  </td>
                </tr>
                
                <% if iType = 2 then %>
                <tr>
                  <th>사용유무</th>
                  <td>
                    <select id="selUseYN" name="selUseYN">
                      <option value="Y">사용중</option>
                      <option value="N" <% if UseYN = "N" then %>selected<% end if %>>미사용</option>
                    </select>
                  </td>
                </tr>
                <% end if %>

              </table>

              <input type="hidden" id="iAdminMenuListIDX" name="iAdminMenuListIDX" value="<%=iAdminMenuListIDX %>" />
					    <input type="hidden" id="iType" name="iType" value="<%=iType %>" />
					    <input type="hidden" id="iID" name="iID" value="<%=iUserID %>" />
					    <input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />

              </form>

            </div>
            <!-- E: table-box -->
          </div>
          <!-- E: box-shadow -->
          <!-- S: bt-btn-box -->
          <div class="bt-btn-box txt-right">
            <a href="javascript:;" id="btnCC" name="btnCC" onclick="javascript: CancelLink('<%=NowPage %>');" class="white-btn">취소</a>
            <a href="javascript:;" id="btnOK" name="btnOK" onclick="javascript: OK_Link();" class="blue-btn">등록</a>
          </div>
          <!-- E: bt-btn-box -->
        </div>
        <!-- E: Admin_MenuList_write -->
      </div>
      <!-- E: sub-content -->
    </div>
    <!-- E: pd-15 -->
  </div>
  <!-- E: right-content -->
  
</div>
<!-- S: 환불모달 -->
<!-- #include file="../include/modal/refund_modal.asp" -->
<!-- E: 환불모달 -->
<!-- S: footer -->
<!-- #include file="../include/footer.asp" -->
<!-- E: footer -->

<% ADADMIN_DBClose() %>