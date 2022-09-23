<%
  
  idx = oJSONoutput.IDX




	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>

<span><%=idx%></span>