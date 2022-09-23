<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	SportsGb        = fInject(Request("SportsGb"))
	PlayerGb        = fInject(Request("PlayerGb"))
	NowSchIDX       = fInject(Request("NowSchIDX"))
	UserName        = fInject(Request("UserName"))
	Sex             = fInject(Request("Sex"))
	UserID          = fInject(Request("UserID"))
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

	'Response.Write SportsGb&"<br>" 
	'Response.Write PlayerGb &"<br>"
	'Response.Write NowSchIDX &"<br>"
	'Response.Write UserName &"<br>"
	'Response.Write Sex &"<br>"
	'Response.Write UserID &"<br>"
	'Response.Write UserPass &"<br>"
	'Response.Write UserPass2 &"<br>"
	'Response.Write UserPhone &"<br>"
	'Response.Write Birth_Year &"<br>"
	'Response.Write Birth_Month &"<br>"
	'Response.Write Birth_Day &"<br>"
	'Response.Write PlayerStartYear &"<br>"
	'Response.Write Tall &"<br>"
	'Response.Write Weight &"<br>"
	'Response.Write BloodType &"<br>"
	'Response.Write Level 

	InSQL = "INSERT INTO SportsDiary.dbo.tblPlayer "
	InSQL = InSQL&"("
	InSQL = InSQL&" SportsGb"
	InSQL = InSQL&" ,PlayerGb"
	InSQL = InSQL&" ,NowSchIDX"
	InSQL = InSQL&" ,UserName"
	InSQL = InSQL&" ,UserPhone"
	InSQL = InSQL&" ,BirthDay"
	InSQL = InSQL&" ,Sex"
	InSQL = InSQL&" ,PlayerStartYear"
	InSQL = InSQL&" ,Tall"
	InSQL = InSQL&" ,Weight"
	InSQL = InSQL&" ,[Level]"
	InSQL = InSQL&" ,BloodType"
	InSQL = InSQL&" ,UseForHand"
	InSQL = InSQL&" ,Specialty"
	InSQL = InSQL&" ,UserID"
	InSQL = InSQL&" ,UserPass"
	InSQL = InSQL&" ,Email"
	InSQL = InSQL&" ,DelYN"
	InSQL = InSQL&" ,WriteDate"
	InSQL = InSQL&" ,UseOS"
	InSQL = InSQL&" ,UseModel"
	InSQL = InSQL&" ,PhotoPath"
	InSQL = InSQL&")"
	InSQL = InSQL&" VALUES "
	InSQL = InSQL&"("
	InSQL = InSQL&" '"&SportsGb&"'"
	InSQL = InSQL&" ,'"&PlayerGb&"'"
	InSQL = InSQL&" ,'"&NowSchIDX&"'"
	InSQL = InSQL&" ,'"&UserName&"'"
	InSQL = InSQL&" ,'"&UserPhone&"'"
	InSQL = InSQL&" ,'"&BirthDay&"'"
	InSQL = InSQL&" ,'"&Sex&"'"
	InSQL = InSQL&" ,'"&PlayerStartYear&"'"
	InSQL = InSQL&" ,'"&Tall&"'"
	InSQL = InSQL&" ,'"&Weight&"'"
	InSQL = InSQL&" ,'"&Level&"'"
	InSQL = InSQL&" ,'"&BloodType&"'"
	InSQL = InSQL&" ,'"&UseForHand&"'"
	InSQL = InSQL&" ,'"&Specialty&"'"
	InSQL = InSQL&" ,'"&UserID&"'"
	InSQL = InSQL&" ,'"&UserPass&"'"
	InSQL = InSQL&" ,'"&Email&"'"
	InSQL = InSQL&" ,'N'"
	InSQL = InSQL&" ,getdate()"
	InSQL = InSQL&" ,'"&UserOS&"'"
	InSQL = InSQL&" ,'"&UseModel&"'"
	InSQL = InSQL&" ,'"&PhotoPath&"'"
	InSQL = InSQL&")"

'	Response.Write InSQL
'	Response.End

	Dbcon.Execute(InSQL)
	Dbclose()
	Response.Write "TRUE"
	Response.End
%>