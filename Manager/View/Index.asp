<!--#include virtual="/Manager/Common/common_header.asp"-->
<!-- bootstrap 부트스트랩 -->
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
	<!-- S : content -->
	<section>
		<div id="content">
			<div class="loaction">
				<strong>회원관리</strong> &gt; 개인프로필
			</div>
			<!-- S : top-navi -->
			<div class="top-navi">
				<div class="top-navi-inner">
					<!-- S : top-navi-tp 접혔을 때-->
					<div class="top-navi-tp">
						<h3 class="top-navi-tit">
							<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
							<strong>개인프로필</strong>
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
								<caption>개인프로필 기본정보</caption>
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
										<th scope="row"><label for="player-code">선수코드</label></th>
										<td><input type="text" id="player-code" /></td>
										<th scope="row"><label for="player-name">이름</label></th>
										<td><input type="text" id="player-name" /></td>
										<th scope="row">성별</th>
										<td>
											<input type="radio" id="gender-man" name="gender" /> <label for="gender-man" class="man">남</label>
											<input type="radio" id="gender-woman" name="gender" /> <label for="gender-woman">여</label>
										</td>
									</tr>
									<tr>
										<th scope="row"><label for="user-name">아이디</label></th>
										<td><input type="text" id="user-name" /></td>
										<th scope="row"><label for="user-pw">비밀번호</label></th>
										<td><input type="password" id="user-pw" /></td>
										<th scope="row"><label for="user-pw-2">비밀번호 확인</label></th>
										<td><input type="password" id="user-pw-2" /></td>
									</tr>
									<tr>
										<th scope="row"><label for="phone-num">휴대폰</label></th>
										<td>
											<input type="text" id="phone-num" />
										</td>
										<th scope="row">생년월일</th>
										<td>
											<div class="birth-list">
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
										<th scope="row"></th>
										<td></td>
									</tr>
								</tbody>
							</table>
						</div>
						<h4 class="sub-tit">운동정보</h4>
						<table class="navi-btm-table">
							<caption>운동정보 입력</caption>
							<colgroup>
								<col width="146px" />
								<col width="110px" />
								<col width="127px" />
								<col width="136px" />
								<col width="136px" />
							</colgroup>
							<tbody>
								<tr>
									<td>
										시작년도
										<select>
											<option value="op1">2016</option>
										</select>
									</td>
									<td>
										<label for="player-stature">키</label>
										<input type="text" id="player-stature" /> cm
									</td>
									<td>
										<label for="player-weight">몸무게</label>
										<input type="text" id="player-weight" /> kg
									</td>
									<td>
										<label for="player-blood-type">혈액형</label>
										<input type="text" id="player-blood-type" /> 형
									</td>
									<td>
										<label for="weight-division">체급
										<input type="text" id="weight-division" /> kg
									</td>
								</tr>
							</tbody>
						</table>
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
							<col width="*" />
							<col width="50px" />
							<col width="*" />
							<col width="37px" />
							<col width="*" />
							<col width="37px" />
							<col width="*" />
							<col width="37px" />
							<col width="*" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">경기종목</th>
								<td>
									<select>
										<option value="op1">::::::: 종목선택 :::::::</option>
									</select>
								</td>
								<th scope="row">지역</th>
								<td>
									<select>
										<option value="op1">::::::::::: 전체 :::::::::::</option>
									</select>
								</td>
								<th scope="row">성별</th>
								<td>
									<select>
										<option value="op1" selected>::::: 전체 :::::</option>
										<option value="op2">남</option>
										<option value="op3">여</option>
									</select>
								</td>
								<th>소속</th>
								<td>
									<select>
										<option value="op1">::::::::::: 전체 :::::::::::</option>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="row">소속명</th>
								<td>
									<input type="text" />
								</td>
								<th scope="row">선수명</th>
								<td>
									<input type="text" />
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
					<caption>개인프로필 리스트</caption>
					<colgroup>
						<col width="44px" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="125px" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">번호</th>
							<th scope="col">경기종목</th>
							<th scope="col">소속구분</th>
							<th scope="col">지역</th>
							<th scope="col">소속명</th>
							<th scope="col">성별</th>
							<th scope="col">이름</th>
							<th scope="col">선수코드</th>
							<th scope="col">프로필</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th scope="row">1</th>
							<td>유도</td>
							<td>고등부</td>
							<td>서울</td>
							<td>중앙여자고등학교</td>
							<td>여</td>
							<td>최보라</td>
							<td>001-002</td>
							<td>
								<a href="#" class="btn-list">프로필 보기 <i><img src="../images/icon_more_right.png" alt="" /></i></a>
							</td>
						</tr>
						<tr>
							<th scope="row">2</th>
							<td>태권도</td>
							<td>중등부</td>
							<td>부산</td>
							<td>경기중학교</td>
							<td>남</td>
							<td>김보라</td>
							<td>001-002</td>
							<td>
								<a href="#" class="btn-list">프로필 보기 <i><img src="../images/icon_more_right.png" alt="" /></i></a>
							</td>
						</tr>
						<tr>
							<th scope="row">3</th>
							<td>테니스</td>
							<td>일반부</td>
							<td>대구</td>
							<td>서서울초등학교</td>
							<td>남</td>
							<td>박보라</td>
							<td>001-002</td>
							<td>
								<a href="#" class="btn-list">프로필 보기 <i><img src="../images/icon_more_right.png" alt="" /></i></a>
							</td>
						</tr>
						<tr>
							<th scope="row">4</th>
							<td>축구</td>
							<td>고등부</td>
							<td>청주</td>
							<td>부산시청</td>
							<td>여</td>
							<td>고보라</td>
							<td>001-002</td>
							<td>
								<a href="#" class="btn-list">프로필 보기 <i><img src="../images/icon_more_right.png" alt="" /></i></a>
							</td>
						</tr>
						<tr>
							<th scope="row">5</th>
							<td>야구</td>
							<td>중등부</td>
							<td>수원</td>
							<td>경기중학교</td>
							<td>여</td>
							<td>진보라</td>
							<td>001-002</td>
							<td>
								<a href="#" class="btn-list">프로필 보기 <i><img src="../images/icon_more_right.png" alt="" /></i></a>
							</td>
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