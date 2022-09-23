<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":3,""tGameRequestGroupIdx"":""4F0C40AE3DFDC66664FB7AC6C660689A"",""tGameTitleIDX"":""526FFDE5660B3F06ACFE218964EC6917"",""tGameTitleNm"":"" 2017 인천공항 배드민턴 코리안리그 및 전국동호인"",""tGameLevelIdx"":""A084416B4B0AD1D9740FB3DEC7C2FA0C"",""tGroupGameGbNm"":""개인전"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tLevel"":""EEBEFA8B49D8E9CF3D0D632F7C4F48E8"",""tLevelNm"":""60대"",""tSex"":""남자""}"

  Set oJSONoutput = JSON.Parse(REQ)
	tGameRequestPlayer = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestPlayerIdx))

  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  En_tidx = crypt.EncryptStringENC(tIdx)

  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  En_tGameLevelIdx =crypt.EncryptStringENC(tGameLevelIdx)

  tGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
  En_tGroupGameGb = fInject(crypt.EncryptStringENC(tGroupGameGb))

  tLevel = fInject(crypt.DecryptStringENC(oJSONoutput.tLevel))
  En_tLevel = fInject(crypt.EncryptStringENC(tLevel))

  tSex = fInject(oJSONoutput.tSex)
  tGameTitleName = fInject(oJSONoutput.tGameTitleNm)
  tGroupGameGbNm = fInject(oJSONoutput.tGroupGameGbNm)
  tLevelNm = fInject(oJSONoutput.tLevelNm)
  'LSQL = " SELECT TOP 1  GameLevelDtlidx ,GameLevelidx ,PlayLevelType ,PlayLevelGroup ,GameType ,StadiumNumber ,TotRound ,GameDay ,GameTime ,EnterType ,EntryCnt ,Level ,LevelDtlName ,DelYN,ViewYN ,EditDate ,WriteDate, LevelJooName, JooNum  "
  LSQL = " SELECT TOP 1   GameRequestPlayerIDX  ,GameRequestGroupIDX ,GameTitleIDX ,GameLevelIDX ,MemberIDX ,TeamName ,MemberName  ,TeamCode  "
  LSQL = LSQL & "   FROM  tblGameRequestPlayer  "
  LSQL = LSQL & " WHERE GameRequestPlayerIDX = '"  & tGameRequestPlayer  & "' and DelYn ='N' "
   'Response.write "LSQL" & LSQL & "<BR>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      rGameRequestPlayerIDX = LRS("GameRequestPlayerIDX")
      rGameRequestGroupIDX = LRS("GameRequestGroupIDX")
      rGameTitleIDX = LRS("GameTitleIDX")
      rGameLevelIDX = LRS("GameLevelIDX")
      rMemberIDX = LRS("MemberIDX")
      En_rMemberIDX = crypt.EncryptStringENC(rMemberIDX)
      rTeamName = LRS("TeamName")
      rMemberName = LRS("MemberName")
      rTeamCode = LRS("TeamCode")
      En_rTeamCode = crypt.EncryptStringENC(rTeamCode)
      LRs.MoveNext
    Loop
  End IF
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

<table class="navi-tp-table">
  <caption>대회정보관리 기본정보</caption>
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
       <input type="text" id="GameRequestPlayerIDX" name="GameRequestPlayerIDX" value="<%=rGameRequestPlayerIDX%>">
      </td>
    </tr>
    <tr>
      <th scope="row"><label for="competition-name">대회명</label></th>
      <td><%=tGameTitleName%></td>
      <input type="hidden" name="selGameTitle" id="selGameTitle" value="<%=tGameTitleName%>">
      <input type="hidden" name="selGameTitleIDX" id="selGameTitleIDX" value="<%=En_tidx%>">
      <input type="hidden" name="selGameLevelIDX" id="selGameLevelIDX" value="<%=En_tGameLevelIdx%>">
      <th scope="row">구분</th>
      <td><%=tGroupGameGbNm%></td>
      <input type="hidden" name="GroupGameGb" id="GroupGameGb" value="<%=En_tGroupGameGb%>">
      <input type="hidden" name="GroupGameGbNm" id="GroupGameGbNm" value="<%=tGroupGameGbNm%>">
    </tr>
    <tr>
      <th scope="row">성별</th>
      <td> <%=tSex%> </td>
      <input type="hidden" name="Sex" id="Sex" value="<%=tSex%>">
      <th scope="row">종목</th>
      <td><%=tLevelNm%></td>
      <input type="hidden" name="Level" id="Level" value="<%=En_tLevel%>">
      <input type="hidden" name="LevelNm" id="LevelNm" value="<%=tLevelNm%>">
      <th scope="row"></th>
      <td></td>
    </tr>
    <tr>
     <th scope="row">타입</th>
      <td>
        <%=tPlayTypeNm%>
        <input type="hidden" name="hiddenPlayType" id="hiddenPlayType" value="<%=crypt_tPlayType%>">
        <input type="hidden" name="hiddenPlayTypeNm" id="hiddenPlayTypeNm" value="<%=tPlayTypeNm%>">
      </td>

    </tr>

    <tr>
      <th scope="row">선수명</th>
      <td>
        <span><input type="text" name="strMember1" id="strMember1" placeholder="" value="<%=rMemberName%>"></span>
        <input type="hidden" name="hiddenMemberName1" id="hiddenMemberName1" value="<%=rMemberName%>">
        <input type="hidden" name="hiddenMemberIdx1" id="hiddenMemberIdx1" value="<%=En_rMemberIDX%>">
      </td>
      <th scope="row">소속</th>
      <td >
       <div id="tdTeam1" name ="tdTeam1"><%=rTeamName%></div>
      <input type="hidden" name="hiddenTeam1" id="hiddenTeam1" value="<%=En_rTeamCode%>">
      <input type="hidden" name="hiddenTeamName1" id="hiddenTeamName1" value="<%=rTeamName%>">
      </td>
    </tr>

    <% IF tPlayType <> "B0020001" Then%>
    <tr>
      <th scope="row">선수명</th>
      <td>
        <span><input type="text" name="strMember2" id="strMember2" placeholder=""></span>
        <input type="hidden" name="hiddenMemberName2" id="hiddenMemberName2" value="">
        <input type="hidden" name="hiddenMemberIdx2" id="hiddenMemberIdx2" value="">
      </td>
      <th scope="row">소속</th>
      <td id="tdTeam2" name ="tdTeam2"><%=rTeamName%></td>
      <div id="tdTeam1" name ="tdTeam1"><%=rTeamName%></div>
      <input type="hidden" name="hiddenTeam2" id="hiddenTeam2" value="">
      <input type="hidden" name="hiddenTeamName2" id="hiddenTeamName2" value="">
    </tr>
    <% End IF %>
  </tbody>
</table>
