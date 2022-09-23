<%
'#############################################
'선택한 쉬트의 내용을 표시해준다.
'#############################################
'request
nkey =oJSONoutput.NKEY
tidx = oJSONoutput.FSTR 
fstr2 = oJSONoutput.FSTR2
levelno = Split(fstr2,",")(0)
boonm = Split(fstr2,",")(1)
filename = oJSONoutput.FNM
sheetno = oJSONoutput.SHEETNO


Set db = new clsDBHelper

xlsFile = "D:\sportsdiary.co.kr\\xls\" & filename
Set objXlsConn = Server.CreateObject("ADODB.connection")

'- 확장자가 xlsx의 경우
xlsConnString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & xlsFile & "; Extended Properties=Excel 12.0;"
sheetname = getSheetName(xlsConnString) '쉬트 목록 가져오기

objXlsConn.Open xlsConnString  
Sql = "Select  * From ["&sheetname(sheetno)&"]"
Set Rs = objXlsConn.Execute(Sql)

If Not rs.eof Then
	arrRS = rs.GetRows()
End if

Dim x_name1(3)
Dim x_name2(3)
Dim x_team1(3)
Dim x_team2(3)

x_courtname = arrRS(0,nkey)
x_joono = arrRS(1,nkey)
x_name1(0) = arrRS(2,nkey)
x_team1(0) = arrRS(3,nkey)
x_name2(0) = arrRS(4,nkey)
x_team2(0) = arrRS(5,nkey)

x_name1(1) = arrRS(6,nkey)
x_team1(1) = arrRS(7,nkey)
x_name2(1) = arrRS(8,nkey)
x_team2(1) = arrRS(9,nkey)

x_name1(2) = arrRS(10,nkey)
x_team1(2) = arrRS(11,nkey)
x_name2(2) = arrRS(12,nkey)
x_team2(2) = arrRS(13,nkey)

'######################
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

Function playerChk(ByVal pname, ByVal team1Nm, ByVal team2Nm ,ByVal t1code, ByVal t2code)
	Dim SQL , rs , insertfield, insertvalue, ppname
	SQL = "Select PlayerIDX,TeamNm,Team2Nm,userName from tblPlayer where SportsGb = 'tennis' and delYN = 'N' and UserName = '"&Trim(pname)&"' "   ' and  TeamNm = '"&Trim(team1Nm)&"' " '1팀까지만 비교  , / 으로 비교하고 1팀 2팀 정보가 비뀐경우도+ 일딴 이름으로
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If rs.eof Then
		'선수등록
		insertfield = " SportsGb,UserName,EnterType,Team,TeamNm, Team2,Team2Nm "
		insertvalue = " 'tennis','"&pname&"','A','"&t1code&"','"&team1Nm&"','"&t1code&"','"&team2Nm&"' "

		SQL = "SET NOCOUNT ON INSERT INTO tblPlayer ( "&insertfield&" ) VALUES " 
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		playerChk = rs(0)

	Else  '동일이름이 있어

		'선수정보 가져옴
		If LCase(rs(1)) = LCase(Trim(team1Nm)) Then '1 = 1 or 1 =2  or 2 = 1 or 2 = 2
			playerChk = rs(0)
		Else  '동명인 인서트
			
			SQL = "Select UserName from tblPlayer where delYN = 'N' and SportsGb = 'tennis' and UserName like '"&LCase(Trim(pname))&"%' order by UserName desc" 
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			Do Until rs.eof 
			chkvalue = mid( rs(0), CDbl(Len(Trim(pname)) + 1)) 

				If isNumeric(chkvalue) = True Then
					nameno = chkvalue
				Exit do
				End if
			rs.movenext
			loop

			If nameno = "" then
				pname = pname & "1"
			Else
				pname = Trim(pname) & CDbl(nameno + 1)
			End if

			insertfield = " SportsGb,UserName,EnterType,Team,TeamNm, Team2,Team2Nm "
			insertvalue = " 'tennis','"&pname&"','A','"&t1code&"','"&team1Nm&"','"&t1code&"','"&team2Nm&"' "

			SQL = "SET NOCOUNT ON INSERT INTO tblPlayer ( "&insertfield&" ) VALUES " 
			SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			playerChk = rs(0)
		End if
	End If
end Function 

Sub attInsert(ByVal p1idx,ByVal p1nm,ByVal p1t1,ByVal p1t2, ByVal p2idx,ByVal p2nm,ByVal p2t1,ByVal p2t2 )
	Dim SQL, rs, idx,insertfield, insertvalue

	'중복 다시 넣을 경우 체크
	SQL = "select P1_PlayerIDX from tblGameRequest where SportsGb = 'tennis' and delYN = 'N' and GameTitleIDX = "&tidx&" and  Level = '"&levelno&"' and  P1_PlayerIDX = " & p1idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If rs.eof then
		insertfield = " SportsGb, GameTitleIDX,Level,EnterType,UserPass,UserName,UserPhone,txtMemo " '여러팀을 등록했을시 ...
		insertfield = insertfield & " ,P1_PlayerIDX,P1_UserName,P1_TeamNm,P1_TeamNm2 "
		insertfield = insertfield & " ,P2_PlayerIDX,P2_UserName,P2_TeamNm,P2_TeamNm2 "
		insertvalue = " 'tennis',"&tidx&",'"&levelno&"','A','null','운영자','01000000000','자동생성' , "&p1idx&", '"&p1nm&"','"&p1t1&"','"&p1t2&"' , "&p2idx&", '"&p2nm&"','"&p2t1&"','"&p2t2&"' "

		SQL = "INSERT INTO tblGameRequest ( "&insertfield&" ) VALUES ("&insertvalue&") " 
		Call db.execSQLRs(SQL , null, ConStr)
	End if
End Sub

Sub memberINsert(ByVal place,ByVal joono,ByVal sortno,           ByVal p1idx,ByVal p1nm,ByVal p1t1,ByVal p1t2,   ByVal p2idx,ByVal p2nm,ByVal p2t1,ByVal p2t2 )
	Dim SQL, rs, midx,insertfield, insertvalue

	'중복 다시 넣을 경우 체크
	SQL = "select userName from sd_TennisMember where  delYN = 'N' and GameTitleIDX = "&tidx&" and  gamekey3 = '"&levelno&"' and  PlayerIDX = " & p1idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If rs.eof then

		'gubun = 0 편성완료 시키면 result 테이블에 결과가 안들어가므로 넣어줘야 한다.
		insertfield = " place, gubun, GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,key3name,TeamANa,TeamBNa,rankpoint,tryoutgroupno,tryoutsortNo "
		insertvalue = " '"&place&"', 0, "&tidx&", "&p1idx&", '"&p1nm&"', 'tn001001',"&Left(levelno,3)&","&levelno&","&Left(levelno,5)&",'"&boonm&"','"&p1t1&"','"&p1t2&"','0',"&joono&","&sortno&" "
		SQL = "SET NOCOUNT ON  Insert into sd_TennisMember ("&insertfield&") values ("&insertvalue&")  SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		midx = rs(0)	

		insertfield = " GameMemberIDX, PlayerIDX,userName,TeamANa,TeamBNa,rankpoint "
		insertvalue = " "&midx&", "&p2idx&", '"&p2nm&"','"&p2t1&"','"&p2t2&"',0 "
		SQL = "Insert into sd_TennisMember_partner ("&insertfield&") values ("&insertvalue&")"
		Call db.execSQLRs(SQL , null, ConStr)		
	End if
End sub
'######################

'타입 석어서 보내기
'Call oJSONoutput.Set("result", "0" )
'strjson = JSON.stringify(oJSONoutput)
'Response.Write strjson
'Response.write "`##`"


x_sortno = 1
For i = 0 To 2 '3개팀 등록

	If Trim(x_name1(i)) <> "" then
		team1_1 = ""
		team1_2 = ""
		team2_1 = ""
		team2_2 = ""

		If CDbl(InStr(x_team1(i), ",")) > 0  Then
			team1_1 = Split(x_team1(i),",")(0)
			team1_2 = Split(x_team1(i),",")(1)
			team1_1_code = teamChk(team1_1)
			team1_2_code = teamChk(team1_2)
		ElseIf CDbl(InStr(x_team1(i), Chr(47))) > 0  Then
			team1_1 = Split(x_team1(i),Chr(47))(0)
			team1_2 = Split(x_team1(i),Chr(47))(1)
			team1_1_code = teamChk(team1_1)
			team1_2_code = teamChk(team1_2)
		ElseIf CDbl(InStr(x_team1(i), ".")) > 0  Then
			team1_1 = Split(x_team1(i),".")(0)
			team1_2 = Split(x_team1(i),".")(1)
			team1_1_code = teamChk(team1_1)
			team1_2_code = teamChk(team1_2)
		ElseIf CDbl(InStr(x_team1(i), " ")) > 0  Then
			team1_1 = Split(x_team1(i)," ")(0)
			team1_2 = Split(x_team1(i)," ")(1)
			team1_1_code = teamChk(team1_1)
			team1_2_code = teamChk(team1_2)
		ElseIf CDbl(InStr(x_team1(i), "(")) > 0  Then
			team1_1 = Split(x_team1(i),"(")(0)
			team1_2 = Replace(Split(x_team1(i),"(")(1),")","")
			team1_1_code = teamChk(team1_1)
			team1_2_code = teamChk(team1_2)
		Else
			team1_1 = x_team1(i)
			team1_2 = ""
			team1_1_code = teamChk(team1_1)
			team1_2_code = ""
		End If

		If CDbl(InStr(x_team2(i), ",")) > 0 Then
			team2_1 = Split(x_team2(i),",")(0)
			team2_2 = Split(x_team2(i),",")(1)
			team2_1_code = teamChk(team2_1)
			team2_2_code = teamChk(team2_2)
		elseIf CDbl(InStr(x_team2(i), Chr(47))) > 0 Then
			team2_1 = Split(x_team2(i),Chr(47))(0)
			team2_2 = Split(x_team2(i),Chr(47))(1)
			team2_1_code = teamChk(team2_1)
			team2_2_code = teamChk(team2_2)
		elseIf CDbl(InStr(x_team2(i), ".")) > 0 Then
			team2_1 = Split(x_team2(i),".")(0)
			team2_2 = Split(x_team2(i),".")(1)
			team2_1_code = teamChk(team2_1)
			team2_2_code = teamChk(team2_2)
		elseIf CDbl(InStr(x_team2(i), " ")) > 0 Then
			team2_1 = Split(x_team2(i)," ")(0)
			team2_2 = Split(x_team2(i)," ")(1)
			team2_1_code = teamChk(team2_1)
			team2_2_code = teamChk(team2_2)
		ElseIf CDbl(InStr(x_team2(i), "(")) > 0  Then
			team1_1 = Split(x_team2(i),"(")(0)
			team1_2 = Replace(Split(x_team2(i),"(")(1),")","")
			team1_1_code = teamChk(team1_1)
			team1_2_code = teamChk(team1_2)
		Else
			team2_1 = x_team2(i)
			team2_2 = ""
			team2_1_code = teamChk(team2_1)
			team2_2_code = ""
		End If

'Response.write "<br><br>"
'Response.write team1_1 & "---" & team1_2 & " <<|파트너|>> " & team2_1 & "---" & team2_2 & "<br>"


		'선수로 등록되어 있는지 확인
		player1idx = playerChk(x_name1(i), team1_1, team1_2, team1_1_code,team1_2_code )
		player2idx = playerChk(x_name2(i), team2_1, team2_2, team2_1_code,team2_2_code )

		'참가신청 등록
		Call attInsert(player1idx,x_name1(i),team1_1,team1_2,   player2idx,x_name2(i),team2_1,team2_2 )

		'예선 대진표 등록
		If x_joono = prejoo Then
			x_sortno = CDbl(x_sortno) + 1
		Else
			x_sortno = 1
		End if
		Call memberINsert(x_courtname,x_joono,x_sortno,    player1idx,x_name1(i),team1_1,team1_2,   player2idx,x_name2(i),team2_1,team2_2 )

	prejoo = x_joono
	End if
Next

'타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"

Response.write x_courtname & " " & x_joono & "조 각선수 등록 완료<br>"


Rs.close
Set Rs=nothing
objXlsConn.close
Set objXlsConn=Nothing


db.Dispose
Set db = Nothing
%>