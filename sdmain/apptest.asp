<%
	Dim AppType : AppType = Request("AppType")
	Dim eventtype : eventtype = Request("eventtype")
	Dim eventcode : eventcode = Request("eventcode")
	Dim eventetc : eventetc = Request("eventetc")

	Response.Write "AppType:" & AppType & "<br>"
	Response.Write "eventtype:" & eventtype & "<br>"
	Response.Write "eventcode:" & eventcode & "<br>"
	Response.Write "eventetc:" & eventetc & "<br>"
%>
<input type="file">