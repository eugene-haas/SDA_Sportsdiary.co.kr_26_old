<!--#include file="../Library/ajax_config.asp"-->
<%
	'===============================================================================================
	'소속팀 정보 조회페이지
	'===============================================================================================
	dim Fnd_KeyWord   	: Fnd_KeyWord   = fInject(Request("Fnd_KeyWord"))
	dim Fnd_Team		: Fnd_Team   	= fInject(Request("Fnd_Team"))
	dim Fnd_TeamNm	 	: Fnd_TeamNm  	= fInject(Request("Fnd_TeamNm"))
	dim sObj	 		: sObj  		= fInject(Request("sObj"))
	dim chk_Team	 	: chk_Team 		= fInject(Request("chk_Team")) 	'소속2 검색시 소속1과 중복되는지 체크
					
	dim FndData			
	dim CSearch, LSQL, LRs
	
	dim txtTeam

	 
	IF Fnd_KeyWord <> "" Then 
		
		
		CSearch = " AND TeamNm like '%"&Fnd_KeyWord&"%'"		
		
		IF chk_Team<>"" Then CSearch = CSearch & " AND Team <> '"&chk_Team&"'"
		
		LSQL =		  " SELECT Team, TeamNm "
		LSQL = LSQL & "	FROM [SD_Tennis].[dbo].[tblTeamInfo] "
		LSQL = LSQL & "	WHERE DelYN = 'N' "
		LSQL = LSQL & "		AND SportsGb = 'tennis' "
		LSQL = LSQL & "		AND EnterType = 'A' "&CSearch
		LSQL = LSQL & "	GROUP BY Team, TeamNm"		
		LSQL = LSQL & "	ORDER BY TeamNm" 
		
		SET LRs = DBCon3.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 
			Do Until LRs.Eof
				FndData = FndData & "<li><a href=""javascript:Info_InputData('"&Fnd_Team&"','"&LRs("Team")&"','"&Fnd_TeamNm&"','"&LRs("TeamNm")&"', '"&sObj&"');"">"&LRs("TeamNm")&"</a></li>"
				LRs.Movenext
			Loop
		Else
			FndData = "<li><a href=""javascript:Info_InputData('"&Fnd_Team&"','','"&Fnd_TeamNm&"','', '"&sObj&"');"">조회된 소속이 없습니다.</a></li>"
		'	FndData = FndData & "<li><a href=""javascript:Info_InputData('"&Fnd_Team&"','','"&Fnd_TeamNm&"','');"">신규 소속생성을 신청하세요.</a></li>"
		End IF
			LRs.Close
		SET LRs = Nothing 
		
		response.Write FndData
		
		DBClose3()
			
	End IF
	
	
	
%>