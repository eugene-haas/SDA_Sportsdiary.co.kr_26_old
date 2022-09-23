<%
	widurl = oJSONoutput.value("URL")
	'iframe



%>
<div class='modal-header'><button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button><h3 id='myModalLabel'><%=widurl%></h3></div>
<div class='modal-body'>



<iframe src="http://<%=widurl%>" frameborder="0" width="100%" height="600"></iframe>




</div>