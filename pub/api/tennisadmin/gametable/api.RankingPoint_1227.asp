<%
'#############################################
' 선수관리, 신청정보 관리에 나오는 선수별 랭킹 포인트 기록 및 수정 화면
'#############################################

'request
idx = oJSONoutput.IDX
name = oJSONoutput.NAME

'대회신청정보 수정에서 오면 받는다.
If hasown(oJSONoutput, "LEVELNO") = "ok" then
	levelno = oJSONoutput.LEVELNO
Else
	levelno = ""
End If

If hasown(oJSONoutput, "TIDX") = "ok" then
	tidx = oJSONoutput.TIDX
Else
	tidx = ""
End If

If hasown(oJSONoutput, "TITLE") = "ok" then
	title = oJSONoutput.TITLE
Else
	title = ""
End If

If hasown(oJSONoutput, "PTYPE") = "ok" then
	ptype = oJSONoutput.PTYPE
Else
	ptype = 1
End If


Set db = new clsDBHelper


SQL = "select userName,UserPhone,belongboo,sex,birthday,team,teamnm,team2,team2nm,gameday,dblrnk from tblPlayer where playerIDX = " & idx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If rs.eof Then
	Response.write "검색 내용 없음"
	Response.end
Else
	uname = rs("username")
	uphone = rs("userPhone")
	uphoneno = Replace(uphone,"-","")
	ubelongboo = rs("belongboo")
	usex = rs("sex")
	ubirth = rs("birthday")
	uteam1 = rs("team")
	uteam1nm = rs("teamnm")
	uteam2 = rs("team2")
	uteam2nm = rs("team2nm")
	gameday = rs("gameday")
	dblrnk = rs("dblrnk")

End if

'SQL = "select PlayerIDX, userName ,UserPhone from tblPlayer where userName = '"&name&"' and userPhone in ('"&uphone&"','"&uphoneno&"') "
'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'i = 1
'Do Until rs.eof
'	If i = 1 then
'		wherepidx =  rs("PlayerIDX")
'	Else
'		wherepidx =  wherepidx & "," & rs("PlayerIDX")
'	End if
'i = i + 1
'rs.movenext
'loop


'If wherepidx <> "" then
	'SQL = "select titleName as '대회명' ,teamGbName as '부서',getpoint as '랭킹포인트',rankno as '순위',ptuse as '반영여부'  from sd_TennisRPoint_log  where ptuse= 'Y' and PlayerIDX in ("&wherepidx&") order by teamGbName, Gamedate desc"
	SQL = "select titleName as '대회명' ,teamGbName as '부서',getpoint as '랭킹포인트',rankno as '순위',ptuse as '반영여부', gamedate as '게임일자'  from sd_TennisRPoint_log  where ptuse= 'Y' and PlayerIDX = "&idx&" order by teamGbName, getpoint desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'End if
'#############################################

	'합산 15개씩
'	SQL = "Select sum(getpoint) from sd_TennisRPoint_log where idx in ( Select top 15 idx from sd_TennisRPoint_log where PlayerIDX = "&p2idx&" and teamGb in "&Whereteamgb&" order by getpoint desc )"
'	SQL = "select top 15 sum(getpoint)  from sd_TennisRPoint_log as a where ptuse= 'Y' and PlayerIDX = "&idx&" and teamGb = b.teamGb"
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	arrb =  listBoo()


%>

<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'><%=name%>

	<%If gameday <> "" then%>&nbsp;승급:<%=gameday%><%End if%>
	
	<%If title <> "" then%>[<%=title%>]<%End if%></h3>

  </div>
<!-- 헤더 코트e -->
<div class='modal-body '>
<div class="scroll_box" style="margin-top:5px;font-size:12px;">
	<%
	'If wherepidx <> "" then
	Call rsDrow(rs)
	'End if
	%>

<%
			'플레이어	Case 20103 '베테랑부
			'선수의 반영 부서가 베테랑 부라면 오픈부값을 추가한다.
			SQL = "select openrnkboo from tblplayer where playerIDX = " & idx & " and openrnkboo in ( '베테랑부', '신인부') "
			Set rsr = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rsr.eof Then
				boo_nm = rsr(0)
				If boo_nm = "베테랑부" then
				SQL = "select max(teamGbName) as '부서',  sum(getpoint) as '상위 15개(오픈부포함) 포인트'  from sd_TennisRPoint_log as a where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y' and PlayerIDX = "&idx&" and teamGbName in ('베테랑부', '오픈부') order by getpoint desc ) "
				Else
				SQL = "select max(teamGbName) as '부서',  sum(getpoint) as '상위 15개(오픈부포함) 포인트'  from sd_TennisRPoint_log as a where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y' and PlayerIDX = "&idx&" and teamGbName in ('신인부', '오픈부') order by getpoint desc ) "
				End if
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If isNull(rs(1)) = false then
				Call rsDrow(rs)
				End if
			End if


		If IsArray(arrb) Then
			For arp = LBound(arrb, 2) To UBound(arrb, 2)
				boocode = arrb(0, arp)
				booname = arrb(1,arp)

				SQL = "select max(teamGbName) as '부서',  sum(getpoint) as '상위 15개 포인트'  from sd_TennisRPoint_log as a where idx in ( Select top 15 idx from sd_TennisRPoint_log where  ptuse= 'Y' and PlayerIDX = "&idx&" and teamGb = "&boocode&" order by getpoint desc ) "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If isNull(rs(1)) = false then
				Call rsDrow(rs)
				End if
			Next
		End if


db.Dispose
Set db = Nothing
%>

</div>


<table class="table-list admin-table-list" id="rankplayerinfo">
<tr>
	<th scope="row">선수정보변경</th>
	<td id="sel_VersusGb">
	<input type="hidden" id="u_idx" value="<%=idx%>">
	<input type="hidden" id="u_name" value="<%=uname%>">
	<span style="font-size:18px;color:orange;"><%=uname%></span>

	<select  id="u_boo" style="width:100px;margin-top:-9px" >
	<option value="개나리부"  <%If ubelongBoo = "개나리부" then%>selected<%End if%>>개나리부</option>
	<option value="국화부"  <%If ubelongBoo = "국화부" then%>selected<%End if%>>국화부</option>
	<option value="신인부"  <%If ubelongBoo = "신인부" then%>selected<%End if%>>신인부</option>
	<option value="오픈부"  <%If ubelongBoo = "오픈부" then%>selected<%End if%>>오픈부</option>
	<option value="베테랑부"  <%If ubelongBoo = "베테랑부" then%>selected<%End if%>>베테랑부</option>
	</select>

	<select name="u_sex" id="u_sex" style="width:50px;margin-top:-9px" >
	<option value="Man"  <%If usex = "Man" then%>selected<%End if%>>남</option>
	<option value="WoMan"  <%If usex = "WoMan" then%>selected<%End if%>>여</option>
	</select>
	<input type="text"  id="u_birth"  maxlength="8" placeholder="ex)19880725" style="width:100px;" value="<%=ubirth%>" >

	<input type="text" id="u_phone" style="width:150px;" value="<%=uphone%>" placeholder="ex)01000000000" >

	1팀
	<input type="text" id="u_team1nm" style="width:150px;" width="150px;" value ="<%=uteam1nm%>">
	2팀
	<input type="text" id="u_team2nm" style="width:150px;" width="150px;" value ="<%=uteam2nm%>">
  <% If tidx <> "" AND levelno <> "" Then %>
    <% If tidx <> 0 AND levelno <> 0 Then %>
	  <a href="javascript:mx.playeredit(<%=idx%>,<%=tidx%>,<%=levelno%>, <%=ptype%>)" class="btn_a btn_func">선수 정보 수정</a> [참가신청, 선수정보, 대진정보]
    <% Else %>
    <a href="javascript:mx.playeredit(<%=idx%>,0,0)" class="btn_a btn_func">선수 정보 수정</a> [선수정보]
    <% End If %>
  <% Else %>
    <a href="javascript:mx.playeredit(<%=idx%>,0,0)" class="btn_a btn_func">선수 정보 수정</a> [선수정보]
  <% End If %>
	</td>
</tr>
</table>

</div>
