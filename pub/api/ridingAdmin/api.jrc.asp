<%
'#############################################
'입력값
'#############################################

	'request
	If hasown(oJSONoutput, "IDNO") = "ok" Then 'input no
		idno= oJSONoutput.IDNO
	End If

	If hasown(oJSONoutput, "RIDX") = "ok" Then 
		tidxgbidx= oJSONoutput.RIDX
	End If

	If hasown(oJSONoutput, "VAL") = "ok" Then 
		inval= oJSONoutput.VAL
	End If

	If hasown(oJSONoutput, "ROUNDNO") = "ok" Then '라운드 번호
		roundno= oJSONoutput.ROUNDNO
	End If

	If inval = "" Then
  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.end
	End if

	Set db = new clsDBHelper 

	If CDbl(idno) = 99 Then '경로설계자라면 blur 할때 99로 보내자.
		'중복확인해서  tblplayer 에 userType 'M' 으로 해서 이름 중복검색해서 넣자.
		If CDbl(Len(inval)) > 1 then
		SQL = "IF not EXISTS ( Select username from tblPlayer  WHERE  userName ='"&inval&"' and userType='M')  INSERT INTO tblPlayer (userName, userType) values ( '"&inval&"' , 'M')"
		Call db.execSQLRs(SQL , null, ConStr)
		End If
		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson		
		Response.end
	End if




	'필드명을 배열로 넣어두고...
	field = " tidxgbidx,chk1,chk2,deduction1,deduction2,deduction3,deduction4,d4second,chk3,d5second,deduction5, hurdle1,hurdle2,hurdle3,hurdle4,hurdle5,hurdle6,hurdle7,hurdle8,hurdle9,hurdle10,hurdle11,hurdle12,hurdle13,hurdle14,hurdle15,hurdle16,hurdle17,hurdle18,hurdle19,hurdle20, totallength1,mspeed1,time1,limittime1,installname,designname,totallength2,mspeed2,time2,limittime2,hurdle2pahasegubun,useOK"
	fieldnmarr = Split(field,",")


	If CDbl(idno) > 100 Then
		SQL = "update tblHurdleInfo Set hurdle2pahasegubun = '"& inval &"' where tidxgbidx =   '" & tidxgbidx & "' and roundno = " & roundno
		Call db.execSQLRs(SQL , null, ConStr)
	else

		'1,2,8 '체크박스
		SQL = "update tblHurdleInfo Set "&fieldnmarr(idno)&" = '"&inval&"' where tidxgbidx =   '" & tidxgbidx & "' and roundno = " & roundno
		Call db.execSQLRs(SQL , null, ConStr)


		If CDbl(idno) = 31 Or CDbl(idno) = 32 Or CDbl(idno) = 37 Or CDbl(idno) = 38 then

			SQL = "select  totallength1,mspeed1, totallength2,mspeed2 from tblHurdleInfo where  tidxgbidx = '" & tidxgbidx & "' and roundno = " & roundno  '자동계산되는 값을 산출
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				If CDbl(idno) = 31 Or CDbl(idno) = 32 then
					a1 = isNullDefault(rs("totallength1"),"")
					a2 = isNullDefault(rs("mspeed1"),"")

					If a1 <> "" And a2 <> "" then
						'a3 = FormatNumber(a1 / a2 * 60 , 0)      '소정시간(소수점 첫쨰자리 올림) = 전장 / 분속 *60 
						a3 = Ceil_a(a1 / a2 * 60)      '소정시간(소수점 첫쨰자리 올림) = 전장 / 분속 *60 
						a4 = a3 * 2
						SQL = "update tblHurdleInfo Set time1 = '"&a3&"',limittime1 = '"&a4&"' where tidxgbidx =   '" & tidxgbidx & "' and roundno = " & roundno
						Call db.execSQLRs(SQL , null, ConStr)		
					  	Call oJSONoutput.Set("jm33", a3 )
					  	Call oJSONoutput.Set("jm34", a4 )
					End if
				Else
					b1 = isNullDefault(rs("totallength2"),"")
					b2 = isNullDefault(rs("mspeed2"),"")

					If b1 <> "" And b2 <> "" then
						'b3 = FormatNumber(b1 / b2 * 60,0)      '소정시간(소수점 첫쨰자리 올림) = 전장 / 분속 *60 
						b3 = Ceil_a(b1 / b2 * 60)      '소정시간(소수점 첫쨰자리 올림) = 전장 / 분속 *60 
						b4 = b3 * 2
						SQL = "update tblHurdleInfo Set time2 = '"&b3&"',limittime2 = '"&b4&"' where tidxgbidx =   '" & tidxgbidx & "' and roundno = " & roundno
						Call db.execSQLRs(SQL , null, ConStr)
					  	Call oJSONoutput.Set("jm39", b3 )
					  	Call oJSONoutput.Set("jm40", b4 )
					End if
				End If
			End if
			
		End if
	End if

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
