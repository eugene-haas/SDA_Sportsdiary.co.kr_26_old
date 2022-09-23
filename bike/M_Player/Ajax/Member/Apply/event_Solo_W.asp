<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, titleIdx, memberIdx, eventIdx

titleIdx  = fInject(Request("titleIdx"))
memberIdx = fInject(Request("memberIdx"))
eventIdx  = fInject(Request("eventIdx"))

If titleIdx = "" Or memberIdx = "" Or eventIdx = "" Then
  Response.End
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


' 같은 종목에 참가한 내역 있는지 확인, CancelYN 컬럼으로 환불여부 판단
SQL =       " SELECT a.EventApplyIdx, a.DelYN FROM tblBikeEventApplyInfo a "
SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & " WHERE b.TitleIDX = "& titleIdx &" AND a.MemberIdx = "& memberIdx &" AND a.EventIdx = "& eventIdx &" AND CancelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  eventApplyIdx = rs(0)
  delState      = rs(1)
  If delState = "Y" Then
    delYN = "N"
  ElseIf delState = "N" Then
    delYN = "Y"
  End If
End If

on error resume next
db.BeginTrans(B_ConStr)
' 참가내역 있으면 업데이트, 없으면 insert
If eventApplyIdx <> "" Then
  SQL = " UPDATE tblBikeEventApplyInfo SET DelYN = '"& delYN &"', WriteDate = GETDATE() WHERE EventApplyIdx = "& eventApplyIdx &" "
  Call db.Execute(SQL)
Else
  SQL = " INSERT INTO tblBikeEventApplyInfo (EventIdx, MemberIdx) VALUES ("& eventIdx &", '"& memberIdx &"' ) "
  Call db.Execute(SQL)
End If

If err.number <> 0 Then
  db.RollbackTrans(B_ConStr)
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans(B_ConStr)
  massage = ""
  If delYN = "N" Then
    massage = "종목참가신청 완료"
  ElseIf delYN = "Y" Then
    massage = "종목참가신청 취소완료"
  Else
    massage = "종목참가신청 완료"
  End If
  jsonStr = "{""return"": true, ""message"":"""& massage &"""}"
End If

db.dispose()
Set db = nothing
Set rs = nothing

Response.Write jsonStr
Response.End
%>
