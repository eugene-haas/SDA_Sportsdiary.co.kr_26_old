<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq	         = fInject(Request("seq")) 

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
	ChkSQL = ChkSQL&" AND RGameLevelIDX <> '"&seq&"'"


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
	SexSQL = SexSQL&" WHERE SportsGb='judo'"
	SexSQL = SexSQL&" AND DelYN='N'"
	SexSQL = SexSQL&" AND TeamGb = '"&TeamGb&"'"
	Set SRs = Dbcon.Execute(SexSQL)

	If Not (SRs.Eof Or SRs.Bof) Then 
		Sex = SRs("Sex")
	Else
		Sex = ""
	End If 




	UpSQL = " Update SportsDiary.dbo.tblRGameLevel"
	UpSQL = UpSQL&" SET "
	UpSQL = UpSQL&"  SportsGb     ='"&SportsGb&"'"
	UpSQL = UpSQL&", GameTitleIDX ='"&GameTitleIDX&"'"
	UpSQL = UpSQL&", TeamGb       ='"&TeamGb&"'"
	UpSQL = UpSQL&", Sex          ='"&Sex&"'"
	UpSQL = UpSQL&", Level        ='"&Level&"'"
	UpSQL = UpSQL&", GroupGameGb  ='"&GroupGameGb&"'"
	UpSQL = UpSQL&", GameDay      ='"&GameDate&"'"
	UpSQL = UpSQL&", GameTime     ='"&GameTime&"'"
	UpSQL = UpSQL&", GameType     ='"&VersusGb&"'"
	UpSQL = UpSQL&", EntryCnt     ='"&EntryCnt&"'"
	UpSQL = UpSQL&" WHERE RGameLevelIDX ='"&seq&"' "
'	Response.Write UpSQL
'	Response.End
	Dbcon.Execute(UpSQL)







	DbClose()

	Response.Write "TRUE"
	Response.End
	
%>