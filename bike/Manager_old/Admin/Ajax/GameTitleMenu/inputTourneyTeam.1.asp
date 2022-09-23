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
	Dim LSQL
	Dim LRs
	Dim strjson
	Dim strjson_sum

	Dim oJSONoutput_SUM
	Dim oJSONoutput

	Dim CMD  
	Dim GameTitleIDX 	

  REQ = Request("Req")
  'REQ = "{""CMD"":9,""tGameLevelDtlIDX"":""5DA8B97309D51CE41772A3CCBF968D9B"",""tTeamGameNum"":""2"",""tstr_LPlayerA"":""73DA0A0AA2FFFAD96C1DDA6F552CCCA6,950106A2FFEC7EE6E6E6CA10223FECE9,,"",""tstr_LPlayerB"":""329D6FF52B7CA1C2DA16CD0C25EF9DD1,A68EC4EAC56F7E127E68509F42D312E5,,"",""tstr_RPlayerA"":""2F3B2A29D1CEA0603BC86048C55E44E3,56005781737C6FB9FBE62D7F5C4A7DEC,,"",""tstr_RPlayerB"":""9D1961EFE1B9F7C0D746250BC6D3E333,,,""}"


  Set oJSONoutput = JSON.Parse(REQ)



  If hasown(oJSONoutput, "tGameLevelDtlIDX") = "ok" then
    GameLevelDtlIDX = fInject(oJSONoutput.tGameLevelDtlIDX)
    DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIDX))
  Else  
    GameLevelDtlIDX = ""
    DEC_GameLevelDtlIDX = ""
  End if	

	If hasown(oJSONoutput, "tTeamGameNum") = "ok" then
    If ISNull(oJSONoutput.tTeamGameNum) Or oJSONoutput.tTeamGameNum = "" Then
      TeamGameNum = ""
      DEC_TeamGameNum = ""
    Else
      TeamGameNum = fInject(oJSONoutput.tTeamGameNum)
      DEC_TeamGameNum = fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGameNum))    
    End If
  Else  
    TeamGameNum = ""
    DEC_TeamGameNum = ""
	End if	

	If hasown(oJSONoutput, "tstr_LPlayerA") = "ok" then
    If ISNull(oJSONoutput.tstr_LPlayerA) Or oJSONoutput.tstr_LPlayerA = "" Then
      str_LPlayerA = ""
    Else
      str_LPlayerA = fInject(oJSONoutput.tstr_LPlayerA)
    End If
  Else  
    str_LPlayerA = ""
	End if	

	If hasown(oJSONoutput, "tstr_LPlayerB") = "ok" then
    If ISNull(oJSONoutput.tstr_LPlayerB) Or oJSONoutput.tstr_LPlayerB = "" Then
      str_LPlayerB = ""
    Else
      str_LPlayerB = fInject(oJSONoutput.tstr_LPlayerB)
    End If
  Else  
    str_LPlayerB = ""
	End if	

	If hasown(oJSONoutput, "tstr_RPlayerA") = "ok" then
    If ISNull(oJSONoutput.tstr_RPlayerA) Or oJSONoutput.tstr_RPlayerA = "" Then
      str_RPlayerA = ""
    Else
      str_RPlayerA = fInject(oJSONoutput.tstr_RPlayerA)
    End If
  Else  
    str_RPlayerA = ""
	End if	

	If hasown(oJSONoutput, "tstr_RPlayerB") = "ok" then
    If ISNull(oJSONoutput.tstr_RPlayerB) Or oJSONoutput.tstr_RPlayerB = "" Then
      str_RPlayerB = ""
    Else
      str_RPlayerB = fInject(oJSONoutput.tstr_RPlayerB)
    End If
  Else  
    str_RPlayerB = ""
	End if	    

  Arr_LPlayerA = Split(str_LPlayerA, ",")
  Arr_LPlayerB = Split(str_LPlayerB, ",")
  Arr_RPlayerA = Split(str_RPlayerA, ",")
  Arr_RPlayerB = Split(str_RPlayerB, ",")


  LSQL = " SELECT A.GameTitleIDX, B.TEamGb, B.Level, A.LevelDtlName, B.Sex, B.GroupGameGb, A.TotRound, B.GameLevelIDX,"
  LSQL = LSQL & "  CASE WHEN TotRound = '512' THEN '9' "
  LSQL = LSQL & "  WHEN TotRound = '256' THEN '8' "
  LSQL = LSQL & "  WHEN TotRound = '128' THEN '7' "
  LSQL = LSQL & "  WHEN TotRound = '64' THEN '6' "
  LSQL = LSQL & "  WHEN TotRound = '32' THEN '5' "
  LSQL = LSQL & "  WHEN TotRound = '16' THEN '4' "
  LSQL = LSQL & "  WHEN TotRound = '8' THEN '3' "
  LSQL = LSQL & "  WHEN TotRound = '4' THEN '2' "
  LSQL = LSQL & "  WHEN TotRound = '2' THEN '1' "
  LSQL = LSQL & "  Else '0' END AS GangCnt"
  LSQL = LSQL & " FROM tblGameLevelDtl A"
  LSQL = LSQL & " INNER JOIN tblGameLevel B ON A.GameLevelidx = B.GameLevelIDX"
  LSQL = LSQL & " WHERE A.DelYN = 'N'"
  LSQL = LSQL & " AND B.DelYN = 'N'"
  LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"

  Set LRs = Dbcon.Execute(LSQL)  
  
  If Not (LRs.Eof Or LRs.Bof) Then
    GameTitleIDX = LRs("GameTitleIDX")
    TeamGb = LRs("TEamGb")
    Level = LRs("Level")
    LevelDtlName = LRs("LevelDtlName")     
    Sex = LRs("Sex") 
    GroupGameGb = LRs("GroupGameGb") 
    TotRound = LRs("TotRound") 
    GangCnt = LRs("GangCnt") 
    GameLevelIDX = LRs("GameLevelIDX") 
    
  End If

LSQL = " UPDATE tblTourneyPlayer SET DelYN = 'Y'"
LSQL = LSQL & " from tblTourneyPlayer A"
LSQL = LSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " INNER JOIN tblTourney C ON C.GameLevelDtlidx = B.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX"
LSQL = LSQL & " WHERE A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND C.TeamGameNum = '" & TeamGameNum & "'"
LSQL = LSQL & " AND A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND C.DelYN = 'N'"
Dbcon.Execute(LSQL)

LSQL = " UPDATE tblTourneyGroup SET DelYN = 'Y'"
LSQL = LSQL & " FROM tblTourneyGroup A"
LSQL = LSQL & " INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
LSQL = LSQL & " WHERE A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND B.TeamGameNum = '" & TeamGameNum & "'"
LSQL = LSQL & " AND A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
Dbcon.Execute(LSQL)

LSQL = " UPDATE tblTourney SET DelYN = 'Y', EditDate = getdate()"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
Dbcon.Execute(LSQL)

LSQL = " UPDATE tblGameResult SET DelYN = 'Y', EditDate = getdate()"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
Dbcon.Execute(LSQL)

LSQL = " UPDATE tblGameResultdtl SET DelYN = 'Y', EditDate = getdate()"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
Dbcon.Execute(LSQL)

LSQL = " UPDATE tblGameSetResult SET DelYN = 'Y', EditDate = getdate()"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
Dbcon.Execute(LSQL)

LSQL = " UPDATE tblGameSign SET DelYN = 'Y', EditDate = getdate()"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
Dbcon.Execute(LSQL)

LSQL = " UPDATE tblGroupGameResult SET DelYN = 'Y', EditDate = getdate()"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
Dbcon.Execute(LSQL)

  TourneyNum = 101
  ORDERBY = 0

  '왼쪽팀 대진표넣기
  If IsArray(Arr_LPlayerA) Then
    For i = 0 TO UBOUND(Arr_LPlayerA,1)
      If Arr_LPlayerA(i) <> "" OR Arr_LPlayerB(i) <> "" Then

        LSQL = " SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl"
        LSQL = LSQL & " FROM tblTorneyTeamTemp"
        LSQL = LSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "' "
        LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
        LSQL = LSQL & " AND GameNum = '" & i + 1 & "'"

        If Arr_LPlayerA(i) <> "" Then
          LSQL = LSQL & " AND GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_LPlayerA(i)) & "'"
        ElseIf Arr_LPlayerB(i) <> "" Then
          LSQL = LSQL & " AND GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_LPlayerA(i)) & "'"
        End If
        LSQL = LSQL & " AND DelYN = 'N'"



        SET LRs = Dbcon.Execute(LSQL)

        If Not (LRs.Eof Or LRs.Bof) Then

          CSQL = "SET NOCOUNT ON"
          CSQL = CSQL & " INSERT INTO dbo.tblTourneyGroup ("
          CSQL = CSQL & " GameTitleIDX, TeamGb, GameLevelDtlidx, Level, LevelDtlName, Team, TeamDtl, TourneyGroupNum"
          CSQL = CSQL & " )"
          CSQL = CSQL & " VALUES ("
          CSQL = CSQL & " '" & GameTitleIDX & "'"
          CSQL = CSQL & " ,'" & TeamGb & "'"
          CSQL = CSQL & " ,'" & DEC_GameLevelDtlIDX & "'"
          CSQL = CSQL & " ,'" & Level & "'"
          CSQL = CSQL & " ,'" & LevelDtlName & "'"
          CSQL = CSQL & " ,'" & LRs("Team") & "'"
          CSQL = CSQL & " ,'" & LRs("TeamDtl") & "'"
          CSQL = CSQL & " ,'" & TourneyGroupNum  & "'"
          CSQL = CSQL & " );"
          CSQL = CSQL & " SELECT @@IDENTITY AS IDX"        

          SET CRs = Dbcon.Execute(CSQL)

          If Not (CRs.Eof Or CRs.Bof) Then

            Do Until CRs.Eof
              TourneyGroupIDX = CRs("IDX")
              CRs.MoveNext            
            Loop

          End If      
          CRs.Close    
          
          LSQL = "SET NOCOUNT ON"
          LSQL = LSQL & " INSERT INTO dbo.tblTourneyPlayer"
          LSQL = LSQL & " ("
          LSQL = LSQL & " TourneyGroupIDX, MemberIDX, GameTitleIDX, UserName, TeamGb"
          LSQL = LSQL & " , GameLevelDtlidx, Level, LevelDtlName, Sex, MemberNum"
          LSQL = LSQL & " , CourtPosition, Team, TeamDtl, Team_Origin"
          LSQL = LSQL & " )"
          LSQL = LSQL & " SELECT '" & TourneyGroupIDX & "', A.MemberIDX, '" & GameTitleIDX & "', A.MemberName, '" & TeamGb & "'"
          LSQL = LSQL & " , A.GameLevelDtlIDX, '" & Level & "', '" & LevelDtlName & "', '" & Sex & "', 0"
          LSQL = LSQL & " , NULL, A.Team, A.TeamDtl, A.Team_Origin"
          LSQL = LSQL & " FROM tblTorneyTeamTemp A"
          LSQL = LSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLeveldtlIDX = A.GameLevelDtlIDX"
          LSQL = LSQL & " WHERE A.DelYN = 'N'"
          LSQL = LSQL & " AND B.DelYN = 'N'"
          'LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
          LSQL = LSQL & " AND B.GameLevelidx = '" & GameLevelIDX & "'"
          LSQL = LSQL & " AND A.TeamGameNum = '" & TeamGameNum & "'"
          LSQL = LSQL & " AND A.Gamenum = '" & i + 1 & "'"
          LSQL = LSQL & " AND A.GameRequestPlayerIDX IN  ( '" & crypt.DecryptStringENC(Arr_LPlayerA(i)) & "', '" & crypt.DecryptStringENC(Arr_LPlayerB(i)) & "')"            


          Dbcon.Execute(LSQL)

          ORDERBY = ORDERBY + 1
      
          LSQL = "INSERT INTO dbo.tblTourney("
          LSQL = LSQL & " TourneyGroupIDX, GameTitleIDX, GameLevelDtlidx, TeamGb, Level,"
          LSQL = LSQL & " LevelDtlName, GroupGameGb, TourneyNum, Round, TeamGameNum, GameNum, ORDERBY, GameLevelIDX"
          LSQL = LSQL & " )"
          LSQL = LSQL & " VALUES"
          LSQL = LSQL & " ("
          LSQL = LSQL & " '" & TourneyGroupIDX & "','" & GameTitleIDX & "', '" & DEC_GameLevelDtlIDX & "', '" & TeamGb & "', '" & Level & "',"
          LSQL = LSQL & " '" & LevelDtlName & "','" & GroupGameGb & "', '" & TourneyNum & "', '1', '" & TeamGameNum & "', '" & i + 1 & "', '" & ORDERBY & "','" & GameLevelIDX & "'"
          LSQL = LSQL & " )"

          Dbcon.Execute(LSQL)

          '상대팀이 부전이어도 경기는 넣어줌
          If Arr_RPlayerA(i) = "" AND Arr_RPlayerB(i) = "" Then

            ORDERBY = ORDERBY + 1

            LSQL = "INSERT INTO dbo.tblTourney("
            LSQL = LSQL & " TourneyGroupIDX, GameTitleIDX, GameLevelDtlidx, TeamGb, Level,"
            LSQL = LSQL & " LevelDtlName, GroupGameGb, TourneyNum, Round, TeamGameNum, GameNum, ORDERBY, GameLevelIDX"
            LSQL = LSQL & " )"
            LSQL = LSQL & " VALUES"
            LSQL = LSQL & " ("
            LSQL = LSQL & " '0','" & GameTitleIDX & "', '" & DEC_GameLevelDtlIDX & "', '" & TeamGb & "', '" & Level & "',"
            LSQL = LSQL & " '" & LevelDtlName & "','" & GroupGameGb & "', NULL, '1', '" & TeamGameNum & "', '" & i + 1 & "', '" & ORDERBY & "', '" & GameLevelIDX & "'"
            LSQL = LSQL & " )"

            Dbcon.Execute(LSQL)          
          End If
          
        End If          

      End If

      TourneyNum = TourneyNum +1
      
    Next
  End If

  '오른쪽팀 대진표넣기
  If IsArray(Arr_RPlayerA) Then
    For i = 0 TO UBOUND(Arr_RPlayerA,1)
      If Arr_RPlayerA(i) <> "" OR Arr_RPlayerB(i) <> "" Then      

        LSQL = " SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl"
        LSQL = LSQL & " FROM tblTorneyTeamTemp"
        LSQL = LSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "' "
        LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
        LSQL = LSQL & " AND GameNum = '" & i + 1 & "'"

        If Arr_RPlayerA(i) <> "" Then
          LSQL = LSQL & " AND GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_RPlayerA(i)) & "'"
        ElseIf Arr_RPlayerB(i) <> "" Then
          LSQL = LSQL & " AND GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_RPlayerA(i)) & "'"
        End If
        LSQL = LSQL & " AND DelYN = 'N'"



        SET LRs = Dbcon.Execute(LSQL)

        If Not (LRs.Eof Or LRs.Bof) Then

          '상대팀이 부전이어도 경기는 넣어줌
          If Arr_LPlayerA(i) = "" AND Arr_LPlayerB(i) = "" Then

            ORDERBY = ORDERBY + 1

            LSQL = "INSERT INTO dbo.tblTourney("
            LSQL = LSQL & " TourneyGroupIDX, GameTitleIDX, GameLevelDtlidx, TeamGb, Level,"
            LSQL = LSQL & " LevelDtlName, GroupGameGb, TourneyNum, Round, TeamGameNum, GameNum, ORDERBY, GameLevelIDX"
            LSQL = LSQL & " )"
            LSQL = LSQL & " VALUES"
            LSQL = LSQL & " ("
            LSQL = LSQL & " '0','" & GameTitleIDX & "', '" & DEC_GameLevelDtlIDX & "', '" & TeamGb & "', '" & Level & "',"
            LSQL = LSQL & " '" & LevelDtlName & "','" & GroupGameGb & "', NULL, '1', '" & TeamGameNum & "', '" & i + 1 & "', '" & ORDERBY & "', '" & GameLevelIDX & "'"
            LSQL = LSQL & " )"

            Dbcon.Execute(LSQL)          
          End If          


          CSQL = "SET NOCOUNT ON"
          CSQL = CSQL & " INSERT INTO dbo.tblTourneyGroup ("
          CSQL = CSQL & " GameTitleIDX, TeamGb, GameLevelDtlidx, Level, LevelDtlName, Team, TeamDtl, TourneyGroupNum"
          CSQL = CSQL & " )"
          CSQL = CSQL & " VALUES ("
          CSQL = CSQL & " '" & GameTitleIDX & "'"
          CSQL = CSQL & " ,'" & TeamGb & "'"
          CSQL = CSQL & " ,'" & DEC_GameLevelDtlIDX & "'"
          CSQL = CSQL & " ,'" & Level & "'"
          CSQL = CSQL & " ,'" & LevelDtlName & "'"
          CSQL = CSQL & " ,'" & LRs("Team") & "'"
          CSQL = CSQL & " ,'" & LRs("TeamDtl") & "'"
          CSQL = CSQL & " ,'" & TourneyGroupNum  & "'"
          CSQL = CSQL & " );"
          CSQL = CSQL & " SELECT @@IDENTITY AS IDX"        

          SET CRs = Dbcon.Execute(CSQL)

          If Not (CRs.Eof Or CRs.Bof) Then

            Do Until CRs.Eof
              TourneyGroupIDX = CRs("IDX")
              CRs.MoveNext            
            Loop

          End If      
          CRs.Close    

          LSQL = "SET NOCOUNT ON"
          LSQL = LSQL & " INSERT INTO dbo.tblTourneyPlayer"
          LSQL = LSQL & " ("
          LSQL = LSQL & " TourneyGroupIDX, MemberIDX, GameTitleIDX, UserName, TeamGb"
          LSQL = LSQL & " , GameLevelDtlidx, Level, LevelDtlName, Sex, MemberNum"
          LSQL = LSQL & " , CourtPosition, Team, TeamDtl, Team_Origin"
          LSQL = LSQL & " )"
          LSQL = LSQL & " SELECT '" & TourneyGroupIDX & "', A.MemberIDX, '" & GameTitleIDX & "', A.MemberName, '" & TeamGb & "'"
          LSQL = LSQL & " , A.GameLevelDtlIDX, '" & Level & "', '" & LevelDtlName & "', '" & Sex & "', 0"
          LSQL = LSQL & " , NULL, A.Team, A.TeamDtl, A.Team_Origin"
          LSQL = LSQL & " FROM tblTorneyTeamTemp A"
          LSQL = LSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLeveldtlIDX = A.GameLevelDtlIDX"
          LSQL = LSQL & " WHERE A.DelYN = 'N'"
          LSQL = LSQL & " AND B.DelYN = 'N'"
          'LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
          LSQL = LSQL & " AND B.GameLevelidx = '" & GameLevelIDX & "'"
          LSQL = LSQL & " AND A.TeamGameNum = '" & TeamGameNum & "'"
          LSQL = LSQL & " AND A.Gamenum = '" & i + 1 & "'"
          LSQL = LSQL & " AND A.GameRequestPlayerIDX IN  ( '" & crypt.DecryptStringENC(Arr_RPlayerA(i)) & "', '" & crypt.DecryptStringENC(Arr_RPlayerB(i)) & "')"  



          Dbcon.Execute(LSQL)

          ORDERBY = ORDERBY + 1

          LSQL = "INSERT INTO dbo.tblTourney("
          LSQL = LSQL & " TourneyGroupIDX, GameTitleIDX, GameLevelDtlidx, TeamGb, Level,"
          LSQL = LSQL & " LevelDtlName, GroupGameGb, TourneyNum, Round, TeamGameNum, GameNum, ORDERBY, GameLevelIDX"
          LSQL = LSQL & " )"
          LSQL = LSQL & " VALUES"
          LSQL = LSQL & " ("
          LSQL = LSQL & " '" & TourneyGroupIDX & "','" & GameTitleIDX & "', '" & DEC_GameLevelDtlIDX & "', '" & TeamGb & "', '" & Level & "',"
          LSQL = LSQL & " '" & LevelDtlName & "','" & GroupGameGb & "', '" & TourneyNum & "', '1', '" & TeamGameNum & "', '" & i + 1 & "', '" & ORDERBY & "','" & GameLevelIDX & "'"
          LSQL = LSQL & " )"

          Dbcon.Execute(LSQL)



          
        End If          

      End If

      TourneyNum = TourneyNum + 1

    Next
  End If



'  LSQL = " SELECT dbo.FN_NameSch(Sex,'pubcode') AS SexNM, dbo.FN_NameSch(GameType,'pubcode') AS GameTypeNM, ORDERBY"
'  LSQL = LSQL & " FROM tblGroupGameOrder"
'  LSQL = LSQL & " WHERE DelYN = 'N'"
'  LSQL = LSQL & " AND GameLevelIDX = '" & GameLevelIDX & "'"  
'
'  SET LRs = Dbcon.Execute(LSQL)
'
'  i = 0
'
'  If Not (LRs.Eof Or LRs.Bof) Then
'
'	  Do Until LRs.Eof
'
'        i = i + 1
'      LRs.MoveNext            
'    Loop
'
'  End If       

  Call oJSONoutput.Set("result", 0 )
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson


Set LRs = Nothing
DBClose()
  
%>