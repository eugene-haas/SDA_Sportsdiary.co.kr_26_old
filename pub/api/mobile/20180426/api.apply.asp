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
	SQL ="SELECT count(*) as attCnt FROM tblGameRequest a  where  GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN in ('Y' , 'N') " '참가이력이 있는 모든인원
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	attCNT = rs(0) '현재까지 참가자수

	
	SQL = "Select top 1 EntryCntGame,attmembercnt,cfg,TeamGb,TeamGbNm from tblRGameLevel where GameTitleIDX = " & tidx & " and level = '"&levelno&"' and  DelYN = 'N' "
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
	
	If ridx = "" Then '입력
		If chk2 = "N" Then
		Call oJSONoutput.Set("result", "52" ) '신청제한
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
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

	'선수1정보
	If hasown(oJSONoutput, "p1idx") = "ok" then
		p1idx = oJSONoutput.p1idx
	End if
	
	
	p1name = oJSONoutput.p1name
	p1phone = oJSONoutput.p1phone
	p1grade = oJSONoutput.p1grade

	if p1phone="010" then 
		p1phone=""
	end if 

	
	p2name = oJSONoutput.p2name
	p2phone = oJSONoutput.p2phone
	p2grade = oJSONoutput.p2grade

	if p2phone="010" then 
		p2phone=""
	end if 

	If hasown(oJSONoutput, "p1idx") = "ok" And p1idx <> "" then
		p1idx = oJSONoutput.p1idx
	Else
		p1idx = 0 

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

		If stateRegExp(p1name ,"[^-가-힣a-zA-Z0-9/ ]") = False  then '한,영,숫자
		'Or stateRegExp(p1team1txt ,"[^-가-힣a-zA-Z0-9/ ]") = False Or stateRegExp(p1team2txt ,"[^-가-힣a-zA-Z0-9/ ]") = False
			Call oJSONoutput.Set("result", "10" ) '사용하면 안되는 문자발생
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		Else
			If p1team1 = "" And p1team1txt <> "" Then
				p1team1 = teamChk(p1team1txt)
			End If
			If p1team2 = "" And p1team2txt <> "" Then
				p1team2 = teamChk(p1team2txt)
			End if			
		End If	
	End if

	'선수2정보
	If hasown(oJSONoutput, "p2idx") = "ok" then
		p2idx = oJSONoutput.p2idx
	End if

	If hasown(oJSONoutput, "p2idx") = "ok" And p2idx <> "" then
		p2idx = oJSONoutput.p2idx
	Else
		p2idx = 0 

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

		If stateRegExp(p2name ,"[^-가-힣a-zA-Z0-9/ ]") = False then '한,영,숫자
		'Or stateRegExp(p2team1txt ,"[^-가-힣a-zA-Z0-9/ ]") = False Or stateRegExp(p2team2txt ,"[^-가-힣a-zA-Z0-9/ ]") = False 
			Call oJSONoutput.Set("result", "10" ) '사용하면 안되는 문자발생
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		Else
			If p2team1 = "" And p2team1txt <> "" Then
				p2team1 = teamChk(p2team1txt)
			End If
			If p2team2 = "" And p2team2txt <> "" Then
				p2team2 = teamChk(p2team2txt)
			End if		
		End If	
	End if


	'수정 ##########
	If ridx <> "" Then
		SQL = "Select UserPass from tblGameRequest where RequestIDX = " & ridx  &  " and UserPass = '"&attpwd&"' "
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

	Function playerChk(ByVal pname, ByVal team1Nm, ByVal team2Nm ,ByVal t1code, ByVal t2code, ByVal phone, ByVal grade,ByVal p_TeamGb,ByVal p_TeamGbNm )
		Dim SQL , rs , insertfield, insertvalue, ppname
		Dim returnvalue(2)
		SQL = "Select PlayerIDX, Replace(UserPhone,'-','')UserPhone,TeamNm,Team2Nm,userName from tblPlayer where delYN = 'N' and UserName = '"&Trim(pname)&"' and Replace(UserPhone,'-','')='"&Replace(phone,"-","")&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs.eof Then
			'선수등록
			insertfield = " SportsGb,UserName,EnterType,Team,TeamNm, Team2,Team2Nm,UserPhone,userLevel ,belongBoo"
			insertvalue = " 'tennis','"&pname&"','A','"&t1code&"','"&team1Nm&"','"&t2code&"','"&team2Nm&"', '"&phone&"','"&grade&"','"&p_TeamGbNm&"' "

			SQL = "SET NOCOUNT ON INSERT INTO tblPlayer ( "&insertfield&" ) VALUES " 
			SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			returnvalue(1) = rs(0)
			returnvalue(2) = pname
			playerChk = returnvalue 

		Else  '동일이름 + 폰정보
			'선수정보 가져옴
			If Replace(rs(1),"-","") = Replace(phone,"-","") Then '1 = 1 or 1 =2  or 2 = 1 or 2 = 2
				returnvalue(1) = rs(0)  '사용자가 존재합니다.
				returnvalue(2) = pname
				playerChk = returnvalue 
			Else  '동명인 인서트( 이름 + 핸드폰) 고유키
				'SQL = "Select UserName from tblPlayer where delYN = 'N' and UserName like '"&LCase(Trim(pname))&"%' order by UserName desc" 
				'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				'Do Until rs.eof 
				'chkvalue = mid( rs(0), CDbl(Len(Trim(pname)) + 1)) 

				'	If isNumeric(chkvalue) = True Then
				'		nameno = chkvalue
				'	Exit do
				'	End if
				'rs.movenext
				'loop

				'If nameno = "" then
				'	pname = pname & "1"
				'Else
				'	pname = Trim(pname) & CDbl(nameno + 1)
				'End if

				insertfield = " SportsGb,UserName,EnterType,Team,TeamNm, Team2,Team2Nm,UserPhone,userLevel  ,belongBoo "
				insertvalue = " 'tennis','"&pname&"','A','"&t1code&"','"&team1Nm&"','"&t2code&"','"&team2Nm&"', '"&phone&"','"&grade&"','"&p_TeamGbNm&"' "

				SQL = "SET NOCOUNT ON INSERT INTO tblPlayer ( "&insertfield&" ) VALUES " 
				SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"

				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				returnvalue(1) = rs(0)  '사용자가 존재합니다.
				returnvalue(2) = pname
				playerChk = returnvalue 
			End if
		End If
	end Function 
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

		    SQL = "Select top 1 UserName,userLevel,isnull(team,'')team,isnull(team2,'')team2,teamNm,team2Nm, Replace(UserPhone,'-','') UserPhone from tblPlayer where PlayerIDX = " & p1idx
		    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		    p1value =   p1idx & " ,'"&rs(0)&"','"&rs(1)&"','"&rs(2)&"','"&rs(3)&"','"&rs(4)&"','"&rs(5)&"','"&rs(6)&"' "
		    p1name = rs(0)
		    p1team1 = rs(2)
		    p1team2 = rs(3)
		    p1team1txt = rs(4)
		    p1team2txt = rs(5)
		    'p1phone = rs(6)
	    Else

            if ridx = ""  then
		        '중복저장체크########################
		        '이름과 전화번호가 동일하다면
		        SQL = "Select UserPass from tblGameRequest where GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN = 'N' and (P1_UserName = '" & p1name & "' and  P1_UserPhone = '" & p1phone & "' or P2_UserName = '" & p1name & "' and  P2_UserPhone = '" & p1phone & "')"
		        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		        If Not rs.eof then
			        Call oJSONoutput.Set("result", "96" ) '중복 참가점수자가 포함됨
			        strjson = JSON.stringify(oJSONoutput)
			        Response.Write strjson
			        Response.End
		        end if
		    '중복저장체크########################
		    end if 

			
			if p1name <> ""  then
			
				p1info = playerChk(p1name, p1team1txt, p1team2txt, p1team1,p1team2,p1phone,p1grade,c_TeamGb,c_TeamGbNm )
				p1idx = p1info(1)
				p1name = p1info(2)

			else
				Call oJSONoutput.Set("result", "97" ) '중복 참가점수자가 포함됨
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.End
			end if 

		    p1value =   p1idx & " ,'"&p1name&"','"&p1grade&"','"&p1team1&"','"&p1team2&"','"&p1team1txt&"','"&p1team2txt&"','"&p1phone&"' "
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


		    SQL = "Select top 1 UserName,userLevel,isnull(team,'')team,isnull(team2,'')team2,teamNm,team2Nm,Replace(UserPhone,'-','') UserPhone from tblPlayer where PlayerIDX = " & p2idx
		    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)	
		    p2value =   p2idx & " ,'"&rs(0)&"','"&rs(1)&"','"&rs(2)&"','"&rs(3)&"','"&rs(4)&"','"&rs(5)&"','"&rs(6)&"' "
		    p2name = rs(0)
		    p2team1 = rs(2)
		    p2team2 = rs(3)
		    p2team1txt = rs(4)
		    p2team2txt = rs(5)
		    'p2phone = rs(6)
	    Else
            if ridx = "" and p2name <> ""  then
		        '중복저장체크########################
		        '이름과 전화번호가 동일하다면
		        SQL = "Select UserPass from tblGameRequest where GameTitleIDX = " & tidx & " and Level = " & levelno & " and DelYN = 'N' and (P1_UserName = '" & p2name & "' and  P1_UserPhone = '" & p2phone & "' or P2_UserName = '" & p2name & "' and  P2_UserPhone = '" & p2phone & "')"
		        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		        If Not rs.eof then
			        Call oJSONoutput.Set("result", "99" ) '중복 참가점수자가 포함됨
			        strjson = JSON.stringify(oJSONoutput)
			        Response.Write strjson
			        Response.End
		        end if
		        '중복저장체크########################
		    end if
				 
			if p2name <> ""  then
				p2info = playerChk(p2name, p2team1txt, p2team2txt, p2team1,p2team2,p2phone,p2grade,c_TeamGb,c_TeamGbNm  )	
				p2idx = p2info(1)
				p2name = p2info(2)
				p2value =   p2idx & " ,'"&p2name&"','"&p2grade&"','"&p2team1&"','"&p2team2&"','"&p2team1txt&"','"&p2team2txt&"','"&p2phone&"' "
			else 
				p2value =   p2idx & " ,'','','','','','','' "
			end if 
		end if


	If ridx <> "" Then
		
		'참가/대진 신청 변경시 체크 
		'진행중일때 체크 
		'참가신청 페이지에서 변경 차단


	end if


	If ridx <> "" Then
		'대진등록 삭제
		strWhere = " GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno & " and isnull(round,0) = 0 and (playerIDX = '"&p1idx&"' or requestIDX = '"&ridx&"') "
		SQL = "select top 1 * From sd_TennisMember Where " & strWhere 
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof Then	'대기자
			attmember = false
		else	'참가자
			attmember = true
		End If

		strWhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno & " and isnull(a.round,0) = 0 and (a.playerIDX = '"&p1idx&"' or requestIDX = '"&ridx&"') "		
		SQL = "DELETE From sd_TennisMember From sd_TennisMember As a  Where " & strWhere 
		Call db.execSQLRs(SQL , null, ConStr)
 


		'1. 수정한다.
		setvalue = " GameTitleIDX = "&tidx&",Level= '"&levelno&"',UserPass = '"&attpwd&"',UserName = '"&attname&"',UserPhone = '"&attphone&"',txtMemo = '"&attask&"',PaymentDt = '"&inbankdate&"',PaymentNm = '"&inbankname&"' " 
		setvalue = setvalue & " ,P1_PlayerIDX = "&p1idx&",P1_UserName = '"&p1name&"',P1_UserLevel = '"&p1grade&"',P1_Team = '"&p1team1&"',P1_Team2 = '"&p1team2&"',P1_TeamNm = '"&p1team1txt&"',P1_TeamNm2 = '"&p1team2txt&"',P1_UserPhone = '"&p1phone&"' "
		setvalue = setvalue & " ,P2_PlayerIDX = "&p2idx&",P2_UserName = '"&p2name&"',P2_UserLevel = '"&p2grade&"',P2_Team = '"&p2team1&"',P2_Team2 = '"&p2team2&"',P2_TeamNm = '"&p2team1txt&"',P2_TeamNm2 = '"&p2team2txt&"',P2_UserPhone = '"&p2phone&"' "

		insertvalue = " "&tidx&",'"&levelno&"','A','"&attpwd&"','"&attname&"','"&attphone&"','"&attask&"','"&inbankdate&"','"&inbankname&"' "		
		insertvalue = insertvalue & "," & p1value & "," & p2value

		SQL = "Update tblGameRequest Set  "&setvalue&" where  RequestIDX = " & ridx 
		Call db.execSQLRs(SQL , null, ConStr)

		'대진표 수정

		'대진 파트너 수정


	else
		'2. 저장한다. c_TeamGb c_TeamGbNm
		insertfield = " GameTitleIDX,Level,EnterType,UserPass,UserName,UserPhone,txtMemo,PaymentDt,PaymentNm " 
		insertfield = insertfield & " ,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_Team,P1_Team2,P1_TeamNm,P1_TeamNm2,P1_UserPhone "
		insertfield = insertfield & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_Team,P2_Team2,P2_TeamNm,P2_TeamNm2,P2_UserPhone "

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
'	If CDbl(attCNT) < CDbl(EntryCntGame)   then ' 현재까지 참가자수 >= 참가 제한수   or 수정상태이고, 참가자라면
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