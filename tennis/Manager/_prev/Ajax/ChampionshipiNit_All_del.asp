<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq             = fInject(decode(Request("seq"),0))
		
	If trim(seq) = "" Then 
		Response.End
	End If 
	
	LSQL = "        SELECT GroupGameGb GroupGameGb"
	LSQL = LSQL & "       ,Sex Sex "
	LSQL = LSQL & "       ,RGameLevelidx RGameLevelidx "
	LSQL = LSQL & "       ,GameNum GameNum "
	LSQL = LSQL & " FROM SportsDiary.dbo.tblRGameResult "
	LSQL = LSQL & " WHERE DelYN = 'N' "
	LSQL = LSQL & " AND RGameResultIDX = " & trim(seq) & " "
	
	Set LRs = Dbcon.Execute(LSQL)
	
	GroupGameGb = trim(LRs("GroupGameGb"))
	Sex = trim(LRs("Sex"))
	RGameLevelidx = trim(LRs("RGameLevelidx"))
	GameNum = trim(LRs("GameNum"))
	
	LRs.Close
	Set LRs = Nothing
	
	if GroupGameGb = "" or Sex="" or RGameLevelidx="" or GameNum="" then
		Response.End
	end if		
	  
  if GroupGameGb = "sd040001" then '개인전	  	
		USQL = "UPDATE SportsDiary.dbo.tblRgameProgress "
		USQL = USQL & " SET DelYN = 'Y' "
		USQL = USQL & " WHERE DelYN = 'N' "
		USQL = USQL & "   AND RGameLevelidx = '" & RGameLevelidx & "' "		
		Dbcon.Execute(USQL)  		
		
		USQL = "UPDATE SportsDiary.dbo.tblRgameResult "
		USQL = USQL & " SET DelYN = 'Y' "
		USQL = USQL & " WHERE DelYN = 'N' "
		USQL = USQL & "   AND RGameLevelidx = '" & RGameLevelidx & "' "		
  	Dbcon.Execute(USQL)  		  	
			
		USQL = "UPDATE SportsDiary.dbo.tblRgameResultDtl "
		USQL = USQL & " SET DelYN = 'Y' "
		USQL = USQL & " WHERE DelYN = 'N' "
		USQL = USQL & "   AND RGameLevelidx = '" & RGameLevelidx & "' "		
  	Dbcon.Execute(USQL)  		  	
  end if
  
  if GroupGameGb = "sd040002" then '단체전	  
	  USQL = "UPDATE SportsDiary.dbo.tblRgameProgress "
	  USQL = USQL & " SET DelYN = 'Y' "
	  USQL = USQL & "    ,WorkDt = GETDATE() "
	  USQL = USQL & " WHERE DelYN = 'N' "
	  USQL = USQL & "   AND RGameLevelidx = '" & RGameLevelidx & "' "	  
	  Dbcon.Execute(USQL) 
	  
		USQL = "UPDATE SportsDiary.dbo.tblRgameResult "
		USQL = USQL & " SET DelYN = 'Y' "
		USQL = USQL & "    ,WorkDt = GETDATE() "
		USQL = USQL & " WHERE DelYN = 'N' "
	  USQL = USQL & "   AND RGameLevelidx = '" & RGameLevelidx & "' "	  
	  Dbcon.Execute(USQL) 
		
		USQL = "UPDATE SportsDiary.dbo.tblRgameResultDtl " 
		USQL = USQL & " SET DelYN = 'Y' "
		USQL = USQL & "    ,WorkDt = GETDATE() "
		USQL = USQL & " WHERE DelYN = 'N' "
	  USQL = USQL & "   AND RGameLevelidx = '" & RGameLevelidx & "' "	  
	  Dbcon.Execute(USQL) 	
	  
	  USQL = "UPDATE SportsDiary.dbo.tblRgameGroup " 
		USQL = USQL & " SET DelYN = 'Y' "
		USQL = USQL & "    ,WorkDt = GETDATE() "
		USQL = USQL & " WHERE DelYN = 'N' "
	  USQL = USQL & "   AND RGameLevelidx = '" & RGameLevelidx & "' "	  
	  
	  USQL = "UPDATE SportsDiary.dbo.tblRPlayer " 
		USQL = USQL & " SET DelYN = 'Y' "
		USQL = USQL & "    ,WorkDt = GETDATE() "
		USQL = USQL & " WHERE DelYN = 'N' "
	  USQL = USQL & "   AND RGameLevelidx = '" & RGameLevelidx & "' "	  
	  Dbcon.Execute(USQL) 	
	end if
  	
	Dbclose()
	
	Response.Write "TRUE"
	Response.End
%>

