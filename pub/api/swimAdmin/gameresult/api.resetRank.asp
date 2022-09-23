<%
'#############################################
'랭킹포인트 리셋
'#############################################

'request
idx = oJSONoutput.IDX 'tblRGameLevel idx
tidx = oJSONoutput.TIDX
levelno = oJSONoutput.LEVELNO
title = oJSONoutput.TITLE
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM

Set db = new clsDBHelper

'renk info 삭제
SQL = "Delete from  sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " and rankno <=  32 and adminINdata = 'N'  " '사람이 수동으로 넣은데이터는 지워지지않게
'SQL = "Delete from  sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " and rankno <=  32   " '사람이 수동으로 넣은데이터는 지워지지않게
Call db.execSQLRs(SQL , null, ConStr)


'20101 개나리 20102 국화부
'20103 베테랑
'20104 신인부 20105 오픈부
'신인부(개나리부) 라면 중복된 데이터 한개만 남기고 싲운다.
If  Left(levelno,5) = "20101" Or Left(levelno,5) = "20104" then
	'중복된 adminINdata = 'Y' 데이터는 삭제 1개만 유지 되도록
	SQL = "select   playeridx, COUNT(*), max(idx)  from sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " and adminINdata = 'Y'  group by PlayerIDX "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	Do Until rs.eof
		delpidx = rs(0)
		cn = rs(1) 
		chkmaxidx = rs(2)
		If CDbl(cn) > 1 Then 'max idx 만 남기고 지우자
			SQL = "Delete from  sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " and adminINdata = 'Y' and playeridx = "  & delpidx & " and  idx < " & chkmaxidx
			Call db.execSQLRs(SQL , null, ConStr)		
		End if
	rs.movenext
	loop
End if


Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>