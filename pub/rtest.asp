<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <title>Using iframe - Launch App with page loading</title>
</head>
<body>

<%
	Set db = new clsDBHelper
	SQL = "select username from tblplayer where username = '백승훈' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write rs(0) & "<br>"

	'rs(0,0) = "t"

Response.write rs(0) & "<br>"

getpt = 260
		getpt = FormatNumber((getpt * 70 / 100),"0") '올림 Fix 버림
'		intTotalPage = FormatNumber(( 15 *70 / 100 ),0)
Response.write getpt

'		if ( intTotalCnt mod intPageSize ) > 0 then intTotalPage = intTotalPage + 1

'=round(10.5)
%>

</body>
</html>