<%
  'request 처리##############

		REQ = chkReqMethod("p", "POST")

		''디버그 프린트
		'Call debugprint(req)
		''디버그 프린트

		If REQ <> "" then
		Set oJSONoutput = JSON.Parse(REQ)
			'page = chkInt(oJSONoutput.pg,1)

			If hasown(oJSONoutput, "tidx") = "ok" then
				tidx =	 chkInt(oJSONoutput.tidx,27)
			Else
				tidx = 27
			End If

			If hasown(oJSONoutput, "subtype") = "ok" then
				subtype = chkInt(oJSONoutput.subtype,1)
			Else
				subtype = 1
			End If

			If hasown(oJSONoutput, "BOONM") = "ok" then
				booNM = oJSONoutput.BOONM
			End if

			If hasown(oJSONoutput, "mysex") = "ok" then
				mysex = oJSONoutput.mysex
			End if


			If hasown(oJSONoutput, "LVLIDX") = "ok" then
				levelIDX = oJSONoutput.LVLIDX
			Else
				Call oJSONoutput.Set( "LVLIDX",  0 )
			End if

			If hasown(oJSONoutput, "ridx") = "ok" then
				ridx = oJSONoutput.ridx
			Else
				Call oJSONoutput.Set( "ridx",  0 )
			End if

			If hasown(oJSONoutput, "attmidx") = "ok" then
				attmidx = oJSONoutput.attmidx
			End If

			If hasown(oJSONoutput, "gameidx") = "ok" then
				gameidx = oJSONoutput.gameidx
			End if

			If hasown(oJSONoutput, "groupno") = "ok" then
				groupno = oJSONoutput.groupno
			Else
				Call oJSONoutput.Set( "groupno",  0 )
			End if

			If hasown(oJSONoutput, "mode") = "ok" then
				mode = oJSONoutput.mode
			End if

			'이미지 영상
			If hasown(oJSONoutput, "pno") = "ok" then
				pno = oJSONoutput.pno
			Else
				pno = 1
			End If

			If hasown(oJSONoutput, "seq") = "ok" then
				seq = oJSONoutput.seq
			End if
			If hasown(oJSONoutput, "idx") = "ok" then
				idx = oJSONoutput.idx
			End if
      If hasown(oJSONoutput, "rownum") = "ok" then
				rownum = oJSONoutput.rownum
			End if



			Select Case  PAGENAME
			Case  "request_apply.asp", "request_team.asp"
				If hasown(oJSONoutput, "chkgame") = "ok" then
					chkgame = oJSONoutput.chkgame
					chkgameboo = Split(chkgame, ":")
					For i = 0 To ubound(chkgameboo)
						'levelIDX , 선수등급
					next
				Else
					Response.redirect "/"
					Response.end
				End If
			Case "request_competition_detail.asp" '###################
				If hasown(oJSONoutput, "subtype") = "ok" Then '개인 , 단체 1,2
					subtype = oJSONoutput.subtype
					If CDbl(subtype) = 1 then
						subtypestr = "개인"
					Else
						subtypestr = "단체"
					End if
				End If
				If hasown(oJSONoutput, "chkgame") = "ok" Then '신청정보   116,루키:117,CAT3:118,루키:  (부에 키값(levelno), 선수등급)
					chkgame = oJSONoutput.chkgame
				End If


				If hasown(oJSONoutput, "bikeidx") = "ok" Then 'bike.tblmember.MemberIDX
					bikeidx = oJSONoutput.bikeidx
				End if

			End Select





			If CDbl(subtype) = 1 Then
				subtitle = "개인경기"
			Else
				subtitle = "단체경기"
			End if

		Else
			pno = 1 '한페이지에서 (여러 화면 중 1페이지)

			'findmode 전체검색
			Set oJSONoutput = JSON.Parse("{}")
      Call oJSONoutput.Set( "tidx",  "27" )
      tidx = chkInt(chkReqMethod("tidx", "GET"), 27)
			Call oJSONoutput.Set( "subtype",  "1" )
			Call oJSONoutput.Set( "LVLIDX",  0 )
			Call oJSONoutput.Set( "groupno",  "0" )
			'page = chkInt(chkReqMethod("page", "GET"), 1)
			subtitle = "개인경기"


			If PAGENAME = "request_apply.asp" Then
				Response.redirect "/"
				Response.end
			End If

		End If



	reqjson = JSON.stringify(oJSONoutput)
  'request 처리##############
%>
