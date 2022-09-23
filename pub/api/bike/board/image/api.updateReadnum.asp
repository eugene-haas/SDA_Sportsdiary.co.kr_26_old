<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){

	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
Dim readnum, idx
Set db = new clsDBHelper

idx = request("idx")
SQL = "UPDATE dbo.sd_bikeBoard_c SET readnum = readnum + 1 WHERE idx = "& idx &" "
Call db.ExecSQLRs(SQL, null, ConStr)

SQL = "SELECT readnum FROM dbo.sd_bikeBoard_c WHERE idx = "& idx &" "
Set rs = db.ExecSQLReturnRs(SQL, null, ConStr)
If Not rs.eof Then
  readnum = rs(0)
End If

response.write readnum
db.dispose
%>
