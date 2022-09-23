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

  'REQ = Request("Req")
  REQ = "{""CMD"":6,""tGameLevelDtlIDX"":""D71A21A6A8152DA384E27F623654F048"",""tTeamGameNum"":""1"",""tGameNum"":1,""tOrderBy"":""1"",""tReqPlayerIDX"":""9D1AB7B48C966CC6CE4629054FBE365D""}"
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

  'INSERT 시, 이용 할 대회 정보 SELECT
  LSQL = "SELECT A.GameTitleIDX, A.GameLevelidx"
  LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameLevel A"
  LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelidx = B.GameLevelIDX"
  LSQL = LSQL & " WHERE A.DelYN = 'N'"
  LSQL = LSQL & " AND B.DelYN = 'N'"
  LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"

  Set LRs = Dbcon.Execute(LSQL)
  Response.Write "1. LSQL" & LSQL & "<BR/>"
  If Not (LRs.Eof Or LRs.Bof) Then
      GameLevelidx = LRs("GameLevelidx")
  End If

  LRs.Close

  LSQL = " SELECT COUNT(*) AS Cnt"
  LSQL = LSQL & " FROM tblTorneyTeamTemp"
  LSQL = LSQL & " WHERE GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
  LSQL = LSQL & " AND DelYN = 'N'"
  LSQL = LSQL & " AND TeamGameNum = '" & TeamGameNum & "'"
  'LSQL = LSQL & " AND ORDERBY = '" & OrderBy & "'"
  LSQL = LSQL & " AND GameRequestPlayerIDX = '" & DEC_ReqPlayerIDX & "'"

  Set LRs = Dbcon.Execute(LSQL)  
  Response.Write "2. LSQL" & LSQL & "<BR/>"
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
    LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlIDX = B.GameLevelDtlIDX"
    LSQL = LSQL & " WHERE A.DelYN = 'N'"
    LSQL = LSQL & " AND B.DelYN = 'N'"
    'LSQL = LSQL & " AND B.GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
    LSQL = LSQL & " AND C.GameLevelIDX = '" & GameLevelIDX & "'"
    LSQL = LSQL & " AND A.GameRequestPlayerIDX = '" & DEC_ReqPlayerIDX & "'"

    Set LRs = Dbcon.Execute(LSQL)  
    Response.Write "3. LSQL" & LSQL & "<BR/>"
    If Not (LRs.Eof Or LRs.Bof) Then
      Team = LRs("Team")
      TeamDtl = LRs("TeamDtl")
      MemberIDX = LRs("MemberIDX")
      MemberName = LRs("MemberName")
    End If
    LRs.Close    


    LSQL = " INSERT INTO tblTorneyTeamTemp("
    LSQL = LSQL & " GameLevelDtlidx, Team, TeamDtl, TeamGameNum, GameNum, GameRequestPlayerIDX, MemberIDX, MemberName, ORDERBY"
    LSQL = LSQL & " )"
    LSQL = LSQL & " VALUES"
    LSQL = LSQL & " ("
    LSQL = LSQL & "  '" & DEC_GameLevelDtlIDX & "',"    
    LSQL = LSQL & "  '" & Team & "',"
    LSQL = LSQL & "  '" & TeamDtl & "',"
    LSQL = LSQL & "  '" & TeamGameNum & "',"
    LSQL = LSQL & "  '" & GameNum & "',"
    LSQL = LSQL & "  '" & DEC_ReqPlayerIDX & "',"
    LSQL = LSQL & "  '" & MemberIDX & "',"
    LSQL = LSQL & "  '" & MemberName & "',"
    LSQL = LSQL & "  '" & OrderBy & "'"
    LSQL = LSQL & " )"
  
    Set LRs = Dbcon.Execute(LSQL)  
    Response.Write "4. LSQL" & LSQL & "<BR/>"
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