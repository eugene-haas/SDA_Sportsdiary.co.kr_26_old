<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>


 <%
    LSQL = " SELECT GameTitleIDX ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,DelYN ,ViewYN ,HostCode ,EditDate ,WriteDate  "
    LSQL = LSQL & " FROM  tblGameTitle a"
    LSQL = LSQL & " WHERE DELYN = 'N' "
    'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = DBCon.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
          RGameTitleIDX = LRs("GameTitleIDX")
          RGameGb = LRs("GameGb")
          RGameTitleName = LRs("GameTitleName")
          RGameS = LRs("GameS")
          RGameE = LRs("GameE")
          RGamePlace = LRs("GamePlace")
          RSido = LRs("Sido")
          RSidoDtl = LRs("SidoDtl")
          REnterType = LRs("EnterType")
          RGameRcvDateS = LRs("GameRcvDateS")
          RGameRcvHourS = LRs("GameRcvHourS")
          RViewYN = LRs("ViewYN")
          RLevelCount = LRs("levelCount")
          %>
            <!--#include file="../../html/GameTitleMenu/GameTitleList.asp"-->
          <%
        LRs.MoveNext
      Loop
    End If
    LRs.close
%>

<%
  DBClose()
%>