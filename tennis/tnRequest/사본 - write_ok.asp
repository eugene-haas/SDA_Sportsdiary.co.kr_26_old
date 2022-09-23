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
	dim RequestIDX		: RequestIDX 		= fInject(decode(request("RequestIDX"), 0))	'참가신청 수정시 	
	dim cntGameLvl		: cntGameLvl 		= fInject(request("cntGameLvl"))			'참가접수제한 수
	dim cntReqLvl		: cntReqLvl 		= fInject(request("cntReqLvl"))				'참가신청한 팀수
	
	'신청자 정보 
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
	
	'참가자	
	dim P1_PlayerIDX_Old: P1_PlayerIDX_Old 	= fInject(Trim(request("P1_PlayerIDX_Old")))
	dim P1_PlayerIDX	: P1_PlayerIDX 		= fInject(Trim(request("P1_PlayerIDX")))
	dim P1_UserName		: P1_UserName 		= fInject(Trim(request("P1_UserName")))
	dim P1_UserLevel	: P1_UserLevel 		= fInject(Trim(request("P1_UserLevel")))
	dim P1_UserPhone1	: P1_UserPhone1 	= fInject(Trim(request("P1_UserPhone1")))
	dim P1_UserPhone2	: P1_UserPhone2 	= fInject(Trim(request("P1_UserPhone2")))
	dim P1_UserPhone3	: P1_UserPhone3 	= fInject(Trim(request("P1_UserPhone3")))
	dim P1_Birthday		: P1_Birthday 		= fInject(Trim(request("P1_Birthday")))
	dim P1_Team			: P1_Team			= fInject(Trim(request("P1_TeamOne")))
	dim P1_TeamNm		: P1_TeamNm 		= fInject(Trim(request("P1_TeamNmOne_1")))
	dim P1_Team2		: P1_Team2			= fInject(Trim(request("P1_TeamTwo")))
	dim P1_TeamNm2		: P1_TeamNm2 		= fInject(Trim(request("P1_TeamNmTwo_1")))

	'파트너
	dim P2_PlayerIDX_Old: P2_PlayerIDX_Old 	= fInject(Trim(request("P2_PlayerIDX_Old")))
	dim P2_PlayerIDX	: P2_PlayerIDX 		= fInject(Trim(request("P2_PlayerIDX")))
	dim P2_UserName		: P2_UserName 		= fInject(Trim(request("P2_UserName")))
	dim P2_UserLevel	: P2_UserLevel 		= fInject(Trim(request("P2_UserLevel")))
	dim P2_UserPhone1	: P2_UserPhone1 	= fInject(Trim(request("P2_UserPhone1")))
	dim P2_UserPhone2	: P2_UserPhone2 	= fInject(Trim(request("P2_UserPhone2")))
	dim P2_UserPhone3	: P2_UserPhone3 	= fInject(Trim(request("P2_UserPhone3")))
	dim P2_Birthday		: P2_Birthday 		= fInject(Trim(request("P2_Birthday")))
	dim P2_Team			: P2_Team			= fInject(Trim(request("P2_TeamOne")))
	dim P2_TeamNm		: P2_TeamNm 		= fInject(Trim(request("P2_TeamNmOne_1")))
	dim P2_Team2		: P2_Team2			= fInject(Trim(request("P2_TeamTwo")))
	dim P2_TeamNm2		: P2_TeamNm2		= fInject(Trim(request("P2_TeamNmTwo_1")))	
	
	dim P1_UserPhone, P2_UserPhone	

	IF P1_UserPhone2 <> "" AND P1_UserPhone3 <> "" Then	P1_UserPhone = P1_UserPhone1&"-"&P1_UserPhone2&"-"&P1_UserPhone3
	IF P2_UserPhone2 <> "" AND P2_UserPhone3 <> "" Then	P2_UserPhone = P2_UserPhone1&"-"&P2_UserPhone2&"-"&P2_UserPhone3

	
'	response.Write "P1_UserName="&P1_UserName&"<br>"
'	response.Write "P1_PlayerIDX="&P1_PlayerIDX&"<br>"
'	response.Write "P1_UserPhone="&P1_UserPhone&"<br>"
'	response.Write "P1_TeamNm="&P1_TeamNm&"<br>"
'	response.Write "P1_TeamNm2="&P1_TeamNm2&"<br>"
'	response.Write "P1_Birthday="&P1_Birthday&"<br>"
'	response.Write "P1_UserPhone1="&request("P1_UserPhone1")&"<br>"
'	response.Write "P1_UserPhone2="&P1_UserPhone2&"<br>"
'	response.Write "P1_UserPhone3="&P1_UserPhone3&"<br>"
'	response.Write "P2_PlayerIDX="&P2_PlayerIDX&"<br>"
'	response.Write "P2_UserPhone="&P2_UserPhone&"<br>"
'	response.Write "P2_TeamNm="&P2_TeamNm&"<br>"
'	response.Write "P2_TeamNm2="&P2_TeamNm2&"<br>"
'	response.Write "P2_Birthday="&P2_Birthday&"<br>"
'	response.End
		
	'기본값 세팅
	dim SportsGb		: SportsGb			= "tennis"
	dim EnterType		: EnterType			= "A"
	
	dim LSQL, LRs, JSQL, JRs, CSQL, CRs
	dim RGroupNum				'참가신청 신규등록시 그룹번호
	dim TotRound	'강수
	dim P1_RPOINT, P2_RPOINT
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
	
	dim SMS_Msg				'SMS 발송 메세지
	dim SMS_MsgEach			'SMS 발송 메세지 [개별메시지]
	dim SMS_GameTitleNm 	'SMS 발송 대회명
	dim SMS_GameLevel		'SMS 발송 대회 참가종목	
	dim SMS_Subject			'SMS 발송 제목
	
	SMS_GameTitleNm	= fInject(request("SMS_GameTitleNm"))
	SMS_Subject		= "*** 대회 참가신청완료 알림메시지 ***"
	
	
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
		
		txt_Msg = replace(val3, "{UserInfoEach}", encode(val2, 0))		'참가자 정보
		txt_Msg = replace(txt_Msg, "\n", "&#13;")
		txt_Msg = replace(txt_Msg, "&#13;", "\r\n")

		IF val1 <> "" Then
		
			response.Write "<script>on_Submit('"&val1&"','"&txt_Msg&"');</script>"

		End IF
		
'		SMS_AGREE_PROC = "TRUE"
		
	END FUNCTION
	'===========================================================================================================
	'대회참가부의 참가자,파트너 랭킹포인트 조회 
	'===========================================================================================================
	FUNCTION PLAYER_RPOINT(valIDX)
		dim valPOINT	: valPOINT = 0
		
		IF valIDX <> "" Then
			LSQL = " 		SELECT ISNULL(rankpoint, 0) rankpoint "
			LSQL = LSQL & "	FROM [SD_Tennis].[dbo].[sd_TennisRPoint]"
			LSQL = LSQL & "	WHERE PlayerIDX = '"&valIDX&"'"
			LSQL = LSQL & "		AND TeamGb IN("
			LSQL = LSQL & "			SELECT L.TeamGb"
			LSQL = LSQL & "			FROM [SD_Tennis].[dbo].[tblLevelinfo] L"
			LSQL = LSQL & "				inner join [SD_Tennis].[dbo].[tblTeamGbinfo] T on L.TeamGb = T.TeamGb"
			LSQL = LSQL & "					AND T.DelYN = 'N'"
			LSQL = LSQL & "					AND T.SportsGb = '"&SportsGb&"'"
			LSQL = LSQL & "			WHERE L.DelYN = 'N'"
			LSQL = LSQL & "				AND L.SportsGb = '"&SportsGb&"'"
			LSQL = LSQL & "				AND L.Level = '"&TeamGb&"'"
			LSQL = LSQL & "		)"
			
			SET LRs = DBcon.Execute(LSQL)
			IF NOT(LRs.Eof OR LRs.Bof) Then
				valPOINT = LRs(0)
			End IF
				LRs.Close
			SET LRs = Nothing	
		End IF
		
		PLAYER_RPOINT = valPOINT

	END FUNCTION				
	'===========================================================================================================
	
	
	IF act = "" Then
		response.Write "<script>"
		response.Write "	alert('잘못된 접근입니다. 확인 후 이용하세요.');"
		response.Write "	history.back();"
		response.Write "<script>"
		response.End()
	Else
		
		On Error Resume Next
	
		DBcon.BeginTrans()
		
		
		'대회정보 참가종목(부) 및 지역 조회
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
		
		
		P1_RPOINT = PLAYER_RPOINT(P1_PlayerIDX)
		P2_RPOINT = PLAYER_RPOINT(P2_PlayerIDX)
		
		
		SELECT CASE act
		
		
		
			'대회참가자 신청정보 수정
			CASE "MOD" 
				
				CSQL = "		UPDATE [SD_Tennis].[dbo].[tblGameRequest] "
				CSQL = CSQL & "	SET UserName = '"&UserName&"'"
				CSQL = CSQL & "		,UserPhone = '"&UserPhone1&"-"&UserPhone2&"-"&UserPhone3&"'"
				CSQL = CSQL & "		,PaymentDt = '"&PaymentDt&"'"
				CSQL = CSQL & "		,PaymentNm = '"&PaymentNm&"'"
				CSQL = CSQL & "		,txtMemo = '"&txtMemo&"'"
				CSQL = CSQL & "		,P1_PlayerIDX = '"&P1_PlayerIDX&"'"
				CSQL = CSQL & "		,P1_UserName = '"&P1_UserName&"'"
				CSQL = CSQL & "		,P1_UserLevel = '"&P1_UserLevel&"'"
				CSQL = CSQL & "		,P1_UserPhone = '"&P1_UserPhone&"'"
				CSQL = CSQL & "		,P1_Birthday = '"&P1_Birthday&"'"
				CSQL = CSQL & "		,P1_Team = '"&P1_Team&"'"
				CSQL = CSQL & "		,P1_Team2 = '"&P1_Team2&"'"
				CSQL = CSQL & "		,P1_TeamNm = '"&P1_TeamNm&"'"
				CSQL = CSQL & "		,P1_TeamNm2 = '"&P1_TeamNm2&"'"
				CSQL = CSQL & "		,P1_RPOINT = '"&P1_RPOINT&"'"
				CSQL = CSQL & "		,P2_PlayerIDX = '"&P2_PlayerIDX&"'"
				CSQL = CSQL & "		,P2_UserName = '"&P2_UserName&"'"
				CSQL = CSQL & "		,P2_UserLevel = '"&P2_UserLevel&"'"
				CSQL = CSQL & "		,P2_UserPhone = '"&P2_UserPhone&"'"
				CSQL = CSQL & "		,P2_Birthday = '"&P2_Birthday&"'"
				CSQL = CSQL & "		,P2_Team = '"&P2_Team&"'"
				CSQL = CSQL & "		,P2_Team2 = '"&P2_Team2&"'"
				CSQL = CSQL & "		,P2_TeamNm = '"&P2_TeamNm&"'"
				CSQL = CSQL & "		,P2_TeamNm2 = '"&P2_TeamNm2&"'"
				CSQL = CSQL & "		,P2_RPOINT = '"&P2_RPOINT&"'"
				CSQL = CSQL & "		,updateip = '"&Request.ServerVariables("REMOTE_ADDR")&"'"
				CSQL = CSQL & "	WHERE DelYN = 'N' "
				CSQL = CSQL & "		AND Level = '"&TeamGb&"' "
				CSQL = CSQL & "		AND GameTitleIDX = '"&Fnd_GameTitle&"' " 
				CSQL = CSQL & "		AND RequestIDX = '"&RequestIDX&"' "
		
				DBcon.Execute(CSQL)
				ErrorNum = ErrorNum + Dbcon.Errors.Count
			
			
			'대회참가자 신청정보 등록	
			CASE "WR"
				
				
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
				CSQL = CSQL & "		,P1_Team "				
				CSQL = CSQL & "		,P1_TeamNm "	
				CSQL = CSQL & "		,P1_Team2 "				
				CSQL = CSQL & "		,P1_TeamNm2 "				
				CSQL = CSQL & "		,P1_UserPhone "				
				CSQL = CSQL & "		,P1_Birthday "				
				CSQL = CSQL & "		,P1_RPOINT"				
				CSQL = CSQL & "		,P2_PlayerIDX "				
				CSQL = CSQL & "		,P2_UserName "				
				CSQL = CSQL & "		,P2_UserLevel "				
				CSQL = CSQL & "		,P2_Team "				
				CSQL = CSQL & "		,P2_TeamNm "				
				CSQL = CSQL & "		,P2_Team2 "		
				CSQL = CSQL & "		,P2_TeamNm2 "				
				CSQL = CSQL & "		,P2_UserPhone "				
				CSQL = CSQL & "		,P2_Birthday "	
				CSQL = CSQL & "		,P2_RPOINT"				
				CSQL = CSQL & "		,EntryListYN "	
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
				CSQL = CSQL & "		,'"&P1_Team&"'"
				CSQL = CSQL & "		,'"&P1_TeamNm&"'"
				CSQL = CSQL & "		,'"&P1_Team2&"'"
				CSQL = CSQL & "		,'"&P1_TeamNm2&"'"
				CSQL = CSQL & "		,'"&P1_UserPhone&"'"
				CSQL = CSQL & "		,'"&P1_Birthday&"'"
				CSQL = CSQL & "		,'"&P1_RPOINT&"'"
				
				'파트너 정보 신규일 경우(tblPlayer 조회되지 않은 경우)
				IF P2_PlayerIDX = "" Then 
					CSQL = CSQL & ",NULL"
				Else
					CSQL = CSQL & ",'"&P2_PlayerIDX&"'"
				End IF
				
				CSQL = CSQL & "		,'"&P2_UserName&"'"
				CSQL = CSQL & "		,'"&P2_UserLevel&"'"
				CSQL = CSQL & "		,'"&P2_Team&"'"
				CSQL = CSQL & "		,'"&P2_TeamNm&"'"
				CSQL = CSQL & "		,'"&P2_Team2&"'"
				CSQL = CSQL & "		,'"&P2_TeamNm2&"'"
				CSQL = CSQL & "		,'"&P2_UserPhone&"'"
				CSQL = CSQL & "		,'"&P2_Birthday&"'"
				CSQL = CSQL & "		,'"&P2_RPOINT&"'"
				
				'대회참가신청 제한 팀수 체크
				IF cntGameLvl > cntReqLvl Then 
					CSQL = CSQL & "		,'Y'"
				Else
					CSQL = CSQL & "		,'N'"
				End IF	

				CSQL = CSQL & "		,'N')"				
				
				
				DBcon.Execute(CSQL)
				ErrorNum = ErrorNum + DBcon.Errors.Count
				
		END SELECT		
		
		

		'SMS 발송 참가자, 파트너 전화번호
		P1_UserPhone 	= replace(P1_UserPhone, "-", "")
		P2_UserPhone 	= replace(P2_UserPhone, "-", "")

		'SMS 발송 참가자, 파트너 신청동의를 받기 위한 참가자, 파트너 정보
		dim P1_SMS_ReVal, P2_SMS_ReVal
		
		IF P1_PlayerIDX <> "" Then P1_SMS_ReVal = P1_PlayerIDX & "," & P1_UserPhone
		IF P2_PlayerIDX <> "" Then P2_SMS_ReVal = P2_PlayerIDX & "," & P2_UserPhone
		

		dim val_RGameLevelIDX	'Level IDX 값
		
		
		'최종적으로 tblRGameLevel 테이블의 Level의 [TotRound], [attmembercnt] 값을 업데이트 한다		
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

		
		'해당선수 업데이트후 강수(TotRound) 조회하여 업데이트 처리 
		CSQL = "  		SELECT COUNT(*) cnt "					'count-참가자(팀)
		CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest]"
		CSQL = CSQL & " WHERE  DelYN = 'N'"
		CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
		CSQL = CSQL & "		AND EntryListYN = 'Y'"
		CSQL = CSQL & "		AND GameTitleIDX = '"&Fnd_GameTitle&"' "
		CSQL = CSQL & "		AND Level = '"&TeamGb&"' "
		CSQL = CSQL & " GROUP BY Level"
		
'		RESPONSE.Write CSQL&"<br><br>"
		
		SET JRs = DBcon.Execute(CSQL)
		ErrorNum = ErrorNum + DBcon.Errors.Count
		
		
		'강수 구하기
		TotRound = chk_TotRound(JRs("Cnt"))
			
		
		CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblRGameLevel] "
		CSQL = CSQL & " SET TotRound = '"&TotRound&"'"				'강수
		CSQL = CSQL & " 	, attmembercnt = '"&JRs("Cnt")&"'"		'참가팀수
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
				response.Write "	alert('대회 참가신청 접수가 완료되지 못하였습니다. 확인 후 다시 신청하세요');"
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
			'참가자
			PlayerInfo = PlayerInfo & "- 참가자 : "&P1_UserName 
			IF P1_TeamNm <> "" OR P1_TeamNm2 <> "" Then PlayerInfo = PlayerInfo & "("  			
			IF P1_TeamNm <> "" Then PlayerInfo = PlayerInfo & P1_TeamNm
			IF P1_TeamNm2 <> "" Then PlayerInfo = PlayerInfo & ", " & P1_TeamNm2
			IF P1_TeamNm <> "" OR P1_TeamNm2 <> "" Then PlayerInfo = PlayerInfo & ")\n"  	
			
			'파트너
			IF P2_UserName <> "" Then
				PlayerInfo = PlayerInfo & "- 파트너 : "&P2_UserName 
				IF P2_TeamNm <> "" OR P2_TeamNm2 <> "" Then PlayerInfo = PlayerInfo & "("  
				IF P2_TeamNm <> "" Then PlayerInfo = PlayerInfo & P2_TeamNm
				IF P2_TeamNm2 <> "" Then PlayerInfo = PlayerInfo & ", " & P2_TeamNm2
				IF P2_TeamNm <> "" OR P2_TeamNm2 <> "" Then PlayerInfo = PlayerInfo & ")\n"  
			End IF
						
		
			
			SMS_Msg = replace(SMS_Msg, "{PlayerInfo}", PlayerInfo)			'참가자 정보
			SMS_Msg = replace(SMS_Msg, "\n", "&#13;")						'줄바꿈 변환
					
			'==========================================================================================
			txt_SMSPhone = UserPhone1 & UserPhone2 & UserPhone3				'신청자 전화번호	
			
			dim SMS_AGREE
			
			'참가자와 파트너의 개별 신청동의 메세지와 URL 발송
			SMS_MsgEach = SMS_Msg 		& "아래 주소를 클릭하여 본인 확인을 해주셔야 대회 참가신청이 완료됩니다.\n"
			SMS_MsgEach = SMS_MsgEach 	& "http://tennis.sportsdiary.co.kr/tennis/request/req_comp.asp?UserInfo={UserInfoEach}"
		
			IF act = "WR" Then
			
				'참가자, 파트너에게 신청동의를 받기 위한 각각의 참가신청 접수내용과 동의를 받을 URL 발송
				IF P1_PlayerIDX <> "" Then SMS_AGREE = SMS_AGREE_PROC(P1_UserPhone, P1_SMS_ReVal, SMS_MsgEach, SMS_Subject)
				IF P2_PlayerIDX <> "" Then SMS_AGREE = SMS_AGREE_PROC(P2_UserPhone, P2_SMS_ReVal, SMS_MsgEach, SMS_Subject)
				
				'신청자에게 참가자, 파트너의 정보를 포함한 신청접수완료에 대한 메세지 발송
				'신규 참가신청일 경우 발송
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
			Else
				'수정시 참가자, 파트너의 정보가 변경되었을 때 신규정보인지 체크하여 신규이면 발송
				'참가자, 파트너에게 신청동의를 받기 위한 각각의 참가신청 접수내용과 동의를 받을 URL 발송
				IF P1_PlayerIDX <> "" AND P1_PlayerIDX <> P1_PlayerIDX_Old Then SMS_AGREE = SMS_AGREE_PROC(P1_UserPhone, P1_SMS_ReVal, SMS_Msg, SMS_Subject)
				IF P2_PlayerIDX <> "" AND P2_PlayerIDX <> P2_PlayerIDX_Old Then SMS_AGREE = SMS_AGREE_PROC(P2_UserPhone, P2_SMS_ReVal, SMS_Msg, SMS_Subject)
				
			End IF
			
						
			
			'확인 및 리턴페이지 이동
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