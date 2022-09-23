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
'		strfield = " A.UNI_GRP_CD , itemcenter.dbo.IC_FN_RETAIL_NM(A.UNI_GRP_CD) AS UNI_GRP_NM "
'		SQL  = "SELECT   " & strfield & " FROM itemcenter.dbo.IC_T_AGENT A LEFT OUTER JOIN "
'		SQL = SQL & " (SELECT UNI_GRP_CD, RTL_COM_NUM  FROM itemcenter.dbo.IC_T_RETAIL  WHERE DEL_YN = 'N') B ON A.UNI_GRP_CD = B.UNI_GRP_CD "
'		SQL = SQL & " WHERE A.DEL_YN = 'N' AND A.END_TP = 'N' AND agt_rank  <> '06'  group by A.UNI_GRP_CD"
'		Set rs = db.ExecSQLReturnRS(SQL , null, I_ConStr)
'
'		If Not rs.EOF Then
'		arrComCode = rs.GetRows()
'		End If
'
'
'		'아이디 검색
'		If F2 <> "" then
'			strfield = " A.AGT_ID,A.AGT_NM ,A.AGT_PWD ,A.UNI_GRP_CD "
'			SQL  = "SELECT   " & strfield & " FROM itemcenter.dbo.IC_T_AGENT A LEFT OUTER JOIN "
'			SQL = SQL & " (SELECT UNI_GRP_CD, RTL_COM_NUM  FROM itemcenter.dbo.IC_T_RETAIL  WHERE DEL_YN = 'N') B ON A.UNI_GRP_CD = B.UNI_GRP_CD "
'			SQL = SQL & " WHERE A.DEL_YN = 'N' AND A.END_TP = 'N' AND agt_rank  <> '06' AND A.AGT_ID = '" & F2 & "' "
'			Set rs = db.ExecSQLReturnRS(SQL , null, I_ConStr)
'
'			If Not rs.EOF Then
'				findid = rs(0)
'				findname = rs(1)
'				findpwd = rs(2)
'				findcomcode = rs(3)
'			End If
'		Else
'				findid = ""
'				findname = ""
'				findpwd = ""
'				findcomcode = ""
'		End if


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
			<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
			<h4 id='myModalLabel'>심판 계정</h4>
		</div>

		<div class="modal-body " id="Modaltestbody">
			<div id="w_form" class="container-fluid">

					<h4>생성</h4>

					<%'################
						Select Case CDbl(fno)
						Case 1
						'################
					%>

					<%
						'################
						Case 2
						'################
						%>
					<%jsonstr = JSON.stringify(oJSONoutput)%>

					<div class="form-group">
						<label class="control-label">아이디/비번/이름</label>
						<input type='text' id="ad_id" placeholder="아이디" class="form-control" value="<%If findid <> "" then%><%=findid%><%else%><%=a_rid%><%End if%>">
						<input type='password' id="ad_pwd" class="form-control" style="ime-mode:inactive;"  placeholder="패스워드"  value="<%If findpwd <> "" then%><%=findpwd%><%else%><%=a_rpwd%><%End if%>" autocomplete="new-password"><!-- 한글사용불가 -->
						<input type='text' id="ad_name" class="form-control" placeholder="이름"  value="<%If findname <> "" then%><%=findname%><%else%><%=a_rname%><%End if%>">
					</div>


					<div class="form-group">
						<label class="control-label">어드민권한/업체코드</label>

						<select class="form-control" id="ad_class">
						  <option value="F">=권한등급(기본)</option>
						  <option value="F" <%If CStr(a_rcode) = "F" then%>selected<%End if%>>기록원 심판 [F]</option>
						</select>


					</div>


					<%
					'################
					End Select
					'################
					%>

			</div>
		</div>

		<div class="modal-footer">
			<button class="btn btn-default" data-dismiss="modal" aria-hidden="true" onclick="location.reload()">닫기</button>
			<%
				Select Case CDbl(fno)
				Case 1
			%>

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
