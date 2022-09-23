<%'<!--#include virtual="/dbconn/common_function.asp"-->%>
<%
'구글 로그로 전환 'by 백	190809
	
	'통합 접속로그분석
'	IF mid(trim(strip),1,14) <> "118.33.86.240" then
'
'		SET DBConStatic = Server.CreateObject("ADODB.Connection")
'			DBConStatic.CommandTimeout = 1000
'			DBConStatic.Open strConnect
'
'			strqrystatic = "				EXEC [SD_Member].[dbo].[Sd_Static] "
'			strqrystatic = strqrystatic & " 	@media = '" & strsetmedia & "'"
'			strqrystatic = strqrystatic & "		,@url = '" & strseturl & "'"
'
'			DBConStatic.Execute(strqrystatic)
'
'			DBConStatic.Close	
'		SET DBConStatic = Nothing
'														   
'	End IF

%>