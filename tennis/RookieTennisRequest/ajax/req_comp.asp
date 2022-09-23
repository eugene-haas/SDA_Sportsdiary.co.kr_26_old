<!--#include file="../Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'KATA 대회참가신청 동의 페이지
	'===============================================================================================
	dim UserInfo 	: UserInfo 	= fInject(decode(request("UserInfo"), 0))	
	
	
	dim SportsGb	: SportsGb 	= "tennis"
	dim EnterType	: EnterType = "A"
	dim CHK_ACT 	
	
	dim txtUserInfo
	dim CSQL, CRs
	
	IF UserInfo = "" Then
		CHK_ACT	= "FALSE|200"
	Else
		txtUserInfo = split(UserInfo, ",")
	
		CSQL = "		SELECT ISNULL(RequestYN, 'N') RequestYN"
		CSQL = CSQL & "		,RequestDt"
		CSQL = CSQL & "	FROM [SD_Tennis].[dbo].[tblPlayer]"
		CSQL = CSQL & "	WHERE DelYN = 'N'"
		CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"'"
		CSQL = CSQL & "		AND EnterType = '"&EnterType&"'"
		CSQL = CSQL & "		AND PlayerIDX = '"&txtUserInfo(0)&"'"		
		CSQL = CSQL & "		AND UserPhone = '"&txtUserInfo(1)&"'"
		
		SET CRs = Dbcon.Execute(CSQL)
		IF Not(CRs.Eof Or CRs.Bof) Then 
			IF CRs("RequestYN") <> "Y" Then
				CSQL = "		UPDATE [SD_Tennis].[dbo].[tblPlayer]"
				CSQL = CSQL & "	SET RequestYN = 'Y'"
				CSQL = CSQL & "		,RequestDt = GETDATE()"
				CSQL = CSQL & "	WHERE DelYN = 'N'"
				CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"'"
				CSQL = CSQL & "		AND EnterType = '"&EnterType&"'"
				CSQL = CSQL & "		AND PlayerIDX = '"&txtUserInfo(0)&"'"		
				CSQL = CSQL & "		AND UserPhone = '"&txtUserInfo(1)&"'"
				
				Dbcon.Execute(CSQL)
				CHK_ACT = "TRUE|33"
			Else
				CHK_ACT = "FALSE|66"	
			END IF		
			
		Else
			CHK_ACT = "FALSE|99"
		End IF
			
			CRs.Close
		SET CRs = Nothing	
	
	End IF
	
	response.Write CHK_ACT

	DBClose()

%>