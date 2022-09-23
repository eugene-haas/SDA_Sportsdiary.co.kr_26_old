<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	ViewCnt = "20"

	'조회조건 데이터
	Search_Type = fInject(Request("Search_Type"))
	Search_Text = fInject(Request("Search_Text"))

	WSQL = ""

	If Search_Type <> "" And Search_Text<>"" Then 
		If Search_Type = "UserID" Then 
			WSQL = WSQL&" AND UserID like '"&Search_Text&"'"
		ElseIf Search_Type = "UserName" Then 
			WSQL = WSQL&" AND UserName like '"&Search_Text&"'"
		End If 
	End If 

	LSQL = "SELECT "
  LSQL = LSQL&" Top "&ViewCnt
	LSQL = LSQL&" IDX "
	LSQL = LSQL&" ,Sportsdiary.dbo.FN_PubName(SportsGb) AS SportsGbNm "
	LSQL = LSQL&" ,Sportsdiary.dbo.FN_PubName(HostCode) AS HostCodeNm "
	LSQL = LSQL&" ,Sportsdiary.dbo.FN_PubName(UserGubun) AS UserGubun "
	LSQL = LSQL&" ,UserName "
	LSQL = LSQL&" ,UserID "
	LSQL = LSQL&" ,HandPhone "		
	LSQL = LSQL&" ,Case When DelGubun='N' Then '사용중' Else '사용중지' End AS DelGubun "
	LSQL = LSQL&" FROM SportsDiary.dbo.tblUserInfo "
	LSQL = LSQL&" WHERE 1=1"


	If Trim(strkey) <> "" Then 
		LSQL = LSQL&" AND IDX < " & strkey
	End If 
	LSQL = LSQL&WSQL

	LSQL = LSQL&" ORDER BY IDX DESC "	

'Response.Write LSQL
'Response.End

	CntSQL = "SELECT "
  CntSQL = CntSQL &" Count(IDX) AS Cnt "
	CntSQL = CntSQL &" FROM SportsDiary.dbo.tblUserInfo "
	CntSQL = CntSQL &" WHERE 1=1"
	CntSQL = CntSQL &WSQL

'	Response.Write LSQL
'	Response.Write CntSQL
'	Response.End

	Dbopen()
		Set LRs = Dbcon.Execute(LSQL)
		Set CRs = Dbcon.Execute(CntSQL)
	Dbclose()

'다음조회 데이타는 행을 변경한다
	If Strtp = "N" Then 
	End If 

%>
<%
	If LRs.Eof Or LRs.Bof Then 
		Response.Write "null"
		Response.End
	Else 
%>
<%
		intCnt = 0

		Do Until LRs.Eof 
%>
	<tr>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>');"><%=LRs("IDX")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>');"><%=LRs("SportsGbNm")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>');"><%=LRs("UserGubun")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>');"><%=LRs("UserName")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>');"><%=LRs("UserID")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>');"><%=LRs("HostCodeNm")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>');"><%=LRs("HandPhone")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("IDX")%>');"><%=LRs("DelGubun")%></th>
	</tr>
<%
				'다음조회를 위하여 키를 생성한다.
				strsetkey = LRs("IDX")
			 LRs.MoveNext
			intCnt = intCnt + 1
		Loop 
%>
		ㅹ<%=encode(strsetkey,0)%>ㅹ<%=StrTp%>ㅹ<%=Crs("Cnt")%>ㅹ<%=intCnt%>
<%
	End If 
%>
<% LRs.Close
   Set LRs = Nothing
   
   CRs.Close
   Set CRs = Nothing
%>
