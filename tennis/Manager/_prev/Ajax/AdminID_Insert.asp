<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	SportsGb = fInject(Request("SportsGb"))
	ChkID = fInject(Request("ChkID"))
	UserID = fInject(Request("UserID"))
	Hidden_UserID = fInject(Request("Hidden_UserID"))
	UserPass = fInject(Request("UserPass"))
	UserPass_Re = fInject(Request("UserPass_Re"))
	UserName = fInject(Request("UserName"))
	UserGubun = fInject(Request("UserGubun"))
	HostCode = fInject(Request("HostCode"))
	HandPhone = fInject(Request("HandPhone"))
	Company = fInject(Request("Company"))
	DelYN = fInject(Request("DelYN"))


	If UserID <> Hidden_UserID Then 
		Response.Write "false"
		Response.End
	End If 

	'아이디 재중복확인
	CSQL = "SELECT Count(UserID) AS Cnt FROM Sportsdiary.dbo.tblUserInfo WHERE UserID='"&UserID&"'"

	Set CRs = Dbcon.Execute(CSQL)

	If CRs("Cnt")  = 0 Then 

		ISQL = "Insert Into Sportsdiary.dbo.tblUserInfo "
		ISQL = ISQL&" ( "
		ISQL = ISQL&" UserID "
		ISQL = ISQL&" , UserPass "
		ISQL = ISQL&" , UserName "
		ISQL = ISQL&" , PartCode "
		ISQL = ISQL&" , UserGubun "
		ISQL = ISQL&" , DelGubun "
		ISQL = ISQL&" , HandPhone "
		ISQL = ISQL&" , Company "
		ISQL = ISQL&" , WriteID "
		ISQL = ISQL&" ,	WriteIP "
		ISQL = ISQL&" , WriteDate "
		ISQL = ISQL&" , UpdateDate "
		ISQL = ISQL&" , UpdateIP "
		ISQL = ISQL&" , UpdateID "
		ISQL = ISQL&" , SportsGb "
		ISQL = ISQL&" , HostCode "
		ISQL = ISQL&" ) "
		ISQL = ISQL&" VALUES "
		ISQL = ISQL&" ( "
		ISQL = ISQL&"'"& UserID& "'"
		ISQL = ISQL&",'"& UserPass& "'"
		ISQL = ISQL&",'"& UserName& "'"
		ISQL = ISQL&",'"& PartCode& "'"
		ISQL = ISQL&",'"& UserGubun& "'"
		ISQL = ISQL&",'"& DelYN& "'"
		ISQL = ISQL&",'"& HandPhone& "'"
		ISQL = ISQL&",'"& Company& "'"
		ISQL = ISQL&",'SportsDiary'"
		ISQL = ISQL&",'"& Request.ServerVariables("REMOTE_ADDR")& "'"
		ISQL = ISQL&" , getdate() "
		ISQL = ISQL&" , getdate() "
		ISQL = ISQL&",'"& Request.ServerVariables("REMOTE_ADDR")& "'"
		ISQL = ISQL&" , 'SportsDiary' "
		ISQL = ISQL&" , '"&SportsGb&"'"
		ISQL = ISQL&" , '"&HostCode&"' "
		ISQL = ISQL&" ) "
		
		Dbcon.Execute(ISQL)
'		Response.Write ISQL
'		Response.End
		Response.Write "true"
		Response.End
	Else
		Response.Write "same"
		Response.End
	End If 



%>