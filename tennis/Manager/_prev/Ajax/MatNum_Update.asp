<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	PlayerResultIDX = fInject(Request("PlayerResultIDX"))
	MatNum = Trim(fInject(Request("MatNum")))


	If Request.Cookies("SportsGb") = "wres" Then 
		If MatNum = "1" Then 
			MatNum = "A"
		ElseIf MatNum = "2" Then 
			MatNum = "B"
		ElseIf MatNum = "3" Then 
			MatNum = "C"
		ElseIf MatNum = "4" Then 
			MatNum = "D"
		End If 
	End If 


	If PlayerResultIDX<> "" Then 
		USQL = "Update Sportsdiary.dbo.tblPlayerResult SET StadiumNumber='"&MatNum&"' WHERE PlayerResultIDX='"&PlayerResultIDX&"'"
		Dbcon.Execute(USQL)
		Response.Write "true"
	Else
		Response.Write "false"
	End If 
%>