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
	player              = fInject(Request("player"))
	
	WSQL = ""

	
	if Search_GroupGameGb = "1" then '개인전
	
		If Search_GameYear <> "" Then 
			WSQL = WSQL&" AND A.GameYear = '"&Search_GameYear&"'"
		End If 
	
		If Search_GameTitleIDX <> "" Then 
			WSQL = WSQL&" AND A.GameTitleIDX = '"&Search_GameTitleIDX&"'"
		End If 

		If Search_TeamGb <> "" Then 
			WSQL = WSQL&" AND B.TeamGb = '"&Search_TeamGb&"'"
		End If 	
	
		If Search_Sex <> "" Then 
			WSQL = WSQL&" AND B.Sex = '"&Search_Sex&"'"
		End If 
		
		If Search_Level <> "" Then 
			WSQL = WSQL&" AND B.[Level] = '"&Search_Level&"'"
		End If 
		
		If player <> "" Then 
			WSQL = WSQL&" AND ISNULL(C.UserName,'') LIKE '%"&player&"%'"
		End If
		
		LSQL = " SELECT TOP " & ViewCnt & " A.GameTitleName, SportsDiary.dbo.FN_PubName(B.GroupGameGb) AS GroupGameGbNM,"
		LSQL = LSQL & " B.GroupGameGb, SportsDiary.dbo.FN_TeamGbNm(B.SportsGb, B.TeamGb) AS TeamGbNM ,"
		LSQL = LSQL & " B.TeamGb, B.Sex, C.Team, C.TeamDtl, "
		LSQL = LSQL & " SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, C.Team) AS TeamNM, C.PlayerIDX, SportsDiary.dbo.FN_PlayerName(C.PlayerIDX) AS PlayerNm,"
		LSQL = LSQL & " B.Level, SportsDiary.dbo.FN_LevelNm(B.SportsGb, B.TeamGb, C.Level) AS LevelNm, [Weight], WeightINYN,"
		LSQL = LSQL & " (CONVERT(VARCHAR,ISNULL(B.GameTitleIDX,''))+CONVERT(VARCHAR,ISNULL(B.TeamGb,''))+CONVERT(VARCHAR,ISNULL(B.GroupGameGb,''))+CONVERT(VARCHAR,ISNULL(B.Sex,''))+"
		LSQL = LSQL & " CONVERT(VARCHAR,ISNULL(B.Level,''))+CONVERT(VARCHAR,ISNULL(C.PlayerNum,''))) AS NextKey,"
		LSQL = LSQL & " B.RGameLevelIDX, B.GameTitleIDX, B.SportsGb, B.StadiumNumber, C.PlayerNum, C.UnearnWin"
		LSQL = LSQL & " FROM tblGameTitle A"
		LSQL = LSQL & " INNER JOIN tblRGameLevel B ON B.GameTitleIDX = A.GameTitleIDX"
		LSQL = LSQL & " INNER JOIN tblRPlayer C ON C.RGameLevelidx = B.RGameLevelidx"
		LSQL = LSQL & " LEFT JOIN tblWeightIn D ON D.RGameLevelidx = C.RGameLevelidx AND D.PlayerIDX = C.PlayerIDX"
		LSQL = LSQL & " WHERE A.DelYN = 'N'"
		LSQL = LSQL & " AND B.DelYN = 'N'"
		LSQL = LSQL & " AND C.DelYN = 'N'"
    LSQL = LSQL & " AND B.GroupGameGb = 'sd040001'"

    If Trim(strkey) <> "" Then 
			LSQL = LSQL & " AND (CONVERT(VARCHAR,ISNULL(B.GameTitleIDX,''))+CONVERT(VARCHAR,ISNULL(B.TeamGb,''))+CONVERT(VARCHAR,ISNULL(B.GroupGameGb,''))+CONVERT(VARCHAR,ISNULL(B.Sex,''))+"
			LSQL = LSQL & " CONVERT(VARCHAR,ISNULL(B.Level,''))+CONVERT(VARCHAR,ISNULL(C.PlayerNum,''))) < '" & strkey & "'"
		End If 

		LSQL = LSQL & WSQL 

		LSQL = LSQL & " ORDER BY (CONVERT(VARCHAR,ISNULL(B.GameTitleIDX,''))+CONVERT(VARCHAR,ISNULL(B.TeamGb,''))+CONVERT(VARCHAR,ISNULL(B.GroupGameGb,''))+CONVERT(VARCHAR,ISNULL(B.Sex,''))+"
		LSQL = LSQL & " CONVERT(VARCHAR,ISNULL(B.Level,''))+CONVERT(VARCHAR,ISNULL(C.PlayerNum,''))) DESC"
		
		CNTSQL = CNTSQL & " SELECT COUNT(*) AS Cnt"
		CNTSQL = CNTSQL & " FROM"
		CNTSQL = CNTSQL & "		("
		CNTSQL = CNTSQL & "		SELECT A.GameTitleName, B.GroupGameGb, B.TeamGb, B.Sex, C.Team, C.TeamDtl, "
		CNTSQL = CNTSQL & "		C.PlayerIDX, B.Level, [Weight], WeightINYN"
		CNTSQL = CNTSQL & "		FROM tblGameTitle A"
		CNTSQL = CNTSQL & "		INNER JOIN tblRGameLevel B ON B.GameTitleIDX = A.GameTitleIDX"
		CNTSQL = CNTSQL & "		INNER JOIN tblRPlayer C ON C.RGameLevelidx = B.RGameLevelidx"
		CNTSQL = CNTSQL & "		LEFT JOIN tblWeightIn D ON D.RGameLevelidx = C.RGameLevelidx AND D.PlayerIDX = C.PlayerIDX"
		CNTSQL = CNTSQL & "		WHERE A.DelYN = 'N'"
		CNTSQL = CNTSQL & "		AND B.DelYN = 'N'"
		CNTSQL = CNTSQL & "		AND C.DelYN = 'N'"
		CNTSQL = CNTSQL & "		AND B.GroupGameGb = 'sd040001'"

		CNTSQL = CNTSQL & WSQL 

		CNTSQL = CNTSQL & " ) AS AA"


 
	end If
	
	Dbopen()
  Set LRs = Dbcon.Execute(LSQL)
	Set CRs = Dbcon.Execute(CNTSQL)

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
		<td style="cursor:pointer;"><%=LRs("GroupGameGbNM")%></td>
		<td style="cursor:pointer;"><%=LRs("TeamGbNM")%></td>
		<td style="cursor:pointer;">
		<%
			If LRs("Sex") = "Man" Then
				Response.Write "남자"
			Else
				Response.Write "여자"
			End If
		%>
		</td>
		<td style="cursor:pointer;"><%=LRs("TeamNM")%></td>		
		<td style="cursor:pointer;"><%=LRs("PlayerNM")%></td>	
		<td style="cursor:pointer;"><%=LRs("LevelNm")%></td>	
		<td style="cursor:pointer;"><input type="text" name="Weight_Input" style="width:40px" value="<%=LRs("Weight")%>"> kg</td>	
			<input type="hidden" name="hi_RGameLevelidx" value="<%=LRs("RGameLevelidx")%>">
			<input type="hidden" name="hi_GameTitleIDX" value="<%=LRs("GameTitleIDX")%>">
			<input type="hidden" name="hi_SportsGb" value="<%=LRs("SportsGb")%>">
			<input type="hidden" name="hi_TeamGb" value="<%=LRs("TeamGb")%>">
			<input type="hidden" name="hi_Sex" value="<%=LRs("Sex")%>">
			<input type="hidden" name="hi_Level" value="<%=LRs("Level")%>">
			<input type="hidden" name="hi_GroupGameGb" value="<%=LRs("GroupGameGb")%>">
			<input type="hidden" name="hi_StadiumNumber" value="<%=LRs("StadiumNumber")%>">
			<input type="hidden" name="hi_PlayerIDX" value="<%=LRs("PlayerIDX")%>">
			<input type="hidden" name="hi_PlayerNum" value="<%=LRs("PlayerNum")%>">
			<input type="hidden" name="hi_UnearnWin" value="<%=LRs("UnearnWin")%>">
			<input type="hidden" name="hi_Team" value="<%=LRs("Team")%>">
			<input type="hidden" name="hi_TeamDtl" value="<%=LRs("TeamDtl")%>">
		<td style="cursor:pointer;" name="DP_Weight_TD">
			<%
				If LRs("WeightINYN") = "Y" Then
					Response.Write "<font color='green'>계체통과</font>"
				ElseIf LRs("WeightINYN") = "N" Then
					Response.Write "<font color='red'>계체탈락</font>"
				End If
			%>
		</td>			
		<td style="cursor:pointer;"><a name="Pass_Btn"><font color="green">계체통과 처리하기</font></a></td>	
		<td style="cursor:pointer;"><a name="Fail_Btn"><font color="red">계체탈락 처리하기</font></a></td>	
			
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

