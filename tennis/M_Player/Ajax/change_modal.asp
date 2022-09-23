<!--#include file="../Library/ajax_config.asp"-->
<%
	'===================================================================================
	'계정전환 설정
	'===================================================================================
	Check_Login()

	dim UserID	: UserID			= Request.Cookies("SD")("UserID")
	dim ChangeUser 	: ChangeUser 	= fInject(trim(Request("ChangeUser")))	'tblMember - MemberIDX

	dim LSQL, LRs, CSQL, CRs
	dim ReData	
	dim ErrorNum
	dim str_Cookie
				
	
	IF ChangeUser = "" OR SportsGb = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else 
		
		'쿠키설정
		SELECT CASE SportsGb
			CASE "judo" : str_Cookie = SET_INFO_COOKIE(UserID, ChangeUser, SportsGb)
			CASE "tennis" : str_Cookie = SET_INFO_COOKIE(UserID, ChangeUser, SportsGb)
		END SELECT
		
		response.Write "TRUE|"&str_Cookie
		
	End IF 
	
	
	
%>