<!--#include file="../Library/ajax_config.asp"-->
<%
	'=====================================================================================
	'대회참가신청 정보 취소페이지
	'=====================================================================================
	dim valTitle	: valTitle      = fInject(Request("valTitle"))
	dim valIDX   	: valIDX 		= fInject(Request("valIDX"))
	dim valPass    	: valPass    	= fInject(Request("valPass"))
	dim valLevel    : valLevel    	= fInject(Request("valLevel"))
	
	dim SportsGb	: SportsGb		= "tennis"
	dim chk_Val		: chk_Val 		= FALSE
	
	dim CSQL, CRs, LSQL, LRs
	dim FndData
	dim ErrorNum
	dim RGameLevelIDX
	
	
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
			
			'기존 참가신청 정보 삭제
			CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblGameRequest] "
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & " 	,DelSayou = 1 "		'유저취소
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&valTitle&"'"
			CSQL = CSQL & " 	AND RequestIDX = '"&valIDX&"'"
			CSQL = CSQL & " 	AND UserPass = '"&valPass&"'"
			
			DBcon.Execute(CSQL)
			ErrorNum = ErrorNum + DBcon.Errors.Count
			
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
			CSQL = CSQL & " SET TotRound = '"&TotRound&"'"
			CSQL = CSQL & " 	, attmembercnt = '"&CRs("Cnt")&"'"
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
	
	response.Write FndData
	
%>