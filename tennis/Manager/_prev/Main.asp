<!--#include virtual="/Manager/Common/common_header.asp"-->
<%
	If Request.Cookies("UserID") = "" Then
		Response.Write "<script>top.location.href='/Manager/gate.asp?Refer_Url="&Refer_URL&"'</script>"
		Response.End
	End If 
%>
<frameset id="body" name="body" rows="114,*" frameborder="0" border="0"><!--rows="97,*,25"-->
	<!-- header -->
	<frame id="fHeader" name="fHeader" src="/Manager/include/header.asp" scrolling="no" style="width:100%; height:114px;">
	<!--// header -->
	<frameset frameborder="0" cols="170,*" border="0"><!--cols="230,*"-->
		<!-- left -->
		<frame id="fLeft" name="fLeft" src="/Manager/include/leftMenu.asp" style="background:#3e4e68;" scrolling="auto" noresize>
		<!--// left -->
		<!-- page -->
		<frame id="fPage" name="fPage" src="/Manager/View/Main.asp">
		<!--// page -->
	</frameset>
	<!-- bottom -->
 	<frame id="fBottom" name="fBottom" src="/Manager/include/bottom.asp" scrolling="no">
 	<!--// bottom -->
</frameset>
</html>

