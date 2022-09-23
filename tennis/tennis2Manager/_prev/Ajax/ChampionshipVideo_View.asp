<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))
	ViewCnt = "50"

	'조회조건 데이터
	Search_GameYear = fInject(Request("Search_GameYear"))
	Search_GameTitleIDX = fInject(Request("Search_GameTitleIDX"))
	Search_GroupGameGb  = fInject(Request("Search_GroupGameGb"))	
	Search_TeamGb       = fInject(Request("Search_TeamGb"))	
	Search_Sex          = fInject(Request("Search_Sex"))
	Search_Level        = fInject(Request("Search_Level"))
	Search_Stadium      = fInject(Request("Search_Stadium"))
	player              = fInject(Request("player"))
	Search_Url          = fInject(Request("Search_Url"))

	WSQL = ""
	
	If Search_GameYear <> "" Then 
		WSQL = WSQL&" AND C.GameYear = '"&Search_GameYear&"'"
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
	
	If Search_Level <> "" Then 
		WSQL = WSQL&" AND A.Level = '"&Search_Level&"'"
	End If 
	
	If Search_Stadium <> "" Then 
		WSQL = WSQL&" AND ISNULL(A.StadiumNumber,'') = '"&Search_Stadium&"'"
	End If 
	
	If player <> "" Then 
		WSQL = WSQL&" AND ISNULL(A.LPlayerName + ' - ' + A.RPlayerName,'') LIKE '%"&player&"%'"
	End If 
	
	If Search_Url = "Y" Then 
		WSQL = WSQL&" AND ISNULL(A.MediaLink,'') <> ''"
	End If 
	
	If Search_Url = "N" Then 
		WSQL = WSQL&" AND ISNULL(A.MediaLink,'') = ''"
	End If 
		
	
	LSQL = "        SELECT TOP " & ViewCnt & " A.RGameResultIDX RGameResultIDX "
	LSQL = LSQL & "       ,A.GameTitleIDX GameTitleIDX"
	LSQL = LSQL & "       ,SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName "
	LSQL = LSQL & "       ,SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbName   "    
	LSQL = LSQL & "       ,CASE WHEN A.Sex = 'Man' THEN '남자'  "
	LSQL = LSQL & "             WHEN A.Sex = 'Woman' THEN '여자'  "
	LSQL = LSQL & "             ELSE '' END Gender  "
	LSQL = LSQL & "       ,SportsDiary.dbo.FN_PubName(A.Level) Level "   
	LSQL = LSQL & "         ,SportsDiary.dbo.FN_PubName(A.TeamGb) AS TeamGb "

	LSQL = LSQL & "       ,A.LPlayerName + ' - ' + A.RPlayerName As Player  "     
	LSQL = LSQL & "       ,CASE WHEN A.GroupGameGb = 'sd040001' THEN A.Round + ' 라운드' ELSE '' END AS strRound   "
	LSQL = LSQL & "       ,CASE WHEN A.GroupGameGb = 'sd040001' THEN CASE WHEN CONVERT(VARCHAR,SportsDiary.dbo.FN_Round_Nm(CONVERT(INT,MAX(B.TotRound)),CONVERT(INT,A.Round))) = '2' THEN '결승' ELSE CONVERT(VARCHAR,SportsDiary.dbo.FN_Round_Nm(CONVERT(INT,MAX(B.TotRound)),CONVERT(INT,A.Round))) + '강' END + ' / ' + CONVERT(VARCHAR,MAX(B.TotRound)) + '강' ELSE '' END Kang"	
	LSQL = LSQL & "       ,A.StadiumNumber StadiumNumber "
	LSQL = LSQL & "       ,ISNULL(A.MediaLink,'') MediaLink "
	LSQL = LSQL & "       ,(CONVERT(VARCHAR,A.GameTitleIDX)+A.GroupGameGb+A.Sex+A.Level+A.ROUND+CONVERT(VARCHAR,A.RGameResultIDX)) NextKey"
	LSQL = LSQL & " FROM SportsDiary.dbo.tblRGameResult A "
	LSQL = LSQL & " LEFT OUTER JOIN (SELECT GameTitleIDX GameTitleIDX "
	LSQL = LSQL & "                        ,SportsGb SportsGb"
	LSQL = LSQL & "                        ,TeamGb TeamGb"
	LSQL = LSQL & "                        ,TotRound TotRound"
	LSQL = LSQL & "                        ,Level Level"
	LSQL = LSQL & "                  FROM Sportsdiary.dbo.tblRGameLevel "
	LSQL = LSQL & "                  WHERE DelYN = 'N') B ON A.GameTitleIDX = B.GameTitleIDX "
	LSQL = LSQL & "                                          AND A.SportsGb = B.SportsGb "
	LSQL = LSQL & "                                          AND A.TeamGb = B.TeamGb "
	LSQL = LSQL & "                                          AND A.Level = B.Level "
	
	LSQL = LSQL & " LEFT OUTER JOIN (SELECT GameTitleIDX GameTitleIDX"
	LSQL = LSQL&"                          ,GameYear GameYear "
	LSQL = LSQL&"                    FROM SportsDiary.dbo.tblGameTitle "
	LSQL = LSQL&"                    WHERE DelYN='N') C ON A.GameTitleIDX = C.GameTitleIDX "	
	LSQL = LSQL & " WHERE A.DELYN = 'N' "	
		
	If Trim(strkey) <> "" Then 
		LSQL = LSQL&" AND (CONVERT(VARCHAR,A.GameTitleIDX)+A.GroupGameGb+A.Sex+A.Level+A.ROUND+CONVERT(VARCHAR,A.RGameResultIDX)) < '" & strkey & "'"
	End If 
	
	LSQL = LSQL&WSQL 
	
	LSQL = LSQL & " GROUP BY A.RGameResultIDX "
	LSQL = LSQL & "         ,A.Sex "
	LSQL = LSQL & "         ,A.Level "      
	LSQL = LSQL & "         ,A.TeamGb "
	LSQL = LSQL & "         ,A.ROUND "
	LSQL = LSQL & "         ,A.GameTitleIDX "
	LSQL = LSQL & "         ,A.GroupGameGb " 
	LSQL = LSQL & "         ,A.LPlayerName + ' - ' + A.RPlayerName "
	LSQL = LSQL & "         ,A.StadiumNumber "
	LSQL = LSQL & "         ,A.MediaLink "
	LSQL = LSQL & " ORDER BY (CONVERT(VARCHAR,A.GameTitleIDX)+A.GroupGameGb+A.Sex+A.Level+A.ROUND+CONVERT(VARCHAR,A.RGameResultIDX)) DESC"
	

	CntSQL = "SELECT  COUNT(A1.RGameResultIDX) CNT  "
  CntSQL = CntSQL & " FROM (SELECT  A.RGameResultIDX RGameResultIDX "
	CntSQL = CntSQL & "       ,A.GameTitleIDX GameTitleIDX"
	CntSQL = CntSQL & "       ,SportsDiary.dbo.FN_GameTitleName(A.GameTitleIDX) AS GameTitleName "
	CntSQL = CntSQL & "       ,SportsDiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbName   "    
	CntSQL = CntSQL & "       ,CASE WHEN A.Sex = 'Man' THEN '남자'  "
	CntSQL = CntSQL & "             WHEN A.Sex = 'Woman' THEN '여자'  "
	CntSQL = CntSQL & "             ELSE '' END Gender  "
	CntSQL = CntSQL & "       ,SportsDiary.dbo.FN_PubName(A.Level) Level "   	
	CntSQL = CntSQL & "       ,A.LPlayerName + ' - ' + A.RPlayerName As Player  "     
	CntSQL = CntSQL & "       ,CASE WHEN A.GroupGameGb = 'sd040001' THEN A.Round + ' 라운드' ELSE '' END AS strRound   "
	CntSQL = CntSQL & "       ,CASE WHEN A.GroupGameGb = 'sd040001' THEN CASE WHEN CONVERT(VARCHAR,SportsDiary.dbo.FN_Round_Nm(CONVERT(INT,MAX(B.TotRound)),CONVERT(INT,A.Round))) = '2' THEN '결승' ELSE CONVERT(VARCHAR,SportsDiary.dbo.FN_Round_Nm(CONVERT(INT,MAX(B.TotRound)),CONVERT(INT,A.Round))) + '강' END + ' / ' + CONVERT(VARCHAR,MAX(B.TotRound)) + '강' ELSE '' END Kang"	
	CntSQL = CntSQL & "       ,A.StadiumNumber StadiumNumber "
	CntSQL = CntSQL & "       ,ISNULL(A.MediaLink,'') MediaLink "
	CntSQL = CntSQL & "       ,(CONVERT(VARCHAR,A.GameTitleIDX)+A.GroupGameGb+A.Sex+A.Level+A.ROUND+CONVERT(VARCHAR,A.RGameResultIDX)) NextKey"
	CntSQL = CntSQL & " FROM SportsDiary.dbo.tblRGameResult A "
	CntSQL = CntSQL & " LEFT OUTER JOIN (SELECT GameTitleIDX GameTitleIDX "
	CntSQL = CntSQL & "                        ,SportsGb SportsGb"
	CntSQL = CntSQL & "                        ,TeamGb TeamGb"
	CntSQL = CntSQL & "                        ,TotRound TotRound"
	CntSQL = CntSQL & "                        ,Level Level"
	CntSQL = CntSQL & "                  FROM Sportsdiary.dbo.tblRGameLevel "
	CntSQL = CntSQL & "                  WHERE DelYN = 'N') B ON A.GameTitleIDX = B.GameTitleIDX "
	CntSQL = CntSQL & "                                          AND A.SportsGb = B.SportsGb "
	CntSQL = CntSQL & "                                          AND A.TeamGb = B.TeamGb "
	CntSQL = CntSQL & "                                          AND A.Level = B.Level "
	
	CntSQL = CntSQL & " LEFT OUTER JOIN (SELECT GameTitleIDX GameTitleIDX"
	CntSQL = CntSQL&"                          ,GameYear GameYear "
	CntSQL = CntSQL&"                    FROM SportsDiary.dbo.tblGameTitle "
	CntSQL = CntSQL&"                    WHERE DelYN='N') C ON A.GameTitleIDX = C.GameTitleIDX "	
	CntSQL = CntSQL & " WHERE A.DELYN = 'N' "	
		
	CntSQL = CntSQL&WSQL 
	
	CntSQL = CntSQL & " GROUP BY A.RGameResultIDX "
	CntSQL = CntSQL & "         ,A.Sex "
	CntSQL = CntSQL & "         ,A.Level "      
	CntSQL = CntSQL & "         ,A.ROUND "
	CntSQL = CntSQL & "         ,A.GameTitleIDX "
	CntSQL = CntSQL & "         ,A.GroupGameGb " 
	CntSQL = CntSQL & "         ,A.LPlayerName + ' - ' + A.RPlayerName "
	CntSQL = CntSQL & "         ,A.StadiumNumber "
	CntSQL = CntSQL & "         ,A.MediaLink "
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
		<td style="cursor:pointer;text-align:left;padding-left:10px;"><%=LRs("GameTitleName")%></td>
		<td style="cursor:pointer;"><%=LRs("GroupGameGbName")%></td>
		<td style="cursor:pointer;"><%=LRs("TeamGb")%></td>
		<td style="cursor:pointer;"><%=LRs("Gender")%></td>
		<td style="cursor:pointer;"><%=LRs("Level")%></td>
		<td style="cursor:pointer;"><%=LRs("Player")%></td>
		<td style="cursor:pointer;"><%=LRs("strRound")%></td>		
		<td style="cursor:pointer;"><%=LRs("Kang")%></td>		
		<td style="cursor:pointer;"><%=LRs("StadiumNumber")%></td>		
		<td style="cursor:pointer;"><input id=<%=LRs("RGameResultIDX")%> style="width:100%;height:25px;border:0px;background-color:#d3d3d3;padding-left:5px;" value="<%=LRs("MediaLink")%>"></td>		
		<td style="cursor:pointer;" onclick="update_frm('<%=LRs("RGameResultIDX")%>');">저장</td>		
		<td style="cursor:pointer;" onclick="url_play('<%=LRs("RGameResultIDX")%>');">보기</td>
		<td style="cursor:pointer;" onclick="copy_path('<%=LRs("GameTitleName")&" "&LRs("GroupGameGbName")&" "&LRs("TeamGb")&" "&LRs("Gender")&" "&LRs("Level")&" "&LRs("Player")&" "&LRs("strRound")%>');">복사</td>
	
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
