<%
'#############################################
'승급자 전체 초기화
'#############################################
	'request
'	If hasown(oJSONoutput, "PIDX") = "ok" then
'		pidx = oJSONoutput.PIDX
'	Else
'		Response.end
'	End If

	Set db = new clsDBHelper

	chkyear = CDbl(year(date)) - 1

	'우승자들 18년도 개나리 , 신인부 기록 ptuse = 'N'
	'18년에 일시승격으로 된 사람도 종료일에 관계없이 19년 신인부 랭킹에서는 빠져야 합니다.
	SQL = "update sd_TennisRPoint_log Set ptuse = 'N'  "
	SQL = SQL & " where teamgb in ( '20101','20104' ) and  titleName like '"&chkyear&"%' and playeridx in (Select playeridx From tblplayer Where levelup = '"&chkyear&"' and dblrnk = 'Y') "
	Call db.execSQLRs(SQL , null, ConStr)

	'올해 이전것만 초기화
	chkq = ", chklevel = Case when chklevel = '20104' then '20105' when chklevel ='20101' then '20102' else chklevel end  "
	SQL = "update tblPlayer Set dblrnk = 'N',gameday=null "&chkq&" where levelup = '" & chkyear & "' and dblrnk = 'Y' " ' and (endrnkdate is null or endrnkdate <= '"&date&"'  )"
	Call db.execSQLRs(SQL , null, ConStr)



	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 3102 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>