<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":3,""tGameRequestGroupIdx"":""DF5566468F556C1EFF2B0AA570F82103"",""tGameTitleIDX"":""526FFDE5660B3F06ACFE218964EC6917"",""tGameTitleNm"":"" 2017 인천공항 배드민턴 코리안리그 및 전국동호인"",""tGameLevelIdx"":""60B0AEEEA15C3605E7742D82FC4D172C"",""tGroupGameGbNm"":""개인전"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tPlayTypeNm"":""복식"",""tPlayType"":""A932F76713F8A9728D92A52C4795E4B7"",""tLevel"":""EEBEFA8B49D8E9CF3D0D632F7C4F48E8"",""tLevelNm"":""60대"",""tSex"":""남자""}"

  Set oJSONoutput = JSON.Parse(REQ)
	tGameRequestGroupIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestGroupIdx))
  crypt_tGameRequestGroupIdx =crypt.EncryptStringENC(tGameRequestGroupIdx)

  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))
  crypt_tidx = crypt.EncryptStringENC(tIdx)

  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  crypt_tGameLevelIdx =crypt.EncryptStringENC(tGameLevelIdx)

  tGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
  crypt_tGroupGameGb = fInject(crypt.EncryptStringENC(tGroupGameGb))

  tPlayType = fInject(crypt.DecryptStringENC(oJSONoutput.tPlayType))
  crypt_tPlayType = fInject(crypt.EncryptStringENC(tPlayType))


  tLevel = fInject(crypt.DecryptStringENC(oJSONoutput.tLevel))
  crypt_tLevel = fInject(crypt.EncryptStringENC(tLevel))

  tSex = fInject(oJSONoutput.tSex)
  tGameTitleName = fInject(oJSONoutput.tGameTitleNm)
  tGroupGameGbNm = fInject(oJSONoutput.tGroupGameGbNm)
  tPlayTypeNm = fInject(oJSONoutput.tPlayTypeNm)
  

  tLevelNm = fInject(oJSONoutput.tLevelNm)

  LSQL = " SELECT Top 1 GameRequestGroupIDX  ,GameTitleIDX  ,GameRequestTeamIDX  ,GameLevelIDX  ,GameTitleName ,Team ,EnterType , EditDate,WriteDate ,DelYN  "
  LSQL = LSQL & "   FROM  tblGameRequestGroup  "
  LSQL = LSQL & " WHERE GameRequestGroupIDX = '"  & tGameRequestGroupIdx  & "' and DelYn ='N' "
  
   'Response.write "LSQL" & LSQL & "<BR><BR><BR><BR><BR>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameRequestGroupIDX = LRS("GameRequestGroupIDX")
      tGameRequestGroupTeam = LRS("Team")
      LRs.MoveNext
    Loop
  End IF

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

<table class="navi-tp-table">
  <caption class="sr-only">대회정보관리 기본정보</caption>
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
      <th scope="row"><span class="l_con"></span>번호</th>
      <td>
       <span class="con">
         <input type="text" id="GameRequestGroupIDX" name="GameRequestGroupIDX" value="<%=tGameRequestGroupIDX%>">
       <input type="hidden" id="hiddenGameRequestGroupIDX" name="hiddenGameRequestGroupIDX" value="<%=crypt_tGameRequestGroupIdx%>">
       </span>
      </td>
    </tr>
    <tr>
      <th scope="row"><span class="l_con"></span>대회명</th>
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
      <th scope="row"><span class="l_con"></span>성별</th>
      <td> <%=tSex%> </td>
      <input type="hidden" name="Sex" id="Sex" value="<%=tSex%>">
      <th scope="row"><span class="l_con"></span>종목</th>
      <td><%=tLevelNm%></td>
      <input type="hidden" name="Level" id="Level" value="<%=crypt_tLevel%>">
      <input type="hidden" name="LevelNm" id="LevelNm" value="<%=tLevelNm%>">
    </tr>
    <tr>
     <th scope="row"><span class="l_con"></span>타입</th>
      <td>
        <%=tPlayTypeNm%>
        <input type="hidden" name="hiddenPlayType" id="hiddenPlayType" value="<%=crypt_tPlayType%>">
        <input type="hidden" name="hiddenPlayTypeNm" id="hiddenPlayTypeNm" value="<%=tPlayTypeNm%>">
      </td>
    </tr>

    <%
      Dim Cnt
      'LSQL = " SELECT TOP 1  GameLevelDtlidx ,GameLevelidx ,PlayLevelType ,PlayLevelGroup ,GameType ,StadiumNumber ,TotRound ,GameDay ,GameTime ,EnterType ,EntryCnt ,Level ,LevelDtlName ,DelYN,ViewYN ,EditDate ,WriteDate, LevelJooName, JooNum  "
      LSQL = " SELECT GameRequestPlayerIDX  ,GameRequestGroupIDX ,GameTitleIDX ,GameLevelIDX ,MemberIDX ,TeamName ,MemberName,Team  "
      LSQL = LSQL & "   FROM  tblGameRequestPlayer  "
      LSQL = LSQL & " WHERE GameRequestGroupIDX = '"  & tGameRequestGroupIDX  & "' and DelYn ='N' "
      'Response.write "<BR>" 
      'Response.write "<BR>" 
      'Response.write "LSQL" & LSQL & "<BR>"
      'Response.write "<BR>" 
       Cnt = 0
      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
          Cnt = Cnt + 1

          IF Cnt = 1 Then
            tGameRequestPlayerIDX = LRS("GameRequestPlayerIDX")
            crypt_tGameRequestPlayerIDX = crypt.EncryptStringENC(tGameRequestPlayerIDX)
            rMemberIDX = LRS("MemberIDX")
            crypt_rMemberIDX = crypt.EncryptStringENC(rMemberIDX)
            rTeamName = LRS("TeamName")
            rMemberName = LRS("MemberName")
            rTeamCode = LRS("Team")
            crypt_rTeamCode = crypt.EncryptStringENC(rTeamCode)
          End IF

          IF Cnt = 2 Then
            tGameRequestPlayerIDX2 = LRS("GameRequestPlayerIDX")
            crypt_tGameRequestPlayerIDX2 = crypt.EncryptStringENC(tGameRequestPlayerIDX2)
            rGameRequestPlayerIDX2 = LRS("GameRequestPlayerIDX")
            rMemberIDX2 = LRS("MemberIDX")
            crypt_rMemberIDX2 = crypt.EncryptStringENC(rMemberIDX)
            rTeamName2 = LRS("TeamName")
            rMemberName2 = LRS("MemberName")
            rTeamCode2 = LRS("Team")
            crypt_rTeamCode2 = crypt.EncryptStringENC(rTeamCode2)
          End IF
          LRs.MoveNext
        Loop
      End IF
    %>
    <tr>
      <th scope="row"><span class="l_con"></span>선수명</th>
      <td>
        <span class="con"><input type="text" name="strMember1" id="strMember1" class="ipt-word" value="<%=rMemberName%>"></span>
        <input type="hidden" name="hiddenMemberName1" id="hiddenMemberName1" value="<%=rMemberName%>"></input>
        <input type="hidden" name="hiddenMemberIdx1" id="hiddenMemberIdx1" value="<%=crypt_rMemberIDX%>"></input>
        <input type="hidden" name="hiddenGameRequestPlayerIDX1" id="hiddenGameRequestPlayerIDX1" value="<%=crypt_tGameRequestPlayerIDX%>"></input>
      </td>
      <th scope="row"><span class="l_con"></span>소속</th>
      <td >
      <div id="tdTeam1" name ="tdTeam1" class="sub_txt">(<%=rTeamName%>)(<%=rTeamCode%>) </div>
      
      <input type="hidden" name="hiddenTeam1" id="hiddenTeam1" value="<%=crypt_rTeamCode%>"></input>
      <input type="hidden" name="hiddenTeamName1" id="hiddenTeamName1" value="<%=rTeamName%>"></input>
      <label><input type="radio" name="majorTeam" value="Team1" <%if tGameRequestGroupTeam = rTeamCode Then%> checked <%End If%>> 대표팀 지정</label>
      </td>
    </tr>
    <% IF tPlayType <> "B0020001" Then%>
    <tr>
      <th scope="row"><span class="l_con"></span>선수명</th>
      <td>
        <span class="con"><span><input type="text" name="strMember2" id="strMember2" value="<%=rMemberName2%>"   class="ipt-word"></span>
        <input type="hidden" name="hiddenMemberName2" id="hiddenMemberName2" value="<%=rMemberName2%>"></input>
        <input type="hidden" name="hiddenMemberIdx2" id="hiddenMemberIdx2" value="<%=crypt_rMemberIDX2%>"></input>
        <input type="hidden" name="hiddenGameRequestPlayerIDX2" id="hiddenGameRequestPlayerIDX2" value="<%=crypt_tGameRequestPlayerIDX2%>"></input>
      </td>
      <th scope="row"><span class="l_con"></span>소속</th>
      <td>
      <div  id="tdTeam2" name ="tdTeam2">(<%=rTeamName2%>)(<%=rTeamCode2%>)</div>
      <input type="hidden" name="hiddenTeam2" id="hiddenTeam2" value="<%=crypt_rTeamCode2%>"></input>
      <input type="hidden" name="hiddenTeamName2" id="hiddenTeamName2" value="<%=rTeamName2%>"></input>
      <label><input type="radio" name="majorTeam" value="Team2"  <%if tGameRequestGroupTeam = rTeamCode2 and rTeamCode <> rTeamCode2 Then%> checked <%End If%>> 대표팀 지정</label>
      </td>
    </tr>
    <% End IF %>
  </tbody>
</table>
 <!-- S: table_btn btn-center-list -->
<div class="table_btn btn-center-list">
  <a href="#" id="btnsave" class="btn btn-add" onclick='inputGameParticipate_frm(<%=strjson%>);' accesskey="i">등록(I)</a>
  <a href="#" id="btnupdate" class="btn btn-confirm" onclick='updateGameParticipate_frm(<%=strjson%>);' accesskey="e">수정(E)</a>
  <a href="#" id="btndel" class="btn btn-red" onclick='delGameParticipate_frm(<%=strjson%>);' accesskey="r">삭제(R)</a>
</div>
<!-- E: table_btn btn-center-list -->