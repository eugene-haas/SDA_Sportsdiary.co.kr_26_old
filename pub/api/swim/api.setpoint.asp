
<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

' 포인트 입력

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	scidx = oJSONoutput.SCIDX '결과테이블 인덱스
	inno = oJSONoutput.INNO	'처리할 번호
	inputvalue = oJSONoutput.INVALUE '이름또는 스킬명
	pos = oJSONoutput.POS 'left right null (승패와 상관없슴)
	serveidx = oJSONoutput.SVIDX '서브인덱스
	servename = oJSONoutput.SVNM '서브자 이름
	'#################################
	Set db = new clsDBHelper



	'inno 업데이트 순서 0,1,2,3 이름, 스킬1 스킬2 스킬3

	strTableName = " sd_TennisResult_record "
	SQL = "select top 1 rcIDX,gameend,gameno,setno,playsortno,score_postion,skill1,skill2,skill3,midx  from "&strTableName&" where  resultIDX = " & scidx & " order by rcIDX desc"
	'debugstr = sql
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	Set skilldef =Server.CreateObject("Scripting.Dictionary")
	'결과 다음 기술s
		skilldef.ADD  "IN", 2
		skilldef.ADD  "ACE", 2
		skilldef.ADD  "NET", 2 '진거
		skilldef.ADD  "OUT", 2 '진거
		
		'선수선택으로
		skilldef.ADD  "퍼스트서브", 0
		skilldef.ADD  "세컨서브", 0
		skilldef.ADD  "기타", 0
		skilldef.ADD  "스매싱", 0

'		skilldef.ADD  "F.리턴", 3
'		skilldef.ADD  "F.스트로크", 3
'		skilldef.ADD  "F.발리", 3
'		skilldef.ADD  "B.리턴", 3
'		skilldef.ADD  "B.스트로크", 3
'		skilldef.ADD  "B.발리", 3

		skilldef.ADD  "F.리턴", 0
		skilldef.ADD  "F.스트로크", 0
		skilldef.ADD  "F.발리", 0
		skilldef.ADD  "B.리턴", 0
		skilldef.ADD  "B.스트로크", 0
		skilldef.ADD  "B.발리", 0


		skilldef.ADD  "크로스", 0
		skilldef.ADD  "스트레이트", 0
		skilldef.ADD  "로브", 0
		skilldef.ADD  "역크로스", 0
		skilldef.ADD  "센터", 0
		skilldef.ADD  "쇼트", 0
	'결과 다음 기술e

	If rs.eof then
		rkey = 0
		gameend  = 0
		setno  = 1
		gameno = 1
		psortno = 0
		leftscore = 0
		rightscore = 0 
		skill1 = ""
	Else
		rkey = rs("rcIDX")
		gameend  = rs("gameend")
		setno  = rs("setno")
		gameno = rs("gameno")
		psortno = rs("playsortno")
		score_postion = rs("score_postion")
		skill1 = rs("skill1")
		skill2 = rs("skill2")
		skill3 = rs("skill3")
		mkey = rs("midx")

		If isNull(pos) = True Then
			pos = score_postion
			oJSONoutput.POS = pos
		End if

		SQL = "Select max(leftscore),max(rightscore) from "&strTableName&" where resultIDX = " & scidx & "and setno = " & setno & " and gameno = " & gameno
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		leftscore = rs(0)
		rightscore = rs(1)	
	End if

'Response.write leftscore & "  right : "& rightscore & "<br>"
'Response.end
	'#########################


	If inno = "0" Then '이름입력
		mkey = Split(inputvalue,"#$")(0)
		mname = Split(inputvalue,"#$")(1)

		'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
			'세트와 게임번호를 구한다. (타이브레이크 체크)
			'SQL = "Select m1set"&setno&",m2set"&setno&" from sd_TennisResult where resultIDX = " & scidx
			'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			'm1set = rs(0)
			'm2set = rs(1)

			If gameend = "1" Then
				psortno = 1 '다시 시작
				gameno = CDbl(gameno) + 1
				leftscore = 0
				rightscore = 0
			Else
				psortno = CDbl(psortno) + 1 '다음
			End If
		'\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
		'게임종료 확인 (사람이 판단)
		'gamediv = Abs(CDbl(rightscore) - Cdbl(leftscore))
		'If  leftscore = "7" Or rightscore = "7" Or ((leftscore = "6" Or rightscore = "6") And gamediv >1) Then
		'End if


		SQL = "INSERT into " & strTableName & "(resultIDX,midx, name,setno,gameno,playsortno,servemidx,servemname,score_postion) values " 'score_postion 클릭한 위치 left right
		SQL = SQL & "  ("&scidx&", " & mkey &" ,'" & mname & "',"&setno&","&gameno&","&psortno&","&serveidx&", '"&servename&"' , '" & pos &"' )"
		Call db.execSQLRs(SQL , null, ConStr)		

		SQL = "Select max(rcIDX) from "&strTableName&" where resultIDX = " & scidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		rkey = rs(0)
		oJSONoutput.INNO = 1 '다음
	Else

		strWhere = "  where  rcIDX = " & rkey

		Select Case inno
		Case "1"  '득실
			SQL = "UPDATE " & strTableName &" Set  skill1= '"& inputvalue & "' " & strWhere
			Call db.execSQLRs(SQL , null, ConStr)
	
		Case "2" 'shot

			If skill1 = "NET" Or skill1 = "OUT" then
				If inputvalue = "퍼스트서브" Then
					SQL = "UPDATE " & strTableName &" Set  skill2= '"& inputvalue & "',leftscore ="&leftscore&"  , rightscore = "&rightscore&",playsortno = playsortno -1      " & strWhere
					Call db.execSQLRs(SQL , null, ConStr)
					leftscore = -1 '패스
					psortno = psortno - 1
				Else

					If pos = "left" then
						rightscore = CDbl(rightscore) + 1

					Else
						leftscore = CDbl(leftscore) + 1
					End If			

					SQL = "UPDATE " & strTableName &" Set  skill2= '"& inputvalue & "',leftscore ="&leftscore&"  , rightscore = "&rightscore&"      " & strWhere

'Response.write sql & " "& pos & "<br>"
'Response.end	

					Call db.execSQLRs(SQL , null, ConStr)

				End if
			Else
				If pos = "left" then
					leftscore = CDbl(leftscore) + 1
				Else
					rightscore = CDbl(rightscore) + 1
				End If

				SQL = "UPDATE " & strTableName &" Set  skill2= '"& inputvalue & "',leftscore ="&leftscore&"  , rightscore = "&rightscore&"      " & strWhere
				Call db.execSQLRs(SQL , null, ConStr)
			End if


		Case "3" 'course
			SQL = "UPDATE " & strTableName &" Set  skill3= '"& inputvalue & "' " & strWhere
			Call db.execSQLRs(SQL , null, ConStr)
		End Select
		
		
		oJSONoutput.INNO = skilldef(inputvalue) '다음갈곳
	End if

	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("RKEY", rkey )
	Call oJSONoutput.Set("SETNO", setno )
	Call oJSONoutput.Set("GAMENO", gameno )
	Call oJSONoutput.Set("LSCORE", leftscore )
	Call oJSONoutput.Set("RSCORE", rightscore )
	Call oJSONoutput.Set("M1SET", m1set ) '현재 세트의 점수
	Call oJSONoutput.Set("M2SET", m2set )
	Call oJSONoutput.Set("MIDX", mkey )
	Call oJSONoutput.Set("SK1", skill1 )
	Call oJSONoutput.Set("POINTNO", psortno )

	'Call oJSONoutput.Set("debugprint", debugstr )


	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set skilldef = nothing
	Set db = Nothing
%> 