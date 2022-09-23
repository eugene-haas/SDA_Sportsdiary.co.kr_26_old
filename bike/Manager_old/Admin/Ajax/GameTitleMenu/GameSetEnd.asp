<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%

REQ = Request("Req")
'REQ = "{""CMD"":14,""GameLevelDtlIDX"":""1DDD4D380E095C6E78A222BA362D0FF7"",""TeamGameNum"":""D3510D3EEF159089CEE3710534553C12"",""GameNum"":""D3510D3EEF159089CEE3710534553C12"",""SetNum"":""4F0C40AE3DFDC66664FB7AC6C660689A"",""TourneyGroupIDX"":""854139A7AB66D8E58398B61A2C2DEAFA"",""Select_ResultPoint"":""11""}"

Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "GameLevelDtlIDX") = "ok" then
    If ISNull(oJSONoutput.GameLevelDtlIDX) Or oJSONoutput.GameLevelDtlIDX = "" Then
      GameLevelDtlIDX = ""
      DEC_GameLevelDtlIDX = ""
    Else
      GameLevelDtlIDX = fInject(oJSONoutput.GameLevelDtlIDX)
      DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameLevelDtlIDX))    
    End If
End if	

If hasown(oJSONoutput, "TeamGameNum") = "ok" then
    If ISNull(oJSONoutput.TeamGameNum) Or oJSONoutput.TeamGameNum = "" Then
      TeamGameNum = ""
      DEC_TeamGameNum = ""
    Else
      TeamGameNum = fInject(oJSONoutput.TeamGameNum)
      DEC_TeamGameNum = fInject(crypt.DecryptStringENC(oJSONoutput.TeamGameNum))    
    End If
End if	

If hasown(oJSONoutput, "GameNum") = "ok" then
    If ISNull(oJSONoutput.GameNum) Or oJSONoutput.GameNum = "" Then
      GameNum = ""
      DEC_GameNum = ""
    Else
      GameNum = fInject(oJSONoutput.GameNum)
      DEC_GameNum = fInject(crypt.DecryptStringENC(oJSONoutput.GameNum))    
    End If
End if	

If hasown(oJSONoutput, "SetNum") = "ok" then
    If ISNull(oJSONoutput.SetNum) Or oJSONoutput.SetNum = "" Then
      SetNum = ""
      DEC_SetNum = ""
    Else
      SetNum = fInject(oJSONoutput.SetNum)
      DEC_SetNum = fInject(crypt.DecryptStringENC(oJSONoutput.SetNum))    
    End If
End if	

If hasown(oJSONoutput, "TourneyGroupIDX") = "ok" then
    If ISNull(oJSONoutput.TourneyGroupIDX) Or oJSONoutput.TourneyGroupIDX = "" Then
      TourneyGroupIDX = ""
      DEC_TourneyGroupIDX = ""
    Else
      TourneyGroupIDX = fInject(oJSONoutput.TourneyGroupIDX)
      DEC_TourneyGroupIDX = fInject(crypt.DecryptStringENC(oJSONoutput.TourneyGroupIDX))    
    End If
End if	

If hasown(oJSONoutput, "GroupGameGb") = "ok" then
    If ISNull(oJSONoutput.GroupGameGb) Or oJSONoutput.GroupGameGb = "" Then
      GroupGameGb = ""
      DEC_GroupGameGb = ""
    Else
      GroupGameGb = fInject(oJSONoutput.GroupGameGb)
      DEC_GroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.GroupGameGb))    
    End If
End if	

If hasown(oJSONoutput, "Select_ResultPoint") = "ok" then
    If ISNull(oJSONoutput.Select_ResultPoint) Or oJSONoutput.Select_ResultPoint = "" Then
      Select_ResultPoint = ""
      DEC_Select_ResultPoint = ""
    Else
      Select_ResultPoint = fInject(oJSONoutput.Select_ResultPoint)
      DEC_Select_ResultPoint = fInject(crypt.DecryptStringENC(oJSONoutput.Select_ResultPoint))    
    End If
End if	


LSQL = "SELECT A.GameTitleIDX, A.TeamGb, A.Sex, B.Level, B.LevelDtlName, A.GroupGameGb, A.GameLevelIDX,"
LSQL = LSQL & " B.PlayLevelType, ISNULL(A.JooRank,0) AS JooRank, ISNULL(B.LevelJooNum,0) AS LevelJooNum"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameLevel A"
LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelidx = B.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    Do Until LRs.Eof

	    GameTitleIDX = LRs("GameTitleIDX")
      TeamGb = LRs("TeamGb")
      Sex = LRs("Sex")
      Level = LRs("Level")
      LevelDtlName = LRs("LevelDtlName")
      GroupGameGb = LRs("GroupGameGb")
      GameLevelIDX = LRs("GameLevelIDX")
      PlayLevelType = LRs("PlayLevelType")
      JooRank = LRs("JooRank")
      LevelJooNum = LRs("LevelJooNum")

      LRs.MoveNext
    Loop

Else
	Call oJSONoutput.Set("result", 1 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.END
End If


'선택한 팀 점수 COUNT
LSQL = "SELECT COUNT(*) AS SetResultCnt"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameResultDtl"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND GameNum = '" & DEC_GameNum & "'"
LSQL = LSQL & " AND SetNum = '" & DEC_SetNum & "'"
LSQL = LSQL & " AND TourneyGroupIDX = '" & DEC_TourneyGroupIDX & "'"


Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    RsCnt = LRs("SetResultCnt")

End If

LRs.Close

'선택안한팀 찾기
CSQL = "SELECT TourneyGroupIDX AS NoSelectIDX"
CSQL = CSQL & " FROM tblTourney "
CSQL = CSQL & " WHERE DelYN = 'N'"
CSQL = CSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"
CSQL = CSQL & " AND TourneyGroupIDX <> '" & DEC_TourneyGroupIDX & "'"

Set CRs = Dbcon.Execute(CSQL)

If Not (CRs.Eof Or CRs.Bof) Then

    NoSelectIDX = CRs("NoSelectIDX")

End If

CRs.Close

'선택한 팀 점수 COUNT
LSQL = "SELECT COUNT(*) AS SetResultCnt"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameResultDtl"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND GameNum = '" & DEC_GameNum & "'"
LSQL = LSQL & " AND SetNum = '" & DEC_SetNum & "'"
LSQL = LSQL & " AND TourneyGroupIDX = '" & NoSelectIDX & "'"


Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    NoSelectRsCnt = LRs("SetResultCnt")

End If

LRs.Close


  '기존 세트별포인트 점수 초기화
  CSQL = " UPDATE KoreaBadminton.dbo.tblGameSetResult SET"
  CSQL = CSQL & " DelYN = 'Y',"
  CSQL = CSQL & " SetEndEditDate = getdate()"
  CSQL = CSQL & " WHERE DelYN = 'N'"
  CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
  CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
  CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"
  CSQL = CSQL & " AND SetNum = '" & DEC_SetNum & "'"

  Dbcon.Execute(CSQL)

 
If Cint(RsCnt) > 0 Then

  '기존 세트별포인트 점수 초기화
  'CSQL = " UPDATE KoreaBadminton.dbo.tblGameSetResult SET"
  'CSQL = CSQL & " DelYN = 'Y',"
  'CSQL = CSQL & " SetEndEditDate = getdate()"
  'CSQL = CSQL & " WHERE DelYN = 'N'"
  'CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
  'CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
  'CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"
  'CSQL = CSQL & " AND SetNum = '" & DEC_SetNum & "'"
  'CSQL = CSQL & " AND TourneyGroupIDX = '" & DEC_TourneyGroupIDX & "'"

  'Dbcon.Execute(CSQL)

  '기존 상세포인트 점수 초기화
  CSQL = "UPDATE KoreaBadminton.dbo.tblGameResultDtl"
  CSQL = CSQL & " SET DelYN = 'Y',"
  CSQL = CSQL & " EditDate = GETDATE()"
  CSQL = CSQL & " WHERE DelYN = 'N'"
  CSQL = CSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
  CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
  CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"
  CSQL = CSQL & " AND SetNum = '" & DEC_SetNum & "'"
  CSQL = CSQL & " AND TourneyGroupIDX = '" & DEC_TourneyGroupIDX & "'"

  Dbcon.Execute(CSQL)


End If




If Select_ResultPoint <> "0" Then

  '이긴팀 상세포인트 점수넣기
  CSQL = "INSERT INTO KoreaBadminton.dbo.tblGameResultDtl"
  CSQL = CSQL & " ("
  CSQL = CSQL & " GameTitleIDX, GameLevelDtlidx, TeamGb, Sex, Level, "
  CSQL = CSQL & " LevelDtlName, GroupGameGb, TeamGameNum, GameNum, SetNum, "
  CSQL = CSQL & " TourneyGroupIDX, MemberIDX, ServeTourneyGroupIDX, ServeMemberIDX, RecieveTourneyGroupIDX, "
  CSQL = CSQL & " RecieveMemberIDX, JumsuGb, Jumsu, "
  CSQL = CSQL & " Pst_TourneyGroupIDX_L, Pst_MemberIDX_LL, Pst_MemberIDX_LR, Pst_TourneyGroupIDX_R, Pst_MemberIDX_RL, Pst_MemberIDX_RR,"
  CSQL = CSQL & " ServerPositionNum, AdminYN"
  CSQL = CSQL & " )"
  CSQL = CSQL & " VALUES"
  CSQL = CSQL & " ("
  CSQL = CSQL & " '" & GameTitleIDX & "', '" & DEC_GameLevelDtlIDX & "', '" & TeamGb & "', '" & Sex & "', '" & Level & "',"
  CSQL = CSQL & " '" & LevelDtlName & "', '" & GroupGameGb & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "', '" & DEC_SetNum & "',"
  CSQL = CSQL & " '" & DEC_TourneyGroupIDX & "', '0', '0', '0', '0',"
  CSQL = CSQL & " '0', '', '" & Select_ResultPoint & "',"
  CSQL = CSQL & " '0','0','0','0','0','0',"
  CSQL = CSQL & " '0', 'Y'"
  CSQL = CSQL & " )"

End If



Dbcon.Execute(CSQL)

If NoSelectRsCnt < 1 Then
'  '선택안한팀 상세포인트 점수넣기
'  CSQL = "INSERT INTO KoreaBadminton.dbo.tblGameResultDtl"
'  CSQL = CSQL & " ("
'  CSQL = CSQL & " GameTitleIDX, GameLevelDtlidx, TeamGb, Sex, Level, "
'  CSQL = CSQL & " LevelDtlName, GroupGameGb, TeamGameNum, GameNum, SetNum, "
'  CSQL = CSQL & " TourneyGroupIDX, MemberIDX, ServeTourneyGroupIDX, ServeMemberIDX, RecieveTourneyGroupIDX, "
'  CSQL = CSQL & " RecieveMemberIDX, JumsuGb, Jumsu, "
'  CSQL = CSQL & " Pst_TourneyGroupIDX_L, Pst_MemberIDX_LL, Pst_MemberIDX_LR, Pst_TourneyGroupIDX_R, Pst_MemberIDX_RL, Pst_MemberIDX_RR,"
'  CSQL = CSQL & " ServerPositionNum, AdminYN"
'  CSQL = CSQL & " )"
'  CSQL = CSQL & " VALUES"
'  CSQL = CSQL & " ("
'  CSQL = CSQL & " '" & GameTitleIDX & "', '" & DEC_GameLevelDtlIDX & "', '" & TeamGb & "', '" & Sex & "', '" & Level & "',"
'  CSQL = CSQL & " '" & LevelDtlName & "', '" & GroupGameGb & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "', '" & DEC_SetNum & "',"
'  CSQL = CSQL & " '" & NoSelectIDX & "', '0', '0', '0', '0',"
'  CSQL = CSQL & " '0', '', '0',"
'  CSQL = CSQL & " '0','0','0','0','0','0',"
'  CSQL = CSQL & " '0', 'Y'"
'  CSQL = CSQL & " )"
'
'  Dbcon.Execute(CSQL)
End If

CSQL = "INSERT INTO KoreaBadminton.dbo.tblGameSetResult("
CSQL = CSQL & " GameLevelDtlidx, GameTitleIDX, TeamGb, GroupGameGb,"
CSQL = CSQL & " Level, LevelDtlName, TeamGameNum, GameNum, SetNum,"
CSQL = CSQL & " TourneyGroupIDX, SetJumsu"
CSQL = CSQL & " )"

CSQL = CSQL & " SELECT A.GameLevelDtlIDX, A.GameTitleIDX, A.TeamGb, A.GroupGameGb,"
CSQL = CSQL & " A.Level, A.LevelDtlName, A.TeamGameNum, A.GameNum, '" & DEC_SetNum & "' AS SetNum,"
CSQL = CSQL & " A.TourneyGroupIDX, SUM(CONVERT(BIGINT,ISNULL(Jumsu,0))) AS SetJumsu"
CSQL = CSQL & " FROM KoreaBadminton.dbo.tblTourney A"
CSQL = CSQL & " LEFT JOIN "
CSQL = CSQL & " 	("
CSQL = CSQL & " 	SELECT GameLevelDtlIDX, GameTitleIDX, TeamGb, GroupGameGb,"
CSQL = CSQL & " 	Level, LevelDtlName, TeamGameNum, GameNum, SetNum,"
CSQL = CSQL & " 	TourneyGroupIDX, Jumsu"
CSQL = CSQL & " 	FROM KoreaBadminton.dbo.tblGameResultDtl"
CSQL = CSQL & " 	WHERE DelYN = 'N'"
CSQL = CSQL & " 	AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " 	AND TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " 	AND GameNum = '" & DEC_GameNum & "'"
CSQL = CSQL & " 	AND SetNum = '" & DEC_SetNum & "'"
CSQL = CSQL & " 	)"
CSQL = CSQL & " 	B ON A.GameLevelDtlIDX = B.GameLevelDtlIDX AND A.TeamGameNum = B.TeamGameNum AND A.GameNum = B.GameNum AND A.TourneyGroupIDX = B.TourneyGroupIDX"
CSQL = CSQL & " WHERE A.DelYN = 'N'"
CSQL = CSQL & " AND A.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
CSQL = CSQL & " AND A.TeamGameNum = '" & DEC_TeamGameNum & "'"
CSQL = CSQL & " AND A.GameNum = '" & DEC_GameNum & "'"
CSQL = CSQL & " GROUP BY A.GameLevelDtlIDX, A.GameTitleIDX, A.TeamGb, A.GroupGameGb, A.Level, A.LevelDtlName, A.TeamGameNum, A.GameNum, B.SetNum, A.TourneyGroupIDX"

Dbcon.Execute(CSQL)

Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()
  
%>