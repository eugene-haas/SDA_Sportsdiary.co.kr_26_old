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
  'REQ = "{""tGameTitleIdx"":""35D5B51E5025C785305E687C2F2EE95E"",""CMD"":6,""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tTeamGb"":""D98DCE4F5BD95371220E6346EBB40906|WoMan"",""tPlayTypeSex"":""791EF6FF9AAA5583497CB0D2B40BD0D4|A932F76713F8A9728D92A52C4795E4B7"",""tLevel"":""3185C0AF529D3F473C086DF0CF9FBF03|C746B9F74EACE2D978CDE183BC395874|1"",""tRankingValue"":""""}"

  Set oJSONoutput = JSON.Parse(REQ)
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
  crypt_reqGameTitleIdx =crypt.EncryptStringENC(tGameTitleIdx)

  If hasown(oJSONoutput, "tGroupGameGb") = "ok" then
    reqGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
    crypt_reqGroupGameGb = crypt.EncryptStringENC(reqGroupGameGb)
  Else
    reqGroupGameGb = "B0030001" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGroupGameGb = crypt.EncryptStringENC(reqGroupGameGb)
  End if	

    If hasown(oJSONoutput, "tTeamGb") = "ok" then
    reqTeamGb= fInject(oJSONoutput.tTeamGb)
    If InStr(reqTeamGb,"|") > 1 Then
      arr_reqTeamGb = Split(reqTeamGb,"|")
      reqTeamGb = fInject(crypt.DecryptStringENC(arr_reqTeamGb(0)))
      crypt_reqTeamGb =crypt.EncryptStringENC(reqTeamGb)
      reqTeamGbSex = fInject(arr_reqTeamGb(1))
    End IF
  End if	

  If hasown(oJSONoutput, "tPlayTypeSex") = "ok" then
    reqPlayTypeSex= fInject(oJSONoutput.tPlayTypeSex)
    If InStr(reqPlayTypeSex,"|") > 1 Then
      arr_reqPlayTypeSex = Split(reqPlayTypeSex,"|")
      reqSex = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(0)))
      reqPlayType = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(1)))
    End if
  End if	

  If hasown(oJSONoutput, "tLevel") = "ok" then
    reqLevel= fInject(oJSONoutput.tLevel)
    'reqLevel = "FE25E609214EB0FC01BC8651577120A1|2B4F14AE43DBCAD1D5BFD3285CE3A249|1"
    If InStr(reqLevel,"|") > 1 Then
      arr_reqLevel = Split(reqLevel,"|")
      reqLevel = fInject(crypt.DecryptStringENC(arr_reqLevel(0)))
      reqLevelJooName = fInject(crypt.DecryptStringENC(arr_reqLevel(1)))
      reqLevelJooNum = arr_reqLevel(2)
    End if
  End if	


  If hasown(oJSONoutput, "tRankingValue") = "ok" then
    reqRankingValue= fInject(oJSONoutput.tRankingValue)
  End if	


  

  'Response.Write reqGameTitleIdx & ":<Br>"
  'Response.Write reqGroupGameGb & ":<Br>"
  'Response.Write reqTeamGb & ":<Br>"
  'Response.Write reqSex & ":<Br>"
  'Response.Write reqPlayType & ":<Br>"
  
  'Response.Write reqLevelJooName & ":<Br>"
  'Response.Write reqLevelJooNum & ":<Br>"

  
LSQL = " SELECT GameLevelDtlIDX,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Sex, 'PubCode') AS SexName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.PlayType, 'PubCode') AS PlayTypeName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.TeamGb, 'TeamGb') AS TeamGbName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Level, 'Level') AS LevelName,"
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.LevelJooName,'PubCode') AS LevelJooName, A.LevelJooNum, B.LevelJooNum AS LevelJooNumDtl,  B.LevelDtlName, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.GameType,'PubCode') AS GameTypeName, "
LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.PlayLevelType,'PubCode') AS PlayLevelTypeName,"
LSQL = LSQL & " B.PlayLevelType,"
LSQL = LSQL & " A.GameType"
LSQL = LSQL & " FROM tblGameLevel A"
LSQL = LSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLevelidx = A.GameLevelIDX"
LSQL = LSQL & " INNER JOIN tblTeamGbInfo C ON C.TeamGb = A.TeamGb AND C.DelYN='N'"

If reqTeamGbSex <> "" AND reqSex = "" Then
  LSQL = LSQL & " AND A.Sex = '" & reqTeamGbSex & "' "
End If

LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND B.PlayLevelType = 'B0100001'" '예선전만

If reqGameTitleIdx <> "" Then
    LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "' "
End If

If reqGroupGameGb <> "" Then
    LSQL = LSQL & " AND A.GroupGameGb = '" & reqGroupGameGb & "' "
End If

If reqTeamGb <> "" AND reqTeamGb <> "0" Then
    LSQL = LSQL & " AND A.TeamGb = '" & reqTeamGb & "' "
End If

If reqSex <> "" AND reqSex <> "0" Then
    LSQL = LSQL & " AND A.Sex = '" & reqSex & "' "
End If

If reqPlayType <> "" AND reqPlayType <> "0" Then
    LSQL = LSQL & " AND A.PlayType = '" & reqPlayType & "' "
End If

If reqLevel <> "" AND reqLevel <> "0" Then
    LSQL = LSQL & " AND A.Level = '" & reqLevel & "' "
End If

If reqLevelJooName <> "" AND reqLevelJooName <> "0" Then
    LSQL = LSQL & " AND A.LevelJooName = '" & reqLevelJooName & "' "
End If

If reqLevelJooNum <> "" AND reqLevelJooNum <> "0" Then
    LSQL = LSQL & " AND A.LevelJooNum = '" & reqLevelJooNum & "' "
End If  



Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
  Arr_Info = LRs.getrows()
End If

IF IsArray(Arr_Info) Then
  Arr_InfoLength = UBOUND(Arr_Info,2)
ELSE 
  Arr_InfoLength = 0
End IF

IF IsArray(Arr_Info) Then
  For i = 0 To Arr_InfoLength
    If i = 0 Then
      LevelDtlLSQL = LevelDtlLSQL & " ( A.GameLevelDtlidx = ''" & Arr_Info(0,i) & "''"
    Else
      LevelDtlLSQL  = LevelDtlLSQL  & " OR A.GameLevelDtlidx = ''" & Arr_Info(0,i) & "''"
    End If
  NEXT
END IF

'IF cdbl(Arr_InfoLength) > 0 And Cdbl(Len(LevelDtlLSQL)) > 0  Then
'  LevelDtlLSQL  = LevelDtlLSQL  & " ) "
'End IF

IF cdbl(Arr_InfoLength) > 0 Or Cdbl(Len(LevelDtlLSQL)) > 0  Then
  LevelDtlLSQL  = LevelDtlLSQL  & " ) "
End IF


'Response.Write "UBOUND(Arr_Info,2) : " & Arr_InfoLength & "<br/>"
'Response.Write "LevelDtlLSQL : " & LevelDtlLSQL & "<br/>"


  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.Write "SQL : " & LSQL & "<br/>"

  'Response.write "oJSONoutput.tLevel : " & oJSONoutput.tLevel & "<BR/>"

  
%>
		<table cellspacing="0" cellpadding="0">
			<tr>
        <th>최종순위</th>
        <th>종목</th>
				<th>순위</th>
				<th>소속</th>
				<th>선수</th>
				<th>승</th>
				<th>패</th>
				<th>승률</th>
				<th>득실차</th>
				<th>총득점</th>
				<th>총실점</th>
			</tr>
			<%
				'해당 단체전대진표 랭킹구하기
				
        'LSQL = "Select * "
        'LSQL = LSQL &" From ("
        'LSQL = LSQL &" SELECT dbo.FN_NameSch(D.TeamGb,'TeamGb') AS TeamGbNM, dbo.FN_NameSch(C.Level,'Level') AS LevelNM, C.PlayLevelType, C.LevelJooNum AS LevelDtlJooNum , AAAA.GameLevelDtlidx, Team, TeamDtl, WinCnt, GameCnt, WinPerc, LoseCnt, WinPoint, LosePoint, PointDiff, "
        'LSQL = LSQL & " CASE WHEN ISNULL(TeamDtl,'0') = '0' THEN '' ELSE TeamDtl END AS TeamDtlNM,"
        'LSQL = LSQL & " dbo.FN_NameSch(Team,'Team') AS TeamNM,"
        'LSQL = LSQL & " ROW_NUMBER() OVER ( PARTITION BY AAAA.GameLevelDtlidx ORDER BY WinCnt DESC, WinPerc DESC, PointDiff DESC, WinPoint DESC) AS TRanking"
        'LSQL = LSQL & " FROM"
        'LSQL = LSQL & " ("
        'LSQL = LSQL & " 	SELECT GameLevelDtlidx, Team, TeamDtl , CONVERT(FLOAT,WinCnt) AS WinCnt, CONVERT(FLOAT,GameCnt) AS GameCnt, "
        'LSQL = LSQL & " 	Round(CONVERT(FLOAT,(CONVERT(FLOAT,WinCnt) / CONVERT(FLOAT,GameCnt)) * 100),2) AS WinPerc,"
        'LSQL = LSQL & " 	LoseCnt, WinPoint, LosePoint, CONVERT(FLOAT,WinPoint) - CONVERT(FLOAT,LosePoint) AS PointDiff"
        'LSQL = LSQL & " 	FROM"
        'LSQL = LSQL & " 		("
        'LSQL = LSQL & " 		SELECT AA.GamelevelDtlIDX, AA.Team, AA.TeamDtl, SUM(AA.WinCnt) AS WinCnt, SUM(AA.LoseCnt) AS LoseCnt, SUM(AA.GameCnt) AS GameCnt,"
        'LSQL = LSQL & " 		dbo.FN_WinGroupPoint(AA.GameLevelDtlidx, AA.Team, AA.TeamDtl) AS WinPoint,"
        'LSQL = LSQL & " 		dbo.FN_LoseGroupPoint(AA.GameLevelDtlidx, AA.Team, AA.TeamDtl) AS LosePoint"
        'LSQL = LSQL & " 		FROM"
        'LSQL = LSQL & " 			("
        'LSQL = LSQL & " 			SELECT A.GamelevelDtlIDX, A.Team, A.TeamDtl, "
        'LSQL = LSQL & " 			CASE WHEN dbo.FN_NameSch(B.Result,'PubType') = 'WIN' THEN 1 ELSE 0 END AS WinCnt,"
        'LSQL = LSQL & " 			CASE WHEN dbo.FN_NameSch(B.Result,'PubType') = 'LOSE' THEN 1 ELSE 0 END AS LoseCnt,"
        'LSQL = LSQL & " 			1 AS GameCnt"
        'LSQL = LSQL & " 			FROM"
        'LSQL = LSQL & " 			("
        'LSQL = LSQL & " 			SELECT GamelevelDtlIDX, Team, TeamDtl"
        'LSQL = LSQL & " 			FROM tblTourneyTeam"
        'LSQL = LSQL & " 			WHERE DelYN = 'N'"
        'LSQL = LSQL & " 			AND "
        'LSQL = LSQL & " 			("
'
        '  If IsArray(Arr_Info) Then
        '    For i = 0 To UBOUND(Arr_Info,2)
        '      If i = 0 Then
        '        LSQL = LSQL & "       GameLevelDtlidx = '" & Arr_Info(0,i) & "'"
        '      Else
        '        LSQL = LSQL & "       OR GameLevelDtlidx = '" & Arr_Info(0,i) & "'"
        '      End If
        '        
        '    NEXT
        '  Else
        '    LSQL = LSQL & "       DelYN = 'Nothing'"
        '  End If

        'LSQL = LSQL & "       )"
        'LSQL = LSQL & " 			GROUP BY GamelevelDtlIDX, Team, TeamDtl"
        'LSQL = LSQL & " 			) AS A"
        'LSQL = LSQL & " 		LEFT JOIN tblGroupGameResult B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND A.Team + A.TeamDtl = B.Team + B.TeamDtl "
        'LSQL = LSQL & " 		AND B.DelYN = 'N'"
        'LSQL = LSQL & " 		WHERE ISNULL(A.Team,'') <> ''"
        'LSQL = LSQL & " 		) AS AA"
        'LSQL = LSQL & " 		GROUP BY GamelevelDtlIDX, Team, TeamDtl"
        'LSQL = LSQL & " 	) AS AAA"
        'LSQL = LSQL & " ) AS AAAA"
        'LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = AAAA.GameLevelDtlidx"
        'LSQL = LSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
        'LSQL = LSQL & " WHERE C.DelYN = 'N'"
        'LSQL = LSQL & " AND D.DelYN = 'N'"
        'LSQL = LSQL & " ) CC"
        'IF reqRankingValue <> "" Then
        'LSQL = LSQL & " WHERE CC.TRanking = '" & reqRankingValue & "'"
        'End IF
        'Response.Write LSQL
        
  if Len(LevelDtlLSQL) = 0 Then
    %>
      <tr >
        <td colspan="11">
          조회된 데이터가 없습니다.
        </td>
      </tr>
    </table>
    <%
    Response.End
  End IF

  LSQL = "EXEC tblGameRankingResult_Searched_STR '" & reqGameTitleIdx  & "', '" & LevelDtlLSQL &  "', '" & reqRankingValue  & "','" & reqGroupGameGb & "'"

  'Response.Write LSQL
  'Response.End

  Set LRs = Dbcon.Execute(LSQL)
  arrnum = 0
  AutoRank = 0
  If Not (LRs.Eof Or LRs.Bof) Then		
    Do Until LRs.Eof		
      arrnum = arrnum  + 1
      rGameLevelDtlCnt = LRs("GameLevelDtlCnt") 
      rJooRank = LRs("JooRank") 
      rFinalPlayer = rJooRank
      rGameLevelidx = LRs("GameLevelidx")
      rGameLevelDtlidx= LRs("GameLevelDtlidx")
      rTourneyGroupIDX= LRs("TourneyGroupIDX")
      rGroupGameGb= LRs("GroupGameGb")
      rRequestIDX= LRs("RequestIDX")

      If LRs("AutoRank") <> "0" Then
        AutoRank = AutoRank + 1
      End If      
      
%>
    <tr>
      <td>
        <select id="STR_Grade_<%=arrnum%>" name="STR_Grade">
          <option value="">=순위선택=</option>
            <%
              If IsArray(Arr_Info) Then
                For j = 1 To rFinalPlayer
            %>
                <option value="<%=j%>" <%If j = AutoRank AND LRs("AutoRank") <> "0" Then%>selected<%End If%>><%=j%>위</option>                  
            <%
                NEXT
              End If
            %>
        </select>
      </td>
      <td><%=LRs("TeamGbNM") & " " & LRs("LevelNM") & " " & LRs("LevelJooNameNM")& LRs("LevelJooNum") %>
      <%


          If LRs("PlayLevelType") = "B0100001" Then
              Response.Write " 예선" & LRs("LevelDtlJooNum")&"조"
          ElseIf LRs("PlayLevelType") = "B0100002" Then
              Response.Write " 본선"
          Else
              Response.Write "-"
          End If   
      %>        
      </td>
      <td>
        <span><%=LRs("TRanking")%></span>
      </td>
      <td>
        <input type="hidden" id="STR_Team_<%=arrnum%>" name="STR_Team" value="<%=LRs("Team")%>">
        <input type="hidden" id="STR_TeamDtl_<%=arrnum%>" name="STR_TeamDtl" value="<%=LRs("TeamDtl")%>">
        <input type="hidden" id="STR_GameLevelIdx_<%=arrnum%>" name="STR_GameLevelIdx" value="<%=rGameLevelidx%>">
        <input type="hidden" id="STR_GameLevelDtlIdx_<%=arrnum%>" name="STR_GameLevelDtlIdx" value="<%=rGameLevelDtlidx%>">
        <input type="hidden" id="STR_TourneyGroupIDX_<%=arrnum%>" name="STR_TourneyGroupIDX" value="<%=rTourneyGroupIDX%>">
        <input type="hidden" id="STR_RequestIdx<%=arrnum%>" name="STR_RequestIdx" value="<%=rRequestIDX%>">
        <span><%=LRs("TeamNM") & LRs("TeamDtlNM")%></span>
      </td>
      <td>
       <%=LRs("Player")%>
      </td>
      <td>
        <span><%=LRs("WinCnt")%></span>
      </td>
      <td>
        <span><%=LRs("LoseCnt")%></span>
      </td>
      <td>
        <span><%=LRs("WinPerc")%>%</span>
      </td>
      <td>
        <span><%=LRs("PointDiff")%></span>
      </td>
      <td>
        <span><%=LRs("WinPoint")%></span>
      </td>
      <td>
        <span><%=LRs("LosePoint")%></span>
      </td>
    </tr>
    <%
           
          LRs.MoveNext
        Loop
      ELSE
    %>
    <tr >
    <td colspan="11">
      조회된 데이터가 없습니다.
    </td>
    </tr>
      
    <%
      End If
    %>
  </table>
  <input type="hidden" id="TotalRankingResult" name="TotalRankingResult" value="<%=arrnum%>">
<%
  Response.Write "LSQL : " & LSQL & "<br/>"
  Set LRs = Nothing
  DBClose()
%>