<!--#include file="../Library/ajax_config.asp"-->
<%
	'========================================================================================
	'로그인 페이지
	'========================================================================================
	dim UserID 		: UserID   	= LCase(fInject(trim(Request("UserID"))))
	dim UserPass 	: UserPass 	= fInject(trim(Request("UserPass")))
	dim saveid		: saveid 	= fInject(trim(request("saveid")))
	
	dim LSQL, LRs
	
	IF UserID = "" OR UserPass = "" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
	
		dim MemberIDX, UserName, UserPhone, Birthday, Sex, UserPassGb
		dim chk_User				'통합ID설정 유무(2개 이상이면 통합설정하지 않은 경우입니다.)
		dim chk_Log					'로그인 로그
		dim str_Cookie()			'종목별 쿠키설정 
		
		'회원DB
		LSQL = " 		SELECT MemberIDX " 
		LSQL = LSQL & " 	,UserName"
		LSQL = LSQL & " 	,replace(UserPhone,'-','') UserPhone"
		LSQL = LSQL & " 	,Birthday"
		LSQL = LSQL & " 	,Sex"
        LSQL = LSQL & " 	,ISNULL(UserPassGb,'') UserPassGb"     '임시비밀번호 구분
		LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember]"
		LSQL = LSQL & " WHERE DelYN = 'N'" 
		LSQL = LSQL & "		AND UserID = '"&UserID&"' " 
		LSQL = LSQL & "		AND UserPass = '"&UserPass&"' " 
		
		SET LRs = DBCon3.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 
			
			MemberIDX 	= LRs("MemberIDX")
			UserName 	= LRs("UserName")
			UserPhone 	= LRs("UserPhone")
			Birthday 	= LRs("Birthday")
			Sex 		= LRs("Sex")
            UserPassGb 	= LRs("UserPassGb")   
			
			'1. 로그인 로그 기록
   			'	/sdmain/Libary/common_function.asp
			chk_Log = INFO_LOGINLOG(UserID, UserName, Sex)
			
			'2. 통합ID 설정 유무체크 
   			'	통합회원DB에서 한개의 개정만 남긴 후 기타 계정은 삭제하기 위한 계정카운트조회 로직입니다.
			'	SD_Member.dbo.tblMember 가입계정 카운트 chk_User
			'	/sdmain/Libary/common_function.asp 
			chk_User = CHK_JOINUS(UserName, Birthday)
			
			'3.	통합정보 쿠키설정 
			response.Cookies("SD").Domain 			= ".sportsdiary.co.kr"
			response.Cookies("SD").path 			= "/"
   
			response.Cookies("SD")("UserID")    	= UserID					'사용자ID
			response.Cookies("SD")("UserName")  	= UserName					'사용자명			
			response.Cookies("SD")("UserBirth")  	= encode(BirthDay, 0)		'생년월일
			response.Cookies("SD")("MemberIDX")  	= encode(MemberIDX, 0)		'MemberIDX
			response.Cookies("SD")("UserPhone")  	= encode(UserPhone, 0)		'Phone
			response.Cookies("SD")("Sex")  			= Sex						'성별		
            response.Cookies("SD")("SaveIDYN")  	= saveid					'자동로그인정보(chk_GameIDSET.asp종목계정설정때 필요)		
			
            IF UserPassGb <> "" Then response.Cookies("SD")("UserPassGb") = encode(UserPassGb, 0)  '임시비밀번호 구분[Y:임시비밀번호 발급의 경우]		

			'4. 각 종목별 메인계정설정이 되어 있다면 해당 계정으로 쿠키를 설정합니다.
   			'	../Libary/ajax_config.asp
			'	LIST_SPORTSTYPE	 = |SD|judo|tennis|bike...  [|SD] 제외 이후 문자사용
             
   			dim txt_SportsGb : txt_SportsGb = split(mid(LIST_SPORTSTYPE, 4, len(LIST_SPORTSTYPE)), "|")
             
            redim str_Cookie(Ubound(txt_SportsGb)) 
   			
   			FOR i = 1 To Ubound(txt_SportsGb)
				str_Cookie(i) = SET_INFO_COOKIE(UserID, txt_SportsGb(i), saveid) '쿠키세팅
			NEXT
			
			
			'5. 자동로그인 기능
			IF saveid = "Y" then
				response.Cookies("SD").expires 	= Date() + 365
			Else
				response.Cookies("SD").expires 	= Date() + 1				
			End IF

            '-------------------------------------------------------------------------------------------------
            '6. 푸시관련 기기식별자 자동등록처리
            dim strip : strip = Request.ServerVariables("REMOTE_ADDR")

            IF mid(trim(strip), 1, 14) = "118.33.86.240" then
                IF decode(request.Cookies("SD")("RegIdentityYN"), 0) <> "Y" Then
                    response.write "<script>alert('sportsdiary://setIdentity?id="&UserID&"');</script>"
                    response.Cookies("RegIdentityYN").Domain 	= ".sportsdiary.co.kr"
			        response.Cookies("RegIdentityYN").path 		= "/"
                    response.Cookies("RegIdentityYN").expires 	= Date() + 365
                    response.Cookies("RegIdentityYN") = encode("Y", 0)                    
                End IF
            End IF
            '-------------------------------------------------------------------------------------------------
			
			Response.Write "TRUE|"&chk_User&"|"&UserName&"|"&BirthDay
				
			Response.End	
				
		ELSE
		
			Response.Write "FALSE|99"
			Response.End
					
		END IF
			LRs.Close
		SET LRs = Nothing
		
		DBClose3()
	
	End IF 

	
%>
