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
	entertype = oJSONoutput.Get("ENTERTYPE")  '21.3.11 추가 동호인구분작업
	nowyear =  oJSONoutput.Get("NOWYEAR")  '21.3.11 추가



	Set db = new clsDBHelper 

		'구분, 1코드, 2팀명, 3국가 , 4시도, 5성별, 6그룹, 7등록, 8창단, 9단체장, 10지도자 ,11우편, 12주소 , 13전화 , 14해체일
		updatefield = " kskey,ksportsnoS,UserName,userNameCn,userNameEn,Birthday,Sex,nation,sidoCode,sido,CDA,CDANM,CDB,CDBNM,TeamNm,userClass,Team "
		upfieldarr =  Split(updatefield, ",")  'e_idx 는 맨두에 별도값으로가져오고

		fno = 0
		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				updatefield	= " "&upfieldarr(fno)&" = '"&reqArr.Get(i)&"' "
			Case 5 '생년월일
					If isdate(reqArr.Get(i)) = True then
						fdate = Cdate(reqArr.Get(i))

						if left(fdate,1) = "2" then
							sexkey = Cdbl(reqArr.Get(6))+ 2
						else
							sexkey = reqArr.Get(6)
						end if					
					
						fdate = mid(replace(left(fdate,10) , "-",""),3) & reqArr.Get(6)

					Else
						fdate = reqArr.Get(i)
					End if
					updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&fdate&"', sexkey = '"&sexkey&"' " 

			Case 8
				SQLP = "select top 1 sidonm from tblSidoInfo where sido = '"&reqArr.Get(i)&"' "
				Set rs = db.ExecSQLReturnRS(SQLP , null, ConStr)
				updatefield	= updatefield & "," & upfieldarr(fno) & " =  '" & reqArr.Get(i) & "' , " & upfieldarr(fno+1) & " =  '" & rs(0) & "'  " 
				fno = fno + 1
			Case 9
				Select Case reqArr.Get(i)
				Case "D2" : updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' , "&upfieldarr(fno+1)&" =  '경영'  "
				Case "E2" : updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' , "&upfieldarr(fno+1)&" =  '다이빙/수구'  "
				Case "F2" : updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' , "&upfieldarr(fno+1)&" =  '아티스틱스위밍'  "
				End Select 
				fno = fno + 1
			Case 10
				SQLP = " select top 1 cd_booNM from tblteamgbinfo where cd_type = 2 and cd_boo = '"&reqArr.Get(i)&"' "
				Set rs = db.ExecSQLReturnRS(SQLP , null, ConStr)
				updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' , "&upfieldarr(fno+1)&" =  '"&rs(0)&"'  " 
				fno = fno + 1
			Case oJSONoutput.PARR.length-1
					e_idx = reqArr.Get(i)
			Case Else
				updatefield	= updatefield & ", "&upfieldarr(fno)&" =  '"&reqArr.Get(i)&"' "
			End Select 
			fno = fno + 1
		next

		If nowyear = "" Then
			nowyear = year(date)
		End if


		strSql = "update  tblPlayer Set   " & updatefield & ",entertype='"&entertype&"',nowyear='"&nowyear&"' where playeridx = " & e_idx
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




