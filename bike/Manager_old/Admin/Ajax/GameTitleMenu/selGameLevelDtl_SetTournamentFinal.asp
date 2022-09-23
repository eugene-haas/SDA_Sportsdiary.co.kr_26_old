<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  
  REQ = Request("Req")
  'REQ = "{""CMD"":2,""tGameTitleIdx"":""C4F45D4766A741AF49900107ACE44658""}"
  Set oJSONoutput = JSON.Parse(REQ)
  tGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>
 <table class="table-list match_info">
  <thead>
    <tr>
      <th>구분</th>
      <th>종별</th>
      <th>게임 레벨 상세 번호</th>
    </tr>
  </thead>
  <tbody id="contest">
    <%
      iType = 1
      LSQL = "  SELECT GameLevelDtlidx, b.GroupGameGb,  KoreaBadminton.dbo.FN_NameSch(B.GroupGameGb, 'PubCode') as GroupGameGbNM, "
      LSQL = LSQL & "SexNm = (case b.Sex when  'man' then	'남자' when 'woman' then '여자' else  '혼합' End  ), "
      LSQL = LSQL & " b.Sex, b.PlayType, b.GameType, b.TeamGb,"
      LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(b.PlayType,'PubCode') AS PlayTypeNm,  "
      LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(b.TeamGb,'TeamGb') AS TeamGbNm,  "
      LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(b.Level,'Level') AS LevelNm, "
      LSQL = LSQL & " b.Level,"
      LSQL = LSQL & " b.LevelJooNum "
      LSQL = LSQL & " FROM tblGameLevelDtl a"
      LSQL = LSQL & " Inner Join tblGameLevel  b on a.GameLevelidx= b.GameLevelidx and b.DelYN = 'N'"
      LSQL = LSQL & " where a.GameTitleIDX = '" & tGameTitleIdx &" ' and PlayLevelType = 'B0100002' And a.DelYN ='N'"
      
      Set LRs = DBCon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
            LCnt = LCnt + 1
            rGameLevelDtlidx  = LRS("GameLevelDtlidx")
            rGroupGameGb  = LRS("GroupGameGb")
            rGroupGameGbNM = LRS("GroupGameGbNM")

            rSexNm = LRS("SexNm")
            rSex = LRS("Sex")
            rPlayType = LRS("PlayType")
            rPlayTypeNM= LRS("PlayTypeNM")
            rGameType = LRS("GameType")
            rTeamGb = LRS("TeamGb")
            rTeamGbNm = LRS("TeamGbNm")
            rLevelNm = LRS("LevelNm")
            rLevel = LRS("Level")
            rLevelJooNum = LRS("LevelJooNum")

  %>
    <tr> 
      <td style="cursor:pointer"><%=rGroupGameGbNM%>
        <input type="hidden"  id="GroupGameGb_<%=LCnt%>" value="<%=rGroupGameGb%>">
      </td>
      <td style="cursor:pointer"><%Response.Write rSexNm & rPlayTypeNM & rTeamGbNm & " " & rLevelNm  & " " & rLevelJooNum %></td>
      <td style="cursor:pointer" id="GameLevelDtlIdx_<%=LCnt%>"><%=rGameLevelDtlidx%></td>
    </tr>
  <%
          LRs.MoveNext
        Loop
      End If
      LRs.close
    %>
  </tbody>
</table>
<input type="hidden" name="GameLevelDtlIdxTotalCnt" id="GameLevelDtlIdxTotalCnt" value="<%=LCnt%>">