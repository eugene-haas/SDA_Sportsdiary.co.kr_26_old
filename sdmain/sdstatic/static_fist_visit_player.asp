<%'<!--#include virtual="/dbconn/common_function.asp"-->%>
<%
'구글 로그로 전환 


   	'순방문자 로그
'	IF mid(trim(strip),1,14) <> "118.33.86.240" then
'        IF Request.Cookies(strSportstype)("vtinck") <> "ok" then           
'             
'            Response.Cookies(strSportstype)("vtinck") = "ok"
'			Response.Cookies(strSportstype).Expires = date + 1 
'
'			SET DBConStatic = Server.CreateObject("ADODB.Connection")
'				DBConStatic.CommandTimeout = 1000
'				DBConStatic.Open strConnect
'
'				strqrystaticfist = "EXEC [SD_Member].[dbo].[Sd_Static_Visit] @media = '" & strsetmedia & "'"
'				DBConStatic.Execute(strqrystaticfist)			
'
'				DBConStatic.Close	
'			SET DBConStatic = Nothing
'            
'		End IF	
'    End IF	

%>
