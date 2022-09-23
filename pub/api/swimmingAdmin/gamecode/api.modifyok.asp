<%
'#############################################

'정보 수정

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '23번까지 '13, 14 날짜형태
		'For intloop = 0 To oJSONoutput.PARR.length-1
		'   Response.write  reqArr.Get(intloop) & "<br>"
		'Next
		'Response.end
		cda = reqArr.Get(0)
	End if


	Set db = new clsDBHelper 


		'If cda = "F2" Then
		'{""CMD"":301,""PARR"":[""F2"",""01"",""aa"",""test"",""1"",""2"",""-"",""3"",""4"",""5"",""솔로(Solo)""]}
		'updatefield = " CDA,CDC,CODE1,CODE2,CODE4,CODE5,codename,CODE6,CODE7,CODE8 " 'title = cdcnm
		'else
		updatefield = " CDA,CDC,CODE1,CODE2,CODE3,CODE4,codename "
		'End if
		upfieldarr =  Split(updatefield, ",")  'e_idx 는 맨뒤에 별도값으로가져오고

		fno = 0
		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				updatefield	= " "&upfieldarr(fno)&" = '"&reqArr.Get(i)&"' "


			
			Case oJSONoutput.PARR.length-1
					title = reqArr.Get(i)

			Case oJSONoutput.PARR.length-2
					e_idx = reqArr.Get(i)
			Case Else
				updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' "
			End Select 
		fno = fno + 1
		next


		strSql = "update  tblGameCode Set   " & updatefield & ",title = '"&title&"' where seq = " & e_idx
		'Response.write strsql
		'Response.end
		Call db.execSQLRs(strSQL , null, ConStr)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>




