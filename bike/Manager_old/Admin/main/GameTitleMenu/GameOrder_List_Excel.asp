<!-- #include file="../../dev/dist/config.asp"-->
<% 
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"

	Dim GameTitleIDX	: GameTitleIDX 		= fInject(Request("GameTitleIDX"))
	Dim GameDay		    : GameDay 		    = fInject(Request("GameDay"))	
	Dim StadiumIDX		: StadiumIDX 		= fInject(Request("StadiumIDX"))
    Dim StadiumNum		: StadiumNumber 		= fInject(Request("StadiumNumber"))
	Dim SearchName	: SearchName		= fInject(Request("SearchName"))
	
	Dim DEC_GameTitleIDX	: DEC_GameTitleIDX 		= crypt.DecryptStringENC(GameTitleIDX)
	Dim DEC_GameDay		    : DEC_GameDay 		    = GameDay
	Dim DEC_StadiumIDX		: DEC_StadiumIDX 		= crypt.DecryptStringENC(StadiumIDX)
    Dim DEC_StadiumNumber	: DEC_StadiumNumber     = StadiumNumber
	Dim DEC_Searchkeyword	: DEC_Searchkeyword		= Searchkeyword
    
    LSQL = "SELECT GameTitleName"
    LSQL = LSQL & " FROM  tblGameTitle"
    LSQL = LSQL & " WHERE GameTitleIDX = " &  DEC_GameTitleIDX
    'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL : " & LSQL
    Set LRs = DBCon.Execute(LSQL)
    If Not (LRs.Eof Or LRs.Bof) Then
        Do Until LRs.Eof
        tGameTitleName = LRs("GameTitleName")
        LRs.MoveNext
        Loop
    End If
    LRs.close

    DEC_TempNum = ""
    DEC_Searchkeyword =""
    DEC_Searchkey = ""
    DEC_PlayType = ""
    DEC_GroupGameGb = ""
    CSQL = " EXEC tblGameTourney_Searched_STR '" & DEC_GameTitleIDX & "', '" & DEC_GameDay & "', '" & DEC_StadiumIDX &"' ,'"  & DEC_StadiumNumber &"','" & "" & "','" & DEC_PlayType & "' ,'" & DEC_TempNum & "'  ,'" & DEC_Searchkey & "'  ,'"  & DEC_Searchkeyword & "','" & DEC_GroupGameGb & "'"
    SET LRs = DBCon.Execute(CSQL)

    If Not(LRs.Eof Or LRs.Bof) Then 
%>
    <span style="vertical-align: middle;text-align: center; font-size: 20pt;"><%=tGameTitleName%>-경기진행순서 (<%=GameDay%>)</span>
    <table border="1">
    	<tr>
				<td>순번</td>
				<td>대회명</td>
				<td>종목</td>
				<td>구분</td>
				<td>경기 타입</td>
				<td>대진표번호</td>
				<td>경기장</td>
				<td>코트</td>
				<td>선수(좌)</td>
				<td>선수(우)</td>
				<td>진행상태</td>
			</tr>
        
<% 
        Do Until LRs.Eof
          A_GameType= LRs("GameType")
          A_MaxRound = LRs("MaxRound")
          A_Round = LRs("Round")
          A_ResultGangSu = GetGangSu(A_GameType, A_MaxRound,A_Round)
%>      
        <tr>
            <td><%=LRs("TempNum")%></td>
            <td><%=tGameTitleName%></td>
            <td><%=LRs("Sex") & LRs("PlayTypeNM") & " " & LRs("TeamGbNM") & " " & LRs("LevelNM") & LRs("LevelJooNum") & " "%> 
            <%
              If LRs("PlayLevelType") = "B0100001" Then
                Response.Write "예선 " & LRs("LevelDtlJooNum") & "조"
              ElseIf LRs("PlayLevelType") = "B0100002" Then
                IF A_ResultGangSu = "" Then
                  Response.Write " 본선" 
                Else
                  Response.Write " 본선" & "-" & A_ResultGangSu
                ENd iF
              Else
                Response.Write "-"
              End If  
            %>
            </td>
            <td>
            <% 
            If LRs("GroupGameGb") = "B0030001" Then
                Response.Write "개인전"  
            ElseIf LRs("GroupGameGb") = "B0030002" Then
                Response.Write "단체전"  
            Else
                Response.Write LRs("")
            End If            
            %>            
            
            
            <%
                LTeamDtl = LRs("LTeamDtl")
                RTeamDtl = LRs("RTeamDtl")

                IF LTeamDtl = "0" Then
                    LTeamDtl = ""
                End IF
                IF RTeamDtl = "0" Then
                    RTeamDtl = ""
                End IF
            %>

            </td>
            <td>
							<%=LRs("GameTypeNM")%>
            </td>

            <td><%=LRs("GameNum")%></td>
            <td><%=LRs("StadiumName")%></td>
            <td><%=LRs("StadiumNum")%></td>
            <td><%=LRs("LPlayer1") & "(" & LRs("LTeam1") & LTeamDtl & ")," & LRs("LPlayer2") & "(" & LRs("LTeam2") & ")"%></td>
            <td><%=LRs("RPlayer1") & "(" & LRs("RTeam1") & RTeamDtl & ")," & LRs("RPlayer2") & "(" & LRs("RTeam2") & ")"%></td>
            <td>
            <% 
            If LRs("GameStatus") = "GameIng" Then
                Response.Write "진행중"  
            ElseIf LRs("GameStatus") = "GameEnd" Then
                Response.Write "경기완료"  
            ElseIf LRs("GameStatus") = "GameEmpty" Then
                Response.Write ""  
            Else
                Response.Write ""
            End If            
            %>
            </td>
        </tr>
<%
            LRs.MoveNext
          Loop
%>

    </table>
<%
    End If

    Response.Buffer = True
    Response.Buffer = True
    Response.ContentType = "application/vnd.ms-excel"
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-disposition","attachment;filename=" & DEC_GameDay & "경기진행순서.xls"
    Response.AddHeader "Content-disposition","attachment;filename=" & DEC_GameDay & "경기진행순서.xls"
%>

