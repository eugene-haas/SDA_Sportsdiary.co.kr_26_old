<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	ViewCnt = "1500"

	'조회조건 데이터
	Search_GameYear = fInject(Request("Search_GameYear"))
	Search_GameTitleIDX = fInject(Request("Search_GameTitleIDX"))
	Search_GroupGameGb  = fInject(Request("Search_GroupGameGb"))	
	Search_TeamGb       = fInject(Request("Search_TeamGb"))	
	Search_Sex          = fInject(Request("Search_Sex"))
	'Search_Level        = fInject(Request("Search_Level"))
	'Search_Stadium      = fInject(Request("Search_Stadium"))
	'player              = fInject(Request("player"))
	'Search_Url          = fInject(Request("Search_Url"))
	'GameDay							= fInject(Request("GameDay"))

	WSQL = ""
	CSQL = ""
	
	If Search_GameYear <> "" Then 
		WSQL = WSQL&" AND B.GameYear = '"&Search_GameYear&"'"
	End If 

	If Search_GameTitleIDX <> "" Then 
		WSQL = WSQL&" AND A.GameTitleIDX = '"&Search_GameTitleIDX&"'"
	End If 
	
	If Search_GroupGameGb <> "" Then 
		WSQL = WSQL&" AND A.GroupGameGb = '"&Search_GroupGameGb&"'"
	End If 
	
	If Search_TeamGb <> "" Then 
		WSQL = WSQL&" AND A.TeamGb = '"&Search_TeamGb&"'"
	End If 	

	If Search_Sex <> "" Then 
		WSQL = WSQL&" AND A.Sex = '"&Search_Sex&"'"
	End If 
	
	'If Search_Level <> "" Then 
	'	WSQL = WSQL&" AND A.Level = '"&Search_Level&"'"
	'End If 
	
	'If Search_Stadium <> "" Then 
	'	WSQL = WSQL&" AND ISNULL(A.StadiumNumber,'') = '"&Search_Stadium&"'"
	'End If 
	
	'If player <> "" Then 
	'	CSQL = CSQL&" AND ISNULL(SportsDiary.dbo.FN_PlayerName(A.LPlayerIDX) + ' - ' + SportsDiary.dbo.FN_PlayerName(A.RPlayerIDX),'') LIKE '%"&player&"%'"
	'End If 
	
	'If Search_Url = "Y" Then 
	'	WSQL = WSQL&" AND ISNULL(A.MediaLink,'') <> ''"
	'End If 
	
	'If Search_Url = "N" Then 
	'	WSQL = WSQL&" AND ISNULL(A.MediaLink,'') = ''"
	'End If 

	'If GameDay <> "" Then
	'	WSQL = WSQL&" AND A.GameDay = '" & GameDay & "'"
	'End If
		

	LSQL = " SELECT TOP " & ViewCnt & " SportsDiary.dbo.FN_GameTitleName(A.GameTitleIdx) AS GameTitleNM,"
	LSQL = LSQL & " A.SportsGb,"
	LSQL = LSQL & " A.GameTitleIdx,"
	LSQL = LSQL & " SportsDiary.dbo.FN_TeamGbNm(A.SportsGb, A.TeamGb) AS TeamGbNM,"
	LSQL = LSQL & " A.TeamGb,"
	LSQL = LSQL & " SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbNM,"
	LSQL = LSQL & " A.GroupGameGb,"
	LSQL = LSQL & " A.Sex,"

	LSQL = LSQL & "  RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.GameTitleIDX,0)),5)"
	LSQL = LSQL & "  + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameGb,0)),5)"
	LSQL = LSQL & "  + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TeamGb,0)),5) AS NextKey"

	LSQL = LSQL & " FROM SportsDiary.dbo.tblRGameLevel A"
	LSQL = LSQL & " INNER JOIN SportsDiary.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX"
	LSQL = LSQL & " WHERE A.DelYN = 'N'"
	LSQL = LSQL & " AND B.DelYN = 'N'"
	LSQL = LSQL & " AND A.SportsGb = '"&Request.Cookies("SportsGb")&"'"
	LSQL = LSQL & WSQL

		
	If Trim(strkey) <> "" Then 

		LSQL = LSQL & " AND RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.GameTitleIDX,0)),5)"
		LSQL = LSQL & "  + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameGb,0)),5)"
		LSQL = LSQL & "  + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TeamGb,0)),5)"
		LSQL = LSQL & " > '" & strkey & "'"

	End If 

	LSQL = LSQL & " GROUP BY A.SportsGb, A.GameTitleIDX, A.TeamGb, A.GroupGameGb, A.Sex"

	LSQL = LSQL & " ORDER BY RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.GameTitleIDX,0)),5)"
	LSQL = LSQL & "  + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameGb,0)),5)"
	LSQL = LSQL & "  + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TeamGb,0)),5)"



	CntSQL = "SELECT  COUNT(*) CNT  "
  CntSQL = CntSQL & " FROM ("
	CntSQL = CntSQL & " SELECT SportsDiary.dbo.FN_GameTitleName(A.GameTitleIdx) AS GameTitleNM,"
	CntSQL = CntSQL & " A.SportsGb,"
	CntSQL = CntSQL & " A.GameTitleIdx,"
	CntSQL = CntSQL & " SportsDiary.dbo.FN_TeamGbNm(A.SportsGb, A.TeamGb) AS TeamGbNM,"
	CntSQL = CntSQL & " A.TeamGb,"
	CntSQL = CntSQL & " SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbNM,"
	CntSQL = CntSQL & " A.GroupGameGb,"
	CntSQL = CntSQL & " A.Sex,"

	CntSQL = CntSQL & "  RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.GameTitleIDX,0)),5)"
	CntSQL = CntSQL & "  + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.GroupGameGb,0)),5)"
	CntSQL = CntSQL & "  + RIGHT('00000' + CONVERT(NVARCHAR,ISNULL(A.TeamGb,0)),5) AS NextKey"

	CntSQL = CntSQL & " FROM SportsDiary.dbo.tblRGameLevel A"
	CntSQL = CntSQL & " INNER JOIN SportsDiary.dbo.tblGameTitle B ON B.GameTitleIDX = A.GameTitleIDX"
	CntSQL = CntSQL & " WHERE A.DelYN = 'N'"
	CntSQL = CntSQL & " AND B.DelYN = 'N'"
	CntSQL = CntSQL & " AND A.SportsGb = '"&Request.Cookies("SportsGb")&"'"
	CntSQL = CntSQL & WSQL
	CntSQL = CntSQL & " GROUP BY A.SportsGb, A.GameTitleIDX, A.TeamGb, A.GroupGameGb, A.Sex"

	CntSQL = CntSQL & " ) A1 "

	Dbopen()
  Set LRs = Dbcon.Execute(LSQL)
	Set CRs = Dbcon.Execute(CntSQL)

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
		<td style="cursor:pointer;text-align:left;padding-left:10px;"><%=LRs("GameTitleNM")%></td>
		<td style="cursor:pointer;"><%=LRs("TeamGbNM")%></td>
		<td style="cursor:pointer;"><%=LRs("GroupGameGbNM")%></td>
		<td>
		<%
			If LRs("GroupGameGb") = SportsCode&"040001" Then 
				PlayerCntSQL = "SELECT Count(RPlayerMasterIDX) AS Cnt "
				PlayerCntSQL = PlayerCntSQL & " FROM SportsDiary.dbo.tblRPlayerMaster"
				PlayerCntSQL = PlayerCntSQL & " WHERE SportsGb='" & Request.Cookies("SportsGb") & "' AND TeamGb = '" & LRs("TeamGb") & "' AND Sex = '" & LRs("Sex") & "'"
				PlayerCntSQL = PlayerCntSQL & " AND GroupGameGb ='"&SportsCode&"040001' AND GameTitleIDX='"&LRs("GameTitleIDX")&"' AND DelYN='N'"

			Else
				PlayerCntSQL = "SELECT Count(RGameGroupSchoolMasterIDX) AS Cnt "
				PlayerCntSQL = PlayerCntSQL & " FROM SportsDiary.dbo.tblRGameGroupSchoolMaster "
				PlayerCntSQL = PlayerCntSQL & " WHERE SportsGb = '"&Request.Cookies("SportsGb")&"'"
				PlayerCntSQL = PlayerCntSQL & " AND GroupGameGb ='"&SportsCode&"040002' AND GameTitleIDX='"&LRs("GameTitleIDX")&"' AND Sex = '" & LRs("Sex") & "'"
				PlayerCntSQL = PlayerCntSQL & " AND TeamGb ='"&LRs("TeamGb")&"' AND DelYN='N'"
			End If


			Set PlayerCntRs = Dbcon.Execute(PlayerCntSQL)

			Response.Write PlayerCntRs("Cnt")
		%>
		</td>

		<td style="cursor:pointer;"><a href="http://www.sportsdiary.co.kr/request/judo/matchlist_all.asp?gametitleidx=<%=LRs("GameTitleIdx")%>&Teamgb=<%=LRs("TeamGb")%>&GroupGameGb=<%=LRs("GroupGameGb")%>&SEX=<%=LRs("Sex")%>" target="_blank">PDF출력</a></td>		
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

	Dbclose()
%>
