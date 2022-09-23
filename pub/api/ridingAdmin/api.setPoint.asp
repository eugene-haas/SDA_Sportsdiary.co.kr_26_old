<%
'#############################################
'
'#############################################
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx= oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" then
		gbidx= oJSONoutput.GBIDX
	End if	
	If hasown(oJSONoutput, "TEAMGB") = "ok" then
		teamgb= oJSONoutput.TEAMGB
	End if	
	If hasown(oJSONoutput, "ORDERTYPE") = "ok" then
		ordertype= oJSONoutput.ORDERTYPE
	End if	
	If hasown(oJSONoutput, "KGAME") = "ok" then
		kgame= oJSONoutput.KGAME
	End if	


	If hasown(oJSONoutput, "ING") = "ok" then
		ing= oJSONoutput.ING
	End if	
	If hasown(oJSONoutput, "PRINT") = "ok" then
		printmsg= oJSONoutput.PRINT
	End if	
	

	'#############################################
	Set db = new clsDBHelper

	  '설정값 가져오기
	  strFieldName = "  setpointarr "
	  SQL = "Select setpointarr,ridingclasshelp from tblTeamGbInfo where DelYN = 'N' and TeamGbIDX = " & gbidx 
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If Not rs.EOF Then
		arrPub = rs.GetRows()
		setpointarr = arrPub(0, 0)
		ptvaluearr = Split(setpointarr, "`")
		r_classhelp = arrPub(1,0)
	  End If

	If teamgb <> "20103" then
		If orderType = "MM" Then '마장마술 '##################################################

			'지점수
			SQL = "Select isnull(judgecnt,0) from tblRGameLevel where GameTitleIDX = '"&tidx&"' and gbidx = "&gbidx&" and DelYN = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If rs.eof Then
				jcnt = 0
			Else
				jcnt = rs(0)
			End if

			'마장마술 배열순서 비교할 득점
			Dim ptarr(45)
			getpt = ubound(ptarr)
			For a = 0 To ubound(ptarr)
				ptarr(a) = (getpt) 
				getpt = getpt - 1
			next		

			findmember =  " and a.gameMemberIDX > " & ing
			tblnm = " SD_tennisMember as a INNER JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
			fldnm = "a.gameMemberIDX,a.playeridx,a.username, b.playeridx,b.username "
			fldnm = fldnm & "  ,score_total  ,	total_order , a.pt "

			SQL = "Select top 1 " & fldnm & " from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&gbidx&"' "&findmember&" and round = 1 and a.gubun < 100 order by gameMemberIDX "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If rs.EOF Then
				oJSONoutput.ING = -1
			else
				arrR = rs.GetRows()
				oJSONoutput.ING = arrR(0, 0)

				'순위가 100보다 작은지 이라면 
				'	비교할값  = chkpt / 10 
				'	상세비교값  = chkpt Mod 10 이것이 (5보다 크면 위에껄로...)
				'아니라면 
				'	그냥 0 으로 

				chkpt = arrR(5, 0) / jcnt
				'chkpt = 456.6
				totalorder = arrR(6, 0)

				If Cdbl(totalorder) >= 100 Then
					
					pidx = arrR(1, 0)
					hidx = arrR(3, 0)
					prept = arrR(7,0) '기존 반영된 포인트

					chkgetvalue = fix(chkpt / 10)
					upchkvalue = round(chkpt Mod 10)

					pt = 0
					For i = 0 To ubound(ptarr) - 1
						If (i = 0 And chkgetvalue > ptarr(i)) Or (chkgetvalue = ptarr(i)) Then
							pt = ptvaluearr(i)
							If upchkvalue >=5 And i > 0  Then
								pt = ptvaluearr(i - 1)


								SQL = "Update SD_tennisMember Set pt = '"&pt&"'  where gamememberidx =  '"&oJSONoutput.ING&"'  "

								'증가값은 지금값 - 이전값 예)5 - 0  = 5 ,5 - 10 =  -5
								updatevalue = CDbl(pt) - CDbl(prept)
								'양수만 입력되도록 설정
								SQL =  SQL & " Update tblPlayer Set pttotal = case when (pttotal + "&updatevalue&" > 0 ) then pttotal + "&updatevalue&" else 0 end,yearpt = case when (yearpt + "&updatevalue&" > 0 ) then yearpt + "&updatevalue&" else 0 end  where playerIDX in ("&pidx&","&hidx&")"
								Call db.execSQLRs(SQL , null, ConStr)
							
							End if
							Exit for
						End if
					Next

				Else
					pt = 0
				End If

				oJSONoutput.PRINT = arrR(2, 0) & " , " & arrR(4,0) & " 각 포인트 :" & pt & " 반영완료<br>"

			End If
			rs.close


		Else '장애물 '##################################################################
			If kgame = "Y" then

				Select Case r_classhelp
				Case CONST_TYPEA1 , CONST_TYPEA2,CONST_TYPEA_1 'type A   재경기가 있는 장애물
					roundstr = " round = 3 "
				Case CONST_TYPEB 'type B
					roundstr = " round = 1 "
				Case CONST_TYPEC 'type C
					roundstr = " round = 1 "
				End select

				findmember =  " and a.gameMemberIDX > " & ing
				tblnm = " SD_tennisMember as a INNER JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
				fldnm = "a.gameMemberIDX,a.playeridx,a.username, b.playeridx,b.username "
				fldnm = fldnm & "  ,score_total  ,	total_order , a.pt "

				SQL = "Select top 1 " & fldnm & " from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&gbidx&"' "&findmember&" and "&roundstr&" and a.gubun < 100 and total_order < 11 order by gameMemberIDX "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If rs.EOF Then
					oJSONoutput.ING = -1
				else
					arrR = rs.GetRows()
					oJSONoutput.ING = arrR(0, 0)
					totalorder = arrR(6, 0)

					pidx = arrR(1, 0)
					hidx = arrR(3, 0)
					prept = arrR(7,0) '기존 반영된 포인트

					pt = 0
					For i = 0 To 9
						If CDbl(i) = CDbl(totalorder) Then
							pt = ptvaluearr(i)

							SQL = "Update SD_tennisMember Set pt = '"&pt&"'  where gamememberidx =  '"&oJSONoutput.ING&"'  "
							'증가값은 지금값 - 이전값 예)5 - 0  = 5 ,5 - 10 =  -5
							updatevalue = CDbl(pt) - CDbl(prept)
							'양수만 입력되도록 설정
							SQL =  SQL & " Update tblPlayer Set pttotal = case when (pttotal + "&updatevalue&" > 0 ) then pttotal + "&updatevalue&" else 0 end,yearpt = case when (yearpt + "&updatevalue&" > 0 ) then yearpt + "&updatevalue&" else 0 end  where playerIDX in ("&pidx&","&hidx&")"
							Call db.execSQLRs(SQL , null, ConStr)
							Exit for
						End if
					Next
					oJSONoutput.PRINT = arrR(2, 0) & " , " & arrR(4,0) & " 각 포인트 :" & pt & " 반영완료<br>"	
				End if

			else

				findmember =  " and a.gameMemberIDX > " & ing
				tblnm = " SD_tennisMember as a INNER JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
				fldnm = "a.gameMemberIDX,a.playeridx,a.username, b.playeridx,b.username "
				fldnm = fldnm & "  ,score_total  ,	total_order , a.pt "

				SQL = "Select top 1 " & fldnm & " from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&gbidx&"' "&findmember&" and round = 1 and a.gubun < 100 order by gameMemberIDX "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If rs.EOF Then
					oJSONoutput.ING = -1
				else
						arrR = rs.GetRows()
						oJSONoutput.ING = arrR(0, 0)
						totalorder = arrR(6, 0)

						pidx = arrR(1, 0)
						hidx = arrR(3, 0)
						prept = arrR(7,0) '기존 반영된 포인트

						pt = 0
						For i = 0 To 9
							If CDbl(i) = CDbl(totalorder) Then
								pt = ptvaluearr(i)

								SQL = "Update SD_tennisMember Set pt = '"&pt&"'  where gamememberidx =  '"&oJSONoutput.ING&"'  "
								'증가값은 지금값 - 이전값 예)5 - 0  = 5 ,5 - 10 =  -5
								updatevalue = CDbl(pt) - CDbl(prept)
								'양수만 입력되도록 설정
								SQL =  SQL & " Update tblPlayer Set pttotal = case when (pttotal + "&updatevalue&" > 0 ) then pttotal + "&updatevalue&" else 0 end,yearpt = case when (yearpt + "&updatevalue&" > 0 ) then yearpt + "&updatevalue&" else 0 end  where playerIDX in ("&pidx&","&hidx&")"
								Call db.execSQLRs(SQL , null, ConStr)
								Exit for
							End if
						Next
						oJSONoutput.PRINT = arrR(2, 0) & " , " & arrR(4,0) & " 각 포인트 :" & pt & " 반영완료<br>"	
						
					end If
					
			End if
		End If

	Else

		findmember =  " and a.gameMemberIDX > " & ing
		tblnm = " SD_tennisMember as a INNER JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
		fldnm = "a.gameMemberIDX,a.playeridx,a.username, b.playeridx,b.username "
		fldnm = fldnm & "  ,score_total  ,	total_order , a.pt "

		'복합마술은 각각 1라운드고 결과는 2라운드이다.
		SQL = "Select top 1 " & fldnm & " from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.teamgb = '20103'  "&findmember&" and round = 2 and a.gubun < 100 order by gameMemberIDX "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.EOF Then
			oJSONoutput.ING = -1
		else
			arrR = rs.GetRows()
			oJSONoutput.ING = arrR(0, 0)
			totalorder = arrR(6, 0)

			pidx = arrR(1, 0)
			hidx = arrR(3, 0)
			prept = arrR(7,0) '기존 반영된 포인트

			pt = 0
			For i = 0 To 9
				If CDbl(i) = CDbl(totalorder) Then
					pt = ptvaluearr(i)

					SQL = "Update SD_tennisMember Set pt = '"&pt&"'  where gamememberidx =  '"&oJSONoutput.ING&"'  "
					'증가값은 지금값 - 이전값 예)5 - 0  = 5 ,5 - 10 =  -5
					updatevalue = CDbl(pt) - CDbl(prept)
					'양수만 입력되도록 설정
					SQL =  SQL & " Update tblPlayer Set pttotal = case when (pttotal + "&updatevalue&" > 0 ) then pttotal + "&updatevalue&" else 0 end,yearpt = case when (yearpt + "&updatevalue&" > 0 ) then yearpt + "&updatevalue&" else 0 end  where playerIDX in ("&pidx&","&hidx&")"
					Call db.execSQLRs(SQL , null, ConStr)
					Exit for
				End if
			Next

			oJSONoutput.PRINT = arrR(2, 0) & " , " & arrR(4,0) & " 각 포인트 :" & pt & " 반영완료<br>"
		End if

	End if

	'-------------------------


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
