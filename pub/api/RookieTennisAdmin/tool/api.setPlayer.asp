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


SQL = "select playeridx,userphone,birthday,teamNm,team2Nm from tblPlayer where UserName = '"&username&"' and delYN = 'N' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
	arrRP = rs.GetRows()
End if

If IsArray(arrRP) Then
	i = 0
	For ar = LBound(arrRP, 2) To UBound(arrRP, 2) 
		If i = 0 then
			pidxs =  arrRP(0, ar)
		Else
			pidxs =  pidxs & "," & arrRP(0, ar)
		End if
	i = i + 1
	Next
End if

'Response.write pidxs
'Response.end

If  pidxs <> "" then
	SQL = "select playeridx from sd_TennisMember where PlayerIDX in ( "&pidxs&" )"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then 
		arrRM1 = rs.GetRows()
	End if


	SQL = "select playeridx from sd_TennisMember_partner where PlayerIDX in (  "&pidxs&" )"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then 
		arrRM2 = rs.GetRows()
	End If
End if


'######################################################

If IsArray(arrRP) Then
	i = 0
	For ar = LBound(arrRP, 2) To UBound(arrRP, 2) 
		m1 = False
		m2 = false
		playeridx = arrRP(0, ar)
		userphone = arrRP(1, ar)	


		'If isNull(userphone) = true then

			If IsArray(arrRM1) Then
				For ar1 = LBound(arrRM1, 2) To UBound(arrRM1, 2) 
					m1pidx = arrRM1(0, ar1)
					If CDbl(m1pidx) = CDbl(playeridx) Then
						m1 = true
					End if
				Next
			End If

			If IsArray(arrRM2) Then
				For ar2 = LBound(arrRM2, 2) To UBound(arrRM2, 2) 
					m2pidx = arrRM2(0, ar2)
					If CDbl(m2pidx) = CDbl(playeridx) Then
						m2 = true
					End if
				Next
			End If
			
			If m1 = false and m2 = false Then
				SQL = "update tblPlayer Set delYn = 'Y' where playerIDX = " & playeridx
				Call db.execSQLRs(SQL , null, ConStr)
				Response.write playeridx & ".....삭제<br>"
			End If
		'Else
		
'			'폰번호 이름 동일한 사람 삭제
'			If IsArray(arrRP) Then
'				 n=1
'				For arp = LBound(arrRP, 2) To UBound(arrRP, 2) 
'					ppidx = arrRP(0, arp)
'					pno = arrRP(1, arp)
'					If userphone= pno And n > 1 Then
'						SQL = "update tblPlayer Set delYn = 'Y' where playerIDX = " & ppidx
'						Call db.execSQLRs(SQL , null, ConStr)
'						Response.write playeridx & ".....삭제<br>"
'					End if
'				n = n + 1
'				Next
'			End If
			
		'End if

	i = i + 1
	Next
End if


Response.write orgkey & " " &  username & ".....정리 완료<br>"

Rs.close
Set Rs=nothing

db.Dispose
Set db = Nothing
%>