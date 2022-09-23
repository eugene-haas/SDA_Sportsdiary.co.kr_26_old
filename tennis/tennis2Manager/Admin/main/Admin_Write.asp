﻿<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
	' 어드민관리메뉴 코드
	RoleType = "AM"	
%>
<!--#include file="CheckRole.asp"-->

<%

	Dim NowPage, iType

	NowPage = fInject(Request("i2"))  ' 현재페이지
	iType = fInject(Request("iType"))  ' 글쓰기 1, 수정 2

	Name = fInject(Request.cookies("UserName"))
	iUserID = fInject(Request.cookies("UserID"))
	iLoginID = decode(iUserID,0)

	' 뷰 관련
	Dim LCnt, iAUSeq, AUSeq, InsDateCv, LoginIDYN
	LCnt = 0

	Dim sType 
	sType = iType

	' iType은 읽기와 쓰기를 같이 쓰게 됌으로 2로 고정
	If iType = "2" Then

		iAdminMemberIDX = fInject(Request("i1"))
		AdminMemberIDX = decode(iAdminMemberIDX,0)


		LSQL = "EXEC AdminMember_Read_S '" & iType & "','" & NowPage & "','" & AdminMemberIDX & "','" & iLoginID & "','','','','',''"
		'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
		'response.End

		Set LRs = DBCon5.Execute(LSQL)
		If Not (LRs.Eof Or LRs.Bof) Then
			Do Until LRs.Eof
				LCnt = LCnt + 1
				sUserID = LRs("UserID")
				AdminName = LRs("AdminName")
				UserPass = LRs("UserPass")
				Authority = LRs("Authority")
				AuthorityName = LRs("AuthorityName")
				UseYN = LRs("UseYN")
				UseYNName = LRs("UseYNName")
				WriteDateCv = LRs("WriteDateCv")
				LoginIDYN = LRs("LoginIDYN")
				ColumnApprovalYN = LRs("ColumnApprovalYN")

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


		LCnt1 = 0
		iiType = "4"

		LSQL = "EXEC AdminMember_Menu_S '" & iiType & "','','','" & sUserID & "','','','','',''"
		'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
		'response.End
		
		Set LRs = DBCon5.Execute(LSQL)
		If Not (LRs.Eof Or LRs.Bof) Then
			Do Until LRs.Eof
				LCnt1 = LCnt1 + 1
                                                                                   
				iRoleDetail1 = iRoleDetail1&"^"&LRs("RoleDetail")&""
                                                                                   
				LRs.MoveNext
			Loop
		End If
			LRs.close

    'Tennis_DBClose()
  
  	End If
  
%>
<script type="text/javascript">

  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

  function Del_Link(i1, i2) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
      post_to_url('./Admin_Delete_p.asp', { 'i1': i1, 'i2': i2 });
    }
    else {
    }
  }

  function CancelLink(i2) {
  	//post_to_url('./Admin_List.asp', { 'i2': i2 });
  	window.history.back();
  }

  function OK_Link() {

    // 스마트에디트 아닐때
    var theForm = document.form1;
    
    
    if (theForm.iAdminName.value == "") {
    	alert('<%=global_Name_Val %>');
    	return theForm.iAdminName.focus();
    }
    
    if (theForm.iUserID.value == "") {
    	alert('<%=global_ID_Val %>');
      return theForm.iUserID.focus();
    }

    if (theForm.iUserPass.value == "") {
    	alert('<%=global_Pass_Val %>');
    	return theForm.iUserPass.focus();
    }
    
    if (confirm("해당 사용자를 저장 하시겠습니까?") == true) {
      try {
    
        theForm.method = "post";
        theForm.target = "_self";
        theForm.action = "./Admin_Write_p.asp";
        theForm.submit();
    
      } catch (e) { }
    }
    else {
    
    }

  }

</script>
<section>
<div id="content"> 
  
  <!-- S : 내용 시작 -->
  <div class="contents"> 
    <!-- S: 네비게이션 -->
    <div	class="navigation_box"> 어드민 관리 > 어드민 관리 </div>
    <!-- E: 네비게이션 -->
    <form id="form1" name="form1" action="./Admin_Write_p.asp" method="post">
      <table cellspacing="0" cellpadding="0" class="Community_wtite_box">
        <tr>
          <th>성명</th>
          <td><span class="right_con">
            <input type="text" id="iAdminName" name="iAdminName" value="<%=AdminName %>" class="in_1"/>
            </span></td>
            
        </tr>
        <% If iType = "2" Then %>
        <tr>
          <th>등록일</th>
          <td><span class="right_con"> <span class="regist_date"><%=WriteDateCv %><br />
            </span> </span></td>
                
        </tr>
        <% End If %>
        <tr>
          <th>아이디</th>
          <td><span class="right_con">
            <input type="text" id="iUserID" name="iUserID" value="<%=sUserID %>" class="in_1"/>
            </span></td>
            
        </tr>
        <tr>
          <th>비밀번호</th>
          <td><span class="right_con">
            <input type="text" id="iUserPass" name="iUserPass" value="<%=UserPass %>" class="in_1"/>
            </span></td>
            
        </tr>
        <tr>
          <th>어드민 권한</th>
          <td><span class="right_con">
            <select id="selAuthority" name="selAuthority">
              <option value="A">어드민</option>
              <% if Authority = "F" then %>
              <option value="F" selected>슈퍼어드민</option>
              <% else %>
              <option value="F">슈퍼어드민</option>
              <% end if %>
            </select>
            </span></td>
                
        </tr>
        <tr>
          <th>칼럼승인 권한</th>
          <td><span class="right_con">
            <select id="selColumnApprovalYN" name="selColumnApprovalYN">
              <% if ColumnApprovalYN = "Y" then %>
              <option value="Y" selected>Y</option>
              <option value="N">N</option>
              <% else %>
              <option value="Y">Y</option>
              <option value="N" selected>N</option>
              <% end if %>
            </select>
            </span></td>
                
        </tr>
        <% if iType = 2 then %>
        <tr>
          <th>사용유무</th>
          <td><span class="right_con">
            <select id="selUseYN" name="selUseYN">
              <option value="Y">사용중</option>
              <% if UseYN = "N" then %>
              <option value="N" selected>미사용</option>
              <% else %>
              <option value="N">미사용</option>
              <% end if %>
            </select>
            </span></td>
                
        </tr>
        <% end if %>
        <%
		dim Old_Category				
		'iLoginID = Request.Cookies("UserID")
		'iLoginID = decode(iLoginID,0)
		iLoginID = ""

		LCnt2 = 0

		siType = "5"

		LSQL = "EXEC AdminMember_Menu_S '" & siType & "','','','" & iLoginID & "','','','','',''"
		'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
		'response.End

		Set LRs = DBCon5.Execute(LSQL)

		If Not (LRs.Eof Or LRs.Bof) Then
	%>
        <tr>
          <th>권한선택</th>
          <td><span class="right_con">
            <%
			Do Until LRs.Eof
				LCnt2 = LCnt2 + 1
               
                IF Old_Category <> LRs("RoleDetailGroup2") Then
			 	    CateCnt = CateCnt + 1
					response.write "<div style='background-color:#EEE; color:#888; padding: 5px;'>"&CateCnt&". "&LRs("RoleDetailGroup1Nm")&" ::: "&LRs("RoleDetailGroup2Nm")&"</div>"
				End IF
              
				iRoleDetail2 = LRs("RoleDetail")
				iRoleDetailNm2 = LRs("RoleDetailNm")
				%><span class="rights-list">
          <label>
            <input type="checkbox" name="chkiRoleDetail2" id="chkiRoleDetail2_<%=iRoleDetail2%>" value="<%=iRoleDetail2%>"><%=iRoleDetailNm2%>
              </label></span>
            <% 
                'IF LCnt2 mod 5 = 0 Then response.write "<br>"
                Old_Category = LRs("RoleDetailGroup2")   
				LRs.MoveNext
			Loop
			%>
            </span></td>
                 
        </tr>
        <%
			End If
				LRs.close

		Tennis_DBClose()
		%>
      </table>
      <div class="btn_list">
        <input type="button" id="btnOK" name="btnOK" class="btn_confirm" value="확인" onclick="javascript: OK_Link();" style="cursor:pointer" />
        <input type="button" id="btnCC" name="btnCC" class="btn_cancel" value="취소" onclick="javascript: CancelLink('<%=NowPage %>');" style="cursor:pointer" />
        <input type="hidden" id="iAdminMemberIDX" name="iAdminMemberIDX" value="<%=iAdminMemberIDX %>" />
        <input type="hidden" id="iType" name="iType" value="<%=iType %>" />
        <input type="hidden" id="iName" name="iName" value="<%=Name %>" />
        <input type="hidden" id="iID" name="iID" value="<%=iUserID %>" />
        <input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />
      </div>
    </form>
  </div>
  <!-- E : 내용 시작 --> 
</div>
<section>
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

<!--#include file="footer.asp"-->

</html>