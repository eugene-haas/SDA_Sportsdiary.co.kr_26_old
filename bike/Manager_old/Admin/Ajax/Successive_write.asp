<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'역대 타이틀정보 관리	
	'==============================================================================================
	Check_AdminLogin()	 

	dim CIDX 			: CIDX 				= crypt.DecryptStringENC(fInject(Request("CIDX")))
	dim UserID 			: UserID 			= crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("UserID")))		
	dim AssoCode 		: AssoCode 			= fInject(trim(Request("AssoCode")))
	dim SuccessiveNm	: SuccessiveNm 		= HtmlSpecialChars(fInject(trim(Request("SuccessiveNm"))))
	dim DatePeriod 		: DatePeriod 		= HtmlSpecialChars(fInject(trim(Request("DatePeriod"))))
	dim DatePeriodStart	: DatePeriodStart 	= HtmlSpecialChars(fInject(trim(Request("DatePeriodStart"))))
	dim Orderby 		: Orderby			= fInject(Request("Orderby"))
	dim ViewYN 			: ViewYN			= fInject(Request("ViewYN"))
	dim valType 		: valType			= fInject(Request("valType"))
   
	
	dim CSQL, CRs, LSQL, LRs
	dim RE_DATA
	 
' 	response.write UserID
'	response.write valType
	 
	IF UserID = "" OR valType = "" Then 	
		RE_DATA = "FALSE|200"
	Else 
		'정보 수정 및 삭제시 
	 	IF CIDX <> "" Then
			
			SELECT CASE valType

				CASE "DEL"
					CSQL =  	  " UPDATE [KoreaBadminton].[dbo].[tblCateSuccessive]"
					CSQL = CSQL & "	SET DelYN = 'Y'"
					CSQL = CSQL & " WHERE CateSuccessiveIDX = '"&CIDX&"' "

					DBCon.Execute(CSQL)

					IF DBCon.Errors.Count > 0 Then
						RE_DATA = "FALSE|11"
					ELSE
						RE_DATA = "TRUE|70"
					END IF												 

				CASE "MOD"	
					CSQL =  	  " UPDATE [KoreaBadminton].[dbo].[tblCateSuccessive]"
					CSQL = CSQL & "	SET AssoCode = '"&AssoCode&"'"
					CSQL = CSQL & "		,SuccessiveNm = '"&SuccessiveNm&"'"
					CSQL = CSQL & "		,DatePeriod = '"&DatePeriod&"'"
					CSQL = CSQL & "		,DatePeriodStart = '"&DatePeriodStart&"'"
					CSQL = CSQL & "		,ViewYN = '"&ViewYN&"'"																								
					CSQL = CSQL & "		,Orderby = '"&Orderby&"'"																								
					CSQL = CSQL & " WHERE DelYN = 'N' "
					CSQL = CSQL & " 	AND CateSuccessiveIDX = '"&CIDX&"' "	

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
			LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblCateSuccessive]"
			LSQL = LSQL & " WHERE DelYN = 'N' "
			LSQL = LSQL & "  	AND AssoCode = '"&AssoCode&"' "
			LSQL = LSQL & "  	AND SuccessiveNm = '"&SuccessiveNm&"' "
			
			SET LRs = DBCon.Execute(LSQL)	
			IF LRs(0) > 0 Then
				RE_DATA = "FALSE|88"	
			Else
				CSQL =  "	   	 INSERT INTO [KoreaBadminton].[dbo].[tblCateSuccessive] (" 
				CSQL =  CSQL & " 	AssoCode "  
				CSQL =  CSQL & "	,SuccessiveNm " 
				CSQL =  CSQL & "	,DatePeriod " 										
				CSQL =  CSQL & "	,DatePeriodStart " 										
				CSQL =  CSQL & "	,ViewYN " 
				CSQL =  CSQL & "	,Orderby " 			
				CSQL =  CSQL & "	,InsID " 
				CSQL =  CSQL & "	,ModID " 
				CSQL =  CSQL & "	,InsDate " 
				CSQL =  CSQL & "	,ModDate " 			
				CSQL =  CSQL & "	,DelYN " 
				CSQL =  CSQL & " ) VALUES ( "
				CSQL =  CSQL & "	'"&AssoCode&"'"	
				CSQL =  CSQL & "	,'"&SuccessiveNm&"'"
				CSQL =  CSQL & "	,'"&DatePeriod&"'"
				CSQL =  CSQL & "	,'"&DatePeriodStart&"'"
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