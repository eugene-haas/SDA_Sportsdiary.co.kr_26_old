<!--#include file="../Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'대회참가자 신청 입력정보 중복신청 체크페이지
	'===============================================================================================
	dim GameTitle   		: GameTitle   		= fInject(Request("GameTitle"))			'대회IDX
	dim TeamGb   			: TeamGb   			= fInject(Request("TeamGb"))			'참가종목
	dim P1_PlayerIDX_Old  	: P1_PlayerIDX_Old  = fInject(Request("P1_PlayerIDX_Old"))		
	dim P1_PlayerIDX   		: P1_PlayerIDX 	 	= fInject(Request("P1_PlayerIDX"))		
	dim P1_UserName   		: P1_UserName   	= fInject(Request("P1_UserName"))		
	dim P1_Birthday 		: P1_Birthday   	= fInject(Request("P1_Birthday"))
	dim P1_TeamOne 			: P1_TeamOne   		= fInject(Request("P1_TeamOne"))
	dim P1_TeamTwo 			: P1_TeamTwo   		= fInject(Request("P1_TeamTwo"))
	dim P2_PlayerIDX_Old  	: P2_PlayerIDX_Old  = fInject(Request("P2_PlayerIDX_Old"))		
	dim P2_PlayerIDX   		: P2_PlayerIDX  	= fInject(Request("P2_PlayerIDX"))
	dim P2_UserName   		: P2_UserName   	= fInject(Request("P2_UserName"))		
	dim P2_Birthday 		: P2_Birthday   	= fInject(Request("P2_Birthday"))
	dim P2_TeamOne 			: P2_TeamOne   		= fInject(Request("P2_TeamOne"))
	dim P2_TeamTwo 			: P2_TeamTwo   		= fInject(Request("P2_TeamTwo"))	
	dim val_Type			: val_Type			= fInject(Request("val_Type"))			'구분[WR | MOD]
	
	dim SportsGb    		: SportsGb    		= "tennis"		'테니스
	dim EnterType    		: EnterType    		= "A"			'생활체육
	
	dim FndData			

	dim cnt 		: cnt 			= 0
	dim cntGameLvl	: cntGameLvl 	= 0		'대회참가 종목별 참가신청 제한 인원
	dim cntReqLvl	: cntReqLvl 	= 0		'대회참가 종목별 참가신청 접수한 카운트
	
	dim str_ValUser		'중복된 유저 리스트
	
	IF GameTitle = "" OR TeamGb = "" OR val_Type = "" Then
		FndData = "FALSE|200"
	Else
		
		SELECT CASE val_Type
			CASE "WR"
				'참가자, 파트너 tblPlayer 조회를 통해서 입력 한 경우
				'참가자 신청정보가 있는지 체크	
				IF P1_PlayerIDX <> "" Then						
					CSQL =        " SELECT COUNT(*) "  
					CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] " 
					CSQL = CSQL & " WHERE DelYN = 'N' " 
					CSQL = CSQL & "   	AND GameTitleIDX = '"&GameTitle&"'"
					CSQL = CSQL & "   	AND Level = '"&TeamGb&"'"
					CSQL = CSQL & "   	AND (P1_PlayerIDX = '"&P1_PlayerIDX&"' OR P2_PlayerIDX = '"&P1_PlayerIDX&"')"
					
		'			response.Write CSQL
					
					SET CRs = DBcon.Execute(CSQL)
					IF CRs(0) > 0 Then 
						cnt	= cnt + 1
						str_ValUser =  str_ValUser & ", " & P1_UserName
					End IF
						CRs.Close
				End IF
			
				
				'파트너		
				IF P2_PlayerIDX <> "" Then				
					CSQL =        " SELECT COUNT(*) "  
					CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] " 
					CSQL = CSQL & " WHERE DelYN = 'N' " 
					CSQL = CSQL & "   	AND GameTitleIDX = '"&GameTitle&"'"
					CSQL = CSQL & "   	AND Level = '"&TeamGb&"'"
					CSQL = CSQL & "   	AND (P1_PlayerIDX = '"&P2_PlayerIDX&"' OR P2_PlayerIDX = '"&P2_PlayerIDX&"')"
					
		'			response.Write CSQL
					
					SET CRs = DBcon.Execute(CSQL)
					IF CRs(0) > 0 Then 
						cnt	= cnt + 1
						str_ValUser =  str_ValUser & ", " & P2_UserName
					End IF
						CRs.Close			
				End IF
				
				
				CSQL =        " SELECT COUNT(*) "  
				CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest]" 
				CSQL = CSQL & " WHERE DelYN = 'N' " 
				CSQL = CSQL & "   	AND GameTitleIDX = '"&GameTitle&"'"
				CSQL = CSQL & "   	AND Level = '"&TeamGb&"'"
				CSQL = CSQL & "		AND EntryListYN = 'Y'"		

				SET CRs = DBcon.Execute(CSQL)
					cntReqLvl =  CRs(0)
					CRs.Close		
					
				CSQL =        " SELECT EntryCntGame "  
				CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblRGameLevel] " 
				CSQL = CSQL & " WHERE DelYN = 'N' " 
				CSQL = CSQL & "   	AND GameTitleIDX = '"&GameTitle&"'"
				CSQL = CSQL & "   	AND Level = '"&TeamGb&"'"

				SET CRs = DBcon.Execute(CSQL)
					cntGameLvl =  CRs(0)
					CRs.Close				
					
				
			CASE "MOD"
			
				'기 참가신청한 선수정보와 다른경우(신규입력의 경우)
				'참가자	
				IF P1_PlayerIDX <> "" AND P1_PlayerIDX <> P1_PlayerIDX_Old Then			
					CSQL =        " SELECT COUNT(*) "  
					CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] " 
					CSQL = CSQL & " WHERE DelYN = 'N' " 
					CSQL = CSQL & "   	AND GameTitleIDX = '"&GameTitle&"'"
					CSQL = CSQL & "   	AND Level = '"&TeamGb&"'"
					CSQL = CSQL & "   	AND (P1_PlayerIDX = '"&P1_PlayerIDX&"' OR P2_PlayerIDX = '"&P1_PlayerIDX&"')"
					
					SET CRs = DBcon.Execute(CSQL)
					IF CRs(0) > 0 Then 
						cnt	= cnt + 1
						str_ValUser =  str_ValUser & ", " & P1_UserName
					End IF
						CRs.Close
				
				End IF
				
				'파트너
				IF P2_PlayerIDX <> "" AND P2_PlayerIDX <> P2_PlayerIDX_Old Then			
					CSQL =        " SELECT COUNT(*) "  
					CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] " 
					CSQL = CSQL & " WHERE DelYN = 'N' " 
					CSQL = CSQL & "   	AND GameTitleIDX = '"&GameTitle&"'"
					CSQL = CSQL & "   	AND Level = '"&TeamGb&"'"
					CSQL = CSQL & "   	AND (P1_PlayerIDX = '"&P2_PlayerIDX&"' OR P2_PlayerIDX = '"&P2_PlayerIDX&"')"
					
					SET CRs = DBcon.Execute(CSQL)
					IF CRs(0) > 0 Then 
						cnt	= cnt + 1
						str_ValUser =  str_ValUser & ", " & P2_UserName
					End IF
						CRs.Close
				
				End IF
		
			
		END SELECT
		
	
		IF cnt > 0 Then
			FndData = "FALSE|99|"&mid(str_ValUser, 3)
		Else
			FndData = "TRUE|"&cntGameLvl&"|"&cntReqLvl
		End IF
		
		DBClose()
		
	End IF
	
	response.Write FndData
%>