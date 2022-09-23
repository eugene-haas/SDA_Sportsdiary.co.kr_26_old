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
  'REQ = "{""CMD"":6,""tGameLevelDtlIDX"":""5F7699C3E5E0C7C729A2B602969785B6"",""tTeamGameNum"":1,""tOrderBy"":""1"",""tReqPlayerIDX"":""A129B7DCDA76849ABF27498076242127""}"
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
  

	If hasown(oJSONoutput, "tOrderBy") = "ok" then
    If ISNull(oJSONoutput.tOrderBy) Or oJSONoutput.tOrderBy = "" Then
      OrderBy = ""
      DEC_OrderBy = ""
    Else
      OrderBy = fInject(oJSONoutput.tOrderBy)
      DEC_OrderBy = fInject(crypt.DecryptStringENC(oJSONoutput.tOrderBy))    
    End If
  Else  
    OrderBy = ""
    DEC_OrderBy = ""
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


  LSQL = " SELECT COUNT(*) AS Cnt"
  LSQL = LSQL & " FROM tblTorneyTeamTemp"
  LSQL = LSQL & " WHERE GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
  LSQL = LSQL & " AND DelYN = 'N'"
  LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
  'LSQL = LSQL & " AND ORDERBY = '" & OrderBy & "'"
  LSQL = LSQL & " AND GameRequestPlayerIDX = '" & DEC_ReqPlayerIDX & "'"


  Set LRs = Dbcon.Execute(LSQL)  

  If Not (LRs.Eof Or LRs.Bof) Then
    Cnt = LRs("Cnt")
  Else
    Cnt = 0 
  End If
  LRs.Close

  If Cnt < 1 Then

    LSQL = " SELECT Team, TeamDtl, MemberIDX, MemberName"
    LSQL = LSQL & " FROM tblGameRequestPlayer A"
    LSQL = LSQL & " INNER JOIN tblGameRequestTouney B ON B.RequestIDX = A.GameRequestTeamIDX"
    LSQL = LSQL & " WHERE A.DelYN = 'N'"
    LSQL = LSQL & " AND B.DelYN = 'N'"
    LSQL = LSQL & " AND B.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
    LSQL = LSQL & " AND A.GameRequestPlayerIDX = '" & DEC_ReqPlayerIDX & "'"

    Set LRs = Dbcon.Execute(LSQL)  

    If Not (LRs.Eof Or LRs.Bof) Then
      Team = LRs("Team")
      TeamDtl = LRs("TeamDtl")
      MemberIDX = LRs("MemberIDX")
      MemberName = LRs("MemberName")
    End If
    LRs.Close    


    LSQL = " INSERT INTO tblTorneyTeamTemp("
    LSQL = LSQL & " GameLevelDtlidx, Team, TeamDtl, TeamGameNum, GameRequestPlayerIDX, MemberIDX, MemberName, ORDERBY"
    LSQL = LSQL & " )"
    LSQL = LSQL & " VALUES"
    LSQL = LSQL & " ("
    LSQL = LSQL & "  '" & DEC_GameLevelDtlIDX & "',"    
    LSQL = LSQL & "  '" & Team & "',"
    LSQL = LSQL & "  '" & TeamDtl & "',"
    LSQL = LSQL & "  '" & TeamGameNum & "',"
    LSQL = LSQL & "  '" & DEC_ReqPlayerIDX & "',"
    LSQL = LSQL & "  '" & MemberIDX & "',"
    LSQL = LSQL & "  '" & MemberName & "',"
    LSQL = LSQL & "  '" & OrderBy & "'"
    LSQL = LSQL & " )"
  
    Set LRs = Dbcon.Execute(LSQL)  

    strResult = 0
  Else
    strResult = 1
  End If


	Call oJSONoutput.Set("result", strResult )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<%

Set LRs = Nothing
DBClose()
  
%>