<%
'#############################################
'선수 정보 수정 ( 이름은 변경 되지 않습니다.)
'#############################################
	'request
	pidx = oJSONoutput.pidx
	pname = oJSONoutput.pname
	pboo = oJSONoutput.boo
	psex = oJSONoutput.psex
	pphone = oJSONoutput.phone
	pbirth = oJSONoutput.pbirth
	pteam1 = oJSONoutput.pteam1
	pteam2 = oJSONoutput.pteam2
	phone = Replace(phone, "-","")

	tidx = oJSONoutput.tidx
	levelno = oJSONoutput.levelno
  ptype = oJSONoutput.ptype


	Set db = new clsDBHelper

	Function teamChk(ByVal teamNm)
		Dim rs, SQL ,insertfield ,insertvalue ,teamcode
		SQL = "Select Team from tblTeamInfo where SportsGb = 'tennis' and TeamNm = '"&Replace(Trim(teamNm)," ","")&"' and delYN = 'N'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			'등록 후 정보
			SQL = "Select top 1 convert(nvarchar,SUBSTRING(Team,4,LEN(Team))+1) teamLast,len(Team)TeamLen from  tblTeamInfo where SportsGb = 'tennis' and delYN = 'N'  ORDER BY Team desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			teamcode = "ATE000" & rs(0)

			insertfield = " SportsGb,Team,TeamNm,EnterType,TeamLoginPwd,NowRegYN "
			insertvalue = "'tennis','"&teamcode&"','"&Replace(Trim(teamNm)," ","")&"','A','"&teamcode&"','Y' "

			SQL = "INSERT INTO tblTeamInfo ( "&insertfield&" ) VALUES ( "&insertvalue&" ) "
			Call db.execSQLRs(SQL , null, ConStr)
			teamChk = teamcode
		Else
			teamChk = rs(0)
		End If
	End function

	If CDbl(tidx) = 0 Then '선수정보만 수정
		'참가 신청이 풀려있는 모둔 대회를 찾아서 바꾼다.
		'SQL = "select gameTitleIDX frm sd_tennisTitle where delYN = 'n' and viewYN = 'Y' "


		If pteam1 = "" Then
		team1_code = ""
		Else
		team1_code = teamChk(pteam1)
		End if


		If pteam2 = "" Then
		team2_code = ""
		Else
		team2_code = teamChk(pteam2)
		End If


		updatevalue = " UserPhone='"&pphone&"',Birthday='"&pbirth&"',sex='"&psex&"',belongBoo='" &pboo& "' "
		updatevalue = updatevalue & ",Team='"&team1_code&"',TeamNm='"&pteam1&"',Team2='"&team2_code&"',Team2Nm='"&pteam2&"' "
		SQL = " Update  tblPlayer Set  " & updatevalue & " where PlayerIDX = " & pidx
		Call db.execSQLRs(SQL , null, ConStr)
	Else '참가신청, 선수정보, 대진정보

		'선수정보
		If pteam1 = "" Then
		team1_code = ""
		Else
		team1_code = teamChk(pteam1)
		End if


		If pteam2 = "" Then
		team2_code = ""
		Else
		team2_code = teamChk(pteam2)
		End If

		updatevalue = " UserPhone='"&pphone&"',Birthday='"&pbirth&"',sex='"&psex&"',belongBoo='" &pboo& "' "
		updatevalue = updatevalue & ",Team='"&team1_code&"',TeamNm='"&pteam1&"',Team2='"&team2_code&"',Team2Nm='"&pteam2&"' "
		SQL = " Update  tblPlayer Set  " & updatevalue & " where PlayerIDX = " & pidx
		Call db.execSQLRs(SQL , null, ConStr)

		'참가신청 update

    If ptype = 1 Then
		updatequery = " p1_userphone='"&pphone&"',p1_sex= '"&psex&"',p1_team='"&team1_code&"',p1_teamnm='"&pteam1&"',p1_team2='"&team2_code&"',p1_teamnm2='"&pteam2&"' "
		SQL = "update tblGameRequest set  "&updatequery&"  where P1_PlayerIDX= " & pidx & " and gametitleidx = " & tidx & " and level= '"&levelno&"' "
		Call db.execSQLRs(SQL , null, ConStr)

    ElseIf ptype = 2 Then
		updatequery = " p2_userphone='"&pphone&"',p2_sex='"&psex&"',p2_team='"&team1_code&"', p2_teamnm='"&pteam1&"',p2_team2='"&team2_code&"', p2_teamnm2='"&pteam2&"' "
		SQL = "update tblGameRequest set  "&updatequery&"  where P2_PlayerIDX= " & pidx & " and gametitleidx = " & tidx & " and level= '"&levelno&"' "
		Call db.execSQLRs(SQL , null, ConStr)

    End If

		'대진표 update
		updatequery = " teamANa='"&pteam1&"', TeamBNa='"&pteam2&"' "
		SQL = "update sd_TennisMember Set "&updatequery&" where PlayerIDX= " & pidx & " and gametitleidx = " & tidx & " and gamekey3= "&levelno&" "
		Call db.execSQLRs(SQL , null, ConStr)

		updatequery = " teamANa='"&pteam1&"', TeamBNa='"&pteam2&"' "
		subq = "Select top 1 b.partneridx from sd_TennisMember as a Left join sd_TennisMember_partner as b ON  a.gamememberidx = b.gamememberidx where b.PlayerIDX= " & pidx & " and a.gametitleidx = " & tidx & " and a.gamekey3= "&levelno&" "
		SQL = "update sd_TennisMember_partner Set  "&updatequery&" where partneridx= (" &subq& ")"
		Call db.execSQLRs(SQL , null, ConStr)
	End if

  db.Dispose
  Set db = Nothing

%>
<tr>
	<th scope="row">선수정보변경.</th>
	<td id="sel_VersusGb">
	<input type="hidden" id="u_idx" value="<%=pidx%>">
	<input type="hidden" id="u_name" value="<%=pname%>">
	<span style="font-size:18px;color:orange;"><%=pname%></span>

	<select  id="u_boo" style="width:100px;margin-top:-9px" >
	<option value="개나리부"  <%If pboo = "개나리부" then%>selected<%End if%>>개나리부</option>
	<option value="국화부"  <%If pboo = "국화부" then%>selected<%End if%>>국화부</option>
	<option value="신인부"  <%If pboo = "신인부" then%>selected<%End if%>>신인부</option>
	<option value="오픈부"  <%If pboo = "오픈부" then%>selected<%End if%>>오픈부</option>
	<option value="베테랑부"  <%If pboo = "베테랑부" then%>selected<%End if%>>베테랑부</option>
	</select>

	<select name="u_sex" id="u_sex" style="width:50px;margin-top:-9px" >
	<option value="Man"  <%If psex = "Man" then%>selected<%End if%>>남</option>
	<option value="WoMan"  <%If psex = "WoMan" then%>selected<%End if%>>여</option>
	</select>
	<input type="text"  id="u_birth"  maxlength="8" placeholder="ex)19880725" style="width:100px;" value="<%=pbirth%>" >

	<input type="text" id="u_phone" style="width:150px;" value="<%=pphone%>" placeholder="ex)01000000000" >

	1팀
	<input type="text" id="u_team1nm" style="width:150px;" width="150px;" value ="<%=pteam1%>">

	2팀
	<input type="text" id="u_team2nm" style="width:150px;" width="150px;" value ="<%=pteam2%>">


	<%If levelno = "" then%>
		<a href="javascript:mx.playeredit(<%=pidx%>,0,0)" class="btn_a btn_func">선수 정보 수정</a> [선수정보]
	<%else%>
		<a href="javascript:mx.playeredit(<%=pidx%>,<%=tidx%>,<%=levelno%>)" class="btn_a btn_func">선수 정보 수정</a> [참가신청, 선수정보, 대진정보]
	<%End if%>
	</td>
</tr>
