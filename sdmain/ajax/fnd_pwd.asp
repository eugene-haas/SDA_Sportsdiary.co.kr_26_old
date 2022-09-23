<!--#include file="../Library/ajax_config.asp"-->
<%
	'=============================================================================
	'비밀번호 찾기 페이지
	'=============================================================================
	dim UserID 		: UserID    = fInject(Trim(Request("USerID")))
	dim UserPhone 	: UserPhone = fInject(Trim(Request("UserPhone")))
	dim UserName	: UserName  = fInject(Trim(Request("UserName")))
	
	dim CSQL, CRs, LSQL, InSQL
	
	IF UserID = "" Or UserPhone = "" Or UserName = "" Then 
		Response.Write "FALSE|200"
		Response.End
	Else
		dim TempPass
		dim SMSMsg
		
		CSQL = 	"		SELECT UserID " 
		CSQL = CSQL & "	FROM [SD_Member].[dbo].[tblMember] " 
		CSQL = CSQL & "	WHERE DelYN = 'N'" 
		CSQL = CSQL & "		AND UserID = '"&UserID&"'" 
		CSQL = CSQL & "		AND UserName = '"&UserName&"'" 
		CSQL = CSQL & " 	AND Replace(UserPhone,'-','') = '"&UserPhone&"'"
					
		SET CRs = DBcon3.Execute(CSQL)
		IF Not(CRs.Eof Or CRs.Bof) Then
			
			'임시비밀번호 업데이트
			'TempPass = random_str()          '영문자+숫자 6자리
            TempPass = random_Disigt_str     '숫자 4자리                                       
			
			'스포츠다이어리 임시비밀번호****** 마이페이지에서 비밀번호 변경바랍니다.	
			SMSMsg = "스포츠다이어리 임시비밀번호 ["&TempPass&"] 마이페이지에서 비밀번호 변경바랍니다."

			'임시비밀번호[TempPass] 업데이트
			LSQL = "		UPDATE [SD_Member].[dbo].[tblMember] " 
			LSQL = LSQL & "	SET UserPass = '"&TempPass&"'"
      LSQL = LSQL & "     ,PassEnc = PWDENCRYPT('"&TempPass&"') "
			LSQL = LSQL & "		,UserPassGb = 'Y'"                  '임시비밀번호 구분
      LSQL = LSQL & "		,WriteDate = GETDATE()"                                                              
			LSQL = LSQL & "	WHERE DelYN = 'N'" 
			LSQL = LSQL & "		AND UserID = '"&UserID&"'" 
			LSQL = LSQL & "		AND UserName = '"&UserName&"'" 
			LSQL = LSQL & "	 	AND Replace(UserPhone,'-','') = '"&UserPhone&"'"

			DBcon3.Execute(LSQL)				

		


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









			'==========================================================================================================
			'임시비밀번호 SMS 발송	
			'==========================================================================================================
				'			Itemcenter_DBOpen()
				'
				'				InSQL = "		  INSERT INTO ITEMCENTER.DBO.T_SEND("
				'				InSQL = InSQL & " 		SSUBJECT "
				'				InSQL = InSQL & "		,NSVCTYPE "
				'				InSQL = InSQL & "		,NADDRTYPE"
				'				InSQL = InSQL & "		,SADDRS "
				'				InSQL = InSQL & "		,NCONTSTYPE"
				'				InSQL = InSQL & "		,SCONTS"
				'				InSQL = InSQL & "		,SFROM"
				'				InSQL = InSQL & "		,DTSTARTTIME"
				'				InSQL = InSQL & " )"
				'				InSQL = InSQL & " VALUES("
				'				InSQL = InSQL & "	'"&SMSMsg&"'"
				'				InSQL = InSQL & "	,3 " '--3:SMS, 5:LMS
				'				InSQL = InSQL & "	,0 "
				'				InSQL = InSQL & "	,'"&UserPhone&"'" '--수신번호
				'				InSQL = InSQL & "	,0"
				'				InSQL = InSQL & "	,'"&SMSMsg&"'"
				'				InSQL = InSQL & "	,'027040282'" '--발신번호 (발신 확인번호 등록 유의)
				'				InSQL = InSQL & "	,GETDATE()"
				'				InSQL = InSQL & " )"
				'				
				'				DBCon2.Execute(InSQL)				
				'
				'			Itemcenter_DbClose()
			'==========================================================================================================

				







			Response.Write "TRUE|"
			Response.End
			
		Else
		
			Response.Write "FALSE|99"
			Response.End
			
		End IF 
		
			CRs.Close
		SET CRs = Nothing 
		
		DBClose3()
		
	End IF 
%>