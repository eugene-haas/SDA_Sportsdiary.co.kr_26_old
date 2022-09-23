<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<% 
	'1. 가상계좌이고 입금대기 중이라면
	'2. 취소하시겠습니까 (결제정보삭제, 	'tblgamereuqest  정보  delete _r  도삭제 다시돌아오기)
	'3. 결제가 완료된것이라면


	oidx = oJSONoutput.Get("oidx")
	otid = oJSONoutput.Get("otid")

	Set db = new clsDBHelper


	'가상계좌 대기상태에서 지울경우 그냥삭제하는게 좋지 않을까

		'결제정보체크
		SQL_Order = "Select Oorderstate,gametitleidx,team,order_MOID,leaderidx From tblSwwimingOrderTable "
		SQL_Order = SQL_Order & " Where del_yn = 'N'  and  orderidx = '"&oidx&"'  " 
		Set rs = db.ExecSQLReturnRS(SQL_Order , null, ConStr)

		If Not rs.eof Then
			orderstate = rs(0)
			tidx = rs(1)
			tcode = rs(2)
			ordermoid = rs(3)
			leaderidx = rs(4)
		End if

		If orderstate = "00" Then '가상계좌 대기상태라면

			'결제확인 업데이트및 가상계좌사용  delYN  복구 #####################################################
			SQL = "update  tblGameRequest set  delyn = 'Y' where Order_MOID = '"&ordermoid&"' "
			Call db.execSQLRs(SQL , null, ConStr)

			SQL = "update  tblGameRequest_r set  delyn = 'Y'  where Order_MOID = '"&ordermoid&"' "
			Call db.execSQLRs(SQL , null, ConStr)

			'등록코치의 선수들 (palyeridx를 찾아서 조건에 넣자)

			
			SQL = "update sd_gameMember set delyn = 'Y' where GameTitleIDX = "&tidx&"  and team = '"&tcode&"'  and requestidx in (select requestidx from tblGameRequest where Order_MOID = '"&ordermoid&"' ) "
			Call db.execSQLRs(SQL , null, ConStr)

			'선수 설정해둔건 살려둔다.  음 지우지 말자
			'SQL = "update tblGameRequest_imsi_r set delyn = 'Y' where seq in (select seq from tblGameRequest_imsi  where delyn = 'N' and tidx = '" & tidx & "' and team = '"&tcode&"' )"
			'Call db.execSQLRs(SQL , null, ConStr)

			SQL = "update tblGameRequest_imsi Set payOk = 'N' where delyn = 'N' and tidx = '" & tidx & "' and team = '"&tcode&"'  and leaderidx = '"&leaderidx&"'  " '한사람당 결제니까 여기만 
			Call db.execSQLRs(SQL , null, ConStr)

		
			'처리
			SQL = "Update tblSwwimingOrderTable set del_yn = 'Y' ,refunddate=getdate()   where orderidx = '"&oidx&"' " 
			Call db.execSQLRs(SQL , null, ConStr)

		End if



	Set rs = Nothing
	db.Dispose
	Set db = Nothing
	 
	Response.redirect "apply-parti.asp"
%> 