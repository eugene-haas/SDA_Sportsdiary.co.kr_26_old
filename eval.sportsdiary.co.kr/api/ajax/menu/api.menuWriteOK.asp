<%
	depno = oJSONoutput.get("DEPNO")
	'@@@@@@@@@@@@@@@@@@@@@@@@
		dep1 = oJSONoutput.get("DEP1") '문자열이다...음 바꾸긴..
		dep2 = oJSONoutput.get("DEP2")
		dep3 = oJSONoutput.get("DEP3") 
		nmurl = oJSONoutput.get("NMURL")
		aclass = oJSONoutput.get("ACLASS")
		if aclass = "" then
			aclass = "D"
		end if

		'여러사이트 등록
		session_scode = session("scode")
		if session_scode <> "" then
			sitecode = session_scode
		end if
		'여러사이트 등록

	Set db = new clsDBHelper

	'#################################

		If (depno = "3" And (dep1 = "" Or dep2 = "") ) Then
				Call oJSONoutput.Set("result", "5" ) '상위메뉴먼저 선택해주시옷...
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.write "`##`"
				Response.End
		End if

		'중복값확인##
			' SQL = "Select AdminMenuListIDX  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"'  and RoleDetailNm = '" & dep3 & "' "
			' Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

			' If Not rs.eof then
			' 	Call oJSONoutput.Set("result", "111" ) '중복
			' 	Call oJSONoutput.Set("servermsg", "3단계 메뉴명이 중복되었습니다." ) '중복
			' 	strjson = JSON.stringify(oJSONoutput)
			' 	Response.Write strjson
			' 	Response.End
			'End if
		'중복값확인##


		'1,2 단계 코드
		SQL = "Select top 1 RoleDetailGroup1,RoleDetailGroup2,DisplayOrder1,DisplayOrder2 from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"' and RoleDepth = 2 "
		SQL = SQL & " and RoleDetailGroup1Nm = '"&dep1&"' and RoleDetailGroup2Nm = '"&dep2&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
		cd1 = rs(0)
		cd2 = rs(1)
		odr1 = rs(2)
		odr2 = rs(3)
		
		'3 생성될 3단계 코드 (3단계코드는 사이트그룹내에서 중복되지 않도록 생성)
		SQL = "Select top 1 RoleDetail,DisplayOrder3 from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"' and RoleDepth = 3 "
		SQL = SQL & " and RoleDetail <> '' order by RoleDetail desc "
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
		if rs.eof then
		cd3 = "Z1"
		odr3 = 1
		else
		cd3 = Cdbl(mid(rs(0),2)) + 1
		cd3 = "Z" & cd3
		odr3 = Cdbl(rs(1)) + 1
		end if


		insertfield = "RoleDepth,RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,RoleDetailGroup2Nm,RoleDetail,RoleDetailNm,WriteID,Link , SiteCode, Authority ,DisplayOrder1,DisplayOrder2,DisplayOrder3"
		insertvalue = " '3','"&cd1&"','"&dep1&"','"&cd2&"','"&dep2&"','"&cd3&"','"&dep3&"','"&Cookies_aID&"','"&nmurl&"','"&SiteCode&"','"&aclass&"',"&odr1&","&odr2&","&odr3&" "
		SQL = " insert into tbladminmenulist ("&insertfield&") values ("&insertvalue&")"
		Call db.execSQLRs(SQL , null, B_ConStr)




		'여러개 사이트인경우 등록되면 안된당. 그리고 사이트 코드도 넣어야구분된다. 작업하잣....
		if sitecode = "EVAL1" then
			'SQL = "insert Into tblAdminMenuRole (adminMemberIDX,RoleDetail,sitecode) values( '"&Cookies_aIDX&"','"&fldkey&"','"&sitecode&"')"
			SQL = "insert Into tblAdminMenuRole (adminMemberIDX,RoleDetail,sitecode) values( '"&Cookies_aIDX&"','"&cd3&"','"&sitecode&"')"
			Call db.execSQLRs(SQL , null, B_ConStr)
		end if
	


	'#################################
	'그룹1
	SQL = "Select RoleDetailGroup1,RoleDetailGroup1Nm,count(*)  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"' and RoleDepth in (1,3) group by  RoleDetailGroup1,RoleDetailGroup1Nm order by RoleDetailGroup1"
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

%>



<h4>생성</h4>

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
										%><option value="<%=grp1nm%>" <%If grp1nm = dep1 then%>selected<%End if%>><%=grp1nm%> [<%=grp1cnt%>]</option><%
									i = i + 1
									Next
								End if
								%>
						</select>

					</div>

					<div class="form-group">
						<label class=" control-label">중메뉴</label>
						<select  id="dep02"  class="form-control" onchange="mn.SelectDEP(2,'dep02','w_form',mn.CMD_INSERTDEP1)">
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

						<input type='text' id= "dep03"  class="form-control"
						<%If depno = "1" Or dep2 = "" then%>placeholder="중 메뉴 활성화 후 입력" disabled<%else%>placeholder="상세 메뉴 입력"  value="<%=dep3%>"	<%End if%>>
					</div>

					<div class="form-group">
						<label class="control-label">경로URL</label>
						<input type='text' class="form-control"  id="nm_url" value="<%=nmurl%>">
					</div>

					<div class="form-group">
						메뉴 <%=dep1%> > <%=dep2%> > <%=dep3%> 가 추가되었습니다. <br>[권한설정 후 메뉴에서 확인가능]
					</div>













