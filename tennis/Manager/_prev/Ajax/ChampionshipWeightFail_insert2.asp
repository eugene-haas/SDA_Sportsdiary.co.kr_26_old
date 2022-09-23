<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	tp = fInject(Request("tp"))    
	Search_GroupGameGb = fInject(Request("Search_GroupGameGb"))    
	LPlayerIDX       = fInject(Request("LPlayerIDX"))    
	RPlayerIDX       = fInject(Request("RPlayerIDX"))
	LUserName        = fInject(Request("LUserName"))
	RUserName        = fInject(Request("RUserName"))    
	LPlayerResult    = fInject(Request("LPlayerResult"))  
	RPlayerResult    = fInject(Request("RPlayerResult")) 
	GameTitleIDX     = fInject(Request("GameTitleIDX")) 
	GroupGameGb      = fInject(Request("GroupGameGb"))   
	Sex              = fInject(Request("Sex"))    
	Level	           = fInject(Request("Level"))		
	RGameLevelidx    = fInject(Request("RGameLevelidx"))	
	TeamGb           = fInject(Request("TeamGb"))	
	Game1R           = fInject(Request("Game1R"))	
	LSchIDX          = fInject(Request("LSchIDX"))	
	RSchIDX          = fInject(Request("RSchIDX"))	
		
	If trim(tp)="" or trim(Search_GroupGameGb)="" or trim(GameTitleIDX) = "" or trim(Sex) = "" or trim(RGameLevelidx) = "" or trim(TeamGb) = ""  or trim(Game1R) = ""   or trim(LSchIDX) = ""  or trim(RSchIDX) = "" then 
		Response.End
	End If 
	
	'기존에 입력된 값 존재여부 체크
	if trim(Search_GroupGameGb) = "2" then '단체전
		LSQL = "        SELECT COUNT(RGameGroupIDX) CNT"	
		LSQL = LSQL & " FROM SportsDiary.dbo.tblRGameGroup "
		LSQL = LSQL & " WHERE DelYN = 'N' "
		LSQL = LSQL & " AND	RGameLevelidx='" & RGameLevelidx & "'"
	  LSQL = LSQL & " AND GameTitleIDX='" & GameTitleIDX & "'"
	  'LSQL = LSQL & " AND  ,'judo'" '" & SportsGb & "'"
	  LSQL = LSQL & " AND TeamGb='" & TeamGb & "'"
	  LSQL = LSQL & " AND Sex='" & Sex & "'"
	  'LSQL = LSQL & " AND Level='" & Level & "'"
	  'LSQL = LSQL & " AND GroupGameGb='" & GroupGameGb & "'"
	  LSQL = LSQL & " AND GameNum='" & Game1R & "'" '" & GameNum & "'"
	 ' LSQL = LSQL & " AND LPlayerIDX='" & LPlayerIDX & "'"
	  'LSQL = LSQL & " AND RPlayerIDX='" & RPlayerIDX & "'"
	  'LSQL = LSQL & " AND  ,'" & LPlayerResult & "'"
	  LSQL = LSQL & " AND LSchIDX='" & LSchIDX & "'"
	  LSQL = LSQL & " AND RSchIDX='" & RSchIDX & "'"
  end if
	
	Set LRs = Dbcon.Execute(LSQL)
	
	CkCnt = trim(LRs("CNT"))
	
	LRs.Close
	Set LRs = Nothing
	
	if CkCnt <> "0" then
		Dbclose()
	
		Response.Write "DUBL"
		Response.End
	end if
	
		
	if trim(Search_GroupGameGb) = "2" then '단체전
		
		INSSQL = " INSERT INTO Sportsdiary.dbo.tblRGameGroup"
    INSSQL = INSSQL & "   (RGameLevelidx"
    INSSQL = INSSQL & "   ,GameTitleIDX"
    INSSQL = INSSQL & "   ,SportsGb"
    INSSQL = INSSQL & "   ,TeamGb"
    INSSQL = INSSQL & "   ,Sex"
    'INSSQL = INSSQL & "   ,Level"
    'INSSQL = INSSQL & "   ,GroupGameGb"
    INSSQL = INSSQL & "   ,GameNum"
    'INSSQL = INSSQL & "   ,LPlayerIDX"
    'INSSQL = INSSQL & "   ,RPlayerIDX"
    INSSQL = INSSQL & "   ,LResult"
    INSSQL = INSSQL & "   ,LSchIDX"
    INSSQL = INSSQL & "   ,RSchIDX"
    'INSSQL = INSSQL & "   ,GameDay"
    'INSSQL = INSSQL & "   ,LPlayerNum"
    'INSSQL = INSSQL & "   ,RPlayerNum"
    'INSSQL = INSSQL & "   ,LPlayerName"
    'INSSQL = INSSQL & "   ,RPlayerName"
    INSSQL = INSSQL & "   ,LJumsu"
    INSSQL = INSSQL & "   ,RJumsu"
    INSSQL = INSSQL & "   ,RResult"
    INSSQL = INSSQL & "   ,GroupGameNum"
    INSSQL = INSSQL & "   ,ChiefSign"
    INSSQL = INSSQL & "   ,AssChiefSign1"
    INSSQL = INSSQL & "   ,Round"
    INSSQL = INSSQL & "   ,AssChiefSign2"
    'INSSQL = INSSQL & "   ,StadiumNumber"
    INSSQL = INSSQL & "   ,WriteDate"
    INSSQL = INSSQL & "   ,WorkDt"
    INSSQL = INSSQL & "   ,DelYN)"
   ' INSSQL = INSSQL & "   ,MediaLink)"
		INSSQL = INSSQL & " VALUES "
		INSSQL = INSSQL & " 	('" & RGameLevelidx & "'"
    INSSQL = INSSQL & "   ,'" & GameTitleIDX & "'"
    INSSQL = INSSQL & "   ,'judo'" '" & SportsGb & "'"
    INSSQL = INSSQL & "   ,'" & TeamGb & "'"
    INSSQL = INSSQL & "   ,'" & Sex & "'"
    'INSSQL = INSSQL & "   ,'" & Level & "'"
    'INSSQL = INSSQL & "   ,'" & GroupGameGb & "'"
    INSSQL = INSSQL & "   ,'" & Game1R & "'" '" & GameNum & "'"
    'INSSQL = INSSQL & "   ,'" & LPlayerIDX & "'"
    'INSSQL = INSSQL & "   ,'" & RPlayerIDX & "'"
    INSSQL = INSSQL & "   ,CASE WHEN '" & TP & "' = 'A' THEN 'sd019024' WHEN '" & TP & "' = 'B' THEN '' WHEN '" & TP & "' = 'C' THEN 'sd019006' END"  '" & LPlayerResult & "'"
    INSSQL = INSSQL & "   ,'" & LSchIDX & "'"
    INSSQL = INSSQL & "   ,'" & RSchIDX & "'"
    'INSSQL = INSSQL & "   ,GETDATE() " '" & GameDay & "'"
    'INSSQL = INSSQL & "   ,CASE WHEN '" & TP & "' = 'A' THEN (CASE WHEN '" & Sex & "' = 'Man' then '1496' WHEN '" & Sex & "' = 'Woman' then '1497' END) ELSE '0' END" '" & LPlayerNum & "'"
    'INSSQL = INSSQL & "   ,CASE WHEN '" & TP & "' = 'A' THEN (CASE WHEN '" & Sex & "' = 'Man' then '1496' WHEN '" & Sex & "' = 'Woman' then '1497' END) ELSE '0' END" '" & RPlayerNum & "'"
    'INSSQL = INSSQL & "   ,'" & LUserName & "'" '" & LPlayerName & "'"
    'INSSQL = INSSQL & "   ,'" & RUserName & "'" '" & RPlayerName & "'"
    INSSQL = INSSQL & "   ,'10'" '" & LJumsu & "'"
    INSSQL = INSSQL & "   ,'10'" '" & RJumsu & "'"
    'INSSQL = INSSQL & "   ,'sd019021'" '" & RPlayerResult & "'"
    INSSQL = INSSQL & "   ,CASE WHEN '" & TP & "' = 'A' THEN 'sd019024' WHEN '" & TP & "' = 'B' THEN 'sd019006' WHEN '" & TP & "' = 'C' THEN '' END"  '" & LPlayerResult & "'"
    INSSQL = INSSQL & "   ,'0'" '" & GroupGameNum & "'"
    INSSQL = INSSQL & "   ,NULL" '" & ChiefSign & "'"
    INSSQL = INSSQL & "   ,NULL" '" & AssChiefSign1 & "'"
    INSSQL = INSSQL & "   ,'01'" '" & Round & "'"
    INSSQL = INSSQL & "   ,NULL" '" & AssChiefSign2 & "'"
    'INSSQL = INSSQL & "   ,NULL" '" & StadiumNumber & "'"
    INSSQL = INSSQL & "   ,GETDATE()" '" & WriteDate & "'"
    INSSQL = INSSQL & "   ,GETDATE()" '" & WorkDt & "'"
    INSSQL = INSSQL & "   ,'N')" '" & DelYN & "'"
    'INSSQL = INSSQL & "   ,NULL)" '" & MediaLink & "'"    
  
	
	end if
		
	Dbcon.Execute(INSSQL) 	
	  	
	Dbclose()
	
	Response.Write "TRUE"
	Response.End
%>

