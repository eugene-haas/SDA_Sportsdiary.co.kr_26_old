<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr

vAccountNumber = fInject(Request("vAccountNumber"))
depositPrice   = fInject(Request("depositPrice"))
depositName    = fInject(Request("depositName"))
memberIdx      = fInject(Request("memberIdx"))
paymentIdx     = fInject(Request("paymentIdx"))

' vAccountNumber =  "23497381323637"
' depositPrice =  "50000"
' depositName =  "오과장"
' memberIdx =  15942
' paymentIdx =  61

CUST_CD = "BK" & memberIdx
' @TR_SEQ 만들기..
SQL = " SELECT MAX(TR_SEQ) FROM SD_RookieTennis.dbo.TB_RVAS_LIST WHERE TR_DATE = (SELECT CONVERT(VARCHAR(10), GETDATE(), 12)) "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  MAX_TE_SEQ = rs(0)
  TR_SEQ = (TR_SEQ * 1) + 1
  zeroLen = 12 - LEN(TR_SEQ)
  zeroStr = ""
  For z = 1 To zeroLen
    zeroStr = zeroStr & "0"
  Next
  TR_SEQ = zeroStr & TR_SEQ
Else
  TR_SEQ = "000000000001"
End If

' 결제금액 맞는지 확인
SQL = " SELECT PAY_AMT FROM SD_RookieTennis.dbo.TB_RVAS_MAST WHERE VACCT_NO = '"& vAccountNumber &"' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  PAY_AMT = rs(0)
  If CStr(PAY_AMT) <> CStr(depositPrice) Then
    jsonStr = "{""return"": false, ""message"": ""입금 금액이 다름""}"
    Response.Write jsonStr
    Response.End
  End If
End If


' 입금 가능한지 확인
SQL = " SELECT PaymentState, PaymentAccount, TR_DATE, TR_SEQ  FROM tblBikePayment WHERE PaymentIdx = "& paymentIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  PaymentState   = rs("PaymentState")
  PaymentAccount = rs("PaymentAccount")
  pTR_DATE       = rs("TR_DATE")
  pTR_SEQ        = rs("TR_SEQ")
  If PaymentState <> 0 Then
    jsonStr = "{""return"": false, ""message"": ""입금불가능한 결제신청상태"", ""paymentState"": "& paymentState &"}"
    Response.Write jsonStr
    Response.End
  End If

  SQL = " SELECT COUNT(*) FROM SD_RookieTennis.dbo.TB_RVAS_LIST WHERE TR_DATE = '"& pTR_DATE &"' AND TR_SEQ = '"& pTR_SEQ &"' AND VACCT_NO = '"& PaymentAccount &"' "
  If Not rs.eof Then
    depositCount = rs(0)
    If depositCount > 0  Then
      jsonStr = "{""return"": false, ""message"": ""이미 입금완료""}"
      Response.Write jsonStr
      Response.End
    End If
  End If
End If


on error resume next
db.BeginTrans()

SQL =       " DECLARE @TR_DATE char(8) = '20' + (SELECT CONVERT(VARCHAR(10), GETDATE(), 12)) "
SQL = SQL & " DECLARE @TR_SEQ  varchar(12) = '"& TR_SEQ &"' "
SQL = SQL & " DECLARE @BANK_CD varchar(10) = '081' "
SQL = SQL & " DECLARE @ORG_CD varchar(10) = '08137040' "
SQL = SQL & " DECLARE @VACCT_NO varchar(20) = '"& vAccountNumber &"' "
SQL = SQL & " DECLARE @STAT_CD char(1) = 0 "
SQL = SQL & " DECLARE @CUST_CD varchar(20) = '"& CUST_CD &"'  "
SQL = SQL & " DECLARE @TR_TIME char(6) = (SELECT REPLACE(CONVERT(CHAR(8), GETDATE(), 8), ':', '')) "
SQL = SQL & " DECLARE @TR_AMT numeric = "& PAY_AMT &"  "
SQL = SQL & " DECLARE @IN_BANK_CD char(3) = '011'  "
SQL = SQL & " DECLARE @IN_BANK_BRANCH varchar(8) = '' "
SQL = SQL & " DECLARE @IN_NAME varchar(20) = '"& depositName &"' "
SQL = SQL & " DECLARE @ENTRY_DATE varchar(14) = '20' + (SELECT RTRIM(@TR_DATE)+@TR_TIME) "
SQL = SQL & " DECLARE @ENTRY_INDO varchar(20) = 'COOCON'  "
SQL = SQL & " INSERT INTO SD_RookieTennis.dbo.TB_RVAS_LIST_20190422  "
SQL = SQL & " ( TR_DATE,TR_SEQ, BANK_CD, ORG_CD, VACCT_NO, STAT_CD, CUST_CD "
SQL = SQL & " , CUST_NM, TR_TIME, TR_AMT, IN_BANK_CD, IN_BANK_BRANCH, IN_NAME "
SQL = SQL & " , ENTRY_DATE, ENTRY_IDNO, ERP_PROC_YN "
SQL = SQL & " ) "
SQL = SQL & " VALUES  "
SQL = SQL & " ( @TR_DATE, @TR_SEQ, @BANK_CD, @ORG_CD, @VACCT_NO, @STAT_CD, @CUST_CD "
SQL = SQL & " , '별도입금', @TR_TIME, @TR_AMT, @IN_BANK_CD, @IN_BANK_BRANCH "
SQL = SQL & " , @IN_NAME, @ENTRY_DATE , @ENTRY_INDO, 'N') "
Call db.Execute(SQL)



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

<%




%>
