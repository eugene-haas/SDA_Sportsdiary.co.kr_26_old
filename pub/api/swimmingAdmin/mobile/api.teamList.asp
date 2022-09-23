<%
'#############################################
'팀 참가신청 목록
'#############################################
	Set db = new clsDBHelper

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = fInject(oJSONoutput.TIDX)
	End if
	If hasown(oJSONoutput, "SIDO") = "ok" then
		sido = fInject(oJSONoutput.SIDO)
	End If
	
	If hasown(oJSONoutput, "TEAM") = "ok" then
		team = fInject(oJSONoutput.TEAM)
	End if

	fld = " p1_team,max(p1_teamnm),COUNT(*),max(a.sidonm) as sidonm  "			
	If sido = "" Then
		If team = "" Then
		SQL = "select "&fld&" from tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and a.sido is null  group by a.P1_team order by a.P1_team"
		else
		SQL = "select "&fld&" from tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and a.p1_team = '"&team&"'   group by a.P1_team order by a.P1_team"
		End if
	else
		SQL = "select "&fld&" from tblGameRequest as a left join tblGameRequest_r as b on a.RequestIDX = b.requestIDX and b.delYN = 'N' where a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and a.sido = '"&sido&"'  group by a.P1_team order by a.P1_team"
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Response.write sql
'Response.end

	If rs.eof Then
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	else
		arr = rs.GetRows()
	End if	

	Set rs = Nothing
	db.Dispose
	Set db = Nothing	
%>


<ul class="list_box">
	<%
	If IsArray(arr) Then
		For ari = LBound(arr, 2) To UBound(arr, 2)
			a_P1_TEAM = arr(0, ari)
			a_P1_TEAMNM = arr(1, ari)
			a_tm_count = arr(2,ari)
			%>
			  <li class="list">
				<a href="javascript:mx.getAttList('<%=TIDX%>','<%=a_P1_TEAM%>', this)" class="sl_list"><%=a_P1_TEAMNM%>  <span id="ul_total">Total : <%=a_tm_count%>명</span></a>  
				<p id="<%=a_P1_TEAM%>" style="display:none;"></p>
			  </li>
			<%
		Next 
	End if
	%>
</ul>
