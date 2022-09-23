<%
'#############################################

'대회생성저장

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '18개번까지 
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

		'중복체크





		insertfield = " titleCode,titlename,gamearea,gameDate,UserName,TeamNm,userClass,gameResult,gameOrder,rctype,CDA,CDANM, gubun,  CDB,CDBNM,CDC,CDCNM ,kskey,Team, playerIDX, Sex,sido,sidoCode "

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case 3 '생년월일
						'2019/12/06
					If isdate(reqArr.Get(i)) = True then
						fdate = Cdate(reqArr.Get(i))
					Else
						fdate = ""
					End if
					insertvalue	= insertvalue & ",'"&fdate&"' " 
'			Case 8
'				SQLP = "select top 1 sidonm from tblSidoInfo where sido = '"&reqArr.Get(i)&"' "
'				Set rs = db.ExecSQLReturnRS(SQLP , null, ConStr)
'				insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '"&rs(0)&"' " 
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

					insertvalue	= insertvalue & ",'"&rcstr&"' "
			Case 10
				
				Select Case reqArr.Get(i)
				Case "D2" :insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '경영' " 
				Case "E2" :insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '다이빙/수구' " 
				Case "F2" :insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '아티스틱스위밍' " 
				End Select 

			'Case 11 개인/단체

			Case 12 ''성별 
			
			Case 13
				SQLP = " select top 1 cd_booNM from tblteamgbinfo where cd_type = 2 and cd_boo = '"&reqArr.Get(i)&"' "
				Set rs = db.ExecSQLReturnRS(SQLP , null, ConStr)
				If rs.eof Then
				insertvalue	= insertvalue & "  ,'' ,''   " 
				else
				insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '"&rs(0)&"' " 
				End if

			Case 14
				SQLP = " select top 1 teamgbnm from tblteamgbinfo where cd_type = 1 and pteamgb = '"&pteamgb&"' and teamgb = '"&reqArr.Get(i)&"' "
				Set rs = db.ExecSQLReturnRS(SQLP , null, ConStr)
				insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '"&rs(0)&"' " 

			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 

		next




		If itgubun = "T" Then
			insertfield  = insertfield & " ,kskey2,kskey3,kskey4,playerIDX2,playerIDX3,playerIDX4,UserName2,UserName3,UserName4 "
			insertvalue = insertvalue & " ,'"&key2&"','"&key3&"','"&key4&"'   ,'"&pidx2&"','"&pidx3&"','"&pidx4&"'   ,'"&unm2&"','"&unm3&"','"&unm4&"'  "
		End if

		insertfield  = insertfield & " ,levelno "
		insertvalue = insertvalue & " ,'"&levelno&"'  "

		SQL = "SET NOCOUNT ON INSERT INTO tblRecord ( "&insertfield&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson




  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>