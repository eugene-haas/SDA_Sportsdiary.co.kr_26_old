<!--#include file="../Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'소속팀 정보 조회페이지
	'===============================================================================================
	dim Fnd_KeyWord   	: Fnd_KeyWord   = fInject(Request("Fnd_KeyWord"))
	
	dim SportsGb    	: SportsGb    	= "tennis"		'테니스
	dim EnterType    	: EnterType    	= "A"			'생활체육
	
	dim FndData			
	dim CSearch
	
	 
	IF Fnd_KeyWord <> "" Then 
		CSearch = " AND TeamNm like '%"&Fnd_KeyWord&"%'"		
		
		CSQL =		  " SELECT TeamNm "
		CSQL = CSQL & "	FROM [SD_Tennis].[dbo].[tblTeamInfo] "
		CSQL = CSQL & "	WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
		CSQL = CSQL & "		AND EnterType = '"&EnterType&"' "&CSearch
		CSQL = CSQL & "	ORDER BY TeamNm " 
		
		SET CRs = DBCon3.Execute(CSQL)
		IF Not(CRs.Eof Or CRs.Bof) Then 
			Do Until CRs.Eof
				FndData = FndData & "<li><a href='#'>"&CRs("TeamNm")&"</a></li>"
				CRs.Movenext
			Loop
		End IF
			CRs.Close
		SET CRs = Nothing 
		
		response.Write FndData
		
		DBClose3()
			
	End IF
	
	
	
%>