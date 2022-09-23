<%
'#############################################
' 세부항목별로 단계별 삭제
'#############################################
	'request
	itemidx2 = oJSONoutput.Get("IIDX2") '3댑스 itemidx 2댑스 
	itemidx = oJSONoutput.Get("IIDX") '3댑스 itemidx


	'select 해서 아래정보 가져온다.
	Set db = new clsDBHelper
	
	itemcntfld = ", (select count(*) from tblEvalItem where delkey = 0 and EvalCateCD = a.EvalCateCD and EvalSubCateCD = a.EvalSubCateCD and EvalItemCD > 0 and EvalItemCD <> a.EvalItemCD) as cnt "

	fld = " EvalTableIDX,  EvalCateCD,EvalSubCateCD " & itemcntfld
	SQL = "Select "&fld&" from tblEvalItem as a where  EvalItemIDX = " & itemidx
	 'response.write SQL
	' response.end

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		f_tableidx = rs(0)
		f_CDA = rs(1)
		f_CDB = rs(2)
		f_itemcnt = rs(3)

		'수정모드 확인
		Call chkEndMode(f_tableidx, oJSONoutput,db,ConStr)

	else
		Call oJSONoutput.Set("result", 111 )
		Call oJSONoutput.Set("servermsg", "항목이 존재하지 않습니다." )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End			
	End If




	SQL = ""
	'1단계
	if Cstr(f_itemcnt) = "0" then
		SQL = SQL & " update tblEvalItem set delkey = 1 where delkey = 0 and EvalCateCD = "&f_CDA&" and EvalSubCateCD = 0 "
	end if
	'2단계
	if Cstr(f_itemcnt) = "0" then
		SQL = SQL & " update tblEvalItem set delkey = 1 where delkey = 0 and EvalCateCD = "&f_CDA&" and EvalSubCateCD = "&f_CDB&" and EvalItemCD = 0 "
	end if
	'3단계
	SQL = SQL & " update tblEvalItem set delkey = 1 where EvalItemIDX = " & itemidx

	'4단계
	'삭제목록 	'tblEvalItemtype	'tblEvalItemTypeGroup	'tblEvalMember	'tblEvalValue
	SQL = SQL & " update tblEvalItemtype set delkey = 1 where EvalItemIDX = " & itemidx
	SQL = SQL & " update tblEvalItemTypeGroup set delkey = 1 where EvalItemIDX = " & itemidx
	SQL = SQL & " update tblEvalMember set delkey = 1 where EvalItemIDX = " & itemidx
	SQL = SQL & " update tblEvalValue set delkey = 1 where EvalItemIDX = " & itemidx
	SQL = SQL & " update tblEvalDesc set delkey = 1 where EvalItemIDX = " & itemidx
	Call db.execSQLRs(SQL , null, ConStr)

	'항목카운트 총합 저장
	call setItemsTotal(f_tableidx,db, Constr)

	
	Call oJSONoutput.Set("CNT", f_itemcnt )
	Call oJSONoutput.Set("TIDX", f_tableidx )
	Call oJSONoutput.Set("CDA", f_CDA )
	Call oJSONoutput.Set("CDB", f_CDB )
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson




	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
