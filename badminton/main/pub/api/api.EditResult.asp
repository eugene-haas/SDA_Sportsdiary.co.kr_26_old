
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


	'DEC_Point_TourneyGroupIDX = 1434
	'NextServeMemberIDX = 	358




LSQL = "SELECT COUNT(*) AS SetResultCnt"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameSetResult"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND GameNum = '" & DEC_GameNum & "'"
LSQL = LSQL & " AND SetNum = '" & SetNum & "'"

Set LRs = db.ExecSQLReturnRS(LSQL , null, ConStr)

If Not (LRs.Eof Or LRs.Bof) Then

    RsCnt = LRs("SetResultCnt")

End If

LRs.Close



 
If Cint(RsCnt) > 0 Then

CSQL = " UPDATE KoreaBadminton.dbo.tblGameSetResult SET"
CSQL = CSQL & " DelYN = 'Y'"
CSQL = CSQL & " WHERE DelYN = 'N'"
CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"
CSQL = CSQL & " AND SetNum = '" & SetNum & "'"

Call db.execSQLRs(CSQL , null, ConStr)


End If

CSQL = "INSERT INTO KoreaBadminton.dbo.tblGameSetResult("
CSQL = CSQL & " GameLevelDtlidx, GameTitleIDX, TeamGb, GroupGameGb,"
CSQL = CSQL & " Level, LevelDtlName, TeamGameNum, GameNum, SetNum,"
CSQL = CSQL & " TourneyGroupIDX, SetJumsu"
CSQL = CSQL & " )"

CSQL = CSQL & " SELECT A.GameLevelDtlIDX, A.GameTitleIDX, A.TeamGb, A.GroupGameGb,"
CSQL = CSQL & " A.Level, A.LevelDtlName, A.TeamGameNum, A.GameNum, '" & SetNum & "' AS SetNum,"
CSQL = CSQL & " A.TourneyGroupIDX, SUM(CONVERT(BIGINT,ISNULL(Jumsu,0))) AS SetJumsu"
CSQL = CSQL & " FROM KoreaBadminton.dbo.tblTourney A"
CSQL = CSQL & " LEFT JOIN "
CSQL = CSQL & " 	("
CSQL = CSQL & " 	SELECT GameLevelDtlIDX, GameTitleIDX, TeamGb, GroupGameGb,"
CSQL = CSQL & " 	Level, LevelDtlName, TeamGameNum, GameNum, SetNum,"
CSQL = CSQL & " 	TourneyGroupIDX, dbo.FN_NameSch(JumsuGb,'PubJumsu') AS Jumsu"
CSQL = CSQL & " 	FROM KoreaBadminton.dbo.tblGameResultDtl"
CSQL = CSQL & " 	WHERE DelYN = 'N'"
CSQL = CSQL & " 	AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " 	AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " 	AND GameNum = '" & DEC_GameNum & "'"
CSQL = CSQL & " 	AND SetNum = '" & SetNum & "'"
CSQL = CSQL & " 	)"
CSQL = CSQL & " 	B ON A.GameLevelDtlIDX = B.GameLevelDtlIDX AND A.TeamGameNum = B.TeamGameNum AND A.GameNum = B.GameNum AND A.TourneyGroupIDX = B.TourneyGroupIDX"
CSQL = CSQL & " WHERE A.DelYN = 'N'"
CSQL = CSQL & " AND A.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND A.TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND A.GameNum = '" & DEC_GameNum & "'"
CSQL = CSQL & " GROUP BY A.GameLevelDtlIDX, A.GameTitleIDX, A.TeamGb, A.GroupGameGb, A.Level, A.LevelDtlName, A.TeamGameNum, A.GameNum, B.SetNum, A.TourneyGroupIDX"

Call db.execSQLRs(CSQL , null, ConStr)

%>
