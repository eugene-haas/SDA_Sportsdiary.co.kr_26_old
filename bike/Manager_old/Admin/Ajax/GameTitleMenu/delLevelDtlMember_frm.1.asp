
<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("REQ")
  'REQ = "{""CMD"":3,""tIdx"":""47E0533CF10C4690F617881B06E75784"",""tGameLevelIdx"":""6F63A0533406C638BC30FDB235BB8D03"",""tGameLevelDtlIdx"":""BC04768F8AAA838ED15091ADE292E3CF"",""tGroupGameGb"":""B4E57B7A4F9D60AE9C71424182BA33FE"",""tGameRequestTouneyIdx"":""50B781A9CB84ADBAB354D02DB2A35DA8""}"

  Set oJSONoutput = JSON.Parse(REQ)

	CMD = oJSONoutput.CMD
 '------------------------대회 기본 정보-------------------------------
  tIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tIdx))
  tGameLevelIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelIdx))
  tGameLevelDtlIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameLevelDtlIdx))
  tGameRequestTouneyIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameRequestTouneyIdx))
  tGroupGameGb = fInject(crypt.DecryptStringENC(oJSONoutput.tGroupGameGb))
  '---------------------------------------------------------------------
  'Response.Write "CMD :" & CMD & "<BR>"
  'Response.Write "tIdx :" & tIdx & "<BR>"
  'Response.Write "tGameLevelIdx :" & tGameLevelIdx & "<BR>"
  'Response.Write "tGameLevelDtlIdx :" & tGameLevelDtlIdx & "<BR>"
  'Response.Write "tGroupGameGb :" & tGroupGameGb & "<BR>"
  'Response.Write "tGameRequestTouneyIdx :" & tGameRequestTouneyIdx & "<BR>"

  '-------------------- 출전 중인 여부 체크   ---------------------
  LSQL = " SELECT Count(*) as TouneyCnt " 
  LSQL = LSQL & " FROM tblGameRequestTouney  "
  LSQL = LSQL & " where RequestDtlIDX = '" & tGameRequestTouneyIdx &  "' and GameLevelDtlIDX  = '" & tGameLevelDtlIdx &  "' and DelYN = 'N' "
  'Response.Write "LSQL :" & LSQL & "<BR>"
  Set LRs = DBCon.Execute(LSQL)
  IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
      TouneyCnt = LRs("TouneyCnt")
    LRs.MoveNext
    Loop
  End If  
  '-------------------- 데이터 출전 insert  ---------------------
  IF( CDBL(TouneyCnt) > CDBL(0) )Then
    LSQL = " Update tblGameRequestTouney " 
    LSQL = LSQL & " SET DelYN = 'Y'" 
    LSQL = LSQL & " Where RequestDtlIDX = '" & tGameRequestTouneyIdx & "'"
    'Response.Write "LSQL :" & LSQL & "<BR>"
    Set LRs = DBCon.Execute(LSQL)
  End If  
  '-------------------- 데이터 출전 insert  ---------------------
  

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>
  
<%
  DBClose()
%>
