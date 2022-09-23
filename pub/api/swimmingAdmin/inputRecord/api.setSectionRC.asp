<%
'#############################################
'구간기록저장
'#############################################
	
	'request
	midx = oJSONoutput.Get("MIDX")
	rc = oJSONoutput.Get("RC")
	lampm = oJSONoutput.Get("AMPM") '예선 결승 두번할수 있으므로 필요.


	
	Set db = new clsDBHelper 


	rcarr = Split(rc,",") '배열갯수로 판단하자.
	racemeter = (CDbl(ubound(rcarr)) + 1) * 50 'sectionno
	ampm = Ucase(lampm)


			Function getRC(endrc, dbrc)
				Dim rc, p_min,p_sec,p_msec,c_min,c_sec,c_msec
				Dim p_total,c_total,d_total
				Dim d_min,d_sec,d_msec

				If Len(endrc) <> 6 Or Len(dbrc) <> 6 Then
					getRC = "000000"
				else

					p_min = Left(dbrc, 2)
					p_sec = mid(dbrc, 3, 2)
					p_msec = right(dbrc, 2)
					c_min = Left(endrc, 2)
					c_sec = mid(endrc, 3, 2)
					c_msec = right(endrc, 2)

					 c_total = (CDbl(c_min) * 60 * 1000 ) + (CDbl(c_sec) * 1000) + CDbl(c_msec * 10)
					 p_total = (CDbl(p_min) * 60 * 1000 ) + (CDbl(p_sec) * 1000) + CDbl(p_msec * 10) 
					 d_total =  CDbl(c_total) - CDbl(p_total)

					 d_min = Fix(Cdbl(d_total) / ( 60 * 1000))
					 d_sec =  Fix((CDbl(d_total) / 1000 ))
					 d_msec =   Fix((CDbl(d_total) Mod 1000) / 10)

					getRC =  addZero(d_min) & addZero(d_sec) & addZero(d_msec)

				End if
			End Function


			'삭제하고 다시넣자...업데이트 귀찮음...
			SQL = "delete from sd_gameMember_sectionRecord where gamememberidx = '"&midx&"' and AMPM = '"&ampm&"' "
			Call db.execSQLRs(SQL , null, ConStr)

			sctionnostr = 50
			n = 1
			For i = 0 To ubound(rcarr)
				If i = 0 then
					insertfld = "section" & (sctionnostr * n) & ",r" & (sctionnostr * n)
					insertval = "'" & rcarr(i) & "','" & rcarr(i) & "'"
				Else
					insertfld = insertfld &  ",section" & (sctionnostr * n) & ",r" & (sctionnostr  * n)
					insertval = insertval & ",'" & getRC(rcarr(i), prevalue)  & "','" & rcarr(i) & "'"
				End If

			prevalue = rcarr(i)
			n = n + 1
			next

	
			SQL = " Insert into sd_gameMember_sectionRecord ( gamememberidx,sectionno, AMPM, "&insertfld&" ) values ("&midx&",'"&racemeter&"','"&ampm&"', "&insertval&")"
			Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>