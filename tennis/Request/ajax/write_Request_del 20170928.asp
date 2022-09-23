<!--#include file="../Library/ajax_config.asp"-->
<%
	'=====================================================================================
	'대회참가신청 정보 삭제페이지
	'=====================================================================================
	dim valTitle		: valTitle      = fInject(Request("valTitle"))
	dim valGroupNum   	: valGroupNum 	= fInject(Request("valGroupNum"))
	dim valPass    		: valPass    	= fInject(Request("valPass"))
	dim valLevel    	: valLevel    	= fInject(Request("valLevel"))
	
	
	dim CSQL, CRs, LSQL, LRs
	dim FndData
	dim ErrorNum
	dim RGameLevelIDX
	dim chk_VAL	: chk_VAL = FALSE
	
	IF valTitle = "" OR valGroupNum = "" OR valPass = "" OR valLevel = "" Then
		FndData = "FALSE|200"
	Else
		On Error Resume Next
	
		DBcon.BeginTrans()
			
		LSQL = "		SELECT * "
		LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] "
		LSQL = LSQL & " WHERE DelYN = 'N' "
		LSQL = LSQL & " 	AND GameTitleIDX = '"&valTitle&"' "
		LSQL = LSQL & " 	AND RequestGroupNum = '"&valGroupNum&"' "
		LSQL = LSQL & " 	AND UserPass = '"&valPass&"' "
		
		SET LRs = DBcon.Execute(LSQL) 
		IF Not(LRs.Eof OR LRs.Bof) Then
			chk_VAL = TRUE
		Else
			chk_VAL = FALSE
		End IF
			LRs.Close
		SET LRs = Nothing
		
		
		IF chk_VAL = TRUE Then
			
			'기존 참가신청 정보 삭제
			CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblGameRequest] "
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&valTitle&"'"
			CSQL = CSQL & " 	AND RequestGroupNum = '"&valGroupNum&"'"
			CSQL = CSQL & " 	AND UserPass = '"&valPass&"'"
			
			DBcon.Execute(CSQL)
			ErrorNum = ErrorNum + DBcon.Errors.Count
			
			'기존 참가신청 참가자정보 삭제
			CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblRPlayerMaster]"
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&valTitle&"'"
			CSQL = CSQL & " 	AND RequestGroupNum = '"&valGroupNum&"'"
			
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
			
				
			'해당선수 업데이트후 TotRound 업데이트 처리 
			CSQL = "  		SELECT COUNT(RPlayerMasterIDX)/2 Cnt "
			CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblRPlayerMaster] "
			CSQL = CSQL & " WHERE  DelYN = 'N'"
			CSQL = CSQL & "		AND GameTitleIDX = '"&valTitle&"' "
			CSQL = CSQL & "		AND RGameLevelIDX = '"&RGameLevelIDX&"' "
	
			SET CRs = DBcon.Execute(CSQL)
			
			'강수 구하기
			TotRound = chk_TotRound(CRs("Cnt"))
			
				CRs.Close
			
			CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblRGameLevel] "
			CSQL = CSQL & " SET TotRound = '"&TotRound&"' "
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&valTitle&"' "
			CSQL = CSQL & "		AND RGameLevelIDX = '"&RGameLevelIDX&"' "
			
			DBcon.Execute(CSQL)
			ErrorNum = ErrorNum + DBcon.Errors.Count	
			
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
		
		
		DBClose()
		
	End IF
	
	response.Write FndData
	
%>