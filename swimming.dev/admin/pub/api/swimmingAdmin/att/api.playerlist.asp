<%
'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.tidx
	End if
	If hasown(oJSONoutput, "TEAM") = "ok" then
		team = oJSONoutput.TEAM
	End If
	leaderidx = oJSONoutput.Get("LEADERIDX") '리더인덱스
'request


	Set db = new clsDBHelper

	'사용한 선수 찾기
	fld = "a.username,a.birthday,a.sex,a.CDB,a.CDBNM,a.userclass,a.playeridx,b.playeridx "
	SQL = "Select "&fld&" from tblPlayer as a inner join (select playeridx from tblGameRequest_imsi where team = '"&team&"' and tidx = '"&tidx&"'  and leaderidx <> '"&leaderidx&"' and leaderidx <> '' group by tidx,playeridx) as b "
	'SQL = SQL & " on a.PlayerIDX = b.playeridx where a.Team = '"&team&"' and a.delyn = 'N' "
	SQL = SQL & " on a.PlayerIDX = b.playeridx where a.Team = '"&team&"' and a.delyn = 'N'  and a.nowyear = '"&year(now)&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		arrP = rs.GetRows()
	End if


	fld = "a.username,a.birthday,a.sex,a.CDB,a.CDBNM,a.userclass,a.playeridx,b.playeridx "
	SQL = "Select "&fld&" from tblPlayer as a left join (select playeridx from tblGameRequest_imsi where team = '"&team&"' and tidx = '"&tidx&"'  and leaderidx = '"&leaderidx&"' group by tidx,playeridx) as b "
	'SQL = SQL & " on a.PlayerIDX = b.playeridx where a.Team = '"&team&"' and a.delyn = 'N' "
	SQL = SQL & " on a.PlayerIDX = b.playeridx where a.Team = '"&team&"' and a.delyn = 'N'  and a.nowyear = '"&year(now)&"' "

'	fld = "a.username,a.birthday,a.sex,a.CDB,a.CDBNM,a.userclass,a.playeridx,b.playeridx "
'	SQL = "Select "&fld&" from tblPlayer as a left join tblGameRequest_imsi as b on a.team= '"&team&"'  where b.team = '"&team&"' and b.tidx = '"&tidx&"' and a.delyn = 'N' "
'	' and a.nowyear = '"&year(now)&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		arrR = rs.GetRows()
	End if

	db.Dispose
	Set db = Nothing
%>


			  <table class="m_modal-player-list__con__tbl">
                <caption>참가 선수 추가/삭제 표</caption>   
                <thead class="m_modal-player-list__con__tbl__thead">
                  <tr>
                    <th scope="col">
                      <input class="m_modal__chek" id="chekBoxModalPlayer00" type="checkbox" id="checkAll"  onclick="px.checkAll($(this))">
                      <label for="chekBoxModalPlayer00"></label>
                    </th>
                    <th scope="col">번호</th>
					<th scope="col">이름</th>
                    <th scope="col">생년월일</th>
                    <th scope="col">성별</th>
                    <th scope="col">종별</th>
                    <th scope="col">학년</th>
                  </tr>
                </thead>
                <tbody class="m_modal-player-list__con__tbl__tbody">
                  <tr>
                    <td></td>
                  </tr>

					<%
						If IsArray(arrR) Then
							For ari = LBound(arrR, 2) To UBound(arrR, 2)
							setplayer = False
							
							p_username = arrR(0, ari)
							p_birthday = arrR(1, ari)
							p_sex = arrR(2, ari)
							If p_sex = "1" Then
								p_sexstr = "남"
							Else
								p_sexstr = "여"
							End if
							p_CDB = arrR(3, ari)
							p_CDBNM = arrR(4, ari)
							p_userclass = isNulldefault(arrR(5, ari),"")
							p_pidx = arrR(6, ari)
							p_bpidx = arrR(7,ari) '임시에 저장되지 않았다면 null

					If InStr(p_CDBNM,"초등") > 0 then
						If CDbl(p_userclass) < 5 Then
							p_CDBNM = Replace(p_CDBNM , "초등", "유년")
						End if	
					End if							


							If IsArray(arrP) Then
								For arp = LBound(arrP, 2) To UBound(arrP, 2)
									set_pidx = arrP(6, arp)
									If CStr(set_pidx) = CStr(p_pidx) Then
									aaa = set_pidx
										setplayer = True
										Exit for
									End if
								next
							end if							
							%>

						  
						  <tr <%If setplayer=True then%>class="s_disabled"<%End if%>>
							<td>
							  <input class="m_modal__chek" id="chekBoxModalPlayer_<%=ari%>" type="checkbox" value="<%=p_pidx%>" <%If isnull(p_bpidx) = False then%>checked<%End if%>>
							  <label for="chekBoxModalPlayer_<%=ari%>"></label>
							</td>
							<td>﻿<%=ari+1%></td>
							<th scope="row"><%=p_username%></th>
							<td>﻿<%=p_birthday%></td>
							<td><%=p_sexstr%></td>
							<td><%=p_CDBNM%></td>
							<td><%=p_userclass%></td>
						  </tr>
							<%
							Next
						End if
					%>



                </tbody>
              </table>
