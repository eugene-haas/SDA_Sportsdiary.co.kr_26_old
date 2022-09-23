<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
  SQL = "SELECT o.name , (SELECT value FROM sys.extended_properties WHERE major_id = o.id and minor_id = 0 )   FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY o.name asc"
  'SQL = "SELECT o.name , i.rows  FROM   sysindexes i INNER JOIN sysobjects o ON i.id = o.id WHERE  i.indid < 2  AND o.xtype = 'U' ORDER BY o.name asc"
  'Response.write SQL & "</BR>"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
 
	If Not rs.EOF Then 
		arr = rs.GetRows()
	End if
%>


 <%'View ####################################################################################################%>

<!-- <a href="javascript:mx.deleteForm(null, {'CMD':1});">경기기록 삭제</a><br><br>
<a href="javascript:mx.deleteForm(null, {'CMD':2});">참가신청 삭제</a><br><br>
<a href="javascript:mx.deleteForm(null, {'CMD':3});">대진표참가 삭제</a><br><br>
<a href="javascript:mx.deleteForm(null, {'CMD':4});">참여부 삭제</a><br><br>
<a href="javascript:mx.deleteForm(null, {'CMD':5});">유저 삭제</a><br><br> -->

<!--
<a href="javascript:alert('경기기록 삭제')">경기기록 삭제</a><br><br>
<a href="javascript:alert('참가신청 삭제')" >참가신청 삭제</a><br><br>
<a href="javascript:alert('대진표참가 삭제')" >대진표참가 삭제</a><br><br>
<a href="javascript:alert('참여부 삭제')" >참여부 삭제</a><br><br>
<a href="javascript:alert('유저 삭제')" >유저 삭제</a><br><br>
-->

<br><br><br><br>

<select id="selectTabelList" style="width:auto;"> 
<%
  if(IsArray(arr)) Then
  	For ar = LBound(arr, 2) To UBound(arr, 2) 
      Response.Write "<option value=" & arr(0,ar) & ">" & arr(0,ar) & " ( " &  arr(1,ar) & " )" & "</option>"
    NEXT
  End IF
%>
</select>

<a class="btn" href="javascript:mx.copyTable('selectTabelList')">복사</a>

<a class="btn" href="javascript:mx.deleteTable('selectTabelList')">삭제</a>






<%

Response.end
SQL = "select  max(idx),titleidx,playeridx,max(userName),count(*) as c,getpoint from sd_TennisRPoint_log where ptuse = 'Y' and titleidx > 0 and teamGb in ('20101','20102','20103','20104','20105','20106') group by titleidx,playeridx,getpoint order by 5 desc"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsdrow(rs)
'Response.end

Do Until rs.eof

If CDbl(rs("c")) < 2 Then
	Exit do
End If

	mxidx = rs(0)
	titleidx = rs("titleidx")
	playeridx = rs("playeridx")
	getpoint = rs("getpoint")
	SQL = "select * from sd_TennisRPoint_log where titleidx = " & titleidx & " and  playeridx =  " & playeridx & " and getpoint = "&getpoint & " and teamGbName  in  ('신인부','개나리부')"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	Call rsdrow(rss)

	'SQL = "delete from sd_TennisRPoint_log where titleidx = " & titleidx & " and  playeridx =  " & playeridx & " and getpoint = "&getpoint & " and teamGbName  in  ('신인부','개나리부')"
	'Call db.execSQLRs(SQL , null, ConStr) 
rs.movenext
loop

Response.end
'#####################################################################################
%>









<br><br><br>
임시 <br>

<%
SQL = "select a.UserName,a.PlayerIDX,b.level,b.GameDay from tblPlayer as a inner join tblRGameLevel as b on a.chkTIDX = b.GameTitleIDX   "
SQL = SQL & " inner join tblGameRequest as c on (a.playeridx = c.P1_PlayerIDX or a.PlayerIDX = c.P2_PlayerIDX ) and (c.Level = b.Level or  RIGHT(b.level,3) = '007' ) "
SQL = SQL & " where a.levelup >0 and a.delyn= 'N' and b.DelYN = 'N'  and left(b.Level ,5) in ('20101','20104') or RIGHT(b.level,3) = '007' "
SQL = SQL & "  order by chkTIDX desc, a.UserName asc , b.Level asc "
'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'Call rsDrow(rs)
'Response.end


SQL = "select  PlayerIDX,username,chkTIDX,startrnkdate from tblPlayer  where levelup >0 and chkTIDX > 0 and gameday is null  and  delyn= 'N' order by chkTIDX asc"
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'Call rsDrow(rs)
'Response.end

i = 0
Response.write "<div style=""font-size:20px;"">"
Do Until rs.eof 

	unm = rs("username")
	pidx = rs("playeridx")
	tidx = rs("chkTIDX")
	sdate = rs("startrnkdate")

	SQL = "select top 1 requestIDX,level from tblGameRequest where gametitleidx = '"&tidx&"'  and "
	SQL = SQL & " (P1_PlayerIDX = "&pidx&" or P2_PlayerIDX = "&pidx&")  and delyn='N' and left(Level ,5) in ('20101','20104') "
	Set rs1 = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not  rs1.eof then
		lvl = rs1("level")
		SQL = "select top 1 gameday from tblRGameLevel where gametitleidx = "&tidx &" and level = '"&Left(lvl,5)&"007' "
		Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr)

		If rs2.eof Then
			SQL = "select top 1 gameday from tblRGameLevel where gametitleidx = "&tidx &" and level = '"&lvl&"' "
			Set rs3 = db.ExecSQLReturnRS(SQL , null, ConStr)		
			gameday = rs3(0)
		Else
			gameday = rs2(0)	
		End if

		Response.write pidx &" " & unm & " " & gameday & "("&tidx&")" &"<br>"

		'SQL = "update tblPlayer set gameday = '"&gameday&"' where playerIDX = " & pidx
		'Call db.execSQLRs(SQL , null, ConStr)
	Else

		Response.write pidx  & " " & unm & "("&tidx&")" & " ["&sdate&"]" & " ....<br>"
	End if

Set rs1 = nothing
gameday = ""

i = i + 1
rs.movenext
Loop

Response.write i 
Response.write "</div>"


Response.end


'SQL = SQL & " "
'SQL = SQL & "where a.levelup >0 and a.delyn= 'N' and b.DelYN = 'N'  and left(b.Level ,5) in ('20101','20104') or RIGHT(b.level,3) = '007' order by chkTIDX desc, a.UserName asc , b.Level asc "
'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)







'a.PlayerIDX,a.UserName,a.levelup,a.titlecode,a.dblrnk,a.chkTIDX,a.startrnkdate,b.Level,b.GameDay
SQL = "select a.username,a.PlayerIDX,b.level,b.GameDay from tblPlayer as a inner join tblRGameLevel as b on a.chkTIDX = b.GameTitleIDX   "
SQL = SQL & " inner join tblGameRequest as c on (a.playeridx = c.P1_PlayerIDX or a.PlayerIDX = c.P2_PlayerIDX ) and (c.Level = b.Level or  RIGHT(b.level,3) = '007' ) "
SQL = SQL & "where a.levelup >0 and a.delyn= 'N' and b.DelYN = 'N'  and left(b.Level ,5) in ('20101','20104') or RIGHT(b.level,3) = '007' order by chkTIDX desc, a.UserName asc , b.Level asc "

Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


i =  1
c = 0
Do Until rs.eof 
	unm = rs("username")
	pidx = rs("playeridx")
	gday = rs("gameday")
	blvl = rs("level")

	If i = 1 Or CStr(pidx) = CStr(oldpidx) Then
		If Right(blvl,3) = "007" Then
			prnStr = unm & " " & pidx  & " " & blvl & " " & gday & "<br>"
		Else
			prnStr = unm & " " & pidx  & " " & blvl & " " & gday & "<br>"		
		End if
	Else
		c = c + 1
		Response.write prnstr
		prnStr = unm & " " & pidx  & " " & blvl & " " & gday & "<br>"	
	End if

	'SQL = "update tblPlayer set gameday = '"&gday&"' where playerIDX = " & pidx
	'Call db.execSQLRs(SQL , null, ConStr)

oldpidx = pidx
i = i + 1
rs.movenext
Loop

Response.write c

'SQL = "update tblPlayer_test set gameday = left(CONVERT(VARCHAR, startrnkdate,120),10) where startrnkdate is not null  "
'Call db.execSQLRs(SQL , null, ConStr)
%>


