<!-- #include virtual = "/pub/header.bike.asp" -->
<%
Set ajaxDb = new clsDBHelper
Dim req, refundIdx, paymentIdx, openState, changeState
req = fInject(request("req"))

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  refundIdx   = oJSONoutput.refundIdx
  paymentIdx  = oJSONoutput.paymentIdx
  openState   = oJSONoutput.openState

  If openState = "N" Then
    changeState = "Y"
    changePayState = 4
  Else
    changeState = "N"
    changePayState = 3
  End If
End If


SQL = " UPDATE tblBikePayment Set PaymentState = "& changePayState &" WHERE PaymentIdx = "& paymentIdx &"  "
Call ajaxDb.ExecSQLRs(SQL, Null, B_ConStr)

SQL = " UPDATE tblBikeRefund Set RefundYN = '"& changeState &"', RefundDate = GETDATE() WHERE RefundIdx = "& refundIdx &"  "
Call ajaxDb.ExecSQLRs(SQL, Null, B_ConStr)



oJSONoutput.Set("changeState"), changeState
strjson = JSON.Stringify(oJSONoutput)
response.write strjson
response.end

ajaxDb.dispose()
Set ajaxDb = nothing
Set oJSONoutput = nothing
%>
