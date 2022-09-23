
<% 
'   ===============================================================================     
'    Purpose : 웹페이지 시작시 넘어오는 Param를 추출한다. 
'    Make    : 2020.04.08
'    Author  :                                                       By Aramdry
'   ===============================================================================    

%>


<script language="Javascript" runat="server">

/* -------------------------------------------------------------------------------------------------
		객체에 property가 존재 하는지 검사 
	------------------------------------------------------------------------------------------------- */
	function hasProperty(obj, prop){
		return (obj.hasOwnProperty(prop) == true) ? 1 : 0; 
	}
</script>

<%
	Function requestParam(req, strTestParam)
		Dim strReq
		strReq = req("REQ")
		If req("test") = "t" Then strReq = strTestParam End If 

		requestParam = strReq 
	End Function 
%>