<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<!doctype html>
<html lang="ko">

 <head>
  <meta charset="UTF-8">
  <title>샘플</title>
 </head>



 <body>

<%

'msec = 110
'
'now_sec = msec / 1000
'hh = now_sec mod 3600
'mm = (now_sec mod 3600) / 60
'ss = now_sec Mod 60
'
'Response.write now_sec & "<br>"
''Response.write hh & "<br>"
'Response.write mm & "<br>"
'Response.write ss & "<br>"
'
'
'aaa = "123456"
'Response.write Mid(aaa,3,2)

			Function getRC(endrc, dbrc)
				Dim rc, p_min,p_sec,p_msec,c_min,c_sec,c_msec
				Dim p_total,c_total,d_total
				Dim d_min,d_sec,d_msec

				If Len(endrc) <> 6 Or Len(dbrc) <> 6 Then
					getRC = "000000"
				else

					p_min = Left(dbrc, 2)
					p_sec = mid(dbrc, 3, 2)
					p_msec = right(dbrc, 2)
'Response.write 	p_min&"__"&p_sec&"__"&p_msec & "<br>"
					c_min = Left(endrc, 2)
					c_sec = mid(endrc, 3, 2)
					c_msec = right(endrc, 2)
'Response.write  c_min&"__"&c_sec&"__"&c_msec & "<br>"


					 c_total = (CDbl(c_min) * 60 * 1000 ) + (CDbl(c_sec) * 1000) + CDbl(c_msec * 10)
					 p_total = (CDbl(p_min) * 60 * 1000 ) + (CDbl(p_sec) * 1000) + CDbl(p_msec * 10) 
					 d_total =  CDbl(c_total) - CDbl(p_total)

Response.write  p_total&"__"&c_total&"__"&d_total & "<br>"

					 d_min = Fix(Cdbl(d_total) / ( 60 * 1000))
					 d_sec =  Fix((CDbl(d_total) / 1000 ))
					 d_msec =   Fix((CDbl(d_total) Mod 1000) / 10)

Response.write  d_min&"__"&d_sec&"__"&d_msec &"__"&addZero(d_min) & addZero(d_sec) & addZero(d_msec) & "<br>"

					getRC =  addZero(d_min) & addZero(d_sec) & addZero(d_msec)

				End if
			End Function


dbrc = "010959"
endrc = "013765"

Response.write getRC(endrc, dbrc)



'03:18:60
'02:54:70
'
'   23:90
%>

 </body>




</html>
