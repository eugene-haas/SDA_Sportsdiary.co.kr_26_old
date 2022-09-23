<%
	ID = oJSONoutput.value("ID")
	NO = oJSONoutput.value("NO")
	
	gubun = Split(ID, "_")
	inout = gubun(0)
	idx = gubun(1)

	Set oClsDBHelper = new clsDBHelper
	SQL = "select  top 1 book_in, book_out,book_idx from  BOOK_LIST_TBL where book_idx = " & idx
	Set rs = oClsDBHelper.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		jstr = "{""result"":""1""}"
		Response.write jstr
		Set rs = Nothing
		Set oClsDBHelper = Nothing
		Response.end
	Else
		curr_in = rs("book_in")
		curr_out = rs("book_out")
		curr_st = CDbl(curr_in - curr_out)
	End If

	Select Case inout
	Case "in"
		book_st = CDbl(NO - curr_out)
		book_in = NO
		book_out = curr_out
		SQL = "update BOOK_LIST_TBL Set book_in = " & Abs(NO) & " where book_idx = " & idx
	Case "out"
		book_st = CDbl(curr_in - NO)
		book_in = curr_in
		book_out = NO
		SQL = "update BOOK_LIST_TBL Set book_out = " & Abs(NO) & " where book_idx = " & idx
	End Select

	If book_st < 0 Then
		JSON.ADD "result", "0"
		JSON.ADD "in", curr_in
		JSON.ADD "out", curr_out
		JSON.ADD "st", curr_st
		JSON.write()
		
		Set rs = Nothing
		Set oClsDBHelper = Nothing
		Response.end
	End if

	Call oClsDBHelper.execSQLRs(SQL , null, ConStr)

	JSON.ADD "result", "0"
	JSON.ADD "in", book_in
	JSON.ADD "out", book_out
	JSON.ADD "st", book_st
	JSON.write()

	Set rs = Nothing
	Set oClsDBHelper = Nothing
%>