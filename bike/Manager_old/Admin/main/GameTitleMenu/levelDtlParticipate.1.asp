<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<script type="text/javascript" src="../../js/library/jquery.timepicker.min.js"></script>
<script type="text/javascript" src="../../js/GameTitleMenu/levelDtlParticipate.js"></script>

<%
	tIdx = fInject(crypt.DecryptStringENC(Request("tIdx")))  ' 현재페이지
	tGameLevelIdx = fInject(crypt.DecryptStringENC(Request("tGameLevelIdx")))  ' 현재페이지
	tGameLevelDtlIdx = fInject(crypt.DecryptStringENC(Request("tGameLevelDtlIdx")))  ' 현재페이지

	crypt_tGameLevelDtlIdx =crypt.EncryptStringENC(tGameLevelDtlIdx)
	crypt_tGameLevelIdx =crypt.EncryptStringENC(tGameLevelIdx)
	crypt_tIdx =crypt.EncryptStringENC(tIdx)

	isChkAllMember = true

	'Response.Write "tIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdxtIdx" & tIdx & "<br>"
	'Response.Write "tGameLevelIdxtGameLevelIdxtGameLevelIdxtGameLevelIdx" & tGameLevelIdx & "<br>"
	'Response.Write "tGameLevelDtlIdxtGameLevelDtlIdxtGameLevelDtlIdxtGameLevelDtlIdx" & tGameLevelDtlIdx & "<br>"

	NowPage = fInject(Request("i2"))  ' 현재페이지
 	PagePerData = 10  ' 한화면에 출력할 갯수
  BlockPage = 10      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴
  LCnt = 0
	'Request Data
	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))

	 If Len(NowPage) = 0 Then
		NowPage = 1
	End If
	if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어
%>

<script type="text/javascript">

	var selSearchValue = "<%=iSearchCol%>";
	var txtSearchValue = "<%=iSearchText%>";

	function WriteLink(i2) {
		post_to_url('./levelDtl.asp', { 'i2': i2, 'iType': '1' });
	}

	function ReadLink(i1, i2) {
		post_to_url('./levelDtl.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
	}

	function PagingLink(i2) {
   
		post_to_url('./levelDtl.asp', { 'i2': i2,'tGameLevelIdx' : '<%=tGameLevelIdx%>','iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

	function fn_selSearch() {
		selSearchValue = document.getElementById('selSearch').value;
		txtSearchValue = document.getElementById('txtSearch').value;
		post_to_url('./levelDtl.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}
</script>

<%

  LSQL = " SELECT Top 1 GameTitleName, EnterType  "
  LSQL = LSQL & " FROM  tblGameTitle "
  LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = " & tidx

  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tGameTitleName = LRS("GameTitleName")
			tEnterType = LRS("EnterType")
      LRs.MoveNext
    Loop
  End IF

	LSQL = " SELECT Top 1 e.PubName as GroupGameGb, b.TeamGbNm as TeamGbNm , Sex = (case a.Sex when  'man'then	'남자'when 'woman'then '여자'else '혼합'End ), c.PubName as PlayType, d.LevelNm as Level, a.GroupGameGb "
  LSQL = LSQL & "  FROM tblGameLevel a "
	LSQL = LSQL & "  LEFT JOIN tblTeamGbInfo b on a.TeamGb = b.TeamGb and b.DelYN ='N' "
	LSQL = LSQL & "  LEFT JOIN tblPubcode c on a.PlayType = c.PubCode and  c.DelYN ='N' "
	LSQL = LSQL & "  LEFT JOIN tblLevelInfo d on a.Level  = d.Level and d.DelYN = 'N' "
	LSQL = LSQL & "  LEFT JOIN tblPubcode e on a.GroupGameGb = e.PubCode and e.DelYN ='N' "	
  LSQL = LSQL & " WHERE a.DelYN = 'N' and GameTitleIDX = " & tidx & " and a.GameLevelidx = " & tGameLevelIdx
	'Response.Write "LSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQL" & LSQL
  Set LRs = DBCon.Execute(LSQL)
   IF NOT (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      tTeamGbNm = LRS("TeamGbNm")
			tSex = LRS("Sex")
			tPlayType = LRS("PlayType")
			tLevel = LRS("Level")
			tGroupGameGb = LRS("GroupGameGb")
			crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
      LRs.MoveNext
    Loop
  End IF

	'Response.WRite "tGroupGameGbtGroupGameGbtGroupGameGbtGroupGameGbtGroupGameGb" & crypt_tGroupGameGb & "<br>"
%>


<div id="content">
		<!-- S: page_title -->
	<div class="page_title clearfix">
		<h2>참가팀 분류</h2>
		<a  href="javascript:href_back('<%=crypt_tIdx%>','<%=crypt_tGameLevelIdx%>',1);" class="btn btn-back">뒤로가기</a>

		<!-- S: 네비게이션 -->
		<div  class="navigation_box">
			<span class="ic_deco">
				<i class="fas fa-angle-right fa-border"></i>
			</span>
			<ul>
				<li>어드민 정보</li>
				<li>대회운영</li>
				<li>대회</li>
				<li>대회종목</li>
				<li>대진표</li>
				<li>참가팀 분류</li>
			</ul>
		</div>
		<!-- E: 네비게이션 -->
	</div>
	<!-- E: page_title -->


	<!-- S : 내용 시작 -->
	<div class="contents">
		<input type="hidden" id="selGameLevelDtlIdx" value="<%=crypt_tGameLevelDtlIdx%>">
		<input type="hidden" id="selGameLevelIdx" value="<%=crypt_tGameLevelIdx%>">
		<input type="hidden" id="selGameIdx" value="<%=crypt_tIdx%>">
		<input type="hidden" id="selGroupGameGb" value="<%=crypt_tGroupGameGb%>">
		<h3 class="top-navi-tit">
		<!-- 종목 -->
		<div class="title_scroll"  style="float: left; width: 45%;">
			<div >
				<table class="sch-table">
					<colgroup>
						<col width="64px">
						<col width="*">
						<col width="64px">
						<col width="*">
						<col width="94px">
						<col width="*">
						<col width="94px">
						<col width="*">
					</colgroup>
					<tbody>
					<tr>
						<td>
							<input type="text" name="strMember" id="strMember" placeholder="팀명 및 선수명으로 검색하세요">
							<input type="checkbox" id="chkAllMember" name="chkAllMember" onclick="javascript:FindAllUser(this.checked)" <% if isChkAllMember = true Then %>checked<% end if%>>
							<label for="chkAllMember">팀 전체</label>
							<a href="javascript:searchLevelMember();"  class="btn btn-search">검색</a>
						</td>
					</tr>
					</tbody>
				</table>
			</div>
			<div id="divLevelDtlMember" name="divLevelDtlMember" >
				<table class="table-list game-ctr">
					<thead>
						<tr>
							<th>번호</th>
							<th>선택</th>
							<th>종별 참가 신청팀</th>
							<th><a class="btn list-btn btn-blue">선택참가</a></th>
						</tr>
					</thead>
					<tbody id="DP_LevelDtlList">
						<%
								if tGroupGameGb = "B0030001" Then
								LSQL = " SELECT  a.GameRequestGroupIDX as TeamIDX, Isnull(b.TeamNm,'') + '(' + Isnull((STUFF((SELECT ',' + MemberName  FROM tblGameRequestPlayer c where a.GameRequestGroupIDX = c.GameRequestGroupIDX and c.DelYN = 'N'  For XML PATH('')),1,1,'')) ,'') + ')' AS TeamTitleNames   "
								LSQL = LSQL & " FROM tblGameRequestGroup a"
								LSQL = LSQL & " LEFT JOIN tblTeamInfo b on a.Team = b.Team and b.DelYN='N'"
								LSQL = LSQL & "   where a.GameLevelIDX ='"& tGameLevelIdx &"' and a.DelYN ='N' "
								End if

								if tGroupGameGb = "B0030002" Then
								LSQL = " SELECT a.GameRequestTeamIDX as TeamIDX, TeamName as TeamTitleNames "
								LSQL = LSQL & " FROM tblGameRequestTeam a "
								LSQL = LSQL & "   where a.GameLevelIDX ='"& tGameLevelIdx &"' and a.DelYN ='N' "
								End if

								'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
								'LSQL = LSQL & " FROM  tblGameTitle a "
								'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
								'LSQL = LSQL & " WHERE a.DELYN = 'N' "
								response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
								
								Set LRs = DBCon.Execute(LSQL)
								If Not (LRs.Eof Or LRs.Bof) Then
									Do Until LRs.Eof
											LCnt = LCnt + 1
												tTeamTitleNames = LRs("TeamTitleNames")
												tTeamIDX = LRs("TeamIDX")
												crypt_tTeamIDX =crypt.EncryptStringENC(tTeamIDX)
											%>
										<tr>
											<td>
											</td>
											<td>
												<input type="checkbox" >
											</td>
											<td>
												<%=tTeamTitleNames%> 
											</td>
											<td>
												<a onclick="insert_RequestLevelDtl('<%=crypt_tTeamIDX%>')" class="btn list-btn btn-blue-empty">참가하기</a>
											</td>
										</tr>
										<%
										LRs.MoveNext
									Loop
								End If
								LRs.close
						%>
					</tbody>
				</table>
			</div>
		</div>
		<div class="title_scroll"  style="float: right; width: 50%;">

		<div >
			<table class="sch-table">
				<colgroup>
					<col width="64px">
					<col width="*">
					<col width="64px">
					<col width="*">
					<col width="94px">
					<col width="*">
					<col width="94px">
					<col width="*">
				</colgroup>
				<tbody>
					<tr>
						<td>
							<input type="checkbox" id="chkAllEntryMember" name="chkAllEntryMember">
							<label for="chkAllMember">팀 전체</label>
							<input type="text" name="strEntrtMember" id="strEntrtMember" placeholder="팀명 및 선수명으로 검색하세요">
							<a class="btn btn-search">검색</a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>



		<div id="divGameLevelDtlList" name="divGameLevelDtlList">
			<table class="table-list game-ctr" >
				<thead>
					<tr>
						<th>번호</th>
						<th>
							참여중인 팀 
							<select id="selGameLevelDtl" name="selGameLevelDtl" onchange="javascript:selLevelDtlChanged();" style="width:100px">
							<%
									LSQL = " Select GameLevelDtlidx,a.LevelJooNum,PlayLevelType, b.PubName as PlayLevelTypeNm  "
									LSQL = LSQL & " FROM tblGameLevelDtl a "
									LSQL = LSQL & " Left Join tblPubcode  b on a.PlayLevelType = b.PubCode and b.DelYN = 'N' "
									LSQL = LSQL & " where GameLevelidx = '" & tGameLevelIdx &"' and a.DelYN ='N'   "

									Set LRs = DBCon.Execute(LSQL)
									If Not (LRs.Eof Or LRs.Bof) Then
										Do Until LRs.Eof
												LCnt = LCnt + 1
												tGameLevelDtlIdx2 = LRs("GameLevelDtlidx")
												crypt_tGameLevelDtlIdx2 =crypt.EncryptStringENC(tGameLevelDtlIdx2)
												tLevelJooNum = LRs("LevelJooNum")
												tPlayLevelTypeNm = LRs("PlayLevelTypeNm")
												IF cdbl(tGameLevelDtlIdx) = cdbl(tGameLevelDtlIdx2) Then 
												%>
												<option value="<%=crypt_tGameLevelDtlIdx2%>" selected><%=tPlayLevelTypeNm%>-<%=tLevelJooNum%></option>
												<% ELSE%>
												<option value="<%=crypt_tGameLevelDtlIdx2%>"><%=tPlayLevelTypeNm%>-<%=tLevelJooNum%></option>
											<%
												END IF
											LRs.MoveNext
										Loop
									End If
									LRs.close
								%>
								</select>
							</th>
							<th>
								<a class="btn list-btn btn-blue">전체취소</a>
							</th>
					</tr>
				</thead>
				<tbody id="DP_LevelDtlList">
						<%
								if tGroupGameGb = "B0030001" Then
								LSQL = " SELECT Isnull((STUFF((SELECT ', ' + MemberName +'(' +TeamName + ')' FROM tblGameRequestPlayer c where b.GameRequestGroupIDX = c.GameRequestGroupIDX and c.DelYN = 'N'  For XML PATH('')),1,1,'')) ,'') AS TeamTitleNames, a.RequestDtlIDX "
								LSQL = LSQL & " FROM tblGameRequestTouney a "
								LSQL = LSQL & " LEFT JOIN tblGameRequestGroup b on a.RequestIDX = b.GameRequestGroupIDX and b.DelYN='N' "
								LSQL = LSQL & "   where a.GroupGameGb ='"& tGroupGameGb &"' and a.GameLevelDtlIDX = '"& tGameLevelDtlIdx & "' and a.DelYN ='N' "
								End if

								if tGroupGameGb = "B0030002" Then
								LSQL = " SELECT b.TeamName  as TeamTitleNames, a.RequestDtlIDX"
								LSQL = LSQL & " FROM tblGameRequestTouney a "
								LSQL = LSQL & " LEFT JOIN tblGameRequestTeam b on a.RequestIDX = b.GameRequestTeamIDX and b.DelYN= 'N'  "
								LSQL = LSQL & " where a.GroupGameGb ='"& tGroupGameGb &"' and GameLevelDtlIDX = '"& tGameLevelDtlIdx & "' and a.DelYN ='N' "
								End if

								'LSQL = " SELECT GameTitleIDX, a.GameTitleHost ,(SELECT COUNT(*) FROM tblGameLevel Where GameTitleIDX = a.GameTitleIDX) as levelCount ,GameGb ,GameTitleName,GameS,GameE,GamePlace,b.SidoNm as Sido,SidoDtl,EnterType,GameRcvDateS,GameRcvHourS,GameRcvMinuteS ,GameRcvDateE ,GameRcvHourE ,GameRcvMinuteE ,ViewYN ,HostCode ,a.EditDate ,a.WriteDate "
								'LSQL = LSQL & " FROM  tblGameTitle a "
								'LSQL = LSQL & " Left Join tblSidoInfo b on a.Sido = b.Sido "
								'LSQL = LSQL & " WHERE a.DELYN = 'N' "
								response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"

								Set LRs = DBCon.Execute(LSQL)
								If Not (LRs.Eof Or LRs.Bof) Then
									Do Until LRs.Eof
											LCnt = LCnt + 1
												tTeamTitleNames = LRs("TeamTitleNames")
												tRequestDtlIDX = LRs("RequestDtlIDX")
												crypt_tRequestDtlIDX =crypt.EncryptStringENC(tRequestDtlIDX)
											%>
										<tr>
											<td>
											</td>
											<td>
												<%=tTeamTitleNames%> 
											</td>
											<td>
												<a class="btn list-btn btn-blue" onclick="cancel_RequestLevelDtl('<%=crypt_tRequestDtlIDX%>')">취소</a>
											</td>
										</tr>
										<%
										LRs.MoveNext
									Loop
								End If
								LRs.close
						%>
				</tbody>
			</table>
			</div>
		</div>
	</div>
</div>

<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>