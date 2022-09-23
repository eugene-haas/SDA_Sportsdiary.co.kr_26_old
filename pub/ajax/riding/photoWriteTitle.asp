<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
  Set db = new clsDBHelper
	get_year = request("get_year")
%>
<META http-equiv="Expires" content="-1">
<META http-equiv="Pragma" content="no-cache">
<META http-equiv="Cache-Control" content="No-Cache">
<%
	Response.Expires = 0
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Cache-Control","no-cache,must-revalidate"
%>
<select name="Search_GameTitleIDX" class="form-control form-control-half" style="width:250pt;">
	<option value="">=대회선택=</option>
	<%
			GSQL = "SELECT GameTitleIDX,'['+convert(nvarchar,convert(date,GameS),11)+'~]'+GameTitleName GameTitleName "
			GSQL = GSQL & " from sd_TennisTitle  "
			GSQL = GSQL & " where   DelYN='N' and GameYear='"&get_year&"' "
			GSQL = GSQL & " ORDER BY GameS DESC"

			Set GRs = db.ExecSQLReturnRS(GSQL , null, ConStr)
			If Not(GRs.Eof Or GRs.Bof) Then
				Do Until GRs.Eof
					%>
					<option value="<%=GRs("GameTitleIDX")%>" <%If CStr(GRs("GameTitleIDX")) = CStr(GameTitleIDX) Then %>selected<%End If%>><%=GRs("GameTitleName")%></option>
					<%
					GRs.MoveNext
				Loop
			End If
	%>
</select>
