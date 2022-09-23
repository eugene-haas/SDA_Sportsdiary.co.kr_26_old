<%
'#############################################


'#############################################
	'request
	titleidx = oJSONoutput.TitleIDX
	title = oJSONoutput.Title
	teamidx = oJSONoutput.TeamIDX  '인덱스
	levelno = oJSONoutput.LevelNo
	teamgbnm = oJSONoutput.BOONM

	'response.write "titleidx : " & titleidx & "</br>"
	'response.write "title : " & title& "</br>"
	'response.write "teamidx : " &teamidx& "</br>"
	'response.write "levelno : " &levelno& "</br>"
	'response.write "teamgbnm : " &teamgbnm& "</br>"

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
	If p1team1 = "" Then
	p1team1txt = ""
	End If
	If p1team2 = "" Then
	p1team2txt = ""
	End if	
	

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
	If p2team1 = "" Then
	p2team1txt = ""
	End If
	If p2team2 = "" Then
	p2team2txt = ""
	End if	

	p1rpoint =  oJSONoutput.p1rpoint
	p2rpoint =  oJSONoutput.p2rpoint


	Set db = new clsDBHelper

		
'		Function make_player_func2(ByVal name, ByVal phone, ByVal birth, ByVal sex, ByVal grade, ByVal team1key, ByVal team1value, ByVal team2key, ByVal team2value  )
'			Dim insertfield,insertvalue,pidx
'				insertfield = " SportsGb,PlayerGb,UserName,UserPhone,Birthday,Sex,Level,EnterType,Team,TeamNm, Team2,Team2Nm "
'				insertvalue = " 'tennis','te045001','"&name&"','"&phone&"','"&birth&"','"&sex&"','"&grade&"','A','"&team1key&"','"&team1value&"','"&team2key&"','"&team2value&"' "
'
'				SQL = "SET NOCOUNT ON INSERT INTO tblPlayer ( "&insertfield&" ) VALUES " 
'				SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
'				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'				pidx = rs(0)
'				make_player_func2 = pidx
'		End Function


		'선수로 등록되어 있는지 확인
		SQL = "Select count(*) from tblPlayer where PlayerIDX in ('"&p1idx&"','"&p2idx&"')"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If CDbl(rs(0)) < 2 Then '한명이라도 등록된 선수가 아니라면
			Call oJSONoutput.Set("result", "3" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.End			
		End if


		'중복검사
		subSql = " and (P1_PlayerIDX = '"&p1idx&"' or P2_PlayerIDX = '"&p2idx&"' or P1_PlayerIDX = '"&p2idx&"' or P2_PlayerIDX = '"&p1idx&"')"
		SQL = "SELECT top 1 GameTitleIDX from tblGameRequest where SportsGb = 'tennis' and DelYN = 'N' and Level =" & levelno & " and GameTitleIDX = "&titleidx& subSql
	
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof  then
			'타입 석어서 보내기
			Call oJSONoutput.Set("result", "2" )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"

			Set rs = Nothing
			db.Dispose
			Set db = Nothing
			Response.End
		End if

		'pidx1 = make_player_func2(p1name,p1phone,p1_birth,p1sex,p1grade,p1team1,p1team1txt,p1team2,p1team2txt)
		'pidx2 = make_player_func2(p2name,p2phone,p2_birth,p2sex,p2grade,p2team1,p2team1txt,p2team2,p2team2txt)

		SQL ="SELECT count(*) as attCnt FROM tblGameRequest where  GameTitleIDX = " & titleidx & " and Level = " & levelno & " and DelYN = 'N' "
		'response.write SQL
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		attCNT = rs(0)
		'response.write attCNT
		'response.end

		SQL = "Update tblRGameLevel Set attmembercnt =" & attCNT & " where RGameLevelIdx = " & teamidx
		'response.write sql
		'response.end
		Call db.execSQLRs(SQL , null, ConStr)

		
		insertfield = " SportsGb, GameTitleIDX,Level,EnterType,UserPass,UserName,UserPhone,txtMemo " '여러팀을 등록했을시 ...
		insertfield = insertfield & " ,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX,P1_rpoint "
		insertfield = insertfield & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P2_rpoint "
		insertvalue = " 'tennis',"&titleidx&",'"&levelno&"','A','null','운영자','01000000000','자동생성' "
		insertvalue = insertvalue & " , "&p1idx&",'"&p1name&"','"&p1grade&"','"&p1team1txt&"','"&p1team2txt&"','"&p1phone&"','"&p1_birth&"','"&p1sex&"',"&p1rpoint&" "
		insertvalue = insertvalue & " , "&p2idx&",'"&p2name&"','"&p2grade&"','"&p2team1txt&"','"&p2team2txt&"','"&p2phone&"','"&p2_birth&"','"&p2sex&"',"&p2rpoint&" "
		SQL = "SET NOCOUNT ON  INSERT INTO tblGameRequest ( "&insertfield&" ) VALUES ("&insertvalue&")  SELECT @@IDENTITY " 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		newplayerkey = rs(0)

		SQL = "SELECT top 1 EntryListYN,RequestIDX, username,userphone,txtMemo,paymentNm,PaymentType,P1_PlayerIDX,P2_PlayerIDX from tblGameRequest where SportsGb = 'tennis' and DelYN = 'N' and Level =" & levelno & " and GameTitleIDX = "&titleidx & " and RequestIDX = " &  newplayerkey 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof  then
			rEntryListYN = rs("EntryListYN")
			idx = rs("RequestIDX")
		End if

		If rEntryListYN = "Y" Then
			rEntryListYN="참가자"
		Else
			rEntryListYN="대기자"
		End If

		
		pidx1 = rs("P1_PlayerIDX")
		pidx2 = rs("P1_PlayerIDX")

		pay_username = rs("username") '신청인
		pay_userphone = rs("userphone")
		pay_txtMemo = rs("txtMemo")
		pay_paymentNm = rs("paymentNm") '입금자명
		pay_PaymentType = rs("PaymentType")	'PaymentType 입금확인 Y확인, N미입금, F환불

		Select Case  pay_PaymentType
		Case "Y" : paytypestr = "입금"
		Case "M" : paytypestr = "미입금"
		Case "F" : paytypestr = "환불"
		Case Else : paytypestr = "미입금"
		End Select 


		'response.write rEntryListYN
		'response.end

		Select Case Left(levelno,3)
		Case "201","200"
			boo = "개인전"
			gamekey1 = "tn001001"
		Case "202"
			boo = "단체전"
			gamekey1 = "tn001002"
		End Select

		p1 = "<span style='color:orange'>" & p1name & "</span> (" & p1team1txt& ", " & p1team2txt & ") " & p1sex
		p2 = "<span style='color:orange'>" & p2name & "</span> (" & p2team1txt& ", " & p2team2txt & ") " & p2sex

		player = p1 & "&nbsp;&nbsp;&nbsp;" & p2



		rEntryListYN="대기자"
		gamemember = "<a href=""javascript:if (window.confirm('대기자에서 신청자로 전환됩니다.')){mx.setPlayer("& idx &")}"" class='btn_a'>신청전환</a>"
		'#################
		p1nm = p1name
		p1t1 = p1team1txt
		p1t2 = p1team2txt

		p2nm = p2name
		p2t1 = p2team1txt
		p2t2 = p2team2txt


  Set rs = Nothing
  db.Dispose
  Set db = Nothing

%>
	<!-- #include virtual = "/pub/html/tennisAdmin/gameInfoPlayerList.asp" -->