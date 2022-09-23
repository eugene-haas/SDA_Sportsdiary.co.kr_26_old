<!--#include file = "../Library/ajax_config.asp"-->
<%
    Check_Login()
   
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))	
	dim Contents   	: Contents 		= ReplaceTagText(fInject(Request("Contents")))
	dim Title   	: Title 		= ReplaceTagText(fInject(Request("Title")))		
	dim strType   	: strType 		= fInject(Request("strType"))		'action
	
    dim UserName   	: UserName  	= request.Cookies("SD")("UserName")	
	dim MemberIDX   : MemberIDX 	= decode(request.Cookies("SD")("MemberIDX"), 0)
	
	
	dim CSQL
	
	IF strType="" Then
		response.Write "FALSE"
		response.End()
	ELSE	
		
		SELECT CASE strType
			CASE "WR"
				
				IF  MemberIDX = "" OR Title="" OR Contents="" Then
					response.Write "FALSE"
					response.End()
				Else
					
					CSQL =" INSERT INTO [SD_tennis].[dbo].[tblSvcQnA] ( "&_
							"	   [SportsGb] "&_
							"	  ,[Title] "&_
							"	  ,[Contents] "&_
							"	  ,[MemberIDX] "&_
							"	  ,[UserName] "&_
							"	  ,[WriteDate] "&_
							"	  ,[WorkDt] "&_
							"	  ,[DelYN] "&_
							"	  ,[QnAType] "&_
							"	  ,[ReQnAIDX] "&_
							"	  ,[ViewCnt] "&_
							") VALUES( "&_
							"	 '"&SportsGb&"' "&_
							"	,'"&Title&"' "&_
							"	,'"&Contents&"' "&_
							"	,'"&MemberIDX&"' "&_
							"	,'"&UserName&"' "&_
							"	,GetDate() "&_
							"	,GetDate() "&_
							"	,'N' "&_
							"	,'P' "&_
							"	,0 "&_
							"	,0) "
			
					DBCon3.Execute(CSQL)
					
					response.Write "TRUE"	
					response.End()
					
				End IF	
			
			CASE "REPLY"
			
				IF CIDX="" OR  MemberIDX="" OR Title="" OR Contents="" Then
					response.Write "FALSE"
					response.End()
				Else
					
					CSQL =" INSERT INTO [SD_tennis].[dbo].[tblSvcQnA] ( "&_
							"	   [SportsGb] "&_
							"	  ,[Title] "&_
							"	  ,[Contents] "&_
							"	  ,[MemberIDX] "&_
							"	  ,[UserName] "&_
							"	  ,[WriteDate] "&_
							"	  ,[WorkDt] "&_
							"	  ,[DelYN] "&_
							"	  ,[QnAType] "&_
							"	  ,[ViewCnt] "&_
							"	  ,[ReQnAIDX] "&_
							") VALUES( "&_
							"	 '"&SportsGb&"' "&_
							"	,'"&Title&"' "&_
							"	,'"&Contents&"' "&_
							"	,'"&MemberIDX&"' "&_
							"	,'"&UserName&"' "&_
							"	,GetDate() "&_
							"	,GetDate() "&_
							"	,'N' "&_
							"	,'P' "&_
							"	,0 "&_
							"	,"&CIDX&") "
			
					DBCon3.Execute(CSQL)

					response.Write "TRUE"	
					response.End()
					
				End IF	
				
		 	CASE "MOD"		
		 		
				IF CIDX="" OR MemberIDX="" OR Title="" OR Contents="" Then
					response.Write "FALSE"
					response.End()
				Else
					CSQL =" 	UPDATE [SD_tennis].[dbo].[tblSvcQnA] "&_
							"	SET	" &_
							"	   [Title] = '"&Title&"' "&_
							"	  ,[Contents] = '"&Contents&"' "&_
							"	  ,[WorkDt] = GetDate() "&_
							" 	WHERE DelYN = 'N' "&_
							"		AND SportsGb = '"&SportsGb&"'"&_
							"		AND QnAIDX = "&CIDX &_
							" 	 	AND MemberIDX = '"&MemberIDX&"'"
				
					DBCon3.Execute(CSQL)
					
					response.Write "TRUE"					
					response.End()
					
				End IF
				
		END SELECT	
	End IF
%>