<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

titleIdx          = fInject(Request("titleIdx"))
eventApplyIdx     = fInject(Request("eventApplyIdx"))
memberIdx         = fInject(Request("memberIdx"))
teamIdx           = fInject(Request("teamIdx"))
teamMemberAdd     = fInject(Request("teamMemberAdd")) '추가 팀원 리스트
teamMemberDel     = fInject(Request("teamMemberDel")) '삭제 팀원 리스트

If eventApplyIdx = "" Or memberIdx = "" Or teamIdx = "" Then
  Response.End
End If

' memberIdx= 22631
' titleIdx= 3
' eventApplyIdx= 374
' teamIdx= 87
' teamMemberAdd= "22615,22614,22613"
' teamMemberDel= "22632,22631"

' 팀원 추가/삭제 리스트 나눠서 배열에 담기
If teamMemberAdd <> "" Then
  arrTeamMemberAdd = Split(teamMemberAdd & ",", ",")
End If

' db 처리 시작
on error resume next
db.BeginTrans()

' 초대문자 기본정보 보내는사람, 종목정보, 링크
SQL =       " SELECT b.UserName, a.EventIdx FROM tblBikeEventApplyInfo a "
SQL = SQL & " LEFT JOIN SD_Member.dbo.tblMember b ON a.MemberIdx = b.MemberIDX "
SQL = SQL & " WHERE EventApplyIdx = '"& eventApplyIdx &"' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  senderName = rs("UserName")
  eventIdx = rs("EventIdx")
  kind = "teamInvite"
  link = "http://bike.sportsdiary.co.kr/bike/event/team_invite.asp"
  Set rs = nothing
End If



' 0. 기존 teamIdx 확인
SQL = " SELECT teamIdx FROM tblBikeEventApplyInfo WHERE DelYN = 'N' AND memberIdx = '"& memberIdx &"' AND EventApplyIdx = '"& eventApplyIdx &"' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  orgTeamIdx = rs(0)
Else
  db.RollbackTrans()
  jsonStr = "{""return"": false, ""message"": ""참가내역 정보 불일치""}"
  Response.Write jsonStr
  Response.End
End If


'1. 본인 팀 idx 업데이트
SQL = " UPDATE tblBikeEventApplyInfo SET TeamIdx = "& teamIdx &" WHERE EventApplyIdx = "& eventApplyIdx &" "
Call db.Execute(SQL)

' 새로운팀 리더설정 , 사용중인사람이 없는지 확인
SQL = " SELECT COUNT(*) FROM tblBikeTeam WHERE TeamIdx = "& teamIdx &" AND (LeaderIdx = 0 OR LeaderIdx = '"& memberIdx &"') "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  teamCount = rs(0)
  If teamCount = 0 Then
    jsonStr = "{""return"": false, ""message"": ""사용가능한 팀정보 없음""}"
    Response.Write jsonStr
    Response.End
  Else
    ' teamidx 에 해당하는 team에 leader 넣어주기
    SQL = " UPDATE tblBikeTeam SET LeaderIdx = '"& memberIdx &"' WHERE TeamIdx = "& teamIdx &" "
    Call db.Execute(SQL)
  End If
End If

' 2. 팀idx 변경시 기존 팀원 teamIdx 업데이트
If Cdbl(teamIdx) <> Cdbl(orgTeamIdx) AND Cdbl(orgTeamIdx) > 0 Then
  SQL = " UPDATE tblBikeEventApplyInfo SET TeamIdx = "& teamIdx &" WHERE TeamIdx = "& orgTeamIdx &" AND DelYN = 'N' "
  Call db.Execute(SQL)

  ' 팀초대내역에 팀정보 업데이트
  SQL = " UPDATE tblBikeTeamInvite SET TeamIdx = "& teamIdx &" WHERE TeamIdx = "& orgTeamIdx &" AND DelYN = 'N' "
  Call db.Execute(SQL)

  ' 기존팀 사용비워주기
  SQL = " UPDATE tblBikeTeam SET LeaderIdx = 0 WHERE TeamIdx = "& orgTeamIdx &" "
  Call db.Execute(SQL)
End If


' 3. 팀원 추가
If IsArray(arrTeamMemberAdd) Then
  For a = 0 To Ubound(arrTeamMemberAdd) - 1
    teamMemberIdx = arrTeamMemberAdd(a)

    SQL =       " SELECT COUNT(*) FROM tblBikeTeamInvite a"
    SQL = SQL & " LEFT JOIN tblBikeTeam b ON a.TeamIdx = b.TeamIdx  "
    SQL = SQL & " WHERE a.MemberIdx = '"& teamMemberIdx &"' AND a.DelYN = 'N' AND b.EventIdx = "& eventIdx &" "


    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      invitedCount = rs(0)
    End If

    SQL = " SELECT COUNT(*) FROM tblBikeTeam WHERE LeaderIdx = '"& teamMemberIdx &"' AND EventIdx = "& eventIdx &" "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      leaderCount = rs(0)
    End If

    ' 종목참가선택내역 확인
    SQL = " SELECT COUNT(*) FROM tblBikeEventApplyInfo WHERE MemberIdx = '"& teamMemberIdx &"' AND EventIdx = "& eventIdx &" AND DelYN = 'N' "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      eApplyCount = rs(0)
    End If


    If Cdbl(invitedCount) > 0 Or Cdbl(leaderCount) > 0 Or Cdbl(eApplyCount) Then
      jsonStr = "{""return"": false, ""message"": ""동일종목 팀 참가내역 있음""}"
      Response.Write jsonStr
      Response.End
    End If


    '조건 - 팀원이 본인이면 등록 안됨, 팀참가내역 없음
    If teamMemberIdx <> memberIdx AND Cdbl(invitedCount) = 0 AND Cdbl(leaderCount) = 0 Then
      ' 3-1. team에 초대
      SQL =       " SET NOCOUNT ON "
      SQL = SQL & " INSERT INTO tblBikeTeamInvite (MemberIdx, InviteMember, TeamIdx) "
      SQL = SQL & " VALUES ('"& teamMemberIdx &"', '"& memberIdx &"', "& teamIdx &") "
      SQL = SQL & " SELECT @@IDENTITY "

      Set rs = db.Execute(SQL)
      If Not rs.eof Then
        inviteIdx = rs(0)

        ' 문자보내기
        SQL = " SELECT UserPhone FROM SD_Member.dbo.tblMember WHERE MemberIDX = '"& teamMemberIdx &"' "
        Set rs = db.Execute(SQL)
        If Not rs.eof Then
          phoneNum = rs(0)
          phoneNum = Replace(phoneNum, "-", "")
          title = "팀원초대"
          content = GetTextContent(db, kind, link, titleIdx, senderName)
          Call SendText(db, phoneNum, title, content)
        End If
      End If

      ' 3-2. 추가정보 입력여부 확인
      SQL = " SELECT COUNT(*) FROM tblBikeApplyMemberInfo WHERE DelYN ='N' AND MemberIdx = '"& teamMemberIdx &"' AND TitleIdx = "& titleIdx &"  "
      Set rs = db.Execute(SQL)
      If Not rs.eof Then
        applyinfoCount = rs(0)

        ' 3-2-1. 추가정보 있으면 참가신청테이블에 insert 후 팀초대수락여부 update
        If applyinfoCount > 0 Then
          SQL =       " INSERT INTO tblBikeEventApplyInfo (EventIdx, MemberIdx, TeamIdx) "
          SQL = SQL & " VALUES ((SELECT EventIdx FROM tblBikeEventApplyInfo WHERE EventApplyIdx = '"& eventApplyIdx &"'), '"& teamMemberIdx &"', "& teamIdx &") "
          Call db.Execute(SQL)

          ' 팀초대 테이블에 참가여부 업데이트
          SQL = " UPDATE tblBikeTeamInvite SET JoinYN = 'Y', JoinDate = GETDATE() WHERE TeamInviteIdx = "& inviteIdx &" "
          Call db.Execute(SQL)
        End If
      End If

    End If
  Next
End If

' 4.팀정보 삭제
If teamMemberDel <> "" Then
  mode = "member"
  Call DeleteTeamInfo(db, eventApplyIdx, mode, teamMemberDel, cancelYN)
End If

If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  jsonStr = "{""return"": true}"
End If


Set db = nothing
Set rs = nothing
Response.Write jsonStr
Response.End




%>
