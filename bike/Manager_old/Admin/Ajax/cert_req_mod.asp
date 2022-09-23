<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'증명서 발급 신청정보 수정페이지 
   	'---------------------------------------------------------------------------------------------
		'ErrorMsg = FALSE|200 	: 잘못된 접근
		'ErrorMsg = FALSE|99 	: 일치하는 정보 없음
		'ErrorMsg = FALSE|66 	: DBCon.Errors
		'ErrorMsg = FALSE|33 	: 수정권한 없음
		'ErrorMsg = TRUE| 		: 신청정보 등록/수정 성공 
   	'---------------------------------------------------------------------------------------------
   	'증명서 발급 수수료
	'--------------------------------------------------------------------------------------------- 
		'팩스수령 FAX 	= 2,000
		'우편수령 POST 	= 3,000
		'방문수령 VISIT	= 1,000   
	'==============================================================================================
	dim TypeResult 		: TypeResult 		= fInject(Request("TypeResult"))
	dim UserPhone 		: UserPhone 		= fInject(Request("UserPhone"))
	dim UserFax 		: UserFax 			= fInject(Request("UserFax"))
	dim TypeCertificate : TypeCertificate 	= fInject(Request("TypeCertificate"))	 
	dim TypeUse 		: TypeUse 			= fInject(Request("TypeUse"))
	dim TypeRecive 		: TypeRecive 		= fInject(Request("TypeRecive"))
	dim SubmitOrg 		: SubmitOrg 		= HtmlSpecialChars(fInject(Request("SubmitOrg")))
	dim DateVisit 		: DateVisit			= fInject(Request("DateVisit"))
	dim ZipCode			: ZipCode			= fInject(Request("ZipCode"))
	dim UserAddr 		: UserAddr		 	= HtmlSpecialChars(fInject(Request("UserAddr")))
	dim UserAddrDtl		: UserAddrDtl	 	= HtmlSpecialChars(fInject(Request("UserAddrDtl")))	
   	dim txtTitleNm1		: txtTitleNm1	 	= HtmlSpecialChars(fInject(Request("txtTitleNm1")))	
   	dim txtTitleNm2		: txtTitleNm2		= HtmlSpecialChars(fInject(Request("txtTitleNm2")))	
	dim txtTitleNm3		: txtTitleNm3 		= HtmlSpecialChars(fInject(Request("txtTitleNm3")))	
   	dim DateDuringS1 	: DateDuringS1	 	= HtmlSpecialChars(fInject(Request("DateDuringS1")))	
	dim DateDuringS2 	: DateDuringS2	 	= HtmlSpecialChars(fInject(Request("DateDuringS2")))	
	dim DateDuringS3 	: DateDuringS3	 	= HtmlSpecialChars(fInject(Request("DateDuringS3")))	
	dim DateDuringE1 	: DateDuringE1	 	= HtmlSpecialChars(fInject(Request("DateDuringE1")))	
	dim DateDuringE2 	: DateDuringE2	 	= HtmlSpecialChars(fInject(Request("DateDuringE2")))	
	dim DateDuringE3 	: DateDuringE3	 	= HtmlSpecialChars(fInject(Request("DateDuringE3")))
	
	dim CertNumber 		: CertNumber	 	= HtmlSpecialChars(fInject(Request("CertNumber")))
	dim CertCount 		: CertCount	 		= HtmlSpecialChars(fInject(Request("CertCount")))
	dim CertAttach 		: CertAttach	 	= HtmlSpecialChars(fInject(Request("CertAttach")))
	dim CertWitness 	: CertWitness	 	= HtmlSpecialChars(fInject(Request("CertWitness")))
	dim CertDirector 	: CertDirector	 	= HtmlSpecialChars(fInject(Request("CertDirector")))

   	dim TYPE_PROC		: TYPE_PROC			= crypt.DecryptStringENC(fInject(Request("TYPE_PROC")))
	dim CIDX			: CIDX				= crypt.DecryptStringENC(fInject(Request("CIDX"))) 

	dim CertContents	: CertContents		= HtmlSpecialChars(fInject(Request("CertContents")))

	dim CSQL, CRs
	dim RE_DATA
	dim CertificateFee
	
	'SET: 증명서 발급 수수료 
	'발급료 가져오기
	'SELECT CASE TypeRecive
	'	CASE "FAX" 		: CertificateFee = 2000
	'	CASE "POST" 	: CertificateFee = 3000
	'	CASE "VISIT" 	: CertificateFee = 1000
	'END SELECT
	CSQL = "SELECT TOP 1 CertPrice from [KoreaBadminton].[dbo].[tblOnlineCertificateInfo] WITH(NOLOCK) ORDER BY CertInfoIDX DESC"
    SET CRs = DBCon.Execute(CSQL)
    IF Not(CRs.Eof Or CRs.Bof) Then
        CertificateFee = CDBL(CRs("CertPrice"))
    ELSE
        CertificateFee = 2000
    END IF
    CRs.Close 
    SET CRs = Nothing
	
	IF CIDX = "" Then 	
		RE_DATA = "FALSE|200"
	Else

		CSQL = "    	SELECT TypeResult"
		CSQL = CSQL & " FROM [KoreaBadminton].[dbo].[tblOnlineCertificate]"
		CSQL = CSQL & " WHERE DelYN = 'N'"
		CSQL = CSQL & " 	AND CertificateIDX = '"&CIDX&"'"

'	  	response.write CSQL

		SET CRs = DBCon.Execute(CSQL)
		IF Not(CRs.Eof Or CRs.Bof) Then

			CSQL =  "		UPDATE [KoreaBadminton].[dbo].[tblOnlineCertificate]" 
			CSQL = CSQL & " SET UserPhone = '" & UserPhone & "'"
			CSQL = CSQL & "		,UserFax = '" & UserFax & "'"
			CSQL = CSQL & "		,TypeCertificate = '" & TypeCertificate & "'"
			CSQL = CSQL & "		,TypeUse = '" & TypeUse & "'"
			CSQL = CSQL & "		,TypeRecive = '" & TypeRecive & "'"	
			CSQL = CSQL & "		,SubmitOrg = '" & SubmitOrg & "'"
			CSQL = CSQL & "		,DateVisit = '" & DateVisit & "'"
			CSQL = CSQL & "		,ZipCode = '" & ZipCode & "'" 
			CSQL = CSQL & "		,UserAddr = '" & UserAddr & "'"
			CSQL = CSQL & "		,UserAddrDtl = '" & UserAddrDtl & "'"
			CSQL = CSQL & "		,txtTitleNm1 = '" & txtTitleNm1 & "'"
			CSQL = CSQL & "		,txtTitleNm2 = '" & txtTitleNm2 & "'"
			CSQL = CSQL & "		,txtTitleNm3 = '" & txtTitleNm3 & "'"
			CSQL = CSQL & "		,DateDuringS1 = '" & DateDuringS1 & "'"
			CSQL = CSQL & "		,DateDuringS2 = '" & DateDuringS2 & "'"
			CSQL = CSQL & "		,DateDuringS3 = '" & DateDuringS3 & "'"
			CSQL = CSQL & "		,DateDuringE1 = '" & DateDuringE1 & "'"
			CSQL = CSQL & "		,DateDuringE2 = '" & DateDuringE2 & "'"
			CSQL = CSQL & "		,DateDuringE3 = '" & DateDuringE3 & "'"
			CSQL = CSQL & "		,CertificateFee = '" & CertificateFee & "'"
			CSQL = CSQL & "		,TypeResult = '" & TypeResult & "'"
			CSQL = CSQL & "		,CertNumber = '" & CertNumber & "'"
			CSQL = CSQL & "		,CertCount = '" & CertCount & "'"
			CSQL = CSQL & "		,CertAttach = '" & CertAttach & "'"
			CSQL = CSQL & "		,CertWitness = '" & CertWitness & "'"
			CSQL = CSQL & "		,CertDirector = '" & CertDirector & "'"
			CSQL = CSQL & "		,CertContents = '" & CertContents & "'"		
			CSQL = CSQL & "		,ModDate = GETDATE()"
			CSQL = CSQL & " WHERE DelYN = 'N'" 
			CSQL = CSQL & " 	AND CertificateIDX = '"&CIDX&"'"

	'		response.write CSQL

			DBCon.Execute(CSQL)

			IF DBCon.Errors.Count > 0 Then
				RE_DATA = "FALSE|66"
			ELSE
				RE_DATA = "TRUE|"
			END IF


		ELSE
			RE_DATA = "FALSE|99"
		END IF
			
	END IF
	
	response.write RE_DATA
%>