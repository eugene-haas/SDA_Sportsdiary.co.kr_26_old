<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq             = fInject(Request("seq"))
	SportsGb        = fInject(Request("SportsGb"))
	PlayerGb        = fInject(Request("PlayerGb"))
	NowSchIDX       = fInject(Request("NowSchIDX"))
	UserName        = fInject(Request("UserName"))
	Sex             = fInject(Request("Sex"))
	UserPass        = fInject(Request("UserPass"))
	UserPass2       = fInject(Request("UserPass2"))
	UserPhone       = fInject(Request("UserPhone"))
	Birth_Year      = fInject(Request("Birth_Year"))
	Birth_Month     = fInject(Request("Birth_Month"))
	Birth_Day       = fInject(Request("Birth_Day"))
	BirthDay = Birth_Year&"-"&Birth_Month&"-"&Birth_Day
	PlayerStartYear = fInject(Request("PlayerStartYear"))
	Tall            = fInject(Request("Tall"))
	Weight          = fInject(Request("Weight"))
	BloodType       = fInject(Request("BloodType"))
	Level           = fInject(Request("Level"))

	If seq = "" Then 
		Response.End
	End If 

	UpSQL = "Update SportsDiary.dbo.tblPlayer"
	UpSQL = UpSQL&" SET "
	UpSQL = UpSQL&"  SportsGb ='"&SportsGb&"'"
	UpSQL = UpSQL&", PlayerGb ='"&PlayerGb&"'"
	UpSQL = UpSQL&", NowSchIDX ='"&NowSchIDX&"'"
	UpSQL = UpSQL&", UserName ='"&UserName&"'"
	UpSQL = UpSQL&", Sex ='"&Sex&"'"
	UpSQL = UpSQL&", UserPass ='"&UserPass&"'"
	UpSQL = UpSQL&", UserPhone ='"&UserPhone&"'"
	UpSQL = UpSQL&", BirthDay ='"&BirthDay&"'"
	UpSQL = UpSQL&", PlayerStartYear ='"&PlayerStartYear&"'"
	UpSQL = UpSQL&", Tall ='"&Tall&"'"
	UpSQL = UpSQL&", Weight ='"&Weight&"'"
	UpSQL = UpSQL&", BloodType ='"&BloodType&"'"
	UpSQL = UpSQL&", [Level] ='"&Level&"'"	
	UpSQL = UpSQL&" WHERE PlayerIDX='"&seq&"' "

'	Response.Write InSQL
'	Response.End

	Dbcon.Execute(UpSQL)
	Dbclose()
	Response.Write "TRUE"
	Response.End
%>

