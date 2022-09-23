<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%

	RgameLevelIDX             = fInject(decode(Request("RgameLevelIDX"),0))
	GroupGameNum             = fInject(decode(Request("GroupGameNum"),0))
		
	If trim(RgameLevelIDX) = "" Then 
		Response.End
	End If 

	If trim(GroupGameNum) = "" Then 
		Response.End
	End If 

	USQL = "UPDATE tblPlayerResult SET "
	USQL = USQL & " DelYN = 'Y',"
	USQL = USQL & " WorkDt = getdate()"
	USQL = USQL & " WHERE DelYN = 'N' "
	USQL = USQL & " AND RGameLevelidx= '" & RgameLevelIDX & "' "
	USQL = USQL & " AND GroupGameNum = '" & GroupGameNum & "' "
	USQL = USQL & " AND GroupGameGb = 'sd040002' "
	USQL = USQL & " AND ISNULL(LPlayerIDX,'') <> '' AND ISNULL(RPlayerIDX,'') <> '' "

	Dbcon.Execute(USQL) 

	USQL = "UPDATE tblRPlayer SET "
	USQL = USQL & " DelYN = 'Y', "
	USQL = USQL & " WorkDt = getdate()"
	USQL = USQL & " WHERE DelYN = 'N'"
	USQL = USQL & " AND RGameLevelidx = '" & RgameLevelIDX & "'"
	USQL = USQL & " AND GroupGameNum = '" & GroupGameNum & "' "
	USQL = USQL & " AND GroupGameGb = 'sd040002'"
	Dbcon.Execute(USQL)

	USQL = "UPDATE tblRGameResult SET "
	USQL = USQL & " DelYN = 'Y', "
	USQL = USQL & " WorkDt = getdate()"
	USQL = USQL & " WHERE DelYN = 'N'"
	USQL = USQL & " AND RGameLevelidx = '" & RgameLevelIDX & "'"
	USQL = USQL & " AND GroupGameNum = '" & GroupGameNum & "'"
	USQL = USQL & " AND GroupGameGb = 'sd040002'"
	Dbcon.Execute(USQL)

	USQL = "UPDATE tblRGameResultDtl SET "
	USQL = USQL & " DelYN = 'Y',"
	USQL = USQL & " WorkDt = getdate()"
	USQL = USQL & " WHERE DelYN = 'N'"
	USQL = USQL & " AND RGameLevelidx = '" & RgameLevelIDX & "'"
	USQL = USQL & " AND GroupGameNum = '" & GroupGameNum & "'"
	USQL = USQL & " AND GroupGameGb = 'sd040002'"

	Dbcon.Execute(USQL)
	  	
	Dbclose()
	
	Response.Write "TRUE"
	Response.End

%>

