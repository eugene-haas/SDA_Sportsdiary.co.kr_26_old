<%@ codepage="65001" language="VBScript" %>
<%
	If request("EUCKR") = "Y" Then
		Response.CharSet="euc-kr"
		Session.codepage="65001"
		Response.codepage="65001"
		Response.ContentType="text/html;charset=euc-kr"
	Else
		Response.CharSet="utf-8"
		Session.codepage="65001"
		Response.codepage="65001"
		Response.ContentType="text/html;charset=utf-8"
	End If
%>
<%
Response.Redirect "Intent://appopen?eventtype=A&eventcode=BK000002&eventetc=#Intent;scheme=sdapp;package=com.sportsdiary.player.sportsdiaryplayer;end"
%>
