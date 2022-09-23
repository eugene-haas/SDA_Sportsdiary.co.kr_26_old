<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<% 'Storage 변수 영역 
  Dim REQ : REQ = "{}"
  Set oJSONoutput = JSON.Parse(REQ)
%>

<% 'Reuqest 데이터 영역
  reqGameTitleIdx = fInject(crypt.DecryptStringENC(Request("tGameTitleIdx")))
  crypt_ReqGameTitleIdx = crypt.EncryptStringENC(reqGameTitleIdx)
  reqGroupGameGb = fInject(crypt.DecryptStringENC(Request("tGroupGameGb")))
  crypt_reqGroupGameGb = crypt.EncryptStringENC(Request(reqGroupGameGb))
  reqTeamGb= fInject(crypt.DecryptStringENC(Request("tTeamGb")))
  '테스트 값
  'reqTeamGb =fInject(crypt.DecryptStringENC("2F9A5AB5A680D3EDDEE944350E247FCB"))
  crypt_reqTeamGb = crypt.EncryptStringENC(Request(reqTeamGb))
  reqPlayTypeSex= fInject(Request("tPlayTypeSex"))
  '테스트 값
  'reqPlayTypeSex = "E300F22B66DC861AB9DA1717B0C3A093|704C5971F9D17ABC8687A215715ABCE6"
  If InStr(reqPlayTypeSex,"|") > 1 Then
    arr_reqPlayTypeSex = Split(reqPlayTypeSex,"|")
    reqSex = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(0)))
    reqPlayType = fInject(crypt.DecryptStringENC(arr_reqPlayTypeSex(1)))
  End if

  reqLevel= fInject(Request("tLevel"))
  'reqLevel = "FE25E609214EB0FC01BC8651577120A1|2B4F14AE43DBCAD1D5BFD3285CE3A249|1"
  If InStr(reqLevel,"|") > 1 Then
    arr_reqLevel = Split(reqLevel,"|")
    reqLevel = fInject(crypt.DecryptStringENC(arr_reqLevel(0)))
    reqLevelJooName = fInject(crypt.DecryptStringENC(arr_reqLevel(1)))
    reqLevelJooNum = arr_reqLevel(2)
  End if
%> 

<% 'Request 값이 없을 경우 기본값

  IF CDBL(Len(reqGroupGameGb)) = Cdbl(0) Then
    reqGroupGameGb = "B0030001" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqGroupGameGb = fInject(crypt.DecryptStringENC(reqGroupGameGb))
  End If

  IF CDBL(Len(reqTeamGb)) = Cdbl(0) Then
    reqTeamGb = "" ' 개인전(B0030001), 단체전(B0030002)
    crypt_reqTeamGb = ""
  End If

  LSQL = "SELECT GameTitleName"
  LSQL = LSQL & " FROM tblGameTitle "
  LSQL = LSQL & " where GameTitleIDX = '" & reqGameTitleIdx & "'"
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameTitleName = LRs("GameTitleName")
      LRs.MoveNext
    Loop
  End If


    
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
LSQL = LSQL & " WHERE A.DelYN = 'N'"
LSQL = LSQL & " AND B.DelYN = 'N'"
LSQL = LSQL & " AND B.PlayLevelType = 'B0100001'"

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



Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then
  Arr_Info = LRs.getrows()
End If
'Response.Write " LSQL : " & LSQL & "<BR/>" 



  Call oJSONoutput.Set("tGameTitleIdx", crypt_reqGameTitleIdx )
  strjson = JSON.stringify(oJSONoutput)  
%>
<script type="text/javascript" src="../../js/GameTitleMenu/ranking_result_popup.js"></script>
<script src="../../js/jquery.oLoader.min.js"></script>
<script src="../../js/loadingbar.js"></script>
<script>
  var locationStr;
</script>
<style>
	#left-navi{display:none;}
	#header{display:none;}
</style>
<!-- S: content -->

<input type="hidden" id="selGameTitleIdx" name="selGameTitleIdx" value="<%=crypt_reqGameTitleIdx%>">

<div class="ranking_result_popup" id="DP_BODY">
	<h2 class="top_title">대회명 : [<%=tGameTitleName%>] - 예선 최종 순위 결과</h2>

	<div class="search_box" id="divGameLevelMenu">
    <%
      '예선 본선 값 설정
      LSQL = " SELECT PubCode, PubName  "
      LSQL = LSQL & " FROM  tblPubcode "
      LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B003'"
      LSQL = LSQL & " ORDER BY OrderBy "
      
      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        arryGroupGameGb = LRs.getrows()
      End If
    %>
    <label>
      <% If IsArray(arryGroupGameGb) Then
          For ar = LBound(arryGroupGameGb, 2) To UBound(arryGroupGameGb, 2) 
            tGroupGameGb    = arryGroupGameGb(0, ar) 
            crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
            tGroupGameGbName  = arryGroupGameGb(1, ar) 
            if(tGroupGameGbName = "개인전") Then
      %>
            <input type="radio" name="radioGroupGameGb" value="<%=crypt_tGroupGameGb%>"  onClick='OnGameLevelChanged(<%=strjson%>)' <% if reqGroupGameGb = tGroupGameGb Then %> Checked <%End IF%> >
            <span>개인전</span>
      <%
            END IF
          Next
        End If      
      %>
    </label>

    <label>
         <% If IsArray(arryGroupGameGb) Then
          For ar = LBound(arryGroupGameGb, 2) To UBound(arryGroupGameGb, 2) 
            tGroupGameGb    = arryGroupGameGb(0, ar) 
            crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
            tGroupGameGbName  = arryGroupGameGb(1, ar) 

            if(tGroupGameGbName = "단체전") Then
              %>
                <input type="radio" name="radioGroupGameGb" value="<%=crypt_tGroupGameGb%>" onClick='OnGameLevelChanged(<%=strjson%>)'
                 <% if reqGroupGameGb = tGroupGameGb Then %> Checked <%End IF%> >
                <span>단체전</span>
              <%
            END IF
          Next
        End If      
      %>
    </label>

    <select id="selPlayTypeSex" name="selPlayTypeSex"  onClick='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::종목 선택::</option>
      <%
          LSQL = " SELECT  Sex, PlayType, KoreaBadminton.dbo.FN_NameSch(Sex,'PubCode') AS SexName, KoreaBadminton.dbo.FN_NameSch(PlayType,'PubCode') AS PlayTypeName"
          LSQL = LSQL & " FROM tblGameLevel"
          LSQL = LSQL & " WHERE DelYN = 'N'"
          LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "'"
          IF reqGroupGameGb <> "" Then
            LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
          End IF
          LSQL = LSQL & " GROUP BY Sex, PlayType"
          
          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
              tSex = LRs("Sex")
              crypt_tSex = crypt.EncryptStringENC(tSex)
              tSexName= LRs("SexName")
              tPlayType = LRs("PlayType")
              crypt_tPlayType= crypt.EncryptStringENC(tPlayType)
              tPlayTypeName= LRs("PlayTypeName")

              IF (reqSex = tSex) and  (reqPlayType = tPlayType) Then %>
                <option value="<%=crypt_tSex%>|<%=crypt_tPlayType%>" selected><%=tSexName & tPlayTypeName%></option>
              <%Else%>
                <option value="<%=crypt_tSex%>|<%=crypt_tPlayType%>" ><%=tSexName & tPlayTypeName%></option>
              <%End IF
              LRs.MoveNext()
              Loop
            End If   
          LRs.Close        
          %>
    </select>

    <% 'Response.Write " LSQL : " & LSQL & "<BR/>"  %>
    <select id="selTeamGb" name="selTeamGb"  onClick='OnGameLevelChanged(<%=strjson%>)'>
        <option value="">::부서 선택::</option>
      <%
        LSQL = " SELECT a.TeamGb, KoreaBadminton.dbo.FN_NameSch(a.TeamGb,'TeamGb') AS TeamGbNm, a.Sex,"
        LSQL = LSQL & " SexNm = (case a.Sex when  'man' then	'남자' when 'woman' then '여자' else  '혼합' End  )"
        LSQL = LSQL & " FROM tblGameLevel a"
        LSQL = LSQL & " inner Join tblTeamGbInfo b on a.TeamGb = b.TeamGb and b.DelYN = 'N'"
        LSQL = LSQL & " WHERE a.DelYN = 'N'"
        LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "'"
        IF reqGroupGameGb <> "" Then
          LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
        End IF
        IF ReqSex <> "" Then
          LSQL = LSQL & " AND Sex = '" & ReqSex & "'"
        End IF
        IF ReqPlayType <> "" Then
          LSQL = LSQL & " AND PlayType = '" & ReqPlayType & "'"
        End IF
        LSQL = LSQL & " GROUP BY a.TeamGb, Sex"
        Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            tTeamGb = LRs("TeamGb")
            crypt_tTeamGb = crypt.EncryptStringENC(tTeamGb)
            tSexNm = LRs("SexNm")
            tSex = LRs("Sex")
            IF (reqTeamGb = tTeamGb) Then
            %>
            <option value="<%=crypt_tTeamGb%>|<%=tSex%>" selected ><%=LRs("TeamGbNM")%>-<%=tSexNm%></option>
            <% ELSE  %>
            <option value="<%=crypt_tTeamGb%>|<%=tSex%>" <%If TeamGb =  crypt.EncryptStringENC(LRs("TeamGb")) Then%>selected<%End If %>><%=LRs("TeamGbNM")%>-<%=tSexNm%></option>
            <% END IF
              LRs.MoveNext()
            Loop
          End If   
          LRs.Close         
        %>
        
    </select>
    <%'Response.Write "LSQL :" & LSQL & "<bR>"%>
       <select  id="selLevel" name="selLevel"  onClick='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::종목 선택::</option>
        <% 
            LSQL = " SELECT Level, KoreaBadminton.dbo.FN_NameSch(Level,'Level') AS LevelNm , KoreaBadminton.dbo.FN_NameSch(leveljooName, 'PubCode') AS LevelJooNameNm, LevelJooName,LevelJooNum "
            LSQL = LSQL & " FROM tblGameLevel "
            LSQL = LSQL & " WHERE DelYN = 'N' "
            LSQL = LSQL & " AND UseYN = 'Y' "
            LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "' "
            IF reqGroupGameGb <> "" Then
              LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
            End IF
            IF ReqSex <> "" Then
              LSQL = LSQL & " AND Sex = '" & ReqSex & "'"
            End IF
            IF ReqPlayType <> "" Then
              LSQL = LSQL & " AND PlayType = '" & ReqPlayType & "'"
            End IF
            IF reqTeamGb <> "" Then
              LSQL = LSQL & " AND TeamGb = '" & reqTeamGb & "'"
            End IF
            LSQL = LSQL & " AND Level <> '' "
            LSQL = LSQL & " And (LevelJooName <> '' or LevelJooName <> 'B0120007') "
            LSQL = LSQL & " GROUP BY Level, leveljooName, LevelJooNum"
            
             Set LRs = Dbcon.Execute(LSQL)
                IF Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                  tLevel = LRs("Level")
                  crypt_tLevel = crypt.EncryptStringENC(tLevel)
                  tLevelNM = LRs("LevelNm")

                  tLevelJooName = LRs("LevelJooName")
                  crypt_tLevelJooName = crypt.EncryptStringENC(tLevelJooName)

                  tLevelJooNameNm= LRs("LevelJooNameNm")

                  IF(tLevelJooNameNm = "미선택") Then
                    tLevelJooNameNm = ""
                  End IF

                  tLevelJooNum = LRs("LevelJooNum") 
                  IF (reqLevel = tLevel) AND (reqLevelJooName = tLevelJooName) And (reqLevelJooNum = tLevelJooNum) Then%>      
                    <option value="<%=crypt_tLevel%>|<%=crypt_tLevelJooName%>|<%=tLevelJooNum%>" selected> <%=tLevelNM & " " & tLevelJooNameNm & " " & tLevelJooNum%>조</option>
                  <%ELSE%>
                    <option value="<%=crypt_tLevel%>|<%=crypt_tLevelJooName%>|<%=tLevelJooNum%>"> <%=tLevelNM & " " & tLevelJooNameNm & " " & tLevelJooNum%>조</option>
                  <%
                  END IF
                    LRs.MoveNext()
                  Loop
                End If   
              LRs.Close %>
    </select>	
    <%'Response.Write "LSQL :" & LSQL & "<bR>"%>
    <select id="selRanking" name="selRanking"  onChange='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::랭킹 선택::</option>
        <% 
            LSQL = " Select TRanking"
            LSQL = LSQL & " From "
            LSQL = LSQL & " ( "
            LSQL = LSQL & " SELECT Distinct ROW_NUMBER() OVER ( PARTITION BY AAAA.GameLevelDtlidx ORDER BY WinCnt DESC, WinPerc DESC, PointDiff DESC, WinPoint DESC) AS TRanking "
            LSQL = LSQL & " FROM"
            LSQL = LSQL & " ("
            LSQL = LSQL & " 	SELECT GameLevelDtlidx, CONVERT(FLOAT,WinCnt) AS WinCnt, CONVERT(FLOAT,GameCnt) AS GameCnt, Round(CONVERT(FLOAT,(CONVERT(FLOAT,WinCnt) / CONVERT(FLOAT,GameCnt)) * 100),2) AS WinPerc, LoseCnt, WinPoint, LosePoint, CONVERT(FLOAT,WinPoint) - CONVERT(FLOAT,LosePoint) AS PointDiff "
            LSQL = LSQL & "   	FROM ( "
            LSQL = LSQL & " 	    SELECT"
            LSQL = LSQL & " 	      AA.GamelevelDtlIDX, SUM(AA.WinCnt) AS WinCnt,  SUM(AA.LoseCnt) AS LoseCnt,  SUM(AA.GameCnt) AS GameCnt, dbo.FN_WinGroupPoint(AA.GameLevelDtlidx, AA.Team, AA.TeamDtl) AS WinPoint,  dbo.FN_LoseGroupPoint(AA.GameLevelDtlidx, AA.Team, AA.TeamDtl) AS LosePoint "
            LSQL = LSQL & " 		      FROM ( "
            LSQL = LSQL & " 		        SELECT  A.GamelevelDtlIDX,  A.Team, A.TeamDtl, CASE WHEN dbo.FN_NameSch(B.Result,'PubType') = 'WIN' THEN 1 ELSE 0 END AS WinCnt, CASE WHEN dbo.FN_NameSch(B.Result,'PubType') = 'LOSE' THEN 1 ELSE 0 END AS LoseCnt, 1 AS GameCnt "
            LSQL = LSQL & " 		          FROM ( "
            LSQL = LSQL & " 		                SELECT GamelevelDtlIDX, Team, TeamDtl "
            LSQL = LSQL & " 		                FROM tblTourneyTeam "
            LSQL = LSQL & " 			              WHERE DelYN = 'N'"
            LSQL = LSQL & " 			            AND "
            LSQL = LSQL & " 			              ( "
              If IsArray(Arr_Info) Then
                For i = 0 To UBOUND(Arr_Info,2)
                  If i = 0 Then
                    LSQL = LSQL & "       GameLevelDtlidx = '" & Arr_Info(0,i) & "'"
                  Else
                    LSQL = LSQL & "       OR GameLevelDtlidx = '" & Arr_Info(0,i) & "'"
                  End If
                NEXT
              Else
                LSQL = LSQL & "       DelYN = 'Nothing'"
              End If

            LSQL = LSQL & "       )"
            LSQL = LSQL & " 			GROUP BY GamelevelDtlIDX, Team, TeamDtl"
            LSQL = LSQL & " 			) AS A"
            LSQL = LSQL & " 		LEFT JOIN tblGroupGameResult B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND A.Team + A.TeamDtl = B.Team + B.TeamDtl "
            LSQL = LSQL & " 		AND B.DelYN = 'N'"
            LSQL = LSQL & " 		WHERE ISNULL(A.Team,'') <> ''"
            LSQL = LSQL & " 		) AS AA"
            LSQL = LSQL & " 		GROUP BY GamelevelDtlIDX, Team, TeamDtl"
            LSQL = LSQL & " 	) AS AAA"
            LSQL = LSQL & " ) AS AAAA"
            LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = AAAA.GameLevelDtlidx"
            LSQL = LSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
            LSQL = LSQL & " WHERE C.DelYN = 'N'"
            LSQL = LSQL & " AND D.DelYN = 'N'"
            LSQL = LSQL & " ) CC "

            Set LRs = Dbcon.Execute(LSQL)
            IF Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof  
                tRanking = LRs("TRanking")
                  %>
                    <option value="<%=tRanking%>"> <%=tRanking%> 위</option>
                  <%
                LRs.MoveNext()
              Loop
            End If   
            LRs.Close 
      %>
    </select>
    <%'Response.Write "LSQL :" & LSQL & "<bR>"%>


    <a href='javascript:OnRankingResultClick(<%=strjson%>)'>조회</a>
    <a href='javascript:OnRankingResultExcelClick(<%=strjson%>);'>출력</a>
    <a href='javascript:OnFinalTournamentClick(<%=strjson%>)'>본선진출</a>

	<!-- s: 검색 -->
	</div>
	<!-- e: 검색 -->
	<!-- s: 리스트 table -->
	<div class="list_box">
    <!--
		<div class="page_title clearfix">
			<h2>
				<span class="red_font">
					[<span class="txt">일반부</span>
					<span class="division">|</span>
					<span class="txt">혼합복식</span>
					<span class="division">|</span>
					<span class="txt">40대D</span>]
				</span>
				예선 최종결과
			</h2>
		</div>
    -->
    <span id="LoadSpan" name="LoadSpan"></span>
    <div id="DP_TeamGbResult">
      <table cellspacing="0" cellpadding="0">
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
        
        <!--
        <%
          '해당 단체전대진표 랭킹구하기
          

          LSQL = " SELECT dbo.FN_NameSch(D.TeamGb,'TeamGb') AS TeamGbNM, dbo.FN_NameSch(C.Level,'Level') AS LevelNM, C.PlayLevelType, C.LevelJooNum AS LevelDtlJooNum , AAAA.GameLevelDtlidx, Team, TeamDtl, WinCnt, GameCnt, WinPerc, LoseCnt, WinPoint, LosePoint, PointDiff, "
          LSQL = LSQL & " CASE WHEN ISNULL(TeamDtl,'0') = '0' THEN '' ELSE TeamDtl END AS TeamDtlNM,"
          LSQL = LSQL & " dbo.FN_NameSch(Team,'Team') AS TeamNM,"
          LSQL = LSQL & " ROW_NUMBER() OVER ( PARTITION BY AAAA.GameLevelDtlidx ORDER BY WinCnt DESC, WinPerc DESC, PointDiff DESC, WinPoint DESC) AS TRanking"
          LSQL = LSQL & " FROM"
          LSQL = LSQL & " ("
          LSQL = LSQL & " 	SELECT GameLevelDtlidx, Team, TeamDtl , CONVERT(FLOAT,WinCnt) AS WinCnt, CONVERT(FLOAT,GameCnt) AS GameCnt, "
          LSQL = LSQL & " 	CONVERT(FLOAT,(CONVERT(FLOAT,WinCnt) / CONVERT(FLOAT,GameCnt)) * 100) AS WinPerc,"
          LSQL = LSQL & " 	LoseCnt, WinPoint, LosePoint, CONVERT(FLOAT,WinPoint) - CONVERT(FLOAT,LosePoint) AS PointDiff"
          LSQL = LSQL & " 	FROM"
          LSQL = LSQL & " 		("
          LSQL = LSQL & " 		SELECT AA.GamelevelDtlIDX, AA.Team, AA.TeamDtl, SUM(AA.WinCnt) AS WinCnt, SUM(AA.LoseCnt) AS LoseCnt, SUM(AA.GameCnt) AS GameCnt,"
          LSQL = LSQL & " 		dbo.FN_WinGroupPoint(AA.GameLevelDtlidx, AA.Team, AA.TeamDtl) AS WinPoint,"
          LSQL = LSQL & " 		dbo.FN_LoseGroupPoint(AA.GameLevelDtlidx, AA.Team, AA.TeamDtl) AS LosePoint"
          LSQL = LSQL & " 		FROM"
          LSQL = LSQL & " 			("
          LSQL = LSQL & " 			SELECT A.GamelevelDtlIDX, A.Team, A.TeamDtl, "
          LSQL = LSQL & " 			CASE WHEN dbo.FN_NameSch(B.Result,'PubType') = 'WIN' THEN 1 ELSE 0 END AS WinCnt,"
          LSQL = LSQL & " 			CASE WHEN dbo.FN_NameSch(B.Result,'PubType') = 'LOSE' THEN 1 ELSE 0 END AS LoseCnt,"
          LSQL = LSQL & " 			1 AS GameCnt"
          LSQL = LSQL & " 			FROM"
          LSQL = LSQL & " 			("
          LSQL = LSQL & " 			SELECT GamelevelDtlIDX, Team, TeamDtl"
          LSQL = LSQL & " 			FROM tblTourneyTeam"
          LSQL = LSQL & " 			WHERE DelYN = 'N'"
          LSQL = LSQL & " 			AND "
          LSQL = LSQL & " 			(GameLevelDtlidx = '1193' OR GameLevelDtlidx = '1194' OR GameLevelDtlidx = '1195' OR GameLevelDtlidx = '1196')"
          LSQL = LSQL & " 			GROUP BY GamelevelDtlIDX, Team, TeamDtl"
          LSQL = LSQL & " 			) AS A"
          LSQL = LSQL & " 		LEFT JOIN tblGroupGameResult B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND A.Team + A.TeamDtl = B.Team + B.TeamDtl "
          LSQL = LSQL & " 		AND B.DelYN = 'N'"
          LSQL = LSQL & " 		WHERE ISNULL(A.Team,'') <> ''"
          LSQL = LSQL & " 		) AS AA"
          LSQL = LSQL & " 		GROUP BY GamelevelDtlIDX, Team, TeamDtl"
          LSQL = LSQL & " 	) AS AAA"
          LSQL = LSQL & " ) AS AAAA"
          LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = AAAA.GameLevelDtlidx"
          LSQL = LSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
          LSQL = LSQL & " WHERE C.DelYN = 'N'"
          LSQL = LSQL & " AND D.DelYN = 'N'"
         
          

          Set LRs = Dbcon.Execute(LSQL)

          If Not (LRs.Eof Or LRs.Bof) Then		

            Do Until LRs.Eof		
        %>
      
        <tr>
          <td>
            <select>
              <option value="1">=순위선택=</option>
              <option value="1">1위</option>
              <option value="2">2위</option>
              <option value="3">3위</option>
              <option value="4">4위</option>
            </select>
          </td>
          <td><%=LRs("TeamGbNM")%>
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
          End If
        %>
        -->
      </table>
       <%'Response.Write "LSQL"& LSQL & "<BR/>"%>
    </div>
	</div>
	<!-- e: 리스트 table -->
	<script>
		function popupOpen(addrs, w, h){
			if (w === undefined)
				w = 1280;
			if (h === undefined)
				h = 747;
			var popWidth = w; // 팝업창 넓이
			var popHeight = h; // 팝업창 높이
			var winWidth = document.body.clientWidth; // 현재창 넓이
			var winHeight = document.body.clientHeight; // 현재창 높이
			var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
			var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표
			var popLeftPos = (winX + (winWidth - popWidth) / 2); // 팝업 x 가운데
			var popTopPos = (winY + (winHeight - popHeight) / 2)-100; // 팝업 y 가운데


			var popUrl = addrs; //팝업창에 출력될 페이지 URL
			var popOption = "left="+popLeftPos+", top="+popTopPos+", width="+popWidth+", height="+popHeight+", resizable=no, scrollbars=yes, status=no;";    //팝업창 옵션(optoin)
			window.open(popUrl,"",popOption);
		}
	</script>
</div>
<!-- E: content -->

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>