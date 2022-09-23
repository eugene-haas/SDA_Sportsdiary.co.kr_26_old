<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr

busApplyIdx = fInject(Request("busApplyIdx"))
memberIdx   = fInject(Request("memberIdx"))
paymentIdx  = fInject(Request("paymentIdx"))

If busApplyIdx = "" Or memberIdx = "" Then
  Response.End
End If



SQL = " SELECT busIdx FROM tblBikeBusApply WHERE MemberIdx = '"& memberIdx &"' AND BusApplyIdx = "& busApplyIdx &" AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If rs.eof Then
  jsonStr = "{""return"": false, ""message"": ""취소할 버스내역 없음""}"
  Response.Write jsonStr
  Response.End
End If

on error resume next
db.BeginTrans()

' 가상계좌 발급내역 있으면 결제취소상태로 업데이트
If paymentIdx <> "" Then
  ' 입금완료 여부 확인후 취소인지 환불인지 cancelState 담기
  SQL = " SELECT PaymentState FROM tblBikePayment WHERE PaymentIdx = "& paymentIdx &" "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    paymentState = rs(0)
    If paymentState = 0 Then
      cancelState = 2
    ElseIf paymentState = 1 Then
      cancelState = 3
    ElseIf paymentState = 3 Then
      cancelState = 3
    End If
  End If


  ' S:결제취소
  SQL = " UPDATE tblBikePayment Set PaymentState = "& cancelState &" WHERE PaymentIdx = "& paymentIdx &"  "
  Call db.Execute(SQL)
  ' E:결제취소


End If

SQL = " UPDATE tblBikeBusApply Set DelYN = 'Y', CancelDate = GETDATE() WHERE busApplyIdx = "& busApplyIdx &" "
Call db.Execute(SQL)


If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  jsonStr = "{""return"": true, ""busApplyIdx"": "& busApplyIdx &"}"
End If

db.dispose()
Set db = nothing
Set rs = nothing

Response.Write jsonStr
Response.End
%>
