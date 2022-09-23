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
	Dim LSQL
	Dim LRs
	Dim strjson
	Dim strjson_sum

	Dim oJSONoutput_SUM
	Dim oJSONoutput

	Dim CMD  
	Dim GameTitleIDX 	

  REQ = Request("Req")
  'REQ = "{""CMD"":6,""tGameLevelDtlIDX"":""5F7699C3E5E0C7C729A2B602969785B6"",""tTeamGameNum"":2,""tGameNum"":""2"",""tReqPlayerIDX"":""47EA9EC583CFE44DB41C14FBCEF75EB4""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "tGameLevelDtlIDX") = "ok" then
    GameLevelDtlIDX = fInject(oJSONoutput.tGameLevelDtlIDX)
    DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIDX))
  Else  
    GameLevelDtlIDX = ""
    DEC_GameLevelDtlIDX = ""
  End if	

  If hasown(oJSONoutput, "tTeamGameNum") = "ok" then
    If ISNull(oJSONoutput.tTeamGameNum) Or oJSONoutput.tTeamGameNum = "" Then
      TeamGameNum = ""
      DEC_TeamGameNum = ""
    Else
      TeamGameNum = fInject(oJSONoutput.tTeamGameNum)
      DEC_TeamGameNum = fInject(crypt.DecryptStringENC(oJSONoutput.tTeamGameNum))    
    End If
  Else  
    TeamGameNum = ""
    DEC_TeamGameNum = ""
	End if	

	If hasown(oJSONoutput, "tReqPlayerIDX") = "ok" then
    If ISNull(oJSONoutput.tReqPlayerIDX) Or oJSONoutput.tReqPlayerIDX = "" Then
      ReqPlayerIDX = ""
      DEC_ReqPlayerIDX = ""
    Else
      ReqPlayerIDX = fInject(oJSONoutput.tReqPlayerIDX)
      DEC_ReqPlayerIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tReqPlayerIDX))    
    End If
  Else  
    ReqPlayerIDX = ""
    DEC_ReqPlayerIDX = ""
	End if	  


  LSQL = " UPDATE tblTorneyTeamTemp SET DelYN = 'Y'" 
  LSQL = LSQL & " WHERE GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
  LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
  LSQL = LSQL & " AND DelYN = 'N'"
  LSQL = LSQL & " AND GameRequestPlayerIDX = '" & DEC_ReqPlayerIDX & "'"

  Set LRs = Dbcon.Execute(LSQL)  

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<%

Set LRs = Nothing
DBClose()
  
%>