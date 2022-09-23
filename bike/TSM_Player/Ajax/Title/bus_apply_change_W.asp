<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr

busIdx      = fInject(Request("busIdx"))
busApplyIdx = fInject(Request("busApplyIdx"))
memberIdx   = fInject(Request("memberIdx"))


If busIdx = "" Or busApplyIdx = "" Or memberIdx = "" Then
  Response.End
End If


SQL = " SELECT busIdx FROM tblBikeBusApply WHERE MemberIdx = '"& memberIdx &"' AND BusApplyIdx = "& busApplyIdx &" AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If rs.eof Then
  jsonStr = "{""return"": false, ""message"": ""버스신청정보 불일치""}"
  Response.Write jsonStr
  Response.End
End If

' 바꾸려는 버스에 자리가 있는지 확인
SQL =       " SELECT ISNULL(b.BusApplyCount, 0) BusApplyCount, a.BusMemberLimit "
SQL = SQL & " FROM tblBikeBusList a "
SQL = SQL & " LEFT JOIN ( SELECT BusIdx, COUNT(BusIdx) BusApplyCount "
SQL = SQL & " 			FROM tblBikeBusApply ba "
SQL = SQL & " 			LEFT JOIN tblBikePayment bp ON ba.PaymentIdx = bp.PaymentIdx "
SQL = SQL & " 			WHERE ba.DelYN = 'N' AND bp.PaymentState = 1 "
SQL = SQL & " 			GROUP BY BusIdx ) b ON a.BusIdx = b.BusIdx "
SQL = SQL & " WHERE a.BusIdx = "& busIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  BusApplyCount  = rs("BusApplyCount")
  BusMemberLimit = rs("BusMemberLimit")
  RemainSeat = Cdbl(BusMemberLimit) - Cdbl(BusApplyCount)

  If RemainSeat = 0 Then
    jsonStr = "{""return"": false, ""message"": ""정원이 가득찼습니다.""}"
    Response.Write jsonStr
    Response.End
  End If
End If


on error resume next
db.BeginTrans()

SQL = " UPDATE tblBikeBusApply Set BusIdx = "& busIdx &" WHERE busApplyIdx = "& busApplyIdx &" "
Call db.Execute(SQL)

If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  jsonStr = "{""return"": true, ""busApplyIdx"": "& busApplyIdx &", ""busIdx"": "& busIdx &"}"
End If

db.dispose()
Set db = nothing
Set rs = nothing

Response.Write jsonStr
Response.End
%>
