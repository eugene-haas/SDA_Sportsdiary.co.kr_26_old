<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'소속팀 이적관리 등록페이지
   	'/Main_HP/TeamTransfer.asp
	'==============================================================================================
	Check_AdminLogin()
	
   	dim CIDX 			: CIDX 				= crypt.DecryptStringENC(fInject(Request("CIDX")))
	dim UserID 			: UserID 			= crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("UserID")))		   
	dim MemberIDX 		: MemberIDX 		= fInject(trim(request("MemberIDX")))   	
   	dim MemberHisIDX 	: MemberHisIDX 		= fInject(trim(request("MemberHisIDX")))   	
	dim MemberType 		: MemberType 		= fInject(trim(request("MemberType")))
   	dim UserName 		: UserName 			= fInject(trim(request("UserName")))
	dim TeamBefore 		: TeamBefore 		= fInject(trim(request("TeamBefore")))
   	dim TeamBefore_Old	: TeamBefore_Old 	= fInject(trim(request("TeamBefore_Old")))
	dim TeamAfter 		: TeamAfter 		= fInject(trim(request("TeamAfter")))
   	dim TeamAfter_Old	: TeamAfter_Old 	= fInject(trim(request("TeamAfter_Old")))
	dim TransDate 		: TransDate 		= fInject(trim(request("TransDate")))
   	dim ApprovalGb 		: ApprovalGb 		= fInject(trim(request("ApprovalGb")))
   	dim txtMemo 		: txtMemo 			= HtmlSpecialChars(fInject(request("txtMemo"))) 
   	dim valType 		: valType 			= fInject(trim(request("valType")))
   	dim ErrorNum

	IF valType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
		
		SELECT CASE valType
			CASE "MOD"
		
				IF CIDX <> "" Then
					
					LSQL = "		SELECT * "
					LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblTeamTransfer] "
					LSQL = LSQL & " WHERE DelYN = 'N'"
					LSQL = LSQL & " 	AND TeamTransferIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then

						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblTeamTransfer] " 
						LSQL =  LSQL & " SET MemberIDX = '" & MemberIDX & "'"
						LSQL =  LSQL & "	,MemberHisIDX = '" & MemberHisIDX & "'"
						LSQL =  LSQL & "	,MemberType = '" & MemberType & "'"
						LSQL =  LSQL & "	,UserName = '" & UserName & "'"
						LSQL =  LSQL & "	,TeamBefore = '" & TeamBefore & "'"						
						LSQL =  LSQL & "	,TeamAfter = '" & TeamAfter & "'"						
						LSQL =  LSQL & "	,TransDate = '" & TransDate & "'"						
						LSQL =  LSQL & "	,ApprovalGb = '" & ApprovalGb & "'"						
						LSQL =  LSQL & "	,ApprDate = GETDATE()"						
						LSQL =  LSQL & "	,txtMemo = '" & txtMemo & "'"						
						LSQL =  LSQL & "	,ModID = '" & UserID & "'"						
						LSQL =  LSQL & "	,ModDate = GETDATE()"
						LSQL =  LSQL & " WHERE TeamTransferIDX = '" & CIDX & "'"
						
						DBCon.Execute(LSQL)
						ErrorNum = ErrorNum + DBCon.Errors.Count 
						
						IF TeamAfter <> TeamAfter_Old Then
							CALL MEMBER_UPDATE()
						End IF

						IF ErrorNum > 0 Then
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
						
				Else
					response.Write "FALSE|200"
					response.End()
				End IF
				
				
			CASE "SAVE"

				LSQL =  "		INSERT INTO [KoreaBadminton].[dbo].[tblTeamTransfer] (" 
				LSQL =  LSQL & "	MemberIDX "	
				LSQL =  LSQL & "	,MemberHisIDX "	
				LSQL =  LSQL & "	,MemberType "  
				LSQL =  LSQL & "	,UserName " 
				LSQL =  LSQL & "	,TeamBefore " 										
				LSQL =  LSQL & "	,TeamAfter " 
				LSQL =  LSQL & "	,TransDate"  
				LSQL =  LSQL & "	,ApprovalGb"  
				LSQL =  LSQL & "	,ApprDate"				
				LSQL =  LSQL & "	,txtMemo"  
				LSQL =  LSQL & "	,DelYN "  					
				LSQL =  LSQL & "	,InsDate "  					
				LSQL =  LSQL & "	,InsID "  					
				LSQL =  LSQL & "	,ModDate "				
				LSQL =  LSQL & ") VALUES( " 
				LSQL =  LSQL & "	'" & MemberIDX & "'" 			
				LSQL =  LSQL & "	,'" & MemberHisIDX & "'" 			
				LSQL =  LSQL & "	,'" & MemberType & "'" 
				LSQL =  LSQL & "	,'" & UserName & "'" 
				LSQL =  LSQL & "	,'" & TeamBefore & "'" 
				LSQL =  LSQL & "	,'" & TeamAfter & "'" 
				LSQL =  LSQL & "	,'" & TransDate & "'" 			
				LSQL =  LSQL & "	,'APPR_1'" 						'tblPubCode[PubCode='APPROVAL'] 기본값세팅
				LSQL =  LSQL & "	,GETDATE()"				
				LSQL =  LSQL & "	,'" & txtMemo & "'" 
				LSQL =  LSQL & "	,'N'" 
				LSQL =  LSQL & "	,GETDATE()" 
				LSQL =  LSQL & "	,'" & UserID & "'" 			
				LSQL =  LSQL & "	,GETDATE()" 				
				LSQL =  LSQL & ")"				
				
				DBCon.Execute(LSQL)
				ErrorNum = ErrorNum + DBCon.Errors.Count
   
   				CALL MEMBER_UPDATE()
   
   
				IF ErrorNum > 0 Then
					response.Write "FALSE|66"
					response.End()
				Else
					response.Write "TRUE|90"
					response.End()
				End IF
			
		END SELECT
			
	End IF 



	'Member 소속변경
   	SUB MEMBER_UPDATE()
   		
   		IF MemberType = "L" Then

			LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblLeaderInfo] " 
			LSQL =  LSQL & " SET Team = '" & TeamAfter & "'"						
			LSQL =  LSQL & "	,ModID = '" & UserID & "'"						
			LSQL =  LSQL & "	,ModDate = GETDATE()"
			LSQL =  LSQL & " WHERE DelYN = 'N' "
			LSQL =  LSQL & "	AND LeaderIDX = '" & MemberIDX & "'"

			DBCon.Execute(LSQL)
			ErrorNum = ErrorNum + DBCon.Errors.Count 
			
			LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblLeaderInfoHistory] " 
			LSQL =  LSQL & " SET Team = '" & TeamAfter & "'"						
			LSQL =  LSQL & "	,ModID = '" & UserID & "'"						
			LSQL =  LSQL & "	,ModDate = GETDATE()"
			LSQL =  LSQL & " WHERE DelYN = 'N' "
			LSQL =  LSQL & "	AND LeaderIDX = '" & MemberIDX & "'"
			LSQL =  LSQL & "	AND LeaderHistoryIDX = '" & MemberHisIDX & "'"		

			DBCon.Execute(LSQL)
			ErrorNum = ErrorNum + DBCon.Errors.Count 

		Else

			LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblMember] " 
			LSQL =  LSQL & " SET Team = '" & TeamAfter & "'"						
			LSQL =  LSQL & "	,EditDate = GETDATE()"
			LSQL =  LSQL & " WHERE DelYN = 'N' "
			LSQL =  LSQL & "	AND MemberIDX = '" & MemberIDX & "'"

			DBCon.Execute(LSQL)
			ErrorNum = ErrorNum + DBCon.Errors.Count 
			
			LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblMemberHistory] " 
			LSQL =  LSQL & " SET Team = '" & TeamAfter & "'"						
			LSQL =  LSQL & "	,EditDate = GETDATE()"
			LSQL =  LSQL & " WHERE DelYN = 'N' "
			LSQL =  LSQL & "	AND MemberIDX = '" & MemberIDX & "'"
			LSQL =  LSQL & "	AND MemberHistoryIDX = '" & MemberHisIDX & "'"

			DBCon.Execute(LSQL)
			ErrorNum = ErrorNum + DBCon.Errors.Count 

			DBCon.Execute(LSQL)
			ErrorNum = ErrorNum + DBCon.Errors.Count 

		End IF
   		
   	END SUB 

%>