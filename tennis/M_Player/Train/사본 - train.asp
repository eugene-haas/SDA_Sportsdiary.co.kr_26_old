<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->

<%
    TrRerdDate=fInject(Request("TrRerdDate")) 
    trainstatus =fInject(Request("trainstatus")) 

    StimFistCd_h="0"
    btn_select="1"
    TFPubCode_COUNT=2

    if trainstatus="" then
     trainstatus=0
    end if

    if TrRerdDate="" then
     TrRerdDate=Date()
     datetimepicker1_h=Date()
    else
    
    TrRerdDate=Replace(fInject(Request("TrRerdDate")),"-","")
    TrRerdDate=left(TrRerdDate,4)&"-"&mid(TrRerdDate,5,2)&"-"&right(TrRerdDate,2)

    datetimepicker1_h=TrRerdDate
    TrRerdDateTrs= FormatDateTime(TrRerdDate,1)

    end if
    
%>

<script  type="text/javascript" src="../js/Train.js"></script>
<script  type="text/javascript" src="../js/Train_save.js"></script>

 <style>
  .option_sel { color: red;}
</style>
<body>
<form name="frm" id="frm" method="post">

  <input type="hidden" name="trainstatus" id="trainstatus" value="<%=trainstatus %>" >
  <input type="hidden" name="StimFistCd_h" id="StimFistCd_h" value="<%=StimFistCd_h %>" >
  <input type="hidden" name="datetimepicker1_h"id="datetimepicker1_h"   value="<%=datetimepicker1_h %>">
  <input type="hidden" name="btn-select"id="btn-select"   value="<%=btn_select %>">
  <input type="hidden" name="TFPubCode_COUNT"id="TFPubCode_COUNT"value="<%=TFPubCode_COUNT %>">

<div id="divTrRerdIDX">
    <input type="hidden" name="p_TrRerdIDX"id="p_TrRerdIDX"value="<%=p_TrRerdIDX %>">
    <input type="hidden" name="p_MentlCd"id="p_MentlCd"value="<%=p_MentlCd %>">

    <input type="hidden" name="p_AdtFistCd"id="p_AdtFistCd"value="<%=p_AdtFistCd %>">
    <input type="hidden" name="p_AdtInTp"id="p_AdtInTp"value="<%=p_AdtInTp %>">
    <input type="hidden" name="p_AdtMidCd"id="p_AdtMidCd"value="<%=p_AdtMidCd %>">

    <input type="hidden" name="p_AdtWell"id="p_AdtWell"value="<%=p_AdtWell %>">
    <input type="hidden" name="p_AdtNotWell"id="p_AdtNotWell"value="<%=p_AdtNotWell %>">
    <input type="hidden" name="p_AdtMyDiay"id="p_AdtMyDiay"value="<%=p_AdtMyDiay %>">
    <input type="hidden" name="p_AdtAdvice"id="p_AdtAdvice"value="<%=p_AdtAdvice %>">
    <input type="hidden" name="p_AdtAdviceRe"id="p_AdtAdviceRe"value="<%=p_AdtAdviceRe %>">

                    
    <input type="hidden" name="p_AdtWellCkYn"id="p_AdtWellCkYn"value="<%=p_AdtWellCkYn %>">
    <input type="hidden" name="p_AdtNotWellCkYn"id="p_AdtNotWellCkYn"value="<%=p_AdtNotWellCkYn %>">
    <input type="hidden" name="p_AdtMyDiayCklYn"id="p_AdtMyDiayCklYn"value="<%=p_AdtMyDiayCklYn %>">
    <input type="hidden" name="p_AdtAdviceCkYn"id="p_AdtAdviceCkYn"value="<%=p_AdtAdviceCkYn %>">
    <input type="hidden" name="p_AdtAdviceReCkYn"id="p_AdtAdviceReCkYn"value="<%=p_AdtAdviceReCkYn %>">

</div>
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>훈련일지</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->
  <!-- S: sub -->
  <div class="sub train strength">
    <div class="top-icon-menu">
       <ul class="flex">
        <!--훈련일지 아이콘 Start-->
        <li>
          <a href="../Train/train.asp" role="button" alt="훈련일지">
            <img src="../images/train/icon_pract_on@3x.png" alt/>
          </a>
        </li>
        <!--훈련일지 아이콘 End -->
        <!--대회일지 아이콘 Start-->
        <li>
          <a href="../MatchDiary/match-diary.asp" role="button" alt="대회일지">
            <img src="../images/train/icon_match_off@3x.png" alt/>
          </a>
        </li>
        <!--대회일지 아이콘 End-->
        <!--체력측정 아이콘 Start-->
        <li>
          <a href="../Strength/index.asp" role="button" alt="체력측정">
            <img src = "../images/train/icon_physi_off@3x.png" alt/>
          </a>
        </li>
        <!--체력측정 아이콘 End-->
        <!--훈련계획 아이콘 Start-->
        <!--스포츠다이어리 팀 매니저 사용시-->
        <li>
          <!--팀매니저사용체크-->
          <a href="javascript:chk_TeamNotice();" role="button" alt="팀공지사항">
            <img src="../images/train/icon_plan_off@3x.png" alt/>
          </a>
        </li>
        <!--스포츠다이어리 팀 매니저 사용시-->
        <!--훈련계획 아이콘 End-->
      </ul>
      <p>꾸준한 일지작성은 <span>객관적인 자기분석</span>과</br>
      <span>경기력향상</span>에 도움됩니다.</p>
    </div>
    <!-- S : datepicker-wrap 훈련날짜 -->
    <!-- E : 날짜 받고 데이터 불러오기 ? 신규  -->
    <div class="datepicker-wrap">
      <label for="datetimepicker1">훈련날짜</label>
      <div class='input-group date'>
        <input id="datetimepicker1" type="date" class="form-control" value="<%=datetimepicker1_h %>"/>
        <span class="input-group-addon">
          <span class="glyphicon glyphicon-calendar"></span>
        </span>
      </div>
      <a href="#" class="btn-navy" onClick="DateToday(); return false;">오늘</a>
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
    <div class="navyline-top-list clearfix">
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
        <li id="btn-select-off"  class="off"> <a href="#" onClick="TrainonfBtn(2); return false;">훈련불참</a> </li>
        <!-- 훈련불참 선택시 훈련목표, 공식훈련내용, 훈련평가 x -->
      </ul>
      <!-- S : 훈련참석 > 정상참석, 일부참석 선택시 -->
      <div id="train-div01" class="clearfix">
        <input type="radio" id="train-check01" name="train_check" value="A"  checked /> <label for="train-check01">정상참석</label>
        <input type="radio" id="train-check02" name="train_check" value="B" /> <label for="train-check02">일부참석</label>
        <select id="train-check01-select" name="train-check01-select" class="train-select">
        <option value=0 selected>::부상부위 선택::</option>
          <option value=1>부상중 / 일부참석</option>
          <option value=2>재활(치료)훈련 / 일부참석</option>
          <option value=3>병가(감기,몸살,기타질환) / 일부참석</option>
          <!--여자일때만-->
          <option value=4>생리(통) / 일부참석</option>
          <!--여자일때만-->
        </select>
      </div>
      <!-- E : 훈련참석 > 정상참석, 일부참석 선택시 -->
      <!-- S : 훈련불참 선택시 -->
      <div id="train-div02" class="clearfix">
        <select id="train-check02-select" name="train-check02-select"class="train-select">
           <option value=0 selected>::부상부위 선택::</option>
          <option value=1>부상</option>
          <option value=2>재활(치료)훈련</option>
          <option value=3>병가(감기,몸살,기타질환)</option>
          <!--여자일때만-->
          <option value=4>생리(통)</option>
          <!--여자일때만-->
          <option value=5>무단불참</option>
          <option value=6>기타(가정사유 등)</option>
          <option value=7>수업참석</option>
          <option value=8>휴식</option>
          <option value=9>대회참석(국내)</option>
          <option value=10>대회참석(해외)</option>
        </select>
      </div>
      <!-- E : 훈련불참 선택시 -->
      <a href="#" class="btn-or-pop" data-toggle="modal" data-target="#injury-chk">부상부위 선택<!-- 클릭시 팝업 --></a>
    </div>
    <!-- E : 훈련참석(부상) 체크 -->
    <!-- S : 훈련목표(중복선택가능) -->
    <h2 id="train-goal-title">훈련목표(중복선택가능)</h2>
    <ul id="train-goal-list"class="train-goal-list">
      <li><input type="checkbox" id="train-goal01"name="train-goal-list" /> <label for="train-goal01">체력향상 훈련</label></li>
      <li><input type="checkbox" id="train-goal02"name="train-goal-list" /> <label for="train-goal02">기술향상 훈련</label></li>
      <li><input type="checkbox" id="train-goal03"name="train-goal-list" /> <label for="train-goal03">대회전략 준비 (실전에 필요한 전술훈련 중심)</label></li>
      <li><input type="checkbox" id="train-goal04"name="train-goal-list" /> <label for="train-goal04">컨디션 조절을 위한 훈련</label></li>
      <li><input type="checkbox" id="train-goal05"name="train-goal-list" /> <label for="train-goal05">부상에 의한 재활훈련</label></li>
    </ul>
    <!-- E : 훈련목표(중복선택가능) -->
    <!-- S : 공식훈련 내용 (기본 2개 노출) -->
    <div id="official-train-wrap">

    <div id="official-train-wrap1" class="official-train-wrap">
      <div class="official-train">
        <h2>공식훈련 내용</h2>
        <a href="http://sportsdiary.co.kr/M_Player/Mypage/training.asp" class="icon-fa-cog"><img src="../images/sub/icon-fa-cog.png" alt="훈련종류 항목관리"></a>
        <a href="#" id="official-train-P1" class="btn-navyline">훈련구분 추가 <span class="txt-or">+</span></a>
        <a href="#" class="del-train-btn"><span><i class="fa fa-trash-o" aria-hidden="true"></i></span>훈련삭제</a>
      </div>
      <div class="bg-navy">
        <select id="TFPubCode1">
          <option value="0" >훈련구분을 선택하세요</option>
          <option value="1" >새벽훈련</option>
          <option value="2" >오전훈련</option>
          <option value="3" >오후훈련</option>
          <option value="4" >야간훈련</option>
          <option value="5" >개인훈련</option>
        </select>
      </div>
      <ul class="official-train-select">
        <li>
          <select id="PceCd1" >
            <option value="0" >훈련장소</option>
            <option value="1" >Home (우리 체육관이나 운동장)</option>
            <option value="2" >Away (다른 팀 체육관이나 운동장)</option>
            <option value="3" >외부훈련 (산악/계단/기타훈련 등)</option>
            <option value="4" >국내전지훈련 (숙식을 하며 타지역에서 훈련)</option>
            <option value="5" >해외전지훈련 (숙식을 하며 타지역에서 훈련)</option>
          </select>
        </li>
        <li>
          <select id="TrailHour1">
            <option value="0.0">시간</option>
            <option value="0.5">30분</option>
            <option value="1.0">1시간</option>
            <option value="1.5">1시간 30분</option>
            <option value="2.0">2시간</option>
            <option value="2.5">2시간 30분</option>
            <option value="3.0">3시간</option>
            <option value="3.5">3시간 30분</option>
            <option value="4.0">4시간</option>
          </select>
        </li>
        <li>
          <select id="TraiFistCd1">
            <option value="0" >훈련유형</option>
            <option value="1" >체력훈련</option>
            <option value="2" >도복훈련</option>
          </select>
        </li>
        <li>
          <a href="#" class="btn-gray"  onclick="officialTrainP(1); return false;">훈련종류선택</a>
        </li>
      </ul>
      <!-- S : btn-train-list 선택 완료시 hide -->
      <div class="btn-train-list-wrap">
        <!-- 01 훈련유형 > 체력훈련 -->
        <ul id="TraiFistCd1TraiMidCd1" class="btn-train-list">
        <!--
          <li><a href="#">준비운동</a></li>
          <li><a href="#">스트레칭</a></li>
          <li><a href="#">정리운동</a></li>
          <li><a href="#">몸풀기 게임</a></li>
          <li><a href="#">줄넘기</a></li>
          <li><a href="#">보조운동</a></li>
          <li><a href="#">밧줄/튜브훈련</a></li>
          <li><a href="#">웨이트 트레이닝</a></li>
          <li><a href="#">써키트 트레이닝</a></li>
          <li><a href="#">스피드<span>(50m,70m,100m)</span></a></li> 
          -->
          <!--class="row-2"-->
          <!--
          <li><a href="#">인터벌 트레이닝</a></li>
          <li><a href="#">계단조깅</a></li>
          <li><a href="#">언덕 스피드</a></li>
          <li><a href="#">운동장 조깅</a></li>
          <li><a href="#">왕복달리기</a></li>
          <li><a href="#">운동장 조깅</a></li>
          <li><a href="#">등 짚고 뛰어넘기</a></li>
          <li><a href="#">빠져나가기</a></li>
          <li><a href="#">배밀기</a></li>
          <li><a href="#">토끼뜀</a></li>
          <li><a href="#">2인 1조</a></li>
          -->
          <!-- 2017-01-03 추가 -->
          <!--
          <li><a href="#">산악훈련</a></li>
          -->
          <!--// 2017-01-03 추가 -->
          <!--
          <li><a href="#">재활운동</a></li>
          <li><a href="#">기타</a></li>
          -->
        </ul>
        <!--// 01 훈련유형 > 체력훈련 -->
        <!-- 02 훈련유형 > 도복훈련 -->
        <ul id="TraiFistCd1TraiMidCd2" class="btn-train-list">
        <!--
          <li><a href="#">준비운동</a></li>
          <li><a href="#">스트레칭</a></li>
          <li><a href="#">정리운동</a></li>
          <li><a href="#">굳히기 익히기</a></li>
          <li><a href="#">끌면서 익히기</a></li>
          <li><a href="#">초익히기(스피드)</a></li>
          <li><a href="#">주특기 기술</a></li>
          <li><a href="#">안다리 후리기</a></li>
          <li><a href="#">밭다리 후리기</a></li>
          <li><a href="#">업어치기</a></li>
          <li><a href="#">허벅다리</a></li>
          <li><a href="#">허리후리기</a></li>
          <li><a href="#">잡기싸움</a></li>
          <li><a href="#">굳히기 자유연습</a></li>
          <li><a href="#">메치기 자유연습</a></li>
          <li><a href="#">메치기</a></li>
          <li><a href="#">소와다리</a></li>
          <li><a href="#">기술연구</a></li>
          <li><a href="#">기타</a></li>
          <li><a href="#">&nbsp;</a></li>
          <li><a href="#">&nbsp;</a></li>
          -->
        </ul>
        <!--// 02 훈련유형 > 도복훈련 -->
      </div>
      <div id="MidCdselectOk1" class="btn-center pb1">
        <a href="#" class="btn-or-select">선택완료</a>
      </div>
      <!-- E : btn-train-list 선택 완료시 hide -->
      <!-- S : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
      <ul id="MidCdselect1" class="train-select-list">
        <li><a href="#">준비운동 <span class="btn-del-x">x</span></a></li>
        <li><a href="#">써키트 트레이닝 <span class="btn-del-x">x</span></a></a></li>
        <li><a href="#">몸풀기 게임 <span class="btn-del-x">x</span></a></a></li>
      </ul>
      <!-- E : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
    </div>

    <!-- E : 공식훈련 내용 (기본 2개 노출) -->


    <!-- S : 공식훈련 내용 (기본 2개 노출) -->

    <div id="official-train-wrap2" class="official-train-wrap">
      <div class="official-train">
        <h2>공식훈련 내용</h2>
        <a href="http://sportsdiary.co.kr/M_Player/Mypage/training.asp" class="icon-fa-cog"><img src="../images/sub/icon-fa-cog.png" alt="훈련종류 항목관리"></a>
        <a href="#" class="btn-navyline">훈련구분 추가 <span class="txt-or">+</span></a>
      </div>
      <div class="bg-navy">
        <select id="TFPubCode2">
          <option value=0 >훈련구분을 선택하세요</option>
          <option value=1 >새벽훈련</option>
          <option value=2 >오전훈련</option>
          <option value=3 >오후훈련</option>
          <option value=4 >야간훈련</option>
          <option value=5 >개인훈련</option>
        </select>
      </div>
      <ul class="official-train-select">
        <li>
          <select id="PceCd2" >
            <option value=0 >훈련장소</option>
            <option value=1 >Home (우리 체육관이나 운동장)</option>
            <option value=2 >Away (다른 팀 체육관이나 운동장)</option>
            <option value=3 >외부훈련 (산악/계단/기타훈련 등)</option>
            <option value=4 >국내전지훈련 (숙식을 하며 타지역에서 훈련)</option>
            <option value=5 >해외전지훈련 (숙식을 하며 타지역에서 훈련)</option>
          </select>
        </li>
        <li>
          <select id="TrailHour2">
            <option value="0.0">시간</option>
            <option value="0.5">30분</option>
            <option value="1.0">1시간</option>
            <option value="1.5">1시간 30분</option>
            <option value="2.0">2시간</option>
            <option value="2.5">2시간 30분</option>
            <option value="3.0">3시간</option>
            <option value="3.5">3시간 30분</option>
            <option value="4.0">4시간</option>
          </select>
        </li>
        <li>
          <select id="TraiFistCd2">
            <option value="0" >훈련유형</option>
            <option value="1" >체력훈련</option>
            <option value="2" >도복훈련</option>
          </select>
        </li>
        <li>
          <a href="#" class="btn-gray">훈련종류선택</a>
        </li>
      </ul>
      <!-- S : btn-train-list 선택 완료시 hide 
      <div class="btn-train-list-wrap">
        <!-- 01 훈련유형 > 체력훈련 
        <ul class="btn-train-list">
          <li class="on"><a href="#">준비운동</a></li>
          <li><a href="#">스트레칭</a></li>
          <li><a href="#">정리운동</a></li>
          <li><a href="#">몸풀기 게임</a></li>
          <li><a href="#">줄넘기</a></li>
          <li><a href="#">보조운동</a></li>
          <li><a href="#">밧줄/튜브훈련</a></li>
          <li><a href="#">웨이트 트레이닝</a></li>
          <li><a href="#">써키트 트레이닝</a></li>
          <li class="row-2"><a href="#">스피드<span>(50m,70m,100m)</span></a></li>
          <li><a href="#">인터벌 트레이닝</a></li>
          <li><a href="#">계단조깅</a></li>
          <li><a href="#">언덕 스피드</a></li>
          <li><a href="#">운동장 조깅</a></li>
          <li><a href="#">왕복달리기</a></li>
          <li><a href="#">운동장 조깅</a></li>
          <li><a href="#">등 짚고 뛰어넘기</a></li>
          <li><a href="#">빠져나가기</a></li>
          <li><a href="#">배밀기</a></li>
          <li><a href="#">토끼뜀</a></li>
          <li><a href="#">2인 1조</a></li>
          <!-- 2017-01-03 추가
          <li><a href="#">산악훈련</a></li>
          <!--// 2017-01-03 추가 
          <li><a href="#">재활운동</a></li>
          <li><a href="#">기타</a></li>
        </ul>
        <!--// 01 훈련유형 > 체력훈련 
        <!-- 02 훈련유형 > 도복훈련 
        <ul class="btn-train-list">
          <li class="on"><a href="#">준비운동</a></li>
          <li><a href="#">스트레칭</a></li>
          <li><a href="#">정리운동</a></li>
          <li><a href="#">굳히기 익히기</a></li>
          <li><a href="#">끌면서 익히기</a></li>
          <li><a href="#">초익히기(스피드)</a></li>
          <li><a href="#">주특기 기술</a></li>
          <li><a href="#">안다리 후리기</a></li>
          <li><a href="#">밭다리 후리기</a></li>
          <li><a href="#">업어치기</a></li>
          <li><a href="#">허벅다리</a></li>
          <li><a href="#">허리후리기</a></li>
          <li><a href="#">잡기싸움</a></li>
          <li><a href="#">굳히기 자유연습</a></li>
          <li><a href="#">메치기 자유연습</a></li>
          <li><a href="#">메치기</a></li>
          <li><a href="#">소와다리</a></li>
          <li><a href="#">기술연구</a></li>
          <li><a href="#">기타</a></li>
          <li><a href="#">&nbsp;</a></li>
          <li><a href="#">&nbsp;</a></li>
        </ul>
        <!--// 02 훈련유형 > 도복훈련
      </div>
      <div class="btn-center pb0">
        <a href="#" class="btn-or-select">선택완료</a>
      </div>
      <!-- E : btn-train-list 선택 완료시 hide -->
      <!-- S : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 
      <ul class="train-select-list">
        <li><a href="#">준비운동 <span class="btn-del-x">x</span></a></li>
        <li><a href="#">써키트 트레이닝 <span class="btn-del-x">x</span></a></a></li>
        <li><a href="#">몸풀기 게임 <span class="btn-del-x">x</span></a></a></li>
      </ul>
      <!-- E : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
    </div>
    
    <!-- E : 공식훈련 내용 (기본 2개 노출) -->
    
    <div id="official-train-wrap3" class="official-train-wrap off">

    </div>
    <div id="official-train-wrap4" class="official-train-wrap off">

    </div>
    <div id="official-train-wrap5" class="official-train-wrap off">

    </div>

    </div>
    <!-- S : 개인훈련 내용은 1개만 노출, 추가없음 -->
    <div class="custom-accord">
    <div id="official-train-person" class="official-train-wrap">
      <div class="accord">
        <a href=".individual-train-item" data-toggle="collapse" data-parent=".custom-accord">
          <div class="tit-individual-train">
            <h2 class="clearfix">개인훈련 내용 입력</h2>
            <span class="icon"><span class="caret"></span></span>
          </div>
        </a>
        <!-- S : 처음엔 hide, 버튼 클릭해야 show -->
        <div class="individual-train-item collapse">
          <div class="bg-or">
            <select id ="bg-or-sd017">
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
          <div class="btn-train-list-wrap">
            <!-- 01 훈련유형 > 체력훈련 -->
            <ul class="btn-train-list">
            <!--
              <li class="on"><a href="#">준비운동</a></li>
              <li><a href="#">스트레칭</a></li>
              <li><a href="#">정리운동</a></li>
              <li><a href="#">몸풀기 게임</a></li>
              <li><a href="#">줄넘기</a></li>
              <li><a href="#">보조운동</a></li>
              <li><a href="#">밧줄/튜브훈련</a></li>
              <li><a href="#">웨이트 트레이닝</a></li>
              <li><a href="#">써키트 트레이닝</a></li>
              <li class="row-2"><a href="#">스피드<span>(50m,70m,100m)</span></a></li>
              <li><a href="#">인터벌 트레이닝</a></li>
              <li><a href="#">계단조깅</a></li>
              <li><a href="#">언덕 스피드</a></li>
              <li><a href="#">운동장 조깅</a></li>
              <li><a href="#">왕복달리기</a></li>
              <li><a href="#">운동장 조깅</a></li>
              <li><a href="#">등 짚고 뛰어넘기</a></li>
              <li><a href="#">빠져나가기</a></li>
              <li><a href="#">배밀기</a></li>
              <li><a href="#">토끼뜀</a></li>
              <li><a href="#">2인 1조</a></li>
              <li><a href="#">산악훈련</a></li>
              <li><a href="#">재활운동</a></li>
              <li><a href="#">기타</a></li>
              -->
            </ul>
            <!--// 01 훈련유형 > 체력훈련 -->
            <!-- 02 훈련유형 > 도복훈련 -->
            <ul class="btn-train-list">
            <!--
              <li class="on"><a href="#">준비운동</a></li>
              <li><a href="#">스트레칭</a></li>
              <li><a href="#">정리운동</a></li>
              <li><a href="#">굳히기 익히기</a></li>
              <li><a href="#">끌면서 익히기</a></li>
              <li><a href="#">초익히기(스피드)</a></li>
              <li><a href="#">주특기 기술</a></li>
              <li><a href="#">안다리 후리기</a></li>
              <li><a href="#">밭다리 후리기</a></li>
              <li><a href="#">업어치기</a></li>
              <li><a href="#">허벅다리</a></li>
              <li><a href="#">허리후리기</a></li>
              <li><a href="#">잡기싸움</a></li>
              <li><a href="#">굳히기 자유연습</a></li>
              <li><a href="#">메치기 자유연습</a></li>
              <li><a href="#">메치기</a></li>
              <li><a href="#">소와다리</a></li>
              <li><a href="#">기술연구</a></li>
              <li><a href="#">기타</a></li>
              <li><a href="#">&nbsp;</a></li>
              <li><a href="#">&nbsp;</a></li>
              -->
            </ul>
            <!--// 02 훈련유형 > 도복훈련 -->
          </div>
          <div class="btn-center pb0">
            <a href="#" class="btn-or-select">선택완료</a>
          </div>
          <!-- E : btn-train-list 선택 완료시 hide -->
          <!-- S : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
          <ul id ="train-select-list" class="train-select-list">
            <li><a href="#">준비운동 <span class="btn-del-x">x</span></a></li>
            <li><a href="#">써키트 트레이닝 <span class="btn-del-x">x</span></a></li>
            <li><a href="#">몸풀기 게임 <span class="btn-del-x">x</span></a></li>
          </ul>
          <!-- E : train-select-list 선택완료시 btn-train-list는 닫히고 이 부분은 남아있음 -->
        </div>
        <!-- E : 처음엔 hide, 버튼 클릭해야 show -->
        </div>
      </div>
    </div>
    <!-- E : 개인훈련 내용 1개만 노출, 추가없음 -->
    <!-- S : 훈련평가 -->
    <h2>훈련평가</h2>
    <table id="tranin-question" class="navy-top-table">
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
      </thead>
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
    </table>
    <!-- E : 훈련평가 -->
    <!-- S : 메모리 -->
    <h2>메모리</h2>
    <ul id="memory" class="memory" >
      <li>
        <a href="#" class="sw-char" onClick="memoryChk('memory-txt01',1); return false;"><span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt01"  name ="memory-txt" value="1"><label for="memory-txt01">잘된점</label></a>
        <p><textarea id="AdtWell" placeholder="잘된점을 입력하세요"></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char" onClick="memoryChk('memory-txt02',2); return false;" ><span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt02"  name ="memory-txt" value="2" ><label for="memory-txt02">보완점</label></a>
        <p><textarea id="AdtNotWell" placeholder="보완점을 입력하세요."></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char"  onclick="memoryChk('memory-txt03',3); return false;"><span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt03"  name ="memory-txt"  value="3"><label for="memory-txt03">나의일기</label></a>
        <p><textarea id="AdtMyDiay" placeholder="나만의 일기를 작성해 보세요. (비공개)"></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char"  onclick="memoryChk('memory-txt04',4); return false;"><span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt04"  name ="memory-txt"  value="4"><label for="memory-txt04">지도자상담</label></a>
        <p><textarea id="AdtAdvice" placeholder="코치님 또는 감독님에게 하고 싶은 말을 입력하세요."></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char"  onclick="memoryChk('memory-txt05',5); return false;"><span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt05"  name ="memory-txt" value="5" ><label for="memory-txt05">지도자답변</label></a>
        <p><textarea id="AdtAdviceRe"></textarea></p>
      </li>
    </ul>
    <!-- E : 메모리 -->
    <div class="container">
      <a href="#" class="btn-full" onClick="SaveData1(); return false;">기록 저장</a>
    </div>
  </div>
  <!-- E : sub -->
  <!-- S: 경기상세입력 누락 알림 modal -->
  <div class="modal fade ipt-injury" id="injury-chk" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header"><h4>부상부위</h4><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button></div> 
        <div class="modal-body">
          <ul class="tab-menu type3">
            <li class="on"><a href="#">부상부위(앞)</a></li>
            <li><a href="#">부상부위(뒤)</a></li>
          </ul>
          <div class="tabc">
            <div class="dist-cont">
              <!-- <img src="../images/stats/injury-front.jpg" alt="부상부위 이미지 앞" /> -->
                <table class="table_01" border="0" style="font-size:12px; background-image: url(../images/stats/injury/f_bg.png);" cellpadding="0" cellspacing="0">
              <tbody>
                <tr>
                  <td align="right">
                    <table class="left_label" border="0" cellspacing="0" cellpadding="0">
                      <tbody>
                        <tr>
                          <td height="52" style="text-align:right;vertical-align: text-top;">
                            <label style="font-size:12px">
                            <input type="checkbox" name="InjuryArea" id="InjuryArea1" value="sd003001"><!-- <span id="Injury_sd003001" style="color: rgb(255, 255, 255); background-color: rgb(240, 91, 85); padding: 5px;">(우)쇄골(1)(1%)</span> -->
                            <span>(우)쇄골</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:right;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea3" value="sd003003"><!-- <span id="Injury_sd003003" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)어깨(0)</span> -->
                            <span>(우)어깨</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:right;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea5" value="sd003005"><!-- <span id="Injury_sd003005" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)늑골(0)</span> -->
                            <span>(우)늑골</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:right;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea7" value="sd003007"><!-- <span id="Injury_sd003007" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)고관절(0)</span> -->
                            <span>(우)고관절</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:right;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea9" value="sd003009"><!-- <span id="Injury_sd003009" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)앞허벅지(0)</span> -->
                            <span>(우)앞허벅지</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:right;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea11" value="sd003011" ><!-- <span id="Injury_sd003011" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)무릎(0)</span> -->
                            <span>(우)무릎</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:right;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea13" value="sd003013"><!-- <span id="Injury_sd003013" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)정강이(0)</span> -->
                            <span>(우)정강이</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:right;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea15" value="sd003015"><!-- <span id="Injury_sd003015" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)발목(0)</span> -->
                            <span>(우)발목</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="28" style="text-align:right;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea17" value="sd003017"><!-- <span id="Injury_sd003017" style="color: rgb(240, 91, 85); background-color: rgb(255, 255, 255); padding: 1px;">(우)발/발가락(5)(5%)</span> -->
                            <span>(우)발/발가락</span>
                            </label>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                  <td colspan="3" align="center">
                    <table class="body-img" border="0" cellspacing="0" cellpadding="0">
                      <tbody>
                        <tr style="height:138px">
                          <td style="width:51px">
                            <img src="../images/stats/injury/f_01.png" id="tbody_sd003003" style="display:none" width="51" height="138">
                          </td>
                          <td style="width:27px">
                            <img src="../images/stats/injury/f_02.png" id="tbody_sd003001" style="display: none;" width="27" height="138">
                          </td>
                          <td style="width:28px">
                            <img src="../images/stats/injury/f_03.png" id="tbody_sd003002" style="display:none" width="28" height="138">
                          </td>
                          <td style="width:49px">
                            <img src="../images/stats/injury/f_04.png" id="tbody_sd003004" style="display:none" width="49" height="138">
                          </td>
                        </tr>
                        <tr style="height:60px">
                          <td colspan="2" style="width:78px">
                            <img src="../images/stats/injury/f_05.png" style="display:none" id="tbody_sd003005" width="78" height="60">
                          </td>
                          <td colspan="2" style="width:77px">
                            <img src="../images/stats/injury/f_06.png" style="display: none;" id="tbody_sd003006" width="77" height="60">
                          </td>
                        </tr>
                        <tr style="height:53px">
                          <td colspan="2">
                            <img src="../images/stats/injury/f_07.png" id="tbody_sd003007" style="display:none" width="78" height="53">
                          </td>
                          <td colspan="2">
                            <img src="../images/stats/injury/f_08.png" id="tbody_sd003008" style="display:none" width="77" height="53">
                          </td>
                        </tr>
                        <tr style="height:52px">
                          <td colspan="2">
                            <img src="../images/stats/injury/f_09.png" id="tbody_sd003009" style="display:none" width="78" height="52">
                          </td>
                          <td colspan="2">
                            <img src="../images/stats/injury/f_10.png" id="tbody_sd003010" style="display:none" width="77" height="52">
                          </td>
                        </tr>
                        <tr style="height:41px">
                          <td colspan="2">
                            <img src="../images/stats/injury/f_11.png" id="tbody_sd003011" style="display:none" width="78" height="41">
                          </td>
                          <td colspan="2">
                            <img src="../images/stats/injury/f_12.png" id="tbody_sd003012" style="display:none" width="77" height="41">
                          </td>
                        </tr>
                        <tr style="height:35px">
                          <td colspan="2">
                            <img src="../images/stats/injury/f_13.png" id="tbody_sd003013" style="display:none" width="78" height="35">
                          </td>
                          <td colspan="2">
                            <img src="../images/stats/injury/f_14.png" id="tbody_sd003014" style="display:none" width="77" height="35">
                          </td>
                        </tr>
                        <tr style="height:32px">
                          <td colspan="2">
                            <img src="../images/stats/injury/f_15.png" id="tbody_sd003015" style="display:none" width="78" height="32">
                          </td>
                          <td colspan="2">
                            <img src="../images/stats/injury/f_16.png" id="tbody_sd003016" style="display:none" width="77" height="32">
                          </td>
                        </tr>
                        <tr style="height:32px">
                          <td colspan="2">
                            <img src="../images/stats/injury/f_17.png" id="tbody_sd003017" style="display: none;" width="78" height="32">
                          </td>
                          <td colspan="2">
                            <img src="../images/stats/injury/f_18.png" id="tbody_sd003018" style="display:none" width="77" height="32">
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                  <td>
                    <table class="left_label" border="0" cellspacing="0" cellpadding="0">
                      <tbody>
                        <tr>
                          <td height="52" style="text-align:left;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea2" value="sd003002"><!-- <span id="Injury_sd003002" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)쇄골(0)</span> -->
                            <span>(좌)쇄골</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:left;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea4" value="sd003004"><!-- <span id="Injury_sd003004" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)어깨(0)</span> -->
                            <span>(좌)어깨</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:left;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea6" value="sd003006"><!-- <span id="Injury_sd003006" style="color: rgb(240, 91, 85); background-color: rgb(255, 255, 255); padding: 1px;">(좌)늑골(1)(1%)</span> -->
                            <span>(좌)늑골</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:left;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea8" value="sd003008"><!-- <span id="Injury_sd003008" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)고관절(0)</span> -->
                            <span>(좌)고관절</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:left;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea8" value="sd003010"><!-- <span id="Injury_sd003010" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)앞허벅지(0)</span> -->
                            <span>(좌)앞허벅지</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:left;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea12" value="sd003012"><!-- <span id="Injury_sd003012" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)무릎(0)</span> -->
                            <span>(좌)무릎</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:left;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea14" value="sd003014"><!-- <span id="Injury_sd003014" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)정강이(0)</span> -->
                            <span>(좌)정강이</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="52" style="text-align:left;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea16" value="sd003016"><!-- <span id="Injury_sd003016" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)발목(0)</span> -->
                            <span>(좌)발목</span>
                            </label>
                          </td>
                        </tr>
                        <tr>
                          <td height="28" style="text-align:left;vertical-align: text-top;">
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea18" value="sd003018"><!-- <span id="Injury_sd003018" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)발/발가락(0)</span> -->
                            <span>(좌)발/발가락</span>
                            </label>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </td>
                </tr>
              </tbody>
            </table>
            </div>
          </div>
          <div class="tabc" style="display:none">
            <div class="dist-cont">
              <!-- <img src="../images/stats/injury-back.jpg" alt="부상부위 이미지 뒤" /> -->
              <table class="table_02" border="0" style="font-size:12px; background-image: url(../images/stats/injury/b_bg.png)" cellpadding="0" cellspacing="0">
                <tbody>
                  <tr>
                    <td align="right">
                      <table class="left_label" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                          <tr>
                            <td height="52" style="text-align:right;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea19" value="sd003019"><!-- <span id="Injury_sd003019" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">목(0)</span> -->
                              <span>목</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:right;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" class="folding" id="InjuryArea21" value="sd003021"><!-- <span id="Injury_sd003021" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">등(0)</span> -->
                              <!-- main.js에서 text와 연결 됩니다. -->
                              <span>등</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:right;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea23" value="sd003023"><!-- <span id="Injury_sd003023" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)팔꿈치(0)</span> -->
                              <span>(좌)팔꿈치</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:right;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea25" value="sd003025"><!-- <span id="Injury_sd003025" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)손목(0)</span> -->
                              <span>(좌)손목</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:right;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea27" value="sd003027"><!-- <span id="Injury_sd003027" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)손/손가락(0)</span> -->
                              <span>(좌)손/손가락</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:right;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea29" value="sd003029"><!-- <span id="Injury_sd003029" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)뒤허벅지(0)</span> -->
                              <span>(좌)뒤허벅지</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:right;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea31" value="sd003031"><!-- <span id="Injury_sd003031" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)종아리(0)</span> -->
                              <span>(좌)종아리</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:right;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea33" value="sd003033"><!-- <span id="Injury_sd003033" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)아킬레스(0)</span> -->
                              <span>(좌)아킬레스</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="28" style="text-align:right;"></td>
                          </tr>
                        </tbody>
                      </table>
                    </td>
                    <td colspan="3" align="center" class="body-img">
                      <table width="155" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                          <tr style="height:88px">
                            <td colspan="3" style="width:155px">
                              <img src="../images/stats/injury/b_01.png" id="tbody_sd003019" style="display:none" width="155" height="88">
                            </td>
                          </tr>
                          <tr style="height:99px;width:155px">
                            <td style="width:43px">
                              <img src="../images/stats/injury/b_02.png" id="tbody_sd003023" style="display:none" width="43" height="99">
                            </td>

                            <td id="ttd_sd003021" class="folding-td">
                              <img src="../images/stats/injury/b_03_1.png" id="tbody_sd003021" style="position: relative; left: 10px; display:none; width: 70px;" width="70" height="99">
                            </td>
                            <td id="ttd_sd003020" class="folding-td">
                              <img src="../images/stats/injury/b_03.png" id="tbody_sd003020" style="display:none; width: 70px; position: relative; left: 12px; " width="70" height="99">
                            </td>
                            <td id="ttd_sd00302021">
                              <img src="../images/stats/injury/b_03_all.png" id="tbody_sd00302021" style="display:none" width="70" height="99">
                            </td>

                            <td style="width: 42px;">
                              <img src="../images/stats/injury/b_04.png" id="tbody_sd003024" style="display:none; width: 42px;" width="42" height="99">
                            </td>
                          </tr>
                          <tr style="height:52px">
                            <td>
                              <img src="../images/stats/injury/b_05.png" id="tbody_sd003025" style="display:none" width="43" height="52">
                            </td>
                            <td style="width: 70px;">
                              <img src="../images/stats/injury/b_06.png" id="tbody_sd003022" style="display:none; width: 70px;" width="70" height="52">
                            </td>
                            <td style="width: 42px;">
                              <img src="../images/stats/injury/b_07.png" id="tbody_sd003026" style="display:none;width: 42px;" width="42" height="52">
                            </td>
                          </tr>
                          <tr>
                            <td colspan="3">
                              <table width="155" border="0" cellspacing="0" cellpadding="0">
                                <tbody>
                                  <tr style="height:28px">
                                    <td style="width:79px">
                                      <img src="../images/stats/injury/b_08.png" id="tbody_sd003027" style="display:none" width="79" height="28">
                                    </td>
                                    <td style="width:76px">
                                      <img src="../images/stats/injury/b_09.png" id="tbody_sd003028" style="display:none" width="76" height="28">
                                    </td>
                                  </tr>
                                  <tr style="height:49px">
                                    <td>
                                      <img src="../images/stats/injury/b_10.png" id="tbody_sd003029" style="display:none" width="79" height="49">
                                    </td>
                                    <td>
                                      <img src="../images/stats/injury/b_11.png" id="tbody_sd003030" style="display:none" width="76" height="49">
                                    </td>
                                  </tr>
                                  <tr style="height:63px">
                                    <td>
                                      <img src="../images/stats/injury/b_12.png" id="tbody_sd003031" style="display:none" width="79" height="63">
                                    </td>
                                    <td>
                                      <img src="../images/stats/injury/b_13.png" id="tbody_sd003032" style="display:none" width="76" height="63">
                                    </td>
                                  </tr>
                                  <tr style="height:64px">
                                    <td>
                                      <img src="../images/stats/injury/b_14.png" id="tbody_sd003033" style="display:none" width="79" height="64">
                                    </td>
                                    <td>
                                      <img src="../images/stats/injury/b_15.png" id="tbody_sd003034" style="display:none" width="76" height="64">
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </td>
                    <td>
                      <table class="right_label" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                          <tr>
                            <td height="52" style="text-align:left;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" class="folding" id="InjuryArea20" value="sd003020"><!-- <span id="Injury_sd003020" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">척추(0)</span> -->
                              <!-- main.js에서 text와 연결 됩니다. -->
                              <span>척추</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:left;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" class="folding" id="InjuryArea22" value="sd003022"><!-- <span id="Injury_sd003022" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">허리(0)</span> -->
                              <!-- main.js에서 text와 연결 됩니다. -->
                              <span>허리</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:left;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea24" value="sd003024"><!-- <span id="Injury_sd003024" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)팔꿈치(0)</span> -->
                              <span>팔꿈치</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:left;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea26" value="sd003026"><!-- <span id="Injury_sd003026" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)손목(0)</span>
                              </label> -->
                              <span>(우)손목</span>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:left;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea28" value="sd003028"><!-- <span id="Injury_sd003028" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)손/손가락(0)</span> -->
                              <span>(우)손/손가락</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:left;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea30" value="sd003030"><!-- <span id="Injury_sd003030" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)뒤허벅지(0)</span> -->
                              <span>(우)뒤허벅지</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:left;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea32" value="sd003032"><!-- <span id="Injury_sd003032" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)종아리(0)</span> -->
                              <span>(우)종아리</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="52" style="text-align:left;vertical-align: text-top;">
                              <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea34" value="sd003034"><!-- <span id="Injury_sd003034" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(우)아킬레스(0)</span> -->
                              <span>(우)아킬레스</span>
                              </label>
                            </td>
                          </tr>
                          <tr>
                            <td height="28" style="text-align:left;"></td>
                          </tr>
                        </tbody>
                      </table>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <!-- S: modal-footer -->
        <div class="modal-footer">
          <div class="btn-list">
            <a href="#" class="btn btn-cancel" data-dismiss="modal">취소</a>
            <a href="#" class="btn btn-save" data-dismiss="modal">저장</a>
          </div>
        </div>
        <!-- E: modal-footer -->
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
  <script>
   $(window).on('load', $('.rotate-caret'), function(){
     $('.rotate-caret').collapseTgOn('.rotate-caret');
   });
  </script>
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
