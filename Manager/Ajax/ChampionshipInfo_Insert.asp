<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	SportsGb          = fInject(Request("SportsGb")) 
	GameGb            = fInject(Request("GameGb")) 
	GameYear          = fInject(Request("GameYear")) 
	GameTitleName     = fInject(Request("GameTitleName")) 
	Sido              = fInject(Request("Sido")) 
	SidoDtl           = fInject(Request("SidoDtl")) 

	GameS_Year        = fInject(Request("GameS_Year")) 
	GameS_Month       = fInject(Request("GameS_Month")) 
	GameS_Day         = fInject(Request("GameS_Day")) 
	GameS             = GameS_Year&"-"&GameS_Month&"-"&GameS_Day

	GameE_Year        = fInject(Request("GameE_Year"))
	GameE_Month       = fInject(Request("GameE_Month")) 
	GameE_Day         = fInject(Request("GameE_Day")) 
	GameE             = GameE_Year&"-"&GameE_Month&"-"&GameE_Day

	GameArea         = fInject(Request("GameArea"))

	GameRcv_SYear     = fInject(Request("GameRcv_SYear")) 
	GameRcv_SMonth    = fInject(Request("GameRcv_SMonth")) 
	GameRcv_SDay      = fInject(Request("GameRcv_SDay")) 
	GameRcvDateS      = GameRcv_SYear&"-"&GameRcv_SMonth&"-"&GameRcv_SDay

	GameRcv_EYear     = fInject(Request("GameRcv_EYear")) 
	GameRcv_EMonth    = fInject(Request("GameRcv_EMonth")) 
	GameRcv_EDay      = fInject(Request("GameRcv_EDay")) 
	GameRcvDateE      = GameRcv_EYear&"-"&GameRcv_EMonth&"-"&GameRcv_EDay



	EnterType        = fInject(Request("EnterType"))


	HostCode         = fInject(Request("HostCode"))
	ViewYN         = fInject(Request("ViewYN"))




	'대회정보 중복 확인
	ChkSQL = "SELECT GameTitleIDX "
	ChkSQL = ChkSQL&" FROM SportsDiary.dbo.tblGameTitle "
	ChkSQL = ChkSQL&" WHERE DelYN='N'"
	ChkSQL = ChkSQL&" AND GameTitleName='"&GameTitleName&"'"

	Set CRs = Dbcon.Execute(ChkSQL)

	
	'이미등록된 경기
	If Not (CRs.Eof Or CRs.Bof) Then 
		Response.Write "SAME"
		Response.End
	End If 

	CRs.Close
	Set CRs = Nothing	



	InSQL = "Insert Into SportsDiary.dbo.tblGameTitle "
	InSQL = InSQL&"("
	InSQL = InSQL&" SportsGb"
	InSQL = InSQL&",GameGb"
	InSQL = InSQL&",GameTitleName"
	InSQL = InSQL&",GameS"
	InSQL = InSQL&",GameE"
	InSQL = InSQL&",GameYear"
	InSQL = InSQL&",GameArea"
	InSQL = InSQL&",Sido"
	InSQL = InSQL&",SidoDtl"
	InSQL = InSQL&",GameRcvDateS"
	InSQL = InSQL&",GameRcvDateE"
	InSQL = InSQL&",EnterType"
	InSQL = InSQL&",HostCode"
	InSQL = InSQL&",ViewYN"
	InSQL = InSQL&")"
	InSQL = InSQL&" VALUES "
	InSQL = InSQL&"("
	InSQL = InSQL&"'"&SportsGb&"'"
	InSQL = InSQL&",'"&GameGb&"'"
	InSQL = InSQL&",'"&GameTitleName&"'"
	InSQL = InSQL&",'"&GameS&"'"
	InSQL = InSQL&",'"&GameE&"'"
	InSQL = InSQL&",'"&GameYear&"'"
	InSQL = InSQL&",'"&GameArea&"'"
	InSQL = InSQL&",'"&Sido&"'"
	InSQL = InSQL&",'"&SidoDtl&"'"
	InSQL = InSQL&",'"&GameRcvDateS&"'"
	InSQL = InSQL&",'"&GameRcvDateE&"'"
	InSQL = InSQL&",'"&EnterType&"'"
	InSQL = InSQL&",'"&HostCode&"'"
	InSQL = InSQL&",'"&ViewYN&"'"
	InSQL = InSQL&")"	
'	Response.Write InSQL
'	Response.End
	
	Dbcon.Execute(InSQL)



	Response.Write "TRUE"
	Response.End
	
%>