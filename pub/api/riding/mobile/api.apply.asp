<%
'#############################################
'참가신청
'#############################################
	'RequestIDX

	Set db = new clsDBHelper

	'수정인경우
	If hasown(oJSONoutput, "ridx") = "ok" then
		ridx = oJSONoutput.ridx
	End if

	tidx = oJSONoutput.tidx			   'sd_tennisTitle.idx
	teamgbNm = oJSONoutput.teamgbNm
	levelno = oJSONoutput.levelno  'tblRGameLevel.idx = tidx + levelno

	'개인천 key1 = "tn001001"
	key1 = "tn001001"

	'대회정보 참가 수정 제한 체크
    attCNT=0
	SQL ="SELECT count(*) as attCnt FROM tblGameRequest a  where  GameTitleIDX = " & tidx & " and Level = '" & levelno & "' and DelYN in ('N') " '참가이력이 있는 모든인원
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	attCNT = rs(0) '현재까지 참가자수


	SQL = "Select top 1 EntryCntGame,attmembercnt,cfg,TeamGb,TeamGbNm,fee,fund from tblRGameLevel where GameTitleIDX = " & tidx & " and level = '"&levelno&"' and  DelYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	attmembercnt = rs("attmembercnt") '참가 인원수
	EntryCntGame = rs("EntryCntGame") '참가 제한수
	c_TeamGb = rs("TeamGb")  ' c_TeamGb c_TeamGbNm
	c_TeamGbNm= rs("TeamGbNm")
	cfg = rs("cfg") '변형요강, 신청, 수정 ,삭제
	chk1 = Left(cfg,1)
	chk2 = Mid(cfg,2,1)
	chk3 = Mid(cfg,3,1)
	chk4 = Mid(cfg,4,1)
	fee = rs("fee")
	fund = rs("fund")
	acctotal = CDbl(fee) + CDbl(fund)

	If ridx = "" Then '입력
		If chk2 = "N" Then
			If CDbl(tidx) = 25 Then
				'test 패스
			else
				Call oJSONoutput.Set("result", "52" ) '신청제한
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.End
			End if
		End If
	Else '수정
		If chk3 = "N" Then
		Call oJSONoutput.Set("result", "53" ) '수정제한
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
		End If
	End if



	'참가신청자 정보
		attname = oJSONoutput.attname
		attphone = oJSONoutput.attphone
		attpwd	=  oJSONoutput.attpwd

		if attphone="010" then
			attphone=""
		end if

		If hasown(oJSONoutput, "inbankdate") = "ok" then	 '입금일짜
			inbankdate = oJSONoutput.inbankdate
		Else
			inbankdate = ""
		End If


		If hasown(oJSONoutput, "inbankname") = "ok" then	 '입금자
			inbankname = oJSONoutput.inbankname
		Else
			inbankname = ""
		End If

		If hasown(oJSONoutput, "attask") = "ok" then	'건의사항
			attask = oJSONoutput.attask
		Else
			attask = ""
		End if
	'참가신청자 정보


	'선수1정보@@@@@@@@@@@@@@@@@@@@@@@
	If hasown(oJSONoutput, "p1idx") = "ok" then
		p1idx = oJSONoutput.p1idx
	End if

	p1name = oJSONoutput.p1name
	p1phone = oJSONoutput.p1phone


	if p1phone="010" then
		p1phone=""
	end if


	p2name = oJSONoutput.p2name
	p2phone = oJSONoutput.p2phone

	if p2phone="010" then
		p2phone=""
	end if

	If hasown(oJSONoutput, "p1idx") = "ok" And p1idx <> "" then
		p1idx = oJSONoutput.p1idx

		p1team1 = ""
		p1team1txt = ""
		p1team2 = ""
		p1team2txt = ""

		If hasown(oJSONoutput, "p1team1") = "ok" then
			p1team1 = oJSONoutput.p1team1
		End If
		If hasown(oJSONoutput, "p1team2") = "ok" then
			p1team2 = oJSONoutput.p1team2
		End If

		If hasown(oJSONoutput, "p1team1txt") = "ok" then
			p1team1txt = trim(oJSONoutput.p1team1txt)
		End If
		If hasown(oJSONoutput, "p1team2txt") = "ok" then
			p1team2txt = trim(oJSONoutput.p1team2txt)
		End If

		If p1team1 = "" And p1team1txt <> "" Then
			p1team1 = teamChk(p1team1txt)
		End If
		If p1team2 = "" And p1team2txt <> "" Then
			p1team2 = teamChk(p1team2txt)
		End if

		If hasown(oJSONoutput, "p1team2txt") = "ok" then
			p1team2txt = trim(oJSONoutput.p1team2txt)
		End If

		'추가 항목
		sidogb1 = oJSONoutput.sidogb1 '거주
		googun1 = oJSONoutput.googun1
		goyear1 = oJSONoutput.goyear1 '구력
		gomonth1 = addZero(oJSONoutput.gomonth1)

		p1grade = oJSONoutput.p1grade '레벨
		addr1 = sidogb1 & "_" & googun1
		goym1 = goyear1 & gomonth1
		prize1 = oJSONoutput.prize1

		'마지막 참가 정보 업데이트 (부서가 처음 셋팅된건지 확인후 클럽도 업데이트)
		SQL = "Select teamNm,team2Nm from tblPlayer where playerIDX = " & p1idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			If rs(0) = "" Or isnull(rs(0)) Then
				team1Aupstr = ", team = '"&p1team1&"' , teamNm = '"&p1team1txt&"' "
			End If
			If rs(1) = "" Or isnull(rs(1)) And  p1team2txt <> "" Then
				team1Bupstr = ", team2 = '"&p1team2&"' , team2Nm = '"&p1team2txt&"' "
			End if
		End if

		SQL = "update tblPlayer set sidogu = '"&addr1&"' , gamestartyymm = '"&goym1&"', userLevel = '"&p1grade&"',teamgb = '"&Left(levelno,5)&"',belongBoo='"&c_TeamGbNm&"'   "&team1Aupstr &team1Bupstr &" where playerIDX = " & p1idx
		Call db.execSQLRs(SQL , null, ConStr)
	End if

	'선수2정보@@@@@@@@@@@@@@@@@@@@@@@
	If hasown(oJSONoutput, "p2midx") = "ok" Then '통합계정인덱스
		p2midx = oJSONoutput.p2midx
	End If

	If hasown(oJSONoutput, "p2idx") = "ok" then
		p2idx = oJSONoutput.p2idx
	End if

	p2team1 = ""
	p2team1txt = ""
	p2team2 = ""
	p2team2txt = ""

	If hasown(oJSONoutput, "p2team1") = "ok" then
		p2team1 = oJSONoutput.p2team1
	End If
	If hasown(oJSONoutput, "p2team2") = "ok" then
		p2team2 = oJSONoutput.p2team2
	End If

	If hasown(oJSONoutput, "p2team1txt") = "ok" then
		p2team1txt = trim(oJSONoutput.p2team1txt)
	End If
	If hasown(oJSONoutput, "p2team2txt") = "ok" then
		p2team2txt = trim(oJSONoutput.p2team2txt)
	End If

	If p2team1 = "" And p2team1txt <> "" Then
		p2team1 = teamChk(p2team1txt)
	End If
	If p2team2 = "" And p2team2txt <> "" Then
		p2team2 = teamChk(p2team2txt)
	End if

	'추가 항목
	sidogb2 = oJSONoutput.sidogb2 '거주
	googun2 = oJSONoutput.googun2
	goyear2 = oJSONoutput.goyear2 '구력
	gomonth2 = addZero(oJSONoutput.gomonth2)

	p2grade = oJSONoutput.p2grade '레벨
	addr2 = sidogb2 & "_" & googun2
	goym2 = goyear1 & gomonth2
	prize2 = oJSONoutput.prize2


	If p2idx = "" Then
		'player insert
		SQL = "select top 1 replace(UserPhone,'-',''),Birthday,Sex,userid   from tblMember where memberIDX = " & p2midx
		Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

		P1_id = Cookies_sdId
		P2_id = rs(3)
		i_field = "MemberIDX,UserName,Userphone,birthday,sex , sidogu,gamestartyymm,userLevel,     team,teamnm, team2, team2nm,teamgb,belongBoo,userid "
		i_value = p2midx & ", '" &p2name& "', '" &rs(0)& "', '" &rs(1)& "', '" &rs(2)& "', '"&addr2&"','"&goym2&"','"&p2grade&"',        '"&p2team1&"','"&p2team1txt&"','"&p2team2&"','"&p2team2txt&"','"&Left(levelno,5)&"','"&c_TeamGbNm&"', '"&P2_id&"'  "
		SQL = "Insert Into tblPlayer ("&i_field&") values ("&i_value&")"
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "Select  playeridx from tblPlayer where MemberIDX = " & p2midx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		p2idx = rs(0)
	Else
		'마지막 참가 정보 업데이트 (부서가 처음 셋팅된건지 확인후 클럽도 업데이트)
		SQL = "Select teamNm,team2Nm from tblPlayer where playerIDX = " & p2idx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			If rs(0) = "" Or isnull(rs(0)) Then
				team2Aupstr = ", team = '"&p2team1&"' , teamNm = '"&p2team1txt&"' "
			End If
			If rs(1) = "" Or isnull(rs(1)) And  p2team2txt <> "" Then
				team2Bupstr = ", team2 = '"&p2team2&"' , team2Nm = '"&p2team2txt&"' "
			End if
		End if
		'player update 마지막 참가 정보 업데이트
		SQL = "update tblPlayer set sidogu = '"&addr2&"' , gamestartyymm = '"&goym2&"', userLevel = '"&p2grade&"',teamgb = '"&Left(levelno,5)&"',belongBoo='"&c_TeamGbNm&"' "&team2Aupstr &team2Bupstr &" where playerIDX = " & p2idx
		Call db.execSQLRs(SQL , null, ConStr)
	End if

	'수정 ##########
	If ridx <> "" Then
		SQL = "Select UserPass from tblGameRequest where RequestIDX = " & ridx  &  " and UserPass = '"&attpwd&"' " '파트너도 수정해야하니 그냥두자
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof Then
			Call oJSONoutput.Set("result", "11" ) '패스워드가 틀림
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	End If
	'수정 ##########


'######################
	Function teamChk(ByVal teamNm)
		Dim rs, SQL ,insertfield ,insertvalue ,teamcode
		SQL = "Select Team from tblTeamInfo where SportsGb = 'tennis' and TeamNm = '"&Replace(Trim(teamNm)," ","")&"' and delyn='N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			'등록 후 정보
			SQL = "Select top 1 convert(nvarchar,SUBSTRING(Team,4,LEN(Team))+1) teamLast,len(Team)TeamLen from  tblTeamInfo where SportsGb = 'tennis' and delyn='N'  ORDER BY Team desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			teamcode = "ATE000" & rs(0)

			insertfield = " SportsGb,Team,TeamNm,EnterType,TeamLoginPwd,NowRegYN "
			insertvalue = "'tennis','"&teamcode&"','"&Replace(Trim(teamNm)," ","")&"','A','"&teamcode&"','Y' "

			SQL = "INSERT INTO tblTeamInfo ( "&insertfield&" ) VALUES ( "&insertvalue&" ) "
			Call db.execSQLRs(SQL , null, ConStr)
			teamChk = teamcode
		Else
			teamChk = rs(0)
		End If
	End function
'######################

	    '선수 1정보
	    If CDbl(p1idx) > 0 Then
            if ridx = ""  then
		        '중복저장체크########################
		        '인덱스 중복
		        '선수가 참가선수인지 중복체크 (이름 두명이 같을때)   GameTitleIDX,Level
		        SQL = "Select UserPass from tblGameRequest where GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN = 'N' and (P1_PlayerIDX = " & p1idx & " or P2_PlayerIDX = " & p1idx & ")"
		        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		        If Not rs.eof then
			        Call oJSONoutput.Set("result", "96" ) '중복 참가점수자가 포함됨
			        Call oJSONoutput.Set("SQL", SQL ) '중복 참가점수자가 포함됨
			        strjson = JSON.stringify(oJSONoutput)
			        Response.Write strjson
			        Response.End
		        end if
		        '중복저장체크########################
	        end if

		    SQL = "Select top 1 UserName,userLevel,isnull(team,'')team,isnull(team2,'')team2,teamNm,team2Nm, Replace(UserPhone,'-','') UserPhone,birthday,sex,userid from tblPlayer where PlayerIDX = " & p1idx
		    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			p1value =   p1idx & " ,'"&rs(0)&"','"&rs(1)&"','"&rs(2)&"','"&rs(3)&"','"&rs(4)&"','"&rs(5)&"','"&rs(6)&"','"&rs(7)&"','"&rs(8)&"','"&prize1&"', '"&rs(9)&"' "
		    p1name = rs(0)
		    p1team1 = rs(2)
		    p1team2 = rs(3)
		    p1team1txt = rs(4)
		    p1team2txt = rs(5)
		    p1phone = rs(6)
	    end if

	    '선수 2정보
	    If CDbl(p2idx) > 0 Then
            if ridx = ""  then
		        '중복저장체크########################
		        '인덱스 중복
		        '선수가 참가선수인지 중복체크 (이름 두명이 같을때)   GameTitleIDX,Level
		        SQL = "Select UserPass from tblGameRequest where GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN = 'N' and (P1_PlayerIDX = " & p2idx & " or P2_PlayerIDX = " & p2idx & ")"
		        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		        If Not rs.eof then
			        Call oJSONoutput.Set("result", "99" ) '중복 참가점수자가 포함됨
			        strjson = JSON.stringify(oJSONoutput)
			        Response.Write strjson
			        Response.End
		        end if
		        '중복저장체크########################
		    end if

		    SQL = "Select top 1 UserName,userLevel,isnull(team,'')team,isnull(team2,'')team2,teamNm,team2Nm,Replace(UserPhone,'-','') UserPhone,birthday,sex,userid from tblPlayer where PlayerIDX = " & p2idx
		    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		    p2value =   p2idx & " ,'"&rs(0)&"','"&rs(1)&"','"&rs(2)&"','"&rs(3)&"','"&rs(4)&"','"&rs(5)&"','"&rs(6)&"','"&rs(7)&"','"&rs(8)&"','"&prize2&"', '"&rs(9)&"' " '사은품, 통합아이디
		    p2name = rs(0)
		    p2team1 = rs(2)
		    p2team2 = rs(3)
		    p2team1txt = rs(4)
		    p2team2txt = rs(5)
		    p2phone = rs(6)
		end if


	If ridx <> "" Then
		'참가/대진 신청 변경시 체크
		'진행중일때 체크
		'참가신청 페이지에서 변경 차단
	end if


	If ridx <> "" Then '수정
		'대진등록 삭제
		strWhere = " GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno & " and gubun = 0 and  (playerIDX = '"&p1idx&"' or requestIDX = '"&ridx&"') "
		SQL = "select top 1 gameMemberIDX From sd_TennisMember Where " & strWhere
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof Then	'대기자
			attmember = false
		else	'참가자
			attmember = True
			delmemberidx = rs(0)

			SQL = "DELETE From sd_TennisMember where  gameMemberIDX = " & delmemberidx
			Call db.execSQLRs(SQL , null, ConStr)
			SQL = "DELETE From sd_TennisMember_partner where  gameMemberIDX = " & delmemberidx
			Call db.execSQLRs(SQL , null, ConStr)
		End If

		'1. 수정한다.
		setvalue = " GameTitleIDX = "&tidx&",Level= '"&levelno&"',UserPass = '"&attpwd&"',UserName = '"&attname&"',UserPhone = '"&attphone&"',txtMemo = '"&attask&"',PaymentDt = '"&inbankdate&"',PaymentNm = '"&inbankname&"' "
		setvalue = setvalue & " ,P1_PlayerIDX = "&p1idx&",P1_UserName = '"&p1name&"',P1_UserLevel = '"&p1grade&"',P1_Team = '"&p1team1&"',P1_Team2 = '"&p1team2&"',P1_TeamNm = '"&p1team1txt&"',P1_TeamNm2 = '"&p1team2txt&"',P1_UserPhone = '"&p1phone&"' "
		setvalue = setvalue & " ,P2_PlayerIDX = "&p2idx&",P2_UserName = '"&p2name&"',P2_UserLevel = '"&p2grade&"',P2_Team = '"&p2team1&"',P2_Team2 = '"&p2team2&"',P2_TeamNm = '"&p2team1txt&"',P2_TeamNm2 = '"&p2team2txt&"',P2_UserPhone = '"&p2phone&"' "

		insertvalue = " "&tidx&",'"&levelno&"','A','"&attpwd&"','"&attname&"','"&attphone&"','"&attask&"','"&inbankdate&"','"&inbankname&"' "
		insertvalue = insertvalue & "," & p1value & "," & p2value

		SQL = "Update tblGameRequest Set  "&setvalue&" where  RequestIDX = " & ridx
		Call db.execSQLRs(SQL , null, ConStr)


	Else
		'2. 저장한다. c_TeamGb c_TeamGbNm
		insertfield = " GameTitleIDX,[Level],EnterType,UserPass,UserName,UserPhone,txtMemo,PaymentDt,PaymentNm "
		insertfield = insertfield & " ,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_Team,P1_Team2,P1_TeamNm,P1_TeamNm2,P1_UserPhone  ,P1_birthday,P1_sex,P1_prizekey,P1_ID "
		insertfield = insertfield & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_Team,P2_Team2,P2_TeamNm,P2_TeamNm2,P2_UserPhone  ,P2_birthday,P2_sex,P2_prizekey,P2_ID "

		insertvalue = " "&tidx&",'"&levelno&"','A','"&attpwd&"','"&attname&"','"&attphone&"','"&attask&"','"&inbankdate&"','"&inbankname&"' "
		insertvalue = insertvalue & "," & p1value & "," & p2value

		SQL = "SET NOCOUNT ON INSERT INTO tblGameRequest ( "&insertfield&" ) VALUES ("&insertvalue&") SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		ridx = rs(0)



		'신청자수 업데이트
        if attCNT = 0 then
        SQL = "Update tblRGameLevel Set attmembercnt =1 where GameTitleIDX = " & tidx & " and level = '"&levelno&"' "
        else
        SQL = "Update tblRGameLevel Set attmembercnt ="&CDbl(attCNT)&"+1 where GameTitleIDX = " & tidx & " and level = '"&levelno&"' "
        end if
		Call db.execSQLRs(SQL , null, ConStr)
	End if


	'################################################
	'대진표등록
	'################################################
	If CDbl(attCNT) < CDbl(EntryCntGame)  Or (ridx <> "" And attmember = true) then ' 현재까지 참가자수 >= 참가 제한수   or 수정상태이고, 참가자라면
		insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa ,Round,requestIDX"
		insertvalue = " 0, "&tidx&", "&p1idx&", '"&p1name&"', '"&key1&"',"&Left(levelno,3)&","&levelno&","&Left(levelno,5)&",'"&teamgbNm&"','"&p1team1txt&"','"&p1team2txt&"' ,0,'"&ridx&"' "
		SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		gamemidx = rs(0)

		insertfield = " GameMemberIDX, PlayerIDX,userName,TeamANa,TeamBNa "
		insertvalue = " "&gamemidx&", "&p2idx&", '"&p2name&"','"&p2team1txt&"','"&p2team2txt&"' "
		SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
		Call db.execSQLRs(SQL , null, ConStr)
        Call oJSONoutput.Set("result", "60" ) '정상 접수


		'==========================================
		'가상계좌 정보를 설정해 둔다.  (빈계좌 하나를 가져온다.)
		'==========================================
			If CDbl(acctotal) > 0 Then '금액이 0이상인 경우만
				Function ConvertDateFormat(ByVal strDate)
					Dim tmpDate1, tmpDate2
					Dim returnDate
					tmpDate1 = Split(strDate, " ")
					tmpDate2 = Split(tmpDate1(2), ":")

					'오후라면 12시간을 더해준다
					If tmpDate1(1) = "오후" Then
						'오후 12시는 정오를 가르키기 때문에 제외
						If CDbl(tmpDate2(0)) < 12 Then
							tmpDate2(0) = CDbl(tmpDate2(0)) + 12
						End If
					End If

					returnDate = Replace(tmpDate1(0),"-","") & CheckFormat(tmpDate2(0),2) & CheckFormat(tmpDate2(1),2) & CheckFormat(tmpDate2(2),2)
					ConvertDateFormat = returnDate
				End Function

				'자릿수를 맞추기 위한 함수
				Function CheckFormat(ByVal num, ByVal splitpos)
					Dim tmpNum : tmpNum = 10000000
					tmpNum = tmpNum + CDbl(num)
					CheckFormat = Right(tmpNum, splitpos)
				End Function

				vcwhere = " VACCT_NO =  (Select top 1 VACCT_NO from TB_RVAS_MAST where CUST_CD is null  and USER_NM is null ) " '이름과 ridx 가 널인값만  현장입금 처리때문에
				SQL = "Update TB_RVAS_MAST Set STAT_CD = '1' ,IN_GB = '2', PAY_AMT = " & acctotal & ", CUST_CD = '" & Left(sitecode,2) & ridx & "' ,CUST_NM = '"&CONST_PAYCOM&"' ,USER_NM = '" & attname & "',ENTRY_DATE= '" & ConvertDateFormat(Now()) & "', sitecode = '"&sitecode&"'  where " & vcwhere
				Call db.execSQLRs(SQL , null, ConStr)
			End if
		'==========================================


	else
        Call oJSONoutput.Set("result", "63" ) '대기접수
	End if
	'################################################

	oJSONoutput.ridx = ridx

	oJSONoutput.p1idx = p1idx
	oJSONoutput.p1name = p1name
	oJSONoutput.p1team1 = p1team1
	oJSONoutput.p1team1txt = p1team1txt
	oJSONoutput.p1team2 = p1team2
	oJSONoutput.p1team2txt = p1team2txt
	oJSONoutput.p1phone = p1phone

	oJSONoutput.p2idx = p2idx
	oJSONoutput.p2name = p2name
	oJSONoutput.p2team1 = p2team1
	oJSONoutput.p2team1txt = p2team1txt
	oJSONoutput.p2team2 = p2team2
	oJSONoutput.p2team2txt = p2team2txt
	oJSONoutput.p2phone = p2phone

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

db.Dispose
Set db = Nothing
%>
