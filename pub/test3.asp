<!-- #include virtual = "/pub/header.tennis.asp" -->

<%
	'reqstr = "?REQ={""CMD"":20000,""IDX"":"""&tidx&""",""S1"":""tn001001"",""S2"":"&Left(levelno,3)&",""S3"":"&levelno&",""TT"":1,""SIDX"":0}"
	source = Stream_BinaryToString( GetHTTPFile("http://tennis.sportsdiary.co.kr/pub/testlms.asp"&reqstr) , "utf-8" )

'Response.write source
%>