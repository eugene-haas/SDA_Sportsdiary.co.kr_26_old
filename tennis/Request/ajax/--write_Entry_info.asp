<!--#include file="../Library/ajax_config.asp"-->
<%
	'=====================================================================================
	'참가신청서 상세페이지 보기 참가자 리스트정보
	'=====================================================================================
	dim Fnd_GameTitle     	: Fnd_GameTitle     = fInject(Request("Fnd_GameTitle"))
	dim RequestGroupNum 	: RequestGroupNum 	= fInject(Request("RequestGroupNum"))
	
	dim SportsGb			: SportsGb 			= "tennis"
	
	dim CSQL, CRs
	dim FndData
	
	IF Fnd_GameTitle = "" OR RequestGroupNum = "" Then
		response.Write "FALSE|200"
		response.End()
	Else
	
		CSQL =    	  "	SELECT * "
		CSQL = CSQL & "	FROM [SD_Tennis].[dbo].[tblGameRequest] "
		CSQL = CSQL & "	WHERE DelYN = 'N' "
		CSQL = CSQL & "		and SportsGb = '"&SportsGb&"' "
		CSQL = CSQL & "		and GameTitleIDX = '"&Fnd_GameTitle&"' "
		CSQL = CSQL & "		and RequestGroupNum = '"&RequestGroupNum&"'"
		
		SET CRs = Dbcon.Execute(CSQL)
  		IF Not(CRs.Eof Or CRs.Bof) Then 

				
		ELSE
			response.Write "FALSE|99"
		END IF
			CRs.Close
		SET CRs = Nothing
  
		DBClose()
	END IF
%>