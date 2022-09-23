<!--#include file="../Library/ajax_config.asp"-->
<%
'	TeamGb = fInject(Request("TeamGb"))			'소속구분[초등부, 중등부...]
'	AreaGb = fInject(Request("AreaGb"))			'지역[서울,울산...]
	
	dim TeamCode : TeamCode = fInject(Request("TeamCode"))		'소속팀[ex. 울산스포츠과학중학교]
	dim UserName : UserName = fInject(Request("UserName"))
	dim UserBirth : UserBirth = fInject(Request("UserBirth"))
	dim SportsType : SportsType = fInject(Request("SportsType"))
	
	'테스트 데이터
	username = "임보영"
	UserBirth = "19990309"

	If UserBirth = "" Or UserName = "" Then 
		Response.Write "FALSE|"
		Response.End
	Else
		'협회등록선수[NowRegYN:Y]
		CSQL = 	"		SELECT PersonCode "
		CSQL = CSQL & "		,PlayerIDX " 
		CSQL = CSQL & "		,Team " 
		CSQL = CSQL & " FROM [SportsDiary].[dbo].[tblPlayer] " 
		CSQL = CSQL & " WHERE DelYN = 'N' "
'		CSQL = CSQL & "		AND NowRegYN = 'Y' " 
		CSQL = CSQL & " 	AND SportsGb = '"&SportsType&"'" 
		CSQL = CSQL & "		AND UserName = '"&UserName&"' " 
		CSQL = CSQL & "		AND Team = '"&TeamCode&"' " 
		CSQL = CSQL & "	 	AND Replace(Birthday,'-','') = '"&UserBirth&"' "
		
'		response.Write CSQL
		
		SET CRs = Dbcon.Execute(CSQL)

		If Not(CRs.Eof Or CRs.Bof) Then 
			Response.Write "TRUE|"&CRs("PersonCode")&"|"&CRs("PlayerIDX")&"|"&CRs("Team")
		Else
			Response.Write "FALSE|"
			Response.End
		End If 
			
			CRs.Close
		SET CRs = Nothing
		
		DBClose()
		
	End If 
%>