<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>대회관리</strong> &gt; 대회순서 등록
			</div>
			<%
				GameTitleIDX = fInject(Request("GameTitleIDX"))
				'대회번호
				'Response.Write GameTitleIDX
				If GameTitleIDX <> "" Then 
					GSQL = "SELECT GameTitleName,GameS,GameE AS GameE FROM Sportsdiary.dbo.tblGametitle WHERE GameTitleIDX='"&GameTitleIDX&"'"
					'Response.Write GSQL
					Set GRs = Dbcon.Execute(GSQL)
					
					If Not(GRs.Eof Or GRs.Bof) Then 
						GametitleName = GRs("GameTitleName")
						GameS         = GRs("GameS")
						GameE         = GRs("GameE")

					End If 
				End If 

				'경기일자
				GameDay = fInject(Request("GameDay"))
				'Response.Write GameDay
				'매트수
				MatCnt  = fInject(Request("MatCnt"))

				If MatCnt = "" Then 
					MatCnt = ""
				End If 

				'분배방식
				ModType = fInject(Request("ModType"))
				
				If ModType = "" Then 
					ModType = "1"
				End If 


				'개회식여부
				Opening = fInject(Request("Opening"))

				If Opening = "" Then 
					Opening = "N"
				End If 


			%>
			<script type="text/javascript">
			function chk_gameDay(){
				var f = document.frm;
				f.submit();
			}

			function cnk_step(){
				var f = document.frm;
				if(confirm("다음단계를 진행하시겠습니까?")){
					f.action="DayList_Step2.asp"
					f.submit();
				}
			}
			</script>
			<form name="frm" method="post">

			<!-- S: top-daylist -->
			<div class="top-daylist">
				<h3 class="top-navi-tit">
					<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
					<strong>대회순번</strong>
				</h3>
				<div class="navi-tp-table-wrap">
					<table class="navi-tp-table">
						<colgroup>
							<col width="100px" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">대회정보</th>
								<td>
								<select name="GameTitleIDX" id="GameTitleIDX" onChange="chk_gameDay();">
									<option value="">==대회선택</option>
									<%
										TSQL = "SELECT GameTitleName,GameTitleIDX FROM Sportsdiary.dbo.tblGametitle"
										TSQL = TSQL&" WHERE DelYN='N' AND SportsGb='"&Request.Cookies("SportsGb")&"'"
										If Request.Cookies("HostCode") <> "" Then 
											TSQL = TSQL&" AND HostCode='"&Request.Cookies("HostCode")&"'"
											TSQL = TSQL&" AND ViewState = '1'"
										End If 
										TSQL = TSQL&" ORDER BY GameS DESC"
										
										Set TRs = Dbcon.Execute(TSQL)
										
										If Not(TRs.Eof Or TRs.Bof) Then 
											Do Until TRs.Eof 
									%>
									<option value="<%=TRs("GameTitleIDX")%>" <%If CStr(TRs("GameTitleIDX")) = CStr(GametitleIDX) Then %>selected<%End If%>><%=TRs("GameTitleName")%></option>
									<%
												TRs.MoveNext
											Loop 
										End If 
									%>
								</select>
								</td>
							</tr>
							<tr>
								<th>대회일자</th>
								<td>
									<select name="GameDay" id="GameDay" onChange="chk_gameDay();">
										<%
											If GameTitleIDX <> "" And( GameS <> "" And GameE <> "") Then 
												SDate = Replace(GameS,"-","")
												EDate = Replace(GameE,"-","")
												For i = CDbl(SDate) To CDbl(EDate)
										%>
										<option value="<%=i%>" <%If CStr(i) = CStr(GameDay) Then %>selected<%End If%>><%=i%></option>
										<%											
												Next
											End If 
										%>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">매트수</th>
								<td>
									<select name="MatCnt" id="MatCnt" onChange="chk_gameDay();">
										<option value="1" <%If MatCnt = "1" Then %>selected<%End If%>>1개</option>
										<option value="2" <%If MatCnt = "2" Then %>selected<%End If%>>2개</option>
										<option value="3" <%If MatCnt = "3" Then %>selected<%End If%>>3개</option>
										<option value="4" <%If MatCnt = "4" Then %>selected<%End If%>>4개</option>
										<option value="5" <%If MatCnt = "5" Then %>selected<%End If%>>5개</option>
										<option value="6" <%If MatCnt = "6" Then %>selected<%End If%>>6개</option>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">분배방식</th>
								<td>
									<select name="ModType" id="ModType" onChange="chk_gameDay();">
										<option value="1" <%If ModType = "1" Then %>selected<%End If%>>게임수+회전별 분배</option>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">개회식여부</th>
								<td>
									<select name="Opening"  id="Opening" onChange="chk_gameDay();">
										<option value="Y" <%If Opening = "Y" Then %>selected<%End If%>>개회식포함</option>
										<option value="N" <%If Opening = "N" Then %>selected<%End If%>>개회식없음</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<!-- E: top-daylist -->
			<!-- S: table-list-wrap -->
			<div class="stit">1단계</div>
			<div class="table-list-wrap">
				<table class="table-list">
					<thead>
						<tr>
							<th scope="col">종별</th>
							<th scope="col">체급</th>
							<th scope="col">경기형태</th>
							<th scope="col">총경기수</th>
							<th scope="col">8강까지경기수</th>
						</tr>
					</thead>
					<tbody>
				<%
					'해당일자의 게임수 계산
					If GameTitleIDX<>"" And GameDay <> "" Then 
						'해당일자 체급 셀렉트
						LSQL = "SELECT "
						LSQL = LSQL&" DISTINCT(Sportsdiary.dbo.FN_LevelNM(SportsGb,TeamGb,Level)) AS LevelNm "
						LSQL = LSQL&" ,Level "
						LSQL = LSQL&" ,RGameLevelIDX "
						LSQL = LSQL&" ,Sportsdiary.dbo.FN_TeamGbNm(SportsGb,TeamGb) AS TeamGbNM"
						LSQL = LSQL&" ,TeamGb"
						LSQL = LSQL&" ,SportsGb"
						LSQL = LSQL&" ,Sex"
						LSQL = LSQL&" ,GameType"
						LSQL = LSQL&" ,GroupGameGb"
						LSQL = LSQL&" ,Sportsdiary.dbo.Fn_PubName(GameType) AS GameTypeNM"
						LSQL = LSQL&" FROM SportsDiary.dbo.tblPlayerResult WHERE DelYN='N' AND GameTitleIDX='"&GameTitleIDX&"' AND Replace(GameDay,'-','')='"&GameDay&"' "
						LSQL = LSQL&" AND (GroupGameGb = '"&SportsCode&"040001' OR (GroupGameGb = '"&SportsCode&"040002' AND (ISNULL(LPlayerIDX,'') = '' AND ISNULL(RPlayerIDX,'') = '' ))) "
						LSQL = LSQL&" ORDER BY Sex,Level"
						Set LRs = Dbcon.Execute(LSQL)
						TotCnt = "0"
						If Not(LRs.Eof Or LRs.Bof) Then 


							'기존데이터 삭제
							If GameTitleIDX <>"" And GameDay <> "" Then 
								DSQL = "Delete FROM SportsDiary.dbo.tblDayList_Temp WHERE GameTitleIDX='"&GametitleIDX&"' AND Replace(GameDay,'-','')='"&GameDay&"'"
								Dbcon.Execute(DSQL)
							End If 

							Do Until LRs.Eof 

								If LRs("GroupGameGb") = SportsCode&"040001" Then 
									CSQL = "SELECT Count(*) AS GameCnt FROM tblPlayerResult "
									CSQL = CSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
									CSQL = CSQL&" AND DelYN='N'"
									CSQL = CSQL&" AND Level='"&LRs("Level")&"'"
									CSQL = CSQL&" AND (ISNULL(RResult,'') <> '"&SportsCode&"019006' AND ISNULL(LResult,'') <> '"&SportsCode&"019006' AND ISNULL(RResult,'') <> '"&SportsCode&"019021' AND ISNULL(LResult,'') <> '"&SportsCode&"019021' AND ISNULL(RResult,'') <> '"&SportsCode&"019022' AND ISNULL(LResult,'') <> 'sd019022' AND ISNULL(RResult,'') <> 'sd019012' AND ISNULL(LResult,'') <> 'sd019012')"
								Else
									CSQL = "SELECT Count(*) AS GameCnt FROM tblPlayerResult "
									CSQL = CSQL&" WHERE GameTitleIDX='"&GameTitleIDX&"'"
									CSQL = CSQL&" AND DelYN='N'"
									CSQL = CSQL&" AND Sex='"&LRs("Sex")&"'"
									CSQL = CSQL&" AND TeamGb='"&LRs("TeamGb")&"'"
									CSQL = CSQL&" AND GroupGameGb='"&SportsCode&"040002'"
									CSQL = CSQL&" AND (ISNULL(RResult,'') <> '"&SportsCode&"019006' AND ISNULL(LResult,'') <> '"&SportsCode&"019006' AND ISNULL(RResult,'') <> '"&SportsCode&"019021' AND ISNULL(LResult,'') <> '"&SportsCode&"019021' AND ISNULL(RResult,'') <> '"&SportsCode&"019022' AND ISNULL(LResult,'') <> '"&SportsCode&"019022' AND ISNULL(RResult,'') <> '"&SportsCode&"019012' AND ISNULL(LResult,'') <> '"&SportsCode&"019012')"	
									'Response.Write CSQL
									'Response.End
								End If 

								'Response.Write CSQL&"<br>"

								Set CRs = Dbcon.Execute(CSQL)
				 
								If LRs("GameTypeNM") = "토너먼트" Then 
									GameCnt = CRs("GameCnt")-3
								Else
									GameCnt = CRs("GameCnt")
								End If 

								InSQL = "INSERT INTO tblDayList_Temp ("
								InSQL = InSQL&" GameTitleIDX"
								InSQL = InSQL&" ,GameTitleName"
								InSQL = InSQL&" ,RGameLevelIDX"
								InSQL = InSQL&" ,SportsGb"
								InSQL = InSQL&" ,Level"
								InSQL = InSQL&" ,LevelNm"
								InSQL = InSQL&" ,TeamGb"
								InSQL = InSQL&" ,TeamGbNm"
								InSQL = InSQL&" ,Sex"
								InSQL = InSQL&" ,TotGameCnt"
								InSQL = InSQL&" ,GameCnt"
								InSQL = InSQL&" ,GameDay"
								InSQL = InSQL&" ,GameType"
								InSQL = InSQL&" ,GameTypeNM"
								InSQL = InSQL&" )"
								InSQL = InSQL&" VALUES "
								InSQL = InSQL&" ("
								InSQL = InSQL&" '"&GameTitleIDX&"'"
								InSQL = InSQL&" ,'"&GameTitleName&"'"
								InSQL = InSQL&" ,'"&LRs("RGameLevelIDX")&"'"
								InSQL = InSQL&" ,'"&LRs("SportsGb")&"'"
								InSQL = InSQL&" ,'"&LRs("Level")&"'"
								InSQL = InSQL&" ,'"&LRs("LevelNm")&"'"
								InSQL = InSQL&" ,'"&LRs("TeamGb")&"'"
								InSQL = InSQL&" ,'"&LRs("TeamGbNm")&"'"
								InSQL = InSQL&" ,'"&LRs("Sex")&"'"
								InSQL = InSQL&" ,'"&CRs("GameCnt")&"'"
								InSQL = InSQL&" ,'"&GameCnt&"'"
								InSQL = InSQL&" ,'"&GameDay&"'"
								InSQL = InSQL&" ,'"&LRs("GameType")&"'"
								InSQL = InSQL&" ,'"&LRs("GameTypeNM")&"'"
								InSQL = InSQL&" )"
								'Response.WRite InSQL&"<br>"
								'Response.End
								Dbcon.Execute(InSQL)
				%>
				<tr>
					<td><%=LRs("TeamGbNM")%></td>
					<td><%=LRs("LevelNm")%></td>
					<td><%=LRs("GameTypeNM")%></td>
					<td><%=CRs("GameCnt")%></td>
					
					<td><%=GameCnt%></td>
				</tr>
					
				<%			
								TotCnt = TotCnt + CRs("GameCnt")				
								TotCnt2 = TotCnt2 + GameCnt

								LRs.MoveNext
							Loop 
				%>
					</tbody>
					<tfoot>
						<tr>
							<td class="first" colspan="5">총경기수:<%=TotCnt%></td>
						</tr>
						<tr>
							<td colspan="5">준결결승제외경기수:<%=TotCnt2%></td>
						</tr>

						<%%>
						<%
							ModCnt = Round(TotCnt2/MatCnt)
						%>
						<tr>
							<td colspan="5">준결경승제외 경기장별 적정경기 수:<%=ModCnt%></td>
						</tr>
						<%
							If Opening = "Y" Then 
								TempTime = (ModCnt*5) + 60
							Else
								TempTime = ModCnt*5
							End If 

						%>
						<tr>
							<td class="last" colspan="5">준결걸승제외 경기장별 예상경기시간(경기별5분):<%=TempTime%>분</td>
						</tr>
						<tr>
							<td colspan="5" class="btn">
								<!--//<input type="button" value="다음" onclick="cnk_step();">-->
								<a href="#" onclick="cnk_step();" class="btn">다음</a>
							</td>
						</tr>
						<%%>
						<%
								Else 
						%>
						<tr>
							<td class="none">등록된 경기가 없습니다.</td>
						</tr>
						<%
								End If 
							End If 
						%>

					</tfoot>
				</table>
			</div>
			<!-- E: table-list-wrap -->
			<input type="hidden" name="ModCnt" id="ModCnt" value="<%=ModCnt%>">
			</form>
		</div>
	</section>
	<!-- E : content -->
</div>
<!-- E : container -->