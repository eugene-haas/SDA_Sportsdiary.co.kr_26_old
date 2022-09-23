
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
  Const const_Empty = "empty"

  REQ = Request("Req")
  'REQ = "{""CMD"":2,""tGameTitleIDX"":""35D5B51E5025C785305E687C2F2EE95E"",""tGameLevelName"":""""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameTitleIDX") = "ok" then
    If ISNull(oJSONoutput.tGameTitleIDX) Or oJSONoutput.tGameTitleIDX = "" Then
      GameTitleIDX = const_Empty
      DEC_GameTitleIDX = const_Empty
    Else
      GameTitleIDX = fInject(oJSONoutput.tGameTitleIDX)
      DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIDX))    
    End If
  End if 

  If hasown(oJSONoutput, "tGameDay") = "ok" then
    If ISNull(oJSONoutput.tGameDay) Or oJSONoutput.tGameDay = "" Then
      GameDay = const_Empty
      DEC_GameDay= const_Empty
    Else
      GameDay = fInject(oJSONoutput.tGameDay)
      DEC_GameDay = fInject(oJSONoutput.tGameDay)
    End If
  End if 
   

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  %>

  <table cellspacing="0" cellpadding="0">
    <thead>
      <tr>
        <th>경기장</th>
        <th>상세설명</th>
      </tr>
    </thead>
    <tbody>
    <%
      LSQL = " SELECT StadiumIDX ,GameTitleIDX ,StadiumName ,StadiumCourt ,StadiumTime ,StadiumAddr ,StadiumAddrDtl "
      LSQL = LSQL & " FROM tblStadium A "
      LSQL = LSQL & " Where A.DelYN = 'N'"
      LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
      
      Set LRs = Dbcon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        r_StadiumIDX = LRs("StadiumIDX")
        crypt_StadiumIDX = crypt.EncryptStringENC(r_StadiumIDX)
        r_StadiumName = LRs("StadiumName")
        r_StadiumCourt = LRs("StadiumCourt")
        %>
        <tr>
          <td><%=r_StadiumName%></td>
        </tr>
        <%
        LRs.MoveNext
        Loop
      End If            

      LRs.Close    
    %>

    </tbody>
  </table>
<%
Response.Write "LSQL" & LSQL & "<BR/>"
  DBClose()
%>
  
