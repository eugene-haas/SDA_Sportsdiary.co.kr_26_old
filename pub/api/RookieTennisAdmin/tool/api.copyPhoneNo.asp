<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
nkey =oJSONoutput.NKEY
orgkey = nkey
Set db = new clsDBHelper

SQL = "select userName,count(*) from tblPlayer where delYN = 'N' group by UserName having count(*) > 1 order by 2 desc"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
	arrRS = rs.GetRows()
End if

If IsArray(arrRS) Then
	i = 0
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
		If CDbl(nkey) = i then
			username =  arrRS(0, ar)
			oJSONoutput.NKEY = i + 1
			Exit for
		End if
	i = i + 1
	Next
End if

'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


'######################################################
SQL = "select playeridx,userphone,birthday,sex,teamNm,team2Nm from tblPlayer where UserName = '"&username&"' and delYN = 'N' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
	arrRP = rs.GetRows()
End if


If IsArray(arrRP) Then
	i = 0
	For ar = LBound(arrRP, 2) To UBound(arrRP, 2) 
		m1 = False
		m2 = false
		playeridx = arrRP(0, ar)
		userphone = arrRP(1, ar)	
		birthday = arrRP(2,ar)
		sex = arrRP(3,ar)

'		If isNull(userphone) = False Or userphone <> "" Then
'			copyphoneno = userphone
'		End If
'		If isNull(userphone) = true Or userphone = "" then
'			SQL = "update tblPlayer Set userphone = '"&copyphoneno&"' where playerIDX = " & playeridx
'			Call db.execSQLRs(SQL , null, ConStr)
'			Response.write playeridx & " PNO:" & copyphoneno & ".....복사<br>"
'		End if		

		If isNull(birthday) = False Or birthday <> "" Then
			copybirthday = birthday
			copysex = sex
		End if

		If isNull(birthday) = true Or birthday = "" Then
			SQL = "update tblPlayer Set birthday = '"&copybirthday&"',sex='"&copysex&"' where playerIDX = " & playeridx
			Call db.execSQLRs(SQL , null, ConStr)
			Response.write playeridx & " PNO:" & copyphoneno & ".....복사<br>"
		End if




	i = i + 1
	Next
End if


Response.write orgkey & " " &  username & ".....폰번호복사 완료<br>"

Rs.close
Set Rs=nothing

db.Dispose
Set db = Nothing
%>