<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

titleIdx  = fInject(Request("titleIdx"))
memberIdx = fInject(Request("memberIdx"))
If titleIdx = "" Then
  Response.End
End If

SQL =       " SELECT a.BusIdx, a.StartLocation, a.StartDate, a.StartTime, a.Destination, ISNULL(b.BusApplyCount, 0), a.BusMemberLimit, a.BusFare "
SQL = SQL & " FROM tblBikeBusList a "
SQL = SQL & " LEFT JOIN ( SELECT BusIdx, COUNT(BusIdx) BusApplyCount "
SQL = SQL & " 			FROM tblBikeBusApply ba "
SQL = SQL & " 			LEFT JOIN tblBikePayment bp ON ba.PaymentIdx = bp.PaymentIdx "
SQL = SQL & " 			WHERE ba.DelYN = 'N' AND bp.PaymentState = 1 "
SQL = SQL & " 			GROUP BY BusIdx ) b ON a.BusIdx = b.BusIdx "
SQL = SQL & " WHERE a.TitleIdx = "& titleIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrBusList = rs.getRows()
End If

jsonStr = "{"
jsonStr = jsonStr & """busList"": "
jsonStr = jsonStr & "["

If IsArray(arrBusList) Then
  For i = 0 To Ubound(arrBusList, 2)

    BusIdx          = arrBusList(0, i)
    StartLocation   = arrBusList(1, i)
    StartDate       = arrBusList(2, i)
    StartTime       = arrBusList(3, i)
    Destination     = arrBusList(4, i)
    BusApplyCount   = arrBusList(5, i)
    BusMemberLimit  = arrBusList(6, i)
    BusFare         = arrBusList(7, i)

    jsonStr = jsonStr & "{"
    jsonStr = jsonStr & """busIdx"": "& BusIdx &", ""startLocation"": """& StartLocation &""", ""startDate"": """& StartDate &""", ""destination"": """& Destination &""" "
    jsonStr = jsonStr & ", ""busApplyCount"": "& BusApplyCount &", ""busMemberLimit"": """& busMemberLimit &""", ""busFare"": """& busFare &""" "
    jsonStr = jsonStr & "}"

    If i < Ubound(arrBusList, 2) Then
      jsonStr = jsonStr & ","
    End If

  Next
End If
jsonStr = jsonStr & "], "

' 버스신청내역 확인
jsonStr = jsonStr & """busApply"": "
jsonStr = jsonStr & "["



If memberIdx <> "" Then
  SQL =       " SELECT a.BusApplyIdx, a.BusIdx, ISNULL(b.PaymentAccount, '') vAccount "
  SQL = SQL & " , ISNULL(CONVERT(VARCHAR(10), b.PaymentIdx), '') PaymentIdx, ISNULL(CONVERT(VARCHAR(10), b.PaymentState), '') PaymentState "
  SQL = SQL & " , ISNULL(c.Price, '') DepositPrice, d.BusFare, ISNULL(e.AccountName, '') rAccountName "
  SQL = SQL & " , ISNULL(e.AccountBank, '') rAccountBank, ISNULL(e.AccountNumber, '') rAccountNumber "
  SQL = SQL & " FROM tblBikeBusApply a "
  SQL = SQL & " LEFT JOIN tblBikePayment b ON a.PaymentIdx = b.PaymentIdx "
  SQL = SQL & " LEFT JOIN tblBikePaymentHistory c ON b.PaymentIdx = c.PaymentIdx "
  SQL = SQL & " LEFT JOIN tblBikeBusList d ON a.BusIdx = d.BusIdx "
  SQL = SQL & " LEFT JOIN tblBikeRefund e ON b.PaymentIdx = e.PaymentIdx "
  SQL = SQL & " WHERE a.MemberIdx = '"& memberIdx &"' AND a.DelYN = 'N' AND d.TitleIdx = "& titleIdx &" "

  Set rs = db.Execute(SQL)

  If Not rs.eof Then
    BusApplyIdx    = rs("BusApplyIdx")
    BusIdx         = rs("BusIdx")
    VAccount       = rs("vAccount")
    VAccountBank   = "하나은행"
    PaymentIdx     = rs("PaymentIdx")
    PaymentState   = rs("PaymentState")
    PaymentStateText = ""
    If PaymentState <> "" Then
      Select Case PaymentState
        Case 0 PaymentStateText = "입금대기"
        Case 1 PaymentStateText = "입금완료"
        Case 2 PaymentStateText = "취소됨"
        Case 3 PaymentStateText = "환불중"
        Case 4 PaymentStateText = "환불완료"
      End Select
    End If
    DepositPrice   = rs("DepositPrice")
    BusFare        = rs("BusFare")
    rAccountName   = rs("rAccountName")
    rAccountBank   = rs("rAccountBank")
    rAccountNumber = rs("rAccountNumber")
    jsonStr = jsonStr & "{"
    jsonStr = jsonStr & "  ""busIdx"": "& BusIdx &", ""busApplyIdx"": "& BusApplyIdx &", ""vAccount"": """& VAccount &""", ""vAccountBank"": """& VAccountBank &""" "
    jsonStr = jsonStr & ", ""paymentIdx"": """& PaymentIdx &""", ""paymentState"": """& PaymentState &""", ""paymentStateText"": """& PaymentStateText &""" "
    jsonStr = jsonStr & ", ""depositPrice"": """& DepositPrice &""", ""busFare"": """& BusFare &"""  "
    jsonStr = jsonStr & ", ""rAccountName"": """& rAccountName &""", ""rAccountBank"": """& rAccountBank &""", ""rAccountNumber"": """& rAccountNumber &""" "
    jsonStr = jsonStr & "}"

  End If
End If
jsonStr = jsonStr & "]"

jsonStr = jsonStr & "}"

Response.Write jsonStr
Response.End
%>
