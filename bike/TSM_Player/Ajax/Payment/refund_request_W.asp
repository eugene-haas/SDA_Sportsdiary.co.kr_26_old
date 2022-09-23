<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

paymentIdx     = fInject(Request("paymentIdx"))
memberIdx      = fInject(Request("memberIdx"))
AccountName    = fInject(Request("accountName"))
AccountBank    = fInject(Request("accountBank"))
AccountNumber  = fInject(Request("accountNumber"))
mode       = "all"
CancelYN   = "Y"

If paymentIdx = "" Or memberIdx = "" Or AccountName = "" Or AccountBank = "" Or AccountNumber = "" Then
  Response.End
End If

SQL = " SELECT COUNT(*) FROM tblBikePayment WHERE PaymentIdx = "& paymentIdx &" AND MemberIdx = '"& memberIdx &"' AND PaymentState = 1 "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  paymentValidation = rs(0)
  If paymentValidation = 0 Then
    jsonStr = "{""return"": false, ""messege"": ""환불요청 불가능 상태""}"
    Response.Write jsonStr
    Response.End
  End If
End If

on error resume next
db.BeginTrans()

' 1.환불정보테이블에 insert
SQL =       " INSERT INTO tblBikeRefund(PaymentIdx, AccountName, AccountBank, AccountNumber) "
SQL = SQL & " VALUES ("& paymentIdx &", '"& accountName &"', '"& AccountBank &"', '"& accountNumber &"' ) "
Call db.Execute(SQL)

' 2. paymentState 변경 3:환불대기중
SQL = " UPDATE tblBikePayment Set PaymentState = 3 WHERE PaymentIdx = "& paymentIdx &" "
Call db.Execute(SQL)

' S: 3. 참가신청 취소
SQL =       " SELECT EventApplyIdx FROM tblBikeEventApplyInfo a "
SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & " WHERE a.PaymentIdx = "& paymentIdx &" AND a.MemberIdx = '"& memberIdx &"' AND b.GroupType = '개인' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrSoloEventApplyIdx = rs.getRows()
End If

SQL =       " SELECT EventApplyIdx FROM tblBikeEventApplyInfo a "
SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
SQL = SQL & " WHERE a.PaymentIdx = "& paymentIdx &" AND a.MemberIdx = '"& memberIdx &"' AND b.GroupType = '단체' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrGroupEventApplyIdx = rs.getRows()
End If


If IsArray(arrSoloEventApplyIdx) Then
  For s = 0 To Ubound(arrSoloEventApplyIdx, 2)
    applyIdx = arrSoloEventApplyIdx(0, s)
    SQL = " UPDATE tblBikeEventApplyInfo Set DelYN = 'Y' ,CancelYN = 'Y', CancelDate = GETDATE() WHERE EventApplyIdx = "& applyIdx &" "
    Call db.Execute(SQL)
  Next
End If

If IsArray(arrGroupEventApplyIdx) Then
  For g = 0 To Ubound(arrGroupEventApplyIdx, 2)
    applyIdx = arrGroupEventApplyIdx(0, g)
    Call DeleteTeamInfo(db, applyIdx, mode, teamMemberDel, cancelYN)
  Next
End If
' E: 3. 참가신청 취소




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
