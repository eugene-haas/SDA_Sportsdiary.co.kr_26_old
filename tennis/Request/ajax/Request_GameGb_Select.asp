<!--#include file="../Library/ajax_config.asp"-->
<%
	'===========================================================================================
	'참가종목 조회 SELECT BOX
	'===========================================================================================
	dim element 		: element 		= fInject(Request("element"))	
	dim GameTitleIDX 	: GameTitleIDX 	= fInject(Request("GameTitleIDX"))	
	
	dim SportsGb		: SportsGb		= "tennis"
	dim EnterType		: EnterType		= "A"			'E:엘리트, A:생활체육
	
	dim LSQL, LRs
	dim selData
	
	
	IF element = "" Then
		Response.Write "FALSE|"
		response.End()
	Else

		LSQL = "		SELECT A.RGameLevelIDX "
		LSQL = LSQL & " 	,B.TeamGbNm "
		LSQL = LSQL & " 	,C.LevelNm "
		LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblRGameLevel] A "
		LSQL = LSQL & " 	left join [SD_Tennis].[dbo].[tblTeamGbInfo] B on A.TeamGb = B.TeamGb"
		LSQL = LSQL & " 		AND B.DelYN = 'N'"
		LSQL = LSQL & " 		AND B.SportsGb = '"&SportsGb&"'"
		LSQL = LSQL & " 		AND B.EnterType = '"&EnterType&"'"
		LSQL = LSQL & "		left join [SD_Tennis].[dbo].[tblLevelInfo] C on A.Level = C.Level"
		LSQL = LSQL & "			AND C.DelYN = 'N'"
		LSQL = LSQL & "			AND C.SportsGb = '"&SportsGb&"'"		
		LSQL = LSQL & " WHERE A.DelYN = 'N'"
		LSQL = LSQL & " 	AND A.SportsGb = '"&SportsGb&"'"
		LSQL = LSQL & " 	AND A.EnterType = '"&EnterType&"'"				
		LSQL = LSQL & " 	AND A.GameTitleIDX = '"&GameTitleIDX&"'"		
		
'		response.Write LSQL
		
		
		SET LRs = DBcon.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 
			
			selData = "TRUE|"
										
			Do Until LRs.Eof 
				
				selData = selData&"<option value='"&LRs(0)&"' >"&LRs(1)&"</option>"	
	
				LRs.MoveNext
			Loop 			
			
		Else
			selData = "FALSE|"
		End IF 
		
			LRs.Close
		SET LRs = Nothing
		
		Response.Write selData
	
		DBclose()
		
		
	End IF	

%>