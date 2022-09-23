<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, memberIdx, titleIdx, eventIdx

titleIdx         = fInject(Request("titleIdx"))
memberIdx        = fInject(Request("memberIdx"))
payKind          = fInject(Request("payKind")) '결제대상 참가신청/ 버스
eventIdx         = fInject(Request("eventIdx"))
busApplyIdx      = fInject(Request("busApplyIdx"))
'
' titleIdx=3
' memberIdx=15942
' payKind="event"
' eventIdx = "83,84,94,95"
' response.write 1 & chr(10)
' response.write err.number & chr(10)
' response.end

If titleIdx = "" Or memberIdx = "" Or payKind = "" Then
  Response.End
End If

If payKind = "event" Then
  If eventIdx = "" Then
    Response.End
  End If
ElseIf payKind = "bus" Then
  If busApplyIdx = "" Then
    Response.End
  End If
End If

' 회원정보 가져오기
SQL = " SELECT UserName, UserPhone FROM SD_MEMBER.dbo.tblMember WHERE MemberIdx = '"& memberIdx &"' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  userName = rs("UserName")
  userPhone = rs("UserPhone")
End If

' 결제신청 할 수 있는 종목이 있는지 확인
If payKind = "event" Then
  SQL = " SELECT COUNT(*) FROM tblBikeEventApplyInfo WHERE DelYN = 'N' And PaymentIdx = 0 AND MemberIdx = '"& memberIdx &"' AND EventIdx IN ("& eventidx &")  "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    applyCount = rs(0)
    If applyCount = 0 Then
      jsonStr = "{""return"": false}"
      Response.Write jsonStr
      Response.End
    End If
  End If

  ' 팀장확인
  SQL = " SELECT EventIdx FROM tblBikeEventList WHERE EventIdx IN ("& eventIdx &") AND GroupType = '단체' "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    arrGroupEvent = rs.GetRows()
    If IsArray(arrGroupEvent) Then
      For i = 0 To Ubound(arrGroupEvent, 2)
        gEventIdx = arrGroupEvent(0, i)
        SQL = " SELECT COUNT(*) FROM tblBikeTeam WHERE EventIdx = '"& gEventIdx &"' AND LeaderIdx = '"& memberIdx &"' AND DelYN = 'N' "
        Set rs = db.Execute(SQL)
        If Not rs.eof Then
          isLeader = rs(0)
          If Cdbl(isLeader) = 0 Then
            eventIdx = Replace(eventIdx, gEventIdx, 0)
          End If
        End If
      Next
    End If
  End If

' 버스결제 내역있는지 확인
ElseIf payKind = "bus" Then
  SQL =       " SELECT COUNT(*) FROM tblBikePayment WHERE MemberIdx = '"& memberIdx &"' "
  SQL = SQL & " AND TitleIdx = "& titleIdx &" AND (PaymentState = 0 OR PaymentState = 1) AND PaymentFor = '"& payKind &"' "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    busApplyCount = rs(0)
    If busApplyCount > 0 Then
      jsonStr = "{""return"": false}"
      Response.Write jsonStr
      Response.End
    End If
  End If
End If

on error resume next
db.BeginTrans()

' 금액계산
If payKind = "event" Then
  depositPrice = SQLGetTotalFee(db, memberIdx, eventIdx)
ElseIf payKind = "bus" Then
  SQL = " SELECT BusIdx FROM tblBikeBusApply WHERE BusApplyIdx = "& busApplyIdx &" AND DelYN = 'N' "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    busIdx = rs(0)
    SQL = " SELECT BusFare FROM tblBikeBusList WHERE BusIdx = "& busIdx &" "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      busFare = rs(0)
      depositPrice = busFare
    End If
  End If
End If

' response.write 2 & chr(10)
' response.write err.number & chr(10)

' 자전거용 회원번호
CUST_CD = "BK" & memberIdx
' 계좌신청 시간
If LEN(DatePart("s", TIME)) = 1 Then
  inputSecond = "0" & DatePart("s", TIME)
Else
  inputSecond = DatePart("s", TIME)
End If
inPutTime = Replace(DATE, "-", "") & DatePart("h", TIME) & DatePart("n", TIME) & inputSecond
' 빈계좌 가져오기
SQL = " SELECT TOP 1 VACCT_NO FROM "& V_ACCOUNT_MAST &" WHERE CUST_CD IS NULL AND STAT_CD = 1 AND ENTRY_IDNO IS NULL "
Set rs = db.Execute(SQL)

If Not rs.eof Then
  VACCT_NO = rs(0)
  If VACCT_NO <> "" Then
    ' 1.가상계좌 마스터테이블에 결제정보 넣어준다
    SQL =       " UPDATE "& V_ACCOUNT_MAST &" "
    SQL = SQL & " SET IN_GB = 2, PAY_AMT = '"& depositPrice &"', CUST_CD = '"& CUST_CD &"', CUST_NM = '위드라인'  "
    SQL = SQL & " , ENTRY_DATE = '"& inPutTime &"', USER_NM = '"& userName &"', SITECODE = '"& SITECODE &"' "
    SQL = SQL & " WHERE VACCT_NO = '"& VACCT_NO &"' AND CUST_CD IS NULL "
    Call db.Execute(SQL)

    ' response.write 3 & chr(10)
    ' response.write err.number & chr(10)

    ' 2.bikePayment 테이블에 결제정보 insert
    SQL =       " SET NOCOUNT ON "
    SQL = SQL & " INSERT INTO tblBikePayment (MemberIdx, TitleIdx, PaymentFor, PaymentAccount) "
    SQL = SQL & " VALUES ('"& memberIdx &"', "& titleIdx &", '"& payKind &"', '"& VACCT_NO &"') "
    SQL = SQL & " SELECT @@IDENTITY "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      paymentIdx = rs(0)

      ' 3. 참가신청/ 버스 가상계좌구분
      ' 3-1 참가신청
      If payKind = "event" Then
        ' 3-1-1. paymentIdx 를 대회참가정보 테이블에 업데이트
        SQL =       " UPDATE tblBikeEventApplyInfo SET PaymentIdx = "& paymentIdx &" WHERE EventApplyIdx IN ( "
        SQL = SQL & " SELECT EventApplyIdx FROM tblBikeEventApplyInfo a "
        SQL = SQL & " WHERE MemberIdx = '"& memberIdx &"' AND DelYN = 'N' AND TeamIdx = 0 AND EventIdx IN ("& eventIdx &") "
        SQL = SQL & " UNION ALL "
        SQL = SQL & " SELECT EventApplyIdx FROM tblBikeEventApplyInfo WHERE DelYN = 'N' AND TeamIdx IN "
        SQL = SQL & " (SELECT TeamIdx FROM tblBikeEventApplyInfo WHERE MemberIdx = '"& memberIdx &"' AND EventIdx IN ("& eventIdx &") AND DelYN = 'N' AND TeamIdx <> 0 GROUP BY TeamIdx) "
        SQL = SQL & " ) "
        Call db.Execute(SQL)

        ' 3-1-2. 결제기록을 PaymentHistory 테이블에 넣기
        SQL =       " INSERT INTO tblBikePaymenthistory (EventIdx, PaymentIdx, Price) "
        SQL = SQL & " SELECT a.EventIdx, a.PaymentIdx, SUM(CONVERT(INT, b.EntryFee)) Price FROM tblBikeEventApplyInfo a "
        SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
        SQL = SQL & " WHERE PaymentIdx = "& paymentIdx &" "
        SQL = SQL & " GROUP BY a.EventIdx, a.PaymentIdx "
        Call db.Execute(SQL)

        ' response.write 4 & chr(10)
        ' response.write err.number & chr(10)

        ' 3-1-3. 개인종목 신청갯수 찾아서 개인종목 할인 추가
        SQL =       " SELECT COUNT(*) FROM tblBikeEventApplyInfo a "
        SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
        SQL = SQL & " WHERE a.PaymentIdx = "& paymentIdx &" AND a.EventIdx IN ("& eventIdx &") AND b.GroupType = '개인' "
        Set rs = db.Execute(SQL)
        If Not rs.eof Then
          Set discount = rs(0)
          If discount > 0 Then
            discountPrice = -10000 * (Cdbl(discount) - 1)
          Else
            discountPrice = 0
          End If

          SQL =       " INSERT INTO tblBikePaymenthistory (EventIdx, PaymentIdx, Price, Memo) "
          SQL = SQL & " VALUES (0, "& paymentIdx &", '"& discountPrice &"', '개인종목동시참가할인') "
          Call db.Execute(SQL)
        End If
      ' 3-2 버스신청
      ElseIf payKind = "bus" Then
        SQL = " UPDATE tblBikeBusApply SET PaymentIdx = "& PaymentIdx &" WHERE BusApplyIdx = "& busApplyIdx &" "
        Call db.Execute(SQL)

        SQL = " INSERT INTO tblBikePaymenthistory (PaymentIdx, Price, Memo) VALUES ("& paymentIdx &", '"& depositPrice &"', '버스신청')"
        Call db.Execute(SQL)
      End If
    End If

    ' response.write 5 & chr(10)
    ' response.write err.number & chr(10)

    ' 4. 문자보내기
    SQL = " SELECT TitleName FROM tblBikeTitle WHERE TitleIdx = "& titleIdx &" "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      titleName = rs("TitleName")
    End If
    phoneNum = Replace(userPhone, "-", "")

    If payKind = "event" Then
      title = "참가신청 가상계좌발급"
      content = GetPayTextContent(titleName, userName, VACCT_NO, depositPrice)
    ElseIf payKind = "bus" Then
      SQL =       " SELECT StartLocation FROM tblBikeBusApply a "
      SQL = SQL & " LEFT JOIN tblBikeBusList b ON a.BusIdx = b.BusIdx "
      SQL = SQL & " WHERE a.BusApplyIdx = "& busApplyIdx &" "
      Set rs = db.Execute(SQL)
      If Not rs.eof Then
        busStartLocation = rs("StartLocation")
      End If

      title = "버스신청 가상계좌발급"
      content = GetBusTextContent(titleName, busStartLocation, VACCT_NO, userName)
    End If

    Call SendText(db, phoneNum, title, content)

    ' response.write 6 & chr(10)
    ' response.write err.number & chr(10)
  End If
Else
  jsonStr = "{""return"": false, ""message"": ""빈계좌 없음""}"
End If

If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  jsonStr = "{""return"": true, ""vAccount"": """& VACCT_NO &""", ""depositPrice"": """& depositPrice &"""}"
End If


db.dispose()
Set db = nothing
Set rs = nothing

Response.Write jsonStr
Response.End
%>
