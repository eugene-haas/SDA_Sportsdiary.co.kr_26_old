<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'역대 타이틀정보 관리	
	'==============================================================================================
	Check_AdminLogin()	 

	dim CIDX 			: CIDX 				= crypt.DecryptStringENC(fInject(Request("CIDX")))
	dim UserID 			: UserID 			= crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("UserID")))		
	dim AssoCode 		: AssoCode			= fInject(trim(Request("AssoCode")))
	dim CateSuccessiveIDX : CateSuccessiveIDX = fInject(trim(Request("CateSuccessiveIDX")))
	dim OfficerNm		: OfficerNm 		= HtmlSpecialChars(fInject(trim(Request("OfficerNm"))))
	dim OfficerEnNm 	: OfficerEnNm 		= HtmlSpecialChars(fInject(trim(Request("OfficerEnNm"))))
	dim Orderby 		: Orderby			= fInject(trim(Request("Orderby")))
	dim ViewYN 			: ViewYN			= fInject(Request("ViewYN"))
	dim valType 		: valType			= fInject(Request("valType"))
   
	
	dim CSQL, CRs, LSQL, LRs
	dim RE_DATA
	
'	response.write UserID 
'	response.write valType 
 
	IF UserID = "" OR valType = "" Then 	
		RE_DATA = "FALSE|200"
	Else 
		'정보 수정 및 삭제시 
	 	IF CIDX <> "" Then
			
			SELECT CASE valType

				CASE "DEL"
					CSQL =  	  " UPDATE [KoreaBadminton].[dbo].[tblCateOfficers]"
					CSQL = CSQL & "	SET DelYN = 'Y'"
					CSQL = CSQL & " WHERE CateOfficersIDX = '"&CIDX&"' "

					DBCon.Execute(CSQL)

					IF DBCon.Errors.Count > 0 Then
						RE_DATA = "FALSE|11"
					ELSE
						RE_DATA = "TRUE|70"
					END IF												 

				CASE "MOD"	
					CSQL =  	  " UPDATE [KoreaBadminton].[dbo].[tblCateOfficers]"
					CSQL = CSQL & "	SET AssoCode = '"&AssoCode&"'"
					CSQL = CSQL & "		,CateSuccessiveIDX = '"&CateSuccessiveIDX&"'"
					CSQL = CSQL & "		,OfficerNm = '"&OfficerNm&"'"
					CSQL = CSQL & "		,OfficerEnNm = '"&OfficerEnNm&"'"
					CSQL = CSQL & "		,ViewYN = '"&ViewYN&"'"																								
					CSQL = CSQL & "		,Orderby = '"&Orderby&"'"																								
					CSQL = CSQL & " WHERE DelYN = 'N' "
					CSQL = CSQL & " 	AND CateOfficersIDX = '"&CIDX&"' "	

					DBCon.Execute(CSQL)

					IF DBCon.Errors.Count > 0 Then
						RE_DATA = "FALSE|33"
					ELSE
						RE_DATA = "TRUE|80"
					END IF	

			END SELECT

	 
		'협회정보 신규등록
	 	Else
			
			LSQL =  	  " SELECT ISNULL(COUNT(*), 0) cnt"
			LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblCateOfficers]"
			LSQL = LSQL & " WHERE DelYN = 'N' "
			LSQL = LSQL & "  	AND AssoCode = '"&AssoCode&"' "
			LSQL = LSQL & "  	AND OfficerNm = '"&OfficerNm&"' "
			LSQL = LSQL & "		AND CateSuccessiveIDX = '"&CateSuccessiveIDX&"'"
			
			SET LRs = DBCon.Execute(LSQL)	
			IF LRs(0) > 0 Then
				RE_DATA = "FALSE|88"	
			Else
				CSQL =  "	   	 INSERT INTO [KoreaBadminton].[dbo].[tblCateOfficers] (" 
				CSQL =  CSQL & " 	AssoCode "  
				CSQL =  CSQL & "	,CateSuccessiveIDX " 
				CSQL =  CSQL & " 	,OfficerNm "  
				CSQL =  CSQL & "	,OfficerEnNm " 
				CSQL =  CSQL & "	,ViewYN " 
				CSQL =  CSQL & "	,Orderby " 			
				CSQL =  CSQL & "	,InsID " 
				CSQL =  CSQL & "	,ModID " 
				CSQL =  CSQL & "	,InsDate " 
				CSQL =  CSQL & "	,ModDate " 			
				CSQL =  CSQL & "	,DelYN " 
				CSQL =  CSQL & " ) VALUES ( "
				CSQL =  CSQL & "	'"&AssoCode&"'"	
				CSQL =  CSQL & "	,'"&CateSuccessiveIDX&"'" 
				CSQL =  CSQL & "	,'"&OfficerNm&"'"	
				CSQL =  CSQL & "	,'"&OfficerEnNm&"'"
				CSQL =  CSQL & "	,'"&ViewYN&"'"
				CSQL =  CSQL & "	,'"&Orderby&"'"
				CSQL =  CSQL & "	,'"&UserID&"'"
				CSQL =  CSQL & "	,'"&UserID&"'"
				CSQL =  CSQL & "	,GETDATE()"
				CSQL =  CSQL & "	,GETDATE()"
				CSQL =  CSQL & "	,'N'"
				CSQL =  CSQL & " ) " 

		'		response.write CSQL

				DBCon.Execute(CSQL)

				IF DBCon.Errors.Count > 0 Then
					RE_DATA = "FALSE|66"
				Else
					RE_DATA = "TRUE|90"
				End IF
			
			End IF
				LRs.Close
			SET LRs = Nothing	

 		End IF	
	
	End IF
	
	response.write RE_DATA

	DBClose()
%>