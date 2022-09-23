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


	If trim(RGameLevelidx)="" or trim(GameTitleIDX)="" or trim(SportsGb) = "" or trim(PlayerIDX) = "" then 
		Respnse.Write "False"
		Response.End
	End If 
	

	if trim(WeightInYN) = "N" then '°èÃ¼Å»¶ô
		LSQL = "Insert_WeightIN_Fail '" & RGameLevelidx & "','" & PlayerIDX & "','" & PlayerNum & "','" & Weight & "','" & WeightInYN & "'"
	Else
		
  end If
  
	Response.Write LSQL
	
	Set LRs = Dbcon.Execute(LSQL)
	
	LRs.Close
	Set LRs = Nothing

	  	
	Dbclose()
	
	Response.Write "TRUE"
	Response.End
%>

