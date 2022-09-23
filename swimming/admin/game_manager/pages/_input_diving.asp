<!DOCTYPE html>
<html lang="ko" dir="ltr">

<head>
   <!--#include virtual="/game_manager/include/head.asp"-->
   <script defer src="/game_manager/js/pages/input_diving.js<%=P_INPUT_DIVING_VER%>"></script>
   <script>
      const g_page_props = {};
   </script>
</head>

<body>
   <!--#include virtual="/game_manager/include/body_before.asp"-->
   <div class="l_wrap">
      <object class="l_wrap__bg-wave" type="image/svg+xml" data="/game_manager/images/bg_wave.svg">
      </object>
      <!-- s: 헤더 영역 -->
      <!--#include virtual="/game_manager/include/header.asp"-->
      <!-- E: 헤더 영역 -->
      <!-- S: 메인 영역 -->
      <main id="app" class="l_main" v-clock>
         <header class="m_header">
            <h2 class="m_header__title"><span :class="'m_match-type t_'+STRMAP_CDC_CODE[Number(header_info.cdc)]">{{STRMAP_CDCICON[header_info.cdcicon]}}</span>{{header_info.cdcnm}} / {{header_info.cdbnm}}</h2>
            <span class="m_header__text">{{ now_date | dateFormat('yyyy-MM-dd') }}</span>
         </header>
         <div class="m_input-score">
            <header v-show="sel_game !== null" class="m_input-score__header">
               <div class="m_input-score__header__into">
                  <dl class="m_input-score__header__into__con">
                     <dt class="m_input-score__header__into__con__head">순번</dt>
                     <dd class="m_input-score__header__into__con__body">{{getInputScoreInfo.orderno}}</dd>
                  </dl>
                  <dl class="m_input-score__header__into__con">
                     <dt class="m_input-score__header__into__con__head">선수명</dt>
                     <dd class="m_input-score__header__into__con__body">{{getInputScoreInfo.names}}</dd>
                  </dl>
                  <dl class="m_input-score__header__into__con">
                     <dt class="m_input-score__header__into__con__head">소속</dt>
                     <dd class="m_input-score__header__into__con__body">{{getInputScoreInfo.team}}</dd>
                  </dl>
                  <dl class="m_input-score__header__into__con">
                     <dt class="m_input-score__header__into__con__head">다이브 번호</dt>
                     <dd class="m_input-score__header__into__con__body">{{getInputScoreInfo.divno}}</dd>
                  </dl>
                  <dl class="m_input-score__header__into__con t_col-2">
                     <dt class="m_input-score__header__into__con__head">다이브명</dt>
                     <dd class="m_input-score__header__into__con__body">{{getInputScoreInfo.divname}}</dd>
                  </dl>
                  <dl class="m_input-score__header__into__con">
                     <dt class="m_input-score__header__into__con__head">자세</dt>
                     <dd class="m_input-score__header__into__con__body">{{getInputScoreInfo.posture}}</dd>
                  </dl>
                  <dl class="m_input-score__header__into__con">
                     <dt class="m_input-score__header__into__con__head">높이</dt>
                     <dd class="m_input-score__header__into__con__body">{{getInputScoreInfo.height}}M</dd>
                  </dl>
                  <dl class="m_input-score__header__into__con">
                     <dt class="m_input-score__header__into__con__head">난이율</dt>
                     <dd class="m_input-score__header__into__con__body t_difficuty">{{getInputScoreInfo.difficulty}}</dd>
                  </dl>
                  <dl class="m_input-score__header__into__con t_col-3">
                     <dt class="m_input-score__header__into__con__head">심판정보 / 심판명</dt>
                     <dd class="m_input-score__header__into__con__body">{{getInputScoreInfo.jidx}}. {{getInputScoreInfo.jname}}</dd>
                  </dl>
               </div>
            </header>
            <div v-show="sel_game === null" class="m_input-score__pending">
               <div class="m_input-score__pending__con">
                  <object class="m_input-score__pending__con__img" type="image/svg+xml" data="/game_manager/images/icon_wating.svg">
                  </object>
                  <span class="m_input-score__pending__con__text">선수 대기중입니다...</span>
                  <button class="m_btn m_input-score__pending__con__btn" type="button">새로고침</button>
               </div>
            </div>
            <div v-if="isMobile === true" class="m_input-score__con" :class="{s_disabled: sel_game === null}">
               <div class="m_input-score__con__input">
                  <!-- <span class="m_input-score__con__input__type">E1</span> -->
                  <input :value="input_text" type="text" readonly>
                  <button v-show="input_text" @touchstart="resetInput()" class="m_input-score__con__input__btn-reset" type="button">
                     <img src="/game_manager/images/icon_reset-input.svg" alt="입력 초기화">
                  </button>
               </div>
               <ul class="m_input-score__con__keypad">
                  <li><button @touchstart="keydownInput('7')" class="m_input-score__con__keypad__btn" type="button">7</button></li>
                  <li><button @touchstart="keydownInput('8')" class="m_input-score__con__keypad__btn" type="button">8</button></li>
                  <li><button @touchstart="keydownInput('9')" class="m_input-score__con__keypad__btn" type="button">9</button></li>
                  <li><button @touchstart="keydownInput('4')" class="m_input-score__con__keypad__btn" type="button">4</button></li>
                  <li><button @touchstart="keydownInput('5')" class="m_input-score__con__keypad__btn" type="button">5</button></li>
                  <li><button @touchstart="keydownInput('6')" class="m_input-score__con__keypad__btn" type="button">6</button></li>
                  <li><button @touchstart="keydownInput('1')" class="m_input-score__con__keypad__btn" type="button">1</button></li>
                  <li><button @touchstart="keydownInput('2')" class="m_input-score__con__keypad__btn" type="button">2</button></li>
                  <li><button @touchstart="keydownInput('3')" class="m_input-score__con__keypad__btn" type="button">3</button></li>
                  <li>
                     <button @touchstart="keydownInput(E_KEY_BACKSPACE)" class="m_input-score__con__keypad__btn" type="button">
                        <img src="/game_manager/images/icon_backspace.svg" alt="Backspace">
                     </button>
                  </li>
                  <li><button @touchstart="keydownInput('0')" class="m_input-score__con__keypad__btn" type="button">0</button></li>
                  <li><button @touchstart="keydownInput(E_KEY_DOT)" class="m_input-score__con__keypad__btn" type="button">.</button></li>
               </ul>
               <div class="m_input-score__con__btns">
                  <button @click="closeModal_input()" class="m_input-score__con__btns__btn" type="button">닫기</button>
                  <button @click="okModal_input()" class="m_input-score__con__btns__btn t_confirm" type="button">입력</button>
               </div>
            </div>
            <div v-else class="m_input-score__con">
               <div class="m_input-score__con__input">
                  <span class="m_input-score__con__input__type">E1</span>
                  <input :value="input_text" type="text" readonly>
                  <button v-show="input_text" @mousedown="resetInput()" class="m_input-score__con__input__btn-reset" type="button">
                     <img src="/game_manager/images/icon_reset-input.svg" alt="입력 초기화">
                  </button>
               </div>
               <ul class="m_input-score__con__keypad">
                  <li><button @mousedown="keydownInput('7')" class="m_input-score__con__keypad__btn" type="button">7</button></li>
                  <li><button @mousedown="keydownInput('8')" class="m_input-score__con__keypad__btn" type="button">8</button></li>
                  <li><button @mousedown="keydownInput('9')" class="m_input-score__con__keypad__btn" type="button">9</button></li>
                  <li><button @mousedown="keydownInput('4')" class="m_input-score__con__keypad__btn" type="button">4</button></li>
                  <li><button @mousedown="keydownInput('5')" class="m_input-score__con__keypad__btn" type="button">5</button></li>
                  <li><button @mousedown="keydownInput('6')" class="m_input-score__con__keypad__btn" type="button">6</button></li>
                  <li><button @mousedown="keydownInput('1')" class="m_input-score__con__keypad__btn" type="button">1</button></li>
                  <li><button @mousedown="keydownInput('2')" class="m_input-score__con__keypad__btn" type="button">2</button></li>
                  <li><button @mousedown="keydownInput('3')" class="m_input-score__con__keypad__btn" type="button">3</button></li>
                  <li>
                     <button @mousedown="keydownInput(E_KEY_BACKSPACE)" class="m_input-score__con__keypad__btn" type="button">
                        <img src="/game_manager/images/icon_backspace.svg" alt="Backspace">
                     </button>
                  </li>
                  <li><button @mousedown="keydownInput('0')" class="m_input-score__con__keypad__btn" type="button">0</button></li>
                  <li><button @mousedown="keydownInput(E_KEY_DOT)" class="m_input-score__con__keypad__btn" type="button">.</button></li>
               </ul>
               <div class="m_input-score__con__btns">
                  <button @click="closeModal_input()" class="m_input-score__con__btns__btn" type="button">닫기</button>
                  <button @click="okModal_input()" class="m_input-score__con__btns__btn t_confirm" type="button">입력</button>
               </div>
            </div>
         </div>
         <!-- S: 모달창 영역 -->
         <!-- E: 모달창 영역 -->
      </main>
      <!-- E: 메인 영역 -->
      <!-- S: 공통 모달창 영역 -->
      <!--#include virtual="/game_manager/include/modal.asp"-->
      <!-- E: 공통 모달창 영역 -->
   </div>
   <!--#include virtual="/game_manager/include/body_after.asp"-->
</body>

</html>
