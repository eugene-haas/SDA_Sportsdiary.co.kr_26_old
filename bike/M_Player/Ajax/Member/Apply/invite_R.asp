<!-- #include file="../../../Library/header.bike.asp" -->
<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, hostIdx, memberIdx

memberIdx = fInject(Request("memberIdx"))
titleIdx = fInject(Request("titleIdx"))
If titleIdx = "" Or memberIdx = "" Then
  Response.End
End If

SQL =       " SELECT b.EventIdx, c.GroupType, c.CourseLength, c.EventDetailType "
SQL = SQL & " FROM tblBikeTeamInvite a "
SQL = SQL & " LEFT JOIN tblBikeEventApplyInfo b ON a.TeamIdx = b.TeamIdx "
SQL = SQL & " LEFT JOIN tblBikeEventList c ON b.EventIdx = c.EventIdx "
SQL = SQL & " WHERE a.DelYN = 'N' AND b.DelYN = 'N' AND a.JoinYN = 'N' AND a.MemberIdx = '"& MemberIdx &"' AND c.TitleIdx = '"& titleIdx &"' "

Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrInvite = rs.getRows()
End If

jsonStr = "{ "
jsonStr = jsonStr & " ""inviteList"": [ "

If IsArray(arrInvite) Then
  For i = 0 To Ubound(arrInvite, 2)
    EventIdx        = arrInvite(0, i)
    GroupType       = arrInvite(1, i)
    CourseLength    = arrInvite(2, i)
    EventDetailType = arrInvite(3, i)

    name = GetEventName(GroupType, CourseLength, EventDetailType)
    jsonStr = jsonStr & " {""teamReady"": ""False"", ""eventIdx"": "& EventIdx &", ""name"": """& name &"""} "
    If i < Ubound(arrInvite, 2) Then
      jsonStr = jsonStr & ", "
    End If
  Next
End If

jsonStr = jsonStr & "]"
jsonStr = jsonStr & "}"


Response.Write jsonStr
Response.End



''----------백업-----------------------------------
' S:단체전 신청정보
jsonStr = jsonStr & ", ""group"": ["
SQL =       " SELECT a.EventIdx, a.TeamName, a.EventApplyIdx "
SQL = SQL & " FROM tblBikeEventApplyInfo a "
SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & " WHERE b.GroupType = '단체' AND a.MemberIdx = "& memberIdx &" AND a.DelYN = 'N' AND a.CancelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrRsGroup = rs.getRows()
  If IsArray(arrRsGroup) Then
    For g = 0 To Ubound(arrRsGroup, 2)
      EventIdx      = arrRsGroup(0, g)
      TeamName      = arrRsGroup(1, g)
      EventApplyIdx = arrRsGroup(2, g)

      jsonStr = jsonStr & "{""eventIdx"": "& EventIdx &", ""teamName"": """& TeamName &""", "

      ' S:팀원정보찾기
      jsonStr = jsonStr & " ""teamMember"": ["
      SQL =       " SELECT a.MemberIdx, d.UserName, d.Birthday, d.UserPhone "
      SQL = SQL & "      , ISNULL(CONVERT(VARCHAR(10), b.MemberInfoIdx), 'N') ApplyInfo, ISNULL(c.AgreeYN, 'N') ParentAgree "
      SQL = SQL & " FROM tblBikeTeamInvite a "
      SQL = SQL & " LEFT JOIN tblBikeApplyMemberInfo b ON a.MemberIdx = b.MemberIdx "
      SQL = SQL & " LEFT JOIN tblBikeParentInfo c ON a.MemberIdx = c.MemberIdx "
      SQL = SQL & " LEFT JOIN SD_Member.dbo.tblMember d ON a.MemberIdx = d.MemberIDX "
      SQL = SQL & " WHERE a.EventApplyIdx = "& EventApplyIdx &" "
      SQL = SQL & " AND a.DelYN = 'N' "
      Set rs = db.Execute(SQL)
      If Not rs.eof Then
        arrTeamMember = rs.getRows()
        If IsArray(arrTeamMember) Then
          For tm = 0 To Ubound(arrTeamMember, 2)
            MemberIdx   = arrTeamMember(0, tm)
            UserName    = arrTeamMember(1, tm)
            Birthday    = arrTeamMember(2, tm)
            UserPhone   = arrTeamMember(3, tm)
            ApplyInfo   = arrTeamMember(4, tm)
            ParentAgree = arrTeamMember(5, tm)
            jsonStr = jsonStr & "{ ""memberIdx"": "& memberIdx &", ""name"": """& UserName &""", ""birth"": """& Birthday &""" "
            jsonStr = jsonStr & ", ""phoneNum"": """& UserPhone &""", ""applyInfo"": """& ApplyInfo &""", ""parentAgree"": """& ParentAgree &"""}"
            If tm < Ubound(arrTeamMember, 2) Then
              jsonStr = jsonStr & ", "
            End If
          Next
        End If
      End If
      jsonStr = jsonStr & "]"
      ' E:팀원정보찾기

      jsonStr = jsonStr & "}"
    Next
  End If
End If

jsonStr = jsonStr & "]"
' E:단체전 신청정보

%>
