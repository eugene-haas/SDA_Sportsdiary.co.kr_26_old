
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
  Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"
  Dim AppendPath : AppendPath = ""
  Dim FSO
  SET FSO = CreateObject("Scripting.FileSystemObject")
  REQ = Request("Req")
  'REQ = "{""CMD"":5,""FileName"":""통합 문서1.xlsx"",""GameType"":""B4E57B7A4F9D60AE9C71424182BA33FE""}"
  Set oJSONoutput = JSON.Parse(REQ)

  If hasown(oJSONoutput, "FileName") = "ok" then
    If ISNull(oJSONoutput.FileName) Or oJSONoutput.FileName = "" Then
      FileName = ""
      DEC_FileName = ""
    Else
      FileName = fInject(oJSONoutput.FileName)
      DEC_FileName = fInject(oJSONoutput.FileName)
    End If
  End if  
  If hasown(oJSONoutput, "GameType") = "ok" then
    If ISNull(oJSONoutput.GameType) Or oJSONoutput.GameType = "" Then
      GameType = ""
      DEC_GameType= ""
    Else
      GameType = fInject(oJSONoutput.GameType)
      DEC_GameType = fInject(crypt.DecryptStringENC(oJSONoutput.GameType))
    End If
  End if  

  
  IF DEC_GameType = GroupGame Then
    AppendPath = "GroupGame"
  elseif  DEC_GameType = PersonGame Then
    AppendPath = "PersonGame"
  End IF
  
  FileLocation =global_filepath_Admin & AppendPath & "\" & FileName
  IF FSO.FileExists(FileLocation) Then 
    FSO.DeleteFile(FileLocation)
    IF FSO.FileExists(FileLocation) = fALSE Then 
      Call oJSONoutput.Set("result", 0 )
    Else
      Call oJSONoutput.Set("result", 1 )
    End IF
  Else
    Call oJSONoutput.Set("result", 1 )
  End IF
  strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>