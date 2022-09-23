<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	'대회정보
	GameTitleIDX = "47"

	GameDate = fInject(Request("GameDate"))

	NowYear = Year(Now())
	NowMonth = AddZero(Month(Now()))
	NowDay = AddZero(Day(Now()))



	If GameDate = "" Then 
'		GameDate = GLOBAL_DT2 '"2016-11-27"
		GameDate = NowYear & "-" & NowMonth & "-" & NowDay
	End If 
	
	TeamGb = fInject(Request("TeamGb"))

	If TeamGb = "" And GameDate = "2017-03-13" Then 
		TeamGb = "11001"
	ElseIf  TeamGb = "" And GameDate = "2016-03-14" Then 
		TeamGb = "21001"
	ElseIf  TeamGb = "" And GameDate = "2016-03-15" Then 
		TeamGb = "31001"
	ElseIf  TeamGb = "" And GameDate = "2016-03-16" Then 
		TeamGb = "41001"
	ElseIf  TeamGb = "" And GameDate = "2016-03-17" Then 
		TeamGb = "51001"
	End If 




	TabSQL = "SELECT "
	TabSQL = TabSQL&" distinct(Sportsdiary.dbo.FN_TeamGbNm(SportsGb,teamgb)) AS TeamName "
	TabSQL = TabSQL&" ,TeamGb"
	TabSQL = TabSQL&" FROM Sportsdiary.dbo.tblRGameLevel "
	TabSQL = TabSQL&" WHERE GameTitleIDX='" & GameTitleIDX & "'"
	TabSQL = TabSQL&" AND GameDay='"&GameDate&"'"
	TabSQL = TabSQL&" AND DelYN = 'N'"
	TabSQL = TabSQL&" ORDER BY TeamGb"
	
	Set TRs = Dbcon.Execute(TabSQL)

	If Not(TRs.Eof Or TRs.Bof) Then 
		Do Until TRs.Eof 
			TeamName = TeamName&TRs("TeamName")
			TRs.MoveNext
		Loop 
	Else
		TeamName = ""
	End If 






	'대회정보 셀렉트
	LSQL = "SELECT "
	LSQL = LSQL&" SportsDiary.dbo.Fn_PubName(GroupGameGb) AS GroupGameName"
	LSQL = LSQL&",SportsDiary.dbo.Fn_TeamGbNm(SportsGb, TeamGb) AS TeamName"
	LSQL = LSQL&",Sex"
	LSQL = LSQL&",SportsDiary.dbo.Fn_LevelNm(SportsGb, TeamGb, Level) AS LevelName"
	LSQL = LSQL&",totRound"
	LSQL = LSQL&",RGameLevelIDX"
	LSQL = LSQL&",GroupGameGb"	
	LSQL = LSQL&",GameType"
	LSQL = LSQL&",Level"
	LSQL = LSQL&",TeamGb"
	LSQL = LSQL&",SportsDiary.dbo.Fn_PubName(GameType) AS GameTypeName"
	LSQL = LSQL&" FROM Sportsdiary.dbo.tblRGameLevel WHERE GameTitleIDX = '"&GameTitleIDX&"'"
	LSQL = LSQL&" AND GameDay='"&GameDate&"'" 
	LSQL = LSQL&" AND TeamGb = '"&TeamGb&"'"
	LSQL = LSQL&" AND GameType='sd043002'"
	LSQL = LSQL&" ORDER BY SEX ASC,Level ASC"
	'Response.Write (Ltext)
	
	Set LRs = Dbcon.Execute(LSQL)



%>
<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script type="text/javascript">
function chk_date(obj){
	location.href="RoundBoard.asp?GameDate="+obj
}
</script>
<script>
function chk_part(obj,dateobj){
	var f = document.frm;
	f.TeamGb.value = obj;
	f.GameDate.value = dateobj;
	f.submit();				
}
</script>
	<!-- S : content -->
	<section>
		<div id="content" class="solo-page">
			<div class="loaction">
				<strong>대회진행율 안내</strong> &gt; 2017년 순천만국가정원컵 유도대회 
				<select name="GameDate" onChange="chk_date(this.value)">
					<option value="2017-03-13" <%If GameDate = "2017-03-13" Then %>selected <%End If%>>2017-03-13</option>
					<option value="2017-03-14" <%If GameDate = "2017-03-14" Then %>selected <%End If%>>2017-03-14</option>
					<option value="2017-03-15" <%If GameDate = "2017-03-15" Then %>selected <%End If%>>2017-03-15</option>
					<option value="2017-03-16" <%If GameDate = "2017-03-16" Then %>selected <%End If%>>2017-03-16</option>
					<option value="2017-03-17" <%If GameDate = "2017-03-17" Then %>selected <%End If%>>2017-03-17</option>
				</select>
			</div>			
			<!-- S : tab 대회정보관리 -->
			<div class="tab pull-0">
				<%
					If InStr(TeamName,"남자초등부") > 0 Then 
				%>
				<a href="javascript:chk_part('11001','<%=GameDate%>');" <%If TeamGb="11001" Then %>class="on"<%End If%>>남자초등부</a>
				<%
					End If 
				%>

				<%
					If InStr(TeamName,"여자초등부") > 0 Then 
				%>
				<a href="javascript:chk_part('11002','<%=GameDate%>');" <%If TeamGb="11002" Then %>class="on"<%End If%>>여자초등부</a>
				<%
					End If 
				%>

				<%
					If InStr(TeamName,"남자중학부") > 0 Then 
				%>
				<a href="javascript:chk_part('21001','<%=GameDate%>')" <%If TeamGb="21001" Then %>class="on"<%End If%>>남자중학부</a>
				<%
					End If
				%>

				<%
					If InStr(TeamName,"여자중학부") > 0 Then 
				%>
				<a href="javascript:chk_part('21002','<%=GameDate%>')" <%If TeamGb="21002" Then %>class="on"<%End If%>>여자중학부</a>
				<%
					End If
				%>

				<%
					If InStr(TeamName,"남자고등부") > 0 Then 
				%>
				<a href="javascript:chk_part('31001','<%=GameDate%>')" <%If TeamGb="31001" Then %>class="on"<%End If%>>남자고등부</a>
				<%
					End If
				%>

				<%
					If InStr(TeamName,"여자고등부") > 0 Then 
				%>
				<a href="javascript:chk_part('31002','<%=GameDate%>')" <%If TeamGb="31002" Then %>class="on"<%End If%>>여자고등부</a>
				<%
					End If
				%>

				<%
					If InStr(TeamName,"남자대학부") > 0 Then 
				%>
				<a href="javascript:chk_part('41001','<%=GameDate%>')" <%If TeamGb="41001" Then %>class="on"<%End If%>>남자대학부</a>
				<%
					End If
				%>

				<%
					If InStr(TeamName,"여자대학부") > 0 Then 
				%>
				<a href="javascript:chk_part('41002','<%=GameDate%>')" <%If TeamGb="41002" Then %>class="on"<%End If%>>여자대학부</a>
				<%
					End If
				%>

				<%
					If InStr(TeamName,"남자일반부") > 0 Then 
				%>
				<a href="javascript:chk_part('51001','<%=GameDate%>')" <%If TeamGb="51001" Then %>class="on"<%End If%>>남자일반부</a>
				<%
					End If
				%>

				<%
					If InStr(TeamName,"여자일반부") > 0 Then 
				%>
				<a href="javascript:chk_part('51002','<%=GameDate%>')" <%If TeamGb="51002" Then %>class="on"<%End If%>>여자일반부</a>
				<%
					End If
				%>


				<!--<a href="RoundBoard.asp?TeamGb=sd011006&GameDate=<%=GameDate%>" <%If TeamGb="sd011006" Then %>class="on"<%End If%>>동아리</a>-->
				<!-- E : tab 대회정보관리 -->
				<div class="btn-right-list">
					<a href="javascript:chk_frm();"  class="btn">새로고침</a>
				</div>
				<!-- E : sch 검색조건 선택 및 입력 -->
			</div>
			<!-- S : 리스트형 20개씩 노출 -->
			<!--
			<div class="sch-result">
				<a href="#" class="btn-more-result">
					전체 (<strong>1,000</strong>)건 / <strong class="current">현재(1)</strong>

				</a>
			</div>
			-->
			<div class="table-list-wrap">
				<!-- S : table-list -->
				<table class="table-list">
					<caption>대회정보관리 리스트</caption>
					<colgroup>
						<col width="44px" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">구분</th>
							<th scope="col">소속</th>
							<th scope="col">성별</th>
							<th scope="col">체급</th>
							<th scope="col">대전방식</th>
							<th scope="col">총라운드</th>
							<th scope="col">종료된 경기수</th>
							<th scope="col">진행율</th>
						</tr>
					</thead>
					<tbody>
						<%
							TotalR = "0"
							SumR   = "0"
							If Not (LRs.Eof Or LRs.Bof) Then 
								i = 1
								Do Until LRs.Eof 
						%>
						<tr>
							<th scope="row"><%=i%></th>
							<td><%=LRs("GroupGameName")%></td>
							<td><%=LRs("TeamName")%></td>
							<td><%If LRs("Sex") = "Man" Then %>남자<%Else%>여자<%End If%></td>
							<td><%=LRs("LevelName")%></td>
							<td><%=LRs("GameTypeName")%></td>
							<td>
								<%
								 '토너먼트 일때 
								 If LRs("GameType")="sd043002" Then 							
										If LRs("totRound") = "2" Then 
											LastRound = "Game1R AS LastR"
										ElseIf LRs("totRound") = "4" Then 
											LastRound = "Game2R AS LastR"
										ElseIf LRs("totRound") = "8" Then 
											LastRound = "Game3R AS LastR"
										ElseIf LRs("totRound") = "16" Then 
											LastRound = "Game4R AS LastR"
										ElseIf LRs("totRound") = "32" Then 
											LastRound = "Game5R AS LastR"
										ElseIf LRs("totRound") = "64" Then 
											LastRound = "Game6R AS LastR"
										ElseIf LRs("totRound") = "128" Then 
											LastRound = "Game7R AS LastR"
										Else
											LastRound = "Game2R AS LastR"
										End If 
										'Response.Write LRs("totRound")
										
										If LRs("GroupGameGb") = "sd040001" Then 
										'개인전일경우 데이터=============================

											SSQL = "SELECT Top 1 "
											SSQL = SSQL&LastRound
											SSQL = SSQL&" FROM Sportsdiary.dbo.tblRPlayer " 
											SSQL = SSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
											SSQL = SSQL&" AND RGameLevelIDX='"&LRs("RGameLevelIDX")&"'"
											SSQL = SSQL&" AND DelYN='N'"
											SSQL = SSQL&" Order BY  LastR DESC"
											'Response.Write SSQL
											Set SRs = Dbcon.Execute(SSQL)
											If Not (SRs.Eof Or SRs.Bof) Then 
												Response.Write SRs("LastR")
												LastR = SRs("LastR")
											Else
												Response.Write "등록된 경기없음"
												LastR = "0"
											End If 
											SRs.Close
											Set SRs = Nothing 
										'개인전일경우 데이터=============================
										Else 
										'단체전일경우 데이터=====================================
										  SSQL = "SELECT Top 1 "
											SSQL = SSQL&LastRound
											SSQL = SSQL&" FROM Sportsdiary.dbo.tblRGameGroupSchool " 
											SSQL = SSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
											SSQL = SSQL&" AND RGameLevelIDX='"&LRs("RGameLevelIDX")&"'"
											SSQL = SSQL&" AND DelYN='N'"
											SSQL = SSQL&" Order BY  LastR DESC"
											'Response.Write SSQL
											'Response.End
											Set SRs = Dbcon.Execute(SSQL)
											If Not (SRs.Eof Or SRs.Bof) Then 
												Response.Write SRs("LastR")
												LastR = SRs("LastR")
											Else
												Response.Write "등록된 경기없음"
												LastR = "0"
											End If 
											SRs.Close
											Set SRs = Nothing 
										'단체전일경우 데이터=====================================										
										End If 
									End If  									                 '토너먼트 일때 
								%>
							</td>
							<%
								If LRs("GroupGameGb") = "sd040001" Then 
									'현재 진행상태 조회
									NSQL = "SELECT "
									NSQL = NSQL&" count(GameNum) AS GameNum"
									NSQL = NSQL&" FROM Sportsdiary.dbo.tblRGameResult " 
									NSQL = NSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
									NSQL = NSQL&" AND Level ='"&LRs("Level")&"'"
									NSQL = NSQL&" AND Sex ='"&LRs("Sex")&"'"
									NSQL = NSQL&" AND DelYN='N'"
									NSQL = NSQL&" Order BY  GameNum DESC"
									Set NRs = Dbcon.Execute(NSQL)
									If Not(NRs.Eof Or NRs.Bof) Then 
										NowRound = NRs("GameNum")
									Else
										NowRound = "0"
									End If 
										NRs.Close
										Set NRs = Nothing 
								Else 
									'현재 진행상태 조회
									NSQL = "SELECT  "
									NSQL = NSQL&" count(GameNum) as GameNum "
									NSQL = NSQL&" FROM Sportsdiary.dbo.tblRGameGroup " 
									NSQL = NSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
									NSQL = NSQL&" AND TeamGb ='"&LRs("TeamGb")&"'"
									NSQL = NSQL&" AND Sex ='"&LRs("Sex")&"'"
									'NSQL = NSQL&" AND DelYN='N'"
									NSQL = NSQL&" Order BY  GameNum DESC"
									Set NRs = Dbcon.Execute(NSQL)
									If Not(NRs.Eof Or NRs.Bof) Then 
										NowRound = NRs("GameNum")
									Else
										NowRound = "0"
									End If 
									NRs.Close
									Set NRs = Nothing 
								End If 
							%>
							<td><%=NowRound%></td>
							<%
								If LastR > 0 Then 
									
									RoundPer = (NowRound/LastR)*100
								Else
									RoundPer = "0"
								End If 
							%>
							<td><%=CInt(RoundPer)%>%</td>
						</tr>
						<%
									LRs.Movenext 
									TotalR = CDbl(TotalR) + CDbl(LastR)
									SumR   = CDbl(SumR) + CDbl(NowRound)
									i = i + 1
								Loop 

								TotalPer = (SumR/TotalR)*100
						%>
						<tr>
							<td colspan="2">총진행율</td>
							<td colspan="4"></td>
							<td><%=TotalR%></td>
							<td><%=SumR%></td>
							<td><%=CInt(TotalPer)%>%</td>
						</tr>
						<%
							Else 
						%>
						<tr>
							<td colspan="9"><b>금일은 대회 일정이 없습니다.</b></td>
						</tr>
						<%
							End If 
						%>
						<tr>
					</tbody>
				</table>
				<!-- E : table-list -->
				<!--<a href="#" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>-->
			</div>
			<!-- E : 리스트형 20개씩 노출 -->
		</div>
	</section>
	<!-- E : content -->
</div>
<!-- E : container -->
<%
	 LRs.Close
	 Set LRs = Nothing 

	 
	 Dbclose()
%>
<!-- sticky -->
<script src="../js/js.js"></script>
<form name="frm" method="post">
<input type="hidden" name="GameTitleIDX" value="<%=GameTitleIDX%>">
<input type="hidden" name="TeamGb" value="<%=TeamGb%>">
<input type="hidden" name="GameDate" value="<%=GameDate%>">
</form>
<script>
setInterval(function(){ chk_frm(); }, 6000);

function chk_frm(){
	var f = document.frm;
	f.action = "RoundBoard.asp";
	f.submit();
}
</script>