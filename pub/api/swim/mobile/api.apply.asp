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

	'전체체크인지 레벨체크인지 옵션 추가
	SQL = "select chkrange,gametitlename from sd_tennisTitle where gametitleidx = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof then
	chkrange = rs("chkrange") '0전체범위 체크 1 부별 체크
	tidxNm = rs(0)
	End If
	



	'대회정보 참가 수정 제한 체크
    attCNT=0
'	If CStr(chkrange) = "0" Then
'	SQL ="SELECT count(*) as attCnt FROM tblGameRequest a  where  GameTitleIDX = " & tidx & " and DelYN = 'N' " '참가이력이 있는 모든인원
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	else
	SQL ="SELECT count(*) as attCnt FROM tblGameRequest a  where  GameTitleIDX = " & tidx & " and Level = '" & levelno & "' and DelYN = 'N' " '참가이력이 있는 모든인원
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	End if
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
	p1name = oJSONoutput.p1name
	p1phone = oJSONoutput.p1phone

	If hasown(oJSONoutput, "jangname") = "ok" then
		jangname = trim(oJSONoutput.jangname)
	End If
	If hasown(oJSONoutput, "readername") = "ok" then
		readername = trim(oJSONoutput.readername)
	End If
	If hasown(oJSONoutput, "readerphone") = "ok" then
		readerphone = trim(oJSONoutput.readerphone)
	End If


	If hasown(oJSONoutput, "p1idx") = "ok" then
		p1idx = oJSONoutput.p1idx

		p1team1 = ""
		p1team1txt = ""

		'추가 항목
		sidogb1 = oJSONoutput.sidogb1 '거주
		googun1 = oJSONoutput.googun1
		addr1 = sidogb1 & "_" & googun1

		If hasown(oJSONoutput, "prize1") = "ok" then
			prize1 = oJSONoutput.prize1
		End If

		If hasown(oJSONoutput, "p1team1") = "ok" then
			p1team1 = oJSONoutput.p1team1
		End If

		If hasown(oJSONoutput, "p1team1txt") = "ok" then
			p1team1txt = trim(oJSONoutput.p1team1txt)
		End If

		If p1team1 = "" And p1team1txt <> "" Then
			p1team1 = teamChk(p1team1txt, jangname, readername, readerphone,addr1)
		End If

		'마지막 참가 정보 업데이트 (부서가 처음 셋팅된건지 확인후 클럽도 업데이트)
		'SQL = "Select teamNm from tblPlayer where playerIDX = " & p1idx
		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'If Not rs.eof Then
		'	If rs(0) = "" Or isnull(rs(0)) Then
				team1Aupstr = ", team = '"&p1team1&"' , teamNm = '"&p1team1txt&"' "
		'	End If
		'End if



		SQL = "update tblPlayer set sidogu = '"&addr1&"' , gamestartyymm = '"&goym1&"', userLevel = '"&p1grade&"',teamgb = '"&Left(levelno,5)&"',belongBoo='"&c_TeamGbNm&"' "&team1Aupstr&" where playerIDX = " & p1idx
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
	Function teamChk(ByVal teamNm, ByVal jangNm, ByVal readerNm , ByVal readerphone ,ByVal addr1)
		Dim rs, SQL ,insertfield ,insertvalue ,teamcode
		SQL = "Select Team from tblTeamInfo where SportsGb = 'tennis' and TeamNm = '"&Replace(Trim(teamNm)," ","")&"' and delyn='N' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		If rs.eof Then
			'등록 후 정보
			SQL = "Select top 1 convert(nvarchar,SUBSTRING(Team,4,LEN(Team))+1) teamLast,len(Team)TeamLen from  tblTeamInfo where SportsGb = 'tennis' and delyn='N'  ORDER BY Team desc"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			teamcode = "ATE000" & rs(0)

			insertfield = " SportsGb,Team,TeamNm,EnterType,TeamLoginPwd,NowRegYN,jangname,readername,readerphone,address "
			insertvalue = "'tennis','"&teamcode&"','"&Replace(Trim(teamNm)," ","")&"','A','"&teamcode&"','Y' ,'"&jangNm&"','"&readerNm&"','"&readerphone&"','"&addr1&"' "

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
					If CStr(chkrange) = "0" Then
						SQL = "Select UserPass from tblGameRequest where GameTitleIDX = " & tidx & " and DelYN = 'N' and (P1_PlayerIDX = " & p1idx & " )"
					Else
						SQL = "Select UserPass from tblGameRequest where GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN = 'N' and (P1_PlayerIDX = " & p1idx & " )"
					End if
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


	If ridx <> "" Then
		'참가/대진 신청 변경시 체크 
		'진행중일때 체크 
		'참가신청 페이지에서 변경 차단
	end if


	If ridx <> "" Then '수정
		'대진등록 삭제
		strWhere = " GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno & " and gubun = 0 and requestIDX = '"&ridx&"' "
		SQL = "select top 1 gameMemberIDX From sd_TennisMember Where " & strWhere 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof Then	'대기자
			attmember = false
		else	'참가자
			attmember = True
			delmemberidx = rs(0)

			SQL = "DELETE From sd_TennisMember where  gameMemberIDX = " & delmemberidx
			Call db.execSQLRs(SQL , null, ConStr)
		End If
 
		'1. 수정한다.
		setvalue = " GameTitleIDX = "&tidx&",Level= '"&levelno&"',UserPass = '"&attpwd&"',UserName = '"&attname&"',UserPhone = '"&attphone&"',txtMemo = '"&attask&"',PaymentDt = '"&inbankdate&"',PaymentNm = '"&inbankname&"' " 
		setvalue = setvalue & " ,P1_PlayerIDX = "&p1idx&",P1_UserName = '"&p1name&"',P1_UserLevel = '"&p1grade&"',P1_Team = '"&p1team1&"',P1_UserPhone = '"&p1phone&"' "
		setvalue = setvalue & " ,jangname = '"&jangname&"',readername = '"&readername&"',readerphone = '"&readerphone&"' "

		SQL = "Update tblGameRequest Set  "&setvalue&" where  RequestIDX = " & ridx 
		Call db.execSQLRs(SQL , null, ConStr)


	Else
		'2. 저장한다. c_TeamGb c_TeamGbNm
		insertfield = " GameTitleIDX,[Level],EnterType,UserPass,UserName,UserPhone,txtMemo,PaymentDt,PaymentNm " 
		insertfield = insertfield & " ,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_Team,P1_Team2,P1_TeamNm,P1_TeamNm2,P1_UserPhone  ,P1_birthday,P1_sex,P1_prizekey,P1_ID "
		insertfield = insertfield & " ,jangname,readername,readerphone,addr "

		insertvalue = " "&tidx&",'"&levelno&"','A','"&attpwd&"','"&attname&"','"&attphone&"','"&attask&"','"&inbankdate&"','"&inbankname&"' "		
		insertvalue = insertvalue & "," & p1value & " ,'"&jangname&"','"&readername&"','"&readerphone&"','"&addr1&"'   "




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












	Sub sendLms(phoneno,state)
		Dim SQL , rs, SMS_Subject, SMS_Msg,levelnm

		SQL = "select top 1 LevelNm from tblLevelInfo where [level] = '"&levelno&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.eof Then
			levelnm = rs("LevelNm")
		End if

		SMS_Subject = "["&tidxNm&"]대회 신청 안내"
		SMS_Msg = SMS_Msg & ""&tidxNm&"  ("&TeamGbNm&" "&levelNm&")에 참가신청이 접수되었습니다."&Chr(10)&Chr(10)

		SMS_Msg = SMS_Msg & "- 신청자 : "&attname&Chr(10)
		SMS_Msg = SMS_Msg & "- 참가자 : "&p1name&"("&p1team1&")"&Chr(10)

		if state = "wait" then 
			SMS_Msg = SMS_Msg & " 현재 인원수 제한으로 참가 대기로 접수 되었습니다."&Chr(10)
			SMS_Msg = SMS_Msg & " 문의 : SD고객센터(02-704-0282)"&Chr(10)&Chr(10)
		Else '가상계좌

			If CDbl(acctotal) > 0 Then '금액이 0이상인 경우만
				SQL = "Select VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_MAST where CUST_CD = '" & Left(sitecode,2) &  ridx & "' and sitecode = '"&sitecode&"' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If Not rs.eof Then
					SMS_Msg = SMS_Msg & "- 가상계좌 : " & rs(0) &Chr(10)
					SMS_Msg = SMS_Msg & "- 은행명 : "&CONST_BANKNM & Chr(10)
					SMS_Msg = SMS_Msg & "- 참가비 : " & acctotal & "원  "&Chr(10)
				End if
			End if
		end If

		SQL = " INSERT INTO SD_tennis.dbo.T_SEND (SSUBJECT ,NSVCTYPE,NADDRTYPE,SADDRS ,NCONTSTYPE,SCONTS,SFROM,DTSTARTTIME, sUserID	) "
		SQL = SQL & " VALUES ('"&SMS_Subject&"',7,0,'" & phoneno &"',0,'" & SMS_Msg & "','027040282',GETDATE(), 'rubin501' )"
		Call db.execSQLRs(SQL , null, ConStr)

	End sub











	'################################################
	'대진표등록
	'################################################
	If CDbl(attCNT) < CDbl(EntryCntGame)  Or (ridx <> "" And attmember = true) then ' 현재까지 참가자수 >= 참가 제한수   or 수정상태이고, 참가자라면
		insertfield = " gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa ,Round,requestIDX"
		insertvalue = " 0, "&tidx&", "&p1idx&", '"&p1name&"', '"&key1&"',"&Left(levelno,3)&","&levelno&","&Left(levelno,5)&",'"&teamgbNm&"','"&p1team1txt&"','"&p1team2txt&"' ,0,'"&ridx&"' "
		SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		gamemidx = rs(0)	


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

				SQL = "select top 1 CUST_CD from SD_rookieTennis.dbo.TB_RVAS_MAST where CUST_CD = '" & Left(sitecode,2) & ridx & "' "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If rs.eof then
					vcwhere = " VACCT_NO =  (Select top 1 VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_MAST where CUST_CD is null  and USER_NM is null) " '이름과 ridx 가 널인값만  현장입금 처리때문에
					SQL = "Update SD_rookieTennis.dbo.TB_RVAS_MAST Set STAT_CD = '1' ,IN_GB = '2', PAY_AMT = " & acctotal & ", CUST_CD = '" & Left(sitecode,2) &  ridx & "' ,CUST_NM = '"&CONST_PAYCOM&"' ,USER_NM = '" & attname & "',ENTRY_DATE= '" & ConvertDateFormat(Now()) & "',SiteCode = '"&sitecode&"' where " & vcwhere
					Call db.execSQLRs(SQL , null, ConStr)
				End if

			End if
		'==========================================

		'문자발송
		Call sendLms(p1phone,"att")

	
	else
        Call oJSONoutput.Set("result", "63" ) '대기접수

		'문자발송
		Call sendLms(p1phone, "wait")

	End if
	'################################################
	
	oJSONoutput.ridx = ridx 

	oJSONoutput.p1idx = p1idx
	oJSONoutput.p1name = p1name
	oJSONoutput.p1team1 = p1team1
	oJSONoutput.p1team1txt = p1team1txt
	oJSONoutput.p1phone = p1phone


	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

db.Dispose
Set db = Nothing
%>