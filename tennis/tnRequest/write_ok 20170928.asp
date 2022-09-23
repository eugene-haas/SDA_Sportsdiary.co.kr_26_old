<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'대회참가 신청 정보 SAVE 페이지
	'===============================================================================================
	dim act				: act 				= fInject(request("act"))					'Write / Modify
	
	'===============================================================================================
	'목록페이지에서 검색을 위한 조건데이터
	'===============================================================================================
	dim currPage		: currPage 			= fInject(request("currPage"))				'./list_repair.asp, ./list.asp	현재페이지 번호
	dim Fnd_KeyWord		: Fnd_KeyWord 		= fInject(request("Fnd_KeyWord"))			'./list_repair.asp, ./list.asp 	키워드 검색어
	dim GameTitle		: GameTitle 		= fInject(request("GameTitle"))				'./list_repair.asp 				대회select box 조회
	dim Fnd_TeamGb		: Fnd_TeamGb 		= fInject(request("Fnd_TeamGb"))			'./list_repair.asp 				참가종목 select box 조회
	'===============================================================================================
	
	'Modify data
	dim RequestGroupNum	: RequestGroupNum 	= fInject(decode(request("RequestGroupNum"), 0))			'참가신청그룹번호: 참가신청 수정시 

	
	'Write data
	dim Fnd_GameTitle	: Fnd_GameTitle 	= fInject(request("Fnd_GameTitle"))			'대회IDX
	dim TeamGb			: TeamGb 			= fInject(request("TeamGb"))				'참가종목
	dim UserPass		: UserPass 			= fInject(Trim(request("UserPass")))		'비밀번호
	dim UserName		: UserName 			= fInject(Trim(request("UserName")))		
	dim UserPhone1		: UserPhone1 		= fInject(request("UserPhone1"))
	dim UserPhone2		: UserPhone2 		= fInject(request("UserPhone2"))
	dim UserPhone3		: UserPhone3 		= fInject(request("UserPhone3"))
	dim PaymentDt		: PaymentDt 		= fInject(Trim(request("PaymentDt")))		'입금일자
	dim PaymentNm		: PaymentNm 		= fInject(Trim(request("PaymentNm")))		'입금자명
	dim txtMemo			: txtMemo 			= fInject(request("txtMemo"))				'비고
	
	
	dim P1_UserName, P1_UserLevel, P1_UserPhone1, P1_UserPhone2, P1_UserPhone3, P1_UserPhone
	dim P1_Birthday, P1_TeamNmOne, P1_TeamNmTwo, P1_GenderIDX
	dim P1_Master, P2_Master
	
	'기본값 세팅
	dim SportsGb		: SportsGb			= "tennis"
	dim EnterType		: EnterType			= "A"
	
	dim LSQL, LRs, JSQL, JRs, CSQL, CRs
	dim RGroupNum				'참가신청 신규등록시 그룹번호
	dim TotRound	'강수
	
	dim ErrorNum	: ErrorNum	= 0
	dim i, j
	
	'========================================================================================================================
	'LMS 문자 발송을 위한 데이터 수집
	'========================================================================================================================
	dim SMS_UserNm			'SMS 발송 메세지(참가신청한 참가자, 파트너 이름 목록 정보)	
	dim SMS_Phone			'SMS 발송 참가신청한 참가자, 파트너 전체 전화번호
	dim SMS_ReVal			'참가신청한 참가자, 파트너의 참가신청 동의를 위한 리턴값 UserNm+UserPhone
	dim txt_SMSUser			'SMS 발송 메세지(참가신청한 참가자, 파트너 이름 목록 정보) 전체
	dim txt_SMSPhone		'SMS 발송 참가신청한 참가자, 파트너 전체 전화번호 전체
	dim txt_SMSReVal		'참가신청한 참가자, 파트너의 참가신청 동의를 위한 리턴값 UserNm+UserPhone 전체
	
	dim SMS_Msg				'SMS 발송 메세지
	dim SMS_MsgEach			'SMS 발송 메세지 [개별메시지]
	dim SMS_GameTitleNm 	'SMS 발송 대회명
	dim SMS_GameLevel		'SMS 발송 대회 참가종목	
	dim SMS_Subject			'SMS 발송 제목
	
	SMS_GameTitleNm	= fInject(request("SMS_GameTitleNm"))
	SMS_Subject		= "*** 대회 참가신청완료 알림메시지 ***"
	
	CSQL = "		SELECT R.TeamGbNm TeamGbNm"
	CSQL = CSQL & "		,L.levelNm levelNm" 
	CSQL = CSQL & "	FROM [SD_Tennis].[dbo].[tblRGameLevel] R "
	CSQL = CSQL & "		left join [SD_Tennis].[dbo].[tblLevelInfo] L on R.Level = L.Level "
	CSQL = CSQL & "			AND L.DelYN = 'N' "
	CSQL = CSQL & "			AND L.SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "	WHERE R.DelYN = 'N' "
	CSQL = CSQL & "		AND R.SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "		AND R.Level = '"&TeamGb&"' "
	CSQL = CSQL & "		AND R.GameTitleIDX = '"&Fnd_GameTitle&"' " 
	
	SET CRs = DBCon.Execute(CSQL)	
	IF Not(CRs.Eof OR CRs.Bof) Then
		SMS_GameLevel = " ("& CRs("TeamGbNm") & " " & CRs("levelNm") &")"
	End IF
		CRs.Close
	SET CRs = Nothing	
	'========================================================================================================================

	
	
	
	IF act = "" Then
		response.Write "<script>"
		response.Write "	alert('잘못된 접근입니다. 확인 후 이용하세요.');"
		response.Write "	history.back();"
		response.Write "<script>"
		response.End()
	Else
		
		On Error Resume Next
	
		DBcon.BeginTrans()
		
		
		
		
		dim PersonCode, bufNum, cntZeroNum
		dim P1_PlayerIDX, PlayerIDX		
		dim SET_Team(2)	'소속팀배열[ 1:소속코드, 2:소속명]
		
		'===========================================================================================================
		'팀정보테이블[tblTeamInfo]  팀정보 등록 여부 체크 및 등록처리
		'===========================================================================================================
		FUNCTION INSERT_TEAM_INFO(val)
			
			'소속팀정보 NOT NULL
			IF val <> "" Then
				
				SET_Team(2) = val	'소속팀 명
			
				LSQL = "		SELECT Team "
				LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblTeamInfo]"						
				LSQL = LSQL & " WHERE DelYN = 'N'"
				LSQL = LSQL & " 	AND SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & " 	AND TeamNm = '"&val&"'"

				SET LRs = DBCon.Execute(LSQL)	
				IF Not(LRs.Eof OR LRs.Bof) Then
					SET_Team(1) = LRs("Team")	'소속팀 코드
				Else
	
					'등록된 팀정보가 없는 경우 신규등록처리
					
					'===============================================================================================
					'팀정보 테이블[tblTeamInfo] Team 값 조회
					'===============================================================================================
					JSQL = "		SELECT ISNULL(MAX(Team), '') Team "
					JSQL = JSQL & " FROM [SD_Tennis].[dbo].[tblTeamInfo]"						
					JSQL = JSQL & " WHERE SportsGb = '"&SportsGb&"'"
					
					SET JRs = DBCon.Execute(JSQL)	
					IF JRs(0) = "" Then
						SET_Team(1) = "ATE" & "0000001"							
					Else
						bufNum = ""
						
						'ex) TE000000012
						'ATE을 제외한 나머지 숫자에 1을 더한 숫자의 자리수와 ATE의 자리수(3)를 뺀 자릿수 만큼 0을 붙인다
						
						FOR j = 1 to Len(JRs(0)) - len(Mid(JRs(0), 4, Len(JRs(0))) + 1) - 3
							bufNum = bufNum & "0"
						NEXT
						
					
						'ATE 이후의 숫자에 1을 더한 수를 구한 후 만든 0의 자리수를 붙인다
						bufNum = bufNum & Mid(JRs(0), 4, Len(JRs(0))) + 1
						
						'ATE + bufNum
						SET_Team(1) =  "ATE" & bufNum
						
					End IF	
						JRs.Close
					SET JRs = Nothing		
					
					'팀정보 테이블[tblTeamInfo] 등록
					JSQL =  "INSERT INTO [SD_Tennis].[dbo].[tblTeamInfo] (" 
					JSQL = JSQL & "[SportsGb]" 
					JSQL = JSQL & ",[EnterType]" 
					JSQL = JSQL & ",[Team]" 
					JSQL = JSQL & ",[TeamNm]" 
					JSQL = JSQL & ",[Sex]" 
					JSQL = JSQL & ",[TeamLoginPwd]"
					JSQL = JSQL & ",[TeamRegDt]" 
					JSQL = JSQL & ",[DelYN]" 
					JSQL = JSQL & ",[NowRegYN]" 
					JSQL = JSQL & ",[WriteDate]" 
					JSQL = JSQL & ") VALUES( '"&SportsGb&"'" 
					JSQL = JSQL & "	,'"&EnterType&"'" 
					JSQL = JSQL & "	,'"&SET_Team(1)&"'" 
					JSQL = JSQL & "	,'"&SET_Team(2)&"'" 
					JSQL = JSQL & "	,3" 
					JSQL = JSQL & "	,'"&SET_Team(1)&"'" 
					JSQL = JSQL & "	,'"&replace(left(now(), 10),"-","")&"'" 
					JSQL = JSQL & "	,'N'" 
					JSQL = JSQL & "	,'Y'"
					JSQL = JSQL & "	,GETDATE()" 
					JSQL = JSQL & ")" 
	
					DBCon.Execute(JSQL)	
					ErrorNum = ErrorNum + Dbcon.Errors.Count	
					
	
				End IF	
					LRs.Close
				SET LRs = Nothing
			Else
				SET_Team(1) = ""	'소속팀 코드
				SET_Team(2) = ""	'소속팀 명
			End IF
			
			
				
			'소속팀정보 배열로 전달
			INSERT_TEAM_INFO = SET_Team				
	
		END FUNCTION
		
		
		
		
		'===========================================================================================================
		'선수 테이블[tblPlayer]  선수 등록 여부 체크 및 등록처리
		'===========================================================================================================
		'val1=UserName, val2=UserPhone, val3=Birthday, val4=Gender, val5=P1_TeamNmOne, val6=P1_TeamNmTwo
		FUNCTION INSERT_PLAYER_INFO(val1, val2, val3, val4, val5, val6)
			
			LSQL = "		SELECT PlayerIDX "
			LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblPlayer]"						
			LSQL = LSQL & " WHERE DelYN = 'N'"
			LSQL = LSQL & " 	AND SportsGb = '"&SportsGb&"'"
			LSQL = LSQL & " 	AND EnterType = '"&EnterType&"'"
			LSQL = LSQL & " 	AND UserName = '"&val1&"'"
			LSQL = LSQL & " 	AND replace(UserPhone,'-','') = '"&val2&"'"
			LSQL = LSQL & " 	AND Sex = '"&val4&"'"		
			IF val3<>"" Then LSQL = LSQL & " AND replace(Birthday,'-','') = '"&val3&"'"
			
			SET LRs = DBCon.Execute(LSQL)	
			IF Not(LRs.Eof OR LRs.Bof) Then
				PlayerIDX = LRs(0)
			Else
				'등록된 선수정보가 없는 경우 신규등록처리
				
				'===============================================================================================
				'선수 테이블[tblPlayer] PersonCode 값 조회
				'===============================================================================================
				JSQL = "		SELECT ISNULL(MAX(PersonCode), '') PersonCode "
				JSQL = JSQL & " FROM [SD_Tennis].[dbo].[tblPlayer]"						
				JSQL = JSQL & " WHERE SportsGb = '"&SportsGb&"'"
				JSQL = JSQL & " 	AND PersonCode like 'ATE%'"				
				
				SET JRs = DBCon.Execute(JSQL)	
				IF JRs(0) = "" Then
					'선수 체육인번호
					PersonCode = "ATE" & Right(Year(Date()),2) & "000000001"							
				Else
					
					bufNum = ""
					
					'ex) ATE17000000012
					'ATE17을 제외한 나머지 숫자에 1을 더한 숫자의 자리수와 ATE17의 자리수(5)를 뺀 자릿수 만큼 0을 붙인다
					
					For j = 1 to Len(JRs(0)) - len(Mid(JRs(0), 6, Len(JRs(0))) + 1) - 5
						bufNum = bufNum & "0"
					Next
					
					'ATE17 이후의 숫자에 1을 더한 수를 구한 후 만든 0의 자리수를 붙인다
					bufNum = bufNum & Mid(JRs(0), 6, Len(JRs(0))) + 1
					
					'ATE + 년도(2자리) + bufNum
					PersonCode =  "ATE" & Right(Year(Date()),2) & bufNum
					
				End IF	
					JRs.Close
				
				'선수테이블[tblPlayer] 등록
				JSQL =  "		INSERT INTO [SD_Tennis].[dbo].[tblPlayer] (" 
				JSQL = JSQL & "		[SportsGb]" 
				JSQL = JSQL & "		,[PlayerGb]" 
				JSQL = JSQL & "		,[UserName]" 
				JSQL = JSQL & "		,[UserPhone]" 
				JSQL = JSQL & "		,[Birthday]" 
				JSQL = JSQL & "		,[Sex]" 
				JSQL = JSQL & "		,[PersonCode]" 
				JSQL = JSQL & "		,[PlayerType]" 
				JSQL = JSQL & "		,[EnterType]" 
				JSQL = JSQL & "		,[Team]" 
				JSQL = JSQL & "		,[TeamNm]" 
				JSQL = JSQL & " 	,[Team2]"
				JSQL = JSQL & " 	,[Team2Nm]" 
				JSQL = JSQL & "		,[Member_YN]" 
				JSQL = JSQL & "		,[Auth_YN]" 									
				JSQL = JSQL & "		,[DelYN]" 
				JSQL = JSQL & "		,[RegTp]" 
				JSQL = JSQL & "		,[NowRegYN]" 
				JSQL = JSQL & "		,[WriteDate]" 
				JSQL = JSQL & "	) VALUES( '"&SportsGb&"'" 
				JSQL = JSQL & "		,'te039001'" 
				JSQL = JSQL & "		,'"&val1&"'" 
				JSQL = JSQL & "		,'"&val2&"'" 
				JSQL = JSQL & "		,'"&val3&"'" 
				JSQL = JSQL & "		,'"&val4&"'" 
				JSQL = JSQL & "		,'"&PersonCode&"'" 
				JSQL = JSQL & "		,'te045001'" 
				JSQL = JSQL & "		,'"&EnterType&"'" 
				JSQL = JSQL & "		,'"&val5(1)&"'" 
				JSQL = JSQL & "		,'"&val5(2)&"'" 
				JSQL = JSQL & "		,'"&val6(1)&"'" 
				JSQL = JSQL & "		,'"&val6(2)&"'" 
				JSQL = JSQL & "		,'N'" 
				JSQL = JSQL & "		,'N'" 									
				JSQL = JSQL & "		,'N'" 
				JSQL = JSQL & "		,'A'" 
				JSQL = JSQL & "		,'Y'"
				JSQL = JSQL & "		,GETDATE()" 
				JSQL = JSQL & "	)" 				
				
				DBCon.Execute(JSQL)	
				ErrorNum = ErrorNum + Dbcon.Errors.Count	
				
				
				'등록한 선수IDX 조회
				JSQL = "		SELECT PlayerIDX "
				JSQL = JSQL & " FROM [SD_Tennis].[dbo].[tblPlayer]"						
				JSQL = JSQL & " WHERE DelYN = 'N'"
				JSQL = JSQL & " 	AND SportsGb = '"&SportsGb&"'"
				JSQL = JSQL & " 	AND EnterType = '"&EnterType&"'"
				JSQL = JSQL & " 	AND UserName = '"&val1&"'"
				JSQL = JSQL & " 	AND UserPhone = '"&val2&"'"
				JSQL = JSQL & " 	AND Sex = '"&val4&"'"			
				IF val3<>"" Then JSQL = JSQL & " AND replace(Birthday,'-','') = '"&val3&"'"
				
				SET JRs = DBCon.Execute(JSQL)	
				IF Not(JRs.Eof OR JRs.Bof) Then
					PlayerIDX = JRs(0)
				End IF
					JRs.Close
				SET JRs = Nothing
				
			End IF	
				LRs.Close
			SET LRs = Nothing
			
			'선수IDX 반환
			INSERT_PLAYER_INFO = PlayerIDX		
			
		END FUNCTION
		
		
		
		
		'===========================================================================================================
		'대회참가자 정보 테이블 [tblRPlayerMaster] 대회참가자 정보등록처리
		'val1 = P1_PlayerIDX, val2 = P1_UserName, val3 = P1_Team, val4 = P1_Team2, val5 = P1_GenderIDX
		'val6 = TeamGb, val7 = Fnd_GameTitle, val8 = RequestGroupNum, val9 = TeamGroupNum
		'===========================================================================================================
		FUNCTION INSERT_RPLAYER_INFO(val1, val2, val3, val4, val5, val6, val7, val8, val9)
			dim TeamGroupNum
			dim val_groupNum	'팀그룹번호 P1_Player = P2_Player 업데이트
			
			'같은 팀원 구분자 생성
			IF val9 <> "" Then
				'val9[TeamGroupNum] 값이 있는 경우는 
				'P1_PlayerIDX 값이 포함되어 있기 때문에 P2_Player에게 P1의 IDX값을 업데이트 시키므로 P1의 파트너임을 구분.
				TeamGroupNum = val9 & "-" & val1
			Else
				'val9[TeamGroupNum] 값이 있는 경우는 P1_Player 이다
				TeamGroupNum = val1
			End IF
			
			'해당 대회 참가종목 상세 IDX 조회 RGameLevelIDX
			LSQL = "  		SELECT RGameLevelIDX "
			LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblRGameLevel] "
			LSQL = LSQL & " WHERE DelYN = 'N' "
			LSQL = LSQL & "		AND SportsGb = '"&SportsGb&"' "
			LSQL = LSQL & " 	AND GameTitleIDX = '"&val7&"' "
			LSQL = LSQL & " 	AND Level = '"&val6&"' "
			
			SET LRs = DBcon.Execute(LSQL)
			IF Not(LRs.Eof OR LRs.Bof) Then
				RGameLevelIDX =  LRs(0)
			End IF
				LRs.Close
				
			LSQL = " 		INSERT INTO [SD_Tennis].[dbo].[tblRPlayerMaster] ( "
			LSQL = LSQL & "		 PlayerIDX "
			LSQL = LSQL & "		,UserName"
			LSQL = LSQL & "		,Team"
			LSQL = LSQL & "		,TeamNm"
			LSQL = LSQL & "		,Team2"
			LSQL = LSQL & "		,Team2Nm"
			LSQL = LSQL & "		,SportsGb"
			LSQL = LSQL & "		,Sex"
			LSQL = LSQL & "		,RGameLevelIDX"			
			LSQL = LSQL & "		,Level"
			LSQL = LSQL & "		,GameTitleIDX"
			LSQL = LSQL & "		,RequestGroupNum"
			LSQL = LSQL & "		,TeamGroupNum"
			LSQL = LSQL & "		,WriteDate "
			LSQL = LSQL & "		,EditDate"
			LSQL = LSQL & "		,DelYN )"
			LSQL = LSQL & "	OUTPUT INSERTED.TeamGroupNum "
			LSQL = LSQL & " VALUES ( "
			LSQL = LSQL & "		'"&val1&"'"
			LSQL = LSQL & "		,'"&val2&"'"
			LSQL = LSQL & "		,'"&val3(1)&"'"
			LSQL = LSQL & "		,'"&val3(2)&"'"
			LSQL = LSQL & "		,'"&val4(1)&"'"
			LSQL = LSQL & "		,'"&val4(2)&"'"
			LSQL = LSQL & "		,'"&SportsGb&"'"
			LSQL = LSQL & "		,'"&val5&"'"
			LSQL = LSQL & "		,'"&RGameLevelIDX&"'"	
			LSQL = LSQL & "		,'"&val6&"'"			
			LSQL = LSQL & "		,'"&val7&"'"
			LSQL = LSQL & "		,'"&val8&"'"
			LSQL = LSQL & "		,'"&TeamGroupNum&"'"
			LSQL = LSQL & "		,GETDATE()"
			LSQL = LSQL & "		,GETDATE()"
			LSQL = LSQL & "		,'N'"
			LSQL = LSQL & "	)"
			
			SET LRs = DBcon.Execute(LSQL)			
			IF NOT(LRs.Bof OR LRs.Eof) Then
				val_groupNum = LRs(0)	
			End IF
				LRs.Close
				
			
			'같은팀원임을 구분하기 위한 P1_PlayerIDX 값 리턴
			IF val9 = "" Then
				INSERT_RPLAYER_INFO = val1	
			Else
				txtGropuNum = Split(val_groupNum, "-")

				LSQL = " 		UPDATE [SD_Tennis].[dbo].[tblRPlayerMaster] "	
				LSQL = LSQL & "	SET TeamgroupNum = '"&val_groupNum&"'"
				LSQL = LSQL & "	WHERE PlayerIDX = '"&txtGropuNum(0)&"'"
					
				DBcon.Execute(LSQL)
				ErrorNum = ErrorNum + DBcon.Errors.Count
				
			End IF
			
		END FUNCTION
		'===========================================================================================================
		
		
		
		'===========================================================================================================
		'대회 참가신청한 참가자, 파트너에게 신청동의를 받기위한 개별 문자발송(url 정보포함)
		'SMS_AGREE_PROC(SMS_Phone, SMS_ReVal, SMS_MsgEach, SMS_Subject)
		'===========================================================================================================		
		FUNCTION SMS_AGREE_PROC(val1, val2, val3, val4)
			
			dim txt_ValSMS		'발송전화번호	
			dim txt_ValINFO		'신청동의 리턴정보	
			dim txt_Msg
			
			txt_ValSMS = Split(val1, "|")	
			txt_ValINFO = Split(val2, "|")	
			
            response.Write "<script>"
			response.Write "	function on_Submit(valPhone, valContents){"
			response.Write "		var strAjaxUrl = 'http://biz.moashot.com/EXT/URLASP/mssendutf.asp';"
			response.Write "		$.ajax({"
			response.Write "			url: strAjaxUrl,"
			response.Write "			type: 'POST',"
			response.Write "			dataType: 'html',"
			response.Write "			contentType: 'application/x-www-form-urlencoded; charset=utf-8',"
			response.Write "			data: { "
			response.Write "				uid			: 'rubin500'"
			response.Write "				,pwd		: 'rubin0907'"
			response.Write "				,commType	: 0"
			response.Write "				,sendType	: 5"
			response.Write "				,fromNumber	: '027040282'"
			response.Write "				,nType		: 4"
			response.Write "				,returnType	: 0"
			response.Write "				,indexCode	: '"&now()&"'"
			response.Write "				,title		: '"&val4&"'"
			response.Write "				,toNumber	: valPhone"
			response.Write "				,contents	: valContents"
			response.Write "			}"
			response.Write "		});"
			response.Write "	}"
			response.Write "</script>"
			
			FOR i = 1 To UBOUND(txt_ValSMS)
			
				txt_Msg = replace(val3, "{UserInfoEach}", encode(txt_ValINFO(i), 0))		'참가자 정보
				txt_Msg = replace(txt_Msg, "\n", "&#13;")
				txt_Msg = replace(txt_Msg, "&#13;", "\r\n")

				IF txt_ValSMS(i) <> "" Then
				
					response.Write "<script>on_Submit('"&txt_ValSMS(i)&"','"&txt_Msg&"');</script>"

				End IF
				
			NEXT	
			
'			SMS_AGREE_PROC = "TRUE"
			
		END FUNCTION
		'===========================================================================================================
		
		
		
		
		IF act = "MOD" Then
		
			'기존 참가신청 정보 삭제
			CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblGameRequest] "
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&Fnd_GameTitle&"'"
			CSQL = CSQL & " 	AND RequestGroupNum = '"&RequestGroupNum&"'"
			CSQL = CSQL & " 	AND Level = '"&TeamGb&"'"
			
			DBcon.Execute (CSQL)
			ErrorNum = ErrorNum + DBcon.Errors.Count	
			
			'기존 참가신청 참가자정보 삭제
			CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblRPlayerMaster]"
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&Fnd_GameTitle&"'"
			CSQL = CSQL & " 	AND RequestGroupNum = '"&RequestGroupNum&"'"
			
			DBcon.Execute (CSQL)
			ErrorNum = ErrorNum + DBcon.Errors.Count
			
		End IF
				
			
				
		'참가신청 그룹 번호 조회 및 생성(참가신청서 Group IDX)
		CSQL = "		SELECT ISNULL(MAX(RequestGroupNum), 0) RGroupNum"
		CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] "
		SET CRs = DBCon.Execute(CSQL)	
		IF Not(CRs.Eof OR CRs.Bof) Then						
			RGroupNum = Cint(CRs("RGroupNum")) + 1
		End IF	
			CRs.Close
		SET CRs = Nothing
		
		
		'=======================================================================================================================			
		'참가자, 파트너 신청정보 등록
		'=======================================================================================================================
		FOR i = 1 to request("P1_UserName").count
			
			'============================================================================================
			'참가자1
			'============================================================================================
			P1_UserName 	= fInject(Trim(request("P1_UserName")(i)))
			P1_UserLevel 	= fInject(request("P1_UserLevel")(i))
			P1_UserPhone1 	= fInject(request("P1_UserPhone1")(i))
			P1_UserPhone2 	= fInject(request("P1_UserPhone2")(i))
			P1_UserPhone3 	= fInject(request("P1_UserPhone3")(i))
			P1_Birthday 	= fInject(request("P1_Birthday")(i))
			P1_TeamNmOne 	= fInject(Trim(request("P1_TeamNmOne_"&i)))
			P1_TeamNmTwo 	= fInject(Trim(request("P1_TeamNmTwo_"&i)))
			P1_GenderIDX	= fInject(request("P1_GenderIDX")(i))
'			P1_Gender 		= fInject(request("P1_Gender_"&i))			
			'============================================================================================
			'참가자 2
			'============================================================================================
			P2_UserName 	= fInject(Trim(request("P2_UserName")(i)))
			P2_UserLevel 	= fInject(request("P2_UserLevel")(i))
			P2_UserPhone1 	= fInject(request("P2_UserPhone1")(i))
			P2_UserPhone2 	= fInject(request("P2_UserPhone2")(i))
			P2_UserPhone3 	= fInject(request("P2_UserPhone3")(i))
			P2_Birthday 	= fInject(request("P2_Birthday")(i))
			P2_TeamNmOne 	= fInject(Trim(request("P2_TeamNmOne_"&i)))
			P2_TeamNmTwo 	= fInject(Trim(request("P2_TeamNmTwo_"&i)))
			P2_GenderIDX	= fInject(request("P2_GenderIDX")(i))
'			P2_Gender 		= fInject(request("P2_Gender_"&i))			
			
'			response.Write "P1_GenderIDX_"&i&"="&P1_GenderIDX&"<br>"
'			response.Write "P2_GenderIDX_"&i&"="&P2_GenderIDX&"<br>"
			
			'============================================================================================
			'팀정보테이블[tblTeamInfo]  팀정보 등록 여부 체크 및 등록처리
			'============================================================================================
			P1_Team			= INSERT_TEAM_INFO(P1_TeamNmOne)		'팀소속1배열[소속코드, 소속명]					
			P1_Team2		= INSERT_TEAM_INFO(P1_TeamNmTwo)		'팀소속1배열2[소속코드, 소속명]
			P2_Team			= INSERT_TEAM_INFO(P2_TeamNmOne)		'팀소속2배열[소속코드, 소속명]
			P2_Team2		= INSERT_TEAM_INFO(P2_TeamNmTwo)		'팀소속2배열2[소속코드, 소속명]
			'============================================================================================
			'선수 테이블[tblPlayer]  선수 등록 여부 체크 및 등록처리	
			'============================================================================================
			P1_PlayerIDX 	= INSERT_PLAYER_INFO(P1_UserName, P1_UserPhone1&P1_UserPhone2&P1_UserPhone3, P1_Birthday, P1_GenderIDX, P1_Team, P1_Team2)	
			P2_PlayerIDX 	= INSERT_PLAYER_INFO(P2_UserName, P2_UserPhone1&P2_UserPhone2&P2_UserPhone3, P2_Birthday, P2_GenderIDX, P2_Team, P2_Team2)
			
			
			'============================================================================================
			'SMS_UserNm : SMS 발송을 위한 참가자, 파트너 목록 - 이름
			'SMS_Phone : 신규 입력정보일때만 문자메세지 발송 전화번호 수집 
				'- write
				'- modify 신규 추가 입력정보 해당 
				'	1팀일 경우 			request("val_RequestIDX") = NULL
				'	1팀일 이상일 경우 	request("val_RequestIDX")(i) = NULL
			'============================================================================================			
			'SMS발송을 위한 메세지와 발송 전화번호 수집
			'============================================================================================
			'수정페이지
			IF act = "MOD" Then
				'신규입력의 경우
				'참가팀 수 1팀의 경우
				IF request("Cnt_Entry") = 1 Then
					
					IF request("val_RequestIDX") = "" Then	
						'SMS 발송 메세지 참가신청자 목록 - 참가자, 파트너 이름
						SMS_UserNm 	= SMS_UserNm & "|" & P1_UserName &"("&P1_Team(2)
						IF P1_Team2(2)<>"" Then SMS_UserNm 	= SMS_UserNm &","&P1_Team2(2)
						SMS_UserNm 	= SMS_UserNm &")"& "|" & P2_UserName &"("&P2_Team(2)
						IF P2_Team2(2)<>"" Then SMS_UserNm 	= SMS_UserNm &","&P2_Team2(2)
						SMS_UserNm 	= SMS_UserNm &")"
						
						'SMS 발송 참가자, 파트너 전화번호
						SMS_Phone 	= SMS_Phone	 & "|" & P1_UserPhone1&P1_UserPhone2&P1_UserPhone3 & "|" & P2_UserPhone1&P2_UserPhone2&P2_UserPhone3	
						'SMS 발송 참가자, 파트너 신청동의를 받기 위한 참가자, 파트너 정보
						SMS_ReVal 	= SMS_ReVal	 & "|" &P1_PlayerIDX&","& P1_UserPhone1&P1_UserPhone2&P1_UserPhone3 & "|" &P2_PlayerIDX&","& P2_UserPhone1&P2_UserPhone2&P2_UserPhone3
					End IF
				'참가팀 1개팀 이상인 경우
				Else

					IF request("val_RequestIDX")(i) = "" Then	
						'SMS 발송 메세지 참가신청자 목록 - 참가자, 파트너 이름
						SMS_UserNm 	= SMS_UserNm & "|" & P1_UserName &"("&P1_Team(2)
						IF P1_Team2(2)<>"" Then SMS_UserNm 	= SMS_UserNm &","&P1_Team2(2)
						SMS_UserNm 	= SMS_UserNm &")"& "|" & P2_UserName &"("&P2_Team(2)
						IF P2_Team2(2)<>"" Then SMS_UserNm 	= SMS_UserNm &","&P2_Team2(2)
						SMS_UserNm 	= SMS_UserNm &")"
						'SMS 발송 참가자, 파트너 전화번호
						SMS_Phone 	= SMS_Phone	 & "|" & P1_UserPhone1&P1_UserPhone2&P1_UserPhone3 & "|" & P2_UserPhone1&P2_UserPhone2&P2_UserPhone3	
						'SMS 발송 참가자, 파트너 신청동의를 받기 위한 참가자, 파트너 정보
						SMS_ReVal 	= SMS_ReVal	 & "|" &P1_PlayerIDX&","& P1_UserPhone1&P1_UserPhone2&P1_UserPhone3 & "|" &P2_PlayerIDX&","& P2_UserPhone1&P2_UserPhone2&P2_UserPhone3
					End IF
				End IF	

		
			'작성페이지	
			Else

				'SMS 발송 메세지 참가신청자 목록 - 참가자, 파트너 이름
				SMS_UserNm 	= SMS_UserNm & "|" & P1_UserName &"("&P1_Team(2)
				IF P1_Team2(2)<>"" Then SMS_UserNm 	= SMS_UserNm &","&P1_Team2(2)
				SMS_UserNm 	= SMS_UserNm &")"& "|" & P2_UserName &"("&P2_Team(2)
				IF P2_Team2(2)<>"" Then SMS_UserNm 	= SMS_UserNm &","&P2_Team2(2)
				SMS_UserNm 	= SMS_UserNm &")"
				'SMS 발송 참가자, 파트너 전화번호
				SMS_Phone 	= SMS_Phone	 & "|" & P1_UserPhone1&P1_UserPhone2&P1_UserPhone3 & "|" & P2_UserPhone1&P2_UserPhone2&P2_UserPhone3	
				'SMS 발송 참가자, 파트너 신청동의를 받기 위한 참가자, 파트너 정보
				SMS_ReVal 	= SMS_ReVal	 & "|" &P1_PlayerIDX&","& P1_UserPhone1&P1_UserPhone2&P1_UserPhone3 & "|" &P2_PlayerIDX&","& P2_UserPhone1&P2_UserPhone2&P2_UserPhone3
				
			End IF		
			
			'============================================================================================
			'대회참가자 신청정보 등록
			'============================================================================================
			CSQL = " 		INSERT INTO [SD_Tennis].[dbo].[tblGameRequest] ( "
			CSQL = CSQL & "		 SportsGb "
			CSQL = CSQL & "		,GameTitleIDX"
			CSQL = CSQL & "		,Level"
			CSQL = CSQL & "		,RequestGroupNum"
			CSQL = CSQL & "		,EnterType"
			CSQL = CSQL & "		,UserPass"
			CSQL = CSQL & "		,UserName"
			CSQL = CSQL & "		,UserPhone"
			CSQL = CSQL & "		,txtMemo"
			CSQL = CSQL & "		,PaymentDt"
			CSQL = CSQL & "		,PaymentNm"
			CSQL = CSQL & "		,PaymentType "
			CSQL = CSQL & "		,WriteDate "				
			CSQL = CSQL & "		,WorkDate "				
			CSQL = CSQL & "		,P1_PlayerIDX "				
			CSQL = CSQL & "		,P1_UserName "				
			CSQL = CSQL & "		,P1_UserLevel "				
			CSQL = CSQL & "		,P1_TeamNm "				
			CSQL = CSQL & "		,P1_TeamNm2 "				
			CSQL = CSQL & "		,P1_UserPhone "				
			CSQL = CSQL & "		,P1_Birthday "				
			CSQL = CSQL & "		,P1_SEX "				
			CSQL = CSQL & "		,P2_PlayerIDX "				
			CSQL = CSQL & "		,P2_UserName "				
			CSQL = CSQL & "		,P2_UserLevel "				
			CSQL = CSQL & "		,P2_TeamNm "				
			CSQL = CSQL & "		,P2_TeamNm2 "				
			CSQL = CSQL & "		,P2_UserPhone "				
			CSQL = CSQL & "		,P2_Birthday "						
			CSQL = CSQL & "		,P2_SEX "	
			CSQL = CSQL & "		,DelYN )"
			CSQL = CSQL & " VALUES ( "
			CSQL = CSQL & "		'"&SportsGb&"'"
			CSQL = CSQL & "		,'"&Fnd_GameTitle&"'"
			CSQL = CSQL & "		,'"&TeamGb&"'"
			CSQL = CSQL & "		,'"&RGroupNum&"'"
			CSQL = CSQL & "		,'"&EnterType&"'"
			CSQL = CSQL & "		,'"&UserPass&"'"
			CSQL = CSQL & "		,'"&UserName&"'"
			CSQL = CSQL & "		,'"&UserPhone1&"-"&UserPhone2&"-"&UserPhone3&"'"
			CSQL = CSQL & "		,'"&txtMemo&"'"
			CSQL = CSQL & "		,'"&PaymentDt&"'"
			CSQL = CSQL & "		,'"&PaymentNm&"'"
			CSQL = CSQL & "		,'N'"				'입금확인 Y확인, N미입금, F환불
			CSQL = CSQL & "		,GETDATE()"
			CSQL = CSQL & "		,GETDATE()"
			CSQL = CSQL & "		,'"&P1_PlayerIDX&"'"
			CSQL = CSQL & "		,'"&P1_UserName&"'"
			CSQL = CSQL & "		,'"&P1_UserLevel&"'"
			CSQL = CSQL & "		,'"&P1_TeamNmOne&"'"
			CSQL = CSQL & "		,'"&P1_TeamNmTwo&"'"
			CSQL = CSQL & "		,'"&P1_UserPhone1&"-"&P1_UserPhone2&"-"&P1_UserPhone3&"'"
			CSQL = CSQL & "		,'"&P1_Birthday&"'"
			CSQL = CSQL & "		,'"&P1_GenderIDX&"'"
			CSQL = CSQL & "		,'"&P2_PlayerIDX&"'"
			CSQL = CSQL & "		,'"&P2_UserName&"'"
			CSQL = CSQL & "		,'"&P2_UserLevel&"'"
			CSQL = CSQL & "		,'"&P2_TeamNmOne&"'"
			CSQL = CSQL & "		,'"&P2_TeamNmTwo&"'"
			CSQL = CSQL & "		,'"&P2_UserPhone1&"-"&P2_UserPhone2&"-"&P2_UserPhone3&"'"
			CSQL = CSQL & "		,'"&P2_Birthday&"'"
			CSQL = CSQL & "		,'"&P2_GenderIDX&"'"
			CSQL = CSQL & "		,'N')"
			
					
			DBcon.Execute(CSQL)
			ErrorNum = ErrorNum + Dbcon.Errors.Count

			
			'============================================================================================
			'대회참가자 정보 [tblRPlayerMaster] 등록(INSERT)
			'============================================================================================
			P1_Master = INSERT_RPLAYER_INFO(P1_PlayerIDX, P1_UserName, P1_Team, P1_Team2, P1_GenderIDX, TeamGb, Fnd_GameTitle, RGroupNum, "")
			P2_Master = INSERT_RPLAYER_INFO(P2_PlayerIDX, P2_UserName, P2_Team, P2_Team2, P2_GenderIDX, TeamGb, Fnd_GameTitle, RGroupNum, P1_Master)
			'============================================================================================
			'참가신청자 정보 데이터 초기화
			P1_UserName 	= ""
			P1_UserLevel 	= ""
			P1_UserPhone1 	= ""
			P1_UserPhone2 	= ""
			P1_UserPhone3 	= ""
			P1_Birthday 	= ""
			P1_TeamNmOne 	= ""
			P1_TeamNmTwo 	= ""
			P1_GenderIDX	= ""
			P1_PlayerIDX 	= ""
			P2_UserName 	= ""
			P2_UserLevel 	= ""
			P2_UserPhone1 	= ""
			P2_UserPhone2 	= ""
			P2_UserPhone3 	= ""
			P2_Birthday 	= ""
			P2_TeamNmOne 	= ""
			P2_TeamNmTwo 	= ""
			P2_GenderIDX	= ""
			P2_PlayerIDX 	= ""
			'============================================================================================
		NEXT


		dim val_RGameLevelIDX	'Level IDX 값
		'==================================================================================
		'최종적으로 tblRGameLevel 테이블의 Level의 [TotRound], [attmembercnt] 값을 업데이트 한다
		'==================================================================================
		'해당 대회 참가종목 상세 IDX 조회 RGameLevelIDX
		CSQL = "  		SELECT RGameLevelIDX "
		CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblRGameLevel] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
		CSQL = CSQL & " 	AND GameTitleIDX = '"&Fnd_GameTitle&"' "
		CSQL = CSQL & " 	AND Level = '"&TeamGb&"' "
		
		SET CRs = DBcon.Execute(CSQL)
		IF NOT(CRs.Eof OR CRs.Bof) Then
			val_RGameLevelIDX = CRs(0)
		End IF
			CRs.Close
		'==================================================================================
		'해당선수 업데이트후 강수(TotRound) 조회하여 업데이트 처리 
		'==================================================================================
'		CSQL = "  		SELECT COUNT(RPlayerMasterIDX)/2 Cnt "			'count-참가자(복식)
'		CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblRPlayerMaster] "
'		CSQL = CSQL & " WHERE  DelYN = 'N'"
'		CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
'		CSQL = CSQL & "		AND GameTitleIDX = '"&Fnd_GameTitle&"' "
'		CSQL = CSQL & "		AND RGameLevelIDX = '"&val_RGameLevelIDX&"' "

		CSQL = "  		SELECT COUNT(A.TeamGroupNum) Cnt "			'count-참가자(팀)
		CSQL = CSQL & " FROM ("
		CSQL = CSQL & " 	SELECT TeamGroupNum"
		CSQL = CSQL & " 	FROM [SD_Tennis].[dbo].[tblRPlayerMaster] "
		CSQL = CSQL & " 	WHERE  DelYN = 'N'"
		CSQL = CSQL & "			AND SportsGb = '"&SportsGb&"' "
		CSQL = CSQL & "			AND GameTitleIDX = '"&Fnd_GameTitle&"' "
		CSQL = CSQL & "			AND RGameLevelIDX = '"&val_RGameLevelIDX&"' "
		CSQL = CSQL & " 	GROUP BY TeamGroupNum"
		CSQL = CSQL & " ) A"
		
'		RESPONSE.Write CSQL&"<br><br>"
		
		SET JRs = DBcon.Execute(CSQL)
		ErrorNum = ErrorNum + DBcon.Errors.Count
		
		
		'강수 구하기
		TotRound = chk_TotRound(JRs("Cnt"))
			
		
		CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblRGameLevel] "
		CSQL = CSQL & " SET TotRound = '"&TotRound&"'"
		CSQL = CSQL & " 	, attmembercnt = '"&JRs("Cnt")&"'"
		CSQL = CSQL & " WHERE RGameLevelIDX = '"&val_RGameLevelIDX&"' "
		
'		RESPONSE.Write CSQL&"<br><br>"
'		RESPONSE.End()

		DBcon.Execute(CSQL)
		ErrorNum = ErrorNum + DBcon.Errors.Count	

		JRs.Close
		'==================================================================================
		
		
		IF ErrorNum > 0 Then
			DBcon.RollbackTrans()
			
			response.Write "<script>"
			IF act = "MOD" Then
				response.Write "	alert('대회 참가신청 정보수정을 완료하지 못하였습니다. 확인 후 다시 시도하세요');"
			Else
				response.Write "	alert('대회 참가신청이 완료되지 못하였습니다. 확인 후 다시 신청하세요');"
			End IF
			response.Write "	history.back();"
			response.Write "</script>"
			
		Else	
			
			DBcon.CommitTrans()
			
			'==========================================================================================
			'참가자/파트너 참가등록 확인 문자발송
			'==========================================================================================
			dim PlayerInfo
			'==========================================================================================
			'발송 메세지 만들기
			'==========================================================================================
			
			SMS_Msg = "[스포츠다이어리] 테니스 대회 참가신청 안내\n\n"
			SMS_Msg = SMS_Msg & "{SGameTitle} {SGameLevel}에 참가신청이 접수되었습니다.\n\n"
			SMS_Msg = SMS_Msg & "{PlayerInfo}\n"

			SMS_Msg = replace(SMS_Msg, "{SGameTitle}", SMS_GameTitleNm)		'대회타이틀 변환
			SMS_Msg = replace(SMS_Msg, "{SGameLevel}", SMS_GameLevel)		'대회참가종목 변환
			
			'참가자, 파트너 명단
			txt_SMSUser = Split(SMS_UserNm, "|")
			
			'수정시 신규추가 참가팀 정보만 추출하여 신청자에게 발송
			FOR x = 1 To UBOUND(txt_SMSUser)
				'홀수이면 참가자[P1_Player]					
				IF x mod 2 <> 0 Then	
					PlayerInfo = PlayerInfo & "- 참가자 : "&txt_SMSUser(x)&" / "
				'짝수이면 참가자[P2_Player]	
				Else  
					PlayerInfo = PlayerInfo & "파트너 : "&txt_SMSUser(x) &"\n"
				End IF
				
			NEXT		
			
			SMS_Msg = replace(SMS_Msg, "{PlayerInfo}", PlayerInfo)			'참가자 정보
			SMS_Msg = replace(SMS_Msg, "\n", "&#13;")						'줄바꿈 변환
					
			'==========================================================================================
			txt_SMSPhone = UserPhone1&UserPhone2&UserPhone3					'신청자 전화번호	
			
			dim SMS_AGREE
			
			'참가자, 파트너의 개별 신청동의 메세지와 URL 발송
			SMS_MsgEach = SMS_Msg & "아래 주소를 클릭하여 본인 확인을 해주셔야 대회 참가신청이 완료됩니다.\n"
			SMS_MsgEach = SMS_MsgEach & "http://tennis.sportsdiary.co.kr/tennis/request/req_comp.asp?UserInfo={UserInfoEach}"
			
			'참가자, 파트너에게 신청동의를 받기 위한 각각의 참가신청 접수내용과 동의를 받을 URL 발송
			SMS_AGREE = SMS_AGREE_PROC(SMS_Phone, SMS_ReVal, SMS_MsgEach, SMS_Subject)
			
			'신청자에게 참가자, 파트너의 정보를 포함한 신청접수완료에 대한 메세지 발송
			response.Write "<form id='form2' action='http://biz.moashot.com/EXT/URLASP/mssendutf.asp' method='post'>"
			response.Write "	<input type='hidden' name='uid' value='rubin500' />"
			response.Write "	<input type='hidden' name='pwd' value='rubin0907' />"
			response.Write "	<input type='hidden' name='commType' value='0' /><!--보안설정 0-일반,1-MD5-->"
			response.Write "	<input type='hidden' name='commCode' value='' /><!--보안코드(비밀번호를 MD5로 변환한값)-->"
			response.Write "	<input type='hidden' name='sendType' value='5' /><!--전송구분 3-단문문자, 5-LMS(장문문자), 6-MMS(Image포함문자) -->"
			response.Write "	<input type='hidden' name='title' value='"&SMS_Subject&"' /><!--전송제목-->"
			response.Write "	<input type='hidden' name='toNumber' id='toNumber' value='"&txt_SMSPhone&"' /><!--수신처 핸드폰 번호(동보 전송일 경우‘,’로 구분하여 입력)-->"
			response.Write "	<input type='hidden' name='contents' id='contents' value='"&SMS_Msg&"' /><!--전송할 문자나 MMS 내용(문자 80byte, MMS 2000byte)-->"
			response.Write "	<input type='hidden' name='fileName' value='' /><!--이미지 전송시 파일명(JPG이미지만 가능)-->"
			response.Write "	<input type='hidden' name='fromNumber' value='027040282' /><!--발신자 번호(휴대폰,일반전화 번호 가능)-->"
			response.Write "	<input type='hidden' name='nType' value='4' /><!--결과전송 타입 1. 전송건 접수 여부, 2. 전송건 성공 실패 여부(1~8), 3. 위 1,2 모두 확인, 4. 모두 확인 안함-->"
			response.Write "	<input type='hidden' name='indexCode' value='"&now()&"' /><!--전송건에 대한 고유 값(동보 전송일 경우 ‘,’로 구분하여 입력)-->"
			response.Write "	<input type='hidden' name='returnUrl' id='returnUrl' value='' /><!--전송결과를 호출 받을 웹 페이지의 URL주소-->"
			response.Write "	<input type='hidden' name='returnType' id='returnType' value='2' /><!--0 또는 NULL 호출페이지 Close, 1. 호출페이지 유지, 2. redirectUrl 에 입력한 경로로 이동합니다(Redirect)-->"
			response.Write "	<input type='hidden' name='redirectUrl' id='redirectUrl' value='http://tennis.sportsdiary.co.kr/tennis/request/list_repair.asp?currPage="&currPage&"&GameTitle="&Fnd_GameTitle&"&TeamGb="&TeamGb&"&Fnd_KeyWord="&Fnd_KeyWord&"' /><!--전송(접수)후 페이지 이동경로http:// 또는 https:// 를 포함한 풀경로를 입력합니다.-->"
			response.Write "</form>"
			
			response.Write "<script>"
			
			IF act = "MOD" Then
				response.Write " alert('대회 참가신청 정보수정이 완료되었습니다.');"
			Else
				response.Write " alert('대회 참가신청이 접수되었습니다.\n\n참가자(파트너 포함)에게 본인확인을 위한 메세지가 발송되었습니다.');"
			End IF	
			
			IF txt_SMSPhone <> "" Then
				response.Write " document.forms['form2'].submit(); "
			Else
				response.Write " location.replace('./list_repair.asp?currPage="&currPage&"&GameTitle="&Fnd_GameTitle&"&TeamGb="&TeamGb&"&Fnd_KeyWord="&Fnd_KeyWord&"');"	
			End IF
			
			response.Write "</script>"
			
			'==========================================================================================

		End IF
	End IF
	
%>