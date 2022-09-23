<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
Response.End



nkey =oJSONoutput.NKEY

Set db = new clsDBHelper

'팀이 있는지 확인
'선수가 있는지 확인
'sd_TennisRPoint_log
'게임코드 찾기  gamegrade (GA,SA~~~), gamecode(대회코드)
'select * from sd_2017excelrank as a inner join sd_TennisTitleCode as b on a.title like  '%'+b.hostTitle+'%' 

Function teamChk(ByVal teamNm)
	Dim rs, SQL ,insertfield ,insertvalue ,teamcode
	SQL = "Select Team from tblTeamInfo where SportsGb = 'tennis' and TeamNm = '"&Replace(Trim(teamNm)," ","")&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		'등록 후 정보
	    SQL = "Select top 1 convert(nvarchar,SUBSTRING(Team,4,LEN(Team))+1) teamLast,len(Team)TeamLen from  tblTeamInfo where SportsGb = 'tennis'  ORDER BY Team desc"
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

Function playerFind(ByVal pname, ByVal team1Nm, ByVal team2Nm ,ByVal t1code, ByVal t2code, ByVal teamgbnm, ByVal phone)
	Dim SQL , rs , insertfield, insertvalue, ppname,userphone,findsameplayer,printmsg,pidx
	findsameplayer = False
	
	'이름과 부가 같다면 다른사람이야.
	'SQL = "Select PlayerIDX,TeamNm,Team2Nm,userName,userPhone from tblPlayer where delYN = 'N' and UserName = '"&Trim(pname)&"' " 
	'SQL = "Select PlayerIDX,TeamNm,Team2Nm,userName,userPhone from tblPlayer where delYN = 'N' and UserName like '"&LCase(Trim(pname))&"%' and belongBoo = '"&teamgbnm&"' order by UserName desc" 
	SQL = "Select top 1 PlayerIDX,TeamNm,Team2Nm,userName,userPhone from tblPlayer where delYN = 'N' and UserName = '"&LCase(Trim(pname))&"' and belongBoo = '"&teamgbnm&"' and userPhone = '"&phone&"' order by UserName desc" 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		'선수등록
		insertfield = " SportsGb,UserName,EnterType,Team,TeamNm, Team2,Team2Nm,belongBoo,userphone "
		insertvalue = " 'tennis','"&pname&"','A','"&t1code&"','"&team1Nm&"','"&t1code&"','"&team2Nm&"', '" &teamgbnm & "', '" & phone &  "' "

		SQL = "SET NOCOUNT ON INSERT INTO tblPlayer ( "&insertfield&" ) VALUES " 
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		pidx = rs(0)
		printmsg = "신규생성 ~~~~~~~~~~~~~~XXXXX"
		playerFind = array(pidx,printmsg,pname)

	Else  '동일이름+부+전번  패스 

		Do Until rs.eof 

			'선수정보 가져옴
			'If LCase(rs(1)) = LCase(Trim(team1Nm)) Or LCase(rs(1)) = LCase(Trim(team2Nm)) Or LCase(rs(2)) = LCase(Trim(team1Nm)) Or LCase(rs(2)) = LCase(Trim(team2Nm))  Then 
			'	pidx = rs(0)		'완전있어
			'	printmsg = "동일선수 있다 정상등록................OOOO" 
			'	pname = rs("userName")
			'	userphone = rs("userphone")
			'	findsameplayer = true
			'	Exit Do
			'Else
				userphone = rs("userphone")				
				pname = rs("userName")				
				pidx = rs(0)
			'End if

		rs.movenext
		Loop
		
		'If findsameplayer = False Then
			'If userphone = "" Or isNull(userphone) = True then
			'	SQL = "Select right(UserPhone,8) from tblPlayer where delYN = 'N' and userPhone is not null and right(userphone,8) < 100000  order by right(userphone,8) asc" 
			'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			'	If rs.eof Then
			'		userphone = "010"&"00000001"
			'	Else
			'		userphone = CDbl(rs(0)) + 1
			'		userphone = "010" & Left("00000000000", 8 -Len(userphone)) & userphone
			'	End if

			'End if

			'팀명을 업데이트 시키자
			'SQL = "Update tblPlayer Set Team = '"&Team&"',TeamNm = '"&TeamNm&"', Team2 = '"&Team2&"',Team2Nm = '"&Team2Nm&"',UserPhone= '"&userphone&"' where PlayerIDX = " & pidx
			'Call db.execSQLRs(SQL , null, ConStr)

			printmsg = pname & " ..........................랭킹포인트 정보 업데이트"
		'End if

		playerFind = array(pidx,printmsg,pname)
	End If

end Function 

Sub attInsert(ByVal pidx,ByVal name,ByVal point,ByVal rankno, ByVal titlegrade,ByVal titlecode,ByVal titleidx,ByVal title,ByVal teamgb,ByVal teamgbnm,ByVal gamedate  )
	Dim SQL, rs, idx,insertfield, insertvalue

	insertfield = " PlayerIDX,userName,getpoint,rankno,titleGrade,titleCode,titleIDX,titleName,teamGb,teamGbName,GameDate " 
	insertvalue = " "&pidx&",'"&name&"',"&point&","&rankno&","&titlegrade&","&titlecode&","&titleidx&", '"&title&"','"&teamgb&"','"&teamgbnm&"' ,'"&gamedate&"' "
	SQL = "INSERT INTO sd_TennisRPoint_log ( "&insertfield&" ) VALUES ("&insertvalue&") " 
	
	Call db.execSQLRs(SQL , null, ConStr)
	'Response.write sql & "<br>"

End Sub

'################################################################
If CDbl(nkey) < 9000 then
nkey = 9497
End if

afield = " a.idx,a.name,a.booname,a.point, a.title, a.gamedate, a.team1, a.team2,a.rankno "
bfield = " ,b.titleCode,b.titleGrade,b.idx,a.phone "

SQL = "select "& afield & bfield &" from sd_2017excelrank as a inner join sd_TennisTitleCode as b on a.title like  '%'+b.hostTitle+'%'  where a.idx = " & nkey & " and b.delYN = 'N' "
'Response.write sql
'Response.end
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rs.eof Then
	idx =rs(0)
	name =rs(1)
	booname =rs(2)
	point =rs(3)
	title =rs(4)
	gamedate =rs(5)
	team1 =rs(6)
	team2  =rs(7)
	rankno = Replace(Replace(rs(8),"위",""),"강","")
	If isnumeric(rankno) = False Then
	rankno = 0
	End if
	phone = rs(12)

	titleCode =  rs(9) '코드인덱스
	titleGrade =  rs(10) '등급
	titleIDX = 0 '기록 내용 없슴

	Select Case  booname
	Case "헤드부"
		teamgb = "20105"
		teamgbnm = "오픈부"
	Case "베테랑부"
		teamgb = "20103"
		teamgbnm = "베테랑부"
	Case "국화부"
		teamgb = "20102" 
		teamgbnm = "국화부"
	Case "스타부"
		teamgb = "20104"
		teamgbnm = "신인부"
	Case "개나리부"
		teamgb = "20101"
		teamgbnm = "개나리부"
	End Select

	team1_code = teamChk(team1)
	team2_code = teamChk(team2)
	'선수로 등록되어 있는지 확인
	pinfo = playerFind(name, team1, team2, team1_code,team2_code ,teamgbnm,phone)
	pidx = pinfo(0)
	name = pinfo(2)

	'로그저장
	Call attInsert(pidx,name,point,rankno,titleGrade,titleCode,titleIDX,title,teamgb,teamgbnm,gamedate )
	oJSONoutput.NKEY = CDbl(nkey) + 1
End if


'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

Response.write pinfo(1) & "<br>"




db.Dispose
Set db = Nothing
%>