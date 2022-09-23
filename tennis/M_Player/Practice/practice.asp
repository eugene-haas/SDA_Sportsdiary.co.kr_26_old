<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<script>
$(function () {
  $('#datetimepicker1').datetimepicker();
});
</script>
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>연습경기</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub rehearsal">
		<div class="top-icon-menu">
			<ul class="flex">
				<li><img src="http://img.sportsdiary.co.kr/sdapp/train/icon_pract_off@3x.png" alt="훈련일지" /></li>
				<li><img src="http://img.sportsdiary.co.kr/sdapp/train/icon_train_on@3x.png" alt="연습경기" /></li>
				<li><img src="http://img.sportsdiary.co.kr/sdapp/train/icon_match_off@3x.png" alt="대회일지" /></li>
				<li><img src="http://img.sportsdiary.co.kr/sdapp/train/icon_physi_off@3x.png" alt="체력측정" /></li>
			</ul>
			<p>연습경기는 <span>실전경기의 리허설</span>입니다.<br />
			<span>충분한 자기분석</span>을 해보세요.</p>
		</div>
		<div class="datepicker-wrap">
			<label for="datetimepicker1">연습날짜</label>
			<div class='input-group date' id='datetimepicker1'>
				<input type='text' class="form-control" />
				<span class="input-group-addon">
						<span class="glyphicon glyphicon-calendar"></span>
				</span>
			</div>
			<a href="#" class="btn-navy">오늘</a>
		</div>
		<div class="list-bu-navy-wrap">
			<h3><span>연습경기 입력 시 참고하세요!</span> <a href="#" class="more-a">▼</a>
			<!--//<a href="#" class="close-a">▲</a>--></h3>
			<ul class="list-bu-navy">
				<li>연습경기마다 상대선수의 정보를 저장/관리 하세요. </li>
				<li>경기결과를 선택 시, 경기의 상세내용을 함께 입력하시기 바랍니다.</li>
				<li>경기상세를 입력시 본인과 상대의 경기흐름과 기술패턴의 데이터 자료를 제공받을 수 있습니다.</li>
			</ul>
		</div>
		<!-- S : list-rehearsal-wrap -->
		<div class="list-rehearsal-wrap">
			<div class="top-list-rehearsal">
				<h3>연습경기 1</h3>
				<a href="#" class="btn-del-x">x</a>
			</div>
			<ul class="list-rehearsal">
				<li>
					<p>
						<select>
							<option>상대선수 선택</option>
						</select>
						<a href="#" class="btn-grayline">신규선수입력</a>
					</p>
					<p>
						<select>
							<option>경기결과 선택</option>
						</select>
						<a href="#" class="btn-or">경기상세입력</a>
					</p>
				</li>
			</ul>
		</div>
		<!--// E : list-rehearsal-wrap -->
		<!-- S : list-rehearsal-wrap -->
		<div class="list-rehearsal-wrap">
			<div class="top-list-rehearsal">
				<h3>연습경기 2</h3>
				<a href="#" class="btn-del-x">x</a>
			</div>
			<ul class="list-rehearsal">
				<li>
					<p>
						<select>
							<option>상대선수 선택</option>
						</select>
						<a href="#" class="btn-grayline">신규선수입력</a>
					</p>
					<p>
						<select>
							<option>경기결과 선택</option>
						</select>
						<a href="#" class="btn-or">경기상세입력</a>
					</p>
				</li>
			</ul>
		</div>
		<!--// E : list-rehearsal-wrap -->
		<div class="container">
			<a href="#" class="btn-plus"><span class="icon-plus">+</span>경기추가</a>
			<a href="#" class="btn-full">저장</a>
		</div>
  </div>
	<!-- E : sub -->
	<!-- S: 경기상세입력 누락 알림 modal -->
	<div class="modal fade" id="" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content modal-small">
				<div class="modal-header">알림</div>
				<div class="modal-body">
					<p>경기 상세입력을 하지 않았습니다.<br />
					경기 결과만 저장하시겠습니까?</p>
					<div class="btn-center">
						<a href="#" class="btn-left">취소</a>
						<a href="#" class="btn-right">저장</a>
					</div>
				</div>
			</div>
			<!-- ./ modal-content -->
		</div> <!-- ./modal-dialog -->
	</div>
	<!-- E : 경기상세입력 누락 알림 modal -->
  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
