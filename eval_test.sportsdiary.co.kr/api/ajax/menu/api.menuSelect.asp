<%
	depno = oJSONoutput.get("DEPNO")
	depnm = oJSONoutput.get("DEPNM")
	cmdtype = oJSONoutput.get("DPTYPE") 'insert
	if cmdtype = "" then
		cmdtype	 = "select"
	End If

	'@@@@@@@@@@@@@@@@@@@@@@@@

	dep1 = oJSONoutput.get("DEP1")
	dep2 = oJSONoutput.get("DEP2")
	dep3 = oJSONoutput.get("DEP3")
	nmurl = oJSONoutput.get("NMURL")
	aclass = oJSONoutput.get("ACLASS")

	
	'여러사이트 등록
	session_scode = session("scode")
	if session_scode <> "" then
		sitecode = session_scode
	end if
	'여러사이트 등록


	Set db = new clsDBHelper
	'#################################

		If (depno = "2" And  dep1 = "") Or (depno = "3" And (dep1 = "" Or dep2 = "") ) Then
				Call oJSONoutput.Set("result", "5" ) '상위메뉴먼저 선택해주시옷...
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.write "`##`"
				Response.End
		End if

		Select Case depno
			Case "1"
			fld = "RoleDetailGroup1"
			fldname = "RoleDetailGroup1Nm"
			dep1 = depnm
			Case "2"
			fld = "RoleDetailGroup2"
			fldname = "RoleDetailGroup2Nm"
			dep2 = depnm
			Case "3"
			fld = "RoleDetail"
			fldname = "RoleDetailNm"
			dep3 = depnm
		End Select


		'중복값확인
		If cmdtype = "insert" then

			' SQL = "Select AdminMenuListIDX  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"' and " &  fldname & " = '" & DEPNM & "' "
			' Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
			' If Not rs.eof then
			' 	Call oJSONoutput.Set("result", "2" ) '중복
			' 	strjson = JSON.stringify(oJSONoutput)
			' 	Response.Write strjson
			' 	Response.write "`##`"
			' 	Response.End
			' End if

			'선택된 필드
			'SQL = "Select "&fld&"  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"'  and " &  fld & " like 'Z%'  order by " & fld & " desc"
			SQL = "Select cast(substring("&fld&",2,100) as int)  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"'  and " &  fld & " like 'Z%'  order by 1 desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
			If rs.eof Then
				fldkey = "Z1"
			Else
				fldlastkey = rs(0) 'Mid(rs(0),2)
				fldkey = "Z" & CDbl(fldlastkey) + 1
			End if

			'생성 분류별 메뉴생성
			Select Case depno
			Case "1" :	SQL = " insert into tbladminmenulist (RoleDepth,"&fld&","&fldname&",WriteID,SiteCode,DisplayOrder1) values ('"&depno&"','"&fldkey&"','"&depnm&"','"&Cookies_aID&"','"&sitecode&"',"& mid(fldkey,2) &")"
			Case "2"
			SQL = "select top 1 RoleDetailGroup1 from tbladminmenulist where RoleDetailGroup1Nm = '" & dep1 & "' and SiteCode = '"&sitecode&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)


			SQL = " insert into tbladminmenulist (RoleDepth,RoleDetailGroup1,RoleDetailGroup1Nm,"&fld&","&fldname&",WriteID,sitecode,DisplayOrder1,DisplayOrder2)"
			SQL = SQL & " values ('"&depno&"','"&rs(0)&"','"&dep1&"', '"&fldkey&"','"&depnm&"','"&Cookies_aID&"','"&sitecode&"',"& mid(rs(0),2) &", "
			SQL = SQL & "(select isNull(max(DisplayOrder2),0)+1 from tbladminmenulist where RoleDetailGroup1Nm = '" & dep1 & "' and SiteCode = '"&sitecode&"') )"
			end Select
			Call db.execSQLRs(SQL , null, B_ConStr)
		End if
	'#################################

	'그룹1
	SQL = "Select RoleDetailGroup1,RoleDetailGroup1Nm,count(*)  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"'  and  RoleDepth in (1,3) group by  RoleDetailGroup1,RoleDetailGroup1Nm order by RoleDetailGroup1"
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End If


	'그룹2
	SQL = "Select RoleDetailGroup2,RoleDetailGroup2Nm,count(*)  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"' and  RoleDetailGroup1Nm = '"&dep1&"' and  RoleDepth in (2,3)  group by  RoleDetailGroup2,RoleDetailGroup2Nm order by RoleDetailGroup2"
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

	If Not rs.EOF Then
		arrRSM = rs.GetRows()
	End If


	'권한등급
	SQL = "Select AdminRoleIDX,RoleName,RoleCode,RoleOrder  from tblAdminRole where delYN = 'N' order by RoleOrder asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

	If Not rs.EOF Then
		arrC = rs.GetRows()
	End If



	db.Dispose
	Set db = Nothing

%>

<h4>메뉴관리</h4>

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
			<%
			If IsArray(arrRS) Then
				For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
					grp1 = arrRS(0, ar)
					grp1nm = arrRS(1, ar)
					grp1cnt =  arrRS(2, ar)
					%><option value="<%=grp1nm%>" <%If grp1nm = dep1 then%>selected<%End if%>><%=grp1nm%> [<%=grp1cnt%>]</option><%
				i = i + 1
				Next
			End if
			%>
			<option value="insert">[추가생성]</option>
	</select>
</div>
<div class="form-group">
	<label class="control-label">중메뉴</label>
	<select  id="dep02" class="form-control" onchange="mn.SelectDEP(2,'dep02','w_form',mn.CMD_INSERTDEP1)">
		<option value="">=중메뉴=</option>
			<%
			If IsArray(arrRSM) Then
				For ar = LBound(arrRSM, 2) To UBound(arrRSM, 2)
					grp2 = arrRSM(0, ar)
					grp2nm = arrRSM(1, ar)
					grp2cnt =  arrRSM(2, ar)
					%><option value="<%=grp2nm%>" <%If grp2nm = dep2 then%>selected<%End if%>><%=grp2nm%> [<%=grp2cnt%>]</option><%
				i = i + 1
				Next
			End if
			%>
			<option value="insert">[추가생성]</option>
	</select>
</div>
<div class="form-group">
	<label class="control-label">상세메뉴</label>
	<input type='text' id= "dep03" class="form-control"
	<%If depno = "1" Or dep2 = "" then%>placeholder="중 메뉴 활성화 후 입력" disabled
	<%else%>placeholder="상세 메뉴 입력"  value="<%=dep3%>"
	<%End if%>
	>
</div>
<div class="form-group">
	<label class="control-label">경로URL</label>
	<input type='text' id="nm_url" class="form-control" value="<%=nmurl%>">
</div>
<div class="form-group">
	<label class="control-label">어드민권한</label>
	<select  id="ad_class" class="form-control" > <!-- onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)"> -->
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
