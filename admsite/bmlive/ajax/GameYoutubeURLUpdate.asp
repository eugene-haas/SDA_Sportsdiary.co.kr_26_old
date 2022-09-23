<!-- #include virtual="/bmlive/config.asp"-->
<!-- #include virtual="/bmlive/JSON_2.0.4.asp" -->
<!-- #include virtual="/bmlive/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/bmlive/json2.asp" -->
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

'REQ = "{""CMD"":33,""tGameLevelDtlIDX"":""8E916C9CEA1AF33A65D41485F91B2E69"",""tTeamGameNum"":""BA8A3F4EEB3BD1BC6BDDCE9B834746BD"",""tGameNum"":""D3510D3EEF159089CEE3710534553C12""}"

Set oJSONoutput = JSON.Parse(REQ)


If hasown(oJSONoutput, "tGameLevelDtlIDX") = "ok" then
    If ISNull(oJSONoutput.tGameLevelDtlIDX) Or oJSONoutput.tGameLevelDtlIDX = "" Then
      GameLevelDtlIDX = ""
      DEC_GameLevelDtlIDX = ""
    Else
      GameLevelDtlIDX = fInject(oJSONoutput.tGameLevelDtlIDX)
      DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIDX))   
    End If
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

If hasown(oJSONoutput, "tGameNum") = "ok" then
    If ISNull(oJSONoutput.tGameNum) Or oJSONoutput.tGameNum = "" Then
      GameNum = ""
      DEC_GameNum = ""
    Else
      GameNum = fInject(oJSONoutput.tGameNum)
      DEC_GameNum = fInject(crypt.DecryptStringENC(oJSONoutput.tGameNum))
    End If
  Else  
    GameNum = ""
    DEC_GameNum = ""
End if	

If hasown(oJSONoutput, "tMovieURL") = "ok" then
    If ISNull(oJSONoutput.tMovieURL) Or oJSONoutput.tMovieURL = "" Then
      MovieURL = ""
      DEC_MovieURL = ""
    Else
      MovieURL = fInject(oJSONoutput.tMovieURL)
      DEC_MovieURL = fInject(oJSONoutput.tMovieURL)
    End If
  Else  
    MovieURL = ""
    DEC_MovieURL = ""
End if	


LSQL = "UPDATE tblGameOperate SET YoutubeURL = '" & DEC_MovieURL & "'"
LSQL = LSQL & " FROM tblGameOperate"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLeveldtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND GameNum = '" & DEC_GameNum & "'"
Dbcon.Execute(LSQL)



Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()
  
%>