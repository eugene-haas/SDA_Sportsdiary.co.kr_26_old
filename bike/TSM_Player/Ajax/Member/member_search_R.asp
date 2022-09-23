<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

id       = fInject(Request("id"))
eventIdx = fInject(Request("eventIdx"))
teamIdx  = fInject(Request("teamIdx"))
If id = "" Or eventIdx = "" Then
  Response.end
End If

' 종목참가 성별확인해서 검색되는 회원을 제한한다
SQL = " SELECT Gender, RatingCategory, TitleIdx FROM tblBikeEventList WHERE EventIdx = "& eventIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  gender = rs(0)
  ratingCategory = rs(1)
  titleIdx = rs(2)
  If gender = "남자" Then
    genderCondition = " AND Sex = 'Man' "
  ElseIf gender = "여자" Then
    genderCondition = " AND Sex = 'WoMan' "
  Else
    genderCondition = ""
  End If
End If




jsonStr = "{"

SQL = " SELECT MemberIdx, UserName, BirthDay, UserPhone FROM SD_Member.dbo.tblMember WHERE UserID = '"& id &"' "& genderCondition &" AND DelYN = 'N' "
Set rs = db.Execute(SQL)

jsonStr = jsonStr & " ""userInfo"": "
jsonStr = jsonStr & "["

If Not rs.eof Then
  MemberIdx = rs("MemberIdx")
  UserName  = rs("UserName")
  BirthDay  = rs("BirthDay")
  UserPhone = rs("UserPhone")

  ' 종목에 이미 참가해있는지 확인, teamIdx 가 존재하면 해당팀말고 다른팀에 소속되어 있는지를 확인한다.
  ' 초대테이블 확인
  SQL =       " SELECT COUNT(*) FROM tblBikeTeamInvite a "
  SQL = SQL & " LEFT JOIN tblBikeTeam b ON a.TeamIdx = b.TeamIdx "
  SQL = SQL & " LEFT JOIN tblBikeEventList c ON b.EventIdx = c.EventIdx "
  SQL = SQL & " LEFT JOIN SD_Member.dbo.tblMember d ON a.MemberIdx = d.MemberIdx "
  SQL = SQL & " WHERE b.EventIdx = "& eventIdx &" AND a.DelYN = 'N' AND d.UserID = '"& id &"' AND d.DelYN = 'N' "
  If teamIdx <> "" Then
    SQL = SQL & " AND a.TeamIdx <> "& teamIdx &" "
  End If
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    inviteCount = rs(0)
  End If

  ' 참가테이블 확인
  SQL =        " SELECT COUNT(*) FROM tblBikeEventApplyInfo a "
  SQL = SQL &  " LEFT JOIN SD_Member.dbo.tblMember b ON a.MemberIDX = b.MemberIdx "
  SQL = SQL &  " WHERE b.UserId = '"& id &"' AND a.EventIdx = "& eventIdx &" AND a.DelYN = 'N' "
  If teamIdx <> "" Then
    SQL = SQL & " AND a.TeamIdx <> "& teamIdx &" "
  End If
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    applyCount = rs(0)
  End If

  ' 다른팀참가내역이 없으면 리턴
  If Cdbl(inviteCount) = 0 AND Cdbl(applyCount) = 0 Then
    SQL =       " SELECT SCRP, b.Category FROM tblBikeApplyMemberInfo a "
    SQL = SQL & " LEFT JOIN tblBikeSCRP b ON a.SCRP = b.SCRPRatingIdx "
    SQL = SQL & " WHERE MemberIdx = '"& memberIdx &"' AND TitleIdx = "& titleIdx &" "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      SCRP = rs("SCRP")
      SCRPCategory = rs("Category")
    End If

    jsonStr = jsonStr & "{ ""memberIdx"": "& MemberIdx &", ""name"": """& UserName &""", ""birth"": """& BirthDay &""" "
    jsonStr = jsonStr & ", ""phoneNum"": """& UserPhone &""", ""SCRP"": """& SCRP &""", ""SCRPCategory"": """& SCRPCategory &""" } "
  End If
Else
  ' 결과없음 빈값
End If

jsonStr = jsonStr & "]"
jsonStr = jsonStr & "}"


Set db = nothing
Set rs = nothing
Response.Write jsonStr
Response.End
%>
