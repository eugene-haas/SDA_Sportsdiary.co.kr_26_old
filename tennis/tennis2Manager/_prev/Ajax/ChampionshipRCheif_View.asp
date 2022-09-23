<!--#include virtual="/Manager_Wres/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	'strtp = "N"
	'strkey = "194"
	ViewCnt = "20"

	'조회조건 데이터
	Search_GameYear				= fInject(Request("Search_GameYear"))
	Search_GameTitleName	= fInject(Request("Search_GameTitleName"))
	Search_CheifName			= fInject(Request("Search_CheifName"))
	Search_Sido						= fInject(Request("Search_Sido"))
	Search_StadiumNumber	= fInject(Request("Search_StadiumNumber"))
	

	WSQL = ""

	If Search_GameYear <> "" Then 
		WSQL = WSQL&" AND B.GameYear = '"&Search_GameYear&"'"
	End If 

	If Search_GameTitleName <> "" Then 
		WSQL = WSQL&" AND B.GameTitleName like '%"&Search_GameTitleName&"%'"
	End If 

	If Search_CheifName <> "" Then 
		WSQL = WSQL&" AND A.UserName like '%"&Search_CheifName&"%'"
	End If 

	If Search_Sido <> "" Then 
		WSQL = WSQL&" AND A.Sido like '%"&Search_Sido&"%'"
	End If 

	If Search_StadiumNumber <> "" Then 
		WSQL = WSQL&" AND A.StadiumNumber='"&Search_StadiumNumber&"'"
	End If 


	LSQL = "SELECT Top "&ViewCnt
	LSQL = LSQL&" RCheifIDX, GameTitleName, CheifLevel, UserName, Sportsdiary.dbo.FN_SidoName(A.Sido, A.SportsGb) AS CheifSidoName, GameDate, "
	LSQL = LSQL&" RIGHT('0000000' + CONVERT(NVARCHAR,ISNULL(A.GametitleIDX,0)),7) + ISNULL(A.GameDate,'0000-00-00') +  RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.CheifLevel,0)),4) AS NextKey,"
	LSQL = LSQL&" A.StadiumNumber, SportsDiary.dbo.FN_PubName(CheifType) AS CheifType"
	LSQL = LSQL&" FROM tblRCheif A"
	LSQL = LSQL&" INNER JOIN tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX"
	LSQL = LSQL&" WHERE A.SportsGb = 'wres'"
	LSQL = LSQL&" AND A.DelYN = 'N'"
	LSQL = LSQL&" AND B.DelYN = 'N'"


	If Trim(strkey) <> "" Then 
		LSQL = LSQL&" AND RIGHT('0000000' + CONVERT(NVARCHAR,ISNULL(A.GametitleIDX,0)),7) + ISNULL(A.GameDate,'0000-00-00') +  RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.CheifLevel,0)),4) > '" & strkey & "'"
	End If 

	LSQL = LSQL& WSQL
	LSQL = LSQL&" ORDER BY RIGHT('0000000' + CONVERT(NVARCHAR,ISNULL(A.GametitleIDX,0)),7) , ISNULL(A.GameDate,'0000-00-00'),  RIGHT('0000' + CONVERT(NVARCHAR,ISNULL(A.CheifLevel,0)),4)"


	CntSQL = "SELECT COUNT(*) AS Cnt"
	CntSQL = CntSQL&" FROM tblRCheif A"
	CntSQL = CntSQL&" INNER JOIN tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX"
	CntSQL = CntSQL&" WHERE A.SportsGb = 'wres'"
	CntSQL = CntSQL&" AND A.DelYN = 'N'"
	CntSQL = CntSQL&" AND B.DelYN = 'N'"
	CntSQL = CntSQL& WSQL

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
		<th scope="row" style="cursor:pointer;" onclick="input_data('<%=LRs("RCheifIDX")%>');"><%=LRs("GameTitleName")%></th>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("RCheifIDX")%>');"><%=LRs("CheifLevel")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("RCheifIDX")%>');"><%=LRs("StadiumNumber")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("RCheifIDX")%>');"><%=LRs("UserName")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("RCheifIDX")%>');"><%=LRs("CheifType")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("RCheifIDX")%>');"><%=LRs("CheifSidoName")%></td>
		<td class="left" style="cursor:pointer;" onclick="input_data('<%=LRs("RCheifIDX")%>');" ><%=LRs("GameDate")%></td>
	</tr>		
<%
				'다음조회를 위하여 키를 생성한다.
				strsetkey = LRs("NextKey")
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
