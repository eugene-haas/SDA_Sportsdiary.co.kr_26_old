<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then
		midx = oJSONoutput.MIDX
	End If
	If hasown(oJSONoutput, "CNGVAL") = "ok" Then
		cngval = oJSONoutput.CNGVAL
		If isnumeric(cngval) = False Then
			Call oJSONoutput.Set("result", 5 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	End If
	If hasown(oJSONoutput, "CNGTYPE") = "ok" Then
		cngtype = oJSONoutput.CNGTYPE
	End if	
	If hasown(oJSONoutput, "AMPM") = "ok" Then
		ampm = oJSONoutput.Get("AMPM")
	End if	

	Set db = new clsDBHelper

	  'startType 시작이 예선인지 본선인지 (1, 3)
	  fld = " gameMemberIDX,tryoutgroupno,tryoutsortNo, 	gametitleidx,gbidx   ,startType,roundNo,sortno " 
	  SQL = "select "&fld&" from SD_gameMember where gameMemberIDX  = '"&midx&"' "
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	  If Not rs.EOF Then
			arrR = rs.GetRows()

	  
		SQLR = "select top 1 RGameLevelidx,gubunam,gubunpm from tblRGameLevel  where delyn = 'N' and  gametitleidx = "&arrR(3,0)&" and Gbidx =  '"&arrR(4,0)&"' "
		Set rsr = db.ExecSQLReturnRS(SQLR , null, ConStr)
		lidx = rsr(0)
		gubunam = rsr(1) '오전 경기 1 예선 3 결승
		gubunpm = rsr(2)
		
		If ampm = "am" Then
		gubun  = gubunam
		Else
		gubun  = gubunpm
		End if

		Call oJSONoutput.Set("LIDX", lidx )	  
	  
	  End If


	'중요 startType 1, 3 으로 시작값을 알면 되고 이걸로 시작이 예선 인지 끝인지 알면 된다.

	If IsArray(arrR) Then 
		For ari = LBound(arrR, 2) To UBound(arrR, 2) - namergi '나누어 떨어지는 명수 가지만 우선 넣자.
			midx =  arrR(0,ari)  'midx
			gno = arrR(1,ari) '조번호(넣을곳)
			raneno = arrR(2,ari) '레인번호(넣을곳)
			
			tidx = arrR(3,ari)
			gbidx = arrR(4, ari)

			startType = arrR(5, ari) 'startType 시작이 예선인지 본선인지 (1, 3)
			gno2 = arrR(6, ari)
			raneno2 = arrR(7, ari)


				'starttype = 1 tryoutgroupno:예선 roundno:결승 starttype = 3 tryoutgroupno:결승

				'결승 starttype = 1 일때 경승으로 사용 (roundno) 그러므로 무조건 여따 넣으면 된다.

				If startType = "1"  Then '예선또
					
					'If 예선이라면 then
					If gubun = "1" then
						gnostr = "tryoutgroupno"
						snostr = "tryoutsortNo"
					Else '예선거쳐온 본선경기라면
						gnostr = "roundNo"
						snostr = "sortno"
						raneno = raneno2
					End if
				
				Else '3
					gnostr = "tryoutgroupno"
					snostr = "tryoutsortNo"
				End if


				strwhere = " delyn = 'N' and gametitleidx = "&tidx&" and gbidx = "&gbidx&" and "&gnostr&" = '"&gno&"' "
				SQL = "select max("&snostr&") from SD_gameMember where " & strwhere
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				maxno = rs(0)

				Select Case cngtype
				Case "1" '위로
					If CStr(raneno) = "1" Then
						SQL = " update  SD_gameMember set "&snostr&" = "&snostr&" - 1  where gameMemberidx in  (select gamememberidx from SD_gameMember where " & strwhere & " and gameMemberidx <> "&midx&")"
						SQL = SQL &  " update  SD_gameMember set "&snostr&" = '"&maxno&"'  where gameMemberidx = " & midx 
						Call db.execSQLRs(SQL , null, ConStr)
					Else
						SQL = " update  SD_gameMember set "&snostr&" = "&snostr&" + 1  where gameMemberidx = (select top 1 gamememberidx from SD_gameMember where " & strwhere & " and "&snostr&" = "&CDbl(raneno) - 1&" )"
						SQL = SQL &  " update  SD_gameMember set "&snostr&" = "&snostr&" - 1  where gameMemberidx = " & midx 
						Call db.execSQLRs(SQL , null, ConStr)
					End if

				Case "2" '아래로
					If CStr(raneno) = CStr(maxno) Then
						SQL = " update  SD_gameMember set "&snostr&" = "&snostr&" + 1  where gameMemberidx in  (select gamememberidx from SD_gameMember where " & strwhere & " and gameMemberidx <> "&midx&" )"
						SQL = SQL &  " update  SD_gameMember set "&snostr&" = 1  where gameMemberidx = " & midx 
						Call db.execSQLRs(SQL , null, ConStr)
					Else
						SQL = " update  SD_gameMember set "&snostr&" = "&snostr&" - 1  where gameMemberidx = (select top 1 gamememberidx from SD_gameMember where " & strwhere & " and "&snostr&" = "&CDbl(raneno) + 1&" )"
						SQL = SQL &  " update  SD_gameMember set "&snostr&" = "&snostr&" + 1  where gameMemberidx = " & midx 
						Call db.execSQLRs(SQL , null, ConStr)
					End if


				Case "3" '범위안에서

					If CDbl(cngval) > CDbl(maxno) then
						Call oJSONoutput.Set("result", 5 )
						strjson = JSON.stringify(oJSONoutput)
						Response.Write strjson
						Response.end
					End if

					SQL = " update  SD_gameMember set "&snostr&" = "&raneno&"  where " & strwhere & " and "&snostr&" = "&cngval&" "
					SQL = SQL & " update  SD_gameMember set "&snostr&" = "&cngval&"  where gameMemberidx = " & midx 
					Call db.execSQLRs(SQL , null, ConStr)
				End Select 


		Next
	End if





	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>