<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, titleIdx, memberIdx, SCRP, bloodType, career, frame, gift, mode

titleIdx   = fInject(Request("titleIdx"))
memberIdx  = fInject(Request("memberIdx"))
SCRP       = fInject(Request("SCRP"))
bloodType  = fInject(Request("bloodType"))
career     = fInject(Request("career"))
frame      = fInject(Request("frame"))
gift       = fInject(Request("gift"))
agree      = fInject(Request("agree"))

If titleIdx = "" Or memberIdx = "" Or SCRP = "" Or bloodType = "" Or career = "" Or frame = "" Or gift ="" Then
  Response.End
End If

SQL = " SELECT COUNT(*) FROM tblBikeApplyMemberInfo WHERE TitleIdx = "& titleIdx &" AND MemberIdx = "& memberidx &" AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  infoCount = rs(0)
End If

SQL = " SELECT COUNT(*) FROM tblBikeGiftSelect WHERE TitleIdx = "& titleIdx &" AND MemberIdx = "& memberidx &" AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  giftInfoCount = rs(0)
End If


on error resume next
db.BeginTrans()
' 입력된 추가정보가 있는지 확인 insert/update
If infoCount > 0 Then
  SQL =       " UPDATE tblBikeApplyMemberInfo SET SCRP = "& SCRP &", BloodType = '"& bloodType &"', BikeCareer = "& career &", AgreeYN = '"& agree &"' "
  SQL = SQL & " , BikeFrame = "& frame &" WHERE TitleIdx = "& titleIdx &" AND MemberIdx = "& memberIdx &" AND DelYN = 'N' "
  Call db.Execute(SQL)
Else
  SQL =       " INSERT INTO tblBikeApplyMemberInfo (MemberIdx, TitleIdx, BloodType, BikeFrame, BikeCareer, SCRP, AgreeYN, DelYN, WriteDate) "
  SQL = SQL & " VALUES ( "& memberIdx &", "& titleIdx &", '"& bloodType &"', "& frame &", "& career &", "& SCRP &", '"& agree &"', 'N', GETDATE() ) "
  Call db.Execute(SQL)
End If


' 사은품선택내역이 있는지 확인 insert/update
If giftInfoCount > 0 Then
  SQL = " UPDATE tblBikeGiftSelect SET GiftIdx = "& gift &", WriteDate = GETDATE() WHERE TitleIdx = "& titleIdx &" AND MemberIdx = "& memberIdx &" AND DelYN = 'N'"
  Call db.Execute(SQL)

Else
  SQL = " INSERT INTO tblBikeGiftSelect (TitleIdx, MemberIdx, Giftidx, WriteDate, DelYN) VALUES ("& titleIdx &", "& memberIdx &", "& gift &", GETDATE(), 'N' ) "
  Call db.Execute(SQL)
End If


' 팀초대내역 확인후 팀참가
SQL =        " SELECT a.TeamInviteIdx, a.TeamIdx, b.EventIdx FROM tblBikeTeamInvite a "
SQL = SQL &  " LEFT JOIN tblBikeTeam b ON a.TeamIdx = b.TeamIdx "
SQL = SQL &  " LEFT JOIN tblBikeEventList c ON b.EventIdx = c.EventIdx "
SQL = SQL &  " WHERE a.MemberIdx = '"& memberIdx &"' AND JoinYN = 'N' AND a.DelYN = 'N' AND c.TitleIdx = "& titleIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrInvite = rs.getRows()

  If IsArray(arrInvite) Then
    For i = 0 To Ubound(arrInvite, 2)
      teamInviteIdx = arrInvite(0, i)
      teamIdx       = arrInvite(1, i)
      eventIdx      = arrInvite(2, i)

      SQL =       " INSERT INTO tblBikeEventApplyInfo (EventIdx, MemberIdx, TeamIdx) "
      SQL = SQL & " VALUES ("& eventIdx &", '"& memberIdx &"', "& teamIdx& ") "
      Call db.Execute(SQL)

      SQL = " UPDATE tblBikeTeamInvite SET JoinYN = 'Y', JoinDate = GETDATE() WHERE TeamInviteIdx = "& teamInviteIdx &" "
      Call db.Execute(SQL)
    Next
  End If
End If


If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  jsonStr = "{""return"": true}"
End If

Response.Write jsonStr
Response.End
Set db = nothing
Set rs = nothing





%>
