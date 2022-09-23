<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, hostIdx, memberIdx, info

memberIdx = fInject(Request("memberIdx"))
titleIdx = fInject(Request("titleIdx"))
addInfo = fInject(Request("addInfo"))
parentInfo = fInject(Request("parentInfo"))
If titleIdx = "" Or memberIdx = "" Then
  Response.End
End If

If addInfo = "Y" Then
  SQL = "SELECT MemberInfoIdx FROM tblBikeApplyMemberInfo WHERE MemberIdx = '"& memberIdx &"' AND TitleIdx = '"& titleIdx &"' AND DelYN = 'N'"
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    addInfoJsonStr = " ""addInfo"": ""Y"" "
  Else
    addInfoJsonStr = " ""addInfo"": ""N"" "
  End If
End If

If parentInfo = "Y" Then
  SQL = " SELECT ParentInfoIdx FROM tblBikeParentInfo WHERE MemberIdx = '"& memberIdx &"' AND TitleIdx = '"& titleIdx &"' AND DelYN = 'N' AND AgreeYN = 'Y' "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    parentJsonStr = " ""parent"": ""Y"" "
  Else
    parentJsonStr = " ""parent"": ""N"" "
  End If
End If


' 개인종목 신청리스트 select
SQL =       " SELECT a.EventIdx, b.GroupType, b.EventDetailType, c.TitleName "
SQL = SQL & " , (CASE ISNULL(pa.paymentState, 0) WHEN 1 THEN 'Y' ELSE 'N' END ) PayState, ISNULL(d.AgreeYN, 'N') ParentAgree, b.EventType "
SQL = SQL & " , (CASE ISNULL(pa.PaymentAccount, 'None') WHEN 'None' THEN 'N' ELSE 'Y' END ) VAccountYN, a.EventApplyIdx "
SQL = SQL & " FROM tblBikeEventApplyInfo a "
SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & " LEFT JOIN tblBikeTitle c ON b.TitleIdx = c.TitleIdx "
SQL = SQL & " LEFT JOIN tblBikeParentInfo d ON a.MemberIdx = d.MemberIdx AND b.TitleIdx = d.TitleIdx "
SQL = SQL & " LEFT JOIN tblBikePayment pa ON a.PaymentIdx = pa.PaymentIdx "
SQL = SQL & " WHERE b.TitleIdx = "& titleIdx &"  "
SQL = SQL & " AND a.MemberIdx = "& memberIdx &"  "
SQL = SQL & " AND a.DelYN = 'N' "
SQL = SQL & " AND b.GroupType = '개인' "

Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrRsSolo = rs.getRows()
End If

' 단체종목 신청리스트 select
SQL =       " SELECT a.EventIdx, b.GroupType, b.EventDetailType, c.TitleName, a.TeamIdx, e.TeamName "
SQL = SQL & " , (CASE ISNULL(pa.paymentState, 0) WHEN 1 THEN 'Y' ELSE 'N' END  ) PayState, ISNULL(d.AgreeYN, 'N') ParentAgree, ISNULL(e.LeaderIdx, 0), a.EventApplyIdx, b.EventType  "
SQL = SQL & " , (CASE ISNULL(pa.PaymentAccount, 'None') WHEN 'None' THEN 'N' ELSE 'Y' END ) VAccountYN "
SQL = SQL & " FROM tblBikeEventApplyInfo a "
SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & " LEFT JOIN tblBikeTitle c ON b.TitleIdx = c.TitleIdx "
SQL = SQL & " LEFT JOIN tblBikeParentInfo d ON a.MemberIdx = d.MemberIdx AND b.TitleIdx = d.TitleIdx "
SQL = SQL & " LEFT JOIN tblBikeTeam e ON a.TeamIdx = e.TeamIdx "
SQL = SQL & " LEFT JOIN tblBikePayment pa ON a.PaymentIdx = pa.PaymentIdx "
SQL = SQL & " LEFT JOIN "& V_ACCOUNT_MAST &" va ON pa.PaymentAccount = va.VACCT_NO "
SQL = SQL & " WHERE b.TitleIdx = "& titleIdx &"  "
SQL = SQL & " AND a.MemberIdx = "& memberIdx &"  "
SQL = SQL & " AND a.DelYN = 'N' "
SQL = SQL & " AND b.GroupType = '단체' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrRsGroup = rs.getRows()
End If

' 단체종목 신청리스트 select
SQL =       " SELECT teamapply.EventIdx, b.GroupType, b.EventDetailType, c.TitleName, ti.TeamIdx, team.TeamName  "
SQL = SQL & " , (CASE ISNULL(pa.paymentState, 0) WHEN 1 THEN 'Y' ELSE 'N' END  ) PayState, ISNULL(d.AgreeYN, 'N') ParentAgree "
SQL = SQL & " , ISNULL(team.LeaderIdx, 0) LeaderIdx, ISNULL(myapply.EventApplyIdx, 0) EventApplyIdx, b.EventType   "
SQL = SQL & " , (CASE ISNULL(pa.PaymentAccount, 'None') WHEN 'None' THEN 'N' ELSE 'Y' END ) VAccountYN  "
SQL = SQL & " FROM tblBikeTeamInvite ti "
SQL = SQL & " LEFT JOIN tblBikeTeam team ON ti.TeamIdx = team.TeamIdx  "
SQL = SQL & " LEFT JOIN tblBikeEventApplyInfo myapply ON ti.TeamIdx = myapply.TeamIdx AND ti.MemberIdx = myapply.MemberIdx "
SQL = SQL & " LEFT JOIN tblBikeEventApplyInfo teamapply ON team.TeamIdx = teamapply.TeamIdx AND team.LeaderIdx = teamapply.MemberIdx "
SQL = SQL & " LEFT JOIN tblBikeEventList b ON teamapply.EventIdx = b.EventIdx  "
SQL = SQL & " LEFT JOIN tblBikeTitle c ON b.TitleIdx = c.TitleIdx  "
SQL = SQL & " LEFT JOIN tblBikeParentInfo d ON ti.MemberIdx = d.MemberIdx AND b.TitleIdx = d.TitleIdx "
SQL = SQL & " LEFT JOIN tblBikePayment pa ON teamapply.PaymentIdx = pa.PaymentIdx  "
SQL = SQL & " LEFT JOIN "& V_ACCOUNT_MAST &" va ON pa.PaymentAccount = va.VACCT_NO  "
SQL = SQL & " WHERE b.TitleIdx = "& titleIdx &" "
SQL = SQL & " AND ti.MemberIdx = "& memberIdx &" "
SQL = SQL & " AND ti.DelYN = 'N'  "
SQL = SQL & " AND ti.JoinYN = 'N'  "
SQL = SQL & " AND teamapply.DelYN = 'N' "
SQL = SQL & " AND b.GroupType = '단체'  "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrRsTeamInvite = rs.getRows()
End If


jsonStr = "{"

If addInfoJsonStr <> "" Then
  jsonStr = jsonStr & addInfoJsonStr & ","
End If

If parentJsonStr <> "" Then
  jsonStr = jsonStr & parentJsonStr & ","
End If

jsonStr = jsonStr & " ""applyList"": {"

' S:개인전 신청정보
jsonStr = jsonStr & " ""solo"": ["
If IsArray(arrRsSolo) Then

  For s = 0 To Ubound(arrRsSolo, 2)
    EventIdx         = arrRsSolo(0, s)
    GroupType        = arrRsSolo(1, s)
    EventDetailType  = arrRsSolo(2, s)
    TitleName        = arrRsSolo(3, s)
    PayState         = arrRsSolo(4, s)
    ParentAgree      = arrRsSolo(5, s)
    EventType        = arrRsSolo(6, s)
    VAccountYN       = arrRsSolo(7, s)
    EventApplyIdx    = arrRsSolo(8, s)
    ApplyComplete    = "N"
    If PayState = "Y" AND ParentAgree = "Y" Then
      ApplyComplete = "Y"
    End If

    jsonStr = jsonStr & " {""eventType"": """& EventType &""", ""eventIdx"": "& eventIdx &", ""groupType"": """& groupType &""", ""eventDetailType"": """& eventDetailType &""", ""eventApplyIdx"": "& EventApplyIdx &" "
    jsonStr = jsonStr & " , ""titleName"": """& titleName &""", ""payState"": """& payState &""", ""parentAgree"": """& parentAgree &""", ""applyComplete"": """& ApplyComplete &""", ""VAccountYN"": """& VAccountYN &"""} "
    If s < Ubound(arrRsSolo, 2) Then
      jsonStr = jsonStr & ", "
    End If
  Next
End If
jsonStr = jsonStr &  "],"
' E:개인전 신청정보



' S:단체전 신청정보
jsonStr = jsonStr & " ""group"": ["
If IsArray(arrRsGroup) Then
  For g = 0 To Ubound(arrRsGroup, 2)
    EventIdx              = arrRsGroup(0, g)
    GroupType             = arrRsGroup(1, g)
    EventDetailType       = arrRsGroup(2, g)
    TitleName             = arrRsGroup(3, g)
    TeamIdx               = arrRsGroup(4, g)
    TeamName              = arrRsGroup(5, g)
    PayState              = arrRsGroup(6, g)
    ParentAgree           = arrRsGroup(7, g)
    TeamLeaderIdx         = arrRsGroup(8, g)
    EventApplyIdx         = arrRsGroup(9, g)
    EventType             = arrRsGroup(10, g)
    VAccountYN            = arrRsGroup(11, g)

    ApplyComplete    = "N"
    If PayState = "Y" AND ParentAgree = "Y" Then
      ApplyComplete = "Y"
    End If

    If Cdbl(memberIdx) = Cdbl(TeamLeaderIdx) Or Cdbl(TeamIdx) = 0 Then
      TeamLeader = "Y"
    Else
      TeamLeader = "N"
    End If

    teamReady = SQLGetTeamReady(db, TeamIdx) ' 팀원 준비상태확인

    jsonStr = jsonStr & " {""eventType"": """& EventType &""", ""eventIdx"": "& eventIdx &", ""groupType"": """& groupType &""", ""teamIdx"": "& TeamIdx &", ""teamName"": """& TeamName &""" "
    jsonStr = jsonStr & " , ""eventDetailType"": """& eventDetailType &""", ""teamLeader"": """& TeamLeader &""", ""titleName"": """& titleName &""" "
    jsonStr = jsonStr & " , ""payState"": """& payState &""", ""parentAgree"": """& parentAgree &""", ""applyComplete"": """& ApplyComplete &""" "
    jsonStr = jsonStr & " , ""VAccountYN"": """& VAccountYN &""", ""teamReady"": """& teamReady &""", ""eventApplyIdx"": "& EventApplyIdx &"} "
    If g < Ubound(arrRsGroup, 2) Then
      jsonStr = jsonStr & ", "
    End If
  Next

  ' 팀원으로 초대받은 내역이 있으면 콤마 추가
  If IsArray(arrRsTeamInvite) Then
      jsonStr = jsonStr & ", "
  End If
End If

' 팀원으로 초대받은 내역있는지 확인,
' joinyn 컬럼 확인해서 Y이면 tblBikeEventApplyInfo에 들어가 있으면 가져올필요없음.
If IsArray(arrRsTeamInvite) Then
  For g = 0 To Ubound(arrRsTeamInvite, 2)
    EventIdx              = arrRsTeamInvite(0, g)
    GroupType             = arrRsTeamInvite(1, g)
    EventDetailType       = arrRsTeamInvite(2, g)
    TitleName             = arrRsTeamInvite(3, g)
    TeamIdx               = arrRsTeamInvite(4, g)
    TeamName              = arrRsTeamInvite(5, g)
    PayState              = arrRsTeamInvite(6, g)
    ParentAgree           = arrRsTeamInvite(7, g)
    TeamLeaderIdx         = arrRsTeamInvite(8, g)
    EventApplyIdx         = arrRsTeamInvite(9, g)
    EventType             = arrRsTeamInvite(10, g)
    VAccountYN            = arrRsTeamInvite(11, g)

    ApplyComplete    = "N"
    If PayState = "Y" AND ParentAgree = "Y" Then
      ApplyComplete = "Y"
    End If

    If Cdbl(memberIdx) = Cdbl(TeamLeaderIdx) Or Cdbl(TeamIdx) = 0 Then
      TeamLeader = "Y"
    Else
      TeamLeader = "N"
    End If

    teamReady = SQLGetTeamReady(db, TeamIdx) ' 팀원 준비상태확인

    jsonStr = jsonStr & " {""eventType"": """& EventType &""", ""eventIdx"": "& eventIdx &", ""groupType"": """& groupType &""", ""teamIdx"": "& TeamIdx &", ""teamName"": """& TeamName &""" "
    jsonStr = jsonStr & " , ""eventDetailType"": """& eventDetailType &""", ""teamLeader"": """& TeamLeader &""", ""titleName"": """& titleName &""" "
    jsonStr = jsonStr & " , ""payState"": """& payState &""", ""parentAgree"": """& parentAgree &""", ""applyComplete"": """& ApplyComplete &""" "
    jsonStr = jsonStr & " , ""VAccountYN"": """& VAccountYN &""", ""teamReady"": """& teamReady &""", ""eventApplyIdx"": "& EventApplyIdx &"} "
    If g < Ubound(arrRsTeamInvite, 2) Then
      jsonStr = jsonStr & ", "
    End If
  Next
End If


jsonStr = jsonStr &  "]"
' E:단체전 신청정보

jsonStr = jsonStr & "}}"

Response.Write jsonStr
Response.End
%>
