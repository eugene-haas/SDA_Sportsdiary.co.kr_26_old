<%
'#######################
'종목별 선수  말 제한 사항 설정
'#######################
	'request 처리##############
	
	If hasown(oJSONoutput, "TARGETLEVEL") = "ok" Then
		TARGETLEVEL = oJSONoutput.TARGETLEVEL
		targetstr = Split(TARGETLEVEL, "_")
		tidx = targetstr(0)
		gbidx = targetstr(1)
	End If
	If hasown(oJSONoutput, "PTYPE") = "ok" Then
		ptype = oJSONoutput.PTYPE
	End If
	If hasown(oJSONoutput, "GTYPE") = "ok" Then
		gtype = oJSONoutput.GTYPE
	End If
	If hasown(oJSONoutput, "IDX") = "ok" Then
		seq = oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "CHK") = "ok" Then
		chk = oJSONoutput.CHK 'YN 선택 해제
	End If



	'#####################
	Function arrfinddel(arrstr , delstr)
		Dim n, i ,newstr, arr
		n = 0
		arr = Split(arrstr,",")
		For i = 0 To ubound(arr)
			If CStr(arr(i)) <> CStr(delstr) Then
				If n = 0 then
					newstr = arr(i)
					n = n + 1
				Else
				newstr = newstr & "," & arr(i)
					n = n + 1
				End if
			End if
		Next
		arrfinddel = newstr
	End Function

	Sub updateidx(db,fieldnm,seq,tidx,gbidx)
		Dim SQL
		SQL = "update tblRGameLevel Set "&fieldnm&" = case when  "&fieldnm&" ='' then  '"&seq&"' else   "&fieldnm&" + ',"&seq&"'   end  where gameTitleIDX = " & tidx & " and gbidx = " & gbidx
		Call db.execSQLRs(SQL , null, ConStr)	
	End Sub
	
	Sub updateidxdel(db,fieldnm,seq,tidx,gbidx)
		Dim SQL,updateseqs
		SQL = "Select "&fieldnm&" from tblRGameLevel where gameTitleIDX = " & tidx & " and gbidx = " & gbidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		seqs = isNullDefault(rs(0),"")
		If seqs = "" Then
			updateseqs = ""
		Else
			updateseqs = arrfinddel(seqs , seq)
		End if
		
		SQL = "update tblRGameLevel Set "&fieldnm&" = '"&updateseqs&"'  where gameTitleIDX = " & tidx & " and gbidx = " & gbidx			
		Call db.execSQLRs(SQL , null, ConStr)
	End sub
	'#####################	

	Set db = new clsDBHelper

	If chk = "Y" Then '선택

		If gtype = "1" Then '개인
			If ptype  = "1" Then '선수 playerlimitidxs
				Call updateidx(db,"playerlimitidxs",seq,tidx,gbidx)
			Else '말 horselimitidxs
				Call updateidx(db,"horselimitidxs",seq,tidx,gbidx)
			End if

		Else '단체
			If ptype  = "1" Then '선수 playerlimitidxs2
				Call updateidx(db,"playerlimitidxs2",seq,tidx,gbidx)
			Else '말 horselimitidxs2
				Call updateidx(db,"horselimitidxs2",seq,tidx,gbidx)			
			End if
		End If
		
	Else'해제#####################################
		If gtype = "1" Then '개인
			If ptype  = "1" Then '선수
				Call updateidxdel(db,"playerlimitidxs",seq,tidx,gbidx)
			Else '말
				Call updateidxdel(db,"horselimitidxs",seq,tidx,gbidx)			
			End if
		Else '단체
			If ptype  = "1" Then '선수
				Call updateidxdel(db,"playerlimitidxs2",seq,tidx,gbidx)
			Else '말
				Call updateidxdel(db,"horselimitidxs2",seq,tidx,gbidx)			
			End if
		End if
	End if

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>