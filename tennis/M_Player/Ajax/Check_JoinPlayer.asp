<!--#include file="../Library/ajax_config.asp"-->
<%
	'=======================================================================================
	'선수보호자 회원가입시 선수정보 조회페이지
	'join3_type2.asp
	'=======================================================================================
	dim UserName 	: UserName 		= fInject(request("UserName"))
	dim UserPhone	: UserPhone 	= fInject(request("UserPhone"))
	dim UserBirth	: UserBirth 	= fInject(request("UserBirth"))	
	dim SportsType	: SportsType 	= fInject(request("SportsType"))	
	dim EnterType	: EnterType 	= fInject(request("EnterType"))	
	
'	response.Write "UserName="&UserName&"<br>"
'	response.Write "UserPhone="&UserPhone&"<br>"
'	response.Write "UserBirth="&UserBirth&"<br>"
'	response.Write "SportsType="&SportsType&"<br>"
	
	dim LSQL, LRs
	dim FndData
	
	IF UserName = "" OR UserBirth = "" OR SportsType = "" OR UserPhone = "" Then
		FndData = "FALSE|1"
	Else
	
		LSQL = "	  	SELECT M.UserID UserID"
		LSQL = LSQL & "		,CONVERT(CHAR(10), CONVERT(DATE,M.Birthday), 102) Birthday "
		LSQL = LSQL & "		,CASE M.SEX WHEN 'WoMan' THEN '여자' WHEN 'Man' THEN '남자' END SEX "
		LSQL = LSQL & "		,M.PlayerIDX PlayerIDX "
		LSQL = LSQL & "		,M.Team Team "
		LSQL = LSQL & "		,T.TeamNm TeamNm "
		LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] M "
		LSQL = LSQL & " 	inner join [SportsDiary].[dbo].[tblTeamInfo] T on M.Team = T.Team "
		LSQL = LSQL & " 		AND T.DelYN = 'N' "
		LSQL = LSQL & " 		AND T.SportsGb = '"&SportsType&"' "
		LSQL = LSQL & " WHERE M.DelYN = 'N'"
		LSQL = LSQL & " 	AND M.SportsType = '"&SportsType&"'"
		LSQL = LSQL & " 	AND M.EnterType = '"&EnterType&"'"
		LSQL = LSQL & " 	AND M.Birthday = '"&UserBirth&"'"
		LSQL = LSQL & " 	AND M.UserName = '"&UserName&"'"
		LSQL = LSQL & " 	AND replace(M.UserPhone,'-','') = '"&replace(UserPhone,"-","")&"'"
		
'		response.Write LSQL
		
		SET LRs = Dbcon.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 
			FndData = "TRUE|"&UserName&"|"&LRs("UserID")&"|"&LRs("Birthday")&"|"&LRs("SEX")&"|"&LRs("TeamNm")&"|"&LRs("Team")&"|"&LRs("PlayerIDX")
		Else
			FndData = "FALSE|2"
		End If 
	
			LRs.Close
		SET LRs = Nothing 
		
		DBClose()
	End IF	
	
	response.Write FndData
	
%>