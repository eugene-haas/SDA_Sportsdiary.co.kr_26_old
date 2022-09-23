<!--#include file="../dev/dist/config.asp"-->
<%
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
<select name="Search_GameTitleIDX" id="Search_GameTitleIDX" style="width:70%;">
	<option value="">=대회선택=</option>
	<%
			GSQL = "SELECT GameTitleIDX,'['+convert(nvarchar,convert(date,GameS),11)+'~]'+GameTitleName GameTitleName "
			GSQL = GSQL & " from sd_TennisTitle  "
			GSQL = GSQL & " where   DelYN='N' and GameYear='"&get_year&"' and stateNo>=5 and MatchYN='Y' and ViewState='Y'"
			GSQL = GSQL & " ORDER BY GameS DESC"
			
			Set GRs = Dbcon.Execute(GSQL)
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