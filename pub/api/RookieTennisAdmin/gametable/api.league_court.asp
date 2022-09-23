<%
'#############################################
' 예선 코트 부여
'#############################################

'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
levelno = oJSONoutput.S3KEY
jono = oJSONoutput.JONO

midx1 = oJSONoutput.MIDX1
midx2 = oJSONoutput.MIDX2
ridx = oJSONoutput.RIDX
courtidx = oJSONoutput.COURTNO
nowcourtidx = oJSONoutput.NOWCTNO

Set db = new clsDBHelper

strtable = " sd_TennisMember "
strtablesub =" sd_TennisMember_partner "
strtablesub2 = " tblGameRequest "
strresulttable = " sd_TennisResult "

'코트 사용여부 확인
If CDbl(courtidx) > 0 then
	SQL = "select idx,no,courtname,courtuse,courtstate,areaname from sd_TennisCourt where idx = " & courtidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	areaname = rs("areaname")
	court_name = rs("courtname")
	courtstate = rs("courtstate")
	If CDbl(courtstate) = 1 Then
		Call oJSONoutput.Set("result", 5000 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if
Else
	SQL = "select idx,no,courtname,courtuse,courtstate,areaname from sd_TennisCourt where idx = " & nowcourtidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	court_name = rs("courtname")
	areaname = rs("areaname")
End if



'아이디 가져오기 푸시메시지 만들기 #################################
SQL = "select top 2 P1_id, P2_id,P1_userName,P2_userName from tblGameRequest where requestIDX in (select requestIDX from sd_TennisMember where  gameMemberIDX in ('"&midx1&"', '"&midx2&"'))"
'SQL = "select top 2 P1_id, P2_id,P1_userName,P2_userName from tblGameRequest where requestIDX in (37110,37123)"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

Dim idarr(4)
i = 1
If Not rs.eof then
	Do Until rs.eof
		P1_id = rs(0)
		P2_id = rs(1)
		P1_username = rs(2)
		P2_username = rs(3)
		If i = 1 Then
			idarr(0) = P1_id
			idarr(1) = P2_id
			teamA = p1_username & "," & P2_username
		Else
			idarr(2) = P1_id
			idarr(3) = P2_id
			teamb = p1_username & "," & P2_username
		End if
	i = i + 1
	rs.movenext
	Loop
Else
		idarr(0) ="" ' "dnjswjd721"
		idarr(1) ="" ' "junggoo4"
		teamA = "김원정" & "," & "김정연"

		idarr(2) = "" '"dnjswjd721"
		idarr(3) = "" '"junggoo4"
		teamB = "김원정" & "," & "김정연"
End if
'###################################################





If CDbl(ridx) = 0 Then '결과값확인
	If CDbl(courtidx) = 0 Then
		SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = " & nowcourtidx
		Call db.execSQLRs(SQL , null, ConStr)
	else
		StateNo = 2 ' 0 진행중, 1 경기종료, 2 경기진행중 (테블릿 입력과 관련된건데 써야할까?)
		Preresult = "ING"
		insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,tryoutgroupno,courtno " 'gubun 0 예선 1 본선
		insertvalue = " "&midx1&","&midx2&","&StateNo&",0,getdate(),'운영자','"&Preresult&"','"&tidx&"',"&Left(levelno,5)&",'"&teamnm&"',"&levelno& "," & jono  & "," & courtidx
		SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
		Call db.execSQLRs(SQL , null, ConStr)

		'courtuse 실지 코트 사용여부( 상황에 따라 막을때)
		SQL = "Update sd_TennisCourt Set courtstate = 1 where idx = " & courtidx
		Call db.execSQLRs(SQL , null, ConStr)	
		

		'푸시알림
		pushtitle = "예선 " & areanm & " " & jono & " 조 경기 ["&areaname&" " & court_name & "] 배정 "  
		pushcontents = "( "&teamA&" vs "&teamB&")"
		Call sendPush( pushtitle , pushcontents, idarr )



	End if
Else
	If CDbl(courtidx) = 0 Then
		SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = " & nowcourtidx
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "Update sd_TennisResult Set courtno = 0,stateno=0 where resultIDX = " & ridx
		Call db.execSQLRs(SQL , null, ConStr)

		'푸시알림
		pushtitle = "코트 배정 취소 "  
		pushcontents = " ( "&teamA&" vs "&teamB&")"
		Call sendPush( pushtitle , pushcontents, idarr )	
	
	else
		SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = " & nowcourtidx
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "Update sd_TennisCourt Set courtstate = 1 where idx = " & courtidx
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "Update sd_TennisResult Set courtno = " &courtidx &  " where resultIDX = " & ridx
		Call db.execSQLRs(SQL , null, ConStr)
	
		'푸시알림
		pushtitle = "예선 " & areanm & " " & jono & " 조 경기 ["&areaname&" " & court_name & "] 재배정 "  
		pushcontents = " ( "&teamA&" vs "&teamB&")"
		Call sendPush( pushtitle , pushcontents, idarr )	

	End if
End if







Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>