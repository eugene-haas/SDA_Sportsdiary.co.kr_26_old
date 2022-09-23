<%
'#############################################
'
'#############################################
'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
levelno = oJSONoutput.S3KEY

midx1 = oJSONoutput.T_M1IDX
midx2 = oJSONoutput.T_M2IDX

rno = oJSONoutput.T_RD
sortno = oJSONoutput.T_SORTNO

ridx = oJSONoutput.RIDX
courtidx = oJSONoutput.COURTNO
nowcourtidx = oJSONoutput.NOWCTNO  '현재코트인덱스

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





'코트 사용여부 확인
If CDbl(courtidx) > 0 then
	SQL = "select idx,no,courtname,courtuse,courtstate from sd_TennisCourt where idx = " & courtidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	courtstate = rs("courtstate")
	If CDbl(courtstate) = 1 Then
		Call oJSONoutput.Set("result", 5000 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if
End if

If CDbl(ridx) = 0 Then '결과값확인
	If CDbl(courtidx) = 0 Then
		SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = " & nowcourtidx
		Call db.execSQLRs(SQL , null, ConStr)
	else
		StateNo = 0 ' 0 진행중, 1 경기종료, 2 경기진행중 (테블릿 입력과 관련된건데 써야할까?)
		Preresult = "ING"
		insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,courtno " 'gubun 0 예선 1 본선
		insertvalue = " "&midx1&","&midx2&","&StateNo&",1,getdate(),'운영자','"&Preresult&"','"&tidx&"',"&Left(levelno,5)&",'"&teamnm&"',"&levelno& "," & courtidx
		SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
		Call db.execSQLRs(SQL , null, ConStr)

		'courtuse 실지 코트 사용여부( 상황에 따라 막을때)
		SQL = "Update sd_TennisCourt Set courtstate = 1,settime=getdate() where idx = " & courtidx
		Call db.execSQLRs(SQL , null, ConStr)		
	End if
Else
	If CDbl(courtidx) = 0 Then
		SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = " & nowcourtidx
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "Update sd_TennisResult Set courtno = 0,stateno=0 where resultIDX = " & ridx
		Call db.execSQLRs(SQL , null, ConStr)
	else
		SQL = "Update sd_TennisCourt Set courtstate = 0 where idx = " & nowcourtidx
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "Update sd_TennisCourt Set courtstate = 1,settime=getdate() where idx = " & courtidx
		Call db.execSQLRs(SQL , null, ConStr)
		SQL = "Update sd_TennisResult Set courtno = " &courtidx &  " where resultIDX = " & ridx
		Call db.execSQLRs(SQL , null, ConStr)
	End if
End if


Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>