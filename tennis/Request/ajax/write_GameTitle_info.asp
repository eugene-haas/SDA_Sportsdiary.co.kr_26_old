<!--#include file="../Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'대회정보 조회페이지
	'===============================================================================================
	dim Fnd_GameTitle   : Fnd_GameTitle   	= fInject(Request("Fnd_GameTitle"))
	
	dim SportsGb    	: SportsGb    		= "tennis"		'테니스
	dim EnterType    	: EnterType    		= "A"			'생활체육
	
	dim FndData			
	
	IF Fnd_GameTitle = "" Then
		FndData = "FALSE|200"
	Else
		
		CSQL =      " 	SELECT G.GameTitleName "  
		CSQL = CSQL & "   	,G.GameS " 
		CSQL = CSQL & "   	,G.GameE " 
		CSQL = CSQL & "   	,G.GameArea " 
	' 	CSQL = CSQL & "   	,G.Sido " 
		CSQL = CSQL & "   	,G.GameRcvDateS " 
		CSQL = CSQL & "   	,G.GameRcvDateE " 
		CSQL = CSQL & "		,CASE WHEN DATEDIFF(d, CONVERT(DATE, G.GameRcvDateS), GETDATE())>=0 and DATEDIFF(d, GETDATE(), CONVERT(DATE, G.GameRcvDateE))>=0 THEN 'on' Else 'off' END reqState"
		CSQL = CSQL & " FROM [SD_Tennis].[dbo].[sd_TennisTitle] G " 
		CSQL = CSQL & " WHERE G.DelYN = 'N' " 
	 	CSQL = CSQL & "   	AND G.ViewYN = 'Y' "
		CSQL = CSQL & "   	AND G.SportsGb = '"&SportsGb&"' "
		CSQL = CSQL & "   	AND GameTitleIDX = '"&Fnd_GameTitle&"'"
		
		SET CRs = Dbcon.Execute(CSQL)
		IF Not(CRs.Eof Or CRs.Bof) Then 

			GameTitleName = CRs("GameTitleName")
			GameS = CRs("GameS")
			GameE = CRs("GameE")
			GameArea = CRs("GameArea")
'			Sido = CRs("Sido")
			GameRcvDateS = CRs("GameRcvDateS")
			GameRcvDateE = CRs("GameRcvDateE")
			reqState = CRs("reqState")			
			
			'대회기간
			txt_Term = replace(GameS,"-",".")&"("&Weekdayname(Weekday(GameS), true)&") ~ "&replace(GameE,"-",".")&"("&Weekdayname(Weekday(GameE),true)&")"
			'대회장소(상세)
			txt_AreaDtl = replace(GameS,"-",".")&"("&Weekdayname(Weekday(GameS), true)&") ~ "&replace(GameE,"-",".")&"("&Weekdayname(Weekday(GameE),true)&")"
			'대회참가신청기간
			txt_TermRcv = replace(GameRcvDateS,"-",".")&"("&Weekdayname(Weekday(GameRcvDateS), true)&") ~ "&replace(GameRcvDateS,"-",".")&"("&Weekdayname(Weekday(GameRcvDateS),true)&")"
			
			FndData = "TRUE|"&GameTitleName&"|"&txt_Term&"|"&txt_AreaDtl&"|"&txt_TermRcv&"|"&reqState
		Else
			FndData = "FALSE|99"
		End IF
		
			CRs.Close
		SET CRs = Nothing 

		DBClose()
		
	End IF
	
	response.Write FndData
%>