<!-- #include file="../../../Library/header.bike.asp" -->
<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, teamName, eventIdx

teamName = fInject(Request("teamName"))
eventIdx = fInject(Request("eventIdx"))
If teamName = "" Or eventIdx = "" Then
  Response.End
End If

on error resume next
db.BeginTrans()
' 팀명, 종목, 리더idx(사용중여부)로 사용가능한지 1차 검색
SQL =       " SELECT Count(a.TeamName) FROM tblBikeTeam a "
SQL = SQL & " LEFT JOIN tblBikeEventApplyInfo b ON a.teamIdx = b.teamIdx "
SQL = SQL & " WHERE a.DelYN = 'N' AND b.DelYN = 'N' AND a.TeamName = '"& teamName &"' AND b.EventIdx = "& eventIdx &" AND a.LeaderIdx > 0 "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  useCount = rs(0)
  ' 사용가능한 팀명이면 기존에 동일한 이름으로 만들어진 팀명중 사용안하는 팀이 있는지 확인
  If useCount = 0 Then
    SQL = " SELECT teamIdx FROM tblBikeTeam WHERE TeamName = '"& teamName &"' AND EventIdx = "& eventIdx &" "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      teamIdx = rs(0)
    ' 없으면 새로 생성
    Else
      SQL = "SET NOCOUNT ON INSERT INTO tblBikeTeam (TeamName, EventIdx) VALUES ('"& teamName &"', "& eventIdx &") SELECT @@IDENTITY "
      Set rs = db.Execute(SQL)
      If Not rs.eof Then
        teamIdx = rs(0)
      End If
    End If

    jsonStr = "{""return"": true, ""teamIdx"": "& teamIdx &"}"
  Else
    jsonStr = "{""return"": false, ""message:"", ""사용중인 팀명""}"
  End If
End If
db.CommitTrans()
' db.RollbackTrans()

Response.Write jsonStr
Response.End

%>
