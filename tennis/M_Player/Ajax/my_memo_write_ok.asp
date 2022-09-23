<!--#include file = "../Library/ajax_config.asp"-->
<%
	'====================================================================================
	'나의 메모장 작성/수정 페이지
	'====================================================================================
	dim strType   	: strType 		= fInject(Request("strType"))		'action
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))	
	dim Title   	: Title 		= ReplaceTagText(fInject(Request("Title")))		
	dim Contents   	: Contents 		= ReplaceTagText(fInject(Request("Contents")))
	
	
	dim UserName   	: UserName  	= request.Cookies("SD")("UserName")
	dim UserID	   	: UserID  		= request.Cookies("SD")("UserID")

	dim CSQL
	
	IF strType = "" OR UserID = "" OR Title = "" OR Contents = "" Then
		response.Write "FALSE"
		response.End()
	ELSE	
		
		SELECT CASE strType
			CASE "WR"
				
				CSQL = " 		INSERT INTO [SD_tennis].[dbo].[tblSvcMemo] ( "
				CSQL = CSQL & "	   [SportsGb] "
				CSQL = CSQL & "	  ,[Title] "
				CSQL = CSQL & "	  ,[Contents] "
				CSQL = CSQL & "	  ,[UserID] "
				CSQL = CSQL & "	  ,[UserName] "
				CSQL = CSQL & "	  ,[WriteDate] "
				CSQL = CSQL & "	  ,[WorkDt] "
				CSQL = CSQL & "	  ,[DelYN] "
				CSQL = CSQL & ") VALUES( "
				CSQL = CSQL & "	 '"&SportsGb&"' "
				CSQL = CSQL & "	,'"&Title&"' "
				CSQL = CSQL & "	,'"&Contents&"' "
				CSQL = CSQL & "	,'"&UserID&"' "
				CSQL = CSQL & "	,'"&UserName&"' "
				CSQL = CSQL & "	,GetDate() "
				CSQL = CSQL & "	,GetDate() "
				CSQL = CSQL & "	,'N') "
		
				DBCon3.Execute(CSQL)
				
				response.Write "TRUE"	
			
		 	CASE "MOD"		 		
			
				CSQL = "  		UPDATE [SD_tennis].[dbo].[tblSvcMemo] "
				CSQL = CSQL & "	SET	[Title] = '"&Title&"' "
				CSQL = CSQL & "	  ,[Contents] = '"&Contents&"' "
				CSQL = CSQL & "	  ,[WorkDt] = GetDate() "
				CSQL = CSQL & " WHERE DelYN = 'N' "
				CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"'"
				CSQL = CSQL & "		AND MemoIDX = "&CIDX 
				CSQL = CSQL & " 	AND UserID = '"&UserID&"'"
				
				DBCon3.Execute(CSQL)
				
				response.Write "TRUE"					
		END SELECT	
	End IF
%>