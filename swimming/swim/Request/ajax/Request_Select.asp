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
				LSQL = LSQL & "		,CASE WHEN DATEDIFF(d, CONVERT(DATE, G.GameRcvDateS), GETDATE())>=0 and DATEDIFF(d, GETDATE(), CONVERT(DATE, G.GameRcvDateE))>=0 THEN '0' Else '1' END reqState "
				LSQL = LSQL & "		,DATEDIFF(d, CONVERT(DATE, G.GameS), GETDATE()) reqStateValue  "
				LSQL = LSQL & "		,DATEDIFF(d, CONVERT(DATE, G.GameRcvDateS), GETDATE()) reqStateValueOn  "				
				LSQL = LSQL & " FROM [SD_Tennis].[dbo].[sd_TennisTitle] G"
				LSQL = LSQL & " 	left join [SD_Tennis].[dbo].[tblPubCode] P on G.GameTitleLevel = P.PubCode "
				LSQL = LSQL & "			AND P.DelYN = 'N' "
				LSQL = LSQL & "			AND P.SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & " WHERE G.DelYN = 'N'"
				LSQL = LSQL & " 	AND G.ViewYN = 'Y'"
				LSQL = LSQL & " 	AND G.SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & " 	AND G.EnterType = '"&EnterType&"'"
'				LSQL = LSQL & " 	AND G.GameYear = '"&GameYear&"'"
'				LSQL = LSQL & " ORDER BY G.GameS ASC "
				LSQL = LSQL & " ORDER BY reqState, reqStateValueOn, reqStateValue, G.GameRcvDateS"
				
				SET LRs = DBcon.Execute(LSQL)
				IF Not(LRs.Eof Or LRs.Bof) Then 
					
					selData = "TRUE|"
												
					Do Until LRs.Eof 
						
						selData = selData & "<option value='"&LRs("GameTitleIDX")&"'"
						
						'현재 참가신청중인 대회 컬러구분하여 표시
						IF LRs("reqState") = 0 Then selData = selData & " style='color:#0000FF'"
						
						selData = selData & ">["&LRs("PubName")&"] "&LRs("GameTitleName")&"</option>"	
			
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
				LSQL = LSQL & "		,T.TeamGbNm TeamGbNm"
				LSQL = LSQL & "		,R.Level Level"
				LSQL = LSQL & "		,L.LevelNm LevelNm"
				LSQL = LSQL & "		,(	SELECT COUNT(*)"
				LSQL = LSQL & "			FROM [SD_Tennis].[dbo].[tblGameRequest]"
				LSQL = LSQL & "			WHERE DelYN = 'N'"
				LSQL = LSQL & "				AND SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & "				AND GameTitleIDX = '"&Fnd_GameTitle&"'"
				LSQL = LSQL & "				AND T.TeamGb = L.TeamGb"
				LSQL = LSQL & "				AND L.Level = Level"
				LSQL = LSQL & "				AND EntryListYN = 'Y'"	'참가 엔트리
				LSQL = LSQL & "		) EntryReqCnt"
				LSQL = LSQL & "		,(	SELECT EntryCntGame"
				LSQL = LSQL & "			FROM [SD_Tennis].[dbo].[tblRGameLevel]"
				LSQL = LSQL & "			WHERE DelYN = 'N'"
				LSQL = LSQL & "				AND SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & "				AND GameTitleIDX = '"&Fnd_GameTitle&"'"
				LSQL = LSQL & "				AND T.TeamGb = L.TeamGb"
				LSQL = LSQL & "				AND L.Level = Level"
				LSQL = LSQL & "		) EntryLevelCnt"
				LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblRGameLevel] R"
				LSQL = LSQL & "		left join [SD_Tennis].[dbo].[tblTeamGbInfo] T on T.TeamGb = R.TeamGb"
				LSQL = LSQL & "			AND T.DelYN = 'N'"
				LSQL = LSQL & "			AND T.SportsGb = '"&SportsGb&"'	"
				LSQL = LSQL & "		left join [SD_Tennis].[dbo].[tblLevelInfo] L on L.Level = R.Level"
				LSQL = LSQL & "			AND L.DelYN = 'N'"
				LSQL = LSQL & "			AND L.SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & "	WHERE R.DelYN = 'N'"
				LSQL = LSQL & "		AND R.SportsGb = '"&SportsGb&"'"
				LSQL = LSQL & "		AND R.GameTitleIDX = '"&Fnd_GameTitle&"'"	
				LSQL = LSQL & "	ORDER BY R.TeamGb, R.Level"	
				
			'	response.Write 	LSQL		
				
				SET LRs = DBcon.Execute(LSQL)
				IF Not(LRs.Eof Or LRs.Bof) Then 				
					
					
					selData = "<option value=''>:: 참가종목선택 ::</option>"
												
					Do Until LRs.Eof 
						
						
						selData = selData & "<option value='"&LRs("Level")&"' "
						
						IF Level <> "" and Level = LRs("Level") Then selData = selData & " selected "
						
						selData = selData & ">"&LRs("TeamGbNm")&"("&LRs("LevelNm")&" - "&LRs("EntryLevelCnt")&"팀) - 신청팀("&LRs("EntryReqCnt")&")</option>"	
			
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