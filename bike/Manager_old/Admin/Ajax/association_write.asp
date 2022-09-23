<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'협회정보 관리	
	'==============================================================================================
	Check_AdminLogin()	 

	dim CIDX 		: CIDX 			= crypt.DecryptStringENC(fInject(Request("CIDX")))
	dim UserID 		: UserID 		= crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("UserID")))		
	dim AssoNm 		: AssoNm 		= HtmlSpecialChars(fInject(trim(Request("AssoNm"))))
	dim AssoNmShort	: AssoNmShort 	= HtmlSpecialChars(fInject(trim(Request("AssoNmShort"))))
	dim AssoEnNm 	: AssoEnNm 		= HtmlSpecialChars(fInject(trim(Request("AssoEnNm"))))
	dim Address 	: Address 		= HtmlSpecialChars(fInject(trim(Request("Address"))))
	dim AddressDtl 	: AddressDtl 	= HtmlSpecialChars(fInject(trim(Request("AddressDtl"))))
	dim Phone 		: Phone 		= fInject(Request("Phone"))
	dim Fax 		: Fax 			= fInject(Request("Fax"))	
	dim Orderby 	: Orderby		= fInject(Request("Orderby"))
	dim ViewYN 		: ViewYN		= fInject(Request("ViewYN"))
	dim valType 	: valType		= fInject(Request("valType"))
   
	
	dim CSQL, CRs, LSQL, LRs
	dim RE_DATA
	 
	'==========================================================================================
	'협회등록코드 생성
	'========================================================================================== 
	FUNCTION MAKE_INFOCODE()
		dim bufCode, bufNum

		CSQL =  	  " SELECT ISNULL(MAX(AssoCode), '') AssoCode "
		CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblAssociationInfo]"
		CSQL = CSQL & " WHERE DelYN = 'N' "

		SET CRs = DBCon.Execute(CSQL)	
		IF CRs(0) = "" Then
			bufCode = "ASS0001"							
		Else
			'ex) ASS0012
			'ASS을 제외한 나머지 숫자에 1을 더한 숫자의 자리수와 ASS의 자리수(3)를 뺀 자릿수 만큼 0을 붙인다
			FOR i = 1 to Len(CRs(0)) - len(Mid(CRs(0), 4, Len(CRs(0))) + 1) - 3
				bufNum = bufNum & "0"
			NEXT

			'ASS 이후의 숫자에 1을 더한 수를 구한 후 만든 0의 자리수를 붙인다
			bufNum = bufNum & Mid(CRs(0), 4, Len(CRs(0))) + 1

			'ASS + bufNum
			bufCode =  "ASS" & bufNum

		End IF	
			CRs.Close
		SET CRs = Nothing
		
   
   		MAKE_INFOCODE = bufCode
   
   
	END FUNCTION
	'==========================================================================================
	 
'	response.write "UserID=" &UserID
'	response.write "valType=" &valType

	 
	IF UserID = "" OR valType = "" Then 	
		RE_DATA = "FALSE|200"
	Else 
		'협회정보 수정 및 삭제시 
	 	IF CIDX <> "" Then
			
			SELECT CASE valType

				CASE "DEL"
					CSQL =  	  " UPDATE [KoreaBadminton].[dbo].[tblAssociationInfo]"
					CSQL = CSQL & "	SET DelYN = 'Y'"
					CSQL = CSQL & " WHERE AssociationIDX = '"&CIDX&"' "

					DBCon.Execute(CSQL)

					IF DBCon.Errors.Count > 0 Then
						RE_DATA = "FALSE|11"
					ELSE
						RE_DATA = "TRUE|70"
					END IF												 

				CASE "MOD"	
					CSQL =  	  " UPDATE [KoreaBadminton].[dbo].[tblAssociationInfo]"
					CSQL = CSQL & "	SET AssoNm = '"&AssoNm&"'"
					CSQL = CSQL & "		,AssoNmShort = '"&AssoNmShort&"'"
					CSQL = CSQL & "		,AssoEnNm = '"&AssoEnNm&"'"
					CSQL = CSQL & "		,Address = '"&Address&"'"
					CSQL = CSQL & "		,AddressDtl = '"&AddressDtl&"'"
					CSQL = CSQL & "		,Phone = '"&Phone&"'"
					CSQL = CSQL & "		,Fax = '"&Fax&"'"
					CSQL = CSQL & "		,ViewYN = '"&ViewYN&"'"																								
					CSQL = CSQL & "		,Orderby = '"&Orderby&"'"																								
					CSQL = CSQL & " WHERE DelYN = 'N' "
					CSQL = CSQL & " 	AND AssociationIDX = '"&CIDX&"' "	

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
			LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblAssociationInfo]"
			LSQL = LSQL & " WHERE DelYN = 'N' "
			LSQL = LSQL & "  	AND AssoNm = '"&AssoNm&"' "
			
			SET LRs = DBCon.Execute(LSQL)	
			IF LRs(0) > 0 Then
				RE_DATA = "FALSE|88"	
			Else
				dim AssoCode : AssoCode = MAKE_INFOCODE()

				CSQL =  "	   	 INSERT INTO [KoreaBadminton].[dbo].[tblAssociationInfo] (" 
				CSQL =  CSQL & " 	AssoCode "  
				CSQL =  CSQL & "	,AssoNm " 
				CSQL =  CSQL & "	,AssoNmShort " 										
				CSQL =  CSQL & "	,AssoEnNm " 										
				CSQL =  CSQL & "	,Phone " 
				CSQL =  CSQL & "	,Fax "  
				CSQL =  CSQL & "	,Address " 
				CSQL =  CSQL & "	,AddressDtl " 
				CSQL =  CSQL & "	,ViewYN " 
				CSQL =  CSQL & "	,Orderby " 			
				CSQL =  CSQL & "	,InsID " 
				CSQL =  CSQL & "	,ModID " 
				CSQL =  CSQL & "	,InsDate " 
				CSQL =  CSQL & "	,ModDate " 			
				CSQL =  CSQL & "	,DelYN " 
				CSQL =  CSQL & " ) VALUES ( "
				CSQL =  CSQL & "	'"&AssoCode&"'"	
				CSQL =  CSQL & "	,'"&AssoNm&"'"
				CSQL =  CSQL & "	,'"&AssoNmShort&"'"
				CSQL =  CSQL & "	,'"&AssoEnNm&"'"
				CSQL =  CSQL & "	,'"&Phone&"'"
				CSQL =  CSQL & "	,'"&Fax&"'"
				CSQL =  CSQL & "	,'"&Address&"'"
				CSQL =  CSQL & "	,'"&AddressDtl&"'"
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