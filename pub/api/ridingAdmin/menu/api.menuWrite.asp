<%
	If hasown(oJSONoutput, "FORMNO") = "ok" then
		fno = oJSONoutput.FORMNO
	End If

	'수정모드일때
	If hasown(oJSONoutput, "SEQ") = "ok" then
		seq = oJSONoutput.SEQ
	End If

	If hasown(oJSONoutput, "F1") = "ok" then
		F1 = oJSONoutput.F1
	End If
	If hasown(oJSONoutput, "F2") = "ok" then
		F2 = oJSONoutput.F2
	End If



	Set db = new clsDBHelper

	Select Case CDbl(fno)
	Case 1
		title = "메뉴생성"
		'그룹/종목
		SQL = "Select RoleDetailGroup1,RoleDetailGroup1Nm,count(*)  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"'  and RoleDepth in (1,3) group by  RoleDetailGroup1,RoleDetailGroup1Nm order by RoleDetailGroup1"
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

		If Not rs.EOF Then
			arrRS = rs.GetRows()
		End If

		'권한등급
		SQL = "Select AdminRoleIDX,RoleName,RoleCode,RoleOrder  from tblAdminRole where delYN = 'N' order by RoleOrder asc"
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

		If Not rs.EOF Then
			arrC = rs.GetRows()
		End If


	Case 2
		If seq = "" then
		title = "어드민계정생성"
		Else
		title = "어드민계정수정"
			SQL = "Select UserID,UserPass,adminName,Authority from tblAdminMember where delYN = 'N'  and AdminMemberIDX = " & seq
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
			a_rid = rs(0)
			a_rpwd = rs(1)
			a_rname = rs(2)
			a_rcode = rs(3)

			SQL = "Select RoleDetail from tblAdminMenuRole where delYN = 'N'  and AdminMemberIDX = " & seq
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

			If Not rs.EOF Then
			arrChkRole = rs.GetRows()
			End If
		End If



		'업체코드
		strfield = " A.UNI_GRP_CD , itemcenter.dbo.IC_FN_RETAIL_NM(A.UNI_GRP_CD) AS UNI_GRP_NM "
		SQL  = "SELECT   " & strfield & " FROM itemcenter.dbo.IC_T_AGENT A LEFT OUTER JOIN "
		SQL = SQL & " (SELECT UNI_GRP_CD, RTL_COM_NUM  FROM itemcenter.dbo.IC_T_RETAIL  WHERE DEL_YN = 'N') B ON A.UNI_GRP_CD = B.UNI_GRP_CD "
		SQL = SQL & " WHERE A.DEL_YN = 'N' AND A.END_TP = 'N' AND agt_rank  <> '06'  group by A.UNI_GRP_CD"
		Set rs = db.ExecSQLReturnRS(SQL , null, I_ConStr)

		If Not rs.EOF Then
		arrComCode = rs.GetRows()
		End If


		'아이디 검색
		If F2 <> "" then
			strfield = " A.AGT_ID,A.AGT_NM ,A.AGT_PWD ,A.UNI_GRP_CD "
			SQL  = "SELECT   " & strfield & " FROM itemcenter.dbo.IC_T_AGENT A LEFT OUTER JOIN "
			SQL = SQL & " (SELECT UNI_GRP_CD, RTL_COM_NUM  FROM itemcenter.dbo.IC_T_RETAIL  WHERE DEL_YN = 'N') B ON A.UNI_GRP_CD = B.UNI_GRP_CD "
			SQL = SQL & " WHERE A.DEL_YN = 'N' AND A.END_TP = 'N' AND agt_rank  <> '06' AND A.AGT_ID = '" & F2 & "' "
			Set rs = db.ExecSQLReturnRS(SQL , null, I_ConStr)

			If Not rs.EOF Then
				findid = rs(0)
				findname = rs(1)
				findpwd = rs(2)
				findcomcode = rs(3)
			End If
		Else
				findid = ""
				findname = ""
				findpwd = ""
				findcomcode = ""
		End if


		'권한등급
		SQL = "Select AdminRoleIDX,RoleName,RoleCode,RoleOrder  from tblAdminRole where delYN = 'N' order by RoleOrder asc"
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

		If Not rs.EOF Then
			arrRS = rs.GetRows()
		End If

		strFieldName = " RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,RoleDetailGroup2Nm,RoleDetail,RoleDetailNm " 'Cookies_AUTH
		SQL = "Select "&strFieldName&" from  tbladminmenulist where DelYN = 'N' and USEYN = 'Y' and RoleDepth = 3 and SiteCode = '"&sitecode&"' and Authority >= '"&Cookies_AUTH&"'  order by RoleDetailGroup1,RoleDetailGroup2,RoleDetail"
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)


		If Not rs.EOF Then
			arrMn = rs.GetRows()
		End If

	End Select



	db.Dispose
	Set db = Nothing
%>
<div class="modal-dialog">
	<div class="modal-content">

		<div class='modal-header'>
			<button type='button' class='close' onclick="location.reload()">×</button>
			<h4 id='myModalLabel'><%=title%><!-- &nbsp;&nbsp;<a href="javascript:mn.writePop('myModal',<%=fno%><%If seq<> "" then%>,<%=seq%><%End if%>)" class="white-btn">&nbsp;새로고침&nbsp;</a> --></h4>
		</div>

		<div class="modal-body " id="Modaltestbody">
			<div id="w_form" class="container-fluid">

					<h4>생성</h4>

					<%
						Select Case CDbl(fno)
						Case 1
					%>

					<div class="form-group">
						<label class="control-label">대메뉴</label>
						<select id="dep01" class="form-control" onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)">
						  <option value="">=대분류=</option>
							  <%
							  If IsArray(arrRS) Then
								  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
									  grp1 = arrRS(0, ar)
									  grp1nm = arrRS(1, ar)
									  grp1cnt =  arrRS(2, ar)
									  %><option value="<%=grp1nm%>" <%If grp1nm = fldname then%>selected<%End if%>><%=grp1nm%> [<%=grp1cnt%>]</option><%
								  i = i + 1
								  Next
							  End if
							  %>
							  <option value="insert">[추가생성]</option>
						</select>

					</div>

					<div class="form-group">
						<label class=" control-label">중메뉴</label>
						<select id= "dep02" class="form-control" disabled>
						  <option value="">=중메뉴 (대분류선택 후 활성화)=</option>
						</select>
					</div>

					<div class="form-group">
						<label class="control-label">상세메뉴</label>
						<input type='text' id= "dep03" class="form-control" placeholder="중 메뉴 활성화 후 입력" disabled>
					</div>

					<div class="form-group">
						<label class="control-label">경로URL</label>
						<input type='text' class="form-control" id="mn_url">
					</div>

					<div class="form-group">
						<label class="control-label">어드민권한</label>
						<select id="ad_class" class="form-control"> <!-- onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)"> -->
						  <option value="">=권한등급=</option>
							  <%
							  If IsArray(arrC) Then
								  For ar = LBound(arrC, 2) To UBound(arrC, 2)
									  r_idx = arrC(0, ar)
									  r_nm = arrC(1, ar)
									  r_code =  arrC(2, ar)
									  %><option value="<%=r_code%>" <%If CStr(r_code) = CStr(aclass) then%>selected<%End if%>><%=r_nm%> [<%=r_code%>]</option><%
								  i = i + 1
								  Next
							  End if
							  %>
							  <!-- <option value="insert">[추가생성]</option> -->
						</select>

					</div>

					<%Case 2'######################################################################################################################%>
					<%jsonstr = JSON.stringify(oJSONoutput)%>

					<div class="form-group">
						<label class="control-label">ERP 아이디검색</label>
						<div class="input-group">
							<input type="text" maxlength="20" id="PF2" class="form-control" onkeydown='if(event.keyCode == 13){mn.Search(<%=jsonstr%>,$("#PF1").val(), $("#PF2").val())}' placeholder="ERPID 입력" value="<%=F2%>" autocomplete="nope">
							<input type="hidden" id="PF1" value="erpid">
							<a href='javascript:mn.Search(<%=jsonstr%>,$("#PF1").val(), $("#PF2").val())' class="input-group-addon">검색</a>
						</div>
					</div>


					<div class="form-group">
						<label class="control-label">아이디/비번/이름</label>
						<input type='text' id="ad_id" placeholder="ID 입력" class="form-control" value="<%If findid <> "" then%><%=findid%><%else%><%=a_rid%><%End if%>">
						<input type='password' id="ad_pwd" class="form-control" style="ime-mode:inactive;"  placeholder="PWD 입력"  value="<%If findpwd <> "" then%><%=findpwd%><%else%><%=a_rpwd%><%End if%>" autocomplete="new-password"><!-- 한글사용불가 -->
						<input type='text' id="ad_name" class="form-control" placeholder="NAME 입력"  value="<%If findname <> "" then%><%=findname%><%else%><%=a_rname%><%End if%>">
					</div>


					<div class="form-group">
						<label class="control-label">어드민권한/업체코드</label>

						<select class="form-control" id="ad_class"> <!-- onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)"> -->
						  <option value="">=권한등급=</option>
							  <%
							  If IsArray(arrRS) Then
								  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
									  r_idx = arrRS(0, ar)
									  r_nm = arrRS(1, ar)
									  r_code =  arrRS(2, ar)
									  %><option value="<%=r_code%>" <%If CStr(r_code) = CStr(a_rcode) then%>selected<%End if%>><%=r_nm%> [<%=r_code%>]</option><%
								  i = i + 1
								  Next
							  End if
							  %>
							  <!-- <option value="insert">[추가생성]</option> -->
						</select>

						<select class="form-control" id="com_code"> <!-- onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)"> -->
						  <option value="">=업체코드=</option>
							  <%
							  If IsArray(arrComCode) Then
								  For ar = LBound(arrComCode, 2) To UBound(arrComCode, 2)
									  c_code = arrComCode(0, ar)
									  c_nm = arrComCode(1, ar)
									  If c_nm = "" Or isnull(c_nm) = true Then
										c_nm = c_code
									  End if
									  %><option value="<%=c_code%>" <%If CStr(c_code) = CStr(findcomcode) then%>selected<%End if%>><%=c_nm%></option><%
								  i = i + 1
								  Next
							  End if
							  %>
							  <!-- <option value="insert">[추가생성]</option> -->
						</select>
					</div>

					<div class="">
						<label class="control-label">권한선택</label>
							<%
						  If IsArray(arrMn) Then

							  For ar = LBound(arrMn, 2) To UBound(arrMn, 2)
								  m_d1 = arrMn(0, ar)
								  m_d1nm = arrMn(1, ar)
								  m_d2 = arrMn(2, ar)
								  m_d2nm = arrMn(3, ar)
								  m_d3 = arrMn(4, ar)
								  m_d3nm = arrMn(5, ar)
								  chk_str = m_d1nm & m_d2nm


								  If (prechkstr <> "" And chk_str <> prechkstr) Or prechkstr = "" Then
									If (prechkstr <> "" And chk_str <> prechkstr) Then
									Response.write "</div>"
									End if
									%>
									<div class="form-group">
										<p class="mgb1"><%=m_d1nm%> _ <%=m_d2nm%></p>
									<%
								  End If
								  %>

										<label class="control-label">
										<input type='checkbox' id="ad_name" name="ad_name" value="<%=m_d3%>"
										<%
										If IsArray(arrChkRole) Then
										  For a = LBound(arrChkRole, 2) To UBound(arrChkRole, 2)
												  chkrole = arrChkRole(0, a)
											  If m_d3 = chkrole Then
												%>checked<%
											  End if
										  Next
										End If
										%>
										> <%=m_d3nm%></label>

								  <%
								  prechkstr = m_d1nm & m_d2nm

							  Next
						  End if
						  %>
					</div>
					<%End select%>

			</div>
		</div>

		<div class="modal-footer">
			<button class="btn btn-default" data-dismiss="modal" aria-hidden="true" onclick="location.reload()">닫기</button>
			<%
				Select Case CDbl(fno)
				Case 1
			%>
		  <button class="btn btn-primary" onclick="mn.writeOK(3,'dep03','w_form',mn.CMD_MENU_WOK)">저장</button>

			<%Case 2 '어드민 화면%>
				<%If seq = "" then%>
				<button class="btn btn-primary" onclick="mn.adminWriteOK(mn.CMD_ADMIN_WOK)">저장</button>
				<%else%>
				<button class="btn btn-primary" onclick="mn.adminEditOK(mn.CMD_ADMIN_EOK,<%=seq%>)">수정</button>
				<%End if%>
			<%End Select %>
		</div>

	</div>
</div>
