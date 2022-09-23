<!--#include file="../Library/ajax_config.asp"-->
<%
	'===========================================================================================
	'대회명, 참가종목 조회 SELECT BOX
	'===========================================================================================
	dim element 		: element 		= fInject(Request("element"))	
	dim Fnd_GameTitle 	: Fnd_GameTitle = fInject(Request("Fnd_GameTitle"))	
	dim Level 			: Level 		= fInject(Request("Level"))
	
	dim GameYear 		: GameYear 		= Year(date())
	dim SportsGb		: SportsGb		= "tennis"
	dim EnterType		: EnterType		= "A"			'E:엘리트, A:생활체육
	
	dim LSQL, LRs
	dim selData
	
	
	IF element = "" Then
		Response.Write "FALSE|"
		response.End()
	Else

		SELECT CASE element
			
			'대회명 
			CASE "GameTitle"
				
				LSQL = "		SELECT G.GameTitleIDX "
				LSQL = LSQL & " 	,G.GameTitleName "
				LSQL = LSQL & "   	,P.PubName PubName" 	
				LSQL = LSQL & " FROM [SD_Tennis].[dbo].[sd_TennisTitle] G"
				LSQL = LSQL & " 	left join [SD_Tennis].[dbo].[tblPubCode] P on G.GameTitleLevel = P.PubCode "
				LSQL = LSQL & "			AND P.DelYN = 'N' "
				LSQL = LSQL & "			AND P.SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & " WHERE G.DelYN = 'N'"
				LSQL = LSQL & " 	AND G.SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & " 	AND G.EnterType = '"&EnterType&"'"
'				LSQL = LSQL & " 	AND G.GameYear = '"&GameYear&"'"
				LSQL = LSQL & " ORDER BY G.GameS ASC "
				
				SET LRs = DBcon.Execute(LSQL)
				IF Not(LRs.Eof Or LRs.Bof) Then 
					
					selData = "TRUE|"
												
					Do Until LRs.Eof 
						
						selData = selData&"<option value='"&LRs("GameTitleIDX")&"' >["&LRs("PubName")&"] "&LRs("GameTitleName")&"</option>"	
			
						LRs.MoveNext
					Loop 			
					
				Else
					selData = "FALSE|"
				End IF 
				
					LRs.Close
				SET LRs = Nothing
				
				Response.Write selData
				response.End()
				
				
			'대회참가종목		
			CASE "TeamGb"				
				
				
				LSQL = "		SELECT RGameLevelidx"
				LSQL = LSQL & "		,R.TeamGb"
				LSQL = LSQL & "		,R.Level Level"
				LSQL = LSQL & "		,L.LevelNm LevelNm"
				LSQL = LSQL & "		,T.TeamGbNm TeamGbNm"
				LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblRGameLevel] R"
				LSQL = LSQL & "		left join [SD_Tennis].[dbo].[tblLevelInfo] L on L.Level = R.Level"
				LSQL = LSQL & "			AND L.DelYN = 'N'"
				LSQL = LSQL & "			AND L.SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & "		left join [SD_Tennis].[dbo].[tblTeamGbInfo] T on T.TeamGb = R.TeamGb"
				LSQL = LSQL & "			AND L.DelYN = 'N'"
				LSQL = LSQL & "			AND L.SportsGb = '"&SportsGb&"'	"
				LSQL = LSQL & "	WHERE R.DelYN = 'N'"
				LSQL = LSQL & "		AND R.SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & "		AND R.GameTitleIDX = '"&Fnd_GameTitle&"'"
				
				
				SET LRs = DBcon.Execute(LSQL)
				IF Not(LRs.Eof Or LRs.Bof) Then 				
					
					
					selData = "<option value=''>:: 참가종목선택 ::</option>"
												
					Do Until LRs.Eof 
						
						
						selData = selData & "<option value='"&LRs("Level")&"' "
						
						IF Level <> "" and Level = LRs("Level") Then selData = selData & " selected "
						
						selData = selData & ">"&LRs("TeamGbNm")&"("&LRs("LevelNm")&")</option>"	
			
						LRs.MoveNext
					Loop 			
					
				Else
					
					selData = "<option value=''>:: 참가종목선택 ::</option>"
				End IF 
				
					LRs.Close
				SET LRs = Nothing
				
				Response.Write "TRUE|"&selData
				response.End()
				
		END SELECT
		
		DBclose()
	End IF	

%>