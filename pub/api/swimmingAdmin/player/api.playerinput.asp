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
	entertype = oJSONoutput.Get("ENTERTYPE")  '21.3.11 추가 동호인구분작업
	nowyear =  oJSONoutput.Get("NOWYEAR")  '21.3.11 추가

	Set db = new clsDBHelper 

		'동일 선수 체크 (알아서 검색한담에 해라 ㅡㅡ) '선수번호 중복체크

		'kskey 중복값체크


		insertfield = " kskey,ksportsnoS,UserName,userNameCn,userNameEn,Birthday,Sex,nation,sidoCode,sido,CDA,CDANM,CDB,CDBNM,TeamNm,userClass,Team "

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case 5 '생년월일
						'2019/12/06
					If isdate(reqArr.Get(i)) = True then
						fdate = Cdate(reqArr.Get(i))
						if left(fdate,1) = "2" then
								sexkey = Cdbl(reqArr.Get(6))+ 2
						else
							sexkey = reqArr.Get(6)
						end if

						fdate = mid(replace(left(fdate,10) , "-",""),3) & reqArr.Get(6)
					Else
						fdate = ""
					End if
					insertvalue	= insertvalue & ",'"&fdate&"' " 
			Case 8
				SQLP = "select top 1 sidonm from tblSidoInfo where sido = '"&reqArr.Get(i)&"' "
				Set rs = db.ExecSQLReturnRS(SQLP , null, ConStr)
				insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '"&rs(0)&"' " 
			Case 9
				Select Case reqArr.Get(i)
				Case "D2" :insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '경영' " 
				Case "E2" :insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '다이빙/수구' " 
				Case "F2" :insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '아티스틱스위밍' " 
				End Select 
			Case 10
				SQLP = " select top 1 cd_booNM from tblteamgbinfo where cd_type = 2 and cd_boo = '"&reqArr.Get(i)&"' "
				Set rs = db.ExecSQLReturnRS(SQLP , null, ConStr)
				insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' , '"&rs(0)&"' " 
			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "SET NOCOUNT ON INSERT INTO tblPlayer ( "&insertfield&", entertype,nowyear ,sexkey) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&"    , '"&entertype&"', '"&nowyear&"','"&sexkey&"' ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>