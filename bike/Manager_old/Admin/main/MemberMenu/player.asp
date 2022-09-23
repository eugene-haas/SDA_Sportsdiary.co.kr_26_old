<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<script type="text/javascript" src="../../js/GameTitleMenu/index.js"></script>


<script type="text/javascript">

	var selSearchValue = "<%=iSearchCol%>";
	var txtSearchValue = "<%=iSearchText%>";

	function WriteLink(i2) {
		post_to_url('./player.asp', { 'i2': i2, 'iType': '1' });
	}

	function ReadLink(i1, i2) {
		post_to_url('./player.asp', { 'i1': i1, 'i2': i2, 'iType': '2' });
	}

	function PagingLink(i2) {
		post_to_url('./player.asp', { 'i2': i2, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

	function fn_selSearch() {
		selSearchValue = document.getElementById('selSearch').value;
		txtSearchValue = document.getElementById('txtSearch').value;
		post_to_url('./player.asp', { 'i2': 1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
	}

</script>

<%
	NowPage = fInject(Request("i2"))  ' 현재페이지
 	PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
  BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

	'Request Data
	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))


	 If Len(NowPage) = 0 Then
		NowPage = 1
	End If

	if(Len(iSearchCol) = 0) Then iSearchCol = "T" ' T:전부, S:제목, C:내용, U:작성자
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

	' 전체 가져오기
	iType = "2"                      ' 1:조회, 2:총갯수

  LSQL = "EXEC Player_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"
	'response.Write "LSQLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLLSQLL="&LSQL&"<br>"
  'response.End

  
  Set LRs = DBCon.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
		Loop
	End If

%>



<section>
	<div id="content">
		<!-- S : 내용 시작 -->
		<div class="contents">
			<!-- S: 네비게이션 -->
			<div	class="navigation_box">
				회원관리 > 선수명단
			</div>
      <!-- S : top-navi -->
      <!-- E : top-navi -->
      <!-- S : sch 검색조건 선택 및 입력 -->
		
			<table class="sch-table">
				<tbody>
					<tr>
						<th scope="row">가입날짜</th>
						<td>
							<input type="date" name="SDate" id="SDate" maxlength="10" value="">-<input type="date" name="EDate" id="EDate" maxlength="10" value="">
						</td>
						
						<th scope="row">구분</th>
						<td><select name="fnd_EnterType" id="fnd_EnterType">
								<option value="" selected="">===전체===</option>
								<option value="E">엘리트</option>
								<option value="A">생활체육</option>
								<option value="K">국가대표</option>
							</select></td>
						<th scope="row">성별</th>
						<td><select name="fnd_SEX" id="fnd_SEX">
								<option value="" selected="">===전체===</option>
								<option value="Man">남자</option>
								<option value="WoMan">여자</option>
							</select></td>
						<th scope="row">등록</th>
						<td><select name="fnd_REG" id="fnd_REG">
								<option value="" selected="">===전체===</option>
								<option value="Y">등록</option>
								<option value="N">비등록</option>
							</select></td>  
						<th>소속</th>
						<td><input type="text" name="fnd_Team" id="fnd_Team"></td>  
						<th>이름</th>
						<td><input type="text" name="fnd_User" id="fnd_User"></td>
					</tr>
				</tbody>
			</table>
     
      <div class="btn-right-list"> <a href="javascript:chk_Submit();" class="btn" accesskey="s">검색(S)</a> </div>
      <!-- E : sch 검색조건 선택 및 입력 -->
      <!-- S : 리스트형 20개씩 노출 -->
      <div id="board-contents" class="table-list-wrap">
				<div>
					<span>전체 : <%=iTotalCount%>,</span>&nbsp;&nbsp;&nbsp;<span><%=NowPage%> page / <%=iTotalPage%> pages</span>
				</div>			 
				<table class="table-list member-info">	
					<thead>		
						<tr>			
							<th>번호</th>			
							<th>이름</th>		
							<th>생년월일</th>			
							<th>성별</th>			
							<th>지역</th>			
							<th>소속</th>			
							<th>팀코드</th>			
							<th>연락처</th>			
							<th>체육인번호</th>			
							<th>구분</th>			
							<th>등록</th>			
							<th>등록일</th>		
						</tr>	
					</thead>	
					<tbody>
						<%
					 	iType = 1
						LSQL = "EXEC Player_Searched_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iDivision & "','" & iSearchCol & "','" & iSearchText & "','" & iSubType & "','" & iTemp & "','" & iLoginID & "'"

						'Response.Write LSQL
						Set LRs = DBCon.Execute(LSQL)
						IF NOT (LRs.Eof Or LRs.Bof) Then
							Do Until LRs.Eof
								rPlayerIDX = LRS("PlayerIDX")
								rGameTitleIDX = LRS("GameTitleIDX")
								rGameLevelDtlIDX = LRS("GameLevelDtlIDX")
								rGroupGameGb= LRS("GroupGameGb")
								rMemberIDX = LRS("MemberIDX")
								rUserName= LRS("UserName")
								rTeam = LRS("Team")
								rTeamDtl = LRS("TeamDtl")
								rTeamGb = LRS("TeamGb")
								rSex = LRS("Sex")
								rLevel = LRS("Level")
								rLevelDtlName = LRS("LevelDtlName")
								rSeedYN = LRS("SeedYN")
								rSubstituteYN = LRS("SubstituteYN")
								rEditDate = LRS("EditDate")
								rWriteDate= LRS("WriteDate")
								%>
								<tr>	
										<td style="cursor:pointer"><%=rPlayerIDX%></td>	
										
										<td style="cursor:pointer"><%=rUserName%></td>	
										<td style="cursor:pointer">19960715</td>
										<td style="cursor:pointer"><%=rSex%></td>	
										<td style="cursor:pointer">경기</td>	
										<td style="cursor:pointer">남양주유도체육관</td>	
										<td style="cursor:pointer"><%=rTeam%></td>	
										<td style="cursor:pointer">01084111431</td>	
										<td style="cursor:pointer">A18000003954</td>	
										<td style="cursor:pointer"><%=rGroupGameGb%></td>	
										<td style="cursor:pointer">Y</td>	
										<td style="cursor:pointer"><%=rWriteDate%></td>
									</tr>
								<%
								LRs.MoveNext
							Loop
						End If
					%>
				

					</tbody>
				</table>
				<div class="bullet-wrap">
					<div class="board-bullet pagination">

					<%
					if LCnt > 0 then
					%>
						<!--#include file="../../dev/dist/judoPaging_Admin.asp"-->
					<%
						End If
					%>
					</div>
				</div>
					
      <!-- E : 리스트형 20개씩 노출 -->
		</div>
	</div>
</section>
<!--#include file="../../include/footer.asp"-->

<%
  DBClose()
%>