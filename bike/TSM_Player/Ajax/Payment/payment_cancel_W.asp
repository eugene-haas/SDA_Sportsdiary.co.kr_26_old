<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, paymentIdx, memberIdx

paymentIdx = fInject(Request("paymentIdx"))
memberIdx  = fInject(Request("memberIdx"))
mode       = "all"
CancelYN   = "Y"

If paymentIdx = "" Or memberIdx = "" Then
  Response.End
End If


on error resume next
db.BeginTrans()

' 입금완료 여부 확인후 취소인지 환불인지 cancelState 담기
SQL = " SELECT PaymentState FROM tblBikePayment WHERE PaymentIdx = "& paymentIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  paymentState = rs(0)
  If paymentState = 0 Then
    cancelState = 2
  ElseIf paymentState = 1 Then
    cancelState = 3
  End If
End If

' S:결제취소
SQL = " UPDATE tblBikePayment Set PaymentState = "& cancelState &" WHERE PaymentIdx = "& paymentIdx &"  "
Call db.Execute(SQL)
' E:결제취소


' S: 신청취소
' 결제내역에 있는 event 리스트를 가져온다.
SQL = " SELECT EventIdx FROM tblBikePaymentHistory WHERE PaymentIdx = "& paymentIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrEventIdx = rs.getRows()
  eventIdxList = ""
  If IsArray(arrEventIdx) Then
    For i = 0 To Ubound(arrEventIdx, 2)
      eventIdx = arrEventIdx(0, i)
      eventIdxList = eventIdxList & eventIdx

      If i < Ubound(arrEventIdx, 2) Then
        eventIdxList = eventIdxList & ","
      End If
    Next
  End If
End if

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
