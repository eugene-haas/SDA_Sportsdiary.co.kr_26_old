<!--#include file="../../dev/dist/config.asp"-->
<%
	'Q&A 수정/삭제/작성 페이지

	
	dim QnAType   	: QnAType 		= fInject(Request("QnAType"))		
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))		
	dim RQnAIDX 	: RQnAIDX 		= fInject(request("RQnAIDX"))		
	dim RTitle   	: RTitle 		= ReplaceTagText(fInject(Request("RTitle")))		
	dim RContents   : RContents 	= ReplaceTagText(fInject(Request("RContents")))	
	dim RUserID		: RUserID 		= fInject(Request("RUserID"))   
	dim RUserName	: RUserName 	= fInject(Request("RUserName"))

	dim act   		: act 			= fInject(Request("act"))	
	dim SportsGb	: SportsGb		= fInject(Request("SportsGb"))	
	
	IF RUserName = "관리자" OR RUserName = "" Then RUserName = "스포츠다이어리"
	
	dim CSQL
	
	IF act = "" Then
		response.Write "FALSE|"
		response.End()	
	ELSE	
		
		SELECT CASE act
			
			CASE "WR"
				IF CIDX = "" OR RTitle = "" OR RContents = "" OR RUserID = "" OR RUserName = "" Then
					response.Write "FALSE|"
					response.End()
				ELSE
					'답변등록
					CSQL =" INSERT INTO [SD_tennis].[dbo].[tblSvcQnA] ( "&_
							"	   [QnAType] "&_
							"	  ,[ReQnAIDX] "&_
							"	  ,[SportsGb] "&_
							"	  ,[Title] "&_
							"	  ,[Contents] "&_
							"	  ,[MemberIDX] "&_
							"	  ,[UserName] "&_
							"	  ,[ViewCnt] "&_
							"	  ,[WriteDate] "&_
							"	  ,[WorkDt] "&_
							"	  ,[DelYN] "&_
							") VALUES( "&_
							"	 '"&QnAType&"' "&_
							"	,'"&CIDX&"' "&_
							"	,'"&SportsGb&"' "&_
							"	,'"&RTitle&"' "&_
							"	,'"&RContents&"' "&_
							"	,'999999' "&_
							"	,'"&RUserName&"' "&_
							"	,0"&_
							"	,GetDate() "&_
							"	,GetDate() "&_
							"	,'N') "
				
					DBCon5.Execute(CSQL)
					
					response.Write "TRUE|66"	
					response.End()
					
				END IF	
							
			CASE "MOD"
				IF CIDX = "" Then
					response.Write "FALSE|"
					response.End()
				ELSE
					'답변 수정
					CSQL = "		UPDATE [SD_tennis].[dbo].[tblSvcQnA] "
					CSQL = CSQL & "	SET Title = '"&RTitle&"' "
					CSQL = CSQL & "		,Contents = '"&RContents&"' "
					CSQL = CSQL & "		,WorkDt = GetDate() "
					CSQL = CSQL & "	WHERE DelYN = 'N' "
					CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "
					CSQL = CSQL & "		AND QnAIDX = '"&RQnAIDX&"' "
					
					DBCon5.Execute(CSQL)
					
					response.Write "TRUE|99"	
					response.End()
				END IF	
				
			CASE "DEL"
				IF CIDX = "" Then
					response.Write "FALSE|"
					response.End()
				ELSE
					
					CSQL = "		UPDATE [SD_tennis].[dbo].[tblSvcQnA] "
					CSQL = CSQL & "	SET DelYN = 'Y' "
					CSQL = CSQL & "		,WorkDt = GetDate() "
					CSQL = CSQL & "	WHERE SportsGb = '"&SportsGb&"' "
					CSQL = CSQL & "		AND QnAIDX = '"&RQnAIDX&"' "
					
					DBCon5.Execute(CSQL)
					
					response.Write "TRUE|100"	
					response.End()
				END IF	
					
		END SELECT
	
	END IF
			
%>