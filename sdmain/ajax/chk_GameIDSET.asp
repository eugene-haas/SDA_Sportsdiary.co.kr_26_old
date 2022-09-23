<!--#include file="../Library/ajax_config.asp"-->
<%
	'===================================================================================
	'종목메인계정 설정 체크
	'sdmain/index.asp
	'===================================================================================
	Check_Login()
	
	dim UserID 		: UserID 	= Request.Cookies("SD")("UserID")	
	dim SportsType 	: SportsType 	= fInject(trim(Request("SportsType")))	'종목
	

	dim LSQL, LRs
	dim cnt_GameIDSET(2)	'종목별 회원가입 체크(1), 메인계정 설정 유무체크(2)
	dim ReData				
	
	IF UserID = "" OR SportsType = "" Then 	
		ReData = "FALSE|200"
	Else 
		
		SELECT CASE SportsType
			
			CASE "judo"
				
				LSQL = " 		SELECT ISNULL(cnt, 0) cnt " 
				LSQL = LSQL & " FROM ( "	
				LSQL = LSQL & " 	SELECT ISNULL(COUNT(*), 0) cnt, 1 stype "	'종목별 회원가입 유무
				LSQL = LSQL & " 	FROM [SportsDiary].[dbo].[tblMember] "
				LSQL = LSQL & " 	WHERE DelYN = 'N' "
				LSQL = LSQL & " 		AND SportsType = '"&SportsType&"' " 
				LSQL = LSQL & " 		AND SD_UserID = '"&UserID&"' " 		
				LSQL = LSQL & " 	UNION ALL "		
				LSQL = LSQL & " 	SELECT ISNULL(COUNT(*), 0) cnt, 2 stype "	'종목별 메인계정 설정유무
				LSQL = LSQL & " 	FROM [SportsDiary].[dbo].[tblMember] "
				LSQL = LSQL & " 	WHERE DelYN = 'N' "
				LSQL = LSQL & " 		AND SportsType = '"&SportsType&"' " 
				LSQL = LSQL & " 		AND SD_UserID = '"&UserID&"' " 
				LSQL = LSQL & " 		AND SD_GameIDSET = 'Y' "	
				LSQL = LSQL & " ) A	"
				LSQL = LSQL & " ORDER BY A.stype " 
				
'				response.Write LSQL
				
				SET LRs = DBCon.Execute(LSQL)
				IF Not(LRs.eof or LRs.bof) Then 
					Do Until LRs.eof	
						cnt  =  cnt + 1

						cnt_GameIDSET(cnt) = LRs(0)
						
						LRs.movenext
					Loop
					
					ReData = "TRUE|"&cnt_GameIDSET(1)&"|"&cnt_GameIDSET(2)
					
				ELSE
					ReData = "FALSE|99"
				END IF
		
					LRs.Close
				SET LRs = Nothing
		
			CASE "tennis"
			
				LSQL = " 		SELECT ISNULL(cnt, 0) cnt " 
				LSQL = LSQL & " FROM ( "	
				LSQL = LSQL & " 	SELECT ISNULL(COUNT(*), 0) cnt, 1 stype "	'종목별 회원가입 유무
				LSQL = LSQL & " 	FROM [SD_tennis].[dbo].[tblMember] "
				LSQL = LSQL & " 	WHERE DelYN = 'N' "
				LSQL = LSQL & " 		AND SportsType = '"&SportsType&"' " 
				LSQL = LSQL & " 		AND SD_UserID = '"&UserID&"' " 		
				LSQL = LSQL & " 	UNION ALL "		
				LSQL = LSQL & " 	SELECT ISNULL(COUNT(*), 0) cnt, 2 stype "	'종목별 메인계정 설정유무
				LSQL = LSQL & " 	FROM [SD_tennis].[dbo].[tblMember] "
				LSQL = LSQL & " 	WHERE DelYN = 'N' "
				LSQL = LSQL & " 		AND SportsType = '"&SportsType&"' " 
				LSQL = LSQL & " 		AND SD_UserID = '"&UserID&"' " 
				LSQL = LSQL & " 		AND SD_GameIDSET = 'Y' "	
				LSQL = LSQL & " ) A	"
				LSQL = LSQL & " ORDER BY A.stype " 
				
				SET LRs = DBCon3.Execute(LSQL)
				IF Not(LRs.eof or LRs.bof) Then 
					Do Until LRs.eof	
						cnt  =  cnt + 1

						cnt_GameIDSET(cnt) = LRs(0)
						
						LRs.movenext
					Loop
					
					ReData = "TRUE|"&cnt_GameIDSET(1)&"|"&cnt_GameIDSET(2)
					
				ELSE
					ReData = "FALSE|99"	
				END IF
		
					LRs.Close
				SET LRs = Nothing
				
		END SELECT
		
		DBClose()	'유도
		DBClose3()	'테니스
	
	End IF 
	
	response.Write ReData
	
%>