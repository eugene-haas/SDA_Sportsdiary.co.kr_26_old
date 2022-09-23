<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	SportsGb	   = fInject(Request("SportsGb")) 
	GameYear     = fInject(Request("GameYear")) 
	GameTitleIDX = fInject(Request("GameTitle")) 
	GroupGameGb  = fInject(Request("GroupGameGb")) 
	TeamGb       = fInject(Request("TeamGb")) 
	Level        = fInject(Request("Level")) 
	VersusGb     = fInject(Request("VersusGb")) 
	GameYear     = fInject(Request("GameYear")) 
	GameMonth    = fInject(Request("GameMonth")) 
	GameDay      = fInject(Request("GameDay")) 
	GameTime     = fInject(Request("GameTime")) 
	EntryCnt     = fInject(Request("EntryCnt"))
	GameDate = GameYear&"-"&GameMonth&"-"&GameDay

	If GameTitleIDX = "" Or GroupGameGb = "" Or TeamGb = "" Or VersusGb = "" Then 
		Response.End
	End If 



	'대회정보 중복 확인
	ChkSQL = "SELECT RGameLevelIDX "
	ChkSQL = ChkSQL&" FROM SportsDiary.dbo.tblRGameLevel "
	ChkSQL = ChkSQL&" WHERE DelYN='N'"
	ChkSQL = ChkSQL&" AND GameTitleIDX='"&GameTitleIDX&"'"
	ChkSQL = ChkSQL&" AND TeamGb = '"&TeamGb&"'"
	ChkSQL = ChkSQL&" AND Level = '"&Level&"'"



	Set CRs = Dbcon.Execute(ChkSQL)

	
	'이미등록된 경기
	If Not (CRs.Eof Or CRs.Bof) Then 
		Response.Write "SAME"
		Response.End
	End If 

	CRs.Close
	Set CRs = Nothing


	'성별체크
	SexSQL = "SELECT " 
	SexSQL = SexSQL&"Sex "
	SexSQL = SexSQL&" FROM SportsDiary.dbo.tblLevelInfo"
	SexSQL = SexSQL&" WHERE SportsGb='" & Request.Cookies("SportsGb") & "'"
	SexSQL = SexSQL&" AND DelYN='N'"
	SexSQL = SexSQL&" AND TeamGb = '"&TeamGb&"'"
	Set SRs = Dbcon.Execute(SexSQL)

	If Not (SRs.Eof Or SRs.Bof) Then 
		Sex = SRs("Sex")
	Else
		Sex = ""
	End If 





	InSQL = "Insert Into SportsDiary.dbo.tblRGameLevel "
	InSQL = InSQL&"("
	InSQL = InSQL&" SportsGb"
	InSQL = InSQL&",GameTitleIDX"
	InSQL = InSQL&",TeamGb"
	InSQL = InSQL&",Sex"
	InSQL = InSQL&",Level"
	InSQL = InSQL&",GroupGameGb"
	InSQL = InSQL&",TotRound"
	InSQL = InSQL&",GameDay"
	InSQL = InSQL&",GameTime"
	InSQL = InSQL&",GameType"
	InSQL = InSQL&",EntryCnt"
	InSQL = InSQL&")"
	InSQL = InSQL&" VALUES "
	InSQL = InSQL&"("
	InSQL = InSQL&"'"&SportsGb&"'"
	InSQL = InSQL&",'"&GameTitleIDX&"'"
	InSQL = InSQL&",'"&TeamGb&"'"
	InSQL = InSQL&",'"&Sex&"'"
	InSQL = InSQL&",'"&Level&"'"
	InSQL = InSQL&",'"&GroupGameGb&"'"	
	InSQL = InSQL&",'0'"
	InSQL = InSQL&",'"&GameDate&"'"
	InSQL = InSQL&",'"&GameTime&"'"
	InSQL = InSQL&",'"&VersusGb&"'"	
	InSQL = InSQL&",'"&EntryCnt&"'"	
	InSQL = InSQL&")"	
	
	Dbcon.Execute(InSQL)


	DbClose()

	Response.Write "TRUE"
	Response.End
	
%>