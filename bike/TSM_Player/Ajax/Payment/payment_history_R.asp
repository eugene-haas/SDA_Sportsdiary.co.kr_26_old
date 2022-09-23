<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

titleIdx = fInject(Request("titleIdx"))
memberIdx = fInject(Request("memberIdx"))
paymentIdx = fInject(Request("paymentIdx"))
If titleIdx = "" Or memberIdx = "" Then
  Response.End
End If

jsonStr = "{"
jsonStr = jsonStr & """paymentList"": "
jsonStr = jsonStr & "["


' 결제목록
SQL =       " SELECT a.PaymentIdx, a.PaymentAccount, ISNULL(b.TR_AMT, 0) depositPrice, a.PaymentState FROM tblBikePayment a  "
SQL = SQL & " LEFT JOIN "& V_ACCOUNT_LIST &" b ON a.TR_DATE = b.TR_DATE AND a.TR_SEQ = b.TR_SEQ AND a.PaymentAccount = b.VACCT_NO "
SQL = SQL & " WHERE MemberIdx = "& memberIdx &" AND TitleIdx = "& titleIdx &" "
If paymentIdx <> "" Then
  SQL = SQL & " AND a.PaymentIdx = "& paymentIdx &" "
Else
  SQL = SQL & " AND a.PaymentFor = 'event' "
End If
SQL = SQL & " ORDER BY a.WriteDate DESC "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrPayment = rs.getRows()
End If


If IsArray(arrPayment) Then
  For p = 0 To Ubound(arrPayment, 2)
    paymentIdx       = arrPayment(0, p)
    paymentAccount   = arrPayment(1, p)
    depositPrice     = arrPayment(2, p) ' 실제입금 금액
    PaymentState     = arrPayment(3, p)
    PaymentStateText = ""
    Select Case PaymentState
      Case 0 PaymentStateText = "입금대기"
      Case 1 PaymentStateText = "입금완료"
      Case 2 PaymentStateText = "취소됨"
      Case 3 PaymentStateText = "환불중"
      Case 4 PaymentStateText = "환불완료"
    End Select

    accountHolder  = "위드라인"
    bank           = "하나은행"

    jsonStr = jsonStr & "{"
    jsonStr = jsonStr & " ""paymentIdx"": "& PaymentIdx &", ""accountHolder"":"""& accountHolder &""", ""bank"": """& bank &""" "
    jsonStr = jsonStr & ", ""account"": """& paymentAccount &""", ""depositPrice"": """& depositPrice &""", ""paymentState"": "& PaymentState &", ""paymentStateText"": """& PaymentStateText &""" "


    SQL =       " SELECT a.PaymentIdx, a.Price, b.EventDetailType, b.CourseLength, b.Gender, b.GroupType "
    SQL = SQL & " FROM tblBikePaymentHistory a "
    SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
    SQL = SQL & " LEFT JOIN tblBikePayment c ON a.PaymentIdx = c.PaymentIdx "
    SQL = SQL & " WHERE a.PaymentIdx = "& paymentIdx &" "
    SQL = SQL & " AND b.GroupType = '개인' "

    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      arrPaymentDetailSolo = rs.getRows()
    End If

    SQL =       " SELECT a.PaymentIdx, a.Price, b.EventDetailType, b.CourseLength, b.Gender, b.GroupType, b.MinPlayer, b.MaxPlayer "
    SQL = SQL & " FROM tblBikePaymentHistory a "
    SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
    SQL = SQL & " LEFT JOIN tblBikePayment c ON a.PaymentIdx = c.PaymentIdx "
    SQL = SQL & " WHERE a.PaymentIdx = "& paymentIdx &" "
    SQL = SQL & " AND b.GroupType = '단체' "

    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      arrPaymentDetailGroup = rs.getRows()
    End If

    SQL =       " SELECT Price "
    SQL = SQL & " FROM tblBikePaymentHistory "
    SQL = SQL & " WHERE PaymentIdx = "& paymentIdx &" "
    SQL = SQL & " AND CONVERT(Money, Price) < 0 "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      discountPrice = rs(0)
    Else
      discountPrice = 0
    End If

    SQL = " SELECT SUM(CONVERT(Money, Price)) FROM tblBikePaymentHistory WHERE PaymentIdx = "& paymentIdx &" GROUP BY PaymentIdx "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      totalPrice = rs(0)
    End If


    ' S: 개인종목 종목,가격 정보
    jsonStr = jsonStr & ", ""soloEvent"": ["
    If IsArray(arrPaymentDetailSolo) Then
      For s = 0 To Ubound(arrPaymentDetailSolo, 2)
        PaymentIdx       = arrPaymentDetailSolo(0, s)
        Price            = arrPaymentDetailSolo(1, s)
        EventDetailType  = arrPaymentDetailSolo(2, s)
        CourseLength     = arrPaymentDetailSolo(3, s)
        Gender           = arrPaymentDetailSolo(4, s)
        GroupType        = arrPaymentDetailSolo(5, s)
        jsonStr = jsonStr & " {""gender"": """& Gender &""", ""name"": """& EventDetailType &""" "
        jsonStr = jsonStr & " , ""courseLength"": """& courseLength &""", ""groupType"": """& GroupType &""", ""price"": """& Cdbl(Price) &"""} "

        If s < Ubound(arrPaymentDetailSolo, 2) Then
          jsonStr = jsonStr & ","
        End If
      Next
    End If
    jsonStr = jsonStr & "],"
    ' E: 개인종목 종목,가격 정보

    ' S: 단체종목 종목,가격 정보
    jsonStr = jsonStr & " ""groupEvent"": ["
    If IsArray(arrPaymentDetailGroup) Then
      For g = 0 To Ubound(arrPaymentDetailGroup, 2)
        PaymentIdx       = arrPaymentDetailGroup(0, g)
        Price            = arrPaymentDetailGroup(1, g)
        EventDetailType  = arrPaymentDetailGroup(2, g)
        CourseLength     = arrPaymentDetailGroup(3, g)
        Gender           = arrPaymentDetailGroup(4, g)
        GroupType        = arrPaymentDetailGroup(5, g)
        MinPlayer        = arrPaymentDetailGroup(6, g)
        MaxPlayer        = arrPaymentDetailGroup(7, g)
        jsonStr = jsonStr & " {""gender"": """& Gender &""", ""name"": """& EventDetailType &""", ""minPlayer"": "& Minplayer &", ""maxPlayer"": "& maxPlayer &" "
        jsonStr = jsonStr & " , ""courseLength"": """& courseLength &""", ""groupType"": """& GroupType &""", ""price"": """& Cdbl(Price) &""" } "

        If g < Ubound(arrPaymentDetailGroup, 2) Then
          jsonStr = jsonStr & ","
        End If
      Next
    End If
    jsonStr = jsonStr & "],"
    ' E: 단체종목 종목,가격 정보

    ' 할인금액
    jsonStr = jsonStr & " ""soloEventDiscount"": """& discountPrice &""", "
    ' 최종금액(결제해야하는)
    jsonStr = jsonStr & " ""totalPrice"": """& totalPrice &""" "

    jsonStr = jsonStr & "}"
    If p < Ubound(arrPayment, 2) Then
      jsonStr = jsonStr & ","
    End If

    arrPaymentDetailSolo = ""
    arrPaymentDetailGroup = ""
  Next
End If

jsonStr = jsonStr & "]"
jsonStr = jsonStr & "}"

Response.Write jsonStr
Response.End
%>
