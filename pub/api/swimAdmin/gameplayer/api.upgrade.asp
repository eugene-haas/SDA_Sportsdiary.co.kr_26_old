<%
'#############################################
'승급자 설정
'#############################################
	'request
	If hasown(oJSONoutput, "PIDX") = "ok" then
		pidx = oJSONoutput.PIDX
	Else
		Response.end
	End If
	If hasown(oJSONoutput, "V") = "ok" then
		setvalue = oJSONoutput.V
	Else
		setvalue = 0
	End If
    If hasown(oJSONoutput, "TITLECODE") = "ok" then
		titleCode = oJSONoutput.TITLECODE
	Else
		titleCode = ""
	End If

	Set db = new clsDBHelper

    'titleCode 로 sd_TennisTitle 테이블에 대회기록이 있는지 찾고 없으면 외부경기로 판단
    If titleCode <> "" Then
        SQL = " SELECT max(gametitleidx) , COUNT(*) FROM sd_TennisTitle a LEFT JOIN sd_TennisTitleCode b ON a.titleCode = b.titleCode WHERE a.titleCode = "&titleCode&" AND GameYear = '"&year(date)&"'"
        Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
        gametitleidx = rs(0)
		checkTitle = rs(1)
    End If


	If setvalue = ""  Then
	SQL = "update tblPlayer Set levelup = 0,titlecode = 0,gameday=null,dblrnk='N',chkTidx=null,chkLevel = null,startrnkdate = null, endRnkdate = null where playerIDX = " & pidx 'year(date) 0 플레이어 정보에 변경해줘야함.
	Else
	'gameday varchar(10)
	SQL = "update tblPlayer Set levelup = " & year(date)& ",gameday='"&date&"',titlecode = "&setvalue&",dblrnk='Y',openrnkboo = null,chkTidx = '"&gametitleidx&"' ,chkLevel= '20104' where playerIDX = " & pidx 'year(date) 0 플레이어 정보에 변경해줘야함.
	End if
	Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing

    If checkTitle = 0 Then
        Call oJSONoutput.Set("result", 3104 )
		Call oJSONoutput.Set("pidx", pidx )
        strjson = JSON.stringify(oJSONoutput)
        Response.Write strjson
    Else
        Call oJSONoutput.Set("result", 3101 )
        strjson = JSON.stringify(oJSONoutput)
        Response.Write strjson
    End If


%>
