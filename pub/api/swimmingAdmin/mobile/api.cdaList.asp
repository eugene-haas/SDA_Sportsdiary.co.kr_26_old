<%
'#############################################
'CDA 생성 부별 종목 리스트
'#############################################
	Set db = new clsDBHelper

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = fInject(oJSONoutput.TIDX)
	End if
	If hasown(oJSONoutput, "CDA") = "ok" then
		cda = fInject(oJSONoutput.CDA)
	End If

	If hasown(oJSONoutput, "GUBUN") = "ok" then
		gubun = fInject(oJSONoutput.GUBUN)
	End If

	If hasown(oJSONoutput, "SHOWTYPE") = "ok" then
		showtype = fInject(oJSONoutput.SHOWTYPE)
	End if	


	fld =  " RGameLevelidx,GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno " 
	strSort = "  ORDER BY itgubun,cdc,sexno"
	strWhere = " a.GameTitleIDX = "&tidx&" and a.CDA = '"&cda&"' and a.DelYN = 'N' "

	SQL = "Select " & fld & " from tblRGameLevel as a where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If rs.eof Then
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	else
		fr = rs.GetRows()
	End if	

	Set rs = Nothing
	db.Dispose
	Set db = Nothing	



'   (tidx,findstr,showtype,unm,pidx)

Select Case SHOWTYPE 
Case "att" '참가신청
	fncname = "getAttMember"
Case "0" '대회결과
	fncname = "getMachTable"
Case "tbl" '대진표
	fncname = "getMachTable"
Case Else 
	fncname = "getMachTable"
End Select 
%>


<!-- #<%=SHOWTYPE%># -->
<select id="cdbc"  class="drow-con__search__box-selc__selc" onchange="mx.<%=fncname%>('<%=tidx%>',$(this).val())">
	<option value=""  selected>::부또는 그룹을 선택해주십시오.::</option>
<%
		If IsArray(fr) Then 
			For ari = LBound(fr, 2) To UBound(fr, 2)

				l_idx = fr(0, ari) 'idx
				l_tidx = fr(1, ari)
				l_gbidx= fr(2, ari)
				l_ITgubun= fr(4, ari)
				l_CDA= fr(5, ari)
				l_CDANM= fr(6, ari)
				l_CDB= fr(7, ari)
				l_CDBNM= fr(8, ari)
				l_CDC= fr(9, ari)
				l_CDCNM= fr(10, ari)
				l_levelno= fr(11, ari)

				Select Case SHOWTYPE 
				Case "att"
				%><option value="<%=l_ITgubun%>_<%=l_levelno%>" ><%=l_CDBNM&" " & l_CDCNM%></option><%
				Case "tbl"
				%><option value="<%=l_idx%>_<%=l_levelno%>" ><%=l_CDBNM&" " & l_CDCNM%></option><%
				Case Else
				%><option value="<%=l_idx%>_<%=l_levelno%>" ><%=l_CDBNM&" " & l_CDCNM%></option><%				
				End Select 
			Next 
		End if
%>
</select>	

