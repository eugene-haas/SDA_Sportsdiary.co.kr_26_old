<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq          = fInject(Request("seq"))		
	

		LSQL = "SELECT "
		LSQL = LSQL&" RPlayerMasterIDX AS IDX"
		LSQL = LSQL&" , PlayerIDX"
		LSQL = LSQL&" , Team"
		LSQL = LSQL&" , UserName"
		LSQL = LSQL&" FROM SportsDiary.dbo.tblRPlayerMaster "
		LSQL = LSQL&" WHERE RPlayerMasterIDX='"&seq&"'"

	
'	Response.Write LSQL
'	Response.End
	
  DBOpen()
	Set LRs =  DBCon.execute(LSQL)	
	DBClose()
%>

<%If LRs.bof and LRs.eof Then %>
		null
<%Else

	Do until LRs.EOF	
		'IDX,학교코드,참가자명,선수IDX
%>
   <%=LRs("IDX")%>|><%=LRs("Team")%>|><%=LRs("UserName")%>|><%=LRs("PlayerIDX")%>
	 <%
			'Response.End
			LRs.MoveNext
		Loop
	End If 
%>
	
<% LRs.Close
   Set LRs = Nothing  
%>
