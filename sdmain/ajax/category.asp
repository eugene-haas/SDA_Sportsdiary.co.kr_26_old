<!--#include file="../Library/ajax_config.asp"-->
<%
	'===================================================================================
	'종목메인계정 설정 체크
	'===================================================================================
	Check_Login()
	
	dim UserID 		: UserID 		= Request.Cookies("SD")("UserID")	
	dim SaveIDYN	: SaveIDYN		= Request.Cookies("SD")("SaveIDYN")		'자동로그인 설정 체크구분자
	dim GameSETID 	: GameSETID 	= fInject(trim(Request("GameSETID")))	'tblMember - MemberIDX
	dim SportsType 	: SportsType 	= fInject(trim(Request("SportsType")))	'종목
	

	dim LSQL, LRs, CSQL, CRs
	dim ReData	
	dim ErrorNum
	dim str_Cookie
				
	
	IF UserID = "" OR GameSETID = "" OR SportsType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else 
		
		On Error Resume Next
			
		DBCon.BeginTrans()
		DBCon3.BeginTrans()
		
		SELECT CASE SportsType
			
			CASE "judo"
				
				'종목메인 계정설정 초기화
				LSQL = " 		UPDATE [SportsDiary].[dbo].[tblMember]" 
				LSQL = LSQL & " SET SD_GameIDSET = 'N'"	
				LSQL = LSQL & " WHERE DelYN = 'N'"	
				LSQL = LSQL & " 	AND SD_UserID = '"&UserID&"'"	
				
				DBCon.Execute(LSQL)
				ErrorNum = ErrorNum + DBCon.Errors.Count
				
				'종목메인 계정설정 
				LSQL = " 		UPDATE [SportsDiary].[dbo].[tblMember]" 
				LSQL = LSQL & " SET SD_GameIDSET = 'Y'"	
				LSQL = LSQL & " WHERE DelYN = 'N'"	
				LSQL = LSQL & " 	AND SD_UserID = '"&UserID&"'"	
				LSQL = LSQL & " 	AND MemberIDX = '"&GameSETID&"'"	
				
				DBCon.Execute(LSQL)
				ErrorNum = ErrorNum + DBCon.Errors.Count
				
				
				'쿠키설정
				str_Cookie = SET_INFO_COOKIE(UserID, SportsType, SaveIDYN)
				
				
			CASE "tennis"
			
				'종목메인 계정설정 초기화
				LSQL = " 		UPDATE [SD_Tennis].[dbo].[tblMember]" 
				LSQL = LSQL & " SET SD_GameIDSET = 'N'"	
				LSQL = LSQL & " WHERE DelYN = 'N'"	
				LSQL = LSQL & " 	AND SD_UserID = '"&UserID&"'"	
				
				DBCon3.Execute(LSQL)
				ErrorNum = ErrorNum + DBCon3.Errors.Count
				
				'종목메인 계정설정 
				LSQL = " 		UPDATE [SD_tennis].[dbo].[tblMember]" 
				LSQL = LSQL & " SET SD_GameIDSET = 'Y'"	
				LSQL = LSQL & " WHERE DelYN = 'N'"	
				LSQL = LSQL & " 	AND SD_UserID = '"&UserID&"'"	
				LSQL = LSQL & " 	AND MemberIDX = '"&GameSETID&"'"	
				
				DBCon3.Execute(LSQL)
				ErrorNum = ErrorNum + DBCon3.Errors.Count
				
				'쿠키설정
				str_Cookie = SET_INFO_COOKIE(UserID, SportsType, SaveIDYN)
				
				
		END SELECT
		
		IF ErrorNum > 0 Then
			DBCon.RollbackTrans()
			DBCon3.RollbackTrans()
			
			Response.Write "FALSE|99"
			response.End()
		Else	
			
			DBCon.CommitTrans()
			DBCon3.CommitTrans()
			
			Response.Write "TRUE|"
			response.End()
			
		End IF
		
		
		DBClose()	'유도
		DBClose3()	'테니스
	
	End IF 
	
	
	
%>