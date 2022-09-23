<%
'######################
'검색리스트  http://tennis.sportsdiary.co.kr/tennis/tsm_player/record/record_sd.asp or ajax에서 사용
'######################


	If hasown(oJSONoutput, "YY") = "ok" Then '년도
		YY = oJSONoutput.YY
	End If
	If hasown(oJSONoutput, "GB") = "ok" Then '코드
		GB = oJSONoutput.GB
	End If
	If hasown(oJSONoutput, "F1") = "ok" Then '이름 검색어
		F1 = oJSONoutput.F1
	End If

	Set db = new clsDBHelper


  SQL = "select top 10 playeridx,MemberIDX,userID,UserName,UserPhone,birthday,sex,TeamGB  from tblPlayer where username like '"&F1&"%' and TeamGB <> '' order by len(username) asc "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


  Do Until rs.eof
	Response.write "<button class=""m_searchPopup__listname"" onmousedown=""tm.searchRecord('drowarea','"&year(date)&"','"&rs("teamgb")&"','"&rs("playeridx")&"')"">"&rs("username")&"</button>"
  rs.movenext
  loop


	db.Dispose
	Set db = Nothing
%>