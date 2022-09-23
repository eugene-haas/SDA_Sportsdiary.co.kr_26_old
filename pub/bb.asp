<!-- #include virtual = "/pub/header.pub.asp" -->

<%
	Set db = new clsDBHelper
	SQL = "select top 1 * from tblmember "
	Set rs = db.ExecSQLReturnRS(SQL , null, SD_ConStr)

Response.write rs(0)
%>




<%
'	reqstr = "?REQ={""CMD"":20000,""IDX"":"""&tidx&""",""S1"":""tn001001"",""S2"":"&Left(levelno,3)&",""S3"":"&levelno&",""TT"":1,""SIDX"":0}"
'	source = Stream_BinaryToString( GetHTTPFile("http://bka.kr/back/gamemaker/view/view_lrf_k_team.asp?ev_serial=3001590&lg_part=1&lg_name=%B3%B2%C0%DA%BD%C7%BE%F7%BA%CE%20%B4%DC%C3%BC") , "utf-8" )
'	source = Stream_BinaryToString( GetHTTPFile("http://bka.kr/back/gamemaker/view/view_lrf_k_team.asp?ev_serial=3001590&lg_part=1&lg_name=%B3%B2%C0%DA%BD%C7%BE%F7%BA%CE%20%B4%DC%C3%BC") , "euc-kr" 

'	source = Stream_BinaryToString( GetHTTPFile("http://www.daum.net") , "utf-8" )
'Response.write year(date)
'Response.write source
%>