<%
	If hasown(oJSONoutput, "DEPNO") = "ok" then
		depno = oJSONoutput.DEPNO
	End If

	'@@@@@@@@@@@@@@@@@@@@@@@@

	If hasown(oJSONoutput, "DEP1") = "ok" then
		dep1 = oJSONoutput.DEP1
	End If
	If hasown(oJSONoutput, "DEP2") = "ok" then
		dep2 = oJSONoutput.DEP2
	End If
	If hasown(oJSONoutput, "DEP3") = "ok" then
		dep3 = oJSONoutput.DEP3
	End If
	
	If hasown(oJSONoutput, "NMURL") = "ok" then
		nmurl = oJSONoutput.NMURL
	End if

	If hasown(oJSONoutput, "ACLASS") = "ok" then
		aclass = oJSONoutput.ACLASS
	End if


	Set db = new clsDBHelper

	'#################################

		If (depno = "3" And (dep1 = "" Or dep2 = "") ) Then
				Call oJSONoutput.Set("result", "5" ) '상위메뉴먼저 선택해주시옷...
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.write "`##`"
				Response.End
		End if


		'중복값확인
		SQL = "Select AdminMenuListIDX  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"'  and RoleDetailNm = '" & dep3 & "' "
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)


		If Not rs.eof then
			Call oJSONoutput.Set("result", "2" ) '중복
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Response.End
		End if

		'선택된 필드
		'SQL = "Select top 1 RoleDetail  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"'  and RoleDetail like 'Z%'  order by RoleDetail desc"
		SQL = "Select top 1 RoleDetail,cast(substring(RoleDetail,2,100) as int) as s  from tbladminmenulist where delYN = 'N' and SiteCode = '"&sitecode&"'  and RoleDetail like 'Z%'  order by s desc"
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
		If rs.eof Then
			fldkey = "Z1"
		Else
			fldlastkey = Mid(rs(0),2)
			fldkey = "Z" & CDbl(fldlastkey) + 1
		End if

		'생성 분류별 메뉴생성	
		SQL = "select top 1 RoleDetailGroup1,RoleDetailGroup2 from tbladminmenulist where RoleDetailGroup2Nm = '" & dep2 & "' and SiteCode = '"&sitecode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

		insertfield = "RoleDepth,RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,RoleDetailGroup2Nm,RoleDetail,RoleDetailNm,WriteID,Link , SiteCode, Authority "
		insertvalue = " '"&depno&"','"&rs(0)&"','"&dep1&"','"&rs(1)&"','"&dep2&"', '"&fldkey&"','"&dep3&"','"&Cookies_aID&"' , '"&nmurl&"' , '"&SiteCode&"' , '"&aclass&"' "
		SQL = " insert into tbladminmenulist ("&insertfield&") values ("&insertvalue&")"
		Call db.execSQLRs(SQL , null, B_ConStr)
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

%>
	<table cellspacing="0" cellpadding="0">
		 <tr>
			<th style="width:100%;" colspan="2">메뉴관리</th>
		</tr> 
		<tr>
				<td style="width:50%;background:gray;color:white">대메뉴</td>
				<td style="width:50%;word-break:break-all;">
					<select  id="dep01"  class="sl_search" style="width:98%;" onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)">
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
				</td>
		</tr>

		<tr>
				<td style="width:30%;background:gray;color:white">중메뉴</td>
				<td style="width:70%;word-break:break-all;">

					<select  id="dep02"  class="sl_search" style="width:98%;" onchange="mn.SelectDEP(2,'dep02','w_form',mn.CMD_INSERTDEP1)">
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

				</td>
		</tr>
		<tr>
				<td style="width:30%;background:gray;color:white">상세메뉴</td>
				<td style="width:70%;word-break:break-all;"><input type='text' id= "dep03" style="width:100%;"
				<%If depno = "1" Or dep2 = "" then%>placeholder="중 메뉴 활성화 후 입력" disabled
				<%else%>placeholder="상세 메뉴 입력"  value="<%=dep3%>"
				<%End if%>
				></td>
		</tr>
		<tr>
				<td style="width:30%;background:gray;color:white">경로URL</td>
				<td style="width:70%;word-break:break-all;"><input type='text' id="nm_url" value="<%=nmurl%>"  style="width:100%;"></td>
		</tr>
	</table>
	<div style="background:#143145;widht:100%;height:30px;text-align:center;padding-top:10px;padding-bottom:10px;color:white;">
	메뉴 <%=dep1%> > <%=dep2%> > <%=dep3%> 가 추가되었습니다. [권한설정 후 메뉴에서 확인가능]</div>


