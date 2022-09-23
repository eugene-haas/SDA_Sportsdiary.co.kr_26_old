<%

'#############################################
'외부랭커 우승 반영체크
'#############################################
	'request
    datareq = True

	If hasown(oJSONoutput, "PIDX") = "ok" then
		pidx = oJSONoutput.PIDX
    Else
        datareq = False
    End IF

	If hasown(oJSONoutput, "PNAME") = "ok" then
		pname = oJSONoutput.PNAME
    Else
        datareq = False
	End If

    If hasown(oJSONoutput, "RNKYN") = "ok" then
		rnkyn = oJSONoutput.RNKYN
    Else
        datareq = False
	End If

    If hasown(oJSONoutput, "RNKSTART") = "ok" then
		rnkstart = oJSONoutput.RNKSTART
    Else
        rnkstart = ""
	End If

    If hasown(oJSONoutput, "RNKEND") = "ok" then
		rnkend = oJSONoutput.RNKEND
    Else
        rnkend = ""
	End If

    If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
    Else
        tidx = ""
	End If

    If hasown(oJSONoutput, "RNKTYPE") = "ok" then
		rnkType = oJSONoutput.RNKTYPE
    Else
        rnkType = ""
	End If

    If hasown(oJSONoutput, "BOONO") = "ok" then
		BOONO = oJSONoutput.BOONO
    Else
        BOONO = ""
	End If


    If datareq = False then
        Call oJSONoutput.Set("result", "1" ) '보낸값이  없음
        strjson = JSON.stringify(oJSONoutput)
        Response.Write strjson
        Response.write "`##`"
        Response.End
    End If


	Set db = new clsDBHelper

'    'chkTIDX, levelup , titlecode 구하기
'    If rnkType = "" Then
'        'chkTIDX 구하기 RNKSTART 와 가장 가까운 날짜에 종료된 대회의 IDX
'        'SQL = " SELECT TOP 1 GameTitleIDX, gameE, ABS(DATEDIFF(DD , '"&RNKSTART&"' , GameE)) DD FROM sd_TennisTitle ORDER BY DD ASC"
'        'Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
'        chkTIDX = 0 'rs("GameTitleIDX")
'
'        'levelup , titlecode 구하기
'        SQL = " SELECT GameYear, titleCode FROM sd_TennisTitle WHERE GameTitleIDX = "&chkTIDX&" "
'        Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
'        If rs.eof Then
'		titleCode = rs("titleCode")
'        gameYear = rs("GameYear")
'		else
'		titleCode = rs("titleCode")
'        gameYear = rs("GameYear")
'		End if
'    Else
'
'		If tidx <> "" then
'			SQL = "Select GameS,titleCode,titleGrade,gametitlename from sd_TennisTitle where GameTitleIDX = " & tidx
'			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'			If Not rs.eof then
'				games = Left(rs("games"),10)
'				titlecode = rs("titlecode")
'				titlegrade = rs("titleGrade")
'				gametitle = rs("gametitlename")
'
'				'당해년도 비교값은 타이
'				gameYear = Left(gametitle,4)
'				If Isnumeric(gameYear) = false Then
'					gameYear = year(date)
'				End If
'			Else
'				chkTIDX = 0
'				titleCode = rnkType				
'			End if
'		Else
'				chkTIDX = 0
'				titleCode = rnkType
'		End if		
'
'    End If

    '업데이트 하기
    updateTable = " tblPlayer "
    If rnkyn = "Y" then
		
		'updateField = " dblrnk = '"&rnkyn&"', chkTIDX = '"&chkTIDX&"', gameday='"&Left(rnkstart,10)&"', startrnkdate = '"&rnkstart&"', endRnkdate = '"&rnkend&"', levelup = "&gameYear&", titlecode = "&titlecode&",chklevel= '"&BOONO&"' " 
		If rnkend = "" Then
			updateField = " dblrnk = '"&rnkyn&"',  gameday='"&Left(rnkstart,10)&"',   chklevel= '"&BOONO&"'  " 
		else
			If Cdate(rnkend) <= Date  Then
			updateField = " dblrnk = '"&rnkyn&"',  gameday='"&Left(rnkstart,10)&"',   chklevel= '"&BOONO&"'  " 
			else
			updateField = " dblrnk = '"&rnkyn&"',  gameday='"&Left(rnkstart,10)&"',  endRnkdate = '"&rnkend&"', chklevel= '"&BOONO&"'  " 
			End if
		End if

	Else
		If rnkend = "" Then
			updateField = " dblrnk = '"&rnkyn&"',  gameday='"&Left(rnkstart,10)&"',   chklevel= null "
		else
			If Cdate(rnkend) <= Date  Then
			updateField = " dblrnk = '"&rnkyn&"',  gameday='"&Left(rnkstart,10)&"',   chklevel= null "
			else
			updateField = " dblrnk = '"&rnkyn&"',  gameday='"&Left(rnkstart,10)&"', endRnkdate = '"&rnkend&"',  chklevel= null "
			End if
		End if
	End if
    
	updateWhere = " PlayerIDX = "&pidx&" "
    SQL = " UPDATE "&updateTable&" SET "&updateField&" WHERE "&updateWhere&" "
    Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing

    Call oJSONoutput.Set("result", 3105 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>
