<!-- #include virtual = "/pub/header.swim.asp" -->

<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->

<link href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.min.js"></script>

<title>KATA Tennis 대회 참가신청</title>
<body class="lack_bg" id="AppBody">
<!-- #include file = "./include/header.asp" -->

<button id="" class="green_btn" data-toggle="modal" data-target="#myModal_level">modal</button>
<button id="" class="green_btn" data-toggle="modal" data-target="#myModal_level2">modal2</button>


<!--  !@# 1star -->
<div class="modal fade l_modalLevel" id="myModal_level" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <div class="levelHeader">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">×</span> </button>
          <h2 class="levelHeaderTit">테니스 레벨 NTRP 선택</h2>
          <p class="levelHeaderTxt">
            <span>
              ＊본인에 해당하는 항목에 체크해주시기 바랍니다.<span class="emphasis">(중복선택불가)</span><br />
              ＊선택항목은 참가신청기간 중 수정/변경이 가능합니다.
            </span>
          </p>
        </div>
      </div>

      <div class="modal-body">
        <div class="m_levelTbl">
          <h3 class="m_levelTbl__cap s_1star">★ 1STAR</h3>
          <table>
            <thead>
              <tr class="m_level__tr">
                <th class="m_level__td"> 등급 </th>
                <th colspan="2" class="m_level__col"> 내용 </th>
                <th class="m_level__col"> 체크 </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="s_level"> 1.0 </td>
                <td colspan="2" class="s_content"> 테니스를 막 시작한 단계. </td>
                <td rowspan="1" class="s_check">
                  <label class="m_levelTbl__lableCheck">
                    <input type="radio" name="a" class="m_levelTbl__check" hidden /><span></span>
                  </label>
                </td>
              </tr>
              <tr>
                <td class="s_level"> 1.5 </td>
                <td colspan="2" class="s_content"> 경험이 부족하고 공을 넘기기 급급함. </td>
                <td rowspan="1" class="s_check">
                  <label class="m_levelTbl__lableCheck">
                    <input type="radio" name="a" class="m_levelTbl__check" hidden /><span></span>
                  </label>
                </td>
              </tr>
              <tr>
                <td rowspan="5" class="s_level"> 2.0 </td>
                <td class="s_category"> 포핸드 </td>
                <td class="s_content"> 완벽하지 않은 스윙, 방향 조절이 어렵다. </td>
                <td rowspan="5" class="s_check">
                  <label class="m_levelTbl__lableCheck">
                    <input type="radio" name="a" class="m_levelTbl__check" hidden /><span></span>
                  </label>
                </td>
              </tr>
              <tr>
                <td class="s_category"> 백핸드 </td>
                <td class="s_content"> 백핸드를 기피. 제대로 맞추지 못함. 그립문제가 생김. 완벽한 스윙불가. </td>
              </tr>
              <tr>
                <td class="s_category"> 서브/리턴 </td>
                <td class="s_content"> 완벽하지 못한 서브동작. 빈번한 더블폴트. 일정하지 못한 토스. 서브리턴시 잦은 실수. </td>
              </tr>
              <tr>
                <td class="s_category"> 발리 </td>
                <td class="s_content"> 네트플레이를 꺼림. 백발리를 기피함. 풋워크가 제대로 안됨. </td>
              </tr>
              <tr>
                <td class="s_category"> 경기타입 </td>
                <td class="s_content"> 단식, 복식의 기본 위치에는 익숙하지만 자주 정위치에서 벗어남. </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="m_btnWrap">
          <a class="m_btnWrap__btn s_confirm" >확인</a>
        </div>
      </div>





    </div>
  </div>
</div>

<!--  !@# 2star -->
<div class="modal fade l_modalLevel" id="myModal_level2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
  <div class="modal-dialog">
    <div class="modal-content">

      <div class="modal-header">
        <div class="levelHeader">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">닫기</button>
          <h2 class="levelHeaderTit">테니스 레벨 NTRP 선택</h2>
          <p class="levelHeaderTxt">
            <span class="levelHeaderTxtInner">
              ＊본인에 해당하는 항목에 체크해주시기 바랍니다.<span class="emphasis">(중복선택불가)</span><br />
              ＊선택항목은 참가신청기간 중 수정/변경이 가능합니다.
            </span>
          </p>
        </div>
      </div>

      <div class="modal-body">
        <div class="m_levelTbl">
          <h3 class="m_levelTbl__cap s_2star">★★ 2STAR</h3>
          <table>
            <thead>
              <tr class="m_level__tr">
                <th class="m_level__td"> 등급 </th>
                <th colspan="2" clas s="m_level__col"> 내용 </th>
                <th class="m_level__col"> 체크 </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td rowspan="6" class="s_level"> 2.5 </td>
                <td class="s_category"> 포핸드 </td>
                <td class="s_content"> 자세가 잡혀가는 단계. </td>
                <td rowspan="6" class="s_check">
                  <label class="m_levelTbl__lableCheck">
                    <input type="radio" name="a" class="m_levelTbl__check" hidden /><span></span>
                  </label>
                </td>
              </tr>
              <tr>
                <td class="s_category"> 백핸드 </td>
                <td class="s_content"> 그립과 준비동작에 문제가 있고, 백핸드 쪽으로 온 볼을 포핸드로 돌아서서 치려고 함. </td>
              </tr>
              <tr>
                <td class="s_category"> 서브/리턴 </td>
                <td class="s_content"> 풀스윙을 시도하고, 느린속도의 서브를 넣을 수 있지만 토스가 불일정함. 느린서브는 제대로 리턴 불가.</td>
              </tr>
              <tr>
                <td class="s_category"> 발리 </td>
                <td class="s_content"> 네트플레이가 익숙하지 못함. 특히 백핸드는 더욱 익숙하지 못함. 종종 포핸드 면으로 백발리를 시도함. </td>
              </tr>
              <tr>
                <td class="s_category"> 경기타입 </td>
                <td class="s_content"> 느린 공의 짧은 랠리는 가능. 코트의 수비 범위가 좁고 복식을 할 때 처음 위치에서 움직이지 않음. </td>
              </tr>
              <tr>
                <td class="s_category"> 고급기술 </td>
                <td class="s_content"> 의도적으로 로브를 띄울 수 있으나 정확성이 부족함. 스매싱은 볼을 맞출 수 있는 수준임. </td>
              </tr>
              <tr>
                <td rowspan="5" class="s_level"> 3.0 </td>
                <td class="s_category"> 포핸드 </td>
                <td class="s_content"> 의도하는 방향으로 어느 정도 공을 보낼 수는 있으나, 깊이 조절 능력이 부족함. </td>
                <td rowspan="5" class="s_check">
                  <label class="m_levelTbl__lableCheck">
                    <input type="radio" name="a" class="m_levelTbl__check" hidden /><span></span>
                  </label>
                </td>
              </tr>
              <tr>
                <td class="s_category"> 백핸드 </td>
                <td class="s_content"> 준비동작이 제대로 됨. 평범한 속도의 공에 대하여 어느 정도 꾸준히 칠 수 있음. </td>
              </tr>
              <tr>
                <td class="s_category"> 서브/리턴 </td>
                <td class="s_content"> 서브의 리듬에 대해서 터득하기 시작함. 볼의 스피드를 줄 경우 실수가 종종 발생함. 리턴을 꾸준히 잘함.</td>
              </tr>
              <tr>
                <td class="s_category"> 발리 </td>
                <td class="s_content"> 포발리는 안정적이지만 백발리는 아직 실수가 많음. 낮거나 옆으로 빠지는 공에 대해 대처를 못함. </td>
              </tr>
              <tr>
                <td class="s_category"> 경기타입 </td>
                <td class="s_content"> 평범한 속도의 공은 꾸준히 랠리를 할 수 있음. 파트너와 각각 전위, 후위의 형태로 운영을 하되 후위에서 네트로 대쉬할 때 제대로 실행을 못함. </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="m_btnWrap">
          <a class="m_btnWrap__btn s_confirm" >확인</a>
        </div>
      </div>




    </div>
  </div>
</div>


<!-- E: main -->
<!--#include file = "./include/mfoot.asp" -->
