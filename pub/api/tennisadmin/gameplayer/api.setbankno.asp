<%
'#############################################

'#############################################
	'request
	ridx = oJSONoutput.Get("RIDX")
	tidx = oJSONoutput.Get("TIDX")
	levelno = oJSONoutput.Get("LNO")

	Set db = new clsDBHelper


	SQL = "Select top 1 fee,fund,teamgbnm  from tblRGameLevel  where GameTitleIDX = " & tidx & " and level = '"&levelno&"' and  DelYN = 'N'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	

	fee = rs("fee")
	fund = rs("fund")
	acctotal = CDbl(fee) + CDbl(fund)
	teamgbnm = rs("teamgbnm")

	
	SQL = "select paymentnm,p1_username,p2_username,userphone from tblGameRequest where requestidx = " & ridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
	attname = rs(0) '참가신청자 정보
	p1nm = rs(1)
	p2nm = rs(2)
	p1phone = rs(3)


	'#############################
		Function ConvertDateFormat(ByVal strDate)
			Dim tmpDate1, tmpDate2
			Dim returnDate
			tmpDate1 = Split(strDate, " ")
			tmpDate2 = Split(tmpDate1(2), ":")
			
			'오후라면 12시간을 더해준다
			If tmpDate1(1) = "오후" Then 
				'오후 12시는 정오를 가르키기 때문에 제외
				If CDbl(tmpDate2(0)) < 12 Then 
					tmpDate2(0) = CDbl(tmpDate2(0)) + 12
				End If 
			End If 
			
			returnDate = Replace(tmpDate1(0),"-","") & CheckFormat(tmpDate2(0),2) & CheckFormat(tmpDate2(1),2) & CheckFormat(tmpDate2(2),2)
			ConvertDateFormat = returnDate
		End Function 

		'자릿수를 맞추기 위한 함수
		Function CheckFormat(ByVal num, ByVal splitpos)
			Dim tmpNum : tmpNum = 10000000
			tmpNum = tmpNum + CDbl(num)
			CheckFormat = Right(tmpNum, splitpos)
		End Function 
	'#############################


	SQL = "select top 1 CUST_CD from TB_RVAS_MAST where CUST_CD = '" & ridx & "' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof then
		vcwhere = " VACCT_NO =  (Select top 1 VACCT_NO from TB_RVAS_MAST where CUST_CD is null  and USER_NM is null) " '이름과 ridx 가 널인값만  현장입금 처리때문에
		SQL = "Update TB_RVAS_MAST Set STAT_CD = '1' ,IN_GB = '2', PAY_AMT = " & acctotal & ", CUST_CD = '" & ridx & "' ,CUST_NM = '한국테니스진흥협회' ,USER_NM = '" & attname & "',ENTRY_DATE= '" & ConvertDateFormat(Now()) & "' where " & vcwhere
		
		Call db.execSQLRs(SQL , null, ConStr)

	
			'==========================================
			'문자전송
				SQL = "select gametitlename from sd_tennistitle where gametitleidx = " & tidx
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			    gametitlename = rs(0)

				SQL = "select top 1 VACCT_NO from TB_RVAS_MAST where CUST_CD = '" & ridx & "' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			    vacctno = rs(0)


				SMS_Subject = "["&gametitlename&"]입금대기전환안내"

				If sitecode = "" Then
					'sitecode = "TENNIS01"	 '21.11.12 로그에 안보이게 해달라고 해서 뺌 (국장 요청)
				End If
	
				fromNumber = "027040282"
				'fromNumber = "05055550055"
				toNumber = p1phone
				SMS_Msg = ""
				SMS_Msg = SMS_Msg & "- "&p1nm&"/"&p2nm&")\n "
				SMS_Msg = SMS_Msg & ""&gametitlename&"  "&TeamGbNm&" 입금대기로 전환\n"
				SMS_Msg = SMS_Msg & "24시간내 (3일전은 3시간, 2일전부터는 1시간) 미입금시 접수취소됩니다. \n"

				SMS_Msg = SMS_Msg & "- 가상계좌 : " & vacctno & "\n"
				SMS_Msg = SMS_Msg & "- 은행명 : KEB하나은행\n"
				SMS_Msg = SMS_Msg & "- 참가비 : " & acctotal & "원  \n\n"
				
				Call sendPhoneMessage(db, "7", SMS_Subject, SMS_Msg, sitecode,fromNumber,  toNumber)

				SQL = "update tblGameRequest set lastupdate = getdate() where requestidx = " & ridx
				Call db.execSQLRs(SQL , null, ConStr)
			
			
			'==========================================
	
	
	End if


		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson



  db.Dispose
  Set db = Nothing
%>

<%=gamemember%>
