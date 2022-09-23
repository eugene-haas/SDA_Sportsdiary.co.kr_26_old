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

If hasown(oJSONoutput, "RequestIDX") = "ok" then
    If ISNull(oJSONoutput.RequestIDX) Or oJSONoutput.RequestIDX = "" Then
      RequestIDX = ""
      DEC_RequestIDX = ""
    Else
      RequestIDX = fInject(oJSONoutput.RequestIDX)
      DEC_RequestIDX = fInject(crypt.DecryptStringENC(oJSONoutput.RequestIDX))    
    End If
  Else  
    RequestIDX = ""
    DEC_RequestIDX = ""
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
LSQL = LSQL & " FROM KoreaBadminton.dbo.tblGameMedal"
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "'"
LSQL = LSQL & " AND RequestIDX = '" & DEC_RequestIDX & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    RsCnt = LRs("ResultCnt")

End If

LRs.Close

 
'실적 있으면 Sign UPDATE
If Cint(RsCnt) > 0 Then

    CSQL = " UPDATE KoreaBadminton.dbo.tblGameMedal SET"
    CSQL = CSQL & " SignData = '" & SignData & "'"
    CSQL = CSQL & " WHERE DelYN = 'N'"
    CSQL = CSQL & " AND GameLevelDtlIDX = '" & DEC_GameLevelDtlIDX & "'"
    CSQL = CSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "'"
    CSQL = CSQL & " AND RequestIDX = '" & DEC_RequestIDX & "'"

    Dbcon.Execute(CSQL)

End If


Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

Set LRs = Nothing
DBClose()
  
%>