<!--#include virtual="/Manager_Wres/Library/ajax_config.asp"-->
<%
	RCheifIDX        = fInject(request("RCheifIDX"))		

	LSQL = "SELECT A.RCheifIDX, A.GameTitleIDX, A.CheifType, A.CheifLevel, A.CheifIDX, A.UserName, A.sido, StadiumNumber, A.GameDate, B.GameYear"
	LSQL = LSQL&" FROM tblRCheif A"
	LSQL = LSQL&" INNER JOIN tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX"
	LSQL = LSQL&" WHERE A.DelYN = 'N'"
	LSQL = LSQL&" AND B.DelYN = 'N'"
	LSQL = LSQL&" AND RCheifIDX = '" & RCheifIDX & "'"
	
'	Response.Write LSQL
'	Response.End
	
  DBOpen()
	Set LRs =  DBCon.execute(LSQL)	
	DBClose()
%>

<%If LRs.bof and LRs.eof Then %>
		null
<%Else%>		
<%	Do until LRs.EOF	%>		
   <%=LRs("RCheifIDX")%>|><%=LRs("GameTitleIDX")%>|><%=LRs("CheifType")%>|><%=LRs("CheifLevel")%>|><%=LRs("CheifIDX")%>|><%=LRs("UserName")%>|><%=LRs("sido")%>|><%=LRs("StadiumNumber")%>|><%=LRs("GameDate")%>|><%=LRs("GameYear")%>
	
	 <%
			'Response.End
			LRs.MoveNext
		Loop
	end if
%>
	
<% LRs.Close
   Set LRs = Nothing  
%>
