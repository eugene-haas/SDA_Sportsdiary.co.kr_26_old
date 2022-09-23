<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":1,""tIdx"":""47E0533CF10C4690F617881B06E75784"",""tGameLevelDtlIDX"":""7FE68866D5BC58B894C3B80476D810E8"",""tGameLevelIdx"":""004DF5B471518BA4DB36548D566C5E3B"",""IsAllMember"":false,""tSearchName"":""김광""}"
  Set oJSONoutput = JSON.Parse(REQ)
  CMD = fInject(oJSONoutput.CMD)
  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  crypt_tIdx =crypt.EncryptStringENC(tIdx)
	tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  crypt_tGameLevelIdx =crypt.EncryptStringENC(tGameLevelIdx)
  tGameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIDX))
  crypt_tGameLevelDtlIDX =crypt.EncryptStringENC(tGameLevelDtlIDX)
  IsAllMember = fInject(oJSONoutput.IsAllMember)
	tSVAL = Replace(fInject(oJSONoutput.tSearchName),Chr(34), "")

  'Response.Write "tIdx : " & tIdx & "<br>"
  'Response.Write "crypt_tIdx : " & crypt_tIdx & "<br>"
  'Response.Write "tGameLevelIdx : " & tGameLevelIdx & "<br>"
  'Response.Write "crypt_tGameLevelIdx : " & crypt_tGameLevelIdx & "<br>"
  'Response.Write "tGameLevelDtlIDX : " & tGameLevelDtlIDX & "<br>"
  'Response.Write "crypt_tGameLevelDtlIDX : " & crypt_tGameLevelDtlIDX & "<br>"
  'Response.Write "tSVAL : " & tSVAL & "<br>"
  'Response.Write "IsAllMember : " & IsAllMember & "<br>"

  IF( cdbl(tGameLevelIDX) > 0 ) Then
    Dim IsGameLevelCnt: IsGameLevelCnt = 0
    'Level을 체크한다  가 0보다 크면서 JOODIVISION이 0보다 클 때
    LSQL = " SELECT Top 1 Level, GameLevelidx, GameTitleIDX, Isnull(PGameLevelidx,'') as PGameLevelidx, JooDivision, GroupGameGb, b.PubName, a.EnterType "
    LSQL = LSQL & " FROM  tblGameLevel  a "
    LSQL = LSQL & " LEFT JOIN tblPubcode b on a.GroupGameGb = b.PubCode and b.DelYN = 'N' "
    LSQL = LSQL & " WHERE a.GameLevelidx = '"  & tGameLevelIDX  & "' and a.DelYn ='N' "

    'Response.Write "설명 : LEVEL 자신이 있는지 확인" & "<br>"
    'Response.Write "LSQL" & LSQL & "<BR><BR><BR><BR><BR>"
    '1. LEVEL 자신이 있는지 확인
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        IsGameLevelCnt = IsGameLevelCnt + 1
        tGroupGameGb = LRS("GroupGameGb")
        GroupGameGbName = LRS("PubName")
        tEnterType = LRS("EnterType")
        LRs.MoveNext
      Loop
    End IF

    'Response.Write "GroupGameGb : " & tGroupGameGb & "<br>"
    'Response.Write "GroupGameGbName : " & tGroupGameGb & "<br>"
  End IF
  
%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.write "LSQL : " & LSQL
%>

<table class="table-list game-ctr">
  <thead>
    <tr><th>종별 참가 신청팀</th></tr>
  </thead>
  <tbody id="DP_LevelDtlList">
    <%
        if tGroupGameGb = "B0030001" Then
          LSQL = " SELECT  a.GameRequestGroupIDX as TeamIDX, Isnull(b.TeamNm,'') + '(' + Isnull((STUFF((SELECT ',' + MemberName FROM tblGameRequestPlayer c where a.GameRequestGroupIDX = c.GameRequestGroupIDX and c.DelYN = 'N'  For XML PATH('')),1,1,'')) ,'') + ')' AS TeamTitleNames   "
          LSQL = LSQL & " FROM tblGameRequestGroup a"
          LSQL = LSQL & " LEFT JOIN tblTeamInfo b on a.Team = b.Team and b.DelYN='N'"
          LSQL = LSQL & "   where a.GameLevelIDX ='"& tGameLevelIdx &"' and a.DelYN ='N' "
           if( IsAllMember = false) Then
            LSQL = LSQL & "  and  b.TeamNm LIKE '%" &  tSVAL & "%'"
          End if
        End if

        if tGroupGameGb = "B0030002" Then
          LSQL = " SELECT a.GameRequestTeamIDX as TeamIDX, TeamName as TeamTitleNames "
          LSQL = LSQL & " FROM tblGameRequestTeam a "
          LSQL = LSQL & "   where a.GameLevelIDX ='"& tGameLevelIdx &"' and a.DelYN ='N' "
          if( IsAllMember = false) Then
            LSQL = LSQL & "  and  a.TeamName LIKE '%" &  tSVAL & "%'"
          End if
        End if

        'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
        'LSQL = LSQL & " FROM  tblGameTitle a "
        'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
        'LSQL = LSQL & " WHERE a.DELYN = 'N' "
        'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        
        Set LRs = DBCon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
              LCnt = LCnt + 1
                tTeamTitleNames = LRs("TeamTitleNames")
                tTeamIDX = LRs("TeamIDX")
                crypt_tTeamIDX =crypt.EncryptStringENC(tTeamIDX)
              %>
            <tr>
              <td>
                <%=tTeamTitleNames%> <a onclick="insert_RequestLevelDtl('<%=crypt_tTeamIDX%>')" style="cursor:pointer">신청</a>
              </td>
            </tr>
            <%
            LRs.MoveNext
          Loop
        End If
        LRs.close
    %>
  </tbody>
</table>