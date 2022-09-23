<%
'request
	If hasown(oJSONoutput, "SEQ") = "ok" then
		seq = oJSONoutput.SEQ
	End if	
	If hasown(oJSONoutput, "CDCNM") = "ok" then
		cdcnm = Mid(oJSONoutput.Get("CDCNM"),2)
	End if
'request


	Set db = new clsDBHelper


	'단체만남기고 삭제되면 안됨 (경영)
	'삭제하는게 단체인지 체크하고 다른게 있는지 확인한다.


		totalcnt =0
		SQL = "select CDA,ITGUBUN,CDCNM from tblGameRequest_imsi_r  where seq = " & seq
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			arrT = rs.GetRows() 
			totalcnt = UBound(arrT, 2) + 1
		End If


		groupcnt = 0
		personcnt = 0
		myit = "I"

		If IsArray(arrT) Then 
		For a = LBound(arrT, 2) To UBound(arrT, 2)
			c_cda = arrT(0, a) 
			c_itgubun = arrT(1,a)
			c_cdcnm = arrT(2,a)

			
			'선택한 종목이 경영이고 단체라면 조건을 보고 지워야한다.
			If c_cdcnm = cdcnm  Then
				If  c_itgubun = "T" Then
					myit = "T"
				End if
			End if
			
			
			If c_cda = "D2" Then '경영이라면
				If c_itgubun = "T" Then
					groupcnt = groupcnt + 1
				else
					personcnt = personcnt + 1
				End if
			Else
					'단체든 개인이든 경영이 아니면 결제다.
					'경영이 아니면 무조건 삭제
					personcnt = personcnt + 1
			End if

		Next
		End if


		If myit = "I" Then '개인이면
			personcnt = personcnt -1
		End if

		

		
		If CDbl(personcnt) < 1 And CDbl(totalcnt) > 1 Then '총카운트가 1개였다면 삭제

				Call oJSONoutput.Set("msg", " 단체전만 참여하실 수 없습니다."  )
				Call oJSONoutput.Set("result", "8" )
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson

				db.Dispose
				Set db = Nothing		
				Response.end

		End If




'Call oJSONoutput.Set("msg", totalcnt &" " & personcnt  )
'Call oJSONoutput.Set("result", "8" )
'strjson = JSON.stringify(oJSONoutput)
'Response.Write strjson
'Response.end




	SQL = "delete from tblGameRequest_imsi_r where seq = '"&seq&"' and cdcnm = '"&cdcnm&"' "
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>

