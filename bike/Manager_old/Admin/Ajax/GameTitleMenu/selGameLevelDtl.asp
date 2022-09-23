<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  
  REQ = Request("Req")
  'REQ = "{""tPGameLevelIdx"":""A9DCA2E87B121CA8CEF6B07D880ACE16"",""tIdx"":""4AC9519B3F35C40A5D496D69A6B07B65"",""tGameLevelIdx"":""A9DCA2E87B121CA8CEF6B07D880ACE16"",""beforeNowPage"":""1"",""NowPage"":""1"",""i2"":1,""pType"":""level"",""iSearchText"":"""",""iSearchCol"":""T"",""CMD"":2,""tGameLevelDtlIdx"":""A327F210BC95C0AD77E9C05F7781572E""}"
  'REQ = "{""tPGameLevelIdx"":""A9DCA2E87B121CA8CEF6B07D880ACE16"",""tIdx"":""4AC9519B3F35C40A5D496D69A6B07B65"",""tGameLevelIdx"":""A9DCA2E87B121CA8CEF6B07D880ACE16"",""beforeNowPage"":""1"",""NowPage"":""1"",""i2"":1,""pType"":""level"",""iSearchText"":"""",""iSearchCol"":""T"",""CMD"":2,""tGameLevelDtlIdx"":""80589E380ADEE92308F49062EF2DCDD6""}"


  

  Set oJSONoutput = JSON.Parse(REQ)
  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  crypt_tGameLevelIdx =crypt.EncryptStringENC(tGameLevelIdx)
  GameLevelDtlIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIdx))
  crypt_GameLevelDtlIdx =crypt.EncryptStringENC(GameLevelDtlIdx)
  NowPage=fInject(oJSONoutput.NowPage)

  SelLeague = 0
  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B010'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayPlayLevelType = LRs.getrows()
  End If

  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B004'"
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayGameType = LRs.getrows()
  End If
  
  'LSQL = " SELECT TOP 1  GameLevelDtlidx ,GameLevelidx ,PlayLevelType ,PlayLevelGroup ,GameType ,StadiumNumber ,TotRound ,GameDay ,GameTime ,EnterType ,EntryCnt ,Level ,LevelDtlName ,DelYN,ViewYN ,EditDate ,WriteDate, LevelJooName, JooNum  "
  LSQL = " SELECT TOP 1  GroupGameGb "
  LSQL = LSQL & "   FROM  tblGameLevel  "
  LSQL = LSQL & " WHERE GameLevelidx = "  & tGameLevelIdx  & ""
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGroupGameGb = LRS("GroupGameGb")
      LRs.MoveNext
    Loop
  End IF

  LSQL = "SELECT StadiumIDX, StadiumName, StadiumCourt   "
  LSQL = LSQL & "FROM  tblStadium " 
  LSQL = LSQL & "Where GameTitleIDX = '" & tIdx & "' And DelYN = 'N'"
  LSQL = LSQL & "ORDER BY WriteDate  DESC"

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayStadiums = LRs.getrows()
  End If

  'LSQL = " SELECT TOP 1  GameLevelDtlidx ,GameLevelidx ,PlayLevelType ,PlayLevelGroup ,GameType ,StadiumNumber ,TotRound ,GameDay ,GameTime ,EnterType ,EntryCnt ,Level ,LevelDtlName ,DelYN,ViewYN ,EditDate ,WriteDate, LevelJooName, JooNum  "
  LSQL = " SELECT TOP 1  GameLevelDtlidx ,GameLevelidx ,PlayLevelType ,PlayLevelGroup ,GameType ,StadiumNumber,StadiumNum ,TotRound ,GameDay ,GameTime ,EnterType ,EntryCnt ,Level ,LevelDtlName ,DelYN,ViewYN ,EditDate ,WriteDate,LevelJooNum,LevelJooDivision,JooRank, FullGameYN"
  LSQL = LSQL & "   FROM  tblGameLevelDtl  "
  LSQL = LSQL & " WHERE GameLevelDtlidx = "  & GameLevelDtlIdx  & ""
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tPlayLevelType = LRS("PlayLevelType")
      tGameType = LRS("GameType")
      tStadiumNumber = LRS("StadiumNumber")
      tStadiumNum = LRS("StadiumNum")
      tTotRound = LRS("TotRound")
      tGameDay = LRS("GameDay")
      tGameTime = LRS("GameTime")
      tEntryCnt = LRS("EntryCnt")
      tLevelJooNum = LRS("LevelJooNum")
      tLevelJooDivision= LRS("LevelJooDivision")
      tViewYN = LRS("ViewYN")
      tJooRank= LRS("JooRank")
      tFullGameYN= LRS("FullGameYN")
      LRs.MoveNext
    Loop
  End IF

  IF IsNumeric(tTotRound) = false Then
    tTotRound = 0
  END IF
  'Response.write "tTotRound : " & (tTotRound ="") & "<br/>"
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.write  "tGroupGameGb" & tGroupGameGb
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL
%>
<%'Response.Write "tPlayLevelTypetPlayLevelTypetPlayLevelTypetPlayLevelTypetPlayLevelTypetPlayLevelType" & tPlayLevelType & "<bR>"%>
<%'Response.Write "tLevelJooNumtLevelJooNumtLevelJooNumtLevelJooNumtLevelJooNumtLevelJooNumtLevelJooNumtLevelJooNum" & tLevelJooNum & "<bR>"%>

<input type="hidden" id="selGameLeveDtlIIdx" value="<%=crypt_GameLevelDtlIdx%>">
<table class="navi-tp-table">
  <caption class="sr-only">예선/본선 대진표</caption>
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
      <th scope="row"><span class="l_con"></span>신청팀현황</th>  
      <%
        IF tGroupGameGb = "B0030001" Then
          LSQL = " SELECT count(*) as RequestCnt "
          LSQL = LSQL & " FROM  tblGameRequestGroup "
          LSQL = LSQL & " WHERE GameTitleIDX = '" &  tIdx & "' AND  GameLevelidx = '" & tGameLevelIdx & "' AND DelYN='N' "
          'Response.Write "LSQL" & LSQL
        End If
        IF tGroupGameGb = "B0030002" Then
          LSQL = " SELECT count(*) as RequestCnt "
          LSQL = LSQL & " FROM  tblGameRequestTeam  "
          LSQL = LSQL & " WHERE GameTitleIDX = '" &  tIdx & "' AND  GameLevelidx = '" & tGameLevelIdx & "' AND DelYN='N' "
        End If
        Set LRs = DBCon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
              tRequestCnt = LRs("RequestCnt")
            LRs.MoveNext
          Loop
        End If 
      %>
      <td>
        <%=tRequestCnt%>팀
      </td>
      
      <th scope="row"><span class="l_con"></span>구분</th>
      <td id="sel_PlayLevelType">
        <select id="selPlayLevelType" onchange="OnPlayLevelTypeChanged(this.value)" class="sel-ctr">
          <% If IsArray(arrayPlayLevelType) Then
              For ar = LBound(arrayPlayLevelType, 2) To UBound(arrayPlayLevelType, 2) 
                playLevelTypeCode   = arrayPlayLevelType(0, ar) 
                crypt_playLevelTypeCode = crypt.EncryptStringENC(playLevelTypeCode)
                playLevelTypeName = arrayPlayLevelType(1, ar) 

                IF tPlayLevelType = playLevelTypeCode Then
          %>
                <option value="<%=crypt_playLevelTypeCode%>" selected><%=playLevelTypeName%></option>
          <%Else%>
                <option value="<%=crypt_playLevelTypeCode%>"><%=playLevelTypeName%></option>
          <%
              End if
              Next
            End If      
          %>
        </select>-
        <select id="selLevelJooNum" class="sel-ctr">
          <option value="">미선택</option>
          <%
            For i = 1 To 40

            if i = tLevelJooNum Then
          %>
            <option value="<%=i%>" selected><%=i%></option>
            <%Else%>
            <option value="<%=i%>"><%=i%></option>
          <%
              End if
            Next
          %>
        </select>조
      </td>
      <%
        GameTypeCnt = 0
        SelLeague = 0
      %>

      <th scope="row"><span class="l_con"></span>경기방식</th>
      <td id="sel_GameType">
        <select id="selGameType" onchange="onGameTypeChanged(this.value)" class="sel-ctr">
          <% If IsArray(arrayGameType) Then
              For ar = LBound(arrayGameType, 2) To UBound(arrayGameType, 2) 
                GameTypeCnt = GameTypeCnt + 1
                GameTypeCode    = arrayGameType(0, ar) 
                crypt_GameTypeCode = crypt.EncryptStringENC(GameTypeCode)
                GameTypeName  = arrayGameType(1, ar) 
              IF tGameType = GameTypeCode Then
                If GameTypeCode = "B0040001" Then
                  SelLeague = 1
                End IF

          %>
              <option value="<%=crypt_GameTypeCode%>" selected><%=GameTypeName%></option>
              <%Else%>
              <option value="<%=crypt_GameTypeCode%>"><%=GameTypeName%></option>
            <%
              End if
              Next
            End If      
          %>
        </select> 

        <select id="selTotalRound" <% if cdbl(SelLeague) = 1 Then %>style="visibility:hidden;"<% End IF%> class="sel-ctr" >
          <option value="512" <% if cdbl(tTotRound) = 512 Then Response.Write "selected" End if %> >512강</option>
          <option value="256" <% if cdbl(tTotRound) = 256 Then Response.Write "selected"   End if %> >256강</option>
          <option value="128"   <% if cdbl(tTotRound) = 128 Then   Response.Write "selected"  End if   %> >128강</option>  
          <option value="64"   <% if cdbl(tTotRound) = 64 Then   Response.Write "selected"  End if   %> > 64강</option>
          <option value="32"   <% if cdbl(tTotRound) = 32 Then   Response.Write "selected"  End if   %> > 32강</option>
          <option value="16"  <% if cdbl(tTotRound) = 16 Then  Response.Write "selected"   End if  %> >16강</option>
          <option value="8"  <% if cdbl(tTotRound) = 8 Then  Response.Write "selected"   End if  %> >8강</option>
          <option value="4"  <% if cdbl(tTotRound) = 4 Then  Response.Write "selected"   End if  %> >4강</option>
          <option value="2" <% if cdbl(tTotRound) = 2 Then Response.Write "selected"   End if %> >2강</option>
        </select>  
      </td>
    </tr>
    <tr>
      <th scope="row"><span class="l_con"></span>경기장</th>
      <td>
      <div class="ymd-list">
        <select id="selStadiums" name="selStadiums">
        <option value="0">==선택==</option>
        <%
          If IsArray(arrayStadiums) Then
            For ar = LBound(arrayStadiums, 2) To UBound(arrayStadiums, 2) 
              arrayStadiumCode    = arrayStadiums(0, ar) 
              crypt_arrayStadiumCode = crypt.EncryptStringENC(arrayStadiumCode)
              arrayStadiumName  = arrayStadiums(1, ar) 
              arrayCourts = arrayStadiums(2, ar) 

              if(CDBL(tStadiumNum) = CDBL(arrayStadiumCode) ) Then
        %>
        <option value="<%=crypt_arrayStadiumCode%>" selected><%=arrayStadiumName%> 코트 : <%=arrayCourts%></option>
        <%Else%>
          <option value="<%=crypt_arrayStadiumCode%>"><%=arrayStadiumName%> 코트 : <%=arrayCourts%></option>
        <%
          End IF
          Next
          End If    
        %>
        </select> 
      </td>
      <!--
      <th scope="row"><span class="l_con"></span>최소인원</th>
      <td>
      <div class="ymd-list">
        <input type="text" id="txtEntryCnt" value="<%=tEntryCnt%>">
      </div>
      </td>
      -->
      <th scope="row"><span class="l_con"></span>본선진출</th>
      <td>
          <div class="ymd-list">
          <span id="sel_JooRank">
          <input type="text" id="txtJooRank" name="txtJooRank" value="<%=tJooRank%>" >
        </span>
      </td>

      <th scope="row" id="thJooDivision" <% if tPlayLevelType = "B0100002" Then %>style="visibility:hidden;"<% End IF%>><span class="l_con"></span>조 생성</th>
      <td id="tdJooDivision" <% if tPlayLevelType = "B0100002" Then %>style="visibility:hidden;"<% End IF%>>
      <div class="ymd-list">
        <input type="text" id="txtJooDivision" value="0">
      </td>

    </tr>

    <tr>
      <th scope="row"><span class="l_con"></span>경기날짜</th>
      <td>
      <div class="ymd-list">
        <span id="sel_GameTime">
          <input type="text" id="selGameDay" value="<%=tGameDay%>" class="date_ipt">
        </span>
      </div>
      </td>

      <th scope="row"><span class="l_con"></span>경기시간</th>
      <td>
      <!-- S: ymd-list -->
       <div class="ymd-list">
        <span id="sel_GameTime">
          <input type="text" id="selGameTime" value="<%=tGameTime%>" class="time_ipt">
        </span>
      </div>
      <!-- E: ymd-list -->
      </td>
      
      <th scope="row"><span class="l_con"></span>노출여부</th>
      <td>
        <select id="selViewYN">
        <%if tViewYN = "Y" Then%>
          <option value="Y" Selected>노출</option>
          <option value="N" >미노출</option>
        <%ELSE%>
          <option value="Y">노출</option>
          <option value="N" Selected>미노출</option>
        <%END IF%> 
        </select> 
      </td>
    </tr>
    <tr>
      <th scope="row"><span class="l_con"></span>풀게임여부</th>
      <td>
        <select id="selFullGameYN">
          <%if tFullGameYN ="Y" Then %>
          <option value="Y" Selected>풀게임</option>
          <option value="N">미선택</option>
          <%Else%>
          <option value="Y" >풀게임</option>
          <option value="N" Selected>미선택</option>
          <%End IF%>
        </select>
      </td>
    </tr>
  
  </tbody>
</table>

<!-- S: table_btn btn-center-list -->
<div class="table_btn btn-center-list">
<a href="#" id="btnsave" class="btn btn-confirm"  onclick='inputGameLevelDtl_frm(<%=strjson%>);' accesskey="i">등록(I)</a>
<a href="#" id="btnupdate" class="btn btn-gray" onclick='updateGameLevelDtl_frm(<%=strjson%>);' accesskey="e">수정(E)</a>
<a href="#" id="btndel" class="btn btn-red" onclick='delGameLevelDtl_frm(<%=strjson%>);' accesskey="r">삭제(R)</a>
</div>
<!-- E: table_btn btn-center-list -->