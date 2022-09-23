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


SQL = "select playeridx,teamNm,team2Nm from tblPlayer where UserName = '"&username&"' and delYN = 'N' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql
'Call rsdrow(rs)
'Response.end

If Not rs.EOF Then 
	arrRP = rs.GetRows()
End if

merge = False
If IsArray(arrRP) Then
	i = 0
	For ar = LBound(arrRP, 2) To UBound(arrRP, 2) 
		pidx = arrRP(0, ar)
		teamNm = arrRP(1, ar)
		If i > 0 Then
			If teamNm = teamPre Then
				merge = True '대진표 합치기
			End if
			teamPre = teamNm
		End if
	i = i + 1
	Next
End if

'If merge = True Then
	SQL = "update sd_TennisMember set PlayerIDX = "&pidx&" where userName =  '"&username&"' "
	Call db.execSQLRs(SQL , null, ConStr)
	SQL = "update sd_TennisMember_partner set PlayerIDX = "&pidx&" where userName =  '"&username&"' "
	Call db.execSQLRs(SQL , null, ConStr)

	'Response.write sql & ".....대진표 정리 완료<br>"
	Response.write orgkey & " " &  username & ".....대진표 정리 완료<br>"
'Else
'	Response.write orgkey & " " &  username & ".....<span style='color:red;'>동일팀 아님 확인필요</span><br>"
'End if




Rs.close
Set Rs=nothing

db.Dispose
Set db = Nothing
%>