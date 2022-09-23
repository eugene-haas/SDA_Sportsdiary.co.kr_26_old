<%
'#############################################
'시간변경
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX 
	End If
	If hasown(oJSONoutput, "FINDYEAR") = "ok" then
		nowgameyear= oJSONoutput.FINDYEAR 
	End If
	
	'@@@@@@@@@@@@@@@@@@@@@@@@	
	If hasown(oJSONoutput, "IDX") = "ok" then
		r_idx= oJSONoutput.IDX 
	End If
	If hasown(oJSONoutput, "TTYPE") = "ok" then
		ttype= oJSONoutput.TTYPE  's 또는 e 또는 g : 일정시간이므로 체크가 들어가야한다.
	End If
	If hasown(oJSONoutput, "H") = "ok" then
		hh = addZero(oJSONoutput.H)
	End If
	If hasown(oJSONoutput, "M") = "ok" then
		mm = addZero(oJSONoutput.M)
	End If

	timestr = setTimeFormat(hh&":"&mm&":00")

	Select Case  ttype
	Case  "s" 
		'동일 애들 모두 변경되어야한다...
		'SQL = "Update tblRGameLevel Set gametime = '"&Left(timestr,5)&"' where RGameLevelidx = " & r_idx
		SQL = "Update tblRGameLevel Set gametime = '"&Left(timestr,5)&"' where gametitleidx = " & tidx & " and gbidx = (select gbidx from tblRGameLevel where RGameLevelidx = "&r_idx&" )"
		Call db.execSQLRs(SQL , null, ConStr)
	Case "e"
		'SQL = "Update tblRGameLevel Set gametimeend = '"&Left(timestr,5)&"' where RGameLevelidx = " & r_idx
		SQL = "Update tblRGameLevel Set gametimeend = '"&Left(timestr,5)&"' where gametitleidx = " & tidx & " and gbidx = (select gbidx from tblRGameLevel where RGameLevelidx = "&r_idx&" )"
		Call db.execSQLRs(SQL , null, ConStr)

	
	
	Case "g" '이건 일정관리임개별 시간변경임... 수정가능시간 체크 

		If hasown(oJSONoutput, "GBIDX") = "ok" then
			gbidx= oJSONoutput.GBIDX 
		End If

		'gbidx 로 묶인 게임 정보 
		strTableName2 = "  tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx "
		strfieldA = " a.RGameLevelidx,  b.levelno,b.TeamGbNm,b.ridingclass,b.ridingclasshelp ,a.GameDay,a.GameTime,a.gametimeend  " 
		strFieldName2 = strfieldA 
		strWhere2 = " a.GameTitleIDX = "&tidx&" and a.gbIDX = '"&gbidx&"' and a.DelYN = 'N' and b.DelYN = 'N' "

		SQL = "Select top 1 "&strFieldName2&" from "&strTableName2&" where " & strWhere2
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'646	20101001	마장마술	b	h	2019-03-19	09:00	20:30

		If Not rs.EOF Then
			arrNo = rs.GetRows()
			If IsArray(arrNo)  Then
				o_ridx = arrNo(0, 0)
				o_levelno = arrNo(1, 0)
				o_levelnm = arrNo(2, 0)
				o_classnm = arrNo(3, 0)
				o_classhelp = arrNo(4, 0)
				o_gamedate = arrNo(5, 0)
				o_stime = arrNo(6, 0) & ":00"
				o_etime = arrNo(7, 0) & ":00"
			End if
		End If

		o_s = o_gamedate & " " & o_stime '시작날짜 시간

		Select Case  o_levelnm '장애물 1시간전, 마장마술 2시간전 경기시작시간 기준 에서만 수정가능...함...
		Case  "마장마술" 
			majang = True
			chkTime = DATEADD("h", -2, o_s)
		Case "장애물"
			majang = false	
			chkTime = DATEADD("h", -1, o_s)
		Case Else
			majang = false	
			chkTime = DATEADD("h", -1, o_s)
		End Select 

	If now() > CDate(chktime) Then
		 'Response.write "두시간전에 취소가능해"
		If majang = True then
			Call oJSONoutput.Set("result", "30" )
		Else
			Call oJSONoutput.Set("result", "31" )
		End if
		
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		db.Dispose
		Set db = Nothing
		Response.end
	End if

	gametime = o_gamedate & " " & timestr

	SQL = "update SD_tennisMember Set gametime = '"&gametime&"' where gameMemberIDX = " & r_idx
	Call db.execSQLRs(SQL , null, ConStr)
	
	End Select 

  
  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
