<%
'#############################################

'대회 정보 수정

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


		'동일 팀명칭 체크
		SQL = "Select teamnm from tblTeamInfo where teamnm = '" & reqArr.Get(1) & "' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If not rs.eof Then
			Call oJSONoutput.Set("result", 2 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if




		updatefield = " Team,TeamNm,LEADER_NM,phone,sido,ZipCode,Address1,Address2,LEADER_KEY "

		upfieldarr =  Split(updatefield, ",")  'e_idx 는 맨두에 별도값으로가져오고

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				updatefield	= " "&upfieldarr(i)&" = '"&reqArr.Get(i)&"' "

			Case 4
					'시도
				updatefield	= updatefield & ", sido = '"&reqArr.Get(i)&"' , sidonm = (select top 1 sidonm from tblSidoInfo where sido = '"&reqArr.Get(i)&"' )  " 
			
			Case oJSONoutput.PARR.length-1
					e_idx = reqArr.Get(i)
			Case Else
				updatefield	= updatefield & ", "&upfieldarr(i)&" =  '"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "update  tblTeamInfo Set   " & updatefield & " where TeamIDX = " & e_idx
		'Response.write SQL
		'Response.end
		Call db.execSQLRs(SQL , null, ConStr)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>




