  
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
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"
  REQ = Request("Req")
  'REQ = "{""CMD"":7,""tGameTitleIDX"":""A0B63180CC3215B403232E31C8E393B4"",""tStadiumIDX"":""513EC1EF8E8DB3C6CC9726D3D288257A"",""tStadiumName"":""한라중학교"",""tGameDay"":""2018-07-13""}"
  Set oJSONoutput = JSON.Parse(REQ)
  

  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
      GameTitleIDX = ""
      DEC_GameTitleIDX = ""
    Else
      GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
    End If
  End if  

  If hasown(oJSONoutput, "tStadiumIDX") = "ok" then
    If ISNull(oJSONoutput.tStadiumIDX) Or oJSONoutput.tStadiumIDX = "" Then
      StadiumIDX = ""
      DEC_StadiumIDX = ""
    Else
      StadiumIDX = fInject(oJSONoutput.tStadiumIDX)
      DEC_StadiumIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tStadiumIDX))
    End If
  End if  

    If hasown(oJSONoutput, "tStadiumName") = "ok" then
    If ISNull(oJSONoutput.tStadiumName) Or oJSONoutput.tStadiumName = "" Then
      StadiumName = ""
      DEC_StadiumName = ""
    Else
      StadiumName = fInject(oJSONoutput.tStadiumName)
      DEC_StadiumName = fInject(oJSONoutput.tStadiumName)
    End If
  End if  


  If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = ""
      DEC_GameDay = ""
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(oJSONoutput.tGameDay)
    End If
  End if  

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.Write "`##`"
%>


  
  <!-- s: table-title -->
  <div class="table-title">
    <h2><%=DEC_StadiumName%></h2>
    <div class="r-btn">
      <a href="javascript:restoreAutoGameSchedule();">
        <i class="fas fa-undo copy"></i>
      </a>
      <a href="javascript:deleteAutoGameSchedule();">
        <i class="far fa-trash-alt"></i>
      </a>
    </div>
  </div>
  <!-- e: table-title -->
  <!-- s: table-list -->
  <div class="table-list">
    <table>
      <tr>
        <th>경기구분</th>
        <th>지정코트</th>
        <th>종별</th>
        <th>경기유형</th>
        <th>조</th>
        <th>경기수</th>
        <th>그룹</th>
        <th>순서</th>
        <th>
          <input type="checkbox" class="checkbox" id="allCheck" onClick="javascript:initControl();"/>
        </th>
      </tr>

    <%
      LSQL = " EXEC tblGameSchedule_STR '" & DEC_GameTitleIDX & "', '" &  DEC_StadiumIDX &"', '" & DEC_GameDay & "'"
      Set LRs = Dbcon.Execute(LSQL)
      Response.Write "LSQL : " & LSQL & "<BR/>"
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
          tGameScheduleIDX  =LRs("GameScheduleIDX")
          tGameLevelIdx  =LRs("GameLevelIdx")
          
          crypt_GameScheduleIDX= crypt.EncryptStringENC(tGameScheduleIDX)
          tGroupGameGbNM =LRs("GroupGameGbNM")
          tGroupGameGb =LRs("GroupGameGb")
          tStartCourt =LRs("StartCourt" )
          tEndCourt  =LRs("EndCourt")
          tTeamGbNM  =LRs("TeamGbNM")
          tLevelNM  =LRs("LevelNM")
          tLevelJooNameNM  =LRs("LevelJooName")
          tPlayLevelTypeNM  =LRs("PlayLevelTypeNM")
          tGameGroupOrder  =LRs("GameGroupOrder")
          tGameOrder  =LRs("GameOrder")
          tTotalReadyTourney = LRs("TotalReadyTourney")
          tTotalFinalTourney = LRs("TotalFinalTourney")
          tTotalTourney = LRs("TotalTourney")
          tMaxGameOrder  =LRs("MaxGameOrder")
          tGameLevelDtlCount  =LRs("GameLevelDtlCount")
          tMaxGameGroupOrder = tMaxGameOrder
          tUpDateGameGroupOrder  =LRs("upDateGameGroupOrder")

          tSexNm  =LRs("SexNm")
          tPlayTypeNM  =LRs("PlayTypeNM")

          IF tUpDateGameGroupOrder = "N" Then
             LSQL2 = " UPDATE tblGameSchedule "
             LSQL2 = LSQL2 & "SET upDateGameGroupOrder = 'Y'"
            IF CDBL(tGameLevelDtlCount) > 8 Then
              LSQL2 = LSQL2 & ",GameGroupOrder = '2'"
            End IF
            LSQL2 = LSQL2 & "Where GameScheduleIDX= '"  & tGameScheduleIDX & "'"
            Dbcon.Execute(LSQL2)
          End IF
      %>
      <tr>
        <td>
          <a href="#" class="individual"><%=tGroupGameGbNM%></a>
        </td>
        <td>
          <span>
          <%
            IF Len(tStartCourt) > 0 And Len(tEndCourt) > 0 Then
                Response.Write tStartCourt & "~" & tEndCourt & "코트"
            Else
                Response.Write "전체"
            End IF
          %>
          </span>
        </td>
        <td>
          <span><%=tTeamGbNM%><span class="red-font"><%=tLevelNM%><%=tLevelJooNameNM%>
          <%
            IF Len(tSexNm) > 0 And  Len(tPlayTypeNM) > 0 Then
              Response.Write Left(tSexNm,1) & Left(tPlayTypeNM,1)
            ElseIF Len(tSexNm) > 0 THEN
              Response.Write tSexNm
            ElseIF Len(tPlayTypeNM) > 0 Then
              Response.Write tPlayTypeNM
            ENd IF
          %>
          </span></span>
        </td>
        <td>
          <span>
          
          <%
            IF Len(tPlayLevelTypeNM) > 0 Then
              Response.Write tPlayLevelTypeNM
            Else
              Response.Write "전체"
            End IF
          
          %></span>
        </td>
        <td>
          <span><%=tGameLevelDtlCount%></span>
        </td>
        <td>
          <span>
          <%
            IF tPlayLevelTypeNM = "" Then
            Response.Write tTotalTourney
            ELSEIF tPlayLevelTypeNM = "예선" Then
            Response.Write tTotalReadyTourney
            ELSEIF tPlayLevelTypeNM = "본선" Then
            Response.Write tTotalFinalTourney
            END IF

          %>
          </span>
        </td>
        <td>
          <select name="selGameGroupOrder" id="selGameGroupOrder" onchange="javascript:onGroupGameOrderChanged('<%=crypt_GameScheduleIDX%>',this.value);">
          <% For i = 1 To tMaxGameGroupOrder %>
            <option value="<%=i%>" <%IF CDBL(i) = CDBL(tGameGroupOrder) Then %> Selected<% End IF %>><%=i%></option>  
          <% Next %>
          </select>
        </td>
        <td>
           <select name="selGameOrder" id="selGameOrder" onchange="javascript:onGameOrderChanged('<%=crypt_GameScheduleIDX%>',this.value);">
          <% For i = 1 To tMaxGameOrder %>
            <option value="<%=i%>" <%IF CDBL(i) = CDBL(tGameOrder) Then %> Selected<% End IF %>><%=i%></option>  
          <% Next %>
          </select>
        </td>
        <td>
          <input type="checkbox" name="chkBox" class="checkbox" value="<%=crypt_GameScheduleIDX%>"/>
        </td>
      </tr>
      <%
        LRs.MoveNext
      Loop
    Else
    %>
    <td colspan="9">조회 결과가 없습니다.</td>
    <%
    End If
    LRs.Close
%>
  </table>
</div>
<!-- e: table-list -->
