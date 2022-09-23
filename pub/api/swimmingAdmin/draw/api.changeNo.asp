<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then '1 바꾼애
		midx = oJSONoutput.MIDX
	End If
	If hasown(oJSONoutput, "CNGVAL") = "ok" Then '바꿀대상애
		cngval = oJSONoutput.CNGVAL
		If isnumeric(cngval) = False Then
			Call oJSONoutput.Set("result", 5 )
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.end
		End if
	End If
	If hasown(oJSONoutput, "CNGTYPE") = "ok" Then
		cngtype = oJSONoutput.CNGTYPE
	End if



	Set db = new clsDBHelper

	'startType 시작이 예선인지 본선인지 (1, 3)
	fld = " gameMemberIDX,tryoutgroupno,tryoutsortNo, 	gametitleidx,gbidx,levelno  "
	SQL = "select "&fld&" from SD_gameMember where gameMemberIDX  = '"&midx&"' "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrR = rs.GetRows()
		tidx  = arrR(3,0)
		lno  = arrR(5,0)

		SQL = "update sd_gameMember set gubun = '0' where gametitleidx =  '"&tidx&"' and levelno = '"&lno&"' and delyn = 'N' "
		'Response.write sql
		'Response.end
		Call db.execSQLRs(SQL , null, ConStr)
	End If


	If IsArray(arrR) Then
		For ari = LBound(arrR, 2) To UBound(arrR, 2) - namergi '나누어 떨어지는 명수 가지만 우선 넣자.
			midx =  arrR(0,ari)  'midx
			gno = arrR(1,ari) '조번호(넣을곳)
			raneno = arrR(2,ari) '레인번호(넣을곳)
			tidx = arrR(3,ari)
			gbidx = arrR(4, ari)


			strwhere = " delyn = 'N' and gametitleidx = "&tidx&" and gbidx = "&gbidx&"  "
			SQL = "select max(tryoutsortNo) from SD_gameMember where " & strwhere
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			maxno = rs(0)

			'범위안에서
			If CDbl(cngval) > CDbl(maxno) then
				Call oJSONoutput.Set("result", 5 )
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.end
			End if

			SQL = " update  SD_gameMember set tryoutsortNo = "&raneno&"  where " & strwhere & " and tryoutsortNo = "&cngval&" "
			SQL = SQL & " update  SD_gameMember set tryoutsortNo = "&cngval&"  where gameMemberidx = " & midx
			Call db.execSQLRs(SQL , null, ConStr)


		Next
	End if



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
