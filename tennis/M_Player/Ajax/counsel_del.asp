<!--#include file="../Library/ajax_config.asp"-->
<%
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))
	dim currPage 	: currPage 		= fInject(request("currPage"))
	dim fnd_user 	: fnd_user 		= fInject(request("fnd_user"))
	dim search_date : search_date 	= fInject(request("search_date"))	
	dim SDate 		: SDate 		= fInject(request("SDate"))
	dim EDate 		: EDate 		= fInject(request("EDate"))
	
	dim CSQL
	
	IF  CIDX="" Then
		response.Write "FALSE"
		response.End()
	Else
		CSQL = " 		UPDATE [Sportsdiary].[dbo].[tblSvcLedrAdv] "
		CSQL = CSQL & " SET DelYN='Y'" 
		CSQL = CSQL & "		,WorkDt = GetDate() "
		CSQL = CSQL & " WHERE LedrAdvIDX = "&CIDX
	
		Dbcon.Execute(CSQL)
	
		response.Write "TRUE"
		
	End IF	
%>