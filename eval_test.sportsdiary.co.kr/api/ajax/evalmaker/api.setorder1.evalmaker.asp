<%
'#############################################
' 1항목소팅
'#############################################
	'request
	itemidx = oJSONoutput.Get("IIDX2") '3댑스 itemidx 2댑스 
	setval = oJSONoutput.Get("SETVAL") '변경값
	defval = oJSONoutput.Get("DEFVAL") '처음값

	
	Set db = new clsDBHelper
	
	'대상테이블 tblEvalItem.orderno
	'1.소팅번호 재설정
	'2.소팅번호 변경
	
	itemcntfld = ", (select count(*) from tblEvalItem where delkey = 0 and EvalTableIDX= a.EvalTableIDX and EvalCateCD >0 and EvalSubCateCD =0 and EvalItemCD = 0) as cnt "
	itemidx1fld = ", (select evalitemidx from tblEvalItem where delkey = 0 and EvalTableIDX= a.EvalTableIDX and EvalCateCD = a.EvalCateCD and EvalSubCateCD =0 and EvalItemCD = 0) as itemidx "
	fld = " EvalTableIDX,  EvalCateCD,EvalSubCateCD " & itemcntfld & itemidx1fld
	
	SQL = "Select "&fld&" from tblEvalItem as a where  EvalItemIDX = " & itemidx 
	'response.write SQL
	'response.end

	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		f_tableidx = rs(0)
		f_CDA = rs(1)
		f_CDB = rs(2)
		f_itemcnt = rs(3)
		f_itemidx = rs(4)



		'수정모드 확인
		Call chkEndMode(f_tableidx, oJSONoutput,db,ConStr)

		if Cdbl(f_itemcnt) > 1 and Cdbl(setval) <= Cdbl(f_itemcnt)  then
			'소팅번호 다시 생성하고 1단계 item, itemtype제정의
			SQL = " UPDATE A  SET A.OrderNo = A.RowNum FROM ( Select OrderNo,rank() over(Order By OrderNo asc) As rowNum From tblEvalItem where delkey=0 and EvalTableIDX= "&f_tableidx&" and EvalCateCD >0 and EvalSubCateCD = 0 and EvalItemCD = 0 ) as A "
			SQL = SQL & "	UPDATE B  SET B.CateOrderNo = B.RowNum FROM ( Select CateOrderNo,rank() over(Order By CateOrderNo asc) As rowNum From tblEvalItemtype where delkey=0 and EvalTableIDX= "&f_tableidx&" and EvalCateCD >0 and EvalSubCateCD = 0 and EvalItemCD = 0 ) as B "
			Call db.execSQLRs(SQL , null, ConStr)
'response.write SQL
'response.end

			'소팅번호 바꾸기
			SQL = "update tblEvalItem set orderno = "&defval&" where evalitemidx in "
			SQL = SQL & " (select evalitemidx from tblEvalItem where delkey=0 and EvalTableIDX= "&f_tableidx&" and  EvalCateCD >0 and EvalSubCateCD = 0 and EvalItemCD = 0 and orderno = "&setval & ")"

			SQL = SQL & " update tblEvalItemtype set CateOrderNo = "&defval&" where delkey=0 and evalitemidx in "
			SQL = SQL & " (select evalitemidx from tblEvalItem where delkey=0 and EvalTableIDX= "&f_tableidx&" and  EvalCateCD >0 and EvalSubCateCD = 0 and EvalItemCD = 0 and orderno = "&setval & ")"
			
			SQL = SQL & " update tblEvalItem set orderno = "&setval&" where evalitemidx =" & f_itemidx
			SQL = SQL & " update tblEvalItemtype set CateOrderNo = "&setval&" where evalitemidx =" & f_itemidx			
			Call db.execSQLRs(SQL , null, ConStr)
		end if

	else
		Call oJSONoutput.Set("result", 111 )
		Call oJSONoutput.Set("servermsg", "항목이 존재하지 않습니다." )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End			
	End If


	
	
	
	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson




	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
