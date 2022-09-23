<!--#include virtual="/Manager/Common/common_header.asp"-->
<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>경기기록관리</strong> &gt; 대진표관리
			</div>
			<!-- S : top-navi -->
			<div class="top-navi">
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->
					<div class="top-navi-tp">
						<h3 class="top-navi-tit">
							<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
							<strong>대진표관리</strong>
						</h3>
						<a href="#" class="btn-top-sdr open" title="더보기"></a>
						<a href="#" class="btn-top-sdr close" title="닫기"></a>
						<!--<a href="#" class="btn-top-sdr" title="더보기"><i class="fa fa-sort-desc" aria-hidden="true"></i></a>
						<a href="#" class="btn-top-sdr" title="닫기"><i class="fa fa-minus" aria-hidden="true"></i></a>-->
					</div>
					<!-- E : top-navi-tp 접혔을 때 -->
				</div>
			</div>
			<!-- E : top-navi -->
			<!-- S : sch 검색조건 선택 및 입력 -->
			<div class="sch">
				<table class="sch-table">
					<caption>검색조건 선택 및 입력</caption>
					<colgroup>
						<col width="50px" />
						<col width="*" />
						<col width="60px" />
						<col width="*" />
						<col width="50px" />
						<col width="*" />
						<col width="50px" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">연도</th>
							<td>
								<select>
									<option value="op1">연도</option>
								</select>
							</td>
							<th scope="row">대회명</th>
							<td>
								<select>
									<option value="op1">한국춘계유도선수권대회</option>
								</select>
							</td>
							<th scope="row">구분</th>
							<td>
								<select>
									<option value="op1">개인전</option>
									<option value="op2">단체전</option>
								</select>
							</td>
							<th scope="row">소속</th>
							<td>
								<select>
									<option value="op1">초등부</option>
									<option value="op2">중등부</option>
									<option value="op3">고등부</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">체급</th>
							<td>
								<select>
									<option value="op1">-32kg</option>
								</select>
							</td>
							<th scope="row">대전방식</th>
							<td>
								<select>
									<option value="op1">토너먼트</option>
									<option value="op2">리그</option>
								</select>
							</td>
							<th scope="row">성별</th>
							<td>
								<select>
									<option value="op1">남</option>
									<option value="op2">여</option>
								</select>
							</td>
							<th scope="row"></th>
							<td></td>
							<th scope="row"></th>
							<td></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn-right-list">
				<a href="#" class="btn">검색</a>
			</div>
			<!-- E : sch 검색조건 선택 및 입력 -->
			<!-- S : 리스트형 20개씩 노출 -->
			<div class="sch-result">
				<a href="#" class="btn-more-result">
					전체 (<strong>1,000</strong>)건 / <strong class="current">현재(1)</strong>
					<!--//<i class="fa fa-plus" aria-hidden="true"></i>-->
				</a>
			</div>
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
						<col width="*" />
						<col width="126px" />
						<col width="171px" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">년도</th>
							<th scope="col">대회명</th>
							<th scope="col">구분</th>
							<th scope="col">소속</th>
							<th scope="col">성별</th>
							<th scope="col">체급</th>
							<th scope="col">참가인원</th>
							<th scope="col">대전방식</th>
							<th scope="col">선수관리</th>
							<th scope="col">인쇄/PDF 다운로드</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th scope="row">1</th>
							<td>2016년</td>
							<td class="left">한국춘계유도선수권대회</td>
							<td>개인전</td>
							<td>중등부</td>
							<td>남</td>
							<td>-32kg</td>
							<td>1명</td>
							<td>토너먼트</td>
							<td><a href="http://sportsdiary.co.kr/WebTournament/www/RGameList.html" class="btn-list type3"><i class="fa fa-sitemap" aria-hidden="true"></i> 대진추첨등록 <i class="fa fa-caret-right" aria-hidden="true"></i></a></td>
							<td>
								<a href="#" class="btn-list type2"><i class="fa fa-print" aria-hidden="true"></i> 인쇄 <i class="fa fa-caret-right" aria-hidden="true"></i></a>
								<a href="#" class="btn-list"><i class="fa fa-download" aria-hidden="true"></i> PDF다운 <i class="fa fa-caret-right" aria-hidden="true"></i></a>
							</td>
						</tr>
						<tr>
							<th scope="row">2</th>
							<td>2016년</td>
							<td class="left">한국춘계유도선수권대회</td>
							<td>개인전</td>
							<td>중등부</td>
							<td>남</td>
							<td>-32kg</td>
							<td>1명</td>
							<td>토너먼트</td>
							<td><a href="http://sportsdiary.co.kr/WebTournament/www/RGameList.html" class="btn-list type3"><i class="fa fa-sitemap" aria-hidden="true"></i> 대진추첨등록 <i class="fa fa-caret-right" aria-hidden="true"></i></a></td>
							<td>
								<a href="#" class="btn-list type2"><i class="fa fa-print" aria-hidden="true"></i> 인쇄 <i class="fa fa-caret-right" aria-hidden="true"></i></a>
								<a href="#" class="btn-list"><i class="fa fa-download" aria-hidden="true"></i> PDF다운 <i class="fa fa-caret-right" aria-hidden="true"></i></a>
							</td>
						</tr>
						<tr>
							<th scope="row">3</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">4</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">5</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">6</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">7</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">8</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">9</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">10</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">11</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">12</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">13</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">14</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">15</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">16</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">17</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">18</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">19</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th scope="row">20</th>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</tbody>
				</table>
				<!-- E : table-list -->
				<a href="#" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>
			</div>
			<!-- E : 리스트형 20개씩 노출 -->
		</div>
	</section>
	<!-- E : content -->
</div>
<!-- E : container -->
<!-- sticky -->
<script src="../js/js.js"></script>