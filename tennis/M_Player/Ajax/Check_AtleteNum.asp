<!--#include file="../Library/ajax_config.asp"-->
<%
	'================================================================================
	'체육인번호, 팀소속 조회페이지
	'================================================================================
	
	dim TeamCode 	: TeamCode 		= fInject(Request("TeamCode"))		'소속팀[ex. 울산스포츠과학중학교]
	dim UserName 	: UserName 		= fInject(Request("UserName"))
	dim UserBirth 	: UserBirth 	= fInject(Request("UserBirth"))
	dim SportsType 	: SportsType 	= fInject(Request("SportsType"))
	dim PlayerReln 	: PlayerReln 	= fInject(Request("PlayerReln"))
	dim CoachType 	: CoachType 	= fInject(Request("CoachType"))
	
	dim CSQL, CRs

	IF UserBirth = "" OR UserName = "" OR PlayerReln = "" Then 
		Response.Write "FALSE|"
		Response.End
	Else
	
		SELECT CASE PlayerReln
   		    '엘리트 선수 tblPlayer 조회
			'협회등록선수[NowRegYN:Y]
			CASE "R"
				CSQL = 	"		SELECT PersonCode "
				CSQL = CSQL & "		,PlayerIDX " 
				CSQL = CSQL & "		,Team " 
				CSQL = CSQL & " FROM [SportsDiary].[dbo].[tblPlayer] " 
				CSQL = CSQL & " WHERE DelYN = 'N' "
				CSQL = CSQL & "		AND NowRegYN = 'Y' " 
				CSQL = CSQL & " 	AND SportsGb = '"&SportsType&"'" 
				CSQL = CSQL & "		AND UserName = '"&UserName&"' " 
				CSQL = CSQL & "		AND Team = '"&TeamCode&"' " 
				CSQL = CSQL & "	 	AND Replace(Birthday,'-','') = '"&UserBirth&"' "
				
		'		response.Write CSQL
				
				SET CRs = Dbcon.Execute(CSQL)
		
				IF Not(CRs.Eof Or CRs.Bof) Then 
					Response.Write "TRUE|"&CRs("PersonCode")&"|"&CRs("PlayerIDX")&"|"&CRs("Team")
				Else
					Response.Write "FALSE|"
					Response.End
				End IF 
					
					CRs.Close
				SET CRs = Nothing
			
			
			'엘리트 지도자 체육인번호 조회	
			CASE "T" 
				CSQL = " 		SELECT PersonNum "
				CSQL = CSQL & "		,LeaderIDX " 
				CSQL = CSQL & "		,CASE b.Sex WHEN 1 THEN '남자팀' WHEN 2 THEN '여자팀' WHEN 3 THEN '남자팀+여자팀' ELSE '' END Sex" 
				CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblLeader] a"
				CSQL = CSQL & "		inner join [Sportsdiary].[dbo].[tblTeamInfo] b on a.Team = b.Team " 
				CSQL = CSQL & "			AND b.DelYN = 'N' " 
				CSQL = CSQL & "			AND b.SportsGb = '"&SportsGb&"' " 
				CSQL = CSQL & " WHERE a.DelYN = 'N' " 
				CSQL = CSQL & " 	AND a.SportsGb = '"&SportsGb&"' " 
				CSQL = CSQL & " 	AND a.LeaderType = '"&CoachType&"' " 
				CSQL = CSQL & "		AND a.Team = '"&TeamCode&"' " 
				CSQL = CSQL & "		AND a.UserName = '"&UserName&"' " 				
				CSQL = CSQL & "		AND Replace(a.Birthday,'-','') = '"&UserBirth&"' "
				
'				response.Write CSQL
'				response.End()
				
				SET CRs = Dbcon.Execute(CSQL)
				IF Not(CRs.Eof Or CRs.Bof) Then 
					Response.Write "TRUE|"&CRs("PersonNum")&"|"&CRs("LeaderIDX")&"|"&CRs("Sex")
				Else
					Response.Write "FALSE|"
					Response.End
				End IF 
					
					CRs.Close
				SET CRs = Nothing
			
			CASE ELSE
			
				Response.Write "FALSE|"
				Response.End
				
		END SELECT	
		
		DBClose()
		
	End If 
%>