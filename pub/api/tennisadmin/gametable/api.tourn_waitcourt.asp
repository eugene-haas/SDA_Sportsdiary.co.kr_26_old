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

Set db = new clsDBHelper

strtable = " sd_TennisMember "
strtablesub =" sd_TennisMember_partner "
strtablesub2 = " tblGameRequest "
strresulttable = " sd_TennisResult "

'코트 사용여부 확인
If CDbl(courtidx) > 0 then
	SQL = "select idx,no,courtname,courtuse,courtstate from sd_TennisCourt where idx = " & courtidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	courtstate = rs("courtstate")
	If CDbl(courtstate) = 1 Then
		'Call oJSONoutput.Set("result", 5000 )
		'strjson = JSON.stringify(oJSONoutput)
		'Response.Write strjson
		'Response.end
	End if
End if


'Response.write nowcourtidx
'Response.end


If CDbl(ridx) = 0 Then '결과값확인
		StateNo = 0 ' 0 진행중, 1 경기종료, 2 경기진행중 (테블릿 입력과 관련된건데 써야할까?)
		Preresult = "ING"
		insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,waitcourtno " 'gubun 0 예선 1 본선
		insertvalue = " "&midx1&","&midx2&","&StateNo&",1,getdate(),'운영자','"&Preresult&"','"&tidx&"',"&Left(levelno,5)&",'"&teamnm&"',"&levelno& "," & courtidx
		SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
		Call db.execSQLRs(SQL , null, ConStr)
Else
	If CDbl(courtidx) = 0 Then
		SQL = "Update sd_TennisResult Set waitcourtno = 0,stateno =0 where resultIDX = " & ridx
		Call db.execSQLRs(SQL , null, ConStr)
	else
		SQL = "Update sd_TennisResult Set waitcourtno = " &courtidx &  " where resultIDX = " & ridx
		Call db.execSQLRs(SQL , null, ConStr)
	End if
End if


Call oJSONoutput.Set("result", 0 )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>