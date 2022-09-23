<!-- #include file="../Library/header.bike.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->

  <style>
  /* 참가신청내역(대회히스토리)  */
  .reqHistory .payResult{background:#005895 url('http://img.sportsdiary.co.kr/images/SD/img/bike_apply_list_bg_@3x.png') no-repeat center/100% auto; text-align:center;overflow:hidden;}
  .reqHistory .payResult__title{margin-top:16px;font-size:12px;color:#68ABDA;letter-spacing:-0.02em;line-height:22px;}
  .reqHistory .payResult__totalCount{font-size:30px;color:#fff;font-weight:500;letter-spacing:-0.02em;line-height:32px;}
  .reqHistory .payResult__totalText{position:relative;top:-2px;font-size:22px;color:#fff;font-weight:500;letter-spacing:-0.02em;line-height:32px;}
  .reqHistory .payResult__item{width:60px;height:60px;border-radius:20px;border:2px solid #6CA0C4;}
  .reqHistory .payResult__itemCount{margin-top:9px;margin-bottom:9px;display:block;font-size:22px;color:#fff;letter-spacing:-0.02em;line-height:1;}
  .reqHistory .payResult__itemText{font-size:12px;color:#68ABDA; letter-spacing:-0.02em;line-height:1;font-weight:300;}

  .reqHistory .payResult__list{margin-top:4px;font-size:0;margin-bottom:16px;}
  .reqHistory .payResult__item{display:inline-block;}
  .reqHistory .payResult__item+.payResult__item{margin-left:10px;}

  .reqHistory .competitionDate{height:40px;text-indent:20px;line-height:40px;font-size:16px;font-weight:500;color:#666666;background-color:#F2F2F2;}
  .reqHistory .competitionList{}
  .reqHistory .competitionList__item{padding:20px 10px;background-color:#fff;}
  .reqHistory .competitionList__item+.competitionList__item{border-top:1px solid #f2f2f2;}
  .reqHistory .competitionList__item>p:nth-of-type(1){font-size:16px;font-weight:500;letter-spacing:-0.02em;line-height:22px;color:#666666;}
  .reqHistory .competitionList__item>p:nth-of-type(2){margin-top:7px;font-size:14px;letter-spacing:-0.02em;line-height:22px;color:#AAAAAA;}
  .reqHistory .competitionList__item>p:nth-of-type(2)>span:nth-of-type(1){display:inline-block;height:20px;padding:0 16px;margin-right:10px;background-color:#005895;color:#fff;border-radius:10px;text-align:center;line-height:19px;}
  .reqHistory .competitionList__item>p:nth-of-type(2)>span:nth-of-type(1).s_end{background-color:#aaa;color:#fff;}
  </style>
</head>
<body>

<div id="app" class="l reqHistory m_bg_f2f2f2">

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file = '../include/header_back.asp' -->
      <h1 class="m_header__tit">참가신청내역</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">

    <!-- <div class="payResult">
      <p class="payResult__title">전체신청내역</p>
      <p>
        <span class="payResult__totalCount">1</span> <span class="payResult__totalText">건</span>
      </p>
      <ul class="payResult__list">
        <li class="payResult__item">
          <span class="payResult__itemCount">1</span>
          <span class="payResult__itemText">대기</span>
        </li>
        <li class="payResult__item">
          <span class="payResult__itemCount">0</span>
          <span class="payResult__itemText">확정</span>
        </li>
        <li class="payResult__item">
          <span class="payResult__itemCount">0</span>
          <span class="payResult__itemText">취소</span>
        </li>
      </ul>
    </div> -->

    <p class="competitionDate">2019.04</p>
    <div class="competitionList">
      <a class="competitionList__item">
        <p>[생활체육] 제2회 스포츠 다이어리 랭킹 리그전</p>
        <p><span>D-30</span><span>18.118.17~18.11.17</span></p>
      </a>

      <a class="competitionList__item">
        <p>[생활체육] 제2회 스포츠 다이어리 랭킹 리그전</p>
        <p><span class="s_end">D-종료</span><span>18.118.17~18.11.17</span></p>
      </a>
    </div>

    <!-- <div class="m_bottomBtns">
      <button class="m_bottomBtns__btn s_more">더보기</button>
    </div> -->

  </div>
</div>

<script>
  var vm = new Vue({
    el: '#app',
    data: {

    },
    created (){

      var data = {
        "reqTitleList": [
          {
            "titleIdx": 1,
            "title": "111",
            "place": "경북",
            "startDate": "2019-04-04",
            "endDate": "2019-04-25",
            "busStatus": "Y",
            "applyStart": "2019-04-02",
            "applyEnd": "2019-04-22",
          },
          {
            "titleIdx": 2,
            "title": "23423",
            "place": "대전",
            "startDate": "2019-03-04",
            "endDate": "2019-03-25",
            "busStatus": "N",
            "applyStart": "2019-03-02",
            "applyEnd": "2019-03-22",
          }
        ]
      }


    }
  })
</script>

</body>
</html>
<!-- #include file="../Library/sub_config.asp" -->