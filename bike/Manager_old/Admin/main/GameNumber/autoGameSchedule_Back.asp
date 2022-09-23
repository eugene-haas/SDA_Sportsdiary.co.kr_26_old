<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<style>
	#left-navi{display:none;}
	#header{display:none;}
</style>
<!-- S: content -->

<input type="hidden" id="selGameTitleIdx" name="selGameTitleIdx" value="<%=crypt_reqGameTitleIdx%>">

<div class="ranking_result_popup autogameschedule">
	<div class="top_title">
		<h2>대회명 : [<%=tGameTitleName%>] - 예선 최종 순위 결과</h2>
			<a href="http://badmintonadmin.sportsdiary.co.kr/main/AdminMenu/Admin_Login.asp" class="r-link">
			<i class="fas fa-list"></i>
			<span>경기순서 리스트</span>
			<i class="fas fa-chevron-right"></i>
		</a>
	</div>
	<!-- s: 검색 -->
	<div class="search_box" id="divGameLevelMenu">
		<input type="text" placeholder="대회명을 입력해주세요" />
		<select id="" name="">
			<option value="">2018-07-04</option>
		</select>
		<a href="#">조회</a>
		<a href="#" class="white-btn">경기 전체 출력</a>
	</div>
	<!-- e: 검색 -->
	<!-- s: 버튼 선택 -->
	<div class="btn-select">
		<ul>
			<li>
				<div class="l-name">경기구분</div>
				<div class="r-con">
					<a href="#" class="active">개인전</a>
					<a href="#">단체전</a>
					<span class="code-box">
						<input type="text" value="1"/>
						<span class="txt">코트 ~</span>
						<input type="text" value="4"/>
						<span class="txt">코트</span>
					</span>
				</div>
			</li>
			<li>
				<div class="l-name">경기유형</div>
				<div class="r-con">
					<a href="#" class="active">예선</a>
					<a href="#">본선</a>
				</div>
			</li>
			<li>
				<div class="l-name">종목</div>
				<div class="r-con">
					<a href="#" class="disabled">일반1부</a>
					<a href="#" class="active">어르신부</a>
					<a href="#">혼합부</a>
					<a href="#">일반2부</a>
				</div>
			</li>
			<li>
				<div class="l-name">종별</div>
				<div class="r-con">
					<a href="#" class="disabled">전체</a>
					<a href="#" class="active">40대</a>
					<a href="#">50대</a>
					<a href="#">60대</a>
				</div>
			</li>
			<li>
				<div class="l-name">급수</div>
				<div class="r-con">
					<a href="#" class="disabled">A</a>
					<a href="#" class="active">B</a>
					<a href="#">C</a>
					<a href="#">D</a>
					<a href="#">E</a>
				</div>
			</li>
			<li>
				<div class="l-name">경기장</div>
				<div class="r-con">
					<a href="#" class="disabled">A체육관</a>
					<a href="#" class="active">B체육관</a>
					<a href="#">C체육관</a>
					<a href="#">D체육관</a>
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
					<span class="number">1000</span>
					<span class="txt">경기</span>
				</span>
			</li>
			<li>
				<span class="l-name">총 경기수</span>
				<span class="r-con">
					<span class="number">1000</span>
					<span class="txt">/ 10000</span>
				</span>
			</li>
			<li>
				<span class="l-name">진행률 경기수</span>
				<span class="r-con">
					<span class="percentage">28%</span>
					<a href="#" class="red-btn">자동진행순서 적용</a>
				</span>
			</li>
		</ul>
	</div>
	<!-- e: player-number -->
	<!-- s: 리스트 table -->
	<div class="table-warp">
		<!-- s: table-one -->
		<div class="table-one">
			<ul>
				<li class="on">
					<div class="l-con">
						<span class="name">A 체육관</span>
						<span class="coat">11코트</span>
					</div>
					<div class="r-con">
						<span class="playe-number">
							총 <span class="red-font">55경기</span>
						</span>
						<span class="date">
							<i class="fas fa-clock"></i>
							<span class="date-number">4시간30분</span>
						</span>
						<i class="fas fa-chevron-circle-right"></i>
					</div>
				</li>
				<li>
					<div class="l-con">
						<span class="name">B 체육관</span>
						<span class="coat">11코트</span>
					</div>
					<div class="r-con">
						<span class="playe-number">
							총 <span class="red-font">55경기</span>
						</span>
						<span class="date">
							<i class="fas fa-clock"></i>
							<span class="date-number">4시간30분</span>
						</span>
						<i class="fas fa-chevron-circle-right"></i>
					</div>
				</li>
				<li>
					<div class="l-con">
						<span class="name">C 체육관</span>
						<span class="coat">11코트</span>
					</div>
					<div class="r-con">
						<span class="playe-number">
							총 <span class="red-font">55경기</span>
						</span>
						<span class="date">
							<i class="fas fa-clock"></i>
							<span class="date-number">4시간30분</span>
						</span>
						<i class="fas fa-chevron-circle-right"></i>
					</div>
				</li>
				<li>
					<div class="l-con">
						<span class="name">D 체육관</span>
						<span class="coat">11코트</span>
					</div>
					<div class="r-con">
						<span class="playe-number">
							총 <span class="red-font">55경기</span>
						</span>
						<span class="date">
							<i class="fas fa-clock"></i>
							<span class="date-number">4시간30분</span>
						</span>
						<i class="fas fa-chevron-circle-right"></i>
					</div>
				</li>
			</ul>
		</div>
		<!-- e: table-one -->
		<!-- s: table-tow -->
		<div class="table-tow">
			<!-- s: table-title -->
			<div class="table-title">
				<h2>A체육관</h2>
				<div class="r-btn">
					<a href="#">
						<i class="fas fa-undo copy"></i>
					</a>
					<a href="#">
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
						<th>경기수</th>
						<th>그룹</th>
						<th>순서</th>
						<th>
							<input type="checkbox" class="checkbox"/>
						</th>
					</tr>
					<tr>
						<td>
							<a href="#" class="individual">개인</a>
						</td>
						<td>
							<span>1~4코트</span>
						</td>
						<td>
							<span>어르신부<span class="red-font">45대D</span></span>
						</td>
						<td>
							<span>예선</span>
						</td>
						<td>
							<span>4</span>
						</td>
						<td>
							<select name="" id="">
								<option value="">1</option>
							</select>
						</td>
						<td>
							<select name="" id="">
								<option value="">1</option>
							</select>
						</td>
						<td>
							<input type="checkbox" class="checkbox"/>
						</td>
					</tr>
					<tr>
						<td>
							<a href="#" class="group-btn">단체</a>
						</td>
						<td>
							<span>1~4코트</span>
						</td>
						<td>
							<span>어르신부<span class="red-font">45대D</span></span>
						</td>
						<td>
							<span>예선</span>
						</td>
						<td>
							<span>4</span>
						</td>
						<td>
							<select name="" id="">
								<option value="">1</option>
							</select>
						</td>
						<td>
							<select name="" id="">
								<option value="">1</option>
							</select>
						</td>
						<td>
							<input type="checkbox" class="checkbox"/>
						</td>
					</tr>
					<tr>
						<td>
							<a href="#" class="individual">개인</a>
						</td>
						<td>
							<span>1~4코트</span>
						</td>
						<td>
							<span>어르신부<span class="red-font">45대D</span></span>
						</td>
						<td>
							<span>예선</span>
						</td>
						<td>
							<span>4</span>
						</td>
						<td>
							<select name="" id="">
								<option value="">1</option>
							</select>
						</td>
						<td>
							<select name="" id="">
								<option value="">1</option>
							</select>
						</td>
						<td>
							<input type="checkbox" class="checkbox"/>
						</td>
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