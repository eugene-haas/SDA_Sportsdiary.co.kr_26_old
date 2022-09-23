<!--#include file="../Library/ajax_config.asp"-->
<%
	'============================================================================
	'나의 메모장 삭제페이지
	'============================================================================
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))
	dim UserID		: UserID		= request.Cookies("SD")("UserID")

	dim CSQL
	
	IF  CIDX = "" or UserID = "" Then
		response.Write "FALSE"
		response.End()
	Else
		CSQL = " 		UPDATE [SD_tennis].[dbo].[tblSvcMemo] "
		CSQL = CSQL & " SET DelYN = 'Y'" 
		CSQL = CSQL & "		,WorkDt = GetDate() "
		CSQL = CSQL & " WHERE MemoIDX = "&CIDX
		CSQL = CSQL & " 	AND SportsGb = '"&SportsGb&"' "
		CSQL = CSQL & "		AND UserID = '"&UserID&"'"
	
		DBCon3.Execute(CSQL)
	
		response.Write "TRUE"
		
	End IF	
%>