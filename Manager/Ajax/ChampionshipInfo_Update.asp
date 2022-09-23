<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq            = fInject(Request("seq"))

	SportsGb       = fInject(Request("SportsGb")) 
	GameGb         = fInject(Request("GameGb")) 
	GameYear       = fInject(Request("GameYear")) 
	GameTitleName  = fInject(Request("GameTitleName")) 
	Sido           = fInject(Request("Sido")) 
	SidoDtl        = fInject(Request("SidoDtl")) 

	GameS_Year     = fInject(Request("GameS_Year")) 
	GameS_Month    = fInject(Request("GameS_Month")) 
	GameS_Day      = fInject(Request("GameS_Day")) 
	GameS          = GameS_Year&"-"&GameS_Month&"-"&GameS_Day

	GameE_Year     = fInject(Request("GameE_Year"))
	GameE_Month    = fInject(Request("GameE_Month")) 
	GameE_Day      = fInject(Request("GameE_Day")) 
	GameE          = GameE_Year&"-"&GameE_Month&"-"&GameE_Day

	GameArea       = fInject(Request("GameArea"))
	
	GameRcv_SYear  = fInject(Request("GameRcv_SYear")) 
	GameRcv_SMonth = fInject(Request("GameRcv_SMonth")) 
	GameRcv_SDay   = fInject(Request("GameRcv_SDay")) 
	GameRcvDateS   = GameRcv_SYear&"-"&GameRcv_SMonth&"-"&GameRcv_SDay

	GameRcv_EYear  = fInject(Request("GameRcv_EYear")) 
	GameRcv_EMonth = fInject(Request("GameRcv_EMonth")) 
	GameRcv_EDay   = fInject(Request("GameRcv_EDay")) 
	GameRcvDateE   = GameRcv_EYear&"-"&GameRcv_EMonth&"-"&GameRcv_EDay

	EnterType      = fInject(Request("EnterType"))

	HostCode       = fInject(Request("HostCode"))

	ViewYN         = fInject(Request("ViewYN"))


	If seq = "" Then 
		Response.End
	End If 


	UpSQL = " Update SportsDiary.dbo.tblGameTitle"
	UpSQL = UpSQL&" SET "
	UpSQL = UpSQL&"  SportsGb      ='"&SportsGb&"'"
	UpSQL = UpSQL&", GameGb        ='"&GameGb&"'"
	UpSQL = UpSQL&", GameYear      ='"&GameYear&"'"
	UpSQL = UpSQL&", GameTitleName ='"&GameTitleName&"'"
	UpSQL = UpSQL&", Sido          ='"&Sido&"'"
	UpSQL = UpSQL&", SidoDtl       ='"&SidoDtl&"'"
	UpSQL = UpSQL&", GameS         ='"&GameS&"'"
	UpSQL = UpSQL&", GameE         ='"&GameE&"'"
	UpSQL = UpSQL&", GameArea      ='"&GameArea&"'"
	UpSQL = UpSQL&", GameRcvDateS  ='"&GameRcvDateS&"'"
	UpSQL = UpSQL&", GameRcvDateE  ='"&GameRcvDateE&"'"
	UpSQL = UpSQL&", EnterType     ='"&EnterType&"'"
	UpSQL = UpSQL&", HostCode      ='"&HostCode&"'"
	UpSQL = UpSQL&", ViewYN        ='"&ViewYN&"'"
	UpSQL = UpSQL&" WHERE GameTitleIDX ='"&seq&"' "

'	Response.Write UpSQL
'	Response.End

	Dbcon.Execute(UpSQL)
	Dbclose()
	Response.Write "TRUE"
	Response.End
%>

