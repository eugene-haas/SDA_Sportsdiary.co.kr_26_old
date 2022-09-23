<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->

<script  type="text/javascript" src="../js/Train.js"></script>
<%
    datetimepicker1_h=Date()
    StimFistCd_h="0"

   if IsNull(fInject(Request("StimFistCd_h")))then
       datetimepicker1_h=Date()
    else
        if fInject(Request("datetimepicker1_h"))="" then
           datetimepicker1_h=Date()
        else
            datetimepicker1_h=fInject(Request("datetimepicker1_h"))
        end if
    end if

    if IsNull(fInject(Request("StimFistCd_h")))then
        StimFistCd_h="0"
    else
         if fInject(Request("StimFistCd_h"))="" then
           StimFistCd_h="0"
        else
            StimFistCd_h=fInject(Request("StimFistCd_h"))
        end if
    end if

%>
<body>
<form name="frm" id="frm" method="post">
  <input type="hidden" name="StimFistCd_h" id="StimFistCd_h" value="<%=StimFistCd_h %>">
  <input type="hidden" name="datetimepicker1_h"id="datetimepicker1_h"   value="<%=datetimepicker1_h %>">
  <input type="hidden" name="COUNT"id="COUNT">

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>훈련일지</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub train">
    <div class="top-icon-menu">
       <!-- #include file="../include/sub_top_icon_menu.asp" -->
      <p>꾸준한 일지작성은 <span>객관적인 자기분석</span>과</br>
      <span>경기력향상</span>에 도움됩니다.</p>
    </div>
    <!-- S : datepicker-wrap 훈련날짜 -->
    <!-- E : 날짜 받고 데이터 불러오기 ? 신규  -->
    <div class="datepicker-wrap">
      <label for="datetimepicker1">훈련날짜</label>
      <div class='input-group date'>
        <input id="datetimepicker1" name='datetimepicker1' type='date' class="form-control"  value ="<%=Date() %>" />
        <span class="input-group-addon">
          <span class="glyphicon glyphicon-calendar"></span>
        </span>
      </div>
      <a href="#" class="btn-navy">오늘</a>
    </div>
    <!-- E : datepicker-wrap 훈련날짜 -->
    <!-- S : 컨디션 -->
    <!--db select -->
    <h2>컨디션</h2>
    <div class="navyline-top-list">
      <label for="condition">심리적상태</label>
      <select id="condition">
        <option>:: 심리적상태 선택 ::</option>
        <option>매우좋음</option>
        <option>좋음</option>
        <option>보통</option>
        <option>나쁨</option>
        <option>매우나쁨</option>
      </select>
    </div>
    <!-- E : 컨디션 -->
    <!-- S : 훈련참석(부상) 체크 -->
    <h2>훈련참석(부상) 체크</h2>
    <div class="navyline-top-list">
			<!-- S: custom-accord -->
			<div class="custom-accord">
				<!-- S: accord-1 -->
				<div class="accord">
					<a href=".hold01" data-toggle="collapse" data-parent=".custom-accord">
						<div class="train-header">
							<h3>훈련참석 체크 시 참고하세요!</h3>
							<span class="icon"><span class="caret"></span></span>
						</div>
					</a>
					<div class="hold01 collapse">
						<div class="list-bu-navy-wrap bg-gray">
							<ul class="list-bu-navy fold1">
								<li>훈련참석
									<ul>
										<li>- 정상참석: 좋은 컨디션에서 전체 훈련 일정을 소화했을 경우</li>
										<li>- 일부참석: 좋지 않은 컨디션에서 훈련 일정의 일부를 소화했을 경우</li>
									</ul>
								</li>
								<li>훈련불참: 부상 등의 사유로 훈련 일정을 참여하지 못했을 경우</li>
								<li>공식일정 불참: 공식일정 사유로 훈련에 참여하지 못했을 경우</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- E: accord-1 -->
			</div>
			<!-- E: custom-accord -->
      <ul class="btn-select flex">
        <li id="btn-select-on" class="on"> <a href="#" onClick="TrainonfBtn(1); return false;">훈련참석</a> </li>
        <li id="btn-select-off" > <a href="#" onClick="TrainonfBtn(2); return false;">훈련불참</a> </li>
        <!-- 훈련불참 선택시 훈련목표, 공식훈련내용, 훈련평가 x -->
      </ul>
      <!-- S : 훈련참석 > 정상참석, 일부참석 선택시
				팀매니저 연동시 값을 가져오고 비활성화된 것처럼 회색으로 처리
			-->
      <div>
        <input type="radio" id="train-check01" name="train-check" disabled /> <label for="train-check01" class="txt-disabled">정상참석</label>
        <input type="radio" id="train-check02" name="train-check" checked disabled /> <label for="train-check02" class="txt-disabled">일부참석</label>
        <select id="train-check01-select" class="train-select" disabled>
          <option>부상중 / 일부참석</option>
          <option>재활(치료)훈련 / 일부참석</option>
          <option>병가(감기,몸살,기타질환) / 일부참석</option>
          <option>생리(통) / 일부참석</option>
        </select>
      </div>
      <!-- E : 훈련참석 > 정상참석, 일부참석 선택시 -->
      <!-- S : 훈련불참 선택시 -->
      <div>
        <select id="train-check02-select" class="train-select" disabled>
          <option>부상</option>
          <option>재활(치료)훈련</option>
          <option>병가(감기,몸살,기타질환)</option>
					<!--여자일때만-->
          <option>생리(통)</option>
					<!--여자일때만-->
          <option>무단불참</option>
          <option>기타(가정사유 등)</option>
          <option>수업참석</option>
          <option>휴식</option>
          <option>대회참석(국내)</option>
          <option>대회참석(해외)</option>
        </select>
      </div>
      <!-- E : 훈련불참 선택시 -->
			<!-- S : 팀매니저 연동시 -->
			<div class="train-team-manager">
				<strong>(좌) 어깨, (좌)발목</strong>
				<a href="#" class="btn-or-pop" data-toggle="modal" data-target="#injury-chk">부상부위 확인<!-- 클릭시 팝업 --></a>
			</div>
			<!-- E : 탬매니저 연동시 -->
    </div>
    <!-- E : 훈련참석(부상) 체크 -->
    <!-- S : 훈련목표(중복선택가능) -->
    <h2>훈련목표(중복선택가능)</h2>
    <ul class="train-goal-list">
<!--
    sd025001
    sd025002
    sd025003
    sd025004
    sd025005
    -->
      <li><input type="checkbox" id="train-goal01" /> <label for="train-goal01">체력향상 훈련</label></li>
      <li><input type="checkbox" id="train-goal02" /> <label for="train-goal02">기술향상 훈련</label></li>
      <li><input type="checkbox" id="train-goal03" /> <label for="train-goal03">대회전략 준비 (실전에 필요한 전술훈련 중심)</label></li>
      <li><input type="checkbox" id="train-goal04" /> <label for="train-goal04">컨디션 조절을 위한 훈련</label></li>
      <li><input type="checkbox" id="train-goal05" /> <label for="train-goal05">부상에 의한 재활훈련</label></li>
    </ul>
    <!-- E : 훈련목표(중복선택가능) -->
    <!-- S : 공식훈련 내용 (기본 2개 노출) -->
    <div class="official-train-wrap">
      <div class="official-train">
        <h2>공식훈련 내용</h2>
      </div>
      <div class="bg-navy">
        <select>
          <option>훈련구분을 선택하세요</option>
          <option>새벽훈련</option>
          <option>오전훈련</option>
          <option>오후훈련</option>
          <option>야간훈련</option>
          <option>개인훈련</option>
        </select>
      </div>
      <ul class="official-train-select">
        <li>
          <select>
            <option>훈련장소</option>
            <option>Home (우리 체육관이나 운동장)</option>
            <option>Away (다른 팀 체육관이나 운동장)</option>
            <option>외부훈련 (산악/계단/기타훈련 등)</option>
            <option>국내전지훈련 (숙식을 하며 타지역에서 훈련)</option>
            <option>해외전지훈련 (숙식을 하며 타지역에서 훈련)</option>
          </select>
        </li>
        <li>
          <select>
            <option>시간</option>
            <option>10분</option>
            <option>20분</option>
            <option>30분</option>
            <option>1시간</option>
            <option>1시간 30분</option>
            <option>2시간</option>
            <option>2시간 30분</option>
            <option>3시간</option>
            <option>3시간 30분</option>
            <option>4시간</option>
            <option>4시간 30분</option>
            <option>5시간</option>
            <option>5시간 30분</option>
            <option>6시간</option>
          </select>
        </li>
        <li>
          <select>
            <option>훈련유형</option>
            <option>체력훈련</option>
            <option>도복훈련</option>
          </select>
        </li>
        <li>
          <a href="#" class="btn-gray">훈련종류선택</a>
        </li>
      </ul>
      <!-- S : btn-train-list 선택 완료시 hide -->
      <!-- S : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
      <ul class="train-select-list bg-gray">
        <li>- 준비운동</li>
        <li>- 써키트 트레이닝</li>
        <li>- 몸풀기 게임</li>
      </ul>
      <!-- E : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
    </div>
    <!-- E : 공식훈련 내용 (기본 2개 노출) -->
    <!-- S : 공식훈련 내용 (기본 2개 노출) -->
    <div class="official-train-wrap">
      <div class="official-train">
        <h2>공식훈련 내용</h2>
      </div>
      <div class="bg-navy">
        <select>
          <option>훈련구분을 선택하세요</option>
          <option>새벽훈련</option>
          <option>오전훈련</option>
          <option>오후훈련</option>
          <option>야간훈련</option>
          <option>개인훈련</option>
        </select>
      </div>
      <ul class="official-train-select">
        <li>
          <select>
            <option>훈련장소</option>
            <option>Home (우리 체육관이나 운동장)</option>
            <option>Away (다른 팀 체육관이나 운동장)</option>
            <option>외부훈련 (산악/계단/기타훈련 등)</option>
            <option>국내전지훈련 (숙식을 하며 타지역에서 훈련)</option>
            <option>해외전지훈련 (숙식을 하며 타지역에서 훈련)</option>
          </select>
        </li>
        <li>
          <select>
            <option>시간</option>
            <option>10분</option>
            <option>20분</option>
            <option>30분</option>
            <option>1시간</option>
            <option>1시간 30분</option>
            <option>2시간</option>
            <option>2시간 30분</option>
            <option>3시간</option>
            <option>3시간 30분</option>
            <option>4시간</option>
            <option>4시간 30분</option>
            <option>5시간</option>
            <option>5시간 30분</option>
            <option>6시간</option>
          </select>
        </li>
        <li>
          <select>
            <option>훈련유형</option>
            <option>체력훈련</option>
            <option>도복훈련</option>
          </select>
        </li>
        <li>
          <a href="#" class="btn-gray">훈련종류선택</a>
        </li>
      </ul>
      <!-- S : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
      <ul class="train-select-list bg-gray">
        <li>- 준비운동</li>
        <li>- 써키트 트레이닝</li>
        <li>- 몸풀기 게임</li>
      </ul>
      <!-- E : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
    </div>
    <!-- E : 공식훈련 내용 (기본 2개 노출) -->
    <!-- S : 개인훈련 내용은 1개만 노출, 추가없음 -->
    <div>
			<!-- S: custom-accord -->
			<div class="custom-accord">
				<!-- S: accord-1 -->
				<div class="accord">
					<a href=".hold02" data-toggle="collapse" data-parent=".custom-accord">
						<div class="train-individual-header">
							<h2>개인훈련 내용 입력</h2>
							<span class="icon"><span class="caret"></span></span>
						</div>
					</a>
					<div class="hold02 collapse">
						<div class="bg-or">
							<select>
								<option>훈련구분을 선택하세요</option>
								<option>새벽훈련</option>
								<option>오전훈련</option>
								<option>오후훈련</option>
								<option>야간훈련</option>
								<option>개인훈련</option>
							</select>
						</div>
						<ul class="official-train-select">
							<li>
								<select>
									<option>훈련장소</option>
									<option>Home (우리 체육관이나 운동장)</option>
									<option>Away (다른 팀 체육관이나 운동장)</option>
									<option>외부훈련 (산악/계단/기타훈련 등)</option>
									<option>국내전지훈련 (숙식을 하며 타지역에서 훈련)</option>
									<option>해외전지훈련 (숙식을 하며 타지역에서 훈련)</option>
								</select>
							</li>
							<li>
								<select>
									<option>시간</option>
									<option>10분</option>
									<option>20분</option>
									<option>30분</option>
									<option>1시간</option>
									<option>1시간 30분</option>
									<option>2시간</option>
									<option>2시간 30분</option>
									<option>3시간</option>
									<option>3시간 30분</option>
									<option>4시간</option>
									<option>4시간 30분</option>
									<option>5시간</option>
									<option>5시간 30분</option>
									<option>6시간</option>
								</select>
							</li>
							<li>
								<select>
									<option>훈련유형</option>
									<option>체력훈련</option>
									<option>도복훈련</option>
								</select>
							</li>
							<li>
								<a href="#" class="btn-gray">훈련종류선택</a>
							</li>
						</ul>
						<!-- E: hold -->
					</div>
				</div>
				<!-- E: accord-1 -->
			</div>
			<!-- E: custom-accord -->
    </div>
    <!-- E : 개인훈련 내용 1개만 노출, 추가없음 -->
    <!-- S : 훈련평가 -->
    <h2>훈련평가</h2>
    <table class="navy-top-table">
      <thead>
        <tr>
          <th rowspan="2">평가 내용</th>
          <th colspan="3">만족도</th>
        </tr>
        <tr>
          <th>상</th>
          <th>중</th>
          <th>하</th>
        </tr>
        <tbody>
          <tr>
            <td><label for="tranin-question01">1.훈련의 목표와 의도에 맞게 훈련이 되었나요?</label></td>
            <td><input type="radio" id="tranin-question01-1" name="tranin-question01" checked /></td>
            <td><input type="radio" id="tranin-question01-2" name="tranin-question01" /></td>
            <td><input type="radio" id="tranin-question01-3" name="tranin-question01" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question02">2.체력적인 만족도는?</label></td>
            <td><input type="radio" id="tranin-question02-1" name="tranin-question02" checked /></td>
            <td><input type="radio" id="tranin-question02-2" name="tranin-question02" /></td>
            <td><input type="radio" id="tranin-question02-3" name="tranin-question02" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question03">3.기술적인 만족도는?</label></td>
            <td><input type="radio" id="tranin-question03-1" name="tranin-question03" checked /></td>
            <td><input type="radio" id="tranin-question03-2" name="tranin-question03" /></td>
            <td><input type="radio" id="tranin-question03-3" name="tranin-question03" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question04">4.훈련의 양이 충분했나요?</label></td>
            <td><input type="radio" id="tranin-question04-1" name="tranin-question04" checked /></td>
            <td><input type="radio" id="tranin-question04-2" name="tranin-question04" /></td>
            <td><input type="radio" id="tranin-question04-3" name="tranin-question04" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question05">5.훈련의 질에 만족하나요?</label></td>
            <td><input type="radio" id="tranin-question05-1" name="tranin-question05" checked /></td>
            <td><input type="radio" id="tranin-question05-2" name="tranin-question05" /></td>
            <td><input type="radio" id="tranin-question05-3" name="tranin-question05" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question06">6.준비운동,정리운동은 잘 했나요?</label></td>
            <td><input type="radio" id="tranin-question06-1" name="tranin-question06" checked /></td>
            <td><input type="radio" id="tranin-question06-2" name="tranin-question06" /></td>
            <td><input type="radio" id="tranin-question06-3" name="tranin-question06" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question07">7.훈련에 집중할 수 있는 환경이였나요?</label></td>
            <td><input type="radio" id="tranin-question07-1" name="tranin-question07" checked /></td>
            <td><input type="radio" id="tranin-question07-2" name="tranin-question07" /></td>
            <td><input type="radio" id="tranin-question07-3" name="tranin-question07" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question08">8.식사,수면,휴식 등 자기관리가 잘 되었나요?</label></td>
            <td><input type="radio" id="tranin-question08-1" name="tranin-question08" checked /></td>
            <td><input type="radio" id="tranin-question08-2" name="tranin-question08" /></td>
            <td><input type="radio" id="tranin-question08-3" name="tranin-question08" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question09">9.최고의 선수가 되겠다는 의지가 강했나요?</label></td>
            <td><input type="radio" id="tranin-question09-1" name="tranin-question09" checked /></td>
            <td><input type="radio" id="tranin-question09-2" name="tranin-question09" /></td>
            <td><input type="radio" id="tranin-question09-3" name="tranin-question09" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question10">10.스스로 최선을 다했다고 생각하나요?</label></td>
            <td><input type="radio" id="tranin-question10-1" name="tranin-question10" checked /></td>
            <td><input type="radio" id="tranin-question10-2" name="tranin-question10" /></td>
            <td><input type="radio" id="tranin-question10-3" name="tranin-question10" /></td>
          </tr>
        </tbody>
      </thead>
    </table>
    <!-- E : 훈련평가 -->
    <!-- S : 메모리 -->
    <h2>메모리</h2>
    <ul class="memory">
      <li>
        <p><span class="icon-on-favorite">★</span> <label for="memory-txt01">잘된점</label></p>
        <p><textarea id="memory-txt01" placeholder="잘된점을 입력하세요"></textarea></p>
      </li>
      <li>
        <p><span class="icon-off-favorite">★</span> <label for="memory-txt02">보완점</label></p>
        <p><textarea id="memory-txt02" placeholder="보완점을 입력하세요."></textarea></p>
      </li>
      <li>
        <p><span class="icon-on-favorite">★</span> <label for="memory-txt03">나의일기</label></p>
        <p><textarea id="memory-txt03" placeholder="나만의 일기를 작성해 보세요. (비공개)"></textarea></p>
      </li>
      <li>
        <p><span class="icon-off-favorite">★</span> <label for="memory-txt04">지도자상담</label></p>
        <p><textarea id="memory-txt04" placeholder="코치님 또는 감독님에게 하고 싶은 말을 입력하세요."></textarea></p>
      </li>
      <li>
        <p><span class="icon-off-favorite">★</span> <label for="memory-txt05">지도자답변</label></p>
        <p><textarea id="memory-txt05"></textarea></p>
      </li>
    </ul>
    <!-- E : 메모리 -->
    <div class="container">
      <a href="#" class="btn-full">저장</a>
    </div>
  </div>
  <!-- E : sub -->
  <!-- S: 경기상세입력 누락 알림 modal -->
  <div class="modal fade confirm-modal" id="injury-chk" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">부상부위</div>
        <div class="modal-body">
          <ul class="tab-menu type3">
            <li class="on"><a href="#">부상부위(앞)</a></li>
            <li><a href="#">부상부위(뒤)</a></li>
          </ul>
          <div class="tabc">
            <div class="dist-cont">
              <img src="http://img.sportsdiary.co.kr/sdapp/stats/injury-front.jpg" alt="부상부위 이미지 앞" />
            </div>
          </div>
          <div class="tabc" style="display:none">
            <div class="dist-cont">
              <img src="http://img.sportsdiary.co.kr/sdapp/stats/injury-back.jpg" alt="부상부위 이미지 뒤" />
            </div>
          </div>
        </div>
			<div class="modal-footer">
				<button type="button" class="btn btn-gray" data-dismiss="modal">닫기</button>
			</div>
      </div>
      <!-- ./ modal-content -->
    </div> <!-- ./modal-dialog -->
  </div>
  </form>
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
<script>
// icon caret
$(".custom-accord a").click(function(){
	$(this).toggleClass("on");
});
</script>
