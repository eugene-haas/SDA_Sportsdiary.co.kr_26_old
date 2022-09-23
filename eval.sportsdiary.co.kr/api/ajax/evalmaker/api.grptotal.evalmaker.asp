<%
'#############################################
'구룹별 기준총합
'#############################################
	'request
	EvalTableIDX = oJSONoutput.get("TIDX") 'EvalTableIDX 현재진행중인 평가

		

	Set db = new clsDBHelper

	'공통코드
	fld = " EvalCodeIDX,EvalCateCD,EvalCateNm,EvalSubCateCD,EvalSubCateNm,EvalItemCD,EvalItemNm "
	SQL = "select "&fld&" from tblEvalCode where delkey = 0 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrP = rs.GetRows()
	End If	
	Set rs = nothing

	SQL = "Select EvalGroupNm, Sum(StandardPoint) As sum_point From tblEvalItemTypeGroup Where DelKey = 0 And EvalTableIDX = "&EvalTableIDX
	SQL = SQL & "  and EvalItemTypeIDX in ( select EvalItemTypeIDX from tblEvalItemType where DelKey = 0 And EvalTableIDX ="&EvalTableIDX&" and EvalTypeCD < 100) "
	SQL = SQL & " group by EvalGroupCD,EvalGroupNm "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	if not rs.eof then
		arrR = rs.GetRows()
		msg = "각그룹총합"&vbLf&vbLf
		For ari = LBound(arrR, 2) To UBound(arrR, 2)
				gnm = arrR(0, ari)
				gcnt = arrR(1, ari)

				msg = msg & gnm & ":" & gcnt & vbLf
		next	

		Call oJSONoutput.Set("result", 111 )
		Call oJSONoutput.Set("servermsg", msg )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End	
	else
		Call oJSONoutput.Set("result", 111 )
		Call oJSONoutput.Set("servermsg", "기본점수가 입력된 항목이 없습니다." )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End	
	end if

	db.Dispose
	Set db = Nothing
%>
