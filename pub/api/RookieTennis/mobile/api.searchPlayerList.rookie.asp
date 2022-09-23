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

  'SQL = "select top 10 playeridx,MemberIDX,userID,UserName,UserPhone,birthday,sex,TeamGB,teamnm  from tblPlayer where username like '"&F1&"%' and TeamGB <> '' order by len(username) asc "
  
  '랭킹에 있는 사람만 으로 변경 19년 5월 16일
  fldstr = " b.playeridx as playeridx,max(b.MemberIDX),max(b.userID),max(b.UserName) as username ,max(b.UserPhone),max(b.birthday),max(b.sex),max(b.TeamGB) as teamgb,max(b.teamnm) as teamnm "
  SQL = "select top 10 "& fldstr &"  from tblPlayer as b  INNER JOIN sd_TennisRPoint_log as a ON a.playeridx = b.playeridx "
  SQL = SQL & " where b.username like '"&F1&"%' and b.TeamGB <> '' group by b.playeridx,b.username order by len(b.username) asc "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  Do Until rs.eof
	Response.write "<button class=""m_searchPopup__listname [ _searchName ]"" onmousedown=""tm.searchRecord('drowarea','"&year(date)&"','"&rs("teamgb")&"','"&rs("playeridx")&"')"">"&rs("username")&"  ("&rs("teamnm")&")<span class=""icon__search_add""><img src=""http://img.sportsdiary.co.kr/images/SD/icon/search_add_@3x.png""></span></button>"
  rs.movenext
  loop


	db.Dispose
	Set db = Nothing
%>
