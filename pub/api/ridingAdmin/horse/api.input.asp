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

		tblnm = "tblPlayer"
		chkfld = "username"

		'동일 팀명칭 체크
		SQL = "Select "&chkfld&" from "&tblnm&" where "&chkfld&" = '" & reqArr.Get(1) & "' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If not rs.eof Then
			Call oJSONoutput.Set("result", 2 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if

		insertfield = " hpassport,userName,hchipno,hfield,hhairclr"
		insertfield = insertfield & ",hpassportagency,hnation,eng_nm,sex,birthday,nowyear,hCDASTR,howner,hownerbirthday,userphone,email,ZipCode,Address1,Address2, usertype     "

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case 11
				'종목시작
				jm	= reqArr.Get(i)
			Case 11,12,13,14
				'종목
				jm	= jm & ","&reqArr.Get(i)
			Case 15
				'종목끝
				jm	= jm & ","&reqArr.Get(i)
				insertvalue	= insertvalue & ",'"&jm&"' "
			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "SET NOCOUNT ON INSERT INTO "&tblnm&" ( "&insertfield&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&",'H' ) SELECT @@IDENTITY"
		Response.write sql
		Response.End
		
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>