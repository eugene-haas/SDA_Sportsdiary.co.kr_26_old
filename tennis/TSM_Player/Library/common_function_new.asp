<%
	'====================================================================================
	'한자리수 숫자 0붙이기
	'====================================================================================
	Function AddZero(Str)
		IF len(Str)=1 Then
			AddZero="0"&Str
		Else
			AddZero=Str
		End IF
	End Function
	'====================================================================================
	'참여인원에 따른 강수 구하기
	'====================================================================================
	Function chk_TotRound(TotCnt)
		If TotCnt = 0 Then 
			TotRound = 0
		ElseIf TotCnt > 0 And TotCnt <= 2 Then 
			TotRound = 2
		ElseIf TotCnt > 2 And TotCnt <= 4 Then 
			TotRound = 4
		ElseIf TotCnt > 4 And TotCnt <= 8 Then 
			TotRound = 8
		ElseIf TotCnt > 8 And TotCnt <= 16 Then 
			TotRound = 16
		ElseIf TotCnt > 16 And TotCnt <= 32 Then 
			TotRound = 32
		ElseIf TotCnt > 32 And TotCnt <= 64 Then 
			TotRound = 64
		ElseIf TotCnt > 64 And TotCnt <= 128 Then 
			TotRound = 128
		ElseIf TotCnt > 128 And TotCnt <= 256 Then 
			TotRound = 256
	 	ElseIf TotCnt > 256 And TotCnt <= 512 Then 
			TotRound = 512
		End If 
		
		chk_TotRound  = TotRound
		
	End Function 
	'====================================================================================
	Function Check_Login()
   		If Request.Cookies("SD")("UserID") = "" Then			'통합로그인		
			response.Write "<script>"			
			response.Write "	alert('로그인 후 이용할 수 있습니다. 로그인 페이지로 이동합니다.');"
			response.Write "	$(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/login.asp');"		
			response.Write "</script>"
			response.End
		Else
			IF COOKIE_MEMBER_IDX() = "" Then 
				response.Write "<script>"
				response.write "	alert('추가 계정정보가 필요한 서비스입니다.\n로그인 후 이용하세요.');"
				response.write "	$(location).attr('href','http://sdmain.sportsdiary.co.kr/sdmain/login.asp');"
				response.write "</script>"
				response.End
			End IF 
   		End IF 
	End Function 	
	'====================================================================================
	Function Check_NoLogin()
		'If Request.Cookies("SD")("UserID") <> "" AND COOKIE_MEMBER_IDX() <> "" Then 
        If Request.Cookies("SD")("UserID") <> "" Then 
			response.Write "<script>"
			response.write "	$(location).attr('href','../Main/index.asp');"
			response.write "</script>"
			response.End
		End If 
	End Function  
	'========================================================================================
	'동일한 사용자계정(이름,생년월일)이 있는지 체크하여 리턴
	'========================================================================================
	FUNCTION CHK_JOINUS(valName, valBirth)
		dim TSQL, TRs
		
		TSQL =  " 		SELECT ISNULL(COUNT(*), 0) cnt " 
		TSQL = TSQL & " FROM [SD_Member].[dbo].[tblMember]"
		TSQL = TSQL & " WHERE DelYN = 'N'" 
		TSQL = TSQL & "		AND UserName = '"&valName&"' " 
		TSQL = TSQL & "		AND Birthday = '"&valBirth&"' " 
		
		
		Set TRs= db.ExecSQLReturnRS(TSQL , null, T_ConStr)
			
		CHK_JOINUS = TRs(0)
		
			TRs.Close
		SET TRs = Nothing	
		
	END FUNCTION
	'========================================================================================
	'통합ID계정 정보출력
	'========================================================================================
	FUNCTION INFO_JOINUS_MEMBER(valName, valBirth)
		dim TSQL, TRs
		dim txt_INFO
		
		TSQL = " 		SELECT UserID" 
		TSQL = TSQL & " 	,UserName"
		TSQL = TSQL & " 	,UserEnName"
		TSQL = TSQL & " 	,UserPhone"
		TSQL = TSQL & " 	,Email"
		TSQL = TSQL & " 	,CASE SEX WHEN 'Man' THEN '남자' ELSE '여자' END SEX"
		'TSQL = TSQL & " 	,CONVERT(CHAR, CONVERT(DATE, Birthday), 102) Birthday"
   		TSQL = TSQL & "		,LEFT(Birthday, 4) +'.'+ SUBSTRING(Birthday, 5, 2) +'.'+ RIGHT(Birthday, 2) Birthday"
		TSQL = TSQL & " 	,Address"
		TSQL = TSQL & " 	,AddressDtl"
		TSQL = TSQL & " 	,CONVERT(CHAR, WriteDate, 102) WriteDate"
		TSQL = TSQL & " FROM [SD_Member].[dbo].[tblMember]"
		TSQL = TSQL & " WHERE DelYN = 'N'" 
		TSQL = TSQL & "		AND UserName = '"&valName&"' " 
		TSQL = TSQL & "		AND Birthday = '"&valBirth&"' " 
		
		Set TRs= db.ExecSQLReturnRS(TSQL , null, T_ConStr)

		IF Not(TRs.Eof OR TRs.Bof) Then
			
			txt_INFO = "		   <ul class='join-form'>"
			txt_INFO = txt_INFO & "	<li>"
			txt_INFO = txt_INFO & "		<p>아이디</p>"
			txt_INFO = txt_INFO & "		<p>"&TRs("UserID")&"</p>"
			txt_INFO = txt_INFO & "	</li>"
			txt_INFO = txt_INFO & "	<li>"
			txt_INFO = txt_INFO & "		<p>이름</p>"
			txt_INFO = txt_INFO & "		<p>"
			txt_INFO = txt_INFO & 			TRs("UserName")
   
			IF TRs("UserEnName")<>"" Then txt_INFO = txt_INFO & " ( "&TRs("UserEnName")&" ) "

			txt_INFO = txt_INFO &"		</p>"
			txt_INFO = txt_INFO & "	</li>"
			txt_INFO = txt_INFO & "	<li>"
			txt_INFO = txt_INFO & "		<p>생년월일</p>"
			txt_INFO = txt_INFO & "		<p>"&TRs("Birthday")&" ( "&TRs("SEX")&" )</p>"
			txt_INFO = txt_INFO & "	</li>"
			txt_INFO = txt_INFO & "	<li>"
			txt_INFO = txt_INFO & "		<p>휴대폰</p>"
			txt_INFO = txt_INFO & "		<p>"&TRs("UserPhone")&"</p>"
			txt_INFO = txt_INFO & "	</li>"
                
            IF TRs("Email") <> "" Then    
                txt_INFO = txt_INFO & "	<li>"
                txt_INFO = txt_INFO & "		<p>이메일</p>"
                txt_INFO = txt_INFO & "		<p>"&TRs("Email")&"</p>"
                txt_INFO = txt_INFO & "	</li>"
            End IF     
                
            IF TRs("Address") <> "" OR TRs("AddressDtl") <> "" Then        
                txt_INFO = txt_INFO & "	<li>"
                txt_INFO = txt_INFO & "		<p>주소</p>"
                txt_INFO = txt_INFO & "		<p>"&TRs("Address")&"<br>"&TRs("AddressDtl")&"</p>"
                txt_INFO = txt_INFO & "	</li>"
            End IF
                
            txt_INFO = txt_INFO & "</ul>"
			
		Else
		
			txt_INFO = 			  "<script>"
			txt_INFO = txt_INFO & "		alert('일치하는 정보가 없습니다. 확인 후 다시 이용하세요.');"
			txt_INFO = txt_INFO & "		history.back();"
			txt_INFO = txt_INFO & "</script>"
		
		End IF
			TRs.Close
		SET TRs = Nothing	
		
		INFO_JOINUS_MEMBER = txt_INFO
		
	END FUNCTION
	
	'========================================================================================
	'종목메인 설정이 되어 있는지 체크
	'/ajax/join_OK_type3.asp
   	'/ajax/join_OK_type4.asp
	'/ajax/join_OK_type5.asp
	'========================================================================================
   	FUNCTION CHK_SD_GameIDSET(valID, valType)
   
   		TSQL = " 		SELECT ISNULL(COUNT(*), 0) cnt" 
   		TSQL = TSQL & " FROM [SD_Tennis].[dbo].[tblMember]"
   		TSQL = TSQL & " WHERE DelYN = 'N'" 
		TSQL = TSQL & " 	AND SportsType = '"&valType&"'" 
		TSQL = TSQL & "		AND SD_UserID = '"&valID&"' " 		
   		TSQL = TSQL & "		AND SD_GameIDSET = 'Y'" 		
   		
		Set TRs= db.ExecSQLReturnRS(TSQL , null, T_ConStr)

		IF TRs(0) > 0 Then
   			CHK_SD_GameIDSET = "N"
   		Else
   			CHK_SD_GameIDSET = "Y"
   		END IF
   			TRs.Close
  		SET TRs = Nothing
   
   	END FUNCTION 
	'========================================================================================
	'쿠키설정(계정전환 /include/gnbType/change_modal.asp)
	'========================================================================================
	FUNCTION SET_INFO_COOKIE(valID, valIDX, valType)
		dim TSQL, TRs, SQL, Rs
		dim PhotoPath
		dim ReValue
		
		response.Cookies(valType).Domain 	= ".sportsdiary.co.kr"
		response.Cookies(valType).path 		= "/"
		response.Cookies(valType) 			= ""		'쿠키초기화 후 쿠키설정 진행합니다.
		
				
		TSQL =  " 		SELECT A.PlayerIDX" 
		TSQL = TSQL & "		,A.MemberIDX"  					
		TSQL = TSQL & "		,A.EnterType " 	
		TSQL = TSQL & "		,A.UserName" 
		TSQL = TSQL & "		,A.PhotoPath" 
		TSQL = TSQL & "		,A.Team " 	
		TSQL = TSQL & "		,A.Team2 " 					
		TSQL = TSQL & "		,A.PlayerReln " 		
		TSQL = TSQL & "		,CONVERT(CHAR(10), CONVERT(DATE, A.SrtDate), 102) SrtDate "  			
		TSQL = TSQL & "		,T.SvcStartDt " 		
		TSQL = TSQL & "		,T.SvcEndDt " 	
		TSQL = TSQL & "   	,CASE A.EnterType  "
		TSQL = TSQL & "     	WHEN 'E' THEN "
		TSQL = TSQL & " 			CASE A.PlayerReln "
		TSQL = TSQL & " 				WHEN 'A' THEN '엘리트-보호자(부-'+B.UserName+')'"
		TSQL = TSQL & " 				WHEN 'B' THEN '엘리트-보호자(모-'+B.UserName+')'"
		TSQL = TSQL & " 				WHEN 'Z' THEN '엘리트-보호자('+A.PlayerRelnMemo+'-'+B.UserName+')'"
		TSQL = TSQL & " 				WHEN 'T' THEN '엘리트-지도자('+ISNULL([SD_Tennis].[dbo].[FN_PubName]('sd03900'+LeaderType),'')+'-'+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valType&"', A.Team),'')+')'"
		TSQL = TSQL & " 				WHEN 'R' THEN "	
		TSQL = TSQL & "						CASE "
		TSQL = TSQL & "							WHEN [SD_Tennis].[dbo].[FN_TeamNm2]('"&valType&"', A.Team2) IS NULL THEN '엘리트-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valType&"', A.Team),'')+')'"
		TSQL = TSQL & "							ELSE '엘리트-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valType&"', A.Team),'')+'/'+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valType&"', A.Team2),'')+')'"
		TSQL = TSQL & "							END "
		TSQL = TSQL & " 				WHEN 'D' THEN '일반' "  
		TSQL = TSQL & "					END "
		TSQL = TSQL & "     	WHEN 'A' THEN "
		TSQL = TSQL & " 			CASE A.PlayerReln "
		TSQL = TSQL & " 				WHEN 'A' THEN '생활체육-보호자(부-'+B.UserName+')'"
		TSQL = TSQL & " 				WHEN 'B' THEN '생활체육-보호자(모-'+B.UserName+')'"
		TSQL = TSQL & " 				WHEN 'Z' THEN '생활체육-보호자('+A.PlayerRelnMemo+'-'+B.UserName+')'"
		TSQL = TSQL & " 				WHEN 'T' THEN '생활체육-지도자('+ISNULL([SD_Tennis].[dbo].[FN_PubName]('sd03900'+LeaderType),'')+'-'+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valType&"', A.Team),'')+')'"
		TSQL = TSQL & " 				WHEN 'R' THEN "	
		TSQL = TSQL & "						CASE "
		TSQL = TSQL & "							WHEN [SD_Tennis].[dbo].[FN_TeamNm2]('"&valType&"', A.Team2) IS NULL THEN '생활체육-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valType&"', A.Team),'')+')'"
		TSQL = TSQL & "							ELSE '생활체육-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valType&"', A.Team),'')+'/'+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&valType&"', A.Team2),'')+')'"
		TSQL = TSQL & "							END "
		TSQL = TSQL & " 				WHEN 'D' THEN '일반' "  
		TSQL = TSQL & "					END "	
		TSQL = TSQL & " 		END PlayerRelnNm "			
		TSQL = TSQL & " FROM [SD_Tennis].[dbo].[tblMember] A "
		TSQL = TSQL & "		left join [SD_Tennis].[dbo].[tblPlayer] B on A.PlayerIDX = B.PlayerIDX AND B.DelYN = 'N' AND B.SportsGb = '"&valType&"'"
		TSQL = TSQL & "		left join [SD_Tennis].[dbo].[tblTeamInfo] T on A.Team = T.Team AND T.DelYN = 'N' AND T.SportsGb = '"&valType&"'"
		TSQL = TSQL & " WHERE A.DelYN = 'N'" 
		TSQL = TSQL & " 	AND A.SportsType = '"&valType&"'" 
		TSQL = TSQL & "		AND A.SD_UserID = '"&valID&"' " 		
		TSQL = TSQL & "		AND A.MemberIDX = '"&valIDX&"' " 					
		Set TRs= db.ExecSQLReturnRS(TSQL , null, T_ConStr)

		IF Not(TRs.Eof Or TRs.Bof) Then 

			response.Cookies(valType).Domain 	= ".sportsdiary.co.kr"
			response.Cookies(valType).path 		= "/"
			
			IF request.Cookies("SD")("SaveIDYN") = "Y" Then
				response.cookies(valType).expires 	= Date() + 365
			Else
				response.cookies(valType).expires 	= Date() + 1	
			End IF	

			'회원프로필 이미지 세팅
			IF len(TRs("PhotoPath")) > 0  Then
				PhotoPath 	= "../"& mid(TRs("PhotoPath"), 4, len(TRs("PhotoPath")))
			Else
				PhotoPath 	= ImgDefault
			End IF	

			'==============================================================================
			'선수보호자 로그인의 경우 선수정보로 쿠키변경 처리
			'==============================================================================		
			IF TRs("PlayerReln") = "A" OR TRs("PlayerReln") = "B" OR TRs("PlayerReln") = "Z" Then

				'선수정보 조회
				TSQL =  " 		SELECT A.PlayerIDX" 
				TSQL = TSQL & "		,A.MemberIDX"  					
				TSQL = TSQL & "		,A.UserName" 
				TSQL = TSQL & "		,A.Team " 	
				TSQL = TSQL & "		,T.SvcStartDt " 		
				TSQL = TSQL & "		,T.SvcEndDt " 		
				TSQL = TSQL & " FROM [SD_Tennis].[dbo].[tblMember] A "
				TSQL = TSQL & "		left join [SD_Tennis].[dbo].[tblPlayer] B on A.PlayerIDX = B.PlayerIDX AND B.DelYN = 'N' AND B.SportsGb = '"&valType&"'"
				TSQL = TSQL & "		left join [SD_Tennis].[dbo].[tblTeamInfo] T on A.Team = T.Team AND T.DelYN = 'N' AND T.SportsGb = '"&valType&"'"
				TSQL = TSQL & " WHERE A.DelYN = 'N'"
				TSQL = TSQL & " 	AND A.SportsType = '"&valType&"' "
				TSQL = TSQL & "		AND A.PlayerIDX = '"&TRs("PlayerIDX")&"' " 
				TSQL = TSQL & "		AND A.PlayerReln IN('R', 'K', 'S')"

				Set Rs= db.ExecSQLReturnRS(TSQL , null, T_ConStr)
				IF Not(Rs.Eof Or Rs.Bof) Then 
					'==============================================================================================
					'선수보호자의 경우 선수정보 조회 후 쿠키셋팅
					'==============================================================================================
					Response.Cookies(valType)("P_MemberIDX") = encode(TRs("MemberIDX"), 0)  	'회원등록번호[선수보호자]			
					'==============================================================================================
					'선수정보
					'==============================================================================================
					Response.Cookies(valType)("MemberIDX") 	= encode(Rs("MemberIDX"), 0)  		'회원등록번호						
					Response.Cookies(valType)("PlayerIDX") 	= encode(Rs("PlayerIDX"), 0)  		'선수번호


					IF Team <> "" Then Response.Cookies(valType)("Team") = encode(Rs("Team") , 0)   	  	'팀소속
					IF SvcStartDt <> "" Then Response.Cookies(valType)("SvcStartDt") = Rs("SvcStartDt")    	'팀 관리 서비스 시작일
					IF SvcEndDt <> "" Then Response.Cookies(valType)("SvcEndDt") = Rs("SvcEndDt ")			'팀 관리 서비스 종료일

				End IF
					Rs.Close
				SET Rs = Nothing

			ELSE

				Response.Cookies(valType)("MemberIDX") = encode(TRs("MemberIDX"), 0)  '회원등록번호			

				IF TRs("Team") <> "" Then Response.Cookies(valType)("Team") = encode(TRs("Team") , 0)     				'팀소속	
				IF TRs("Team2") <> "" Then Response.Cookies(valType)("Team2") = encode(TRs("Team2") , 0)     			'팀소속	2
				IF TRs("PlayerIDX") <> "" Then Response.Cookies(valType)("PlayerIDX") = encode(TRs("PlayerIDX"), 0) 	'선수번호
				IF TRs("SvcStartDt") <> "" Then Response.Cookies(valType)("SvcStartDt") = TRs("SvcStartDt")    			'팀 관리 서비스 시작일
				IF TRs("SvcEndDt") <> "" Then Response.Cookies(valType)("SvcEndDt") = TRs("SvcEndDt")    				'팀 관리 서비스 종료일

			END IF

			IF TRs("PlayerReln") <> "" Then Response.Cookies(valType)("PlayerReln") = encode(TRs("PlayerReln"), 0) 	'보호자와 매칭된 선수와의 관계

			Response.Cookies(valType)("SrtDate") = TRs("SrtDate")													'회원가입일[선수보호자]									
			Response.Cookies(valType)("EnterType") = TRs("EnterType")  												'선수구분[E:엘리트 | A:아마추어 | K:국가대표]			
			Response.Cookies(valType)("PhotoPath") = encode(Server.HTMLEncode(PhotoPath), 0)						'회원프로필 이미지
			Response.Cookies(valType)("UserName") = TRs("UserName")    												'사용자명			
			Response.Cookies(valType)("SportsGb") = valType

			ReValue = TRs("PlayerRelnNm")
		End IF
			TRs.Close
		SET TRs = Nothing
				
		
		
		SET_INFO_COOKIE = ReValue
		
	END FUNCTION	
	'========================================================================================
  	'회원 MemberIDX 반환 (부모의 경우 P_MemberIDX)
	'mypage/myinfo.asp
	'include/gnbType/player_gnb.asp 
	FUNCTION COOKIE_MEMBER_IDX()
		
		SELECT CASE decode(request.Cookies(SportsGb)("PlayerReln"),0)
			CASE  "A","B","Z"	:  COOKIE_MEMBER_IDX = decode(request.Cookies(SportsGb)("P_MemberIDX"),0) 
			CASE Else	: COOKIE_MEMBER_IDX = decode(request.Cookies(SportsGb)("MemberIDX"),0)
		END SELECT	  
		
	END FUNCTION
	'========================================================================================================
	'대회레벨
	'========================================================================================================
	FUNCTION findGrade(gradeno)
		Dim txt_titleGrade
		
		SELECT CASE gradeno
			CASE "1" : txt_titleGrade = "SA"
			CASE "2" : txt_titleGrade = "GA"
			CASE "3" : txt_titleGrade = "A"
			CASE "4" : txt_titleGrade = "B"
			CASE "5" : txt_titleGrade = "C"
			CASE "6" : txt_titleGrade = "D" '단체
		END SELECT 
		
		findGrade = txt_titleGrade
		
	END FUNCTION
	'========================================================================================================
	'바이트수 구하기
	'========================================================================================================
	Function gf_LeftAtDb(szInput, nLen) 
	   Dim nCnt, szLeft 
	   
	   szInput = Trim(szInput) 
	   if isNull(szInput) or isEmpty(szInput) then 
		  gf_LeftAtDb = "" 
	   else 
		  For nCnt = 1 To Len(szInput) 
			 szLeft = Mid(szInput,1,nCnt) 
			 If gf_LenAtDb(szLeft) > nLen Then 
				szLeft = Mid(szInput,1,nCnt-1) 
				szleft = szleft & "..." 
				Exit For 
			 End If 
		  Next 
		  gf_LeftAtDb = szLeft 
	   end if 
	End Function 

	Function gf_LenAtDb(szAllText) 
		Dim nLen, nCnt, szEach 

		nLen = 0 
		szAllText = Trim(szAllText) 
		For nCnt = 1 To Len(szAllText) 
			szEach = Mid(szAllText,nCnt,1) 
			If 0 <= Asc(szEach) And Asc(szEach) <= 255 Then 
					nLen = nLen + 1             '한글이 아닌 경우 
			Else 
					nLen = nLen + 2             '한글인 경우 
			End If 
		Next 

		gf_LenAtDb = nLen 
	End Function 
	'========================================================================================================
	'가입된 회원계정 목록 출력쿼리
	'	GNB 상단영역../include/gnbType/player_gnb.asp
	'	MODAL 계정전환 모달../include/gnbType/change_modal.asp
	'	ACCOUNT 종목메인설정../mypage/user_account.asp
	'	ACCOUNTSET 종목메인설정변경../mypage/user_account_type.asp
	'========================================================================================================
	FUNCTION INFO_QUERY_JOINACCOUNT(valType)		 
		dim txt_SQL

		SELECT CASE valType
			CASE "GNB"		: txt_SQL = " AND M.MemberIDX = '"&COOKIE_MEMBER_IDX()&"' "	
			CASE "ACCOUNT" 	: txt_SQL = " AND M.SD_GameIDSET = 'Y'" 				
		END SELECT
		
		LSQL = "     	SELECT M.MemberIDX"
		LSQL = LSQL & "   	,M.SD_GameIDSET"
		LSQL = LSQL & "   	,CONVERT(DATE, M.SrtDate, 102) SrtDate "
		LSQL = LSQL & "   	,CASE M.EnterType  "
		LSQL = LSQL & "     	WHEN 'E' THEN "
		LSQL = LSQL & "     		CASE M.PlayerReln "
		LSQL = LSQL & "       			WHEN 'A' THEN '엘리트-보호자(부-'+P.UserName+')'"
		LSQL = LSQL & "       			WHEN 'B' THEN '엘리트-보호자(모-'+P.UserName+')'"
		LSQL = LSQL & "       			WHEN 'Z' THEN '엘리트-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
		LSQL = LSQL & "       			WHEN 'T' THEN '엘리트-지도자('+ISNULL([SD_Tennis].[dbo].[FN_PubName]('sd03900'+M.LeaderType),'')+')'+'-'+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team),'')"
		LSQL = LSQL & "       			WHEN 'D' THEN '일반' "  
		LSQL = LSQL & "       			WHEN 'R' THEN " 
		LSQL = LSQL & "           			CASE WHEN [SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team2) IS NULL THEN '<span class=""affiliation"">엘리트-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team),'')+')</span>'"
		LSQL = LSQL & "             			ELSE '<span class=""affiliation"">엘리트-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team),'')+' / '+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team2),'')+')</span>'"
		LSQL = LSQL & "             			END"      
		LSQL = LSQL & "             	END"      
		LSQL = LSQL & "     	WHEN 'A' THEN "
		LSQL = LSQL & "     		CASE M.PlayerReln "
		LSQL = LSQL & "       			WHEN 'A' THEN '생활체육-보호자(부-'+P.UserName+')'"
		LSQL = LSQL & "       			WHEN 'B' THEN '생활체육-보호자(모-'+P.UserName+')'"
		LSQL = LSQL & "       			WHEN 'Z' THEN '생활체육-보호자('+PlayerRelnMemo+'-'+P.UserName+')'"
		LSQL = LSQL & "       			WHEN 'T' THEN '생활체육-지도자('+ISNULL([SD_Tennis].[dbo].[FN_PubName]('sd03900'+M.LeaderType),'')+')'+'-'+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team),'')"
		LSQL = LSQL & "       			WHEN 'D' THEN '일반' "  
		LSQL = LSQL & "       			WHEN 'R' THEN " 
		LSQL = LSQL & "           			CASE WHEN [SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team2) IS NULL THEN '<span class=""affiliation"">생활체육-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team),'')+')</span>'"
		LSQL = LSQL & "             			ELSE '<span class=""affiliation"">생활체육-선수('+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team),'')+' / '+ISNULL([SD_Tennis].[dbo].[FN_TeamNm2]('"&SportsGb&"', M.Team2),'')+')</span>'"
		LSQL = LSQL & "             			END"    
		LSQL = LSQL & "             	END"      
		LSQL = LSQL & "       	END PlayerRelnNm "
		LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblMember] M"
		LSQL = LSQL & "     left join [SD_Tennis].[dbo].[tblPlayer] P on M.PlayerIDX = P.PlayerIDX AND P.SportsGb = '"&SportsGb&"' AND P.DelYN = 'N' "
		LSQL = LSQL & " WHERE M.DelYN = 'N' "
		LSQL = LSQL & "     AND M.SportsType = '"&SportsGb&"' "
		LSQL = LSQL & "     AND M.SD_UserID = '"&request.Cookies("SD")("UserID")&"' " 
		LSQL = LSQL &		txt_SQL  
		LSQL = LSQL & " ORDER BY M.EnterType "
		LSQL = LSQL & "     ,M.PlayerReln "

		
		INFO_QUERY_JOINACCOUNT = LSQL 

	END FUNCTION
	'========================================================================================================

    FUNCTION IPHONEYN()	

        If(Len(Request.ServerVariables("HTTP_USER_AGENT"))=0) Then
            strAgent = "NONE"
        Else
            strAgent = Request.ServerVariables("HTTP_USER_AGENT")
        End if
       
        mobile = Array("iPhone", "ipad", "ipod")

        imb = 0
        
        For Each n In mobile
            If (InStr(LCase(strAgent), LCase(n)) > 0) Then
                imb = imb + 1
            End If
        Next

        IPHONEYN = imb

    END FUNCTION
    '========================================================================================================            
    '비밀번호가 임시 비밀번호인지 체크 후 임시비밀번호인 경우 비밀번호 변경페이지로 이동시킵니다.
    '/include/gnbType/player_gnb.asp            
    '========================================================================================================                
    FUNCTION CHK_USERPASS_TYPE()
        IF decode(request.cookies("SD")("UserPassGb"), 0) = "Y" Then
            response.write "<script>"
            response.write "    alert('임시발급된 비밀번호로 로그인하였습니다. 비밀번호를 변경하여야합니다.\n비밀번호 변경페이지로 이동합니다.');"
            response.write "    $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/pwd_change.asp');"
            response.write "</script>"
            response.end
        End IF            
    END FUNCTION               
    '======================================================================================================== 


  M_conKey = "w암호화 비밀키" ' 암호화 비밀키
	'M_conIV = Replace(USER_IP,".","") & "초기화 백터" '초기화 벡터 (결제중 아이피가 변경되면 오류발생가능성 ) 
	'M_conIV = Replace(date,"-","") & "초기화 백터" '초기화 벡터 (자정문제발생)
	M_conIV = year(date) & "초기화 백터" '초기화 벡터 (자정문제발생)


	Function mallEncode(ByVal word, ByVal zero)

		'If chkBlank(word) Then Exit Function
		Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
	 	objEncrypter.Key = M_conKey
		objEncrypter.IV = M_conIV

		' 키 해시 알고리즘 설정. MD5 와 SHA2-256 을 지원합니다.
		' 아래 코드는 해시 크기가 256 비트이기 때문에, AES-256 이 사용됩니다.
		objEncrypter.KeyHashAlgorithm = "SHA2-256"

		' 문자열 암호화
		mallEncode =objEncrypter.Encrypt(word)
		Set objEncrypter = Nothing
	End Function


	Function malldecode(ByVal cipher_word, ByVal zero)
		'Response.write "<script>alert('"&cipher_word&"')</script>"
		'If chkBlank(cipher_word) Then Exit Function
		Set objEncrypter = Server.CreateObject("Ryeol.StringEncrypter")
	 	objEncrypter.Key = M_conKey
		objEncrypter.IV = M_conIV

		' 키 해시 알고리즘 설정. MD5 와 SHA2-256 을 지원합니다.
		' 아래 코드는 해시 크기가 256 비트이기 때문에, AES-256 이 사용됩니다.
		objEncrypter.KeyHashAlgorithm = "SHA2-256"

		' 문자열 복호화
		malldecode = objEncrypter.Decrypt(cipher_word)
		Set objEncrypter = Nothing
	End Function

  iLIMemberIDXG = decode(Request.Cookies("SD")("MemberIDX"),0)
%>