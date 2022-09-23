<!--#include virtual="/Manager_Wres/Library/ajax_config.asp"-->
<%
	GameTitleIDX     = fInject(Request("GameTitleIDX")) 
	GameDay          = fInject(Request("GameDay")) 
	CheifIdx         = fInject(Request("CheifIdx")) 
	CheifType        = fInject(Request("CheifType")) 
	StadiumNumber    = fInject(Request("StadiumNumber")) 
	CheifLevel       = fInject(Request("CheifLevel")) 

	'심판정보 같은날 같은심판 중복 확인
	ChkSQL = "SELECT CheifIDX "
	ChkSQL = ChkSQL&" FROM tblRCheif"
	ChkSQL = ChkSQL&" WHERE DelYN = 'N'"
	ChkSQL = ChkSQL&" AND SportsGb = 'wres'"
	ChkSQL = ChkSQL&" AND GameDate = '" & GameDay & "'"
	ChkSQL = ChkSQL&" AND CheifIDX = '" & CheifIdx & "'"

	Set CRs = Dbcon.Execute(ChkSQL)

	
	'이미등록된 경기
	If Not (CRs.Eof Or CRs.Bof) Then 
		Response.Write "SAME"
		Response.End
	End If 

	CRs.Close
	Set CRs = Nothing	

	'심판정보 같은날 같은심판 중복 확인
	ChkSQL = "SELECT Sido,  UserName"
	ChkSQL = ChkSQL&" FROM tblCheif"
	ChkSQL = ChkSQL&" WHERE DelYN = 'N'"
	ChkSQL = ChkSQL&" AND SportsGb = 'wres'"
	ChkSQL = ChkSQL&" AND CheifIDX = '" & CheifIdx & "'"

	Set CRs = Dbcon.Execute(ChkSQL)

	If Not (CRs.Eof Or CRs.Bof) Then 
		STR_Sido = CRs("Sido")
		STR_UserName = CRs("UserName")
	End If 

	CRs.Close
	Set CRs = Nothing


	InSQL = "INSERT INTO SportsDiary.dbo.tblRCheif"
	InSQL = InSQL&" ("
	InSQL = InSQL&" SportsGb, "
	InSQL = InSQL&" GameTitleIDX, "
	'InSQL = InSQL&" TeamGb, "
	'InSQL = InSQL&" Sex, "
	'InSQL = InSQL&" Level, "
	'InSQL = InSQL&" GroupGameGb, "
	'InSQL = InSQL&" RgameLevelIDX, "
	InSQL = InSQL&" CheifType, "
	InSQL = InSQL&" CheifLevel, "
	InSQL = InSQL&" CheifIDX, "
	InSQL = InSQL&" UserName, "
	InSQL = InSQL&" sido, "
	InSQL = InSQL&" StadiumNumber, "
	InSQL = InSQL&" GameDate"
	InSQL = InSQL&" )"
	InSQL = InSQL&" VALUES"
	InSQL = InSQL&" ("
	InSQL = InSQL&"'wres',"
	InSQL = InSQL&"'" & GameTitleIDX & "',"
	InSQL = InSQL&"'" & CheifType & "',"
	InSQL = InSQL&"'" & CheifLevel & "',"
	InSQL = InSQL&"'" & CheifIDX & "',"
	InSQL = InSQL&"'" & STR_UserName & "',"
	InSQL = InSQL&"'" & STR_Sido & "',"
	InSQL = InSQL&"'" & StadiumNumber & "',"
	InSQL = InSQL&"'" & GameDay & "'"
	InSQL = InSQL&" )"


	Dbcon.Execute(InSQL)



	Response.Write "TRUE"
	Response.End
	
%>