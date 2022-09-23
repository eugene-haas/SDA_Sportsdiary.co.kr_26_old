<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->

<!--//
<div class="train-diary custom-accod">
	<a href=".hold" data-toggle="collapse" >제목<span class="icon"><span class="caret"></span></span></a>
	<div class="hold collapse">내용</div>
</div>
-->

<!-- S: custom-accord -->
<div class="my-schedule-list custom-accord">
	<!-- S: accord-1 -->
	<div class="accord">
		<a href=".hold01" data-toggle="collapse" data-parent=".custom-accord">
			<div class="schedule-header sche-title">
				<h2><span>11</span>일</h2>
				<span class="mk-sqare mk-skyblue">훈</span>
				<span href="'#" class="mk-sqare mk-red">부</span>
				<span href="'#" class="mk-sqare mk-yellowgreen">체</span>
				<span class="icon"><span class="caret"></span></span>
			</div>
		</a>
		<div class="hold01 collapse">
			<!-- S: hold -->
			<div class="hold">
				내용1
			</div>
			<!-- E: hold -->
		</div>
	</div>
	<!-- E: accord-1 -->
	<!-- S: accord-2 -->
	<div class="accord">
		<a href=".hold02" data-toggle="collapse" data-parent=".custom-accord">
			<div class="schedule-header sche-title">
				<h2><span>12</span>일</h2>
				<span class="icon"><span class="caret"></span></span>
			</div>
		</a>
		<div class="hold02 collapse">
			<!-- S: hold -->
			<div class="hold">
				내용2
			</div>
			<!-- E: hold -->
		</div>
	</div>
	<!-- E: accord-2 -->
</div>
<!-- E: custom-accord -->

<script>
// icon caret
$(".my-schedule-list a").click(function(){
	$(this).toggleClass("on");
});
</script>