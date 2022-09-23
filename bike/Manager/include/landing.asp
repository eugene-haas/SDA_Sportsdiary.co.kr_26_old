<%@ codepage="65001" language="VBScript" %>
<%
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"
%>

<%
PN = Session("PN")
titleIdx = Session("titleIdx")
Response.redirect "/board/image/detail/info_list.asp?titleIdx="& titleIdx &"&PN="& PN &""
%>
