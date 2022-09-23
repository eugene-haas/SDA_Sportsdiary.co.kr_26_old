<!--#include file="../Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'선수정보 조회페이지
	'===============================================================================================
	dim Fnd_KeyWord   	: Fnd_KeyWord   = fInject(Request("Fnd_KeyWord"))
	dim Fnd_ObjCnt  	: Fnd_ObjCnt   	= fInject(Request("Fnd_ObjCnt"))
	dim Fnd_ObjPlayer	: Fnd_ObjPlayer	= fInject(Request("Fnd_ObjPlayer"))
	
	
	dim SportsGb    	: SportsGb    	= "tennis"		'테니스
	dim EnterType    	: EnterType    	= "A"			'생활체육
	
	dim FndData			
	dim CSearch
	
	 
	IF Fnd_KeyWord <> "" Then 
		
		CSearch = " AND UserName like '%"&Fnd_KeyWord&"%'"		
		
		CSQL =		  " SELECT PlayerIDX "
		CSQL = CSQL & " 	,UserName"
		CSQL = CSQL & " 	,Team"
		CSQL = CSQL & " 	,TeamNm"
		CSQL = CSQL & " 	,Team2"
		CSQL = CSQL & " 	,Team2Nm"
		CSQL = CSQL & " 	,SEX"
		CSQL = CSQL & " 	,Birthday"
		CSQL = CSQL & " 	,CASE WHEN UserPhone IS NOT NULL THEN replace(UserPhone, '-','') END UserPhone"
		CSQL = CSQL & "	FROM [SD_Tennis].[dbo].[tblPlayer] "
		CSQL = CSQL & "	WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
		CSQL = CSQL & "		AND EnterType = '"&EnterType&"' "&CSearch
		CSQL = CSQL & "	ORDER BY UserName " 
		
		SET CRs = Dbcon.Execute(CSQL)
		IF Not(CRs.Eof Or CRs.Bof) Then 
			Do Until CRs.Eof
				FndData = FndData & "<li onclick=""Input_PlayerInfo('"&Fnd_ObjPlayer&"','"&Fnd_ObjCnt&"','"&CRs("PlayerIDX")&"','"&CRs("UserName")&"','"&CRs("Team")&"','"&CRs("TeamNm")&"','"&CRs("Team2")&"','"&CRs("Team2Nm")&"','"&CRs("SEX")&"','"&CRs("Birthday")&"','"&CRs("UserPhone")&"');"">"
				FndData = FndData & "<a href=""#"">"&CRs("UserName")&" ( "&CRs("TeamNm")
				
				IF CRs("Team2Nm") <> "" Then FndData = FndData &" / "&CRs("Team2Nm")
				
				FndData = FndData &" ) </a></li>"
				
				CRs.Movenext
			Loop
		End IF
			CRs.Close
		SET CRs = Nothing 
		
		response.Write FndData
		
		DBClose()
			
	End IF
	
	
	
%>