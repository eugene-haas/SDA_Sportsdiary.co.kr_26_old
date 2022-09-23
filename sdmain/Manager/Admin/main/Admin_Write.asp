<!--#include file="../dev/dist/config.asp"-->

<!-- S: head -->
<!-- #include file="../include/head.asp" -->
<!-- E: head -->

<% 
	RoleType = "AM"	
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
  
  	Name = fInject(Request.cookies("UserName"))
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
  
  		iAdminMemberIDX = fInject(Request("i1"))
  		'AdminMemberIDX = decode(iAdminMemberIDX,0)
      AdminMemberIDX = crypt.DecryptStringENC(iAdminMemberIDX)
  
  
  		LSQL = "EXEC AdminMember_Read_S '" & iType & "','" & NowPage & "','" & AdminMemberIDX & "','" & iLoginID & "','','','','',''"
  		'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  		'response.End
  
  		Set LRs = DBCon7.Execute(LSQL)
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
  				'ColumnApprovalYN = LRs("ColumnApprovalYN")
  
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
  		
  		Set LRs = DBCon7.Execute(LSQL)
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
      //else {
      //}
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
        //try {
      
          theForm.method = "post";
          theForm.target = "_self";
          theForm.action = "./Admin_Write_p.asp";
          theForm.submit();
      
        //} catch (e) { }
      }
      //else {
      //
      //}
  
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
      <span>어드민관리</span>
      <!--<i class="fas fa-chevron-right"></i>
      <span>등록</span>-->
    </div>
    <!-- E: navigation -->
    <!-- S: pd-15 -->
    <div class="pd-30">
      <!-- S: sub-content -->
      <div class="sub-content">
        
        <!-- S: Admin_List_write -->
        <div class="Admin_List_write">
          <!-- S: box-shadow -->
          <div class="box-shadow">
            <!-- S: table-box -->
            <div class="table-box basic-write">

              <form id="form1" name="form1" action="./Admin_Write_p.asp" method="post">
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
									<th>성명</th>
                  <td>
                      <input type="text" placeholder="성명을 입력하세요" id="iAdminName" name="iAdminName" value="<%=AdminName %>" class="in-style-1">
                  </td>
                </tr>
                <% End If %>
                <tr>
                  <th>아이디</th>
                  <td>
                      <input type="text" placeholder="아이디를 입력하세요" id="iUserID" name="iUserID" value="<%=sUserID %>" class="in-style-1">
                  </td>
                  <th>비밀번호</th>
                  <td>
                      <input type="text" placeholder="비밀번호를 입력하세요" id="iUserPass" name="iUserPass" value="<%=UserPass %>" class="in-style-1">
                  </td>
                </tr>

                <tr>
                  <th>어드민 권한</th>
                  <td>
                    <select id="selAuthority" name="selAuthority">
                      <%
                      
                        LSQL = "EXEC AdminRole_S '1','','" & iLoginID & "','','','','',''"
  		                  'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  		                  'response.End
  
  		                  Set LRs = DBCon7.Execute(LSQL)
  		                  If Not (LRs.Eof Or LRs.Bof) Then
  		                  	Do Until LRs.Eof
  		                  		LCnt = LCnt + 1
                        
                      %>
                      <option value="<%=LRs("RoleCode") %>" <% if Authority = LRs("RoleCode") then %>selected<% end if %>><%=LRs("RoleName") %></option>
                      <%
                      
                            LRs.MoveNext
		                    	Loop
		                    End If
		                    LRs.close

                      %>
                    </select>
                  </td>
									<% if iType = 2 then %>
                  <th>사용유무</th>
                  <td>
                    <select id="selUseYN" name="selUseYN">
                      <option value="Y">사용중</option>
                      <option value="N" <% if UseYN = "N" then %>selected<% end if %>>미사용</option>
                    </select>
                  </td>
									<% end if %>

									<%
										dim Old_Category				
                    dim CateCnt_Old
                     
										'iLoginID = Request.Cookies("UserID")
										'iLoginID = decode(iLoginID,0)
										iLoginID = ""
										
										LCnt2 = 0
										
										siType = "5"

										LSQL = "EXEC AdminMember_Menu_S '" & siType & "','','','" & iLoginID & "','','','','',''"
										'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
										'response.End
										
										Set LRs = DBCon7.Execute(LSQL)
										
										If Not (LRs.Eof Or LRs.Bof) Then
									%>
                </tr>
                
                
                <tr>
                  <th>권한선택</th>
                  <td colspan="3">
                    
                  <%
			              Do Until LRs.Eof
				              LCnt2 = LCnt2 + 1
               
                      IF Old_Category <> LRs("RoleDetailGroup2") Then
                        
                        LCnt2 = 1
			 	                CateCnt = CateCnt + 1
                        response.write "</div>"
					              response.write "<div class='admin-title'>"&CateCnt&". "&LRs("RoleDetailGroup1Nm")&" ::: "&LRs("RoleDetailGroup2Nm")&"</div>"
                        response.write "<div class='label-box'>"
                        
				              End IF
              
				              iRoleDetail2 = LRs("RoleDetail")
				              iRoleDetailNm2 = LRs("RoleDetailNm")
                    
                      
				          %>
									
										<label>
											<input type="checkbox" name="chkiRoleDetail2" id="chkiRoleDetail2_<%=iRoleDetail2%>" value="<%=iRoleDetail2%>"><span><%=iRoleDetailNm2%></span>
										</label>
									
                  <% 
'                      response.write "<br>LCnt2="&LCnt2
'                      response.write "<br>CateCnt="&CateCnt

   
                    
                    
                      'IF LCnt2 mod 5 = 0 Then response.write "<br>"                     
                     
                      Old_Category = LRs("RoleDetailGroup2")   
			              	
                      LRs.MoveNext
			              Loop
			            %>
                  </td>
                </tr>
                <%
			            End If
				          LRs.close
                %>
              </table>
              <input type="hidden" id="iAdminMemberIDX" name="iAdminMemberIDX" value="<%=iAdminMemberIDX %>" />
              <input type="hidden" id="iType" name="iType" value="<%=iType %>" />
              <input type="hidden" id="iName" name="iName" value="<%=Name %>" />
              <input type="hidden" id="iID" name="iID" value="<%=iUserID %>" />
              <input type="hidden" id="iNowPage" name="iNowPage" value="<%=NowPage %>" />

              </form>

            </div>
            <!-- E: table-box -->
          </div>
          <!-- E: box-shadow -->
          <!-- S: bt-btn-box -->
          <div class="bt-btn-box txt-right">
            <a href="javascript:;" id="btnCC" name="btnCC" onclick="javascript: CancelLink('<%=NowPage %>');" class="btn btn-default">취소</a>
            <a href="javascript:;" id="btnOK" name="btnOK" onclick="javascript: OK_Link();" class="btn btn-primary">등록</a>
          </div>
          <!-- E: bt-btn-box -->
        </div>
        <!-- E: Admin_List_write -->
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

<% ADADMIN_DBClose() %>