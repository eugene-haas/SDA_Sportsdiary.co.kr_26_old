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
Dim GroupGameGb
Dim PlayType
Dim TeamGb
Dim Level

Dim GameLevelidx

REQ = Request("Req")
'REQ = "{""CMD"":3,""GameTitleIDX"":""BF242F3A46C5952F1DF14D02620F1AB7"",""GroupGameGb"":""B4E57B7A4F9D60AE9C71424182BA33FE"",""PlayType"":""9313C11726C4F47D4859E9CC91CA6DAA|"",""TeamGb"":"""",""Level"":""""}"


Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "GameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.GameTitleIDX) Or oJSONoutput.GameTitleIDX = "" Then
      GameTitleIDX = ""
      DEC_GameTitleIDX = ""
    Else
      GameTitleIDX = fInject(oJSONoutput.GameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameTitleIDX))    
    End If
  Else  
    GameTitleIDX = ""
    DEC_GameTitleIDX = ""
End if	


If hasown(oJSONoutput, "GroupGameGb") = "ok" then
    If ISNull(oJSONoutput.GroupGameGb) Or oJSONoutput.GroupGameGb = "" Then
      GroupGameGb = ""
      DEC_GroupGameGb = ""
    Else
      GroupGameGb = fInject(oJSONoutput.GroupGameGb)
      DEC_GroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.GroupGameGb))    
    End If
  Else  
    GroupGameGb = ""
    DEC_GroupGameGb = ""
End if	

If hasown(oJSONoutput, "PlayType") = "ok" then
    PlayType = fInject(oJSONoutput.PlayType)   
End if	

If PlayType = "" Then
  PlayType = "|"
End If

If hasown(oJSONoutput, "TeamGb") = "ok" then
    If ISNull(oJSONoutput.TeamGb) Or oJSONoutput.TeamGb = "" Then
      TeamGb = ""
      DEC_GTeamGb = ""
    Else
      TeamGb = fInject(oJSONoutput.TeamGb)
      DEC_TeamGb = fInject(crypt.DecryptStringENC(oJSONoutput.TeamGb))    
    End If
  Else  
    TeamGb = ""
    DEC_TeamGb = ""
End if	

If hasown(oJSONoutput, "Level") = "ok" then
    Level = fInject(oJSONoutput.Level)   
End if	

If Level = "" Then
  Level = "||"
End If

strjson = JSON.stringify(oJSONoutput)

If InStr(PlayType,"|") < 1 Then
    Response.Write strjson
    'Response.END
End if

If InStr(Level,"|") < 1 Then
    Response.Write strjson
    'Response.END
End if


Arr_PlayType = Split(PlayType,"|")

If IsArray(Arr_PlayType) Then

  Sex = fInject(Arr_PlayType(0))
  DEC_Sex = fInject(crypt.DecryptStringENC(Arr_PlayType(0)))
  PlayType = fInject(Arr_PlayType(1))
  DEC_PlayType = fInject(crypt.DecryptStringENC(Arr_PlayType(1)))
End If

Arr_Level = Split(Level,"|")

If IsArray(Arr_Level)  Then
  
  Level = fInject(Arr_Level(0))
  DEC_Level = fInject(crypt.DecryptStringENC(Arr_Level(0)))
  LevelJooName = fInject(Arr_Level(1))
  DEC_LevelJooName = fInject(crypt.DecryptStringENC(Arr_Level(1)))
  LevelJooNum = fInject(Arr_Level(2))
  DEC_LevelJooNum = Arr_Level(2)

End If


Response.Write strjson
Response.write "`##`"

LSQL = " SELECT "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Sex, 'PubCode') AS SexName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.PlayType, 'PubCode') AS PlayTypeName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.TeamGb, 'TeamGb') AS TeamGbName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Level, 'Level') AS LevelName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.LevelJooName,'PubCode') AS LevelJooName, A.LevelJooNum, B.LevelJooNum AS LevelJooNumDtl,  B.LevelDtlName, GameLevelDtlIDX, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.GameType,'PubCode') AS GameTypeName, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.PlayLevelType,'PubCode') AS PlayLevelTypeName,"
LSQL = LSQL & " B.PlayLevelType,"
LSQL = LSQL & " A.GameType,"
LSQL = LSQL & " B.TotRound,"
LSQL = LSQL & " B.GameType AS GameTypeDtl,"
LSQL = LSQL & " B.FullGameYN,"
LSQL = LSQL & " ISNULL(( SELECT MAX( CONVERT(INT,ISNULL(GameNum,'0')) )"
LSQL = LSQL & "   FROM tblTourney"
LSQL = LSQL & "   WHERE DelYN = 'N'"
LSQL = LSQL & "   AND GameLevelDtlidx = B.GameLevelDtlidx"
LSQL = LSQL & "   GROUP BY GameLevelDtlidx"
LSQL = LSQL & "  ),0) AS TouneyCnt,"
LSQL = LSQL & " ISNULL(( SELECT MAX( CONVERT(INT,ISNULL(TeamGameNum,'0')) )"
LSQL = LSQL & "   FROM tblTourneyTeam"
LSQL = LSQL & "   WHERE DelYN = 'N'"
LSQL = LSQL & "   AND GameLevelDtlidx = B.GameLevelDtlidx"
LSQL = LSQL & "   GROUP BY GameLevelDtlidx"
LSQL = LSQL & "  ),0) AS TouneyTeamCnt,"

LSQL = LSQL & "  ( SELECT COUNT(*)"
LSQL = LSQL & "  FROM"
LSQL = LSQL & "  ("
LSQL = LSQL & "  SELECT GameLevelDtlidx, TeamGameNum, GameNum"
LSQL = LSQL & "  FROM tblGameResult"
LSQL = LSQL & "  WHERE DelYN = 'N'"
LSQL = LSQL & "  AND GameLevelDtlidx = B.GameLevelDtlidx"
LSQL = LSQL & "  GROUP BY GameLevelDtlidx, TeamGameNum, GameNum"
LSQL = LSQL & "  ) AS A ) AS PlayerResult,"

LSQL = LSQL & "  ( SELECT COUNT(*)"
LSQL = LSQL & "  FROM"
LSQL = LSQL & "  ("
LSQL = LSQL & "  SELECT GameLevelDtlidx, TeamGameNum"
LSQL = LSQL & "  FROM tblGroupGameResult"
LSQL = LSQL & "  WHERE DelYN = 'N'"
LSQL = LSQL & "  AND GameLevelDtlidx = B.GameLevelDtlidx"
LSQL = LSQL & "  GROUP BY GameLevelDtlidx, TeamGameNum"
LSQL = LSQL & "  ) AS A ) AS GroupResult,"
LSQL = LSQL & "  GroupGameGb"
LSQL = LSQL & " FROM tblGameLevel A"
LSQL = LSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLevelidx = A.GameLevelIDX"
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"

If GameTitleIDX <> "" Then
    LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "' "
End If

If GroupGameGb <> "" Then
    LSQL = LSQL & " AND A.GroupGameGb = '" & DEC_GroupGameGb & "' "
End If

If DEC_Sex <> "" AND DEC_Sex <> "0" Then
    LSQL = LSQL & " AND A.Sex = '" & DEC_Sex & "' "
End If

If DEC_PlayType <> "" AND DEC_PlayType <> "0" Then
    LSQL = LSQL & " AND A.PlayType = '" & DEC_PlayType & "' "
End If

If DEC_TeamGb <> "" AND DEC_TeamGb <> "0" Then
    LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "' "
End If

If DEC_Level <> "" AND DEC_Level <> "0" Then
    LSQL = LSQL & " AND A.Level = '" & DEC_Level & "' "
End If

If DEC_LevelJooName <> "" AND DEC_LevelJooName <> "0" Then
    LSQL = LSQL & " AND A.LevelJooName = '" & DEC_LevelJooName & "' "
End If

If DEC_LevelJooNum <> "" AND DEC_LevelJooNum <> "0" Then
    LSQL = LSQL & " AND A.LevelJooNum = '" & DEC_LevelJooNum & "' "
End If

Set LRs = Dbcon.Execute(LSQL)

%>
<tbody>
<%

If Not (LRs.Eof Or LRs.Bof) Then

	Do Until LRs.Eof

    '개인전 및 단체전일때 대진표상의 경기수
    If LRs("GroupGameGb") = "B0030001" Then
      TourneyCnt = LRs("TouneyCnt")
      ResultCnt = LRs("PlayerResult")
    Else
      TourneyCnt = LRs("TouneyTeamCnt")
      ResultCnt = LRs("GroupResult")
    End If
%>
    <tr>
      <td>

        <span class='txt'>
          <%If TourneyCnt > 0 Then%>
					<span class="l-btn-box">대진표</span>
          <%End If%>
          <%=LRs("SexName") & LRs("PlayTypeName") & " " &  LRs("TeamGbName")  & " " & LRs("LevelName") & " " & LRs("LevelJooName") & LRs("LevelJooNum")%>
          
          <%
            if LRs("PlayLevelType") = "B0100001" Then
              Response.Write "예선" & LRs("LevelJooNumDtl") & "조"
            ElseIf LRs("PlayLevelType") = "B0100002" Then
              If LRs("GameTypeDtl") = "B0040001" AND  LRs("FullGameYN") = "Y" Then
                Response.Write "풀리그"
              Else
                Response.Write "본선"
              End If
            Else
              Response.Write "-"
            End If
          %>

          [C:<%=LRs("GameLevelDtlIDX")%>]

					<div class="ps-btn-box">
            <%
              '개인전대진표가 있거나 단체전 대진표가 있으면 색깔표시
              If TourneyCnt <> "0" AND TourneyCnt = ResultCnt Then
            %>  
              <a class='btn btn-league-sel gray-btn' onclick=cli_RequestLevelDtl('<%=LRs("GameLevelDtlIDX")%>',this) >경기종료</a><!--<%=TourneyCnt%>,<%=ResultCnt%>-->
						  
            <%Else%>
              <a class='btn btn-league-sel' onclick=cli_RequestLevelDtl('<%=LRs("GameLevelDtlIDX")%>',this) >선택</a><!--<%=TourneyCnt%>,<%=ResultCnt%>-->
            <%End If%>
            <%
              If LRs("GameTypeDtl") = "B0040001" Then
                PrintURL = "MatchLeague_View.asp"
              Else
                PrintURL = "Match" & LRs("TotRound") & "_View.asp"
              End If
            %>
						<a href="../Print/<%=PrintURL%>?GameLevelDtlIDX=<%=crypt.EncryptStringENC(LRs("GameLevelDtlIDX"))%>" class="print-btn" target="_blank">출력</a>
					</div>

          
          
        </span>
      </td>
    </tr>

  <%

	    LRs.MoveNext
	Loop


End If
%>

</tbody>

<%
LRs.Close


Set LRs = Nothing
DBClose()
  
%>