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
' http://sportsdiary.co.kr/M_Player/Train/train_test.asp    
%>

<script  type="text/javascript" src="../js/Train_test.js"></script>
<script  type="text/javascript" src="../js/Train_save.js"></script>
<script type="text/javascript">
    document.cookie = "SearchDate=<%=TrRerdDate %>; path=/;";
    //history.pushState(0, null, location.href);
//    $(window).bind("pageshow", function (event) {
//        console.log("pageshow");
//        if (event.originalEvent.persisted) {
//            document.location.reload();

//            
//        }
//    });

//    $(window).onpageshow = function (event) {
//        console.log("onpageshow");
//        history.pushState(0, null, location.href);
//        if (event.persisted) {
//            document.location.reload();
//        }
//    };
     
</script>

 <style>
  .option_sel { color: red;}
</style>
<body>

<form name="frm" id="frmSave" method="post">
    <input type="hidden" name="F1_Trdate" id="F1_Trdate" >
    <input type="hidden" name="F1_Mentcd" id="F1_Mentcd" >
    <input type="hidden" name="F1_Adtfistcd" id="F1_Adtfistcd" >
    <input type="hidden" name="F1_AdtIntp" id="F1_AdtIntp" >
    <input type="hidden" name="F1_AdtMidcd" id="F1_AdtMidcd" >
    <input type="hidden" name="F1_AdtInjury" id="F1_AdtInjury" >
    <input type="hidden" name="F1_Goallist" id="F1_Goallist" >
    <input type="hidden" name="F1_Officialtrain1" id="F1_Officialtrain1" >
    <input type="hidden" name="F1_Officialtrain2" id="F1_Officialtrain2" >
    <input type="hidden" name="F1_Officialtrain3" id="F1_Officialtrain3" >
    <input type="hidden" name="F1_Officialtrain4" id="F1_Officialtrain4" >
    <input type="hidden" name="F1_Officialtrain5" id="F1_Officialtrain5" >
    <input type="hidden" name="F1_Questionlist" id="F1_Questionlist" >
    <input type="hidden" name="F1_AdtWell"id="F1_AdtWell">
    <input type="hidden" name="F1_AdtNotWell"id="F1_AdtNotWell">
    <input type="hidden" name="F1_AdtMyDiay"id="F1_AdtMyDiay">
    <input type="hidden" name="F1_AdtAdvice"id="F1_AdtAdvice">
</form>
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
  <iframe id="iframe"  width="0" height="0" ></iframe>
  <div class="sub train strength" id="trainBody">
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
               <!-- <li>공식일정 불참: 공식일정 사유로 훈련에 참여하지 못했을 경우</li>-->
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
     
        </select>
      </div>
      <!-- E : 훈련참석 > 정상참석, 일부참석 선택시 -->
      <!-- S : 훈련불참 선택시 -->
      <div id="train-div02" class="clearfix">
        <select id="train-check02-select" name="train-check02-select"class="train-select">
       
        </select>
      </div>
      <!-- E : 훈련불참 선택시 -->
      <a href="#injury-chk" class="btn-or-pop" data-toggle="modal" data-target="#injury-chk">부상부위 선택<!-- 클릭시 팝업 --></a>
    </div>
    <!-- E : 훈련참석(부상) 체크 -->
    <!-- S : 훈련목표(중복선택가능) -->
    <h2 id="train-goal-title">훈련목표(중복선택가능)</h2>
    <ul id="train-goal-list"class="train-goal-list">

    </ul>
    <!-- E : 훈련목표(중복선택가능) -->
    <!-- S: 공식훈련 내용 제목 -->
    <div class="public-train-tit">
     <h2>공식훈련 내용 입력</h2>
     <!-- S: add-train-wrap -->
      <div class="add-train-wrap clearfix">
        <p>훈련별 내용을 작성하세요.</p>
        <a id="official-train-cog1"  class="icon-fa-cog">훈련종류 항목관리 <img src="../images/sub/icon-fa-cog.png" alt></a>
      </div>
     <!-- E: add-train-wrap -->
    </div>
    <!-- E: 공식훈련 내용 제목 -->
    <!-- S : 공식훈련 내용 (기본 2개 노출) -->
    <div id="official-train-wrap">

    <div id="official-train-wrap1" class="official-train-wrap">
    
    </div>

    <!-- E : 공식훈련 내용 (기본 2개 노출) -->


    <!-- S : 공식훈련 내용 (기본 2개 노출) -->

    <div id="official-train-wrap2" class="official-train-wrap">
     
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

      </div>
    </div>
    <!-- E : 개인훈련 내용 1개만 노출, 추가없음 -->
    <!-- S : 훈련평가 -->
    <h2>훈련평가</h2>
    <table id="tranin-question" class="navy-top-table">

    </table>
    <!-- E : 훈련평가 -->
    <!-- S : 메모리 -->
    <h2>메모리</h2>
    <ul id="memory" class="memory" >
      
    </ul>
    <!-- E : 메모리 -->
    <div class="container">
      <a class="btn-full btnSaveTrai" onClick="SaveData1(); return false;">기록 저장</a>
    </div>
  </div>
  <!-- E : sub -->
  <!-- S: 경기상세입력 누락 알림 modal -->
  <div class="modal fade ipt-injury" id="injury-chk" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header"><h4>부상부위</h4>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div> 
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
                            <label style="font-size:12px"><input type="checkbox" name="InjuryArea" id="InjuryArea10" value="sd003010"><!-- <span id="Injury_sd003010" style="color: rgb(170, 170, 170); background-color: rgb(255, 255, 255); padding: 1px;">(좌)앞허벅지(0)</span> -->
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

  <!-- S: warn-back 뒤로가기 주의 안내 -->
  <!-- #include file="../include/warn_back.asp" -->
  <!-- E: warn-back 뒤로가기 주의 안내 -->
  
</body>
