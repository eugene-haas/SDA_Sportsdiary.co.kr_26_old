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
  REQ = Request("Req")
  'REQ = "{""tGameTitleIdx"":""78660146D434CFADE660EA07CF4BDCA2"",""CMD"":2,""tTeamGb"":"""",""tPlayTypeSex"":"""",""tLevel"":"""",""tRankingValue"":""""}"
  'REQ = "{""tGameTitleIdx"":""78660146D434CFADE660EA07CF4BDCA2"",""CMD"":2,""tTeamGb"":"""",""tPlayTypeSex"":"""",""tLevel"":"""",""tRankingValue"":""""}"
  'REQ = "{""CMD"":2,""tGameTitleIDX"":""35D5B51E5025C785305E687C2F2EE95E"",""tLevelJooName"":""C"",""tRanking"":""""}"
 
  Set oJSONoutput = JSON.Parse(REQ)
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
  crypt_reqGameTitleIdx =crypt.EncryptStringENC(tGameTitleIdx)
  reqLevelJooNameNM = fInject(oJSONoutput.tLevelJooName)
  reqRanking = fInject(oJSONoutput.tRanking)
  
  'RESPONSE.WRITE "reqGameTitleIdx : "  & reqGameTitleIdx & " </BR>"
  'RESPONSE.WRITE "reqLevelJooName : "  & reqLevelJooName & " </BR>"
  'RESPONSE.WRITE "reqRanking : "  & reqRanking & " </BR>"

  LSQL = " SELECT PubCode, PubName  "
  LSQL = LSQL & " FROM  tblPubcode "
  LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B011' and PubName <> '' "
  LSQL = LSQL & " ORDER BY OrderBy "

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrayLevelJooName = LRs.getrows()
  End If
  
%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'RESPONSE.WRITE "reqRanking" & reqRanking & "<BR/>"
%>

<select id="selLevelJooName" name="selLevelJooName"  onChange='OnGameLevelChanged()'>
  <option value="">::등급 선택::</option>
    <% If IsArray(arrayLevelJooName) Then
      For ar = LBound(arrayLevelJooName, 2) To UBound(arrayLevelJooName, 2) 
        LevelJooNameCnt = LevelJooNameCnt + 1
        LevelJooNameCode    = arrayLevelJooName(0, ar) 
        LevelJooNameNM  = arrayLevelJooName(1, ar) 

        If LevelJooNameNM = reqLevelJooNameNM Then
    %>
        <option value="<%=LevelJooNameNM%>" selected><%=LevelJooNameNM%></option> 
        <% else %>
        <option value="<%=LevelJooNameNM%>"><%=LevelJooNameNM%></option>
    <%
        END IF
      Next
    End If      
  %>

  
</select>

<%
  MAXRanking = 0
  LSQL = " EXEC tblGameTotalRanking_Searched_STR '" & reqGameTitleIdx &"','','"  & reqLevelJooNameNM & "','1'" 
  'Response.Write "LSQL" & LSQL& "<br/>"

  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          MAXRanking = LRs("MAXRanking")
          
        LRs.MoveNext
      Loop
  End If

  IF reqRanking = "" Then
    reqRanking =0
  end if 

%>
<select id="selRanking" name="selRanking"  onChange='OnGameLevelChanged()'>
  <option value="">::랭킹 선택::</option>
  <% For i = 1 To cdbl(MAXRanking) %>
    <% IF CDBL(i) = CDBL(reqRanking) Then %>
      <option value="<%=i%>" selected><%=i%></option>
    <%Else%>
      <option value="<%=i%>"><%=i%></option>
    <%End IF%>
  <% Next %>
</select>

<a href='javascript:OnResultSearch()'>조회</a>
<% 'RESPONSE.WRITE "reqRanking" & reqRanking & "<BR/>"%>