<!--#include file="../Library/ajax_config.asp"-->
<%
	'======================================================================================
	'나의 메모장 수정시 정보 조회 출력
	'======================================================================================
	
	dim CIDX 		: CIDX 		= fInject(request("CIDX"))
	dim UserID		: UserID	= request("UserID")
	
	dim CSQL, CRs
	
	IF CIDX = "" or UserID = "" Then
		response.Write "FALSE|1"	
		response.End()
	Else

		CSQL = 	" 		SELECT Title " 
		CSQL = CSQL & "		,Contents "
		CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcMemo] " 
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & "		And SportsGb = '"&SportsGb	&"'"
		CSQL = CSQL & "		And MemoIDX = "&CIDX	
		CSQL = CSQL & "		And UserID = '"&UserID&"'"	
		
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