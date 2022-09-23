<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "GBCD") = "ok" Then
		gbcd = oJSONoutput.GBCD
	End if


	Set db = new clsDBHelper

	SQL = "Select  teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and pteamgb = '"&gbcd&"' "
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		f = rss.GetRows()
	End If

	db.Dispose
	Set db = Nothing

%>
<select id="mk_g4" class="form-control">
	<%
		If IsArray(f) Then 
			fldcnt =  UBound(f, 2)
			For ari = LBound(f, 2) To UBound(f, 2)
				%><option value="<%=f(0, ari)%>" ><%=f(1, ari)%></option><%
			Next 
		End if
	%>
</select>