<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	IDX          = fInject(Request("IDX"))
	MatNum       = fInject(Request("MatNum"))
	GameDay      = fInject(Request("GameDay"))


	'선택체급 업데이트
	If IDX <> ""  Then 
	USQL = "UPDATE Sportsdiary.dbo.tblDayList_Temp"
	USQL = USQL&" SET MatNum='"&MatNum&"'"
	USQL = USQL&" WHERE IDX='"&IDX&"'"

	Dbcon.Execute(USQL)
	
	End If 


	CSQL = "SELECT MatNum,Sum(GameCnt) AS GameCnt"
	CSQL = CSQL&" FROM Sportsdiary.dbo.tblDayList_Temp "
	CSQL = CSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
	CSQL = CSQL&" AND GameDay='"&GameDay&"'"
	CSQL = CSQL&" and IsNull(MatNum,'') <> ''"
	CSQL = CSQL&" Group By MatNum"

'	Response.Write CSQL
'	Response.End

	Set CRs = Dbcon.Execute(CSQL)
	'업데이트후 카운트 체크
	If Not (CRs.Eof Or CRs.Bof) Then 
		totcnt = 0
		Do Until CRs.Eof 
%>
		<td><%=CRs("MatNum")%>매트</td>
		<td><%=CRs("GameCnt")%></td>
<%
			totcnt = totcnt + CInt(CRs("GameCnt"))
			CRs.MoveNext
		Loop 
%>
		<td>총:<%=totcnt%>경기</td>
<%
	Else
%>
	<td></td>
<%
	End If 

%>