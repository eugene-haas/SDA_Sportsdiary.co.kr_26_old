<%
'#############################################
'
'#############################################
	
	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx = oJSONoutput.MIDX
	End If
	If hasown(oJSONoutput, "OKNO") = "ok" Then 
		okno = oJSONoutput.OKNO ' 1인정 2 승인
	End if	
	If hasown(oJSONoutput, "ONOFF") = "ok" Then 
		onoff = oJSONoutput.ONOFF
	End if	

	If hasown(oJSONoutput, "RNDSTR") = "ok" Then  'sinround = "결승"
		rndstr = oJSONoutput.RNDSTR
	End if	
	If hasown(oJSONoutput, "SINSTR") = "ok" Then  'singistr = "대회신기록"
		sinstr = oJSONoutput.SINSTR
	End if	
	If hasown(oJSONoutput, "FLDNO") = "ok" Then  'savefld = "2"  tryout 필드인지 경승필드인지 
		fldno = oJSONoutput.FLDNO
	End if	


	If hasown(oJSONoutput, "RC") = "ok" Then  '기록
		rc = oJSONoutput.Get("RC")
	End if	
	If hasown(oJSONoutput, "PIDX") = "ok" Then  '선수번호
		pidx = oJSONoutput.Get("PIDX")
	End if	




	
	Set db = new clsDBHelper 

	If okno = "2" Then '승인여부에서 적용된다.
		'시나리오
		'1. 한국신기록이라면 내용을 찾아서(tblrecord)에서  titlecode와 rctype을 변경해서 insert한다.
		'2. 대회기록이라면  tblrecord에서 에선인지 본선인지 여하튼 찾아서 rctype을 update 한다.
		'3. off 했을때 역순으로 처리해야하는데
		'변경하고 tblrecord > gameMemberIDX(midx) 를 저장해두어야할수도.. OFF에 사용

			fld = " a.gametitleidx ,b.rgameLevelIDX, a.cdbnm,rcOK1ID,rcOK2ID " 
			SQL = "select "&fld&"   from sd_gamemember as a inner join tblRgameLevel as b ON a.gametitleidx = b.gametitleidx  and a.gbidx = b.gbidx where a.gameMemberidx = " & midx
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		

			tidx = rs(0)
			lidx = rs(1)
			cdbnm = rs(2)

			'대회구분 구하기   >> tblCode 검색
			If InStr(cdbnm,"유년")  Then
				gamegubun = "R01"
			End If
			If InStr(cdbnm,"초등")  Then			
				gamegubun = "R02"
			End If
			If InStr(cdbnm,"중등") Or InStr(cdbnm,"중학")  Then
				gamegubun = "R03"
			End If
			If InStr(cdbnm,"고등")  Then			
				gamegubun = "R04"
			End If
			If InStr(cdbnm,"대학")  Then			
				gamegubun = "R05"
			End If
			If InStr(cdbnm,"일반")  Then			
				gamegubun = "R06"
			End if
			'한국기록
			'일반-참가기록		





		If InStr(sinstr,",") > 0 Then
			If InStr(sinstr,"한국신기록") > 0 Then
				sinstr = "한국신기록"
			ElseIf  InStr(sinstr,"대회신") > 0 Then
				sinstr = "대회신기록"
			End if
		End if

		'계영은 ? 어떻게 되는거지 아 복잡..

		Select Case sinstr 'R07한국신기록
		Case "한국신기록"  '1. 한국신기록이라면 내용을 찾아서(tblrecord)에서  titlecode와 rctype을 변경해서 insert한다. 
			If onoff = "on" Then 'on insert (기존자료는 대회신기록으로 변경)

				SQL = "select top 1 CDBNM,CDCNM from tblRecord where gametitleidx = '"&tidx&"' and rgameLevelIDX = '"&lidx&"' and RCNO = '"&fldno&"' and gameResult = '"&rc&"' and playeridx = '"&pidx&"' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		
				cdbnm = rs(0)
				cdcnm = rs(1)

				'이전한국신기록은 delyn = 'Y'
				SQL = "update tblRecord set delyn = 'Y' where CDBNM = '"&cdbnm&"' and CDCNM = '"&CDCNM&"' and rctype = 'R07' "
				Call db.execSQLRs(SQL , null, ConStr)


				fld = " gametitleidx,'201904395',titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,ksportsno,playerIDX,UserName,Birthday,Sex,nation,sidoCode,sido,gameDate,EnterType,Team,TeamNm,userClass,'R07',gamearea,gameResult,preGameResult,gameOrder,rane,DelYN,gubun,kskey2,kskey3,kskey4,playerIDX2,UserName2,playerIDX3,UserName3,playerIDX4,UserName4,levelno,Roundstr,firstRC,RCNO,RgameLevelIDX,'"&midx&"' "

				insertfld = "gametitleidx,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,ksportsno,playerIDX,UserName,Birthday,Sex,nation,sidoCode,sido,gameDate,EnterType,Team,TeamNm,userClass,rctype,gamearea,gameResult,preGameResult,gameOrder,rane,DelYN,gubun,kskey2,kskey3,kskey4,playerIDX2,UserName2,playerIDX3,UserName3,playerIDX4,UserName4,levelno,Roundstr,firstRC,RCNO,RgameLevelIDX,midx "

				'한국신기록으로 복사하고
				selectSQL = "select top 1 "&fld&" from tblRecord where gametitleidx = '"&tidx&"' and rgameLevelIDX = '"&lidx&"' and RCNO = '"&fldno&"' and gameResult = '"&rc&"' and playeridx = '"&pidx&"' "
				SQL = "insert Into tblRecord ("&insertfld&")  ("&SelectSQL&")"
				Call db.execSQLRs(SQL , null, ConStr)

				'위에 꺼는 안바뀌게 줘야... 대상이 한개만...되어야 하지 않나. (대회기록으로 만들어버리고)
				SQL  = "update tblRecord Set  rcType = '"&gamegubun&"' ,midx = '"&midx&"'  where gametitleidx = '"&tidx&"' and rgameLevelIDX = '"&lidx&"' and RCNO = '"&fldno&"' and gameResult = '"&rc&"' and playeridx = '"&pidx&"'  and rctype <> 'R07' "
				Call db.execSQLRs(SQL , null, ConStr)

			Else 'off 인서트한 자료삭제

				SQL = "delete from tblRecord where titlecode = '201904395' and  midx = '"&midx&"' " '한국신기록 정보삭제
				Call db.execSQLRs(SQL , null, ConStr)

				SQL  = "update tblRecord Set  rcType = 'R08'  where midx = '"&midx&"' "
				Call db.execSQLRs(SQL , null, ConStr)

			End if

		Case "대회신기록" '2. 대회기록이라면  tblrecord에서 에선인지 본선인지 여하튼 찾아서 rctype을 update 한다.
			If onoff = "on" Then 'on 대회신기록으로 변경

				SQL  = "update tblRecord Set  rcType = '"&gamegubun&"' ,midx = '"&midx&"'  where gametitleidx = '"&tidx&"' and rgameLevelIDX = '"&lidx&"' and RCNO = '"&fldno&"' "
				Call db.execSQLRs(SQL , null, ConStr)

			Else 'R08 일반으로 변경
				SQL  = "update tblRecord Set  rcType = 'R08'  where midx = '"&midx&"' "
				Call db.execSQLRs(SQL , null, ConStr)
			End If
			
		Case "한국타이"
				If onoff = "on" Then
					SQL  = "update tblRecord Set  kortie = 'Y'  ,midx = '"&midx&"'  where gametitleidx = '"&tidx&"' and rgameLevelIDX = '"&lidx&"'  and rgameLevelIDX = '"&lidx&"' and RCNO = '"&fldno&"'  "
					Call db.execSQLRs(SQL , null, ConStr)
				else
					SQL  = "update tblRecord Set  kortie = 'N'  where midx = '"&midx&"' "
					Call db.execSQLRs(SQL , null, ConStr)
				End if
		Case "대회타이"
				If onoff = "on" Then
					SQL  = "update tblRecord Set  gametie = 'Y'  ,midx = '"&midx&"'  where gametitleidx = '"&tidx&"' and rgameLevelIDX = '"&lidx&"'  and rgameLevelIDX = '"&lidx&"' and RCNO = '"&fldno&"'  "
					Call db.execSQLRs(SQL , null, ConStr)
				Else
					SQL  = "update tblRecord Set  gametie = 'N'  where midx = '"&midx&"' "
					Call db.execSQLRs(SQL , null, ConStr)
				End if
		End Select 
	End if

'Response.write sql


	If onoff = "on" Then
		rcok = "Y"
	Else
		rcok = "N"
	End If
	
	Select case okno 
	Case "1"
		okfld = "rcOK1ID"
	Case "2"
		okfld = "rcOK2ID"
	End Select

	'관리자 아이디로 저장 승인 취소상태를..
	SQL = "update sd_gameMember set "&okfld&" = '"&rcok&"_"&Cookies_aID&"' where gamememberidx = '"&midx&"' "
	Call db.execSQLRs(SQL , null, ConStr)	
	

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>