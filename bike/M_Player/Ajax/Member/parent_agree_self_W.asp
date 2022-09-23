<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, memberIdx, titleIdx

titleIdx  = fInject(Request("titleIdx"))
memberIdx = fInject(Request("memberIdx"))

If titleIdx = "" Or memberIdx = "" Then
  titleIdx = Session("titleIdx")
  memberIdx = Session("memberIdx")
  If titleIdx = "" Or memberIdx = "" Then
    Response.End
  End If
End If

' 통합회원 db에서 정보가져오기
SQL = " SELECT UserName, UserPhone FROM SD_Member.dbo.tblMember WHERE MemberIdx = '"& memberIdx &"' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  name      = rs(0)
  phoneNum  = rs(1)
End If

' 저장된 부모동의 정보 있는지 확인
SQL = " SELECT COUNT(ParentInfoIdx), ParentInfoIdx FROM tblBikeParentInfo WHERE DelYN = 'N' AND MemberIdx = '"& memberIdx &"' AND TitleIdx = "& titleIdx &" GROUP BY ParentInfoIdx "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  parentInfoIdx = rs(0)
End If

on error resume next
db.BeginTrans()
' 입력된 추가정보가 있는지 확인 insert/update
If parentInfoIdx <> "" Then
  SQL =       " UPDATE tblBikeParentInfo SET ParentName = '"& name &"', ParentPhone = '"& phoneNum &"', Relation = '본인', AgreeDate = GETDATE(), AgreeYN = 'Y' "
  SQL = SQL & " WHERE ParentInfoIdx = "& parentInfoIdx &" AND MemberIdx = '"& memberIdx &"' AND DelYN = 'N' AND AgreeYN = 'N' "
  Call db.Execute(SQL)
Else
  SQL =       " INSERT INTO tblBikeParentInfo (MemberIdx, TitleIdx, ParentName, ParentPhone, Relation, AgreeDate, AgreeYN, DelYN) "
  SQL = SQL & " VALUES ('"& memberIdx &"', "& titleIdx &", '"& name &"', '"& phoneNum &"', '본인', GETDATE(), 'Y', 'N')"
  Call db.Execute(SQL)
End If

If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  jsonStr = "{""return"": true}"
End If


db.dispose()
Set db = nothing
Set rs = nothing

Response.Write jsonStr
Response.End
%>
