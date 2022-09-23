
						<!--<a href="#" class="btn-top-sdr" title="더보기"><i class="fa fa-sort-desc" aria-hidden="true"></i></a>
						<a href="#" class="btn-top-sdr" title="닫기"><i class="fa fa-minus" aria-hidden="true"></i></a>--><!--#include virtual="/Manager/Common/common_header.asp"-->
	<!-- S : content -->
	<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
	<section>
		<div id="content">
			<div class="loaction">
				<strong>관리</strong> &gt; 공통코드
			</div>
			<!-- S : top-navi -->
			<div class="top-navi">
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->
					<div class="top-navi-tp">
						<h3 class="top-navi-tit">
							<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
							<strong>공통코드</strong>
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
								<caption>공통코드 기본정보</caption>
								<colgroup>
									<col width="94px" />
									<col width="*" />
									<col width="64px" />
									<col width="*" />
									<col width="64px" />
									<col width="*" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row"><label for="common-code">공통코드</label></th>
										<td><input type="text" id="common-code" /></td>
										<th scope="row"><label for="refer-code">참조코드</label></th>
										<td><input type="text" id="refer-code" /></td>
										<th scope="row">정렬순서</th>
										<td>
												<select>
													<option value="op1">3</option>
													<option value="op2">4</option>
												</select>
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="code-name-l">코드명(L)</label></th>
										<td><input type="text" id="code-name-l" /></td>
										<th scope="row"><label for="code-name-s">코드명(S)</th>
										<td><input type="text" id="code-name-s" /></td>
										<th scope="row">삭제구분</th>
										<td>
											<select>
												<option value="op1">아니오</option>
												<option value="op2">예</option>
											</select>
										</td>
									</tr>
									<tr>
										<th scope="row">스포츠구분</th>
										<td>
											<select>
												<option value="op1">유도</option>
											</select>
										</td>
										<th scope="row"><label for="skill-score">기술점수</th>
										<td>
											<input type="text" id="skill-score" />
										</td>
										<th scope="row"></th>
										<td></td>
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
							<col width="78px" />
							<col width="150px" />
							<col width="50px" />
							<col width="*" />
							<col width="120px" />
							<col width="150px" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">경기종목</th>
								<td>
									<select>
										<option value="op1">::::::: 종목선택 :::::::</option>
									</select>
								</td>
								<th scope="row">항목</th>
								<td>
									<select>
										<option value="op1">경기결과</option>
										<option value="op2">경기구분</option>
										<option value="op3">고등남자</option>
									</select>
								</td>
								<th></th>
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
					<caption>공통코드 리스트</caption>
					<colgroup>
						<col width="44px" />
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
							<th scope="col">경기종목</th>
							<th scope="col">공통코드</th>
							<th scope="col">코드명(L)</th>
							<th scope="col">코드명(S)</th>
							<th scope="col">부모코드</th>
							<th scope="col">정렬순서</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th scope="row">1</th>
							<td>유도</td>
							<td>sd042002</td>
							<td>부전승구분</td>
							<td>부전승</td>
							<td>sd042</td>
							<td>2</td>
						</tr>
						<tr>
							<th scope="row">2</th>
							<td>유도</td>
							<td>sd042002</td>
							<td>부전승구분</td>
							<td>부전승</td>
							<td>sd042</td>
							<td>2</td>
						</tr>
						<tr>
							<th scope="row">3</th>
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
						</tr>
						<tr>
							<th scope="row">5</th>
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
						</tr>
						<tr>
							<th scope="row">7</th>
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
						</tr>
						<tr>
							<th scope="row">9</th>
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
						</tr>
						<tr>
							<th scope="row">11</th>
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
						</tr>
						<tr>
							<th scope="row">13</th>
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
						</tr>
						<tr>
							<th scope="row">15</th>
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
						</tr>
						<tr>
							<th scope="row">17</th>
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
						</tr>
						<tr>
							<th scope="row">19</th>
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