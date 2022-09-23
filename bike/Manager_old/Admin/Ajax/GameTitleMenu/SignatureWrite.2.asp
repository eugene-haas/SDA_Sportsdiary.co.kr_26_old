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
'단체전 경기결과 입력

REQ = Request("Req")
'REQ = "{""CMD"":16,""GameLevelDtlIDX"":""1DDD4D380E095C6E78A222BA362D0FF7"",""TeamGameNum"":""D3510D3EEF159089CEE3710534553C12"",""GameNum"":""D3510D3EEF159089CEE3710534553C12"",""SignData"":""data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAV4AAACMCAYAAAA0qsGKAAAEeklEQVR4Xu3UwQkAAAgDMbv/0m5xr7hAIcjtHAECBAikAkvXjBEgQIDACa8nIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQICK8fIECAQCwgvDG4OQIECAivHyBAgEAsILwxuDkCBAgIrx8gQIBALCC8Mbg5AgQIPAnUAI3IewdBAAAAAElFTkSuQmCC"",""TourneyGroupIDX"":""2A210F92001DC101C0C28EAC426CB106""}"

Set oJSONoutput = JSON.Parse(REQ)

If hasown(oJSONoutput, "GameLevelDtlIDX") = "ok" then
    If ISNull(oJSONoutput.GameLevelDtlIDX) Or oJSONoutput.GameLevelDtlIDX = "" Then
      GameLevelDtlIDX = ""
      DEC_GameLevelDtlIDX = ""
    Else
      GameLevelDtlIDX = fInject(oJSONoutput.GameLevelDtlIDX)
      DEC_GameLevelDtlIDX = fInject(crypt.DecryptStringENC(oJSONoutput.GameLevelDtlIDX))
    End If
  Else  
    GameLevelDtlIDX = ""
    DEC_GameLevelDtlIDX = ""
End if	

If hasown(oJSONoutput, "TeamGameNum") = "ok" then
    If ISNull(oJSONoutput.TeamGameNum) Or oJSONoutput.TeamGameNum = "" Then
      TeamGameNum = ""
      DEC_TeamGameNum = ""
    Else
      TeamGameNum = fInject(oJSONoutput.TeamGameNum)
      DEC_TeamGameNum = fInject(crypt.DecryptStringENC(oJSONoutput.TeamGameNum))    
    End If
  Else  
    TeamGameNum = ""
    DEC_TeamGameNum = ""
End if	

If hasown(oJSONoutput, "GameNum") = "ok" then
    If ISNull(oJSONoutput.GameNum) Or oJSONoutput.GameNum = "" Then
      GameNum = ""
      DEC_GameNum = ""
    Else
      GameNum = fInject(oJSONoutput.GameNum)
      DEC_GameNum = fInject(crypt.DecryptStringENC(oJSONoutput.GameNum))    
    End If
  Else  
    GameNum = ""
    DEC_GameNum = ""
End if	

If hasown(oJSONoutput, "TourneyGroupIDX") = "ok" then
    If ISNull(oJSONoutput.TourneyGroupIDX) Or oJSONoutput.TourneyGroupIDX = "" Then
      TourneyGroupIDX = ""
      DEC_TourneyGroupIDX = ""
    Else
      TourneyGroupIDX = fInject(oJSONoutput.TourneyGroupIDX)
      DEC_TourneyGroupIDX = fInject(crypt.DecryptStringENC(oJSONoutput.TourneyGroupIDX))    
    End If
  Else  
    TourneyGroupIDX = ""
    DEC_TourneyGroupIDX = ""
End if	

If hasown(oJSONoutput, "GroupGameGb") = "ok" then
    If ISNull(oJSONoutput.GroupGameGb) Or oJSONoutput.GroupGameGb = "" Then
      GroupGameGb = ""
      DEC_GroupGameGb = ""
    Else
      GroupGameGb = fInject(oJSONoutput.GroupGameGb)
      DEC_GroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.GroupGameGb))    
    End If
  Else  
    GroupGameGb = ""
    DEC_GroupGameGb = ""
End if	

If hasown(oJSONoutput, "SignData") = "ok" then
  SignData = oJSONoutput.SignData
Else  
  SignData = ""
End if	


'경기결과 카운트 불러오기
LSQL = "SELECT COUNT(*) AS ResultCnt"
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameSign"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
LSQL = LSQL & " AND GameNum = '" & DEC_GameNum & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    RsCnt = LRs("ResultCnt")

End If

LRs.Close

 
'경기결과가 있으면 UPDATE
If Cint(RsCnt) > 0 Then

    CSQL = " UPDATE KoreaBadminton.dbo.tblGameSign SET"
    CSQL = CSQL & " DelYN = 'Y'"
    CSQL = CSQL & " WHERE DelYN = 'N'"
    CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
    CSQL = CSQL & " AND TeamGameNum = '" & DEC_TeamGameNum & "'"
    CSQL = CSQL & " AND GameNum = '" & DEC_GameNum & "'"

    Dbcon.Execute(CSQL)

End If


CSQL = " INSERT INTO KoreaBadminton.dbo.tblGameSign (GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, SignData)"
CSQL = CSQL & " VALUES('" & DEC_GameLevelDtlIDX & "', '" & DEC_TeamGameNum & "', '" & DEC_GameNum & "', '" &  DEC_TourneyGroupIDX& "', '" & SignData & "')"

Dbcon.Execute(CSQL)
  

Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()
  
%>