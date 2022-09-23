<!--#include file="../dev/dist/config.asp"-->
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

	' iType은 읽기와 쓰기를 같이 쓰게 됌으로 2로 고정
  If iType = "3" Then

    iAdminMemberIDX = fInject(Request("i1"))
    AdminMemberIDX = decode(iAdminMemberIDX,0)

		Dim sType 
		sType = "2"


    LSQL = "EXEC AdminMember_Read_S '" & sType & "','" & NowPage & "','" & AdminMemberIDX & "','" & iLoginID & "','','','','',''"
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

    'Tennis_DBClose()
  
  End If
  
%>


<script type="text/javascript">

  var iType = Number("<%=iType%>");
  var iMSeq = Number("<%=iMSeq%>");

  function Del_Link(i1, i2) {
    if (confirm("해당 글을 삭제 하시겠습니까?") == true) {
    	post_to_url('./Admin_Column_Approval_Delete_p.asp', { 'i1': i1, 'i2': i2 });
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
    
    if (confirm("칼럼승인권한을 저장 하시겠습니까?") == true) {
      try {
    
        theForm.method = "post";
        theForm.target = "_self";
        theForm.action = "./Admin_Column_Approval_Write_p.asp";
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
			<div	class="navigation_box">
				어드민관리 > 권한관리 > 칼럼승인권한
			</div>
			<!-- E: 네비게이션 -->
      <form id="form1" name="form1" action="./Admin_Column_Approval_Write_p.asp" method="post">
				<table cellspacing="0" cellpadding="0" class="Community_wtite_box">			

					<tr>
						<th>칼럼승인 권한</th>
						<td colspan="2">
							<span class="right_con">
								<select id="selColumnApprovalYN" name="selColumnApprovalYN">
									<% if ColumnApprovalYN = "Y" then %>
									<option value="Y" selected>Y</option>
									<option value="N">N</option>
									<% else %>
									<option value="Y">Y</option>
									<option value="N" selected>N</option>
									<% end if %>
								</select>
							</span>
						</td>
					</tr>

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

<!--#include file="footer.asp"-->

</html>