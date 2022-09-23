<%
	'request
	pageno = oJSONoutput.PAGENO
	ftype = oJSONoutput.findTYPE
	fsex = oJSONoutput.findSEX
	fstr = oJSONoutput.fndSTR

		If hasown(oJSONoutput, "winner") = "ok" then	 '입금일짜
			winner = oJSONoutput.winner
		End if

	Set db = new clsDBHelper

	intPageNum = pageno
	intPageSize = 50

	rnkquery = "(SELECT sum(getpoint) FROM sd_TennisRPoint_log b where  b.PlayerIDX = a.PlayerIDX and ptuse = 'Y') as rankpoint "
	rnkcount = "(SELECT count(*) FROM sd_TennisRPoint_log b where  b.PlayerIDX = a.PlayerIDX and ptuse = 'Y') as rankcount "
	strTableName = " tblPlayer as a "
	strFieldName = " PlayerIDX,UserName,UserPhone,Birthday,Sex,PersonCode,team,teamNm,team2,team2Nm,userLevel,WriteDate "
	strFieldName = strFieldName & " ,"&rnkquery&", "&rnkcount&",belongBoo, titlecode,dblrnk,levelup,openrnkboo       ,teamgb,firstcount,gameday,gamestartyymm, stateNo,lastorder " 

	strSort = "  ORDER By UserName asc"
	strSortR = "  ORDER By  UserName desc"


	'search
	Select Case fsex
	Case "0"		: whereSex = ""
	Case "Man"	: whereSex = " and Sex = 'Man'"
	Case "WoMan"	: whereSex = " and Sex = 'WoMan'"
	End Select

	Select Case ftype
	Case "s_name"		'선수명
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and UserName like '%"&fstr&"%' "
	Case "s_team"	'팀명
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and (teamNm like '%"&fstr&"%' or team2Nm like '%"&fstr&"%') "
	Case "s_phone"	'연락처
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and UserPhone like '%"&fstr&"%'"
	Case "s_grade"	'등급
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and userLevel = '"&fstr&"'"
	Case "s_birth"	'생년
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and Birthday >= '"&fstr&"%' "
	Case "s_openrank"
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' and openrnkboo like '"&fstr&"%' "
	Case "s_point"	'랭킹포인트
		if Len(fstr) = 0 Then
			fstr= 0
		END IF
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' "' and (SELECT Top 1 rankpoint FROM sd_TennisRPoint b where b.PlayerIDX = a.PlayerIDX order by rankpoint desc) >= "& fstr & " "
	End Select

	strWhere = strWhere '& whereSex

	If winner <> "" Then
		strWhere = strWhere & " and levelup > 0 "
	End if

	If winner = "" Then
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	Else
	SQL = "Select " & strFieldName & " from " & strTableName & " where " & strwhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	End If

	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End if

	'대회그룹/등급
	SQL = "Select titleCode,titleGrade,hostTitle,idx from sd_TennisTitleCode where  DelYN = 'N' "
	Set rsg = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rsg.EOF Then
	arrRSG = rsg.GetRows()
	End if






	'부목록
	SQL = "select sex,PTeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('201') and DelYN = 'N' order by Orderby asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrBoo = rs.GetRows()
	End if





'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )

If CDbl(pageno) >= CDbl(intTotalPage) Then
	lastpage = "_end"
Else
	lastpage = "_ing"
End if

If winner <> "" Then
	lastpage = "_end"
End if


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
Call oJSONoutput.Set("lastchk", lastpage )
Call oJSONoutput.Set("totalcnt", intTotalCnt )
Call oJSONoutput.Set("totalpage", intTotalPage )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

  db.Dispose
  Set db = Nothing

'Response.write strWhere

i = 0
'	strFieldName = " PlayerIDX, UserName, UserPhone,Birthday, Sex,PersonCode,team,teamNm,team2,team2Nm,RankingPoint,userLevel,WriteDate "
If IsArray(arrRS) Then
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

		pidx = arrRS(0, ar)
		pname = arrRS(1, ar)
		pphone =	 arrRS(2, ar)
		pbirth =	 arrRS(3, ar)
		psex =	 arrRS(4, ar)
		pcode = arrRS(5, ar)
		pteam1 =	 arrRS(7, ar)
		pteam2 =	 arrRS(9, ar)
		'prankno =	 arrRS(10, ar)
		pgrade =	 arrRS(10, ar)
		writeday =	 Left(arrRS(11, ar) ,10)
		prankpoint =arrRS(12, ar)
		rankcount = arrRS(13, ar)
		belongBoo = arrRS(14,ar)

		titlecode =  arrRS(15,ar) '우승한 대회의 코드
		dblrnk =  arrRS(16,ar) '승급자반영여부
		levelup =  arrRS(17,ar) '우승년도
		openboornk = arrRS(18,ar) '오픈부 반영부서
		If dblrnk = "N" Then
			titlecode = ""
		End if


		s_teamgb = arrRS(19,ar)
		s_firstcount = arrRS(20,ar)
		s_gameday = arrRS(21,ar)
		s_gamestartyymm = arrRS(22,ar)
		s_stateNo = arrRS(23,ar)
		s_lastorder = arrRS(24,ar)

	%>
	<!-- #include virtual = "/pub/html/swimAdmin/PlayerList.asp" -->
	<%
	i = i + 1
	Next
End if
%>
