<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq       = fInject(Request("seq"))
	SportsGb  = fInject(Request("SportsGb")) 
	UserPass  = fInject(Request("UserPass")) 
	UserName  = fInject(Request("UserName")) 
	UserGubun = fInject(Request("UserGubun")) 
	HostCode  = fInject(Request("HostCode")) 
	HandPhone = fInject(Request("HandPhone")) 
	Company   = fInject(Request("Company")) 
	DelYN     = fInject(Request("DelYN")) 


'	Response.Write seq
'	Response.End


	If seq = "" Then 
		Response.End
	End If 


	UpSQL =       "Update Sportsdiary.dbo.tblUserInfo "
	UpSQL = UpSQL&" SET "
	UpSQL = UpSQL&"  SportsGb  ='"&SportsGb&"'"
	UpSQL = UpSQL&" , UserPass  ='"&UserPass&"'"
	UpSQL = UpSQL&" , UserName  ='"&UserName&"'"
	UpSQL = UpSQL&" , UserGubun ='"&UserGubun&"'"
	UpSQL = UpSQL&" , HostCode  ='"&HostCode&"'"
	UpSQL = UpSQL&" , HandPhone ='"&HandPhone&"'"
 	UpSQL = UpSQL&" , Company   ='"&Company&"'"
	UpSQL = UpSQL&" , DelGubun  ='"&DelYN&"'"
	UpSQL = UpSQL&" WHERE IDX  ='"&seq&"'"

	Response.Write UpSQL
	Response.End

	Dbcon.Execute(UpSQL)
'	Dbclose()
	Response.Write "true"
	Response.End
%>

