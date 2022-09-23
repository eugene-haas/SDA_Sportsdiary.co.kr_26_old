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
Dim tTourneyTeamIDX : tTourneyTeamIDX = ""
Dim tRequestIDX : tRequestIDX = ""
REQ = Request("Req")
'REQ = "{""CMD"":12,""TourneyTeamIdx"":""1554"",""RequestIdx"":""133"",""LevelDtl"":""1045""}"


Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "LevelDtl") = "ok" then
    If ISNull(oJSONoutput.LevelDtl) Or oJSONoutput.LevelDtl = "" Then
      LevelDtl = ""
      DEC_LevelDtl = ""
    Else
      LevelDtl = fInject(oJSONoutput.LevelDtl)
      DEC_LevelDtl = fInject(oJSONoutput.LevelDtl)    
    End If
  Else  
    LevelDtl = ""
    DEC_LevelDtl = ""
End if	

If hasown(oJSONoutput, "RequestIdx") = "ok" then
    If ISNull(oJSONoutput.RequestIdx) Or oJSONoutput.RequestIdx = "" Then
      RequestIdx = ""
      DEC_RequestIdx = ""
    Else
      RequestIdx = fInject(oJSONoutput.RequestIdx)
      DEC_RequestIdx = fInject(oJSONoutput.RequestIdx)    
    End If
  Else  
    RequestIdx = ""
    DEC_RequestIdx = ""
End if	

If hasown(oJSONoutput, "TourneyTeamIdx") = "ok" then
    If ISNull(oJSONoutput.TourneyTeamIdx) Or oJSONoutput.TourneyTeamIdx = "" Then
      TourneyTeamIdx = ""
      DEC_TourneyTeamIdx = ""
    Else
      TourneyTeamIdx = fInject(oJSONoutput.TourneyTeamIdx)
      DEC_TourneyTeamIdx = fInject(oJSONoutput.TourneyTeamIdx)    
    End If
  Else  
    TourneyTeamIdx = ""
    DEC_TourneyTeamIdx = ""
End if	


'Response.Write "DEC_LevelDtl : " & DEC_LevelDtl & "<br/>"
'Response.Write "DEC_RequestIdx : " & DEC_RequestIdx & "<br/>"
'Response.Write "DEC_TourneyTeamIdx : " & DEC_TourneyTeamIdx & "<br/>"


'Response.Write "TourneyTeamIdx : " & TourneyTeamIdx & "<br/>"


  LSQL = "SELECT TourneyTeamIDX, RequestIDX "
  LSQL = LSQL & " FROM  tblTourneyTeam"
  LSQL = LSQL & " WHERE TourneyTeamIDX = '" &  DEC_TourneyTeamIdx & "'"
  'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br/>"

  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tTourneyTeamIDX = LRs("TourneyTeamIDX")
    	tRequestIDX = LRs("RequestIDX")
      LRs.MoveNext
    Loop
  End If
  LRs.close

	
	'Response.Write "tTourneyTeamIDX : " & tTourneyTeamIDX & "<br/>"
	'Response.Write "tRequestIDX : " & tRequestIDX & "<br/>"

	IF Len(tTourneyTeamIDX) <> cdbl(0) Then

		LSQL = "SELECT Team, TeamDtl "
		LSQL = LSQL & " FROM tblGameRequestGroup "
		LSQL = LSQL & " WHERE DelYN = 'N' AND GameRequestTeamIDX = '" & DEC_RequestIdx & "'"    
		Set LRs = Dbcon.Execute(LSQL)
		If Not (LRs.Eof Or LRs.Bof) Then
			Do Until LRs.Eof
				Team = LRs("Team")
				TeamDtl = LRs("TeamDtl")
				LRs.MoveNext
			Loop
		Else    
			Team = ""
			TeamDtl = "0"
		End If        


		LSQL = " UPDATE tblTourneyTeam "
		LSQL = LSQL & " 	SET RequestIDX =	'" & DEC_RequestIdx & "'" 
		LSQL = LSQL & " ,Team =	'" & Team & "'" 
		LSQL = LSQL & " ,TeamDtl ='" & TeamDtl & "'"
		LSQL = LSQL & " ,TeamName = dbo.FN_NameSch('" & Team & "','Team')"
		LSQL = LSQL & " WHERE TourneyTeamIDX = '" & tTourneyTeamIDX & "'" 
		Dbcon.Execute(LSQL)
		'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL & "<br/>"
	End IF


Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson


Set LRs = Nothing
DBClose()
  
%>