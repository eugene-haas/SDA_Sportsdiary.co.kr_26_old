<%

'######################
'######################

idx = oJSONoutput.IDX
chk = oJSONoutput.CHK

If chk = "Y" Then
    gubun = 1
ElseIf chk = "N" Then
    gubun = 0
End If

Set db = new clsDBHelper

'group no확인
SQL = " SELECT Top 1 groupno FROM sd_bikeRequest WHERE requestIDX = "&idx&" "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
groupno = rs(0)

'request table 업데이트
updateTable = " sd_bikeRequest "
updatefield = " Paymentstate = '"&chk&"', Paymentdate = getdate() "
'단체일경우 groupno = 0
If groupno = 0 Then
    updateWhere = " RequestIDX = "&idx&" "
ElseIf groupno > 0 Then
    updateWhere = " groupno = "&groupno&" "
End If

SQL = "UPDATE "&updateTable&" SET "&updatefield&" WHERE "&updateWhere&" "
Call db.ExecSQL(SQL , null, ConStr)


'game table 업데이트 (구분값 0:진행중 1:입금완료 2:취소) 구분값이 취소일때는 변경안되도록 수정함
updateTable = " sd_bikeGame "
updateField = " gubun = "&gubun&" "
'개인신청일때
If groupno > 0 Then
updateWhere = " gameidx in (select gameIDX from sd_bikeRequest where groupno = "&groupno&" ) AND gubun in (0,1)"
'단체 신청일때
ElseIf groupno = 0 Then
updateWhere = " requestIDX = "&idx&" AND gubun in (0,1)"
End If

SQL = "UPDATE "&updateTable&" SET "&updatefield&" WHERE "&updateWhere&" "
Call db.ExecSQL(SQL , null, ConStr)

strTable = " sd_bikeRequest a"
strField = " RequestIDX, titleIDX, levelno, gameIDX, subType, PlayerIDX, UserName, PaymentState, PaymentName, Paymentdate, attmoney, Writeday, "
strField = strField & "refundno, refundbnk, refundattdate, refundstate, refundupdate, "
strFieldSub1 = " (select GameTitleName from sd_bikeTitle where titleIDX = a.titleIDX ) as gameTitle,"
strFieldSub2 = " (select detailtitle from sd_bikelevel where titleIDX = a.titleIDX AND levelIDX = a.levelno) as levelnoTitle "
strFieldSub3 = ", ( SELECT COUNT(groupno) from sd_bikeRequest WHERE groupno = a.groupno AND groupno <> 0 ) as requestCount  "
strFieldSub4 = ", ( SELECT CASE Sex WHEN 'Man' THEN '남' WHEN 'WoMan' THEN '여' ELSE Sex END  FROM sd_bikePlayer WHERE PlayerIDX = a.playerIDX ) as sex"
strWhere = " DelYN = 'N' AND requestIDX = "&idx&" "
SQL = "SELECT "&strField&strFieldSub1&strFieldSub2&strFieldSub3&strFieldSub4&" FROM "&strTable&" WHERE "&strWhere&" "
set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	idx = rs("RequestIDX")
    levelTitle = rs("levelnotitle")
    gameTitle = rs("gameTitle")
    subtype = rs("subType")
    UserName = rs("UserName")
    sex = rs("sex")
    Writeday = rs("Writeday")
    requestCount = rs("requestCount")
    PaymentName = rs("PaymentName")
    PaymentState = rs("PaymentState")
    Paymentdate = rs("Paymentdate")
    attmoney = rs("attmoney")
    refundno = rs("refundno")
    refundbnk = rs("refundbnk")
    refundattdate = rs("refundattdate")
    refundstate = rs("refundstate")
    refundupdate = rs("refundupdate")

db.dispose()
set db = nothing

Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

%>
<!-- #include virtual = "/pub/html/bike/findcontestplayer/findgameinfoplayerlist_dev.asp" -->
