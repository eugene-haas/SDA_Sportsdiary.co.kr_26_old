<!--#include file="../Library/ajax_config.asp"-->
<%
	'=====================================================================================
	'참가신청서 상세페이지 보기 및 수정페이지	
	'=====================================================================================
	dim CIDX      : CIDX      = fInject(decode(Request("CIDX"), 0))
	dim CUserPass : CUserPass = fInject(Request("CUserPass"))
	
	dim CSQL, CRs
	
	IF CIDX = "" OR CUserPass = "" Then
		response.Write "FALSE|200"
		response.End()
	Else
	
		CSQL =    	  "	SELECT UserPass "
		CSQL = CSQL & " 	,GameTitleIDX"
		CSQL = CSQL & " 	,RequestGroupNum"
		CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] " 
		CSQL = CSQL & " WHERE DelYN = 'N' " 
		CSQL = CSQL & "   AND RequestIDX = '"&CIDX&"' "
		
		SET CRs = Dbcon.Execute(CSQL)
  		IF Not(CRs.Eof Or CRs.Bof) Then 
			IF CUserPass = CRs("UserPass") Then
				response.Write "TRUE|"&CRs("GameTitleIDX")&"|"&encode(CRs("RequestGroupNum"), 0)
			ELSE
				response.Write "FALSE|66"
			END IF	
		ELSE
			response.Write "FALSE|99"
		END IF
			CRs.Close
		SET CRs = Nothing
  
		DBClose()
		
	END IF
%>