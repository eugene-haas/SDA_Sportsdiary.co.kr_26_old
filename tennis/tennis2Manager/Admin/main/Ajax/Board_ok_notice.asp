<!--#include file="../../dev/dist/config.asp"-->
<%
	'공지사항 수정/삭제/작성 페이지
	dim BRPubCode   : BRPubCode 	= fInject(Request("BRPubCode"))		
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))		
	dim Title   	: Title 		= ReplaceTagText(fInject(Request("Title")))		
	dim Contents   	: Contents 		= ReplaceTagText(fInject(Request("Contents")))	
	dim Notice   	: Notice 		= fInject(Request("Notice"))	
	dim act   		: act 			= fInject(Request("act"))	
	dim SportsGb	: SportsGb		= fInject(Request("SportsGb"))	
	dim UserID		: UserID 		= fInject(Request("UserID"))   
	dim UserName	: UserName 		= fInject(Request("UserName"))
	dim ViewYN		: ViewYN 		= fInject(Request("ViewYN")) 
	
	IF UserName = "관리자" OR UserName = "" Then UserName = "스포츠다이어리"
	
	dim CSQL
	 
	 
'	response.write "act ="&act
'	 response.write "Title ="&Title
'	 response.write "Contents ="&Contents
'	 response.write "BRPubCode ="&BRPubCode
	
	IF act = "" Then
		response.Write "FALSE|200"
		response.End()	
	ELSE	
		
		SELECT CASE act
			CASE "WR"
				IF Title = "" OR Contents = "" OR BRPubCode = "" Then
					response.Write "FALSE|200"
					response.End()
				ELSE
					CSQL =" INSERT INTO [SD_tennis].[dbo].[tblSvcNotice] ( "&_
							"	   [BRPubCode] "&_
							"	  ,[SportsGb] "&_
							"	  ,[Notice] "&_
							"	  ,[Title] "&_
							"	  ,[Contents] "&_
							"	  ,[UserID] "&_
							"	  ,[UserName] "&_
							"	  ,[WriteDate] "&_
							"	  ,[WorkDt] "&_
							"	  ,[DelYN] "&_
							"	  ,[ViewTp] "&_
							"	  ,[ViewYN] "&_
	 						"	  ,[ViewCnt] "&_
							") VALUES( "&_
							"	 '"&BRPubCode&"' "&_
							"	,'"&SportsGb&"' "&_
							"	,'"&Notice&"' "&_
							"	,'"&Title&"' "&_
							"	,'"&Contents&"' "&_
							"	,'"&UserID&"' "&_
							"	,'"&UserName&"' "&_
							"	,GetDate() "&_
							"	,GetDate() "&_
							"	,'N' "&_
							"	,'A' "&_
							"	,'"&ViewYN&"' "&_		
							"	,0) "
			
					DBCon5.Execute(CSQL)
					
					IF DBCon5.Errors.Count > 0 Then
						response.Write "FALSE|66"	
						response.End()
					Else
						response.Write "TRUE|90"	
						response.End()
					End IF	
					
				END IF	
						
						
							
			CASE "MOD"
				IF CIDX = "" Then
					response.Write "FALSE|200"
					response.End()
				ELSE
					CSQL = "		SELECT COUNT(*)"
					CSQL = CSQL & "	FROM [SD_tennis].[dbo].[tblSvcNotice] "
					CSQL = CSQL & "	WHERE DelYN = 'N' "
					CSQL = CSQL & "		AND NtcIDX = '"&CIDX&"' "
					
					SET CRs = DBCon5.Execute(CSQL)
					IF CRs(0) > 0 Then
						
						CSQL = "		UPDATE [SD_tennis].[dbo].[tblSvcNotice] "
						CSQL = CSQL & "	SET BRPubCode = '"&BRPubCode&"' "
						CSQL = CSQL & "		,Notice = '"&Notice&"' "
						CSQL = CSQL & "		,Title = '"&Title&"' "
						CSQL = CSQL & "		,Contents = '"&Contents&"' "
						CSQL = CSQL & "		,ViewYN = '"&ViewYN&"' "
						CSQL = CSQL & "		,WorkDt = GetDate() "
						CSQL = CSQL & "	WHERE DelYN = 'N' "
						CSQL = CSQL & "		AND NtcIDX = '"&CIDX&"' "
						
						DBCon5.Execute(CSQL)
						
						IF DBCon5.Errors.Count > 0 Then
							response.Write "FALSE|66"	
							response.End()
						Else
							response.Write "TRUE|80"	
							response.End()
						End IF	
						
					Else
						response.Write "FALSE|99"
						response.End()
					End IF
					
						CRs.Close
					SET CRs = Nothing	

				END IF	
				
			CASE "DEL"
				IF CIDX = "" Then
					response.Write "FALSE|200"
					response.End()
				ELSE
					CSQL = "		SELECT COUNT(*)"
					CSQL = CSQL & "	FROM [SD_tennis].[dbo].[tblSvcNotice] "
					CSQL = CSQL & "	WHERE DelYN = 'N' "
					CSQL = CSQL & "		AND NtcIDX = '"&CIDX&"' "
					
					SET CRs = DBCon5.Execute(CSQL)
					IF CRs(0) > 0 Then
						CSQL = "		UPDATE [SD_tennis].[dbo].[tblSvcNotice] "
						CSQL = CSQL & "	SET DelYN = 'Y' "
						CSQL = CSQL & "		,WorkDt = GetDate() "
						CSQL = CSQL & "	WHERE DelYN = 'N' "
						CSQL = CSQL & "		AND NtcIDX = '"&CIDX&"' "
						
						DBCon5.Execute(CSQL)
						
						IF DBCon5.Errors.Count > 0 Then
							response.Write "FALSE|66"	
							response.End()
						Else
							response.Write "TRUE|70"	
							response.End()
						End IF	
						
					Else
						response.Write "FALSE|99"
						response.End()
					End IF
					
						CRs.Close
					SET CRs = Nothing	
					
				END IF	
					
		END SELECT
	
	END IF
			
%>