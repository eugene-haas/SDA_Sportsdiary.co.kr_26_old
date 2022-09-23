<!--#include file="../Library/ajax_config.asp"-->
<%
	'=================================================================
  	'SD 회원가입 페이지
  	'=================================================================
	dim UserID 			: UserID 			= fInject(trim(Request("UserID")))
	dim UserPass 		: UserPass 			= fInject(trim(Request("UserPass")))		
	dim UserName 		: UserName 			= fInject(trim(Request("UserName")))
	dim UserEnName 		: UserEnName   		= fInject(trim(Request("UserEnName")))
	dim UserBirth 		: UserBirth 		= fInject(trim(Request("UserBirth")))	
	dim UserPhone 		: UserPhone 		= fInject(trim(Request("UserPhone")))
	dim SEX 			: SEX 				= fInject(Request("SEX"))	 
	dim UserEmail 		: UserEmail 		= fInject(trim(Request("UserEmail")))
	dim ZipCode 		: ZipCode 			= fInject(Request("ZipCode"))	 
	dim UserAddr 		: UserAddr 			= fInject(trim(Request("UserAddr")))
	dim UserAddrDtl 	: UserAddrDtl 		= fInject(trim(Request("UserAddrDtl")))
	dim SmsYn 			: SmsYn 			= fInject(Request("SmsYn"))	 				'휴대폰 수신동의
	dim EmailYn 		: EmailYn 			= fInject(Request("EmailYn"))	 			'이메일 수신동의	
                                                                                         
    IF len(EmailYn) = 0 Then EmailYn = "N"  '기본값 세팅
                                                                                         
	dim CSQL, CRs, LSQL, LRs
	dim chk_Log
   
	'======================================================================================================
	'회원가입 후 로그인 상태로 SET, 쿠키 SET
	'====================================================================================================== 
	FUNCTION LOGIN_OK(valID)
		LSQL =  " 		SELECT MemberIDX " 
		LSQL = LSQL & " 	,UserName"
		LSQL = LSQL & " 	,replace(UserPhone,'-','') UserPhone"
		LSQL = LSQL & " 	,Birthday"
		LSQL = LSQL & " 	,Sex"
		LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember]"
		LSQL = LSQL & " WHERE DelYN = 'N'" 
		LSQL = LSQL & "		AND UserID = '"&valID&"' " 
		
		SET LRs = DBCon3.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 

			chk_Log = INFO_LOGINLOG(UserID, UserName, Sex)								'로그인 로그 기록
			
			response.Cookies("SD").Domain 			= ".sportsdiary.co.kr"
			response.Cookies("SD").path 			= "/"
			response.Cookies("SD")("MemberIDX")  	= encode(LRs("MemberIDX"), 0)		'MemberIDX																					 
			response.Cookies("SD")("UserID")    	= valID								'사용자ID
			response.Cookies("SD")("UserName")  	= LRs("UserName")					'사용자명			
			response.Cookies("SD")("UserBirth")  	= encode(LRs("Birthday"), 0)		'생년월일			
			response.Cookies("SD")("UserPhone")  	= encode(LRs("UserPhone"), 0)		'Phone('-'제거)
			response.Cookies("SD")("Sex")  			= LRs("Sex")						'성별		
			response.cookies("SD").expires 			= Date() + 1						'쿠키만료일 1일
			
			LOGIN_OK = request.Cookies("SD")("UserID") 
																				 
		END IF
			LRs.Close
		SET LRs = Nothing
   
	END FUNCTION
	'======================================================================================================
	 
																									 

	IF UserID = "" OR UserPass = "" OR UserName = "" OR UserBirth = "" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
		On Error Resume Next
			
		DBcon3.BeginTrans()
		
		
		'tblMember 가입내역 조회		
		CSQL =  	  " SELECT UserID"
		CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND UserName = '" & UserName & "'"  	
		CSQL = CSQL & "		AND Birthday = '" & UserBirth & "'" 
   		CSQL = CSQL & "		AND SEX = '" & SEX & "'" 

		SET CRs = DBCon3.Execute(CSQL)	
		IF Not(CRs.eof or CRs.Bof) Then
			Response.Write "FALSE|99"
			Response.End
		Else
			LSQL = "		INSERT INTO [SD_Member].[dbo].[tblMember] (" 
			LSQL = LSQL & "		UserID "  
			LSQL = LSQL & "		,UserPass " 
			LSQL = LSQL & "		,UserName " 										
			LSQL = LSQL & "		,UserEnName " 
			LSQL = LSQL & "		,UserPhone " 
			LSQL = LSQL & "		,Birthday "  
			LSQL = LSQL & "		,Email " 
			LSQL = LSQL & "		,ZipCode " 
			LSQL = LSQL & "		,Address " 
			LSQL = LSQL & "		,AddressDtl " 
			LSQL = LSQL & "		,Sex " 				
			LSQL = LSQL & "		,EmailYn "  					
			LSQL = LSQL & "		,EmailYnDt "  					
			LSQL = LSQL & "		,SmsYn "  					
			LSQL = LSQL & "		,SmsYnDt "  									
			LSQL = LSQL & "		,WriteDate "  
			LSQL = LSQL & "		,ModDate "
      LSQL = LSQL & "		,PushYN "
			LSQL = LSQL & "		,PushYNDt "
      LSQL = LSQL & "		,PassEnc "
      LSQL = LSQL & "		,DelYN "				
			LSQL = LSQL & "	) VALUES(" 
			LSQL = LSQL & "		'" & UserID 		& "'" 
			LSQL = LSQL & "		,'" & UserPass 		& "'" 
			LSQL = LSQL & "		,'" & UserName 		& "'" 
			LSQL = LSQL & "		,'" & UserEnName 	& "'" 
			LSQL = LSQL & "		,'" & UserPhone 	& "'" 
			LSQL = LSQL & "		,'" & UserBirth 	& "'" 
			LSQL = LSQL & "		,'" & UserEmail 	& "'" 
			LSQL = LSQL & "		,'" & ZipCode 		& "'" 
			LSQL = LSQL & "		,'" & UserAddr 		& "'" 
			LSQL = LSQL & "		,'" & UserAddrDtl 	& "'" 
			LSQL = LSQL & "		,'" & SEX 			& "'" 
			LSQL = LSQL & "		,'" & EmailYn 		& "'" 
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,'" & SmsYn 		& "'" 
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,GETDATE()"
      LSQL = LSQL & "		,'Y'" 
      LSQL = LSQL & "		,GETDATE()"
      LSQL = LSQL & "		,PWDENCRYPT('" & UserPass & "')"
			LSQL = LSQL & "		,'N'"
			LSQL = LSQL & "	)"
			
			'response.Write "LSQL=" & LSQL&"<br>"
			
			DBCon3.Execute(LSQL)	
 
 			IF DBCon3.Errors.Count > 0 Then
				DBCon3.RollbackTrans()				
				Response.Write "FALSE|66"				
			Else					
				DBCon3.CommitTrans()								
				strCookies = LOGIN_OK(UserID) 	'로그인상태 유지 및 쿠키 SET
				Response.Write "TRUE|" 				
			End IF

		End IF
			CRs.Close
		SET CRs = Nothing
		
		DBClose3()
		
	End IF 

%>