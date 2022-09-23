<!--#include file="../Library/ajax_config.asp"-->
<%
    Check_Login()
   
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))
	dim MemberIDX   : MemberIDX 	= decode(request.Cookies("SD")("MemberIDX"), 0)
	
	IF CIDX = ""  Then
		response.Write "FALSE|1"	
		response.End()
	Else

		CSQL = 	" 		SELECT Title " 
		CSQL = CSQL & "		,Contents "
		CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblSvcQnA] " 
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & "		And SportsGb = '"&SportsGb	&"'"
		CSQL = CSQL & "		And QnAIDX = '"&CIDX&"'"		
        CSQL = CSQL & "		And MemberIDX = '"&MemberIDX&"'"	
		
		SET CRs = DBCon3.Execute(CSQL)			
		IF Not(CRs.eof or CRs.bof) Then
			
			Title 		= ReplaceTagReText(CRs("Title"))
			Contents 	= ReplaceTagReText(CRs("Contents"))
			
			response.Write "TRUE|"	&Title&"|"&Contents
		
		
		Else
			response.Write "FALSE|2"	
			response.End()
		End IF
			
			CRs.Close
		SET CRs = Nothing
		
		DBClose3()
		
	End IF	
%>