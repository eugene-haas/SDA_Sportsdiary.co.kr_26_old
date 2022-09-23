<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.IDX

	titleidx = oJSONoutput.TitleIDX
	title = oJSONoutput.Title
	teamidx = oJSONoutput.TeamIDX  '인덱스
	levelno = oJSONoutput.LevelNo
	teamgbnm = oJSONoutput.BOONM

	p1idx = oJSONoutput.p1idx
	p1name = oJSONoutput.p1name
	p1phone = oJSONoutput.p1phone
	p1_birth = oJSONoutput.p1_birth
	p1sex = oJSONoutput.p1sex
	p1grade = oJSONoutput.p1grade
	p1team1 = oJSONoutput.p1team1
	p1team1txt = oJSONoutput.p1team1txt
	p1team2 = oJSONoutput.p1team2
	p1team2txt = oJSONoutput.p1team2txt

	p2idx = oJSONoutput.p2idx
	p2name = oJSONoutput.p2name
	p2phone = oJSONoutput.p2phone
	p2_birth = oJSONoutput.p2_birth
	p2sex = oJSONoutput.p2sex
	p2grade = oJSONoutput.p2grade
	p2team1 = oJSONoutput.p2team1
	p2team1txt = oJSONoutput.p2team1txt
	p2team2 = oJSONoutput.p2team2
	p2team2txt = oJSONoutput.p2team2txt

	If p1team1 = "" Then
	p1team1txt = ""
	End If
	If p1team2 = "" Then
	p1team2txt = ""
	End if	
	If p2team1 = "" Then
	p2team1txt = ""
	End If
	If p2team2 = "" Then
	p2team2txt = ""
	End if	

	p1rpoint =  oJSONoutput.p1rpoint
	p2rpoint =  oJSONoutput.p2rpoint

	Set db = new clsDBHelper

		'원래값
		SQL = "Select P1_PlayerIDX, P2_PlayerIDX,EntryListYN from tblGameRequest where RequestIDX = " & idx & " and DelYN='N'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof  then
			p1player = rs(0)
			p2player = rs(1)
			p1player = CDbl(p1player)
			p2player = CDbl(p2player)
			'rEntryListYN = rs(2)
		End if


		'아이디 가져오기
		SQL = "select playeridx ,userid from tblPlayer where playerIDx in ('"&p1idx&"','"&p2idx&"') "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		Do Until rs.eof
			player_idx  = rs(0)
			user_id = rs(1)
			If CStr(player_idx) = CStr(p1idx) Then
				p1_userid = user_id
			End If
			If CStr(player_idx) = CStr(p2idx) Then
				p2_userid = user_id
			End if			
		rs.movenext
		loop


		'정보업데이트
		updatevalue = " P1_PlayerIDX = "&p1idx&",P1_UserName='"&p1name&"',P1_UserLevel='"&p1grade&"',P1_TeamNm='"&p1team1txt&"',P1_TeamNm2='"&p1team2txt&"',P1_UserPhone='"&p1phone&"',P1_Birthday='"&p1_birth&"',P1_SEX='"&p1sex&"' , P1_rpoint = "&p1rpoint&", P1_ID = '"&p1_userid&"' "
		updatevalue = updatevalue & " ,P2_PlayerIDX = "&p2idx&",P2_UserName='"&p2name&"',P2_UserLevel='"&p2grade&"',P2_TeamNm='"&p2team2txt&"',P2_TeamNm2='"&p2team2txt&"',P2_UserPhone='"&p2phone&"',P2_Birthday='"&p2_birth&"',P2_SEX='"&p2sex&"' , P2_rpoint = "&p2rpoint&" , P2_ID = '"&p2_userid&"' "
		SQL = " Update  tblGameRequest Set  " & updatevalue & " where RequestIDX = " & idx
		Call db.execSQLRs(SQL , null, ConStr)


		'프린트할 바뀐정보
		SQL = "SELECT top 1 EntryListYN,RequestIDX, username,userphone,txtMemo,paymentNm,PaymentType from tblGameRequest where RequestIDX = " & idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof  then
			rEntryListYN = rs("EntryListYN")
			idx = rs("RequestIDX")
		End if

		pay_username = rs("username") '신청인
		pay_userphone = rs("userphone")
		pay_txtMemo = rs("txtMemo")
		pay_paymentNm = rs("paymentNm") '입금자명
		pay_PaymentType = rs("PaymentType")	'PaymentType 입금확인 Y확인, N미입금, F환불



		'업데이트 대진표 예선
		
		SQL = "select gameMemberIDX from sd_TennisMember where GameTitleIDX = "&titleidx&" and gamekey3 = " & levelno & " and gubun in (0,1) and  delYN='N'   and  playerIDX =  " & p1player
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		
		If rs.eof then
			rEntryListYN="대기자"
			gamemember = "<a href=""javascript:if (window.confirm('대기자에서 신청자로 전환됩니다.')){mx.setPlayer("& idx &")}"" class='btn_a'>신청전환</a>"				
		Else
			SQL = "select gameMemberIDX from sd_TennisMember where GameTitleIDX = "&titleidx&" and gamekey3 = " & levelno & " and  delYN='N'   and  playerIDX =  " & p1player
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
			
			i = 1
			Do Until rs.eof
				If i = 1 Then
					wherestr = rs(0)
				Else
					wherestr = wherestr & "," & rs(0)
				End if
			i = i + 1
			rs.movenext
			loop
			
			setfield = " PlayerIDX = "&p1idx&" , userName = '"&p1name&"', TeamANa = '"&p1team1txt&"' , TeamBNa = '"&p1team2txt&"',rankpoint = "&p1rpoint&" "
			SQL = "update sd_TennisMember Set  "& setfield &" where  gamememberidx in ("&wherestr&")"
			Call db.execSQLRs(SQL , null, ConStr)

			setfield = " PlayerIDX = "&p2idx&" , userName = '"&p2name&"', TeamANa = '"&p2team1txt&"' , TeamBNa = '"&p2team2txt&"',rankpoint = "&p2rpoint&" "
			SQL = "update sd_TennisMember_partner Set  "& setfield &" where  gamememberidx in ("&wherestr&")"
			Call db.execSQLRs(SQL , null, ConStr)

			rEntryListYN="<span style='color:orange;'>참가자</span>"
			gamemember = "<a href=""javascript:if (window.confirm('참가를 취소하면 복구 되지 않습니다.')){mx.delPlayer("& idx &", "& playeridx &");}"" class='btn_a' style='color:red'>신청취소</a>"
		End if
		


p1nm = p1name
p2nm = p2name

p1t1 = p1team1txt
p1t2 = p1team2txt
p2t1 = p2team1txt
p2t2 = p2team2txt

  db.Dispose
  Set db = Nothing









%>

<!-- #include virtual = "/pub/html/riding/gameinfoPlayerList.asp" -->
