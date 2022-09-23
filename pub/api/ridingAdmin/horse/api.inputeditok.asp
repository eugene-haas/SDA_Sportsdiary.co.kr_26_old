<%
'#############################################

'말정보수정

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
	chkfld = "playerIDX"



		updatefield = " hpassport,userName,hchipno,hfield,hhairclr "

		updatefield = updatefield & ",hpassportagency,hnation,eng_nm,sex,birthday,nowyear, chk1,chk2,chk3,chk4, hCDASTR,howner,hownerbirthday,userphone,email,ZipCode,Address1,Address2     "


		upfieldarr =  Split(updatefield, ",")  'e_idx 는 맨두에 별도값으로가져오고

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				updatefield	= " "&upfieldarr(i)&" = '"&reqArr.Get(i)&"' "


			Case 11
				'종목시작
				jm	= reqArr.Get(i)
			Case 11,12,13,14
				'종목
				jm	= jm & ","&reqArr.Get(i)
			Case 15
				'종목끝
				jm	= jm & ","&reqArr.Get(i)
				updatefield	= updatefield & ", "&upfieldarr(i)&" =  '"&jm&"' "



			Case oJSONoutput.PARR.length-1
					e_idx = reqArr.Get(i)
			Case Else
				updatefield	= updatefield & ", "&upfieldarr(i)&" =  '"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "update  "&tblnm&" Set   " & updatefield & " where "&chkfld&" = " & e_idx
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




