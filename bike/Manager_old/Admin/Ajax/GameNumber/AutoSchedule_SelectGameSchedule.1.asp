  
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
  'REQ = "{""CMD"":7,""tGameTitleIDX"":""A0B63180CC3215B403232E31C8E393B4"",""tStadiumIdx"":""DBFEA0D74B3E8F60F71FF6132C0DB1AC"",""tStadiumName"":""제주복합체육관"",""tGameDay"":""2018-07-13""}"
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
      <a href="#">
        <i class="fas fa-undo copy"></i>
      </a>
      <a href="#">
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
        <th>경기수</th>
        <th>그룹</th>
        <th>순서</th>
        <th>
          <input type="checkbox" class="checkbox"/>
        </th>
      </tr>

    <%

      LSQL = " SELECT A.GameTitleIDX,"
      LSQL = LSQL & " GameLevelidx, "
      LSQL = LSQL & " GroupGameGb, "
      LSQL = LSQL & " dbo.FN_NameSch(GroupGameGb, 'PubCode') AS GroupGameGbNM, "
      LSQL = LSQL & " PlayLevelType, "
      LSQL = LSQL & " dbo.FN_NameSch(PlayLevelType, 'PubCode') AS PlayLevelTypeNM, "
      LSQL = LSQL & " TeamGb, "
      LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(TeamGb,'TeamGb') AS TeamGbNM, "
      LSQL = LSQL & " Level, "
      LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(Level,'Level') AS LevelNM, "
      LSQL = LSQL & " LevelJooName as LevelJoo, "
      LSQL = LSQL & " dbo.FN_NameSch(LevelJooName, 'PubCode') AS LevelJooName, "
      LSQL = LSQL & " StartCourt, "
      LSQL = LSQL & " EndCourt, "
      LSQL = LSQL & " A.StadiumIDX, "
      LSQL = LSQL & " B.StadiumName, "
      LSQL = LSQL & " GameDay, "
      LSQL = LSQL & " GameGroupOrder, "
      LSQL = LSQL & " GameOrder,"
      LSQL = LSQL & " (SELECT Count(*) FROM tblGameSchedule C where C.GameTitleIDX ='" & DEC_GameTitleIDX & "' and C.StadiumIDX ='" & DEC_StadiumIDX & "' and C.GameDay = '" & DEC_GameDay & "' And C.DelYn='N') as MaxGameOrder"
      LSQL = LSQL & " FROM tblGameSchedule A "
      LSQL = LSQL & " LEFT JOIN tblStadium B ON A.StadiumIDX = B.StadiumIDX And B.DelYN ='N' "
      LSQL = LSQL & " where A.GameTitleIDX ='"& DEC_GameTitleIDX & "' and A.StadiumIDX ='" & DEC_StadiumIDX & "' and A.GameDay = '" & DEC_GameDay & "' And A.DelYn='N'"
      Set LRs = Dbcon.Execute(LSQL)
      Response.Write "LSQL : " & LSQL & "<BR/>"
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
          tGroupGameGbNM =LRs("GroupGameGbNM")
          tGroupGameGb =LRs("GroupGameGb")
          tStartCourt =LRs("StartCourt")
          tEndCourt  =LRs("EndCourt")
          tTeamGbNM  =LRs("TeamGbNM")
          tLevelNM  =LRs("LevelNM")
          tLevelJooNameNM  =LRs("LevelJooName")
          tPlayLevelTypeNM  =LRs("PlayLevelTypeNM")
          tGameGroupOrder  =LRs("GameGroupOrder")
          tGameOrder  =LRs("GameOrder")
          tMaxGameOrder  =LRs("MaxGameOrder")
          tMaxGameGroupOrder = tMaxGameOrder
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
          <span><%=tTeamGbNM%><span class="red-font"><%=tLevelNM%><%=tLevelJooNameNM%></span></span>
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
          <span>4</span>
        </td>
        <td>
          <select name="selGameGroupOrder" id="selGameGroupOrder">
          <% For i = 1 To tMaxGameGroupOrder %>
            <option value="" <%IF CDBL(i) = CDBL(tGameGroupOrder) Then %> Selected<% End IF %>><%=i%></option>  
          <% Next %>
          </select>
        </td>
        <td>
           <select name="selGameOrder" id="selGameOrder">
          <% For i = 1 To tMaxGameOrder %>
            <option value="" <%IF CDBL(i) = CDBL(tGameOrder) Then %> Selected<% End IF %>><%=i%></option>  
          <% Next %>
          </select>
        </td>
        <td>
          <input type="checkbox" class="checkbox"/>
        </td>
      </tr>
      <%
        LRs.MoveNext
      Loop
    Else
    %>
    <td colspan="8">조회 결과가 없습니다.</td>
    <%
    End If
    LRs.Close
%>
  </table>
</div>
<!-- e: table-list -->
