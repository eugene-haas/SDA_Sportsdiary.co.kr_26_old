<%
'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End if	
	If hasown(oJSONoutput, "TEAM") = "ok" then
		team = oJSONoutput.TEAM
	End If
	If hasown(oJSONoutput, "CHKSEQ") = "ok" Then '임시테이블에 저장된 SEQ
		chkseq = oJSONoutput.CHKSEQ
	End If	

	leaderidx = oJSONoutput.Get("LEADERIDX") '리더인덱스
'request

	'체크된 단체수
	groupcnt = oJSONoutput.Get("GROUPCNT")

	chkcnt = 0
	chklidxstr  = ""
	If hasown(oJSONoutput, "LIDXARR") = "ok" then
		Set lArr = oJSONoutput.LIDXARR 
		ReDim chkarr(oJSONoutput.LIDXARR.length-1)
		For i = 0 To oJSONoutput.LIDXARR.length-1
			
			chkarr(i) = lArr.Get(i) '수영모자 있을때
			If InStr(chkarr(i),"#") > 0 Then
				lidxcap = Split(chkarr(i),"#")
				chkarr(i) = lidxcap(0)
				sglidx = lidxcap(0)
				sgcap = lidxcap(1)
			End if
			chklidxstr = chklidxstr & "," & chkarr(i)
		Next

		chklidxstr = Mid(chklidxstr,2)
		chkcnt = oJSONoutput.LIDXARR.length
	End If

'		loopcnt = oJSONoutput.LIDXARR.length-1
		'Response.write chkarr(0)
		'Response.end


	'종목번호 1,2,3 으로 받자
	kindno = isNulldefault(oJSONoutput.get("KNO"),"")
	If kindno = "" Then
		kindno = "1"
	End if



	'***단체전은 제한에서 제외한다 20210126 황동현과 논의 (협단체에서 이야기 되지 않음)***


	Set db = new clsDBHelper

	'********************************
	'제한 종목당 한팀에서 2명이상 출전하지 못함 체크
	'한선수가 참가가능한 종목수
	'********************************	
	SQL = "select teamlimit, attgamecnt from sd_gameTitle where gametitleidx = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof then
		teamlimit = rs(0)
		attgamecnt = rs(1)
	End if


	If kindno = "1" Then '경영만 제한조건체크한다.

		'제한 종목당 한팀에서 2명이상 출전하지 못함 체크 (경영만 체크하자)
		If teamlimit = "Y" And chklidxstr <> ""  Then
			'팀당 체크된 종목이 몇개인지 확인하자. (seq) 인것중에
			'팀정보도 넣자...  (남여 구분해야할까)  경영만 체크

			'체크되지 안아야할것들 경영에 수구와 아티스틱 코드를 가져오자.
			'		31	플렛포옴다이빙
			'		32	스프링보오드1m
			'		33	스프링보오드3m
			'		34	싱크로다이빙3m
			'		35	싱크로다이빙10m
			'		41	싱크로나이즈드스위밍(솔로)
			'		42	싱크로나이즈드스위밍(듀엣)


			'팀에서 체크해야한다.
			
			'카운트 그룹안에 선택된 유저가 있는지 확인용
			chkq = " ,( "
			chkq =  chkq & " select top 1 playeridx from tblGameRequest_imsi as x inner join tblGameRequest_imsi_r as y on x.seq = y.seq and y.delyn = 'N'  "
			chkq =  chkq & " where x.team = '"&team&"' and x.cdb = a.cdb and y.cdc = b.cdc  and x.seq= '"&chkseq&"' "
			chkq =  chkq & " ) as pidx " 'null 인지 체크

			SQL = "Select COUNT(*) , cdcnm,cda    "&chkq&"    from tblGameRequest_imsi as a inner join tblGameRequest_imsi_r as b on a.seq = b.seq  and b.delyn = 'N' "
			SQL = SQL & "  where b.cda='D2' and a.tidx ="&tidx&" and  a.team ='"&team&"' and  b.RgameLevelIDX in ("&chklidxstr&") and b.itgubun='I' and b.cdc not in ('31','32','33','34','35','41','42') group by b.cdcnm,cdc,a.cdb,cda,sex   "

			'Response.write sql
			'Response.end

			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				arrC = rs.GetRows() 
			End if


			If IsArray(arrC) Then 
				For ari = LBound(arrC, 2) To UBound(arrc, 2)
					c_chkcnt = arrC(0, ari)
					c_chknm = arrC(1,ari)
					c_cda = arrC(2,ari)

					c_pidx = arrC(3,ari)

					
					'종목참가자수2명인데 선택한 
					If isNull(c_pidx) = True Then '보낸선수가 포함안된숫자라면
					If CDbl(c_chkcnt) > 1 And c_cda = "D2" then
							Call oJSONoutput.Set("msg", " 제한종목이 설정되어 2명이상 참가가 되지 않습니다.. 종목은:" & c_chknm  & "입니다." )
							Call oJSONoutput.Set("result", "8" )
							strjson = JSON.stringify(oJSONoutput)
							Response.Write strjson

							db.Dispose
							Set db = Nothing		
							Response.end
					End If
					End if
				Next
			End If

		End if


		
		'한선수가 참가가능한 종목수 (이것도 퀴리날려보자. 단체인경기는 체크항목에서 빼자.)
		If  CDbl(chkcnt -groupcnt) > CDbl(attgamecnt) Then
			Call oJSONoutput.Set("msg", " 참가가능 종목수가 초과되었습니다. 종목수는:" & attgamecnt & "입니다."  )
			Call oJSONoutput.Set("result", "8" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson

			db.Dispose
			Set db = Nothing		
			Response.end
		End If

	End if

	'###################################################################

		'선택된 맴버는 1인이므로 

		'새로 추가되는것과 삭제될 pidx 값을 구한다.
		SQL = "select RgameLevelIDX,cda,cdc from tblGameRequest_imsi_r where seq = " & chkseq
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			arrR = rs.GetRows() '설정되어있는 값
		End if
		'Call getrowsdrow(arrr)


		'기존맴버확인
		Function isBoo(lidx ,cArr)
			Dim i, ism
			ism = false

			For i = 0 To UBound(cArr)
				If Cstr(lidx) = Cstr(cArr(i)) Then '등록됨
					ism = true
				End If
			Next	

			isBoo = ism
		End Function


		'삭제할꺼
		Function delBoo(pidx , arrR)
			Dim i, ism
			ism = false
			
			If IsArray(arrR) Then 
				For i = LBound(arrR, 2) To UBound(arrR, 2)
					If CStr(pidx) = CStr(arrR(0, i)) Then 
						ism = true
					End if
				Next
			End If
			delBoo = ism
		End Function
	


		loopcnt = oJSONoutput.LIDXARR.length-1
		insertlidxs = ""
		dellidxs = ""
		delcda = ""
		delcdc = ""
		If IsArray(arrR) Then 
			For ari = LBound(arrR, 2) To UBound(arrR, 2)
				l_lidx = arrR(0, ari) '셋팅된 lidx
				l_cda = arrR(1,ari)
				l_cdc = arrR(2,ari)
				
				If isBoo(l_lidx , chkarr) = false Then 
					'삭제할맴법
					dellidxs = dellidxs & "," & l_lidx
					delcda = delcda & "," & l_cda
					delcdc = delcdc & "," & l_cdc
				End if
			Next
			dellidxs = Mid(dellidxs,2)
			delcda = Mid(delcda,2)
			delcdc = Mid(delcdc,2)

			If dellidxs <> "" then
			'지울때 (경영과 수구는 같이 참가할수 있다고 한다. 21.2.23 짜증나지만 ..

				Select Case kindno 
				Case "1" '경영
					SQL = "delete from tblGameRequest_imsi_r where seq = "&chkseq&" and RgameLevelIDX in ("&dellidxs&") and  not (cda = 'E2' and cdc = '31' ) " '수구가 아닌애들 대상
					Call db.execSQLRs(SQL , null, ConStr)
				Case "2" '다이빙
					SQL = "delete from tblGameRequest_imsi_r where seq = "&chkseq&" and RgameLevelIDX in ("&dellidxs&")"
					Call db.execSQLRs(SQL , null, ConStr)
				Case "3" '수구는 E2 이고 31이다. (경영체크된 항목을 지우지 않는다.)
					SQL = "delete from tblGameRequest_imsi_r where seq = "&chkseq&" and RgameLevelIDX in ("&dellidxs&") and  not ( cda = 'D2' and  cdc not in ('31','32','33','34','35','41','42')  )     "'경영이 아닌애들 (대상)
					Call db.execSQLRs(SQL , null, ConStr)
				Case Else
					SQL = "delete from tblGameRequest_imsi_r where seq = "&chkseq&" and RgameLevelIDX in ("&dellidxs&")"
					Call db.execSQLRs(SQL , null, ConStr)
				End Select 


			End if
		End If
		


		For i = 0 To oJSONoutput.LIDXARR.length-1
			i_lidx = lArr.Get(i) '요청된 lidx

			If InStr(i_lidx,"#") > 0 Then
				i_lidx = Split(i_lidx,"#")(0)
			End if


			If delBoo(i_lidx , arrR) = false Then 
				'추가할맴법
				insertlidxs = insertlidxs & "," & i_lidx
			End if
		Next
		insertlidxs = Mid(insertlidxs,2)



		
		
		
		'****경영에 단체만(단체처럼 체크) 아티스틱, 다이빙, 수구 (단체지만 개인처럼 체크)****** 룰적용 기준이 없어서 이렇게 합니다. 
		'여기서 문제를 찾자 종목에서 단체만 있다면 안됨. (경영기준)
		If insertlidxs <> "" Then

			SQL = "select CDA,ITGUBUN from tblRGameLevel  RgameLevelIDX where delyn = 'N'  and  RgameLevelIDX  in ("  & insertlidxs &  ") "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				arrT = rs.GetRows() 
			End If
			d2groupcnt = 0
			etccnt = 0
			If IsArray(arrT) Then 
			For a = LBound(arrT, 2) To UBound(arrT, 2)
				c_cda = arrT(0, a) 
				c_itgubun = arrT(1,a)

				If c_cda = "D2" Then '경영이라면
					If c_itgubun = "T" Then
						'경영단체다
						d2groupcnt = d2groupcnt + 1
					Else
						etccnt = etccnt + 1
					End if
				Else
					'단체든 개인이든 경영이 아니면 결제다. (결제되는 종목이 있나 체크하기위해 갯수를 구해둔다 하지만 묶어서 한개라는거)
					etccnt = etccnt + 1
				End if

			Next
			End if


			'지우고 남은것중에 개인(결제할게 있는지 확인하고) etccnt 있는지 확인하고 더하기
			SQL = "select CDA,ITGUBUN,CDCNM from tblGameRequest_imsi_r  where seq = " & chkseq
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				arrTT = rs.GetRows() 
				For a = LBound(arrTT, 2) To UBound(arrTT, 2)
					c_cda = arrTT(0, a) 
					c_itgubun = arrTT(1,a)

					If c_cda = "D2" Then '경영이라면
						If c_itgubun = "I" Then
							etccnt = etccnt + 1
						End if
					Else
						etccnt = etccnt + 1
					End if

				Next
			End If


			
			If kindno = "1" Then '경영만 체크
			
				If CDbl(etccnt) > 0 Then '패스
				Else
					If CDbl(d2groupcnt) > 0 Then

							Call oJSONoutput.Set("msg", " 단체전만 참여하실수 없습니다."  )
							Call oJSONoutput.Set("result", "8" )
							strjson = JSON.stringify(oJSONoutput)
							Response.Write strjson

							db.Dispose
							Set db = Nothing		
							Response.end

					End if
				End If

			End If
			
		End if




		If insertlidxs <> "" then
			SQL = " insert Into tblGameRequest_imsi_r (seq,rgamelevelidx,cda,cdanm,cdb,cdbnm,cdc,cdcnm,gbidx,levelno,itgubun ) "
			SQL = SQL & " Select "&chkseq&",rgamelevelidx,cda,cdanm,cdb,cdbnm,cdc,cdcnm,gbidx,levelno,itgubun from tblRGameLevel  where RgameLevelIDX in ("  & insertlidxs &  ") "

			Call db.execSQLRs(SQL , null, ConStr)
		End if


		'수구모는 어차피 한개 업데이트 하는거니 그냥 따로 업데이트 하자.
		If sglidx <> "" Then
			SQL = "update tblGameRequest_imsi_r Set capno = '"&sgcap&"' where seq = "&chkseq&" and RgameLevelIDX ="&sglidx
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	
	
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>

