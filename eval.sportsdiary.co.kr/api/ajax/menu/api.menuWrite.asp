<%
	fno = oJSONoutput.get("FORMNO")

	'수정모드일때
	seq = oJSONoutput.get("SEQ")
	F1 = oJSONoutput.get("F1")
	F2 = oJSONoutput.get("F2")

	Set db = new clsDBHelper

	'##############################
	'여러개 사이트코드 사용시 
	'##############################
		'response.write fno & "--"
		if Cdbl(len(fno)) > 1 then
			sitecode_no = right(fno,1)
			fno = left(fno,1)
			select case Cstr(sitecode_no)
			case "1" 
				sitecode = "EVAL1"
				session("scode") = "EVAL1" 
			case "2" 
				sitecode = "EVAL2"
				session("scode") = "EVAL2"
			end select
			'response.write sitecode_no & " " & session("scode")
		end if

		'여러사이트 등록
		session_scode = session("scode")
		if session_scode <> "" then
			sitecode = session_scode
		end if
		'여러사이트 등록

	'##############################	

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
		title = "계정생성"
		Else
		title = "계정수정"

			SQL = "Select UserID,adminName,Authority,"&fldDec("adminbirth") &","&fldDec("adminphone")&",AssociationIDX,AssociationNM from tblAdminMember where delYN = 'N'  and AdminMemberIDX = " & seq
			SQL = QueryKeyOpenClose ( SQL )
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
			a_rid = rs(0)
			a_rname = rs(1)
			a_rcode = rs(2)
			a_birth = rs(3)
			a_phone = rs(4)
			a_acidx = isNulldefault(rs(5),"")

			'이것도 구분해서
			SQL = "Select RoleDetail from tblAdminMenuRole where delYN = 'N'  and sitecode = '"&sitecode&"' and  AdminMemberIDX = " & seq
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

			If Not rs.EOF Then
			arrChkRole = rs.GetRows()
			End If
		End If

		'권한등급
		SQL = "Select AdminRoleIDX,RoleName,RoleCode,RoleOrder  from tblAdminRole where delYN = 'N' order by RoleOrder asc"
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

		If Not rs.EOF Then
			arrRS = rs.GetRows()
		End If

		strFieldName = " RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,RoleDetailGroup2Nm,RoleDetail,RoleDetailNm " 'Cookies_AUTH
		SQL = "Select "&strFieldName&" from  tbladminmenulist where DelYN = 'N' and USEYN = 'Y' and RoleDepth = 3 and SiteCode = '"&sitecode&"' and Authority >= '"&Cookies_AUTH&"'  order by DisplayOrder1,DisplayOrder2,DisplayOrder3"
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

		If Not rs.EOF Then
			arrMn = rs.GetRows()
		End If

		'단체
		strFieldName = " AssociationIDX,AssociationNM "
		SQL = "Select "&strFieldName&" from  tblAssociation where delkey = 0 "
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

		If Not rs.EOF Then
			arrA = rs.GetRows()
		End If		

	End Select



	db.Dispose
	Set db = Nothing
%>
<div class="modal-dialog">
	<div class="modal-content">

		<div class='modal-header'>
			<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
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
							<%if sitecode = "EVAL1" then%>
							<a href="javascript:mn.writePop('modalS','<%=fno%>1')" class="btn btn-primary">관리자메뉴</a>
							<a href="javascript:mn.writePop('modalS','<%=fno%>2')" class="btn btn-default">평가결과메뉴</a>
							<%else%>
							<a href="javascript:mn.writePop('modalS','<%=fno%>1')" class="btn btn-default">관리자메뉴</a>
							<a href="javascript:mn.writePop('modalS','<%=fno%>2')" class="btn btn-primary">평가결과메뉴</a>							
							<%end if%>
					</div>

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
							<%if seq = "" then%>
								<%if sitecode = "EVAL1" then%>
								<a href="javascript:mn.writePop('modalS','<%=fno%>1')" class="btn btn-primary">관리자메뉴</a>
								<a href="javascript:mn.writePop('modalS','<%=fno%>2')" class="btn btn-default">평가결과메뉴</a>
								<%else%>
								<a href="javascript:mn.writePop('modalS','<%=fno%>1')" class="btn btn-default">관리자메뉴</a>
								<a href="javascript:mn.writePop('modalS','<%=fno%>2')" class="btn btn-primary">평가결과메뉴</a>							
								<%end if%>
							<%else%>
								<%if sitecode = "EVAL1" then%>
								<a href="javascript:mn.writePop('modalS','<%=fno%>1',<%=seq%>)" class="btn btn-primary">관리자메뉴</a>
								<a href="javascript:mn.writePop('modalS','<%=fno%>2',<%=seq%>)" class="btn btn-default">평가결과메뉴</a>
								<%else%>
								<a href="javascript:mn.writePop('modalS','<%=fno%>1',<%=seq%>)" class="btn btn-default">관리자메뉴</a>
								<a href="javascript:mn.writePop('modalS','<%=fno%>2',<%=seq%>)" class="btn btn-primary">평가결과메뉴</a>							
								<%end if%>
							<%end if%>
					</div>



					<div class="form-group">
						<label class="control-label">아이디/비번/이름</label>
						<input type='text' id="ad_id" placeholder="ID 입력" class="form-control" value="<%=a_rid%>">
						<input type='password' id="ad_pwd" class="form-control" style="ime-mode:inactive;"  placeholder="<%If seq = "" then%>패스워드<%else%>입력시 패스워드가 변경됩니다.<%end if%>"  value="" autocomplete="new-password"><!-- 한글사용불가 -->
						<input type='text' id="ad_name" class="form-control" placeholder="NAME 입력"  value="<%=a_rname%>">
						<input type='text' id="ad_birth" class="form-control" placeholder="생년월일"  value="<%=a_birth%>" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength=8>
						<input type='text' id="ad_phone" class="form-control" placeholder="전화번호"  value="<%=a_phone%>" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" maxlength=11>					
					</div>

					<div class="form-group">
						<label class="control-label">종목단체</label>

					<select class="form-control" id="ad_as">
							<%
							If IsArray(arrA) Then
								For ar = LBound(arrA, 2) To UBound(arrA, 2)
									r_acidx = isNulldefault(arrA(0, ar),"")
									r_acnm = arrA(1, ar)
									%><option value="<%=r_acidx%>" <%If CStr(r_acidx) = CStr(a_acidx) then%>selected<%End if%>><%=r_acnm%></option><%
								i = i + 1
								Next
							End if
							%>
					</select>


					<div class="form-group">
						<label class="control-label">어드민권한</label>

						<select class="form-control" id="ad_class"> <!-- onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)"> -->
							
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
