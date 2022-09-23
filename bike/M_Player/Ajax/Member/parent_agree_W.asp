<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

Dim jsonStr, p, pPhoneNum, pAdress, pAdressDetail, pBirth

p              = fInject(Request("p"))
pPhoneNum      = fInject(Request("pPhoneNum"))
pAdress        = fInject(Request("pAddress"))
pAdressDetail  = fInject(Request("pAddressDetail"))
pBirth         = fInject(Request("pBirth"))
If p = "" Or pPhoneNum = "" Or pAdress = "" Or pBirth = "" Then
  Response.End
Else
  pDecode        = decode(p, 0)
  parentInfoIdx  = Split(pDecode, ",")(0)
  memberIdx      = Split(pDecode, ",")(1)
  titleIdx       = Split(pDecode, ",")(2)
End If

' 동일한 전화번호인지 비교
SQL = " SELECT ParentPhone, AgreeYN FROM tblBikeParentInfo WHERE DelYN = 'N' AND ParentInfoIdx = "& parentInfoIdx &" AND MemberIdx = "& memberIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  orgPhoneNum = rs(0)
  agree       = rs(1)

  ' 보호자동의 문자보낸 번호와 현재 저장되어 있는 보호자 번호 비교해서 다르면 리턴
  If CStr(orgPhoneNum) <> CStr(pPhoneNum) Then
    jsonStr = "{""return"": false, ""message"": ""보호자동의 요청정보가 일치하지 않습니다.""}"
    Response.Write jsonStr
    Response.End
  End If

  ' 동의자정보가 한번 저장하면 추가로 동의 못하도록 리턴
  If agree = "Y" Then
    jsonStr = "{""return"": false, ""message"": ""이미 보호자동의가 완료된 선수입니다.""}"
    Response.Write jsonStr
    Response.End
  End If
Else
  Response.end
End If

on error resume next
db.BeginTrans()
' 입력된 추가정보가 있는지 확인 insert/update
If parentInfoIdx <> "" Then
  SQL =       " UPDATE tblBikeParentInfo SET ParentBirth = '"& pBirth &"', Adress = '"& pAdress &"', AdressDetail = '"& pAdressDetail &"', AgreeDate = GETDATE(), AgreeYN = 'Y' "
  SQL = SQL & " WHERE ParentInfoIdx = "& parentInfoIdx &" AND MemberIdx = '"& memberIdx &"' AND DelYN = 'N' AND AgreeYN = 'N' "
  Call db.Execute(SQL)
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
