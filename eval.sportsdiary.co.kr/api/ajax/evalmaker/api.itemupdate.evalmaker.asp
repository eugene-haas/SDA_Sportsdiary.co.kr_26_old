<%
'#############################################
' 1항목소팅
'#############################################
	'request
	itemidx = oJSONoutput.Get("IIDX") '3댑스 itemidx  
	itemtitle = oJSONoutput.Get("INM") '변경값
		
	Set db = new clsDBHelper
	

	fld = " EvalTableIDX,EvalCateCD,EvalSubCateCD,EvalItemCD "
	SQL = "Select "&fld&" from tblEvalItem as a where  EvalItemIDX = " & itemidx 
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If rs.EOF Then
		Call oJSONoutput.Set("result", 111 )
		Call oJSONoutput.Set("servermsg", "항목이 존재하지 않습니다." )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End			
	end if



		f_tableidx = rs(0)
		f_CDA = rs(1)
		f_CDB = rs(2)
		f_CDC = rs(3)

		'수정모드 확인
		Call chkEndMode(f_tableidx, oJSONoutput,db,ConStr)



		SQL = " UPDATE tblEvalItem set EvalItemNm = '"&itemtitle&"' where  EvalItemIDX = " & itemidx 
		SQL = SQL & " UPDATE tblEvalItemType set EvalItemNm = '"&itemtitle&"' where  EvalItemIDX = " & itemidx 
		SQL = SQL & " UPDATE tblEvalCode set EvalItemNm = '"&itemtitle&"' where EvalCateCD = "&f_CDA&" and EvalSubCateCD = "&f_CDB&" and EvalItemCD = "&f_CDC&" "  
		Call db.execSQLRs(SQL , null, ConStr)


	
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
