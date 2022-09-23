<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
nkey =oJSONoutput.NKEY
orgkey = nkey
Set db = new clsDBHelper


SQL = "select a.partnerIDX,a.gameMemberIDX,b.gameMemberIDX from sd_TennisMember_partner as a left outer join sd_TennisMember as b on a.gameMemberIDX = b.gameMemberIDX"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
	arrRS = rs.GetRows()
End if

If IsArray(arrRS) Then
	i = 0
	For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
			
			pnidx =  arrRS(0, ar)
			m1idx = arrRS(2, ar)



			If isNull(m1idx) = True Or m1idx = "" Then
				If i = 0 then
					delidx = pnidx	
					i = i + 1
				Else
					delidx = delidx & "," & pnidx
					i = i + 1
				End If
			End if
	Next
End if

If delidx <> "" then
SQL = "delete  sd_TennisMember_partner  where partnerIDX in (" & delidx & " )"
'Response.write sql
Call db.execSQLRs(SQL , null, ConStr)
End If



'반대로
SQL = "select b.partnerIDX,a.gameMemberIDX,b.gameMemberIDX from sd_TennisMember as a left outer join sd_TennisMember_partner as b on a.gameMemberIDX = b.gameMemberIDX"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.EOF Then 
	arrRT = rs.GetRows()
End if

If IsArray(arrRT) Then
	i = 0
	For ar2 = LBound(arrRT, 2) To UBound(arrRT, 2) 
			
			pnidx =  arrRT(0, ar2)
			m1idx = arrRT(1, ar2)

			If isNull(pnidx) = True Or pnidx = "" Then
				If i = 0 then
					mdelidx = m1idx	
					i = i + 1
				Else
					mdelidx = mdelidx & "," & m1idx
					i = i + 1
				End If
			End if
	Next
End if


If mdelidx <> "" then
SQL = "delete  sd_TennisMember  where gameMemberIDX in (" & mdelidx & " )"
Call db.execSQLRs(SQL , null, ConStr)
End If










Response.write delidx & ".....맴버 , 파트너 정보 삭제 완료<br>"

Rs.close
Set Rs=nothing

db.Dispose
Set db = Nothing
%>