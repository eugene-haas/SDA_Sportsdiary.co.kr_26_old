<!--#include virtual="/Manager/Common/common_header.asp"-->

<!-- psd에선 width가 930px로 되어있네요 -->
<div class="popup-wrap">
	<div class="popup">
		<!-- S : tit-popup 타이틀 -->
		<div class="tit-popup">
			<h1>
				<!--<i class="fa fa-th-large" aria-hidden="true"></i>-->
				<strong>조회</strong>
			</h1>
		</div>
		<!-- E : tit-popup 타이틀 -->
		<!-- S : popup-inner 팝업 콘텐츠 -->
		<div class="popup-inner">
			<!-- S : pop-view 검색조건-->
			<div class="pop-view">
				<select>
					<option value="op1">::: 지역 :::</option>
				</select>
				<select>
					<option value="op1">::: 팀구분 선택 :::</option>
				</select>
				<select>
					<option value="op1">::: 소속 :::</option>
				</select>
				<a href="#" class="btn-sch-pop"><i class="icon-sch"><img src="../images/icon_sch.png" alt="" /></i>검색</a>
			</div>
			<!-- E : pop-view 검색조건 -->
			<!-- S : sch-result-pop 검색결과 -->
			<div class="sch-result-pop">
				<a href="#" class="btn-more-result">
					전체 (<strong>1,000</strong>)건 / <strong class="current">현재(1)</strong>
					<!--//<i class="fa fa-plus" aria-hidden="true"></i>-->
				</a>
			</div>
			<!-- E : sch-result-pop 검색결과 -->
			<!--  S : table-list-wrap 리스트-->
			<div class="table-list-wrap">
				<table class="table-list">
					<caption>조회 리스트</caption>
					<colgroup>
						<col width="60px" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
						<col width="*" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">선택</th>
							<th scope="col">팀코드</th>
							<th scope="col">팀구분</th>
							<th scope="col">시도</th>
							<th scope="col">구군</th>
							<th scope="col">학교명</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th scope="row"><a href="#" class="btn-list type2">선택 <i class="fa fa-caret-right" aria-hidden="true"></i></a></th>
							<td>22351</td>
							<td>일반부</td>
							<td>서울</td>
							<td>중구</td>
							<td class="left">파이널유도멀티짐</td>
						</tr>
						<tr>
							<th scope="row"><a href="#" class="btn-list type2">선택 <i class="fa fa-caret-right" aria-hidden="true"></i></a></th>
							<td>22351</td>
							<td>대학교</td>
							<td>대전</td>
							<td>동구</td>
							<td class="left">코리아유도체육관</td>
						</tr>
					</tbody>
				</table>
				<a href="#" class="btn-more-list"><span>더보기</span><i class="fa fa-caret-down" aria-hidden="true"></i></a>
			</div>
			<!--  E : table-list-wrap 리스트-->
		</div>
		<!-- E : popup-inner 팝업 콘텐츠 -->
	</div>
	<div class="btn-center-list">
		<a href="#" class="btn">닫기</a>
	</div>
</div>