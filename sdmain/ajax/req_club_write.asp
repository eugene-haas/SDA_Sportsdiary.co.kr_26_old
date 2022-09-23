<!--#include file="../Library/ajax_config.asp"-->
<%
	'=========================================================================================
	'家加 脚痹积己 夸没其捞瘤
	'=========================================================================================
	dim AreaGb 		: AreaGb 	= fInject(Trim(Request("AreaGb")))
	dim AreaGbDt	: AreaGbDt  = fInject(Trim(Request("AreaGbDt")))
	dim TeamNm		: TeamNm  	= fInject(Trim(ReplaceTagText(Request("TeamNm"))))
	dim ReqName		: ReqName  	= fInject(Trim(ReplaceTagText(Request("ReqName"))))
	
	dim CSQL, CRs
	
	IF AreaGb = "" Or AreaGbDt = "" OR TeamNm = "" Then 
		Response.Write "FALSE|200"
		Response.End
	Else

		CSQL = 	"		INSERT INTO [SD_tennis].[dbo].[tblClubRequest] (" 
		CSQL = CSQL & "		SportsGb" 
		CSQL = CSQL & "		,AreaGb" 
		CSQL = CSQL & "		,AreaGbDt" 
		CSQL = CSQL & "		,TeamNm" 
		CSQL = CSQL & "		,ReqName" 
		CSQL = CSQL & "		,WriteDate" 
		CSQL = CSQL & "		,ModDate" 
		CSQL = CSQL & "		,DelYN" 
		CSQL = CSQL & "	) VALUES(" 
		CSQL = CSQL & "		'tennis'" 
		CSQL = CSQL & "		,'"&AreaGb&"'" 
		CSQL = CSQL & "		,'"&AreaGbDt&"'" 
		CSQL = CSQL & "		,'"&TeamNm&"'" 
		CSQL = CSQL & "		,'"&ReqName&"'" 
		CSQL = CSQL & "		,GETDATE()" 
		CSQL = CSQL & "		,GETDATE()" 
		CSQL = CSQL & "		,'N'" 
		CSQL = CSQL & "	)" 
		
		DBCon3.Execute(CSQL)
		
		IF DBCon3.Errors.Count > 0  Then
			Response.Write "FALSE|66"
		Else
			Response.Write "TRUE|"
		End IF
		
		Response.End
		
	End IF 
%>