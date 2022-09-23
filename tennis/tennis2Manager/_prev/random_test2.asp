<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	totcnt = Request("totcnt")
	
	chkSQL = "SELECT TOP 10 UserName FROM tblPlayer  order by newid()"
	Set CRs = Dbcon.Execute(ChkSQL)


	If Not (CRs.Eof Or CRs.Bof) Then 

		Response.Write "<tr>"		
			Do Until CRs.Eof 
%>
	<td><input type="text" name="aaa" value="<%=CRs("UserName")%>"></td>

<%
				CRs.MoveNext
			Loop 
		Response.Write "</tr>"
	End If 
%>