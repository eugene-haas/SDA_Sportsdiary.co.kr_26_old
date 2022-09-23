<!DOCTYPE html>
<!-- http://tennisadmin2.sportsdiary.co.kr/mobile_list_match.asp -->
<html lang="ko">
  <head>
    <!--#include virtual="./include/mobile_head.asp"-->
  </head>
  <body class="t_match-list">
    <!-- s 헤더 영역 -->
      <!--#include virtual="./include/mobile_header.asp"-->
    <!-- e 헤더 영역 -->
    <!-- s 메인 영역 -->
    <div class="l_main">
      <h2><strong class="hide">메인 콘텐츠 시작</strong></h2>
      <section class="">
        <h1 class="l_main__header hide">대회 리스트 시작</h1>
        <div class="l_main__con">
          <ul>
            <li class="match__list clear">
              <h2>개나리부(용인)</h2>
              <ol>
                <li class="match__list__list"><button type="button" name="button" onclick="openModal(0)">
                  <h4>1.코트등록/관리</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button" onclick="openModal(1)">
                  <h4>2.출전신고 / 예선 대진표</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button" onclick="openModal(2)">
                  <h4>3.예선 경기진행</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button" onclick="openModal(3)">
                  <h4>4.본선대진 추첨</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button" onclick="openModal(4)">
                  <h4>5.본선 경기진행</h4>
                </button></li>
              </ol>
            </li>
            <li class="match__list clear">
              <h2>개나리부(용인)</h2>
              <ol>
                <li class="match__list__list"><button type="button" name="button">
                  <h4>1.코트등록/관리</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button">
                  <h4>2.출전신고 / 예선 대진표</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button">
                  <h4>3.예선 경기진행</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button">
                  <h4>4.본선대진 추첨</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button">
                  <h4>5.본선 경기진행</h4>
                </button></li>
              </ol>
            </li>
            <li class="match__list clear">
              <h2>개나리부(용인)</h2>
              <ol>
                <li class="match__list__list"><button type="button" name="button">
                  <h4>1.코트등록/관리</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button">
                  <h4>2.출전신고 / 예선 대진표</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button">
                  <h4>3.예선 경기진행</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button">
                  <h4>4.본선대진 추첨</h4>
                </button></li>
                <li class="match__list__list"><button type="button" name="button">
                  <h4>5.본선 경기진행</h4>
                </button></li>
              </ol>
            </li>
          </ul>
        </div>
      </section>
    </div>
    <!-- e 메인 영역 -->
    <!-- s 모달창 영역 -->
    <section class="l_modal">
      <!--#include virtual="./include/mobile_header.asp"-->
      <div class="l_modal__con tryout-match">
        <div class="tryout-match__seach">
          <div class="tryout-match__seach__selc-box selc-box">
            <h2><strong class="hide">조 선택</strong></h2>
            <select name="">
              <option value="">1조</option>
            </select>
          </div>
        </div>
        <h2><strong class="hide">리스트 시작</strong></h2>
        <ul>
          <li class="tryout-match__list clear">
            <h3>
              <span>1번</span><span>2번</span>
            </h3>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 선택</option>
              </select>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_win" type="button" name="button"></button>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_defeat" type="button" name="button"></button>
            </div>
          </li>
          <li class="tryout-match__list clear">
            <h3>
              <span>1번</span><span>2번</span>
            </h3>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 선택</option>
              </select>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_win" type="button" name="button"></button>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_defeat" type="button" name="button"></button>
            </div>
          </li>
          <li class="tryout-match__list clear">
            <h3>
              <span>1번</span><span>2번</span>
            </h3>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 선택</option>
              </select>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_win" type="button" name="button"></button>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_defeat" type="button" name="button"></button>
            </div>
          </li>
          <li class="tryout-match__list clear">
            <h3>
              <span>1번</span><span>2번</span>
            </h3>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 선택</option>
              </select>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_win" type="button" name="button"></button>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_defeat" type="button" name="button"></button>
            </div>
          </li>
          <li class="tryout-match__list clear">
            <h3>
              <span>1번</span><span>2번</span>
            </h3>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 선택</option>
              </select>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_win" type="button" name="button"></button>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_defeat" type="button" name="button"></button>
            </div>
          </li>
          <li class="tryout-match__list clear">
            <h3>
              <span>1번</span><span>2번</span>
            </h3>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 선택</option>
              </select>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_win" type="button" name="button"></button>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_defeat" type="button" name="button"></button>
            </div>
          </li>
          <li class="tryout-match__list clear">
            <h3>
              <span>1번</span><span>2번</span>
            </h3>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 선택</option>
              </select>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="" type="button" name="button"></button>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="" type="button" name="button"></button>
            </div>
          </li>
          <li class="tryout-match__list clear">
            <h3>
              <span>1번</span><span>2번</span>
            </h3>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 선택</option>
              </select>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_win" type="button" name="button"></button>
            </div>
            <div class="tryout-match__list__result">
              <div class="tryout-match__list__result__selc-box">
                <select name="">
                  <option value="">0</option>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
                  <option value="">4</option>
                </select>
              </div>
              <h4>조분숙<br>이우창</h4>
              <button class="s_defeat" type="button" name="button"></button>
            </div>
          </li>
        </ul>
      </div>
    </section>
    <section class="l_modal t_court">
      <!--#include virtual="./include/mobile_header.asp"-->
      <div class="l_modal__con tryout-match">
        <div class="court__creat">
          <div class="court__creat__input-box clear">
            <h2><strong class="hide">코트명 생성</strong></h2>
            <input type="text" name="" value="" placeholder="코트명 입력">
            <button type="button" name="button">생성</button>
          </div>
        </div>
        <h2><strong class="hide">리스트 시작</strong></h2>
        <ul>
          <li class="court__list clear">
            <h3>제주도</h3>
            <button type="button" name="button">코트잠금</button>
            <div class="court__list__num clear">
              <input type="number" name="" value="">
              <button type="button" name="button">수정</button>
            </div>
            <button type="button" name="button"></button>
          </li>
          <li class="court__list clear">
            <h3>제주도</h3>
            <button type="button" name="button">코트잠금</button>
            <div class="court__list__num clear">
              <input type="number" name="" value="">
              <button type="button" name="button">수정</button>
            </div>
            <button type="button" name="button"></button>
          </li>
          <li class="court__list clear">
            <h3>제주도</h3>
            <button type="button" name="button">코트잠금</button>
            <div class="court__list__num clear">
              <input type="number" name="" value="">
              <button type="button" name="button">수정</button>
            </div>
            <button type="button" name="button"></button>
          </li>
          <li class="court__list clear">
            <h3>제주도</h3>
            <button type="button" name="button">코트잠금</button>
            <div class="court__list__num clear">
              <input type="number" name="" value="">
              <button type="button" name="button">수정</button>
            </div>
            <button type="button" name="button"></button>
          </li>
          <li class="court__list clear">
            <h3>제주도</h3>
            <button type="button" name="button">코트잠금</button>
            <div class="court__list__num clear">
              <input type="number" name="" value="">
              <button type="button" name="button">수정</button>
            </div>
            <button type="button" name="button"></button>
          </li>
          <li class="court__list clear">
            <h3>제주도</h3>
            <button type="button" name="button">코트잠금</button>
            <div class="court__list__num clear">
              <input type="number" name="" value="">
              <button type="button" name="button">수정</button>
            </div>
            <button type="button" name="button"></button>
          </li>
          <li class="court__list clear t_lock">
            <h3>제주도</h3>
            <button type="button" name="button">코트잠금</button>
            <div class="court__list__num clear">
              <input type="number" name="" value="">
              <button type="button" name="button">수정</button>
            </div>
            <button type="button" name="button"></button>
          </li>
          <li class="court__list clear t_disable">
            <h3>제주도</h3>
            <button type="button" name="button">코트잠금</button>
            <div class="court__list__num clear">
              <input type="number" name="" value="">
              <button type="button" name="button">수정</button>
            </div>
            <button type="button" name="button"></button>
          </li>
        </ul>
      </div>
    </section>
    <section class="l_modal t_match-list">
      <!--#include virtual="./include/mobile_header.asp"-->
      <div class="l_modal__con tryout-match">
        <div class="tryout-match__seach">
          <div class="tryout-match__seach__selc-box selc-box">
            <h2><strong class="hide">조 선택</strong></h2>
            <select name="">
              <option value="">1조</option>
            </select>
          </div>
        </div>
        <h2><strong class="hide">리스트 시작</strong></h2>
        <ul>
          <li class="match-list__list clear">
            <h3>
              서울 <em>1</em> 팀 <span>(승:<em>1</em> 패:<em>0</em>)</span>
            </h3>
            <div class="match-list__list__selc-box selc-box">
              <select name="">
                <option value="">순위</option>
              </select>
            </div>
            <div class="match-list__list__con">
              <span>삼성반도체테니스동호회</span>
              <h4>강원창</h4>
            </div>
            <div class="match-list__list__con">
              <span>삼성반도체테니스동호회</span>
              <h4>강원창</h4>
            </div>
            <ul class="clear">
              <!-- match-list__list__btns.s_off = button 토글 클래스 -->
              <li class="match-list__list__btns">
                <h4>출석</h4>
                <button type="button" name="button"></button>
              </li>
              <li class="match-list__list__btns">
                <h4>사은품</h4>
                <button type="button" name="button"></button>
              </li>
              <li class="match-list__list__btns s_off">
                <h4>입금</h4>
                <button type="button" name="button"></button>
              </li>
            </ul>
          </li>
          <li class="match-list__list clear">
            <h3>
              서울 <em>1</em> 팀 <span>(승:<em>1</em> 패:<em>0</em>)</span>
            </h3>
            <div class="match-list__list__selc-box selc-box">
              <select name="">
                <option value="">순위</option>
              </select>
            </div>
            <div class="match-list__list__con">
              <span>삼성반도체테니스동호회</span>
              <h4>강원창</h4>
            </div>
            <div class="match-list__list__con">
              <span>삼성반도체테니스동호회</span>
              <h4>강원창</h4>
            </div>
            <ul class="clear">
              <!-- match-list__list__btns.s_off = button 토글 클래스 -->
              <li class="match-list__list__btns">
                <h4>출석</h4>
                <button type="button" name="button"></button>
              </li>
              <li class="match-list__list__btns">
                <h4>사은품</h4>
                <button type="button" name="button"></button>
              </li>
              <li class="match-list__list__btns s_off">
                <h4>입금</h4>
                <button type="button" name="button"></button>
              </li>
            </ul>
          </li>
          <li class="match-list__list clear">
            <h3>
              서울 <em>1</em> 팀 <span>(승:<em>1</em> 패:<em>0</em>)</span>
            </h3>
            <div class="match-list__list__selc-box selc-box">
              <select name="">
                <option value="">순위</option>
              </select>
            </div>
            <div class="match-list__list__con">
              <span>삼성반도체테니스동호회</span>
              <h4>강원창</h4>
            </div>
            <div class="match-list__list__con">
              <span>삼성반도체테니스동호회</span>
              <h4>강원창</h4>
            </div>
            <ul class="clear">
              <!-- match-list__list__btns.s_off = button 토글 클래스 -->
              <li class="match-list__list__btns">
                <h4>출석</h4>
                <button type="button" name="button"></button>
              </li>
              <li class="match-list__list__btns">
                <h4>사은품</h4>
                <button type="button" name="button"></button>
              </li>
              <li class="match-list__list__btns s_off">
                <h4>입금</h4>
                <button type="button" name="button"></button>
              </li>
            </ul>
          </li>
          <li class="match-list__list clear">
            <h3>
              서울 <em>1</em> 팀 <span>(승:<em>1</em> 패:<em>0</em>)</span>
            </h3>
            <div class="match-list__list__selc-box selc-box">
              <select name="">
                <option value="">순위</option>
              </select>
            </div>
            <div class="match-list__list__con">
              <span>삼성반도체테니스동호회</span>
              <h4>강원창</h4>
            </div>
            <div class="match-list__list__con">
              <span>삼성반도체테니스동호회</span>
              <h4>강원창</h4>
            </div>
            <ul class="clear">
              <!-- match-list__list__btns.s_off = button 토글 클래스 -->
              <li class="match-list__list__btns">
                <h4>출석</h4>
                <button type="button" name="button"></button>
              </li>
              <li class="match-list__list__btns">
                <h4>사은품</h4>
                <button type="button" name="button"></button>
              </li>
              <li class="match-list__list__btns s_off">
                <h4>입금</h4>
                <button type="button" name="button"></button>
              </li>
            </ul>
          </li>
        </ul>
      </div>
    </section>
    <section class="l_modal t_draw-lots">
      <!--#include virtual="./include/mobile_header.asp"-->
      <div class="l_modal__con draw-lots">
        <h2><strong class="hide">콘텐츠 시작</strong></h2>
        <table class="draw-lots__tbl">
          <caption>본선 추첨 표</caption>
          <thead>
            <tr>
              <th>조</th>
              <th>1위번호</th>
              <th>2위번호</th>
              <th><button type="button" name="button">지역저장</button></th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
            <tr>
              <th>1</th>
              <td><input type="number" name="" value="1"></td>
              <td><input type="number" name="" value="10"></td>
              <td><input type="text" name="" value="부천"></td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
    <section class="l_modal t_match_main">
      <!--#include virtual="./include/mobile_header.asp"-->
      <div class="l_modal__con tryout-match">
        <div class="tryout-match__seach">
          <div class="tryout-match__seach__selc-box selc-box">
            <h2><strong class="hide">코트명 선택</strong></h2>
            <select name="">
              <option value="">코트명 선택</option>
            </select>
          </div>
          <div class="tryout-match__seach__selc-box selc-box">
            <h2><strong class="hide">진행중</strong></h2>
            <select name="">
              <option value="">진행중</option>
            </select>
          </div>
          <button type="button" name="button">대진표</button>
        </div>
        <h2><strong class="hide">리스트 시작</strong></h2>
        <ul>
          <li class="tryout-match__list clear s_on">
            <div class="tryout-match__list__header">
              <h3>대기순번 <em>1</em></h3>
              <span>지정/매칭 <strong>10:24:38</strong></span>
              <span><em>32</em>강</span>
            </div>
            <div class="tryout-match__list__selc_header"><span><strong>A</strong> 코트</span></div>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 배정</option>
              </select>
            </div>
            <div class="tryout-match__list__result t_main clear">
              <button class="s_win" type="button" name="button">조분숙, 이우창</button>
              <button class="s_defeat" type="button" name="button">표성택, 육희영</button>
            </div>
          </li>
          <li class="tryout-match__list clear">
            <div class="tryout-match__list__header">
              <h3>대기순번 <em>1</em></h3>
              <span>지정/매칭 <strong>10:24:38</strong></span>
              <span><em>32</em>강</span>
            </div>
            <div class="tryout-match__list__selc_header"><span><strong>A</strong> 코트</span></div>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 배정</option>
              </select>
            </div>
            <div class="tryout-match__list__result t_main clear">
              <button class="s_win" type="button" name="button">조분숙, 이우창</button>
              <button class="" type="button" name="button">표성택, 육희영</button>
            </div>
          </li>
          <li class="tryout-match__list clear ">
            <div class="tryout-match__list__header">
              <h3>대기순번 <em>1</em></h3>
              <span>지정/매칭 <strong>10:24:38</strong></span>
              <span><em>32</em>강</span>
            </div>
            <div class="tryout-match__list__selc_header"><span><strong>A</strong> 코트</span></div>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 배정</option>
              </select>
            </div>
            <div class="tryout-match__list__result t_main clear">
              <button class="s_win" type="button" name="button">조분숙, 이우창</button>
              <button class="s_defeat" type="button" name="button">표성택, 육희영</button>
            </div>
          </li>
          <li class="tryout-match__list clear ">
            <div class="tryout-match__list__header">
              <h3>대기순번 <em>1</em></h3>
              <span>지정/매칭 <strong>10:24:38</strong></span>
              <span><em>32</em>강</span>
            </div>
            <div class="tryout-match__list__selc_header"><span><strong>A</strong> 코트</span></div>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 배정</option>
              </select>
            </div>
            <div class="tryout-match__list__result t_main clear">
              <button class="s_win" type="button" name="button">조분숙, 이우창</button>
              <button class="s_defeat" type="button" name="button">표성택, 육희영</button>
            </div>
          </li>
          <li class="tryout-match__list clear ">
            <div class="tryout-match__list__header">
              <h3>대기순번 <em>1</em></h3>
              <span>지정/매칭 <strong>10:24:38</strong></span>
              <span><em>32</em>강</span>
            </div>
            <div class="tryout-match__list__selc_header"><span><strong>A</strong> 코트</span></div>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 배정</option>
              </select>
            </div>
            <div class="tryout-match__list__result t_main clear">
              <button class="s_win" type="button" name="button">조분숙, 이우창</button>
              <button class="s_defeat" type="button" name="button">표성택, 육희영</button>
            </div>
          </li>
          <li class="tryout-match__list clear ">
            <div class="tryout-match__list__header">
              <h3>대기순번 <em>1</em></h3>
              <span>지정/매칭 <strong>10:24:38</strong></span>
              <span><em>32</em>강</span>
            </div>
            <div class="tryout-match__list__selc_header"><span><strong>A</strong> 코트</span></div>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 배정</option>
              </select>
            </div>
            <div class="tryout-match__list__result t_main clear">
              <button class="s_win" type="button" name="button">조분숙, 이우창</button>
              <button class="s_defeat" type="button" name="button">표성택, 육희영</button>
            </div>
          </li>
          <li class="tryout-match__list clear ">
            <div class="tryout-match__list__header">
              <h3>대기순번 <em>1</em></h3>
              <span>지정/매칭 <strong>10:24:38</strong></span>
              <span><em>32</em>강</span>
            </div>
            <div class="tryout-match__list__selc_header"><span><strong>A</strong> 코트</span></div>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 배정</option>
              </select>
            </div>
            <div class="tryout-match__list__result t_main clear">
              <button class="s_win" type="button" name="button">조분숙, 이우창</button>
              <button class="s_defeat" type="button" name="button">표성택, 육희영</button>
            </div>
          </li>
          <li class="tryout-match__list clear ">
            <div class="tryout-match__list__header">
              <h3>대기순번 <em>1</em></h3>
              <span>지정/매칭 <strong>10:24:38</strong></span>
              <span><em>32</em>강</span>
            </div>
            <div class="tryout-match__list__selc_header"><span><strong>A</strong> 코트</span></div>
            <div class="tryout-match__list__selc-box selc-box">
              <select name="">
                <option value="">코트 배정</option>
              </select>
            </div>
            <div class="tryout-match__list__result t_main clear">
              <button class="s_win" type="button" name="button">조분숙, 이우창</button>
              <button class="s_defeat" type="button" name="button">표성택, 육희영</button>
            </div>
          </li>
        </ul>
      </div>
    </section>
    <!-- e 모달창 영역 -->
<script>
function openModal(index){
  document.querySelectorAll('.l_modal')[index].classList.add('s_show');
  document.querySelector('body').classList.add('s_modal');
}
function closeModal(){
  var $modal = document.querySelectorAll('.l_modal');
  for (var i = 0; i < $modal.length; i++) {
    $modal[i].classList.remove('s_show');
  }
  document.querySelector('body').classList.remove('s_modal');
}

</script>
  </body>
</html>
