<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr

busIdx    = fInject(Request("busIdx"))
memberIdx = fInject(Request("memberIdx"))

If busIdx = "" Or memberIdx = "" Then
  Response.End
End If


SQL =       " SELECT ISNULL(b.BusApplyCount, 0) BusApplyCount, a.BusMemberLimit, a.BusFare, a.TitleIdx "
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
  BusFare        = rs("BusFare")
  TitleIdx       = rs("TitleIdx")
  RemainSeat = Cdbl(BusMemberLimit) - Cdbl(BusApplyCount)

  If RemainSeat = 0 Then
    jsonStr = "{""return"": false, ""message"": ""정원이 가득찼습니다.""}"
    Response.Write jsonStr
    Response.End
  End If
End If

SQL =       " SELECT COUNT(*) FROM tblBikeBusApply a "
SQL = SQL & " LEFT JOIN tblBikeBusList b ON a.BusIdx = b.BusIdx "
SQL = SQL & " WHERE a.MemberIdx = '"& memberIdx &"' AND b.TitleIdx = "& TitleIdx &" AND a.DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  myApply = rs(0)
  If myApply > 0 Then
    jsonStr = "{""return"": false, ""message"": ""버스신청내역있음"" }"
    Response.Write jsonStr
    Response.End
  End If
End If

on error resume next
db.BeginTrans()

SQL =       " SET NOCOUNT ON "
SQL = SQL & " INSERT INTO tblBikeBusApply ( MemberIdx,busIdx ) VALUES ('"& memberIdx &"', "& busIdx &" ) "
SQL = SQL & " SELECT @@IDENTITY "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  busApplyIdx = rs(0)
End if

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
