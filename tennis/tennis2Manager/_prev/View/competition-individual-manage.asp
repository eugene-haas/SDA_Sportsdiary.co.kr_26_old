<!--#include virtual="/Manager/Common/common_header.asp"-->
<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>대회정보관리</strong> &gt; 한국춘계유도선수권대회 &gt; 개인전 &gt; 출전선수관리
			</div>
			<!-- S : top-navi -->
			<div class="top-navi">
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->
					<div class="top-navi-tp">
						<h3 class="top-navi-tit">
							<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
							<strong>한국춘계유도선수권대회</strong>
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
								<caption>대회정보관리 기본정보</caption>
								<colgroup>
									<col width="64px" />
									<col width="*" />
									<col width="64px" />
									<col width="*" />
									<col width="94px" />
									<col width="*" />
									<col width="94px" />
									<col width="*" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">연도</th>
										<td>
											<select>
												<option value="op1">년도</option>
											</select>
										</td>
										<th scope="row"><label for="competition-name">대회명</label></th>
										<td><input type="text" id="competition-name" /></td>
										<th scope="row">구분</th>
										<td>
											<select>
												<option value="op1">개인전</option>
												<option value="op2">단체전</option>
											</select>
										</td>
									</tr>
									<tr>
										<th scope="row">소속</th>
										<td>
											<select>
												<option value="op1">초등부</option>
												<option value="op2">중등부</option>
												<option value="op3">고등부</option>
											</select>
										</td>
										<th scope="row">성별</th>
										<td>
											<input type="radio" id="gender-man" name="gender" /> <label for="gender-man" class="man">남</label>
											<input type="radio" id="gender-woman" name="gender" /> <label for="gender-woman">여</label>
										</td>
										<th scope="row">체급</th>
										<td>
											<select>
												<option value="op1">전체</option>
											</select>
										</td>
									</tr>
									<tr>
										<th scope="row">대전방식</th>
										<td>
											<select>
												<option value="op1">토너먼트</option>
												<option value="op2">리그</option>
											</select>
										</td>
										<th scope="row">소속명</th>
										<td>
											<select>
												<option value="op1">보성초등학교</option>
											</select>
										</td>
										<th scope="row">소속명</th>
										<td>
											<select>
												<option value="op1">이세라</option>
											</select>
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
			<!-- S : tab 대회정보관리 -->
			<div class="tab">
				<a href="#" class="on">개인전</a>
				<a href="#">단체전</a>
			</div>
			<!-- E : tab 대회정보관리 -->
			<h4 class="stit">출전선수관리</h4>
			<!-- S : sch 검색조건 선택 및 입력 -->
			<div class="sch">
				<table class="sch-table">
					<caption>검색조건 선택 및 입력</caption>
					<colgroup>
						<col width="40px" />
						<col width="*" />
						<col width="50px" />
						<col width="*" />
						<col width="90px" />
						<col width="*" />
						<col width="40px" />
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
							<th scope="row">소속명</th>
							<td>
								<select>
									<option value="op1">보성초등학교</option>
								</select>
							</td>
							<th scope="row">선수코드번호</th>
							<td>
								<select>
									<option value="op1">002-001</option>
								</select>
							</td>
							<th scope="row">이름</th>
							<td>
								<select>
									<option value="op1">이세라</option>
								</select>
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
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
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
							<th scope="col">대전방식</th>
							<th scope="col">소속명</th>
							<th scope="col">소속코드번호</th>
							<th scope="col">소속명</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th scope="row">1</th>
							<td>2016년</td>
							<td class="left">한국춘계유도선수권대회</td>
							<td>개인전</td>
							<td>초등부</td>
							<td>여</td>
							<td>-32kg</td>
							<td>토너먼트</td>
							<td>보성초등학교</td>
							<td>002-001</td>
							<td>이세라</td>
						</tr>
						<tr>
							<th scope="row">2</th>
							<td>2016년</td>
							<td class="left">한국춘계유도선수권대회</td>
							<td>개인전</td>
							<td>초등부</td>
							<td>여</td>
							<td>-32kg</td>
							<td>토너먼트</td>
							<td>보성초등학교</td>
							<td>002-001</td>
							<td>이세라</td>
						</tr>
						<tr>
							<th scope="row">3</th>
							<td>2016년</td>
							<td class="left">한국춘계유도선수권대회</td>
							<td>개인전</td>
							<td>초등부</td>
							<td>여</td>
							<td>-32kg</td>
							<td>토너먼트</td>
							<td>보성초등학교</td>
							<td>002-001</td>
							<td>이세라</td>
						</tr>
						<tr>
							<th scope="row">4</th>
							<td>2016년</td>
							<td class="left">한국춘계유도선수권대회</td>
							<td>개인전</td>
							<td>초등부</td>
							<td>여</td>
							<td>-32kg</td>
							<td>토너먼트</td>
							<td>보성초등학교</td>
							<td>002-001</td>
							<td>이세라</td>
						</tr>
						<tr>
							<th scope="row">5</th>
							<td>2016년</td>
							<td class="left">한국춘계유도선수권대회</td>
							<td>개인전</td>
							<td>초등부</td>
							<td>여</td>
							<td>-32kg</td>
							<td>토너먼트</td>
							<td>보성초등학교</td>
							<td>002-001</td>
							<td>이세라</td>
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