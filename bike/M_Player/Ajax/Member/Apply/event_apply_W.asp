<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

titleIdx       = fInject(Request("titleIdx"))
memberIdx      = fInject(Request("memberIdx"))
eventIdx       = fInject(Request("eventIdx"))
eventApplyIdx  = fInject(Request("eventApplyIdx"))

If titleIdx = "" Or memberIdx = "" Or eventIdx = "" Then
  Response.End
End If

' 종목있는지 확인
SQL = " SELECT COUNT(*) FROM tblBikeEventList WHERE DelYN = 'N' AND TitleIdx = "& titleIdx &" AND EventIdx = "& eventIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  eventCount = rs(0)
  If eventCount = 0 Then
    jsonStr = "{""return"": false, ""message"": ""종목없음""}"
    Response.write jsonStr
    Response.end
  End If
End If


' 로드/ 트랙대회 참가 내역 있는지 확인
SQL =       " SELECT COUNT(*), EventType FROM tblBikeEventApplyInfo a "
SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & " WHERE b.EventType <> (SELECT EventType FROM tblBikeEventList WHERE EventIdx = "& eventIdx &") "
SQL = SQL & " AND a.DelYN = 'N' AND b.TitleIdx = "& titleIdx &" AND a.MemberIdx = '"& memberIdx &"' "
SQL = SQL & " GROUP BY EventType "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  diffEventApplyCount = rs(0)
  diffEventApplyType  = rs(1)
  If diffEventApplyCount > 0 Then
    jsonStr = "{""return"": false, ""message"": """& diffEventApplyType &"종목 참가중""}"
    Response.write jsonStr
    Response.end
  End If
End If

' 추가정보 있는지 확인
SQL = " SELECT COUNT(*) FROM tblBikeApplyMemberInfo WHERE DelYN = 'N' AND MemberIdx = '"& memberIDx &"' AND TitleIdx = "& titleIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  infoCount = rs(0)
  If infoCount = 0 Then
    jsonStr = "{""return"": false, ""message"": ""추가정보 입력필요""}"
    Response.write jsonStr
    Response.end
  End If
End If


If eventApplyIdx = "" Then
  ' 같은 종목에 참가한 내역 있는지 확인, CancelYN 컬럼으로 환불여부 판단.
  ' 단체전 참가할때는 팀명 중복사용 방지를 위해 teamidx가 없을때만(팀정보 입력전상태, teamidx 빈값 = 0) 업데이트하고, 팀정보 입력후 취소/재등록 시 insert해준다
  SQL =       " SELECT a.EventApplyIdx, a.DelYN FROM tblBikeEventApplyInfo a "
  SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
  SQL = SQL & " WHERE b.TitleIDX = "& titleIdx &" AND a.MemberIdx = "& memberIdx &" AND a.EventIdx = "& eventIdx &" AND CancelYN = 'N' AND TeamIdx = 0 "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    eventApplyIdx = rs(0)
    delState      = rs(1)
  Else
    delState      = "Y"
  End If
Else
  SQL = " SELECT delYN FROM tblBikeEventApplyInfo WHERE EventApplyIdx = "& eventApplyIdx &" AND EventIdx = "& eventIdx &" "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    delState = rs(0)
  Else
    jsonStr = "{""return"": false, ""message"": ""참가내역없음""}"
    Response.Write jsonStr
    Response.End
  End If
End If


If delState = "Y" Then
  delYN = "N"
ElseIf delState = "N" Then
  delYN = "Y"
End If

on error resume next
db.BeginTrans()
' 참가내역 있으면 업데이트, 없으면 insert
If Cdbl(eventApplyIdx) <> 0 Then
  SQL = " UPDATE tblBikeEventApplyInfo SET DelYN = '"& delYN &"', WriteDate = GETDATE() WHERE EventApplyIdx = "& eventApplyIdx &" AND EventIdx = "& eventIdx
  Set rs = db.Execute(SQL)
Else
  SQL = " SET NOCOUNT ON INSERT INTO tblBikeEventApplyInfo (EventIdx, MemberIdx) VALUES ("& eventIdx &", '"& memberIdx &"' ) SELECT @@IDENTITY "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    eventApplyIdx = rs(0)
  End If
End If



If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  massage = ""
  If delYN = "N" Then
    massage = "종목참가신청 완료"
  ElseIf delYN = "Y" Then
    massage = "종목참가신청 취소완료"
    state = "cancel"
  Else
    massage = "종목참가신청 완료"
  End If
  jsonStr = "{""return"": true, ""eventApplyIdx"": "& eventApplyIdx &", ""message"":"""& massage &""", ""state"": """& delState &"""}"
End If

Set db = nothing
Set rs = nothing
Response.Write jsonStr
Response.End
%>
