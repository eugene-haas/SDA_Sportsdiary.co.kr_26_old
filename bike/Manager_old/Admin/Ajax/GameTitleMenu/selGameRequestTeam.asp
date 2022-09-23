<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":3,""tGameRequestTeamIdx"":""44E6E7964C8A09C0DEE96ADEA4157A43"",""tGameTitleIDX"":""B982ED46B36E629292ABE4DFB9242C60"",""tGameTitleNm"":""2018 중고연맹회장기 전국학생배드민턴선수권대회"",""tGameLevelIdx"":""890B09C57E3E5953C188AA071FCC1812"",""tGroupGameGbNm"":""단체전"",""tGroupGameGb"":""400CCFC358DA360D5A863D04FD0C3136"",""tLevel"":""400CCFC358DA360D5A863D04FD0C3136"",""tLevelNm"":""중학부""}"

  Set oJSONoutput = JSON.Parse(REQ)
	tGameRequestTeamIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestTeamIdx))
  crypt_tGameRequestTeamIdx = crypt.EncryptStringENC(tGameRequestTeamIdx)
  

  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  crypt_tidx = crypt.EncryptStringENC(tIdx)

  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  crypt_tGameLevelIdx =crypt.EncryptStringENC(tGameLevelIdx)

  tGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
  crypt_tGroupGameGb = fInject(crypt.EncryptStringENC(tGroupGameGb))

  tLevel = fInject(crypt.DecryptStringENC(oJSONoutput.tLevel))
  crypt_tLevel = fInject(crypt.EncryptStringENC(tLevel))

  
  tGameTitleName = fInject(oJSONoutput.tGameTitleNm)
  tGroupGameGbNm = fInject(oJSONoutput.tGroupGameGbNm)
  tLevelNm = fInject(oJSONoutput.tLevelNm)

  NowPage =  fInject(oJSONoutput.NowPage)

  'LSQL = " SELECT TOP 1  GameLevelDtlidx ,GameLevelidx ,PlayLevelType ,PlayLevelGroup ,GameType ,StadiumNumber ,TotRound ,GameDay ,GameTime ,EnterType ,EntryCnt ,Level ,LevelDtlName ,DelYN,ViewYN ,EditDate ,WriteDate, LevelJooName, JooNum  "
  LSQL = " SELECT Top 1 GameRequestTeamIDX, GameTitleIDX, GameLevelIDX, GameTitleName, Team, TeamDtl, TeamName, EditDate, WriteDate, DelYN   "
  LSQL = LSQL & "   FROM  tblGameRequestTeam  "
  LSQL = LSQL & " WHERE GameRequestTeamIDX = '"  & tGameRequestTeamIdx  & "' and DelYn ='N' "
   'Response.write "LSQL" & LSQL & "<BR>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameRequestTeamIDX = LRS("GameRequestTeamIDX") 
      tGameTitleIDX = LRS("GameTitleIDX")
      tGameLevelIDX = LRS("GameLevelIDX")
      tGameTitleName = LRS("GameTitleName")
      tTeam = LRS("Team")
      crypt_tTeam = crypt.EncryptStringENC(tTeam)
      tTeamDtl = LRS("TeamDtl")
      tTeamName = LRS("TeamName")
      LRs.MoveNext
    Loop
  End IF

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

<table class="navi-tp-table">
  <colgroup>
    <col width="64px">
    <col width="*">
    <col width="64px">
    <col width="*">
    <col width="94px">
    <col width="*">
    <col width="94px">
    <col width="*">							
  </colgroup>
  <tbody>
    <tr>
      <th scope="row">번호</th>
      <td>
       <input type="text" id="GameRequestTeamIdx" name="GameRequestTeamIdx" value="<%=tGameRequestTeamIdx%>">
       <input type="hidden" id="hiddenGameRequestTeamIdx" name="hiddenGameRequestTeamIdx" value="<%=crypt_tGameRequestTeamIdx%>">
      </td>
    </tr>

    <tr>
      <th scope="row"><span class="l_con"></span>대회명</label></th>
      <td><%=tGameTitleName%></td>
      <input type="hidden" name="selGameTitle" id="selGameTitle" value="<%=tGameTitleName%>">
      <input type="hidden" name="selGameTitleIDX" id="selGameTitleIDX" value="<%=crypt_tidx%>">
      <input type="hidden" name="selGameLevelIDX" id="selGameLevelIDX" value="<%=crypt_tGameLevelIdx%>">
      <th scope="row"><span class="l_con"></span>구분</th>
      <td><%=tGroupGameGbNm%></td>
      <input type="hidden" name="GroupGameGb" id="GroupGameGb" value="<%=crypt_tGroupGameGb%>">
      <input type="hidden" name="GroupGameGbNm" id="GroupGameGbNm" value="<%=tGroupGameGbNm%>">
    </tr>

    <tr>
      <th scope="row"><span class="l_con"></span>종목</th>
      <td><%=tLevelNm%></td>
      <input type="hidden" name="Level" id="Level" value="<%=crypt_tLevel%>">
      <input type="hidden" name="LevelNm" id="LevelNm" value="<%=tLevelNm%>">
      <th scope="row"></th>
      <td></td>
    </tr>

    <tr>
      <th scope="row"><span class="l_con"></span>팀명</th>
      <td>
        <span class="con"><input type="text" name="strTeam" id="strTeam" value="<%=tTeamName%>" placeholder="검색할 팀명을 입력해 주세요."></span>
        <input type="hidden" name="hiddenTeam" id="hiddenTeam" value="<%=crypt_tTeam%>">
        <input type="hidden" name="hiddenTeamName" id="hiddenTeamName" value="<%=tTeamName%>">
      </td>
      <th scope="row"><span class="l_con"></span>세부 팀명</th>
      <td>
        <span class="con"><input type="text" name="strTeamDtl" id="strTeamDtl" value="<%=tTeamDtl%>" placeholder="세부팀명을 입력해주세요."></span>
      </td>
    </tr>

  </tbody>
</table>
  <!-- S: table_btn btn-center-list -->
  <div class="table_btn btn-center-list">
    <a href="#" id="btnsave" class="btn btn-confirm" onclick="inputGameParticipateTeam_frm(<%=NowPage%>);" accesskey="i">등록(I)</a>
    <a href="#" id="btnupdate" class="btn" onclick="updateGameParticipateTeam_frm(<%=NowPage%>);" accesskey="e">수정(E)</a>
    <a href="#" id="btndel" class="btn btn-red" onclick="delGameParticipateTeam_frm(<%=NowPage%>);" accesskey="r">삭제(R)</a>
  </div>
  <!-- E: table_btn btn-center-list -->