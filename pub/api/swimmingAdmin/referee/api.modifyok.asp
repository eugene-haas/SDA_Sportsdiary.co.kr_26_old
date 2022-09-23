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
	End if


	Set db = new clsDBHelper 


		updatefield = " CDA,name,sex,teamnm,grade,team,userphone  "
		upfieldarr =  Split(updatefield, ",")  'e_idx 는 맨뒤에 별도값으로가져오고

		fno = 0
		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				updatefield	= " "&upfieldarr(fno)&" = '"&reqArr.Get(i)&"' "
			Case oJSONoutput.PARR.length-1
					e_idx = reqArr.Get(i)
			Case Else
				updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' "
			End Select 
		fno = fno + 1
		next


		strSql = "update  tblReferee Set   " & updatefield & " where seq = " & e_idx
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




