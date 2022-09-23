<!--#include file="../Library/ajax_config.asp"-->
<%
	'마이페이지 체급 셀렉박스 조회생성
	
	dim element : element = fInject(Request("element"))
	dim attname : attname = fInject(Request("attname"))	
	dim code : code    = fInject(Request("code"))	
	dim SEX : SEX	= fInject(Request("SEX"))
	dim TeamGb : TeamGb	= fInject(Request("TeamGb"))
	
	dim txtSEX
	dim chkPlayerLevel	
	dim LSQL, LRs
		
	If SEX = "" OR TeamGb = "" Then 		
		Response.End
	Else
		'가입회원 체급조회
		LSQL =  " 		SELECT PlayerLevel " 
		LSQL = LSQL & "	FROM [Sportsdiary].[dbo].[tblMember] " 
		LSQL = LSQL & "	WHERE DelYN = 'N' " 
		LSQL = LSQL & "		AND MemberIDX = '"&decode(request.Cookies("MemberIDX"), 0)&"'"			
		SET LRs = Dbcon.Execute(LSQL)	
		IF Not(LRs.eof or LRs.bof) Then
			chkPlayerLevel = LRs(0)		
		End IF		
			LRs.Close
		
		'체급[성별 붙이기]			
		SELECT CASE SEX
			CASE "Man" : txtSEX = "남자"
			CASE "WoMan" : txtSEX = "여자"
		END SELECT	

		LSQL =  " 		SELECT Level " 
		LSQL = LSQL & "		, LevelNm  " 
		LSQL = LSQL & "	FROM [Sportsdiary].[dbo].[tblLevelInfo] " 
		LSQL = LSQL & "	WHERE TeamGb in ( " 
		LSQL = LSQL & "		SELECT TeamGb FROM [Sportsdiary].[dbo].[tblTeamGbInfo] " 
		LSQL = LSQL & "		WHERE  DelYN='N' " 
		LSQL = LSQL & "			AND SportsGb = '"&SportsGb&"' " 
		LSQL = LSQL & "			AND Sex='"&SEX&"' " 	
		LSQL = LSQL & "			AND PTeamGb = '"&TeamGb&"' " 
		LSQL = LSQL & "		) "
		SET LRs = Dbcon.Execute(LSQL)
		If Not(LRs.Eof Or LRs.Bof) Then 
			
			selData = "<select name='"&attname&"' id='"&attname&"'>"
			selData = selData&"<option value=''>체급선택</option>"
					
			Do Until LRs.Eof 
			
				IF chkPlayerLevel = LRs("Level") Then
					selData = selData &"<option value='"&LRs("Level")&"' selected >"
				Else
					selData = selData &"<option value='"&LRs("Level")&"'>"
				End IF			
					
				selData = selData &		txtSEX&" "&LRs("LevelNm") 
				selData = selData &"</option>"	
	
				LRs.MoveNext
			Loop 
	
			selData = selData&"</select>"	
	
		End If 
		
			LRs.Close
		SET LRs = Nothing
		
		Response.Write selData	
	
		DBClose()
	
	End If 
	
%>