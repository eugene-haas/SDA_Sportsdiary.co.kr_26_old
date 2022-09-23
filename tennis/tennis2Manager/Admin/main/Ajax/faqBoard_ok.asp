<!--#include file="../Library/config.asp"-->
<%
	'FAQ 수정/삭제/작성 페이지
	
	dim FAPubCode   : FAPubCode 	= fInject(Request("FAPubCode"))		
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))		
	dim Contents   	: Contents 		= ReplaceTagText(fInject(Request("Contents")))	
	dim RContents  	: RContents		= ReplaceTagText(fInject(Request("RContents")))		
	dim act   		: act 			= fInject(Request("act"))	
	dim SportsGb	: SportsGb		= fInject(Request("SportsGb"))	
	dim RUserName	: RUserName 	= fInject(Request("RUserName"))
	
	IF RUserName = "관리자" OR RUserName = "" Then RUserName = "스포츠다이어리"
	
	dim CSQL
	dim ErrorNum
		
	IF act = "" Then
		response.Write "FALSE|"
		response.End()	
	ELSE	
		On Error Resume Next
		
		SELECT CASE act
			
			CASE "WR"
				IF Contents = "" OR RContents = "" OR FAPubCode = "" Then
					response.Write "FALSE|"
					response.End()
				ELSE
					
	
					DBCon5.BeginTrans()
				
					'질문 등록
					CSQL =" INSERT INTO [SD_tennis].[dbo].[tblSvcFAQ] ( "&_
							"	   [FAPubCode] "&_
							"	  ,[SportsGb] "&_
							"	  ,[ReFaqIDX] "&_
							"	  ,[Contents] "&_
							"	  ,[WriteName] "&_
							"	  ,[WriteDate] "&_
							"	  ,[WorkDt] "&_
							"	  ,[DelYN] "&_
							"	  ,[ViewCnt] "&_
							") VALUES( "&_
							"	 '"&FAPubCode&"' "&_
							"	,'"&SportsGb&"' "&_
							"	,0 "&_
							"	,'"&Contents&"' "&_
							"	,'"&RUserName&"' "&_
							"	,GetDate() "&_
							"	,GetDate() "&_
							"	,'N' "&_
							"	,0) " 
					
					DBCon5.Execute(CSQL)
					ErrorNum = ErrorNum + DBCon5.Errors.Count
										
					'질문 FaqIDX 조회	
					CSQL = "SELECT IDENT_CURRENT('[SD_tennis].[dbo].[tblSvcFAQ]') "
					SET CRs = DBCon5.Execute(CSQL)
					ErrorNum = ErrorNum + DBCon5.Errors.Count
					
					'답변 등록
					CSQL =" INSERT INTO [SD_tennis].[dbo].[tblSvcFAQ] ( "&_
							"	   [FAPubCode] "&_
							"	  ,[SportsGb] "&_
							"	  ,[ReFaqIDX] "&_
							"	  ,[Contents] "&_
							"	  ,[WriteName] "&_
							"	  ,[WriteDate] "&_
							"	  ,[WorkDt] "&_
							"	  ,[DelYN] "&_
							"	  ,[ViewCnt] "&_
							") VALUES( "&_
							"	 '"&FAPubCode&"' "&_
							"	,'"&SportsGb&"' "&_
							"	,"&CRs(0)&" "&_
							"	,'"&Contents&"' "&_
							"	,'"&RUserName&"' "&_
							"	,GetDate() "&_
							"	,GetDate() "&_
							"	,'N' "&_
							"	,0) "
			
					DBCon5.Execute(CSQL)
					ErrorNum = ErrorNum + DBCon5.Errors.Count
					
				
					If ErrorNum > 0 Then
						DBCon5.RollbackTrans()						
						response.Write "FALSE|66"
						
					Else							
						DBCon5.CommitTrans()						
						response.Write "TRUE|66"	
					End IF	
					
					ErrorNum = 0
					
				END IF	
							
			CASE "MOD"
				IF CIDX = "" Then
					response.Write "FALSE|"
					response.End()
				ELSE
					DBCon5.BeginTrans()
					
					'질문 수정
					CSQL = "		UPDATE [SD_tennis].[dbo].[tblSvcFAQ] "
					CSQL = CSQL & "	SET Contents = '"&Contents&"' "
					CSQL = CSQL & "		,WorkDt = GetDate() "
					CSQL = CSQL & "	WHERE  SportsGb = '"&SportsGb&"' "
					CSQL = CSQL & "		AND FaqIDX = '"&CIDX&"' " 
					
					DBCon5.Execute(CSQL)
					ErrorNum = ErrorNum + DBCon5.Errors.Count
					
					'답변 수정
					CSQL = "		UPDATE [SD_tennis].[dbo].[tblSvcFAQ] "
					CSQL = CSQL & "	SET Contents = '"&RContents&"' "
					CSQL = CSQL & "		,WorkDt = GetDate() "
					CSQL = CSQL & "	WHERE  SportsGb = '"&SportsGb&"' "
					CSQL = CSQL & "		AND ReFaqIDX = '"&CIDX&"' " 
					
					DBCon5.Execute(CSQL)
					ErrorNum = ErrorNum + DBCon5.Errors.Count
					
					If ErrorNum > 0 Then
						DBCon5.RollbackTrans()
						response.Write "FALSE|99"
					Else	
						DBCon5.CommitTrans()						
						response.Write "TRUE|99"	
					End IF	
					
					ErrorNum = 0
					
				END IF	
				
			CASE "DEL"
				
				IF CIDX = "" Then
					response.Write "FALSE|"
					response.End()
				ELSE
					
					DBCon5.BeginTrans()
					
					'질문 삭제처리
					CSQL = "		UPDATE [SD_tennis].[dbo].[tblSvcFAQ] "
					CSQL = CSQL & "	SET DelYN = 'Y' "
					CSQL = CSQL & "		,WorkDt = GetDate() "
					CSQL = CSQL & "	WHERE SportsGb = '"&SportsGb&"' "
					CSQL = CSQL & "		AND FaqIDX = '"&CIDX&"' "
					
					DBCon5.Execute(CSQL)
					ErrorNum = ErrorNum + DBCon5.Errors.Count
					
					'답변 삭제처리
					CSQL = "		UPDATE [SD_tennis].[dbo].[tblSvcFAQ] "
					CSQL = CSQL & "	SET DelYN = 'Y' "
					CSQL = CSQL & "		,WorkDt = GetDate() "
					CSQL = CSQL & "	WHERE SportsGb = '"&SportsGb&"' "
					CSQL = CSQL & "		AND ReFaqIDX = '"&CIDX&"' "
					
					DBCon5.Execute(CSQL)
					ErrorNum = ErrorNum + DBCon5.Errors.Count
					
					If ErrorNum > 0 Then
						DBCon5.RollbackTrans()						
						response.Write "FALSE|100"							
					Else							
						DBCon5.CommitTrans()						
						response.Write "TRUE|100"	
					End IF	
					
					ErrorNum = 0
					
				END IF	
					
		END SELECT
	
	END IF
			
%>