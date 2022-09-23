<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq        = fInject(request("seq"))		
	
	LSQL = "SELECT "
	LSQL = LSQL&" P.PlayerIDX "
	LSQL = LSQL&" ,PlayerCode "
	LSQL = LSQL&" ,P.SportsGb AS SportsGb "
	LSQL = LSQL&" ,P.PlayerGb AS PlayerGb "
	LSQL = LSQL&" ,SL.SchoolName "
	LSQL = LSQL&" ,SL.SchIDX AS SchIDX "
	LSQL = LSQL&" ,SL.TeamGb AS TeamGb "
	LSQL = LSQL&" ,P.UserName AS UserName "
	LSQL = LSQL&" ,P.Sex AS Sex "
	LSQL = LSQL&" ,P.UserID AS UserID "
	LSQL = LSQL&" ,P.UserPass AS UserPass "
	LSQL = LSQL&" ,P.UserPhone  AS UserPhone"
	LSQL = LSQL&" ,Left(P.BirthDay,4)  AS Birth_Year"
	LSQL = LSQL&" ,SubString(P.BirthDay,6,2)  AS Birth_Month"
	LSQL = LSQL&" ,SubString(P.BirthDay,9,4)  AS Birth_Day"
	LSQL = LSQL&" ,P.PlayerStartYear AS PlayerStartYear "
	LSQL = LSQL&" ,P.Tall AS Tall "
	LSQL = LSQL&" ,P.Weight AS Weight "
	LSQL = LSQL&" ,P.BloodType AS BloodType "
	LSQL = LSQL&" ,P.Level AS Level "
	LSQL = LSQL&" FROM SportsDiary.dbo.tblPlayer P "
	LSQL = LSQL&" Join SportsDiary.dbo.tblSchoolList SL "
	LSQL = LSQL&" ON P.NowSchIDX = SL.SchIDX "
	LSQL = LSQL&" WHERE P.PlayerIDX='"&seq&"'"
	
  
  DBOpen()
	Set LRs =  DBCon.execute(LSQL)	
	DBClose()
%>

<%If LRs.bof and LRs.eof Then %>
		null
<%Else%>		
<%	Do until LRs.EOF	%>		
   <%=LRs("PlayerCode")%>|><%=LRs("SportsGb")%>|><%=LRs("PlayerGb")%>|><%=LRs("SchoolName")%>|><%=LRs("SchIDX")%>|><%=LRs("TeamGb")%>|><%=LRs("UserName")%>|><%=LRs("Sex")%>|><%=LRs("UserID")%>|><%=LRs("UserPass")%>|><%=LRs("UserPhone")%>|><%=LRs("Birth_Year")%>|><%=LRs("Birth_Month")%>|><%=LRs("Birth_Day")%>|><%=LRs("PlayerStartYear")%>|><%=LRs("Tall")%>|><%=LRs("Weight")%>|><%=LRs("BloodType")%>|><%=LRs("Level")%>
	 <%	LRs.MoveNext
		Loop
	end if
%>
	
<% LRs.Close
   Set LRs = Nothing  
%>
