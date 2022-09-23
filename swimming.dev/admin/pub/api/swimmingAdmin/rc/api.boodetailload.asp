<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "GBCD") = "ok" Then
		gbcd = oJSONoutput.GBCD
	End if

	If hasown(oJSONoutput, "ITGUBUN") = "ok" Then
		itgubun = oJSONoutput.ITGUBUN
	End if


	Set db = new clsDBHelper

	Select Case itgubun
	Case ""
	SQL = "Select  teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and pteamgb = '"&gbcd&"'  order by orderby"
	Case "I"
	SQL = "Select  teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and pteamgb = '"&gbcd&"' and orderby < 100 order by orderby"
	Case "T"
	SQL = "Select  teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and pteamgb = '"&gbcd&"' and orderby = 100  order by orderby"	
	End Select
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		f = rss.GetRows()
	End If

	db.Dispose
	Set db = Nothing


			'If USER_IP = "118.33.86.240" Then
			'Response.write aa
			'Response.end
			'End if
%>
<select id="mk_g14" class="form-control">
	<%
		If IsArray(f) Then 
			fldcnt =  UBound(f, 2)
			For ari = LBound(f, 2) To UBound(f, 2)
				%><option value="<%=f(0, ari)%>" ><%=f(1, ari)%>   </option><%
			Next 
		End if
	%>
</select>