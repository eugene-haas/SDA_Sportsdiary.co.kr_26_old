<!--#include file = "./include/config_top.asp" -->
<title>KATA Tennis 대회 참가신청</title>
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<%  
	'==============================================================================
	'act=MOD 일 경우 상세정보페이지 조회 조건값 수신
	'==============================================================================
	dim act			  	: act   		= fInject(Request("act"))
	dim CIDX			: CIDX   		= fInject(decode(Request("CIDX"), 0))
	dim currPage    	: currPage    	= fInject(Request("currPage"))
	dim Fnd_GameTitle 	: Fnd_GameTitle = fInject(Request("GameTitle"))
	dim Fnd_GameGb 		: Fnd_GameGb   	= fInject(Request("GameGb"))
	dim Fnd_KeyWord  	: Fnd_KeyWord   = fInject(Request("Fnd_KeyWord"))
	'==============================================================================
	
	IF act = "MOD" Then
	
	End IF
	
	response.Write "act="&act&"<br>"
	response.Write "CIDX="&CIDX&"<br>"
	response.Write "currPage="&currPage&"<br>"
	response.Write "Fnd_GameTitle="&Fnd_GameTitle&"<br>"
	response.Write "Fnd_GameGb="&Fnd_GameGb&"<br>"
	response.Write "Fnd_KeyWord="&Fnd_KeyWord&"<br>"
%>
<script>
  //maxlength 체크
  function maxLengthCheck(object){
    if(object.value.length > object.maxLength){
      object.value = object.value.slice(0, object.maxLength);
    }  
  }
  
  //create Select box 대회조회 및 대회참가종목 조회
  function FND_SELECTOR(element){
    var strAjaxUrl = "./ajax/request_list_Select.asp";  
    var Fnd_GameTitle = $("#GameTitle").val();
    
    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: { 
        element     : element
        ,Fnd_GameTitle  : Fnd_GameTitle
      },
      success: function(retDATA) {
        
        //console.log(retDATA);
        
        if(retDATA){
          
          var strcut = retDATA.split("|");
          
          if(strcut[0]=="TRUE"){
            $('#'+element).append(strcut[1]);
          }
        }       
      }, 
      error: function(xhr, status, error){
        if(error!=""){ 
          alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"); 
          return; 
        }     
      }
    });
  }
  
  $(document).on('change','#GameTitle',function(){
    //참가종목 조회
    FND_SELECTOR('GameGb');
  });
  
  $(document).ready(function(){
    //검색조건 대회명 조회
    FND_SELECTOR('GameTitle');
  });   
  </script>
</head>
<body class="lack_bg">
  <!-- S: header -->
  <!-- #include file = './include/header.asp' -->
  <!-- E: header -->

  <!-- S: main -->
  <div class="main">
    <!-- S: cont_box -->
    <div class="cont_box">
      <!-- S: form_header -->
      <div class="form_header">
        <h2 class="title">[C그룹] 2017 Flex Power 용인클레이배 테니스대회</h2>
        <p class="term">2017.09.02(토) ~ 2017.09.04(월)</p>
      </div>
      <!-- E: form_header -->

      <!-- S: form_cont -->
      <div class="form_cont">
        <!-- S: form -->
        <form>
          <fieldset>
            <!-- legend 안 보임 -->
            <legend>참가신청 작성</legend>
            <!-- legend 안 보임 -->

            <!-- S: form_list -->
            <ul class="form_list">
              <!-- S: 패스워드 -->
              <li class="el_1">
                <label>
                  <span class="title">패스워드</span>
                  <input type="password" id="UserPass" name="UserPass" maxlength="20" class="ipt" />
                </label>
              </li>
              <!-- E: 패스워드 -->

              <!-- S: 대회명 -->
              <li class="el_1">
                <label>
                  <span class="title">대회명</span>
          
                  <select class="ipt" id="GameTitle" name="GameTitle" >
                    <option value="">:: 대회선택 ::</option>
                    <!--
                    <option>[B그룹]2017 프렌드쉽오픈</option>
                    <option>[SA그룹]2017 엔프라니배</option>
                    <option>[C그룹]2017 Flex Power 용인클레이배</option>
                    <option>[B그룹]2017 안양한우리 OPEN</option>
                    <option>[SA그룹]2017 나사라배</option>
                    -->
                  </select>
                  
                </label>
              </li>
              <!-- E: 대회명 -->

              <!-- S: 출전종목 -->
              <li class="el_1">
                <label>
                  <span class="title">출전종목</span>
                  <select class="ipt" id="TeamGb" name="TeamGb">
                    <option value="">:: 참가종목선택 ::</option>
                    <!--
                    <option>국화부</option>
                    <option>개나리부(부천)</option>
                    <option>개나리부(구리)</option>
                    <option>오픈부</option>
                    <option>신인부B(부천)</option>
                    <option>신인부B(구리)</option>
                    -->
                  </select>
                </label>
              </li>
              <!-- E: 출전종목 -->

              <!-- S: 신청자 이름 -->
              <li class="reqer el_2">
                <label class="col_1">
                  <span class="title">신청자 이름</span>
                  <input type="text" class="ipt" id="UserName" name="UserName" placeholder=":: 이름을 입력하세요 ::">
                </label>
                <span class="col_1 el_3 phone_line">
                  <label>
                    <span class="title">휴대폰 번호</span>
                    <select class="ipt col_1" id="UserPhone1" name="UserPhone1">
                      <option value="010">010</option>
                      <option value="011">011</option>
                      <option value="016">016</option>
                      <option value="017">017</option>
                      <option value="018">018</option>
                      <option value="019">019</option>
                    </select>
                  </label>
                  <span class="divn">-</span>
                  <input type="number" class="ipt col_1 phone_line" id="UserPhone2" name="UserPhone2" maxlength="4" oninput="maxLengthCheck(this)" onKeyUp="if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}" />
                  <span class="divn">-</span>
                  <input type="number" class="ipt col_1 phone_line" id="UserPhone3" name="UserPhone3" maxlength="4" oninput="maxLengthCheck(this)" />
                </span>
              </li>
              <!-- E: 신청자 이름 -->

              <li class="no_bdb">
                <ul class="entry_list">
                  <!-- S: 참가자 정보 -->
                  <li class="entry el_2">
                    <!-- S: party -->
                    <ul class="party col_1">
                      <!-- S: header -->
                      <li class="header">
                        <a href="#" class="btn btn_party_del">
                          <span class="ic_deco">
                            <i class="fa fa-times-circle"></i>
                          </span>
                          <!-- <span>참가자 삭제</span> -->
                        </a>
                        <span class="num-box">1</span>
                        <h3>참가자1 정보</h3>
                        <label>
                          <input type="checkbox">
                          <span class="txt">신청자 정보와 동일</span>
                        </label>
                      </li>
                      <!-- E: header -->

                      <!-- S: 이름 -->
                      <li class="el_2 name">
                        <label class="col_1">
                        <span class="title">이름</span>
                        <input type="text" class="ipt" id="P1_UserName" name="P1_UserName">
                        </label>
                        <label class="col_1">
                        <span class="title">등급</span>
                        <select class="ipt" id="P1_UserLevel" name="P1_UserLevel">
                          <option value="">선택</option>
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="D">D</option>
                            <option value="E">E</option>
                            <option value="F">F</option>
                        </select>
                        </label>
                      </li>
                      <!-- E: 이름 -->

                      <!-- S: 소속 구버전 -->
                      <!-- <li class="el_1">
                        <label>
                          <span class="title">소속</span>
                          <select class="ipt" id="P_ReqClub2" name="P_ReqClub2">
                            <option>:: 소속을 선택하세요 ::</option>
                            <option>무궁화, 삼천리</option>
                            <option>백두산, 한라산</option>
                            <option>직접 입력</option>
                          </select>
                        </label>
                        <ul class="dir_ipt el_2 clearfix">
                          <li>
                            <input type="text">
                          </li>
                          <li class="divn">,</li>
                          <li>
                            <input type="text">
                          </li>
                        </ul>
                      </li> -->
                      <!-- E: 소속 구버전 -->

                      <!-- S: 소속 -->
                      <li class="club el_2 clearfix">
                        <label>
                          <span class="title">소속</span>
                          <span class="show_srch col_1 ipt">
                            <input type="text" id="P1_TeamNmOne" name="P1_TeamNmOne" />
                            <ul class="auto_srch">
                              <li><a href="#">강서어택</a></li>
                              <li><a href="#">강북멋쟁이</a></li>
                              <li><a href="#">강남스타일</a></li>
                              <li><a href="#">강서뚜쟁이</a></li>
                              <li><a href="#">강동막둥이</a></li>
                              <li><a href="#">마포막난이</a></li>
                            </ul>
                          </span>
                        </label>
                        <span class="divn">,</span>
                        <label class="col_1 ipt">
                          <input type="text" id="P1_TeamNmTwo" name="P1_TeamNmTwo" />
                          <ul class="auto_srch">
                            <li><a href="#">강서어택</a></li>
                            <li><a href="#">강북멋쟁이</a></li>
                            <li><a href="#">강남스타일</a></li>
                            <li><a href="#">강서뚜쟁이</a></li>
                            <li><a href="#">강동막둥이</a></li>
                            <li><a href="#">마포막난이</a></li>
                          </ul>
                        </label>
                      </li>
                      <!-- E: 소속 -->

                      <!-- S: 성별 -->
                      <li class="gender el_2">
                        <span class="title">성별</span>
                        <span class="type radio_list">
                          <label class="col_1 btn">
                            <span class="ic_deco">
                              <i class="fa fa-male"></i>
                            </span>
                            <input type="radio" id="P1_Gender" name="P1_Gender">
                            <span>남자</span>
                          </label>
                          <label class="col_1 btn">
                            <span class="ic_deco">
                              <i class="fa fa-female"></i>
                            </span>
                            <input type="radio" id="P1_Gender" name="P1_Gender">
                            <span>여자</span>
                          </label>
                        </span>
                      </li>
                      <!-- E: 성별 -->

                      <!-- S: 핸드폰 -->
                      <li class="phone_line el_3">
                        <label>
                          <span class="title">핸드폰</span>
                          <select class="ipt col_1" id="P1_UserPhone1" name="P1_UserPhone1">
                            <option value="010">010</option>
                              <option value="011">011</option>
                              <option value="016">016</option>
                              <option value="017">017</option>
                              <option value="018">018</option>
                              <option value="019">019</option>
                          </select>
                        </label>
                        <span class="divn">-</span>
                        <input type="number" class="ipt col_1" id="P1_UserPhone2" name="P1_UserPhone2" maxlength="4" oninput="maxLengthCheck(this)" onKeyUp="if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}" />
                        <span class="divn">-</span>
                        <input type="number" class="ipt col_1" id="P1_UserPhone3" name="P1_UserPhone3" maxlength="4" oninput="maxLengthCheck(this)" />
                      </li>
                      <!-- E: 핸드폰 -->

                      <!-- S: 생년월일 -->
                      <li class="birth el_1">
                        <label>
                          <span class="title">생년월일</span>
                          <!-- <select class="ipt col_1" id="P1_BirthdayY" name="P1_BirthdayY">
                            <option value="">생년</option>
                            <option value="">1940</option>
                            <option value="">1941</option>
                            <option value="">1942</option>
                            <option value="">1943</option>
                            <option value="">1944</option>
                            <option value="">1945</option>
                            <option value="">1946</option>
                            <option value="">1947</option>
                            <option value="">1948</option>
                            <option value="">1949</option>
                            <option value="">1950</option>
                          </select> -->
                          <input type="number" class="ipt col_1" id="P1_Birthday" name="P1_Birthday" placeholder="ex)19880725" oninput="maxLengthCheck(this)" />
                        </label>
                        <!-- <span class="divn">-</span>
                        <select class="ipt col_1" id="P1_BirthdayM" name="P1_BirthdayM">
                          <option value="">월</option>
                          <option value="">01</option>
                          <option value="">02</option>
                          <option value="">03</option>
                          <option value="">04</option>
                          <option value="">05</option>
                          <option value="">06</option>
                          <option value="">07</option>
                          <option value="">08</option>
                          <option value="">09</option>
                          <option value="">10</option>
                          <option value="">11</option>
                          <option value="">12</option>
                        </select> 
                        <span class="divn">-</span>-->
                        <!-- <select class="ipt col_1" id="P1_BirthdayD" name="P1_BirthdayD">
                          <option value="">일</option>
                          <option value="">1</option>
                          <option value="">2</option>
                          <option value="">3</option>
                          <option value="">4</option>
                        </select> -->
                      </li>
                      <!-- E: 생년월일 -->
                    </ul>
                    <!-- E: party -->

                    <!-- S: party -->
                    <ul class="party col_1">
                      <!-- S: header -->
                      <li class="header">
                        <h3>참가자2 정보</h3>
                      </li>
                      <!-- E: header -->

                      <!-- S: 이름 -->
                      <li class="el_2 name">
                        <label class="col_1">
                          <span class="title">이름</span>
                          <input type="text" class="ipt" id="P2_UserName" name="P2_UserName" />
                        </label>
                        <label class="col_1">
                          <span class="title">등급</span>
                          <select class="ipt" id="P2_UserLevel" name="P2_UserLevel">
                            <option value="">선택</option>
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="D">D</option>
                            <option value="E">E</option>
                            <option value="F">F</option>
                          </select>
                        </label>
                      </li>
                      <!-- E: 이름 -->

                      <!-- S: 소속 -->
                      <li class="club el_2 clearfix">
                        <label>
                          <span class="title">소속</span>
                          <span class="show_srch col_1 ipt">
                            <input type="text" id="P2_TeamNmOne" name="P2_TeamNmOne" />
                            <ul class="auto_srch">
                              <!-- <li><a href="#">강서어택</a></li>
                              <li><a href="#">강북멋쟁이</a></li>
                              <li><a href="#">강남스타일</a></li>
                              <li><a href="#">강서뚜쟁이</a></li>
                              <li><a href="#">강동막둥이</a></li>
                              <li><a href="#">마포막난이</a></li> -->
                            </ul>
                          </span>
                        </label>
                        <span class="divn">,</span>
                        <label class="col_1 ipt">
                          <input type="text" id="P2_TeamNmTwo" name="P2_TeamNmTwo" />
                          <ul class="auto_srch">
                            <li><a href="#">강서어택</a></li>
                            <li><a href="#">강북멋쟁이</a></li>
                            <li><a href="#">강남스타일</a></li>
                            <li><a href="#">강서뚜쟁이</a></li>
                            <li><a href="#">강동막둥이</a></li>
                            <li><a href="#">마포막난이</a></li>
                          </ul>
                        </label>
                      </li>
                      <!-- E: 소속 -->

                      <!-- S: 성별 -->
                      <li class="gender el_2">
                        <span class="title">성별</span>
                        <span class="type radio_list">
                          <label class="col_1 btn">
                            <span class="ic_deco">
                              <i class="fa fa-male"></i>
                            </span>
                            <input type="radio" id="P2_Ggender" name="P2_Ggender" />
                            <span>남자</span>
                          </label>
                          <label class="col_1 btn">
                            <span class="ic_deco">
                              <i class="fa fa-female"></i>
                            </span>
                            <input type="radio" id="P2_Ggender" name="P2_Ggender" />
                            <span>여자</span>
                          </label>
                        </span>
                      </li>
                      <!-- E: 성별 -->

                      <!-- S: 핸드폰 -->
                      <li class="phone_line el_3">
                        <label>
                          <span class="title">핸드폰</span>
                          <select class="ipt col_1" id="P2_UserPhone1" name="P2_UserPhone1">
                            <option value="010">010</option>
                              <option value="011">011</option>
                              <option value="016">016</option>
                              <option value="017">017</option>
                              <option value="018">018</option>
                              <option value="019">019</option>
                          </select>
                        </label>
                        <span class="divn">-</span>
                        <input type="number" class="ipt col_1" id="P2_UserPhone2" name="P2_UserPhone2" maxlength="4" onKeyUp="if($('#UserPhone2').val().length==4){$('#UserPhone3').focus();}">
                        <span class="divn">-</span>
                        <input type="number" class="ipt col_1" id="P2_UserPhone3" name="P2_UserPhone3" maxlength="4" oninput="maxLengthCheck(this)" />
                      </li>
                      <!-- E: 핸드폰 -->

                      <!-- S: 생년월일 -->
                      <li class="birth el_1">
                        <label>
                          <span class="title">생년월일</span>
                          <!-- <select class="ipt col_1" id="P_ReqBirthdayY2" name="P_ReqBirthdayY2">
                            <option value="">생년</option>
                            <option value="">1940</option>
                            <option value="">1941</option>
                            <option value="">1942</option>
                            <option value="">1943</option>
                            <option value="">1944</option>
                            <option value="">1945</option>
                            <option value="">1946</option>
                            <option value="">1947</option>
                            <option value="">1948</option>
                            <option value="">1949</option>
                            <option value="">1950</option>
                          </select> -->
                          <input type="number" class="ipt col_1" id="P2_Birthday" name="P2_Birthday" placeholder="ex)19880725" oninput="maxLengthCheck(this)" />
                        </label>
                        <!-- <span class="divn">-</span>
                        <select class="ipt col_1"id="P_ReqBirthdayM2" name="P_ReqBirthdayM2">
                          <option value="">월</option>
                          <option value="">01</option>
                          <option value="">02</option>
                          <option value="">03</option>
                          <option value="">04</option>
                          <option value="">05</option>
                          <option value="">06</option>
                          <option value="">07</option>
                          <option value="">08</option>
                          <option value="">09</option>
                          <option value="">10</option>
                          <option value="">11</option>
                          <option value="">12</option>
                        </select>
                        <span class="divn">-</span>
                        <select class="ipt col_1"id="P_ReqBirthdayD2" name="P_ReqBirthdayD2">
                          <option value="">일</option>
                          <option value="">1</option>
                          <option value="">2</option>
                          <option value="">3</option>
                          <option value="">4</option>
                        </select> -->
                      </li>
                      <!-- E: 생년월일 -->
                    </ul>
                    <!-- E: party -->
                  </li>
                  <!-- E: 참가자 정보 -->
                </ul>
              </li>

              <!-- S: 소속 입력 안내 -->
              <li class="guide_txt club_guide">
                <p>※신규 대회출전자, 혹은 소속명 자동조회가 안 될 경우, "직접입력"하셔서 등록 하시기 바랍니다.</p>
              </li>
              <!-- E: 소속 입력 안내 -->

              <!-- S: 생년월일 입력 안내 -->
              <li class="guide_txt birth_guide">
                <p>※생년월일의 정보를 입력하게되면 향후 스포츠다이어리 어플리케이션에서 파트너(Pair)찾기 등의 다양한 서비스이용시 용이하며, 그 외의 이벤트 기간에 많은 혜택의 기회가 주어집니다.
                </p>
              </li>
              <!-- E: 생년월일 입력 안내 -->

              <!-- 
                S: 참가팀 추가등록 
                버튼 클릭시 
                entry_list 아래 li.entry 가 추가 되도록 구성
              -->
              <li class="btn_full no_bdb">
                <a href="#" class="btn add_party">
                  <span class="ic_deco"><i class="fa fa-plus"></i></span>
                  <span>참가팀 추가등록</span>
                </a>
              </li>
              <!-- E: 참가팀 추가등록 -->

              <!-- S: 입금일자 -->
              <li class="title_list">
                <span class="big_title">대회참가비 입금정보</span>
                <label>
                  <span class="title">입금일자</span>
                  <input type="text" class="ipt" placeholder="ex) 2017.01.01" id="PaymentDt" name="PaymentDt" />
                </label>
                <label>
                  <span class="title">입금자명</span>
                  <input type="text" class="ipt" id="PaymentNm" name="PaymentNm" />
                </label>
              </li>
              <!-- E: 입금일자 -->


              <!-- S: 기타 건의내용 -->
              <li class="title_list user_suggest">
                <span class="big_title">기타 건의내용</span>
                <label>
                  <span class="ipt">
                    <textarea id="txtMemo" name="txtMemo"></textarea>
                  </span>
                </label>
              </li>
              <!-- E: 기타 건의내용 -->

              <!-- S: guide_txt -->
              <li class="guide_txt agree_warn clearfix">
                <span class="ic_deco">
                  <i class="fa fa-exclamation-circle"></i>
                </span>
                <div class="txt">
                  <p>입력하신 참가자(파트너 포함) 휴대폰 번호를 통해 참가선수 본인 확인절차가 진행됩니다.<br>
                  반드시 대회 참가자의 휴대폰 번호를 정확하게 입력하시기 바랍니다.</p>
                </div>
              </li>
              <li class="guide_txt no_bg">
                <p>※ 앞으로 KATA동호인테니스 대회의 모든 경기결과 및 선수조회는 스포츠다이어리 어플리케이션을 통해 실시간 제공해 드립니다.<br>
                  스포츠다이어리로 대회정보 외에도 다양한 컨텐츠를 이용</p>
              </li>
              <!-- E: guide_txt -->
            </ul>
            <!-- E: form_list -->
          </fieldset>
          <!-- S: cta_btn -->
          <div class="cta_btn">
            <a href="list.asp" class="btn_gray">목록보기</a>
            <a href="#" class="btn_green">참가신청 완료</a>
          </div>
          <!-- E: cta_btn -->

          <!-- 
            조회 후 보이는 버튼 목록
            신청 삭제 : 내용 삭제 및 취소 (confirm 창으로 재확인)
            수정하기 -> write 상태로 변경
            목록보기 -> 이전 list.asp로 이동
           -->
          <!-- S: cta_btn -->
          <div class="cta_btn">
            <a href="#" class="btn_redy">신청 삭제</a>
            <a href="#" class="btn_green">수정하기</a>
            <a href="list.asp" class="btn_gray">목록보기</a>
          </div>
          <!-- E: cta_btn -->
        </form>
        <!-- E: form -->
      </div>
      <!-- E: form_cont -->
    </div>
    <!-- E: cont_box -->
  </div>
  <!-- E: main -->
  <script src="js/main.js"></script>
</body>
</html>