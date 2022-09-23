<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq        = fInject(request("seq"))		

	LSQL = "SELECT "
	LSQL = LSQL&" SportsGb"
	LSQL = LSQL&" ,UserID"
	LSQL = LSQL&" ,UserPass "
	LSQL = LSQL&" ,UserName "
	LSQL = LSQL&" ,UserGubun "
	LSQL = LSQL&" ,HostCode "
	LSQL = LSQL&" ,HandPhone "
	LSQL = LSQL&" ,Company "
	LSQL = LSQL&" ,DelGubun "
	LSQL = LSQL&" FROM SportsDiary.dbo.tblUserInfo  "
	LSQL = LSQL&" WHERE IDX='"&seq&"'"
	
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
   <%=LRs("SportsGb")%>|><%=LRs("UserID")%>|><%=LRs("UserPass")%>|><%=LRs("UserName")%>|><%=LRs("UserGubun")%>|><%=LRs("HostCode")%>|><%=LRs("HandPhone")%>|><%=LRs("Company")%>|><%=LRs("DelGubun")%>|>	
	 <%
			'Response.End
			LRs.MoveNext
		Loop
	end if
%>
	
<% LRs.Close
   Set LRs = Nothing  
%>
