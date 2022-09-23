<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%

	Weight        = fInject(Request("Weight"))
	RGameLevelidx = fInject(Request("RGameLevelidx"))
	GameTitleIDX	= fInject(Request("GameTitleIDX"))
	SportsGb      = fInject(Request("SportsGb")) 
	TeamGb				= fInject(Request("TeamGb"))   
	Sex					  = fInject(Request("Sex"))
	Level					= fInject(Request("Level"))
	GroupGameGb		= fInject(Request("GroupGameGb"))
	StadiumNumber	= fInject(Request("StadiumNumber"))
	PlayerIDX			= fInject(Request("PlayerIDX"))
	PlayerNum			= fInject(Request("PlayerNum"))
	UnearnWin     = fInject(Request("UnearnWin"))	
	WeightInYN		= fInject(Request("WeightInYN"))	
	Team		= fInject(Request("Team"))	
	TeamDtl		= fInject(Request("TeamDtl"))	


	If trim(RGameLevelidx)="" or trim(GameTitleIDX)="" or trim(SportsGb) = "" or trim(PlayerIDX) = "" then 
		Response.Write "False"
		Response.End
	End If 
	

	LSQL = "SELECT COUNT(*) AS CNT"
	LSQL = LSQL & " FROM tblWeightIn"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " AND RGameLevelIDX = '" & RGameLevelidx & "'"
	LSQL = LSQL & " AND PlayerIDX = '" & PlayerIDX & "'"
	LSQL = LSQL & " AND PlayerNum = '" & PlayerNum & "'"
	LSQL = LSQL & " AND DelYN = 'N'"


	Set LRs = Dbcon.Execute(LSQL)

	If Not (LRs.Eof Or LRs.Bof) Then 
		LCnt = LRs("CNT")
	Else
		LCnt = "0"
	End If

	LRs.Close
	Set LRs = Nothing
	
	If Int(LCnt) > 0 Then
		LSQL = "UPDATE tblWeightIn SET"
		LSQL = LSQL & " [Weight] = '" & Weight & "',"
		LSQL = LSQL & " WeightInYN = '" & WeightInYN & "'"
		LSQL = LSQL & " WHERE DelYN = 'N'"
		LSQL = LSQL & " AND RGameLevelIDX = '" & RGameLevelidx & "'"
		LSQL = LSQL & " AND PlayerIDX = '" & PlayerIDX & "'"
		LSQL = LSQL & " AND PlayerNum = '" & PlayerNum & "'"

	Else
		LSQL = "INSERT INTO tblWeightIn"
		LSQL = LSQL & " ("
		LSQL = LSQL & " RGameLevelIDX, Team, TeamDtl, PlayerIDX, PlayerNum, Weight, WeightInYN"
		LSQL = LSQL & " )"
		LSQL = LSQL & " VALUES"
		LSQL = LSQL & " ("
		LSQL = LSQL & " '" & RGameLevelidx & "',"
		LSQL = LSQL & " '" & Team & "',"
		LSQL = LSQL & " '" & TeamDtl & "'," 
		LSQL = LSQL & " '" & PlayerIDX & "',"
		LSQL = LSQL & " '" & PlayerNum & "',"
		LSQL = LSQL & " '" & Weight & "',"
		LSQL = LSQL & " '" & WeightInYN & "')"

	End If

	Set MRs = Dbcon.Execute(LSQL)
	

	Set MRs = Nothing

	Dbclose()
	
	Response.Write "TRUE"
	Response.End
%>

