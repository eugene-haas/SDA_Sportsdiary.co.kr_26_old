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


SQL = "select   Playeridx,getpoint  from sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

Do Until rs.eof
	delpidx = rs("playeridx")
	pt = rs("getpoint") 
	SQL = "update  tblPlayer Set sdpoint = sdpoint - " &pt& " where Playeridx = " & delpidx
	Call db.execSQLRs(SQL , null, ConStr)		
rs.movenext
loop

'renk info 삭제
SQL = "Delete from  sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " and rankno <=  32 and adminINdata = 'N'  " '사람이 수동으로 넣은데이터는 지워지지않게
Call db.execSQLRs(SQL , null, ConStr)




Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>





<%
'#############################################
'랭킹포인트 리셋
'#############################################

'request
'idx = oJSONoutput.IDX 'tblRGameLevel idx
'tidx = oJSONoutput.TIDX
'levelno = oJSONoutput.LEVELNO
'title = oJSONoutput.TITLE
'teamnm = oJSONoutput.TeamNM
'areanm = oJSONoutput.AreaNM
'
'Set db = new clsDBHelper
'
'teamgb = Left(levelno,5)
'
'Select Case Left(levelno,5) 
'Case "20101"  '원스타  (승급시, teamgb, belongBoo변경)
'	SQL = "select   a.Playeridx, a.getpoint as pt1 , isnull(b.getpoint,0) as pt2  from sd_TennisRPoint_log as a left join sd_TennisRPoint_log as b "
'	SQL = SQL & " ON a.titleIDX = b.titleIDX  and (b.teamGb = '20102' and a.PlayerIDX = b.PlayerIDX)  where a.titleIDX =  " & tidx & " and a.teamGb = '" & Left(levelno,5) & "' "
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	Do Until rs.eof
'		delpidx = rs("playeridx")
'		pt1 = rs(1) 
'		pt2 = rs(2)
'
'		If CDbl(pt2) = 0 then
'			SQL = "update  tblPlayer Set sdpoint = sdpoint - " &pt1 & " where Playeridx = " & delpidx
'			Call db.execSQLRs(SQL , null, ConStr)
'		Else
'			If CDbl(tp1) > CDbl(pt2) Then
'				SQL = "update  tblPlayer Set sdpoint = sdpoint - " &pt1 & " where Playeridx = " & delpidx
'				Call db.execSQLRs(SQL , null, ConStr)
'			Else
'				SQL = "update  tblPlayer Set sdpoint = sdpoint - " &pt2 & " where Playeridx = " & delpidx
'				Call db.execSQLRs(SQL , null, ConStr)
'			End if
'		End if
'	rs.movenext
'	Loop
'	
'
'
'
'
'Case  "20104" '원스타  (승급시, teamgb, belongBoo변경)
'	SQL = "select   a.Playeridx, a.getpoint as pt1 , isnull(b.getpoint,0) as pt2  from sd_TennisRPoint_log as a left join sd_TennisRPoint_log as b "
'	SQL = SQL & " ON a.titleIDX = b.titleIDX  and (b.teamGb = '20105' and a.PlayerIDX = b.PlayerIDX)  where a.titleIDX =  " & tidx & " and a.teamGb = '" & Left(levelno,5) & "' "
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'	Do Until rs.eof
'		delpidx = rs("playeridx")
'		pt1 = rs(1) 
'		pt2 = rs(2)
'
'		If CDbl(pt2) = 0 then
'			SQL = "update  tblPlayer Set sdpoint = sdpoint - " &pt1 & " where Playeridx = " & delpidx
'			Call db.execSQLRs(SQL , null, ConStr)
'		Else
'			If CDbl(tp1) > CDbl(pt2) Then
'				SQL = "update  tblPlayer Set sdpoint = sdpoint - " &pt1 & " where Playeridx = " & delpidx
'				Call db.execSQLRs(SQL , null, ConStr)
'			Else
'				SQL = "update  tblPlayer Set sdpoint = sdpoint - " &pt2 & " where Playeridx = " & delpidx
'				Call db.execSQLRs(SQL , null, ConStr)
'			End if
'		End if
'	rs.movenext
'	Loop
'
'
'
'Case Else
'	SQL = "select   Playeridx, getpoint  from sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = '" & Left(levelno,5) & "' "
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	Do Until rs.eof
'		delpidx = rs("playeridx")
'		pt = rs("getpoint") 
'
'			SQL = "update  tblPlayer Set sdpoint = sdpoint - " &pt & " where Playeridx = " & delpidx
'			Call db.execSQLRs(SQL , null, ConStr)
'	rs.movenext
'	Loop
'
'End Select 
'
'
'
'
'
''renk info 삭제
'SQL = "Delete from  sd_TennisRPoint_log where titleIDX = " & tidx & " and teamGb = " & Left(levelno,5) & " and rankno <=  32 and adminINdata = 'N'  " '사람이 수동으로 넣은데이터는 지워지지않게
'Call db.execSQLRs(SQL , null, ConStr)
'
'
'
'
'Call oJSONoutput.Set("result", "0" )
'strjson = JSON.stringify(oJSONoutput)
'Response.Write strjson
'
'db.Dispose
'Set db = Nothing
%>