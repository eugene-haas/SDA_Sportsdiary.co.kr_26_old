<!--#include file="../Library/ajax_config.asp"-->
<%
	'==================================================================================
	'인증번호 발송페이지
	'==================================================================================
	dim UserPhone1 : UserPhone1 	= fInject(Request("UserPhone1"))
	dim UserPhone2 : UserPhone2 	= fInject(Request("UserPhone2"))
	dim UserPhone3 : UserPhone3 	= fInject(Request("UserPhone3"))

	dim UserPhone
	dim tempAuth, SMSMsg
	dim InSQL

	If UserPhone1 = "" OR UserPhone2 = "" OR UserPhone3 = "" Then 
		Response.Write "FALSE|"
		Response.End
	Else
	 	UserPhone = UserPhone1&UserPhone2&UserPhone3
		
		'인증번호
		tempAuth = random_Disigt_str()
		SMSMsg = "스포츠다이어리 인증번호 ["&tempAuth&"]를 입력해주세요."
	
		'인증번호 SMS 발송	


	'#####################
		Function sprintf(sVal, aArgs)      
			Dim i, arg
			  If(sVal = "") Then 
				 sprintf = ""
				 Exit Function 
			  End If 

			  For i=0 To UBound(aArgs)
				 arg = aArgs(i)
				 If(IsNull(arg)) Then arg = "" End If 
				 sVal = Replace(sVal,"{" & CStr(i) & "}",arg)
			  Next
			  
			  sprintf = sVal
		   End Function

		'   ===============================================================================     
		'    Send SMS 
		'    NSVCTYPE --3:SMS, 7:LMS
		'    subject: 제목 , sendPhone:발신번호 , recvPhone: recvPhone, content: 내용
		'   =============================================================================== 
		  Function getSQLSendSMS(subject, content, recvPhone) 
			SMSDBOpen()
			  Dim strSql, strField, strValue, sendPhone
			  
			  sendPhone = "027040282"   

			  sendPhone = Replace(sendPhone, "-", "")
			  recvPhone = Replace(recvPhone, "-", "")
			  content   = Replace(content, "\r\n", Chr(10))       ' 개행 문자열 변환
			  content   = Replace(content, "\n", Chr(10))         ' 개행 문자열 변환
			  
			  strField = "sSubject,nSvcType,nAddrType,sAddrs,nContsType,sConts,sFrom,dtStartTime" 
			  strValue = sprintf("'{0}','{1}','{2}','{3}','{4}','{5}','{6}',{7}", _
						  Array(subject, 3, 0, recvPhone, 0, content, sendPhone, "Getdate()"))         
			  
			  strSql = sprintf("Insert Into t_send ({0}) Values({1})", Array(strField, strValue))        
			  DBConSms.Execute(strSql)	
			  SMSDBClose()     
		  End Function  
		  
		  ' ===============================================================================  
	'#####################



		' SMS 발송  
		strSub = "스포츠다이어리"
		strContent = SMSMsg
		req_phone = REPLACE(UserPhone,"-","")

		Call getSQLSendSMS(strSub, strContent, req_phone)  


'			InSQL = "		  INSERT INTO ITEMCENTER.DBO.T_SEND("
'			InSQL = InSQL & " 	SSUBJECT "
'			InSQL = InSQL & "	,NSVCTYPE "
'			InSQL = InSQL & "	,NADDRTYPE"
'			InSQL = InSQL & "	,SADDRS "
'			InSQL = InSQL & "	,NCONTSTYPE"
'			InSQL = InSQL & "	,SCONTS"
'			InSQL = InSQL & "	,SFROM"
'			InSQL = InSQL & "	,DTSTARTTIME"
'			InSQL = InSQL & " )"
'			InSQL = InSQL & " VALUES("
'			InSQL = InSQL & "	'"&SMSMsg&"'"
'			InSQL = InSQL & "	,3 " 					'3:SMS, 5:LMS
'			InSQL = InSQL & "	,0 "
'			InSQL = InSQL & "	,'"&UserPhone&"'" 		'수신번호
'			InSQL = InSQL & "	,0"
'			InSQL = InSQL & "	,'"&SMSMsg&"'"
'			InSQL = InSQL & "	,'027040282'" 			'발신번호(발신 확인번호 등록 유의)
'			InSQL = InSQL & "	,GETDATE()"
'			InSQL = InSQL & " )"
'			
'			DBCon2.Execute(InSQL)				
'
'		Itemcenter_DbClose()

		Response.Write "TRUE|"&tempAuth&"|"&UserPhone1&"|"&UserPhone2&"|"&UserPhone3
		Response.End
		
	End IF 
%>