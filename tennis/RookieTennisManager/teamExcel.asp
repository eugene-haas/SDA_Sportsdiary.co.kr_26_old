<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<head>
<title>excel</title>
</head>
<body >

<%
'request
idx = chkInt(chkReqMethod("idx", "GET"), 1)
tidx = chkInt(chkReqMethod("tidx", "GET"), 1)



	SQL = "select team as '클럽코드',teamnm as '클럽명칭' from  tblTeamInfo where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rs.RecordCount




Response.Buffer = True     
Response.ContentType = "application/vnd.ms-excel"
Response.CacheControl = "public"
Response.AddHeader "Content-disposition","attachment;filename=KATACLUB_"&date()& ".xls"


Call rsDrow(rs)
%>


<%
db.Dispose
Set db = Nothing
%>




</body>
</html>
