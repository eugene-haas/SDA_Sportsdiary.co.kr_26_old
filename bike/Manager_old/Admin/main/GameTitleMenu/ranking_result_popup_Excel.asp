<!-- #include file="../../dev/dist/config.asp"-->
<% 
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"

    Dim CMD             : CMD               = fInject(Request("CMD"))
	Dim GameTitleIDX	: GameTitleIDX 		= fInject(Request("GameTitleIDX"))
	Dim GroupGameGbValue : GroupGameGbValue = fInject(Request("GroupGameGbValue"))	
	Dim PlayTypeSexValue: PlayTypeSexValue 		= fInject(Request("PlayTypeSexValue"))
    Dim TeamGbValue		: TeamGbValue 		= fInject(Request("TeamGbValue"))
	Dim LevelValue		: LevelValue			= fInject(Request("LevelValue"))
	Dim RankingValue	: RankingValue		= fInject(Request("RankingValue"))
    

    'Response.Write "GameTitleIDX : " & GameTitleIDX & "<BR/>"
    'Response.Write "GroupGameGbValue : " & GroupGameGbValue & "<BR/>"
    'Response.Write "PlayTypeSexValue : " & PlayTypeSexValue & "<BR/>"
    'Response.Write "TeamGbValue : " & TeamGbValue & "<BR/>"
    'Response.Write "LevelValue : " & LevelValue & "<BR/>"
    'Response.Write "RankingValue : " & RankingValue & "<BR/>"

    ' reqGameTitleIdx = fInject(crypt.DecryptStringENC(oJSONoutput.tGameTitleIdx))
    reqGameTitleIdx =crypt.DecryptStringENC(GameTitleIDX)
    crypt_reqGameTitleIdx =crypt.EncryptStringENC(reqGameTitleIdx)

    IF GroupGameGbValue <> "" Then
      reqGroupGameGb = fInject(crypt.DecryptStringENC(GroupGameGbValue))
      crypt_reqGroupGameGb = crypt.EncryptStringENC(reqGroupGameGb)
    ELSE
      reqGroupGameGb = "B0030001" ' 개인전(B0030001), 단체전(B0030002)
      crypt_reqGroupGameGb = crypt.EncryptStringENC(reqGroupGameGb)
    END IF

    If TeamGbValue <> "" then
        reqTeamGb= TeamGbValue
        If InStr(reqTeamGb,"|") > 1 Then
        arr_reqTeamGb = Split(reqTeamGb,"|")
        reqTeamGb = fInject(crypt.DecryptStringENC(arr_reqTeamGb(0)))
        crypt_reqTeamGb =crypt.EncryptStringENC(reqTeamGb)
        reqTeamGbSex = fInject(arr_reqTeamGb(1))
        End IF
    End if	

    If PlayTypeSexValue <> "" then
        reqPlayTypeSex= PlayTypeSexValue
        If InStr(reqPlayTypeSex,"|") > 1 Then
        arr_reqPlayTypeSex = Split(reqPlayTypeSex,"|")
        reqSex = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(0)))
        reqPlayType = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(1)))
        End if
    End if	

    If LevelValue <> ""then
        reqLevel= LevelValue
        'reqLevel = "FE25E609214EB0FC01BC8651577120A1|2B4F14AE43DBCAD1D5BFD3285CE3A249|1"
        If InStr(reqLevel,"|") > 1 Then
        arr_reqLevel = Split(reqLevel,"|")
        reqLevel = fInject(crypt.DecryptStringENC(arr_reqLevel(0)))
        reqLevelJooName = fInject(crypt.DecryptStringENC(arr_reqLevel(1)))
        reqLevelJooNum = arr_reqLevel(2)
        End if
    End if	

    If RankingValue <> "" then
      reqRankingValue= RankingValue
    End if	


  IF CDBL(Len(reqGroupGameGb)) = Cdbl(0) Then
    reqGroupGameGb = "B0030001" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGroupGameGb = fInject(crypt.DecryptStringENC(reqGroupGameGb))
  End If

  IF CDBL(Len(reqTeamGb)) = Cdbl(0) Then
    reqTeamGb = "" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqTeamGb = ""
  End If
  
    'Response.Write "reqTeamGbSex  : " & reqTeamGbSex & "<BR/>"
    'Response.Write "reqGameTitleIdx   : " & reqGameTitleIdx & "<BR/>"
    'Response.Write "reqGroupGameGb  : " & reqGroupGameGb  & "<BR/>"
    'Response.Write "reqTeamGb  : " & reqTeamGb  & "<BR/>"
    'Response.Write "reqSex  : " & reqSex  & "<BR/>"
    'Response.Write "reqPlayType  : " & reqPlayType  & "<BR/>"
    'Response.Write "reqLevel  : " & reqLevel  & "<BR/>"
    'Response.Write "reqLevelJooName  : " & reqLevelJooName  & "<BR/>"
    'Response.Write "reqLevelJooNum  : " & reqLevelJooNum  & "<BR/>"
    
    LSQL = " SELECT GameLevelDtlIDX,"
    LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Sex, 'PubCode') AS SexName,"
    LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.PlayType, 'PubCode') AS PlayTypeName,"
    LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.TeamGb, 'TeamGb') AS TeamGbName,"
    LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Level, 'Level') AS LevelName,"
    LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.LevelJooName,'PubCode') AS LevelJooName, A.LevelJooNum, B.LevelJooNum AS LevelJooNumDtl,  B.LevelDtlName, "
    LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.GameType,'PubCode') AS GameTypeName, "
    LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.PlayLevelType,'PubCode') AS PlayLevelTypeName,"
    LSQL = LSQL & " B.PlayLevelType,"
    LSQL = LSQL & " A.GameType"
    LSQL = LSQL & " FROM tblGameLevel A"
    LSQL = LSQL & " INNER JOIN tblGameLevelDtl B ON B.GameLevelidx = A.GameLevelIDX"
    LSQL = LSQL & " INNER JOIN tblTeamGbInfo C ON C.TeamGb = A.TeamGb AND C.DelYN='N'"

    If reqTeamGbSex <> "" AND reqSex = "" Then
    LSQL = LSQL & " AND A.Sex = '" & reqTeamGbSex & "' "
    End If

    LSQL = LSQL & " WHERE A.DelYN = 'N'"
    LSQL = LSQL & " AND B.DelYN = 'N'"
    LSQL = LSQL & " AND B.PlayLevelType = 'B0100001'" '예선전만

    If reqGameTitleIdx <> "" Then
        LSQL = LSQL & " AND A.GameTitleIDX = '" & reqGameTitleIdx & "' "
    End If

    If reqGroupGameGb <> "" Then
        LSQL = LSQL & " AND A.GroupGameGb = '" & reqGroupGameGb & "' "
    End If

    If reqTeamGb <> "" AND reqTeamGb <> "0" Then
        LSQL = LSQL & " AND A.TeamGb = '" & reqTeamGb & "' "
    End If

    If reqSex <> "" AND reqSex <> "0" Then
        LSQL = LSQL & " AND A.Sex = '" & reqSex & "' "
    End If

    If reqPlayType <> "" AND reqPlayType <> "0" Then
        LSQL = LSQL & " AND A.PlayType = '" & reqPlayType & "' "
    End If

    If reqLevel <> "" AND reqLevel <> "0" Then
        LSQL = LSQL & " AND A.Level = '" & reqLevel & "' "
    End If

    If reqLevelJooName <> "" AND reqLevelJooName <> "0" Then
        LSQL = LSQL & " AND A.LevelJooName = '" & reqLevelJooName & "' "
    End If

    If reqLevelJooNum <> "" AND reqLevelJooNum <> "0" Then
        LSQL = LSQL & " AND A.LevelJooNum = '" & reqLevelJooNum & "' "
    End If  


    'Response.Write "LSQL : " & LSQL & "<br/>"
    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
    Arr_Info = LRs.getrows()
    End If

    IF IsArray(Arr_Info) Then
    Arr_InfoLength = UBOUND(Arr_Info,2)
    ELSE 
    Arr_InfoLength = 0
    End IF

    IF IsArray(Arr_Info) Then
    For i = 0 To Arr_InfoLength
        If i = 0 Then
        LevelDtlLSQL = LevelDtlLSQL & " ( A.GameLevelDtlidx = ''" & Arr_Info(0,i) & "''"
        Else
        LevelDtlLSQL  = LevelDtlLSQL  & " OR A.GameLevelDtlidx = ''" & Arr_Info(0,i) & "''"
        End If
    NEXT
    END IF

    IF cdbl(Arr_InfoLength) > 0 And Cdbl(Len(LevelDtlLSQL)) > 0  Then
    LevelDtlLSQL  = LevelDtlLSQL  & " ) "
    End IF

    'Response.Write "UBOUND(Arr_Info,2) : " & Arr_InfoLength & "<br/>"
    'Response.Write "LevelDtlLSQL : " & LevelDtlLSQL & "<br/>"

  
  %>

		<table cellspacing="0" cellpadding="0" border="1">
			<tr>
        <th>최종순위</th>
        <th>종목</th>
				<th>순위</th>
				<th>소속</th>
				<th>선수</th>
				<th>승</th>
				<th>패</th>
				<th>승률</th>
				<th>득실차</th>
				<th>총득점</th>
				<th>총실점</th>
			</tr>
      <%
				LSQL = "EXEC tblGameRankingResult_Searched_STR '" & reqGameTitleIdx  & "', '" & LevelDtlLSQL &  "', '" & reqRankingValue  & "','" & reqGroupGameGb & "'"

				Set LRs = Dbcon.Execute(LSQL)
				arrnum = 0
				AutoRank = 0
				If Not (LRs.Eof Or LRs.Bof) Then		
					Do Until LRs.Eof		
						arrnum = arrnum  + 1
						rGameLevelDtlCnt = LRs("GameLevelDtlCnt") 
						rJooRank = LRs("JooRank") 
						rFinalPlayer = rJooRank
						rGameLevelidx = LRs("GameLevelidx")
						rGameLevelDtlidx= LRs("GameLevelDtlidx")
						rTourneyGroupIDX= LRs("TourneyGroupIDX")
						rGroupGameGb= LRs("GroupGameGb")
						'rRequestIDX= LRs("RequestIDX")

						If LRs("AutoRank") <> "0" Then
							AutoRank = AutoRank + 1
						End If      
						
			%>
			<tr>
      <td>
				<%
				if LRs("AutoRank") <> "0" Then
					Response.Write LRs("AutoRank") & "위"
				End IF
				%>
      </td>
      <td><%=LRs("TeamGbNM") & " " & LRs("LevelNM") & " " & LRs("LevelJooNameNM")& LRs("LevelJooNum") %>
      <%
          If LRs("PlayLevelType") = "B0100001" Then
              Response.Write " 예선" & LRs("LevelDtlJooNum")&"조"
          ElseIf LRs("PlayLevelType") = "B0100002" Then
              Response.Write " 본선"
          Else
              Response.Write "-"
          End If   
      %>        
      </td>
      <td>
        <span><%=LRs("TRanking")%></span>
      </td>
      <td>
        <span><%=LRs("TeamNM") & LRs("TeamDtlNM")%></span>
      </td>
      <td>
       <%=LRs("Player")%>
      </td>
      <td>
        <span><%=LRs("WinCnt")%></span>
      </td>
      <td>
        <span><%=LRs("LoseCnt")%></span>
      </td>
      <td>
        <span><%=LRs("WinPerc")%>%</span>
      </td>
      <td>
        <span><%=LRs("PointDiff")%></span>
      </td>
      <td>
        <span><%=LRs("WinPoint")%></span>
      </td>
      <td>
        <span><%=LRs("LosePoint")%></span>
      </td>
    </tr>
    <%
           
          LRs.MoveNext
        Loop
      ELSE
    %>
    <tr >
    <td colspan="11">
      조회된 데이터가 없습니다.
    </td>
    </tr>
      
    <%
      End If
    %>



    </table>
<%
   

    Response.Buffer = True
    Response.ContentType = "application/vnd.ms-excel"
    Response.AddHeader "Content-disposition","attachment;filename=예선 최종 순위 결과.xls"
%>

