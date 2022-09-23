<!--#include file="../Library/ajax_config.asp"-->
<%
	'선수보호자 상담요청하기 작성페이지
	
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))	
	dim Contents   	: Contents 		= ReplaceTagText(fInject(Request("Contents")))
	dim Title   	: Title 		= ReplaceTagText(fInject(Request("Title")))		
	dim strType   	: strType 		= fInject(Request("strType"))		

	dim UserID   	: UserID  		= decode(request.Cookies("UserID"), 0)
	dim UserName   	: UserName  	= request.Cookies("UserName")
	
	'선수 보호자 회원의 경우 MemberIDX 쿠키 교체되었기 때문에 선수보호자 MemberIDX로 교체
	SELECT CASE decode(request.Cookies("PlayerReln"), 0)
		CASE "A","B","Z" 	: MemberIDX = decode(request.Cookies("P_MemberIDX"),0) 
		CASE ELSE			: MemberIDX = decode(request.Cookies("MemberIDX"),0) 
	END SELECT
	

	dim CSQL, LSQL
	
	IF strType="" Then
		response.Write "FALSE"
		response.End()
	ELSE	
		
		SELECT CASE strType
			CASE "WR"
				
				IF  UserID="" OR Title="" OR Contents="" Then
					response.Write "FALSE"
					response.End()
				Else
					
					CSQL = " 		INSERT INTO [Sportsdiary].[dbo].[tblSvcLedrAdv] ( "
					CSQL = CSQL & "	   [SportsGb] "
					CSQL = CSQL & "	  ,[Title] "
					CSQL = CSQL & "	  ,[Contents] "
					CSQL = CSQL & "	  ,[UserID] "
					CSQL = CSQL & "	  ,[UserName] "
					CSQL = CSQL & "	  ,[MarkYN] "
					CSQL = CSQL & "	  ,[WriteDate] "
					CSQL = CSQL & "	  ,[WorkDt] "
					CSQL = CSQL & "	  ,[DelYN] "
					CSQL = CSQL & "	  ,[ReLedrAdvIDX] "
					CSQL = CSQL & ") VALUES( "
					CSQL = CSQL & "	 '"&SportsGb&"' "
					CSQL = CSQL & "	,'"&Title&"' "
					CSQL = CSQL & "	,'"&Contents&"' "
					CSQL = CSQL & "	,'"&UserID&"' "
					CSQL = CSQL & "	,'"&UserName&"' "
					CSQL = CSQL & "	,'N' "
					CSQL = CSQL & "	,GetDate() "
					CSQL = CSQL & "	,GetDate() "
					CSQL = CSQL & "	,'N' "
					CSQL = CSQL & "	,0) "
			
					Dbcon.Execute(ChkSQL)
					response.Write "TRUE"	
					response.End()
					
				End IF	
			
			CASE "REPLY"
			
				IF CIDX="" OR  UserID="" OR Title="" OR Contents="" Then
					response.Write "FALSE"
					response.End()
				Else
					
					CSQL = " 		INSERT INTO [Sportsdiary].[dbo].[tblSvcLedrAdv] ( "
					CSQL = CSQL & "	   [SportsGb] "
					CSQL = CSQL & "	  ,[Title] "
					CSQL = CSQL & "	  ,[Contents] "
					CSQL = CSQL & "	  ,[UserID] "
					CSQL = CSQL & "	  ,[UserName] "
					CSQL = CSQL & "	  ,[WriteDate] "
					CSQL = CSQL & "	  ,[WorkDt] "
					CSQL = CSQL & "	  ,[DelYN] "
					CSQL = CSQL & "	  ,[ReLedrAdvIDX] "
					CSQL = CSQL & ") VALUES( "
					CSQL = CSQL & "	 '"&SportsGb&"' "
					CSQL = CSQL & "	,'"&Title&"' "
					CSQL = CSQL & "	,'"&Contents&"' "
					CSQL = CSQL & "	,'"&UserID&"' "
					CSQL = CSQL & "	,'"&UserName&"' "
					CSQL = CSQL & "	,GetDate() "
					CSQL = CSQL & "	,GetDate() "
					CSQL = CSQL & "	,'N' "
					CSQL = CSQL & "	,"&CIDX&") "
			
					Dbcon.Execute(ChkSQL)
					response.Write "TRUE"	
					response.End()
					
				End IF	
				
		 	CASE "MOD"		
		 		
				IF CIDX="" OR UserID="" OR Title="" OR Contents="" Then
					response.Write "FALSE"
					response.End()
				Else
					CSQL = "		UPDATE [Sportsdiary].[dbo].[tblSvcLedrAdv] "
					CSQL = CSQL & "	SET	[Title] = '"&Title&"' "
					CSQL = CSQL & "	  ,[Contents] = '"&Contents&"' "
					CSQL = CSQL & "	  ,[WorkDt] = GetDate() "
					CSQL = CSQL & " WHERE DelYN = 'N' "
					CSQL = CSQL & "		AND LedrAdvIDX = "&CIDX 
					CSQL = CSQL & "  	AND UserID = '"&UserID&"'"
					
					Dbcon.Execute(ChkSQL)
					response.Write "TRUE"					
					response.End()
					
				End IF
				
			'즐겨찾기 설정
			CASE "FAV"	
				dim chkFAV
				
				CSQL = " 		SELECT * "					
				CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcLedrAdvSub] " 
				CSQL = CSQL & " WHERE MemberIDX = '"&MemberIDX&"' "
				CSQL = CSQL & "		AND LedrAdvIDx = "&CIDX
				CSQL = CSQL & "		AND TypeLedrAdv = 'F'"
				
				SET CRs = Dbcon.Execute(ChkSQL)
				IF Not(CRs.eof or CRs.bof) Then	
					'질문과 답변 즐겨찾기 설정/해제
						
						LSQL = 	" 		 UPDATE [Sportsdiary].[dbo].[tblSvcLedrAdvSub] " 
						LSQL = 	LSQL & " SET WorkDt = GetDate() "
								
						SELECT CASE CRs("DelYN")
							CASE "N" : 	LSQL = LSQL & ",DelYN = 'Y'" : chkFAV="Y"	'해제
							CASE ELSE : LSQL = LSQL & ",DelYN = 'N'" : chkFAV="N"	'설정
						END SELECT
						
						LSQL = 	LSQL & " WHERE LedrAdvIDX = "&CIDX
						LSQL = 	LSQL & " 	AND UserID = '"&UserID&"'"
						LSQL = 	LSQL & " 	AND TypeLedrAdv = 'F'"
							
						Dbcon.Execute(LSQL)	
						
						response.Write "TRUE|"&chkFAV	
						response.End()							
				Else
					
					LSQL = "		 INSERT INTO [Sportsdiary].[dbo].[tblSvcLedrAdvSub] (" 
					LSQL = 	LSQL & " 	 LedrAdvIDX " 
					LSQL = 	LSQL & "	,MemberIDX " 
					LSQL = 	LSQL & "	,UserID " 
					LSQL = 	LSQL & "	,TypeLedrAdv " 
					LSQL = 	LSQL & "	,WriteDate " 
					LSQL = 	LSQL & "	,WorkDt " 
					LSQL = 	LSQL & "	,DelYN " 
					LSQL = 	LSQL & " ) VALUES ( "
					LSQL = 	LSQL & "	 "&CIDX 
					LSQL = 	LSQL & "	,"&MemberIDX 
					LSQL = 	LSQL & "	,'"&UserID &"' "
					LSQL = 	LSQL & "	,'F' " 
					LSQL = 	LSQL & "	,GetDate() " 
					LSQL = 	LSQL & "	,GetDate() " 
					LSQL = 	LSQL & "	,'N') "		
					
							
					Dbcon.Execute(LSQL)						
					
					
					response.Write "TRUE|N"		
					response.End()
					
							
				End IF							
					CRs.Close
				SET CRs = Nothing	
				
				
				
		END SELECT	
	End IF
%>