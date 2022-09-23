<!--#include file="../../dev/dist/config.asp"-->
<%
	'문의내용 업데이트 페이지
	dim valType   		: valType  		= fInject(Request("valType"))
	dim txtReContent   	: txtReContent 	= fInject(Request("txtReContent"))	
	dim ResultGb		: ResultGb 		= fInject(Request("ResultGb"))
	dim CIDX			: CIDX			= decode(fInject(Request("CIDX")), 0)
	 
	dim UserID			: UserID		= decode(request.Cookies("UserID"), 0)
	 
	IF CIDX = "" Then	 	
		response.write "FALSE|200"		
		response.end
	Else
	 	dim LSQL, LRs
		
	 	On Error Resume Next
			
		DBCon.BeginTrans()
	 
	 
		LSQL = "		SELECT * "	
		LSQL = LSQL & "	FROM [SD_Member].[dbo].[tblAllianceInfo] "	
		LSQL = LSQL & "	WHERE DelYN = 'N'"	
		LSQL = LSQL & "		AND AllianceIDX = '"&CIDX&"'"

		SET LRs =  DBCon.Execute(LSQL)  
		IF Not(LRs.Eof OR LRs.Bof) Then		
														
			SELECT CASE valType
				CASE "MOD"
					LSQL = "		UPDATE [SD_Member].[dbo].[tblAllianceInfo] "	
					LSQL = LSQL & "	SET txtReContent = '"&txtReContent&"'"
					LSQL = LSQL & "		,ResultGb = '"&ResultGb&"'"
					LSQL = LSQL & "		,ResultDate = GETDATE()"
					LSQL = LSQL & "		,ModID = '"&UserID&"'"
					LSQL = LSQL & "		,ModDate = GETDATE()"					
					LSQL = LSQL & "	WHERE DelYN = 'N'"	
					LSQL = LSQL & "		AND AllianceIDX = '"&CIDX&"'"									
														
				CASE "DEL"
					LSQL = "		UPDATE [SD_Member].[dbo].[tblAllianceInfo] "	
					LSQL = LSQL & "	SET DelYN = 'Y'"
					LSQL = LSQL & "		,ModID = '"&UserID&"'"
					LSQL = LSQL & "		,ModDate = GETDATE()"					
					LSQL = LSQL & "	WHERE DelYN = 'N'"	
					LSQL = LSQL & "		AND AllianceIDX = '"&CIDX&"'"	
																	
			END SELECT
				
			DBCon.Execute(LSQL)

			IF DBCon.Errors.Count > 0 Then
				DBCon.RollbackTrans()				
				Response.Write "FALSE|66"				
			Else					
				DBCon.CommitTrans()											
				Response.Write "TRUE|"&valType
			End IF

		Else
			response.write "FALSE|99"		
			response.end
		End IF
			LRs.Close
		SET LRs = Nothing
		
		DBClose3()
	 
	End IF
														  

%>