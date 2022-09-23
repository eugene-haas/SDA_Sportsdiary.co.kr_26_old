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

  'REQ = Request("Req")
  REQ = "{""CMD"":9,""tGameLevelDtlIDX"":""D699A4D046D9389A5B28ACBEC4075BBD"",""tTeamGameNum"":""8"",""tstr_LPlayerA"":""FDC7AB6628302C27845B86EABC28B5F9,B4AA109D74E75539EBA0EBC05F982012,,,"",""tstr_LPlayerB"":""7761A807F78B1CEFD0A0F3C4AFDDAE76,FDC7AB6628302C27845B86EABC28B5F9,,,"",""tstr_RPlayerA"":""E93A4E6217EA4C8188DB6173B22D7919,E5F41562AE22B64D74AC07177E83D142,,,"",""tstr_RPlayerB"":""5BB948A04B983D8C3A488066EC6A15C3,,,,""}"


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

  LRs.Close
  Response.Write "LSQL : " & LSQL & "<BR/>"
  
  LSQL = " SELECT A.Team AS LTeam, A.TeamDtl AS LTeamDtl, B.Team AS RTeam, B.TeamDtl AS RTeamDtl,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM, "
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS RTeamNM,"
  LSQL = LSQL & " D.GameLevelIDX"
  LSQL = LSQL & " FROM tblTourneyTeam A"
  LSQL = LSQL & " INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
  LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
  LSQL = LSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
  LSQL = LSQL & " LEFT JOIN ("
  LSQL = LSQL & "   SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu"
  LSQL = LSQL & "   FROM KoreaBadminton.dbo.tblGroupGameResult"
  LSQL = LSQL & "   WHERE DelYN = 'N'"
  LSQL = LSQL & "   ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
  LSQL = LSQL & " WHERE A.DelYN = 'N'"
  LSQL = LSQL & " AND B.DelYN = 'N'"
  LSQL = LSQL & " AND A.ORDERBY < B.ORDERBY"
  LSQL = LSQL & " AND A.GameLevelDtlIDX  = '" & DEC_GameLevelDtlIDX & "'"
  LSQL = LSQL & " AND A.TeamGameNum = '" & TeamGameNum & "'"
   Response.Write "LSQL : " & LSQL & "<BR/>"
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
    LTeam = LRs("LTeam")
    LTeamDtl = LRs("LTeamDtl")
    LTeamNM = LRs("LTeamNM")
    RTeam = LRs("RTeam")
    RTeamDtl = LRs("RTeamDtl")
    RTeamNM = LRs("RTeamNM")
    
    GameLevelIDX = LRs("GameLevelIDX")
  End If  
  
'LSQL = " UPDATE tblTourneyPlayer SET DelYN = 'Y'"
'LSQL = LSQL & " from tblTourneyPlayer A"
'LSQL = LSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
'LSQL = LSQL & " INNER JOIN tblTourney C ON C.GameLevelDtlidx = B.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX"
'LSQL = LSQL & " WHERE A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND C.TeamGameNum = '" & TeamGameNum & "'"
'LSQL = LSQL & " AND A.DelYN = 'N'"
'LSQL = LSQL & " AND B.DelYN = 'N'"
'LSQL = LSQL & " AND C.DelYN = 'N'"
'Dbcon.Execute(LSQL)
'
'LSQL = " UPDATE tblTourneyGroup SET DelYN = 'Y'"
'LSQL = LSQL & " FROM tblTourneyGroup A"
'LSQL = LSQL & " INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
'LSQL = LSQL & " WHERE A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND B.TeamGameNum = '" & TeamGameNum & "'"
'LSQL = LSQL & " AND A.DelYN = 'N'"
'LSQL = LSQL & " AND B.DelYN = 'N'"
'Dbcon.Execute(LSQL)
'
'LSQL = " UPDATE tblTourney SET DelYN = 'Y', EditDate = getdate()"
'LSQL = LSQL & " WHERE DelYN = 'N'"
'LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
'Dbcon.Execute(LSQL)
'
'LSQL = " UPDATE tblGameResult SET DelYN = 'Y', EditDate = getdate()"
'LSQL = LSQL & " WHERE DelYN = 'N'"
'LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
'Dbcon.Execute(LSQL)
'
'LSQL = " UPDATE tblGameResultdtl SET DelYN = 'Y', EditDate = getdate()"
'LSQL = LSQL & " WHERE DelYN = 'N'"
'LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
'Dbcon.Execute(LSQL)
'
'LSQL = " UPDATE tblGameSetResult SET DelYN = 'Y', EditDate = getdate()"
'LSQL = LSQL & " WHERE DelYN = 'N'"
'LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
'Dbcon.Execute(LSQL)
'
'LSQL = " UPDATE tblGameSign SET DelYN = 'Y', EditDate = getdate()"
'LSQL = LSQL & " WHERE DelYN = 'N'"
'LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
'Dbcon.Execute(LSQL)
'
'LSQL = " UPDATE tblGroupGameResult SET DelYN = 'Y', EditDate = getdate()"
'LSQL = LSQL & " WHERE DelYN = 'N'"
'LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
'LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
'Dbcon.Execute(LSQL)





  TourneyNum = 101
  ORDERBY = 0

  '왼쪽팀 대진표넣기
  If IsArray(Arr_LPlayerA) Then
    For i = 0 TO UBOUND(Arr_LPlayerA,1)

      If Arr_LPlayerA(i) <> "" OR Arr_LPlayerB(i) <> "" Then

        'ORDERBY 오름차순 정렬하여 왼쪽팀 TourneyGroupIDX 가져옴
        LSQL = " SELECT TOP 1 TourneyGroupIDX"
        LSQL = LSQL & " FROM tbltourney "
        LSQL = LSQL & " WHERE DelYN = 'N'"
        LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
        LSQL = LSQL & " AND TeamGameNum='" & TeamGameNum & "'	"
        LSQL = LSQL & " AND GameNum = '" & i + 1 & "'"  
        LSQL = LSQL & " ORDER BY ORDERBY ASC"  

        SET LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          LTourneyGroupIDX = LRs("TourneyGroupIDX")
          LTourneyData = "Y"
        Else
          LTourneyGroupIDX = ""
          LTourneyData = "N"
        End If

        LRs.Close


        'TourneyTEmp에 왼오 두선수중 한선수라도 있으면..
        LSQL = " SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, MemberIDX"
        LSQL = LSQL & " FROM tblTorneyTeamTemp"
        LSQL = LSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "' "
        LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
        LSQL = LSQL & " AND GameNum = '" & i + 1 & "'"

        If Arr_LPlayerA(i) <> "" Then
          LSQL = LSQL & " AND GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_LPlayerA(i)) & "'"
        ElseIf Arr_LPlayerB(i) <> "" Then
          LSQL = LSQL & " AND GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_LPlayerB(i)) & "'"
        End If
        LSQL = LSQL & " AND DelYN = 'N'"     


        'Response.Write LTourneyData
        'Response.END

        SET LRs = Dbcon.Execute(LSQL)

        If Not (LRs.Eof Or LRs.Bof) Then


          '대진표가 있으면 있는대진표의 TourneyGroupIDX를 가져옴
          If LTourneyData = "Y" Then

            TourneyGroupIDX = LTourneyGroupIDX

          Else

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

          End If 

          ORDERBY = ORDERBY + 1



          '기존 대진표가 없으면 넣어줌
          If LTourneyData = "N" Then
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
          '기존대진표가 있으면 결과 UPDATE
          Else

            '새로 등록되는 선수들을 각자
            'CSQL = " SELECT MemberIDX "
            'CSQL = CSQL & " from tblTourneyPlayer A"
            'CSQL = CSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
            'CSQL = CSQL & " INNER JOIN tblTourney C ON C.GameLevelDtlidx = B.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX"
            'CSQL = CSQL & " WHERE A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
            'CSQL = CSQL & " AND C.TeamGameNum = '" & TeamGameNum & "'"
            'CSQL = CSQL & " AND C.GameNum = '" & i + 1 & "'"
            'CSQL = CSQL & " AND A.DelYN = 'N'"
            'CSQL = CSQL & " AND B.DelYN = 'N'"
            'CSQL = CSQL & " AND C.DelYN = 'N'"
            'CSQL = CSQL & " AND ("
            'CSQL = CSQL & " MemberIDX = '" & crypt.DecryptStringENC(Arr_LPlayerA(i)) & "'"
            'CSQL = CSQL & " OR MemberIDX = '" & crypt.DecryptStringENC(Arr_LPlayerB(i)) & "'"
            'CSQL = CSQL & " )"  

            'CSQL = " SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, MemberIDX"
            'CSQL = CSQL & " FROM tblTorneyTeamTemp"
            'CSQL = CSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "' "
            'CSQL = CSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
            'CSQL = CSQL & " AND GameNum = '" & i + 1 & "'"
            'CSQL = CSQL & " AND ("
            'CSQL = CSQL & " GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_LPlayerA(i)) & "'"
            'CSQL = CSQL & " OR GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_LPlayerB(i)) & "'"
            'CSQL = CSQL & " ) "              
            'CSQL = CSQL & " AND DelYN = 'N'"   

            'CSQL = " SELECT A.MemberIDX, D.GameRequestPlayerIDX"
            'CSQL = CSQL & " from tblTourneyPlayer A"
            'CSQL = CSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
            'CSQL = CSQL & " INNER JOIN tblTourney C ON C.GameLevelDtlidx = B.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX"
            'CSQL = CSQL & " INNER JOIN tblTorneyTeamTemp D ON D.GameLevelDtlidx = C.GameLevelDtlIDX AND D.TeamGameNum = C.TeamGameNum AND D.Gamenum = C.GameNum AND D.MemberIDX = A.MemberIDX"
            'CSQL = CSQL & " WHERE A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
            'CSQL = CSQL & " AND C.TeamGameNum = '" & TeamGameNum & "'"
            'CSQL = CSQL & " AND C.GameNum = '" & i + 1 & "' "
            'CSQL = CSQL & " AND A.DelYN = 'N'"
            'CSQL = CSQL & " AND B.DelYN = 'N'"
            'CSQL = CSQL & " AND C.DelYN = 'N'"
            'CSQL = CSQL & " AND D.DelYN = 'N'"   

            CSQL = " SELECT A.MemberIDX, GameRequestPlayerIDX"
            CSQL = CSQL & " FROM tblTourneyPlayer A "
            CSQL = CSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX "
            CSQL = CSQL & " INNER JOIN tblTourney C ON C.GameLevelDtlidx = B.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX "
            CSQL = CSQL & " INNER JOIN"
            CSQL = CSQL & " ("
            CSQL = CSQL & " SELECT D.GameLevelDtlidx, A.MemberIDX, C.TEam, C.TeamDtl, GameRequestPlayerIDX "
            CSQL = CSQL & " FROM tblGameRequestPlayer A"
            CSQL = CSQL & " INNER JOIN tblGameRequestGroup B ON B.GameRequestGroupIDX = A.GameRequestGroupIDX"
            CSQL = CSQL & " INNER JOIN tblGameRequestTeam C ON C.GameRequestTeamIDX = A.GameRequestTeamIDX"
            CSQL = CSQL & " INNER JOIN tblGameRequestTouney D ON D.RequestIDX = C.GameRequestTeamIDX AND D.GroupGameGb = 'B0030002'"
            CSQL = CSQL & " WHERE A.DelYN = 'N'"
            CSQL = CSQL & " AND B.DelYN = 'N'"
            CSQL = CSQL & " AND C.DelYN = 'N'"
            CSQL = CSQL & " AND D.DelYN = 'N'"
            CSQL = CSQL & " AND D.GameLeveldtlidx = '" & DEC_GameLevelDtlIDX & "'"
            CSQL = CSQL & " ) DD ON  DD.GameLevelDtlidx = C.GameLevelDtlidx AND DD.MemberIDX = A.MemberIDX"
            CSQL = CSQL & " WHERE A.gameleveldtlidx = '" & DEC_GameLevelDtlIDX & "'"
            CSQL = CSQL & " AND C.DelYN = 'N'"
            CSQL = CSQL & " AND C.TeamGAmeNum = '" & TeamGameNum & "'"
            CSQL = CSQL & " AND C.Gamenum = '" & i + 1 & "'"
            CSQL = CSQL & " AND DD.Team = '" & LTeam & "'"
            CSQL = CSQL & " AND DD.Teamdtl = '" & LTeamDtl & "'"
            CSQL = CSQL & " AND A.DelYN = 'N'"
            CSQL = CSQL & " AND B.DelYN = 'N'"
            CSQL = CSQL & " AND C.DelYN = 'N'"  

            
            'REsponse.write "CSQL: "& CSQL & "<BR> <BR> <BR>"

            'CSQL = CSQL & " AND ("
            'CSQL = CSQL & " GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_LPlayerA(i)) & "'"
            'CSQL = CSQL & " OR GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_LPlayerB(i)) & "'"
            'CSQL = CSQL & " ) "    


            'Response.Write "CSQL:" &  CSQL & "<BR><BR><BR>"            

            SET CRs = Dbcon.Execute(CSQL)

            If Not (CRs.Eof Or CRs.Bof) Then

              Do Until CRs.Eof

                oldplayerCnt = 0
                oldplayer = ""

                If oldplayerCnt = 0 Then
                  oldplayer = crypt.DecryptStringENC(Arr_LPlayerA(i))
                Else
                  oldplayer = crypt.DecryptStringENC(Arr_LPlayerB(i))
                End If


                NSQL = "SELECT MemberIDX"
                NSQL = NSQL & " FROM tblTorneyTeamTemp"
                NSQL = NSQL & " WHERE DelYN = 'N'"
                NSQL = NSQL & " AND GameLeveldtlIDX = '" & DEC_GameLevelDtlIDX & "'"
                NSQL = NSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
                NSQL = NSQL & " AND GameNum = '" & i + 1 & "'"
                NSQL = NSQL & " AND GameRequestPlayerIDX = '" & oldplayer & "'"

                SET NRs = Dbcon.Execute(NSQL)

                If Not (CRs.Eof Or CRs.Bof) Then
                  oldplayer_MemberIDX = NRs("MemberIDX")
                Else
                  oldplayer_MemberIDX = "0"
                End If

                NRs.Close


                  ''asdkaskasdkasd
                  'If CStr(CRs("GameRequestPlayerIDX")) <> oldplayer Then
                    '새로운선수에게 점수 이관 작업필수
                    'MSQL = " UPDATE tblGameResultDtl SET "
                    'MSQL = MSQL & " ServeMemberIDX = CASE WHEN ServeMemberIDX = '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE ServeMemberIDX END, "
                    'MSQL = MSQL & " RecieveMemberIDX = CASE WHEN RecieveMemberIDX = '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE RecieveMemberIDX END, "
                    'MSQL = MSQL & " Pst_MemberIDX_LL = CASE WHEN Pst_MemberIDX_LL = '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE Pst_MemberIDX_LL END, "
                    'MSQL = MSQL & " Pst_MemberIDX_LR = CASE WHEN Pst_MemberIDX_LR = '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE Pst_MemberIDX_LR END, "
                    'MSQL = MSQL & " Pst_MemberIDX_RL = CASE WHEN Pst_MemberIDX_RL = '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE Pst_MemberIDX_RL END, "
                    'MSQL = MSQL & " Pst_MemberIDX_RR = CASE WHEN Pst_MemberIDX_RR = '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE Pst_MemberIDX_RR END "
                    'MSQL = MSQL & " WHERE DelYN = 'N' "
                    'MSQL = MSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "' "
                    'MSQL = MSQL & " AND TeamGameNum = '" & TeamGameNum & "' "
                    'MSQL = MSQL & " AND GameNum = '" & i + 1 & "' "
                    'Dbcon.Execute(MSQL)   

                 

                    MSQL = " UPDATE tblTourneyPlayer SET DelYN = 'Y'"
                    MSQL = MSQL & " from tblTourneyPlayer A"
                    MSQL = MSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
                    MSQL = MSQL & " INNER JOIN tblTourney C ON C.GameLevelDtlidx = B.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX"
                    MSQL = MSQL & " WHERE A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
                    MSQL = MSQL & " AND C.TeamGameNum = '" & TeamGameNum & "'"
                    MSQL = MSQL & " AND C.GameNum = '" & i + 1 & "' "
                    MSQL = MSQL & " AND A.MemberIDX = '" & CRs("MemberIDX") & "' "
                    MSQL = MSQL & " AND A.DelYN = 'N'"
                    MSQL = MSQL & " AND B.DelYN = 'N'"
                    MSQL = MSQL & " AND C.DelYN = 'N'"
                    Dbcon.Execute(MSQL)     
                    'REsponse.write "22222222: "& MSQL & "<BR> <BR> <BR>"


                  'End If 

                  'Response.WriteResponse.Write "MSQL:" & MSQL & "<BR><BR><BR>"
           
                  
                             
                          
                  oldplayerCnt = oldplayerCnt + 1

                CRs.MoveNext     
              Loop

            End If      
            CRs.Close                      

            'LSQL = " UPDATE tblGameResultdtl SET DelYN = 'Y', EditDate = getdate()"
            'LSQL = LSQL & " WHERE DelYN = 'N'"
            'LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
            'LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
            'Dbcon.Execute(LSQL)

          End If          
          
          '대진표없으면 새로생성된 TourneyGroupIDX로 선수를 넣어주고
          '대진표있으면 기존 TourneyGroupIDX로 선수를 넣어줌
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

          'REsponse.write "33333333: "& LSQL & "<BR> <BR> <BR>"
          

          Dbcon.Execute(LSQL)

          'Response.Write "LSQL:" &  LSQL & "<BR><BR><BR>"

          
        End If   
    
















      End If

      TourneyNum = TourneyNum +1
      
    Next

           
  End If

  '오른쪽팀 대진표넣기
  If IsArray(Arr_RPlayerA) Then
    For i = 0 TO UBOUND(Arr_RPlayerA,1)

      If Arr_RPlayerA(i) <> "" OR Arr_RPlayerB(i) <> "" Then      

        LSQL = " SELECT COUNT(*) AS Cnt"
        LSQL = LSQL & " FROM tbltourney "
        LSQL = LSQL & " WHERE DelYN = 'N'"
        LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
        LSQL = LSQL & " AND TeamGameNum='" & TeamGameNum & "'	"
        LSQL = LSQL & " AND GameNum = '" & i + 1 & "'"  
        SET LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          RTourneyCount = LRs("Cnt")
        Else
          RTourneyCount = 0
        End If  
        LRs.Close      

        'ORDERBY 오름차순 정렬하여 왼쪽팀 TourneyGroupIDX 가져옴
        LSQL = " SELECT TOP 1 TourneyGroupIDX"
        LSQL = LSQL & " FROM tbltourney "
        LSQL = LSQL & " WHERE DelYN = 'N'"
        LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
        LSQL = LSQL & " AND TeamGameNum='" & TeamGameNum & "'	"
        LSQL = LSQL & " AND GameNum = '" & i + 1 & "'"  
        LSQL = LSQL & " ORDER BY ORDERBY DESC"  

        'Response.Write "LSQL:" &  LSQL & "<BR><BR><BR>"
        

        SET LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          RTourneyGroupIDX = LRs("TourneyGroupIDX")
          RTourneyData = "Y"
        Else
          RTourneyGroupIDX = ""
          RTourneyData = "N"
        End If
        
        LRs.Close

        If RTourneyData = "Y" AND RTourneyCount > 1 Then
          RTourneyData = "Y"
        Else
          RTourneyData = "N"
        End If


        LSQL = " SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, MemberIDX"
        LSQL = LSQL & " FROM tblTorneyTeamTemp"
        LSQL = LSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "' "
        LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
        LSQL = LSQL & " AND GameNum = '" & i + 1 & "'"

        If Arr_RPlayerA(i) <> "" Then
          LSQL = LSQL & " AND GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_RPlayerA(i)) & "'"
        ElseIf Arr_RPlayerB(i) <> "" Then
          LSQL = LSQL & " AND GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_RPlayerB(i)) & "'"
        End If
        LSQL = LSQL & " AND DelYN = 'N'"

        'Response.Write "LSQL1111:" &  LSQL & "<BR><BR><BR>"


        SET LRs = Dbcon.Execute(LSQL)

        If Not (LRs.Eof Or LRs.Bof) Then

        

          '대진표가 있으면 있는대진표의 TourneyGroupIDX를 가져옴
          If RTourneyData = "Y" Then

            TourneyGroupIDX = RTourneyGroupIDX

          Else

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

          End If



            ORDERBY = ORDERBY + 1

            '기존 대진표가 없으면 넣어줌
            If LTourneyData = "N" Then

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
            Else

              '새로 등록되는 선수들을 각자
             'CSQL = " SELECT MemberIDX "
             'CSQL = CSQL & " from tblTourneyPlayer A"
             'CSQL = CSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
             'CSQL = CSQL & " INNER JOIN tblTourney C ON C.GameLevelDtlidx = B.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX"
             'CSQL = CSQL & " WHERE A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
             'CSQL = CSQL & " AND C.TeamGameNum = '" & TeamGameNum & "'"
             'CSQL = CSQL & " AND C.GameNum = '" & i + 1 & "'"
             'CSQL = CSQL & " AND A.DelYN = 'N'"
             'CSQL = CSQL & " AND B.DelYN = 'N'"
             'CSQL = CSQL & " AND C.DelYN = 'N'"
             'CSQL = CSQL & " AND ("
             'CSQL = CSQL & " MemberIDX = '" & crypt.DecryptStringENC(Arr_RPlayerA(i)) & "'"
             'CSQL = CSQL & " OR MemberIDX = '" & crypt.DecryptStringENC(Arr_RPlayerB(i)) & "'"
             'CSQL = CSQL & " )"  

              'CSQL = " SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, MemberIDX"
              'CSQL = CSQL & " FROM tblTorneyTeamTemp"
              'CSQL = CSQL & " WHERE GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "' "
              'CSQL = CSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
              'CSQL = CSQL & " AND GameNum = '" & i + 1 & "'"
              'CSQL = CSQL & " AND ("
              'CSQL = CSQL & " GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_RPlayerA(i)) & "'"
              'CSQL = CSQL & " OR GameRequestPlayerIDX = '" & crypt.DecryptStringENC(Arr_RPlayerB(i)) & "'"
              'CSQL = CSQL & " ) "              
              'CSQL = CSQL & " AND DelYN = 'N'"              

            'CSQL = " SELECT A.MemberIDX, D.GameRequestPlayerIDX"
            'CSQL = CSQL & " from tblTourneyPlayer A"
            'CSQL = CSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
            'CSQL = CSQL & " INNER JOIN tblTourney C ON C.GameLevelDtlidx = B.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX"
            'CSQL = CSQL & " INNER JOIN tblTorneyTeamTemp D ON D.GameLevelDtlidx = C.GameLevelDtlIDX AND D.TeamGameNum = C.TeamGameNum AND D.Gamenum = C.GameNum AND D.MemberIDX = A.MemberIDX"
            'CSQL = CSQL & " WHERE A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
            'CSQL = CSQL & " AND C.TeamGameNum = '" & TeamGameNum & "'"
            'CSQL = CSQL & " AND C.GameNum = '" & i + 1 & "' "
            'CSQL = CSQL & " AND A.DelYN = 'N'"
            'CSQL = CSQL & " AND B.DelYN = 'N'"
            'CSQL = CSQL & " AND C.DelYN = 'N'"
            'CSQL = CSQL & " AND D.DelYN = 'N'"           

            CSQL = " SELECT A.MemberIDX, GameRequestPlayerIDX"
            CSQL = CSQL & " FROM tblTourneyPlayer A "
            CSQL = CSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX "
            CSQL = CSQL & " INNER JOIN tblTourney C ON C.GameLevelDtlidx = B.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX "
            CSQL = CSQL & " INNER JOIN"
            CSQL = CSQL & " ("
            CSQL = CSQL & " SELECT D.GameLevelDtlidx, A.MemberIDX, C.TEam, C.TeamDtl, GameRequestPlayerIDX"
            CSQL = CSQL & " FROM tblGameRequestPlayer A"
            CSQL = CSQL & " INNER JOIN tblGameRequestGroup B ON B.GameRequestGroupIDX = A.GameRequestGroupIDX"
            CSQL = CSQL & " INNER JOIN tblGameRequestTeam C ON C.GameRequestTeamIDX = A.GameRequestTeamIDX"
            CSQL = CSQL & " INNER JOIN tblGameRequestTouney D ON D.RequestIDX = C.GameRequestTeamIDX AND D.GroupGameGb = 'B0030002'"
            CSQL = CSQL & " WHERE A.DelYN = 'N'"
            CSQL = CSQL & " AND B.DelYN = 'N'"
            CSQL = CSQL & " AND C.DelYN = 'N'"
            CSQL = CSQL & " AND D.DelYN = 'N'"
            CSQL = CSQL & " AND D.GameLeveldtlidx = '" & DEC_GameLevelDtlIDX & "'"
            CSQL = CSQL & " ) DD ON  DD.GameLevelDtlidx = C.GameLevelDtlidx AND DD.MemberIDX = A.MemberIDX"
            CSQL = CSQL & " WHERE A.gameleveldtlidx = '" & DEC_GameLevelDtlIDX & "'"
            CSQL = CSQL & " AND C.DelYN = 'N'"
            CSQL = CSQL & " AND C.TeamGAmeNum = '" & TeamGameNum & "'"
            CSQL = CSQL & " AND C.Gamenum = '" & i + 1 & "'"
            CSQL = CSQL & " AND DD.Team = '" & RTeam & "'"
            CSQL = CSQL & " AND DD.Teamdtl = '" & RTeamDtl & "'"
            CSQL = CSQL & " AND A.DelYN = 'N'"
            CSQL = CSQL & " AND B.DelYN = 'N'"
            CSQL = CSQL & " AND C.DelYN = 'N'"    

              'Response.Write "LSQL1111:" &  CSQL & "<BR><BR><BR>"     
            

              SET CRs = Dbcon.Execute(CSQL)

              If Not (CRs.Eof Or CRs.Bof) Then

                Do Until CRs.Eof

                  oldplayerCnt = 0
                  oldplayer = ""

                  If oldplayerCnt = 0 Then
                    oldplayer = crypt.DecryptStringENC(Arr_RPlayerA(i))
                  Else
                    oldplayer = crypt.DecryptStringENC(Arr_RPlayerB(i))
                  End If

                  NSQL = "SELECT MemberIDX"
                  NSQL = NSQL & " FROM tblTorneyTeamTemp"
                  NSQL = NSQL & " WHERE DelYN = 'N'"
                  NSQL = NSQL & " AND GameLeveldtlIDX = '" & DEC_GameLevelDtlIDX & "'"
                  NSQL = NSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
                  NSQL = NSQL & " AND GameNum = '" & i + 1 & "'"
                  NSQL = NSQL & " AND GameRequestPlayerIDX = '" & oldplayer & "'"

                  SET NRs = Dbcon.Execute(NSQL)

                  If Not (CRs.Eof Or CRs.Bof) Then
                    oldplayer_MemberIDX = NRs("MemberIDX")
                  Else
                    oldplayer_MemberIDX = "0"
                  End If

                  NRs.Close                  
                  
                    '
                    'MSQL = " UPDATE tblGameResultDtl SET "
                    'MSQL = MSQL & " ServeMemberIDX = CASE WHEN ServeMemberIDX <> '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE ServeMemberIDX END, "
                    'MSQL = MSQL & " RecieveMemberIDX = CASE WHEN RecieveMemberIDX <> '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE RecieveMemberIDX END, "
                    'MSQL = MSQL & " Pst_MemberIDX_LL = CASE WHEN Pst_MemberIDX_LL <> '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE Pst_MemberIDX_LL END, "
                    'MSQL = MSQL & " Pst_MemberIDX_LR = CASE WHEN Pst_MemberIDX_LR <> '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE Pst_MemberIDX_LR END, "
                    'MSQL = MSQL & " Pst_MemberIDX_RL = CASE WHEN Pst_MemberIDX_RL <> '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE Pst_MemberIDX_RL END, "
                    'MSQL = MSQL & " Pst_MemberIDX_RR = CASE WHEN Pst_MemberIDX_RR <> '" & CRs("MemberIDX") & "' THEN '" & oldplayer_MemberIDX & "' ELSE Pst_MemberIDX_RR END "
                    'MSQL = MSQL & " WHERE DelYN = 'N' "
                    'MSQL = MSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "' "
                    'MSQL = MSQL & " AND TeamGameNum = '" & TeamGameNum & "' "
                    'MSQL = MSQL & " AND GameNum = '" & i + 1 & "' "
                    'Dbcon.Execute(MSQL)                                                                                                  
                                                            

                    MSQL = " UPDATE tblTourneyPlayer SET DelYN = 'Y'"
                    MSQL = MSQL & " from tblTourneyPlayer A"
                    MSQL = MSQL & " INNER JOIN tblTourneyGroup B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TourneyGroupIDX = A.TourneyGroupIDX"
                    MSQL = MSQL & " INNER JOIN tblTourney C ON C.GameLevelDtlidx = B.GameLevelDtlidx AND C.TourneyGroupIDX = B.TourneyGroupIDX"
                    MSQL = MSQL & " WHERE A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
                    MSQL = MSQL & " AND C.TeamGameNum = '" & TeamGameNum & "'"
                    MSQL = MSQL & " AND C.GameNum = '" & i + 1 & "' "
                    MSQL = MSQL & " AND A.MemberIDX = '" & CRs("MemberIDX") & "' "
                    MSQL = MSQL & " AND A.DelYN = 'N'"
                    MSQL = MSQL & " AND B.DelYN = 'N'"
                    MSQL = MSQL & " AND C.DelYN = 'N'"

                    Dbcon.Execute(MSQL)  

              'Response.Write "LSQL1111:" &  MSQL & "<BR><BR><BR>"     
             
                    
                                            
                            
                    oldplayerCnt = oldplayerCnt + 1

                  CRs.MoveNext     
                Loop

              End If      
              CRs.Close  

            End If

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