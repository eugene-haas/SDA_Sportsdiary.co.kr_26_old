<!--#include file="../Library/ajax_config.asp"-->
<%
    Check_Login()
   
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))
	dim MemberIDX   : MemberIDX 	= decode(request.Cookies("SD")("MemberIDX"), 0)
	
	
	dim CSQL
	
	IF  CIDX="" Then
		response.Write "FALSE"
		response.End()
	Else
		CSQL =" 		UPDATE [SD_tennis].[dbo].[tblSvcQnA] "
		CSQL = CSQL & " SET DelYN = 'Y'" 
		CSQL = CSQL & "		,WorkDt = GetDate() "
		CSQL = CSQL & " WHERE QnAIDX = '"&CIDX&"'"
        CSQL = CSQL & "     AND MemberIDX = '"&MemberIDX&"'"
                                       
		DBCon3.Execute(CSQL)
	
		response.Write "TRUE"
		
	End IF	
%>