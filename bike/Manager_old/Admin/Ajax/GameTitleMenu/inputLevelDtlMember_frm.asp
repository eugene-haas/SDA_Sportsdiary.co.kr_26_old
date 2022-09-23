
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":4,""tIdx"":""7CF03B23B9A19495C66E7DCEE4683D5E"",""tGameLevelIdx"":""3143AFFA50778E24177E7DD7D8376499"",""tGameLevelDtlIdx"":""1F09FB95FD04BD14EA9FAD6A967EE31C"",""tGroupGameGb"":""F9A43D4DE4191C125B08095CC465CD4B"",""tTeamIdx"":""997C708DED1F4CC4123CACD5C9A6337B""}"

  Set oJSONoutput = JSON.Parse(REQ)

	CMD = oJSONoutput.CMD
 '------------------------대회 기본 정보-------------------------------
  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  tGameLevelDtlIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIdx))
  tTeamIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tTeamIdx))
  tGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
  '---------------------------------------------------------------------
  'Response.Write "CMD :" & CMD & "<BR>"
  'Response.Write "tIdx :" & tIdx & "<BR>"
  'Response.Write "tGameLevelIdx :" & tGameLevelIdx & "<BR>"
  'Response.Write "tGameLevelDtlIdx :" & tGameLevelDtlIdx & "<BR>"
  'Response.Write "tGroupGameGb :" & tGroupGameGb & "<BR>"
  'Response.Write "tTeamIdx :" & tTeamIdx & "<BR>"

  '-------------------- 출전 중인 여부 체크   ---------------------
  LSQL = " SELECT Count(*) as TouneyCnt " 
  LSQL = LSQL & " FROM tblGameRequestTouney  "
  LSQL = LSQL & " where RequestIDX = '" & tTeamIdx &  "' and GameLevelDtlIDX  = '" & tGameLevelDtlIdx &  "' and DelYN = 'N' "
  Response.Write "LSQL :" & LSQL & "<BR>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      TouneyCnt = LRs("TouneyCnt")
    LRs.MoveNext
    Loop
  End If  
  '-------------------- 데이터 출전 insert  ---------------------
  IF( CDBL(TouneyCnt) = CDBL(0) )Then
    LSQL = " SET NOCOUNT ON insert into tblGameRequestTouney " 
    LSQL = LSQL & " ( RequestIDX, GroupGameGb, GameLevelDtlIDX) "
    LSQL = LSQL & " values ('"&tTeamIdx & "','" &  tGroupGameGb & "','"&  tGameLevelDtlIdx & "')" 
    LSQL = LSQL & " SELECT @@IDENTITY as IDX "
    Response.Write "LSQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        IDX = LRs("IDX")
      LRs.MoveNext
      Loop
    End If  
  End If  
  '-------------------- 데이터 출전 insert  ---------------------
  

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>
  
<%
  DBClose()
%>
