<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	Level        = fInject(Request("Level"))	
	seq          = fInject(Request("seq"))
	LSQL = "SELECT "
	LSQL = LSQL&" GameTitleIDX"
	LSQL = LSQL&" ,SportsGb"
	LSQL = LSQL&" ,GroupGameGb "
	LSQL = LSQL&" ,TeamGb "
	LSQL = LSQL&" ,Sex "
	LSQL = LSQL&" ,GameType"
	LSQL = LSQL&" ,Left(GameDay,4)  AS GameYear"
	LSQL = LSQL&" ,SubString(GameDay,6,2)  AS GameMonth"
	LSQL = LSQL&" ,SubString(GameDay,9,2)  AS GameDay"
	LSQL = LSQL&" ,GameTime"
	LSQL = LSQL&" ,[Level]"
	LSQL = LSQL&" , EntryCnt"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblRGameLevel "
	LSQL = LSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
	LSQL = LSQL&" AND RGameLevelIDX='"&seq&"'"
	LSQL = LSQL&" AND DelYN='N'"
	LSQL = LSQL&" AND SportsGb='judo'"

'	Response.Write LSQL
'	Response.End
	
  DBOpen()
	Set LRs =  DBCon.execute(LSQL)	
	DBClose()
%>

<%If LRs.bof and LRs.eof Then %>
		null
<%Else%>		
<%
	Do until LRs.EOF	
	 If LRs("GameYear") = "--" Then 
		GameYear = ""
	 End If 
%>		
   <%=LRs("GameTitleIDX")%>|><%=LRs("SportsGb")%>|><%=LRs("GroupGameGb")%>|><%=LRs("TeamGb")%>|><%=LRs("Sex")%>|><%=LRs("GameType")%>|><%=LRs("GameYear")%>|><%=LRs("GameMonth")%>|><%=LRs("GameDay")%>|><%=LRs("GameTime")%>|><%=LRs("Level")%>|><%=LRs("EntryCnt")%>
	 <%
			'Response.End
			LRs.MoveNext
		Loop
	end if
%>
	
<% LRs.Close
   Set LRs = Nothing  
%>
