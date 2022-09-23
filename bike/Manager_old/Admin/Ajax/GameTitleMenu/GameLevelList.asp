<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->

<%
  REQ = Request("Req")
  Set oJSONoutput = JSON.Parse(REQ)
%>

<%
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson
  Response.write "`##`"
%>

<%
	tIdx = oJSONoutput.TIDX
  If(tIdx <> "") Then
    LSQL = " SELECT Top 1 GameTitleName,EnterType,GameS,GameE"
    LSQL = LSQL & " FROM  tblGameTitle"
    LSQL = LSQL & " WHERE DELYN = 'N' and GameTitleIDX = '" & tidx  & "'"

    Set TLRS = DBCon.Execute(LSQL)
    IF NOT (TLRS.Eof Or TLRS.Bof) Then
      Do Until TLRS.Eof
        tGameTitleName = TLRS("GameTitleName")
        tEnterType = TLRS("EnterType")
        tGameS = TLRS("GameS")
        tGameE = TLRS("GameE")
        TLRS.MoveNext
      Loop
    End If
    Call oJSONoutput.Set("tIdx", tIdx )
    Call oJSONoutput.Set("tEnterType", tEnterType )
    Call oJSONoutput.Set("tGameS", tGameS )
    Call oJSONoutput.Set("tGameE", tGameE )
    Call oJSONoutput.Set("tGameTitleName", tGameTitleName )
    strjson = JSON.stringify(oJSONoutput)		
    %>

    <input type="hidden" id="selGameTitleIdx" value="<%=tIdx%>">
    <input type="hidden" id="selGameTitleEnterType" value="<%=tEnterType%>">
    <input type="hidden" id="selGameTitleName" value="<%=tGameTitleName%>">

    <%

    LSQL = " SELECT GameLevelidx, GameTitleIDX, b.PubName as PlayType, c.PubName as GameType, f.TeamGbNm as TeamGb, e.PubName  as Level, Sex, d.PubName as GroupGameGb, GameDay, GameTime, OrderbyNum, a.DelYN, a.EditDate, a.WriteDate,  a.ViewYN as ViewYN "
    LSQL = LSQL & " FROM  tblGameLevel a "
    LSQL = LSQL & " LEFT JOIN tblPubcode b on a.PlayType = b.PubCode and b.DelYN = 'N' "
    LSQL = LSQL & " LEFT JOIN tblPubcode c on a.GameType = c.PubCode and c.DelYN = 'N' "
    LSQL = LSQL & " LEFT JOIN tblPubcode d on a.GroupGameGb = d.PubCode and d.DelYN = 'N' "
    LSQL = LSQL & " LEFT JOIN tblPubcode e on a.Level = e.PubCode and d.DelYN = 'N' "
    LSQL = LSQL & " LEFT JOIN tblTeamGbInfo f on a.TeamGb = f.TeamGb and f.DelYN = 'N' "
    LSQL = LSQL & " WHERE GameTitleIDX = "  & tIdx 
    'Response.Write LSQL
    Set LRs = DBCon.Execute(LSQL)
    IF NOT (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof
        rGameLevelidx = LRS("GameLevelidx")
        rGameTitleIDX = LRS("GameTitleIDX")
        rPlayType = LRS("PlayType")
        rGameType = LRS("GameType")
        rTeamGb = LRS("TeamGb")
        rLevel = LRS("Level")
        rSex = LRS("Sex")
        rGroupGameGb = LRS("GroupGameGb")
        rGameDay = LRS("GameDay")
        rGameTime = LRS("GameTime")
        rOrderbyNum = LRS("OrderbyNum")
        rDelYN = LRS("DelYN")
        rEditDate = LRS("EditDate")
        rWriteDate = LRS("WriteDate")
        rViewYN = LRS("ViewYN")
        %>
        <!--#include file="../../html/GameTitleMenu/GametTitleLevelList.asp"-->
        <%
        LRs.MoveNext
      Loop
    End If
  End IF
%>

