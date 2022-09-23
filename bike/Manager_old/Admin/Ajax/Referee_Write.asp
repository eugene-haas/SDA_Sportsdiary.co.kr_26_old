<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'경기지도자/심판 자격 
   	'/Main_HP/Referee_Write.asp
	'==============================================================================================
	Check_AdminLogin()

	dim valType 		: valType 		=  fInject(Request("valType"))
	dim RefereeGb 		: RefereeGb 	=  fInject(Request("RefereeGb"))
	dim RefereeLevel 	: RefereeLevel 	=  fInject(Request("RefereeLevel"))
	dim UserName 		: UserName 		=  fInject(Request("UserName"))
	dim UserBirth 		: UserBirth 	=  fInject(Request("UserBirth"))
	dim LicenseNumber 	: LicenseNumber =  HtmlSpecialChars(fInject(Request("LicenseNumber")))
	dim LicenseDt 		: LicenseDt 	=  fInject(Request("LicenseDt"))
   
	IF valType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
		
		SELECT CASE valType
			
			CASE "DEL"
			
				IF CIDX <> "" Then
					LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblLicenseInfo]" 
					LSQL =  LSQL & " SET DelYN = 'Y'"
					LSQL =  LSQL & "	,EditDate = GETDATE()"
					LSQL =  LSQL & " WHERE LicenseIDX = '" & CIDX & "'"
					
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
						
					LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblLicenseInfo] " 
					LSQL =  LSQL & " SET RefereeGb = '" & RefereeGb & "'"
					LSQL =  LSQL & "	,RefereeLevel = '" & RefereeLevel & "'"
					LSQL =  LSQL & "	,UserName = '" & UserName & "'"
					LSQL =  LSQL & "	,UserBirth = '" & UserBirth & "'"
					LSQL =  LSQL & "	,LicenseNumber = '" & LicenseNumber & "'"
					LSQL =  LSQL & "	,LicenseDt = '" & LicenseDt & "'"
					LSQL =  LSQL & "	,EditDate = GETDATE()"
					LSQL =  LSQL & " WHERE LicenseIDX = '" & CIDX & "'"

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
				
				LSQL =  "		INSERT INTO [KoreaBadminton].[dbo].[tblLicenseInfo] (" 
				LSQL =  LSQL & "	RefereeGb "  
				LSQL =  LSQL & "	,RefereeLevel " 
				LSQL =  LSQL & "	,LicenseNumber " 										
				LSQL =  LSQL & "	,LicenseDt " 
				LSQL =  LSQL & "	,UserName " 
				LSQL =  LSQL & "	,UserBirth"  
				LSQL =  LSQL & "	,DelYN "  					
				LSQL =  LSQL & "	,WriteDate "  					
				LSQL =  LSQL & "	,EditDate "  					
				LSQL =  LSQL & ") VALUES( " 
				LSQL =  LSQL & "	'" & RefereeGb & "'" 
				LSQL =  LSQL & "	,'" & RefereeLevel & "'" 
				LSQL =  LSQL & "	,'" & LicenseNumber & "'" 
				LSQL =  LSQL & "	,'" & LicenseDt & "'" 
				LSQL =  LSQL & "	,'" & UserName & "'" 
				LSQL =  LSQL & "	,'" & UserBirth & "'" 			
				LSQL =  LSQL & "	,'N'" 
				LSQL =  LSQL & "	,GETDATE()" 
				LSQL =  LSQL & "	,GETDATE()" 
				LSQL =  LSQL & ")"				
				
				DBCon.Execute(LSQL)
				
				IF DBCon.Errors.Count > 0 Then
					response.Write "FALSE|66"
					response.End()
				Else
					response.Write "TRUE|90"
					response.End()
				End IF
			
		END SELECT
			
	End IF 
%>