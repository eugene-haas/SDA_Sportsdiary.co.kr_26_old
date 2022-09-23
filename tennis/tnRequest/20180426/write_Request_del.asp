<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<%
	'=====================================================================================
	'대회참가신청 정보 취소페이지
	'=====================================================================================
	dim valTitle	: valTitle      = fInject(Request("valTitle"))		'GameTitleIDX
	dim valIDX   	: valIDX 		= fInject(Request("valIDX"))		'GameRequestIDX
	dim valPass    	: valPass    	= fInject(Request("valPass"))		'PWD
	dim valLevel    : valLevel    	= fInject(Request("valLevel"))		'GameRequest-Level
	
	dim SportsGb	: SportsGb		= "tennis"
	dim chk_Val		: chk_Val 		= FALSE
	
	dim CSQL, CRs, LSQL, LRs
	dim FndData
	dim ErrorNum
	dim RGameLevelIDX
	
	dim SMS_Subject		: SMS_Subject 	= "*** 대회 참가신청 정상접수 완료 알림메시지 ***"
	dim SMS_Msg			: SMS_Msg 		= "{UserName}님! 참가신청 대기팀으로 접수되었던 참가신청이 정상접수 처리되었습니다."				'참가대기팀에서 업데이트 메세지
	dim SMS_TxtString	'참가신청 대기 정상접수처리 LMS 발송내용
	
	dim EntryCntGame		'참가신청 제한 팀수
	dim EntryCntRequest		'참가신청한 팀수
	
	
	'참가신청 정보 삭제로 인한 참가신청대기정보 조회하여 엔트리로 업데이트처리
	FUNCTION CHK_GameRequest_Entry(GTitle, GLevel)
		
		'참가신청 제한 팀수 조회
		CSQL = "		SELECT EntryCntGame "
		CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblRGameLevel] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & " 	AND GameTitleIDX = '"&GTitle&"' "
		CSQL = CSQL & " 	AND Level = '"&GLevel&"' "
		
		SET CRs = DBcon.Execute(CSQL)
		IF Not(CRs.Eof OR CRs.Bof) Then
			EntryCntGame =  CRs(0)
		End IF
			CRs.Close
		
		'참가신청한 팀수 조회	
		CSQL = "		SELECT COUNT(*) "
		CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest]"
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & " 	AND GameTitleIDX = '"&GTitle&"' "
		CSQL = CSQL & " 	AND Level = '"&GLevel&"' "
		CSQL = CSQL & " 	AND EntryListYN = 'Y'"
		
		SET CRs = DBcon.Execute(CSQL)
		IF Not(CRs.Eof OR CRs.Bof) Then
			EntryCntRequest =  CRs(0)
		End IF
			CRs.Close	
		
		
		IF EntryCntGame > EntryCntRequest Then
			SMS_TxtString = "				 <script>"
			SMS_TxtString = SMS_TxtString & "	function on_Submit(valPhone, valContents){"
			SMS_TxtString = SMS_TxtString & "		var strAjaxUrl = 'http://biz.moashot.com/EXT/URLASP/mssendutf.asp';"
			SMS_TxtString = SMS_TxtString & "		$.ajax({"
			SMS_TxtString = SMS_TxtString & "			url: strAjaxUrl,"
			SMS_TxtString = SMS_TxtString & "			type: 'POST',"
			SMS_TxtString = SMS_TxtString & "			dataType: 'html',"
			SMS_TxtString = SMS_TxtString & "			contentType: 'application/x-www-form-urlencoded; charset=utf-8',"
			SMS_TxtString = SMS_TxtString & "			data: { "
			SMS_TxtString = SMS_TxtString & "				uid			: 'rubin500'"
			SMS_TxtString = SMS_TxtString & "				,pwd		: 'rubin0907'"
			SMS_TxtString = SMS_TxtString & "				,commType	: 0"
			SMS_TxtString = SMS_TxtString & "				,sendType	: 5"
			SMS_TxtString = SMS_TxtString & "				,fromNumber	: '027040282'"
			SMS_TxtString = SMS_TxtString & "				,nType		: 4"
			SMS_TxtString = SMS_TxtString & "				,returnType	: 0"
			SMS_TxtString = SMS_TxtString & "				,indexCode	: '"&now()&"'"
			SMS_TxtString = SMS_TxtString & "				,title		: '"&SMS_Subject&"'"
			SMS_TxtString = SMS_TxtString & "				,toNumber	: valPhone"
			SMS_TxtString = SMS_TxtString & "				,contents	: valContents"
			SMS_TxtString = SMS_TxtString & "			}"
			SMS_TxtString = SMS_TxtString & "		});"
			SMS_TxtString = SMS_TxtString & "	}"
			SMS_TxtString = SMS_TxtString & "</script>"
			
			
			CSQL = "		SELECT TOP "&EntryCntGame - EntryCntRequest &" RequestIDX"
			CSQL = CSQL & " 	,P1_UserName"
			CSQL = CSQL & " 	,P1_UserPhone"
			CSQL = CSQL & " 	,P2_UserName"
			CSQL = CSQL & " 	,P2_UserPhone"
			CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest]"
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&GTitle&"' "
			CSQL = CSQL & " 	AND Level = '"&GLevel&"' "
			CSQL = CSQL & " 	AND EntryListYN = 'N'"
			CSQL = CSQL & " ORDER BY WriteDate"
			
			SET CRs = DBcon.Execute(CSQL)
			IF Not(CRs.Eof OR CRs.Bof) Then
				Do Until CRs.Eof
					
					CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblGameRequest] "
					CSQL = CSQL & " SET EntryListYN = 'Y' "
					CSQL = CSQL & " 	,WorkDate = GETDATE() "
					CSQL = CSQL & " WHERE DelYN = 'N' "
					CSQL = CSQL & " 	AND GameTitleIDX = '"&GTitle&"'"
					CSQL = CSQL & " 	AND Level = '"&GLevel&"'"
					CSQL = CSQL & " 	AND RequestIDX = '"&CRs("RequestIDX")&"'"
					
'					SMS_TxtString = SMS_TxtString & CSQL
					
					DBcon.Execute(CSQL)
					ErrorNum = ErrorNum + DBcon.Errors.Count
					
					'참가자 LMS발송
					IF CRs("P1_UserPhone") <> "" Then 
						SMS_Msg = replace(SMS_Msg, "{UserName}", CRs("P1_UserName"))
						SMS_TxtString = SMS_TxtString & "<script>on_Submit('"&replace(CRs("P1_UserPhone"),"-","")&"','"&SMS_Msg&"');</script>"
					End IF
					
					'파트너 LMS발송	
					IF CRs("P2_UserPhone") <> "" Then 
						SMS_Msg = replace(SMS_Msg, "{UserName}", CRs("P2_UserName"))
						SMS_TxtString = SMS_TxtString & "<script>on_Submit('"&replace(CRs("P2_UserPhone"),"-","")&"','"&SMS_Msg&"');</script>"
					End IF
			
					CRs.movenext
				Loop
			End IF
				CRs.Close	
		End IF
		
		CHK_GameRequest_Entry = SMS_TxtString
		
		response.Write SMS_TxtString
		
				
	END FUNCTION
	
	
	
	IF valTitle = "" OR valIDX = "" OR valPass = "" OR valLevel = "" Then
		FndData = "FALSE|200"
	Else
		On Error Resume Next
	
		DBcon.BeginTrans()
			
		LSQL = "		SELECT * "
		LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] "
		LSQL = LSQL & " WHERE DelYN = 'N' "
		LSQL = LSQL & " 	AND GameTitleIDX = '"&valTitle&"' "
		LSQL = LSQL & " 	AND RequestIDX = '"&valIDX&"' "
		LSQL = LSQL & " 	AND UserPass = '"&valPass&"' "
		
		SET LRs = DBcon.Execute(LSQL) 
		IF Not(LRs.Eof OR LRs.Bof) Then
			
			'기존 참가신청 정보 삭제 처리
			CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblGameRequest] "
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & " 	,DelSayou = 1 "		'유저취소
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&valTitle&"'"
			CSQL = CSQL & " 	AND RequestIDX = '"&valIDX&"'"
			CSQL = CSQL & " 	AND UserPass = '"&valPass&"'"
			
			DBcon.Execute(CSQL)
			ErrorNum = ErrorNum + DBcon.Errors.Count
			
			'참가신청 정보 삭제로 인한 참가신청대기정보 조회하여 엔트리로 업데이트처리
			CHK_Entry = CHK_GameRequest_Entry(valTitle, valLevel)
			
			
			
			'해당 대회 참가종목 상세 IDX 조회 RGameLevelIDX
			CSQL = "		SELECT RGameLevelIDX "
			CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblRGameLevel] "
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&valTitle&"' "
			CSQL = CSQL & " 	AND Level = '"&valLevel&"' "
			
			SET CRs = DBcon.Execute(CSQL)
			IF Not(CRs.Eof OR CRs.Bof) Then
				RGameLevelIDX =  CRs(0)
			End IF
				CRs.Close
			
			'해당선수 업데이트후 강수(TotRound) 조회하여 업데이트 처리 
			CSQL = "  		SELECT COUNT(*) cnt "					'count-참가자(팀)
			CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest]"
			CSQL = CSQL & " WHERE  DelYN = 'N'"
			CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
			CSQL = CSQL & "		AND EntryListYN = 'Y'"
			CSQL = CSQL & "		AND GameTitleIDX = '"&Fnd_GameTitle&"' "
			CSQL = CSQL & "		AND Level = '"&valLevel&"' "
			CSQL = CSQL & " GROUP BY Level"
			
	'		RESPONSE.Write CSQL&"<br><br>"
			
			SET CRs = DBcon.Execute(CSQL)
			ErrorNum = ErrorNum + DBcon.Errors.Count
			
			
			'강수 구하기
			TotRound = chk_TotRound(CRs("Cnt"))
				
			
			CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblRGameLevel] "
			CSQL = CSQL & " SET TotRound = '"&TotRound&"'"						'강수
			CSQL = CSQL & " 	, attmembercnt = '"&CRs("Cnt")&"'"				'참가팀 수
			CSQL = CSQL & " WHERE RGameLevelIDX = '"&val_RGameLevelIDX&"' "
			
			IF ErrorNum > 0 Then
				DBcon.RollbackTrans()
				FndData = "FALSE|66"
			Else					
				DBcon.CommitTrans()
				FndData = "TRUE|"
			End IF
			
		Else
		
			FndData = "FALSE|99"		
			
		End IF
		
			LRs.Close
		SET LRs = Nothing
		
		
		DBClose()
		
	End IF
	
'	response.Write FndData
	
'	IF CHK_Entry <> "" Then response.Write CHK_Entry
	
%>