<!-- #include file="../include/config.asp" -->
<%
	'검색 시작일
	SDate = Request("SDate")
	'검색 종료일
	EDate = Request("EDate")

	SType = Request("SType")


	If SDate="" Then
		SDate = Left(DateAdd("w",-6,now()),10)
	End If

	If EDate = "" Then
		EDate = Left(now(),10)
	End If

	'검색 기간 설정이 되어 있지 않다면 기본 오늘 날짜~1주일전
%>

<script type="text/javascript">
	function pad(num) {
		num = num + '';
		return num.length < 2 ? '0' + num : num;
	}

	function dateToYYYYMMDD(date, status) {
		if (status == "M") {
			return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate() - 1);
		}
		else if (status == "Y") {
			return date.getFullYear() + '-' + pad(date.getMonth() + 2) + '-' + pad(date.getDate() - 1);
		}
		else if (status == "W") {
			return date.getFullYear() + '-' + pad(date.getMonth() + 2) + '-' + pad(date.getDate() - 6);
		}
	}

	var currDate = new Date();
	var tMon = currDate.getFullYear() + '-' + pad(currDate.getMonth() + 1) + '-' + pad(currDate.getDate());

	$(document).ready(function () {
		$('#search_date_id').change(function () {

			var search_date_id = $("#search_date_id option:selected").val();
			if (search_date_id == "1month") {
				var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 1));
				var prevMon = dateToYYYYMMDD(prevDate, 'M');
				$('#SDate').val(prevMon);
				$('#EDate').val(tMon);
				//alert(prevMon);
			}
			else if (search_date_id == "3month") {
				var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 3));
				var prevMon = dateToYYYYMMDD(prevDate, 'M');
				$('#SDate').val(prevMon);
				$('#EDate').val(tMon);
				//alert(prevMon);
			}
			else if (search_date_id == "6month") {
				var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 6));
				var prevMon = dateToYYYYMMDD(prevDate, 'M');
				$('#SDate').val(prevMon);
				$('#EDate').val(tMon);
				//alert(prevMon);
			}
			else if (search_date_id == "1year") {
				var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 13));
				var prevMon = dateToYYYYMMDD(prevDate, 'Y');
				$('#SDate').val(prevMon);
				$('#EDate').val(tMon);
				//alert(prevMon);
			}
			else if (search_date_id == "2year") {
				var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 25));
				var prevMon = dateToYYYYMMDD(prevDate, 'Y');
				$('#SDate').val(prevMon);
				$('#EDate').val(tMon);
				//alert(prevMon);
			}
			else if (search_date_id == "3year") {
				var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 37));
				var prevMon = dateToYYYYMMDD(prevDate, 'Y');
				$('#SDate').val(prevMon);
				$('#EDate').val(tMon);
				//alert(prevMon);
			}
			else if (search_date_id == "5year") {
				var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 61));
				var prevMon = dateToYYYYMMDD(prevDate, 'Y');
				$('#SDate').val(prevMon);
				$('#EDate').val(tMon);
				//alert(prevMon);
			}
			else if (search_date_id == "10year") {
				var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 121));
				var prevMon = dateToYYYYMMDD(prevDate, 'Y');
				$('#SDate').val(prevMon);
				$('#EDate').val(tMon);
				//alert(prevMon);
			}
			else {
				var prevDate = new Date(new Date().setMonth(new Date().getMonth() - 1));
				var prevMon = dateToYYYYMMDD(prevDate, 'W');
				$('#SDate').val(prevMon);
				$('#EDate').val(tMon);
			}

		});
	});


	//검색창 닫기
	function click_close(){
		 $("#sbox").slideToggle( "slow", function() {
			 $('#click_close').hide();
			 $('#click_open').show();
		});
	}


	//검색창 열기
	function click_open(){
		$("#sbox").slideDown( "slow", function() {
			$('#click_close').show();
			$('#click_open').hide();
		});
	}

</script>
<body class="lack-bg">
	<!-- S: sub-header -->
	<div class="sd-header sd-header-sub">
		<!-- #include file="../include/sub_header_arrow.asp" -->
		<h1>지도자상담</h1>
		<!-- #include file="../include/sub_header_gnb.asp" -->
	</div>
	<!-- #include file = "../include/gnb.asp" -->
	<!-- E: sub-header -->

	<!-- S: record-menu -->
	<div class="record-menu">
        <div class="big-cat">
          <ul class="menu-list flex">
            <li><a href="./req-counsel.asp" class="btn">상담요청하기</a></li>
            <li><a href="./from-manager.asp" class="btn">상담받기</a></li>
            <li><a href="./favorite-counsel.asp" class="btn">즐겨찾기</a></li>
          </ul>
        </div>
    </div>
	<!-- E: record-menu -->
	<!-- S: record-input -->
	<form name="s_frm" method="post">
	<div class="record-input" id="sbox">
		<!-- S: sel-list -->
		<div class="sel-list">
			<!-- S: 기간 선택 -->
			<dl class="clearfix term-sel">
				<dt>기간선택</dt>
				<!--<dd class="on">-->
				<dd id="search_date">
					<select name="search_date" id="search_date_id" onChange="chk_FndDateValue();">
						<option value="week">최근 1주일</option>
						<option value="month">최근 1개월</option>
						<option value="month3">최근 3개월</option>
                        <option value="month6">최근 6개월</option>
					  	<option value="year">최근 1년</option>
						<option value="year2">최근 2년</option>
                        <option value="year3">최근 3년</option>
						<option value="yerar5">최근 5년</option>
						<option value="year10">최근 10년</option>
					</select>
				</dd>
			</dl>
			<!-- E: 기간 선택 -->
			<!-- S: 기간 조회 -->
			<dl class="clearfix term-srch">
				<dt>기간조회</dt>
				<!--<dd class="on">-->
				<dd>
					<span><input type="date" name="SDate" id="SDate" value="<%=SDate%>"></span>
				</dd>
				<dd class="flow">
					<span>~</span>
				</dd>
				<!--<dd class="on">-->
				<dd>
					<span><input type="date" name="EDate" id="EDate" value="<%=EDate%>"></span>
				</dd>
			</dl>
			<!-- E: 기간 조회 -->
			<!-- S: 작성자 검색 -->
			<dl class="clearfix term-user">
				<dt>작성자 선택</td>
				<!--<dd class="on">-->
				<dd id="search_user">
					<select>
						<option>홍길동</option>
					</select>
				</dd>
			</dl>
			<!-- E: 작성자 검색 -->
		</div>
		<!-- E: sel-list -->
		<div class="btn-list">
			<a href="javascript:click_close();" class="btn-left btn">닫기</a>
			<a href="javascript:chart_view();" class="btn-right btn">조회</a>
		</div>
	</div>
	</form>
	<!-- E: record-input -->
	<!-- S: tail -->
	<div class="tail">
		<a href="javascript:click_open();"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" id="click_open" style="display:none;" alt="열기"></a>
		<a href="javascript:click_close();" ><img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" id="click_close" alt="닫기"></a>
	</div>
	<!-- E: tail -->
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
