<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq          = fInject(Request("seq"))		
	GroupGameGb  = fInject(Request("GroupGameGb"))


	If GroupGameGb = SportsCode&"040001" Then 
	'개인전일때
		LSQL = "SELECT "
		LSQL = LSQL&" RPlayerMasterIDX AS IDX"
		LSQL = LSQL&" , PlayerIDX"
		LSQL = LSQL&" , SchIDX"
		LSQL = LSQL&" , Team"
		LSQL = LSQL&" , UserName"
		LSQL = LSQL&" FROM SportsDiary.dbo.tblRPlayerMaster "
		LSQL = LSQL&" WHERE RPlayerMasterIDX='"&seq&"'"

	ElseIf GroupGameGb = SportsCode&"040002" Then 
	'단체전일때
		LSQL = "SELECT "
		LSQL = LSQL&" RGameGroupSchoolMasterIDX AS IDX"
		LSQL = LSQL&" , SchIDX"
		LSQL = LSQL&" , Team"
		LSQL = LSQL&" , SchoolName AS UserName"
		LSQL = LSQL&" FROM SportsDiary.dbo.tblRGameGroupSchoolMaster "
		LSQL = LSQL&" WHERE RGameGroupSchoolMasterIDX='"&seq&"'"		
	End If 


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
		If GroupGameGb = SportsCode&"040001" Then 
		'개인전일때
		'IDX,학교코드,참가자명,선수IDX
%>
   <%=LRs("IDX")%>|><%=LRs("Team")%>|><%=LRs("UserName")%>|><%=LRs("PlayerIDX")%>
<%
		ElseIf GroupGameGb = SportsCode&"040002" Then 		
		'단체전일때
		'IDX,학교코드,학교명
%>
   <%=LRs("IDX")%>|><%=LRs("Team")%>|><%=LRs("UserName")%>
<%
		End If 
%>		

	 <%
			'Response.End
			LRs.MoveNext
		Loop
	end if
%>
	
<% LRs.Close
   Set LRs = Nothing  
%>
