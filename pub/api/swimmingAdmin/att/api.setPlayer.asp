<%
'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End if	
	If hasown(oJSONoutput, "TEAM") = "ok" then
		team = oJSONoutput.TEAM
	End if
'request

	If hasown(oJSONoutput, "PIDXARR") = "ok" then
		Set pArr = oJSONoutput.PIDXARR 
		ReDim chkarr(oJSONoutput.PIDXARR.length-1)
		For i = 0 To oJSONoutput.PIDXARR.length-1
			chkarr(i) = pArr.Get(i)
		next
	End If

	leaderidx = oJSONoutput.Get("LEADERIDX") '리더인덱스
'		loopcnt = oJSONoutput.PIDXARR.length-1
		'Response.write chkarr(0)
		'Response.end


	Set db = new clsDBHelper

		'새로 추가되는것과 삭제될 pidx 값을 구한다.
		SQL = "select playeridx,leaderidx from tblGameRequest_imsi where tidx = '"&tidx&"' and team = '"&team&"'  and leaderidx = '"&leaderidx&"' " 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			arrR = rs.GetRows() '설정되어있는 값
		End if

		'기존맴버확인
		Function isMember(pidx ,cArr)
			Dim i, ism
			ism = false

			For i = 0 To UBound(cArr)
				If Cstr(pidx) = Cstr(cArr(i)) Then '등록됨
					ism = true
				End If
			Next	
			

			isMember = ism
		End Function

		'삭제할맴버
		Function delMember(pidx , arrR)
			Dim i, ism
			ism = false
			
			If IsArray(arrR) Then 
				For i = LBound(arrR, 2) To UBound(arrR, 2)
					If CStr(pidx) = CStr(arrR(0, i)) Then 
						ism = true
					End if
				Next
			End If
			delMember = ism
		End Function
	


		loopcnt = oJSONoutput.PIDXARR.length-1
		insertpidxs = ""
		delpidxs = ""
		If IsArray(arrR) Then 
			For ari = LBound(arrR, 2) To UBound(arrR, 2)
				p_pidx = arrR(0, ari) '셋팅된 pidx

				If isMember(p_pidx , chkarr) = false Then 
					'삭제할맴법
					delpidxs = delpidxs & "," & p_pidx
				End if
			Next
			delpidxs = Mid(delpidxs,2)
			If delpidxs <> "" then			
				SQL = "delete from tblGameRequest_imsi_r where seq in (select seq from tblGameRequest_imsi where  tidx = "&tidx&" and leaderidx = '"&leaderidx&"' and  playeridx in ("&delpidxs&") ) "
				Call db.execSQLRs(SQL , null, ConStr)
				SQL = "delete from tblGameRequest_imsi where  tidx = "&tidx&" and  leaderidx = '"&leaderidx&"' and playeridx in ("&delpidxs&")"
				Call db.execSQLRs(SQL , null, ConStr)
			End if
		End if

		For i = 0 To oJSONoutput.PIDXARR.length-1
			i_pidx = pArr.Get(i) '요청된 pidx
			If delMember(i_pidx , arrR) = false Then 
				'추가할맴법
				insertpidxs = insertpidxs & "," & i_pidx
			End if
		Next
		insertpidxs = Mid(insertpidxs,2)
		If insertpidxs <> "" then
		SQL = " insert Into tblGameRequest_imsi (tidx,kskey,playeridx,username,sex,team,teamnm,userclass,birthday,cdb,cdbnm,userphone,sido,sidonm, leaderidx ) "
		SQL = SQL & " Select "&tidx&",kskey,playeridx,username,sex,team,teamnm,userclass,birthday,cdb,cdbnm,userphone,sidocode,sido,'"&leaderidx&"' from tblPlayer  where playeridx in ("  & insertpidxs &  ") "
		Call db.execSQLRs(SQL , null, ConStr)
		End If

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>

