<%
'#############################################

'상세종목 불러오기

'#############################################
	'request
	If hasown(oJSONoutput, "GBCD") = "ok" Then
		gbcd = oJSONoutput.GBCD
	End if

	sel_it = oJSONoutput.Get("ITCD") '개인단체
	sel_sex = oJSONoutput.Get("SEX") '남자여자
	




	Set db = new clsDBHelper
	Select Case gbcd
	Case "D2"
		SQL = "Select  teamgb,teamgbnm,pteamgb  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and  pteamgb = 'D2'  and  teamgb not in ('31','32','33','34','35','41','42')    and cd_mcnt = '"&sel_it&"'  order by orderby asc"
	Case "E2"
		SQL = "Select  teamgb,teamgbnm,pteamgb  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and  (pteamgb = 'E2' or (  pteamgb = 'D2'  and  teamgb  in ('31','32','33','34','35','41','42') ))  and cd_mcnt = '"&sel_it&"'  order by orderby asc"
	Case "F2"
		SQL = "Select  teamgb,teamgbnm,pteamgb  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and  pteamgb = 'F2'  and cd_mcnt = '"&sel_it&"'  order by orderby asc"
	End Select 
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
				%><option value="<%=f(0, ari)%>" ><%=f(2,ari)%>: <%=f(1, ari)%></option><%
			Next 
		End if
	%>
</select>