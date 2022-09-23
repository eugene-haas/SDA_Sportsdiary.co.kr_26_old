
<%
'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

' 포인트 입력 (직접 포인트를 입력한다. 

'$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

	scidx = oJSONoutput.SCIDX '결과테이블 인덱스
	mkey = oJSONoutput.MIDX
	mname = oJSONoutput.NM
	pos = oJSONoutput.POS 'left right null (승패와 상관없슴)
	serveidx = oJSONoutput.SVIDX '서브인덱스
	servename = oJSONoutput.SVNM '서브자 이름
	'#################################
	Set db = new clsDBHelper

	strTableName = " sd_TennisResult_record "
	SQL = "select top 1 rcIDX,gameend,gameno,setno,playsortno,score_postion,skill1,skill2,skill3,midx  from "&strTableName&" where  resultIDX = " & scidx & " order by rcIDX desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof then
		rkey = 0
		gameend  = 0
		setno  = 1
		gameno = 1
		psortno = 0
		leftscore = 0
		rightscore = 0 
		skill1 = "기타"
	Else
		rkey = rs("rcIDX")
		gameend  = rs("gameend")
		setno  = rs("setno")
		gameno = rs("gameno")
		psortno = rs("playsortno")
		score_postion = rs("score_postion")
		skill1 = "기타"
		'mkey = rs("midx")

		If isNull(pos) = True Then
			pos = score_postion
			oJSONoutput.POS = pos
		End if

		SQL = "Select max(leftscore),max(rightscore) from "&strTableName&" where resultIDX = " & scidx & "and setno = " & setno & " and gameno = " & gameno
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		leftscore = rs(0)
		rightscore = rs(1)	
	End if


	'#########################

	If gameend = "1" Then
		psortno = 1 '다시 시작
		gameno = CDbl(gameno) + 1
		leftscore = 0
		rightscore = 0
	Else
		psortno = CDbl(psortno) + 1 '다음
	End If

	If pos = "left" then
		leftscore = CDbl(leftscore) + 1
	Else
		rightscore = CDbl(rightscore) + 1
	End If

	SQL = "INSERT into " & strTableName & "(resultIDX,midx, name,setno,gameno,playsortno,servemidx,servemname,score_postion,skill1,skill2,leftscore,rightscore) values " 'score_postion 클릭한 위치 left right
	SQL = SQL & "  ("&scidx&", " & mkey &" ,'" & mname & "',"&setno&","&gameno&","&psortno&","&serveidx&", '"&servename&"' , '" & pos &"', '기타','기타',"&leftscore&","&rightscore&" )"
	Call db.execSQLRs(SQL , null, ConStr)		

	SQL = "Select max(rcIDX) from "&strTableName&" where resultIDX = " & scidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rkey = rs(0)

	Call oJSONoutput.Set("INNO", "0" ) '점수 다음
	Call oJSONoutput.Set("result", "0" )
	Call oJSONoutput.Set("RKEY", rkey )
	Call oJSONoutput.Set("SETNO", setno )
	Call oJSONoutput.Set("GAMENO", gameno )
	Call oJSONoutput.Set("LSCORE", leftscore )
	Call oJSONoutput.Set("RSCORE", rightscore )
	Call oJSONoutput.Set("MIDX", mkey )
	Call oJSONoutput.Set("SK1", skill1 )
	Call oJSONoutput.Set("POINTNO", psortno )


	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set skilldef = nothing
	Set db = Nothing
%> 