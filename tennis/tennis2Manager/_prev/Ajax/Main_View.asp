<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	'strtp = "N"
	'strkey = "194"


	
	NowYear = Year(Now())

	WSQL = ""


	If NowYear <> "" Then 
		WSQL = WSQL&" AND GameYear>='"&NowYear&"'"
	End If 

	If Request.Cookies("SportsGb") <> "" Then 
		WSQL = WSQL&" AND SportsGb='"&Request.Cookies("SportsGb")&"'"
	End If 



	LSQL = "SELECT "
	LSQL = LSQL&" GameTitleIDX "
	LSQL = LSQL&" ,GameYear "
	LSQL = LSQL&" ,GameS + '~' + GameE AS Game_Date "
	LSQL = LSQL&" ,GameTitleName "
	LSQL = LSQL&" ,SportsDiary.dbo.FN_SidoName(Sido,'"&Request.Cookies("SportsGb")&"') AS Sido "
	LSQL = LSQL&" ,GameArea "		
	LSQL = LSQL&" ,Sportsdiary.dbo.FN_PubName(HostCode) AS HostName "
	LSQL = LSQL&" ,Case When ViewYN='Y' Then '노출' When ViewYN='N' Then '미노출' End AS ViewName "
	LSQL = LSQL&" FROM SportsDiary.dbo.tblGameTitle "
	LSQL = LSQL&" WHERE DelYN='N'"
	LSQL = LSQL&" AND ViewYN = 'Y'"
	


	LSQL = LSQL&WSQL

	LSQL = LSQL&" ORDER BY GameTitleIDX DESC "	



	CntSQL = "SELECT "
  CntSQL = CntSQL &" Count(GameTitleIDX) AS Cnt "
	CntSQL = CntSQL &" FROM SportsDiary.dbo.tblGameTitle "
	CntSQL = CntSQL &" WHERE DelYN='N'"
	CntSQL = CntSQL&" AND ViewYN = 'Y'"

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
		<th scope="col"><%=LRs("GameYear")%>년</th>					
		<th scope="col"><%=LRs("Game_Date")%></th>
		<th scope="col"><%=LRs("HostName")%></th>
		<th scope="col"><%=LRs("GameTitleName")%></th>
		<th scope="col"><%=LRs("Sido")%></th>
		<th scope="col"><%=LRs("GameArea")%></th>
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
