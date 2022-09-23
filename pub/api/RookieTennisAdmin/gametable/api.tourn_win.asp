<%
'#############################################
'{"CMD":40004,"IDX":128,"TitleIDX":24,"Title":"예선 업로드","TeamNM":"신인부","AreaNM":"구리","ONEMORE":"notok","roundSel":"0","RESET":"notok","T_M1IDX":40343,"T_M2IDX":40357,"T_SORTNO":8,"T_RD":1,"S3KEY":"20104002","RIDX":4826,"NOWCTNO":40,"WINIDX":40343}

'{"CMD":40004,"IDX":128,"TitleIDX":24,"Title":"예선 업로드","TeamNM":"신인부","AreaNM":"구리","ONEMORE":"notok","RESET":"notok","roundSel":0,"T_M1IDX":40359,"T_M2IDX":40345,"T_SORTNO":10,"T_RD":1,"S3KEY":"20104002","RIDX":0,"WINIDX":40359}

'Response.end
'#############################################

'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
levelno = oJSONoutput.S3KEY
winidx = oJSONoutput.WINIDX 'gamememberidx

If hasown(oJSONoutput, "SCOREA") = "ok" then	
	scoreA = oJSONoutput.SCOREA
	scoreB = oJSONoutput.SCOREB
Else
	scoreA = 0
	scoreB = 0
End If

rno = oJSONoutput.T_RD
sortno = oJSONoutput.T_SORTNO '짝수로 검사해서 짝수만 온다.

If hasown(oJSONoutput, "NOWCTNO") = "ok" then	
	nowcourtidx = oJSONoutput.NOWCTNO
Else
	nowcourtidx = 0
End If

midx1 = oJSONoutput.T_M1IDX
midx2 = oJSONoutput.T_M2IDX
ridx = oJSONoutput.RIDX


'If CDbl(sortno) Mod 2 = 1 Then
'	sortno = CDbl(sortno) +1
'	winner = "left" 'left right tie (승패위치)
'Else
'	winner = "right"
'End If

nextSortNo = Fix(CDbl(sortno) /2)  '짝수만 오니까
nextRound = CDbl(rno) + 1 '최종라운드여부 확인

Set db = new clsDBHelper

strtable = " sd_TennisMember "
strtablesub =" sd_TennisMember_partner "
strtablesub2 = " tblGameRequest "
strresulttable = " sd_TennisResult "


'본선 진행에서 혹 승패처리했는지의 여부 확인하기 화면 재생성을 위해 패스시킴
	'코트 반환 문재 해결을 위해서 처리해야함
	SQL = "Select top 1 resultIDX,gameMemberIDX1,gameMemberIDX2,stateno,winIDX,preresult,recorderName,courtno from sd_tennisResult where gameMemberIDX1 = " & midx1 & " and delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
		If rs("winIDX") = "" Or rs("winIDX") = "0" Or isnull(rs("winIDX")) = true Then
			'아래로패스
		Else
			'이미 처리된건이므로 
			Call oJSONoutput.Set("result", 0 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson			
			Response.end
		End if
	End if
'본선 진행에서 혹 승패처리했는지의 여부 확인하기 화면 재생성을 위해 패스시킴




'혹시 결과 없는데 보냈다면 수정
	If CDbl(nowcourtidx) > 0 then
		SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = " & nowcourtidx
		Call db.execSQLRs(SQL , null, ConStr)
	End if
'혹시 결과 없는데 보냈다면 수정



If CDbl(ridx) = 0 Then '결과값확인
		
		'gubun 0 예선 1 본선 stateno 0 진행중, 1 경기종료, 2 경기진행중 
		If CDbl(midx1) = CDbl(winidx) Then
			winner = "left"
		End if
		If CDbl(midx2) = CDbl(winidx) Then
			winner = "right"
		End if		

		'm1set1, m2set1
		insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,winIDX,winResult, m1set1,m2set1 " 
		insertvalue = " "&midx1&","&midx2&",1,1,getdate(),'운영자','ADMIN','"&tidx&"',"&Left(levelno,5)&",'"&teamnm&"',"&levelno& "," & winidx& ",'" & winner & "', "&scoreA&","&scoreB&"  "
		SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
		Call db.execSQLRs(SQL , null, ConStr)
Else


		SQL = "select courtno from sd_TennisResult where resultIDX = " & ridx & " and gameMemberIDX1 = " & winidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If rs.eof Then
			winner = "right"
		Else
			winner = "left"
		End if
		
		SQL = "Update sd_TennisCourt Set courtstate = 0 where idx in (select courtno from sd_TennisResult where resultIDX = " & ridx & " )" '예선 본선두개가 된경우도 풀리도록
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = "Update sd_TennisResult Set winIDX = "&winidx&",winResult = '"&winner&"',stateno = 1,preresult='ADMIN' where resultIDX = " & ridx
		Call db.execSQLRs(SQL , null, ConStr)
End if


		'보낼 라운드에 3이 있으면 gubun = 3 이고 없으면 2로
		'SQL = "select top 1 gubun from sd_TennisMember where gubun > 2 and GameTitleIDX = "&tidx&" And gamekey3 = "&levelno&"  And Round = "&nextRound
		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'If rs.eof Then
		'	nextgubun = 2
		'Else
			nextgubun = 3
		'End if

		'//기존거 삭제 --
		SQL = "Delete From sd_TennisMember Where GameTitleIDX = "&tidx&" And gamekey3 = "&levelno&"  And Round = "&nextRound&" And sortno = " & nextSortNo
		Call db.execSQLRs(SQL , null, ConStr)

		'다음 라운드 부전맴버 insert * 구분2 준비 상태 구분 3 경기 시작상태( 코트 준비 또는 대기 기간 필요)
		insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,Round,SortNo ,ABC"
		selectfield = nextgubun & " ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,"&nextRound&","&nextSortNo&" ,ABC "
		selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & winidx

		SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		midx = rs(0)

		'파트너 insert
		insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
		selectfield =  " "&midx&",PlayerIDX,userName,TeamANa,TeamBNa "
		SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & winidx
		Call db.execSQLRs(SQL , null, ConStr)
'다음 라운드 승자 등록


Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>