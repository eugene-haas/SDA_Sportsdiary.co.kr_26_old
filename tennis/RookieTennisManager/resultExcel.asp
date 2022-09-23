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
tidx = chkInt(chkReqMethod("tidx", "GET"), 1)
levelno = chkInt(chkReqMethod("levelno", "GET"), 1)


SQL = "select a.gametitlename ,b.teamgbnm from sd_tennistitle as a inner join tblrgamelevel as b on a.gametitleidx = b.gametitleidx where a.gametitleidx = "  & tidx & " and b.level =  '"&levelno&"' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
gtitle = rs(0)
gboo = rs(1)



field = " ROW_NUMBER() over(order by b.idx asc) as no , a.userid as '아이디',a.username as '이름',a.userphone as '핸드폰',a.birthday as '생일',a.sex as '성별',   b.titleidx as '대회인덱스',b.titleName as '대회명',b.teamgbName as '부명',getpoint as '랭킹포인트' , rankno as '순위'  "
SQL = "select  "&field&"  from tblplayer as a INNER JOIN sd_TennisRPoint_log as b ON a.playeridx = b.playeridx where  b.titleIDX = " & tidx & " and b.teamGb = " & Left(levelno,5) & " "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


Response.Buffer = True     
Response.ContentType = "application/vnd.ms-excel"
Response.CacheControl = "public"
Response.AddHeader "Content-disposition","attachment;filename=대회결과_"&gtitle&"("&gboo&")"&date()& ".xls"


Call rsDrow(rs)
%>


<%
db.Dispose
Set db = Nothing
%>




</body>
</html>
