<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
Response.End





filename = oJSONoutput.FNM
sheetno = oJSONoutput.SHEETNO


Set db = new clsDBHelper

xlsFile = "D:\sportsdiary.co.kr\\xls\" & filename
Set objXlsConn = Server.CreateObject("ADODB.connection")

'- 확장자가 xlsx의 경우
xlsConnString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & xlsFile & "; Extended Properties=Excel 12.0;"

sheetname = getSheetName(xlsConnString)
objXlsConn.Open xlsConnString  

Sql = "Select  * From ["&sheetname(sheetno)&"] "
Set Rs = objXlsConn.Execute(Sql)


	Do Until rs.eof
		'Response.write rs(0) & "<br>"
'		If CDbl(rs(0)) > 2334 And CDbl(rs(0)) < 2400 then
'		Response.write rs(0) & "_" &  rs(10) & "<br>"
'		Response.End
		
			'Response.write rs(10)
			'Response.end
			If isNull(rs(9)) = False then
			phone = Replace(rs(9), vbCrLf, "")
			phone = Replace(phone, vbCr, "")
			phone = Replace(phone, vbLf, "")
			Else
			phone = ""
			End if


	'		SQL = "update sd_2017excelrank set rankno  = "&rs(6)&" where idx = "&rs(0)&" and name = '"&rs(1)&"' " 
			SQL = "insert into sd_2017excelrank (idx,name,booname,point, title,gamedate,rankno,team1,team2,phone) values ('"&rs(0)&"','"&rs(2)&"','"&rs(1)&"','"&rs(7)&"','"&rs(5)&"','"&rs(8)&"','"&rs(6)&"','"&rs(3)&"','"&rs(4)&"','"&phone&"')"
			Call db.execSQLRs(SQL , null, ConStr)
			Response.write sql & "<br>"
		
'		End if

	rs.movenext
	Loop

db.Dispose
Set db = Nothing
Response.end



If Not rs.eof Then
	arrRS = rs.GetRows()
End If
lastrs = UBound(arrRS, 2) 



'타입 석어서 보내기
Call oJSONoutput.Set("LASTRS", lastrs )
Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


'movefirst 막먹힘 엑셀에서 rs.RecordCount 이것도 안됨 그냥 카운트 하자
Sql = "Select  * From ["&sheetname(sheetno)&"]  "
Set Rs = objXlsConn.Execute(Sql)



Response.write "<br><br><br>"
For i = 0 To ubound(sheetname)-1
	%><a href="javascript:mx.SetSheet(<%=CDbl(i )%>,'<%=filename%>')" class="btn_a"><%=sheetname(i) & " 내용"%> 선택</a><%
next

Response.write "<br><br>"
Call rsDrow(rs)


Rs.close
Set Rs=nothing
objXlsConn.close
Set objXlsConn=Nothing
%>