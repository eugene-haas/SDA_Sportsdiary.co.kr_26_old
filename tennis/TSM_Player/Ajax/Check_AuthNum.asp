<!--#include file="../Library/ajax_config.asp"-->
<%
	'==================================================================================
	'인증번호 발송페이지
	'==================================================================================
	dim UserPhone1 : UserPhone1 	= fInject(Request("UserPhone1"))
	dim UserPhone2 : UserPhone2 	= fInject(Request("UserPhone2"))
	dim UserPhone3 : UserPhone3 	= fInject(Request("UserPhone3"))
	
	dim tempAuth, SMSMsg
	
	If UserPhone1 = "" OR UserPhone2 = "" OR UserPhone3 = "" Then 
		Response.Write "FALSE|"
		Response.End
	Else
		
		'인증번호
		tempAuth = random_Disigt_str()
		SMSMsg = "[스포츠다이어리]인증번호 ["&tempAuth&"] 를 입력해 주세요."
	
		'인증번호 SMS 발송	
		Itemcenter_DBOpen()

			InSQL = "INSERT INTO ITEMCENTER.DBO.T_SEND"
			InSQL = InSQL&"("
			InSQL = InSQL&" SSUBJECT "
			InSQL = InSQL&",NSVCTYPE "
			InSQL = InSQL&",NADDRTYPE"
			InSQL = InSQL&",SADDRS "
			InSQL = InSQL&",NCONTSTYPE"
			InSQL = InSQL&",SCONTS"
			InSQL = InSQL&",SFROM"
			InSQL = InSQL&",DTSTARTTIME"
			InSQL = InSQL&")"
			InSQL = InSQL&" VALUES "
			InSQL = InSQL&"("
			InSQL = InSQL&"'"&SMSMsg&"'"
			InSQL = InSQL&",3 " '--3:SMS, 5:LMS
			InSQL = InSQL&",0 "
			InSQL = InSQL&",'"&UserPhone1&UserPhone2&UserPhone3&"'" '--수신번호
			InSQL = InSQL&",0"
			InSQL = InSQL&",'"&SMSMsg&"'"
			InSQL = InSQL&",'027040282'" '--발신번호 (발신 확인번호 등록 유의)
			InSQL = InSQL&",GETDATE()"
			InSQL = InSQL&")"
			
			DBCon2.Execute(InSQL)				

		Itemcenter_DbClose()

		Response.Write "TRUE|"&tempAuth&"|"&UserPhone1&"|"&UserPhone2&"|"&UserPhone3
		Response.End
		
	End If 
%>