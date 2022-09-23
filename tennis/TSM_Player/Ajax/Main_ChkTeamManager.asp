<!--#include file="../Library/ajax_config.asp"-->
<%
	'==========================================================================
	'회원MemberIDX 로그의 팀정보 조회하여 팀매니저정보 체크
	'==========================================================================
	Check_Login()
	
	dim ChkTeam : ChkTeam = decode(Request.Cookies("Team"), 0)
	
	dim CSQL, CRs
	
	IF ChkTeam="" Then
		response.Write "FALSE"
		response.End()
	Else
		
		CSQL = "		SELECT COUNT(*) " 
		CSQL = CSQL & "	FROM [Sportsdiary].[dbo].[tblMember] " 
		CSQL = CSQL & "	WHERE DelYN = 'N' " 
		CSQL = CSQL & "		AND SportsType = '"&SportsGb&"' " 
		CSQL = CSQL & "		AND PlayerReln = 'T' " 
		CSQL = CSQL & "		AND EdSvcReqTp = 'A' " 
		CSQL = CSQL & "		AND Team IN( " 
		CSQL = CSQL & "			SELECT  Team  " 
		CSQL = CSQL & "			FROM [Sportsdiary].[dbo].[tblMember] " 
		CSQL = CSQL & "			WHERE DelYN = 'N' " 
		CSQL = CSQL & "				AND SportsType = '"&SportsGb&"' " 
		CSQL = CSQL & "				AND Team = '"&ChkTeam&"' " 
		CSQL = CSQL & "				AND EdSvcReqTp = 'A' )"
		
		SET CRs = Dbcon.Execute(CSQL)
		If CRs(0) > 0 Then 
			Response.Write "TRUE"
		Else
			Response.Write "FALSE"
		End If 
			
			CRs.Close
		SET CRs = Nothing
		
		DBClose()

	End IF	
%>