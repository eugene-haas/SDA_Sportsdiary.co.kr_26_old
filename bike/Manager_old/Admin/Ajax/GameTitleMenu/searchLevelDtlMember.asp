<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":2,""tIdx"":""47E0533CF10C4690F617881B06E75784"",""tGameLevelIdx"":""6F63A0533406C638BC30FDB235BB8D03"",""tGameLevelDtlIdx"":""BC04768F8AAA838ED15091ADE292E3CF""}"
  Set oJSONoutput = JSON.Parse(REQ)

  CMD = fInject(oJSONoutput.CMD)

  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  crypt_tIdx =crypt.EncryptStringENC(tIdx)

	tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  crypt_tGameLevelIdx =crypt.EncryptStringENC(tGameLevelIdx)

  tGameLevelDtlIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIdx))
  crypt_tGameLevelDtlIdx =crypt.EncryptStringENC(tGameLevelDtlIdx)

  'Response.Write "tIdx : " & tIdx & "<br>"
  'Response.Write "crypt_tIdx : " & crypt_tIdx & "<br>"
  'Response.Write "tGameLevelIdx : " & tGameLevelIdx & "<br>"
  'Response.Write "crypt_tGameLevelIdx : " & crypt_tGameLevelIdx & "<br>"
  'Response.Write "tGameLevelDtlIdx : " & tGameLevelDtlIdx & "<br>"
  'Response.Write "crypt_tGameLevelDtlIdx : " & crypt_tGameLevelDtlIdx & "<br>"

  IF( cdbl(tGameLevelIDX) > 0 ) Then
    Dim IsGameLevelCnt: IsGameLevelCnt = 0
    'Level을 체크한다  가 0보다 크면서 JOODIVISION이 0보다 클 때
    LSQL = " SELECT Top 1 GroupGameGb, b.PubName, a.EnterType "
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
    
    '개인전
    IF( tGroupGameGb = "B0030001") Then
    

    End IF

    ' 단체전
    IF( tGroupGameGb = "B0030002") Then


    End IF
  End IF


%>


<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.write "LSQL : " & LSQL
%>

	<table class="table-list game-ctr" >
  <thead>
  <tr>
  	<th>번호</th>
    <th>참여중인 팀
    	<select id="selGameLevelDtl" name="selGameLevelDtl" onchange="javascript:selLevelDtlChanged();" style="width:100px">
      <%
          LSQL = " Select GameLevelDtlidx,a.LevelJooNum,PlayLevelType, b.PubName as PlayLevelTypeNm  "
          LSQL = LSQL & " FROM tblGameLevelDtl a "
          LSQL = LSQL & " Left Join tblPubcode  b on a.PlayLevelType = b.PubCode and b.DelYN = 'N' "
          LSQL = LSQL & " where GameLevelidx = '" & tGameLevelIdx &"' and a.DelYN ='N'   "

          Set LRs = DBCon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
                LCnt = LCnt + 1
                tGameLevelDtlIdx2 = LRs("GameLevelDtlidx")
                crypt_tGameLevelDtlIdx2 =crypt.EncryptStringENC(tGameLevelDtlIdx2)
                tLevelJooNum = LRs("LevelJooNum")
                tPlayLevelTypeNm = LRs("PlayLevelTypeNm")
                IF cdbl(tGameLevelDtlIdx) = cdbl(tGameLevelDtlIdx2) Then 
                %>
                <option value="<%=crypt_tGameLevelDtlIdx2%>" selected><%=tPlayLevelTypeNm%>-<%=tLevelJooNum%></option>
                <% ELSE%>
                <option value="<%=crypt_tGameLevelDtlIdx2%>"><%=tPlayLevelTypeNm%>-<%=tLevelJooNum%></option>
              <%
                END IF
              LRs.MoveNext
            Loop
          End If
          LRs.close
        %>
      </select></th>
    <th>
      <a class="btn list-btn btn-blue">전체취소</a>
    </th>
  </tr>
  </thead>
  <tbody id="DP_LevelDtlList">
      <%
          if tGroupGameGb = "B0030001" Then
          LSQL = " SELECT Isnull((STUFF((SELECT ', ' + MemberName +'(' +TeamName + ')' FROM tblGameRequestPlayer c where b.GameRequestGroupIDX = c.GameRequestGroupIDX and c.DelYN = 'N'  For XML PATH('')),1,1,'')) ,'') AS TeamTitleNames, a.RequestDtlIDX  "
          LSQL = LSQL & " FROM tblGameRequestTouney a "
          LSQL = LSQL & " LEFT JOIN tblGameRequestGroup b on a.RequestIDX = b.GameRequestGroupIDX and b.DelYN='N' "
          LSQL = LSQL & "   where a.GroupGameGb ='"& tGroupGameGb &"' and a.GameLevelDtlIDX = '"& tGameLevelDtlIdx & "' and a.DelYN ='N' "
          End if

          if tGroupGameGb = "B0030002" Then
          LSQL = " SELECT b.TeamName  as TeamTitleNames, a.RequestDtlIDX"
          LSQL = LSQL & " FROM tblGameRequestTouney a "
          LSQL = LSQL & " LEFT JOIN tblGameRequestTeam b on a.RequestIDX = b.GameRequestTeamIDX and b.DelYN= 'N'  "
          LSQL = LSQL & " where a.GroupGameGb ='"& tGroupGameGb &"' and GameLevelDtlIDX = '"& tGameLevelDtlIdx & "' and a.DelYN ='N' "
          End if
          'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
          'LSQL = LSQL & " FROM  tblGameTitle a "
          'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
          'LSQL = LSQL & " WHERE a.DELYN = 'N' "
          response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        	Set LRs = DBCon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
                LCnt = LCnt + 1
                  tTeamTitleNames = LRs("TeamTitleNames")
                  tRequestDtlIDX = LRs("RequestDtlIDX")
                  crypt_tRequestDtlIDX =crypt.EncryptStringENC(tRequestDtlIDX)
                %>
              <tr>
              	<td>
                </td>
                <td>
                  <%=tTeamTitleNames%> 
                </td>
                <td>
                  <a class="btn list-btn btn-blue" onclick="cancel_RequestLevelDtl('<%=crypt_tRequestDtlIDX%>')">취소</a>
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