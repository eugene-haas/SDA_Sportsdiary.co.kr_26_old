<!--#include file="../Library/ajax_config.asp"-->
<%
	'===========================================================================================
	'국가대표 가입 유무 체크
	'===========================================================================================
	Check_Login()
	
	dim MemberIDX  	: MemberIDX 	= fInject(Request("MemberIDX"))
	dim PlayerIDX  	: PlayerIDX 	= fInject(Request("PlayerIDX"))
	dim Team   		: Team 			= fInject(Request("Team"))
	dim SportsType  : SportsType 	= fInject(Request("SportsType"))
	
	dim FndData
	
	IF MemberIDX = "" OR PlayerIDX = "" OR Team = "" OR SportsType = "" Then 
		FndData = "FALSE|200"
	Else
		
		CSQL =  " 		SELECT COUNT(*) "
		CSQL = CSQL & " FROM [SportsDiary].[dbo].[tblMember] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & " 	AND SportsType = '"&SportsType&"' "
		CSQL = CSQL & " 	AND EnterType = 'K' "
		CSQL = CSQL & " 	AND PlayerIDXNow = '"&PlayerIDX&"' "
		CSQL = CSQL & " 	AND TeamNow = '"&Team&"' "

'		response.Write CSQL

		SET CRs = DBcon.Execute(CSQL)
		IF CRs(0) > 0 Then 
			FndData = "FALSE|99"		
		ELSE      
		  	FndData = "TRUE|"	'국가대표 계정 미등록이면 
		End IF 
			CRs.Close
		SET CRs = Nothing
			
		DBClose()

  	End If 
	
	response.Write FndData
%>