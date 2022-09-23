<%
'request
	If hasown(oJSONoutput, "OIDX") = "ok" then
		oidx = oJSONoutput.Get("OIDX")
	End if	
	If hasown(oJSONoutput, "PAYTYPE") = "ok" then
		paytype = oJSONoutput.Get("PAYTYPE")
	End If

	If hasown(oJSONoutput, "RNM") = "ok" then
		rnm = oJSONoutput.Get("RNM")
	End If
	If hasown(oJSONoutput, "RBNK") = "ok" then
		rbnk = oJSONoutput.Get("RBNK")
	End If
	If hasown(oJSONoutput, "RNO") = "ok" then
		rno = oJSONoutput.Get("RNO")
	End If
'request


	Set db = new clsDBHelper


		'결제정보체크
		SQL_Order = "Select Oorderstate,gametitleidx,team,order_MOID From tblSwwimingOrderTable "
		SQL_Order = SQL_Order & " Where del_yn = 'N'  and  orderidx = '"&oidx&"'  " 
		Set rs = db.ExecSQLReturnRS(SQL_Order , null, ConStr)

		If Not rs.eof Then
			orderstate = rs(0)
			tidx = rs(1)
			tcode = rs(2)
			ordermoid = rs(3)
		End if

		'처리 88 취소요청중
		SQL = "Update tblSwwimingOrderTable set Oorderstate = '88',refundNM='"&rnm&"',refundBnk='"&rbnk&"',RefundCC= '"&rno&"' ,refunddate=getdate()   where orderidx = '"&oidx&"' " 
		Call db.execSQLRs(SQL , null, ConStr)

		payOK = "N"
		delYN = "Y"



		'delete from tblGameRequest_r  where requestidx in (select requestidx from tblGameRequest where GameTitleIDX = 129 )
		'delete from tblGameRequest where GameTitleIDX = 129 and gbidx in (41696,41702)
		'
		'delete from sd_gameMember where GameTitleIDX = 129 and gbidx in (41696,41702)
		'
		'delete from tblGameRequest_imsi_r where seq in (select seq from tblGameRequest_imsi where tidx = 129)
		'delete from tblGameRequest_imsi where tidx = 129


		If orderstate = "01" then

			'결제확인 업데이트및 가상계좌사용  delYN  복구 #####################################################
			SQL = "update  tblGameRequest set  payOK = '"&payOK&"', delyn = '"&delYN&"' where Order_MOID = '"&ordermoid&"' "
			Call db.execSQLRs(SQL , null, ConStr)

			SQL = "update  tblGameRequest_r set  payOK = '"&payOK&"', delyn = '"&delYN&"' where Order_MOID = '"&ordermoid&"' "
			Call db.execSQLRs(SQL , null, ConStr)

			SQL = "update sd_gameMember set delyn = 'Y' where GameTitleIDX = "&tidx&"  and team = '"&tcode&"' "
			Call db.execSQLRs(SQL , null, ConStr)


			'선수 설정해둔건 살려둔다.  음 지우지 말자
			'SQL = "update tblGameRequest_imsi_r set delyn = 'Y' where seq in (select seq from tblGameRequest_imsi  where delyn = 'N' and tidx = '" & tidx & "' and team = '"&tcode&"' )"
			'Call db.execSQLRs(SQL , null, ConStr)
			SQL = "update tblGameRequest_imsi Set payOk = '"&payOK&"' where delyn = 'N' and tidx = '" & tidx & "' and team = '"&tcode&"' " '한사람당 결제니까 여기만 
			Call db.execSQLRs(SQL , null, ConStr)

'Response.write sql
'Response.end

			'가상계좌로그
			rvalue = oidx & "," & "결제취소요청"
			SQL = "insert into tblVACCLOG (rvalue) values ('"&rvalue&"')"
			Call db.execSQLRs(SQL , null, ConStr)

		End if

	
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>

