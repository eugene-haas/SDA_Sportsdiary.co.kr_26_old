
<%
'######################
'스코어 보드지의 스코어 변경
'######################

	'If hasown(oJSONoutput, "IDX") = "ok" then
	'	idx = oJSONoutput.IDX
	'End if	

  Set db = new clsDBHelper

  'Dim REQ : REQ = "{}"
  'Set oJSONoutput = JSON.Parse(REQ)

	'REQ = Request("Req")
	'REQ = "{""CMD"":6,""PlayerCnt"":3,""GameType"":""B0040001"",""GroupGameGb"":""B0030001""}"

	Set oJSONoutput = JSON.Parse(REQ)  

	DEC_GameLevelDtlIDX = oJSONoutput.DEC_GameLevelDtlIDX
	DEC_TeamGameNum = oJSONoutput.DEC_TeamGameNum
	DEC_GameNum = oJSONoutput.DEC_GameNum
	SetNum = oJSONoutput.SetNum

	If hasown(oJSONoutput, "GameResultDtlIDX") = "ok" then
		GameResultDtlIDX = oJSONoutput.GameResultDtlIDX
	Else
		GameResultDtlIDX = ""
	End If
	DEC_Point_TourneyGroupIDX = oJSONoutput.TourneyGroupIDX
	NextServeMemberIDX = oJSONoutput.MemberIDX

	LTourneyGroupIDX = oJSONoutput.LTourneyGroupIDX
	RTourneyGroupIDX = oJSONoutput.RTourneyGroupIDX
	'DEC_Point_TourneyGroupIDX = 1434
	'NextServeMemberIDX = 	358

	strjson = JSON.stringify(oJSONoutput)


LSQL = "SELECT A.GameTitleIDX, A.TeamGb, A.Sex, B.Level, B.LevelDtlName, A.GroupGameGb"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameLevel A"
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelidx = B.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"



Set rs = db.ExecSQLReturnRS(LSQL , null, ConStr)

If Not (rs.Eof Or rs.Bof) Then

    Do Until rs.Eof

	    GameTitleIDX = rs("GameTitleIDX")
      TeamGb = rs("TeamGb")
      Sex = rs("Sex")
      Level = rs("Level")
      LevelDtlName = rs("LevelDtlName")
      GroupGameGb = rs("GroupGameGb")

      rs.MoveNext
    Loop

Else

End If

rs.Close

	


'1점 점수코드
JumsuGb = "B0090001"

If GameResultDtlIDX = "" Then
	'1점 득점
	CSQL = "INSERT INTO KoreaBadminton.dbo.tblGameResultDtl"
	CSQL = CSQL & " ("
	CSQL = CSQL & " GameTitleIDX, GameLevelDtlidx, TeamGb, Sex, Level, "
	CSQL = CSQL & " LevelDtlName, GroupGameGb, TeamGameNum, GameNum, SetNum, "
	CSQL = CSQL & " TourneyGroupIDX, JumsuGb, Jumsu, "
	CSQL = CSQL & " NextServeMemberIDX"
	CSQL = CSQL & " )"
	CSQL = CSQL & " VALUES"
	CSQL = CSQL & " ("
	CSQL = CSQL & " '" & GameTitleIDX & "', '" & DEC_GameLevelDtlIDX & "', '" & TeamGb & "', '" & Sex & "', '" & Level & "',"
	CSQL = CSQL & " '" & LevelDtlName & "', '" & GroupGameGb & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "', '" & SetNum & "',"
	CSQL = CSQL & " '" & DEC_Point_TourneyGroupIDX & "', '" & JumsuGb & "', KoreaBadminton.dbo.FN_NameSch('" & JumsuGb & "','PubJumsu'),"
	CSQL = CSQL & " '" & NextServeMemberIDX & "'"
	CSQL = CSQL & " )"

	Set rs = db.ExecSQLReturnRS(CSQL , null, ConStr)
Else

CSQL = "UPDATE tblGameResultDtl SET TourneyGroupIDX = '" & DEC_Point_TourneyGroupIDX & "', NextServeMemberIDX = '" & NextServeMemberIDX & "'"
CSQL = CSQL & " WHERE DelYN = 'N'"
CSQL = CSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"
CSQL = CSQL & " AND SetNum = '" & SetNum & "'"
CSQL = CSQL & " AND GameResultDtlIDX = '" & GameResultDtlIDX & "'"

Set rs = db.ExecSQLReturnRS(CSQL , null, ConStr)

End If


  Function SetJumsu(strGameLevelDtlidx, strTeamGameNum, strGameNum, strTourneyGroupIDX)

			SQL = "SELECT ISNULL(SUM(SetPoint1),0) AS SetPoint1,		"
			SQL = SQL & "    ISNULL(SUM(SetPoint2),0) AS SetPoint2,	"
			SQL = SQL & "    ISNULL(SUM(SetPoint3),0) AS SetPoint3,	"
			SQL = SQL & "    ISNULL(SUM(SetPoint4),0) AS SetPoint4,	"
			SQL = SQL & "    ISNULL(SUM(SetPoint5),0) AS SetPoint5	"
			SQL = SQL & "    FROM	"
			SQL = SQL & "     (		"
			SQL = SQL & "     SELECT CASE WHEN SetNum = '1' THEN Jumsu ELSE 0 END AS SetPoint1,	"
			SQL = SQL & "     CASE WHEN SetNum = '2' THEN Jumsu ELSE 0 END AS SetPoint2,	"
			SQL = SQL & "     CASE WHEN SetNum = '3' THEN Jumsu ELSE 0 END AS SetPoint3,	"
			SQL = SQL & "     CASE WHEN SetNum = '4' THEN Jumsu ELSE 0 END AS SetPoint4,	"
			SQL = SQL & "     CASE WHEN SetNum = '5' THEN Jumsu ELSE 0 END AS SetPoint5	"
			SQL = SQL & "     FROM KoreaBadminton.dbo.tblTourney A	"
			SQL = SQL & "     LEFT JOIN KoreaBadminton.dbo.tblGameResultDtl B ON B.TourneyGroupIDX = A.TourneyGroupIDX AND B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum	"
			SQL = SQL & "     WHERE A.DelYN = 'N'	"
			SQL = SQL & "     AND B.DelYN = 'N'	"
			SQL = SQL & "     AND B.GameLevelDtlidx = '" & strGameLevelDtlidx & "'	"
			SQL = SQL & "     AND B.TeamGameNum = '" & strTeamGameNum & "'	"
			SQL = SQL & "     AND B.GameNum = '" & strGameNum & "'	"

			SQL = SQL & "     AND B.TourneyGroupIDX = '" & strTourneyGroupIDX & "'	 ) as c"

      Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

      Set fn_oJSONoutput_ct = jsArray()
      Set fn_oJSONoutput_ct = jsObject()

      If Not (rs.Eof Or rs.Bof) Then

          Do Until rs.Eof

            fn_oJSONoutput_ct("SetPoint1") = rs("SetPoint1")
            fn_oJSONoutput_ct("SetPoint2") = rs("SetPoint2")
            fn_oJSONoutput_ct("SetPoint3") = rs("SetPoint3")
            fn_oJSONoutput_ct("SetPoint4") = rs("SetPoint4")
            fn_oJSONoutput_ct("SetPoint5") = rs("SetPoint5")

                
            rs.MoveNext
          Loop

      Else
        fn_oJSONoutput_ct("SetPoint1") = "0"
        fn_oJSONoutput_ct("SetPoint2") = "0"
        fn_oJSONoutput_ct("SetPoint3") = "0"
        fn_oJSONoutput_ct("SetPoint4") = "0"
        fn_oJSONoutput_ct("SetPoint5") = "0" 


      End If

      SetJumsu =  toJSON(fn_oJSONoutput_ct)

      rs.Close

  End Function  

  Set fn_oJSONoutput_LJumsu = jsArray()
  Set fn_oJSONoutput_RJumsu = jsArray()	

  fn_oJSONoutput_LJumsu = SetJumsu(DEC_GameLevelDtlIDX, DEC_TeamGameNum, DEC_GameNum, LTourneyGroupIDX)
  fn_oJSONoutput_RJumsu = SetJumsu(DEC_GameLevelDtlIDX, DEC_TeamGameNum, DEC_GameNum, RTourneyGroupIDX)	

  Set JSON_LJumsu = JSON.Parse(fn_oJSONoutput_LJumsu)
  Set JSON_RJumsu = JSON.Parse(fn_oJSONoutput_RJumsu)	

	'중복값확인
'	SQL = "select "
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	If Not rs.eof then
'		Call oJSONoutput.Set("result", "2" ) '중복
'		strjson = JSON.stringify(oJSONoutput)
'		Response.Write strjson
'		Response.write "`##`"
'		Response.End	
'	End if

	'스코어 보드 업데이트 또는 인서트
	'SQL = " update " 
	'Call db.execSQLRs(SQL , null, ConStr)

	'############
	
	'세트당 스코어 검색 ( 프론트 랑 동일하게 가져 와서)
	'SQL = "Select "
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

%><!-- #include virtual="/pub/inc/inc.scoreboard.asp" --><%

	db.Dispose
	Set db = Nothing
%>


<!--
<table>
	 <tr>
	  <td class="font_bold no_border">
		<%If SetNum = "" Then%>
	 	<a onclick='bm.EditResult(this.id, <%=strjson%>)'>Score</a>
		<%Else%>
		<a onclick='bm.EditResult(this.id, <%=strjson%>)'>[<%=SetNum%>세트 종료]</a>
		<%End If%>
	  </td></tr>
	 <tr><td class="border_top border_right border_left"><%=JSON_LJumsu.SetPoint1%> : <%=JSON_RJumsu.SetPoint1%></td></tr>
	 <tr><td class="border_right border_left"><%=JSON_LJumsu.SetPoint2%> : <%=JSON_RJumsu.SetPoint2%></td></tr>
	 <tr><td class="border_bottom border_right border_left"><%=JSON_LJumsu.SetPoint3%> : <%=JSON_RJumsu.SetPoint3%></td></tr>
</table>
-->