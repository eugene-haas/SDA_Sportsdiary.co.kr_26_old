<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'대표팀 등록 - 지도자
	'==============================================================================================
	Check_AdminLogin()

	dim valType 		: valType 		=  fInject(Request("valType"))
	dim CIDX 			: CIDX 			=  fInject(Request("CIDX"))
   	dim MemberIDX 		: MemberIDX 	=  fInject(Request("MemberIDX"))
	dim PeriodDateS		: PeriodDateS 	=  trim(fInject(Request("PeriodDateS")))
	dim PeriodDateE		: PeriodDateE 	=  trim(fInject(Request("PeriodDateE"))) 
	dim txtMemo		 	: txtMemo		=  HtmlSpecialChars(trim(fInject(Request("txtMemo"))))
	dim Sex 			: Sex 			=  fInject(Request("Sex"))
	dim RegYear 		: RegYear 		=  fInject(Request("RegYear"))
   	dim TeamGb 			: TeamGb 		=  fInject(Request("TeamGb"))
   	dim SubstituteYN 	: SubstituteYN	=  fInject(Request("SubstituteYN"))
	dim LeaderType 		: LeaderType	=  fInject(Request("LeaderType"))
	dim LeaderTypeSub 	: LeaderTypeSub	=  fInject(Request("LeaderTypeSub")) 
   	
   	dim UserID 			: UserID 		= crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("UserID")))	
	
   	
	IF valType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
		
		SELECT CASE valType
			
			CASE "DEL"
			
				IF CIDX <> "" Then
					LSQL =  "		UPDATE [KoreaBadminton].[dbo].[tblMemberKorea]" 
	 				LSQL = LSQL & " SET DelYN = 'Y'"
					LSQL = LSQL & " 	,ModID = '"&UserID&"'"
					LSQL = LSQL & "		,PeriodDateS = '" & PeriodDateS & "'"
					LSQL = LSQL & "		,PeriodDateE = '" & PeriodDateE & "'"														 
					LSQL = LSQL & " 	,ModDate = GETDATE()"
					LSQL = LSQL & " WHERE MemberKoreaIDX = '" & CIDX & "'"
					
					DBCon.Execute(LSQL)
					
					IF DBCon.Errors.Count > 0 Then
						response.Write "FALSE|66"
						response.End()
					Else
						response.Write "TRUE|70"
						response.End()
					End IF
				Else
					response.Write "FALSE|200"
					response.End()
				End IF
				
				
			CASE "MOD"
		
				IF CIDX <> "" Then					
						
					LSQL = "		UPDATE [KoreaBadminton].[dbo].[tblMemberKorea] " 
					LSQL = LSQL & " SET MemberIDX = '" & MemberIDX & "'"
					LSQL = LSQL & "		,RegYear = '" & RegYear & "'"
					LSQL = LSQL & "		,TeamGb = '" & TeamGb & "'"
					LSQL = LSQL & "		,SubstituteYN = '" & SubstituteYN & "'"
					LSQL = LSQL & "		,PeriodDateS = '" & PeriodDateS & "'"
					LSQL = LSQL & "		,PeriodDateE = '" & PeriodDateE & "'"
					LSQL = LSQL & "		,txtMemo = '" & txtMemo & "'"
					LSQL = LSQL & "		,Sex = '" & Sex & "'"
					LSQL = LSQL & "		,LeaderType = '" & LeaderType & "'"
					LSQL = LSQL & "		,LeaderTypeSub = '" & LeaderTypeSub & "'"
					LSQL = LSQL & "		,ModID = '" & UserID & "'"
					LSQL = LSQL & "		,ModDate = GETDATE()"
					LSQL = LSQL & " WHERE MemberKoreaIDX = '" & CIDX & "'"

					DBCon.Execute(LSQL)

					IF DBCon.Errors.Count > 0 Then
						response.Write "FALSE|66"
						response.End()
					Else
						response.Write "TRUE|80"
						response.End()
					End IF
				Else
					response.Write "FALSE|200"
					response.End()
				End IF
				
				
			CASE "SAVE"
				LSQL = "		SELECT COUNT(*) "
				LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblMemberKorea]"
				LSQL = LSQL & " WHERE DelYN = 'N'"
				LSQL = LSQL & " 	AND RegYear = '"&RegYear&"'"
				LSQL = LSQL & "		AND MemberType = 'L'"
				LSQL = LSQL & " 	AND MemberIDX = '"&MemberIDX&"'"

				SET LRs = DBCon.Execute(LSQL)
				IF LRs(0) > 0 Then 
					response.Write "FALSE|99"
					response.End()
				Else
					
					LSQL = "		INSERT INTO [KoreaBadminton].[dbo].[tblMemberKorea] (" 
					LSQL = LSQL & "		MemberIDX "  
					LSQL = LSQL & "		,MemberType " 
					LSQL = LSQL & "		,RegYear " 
					LSQL = LSQL & "		,TeamGb " 										
					LSQL = LSQL & "		,SubstituteYN " 
					LSQL = LSQL & "		,PeriodDateS " 
					LSQL = LSQL & "		,PeriodDateE " 
					LSQL = LSQL & "		,txtMemo " 
					LSQL = LSQL & "		,Sex"  
					LSQL = LSQL & "		,LeaderType"  
					LSQL = LSQL & "		,LeaderTypeSub"  
					LSQL = LSQL & "		,DelYN "  					
					LSQL = LSQL & "		,InsID "  					
					LSQL = LSQL & "		,InsDate "  					
					LSQL = LSQL & "		,ModDate "  						
					LSQL = LSQL & "	) VALUES( " 
					LSQL = LSQL & "		'" & MemberIDX & "'" 
					LSQL = LSQL & "		,'L'" 
					LSQL = LSQL & "		,'" & RegYear & "'" 
					LSQL = LSQL & "		,'" & TeamGb & "'" 
					LSQL = LSQL & "		,'" & SubstituteYN & "'" 
					LSQL = LSQL & "		,'" & PeriodDateS & "'" 
					LSQL = LSQL & "		,'" & PeriodDateE & "'" 
					LSQL = LSQL & "		,'" & txtMemo & "'" 
					LSQL = LSQL & "		,'" & Sex & "'" 			
					LSQL = LSQL & "		,'" & LeaderType & "'" 			
					LSQL = LSQL & "		,'" & LeaderTypeSub & "'" 																  
					LSQL = LSQL & "		,'N'" 
					LSQL = LSQL & "		,'" & UserID & "'" 			
					LSQL = LSQL & "		,GETDATE()" 
					LSQL = LSQL & "		,GETDATE()" 
					LSQL = LSQL & "	)"

					DBCon.Execute(LSQL)
				
					IF DBCon.Errors.Count > 0 Then
						response.Write "FALSE|66"
						response.End()
					Else
						response.Write "TRUE|90"
						response.End()
					End IF

				End IF
					LRs.Close
				SET LRs = Nothing
			
		END SELECT
			
	End IF 
%>