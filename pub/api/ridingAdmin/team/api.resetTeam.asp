<%
'#############################################

'팀정보 초기화

'#############################################
	'request
	lid   = oJSONoutput.Get("LID")

	Set db = new clsDBHelper 
	
	If lid = "" Then
		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	Response.end
	End if


'	select * from tblWebRegLog where userid = 'mujerk' and delyn = 'N' and gubun = 3 and writedate >= '2021-01-01' 
'	select * from tblteaminfo where LEADER_KEY = 'mujerk' and delyn = 'N' and nowyear = '2021'
'	select  * from tblplayer where owner_id = 'mujerk' and delyn = 'N'  and usertype = 'P' nowyear = '2021'
'	select * from tblleader where owner_id = 'mujerk' and delyn = 'N'   and and apply_yn = 'Y'  nowyear = '2021'
'	--팀초기화

yy = year(date)
wdate =  yy & "-01-01"

SQL = ""
SQL = SQL & " update tblWebRegLog set delyn = 'Y' where userid = '"&lid&"' and delyn = 'N' and gubun = 3 and writedate >= '"&wdate&"'  " '해가 바뀌어서 소유자가 바뀐다면 어떻게 해야하나...

SQL = SQL & "	update tblteaminfo set leader_key = ''  where LEADER_KEY = '"&lid&"' and delyn = 'N'  and nowyear = '"&yy&"' " '삭제하면 음 팀이 사라져서 안될듯.....

SQL = SQL & "	update tblplayer set owner_id = '',  apply_yn = 'N'  where owner_id = '"&lid&"' and delyn = 'N' and usertype = 'P'  and nowyear = '"&yy&"' "

'SQL = SQL & " update tblleader set team = '',teamnm = '',apply_yn = 'N' where owner_id  = '"&lid&"' and delyn = 'N'  and apply_yn = 'Y'   and nowyear = '"&yy&"'"
SQL = SQL & " update tblleader set apply_yn = 'N' where owner_id  = '"&lid&"' and delyn = 'N'  and apply_yn = 'Y'   and nowyear = '"&yy&"'"

SQL = SQL & " update tblwebmember set apply_yn = 'N' where userid = '"&lid&"'  "
'Response.write sql
'Response.end
Call db.execSQLRs(SQL , null, ConStr)



Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>




