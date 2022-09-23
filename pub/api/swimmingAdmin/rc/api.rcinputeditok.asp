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

		cda =  reqArr.Get(10)
		cdb =  reqArr.Get(13)
		cdc =  reqArr.Get(14)
		levelno = cda & cdb & cdc


		itgubun = reqArr.Get(11)
		pteamgb = reqArr.Get(10)
	End if

	'단체
	If itgubun = "T" then
		If hasown(oJSONoutput, "KSKEY2") = "ok" Then
			key2 = oJSONoutput.KSKEY2
		End If
		If hasown(oJSONoutput, "KSKEY3") = "ok" Then
			key3 = oJSONoutput.KSKEY3
		End If
		If hasown(oJSONoutput, "KSKEY4") = "ok" Then
			key4 = oJSONoutput.KSKEY4
		End If

		If hasown(oJSONoutput, "PIDX2") = "ok" Then
			pidx2 = oJSONoutput.PIDX2
		End If
		If hasown(oJSONoutput, "PIDX3") = "ok" Then
			pidx3 = oJSONoutput.PIDX3
		End If
		If hasown(oJSONoutput, "PIDX4") = "ok" Then
			pidx4 = oJSONoutput.PIDX4
		End If

		If hasown(oJSONoutput, "UNM2") = "ok" Then
			unm2 = oJSONoutput.UNM2
		End If
		If hasown(oJSONoutput, "UNM3") = "ok" Then
			unm3 = oJSONoutput.UNM3
		End If
		If hasown(oJSONoutput, "UNM4") = "ok" Then
			unm4 = oJSONoutput.UNM4
		End If
	End if
	Set db = new clsDBHelper 

							'"201903839","제28회 대통령배 전국수영대회","비고","2009-01-01","장희진","경북도청","","005527","1","R06"           ,"D2","I","2","6","02","200903009264","SW00607","48577",null,"경북","14","1366"
		updatefield = " titleCode,titlename,gamearea,gameDate,UserName,TeamNm,userClass,gameResult,gameOrder,rctype,CDA,   CDANM, gubun,Sex,  CDB,CDBNM,CDC,CDCNM ,kskey,Team, playerIDX, sido,sidoCode "
		upfieldarr =  Split(updatefield, ",")  'e_idx 는 맨두에 별도값으로가져오고

		fno = 0
		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				updatefield	= " "&upfieldarr(fno)&" = '"&reqArr.Get(i)&"' "
			Case 3 '생년월일
					If isdate(reqArr.Get(i)) = True then
						fdate = Cdate(reqArr.Get(i))
					Else
						fdate = reqArr.Get(i)
					End if
					updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&fdate&"' " 
			Case 7
					rcstr = Replace(Replace(reqArr.Get(i),":",""),".","")
					rclen = Len(rcstr)
					If rclen < 6 Then
						zerocnt =  6 - rclen
						For z = 1 To zerocnt
							zerostr = zerostr & "0"
						Next
						rcstr = zerostr & rcstr
					Else
						rcstr = Left(rcstr,6)
					End if
					updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&rcstr&"' " 

			Case 10
				Select Case reqArr.Get(i)
				Case "D2" : updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' , "&upfieldarr(fno+1)&" =  '경영'  "
				Case "E2" : updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' , "&upfieldarr(fno+1)&" =  '다이빙/수구'  "
				Case "F2" : updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' , "&upfieldarr(fno+1)&" =  '아티스틱스위밍'  "
				End Select 
				fno = fno + 1

			'Case 11 개인/단체
			'Case 12 '성별  패스 할때는 빼고
				'fno = fno - 1

			Case 13

				SQLP = " select top 1 cd_booNM from tblteamgbinfo where cd_type = 2 and cd_boo = '"&reqArr.Get(i)&"' "
				Set rs = db.ExecSQLReturnRS(SQLP , null, ConStr)
				If rs.eof Then
				updatefield	= updatefield & ", CDB =  '' , CDBNM =  ''  " 
				else
				updatefield	= updatefield & ", CDB =  '"&reqArr.Get(i)&"' , CDBNM =  '"&rs(0)&"'  " 
				End if
				fno = fno + 1

			Case 14 '15
				SQLP = " select top 1 teamgbnm from tblteamgbinfo where cd_type = 1 and pteamgb = '"&pteamgb&"' and teamgb = '"&reqArr.Get(i)&"' "
				Set rs = db.ExecSQLReturnRS(SQLP , null, ConStr)
				updatefield	= updatefield & ", CDC =  '"&reqArr.Get(i)&"' , CDCNM =  '"&rs(0)&"'  " 
				fno = fno + 1

			Case oJSONoutput.PARR.length-1
					e_idx = reqArr.Get(i)

			Case Else
				updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' "
			End Select 
			
			fno = fno + 1
		next


		If itgubun = "T" Then
			updatefield  = updatefield & " ,kskey2='"&key2&"',kskey3='"&key3&"',kskey4='"&key4&"',playerIDX2='"&pidx2&"',playerIDX3='"&pidx3&"',playerIDX4='"&pidx4&"',UserName2='"&unm2&"',UserName3='"&unm3&"',UserName4='"&unm4&"' "
		End if

		updatefield  = updatefield & ", levelno = '"&levelno&"' "

		strSql = "update  tblRecord Set   " & updatefield & " where rcIDX = " & e_idx
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




