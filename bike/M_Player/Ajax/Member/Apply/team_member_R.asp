<!-- #include file="../../../Library/header.bike.asp" -->


<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, teamName, eventIdx

eventApplyIdx = fInject(Request("eventApplyIdx"))

If eventApplyIdx = "" Then
  Response.End
End If

SQL =       " SELECT a.TeamIdx, b.TitleIdx FROM tblBikeEventApplyInfo a "
SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & " WHERE a.EventApplyIdx = "& eventApplyIdx
Set rs = db.Execute(SQL)
If Not rs.eof Then
  teamIdx  = rs(0)
  titleIdx = rs(1)
End If

If Cdbl(teamIdx) <> 0 Then
  teamReady = SQLGetTeamReady(db, teamIdx)
End If


SQL =       " SELECT b.TeamName, a.MemberIdx, g.UserName, g.UserID, g.Birthday "
SQL = SQL & "      , g.UserPhone, ISNULL(e.AgreeYN, 'N') ParentAgreeYN, (SELECT CASE ISNULL(f.MemberInfoIdx, 0) WHEN 0 THEN 'N' ELSE 'Y' END) ApplyInfoYN "
SQL = SQL & " FROM tblBikeTeamInvite a "
SQL = SQL & " LEFT JOIN tblBikeTeam b ON a.TeamIdx = b.TeamIdx "
SQL = SQL & " LEFT JOIN tblBikeEventList c ON b.EventIdx = c.EventIdx "
SQL = SQL & " LEFT JOIN tblBikeEventApplyInfo d ON b.EventIdx = d.EventIdx AND a.MemberIdx = d.MemberIdx "
SQL = SQL & " LEFT JOIN (SELECT TOP 1 * FROM tblBikeParentInfo ORDER BY WriteDate DESC) e ON a.MemberIdx = e.MemberIdx "
SQL = SQL & " LEFT JOIN (SELECT TOP 1 * FROM tblBikeApplyMemberInfo ORDER BY WriteDate DESC) f ON a.MemberIdx = f.MemberIdx "
SQL = SQL & " LEFT JOIN SD_Member.dbo.tblMember g ON a.MemberIdx = g.MemberIdx "
SQL = SQL & " WHERE a.TeamIdx = '"& teamIdx &"' AND a.DelYN = 'N' AND c.TitleIDx = '"& titleIdx &"' AND (d.DelYN = 'N' OR d.DelYN IS NULL) "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrTeamMember = rs.getRows()
End If

jsonStr = "{"
jsonStr = jsonStr & """teamReady"": """& teamReady &""", "
jsonStr = jsonStr & """teamMembers"": "
jsonStr = jsonStr & "["
If IsArray(arrTeamMember) Then
  For i = 0 To Ubound(arrTeamMember, 2)
    teamName      = arrTeamMember(0, i)
    MemberIdx     = arrTeamMember(1, i)
    UserName      = arrTeamMember(2, i)
    UserID        = arrTeamMember(3, i)
    Birthday      = arrTeamMember(4, i)
    UserPhone     = arrTeamMember(5, i)
    ParentAgreeYN = arrTeamMember(6, i)
    ApplyInfoYN   = arrTeamMember(7, i)
    jsonStr = jsonStr & "{""teamName"": """& teamName &""", ""memberIdx"": "& memberIdx &", ""name"": """& UserName &""", ""birth"": """& Birthday &""" "
    jsonStr = jsonStr & ", ""phoneNum"": """& UserPhone &""", ""parentAgree"": """& ParentAgreeYN &""", ""applyInfoYN"": """& ApplyInfoYN &""" }"
    If i < Ubound(arrTeamMember, 2) Then
      jsonStr = jsonStr & ","
    End If
  Next
End If
jsonStr = jsonStr & "]"
jsonStr = jsonStr & "}"


Response.Write jsonStr
Response.End

%>
