<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<script type="text/javascript" src="../../js/GameNumber/autoGameSchedule.js"></script>

<style>
	#left-navi{display:none;}
	#header{display:none;}
</style>
<%
	Const PersonGame = "B0030001"
  Const GroupGame = "B0030002"
  Const const_Empty = "empty"
%>
<%
	tGameTitleIdx = Request("GameTitleIdx")
	tStadiumIDX = Request("StadiumIDX")
	tGroupGameGb = Request("GroupGameGb")
	tTeamGb = Request("TeamGb")
	tLevelJooName = Request("LevelJooName")
	tLevel = Request("Level")
	tLevelJooName = Request("LevelJooName")
	tPlayLevelType = Request("PlayLevelType")
	tPlayType = Request("PlayType")
	tSex= Request("Sex")
	

	If ISNull(tGameTitleIdx) Or tGameTitleIdx = "" Then
		GameTitleIDX = ""
		DEC_GameTitleIDX = ""
	Else
		GameTitleIDX = fInject(tGameTitleIdx)
		DEC_GameTitleIDX = fInject(crypt.DecryptStringENC(tGameTitleIdx))    
	End If
	
	If ISNull(tStadiumIDX) Or tStadiumIDX = "" Then
		StadiumIDX = 0
		DEC_StadiumIDX = 0
	Else
		StadiumIDX = fInject(tStadiumIDX)
		DEC_StadiumIDX = fInject(crypt.DecryptStringENC(tStadiumIDX))    
	End If

	If ISNull(tGroupGameGb) Or tGroupGameGb = "" Then
		GroupGameGb = const_Empty
		DEC_GroupGameGb = const_Empty
	Else
		GroupGameGb = fInject(tGroupGameGb)
		DEC_GroupGameGb =  fInject(tGroupGameGb)
	End If
	
	If ISNull(tTeamGb) Or tTeamGb = "" Then
		TeamGb = const_Empty
		DEC_TeamGb = const_Empty
	Else
		TeamGb = fInject(tTeamGb)
		DEC_TeamGb =  fInject(tTeamGb)
	End If

	If ISNull(tLevelJooName) Or tLevelJooName = "" Then
		LevelJooName = const_Empty
		DEC_LevelJooName = const_Empty
	Else
		LevelJooName = fInject(tLevelJooName)
		DEC_LevelJooName =  fInject(tLevelJooName)   
	End If

	If ISNull(tLevel) Or tLevel = ""Then
		Level = const_Empty
		DEC_Level = const_Empty
	Else
		Level = fInject(tLevel)
		DEC_Level =  fInject(tLevel)   
	End If


	If ISNull(tPlayLevelType) Or tPlayLevelType = "" Then
		PlayLevelType = const_Empty
		DEC_PlayLevelType =const_Empty
	Else
		PlayLevelType = fInject(tPlayLevelType)
		DEC_PlayLevelType =  fInject(tPlayLevelType)   
	End If

	If ISNull(tPlayType) Or tPlayType = "" Then
		PlayType = const_Empty
		DEC_PlayType =const_Empty
	Else
		PlayType = fInject(tPlayType)
		DEC_PlayType =  fInject(tPlayType)   
	End If

	If ISNull(tSex) Or tSex = "" Then
		Sex = const_Empty
		DEC_Sex =const_Empty
	Else
		Sex = fInject(tSex)
		DEC_Sex=  fInject(tSex)   
	End If


	

  
  
	DEC_GameTitleIDX = 696



%>
<!-- S: content -->


<div class="ranking_result_popup autogameschedule">
	<div class="top_title">
		<h2>대회명 : [<span id="span_GameTitleName"></span>] - 진행순서관리</h2>
			<a href="javascript:GameScheduleView();" class="r-link">
			<i class="fas fa-list"></i>
			<span>경기순서 리스트</span>
			<i class="fas fa-chevron-right"></i>
		</a>
	</div>
	<!-- s: 검색 -->
	<div class="search_box" id="divGameLevelMenu">
		<%
			Admin_Authority = crypt.DecryptStringENC(Request.Cookies(global_HP)("Authority"))
			Admin_UserID = crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))
		%>

		<%
			IF (Admin_Authority <> "O") Then
				Dim tblGameTitleCnt :tblGameTitleCnt = 0
				LSQL = " SELECT GameTitleIDX, GameTitleName"
				LSQL = LSQL & " FROM tblGameTitle "
				LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = '" & DEC_GameTitleIDX & "'" 
				Set LRs = Dbcon.Execute(LSQL)

				IF Not (LRs.Eof Or LRs.Bof) Then
					Do Until LRs.Eof
						tblGameTitleCnt = tblGameTitleCnt + 1
						tGameTitleName = LRs("GameTitleName")
						crypt_GameTitleIDX =  crypt.EncryptStringENC(LRs("GameTitleIDX"))
						LRs.MoveNext()
					Loop
				End If   
				LRs.Close         

				IF cdbl(tblGameTitleCnt) = 0 Then
					LSQL = " SELECT Top 1 GameTitleIDX, GameTitleName"
					LSQL = LSQL & " FROM tblGameTitle "
					LSQL = LSQL & " WHERE DelYN = 'N' " 
					LSQL = LSQL & " Order By WriteDate desc " 

					Set LRs = Dbcon.Execute(LSQL)

					IF Not (LRs.Eof Or LRs.Bof) Then
						Do Until LRs.Eof
							crypt_GameTitleIDX =  crypt.EncryptStringENC(LRs("GameTitleIDX"))
							tGameTitleName = LRs("GameTitleName")
							LRs.MoveNext()
						Loop
					End If   
					LRs.Close         
				End IF
		%>
		<input type="text" name="strGameTtitle" id="strGameTtitle" placeholder="검색할 대회명을 입력해 주세요." value="<%=tGameTitleName%>" style="width:750px">
		<input type="hidden" name="selGameTitleIdx" id="selGameTitleIdx" value="<%=crypt_GameTitleIDX%>">
		<% Else%>
			<select id="selGameTitleIdx" name="selGameTitleIdx"  onchange="OnGameTitleChanged(this.value)">
				<option value="">::대회 선택::</option>
					<% 
							Dim GameTitleIdxCnt : GameTitleIdxCnt = 0
							LSQL = " SELECT a.GameTitleIDX, a.GameTitleName"

							LSQL = LSQL & " FROM tblGameTitle a "
							LSQL = LSQL & " INNER JOIN tblAdminGameTitle d on d.AdminID = '" & Admin_UserID &"' And a.GameTitleIDX = d.GameTitleIDX " 
							LSQL = LSQL & " WHERE a.DelYN = 'N'" 
							Set LRs = Dbcon.Execute(LSQL)

							IF Not (LRs.Eof Or LRs.Bof) Then
									Do Until LRs.Eof
										GameTitleIdxCnt = GameTitleIdxCnt  + 1
										tGameTitleIdx = LRs("GameTitleIDX")
										crypt_tGameTitleIdx = crypt.EncryptStringENC(tGameTitleIdx)
										tGameTitleName = LRs("GameTitleName")
							
										IF(Len(DEC_GameTitleIDX) = 0 ) Then
											IF (GameTitleIdxCnt = 1) Then
												DEC_GameTitleIDX = tGameTitleIdx
												crypt_GameTitleIDX = crypt.EncryptStringENC(DEC_GameTitleIDX)
											End IF
										End IF

										If CDBL(DEC_GameTitleIDX) = CDBL(tGameTitleIdx)Then 
											%>
												<option value="<%=crypt_tGameTitleIdx%>" selected> <%=tGameTitleName%></option>
											<% Else %>
												<option value="<%=crypt_tGameTitleIdx%>" > <%=tGameTitleName%></option>
											<%
										End IF
									LRs.MoveNext()
								Loop
							End If   
							LRs.Close         
					%>
			</select>
		<% End IF %>
	<input type="text" class="date_ipt" id="initDatePicker" name="initDatePicker">
		<a href="javascript:OnGameTitleSearch();">조회</a>
		<a href="javascript:printLevelGame();" class="white-btn">경기 전체 출력</a>
	</div>
	<!-- e: 검색 -->
	<!-- s: 버튼 선택 -->
	<div class="btn-select" id="divGameLevelList" name="divGameLevelList">
		<ul>
			<li>
				<div class="l-name">경기구분</div>
				<div class="r-con">
 				<%
          LSQL = " SELECT GroupGameGb, ISNULL(GroupGameGbNM,'') AS GroupGameGbNM  "
          LSQL = LSQL & " FROM "
          LSQL = LSQL & " ("
          LSQL = LSQL & " SELECT C.GroupGameGb,dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM"
          LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
          LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
          LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON C.GameLevelidx = B.GameLevelidx AND C.DelYN ='N'  "
          LSQL = LSQL & " WHERE A.DelYN = 'N'"
          LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
          LSQL = LSQL & " "
          LSQL = LSQL & " UNION ALL"
          LSQL = LSQL & " "
          LSQL = LSQL & " SELECT C.GroupGameGb,dbo.FN_NameSch(C.GroupGameGb, 'PubCode') AS GroupGameGbNM"
          LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
          LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl B ON A.GameLevelDtlidx = B.GameLevelDtlidx AND B.DelYN ='N' "
          LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevel C ON C.GameLevelidx = B.GameLevelidx AND C.DelYN ='N'  "
          LSQL = LSQL & " WHERE A.DelYN = 'N'"
          LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
          LSQL = LSQL & " ) AS AA"
          LSQL = LSQL & " WHERE AA.GroupGameGb <> ''"
          LSQL = LSQL & " GROUP BY AA.GroupGameGb,AA.GroupGameGbNM"
          'Response.Write "LSQL" & LSQL & "<BR/>"
          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
          %>
           
          <%
            Do Until LRs.Eof
            tGroupGameGbNM =LRs("GroupGameGbNM")
            tGroupGameGb =LRs("GroupGameGb")

            IF tGroupGameGbNM ="" Then
              tGroupGameGbNM ="Null"
            End IF

            %>
            <a href="javascript:OnGroupGameGbChanged('<%=tGroupGameGb%>','<%=tGroupGameGbNM%>')"  <%If tGroupGameGb = DEC_GroupGameGb Then%> class="active" <%End IF%> ><%=tGroupGameGbNM%></a>
            <%
              LRs.MoveNext
            Loop
            %>
            <span class="code-box">
           		<input type="text" id="txtStartCourt" value="<%=DEC_StartCourt%>"  onchange="javascript:OnStartCourtChanged(this.value);"/>
              <span class="txt">코트 ~</span>
              <input type="text" id="txtEndCourt" value="<%=DEC_EndCourt%>"  onchange="javascript:OnEndCourtChanged(this.value);"/>
              <span class="txt">코트</span>
					  </span>
					<%
						End If
						LRs.Close
					%>
         </div>
			</li>
		
			<li>
				<div class="l-name">종목</div>
				<div class="r-con">
				<%
					LSQL = " SELECT TeamGb, ISNULL(TeamGbNm,'') AS TeamGbNm "
					LSQL = LSQL & " FROM "
					LSQL = LSQL & " ("
					LSQL = LSQL & " SELECT A.TeamGb, D.TeamGbNm"
					LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
					LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
					LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
					LSQL = LSQL & " Left Join KoreaBadminton.dbo.tblTeamGbInfo D ON A.TeamGb = D.TeamGb AND D.DelYN ='N' "
					LSQL = LSQL & " WHERE A.DelYN = 'N'"
					LSQL = LSQL & " AND B.DelYN = 'N'"
					LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
							IF DEC_GroupGameGb <> "empty" Then
					LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
					End IF
					LSQL = LSQL & " AND A.TeamGb IS NOT NULL"
					LSQL = LSQL & " "
					LSQL = LSQL & " UNION ALL"
					LSQL = LSQL & " "
					LSQL = LSQL & " SELECT A.TeamGb, D.TeamGbNm"
					LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
					LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
					LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
					LSQL = LSQL & " Left Join KoreaBadminton.dbo.tblTeamGbInfo D ON A.TeamGb = D.TeamGb AND D.DelYN ='N' "
					LSQL = LSQL & " WHERE A.DelYN = 'N'"
					LSQL = LSQL & " AND B.DelYN = 'N'"
					LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
					IF DEC_GroupGameGb <> "empty" Then
						LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
					End IF
					LSQL = LSQL & " AND A.TeamGb IS NOT NULL"
					LSQL = LSQL & " ) AS AA"
					LSQL = LSQL & " WHERE AA.TeamGb <> ''"
					LSQL = LSQL & "    GROUP BY AA.TeamGb,AA.TeamGbNm"
					'Response.Write "LSQL" & LSQL & "<BR/>"
					Set LRs = Dbcon.Execute(LSQL)
					If Not (LRs.Eof Or LRs.Bof) Then
						Do Until LRs.Eof
						tTeamGbNm =LRs("TeamGbNm")
						tTeamGb =LRs("TeamGb")

						IF tTeamGbNm ="" Then
							tTeamGbNm ="Null"
						End IF
						%>
						<a href="javascript:OnTeamGbChanged('<%=tTeamGb%>','<%=tTeamGbNm%>');" <%If tTeamGb = DEC_TeamGb Then%> class="active" <%End IF%>><%=tTeamGbNm%></a>
						<%
							LRs.MoveNext
						Loop
					End If
					LRs.Close
				%>
				</div>
			</li>

			<li>
      <div class="l-name">종목구분</div>
      <div class="r-con">
      <%
        LSQL = " SELECT Sex, dbo.FN_NameSch(Sex, 'PubCode') AS SexNM, PlayType, dbo.FN_NameSch(PlayType, 'PubCode') AS PlayTypeNM "
        LSQL = LSQL & " FROM "
        LSQL = LSQL & " ("
        LSQL = LSQL & " SELECT B.Sex, B.PlayType "
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
        IF DEC_GroupGameGb <> "empty" Then
        LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
        End IF
        LSQL = LSQL & " AND A.TeamGb IS NOT NULL"
        LSQL = LSQL & " "
        LSQL = LSQL & " UNION ALL"
        LSQL = LSQL & " "
        LSQL = LSQL & " SELECT B.Sex, B.PlayType "
        LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
        LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
        LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
        LSQL = LSQL & " WHERE A.DelYN = 'N'"
        LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
        IF DEC_GroupGameGb <> "empty" Then
          LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
        End IF
        LSQL = LSQL & " AND A.TeamGb IS NOT NULL"
        LSQL = LSQL & " ) AS AA"
        LSQL = LSQL & " WHERE AA.PlayType <> '' And AA.Sex <> ''"
        LSQL = LSQL & "  GROUP BY AA.Sex,AA.PlayType"
        'Response.Write "LSQL" & LSQL & "<BR/>"
        Set LRs = Dbcon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof
          rSex =LRs("Sex")
          rSexNM =LRs("SexNM")
          rPlayType =LRs("PlayType")
          rPlayTypeNM =LRs("PlayTypeNM")
          %>
          <a href="javascript:OnSexPlayTypeChanged('<%=rSex%>','<%=rSexNM%>','<%=rPlayType%>','<%=rPlayTypeNM%>');" <%If rSex = DEC_Sex And rPlayType = DEC_PlayType Then%> class="active" <%End IF%>><%Response.Write Left(rSexNM,1) & Left(rPlayTypeNM,1) %></a>
          <%
            LRs.MoveNext
          Loop
        ELSE
        %>
          <span style="font-weight:bold;">등록된 종목이 없습니다.</span>
        <%            
        End If
        LRs.Close
      %>
      </div>
    </li>

			<li>
				<div class="l-name">급수</div>
				<div class="r-con">
					<%
						LSQL = "  SELECT LevelJooName, ISNULL(LevelJooNameNM,'') AS LevelJooNameNM, OrderBy"
						LSQL = LSQL & " FROM "
						LSQL = LSQL & " ("
						LSQL = LSQL & " SELECT B.LevelJooName,E.PubName AS LevelJooNameNM, E.OrderBy"
						LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
						LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
						LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
						LSQL = LSQL & " Left Join tblPubcode E ON B.LevelJooName = E.PubCode AND E.DelYN ='N'"
						LSQL = LSQL & " WHERE A.DelYN = 'N'"
						LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
						IF DEC_GroupGameGb <> "empty" Then
							LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
						End IF
						IF DEC_TeamGb <> "empty" Then
							LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
						End IF
						LSQL = LSQL & " "
						LSQL = LSQL & " UNION ALL"
						LSQL = LSQL & " "
						LSQL = LSQL & " SELECT B.LevelJooName,E.PubName AS LevelJooNameNM, E.OrderBy"
						LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
						LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
						LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
						LSQL = LSQL & " Left Join tblPubcode E ON B.LevelJooName = E.PubCode AND E.DelYN ='N'"
						LSQL = LSQL & " WHERE A.DelYN = 'N'"
						LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
						IF DEC_GroupGameGb <> "empty" Then
							LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
						End IF
						IF DEC_TeamGb <> "empty" Then
							LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
						End IF
						LSQL = LSQL & " ) AS AA"
						LSQL = LSQL & " GROUP BY AA.LevelJooName, AA.LevelJooNameNM, AA.OrderBy"
						LSQL = LSQL & " Order by OrderBy "
						
						'Response.Write "LSQL" & LSQL & "<BR/>"
						Set LRs = Dbcon.Execute(LSQL)
						If Not (LRs.Eof Or LRs.Bof) Then
							Do Until LRs.Eof
							tLevelJooNameNM=LRs("LevelJooNameNM")
							tLevelJooName=LRs("LevelJooName")

							IF tLevelJooNameNM ="" Then
								tLevelJooNameNM = "미선택"
							End if
							%>
							<a href="javascript:OnLevelJooNameChanged('<%=tLevelJooName%>','<%=tLevelJooNameNM%>');" <%If tLevelJooName = DEC_LevelJooName Then%> class="active" <%End IF%>><%=tLevelJooNameNM%></a>
							<%
								LRs.MoveNext
							Loop
						End If
						LRs.Close
					%>
				</div>
			</li>
			<li>
				<div class="l-name">종별</div>
				<div class="r-con">
				<%
					LSQL = "   SELECT Level, ISNULL(LevelNm,'') AS LevelNm "
					LSQL = LSQL & " FROM "
					LSQL = LSQL & " ("
					LSQL = LSQL & " SELECT  B.Level ,E.LevelNm "
					LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
					LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
					LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
					LSQL = LSQL & " Left Join tblLevelInfo E ON B.Level = E.Level AND E.DelYN ='N'"
					LSQL = LSQL & " WHERE A.DelYN = 'N'"
					LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
					IF DEC_GroupGameGb <> "empty" Then
						LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
					End IF

					IF DEC_TeamGb <> "empty" Then
						LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
					End IF

					IF DEC_LevelJooName <> "empty" Then
						LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
					End IF

					LSQL = LSQL & " "
					LSQL = LSQL & " UNION ALL"
					LSQL = LSQL & " "
					LSQL = LSQL & " SELECT  B.Level ,E.LevelNm"
					LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
					LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
					LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
					LSQL = LSQL & " Left Join tblLevelInfo E ON B.Level = E.Level AND E.DelYN ='N'"
					LSQL = LSQL & " WHERE A.DelYN = 'N'"
					LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
					IF DEC_GroupGameGb <> "empty" Then
						LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
					End IF

					IF DEC_TeamGb <> "empty" Then
						LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
					End IF

					IF DEC_LevelJooName <> "empty" Then
						LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
					End IF

					LSQL = LSQL & " ) AS AA"
					LSQL = LSQL & " GROUP BY  AA.Level ,AA.LevelNm"
					'LSQL = LSQL & " Order BY  AA.Level ,AA.LevelNm"
					'Response.Write "LSQL" & LSQL & "<BR/>"
					'Response.End
					Set LRs = Dbcon.Execute(LSQL)
					If Not (LRs.Eof Or LRs.Bof) Then
						Do Until LRs.Eof
						tLevelNm=LRs("LevelNm")
						tLevel=LRs("Level")
						IF tLevelNm ="" Then
							tLevelNm = "미선택"
						End if
						%>
						<a href="javascript:OnLevelChanged('<%=tLevel%>','<%=tLevelNm%>');" <%If tLevel = DEC_Level Then%> class="active" <%End IF%> ><%=tLevelNm%></a>
						<%
							LRs.MoveNext
						Loop
					End If
					LRs.Close
					%>
				</div>
			</li>
		
			<li>
				<div class="l-name">경기유형</div>
			  <div class="r-con">
				<%
					LSQL = " SELECT PlayLevelType, ISNULL(PlayLevelTypeNM,'') AS PlayLevelTypeNM "
					LSQL = LSQL & " FROM "
					LSQL = LSQL & " ("
					LSQL = LSQL & " SELECT C.PlayLevelType, E.PubName AS PlayLevelTypeNM "
					LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourney A"
					LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
					LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
					LSQL = LSQL & " Left Join tblPubcode E ON C.PlayLevelType = E.PubCode AND E.DelYN ='N' "
					LSQL = LSQL & " WHERE A.DelYN = 'N'"
					LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
					IF DEC_GroupGameGb <> "empty" Then
						LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
					End IF

					IF DEC_TeamGb <> "empty" Then
						LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
					End IF

					IF DEC_LevelJooName <> "empty" Then
						LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
					End IF

					IF DEC_Level <> "empty" Then
						LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
					End IF
					LSQL = LSQL & " "
					LSQL = LSQL & " UNION ALL"
					LSQL = LSQL & " "
					LSQL = LSQL & " SELECT C.PlayLevelType, E.PubName AS PlayLevelTypeNM "
					LSQL = LSQL & " FROM KoreaBadminton.dbo.tblTourneyTeam A"
					LSQL = LSQL & " INNER JOIN KoreaBadminton.dbo.tblGameLevel B ON A.GameLevelIdx = B.GameLevelIdx AND B.DelYN ='N' "
					LSQL = LSQL & " INNER join KoreaBadminton.dbo.tblGameLevelDtl C ON A.GameLevelDtlidx = C.GameLevelDtlidx AND C.DelYN ='N' "
					LSQL = LSQL & " Left Join tblPubcode E ON C.PlayLevelType = E.PubCode AND E.DelYN ='N'"
					LSQL = LSQL & " WHERE A.DelYN = 'N'"
					LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
					IF DEC_GroupGameGb <> "empty" Then
						LSQL = LSQL & " AND B.GroupGameGb = '" & DEC_GroupGameGb & "'"
					End IF

					IF DEC_TeamGb <> "empty" Then
						LSQL = LSQL & " AND A.TeamGb = '" & DEC_TeamGb & "'"
					End IF

					IF DEC_LevelJooName <> "empty" Then
						LSQL = LSQL & " AND B.LevelJooName = '" & DEC_LevelJooName & "'"
					End IF

					IF DEC_Level <> "empty" Then
						LSQL = LSQL & " AND A.Level = '" & DEC_Level & "'"
					End IF
					LSQL = LSQL & " ) AS AA"
					LSQL = LSQL & " GROUP BY  AA.PlayLevelType ,AA.PlayLevelTypeNM"
					'Response.Write "LSQL" & LSQL & "<BR/>"
					
					Set LRs = Dbcon.Execute(LSQL)
					If Not (LRs.Eof Or LRs.Bof) Then
						Do Until LRs.Eof
						tPlayLevelTypeNM=LRs("PlayLevelTypeNM")
						tPlayLevelType=LRs("PlayLevelType")
						IF tPlayLevelTypeNM ="" Then
							tPlayLevelTypeNM = "미선택"
						End if
						%>
							<a href="javascript:OnPlayLevelTypeChanged('<%=tPlayLevelType%>','<%=tPlayLevelTypeNM%>');"<%If tPlayLevelType = DEC_PlayLevelType Then%> class="active" <%End IF%>><%=tPlayLevelTypeNM%></a>
						<%
							LRs.MoveNext
						Loop
					End If
					LRs.Close
				%>
				</div>
				</li>
			<li>
				<div class="l-name">경기장</div>
				<div class="r-con">
				<%
						LSQL = " SELECT StadiumIDX ,GameTitleIDX ,StadiumName ,StadiumCourt ,StadiumTime ,StadiumAddr ,StadiumAddrDtl "
						LSQL = LSQL & " FROM tblStadium A "
						LSQL = LSQL & " Where A.DelYN = 'N'"
						LSQL = LSQL & " AND A.GameTitleIDX = '" & DEC_GameTitleIDX & "'"
						
						Set LRs = Dbcon.Execute(LSQL)
						If Not (LRs.Eof Or LRs.Bof) Then
							Do Until LRs.Eof
							r_StadiumIDX = LRs("StadiumIDX")
							crypt_StadiumIDX = crypt.EncryptStringENC(r_StadiumIDX)
							r_StadiumName = LRs("StadiumName")
							IF LEN(r_StadiumName) > 6 Then
								r_StadiumName = Left(r_StadiumName,4) & ".."
							End IF
							r_StadiumCourt = LRs("StadiumCourt")
							%>
							<a href="javascript:OnStadiumChanged('<%=crypt_StadiumIDX%>','<%=r_StadiumName%>');"<%If CDBL(r_StadiumIDX) = CDBL(DEC_StadiumIDX) Then%> class="active" <%End IF%>><%=r_StadiumName%></a>
							<%
								LRs.MoveNext
							Loop
						End If            
						LRs.Close    
					%>
				</div>
			</li>
		</ul>
	</div>
	<!-- e: 버튼 선택 -->
	<!-- s: player-number -->
	<div class="player-number">
		<ul>
			<li>
				<span class="l-name">선택된 경기수</span>
				<span class="r-con">
					<span class="number" id="selGameCnt">0</span>
					<span class="txt">경기</span>
				</span>
			</li>
			<li>
				<span class="l-name">배정된 경기 / 총 경기수</span>
				<span class="r-con" title="배정된 경기 / 총경기">
					<span class="number" id="ApplyGameCnt">0</span>
					<span class="txt" >/</span>
					<span class="txt" id="TotalGameCnt">0</span>
				</span>
			</li>
			<li>
				<span class="l-name">진행률 경기수</span>
				<span class="r-con">
					<span class="percentage" id="GamePercent">0%</span>
					<a href="javascript:setAutoGameNumber();" class="red-btn">자동진행순서 적용</a>
				</span>
			</li>
		</ul>
	</div>
	<!-- e: player-number -->
	<!-- s: 리스트 table -->
	<div class="table-warp">
		<!-- s: table-one -->
		<div class="table-one" id="divGameScheduleStadium" name="divGameScheduleStadium">
			<ul>
				<li >
					<div class="l-con">
						<span class="name">경기장이 존재하지 않습니다.</span>
					</div>
				</li>
			</ul>
		</div>
		<!-- e: table-one -->
		<!-- s: table-tow -->
		<div class="table-tow" id="divAutoGameSchedule" name="divAutoGameSchedule">
			<!-- s: table-title -->
			<div class="table-title">
				<h2>선택된 체육관이 없습니다.</h2>
				<div class="r-btn">
					<a href="javascript:restoreAutoGameSchedule()">
						<i class="fas fa-undo copy"></i>
					</a>
					<a href="javascript:deleteAutoGameSchedule();">
						<i class="far fa-trash-alt"></i>
					</a>
				</div>
			</div>
			<!-- e: table-title -->
			<!-- s: table-list -->
			<div class="table-list">
				<table>
					<tr>
						<th>경기구분</th>
						<th>지정코트</th>
						<th>종별</th>
						<th>경기유형</th>
						<th>조</th>
						<th>경기수</th>
						<th>그룹</th>
						<th>순서</th>
						<th>
							<input type="checkbox" class="checkbox" id="allCheck" onClick="javascript:initControl();"/>
						</th>
					</tr>
					<tr>
						<td colspan="9">조회 결과가 없습니다.</td>
					</tr>
				</table>
			</div>
			<!-- e: table-list -->
		</div>
		<!-- e: table-tow -->
	</div>
	<!-- e: 리스트 table -->
</div>
<!-- E: content -->
<script type="text/javascript">
	var $tableTow = $(".autogameschedule .table-warp .table-tow");
	var $tableOne = $(".autogameschedule .table-warp .table-one").outerWidth(true);;
	var $windowWidth = $(window).width(); /* 윈도창 높이 */
	//$tableTow.css("width", $windowWidth - $tableOne - 80);

</script>
<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>