<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	Search_Text = fInject(request("Search_Text"))

	If Search_Text = "" Then 
		Response.End
	End If 


	CSQL = "SELECT "
  CSQL = CSQL &" Count(UserID) AS Cnt "
	CSQL = CSQL &" FROM SportsDiary.dbo.tblPlayer "
	CSQL = CSQL &" WHERE "
	CSQL = CSQL &" UserID ='"&Search_Text&"'" 	

	Set CRs = Dbcon.Execute(CSQL)
	'Response.Write CSQL
	
	
	Dbclose()

	If CRs("Cnt") > 0  Then 
%>
	<tr>
		<td colspan="2">이미 사용중인 아이디 입니다.</td>
	</tr>
<%
	Else
%>
	<tr>
		<th scope="row"><a href="javascript:chk_sch('<%=Search_Text%>')" class="btn-list type2">선택 <i class="fa fa-caret-right" aria-hidden="true"></i></a></th>
		<td>(<b><%=Search_Text%></b>) 사용가능한 아이디 입니다.</td>
	</tr>
<%
	End If 

	CRs.Close
	Set CRs = Nothing

%>