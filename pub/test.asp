

<script type="text/javascript">
<!--
	var middlepath = location.hostname.split(".")[0].toLowerCase().replace('admin','');

	document.write (middlepath);
//-->
</script>



<%
Response.end
ddd = "Testttt"
Response.write Replace(ddd,"test","DDD")

%>


<!-- include s --><!-- include e -->


<script type="text/javascript">
<!--
	var aaa = [];
	aaa.push('a');
	aaa.push('b');
	alert(aaa.join());
//-->
</script>

<%

ids = "mujerk,dddd"
uid = "mujerk"


	idss = Split(ids,",")
	For i = 0 To ubound(idss)  

		If idss(i) = uid Then
			Response.write "sss"
		End if
	next













Response.end
%>
