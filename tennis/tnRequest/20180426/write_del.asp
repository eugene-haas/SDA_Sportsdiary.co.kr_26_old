<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./library/ajax_config.asp"-->
<%
	'=====================================================================================
	'대회참가신청 정보 취소페이지
	'=====================================================================================
	dim valTitle		: valTitle      = fInject(Request("Fnd_GameTitle"))		'GameTitleIDX
	dim valIDX   		: valIDX 		= fInject(Request("RequestIDX"))		'GameRequestIDX
	dim valPass    		: valPass    	= fInject(Request("UserPass"))			'PWD
	dim valLevel    	: valLevel    	= fInject(Request("Level"))				'GameRequest-Level
	
	dim currPage		: currPage		= fInject(Request("currPage"))				
	dim Fnd_KeyWord		: Fnd_KeyWord	= fInject(Request("Fnd_KeyWord"))				
	dim Fnd_TeamGb		: Fnd_TeamGb	= fInject(Request("Fnd_TeamGb"))				
	dim Fnd_GameTitle	: Fnd_GameTitle	= fInject(Request("Fnd_GameTitle"))				
	
	dim SportsGb		: SportsGb		= "tennis"
	
	dim CSQL, CRs, LSQL, LRs, JSQL, TSQL
	dim FndData
	dim ErrorNum
	dim RGameLevelIDX
	
	dim SMS_Subject		: SMS_Subject 	= "*** 대회 참가신청 정상접수 완료 알림메시지 ***"
	dim SMS_Msg			: SMS_Msg 		= "{UserName}님!\n{GameInfo} 참가신청이 선착순으로 마감되어 참가대기팀으로 접수하셨던 참가신청이 정상접수 처리되었습니다.\n{PlayerInfo}"				'참가대기팀에서 업데이트 메세지

	dim SMS_TxtString	'참가신청 대기 정상접수처리 LMS 발송내용
	dim SMS_TxtPlayer	'참가자, 파트너 목록
	dim SMS_Msg1, SMS_Msg2, SMS_Msg3
	dim EntryCntGame		'참가신청 제한 팀수
	dim EntryCntRequest		'참가신청한 팀수

	
	
	'참가신청 정보 삭제로 인한 참가신청대기정보 조회하여 엔트리로 업데이트처리
	FUNCTION CHK_GameRequest_Entry(GTitle, GLevel)				
		'대회정보 조회
		CSQL = "		SELECT G.GameTitleName"
		CSQL = CSQL & "		,R.TeamGbNm"
		CSQL = CSQL & "		,R.EntryCntGame"
		CSQL = CSQL & "		,L.LevelNm"
		CSQL = CSQL & "		,("
		CSQL = CSQL & "			SELECT ISNULL(COUNT(*), 0)"
		CSQL = CSQL & "			FROM [SD_Tennis].[dbo].[tblGameRequest]"
		CSQL = CSQL & "			WHERE DelYN = 'N'"
		CSQL = CSQL & "				AND GameTitleIDX = '"&GTitle&"'"
		CSQL = CSQL & "				AND Level = '"&GLevel&"'"
		CSQL = CSQL & "				AND EntryListYN = 'Y'"
		CSQL = CSQL & "		) EntryCntRequest"
		CSQL = CSQL & "	FROM [SD_Tennis].[dbo].[sd_TennisTitle] G"
		CSQL = CSQL & "		left join [SD_Tennis].[dbo].[tblRGameLevel] R on G.GameTitleIDX = R.GameTitleIDX"
		CSQL = CSQL & "			AND R.Level = '"&GLevel&"'"
		CSQL = CSQL & "		left join [SD_Tennis].[dbo].[tblLevelInfo] L on R.Level = L.Level"
		CSQL = CSQL & "	WHERE G.DelYN = 'N'"
		CSQL = CSQL & "		AND G.SportsGb = '"&SportsGb&"'"
		CSQL = CSQL & "		AND G.GameTitleIDX = '"&GTitle&"'"
		
		SET CRs = DBCon.Execute(CSQL)
		IF Not(CRs.Eof OR CRs.Bof) Then
			GameTitleName =  CRs("GameTitleName")
			TeamGbNm =  CRs("TeamGbNm")
			LevelNm =  CRs("LevelNm")
			EntryCntGame =  CRs("EntryCntGame")			'참가신청 제한 팀수 조회
			EntryCntRequest =  CRs("EntryCntRequest")	'참가신청한 팀수 조회	
		End IF
			CRs.Close	
		
		'대회정보 변환	
		SMS_Msg = replace(SMS_Msg, "{GameInfo}", GameTitleName&"("&TeamGbNm&"-"&LevelNm&")")					
		
		
		'대회 종목별 참가제한 팀보다 적게 신청한 경우
		IF EntryCntGame > EntryCntRequest Then
			'LMS 정보
			SMS_TxtString = SMS_TxtString & "<script>"
			SMS_TxtString = SMS_TxtString & "	function on_Submit(valPhone, valContents){"
			SMS_TxtString = SMS_TxtString & "		var strAjaxUrl = 'http://biz.moashot.com/EXT/URLASP/mssendutf.asp';"
			SMS_TxtString = SMS_TxtString & "		$.ajax({"
			SMS_TxtString = SMS_TxtString & "			url: strAjaxUrl,"
			SMS_TxtString = SMS_TxtString & "			type: 'POST',"
			SMS_TxtString = SMS_TxtString & "			dataType: 'html',"
			SMS_TxtString = SMS_TxtString & "			contentType: 'application/x-www-form-urlencoded; charset=utf-8',"
			SMS_TxtString = SMS_TxtString & "			data: { "
			SMS_TxtString = SMS_TxtString & "				uid			: 'rubin500'"
			SMS_TxtString = SMS_TxtString & "				,pwd		: 'rubin0907'"
			SMS_TxtString = SMS_TxtString & "				,commType	: 0"
			SMS_TxtString = SMS_TxtString & "				,sendType	: 5"
			SMS_TxtString = SMS_TxtString & "				,fromNumber	: '027040282'"
			SMS_TxtString = SMS_TxtString & "				,nType		: 4"
			SMS_TxtString = SMS_TxtString & "				,returnType	: 0"
			SMS_TxtString = SMS_TxtString & "				,indexCode	: '"&now()&"'"
			SMS_TxtString = SMS_TxtString & "				,title		: '"&SMS_Subject&"'"
			SMS_TxtString = SMS_TxtString & "				,toNumber	: valPhone"
			SMS_TxtString = SMS_TxtString & "				,contents	: valContents"
			SMS_TxtString = SMS_TxtString & "			}"
			SMS_TxtString = SMS_TxtString & "		});"
			SMS_TxtString = SMS_TxtString & "	}"
			SMS_TxtString = SMS_TxtString & "</script>"
			
			CSQL = "		SELECT TOP "&EntryCntGame - EntryCntRequest &" RequestIDX"
			CSQL = CSQL & " 	,UserName"
			CSQL = CSQL & " 	,UserPhone"
			CSQL = CSQL & " 	,P1_UserName"
			CSQL = CSQL & " 	,P1_UserPhone"
			CSQL = CSQL & " 	,P2_UserName"
			CSQL = CSQL & " 	,P2_UserPhone"
			CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest]"
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&GTitle&"' "
			CSQL = CSQL & " 	AND Level = '"&GLevel&"' "
			CSQL = CSQL & " 	AND EntryListYN = 'N'"
			CSQL = CSQL & " ORDER BY WriteDate"
			
			SET CRs = DBCon.Execute(CSQL)
			IF Not(CRs.Eof OR CRs.Bof) Then
				Do Until CRs.Eof
					'업데이트 쿼리문(RequestIDX)			
					TSQL = TSQL & "," & CRs("RequestIDX")
					
					'선수목록	
					SMS_TxtPlayer = "(참가자:"&CRs("P1_UserName")
					IF CRs("P2_UserName") <> "" Then SMS_TxtPlayer = SMS_TxtPlayer & " / 파트너:"&CRs("P2_UserName")
					SMS_TxtPlayer = SMS_TxtPlayer & ")"
					
					'참가자 LMS발송
					IF CRs("P1_UserPhone") <> "" Then 						
						SMS_Msg1 = replace(SMS_Msg, "{UserName}", CRs("P1_UserName"))						
						SMS_Msg1 = replace(SMS_Msg1, "{PlayerInfo}", SMS_TxtPlayer)		'참가자정보					
						SMS_Msg1 = replace(SMS_Msg1, "\n", "\r\n")								
						SMS_TxtString = SMS_TxtString & "<script>on_Submit('"&CRs("P1_UserPhone")&"','"&SMS_Msg1&"');</script>"
					End IF
					
					'파트너 LMS발송	
					IF CRs("P2_UserPhone") <> "" Then 
						SMS_Msg2 = replace(SMS_Msg, "{UserName}", CRs("P2_UserName"))
						SMS_Msg2 = replace(SMS_Msg2, "{PlayerInfo}", SMS_TxtPlayer)						
						SMS_Msg2 = replace(SMS_Msg2, "\n", "\r\n")		
						SMS_TxtString = SMS_TxtString & "<script>on_Submit('"&CRs("P2_UserPhone")&"','"&SMS_Msg2&"');</script>"
					End IF
					
					'신청자 LMS발송	
					IF CRs("UserPhone") <> "" Then 
						SMS_Msg3 = replace(SMS_Msg, "{UserName}", CRs("UserName"))
						SMS_Msg3 = replace(SMS_Msg3, "{PlayerInfo}", SMS_TxtPlayer)						
						SMS_Msg3 = replace(SMS_Msg3, "\n", "\r\n")		
						SMS_TxtString = SMS_TxtString & "<script>on_Submit('"&CRs("UserPhone")&"','"&SMS_Msg3&"');</script>"
					End IF
			
					CRs.movenext
				Loop
			End IF
				CRs.Close	
		End IF
		
		'참가신청 대기정보 엔트리로 업데이트 처리
		JSQL =  "		UPDATE [SD_Tennis].[dbo].[tblGameRequest] "
		JSQL = JSQL & " SET EntryListYN = 'Y' "
		JSQL = JSQL & " 	,WorkDate = GETDATE() "
		JSQL = JSQL & " WHERE DelYN = 'N' "
		JSQL = JSQL & " 	AND RequestIDX IN("&mid(TSQL, 2)&")"
		
		DBCon.Execute(JSQL)
		ErrorNum = ErrorNum + DBCon.Errors.Count
		
		'LMS 정보 리턴
		CHK_GameRequest_Entry = SMS_TxtString

	END FUNCTION
	
	
	
	IF valTitle = "" OR valIDX = "" OR valPass = "" OR valLevel = "" Then
		response.Write "<script>"
		response.Write "	alert('잘못된 접근입니다. 확인 후 이용하세요.');"
		response.Write "	history.back();"
		response.Write "</script>"
	Else
	
	
		On Error Resume Next
	
		DBCon.BeginTrans()
			
		LSQL = "		SELECT * "
		LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest] "
		LSQL = LSQL & " WHERE DelYN = 'N' "
		LSQL = LSQL & " 	AND GameTitleIDX = '"&valTitle&"' "
		LSQL = LSQL & " 	AND RequestIDX = '"&valIDX&"' "
		LSQL = LSQL & " 	AND UserPass = '"&valPass&"' "
		
		SET LRs = DBCon.Execute(LSQL) 
		IF Not(LRs.Eof OR LRs.Bof) Then
			
			'기존 참가신청 정보 삭제 처리
			CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblGameRequest] "
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & " 	,DelSayou = 1 "		'유저취소
			CSQL = CSQL & " WHERE RequestIDX = '"&valIDX&"'"
			
			DBCon.Execute(CSQL)
			ErrorNum = ErrorNum + DBCon.Errors.Count
			
			'참가신청 정보 삭제로 인한 참가신청대기정보 조회하여 엔트리로 업데이트처리
			CHK_Entry = CHK_GameRequest_Entry(valTitle, valLevel)
			
			'해당 대회 참가종목 상세 IDX 조회 RGameLevelIDX
			CSQL = "		SELECT RGameLevelIDX "
			CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblRGameLevel] "
			CSQL = CSQL & " WHERE DelYN = 'N' "
			CSQL = CSQL & " 	AND GameTitleIDX = '"&valTitle&"' "
			CSQL = CSQL & " 	AND Level = '"&valLevel&"' "
			
			SET CRs = DBCon.Execute(CSQL)
			IF Not(CRs.Eof OR CRs.Bof) Then
				RGameLevelIDX =  CRs("RGameLevelIDX")
			End IF
				CRs.Close
			
			'해당선수 업데이트후 강수(TotRound) 조회하여 업데이트 처리 
			CSQL = "  		SELECT ISNULL(COUNT(*), 0) cnt "					'count-참가자(팀)
			CSQL = CSQL & " FROM [SD_Tennis].[dbo].[tblGameRequest]"
			CSQL = CSQL & " WHERE  DelYN = 'N'"
			CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
			CSQL = CSQL & "		AND EntryListYN = 'Y'"
			CSQL = CSQL & "		AND GameTitleIDX = '"&Fnd_GameTitle&"' "
			CSQL = CSQL & "		AND Level = '"&valLevel&"' "
			CSQL = CSQL & " GROUP BY Level"
			
			SET CRs = DBCon.Execute(CSQL)
			ErrorNum = ErrorNum + DBCon.Errors.Count
			
			
			'강수 구하기
			TotRound = chk_TotRound(CRs("cnt"))


			CSQL = "  		UPDATE [SD_Tennis].[dbo].[tblRGameLevel] "
			CSQL = CSQL & " SET TotRound = '"&TotRound&"'"						'강수
			CSQL = CSQL & " 	, attmembercnt = '"&CRs("cnt")&"'"				'참가팀 수
			CSQL = CSQL & " WHERE RGameLevelIDX = '"&RGameLevelIDX&"' "
			
			SET CRs = DBCon.Execute(CSQL)
			ErrorNum = ErrorNum + DBCon.Errors.Count
			
			IF ErrorNum > 0 Then
				DBCon.RollbackTrans()
				
				response.Write "<script>"
				response.Write "	alert('참가신청정보를 삭제하지 못하였습니다. 확인 후 이용하세요.');"
				response.Write "	history.back();"
				response.Write "</script>"
				
			Else					
				DBCon.CommitTrans()
				
				'LMS 발송
				response.Write CHK_Entry
				
				response.Write "<script>"
				response.Write "	alert('참가신청 정보를 취소하였습니다.');"
				response.Write "	location.replace('./list_repair.asp?currPage="&currPage&"&Fnd_GameTitle="&Fnd_GameTitle&"&Fnd_TeamGb="&Fnd_TeamGb&"&Fnd_KeyWord="&Fnd_KeyWord&"');"
				response.Write "</script>"				

			End IF
			
		Else
		
			response.Write "<script>"
			response.Write "	alert('일치하는 정보가 없습니다. 확인 후 이용하세요.');"
			response.Write "	history.back();"
			response.Write "</script>"
			
		End IF
		
			LRs.Close
		SET LRs = Nothing
		
		
		DBClose()
		
	End IF
%>