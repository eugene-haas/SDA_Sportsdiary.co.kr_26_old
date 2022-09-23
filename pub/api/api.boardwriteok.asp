<%
	'로그인체크

	'request 처리##############
'	search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
'	pagec = chkInt(chkReqMethod("pagec", "GET"), 1)
'	tid = chkInt(chkReqMethod("tid", "GET"), 0)
'	title = chkLength(chkStrRpl(chkReqMethod("title", ""), ""), 200) 'chkStrReq 막음 chkStrRpl replace
'	search_first = chkInt(chkReqMethod("search_first", "POST"), 0)
'	page = iif(search_first = "1", 1, page)
	
	title = oJSONoutput.value("TITLE") 
	contents = oJSONoutput.value("CON") 

	title = chkStrRpl(title, "") 
	contents = chkStrRpl(contents, "") 
	CMT = chkStrRpl(CMT, "")
	tid = 0
	pagec = 1
	myref = ""
	'MD = chkInt(MD , 3)
	'myref		= $_POST['ref'];
	'mystep		= $_POST['step'];
	'mylevel		= $_POST['level'];
	
	'request 처리##############

	ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper


	strTableName = " __wboardS "
	SQL = "Select MAX(num) from " & strTableName & " where  tid = " & tid
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If IsNULL(rs(0)) Then
		number = 1
	else 
		number = rs(0) + 1
	End If

	rs.Close
	set rs = nothing

	if  myref <> "" then '즉 답변쓰기라면
		SQL = "update " & strTableName & " set re_step = re_step+1 where ref=" & myref & " and re_step > " & mystep & " and tid = " & tid


		Call db.execSQLRs(SQL , null, ConStr)

		mystep		= cdbl(mystep) + 1
		mylevel 	= cdbl(mylevel) + 1

	else ' 첨 글쓰기라면...
		myref		= number
		mystep		= 0
		mylevel	= 0
	end if


	field = "tid,id,ip,title,contents,num,ref,re_step,re_level"

	'저장
 	SQL = "INSERT INTO "& strTableName &" ("&field&") VALUES "
	SQL = SQL & "(" & tid
	SQL = SQL & ",'" & id & "'"
	SQL = SQL & ",'" & USER_IP & "'"
	SQL = SQL & ",'" & title & "'"
	SQL = SQL & ",'" & contents & "'"
	SQL = SQL & "," & number	
	SQL = SQL & "," & myref
	SQL = SQL & "," & mystep
	SQL = SQL & "," & mylevel & ")"
	Call db.execSQLRs(SQL , null, ConStr)


	jstr = "{""result"":""0"",""pagec"":"""&pagec&"""}"
	Response.write jstr

	db.Dispose
	Set db = Nothing
%>