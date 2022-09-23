<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%

  REQ = Request("Req")
  Set oJSONoutput = JSON.Parse(REQ)
	idx =fInject(oJSONoutput.IDX)
  If(idx <> "") Then
    LSQL = "SELECT GameGb,GameTitleName,GameS,GameE,GamePlace,Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS  ,GameRcvDateE  ,GameRcvHourE  ,GameRcvMinuteE  ,DelYN  ,ViewYN  ,HostCode ,EditDate ,WriteDate "
    LSQL = LSQL & " FROM  tblGameTitle "
    LSQL = LSQL & " WHERE GameTitleIDX = "  & idx 
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        rGameGb = LRS("GameGb")
        rGameTitleName = LRS("GameTitleName")
        rGameS = LRS("GameS")
        rGameE = LRS("GameE")
        rGameArea = LRS("GamePlace")
        rGameTitleSido = LRS("Sido")
        rGameTitleSidoDtl = LRS("SidoDtl")
        rGameRcvDateS = LRS("GameRcvDateS")
        rGameRcvHourS = LRS("GameRcvHourS")
        rGameRcvMinuteS = LRS("GameRcvMinuteS")
        rGameRcvDateE = LRS("GameRcvDateE")
        rGameRcvHourE = LRS("GameRcvHourE")
        rViewYN = LRS("ViewYN")
        rHostCode = LRS("HostCode")
        rEditDate = LRS("EditDate")
        LRs.MoveNext
      Loop
    End If
  End IF
%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

<!--#include file="../../html/GameTitleMenu/GameTitleMenuInfo.asp"-->