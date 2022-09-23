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
  'REQ = "{""CMD"":1,""tGameTitleIDX"":""35D5B51E5025C785305E687C2F2EE95E""}"
  Set oJSONoutput = JSON.Parse(REQ)
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
  crypt_reqGameTitleIdx =crypt.EncryptStringENC(tGameTitleIdx)
 
  reqRanking = fInject(oJSONoutput.tRanking)
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
  'Response.write "oJSONoutput.tLevel : " & oJSONoutput.tLevel & "<BR/>"
%>
		<table cellspacing="0" cellpadding="0">
			<tr>
         <th>순위</th>
         <th>팀</th>
         <th>점수</th>
			</tr>
			<%
  iType = 2
  LSQL = "EXEC tblGameTotalRanking_Searched_STR '" & reqGameTitleIdx  & "', '" & reqRanking &  "', '','" & iType  & "'"

  'Response.Write "LSQL" & LSQL & "<br/>"
  'Response.End
  Set LRs = Dbcon.Execute(LSQL)
  arrnum = 0
 
  If Not (LRs.Eof Or LRs.Bof) Then		
    Do Until LRs.Eof		
      arrnum = arrnum  + 1
      rTeam= LRs("Team")
      rTeamNm= LRs("TeamNm")
      rTeamDtl= LRs("TeamDtl")
      rTotalScore= LRs("TotalScore")
      rTRanking= LRs("TRanking")
%>
    <tr>
      <td>       
        <%=rTRanking%>
      </td>
      <td>
        <span><%=rTeamNm%></span>
      </td>
      <td>
        <%=rTotalScore%>
      </td>
     
    </tr>
    
    <%
           
          LRs.MoveNext
        Loop
      ELSE
    %>
    <tr >
    <td colspan="4">
      조회된 데이터가 없습니다.
    </td>
    </tr>
      

    <%
      End If
    %>
  </table>
  <input type="hidden" id="TotalRankingResult" name="TotalRankingResult" value="<%=arrnum%>">
<%
  'Response.Write "LSQL : " & LSQL & "<br/>"
  Set LRs = Nothing
  DBClose()
%>