<!--#include file="../Library/ajax_config.asp"-->
<%
	'=================================================================
  	'제휴/입점문의 페이지
  	'=================================================================
	 
	dim CompanyNm 		: CompanyNm 	= ReplaceTagText(fInject(trim(Request("CompanyName"))))
	dim ProductGbNm 	: ProductGbNm 	= ReplaceTagText(fInject(trim(Request("Product"))))		
	dim ZipCode 		: ZipCode 		= fInject(trim(Request("ZipCode")))
	dim Address		 	: Address   	= fInject(trim(Request("CompanyAddr")))
	dim AddressDtl 		: AddressDtl	= ReplaceTagText(fInject(trim(Request("CompanyAddrDtl"))))	
	dim CompanyURL 		: CompanyURL 	= ReplaceTagText(fInject(trim(Request("CompanyURL"))))
	dim UserName 		: UserName 		= ReplaceTagText(fInject(trim(Request("ManagerName"))))	 
	dim UserPhone 		: UserPhone 	= fInject(trim(Request("UserPhone")))
	dim UserEmail 		: UserEmail 	= ReplaceTagText(fInject(trim(Request("UserEmail"))))	 
	dim ReqContent 		: ReqContent 	= ReplaceTagText(fInject(trim(Request("ReqContent"))))
	dim PrivacyYN		: PrivacyYN 	= fInject(trim(Request("PrivacyYN"))) 
	dim Subject			: Subject 		= "제휴/입점문의합니다."
	 
	dim LSQL


	IF CompanyNm = "" OR UserName = "" OR UserPhone = "" OR UserEmail = "" OR ReqContent = "" OR PrivacyYN = "N" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
	 	On Error Resume Next
			
		DBcon3.BeginTrans()

		LSQL = "		INSERT INTO [SD_Member].[dbo].[tblAllianceInfo] (" 
		LSQL = LSQL & "		Subject "  
		LSQL = LSQL & "		,CompanyNm " 
	 	LSQL = LSQL & "		,CompanyURL " 				
		LSQL = LSQL & "		,ProductGbNm " 										
		LSQL = LSQL & "		,ZipCode " 
		LSQL = LSQL & "		,Address " 
		LSQL = LSQL & "		,AddressDtl " 		
		LSQL = LSQL & "		,UserName "  					
		LSQL = LSQL & "		,UserPhone "  					
		LSQL = LSQL & "		,UserEmail "  					
		LSQL = LSQL & "		,txtContent "
	 	LSQL = LSQL & "		,PrivacyYN "
        LSQL = LSQL & "     ,ResultGb "
		LSQL = LSQL & "		,InsDate "  
		LSQL = LSQL & "		,ModDate "  					
	 	LSQL = LSQL & "		,InsID "  
		LSQL = LSQL & "		,ModID "  					
		LSQL = LSQL & "		,DelYN "  					
		LSQL = LSQL & "	) VALUES(" 
		LSQL = LSQL & "		'" & Subject 		& "'"
		LSQL = LSQL & "		,'" & CompanyNm 	& "'"
		LSQL = LSQL & "		,'" & CompanyURL	& "'"
		LSQL = LSQL & "		,'" & ProductGbNm	& "'"
		LSQL = LSQL & "		,'" & ZipCode 		& "'"
		LSQL = LSQL & "		,'" & Address 		& "'"
		LSQL = LSQL & "		,'" & AddressDtl 	& "'"
		LSQL = LSQL & "		,'" & UserName 		& "'"
		LSQL = LSQL & "		,'" & UserPhone		& "'"
		LSQL = LSQL & "		,'" & UserEmail		& "'"
		LSQL = LSQL & "		,'" & ReqContent	& "'"
		LSQL = LSQL & "		,'" & PrivacyYN		& "'"
        LSQL = LSQL & "		,'stan'"                       '대기중
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "		,'" & request.Cookies("SD")("UserID")	& "'"
		LSQL = LSQL & "		,'" & request.Cookies("SD")("UserID")	& "'"
		LSQL = LSQL & "		,'N'"
		LSQL = LSQL & "	)"

'		response.Write "LSQL=" & LSQL&"<br>"

		DBCon3.Execute(LSQL)	

		IF DBCon3.Errors.Count > 0 Then
			DBCon3.RollbackTrans()				
			Response.Write "FALSE|66"				
		Else					
			DBCon3.CommitTrans()											
			Response.Write "TRUE|" 				
		End IF
	
		DBClose3()
		
	End IF 

%>