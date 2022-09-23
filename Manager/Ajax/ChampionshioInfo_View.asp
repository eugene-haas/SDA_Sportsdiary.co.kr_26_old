<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	'strtp = "N"
	'strkey = "194"
	ViewCnt = "20"

	'조회조건 데이터
	Search_GameYear      = fInject(Request("Search_GameYear"))
	Search_GameTitleName = fInject(Request("Search_GameTitleName"))
	Search_Sido      = fInject(Request("Search_Sido"))
	Search_SidoDtl  = fInject(Request("Search_SidoDtl"))
	

	WSQL = ""

	If Search_GameYear <> "" Then 
		WSQL = WSQL&" AND GameYear = '"&Search_GameYear&"'"
	End If 

	If Search_GameTitleName <> "" Then 
		WSQL = WSQL&" AND GameTitleName like '%"&Search_GameTitleName&"%'"
	End If 

	If Search_Sido <> "" Then 
		WSQL = WSQL&" AND Sido = '"&Search_Sido&"'"
	End If 

	If Search_SidoDtl <> "" Then 
		WSQL = WSQL&" AND SidoDtl like '%"&Search_SidoDtl&"%'"
	End If 

	If Request.Cookies("HostCode") <> "" Then 
		WSQL = WSQL&" AND HostCode='"&Request.Cookies("HostCode")&"'"
	End If 





	LSQL = "SELECT "
  LSQL = LSQL&" Top "&ViewCnt
	LSQL = LSQL&" GameTitleIDX "
	LSQL = LSQL&" ,GameYear "
	LSQL = LSQL&" ,GameS + '~' + GameE AS Game_Date "
	LSQL = LSQL&" ,GameTitleName "
	LSQL = LSQL&" ,SportsDiary.dbo.FN_SidoName(Sido,'judo') AS Sido "
	LSQL = LSQL&" ,GameArea "		
	LSQL = LSQL&" ,Sportsdiary.dbo.FN_PubName(HostCode) AS HostName "
	LSQL = LSQL&" ,Case When ViewYN='Y' Then '노출' When ViewYN='N' Then '미노출' End AS ViewName "
	LSQL = LSQL&" FROM SportsDiary.dbo.tblGameTitle "
	LSQL = LSQL&" WHERE DelYN='N'"
	LSQL = LSQL&" AND SportsGb='judo'"

'Response.Write LSQL
'Response.End
	If Trim(strkey) <> "" Then 
		LSQL = LSQL&" AND GameTitleIDX < " & strkey
	End If 
	LSQL = LSQL&WSQL

	LSQL = LSQL&" ORDER BY GameTitleIDX DESC "	



	CntSQL = "SELECT "
  CntSQL = CntSQL &" Count(GameTitleIDX) AS Cnt "
	CntSQL = CntSQL &" FROM SportsDiary.dbo.tblGameTitle "
	CntSQL = CntSQL &" WHERE DelYN='N'"
	CntSQL = CntSQL&" AND SportsGb='judo'"
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
		<th scope="row" style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>');"><%=LRs("GameTitleIDX")%></th>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>');"><%=LRs("GameYear")%>년</td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>');"><%=LRs("Game_Date")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>');"><%=LRs("HostName")%></td>
		<td class="left" style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>');"><%=LRs("GameTitleName")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>');"><%=LRs("Sido")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>');"><%=LRs("GameArea")%></td>
		<td style="cursor:pointer;" onclick="input_data('<%=LRs("GameTitleIDX")%>');"><%=LRs("ViewName")%></td>
		<td><a href="javascript:view_level('<%=LRs("GameTitleIDX")%>','<%=LRs("GameTitleName")%>','');" class="btn-list type2">체급관리 <i><img src="../images/icon_more_right.png" alt="" /></i></a></td>
	</tr>		
<%
				'다음조회를 위하여 키를 생성한다.
				strsetkey = LRs("GameTitleIDX")
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
