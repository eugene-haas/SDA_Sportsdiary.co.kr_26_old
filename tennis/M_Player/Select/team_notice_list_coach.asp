<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	dim Team		: Team 		= decode(request.Cookies("Team"),0)

	dim LSQL, LRs
	dim FormData
	

	'ViewTp[A:전체 | T:선수소속팀]
	LSQL =  " SELECT [MemberIDX] "
	LSQL = LSQL & "		,[UserName] "
	LSQL = LSQL & "		,CASE [LeaderType] WHEN 2 THEN '감독' WHEN 3 THEN '코치' END LeaderType "
	LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblMember] "
	LSQL = LSQL & " WHERE DelYN = 'N' "
	LSQL = LSQL & "		AND EdSvcReqTp = 'A' "
	LSQL = LSQL & "		AND PlayerReln = 'T' "
	LSQL = LSQL & "		AND Team = '"&Team&"' "
	LSQL = LSQL & " ORDER BY [LeaderType] ASC "
	LSQL = LSQL & "		,[UserName] ASC "
	
	
	FormData = "<select name='fnd_user' id='fnd_user'>"
	FormData = FormData & "<option value=''>작성자</option>"	
					
	SET LRs = Dbcon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			FormData = FormData & "<option value='"&LRs("UserName")&"'>"&LRs("UserName")&"("&LRs("LeaderType")&")</option>"	

			LRs.MoveNext
		Loop 
	End If 
	
	FormData = FormData & "</select>"
	
		LRs.Close
	SET LRs = Nothing 
	
	DBClose()
	
	response.Write FormData
	
%>