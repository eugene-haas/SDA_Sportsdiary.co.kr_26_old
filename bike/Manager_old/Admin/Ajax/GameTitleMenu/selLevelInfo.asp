
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  'REQ = "{""CMD"":12,""TEAMGB"":""18001""}"
  Set oJSONoutput = JSON.Parse(REQ)
	teamGB = fInject(crypt.DecryptStringENC(oJSONoutput.TEAMGB))

  LSQL = "SELECT Level,LevelNm,LevelDtl   "
  LSQL = LSQL & " FROM  tblLevelInfo  "
  LSQL = LSQL & " where TeamGb =  '" & teamGB & "'"
  LSQL = LSQL & "ORDER BY Orderby "
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL

  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
    arrLevelInfo = LRs.getrows()
  End If

  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>


  <select id="selTeamGBLevel" >
     <option value="" >미선택</option>
      <% If IsArray(arrLevelInfo) Then
        For ar = LBound(arrLevelInfo, 2) To UBound(arrLevelInfo, 2) 

          levelInfoCode		= arrLevelInfo(0, ar) 
          crypt_levelInfoCode = crypt.EncryptStringENC(levelInfoCode)
          levelInfoName	= arrLevelInfo(1, ar) 
          levelInfoDtl	= arrLevelInfo(2, ar) 


    %>
          <option value="<%=crypt_levelInfoCode%>"><%=levelInfoName%></option>
    <%
        Next
      End If			
    %>
  </select>	

