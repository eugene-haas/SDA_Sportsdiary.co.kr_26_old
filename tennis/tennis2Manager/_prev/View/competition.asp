<!--#include virtual="/Manager/Common/common_header.asp"-->
<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script language="javascript">
$(document).ready(function(){
	init();
});
</script>
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>대회정보관리</strong> &gt; 대회정보관리
			</div>
			<!-- S : top-navi -->
			<div class="top-navi">
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->
					<div class="top-navi-tp">
						<h3 class="top-navi-tit">
							<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
							<strong>대회정보</strong>
						</h3>
						<a href="#" class="btn-top-sdr open" title="더보기"></a>
						<a href="#" class="btn-top-sdr close" title="닫기"></a>
						<!--<a href="#" class="btn-top-sdr" title="더보기"><i class="fa fa-sort-desc" aria-hidden="true"></i></a>
						<a href="#" class="btn-top-sdr" title="닫기"><i class="fa fa-minus" aria-hidden="true"></i></a>-->
					</div>
					<!-- E : top-navi-tp 접혔을 때 -->
					<!-- S : top-navi-btm 펼쳤을 때 보이는 부분 -->
					<div class="top-navi-btm">
						<div class="navi-tp-table-wrap">
							<table class="navi-tp-table">
								<caption>대회정보 기본정보</caption>
								<colgroup>
									<col width="64px" />
									<col width="*" />
									<col width="64px" />
									<col width="*" />
									<col width="94px" />
									<col width="*" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">년도</th>
										<td>
												<select>
													<option value="op1">년도</option>
												</select>
										</td>
										<th scope="row"><label for="competition-name">대회명</label></th>
										<td><input type="text" id="competition-name" /></td>
										<th scope="row">지역</th>
										<td>
												<select>
													<option value="op1">지역</option>
												</select>
												<input type="text" id="" title="장소를 입력해주세요" class="input-small" />
										</td>
									</tr>
									<tr>
										<th scope="row">시작일</th>
										<td>
											<div class="ymd-list">
												<select>
													<option value="op1">년도</option>
												</select>
												<select>
													<option value="op1">월</option>
												</select>
												<select>
													<option value="op1">일</option>
												</select>
											</div>
										</td>
										<th scope="row">종료일</th>
										<td>
											<div class="ymd-list">
												<select>
													<option value="op1">년도</option>
												</select>
												<select>
													<option value="op1">월</option>
												</select>
												<select>
													<option value="op1">일</option>
												</select>
											</div>
										</td>
										<th scope="row"><label for="competition-place">장소</label></th>
										<td>
											<input type="text" id="competition-place" class="input-small" />
											<a href="#" class="btn-sch-pop">조회</a>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- S : btn-right-list 버튼 -->
						<div class="btn-right-list">
							<a href="#" class="btn">등록</a>
							<a href="#" class="btn">수정</a>
							<a href="#" class="btn btn-delete">삭제</a>
							<a href="#" class="btn">목록보기</a>
						</div>
						<!-- E : btn-right-list 버튼 -->
					</div>
					<!-- E : top-navi-btm 펼쳤을 때 보이는 부분 -->
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
								<th scope="row"><label for="competition-name-2">대회명</label></th>
								<td>
									<input type="text" id="competition-name-2" class="txt-bold" value="한국유도선수권대회" />
								</td>
								<th scope="row">지역</th>
								<td>
									<select class="select-small">
										<option value="op1">전체</option>
									</select>
									<input type="text" id="competition-place" class="input-small" />
								</td>
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
						<col width="125px" />
						<col width="125px" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">년도</th>
							<th scope="col">기간(시작-종료)</th>
							<th scope="col">대회명</th>
							<th scope="col">지역</th>
							<th scope="col">장소</th>
							<th scope="col">개인전</th>
							<th scope="col">단체전</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th scope="row">1</th>
							<td>2016년</td>
							<td>05/07 ~ 05/14</td>
							<td class="left">한국춘계유도선수권대회</td>
							<td>강원도 양구</td>
							<td>양구 실내 채육관</td>
							<td><a href="#" class="btn-list type2">개인전 보기 <i><img src="../images/icon_more_right.png" alt="" /></i></a></td>
							<td><a href="#" class="btn-list">단체전 보기 <i><img src="../images/icon_more_right.png" alt="" /></i></a></td>
						</tr>
						<tr>
							<th scope="row">2</th>
							<td>2016년</td>
							<td>05/07 ~ 05/14</td>
							<td class="left">한국춘계유도선수권대회</td>
							<td>강원도 양구</td>
							<td>양구 실내 채육관</td>
							<td><a href="#" class="btn-list type2">개인전 보기 <i><img src="../images/icon_more_right.png" alt="" /></i></i></a></td>
							<td><a href="#" class="btn-list">단체전 보기 <i><img src="../images/icon_more_right.png" alt="" /></i></a></td>
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