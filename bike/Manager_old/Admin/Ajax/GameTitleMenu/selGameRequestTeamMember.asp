<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""NowPage"":""1"",""tGameRequestTeamPlayerIdx"":""D7AB5E8D8F6CF0A2B0B29B0512C96862"",""CMD"":3,""tGameRequestTeamIdx"":""EDA53EB24518F23F2730F910B5FDFA9D"",""tGameTitleIDX"":""DE06405500BB0584EDD42C189431D8AA"",""tGameTitleNm"":""제47회 전국소년체육대회test"",""tGameLevelIdx"":""93C6CFBF8D2865C5B63BD45787FC134D"",""tGroupGameGbNm"":""단체전"",""tGroupGameGb"":"""",""tLevel"":"""",""tLevelNm"":""""}"
  Set oJSONoutput = JSON.Parse(REQ)

	tGameRequestTeamPlayerIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestTeamPlayerIdx))
  crypt_tGameRequestTeamPlayerIdx = crypt.EncryptStringENC(tGameRequestTeamPlayerIdx)
  
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

  NowPage = fInject(oJSONoutput.NowPage)

  'Response.Write "tGameRequestTeamMemberIdx : " & tGameRequestTeamMemberIdx & "<BR>"
  'Response.Write "tIdx : " & tIdx & "<BR>"
  'Response.Write "tGameLevelIdx : " & tGameLevelIdx & "<BR>"
  'Response.Write "tGroupGameGb : " & tGroupGameGb & "<BR>"
  'Response.Write "tLevel : " & tLevel & "<BR>"
  'Response.Write "tGameTitleName : " & tGameTitleName & "<BR>"
  'Response.Write "tGroupGameGbNm : " & tGroupGameGbNm & "<BR>"
  'Response.Write "tLevelNm : " & tLevelNm & "<BR>"

  '대회 정보
  LSQL = " SELECT Top 1 e.PubName as GroupGameGbNm, b.TeamGbNm as TeamGbNm , Sex = (case a.Sex when  'man'then	'남자'when 'woman'then '여자'else '혼합'End ), c.PubName as PlayType, a.Level, d.LevelNm as LevelNm, a.GroupGameGb "
  LSQL = LSQL & "  FROM tblGameLevel a "
	LSQL = LSQL & "  LEFT JOIN tblTeamGbInfo b on a.TeamGb = b.TeamGb and b.DelYN ='N' "
	LSQL = LSQL & "  LEFT JOIN tblPubcode c on a.PlayType = c.PubCode and  c.DelYN ='N' "
	LSQL = LSQL & "  LEFT JOIN tblLevelInfo d on a.Level  = d.Level and d.DelYN = 'N' "
  LSQL = LSQL & "  LEFT JOIN tblPubcode e on a.GroupGameGb= e.PubCode and e.DelYN ='N' "	
  LSQL = LSQL & " WHERE a.DelYN = 'N' and GameTitleIDX = " & tidx & " and a.GameLevelidx = " & tGameLevelIdx
	'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL & "<br>"
  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tTeamGbNm = LRS("TeamGbNm")
			tSex = LRS("Sex")
      crypt_tSex = crypt.EncryptStringENC(tSex)
			tPlayType = LRS("PlayType")
			tLevelNm = LRS("LevelNm")
      tLevel = LRS("Level")
      crypt_tLevel = crypt.EncryptStringENC(tLevel)
			tGroupGameGb = LRS("GroupGameGb")
      crypt_tGroupGameGb = crypt.EncryptStringENC(tLevel)
      tGroupGameGbNm = LRS("GroupGameGbNm")
      LRs.MoveNext
    Loop
  End IF

  '팀 정보
  LSQL = " SELECT Top 1 b.Team, b.TeamNm "
  LSQL = LSQL & " FROM tblGameRequestTeam a "
  LSQL = LSQL & " Left Join tblTeamInfo b on a.Team = b.Team and b.DelYN='N' "
  LSQL = LSQL & "   Where a.DelYN = 'N' and GameRequestTeamIDX =" & tGameRequestTeamIdx 

  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tTeam = LRS("Team")
			tTeamNm = LRS("TeamNm")
      LRs.MoveNext
    Loop
  End IF

  '선수정보
  'LSQL = " SELECT TOP 1  GameLevelDtlidx ,GameLevelidx ,PlayLevelType ,PlayLevelGroup ,GameType ,StadiumNumber ,TotRound ,GameDay ,GameTime ,EnterType ,EntryCnt ,Level ,LevelDtlName ,DelYN,ViewYN ,EditDate ,WriteDate, LevelJooName, JooNum  "
  LSQL = " SELECT TOP 1 GameRequestPlayerIDX , GameRequestGroupIDX , GameTitleIDX , GameLevelIDX ,  MemberIDX , isnull(b.TeamNm,'') as Team_OriginNM, MemberName , isnull(b.Team,'') as Team, TeamDtl, Team_Origin"
  LSQL = LSQL & " FROM  tblGameRequestPlayer a "
  LSQL = LSQL & " LEFT JOIN tblTeamInfo b on a.Team_Origin = b.Team and b.DelYN='N' "
  LSQL = LSQL & " WHERE GameRequestPlayerIDX = '"  & tGameRequestTeamPlayerIdx  & "' and a.DelYn ='N' "
  
  'Response.write  "<BR>"
  Response.write "LSQL" & LSQL & "<BR>"
  'Response.write "<BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR><BR>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tMemberName = LRS("MemberName")
      tMemberIDX = LRS("MemberIDX")
      crypt_tMemberIDX = crypt.EncryptStringENC(tMemberIDX)

      tTeam_Origin = LRS("Team_Origin")
      tTeam_OriginNM = LRS("Team_OriginNM")
      
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
       <input type="text" id="GameRequestPlayerIDX" name="GameRequestPlayerIDX" value="<%=tGameRequestTeamPlayerIdx%>">
      </td>
    </tr>
    <tr>
      <th scope="row"><label for="competition-name">대회명</label></th>
      <td><%=tGameTitleName%></td>
      <input type="hidden" name="selGameTitle" id="selGameTitle" value="<%=tGameTitleName%>">
      <input type="hidden" name="selGameTitleIDX" id="selGameTitleIDX" value="<%=crypt_tidx%>">
      <input type="hidden" name="selGameLevelIDX" id="selGameLevelIDX" value="<%=crypt_tGameLevelIdx%>">
      <input type="hidden" name="selGameRequestTeamIdx" id="selGameRequestTeamIdx" value="<%=crypt_tGameRequestTeamIdx%>">
      <th scope="row">구분</th>
      <td><%=tGroupGameGbNm%></td>
      <input type="hidden" name="GroupGameGb" id="GroupGameGb" value="<%=crypt_tGroupGameGb%>">
      <input type="hidden" name="GroupGameGbNm" id="GroupGameGbNm" value="<%=tGroupGameGbNm%>">
    </tr>
    <tr>
      <th scope="row">성별</th>
      <td> <%=tSex%> </td>
      <input type="hidden" name="Sex" id="Sex" value="<%=tSex%>">
      <th scope="row">종목</th>
      <td><%=tLevelNm%></td>
      <input type="hidden" name="Level" id="Level" value="<%=crypt_tLevel%>">
      <input type="hidden" name="LevelNm" id="LevelNm" value="<%=tLevelNm%>">
    </tr>
    <tr>
      <th scope="row">팀명</th>
      <td> <%=tTeamNm%> </td>
      <input type="hidden" name="hiddenTeam" id="hiddenTeam" value="<%=tTeam%>">
      <input type="hidden" name="hiddenTeamNm" id="hiddenTeamNm" value="<%=tTeamNm%>">
      <th scope="row">팀코드</th>
      <td> <%=tTeam%> </td>
    <tr>
    <tr>
      <th scope="row">선수명</th>
      <td>
        <span class="con"><input type="text" name="strMember" id="strMember" value="<%=tMemberName%>"></span>
        <input type="hidden" name="hiddenMemberName" id="hiddenMemberName" value="<%=tMemberName%>">
        <input type="hidden" name="hiddenMemberIdx" id="hiddenMemberIdx" value="<%=crypt_tMemberIDX%>">
        <input type="hidden" name="hiddenGameRequestPlayerIDX" id="hiddenGameRequestPlayerIDX" value="<%=crypt_tGameRequestTeamPlayerIdx%>">
      </td>
      <th scope="row"><span class="l_con"></span>팀명</th>
      <td id="tdTeam" name ="tdTeam"><%=tTeam_OriginNM%></td>
      <input type="hidden" name="hiddenTeamCode" id="hiddenTeamCode" value="<%=tTeam_Origin %>">
      <input type="hidden" name="hiddenTeamName" id="hiddenTeamName" value="<%=tTeam_OriginNM%>">
    </tr>
  </tbody>
</table>


<!-- S: table_btn btn-center-list -->
  <div class="table_btn btn-center-list">
    <a href="#" id="btnsave" class="btn btn-confirm" onclick="inputGameParticipateTeamMember_frm(1);" accesskey="i">등록(I)</a>
    <a href="#" id="btnupdate" class="btn" onclick="updateGameParticipateTeamMember_frm(<%=NowPage%>);" accesskey="e">수정(E)</a>
    <a href="#" id="btndel" class="btn btn-red" onclick="delGameParticipateTeamMember_frm(<%=NowPage%>);" accesskey="r">삭제(R)</a>
  </div>
<!-- E: table_btn btn-center-list -->