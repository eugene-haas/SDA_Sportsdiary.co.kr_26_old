<%
'#############################################

'대회생성저장

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


		insertfield = " Team,TeamNm,LEADER_NM,phone,sido,sidonm,ZipCode,Address1,Address2,LEADER_KEY "

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case 4
					'시도
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' ,(select top 1 sidonm from tblSidoInfo where sido = '"&reqArr.Get(i)&"' )  " 
			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "SET NOCOUNT ON INSERT INTO tblTeamInfo ( "&insertfield&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		'Response.write sql
		'Response.end
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>