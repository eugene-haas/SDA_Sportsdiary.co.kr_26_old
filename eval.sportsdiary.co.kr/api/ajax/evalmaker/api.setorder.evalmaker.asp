<%
'#############################################
' 3항목소팅
'#############################################
	'request
	itemidx2 = oJSONoutput.Get("IIDX2") '3댑스 itemidx 2댑스 
	itemidx = oJSONoutput.Get("IIDX") '3댑스 itemidx
	setval = oJSONoutput.Get("SETVAL") '변경값
	defval = oJSONoutput.Get("DEFVAL") '처음값

	'3단계순서변경

	'select 해서 아래정보 가져온다.
	Set db = new clsDBHelper
	
	'대상테이블 tblEvalItem.orderno, tblEvalItemtype.itemorderno
	'1.소팅번호 재설정
	'2.소팅번호 변경
	
	itemcntfld = ", (select count(*) from tblEvalItem where delkey = 0 and EvalTableIDX= a.EvalTableIDX and EvalCateCD = a.EvalCateCD and EvalSubCateCD = a.EvalSubCateCD and EvalItemCD > 0) as cnt "
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


		if Cdbl(f_itemcnt) > 1 and Cdbl(setval) <= Cdbl(f_itemcnt)  then
			'소팅번호 다시 생성하고 A 3단계, item과 itemtype 제정의
			SQL = " UPDATE A  SET A.OrderNo = A.RowNum FROM ( Select OrderNo,rank() over(Order By OrderNo asc) As rowNum From tblEvalItem where delkey=0 and EvalTableIDX= "&f_tableidx&" and EvalCateCD = "&f_CDA&" and EvalSubCateCD = "&f_CDB&" and EvalItemCD > 0 ) as A "
			SQL = SQL & "	UPDATE B  SET B.itemOrderNo = B.RowNum FROM ( Select itemOrderNo,rank() over(Order By itemOrderNo asc) As rowNum From tblEvalItemtype where delkey=0 and EvalTableIDX= "&f_tableidx&" and EvalCateCD = "&f_CDA&" and EvalSubCateCD = "&f_CDB&" and EvalItemCD > 0 ) as B "
			Call db.execSQLRs(SQL , null, ConStr)
'response.write SQL
'response.end

			'소팅번호 바꾸기
			SQL = "update tblEvalItem set orderno = "&defval&" where delkey=0 and evalitemidx in "
			SQL = SQL & " (select top 1 evalitemidx from tblEvalItem where delkey=0 and EvalTableIDX= "&f_tableidx&" and EvalCateCD = "&f_CDA&" and EvalSubCateCD = "&f_CDB&" and EvalItemCD > 0 and orderno = "&setval & ")"
			
			SQL = SQL & " update tblEvalItemtype set itemorderno = "&defval&" where delkey=0 and evalitemidx in "
			SQL = SQL & " (select evalitemidx from tblEvalItem where delkey=0 and EvalTableIDX= "&f_tableidx&" and EvalCateCD = "&f_CDA&" and EvalSubCateCD = "&f_CDB&" and EvalItemCD > 0 and orderno = "&setval & ")"			

			SQL = SQL & " update tblEvalItem set orderno = "&setval&" where delkey=0 and evalitemidx =" & itemidx
			SQL = SQL & " update tblEvalItemtype set itemorderno = "&setval&" where delkey=0 and evalitemidx =" & itemidx			
			Call db.execSQLRs(SQL , null, ConStr)
		

' response.write SQL
' response.end

		end if

	else
		Call oJSONoutput.Set("result", 111 )
		Call oJSONoutput.Set("servermsg", "항목이 존재하지 않습니다." )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End			
	End If


	
	
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
