<!--#include file="../Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'선수정보 조회
	'조회되지 않을 경우 
	'KATA 선수정보가 조회되지 않습니다.\nKATA에 문의하시기바랍니다.☎ 0505-555-0055
	'===============================================================================================
	dim UserName   	: UserName   	= fInject(Request("UserName"))
	dim UserBirth	: UserBirth 	= decode(fInject(Request("UserBirth")),0)
	
	dim FndData			
	dim LSQL, LRs
	
	dim txtTeam

	 
	IF UserName = "" OR UserBirth = "" Then 
		response.Write "FALSE|200"
		response.End()
	Else
		
		LSQL =		  " SELECT PlayerIDX"
		LSQL = LSQL & "	FROM [SD_Tennis].[dbo].[tblPlayer] "
		LSQL = LSQL & "	WHERE DelYN = 'N' "
		LSQL = LSQL & "		AND SportsGb = 'tennis' "
		LSQL = LSQL & "		AND EnterType = 'A'"
		LSQL = LSQL & "		AND UserName = '"&UserName&"'"		
		LSQL = LSQL & "		AND replace(Birthday,'-','') = '"&UserBirth&"'"		
		
		SET LRs = DBCon3.Execute(LSQL)
		IF Not(LRs.eof or LRs.bof) Then 
			response.Write "TRUE|"&encode(LRs("PlayerIDX"), 0)
			response.End()
		Else
			response.Write "FALSE|99"
			response.End()
		End IF
			LRs.Close
		SET LRs = Nothing 
		
		DBClose3()
			
	End IF
	
	
	
%>