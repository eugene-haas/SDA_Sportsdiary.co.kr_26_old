<%
'#############################################
'수정
'#############################################
	'request
	If hasown(oJSONoutput, "VAL") = "ok" then
		bgubun = oJSONoutput.VAL
	End if


	Set db = new clsDBHelper


	Select Case bgubun
	Case 	"01"
	%>
	<select id="mk_g0" class="form-control">
		<option value="01" <%If e_gubun = "" Or e_gubun = "01" then%>selected<%End if%>>대통령배</option>
		<option value="02" <%If e_gubun = "02" then%>selected<%End if%>>총리배</option>
		<option value="03" <%If  e_gubun = "03" then%>selected<%End if%>>장관배</option>
	</select>	
	<%
	Case "02"
	%>
	<select id="mk_g0" class="form-control">
		<option value="04" <%If  e_gubun = "04" then%>selected<%End if%>>대한체육회장배</option>
		<option value="09" <%If  e_gubun = "09" then%>selected<%End if%>>기타</option>
	</select>	
	<%
	Case "09"
	%>
	<select id="mk_g0" class="form-control">
		<option value="11" <%If  e_gubun = "11" then%>selected<%End if%>>올림픽</option>
		<option value="12" <%If  e_gubun = "12" then%>selected<%End if%>>아시아경기대회</option>
		<option value="19" <%If  e_gubun = "19" then%>selected<%End if%>>기타(국제)</option>
	</select>	
	<%
	End Select 



	db.Dispose
	Set db = Nothing
%>
