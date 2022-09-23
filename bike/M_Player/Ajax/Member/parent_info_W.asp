<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, titleIdx, memberIdx, pName, pPhoneNum, pRelation, adultYN

titleIdx         = fInject(Request("titleIdx"))
memberIdx        = fInject(Request("memberIdx"))
pName            = fInject(Request("pName"))
pPhoneNum        = fInject(Request("pPhoneNum"))
pRelation        = fInject(Request("pRelation"))
adultYN          = GetAdultBasedOnTitle(titleIdx, memberIdx, db)

If titleIdx = "" Or memberIdx = "" Then
  Response.End
End If

' 기존에 입력된 보호자 동의 내용이 있는지 확인
SQL = " SELECT COUNT(AgreeYN), AgreeYN, ParentInfoIdx FROM tblBikeParentInfo WHERE TitleIdx = "& titleIdx &" AND MemberIdx = "& memberidx &" AND DelYN = 'N' GROUP BY AgreeYN, ParentInfoIdx "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  parentInfoCount = rs(0)
  agreeYN         = rs(1)
  parentInfoIdx   = rs(2)

  ' 이미 동의한 내역이 있으면 수정 불가
  If agreeYN = "Y" And adultYN = "N" Then
    jsonStr = "{""return"": false, ""message"": ""동의내역있음""}"
    Response.write jsonStr
    Response.end
  End If
End If

' 본인핸드폰 확인
SQL = " SELECT UserPhone FROM SD_Member.dbo.tblMember WHERE MemberIdx = '"& memberIdx &"' AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  UserPhone = rs(0)
  If CStr(UserPhone) = CStr(pPhoneNum) Then
    jsonStr = "{""return"": false, ""message"": ""본인핸드폰""}"
    Response.write jsonStr
    Response.end
  End If
End If

on error resume next
db.BeginTrans()
' 입력된 추가정보가 있는지 확인 insert/update
If parentInfoCount = 0 Then
  SQL =       " SET NOCOUNT ON "
  SQL = SQL & " INSERT INTO tblBikeParentInfo (MemberIdx, TitleIdx, ParentName, ParentPhone, Relation) "
  SQL = SQL & " VALUES ('"& memberIdx &"', "& titleIdx &", '"& pName &"', '"& pPhoneNum &"', '"& pRelation &"') "
  SQL = SQL & " SELECT @@IDENTITY "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    parentInfoIdx = rs(0)
  End If
Else
  SQL =       " UPDATE tblBikeParentInfo SET ParentName = '"& pName &"', ParentPhone = '"& pPhoneNum &"', Relation = '"& pRelation &"' "
  SQL = SQL & " WHERE MemberIdx = '"& memberIdx &"' AND TitleIdx = "& titleIdx &" AND DelYN = 'N' "
  Call db.Execute(SQL)
End If

If adultYN = "Y" Then
  SQL = " UPDATE tblBikeParentInfo SET AgreeYN = 'Y', AgreeDate = GETDATE() WHERE ParentInfoIdx = "& parentInfoIdx &" "
  Call db.Execute(SQL)
End If


If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  jsonStr = "{""return"": true, ""parentInfoIdx"": "& parentInfoIdx &"}"
End If

db.dispose()
Set db = nothing
Set rs = nothing

Response.Write jsonStr
Response.End
%>
