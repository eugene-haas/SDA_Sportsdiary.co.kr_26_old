
<!--#include virtual="/tennis/M_Player/Library/ajax_config.asp"-->

<%
sSql = "SELECT TeamGb TeamGb "
sSql = sSql & ",TeamGbNm TeamGbNm "
sSql = sSql & " FROM SD_tennis.dbo.tblTeamGbInfo "
sSql = sSql & " WHERE SportsGb = 'tennis' "

DBOpen()
Set rs = DBCon.execute(sSql)
DBClose()  
%>

<% Do until rs.EOF %>	
	<option value="<%=rs("TeamGb")%>"><%=rs("TeamGbNm")%></option>
<%  	
	rs.MoveNext
	Loop
%>

    