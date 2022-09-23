<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->
</head>
<body>
<div id="app" class="l m_bg_f2f2f2 matchSch" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">출전순서표</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <p class="m_matchTit">{{game_title}}<button class="m_matchTit__refresh" v-if="game_top_info.status!=''" @click="gameStatusRefresh">리로드</button></p>

    <!-- <div class="m_roundBoard" v-if="game_top_info.status!=''">
      <p class="currentMatch">
        <span class="currentMatch__status">{{game_top_info.status}}</span>
        <span class="currentMatch__name">{{game_top_info.title}}</span>
      </p>
    </div> -->
    <div class="m_cube" v-if="game_top_info.status!=''">
      <div class="m_cube__inner" v-bind:class="{s_on:status_rotate=='on', s_notran:status_rotate=='s_notran'}">
        <div class="m_roundBoard">
          <p class="currentMatch">
            <span class="currentMatch__status">{{game_top_info.status}}</span>
            <span class="currentMatch__name">{{game_top_info.title}}</span>
          </p>
        </div>
        <div class="m_roundBoard">
          <p class="currentMatch">
            <span class="currentMatch__status">{{game_top_info.status}}</span>
            <span class="currentMatch__name">{{game_top_info.title}}</span>
          </p>
        </div>
      </div>
    </div>

    <div class="m_searchTags">
      <div class="m_searchTags__infoBox">
        <p class="m_searchTags__infoTxt" v-if="search_txt!=''">{{search_txt}}</p>
        <button class="m_searchTags__btn" @click="openSearching('.searchPopup')"><div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt=""></div></button>
      </div>
    </div>

    <div class="matchDays" v-if="game_day!='nodata'">
      <div class="matchDays__list m_horizontal_scroll">
        <button class="matchDays__day" v-for="(day,key) in game_day" v-bind:class="{s_active: dayChoice(key,game_day_active_no,day.day,(mm+'/'+dd))}" @click="gameSchedule(day.day,key)">{{day.day}}</button>
      </div>
    </div>

    <div class="m_roundBoard__wrap" v-if="game_schedule!='nodata'">
      <div class="m_loadingbar" v-if="loading_days" v-bind:class="{m_dflex: loading_days}">
        <div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt=""></div>
      </div>
      <div class="m_roundBoard" v-for="(sdata,key) in game_schedule">
        <div class="scheduleItem" v-bind:class="{s_notice: sdata.playerlist==undefined}" v-if="sdata.playerlist==undefined">
          <p class="scheduleItem__index">
            <span class="scheduleItem__indexTit">{{sdata.title}}</span>
            <span class="scheduleItem__indexTime">{{sdata.time}}</span>
          </p>
        </div>
        <button class="scheduleItem" v-if="sdata.playerlist!=undefined" @click="openSearching('.gameDetailPopup',['playerlist',sdata.playerlist])">
          <p class="scheduleItem__index">
            <span class="scheduleItem__indexTit">{{sdata.title}}</span>
            <span class="scheduleItem__indexTime">{{sdata.time}}</span>
          </p>
          <p class="scheduleItem__name">{{sdata.cmt}}</p>
        </button>
      </div>
    </div>
  </div>

  <!-- search popup -->
  <div class="l_upLayer searchPopup [ _overLayer _searchLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox m_searching__area [ _overLayer__box ]">

      <div class="m_searchPopup__header">
        <button class="m_searchPopup__close [ _overLayer__close ]" @click="closePopup('noname')"><img src="http://img.sportsdiary.co.kr/images/SD/icon/popup_x_@3x.png" alt="닫기"></button>
      </div>

      <div class="l_upLayer__wrapCont m_searchPopup__cont [ _overLayer__wrap ]">
        <div class="m_searchPopup__control">
          <input type="text" v-bind:placeholder="placeholder" class="m_searchPopup__input s_only [ _searchingInput ]" v-model="keyword" v-on:input="keyword=$event.target.value" @keyup="inputKeyup">
          <button type="button" class="m_searchPopup__submit [ _searching ]" @click="popupSearchOption"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt="조회"></button>
        </div>

        <div class="m_searchPopup__panelWrap [ _sliderWrap ] s_filtering">
          <div class="m_searchPopup__panel [ _panelGamemovieList ]">
            <div v-if="keyword!='' && search_list!='nodata'">
              nodata ? {{nokeyword}}
              {{search_list.length}}
              <button class="m_searchPopup__listname s_only [ _searchName ]" v-for="(stxt,key) in search_list" @click="popupSearchChoice(stxt.title,stxt.gno)">{{stxt.title}}<span class="icon__search_add"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_add_@3x.png"></span></button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- // search popup -->

  <!-- gameDetail popup -->
  <div class="l_upLayer gameDetailPopup [ _overLayer _searchLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox [ _overLayer__box ]">

      <div class="m_roundLayer__header">
        <button class="m_roundLayer__close [ _overLayer__close ]" @click="closePopup"><img src="http://img.sportsdiary.co.kr/images/SD/icon/popup_x_@3x.png" alt="닫기"></button>
      </div>
      
      <div class="m_roundLayer__content [ _overLayer__wrap ]">
        <div class="gameHeader">
          <div class="gameHeader__txts">
            <p class="gameHeader__header"><span class="gameDetail__order">{{player_list.no}}</span> <span class="gameHeader__time">{{player_list.time}}</span></p>
            <p class="gameHeader__title">{{player_list.title}}</p>
          </div>
          <button class="gameHeader__refresh" @click="refreshPlayerList">새로고침<span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/settings_backup_restore_@3x.png" alt=""></span></button>
        </div>

        <div class="gameBoard__wrap">
          <div class="m_loadingbar" v-if="loading_pop" v-bind:class="{m_dflex: loading_pop}">
            <div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt=""></div>
          </div>
          <div v-else>
            <div class="m_loadingbar" v-if="refresh_player_list" v-bind:class="{m_dflex: refresh_player_list}">
              <div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt=""></div>
            </div>
            <ul v-if="!loading_pop" class="gameBoard" v-bind:class="{s_refresh: refresh_player_list}">
              <li class="gameBoard__item" v-for="(player,key) in player_list.list" v-bind:class="{s_notice: player.name=='공지사항', s_gubun:player.gubun=='1'}">
                <p class="gameBoard__header">
                  <span class="gameBoard__index" v-if="player.name!='공지사항'">{{player.no}}</span>
                  <span class="gameBoard__txt"><span class="gameBoard__time" v-if="player.event!='장애물'">{{player.time}}</span> <span v-bind:class="highlightTxt(player.name)">{{player.name=="공지사항"? player.txt : player.name}}</span></span>
                  <span class="gameBoard__status" v-bind:class="playerPopClass(player.status)" v-if="player.name!='공지사항'">{{playerStatus(player.status)}}</span>
                </p>
                <p class="gameBoard__subTxt"><span>{{player.gubun=='1'? player.txt : player.div}}</span></p>
  
                <div class="recordTable__wrap" v-bind:class="{on: key==showtableno}" v-if="player.tabletype!=''">
                  <div class="recordTable">
                    <table>
                      <thead>
                        <th colspan="3">{{playerGameRestart(player.name)}} 심사</th>
                      </thead>
                      <tbody>
                        <tr v-if="player.tabletype=='MA'" v-for="(matable,key2) in player.tableinfo[0].judge">
                          <td v-if="key2==0" v-bind:rowspan="player.tableinfo[0].judge.length" class="s_gray1">심판 지점</td>
                          <td class="s_gray2 s_border">{{matable.location}}</td>
                          <td>{{matable.grade}}</td>
                        </tr>
  
                        <tr v-if="player.tabletype=='A'">
                          <td colspan="2" class="s_gray2 s_border">소요시간</td>
                          <td>{{player.tableinfo[0].timeall}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='A'">
                          <td colspan="2" class="s_gray2 s_border">시간감점</td>
                          <td>{{player.tableinfo[0].timeminus}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='A'">
                          <td colspan="2" class="s_gray2 s_border">장애감점</td>
                          <td>{{player.tableinfo[0].disminus}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='A'">
                          <td colspan="2" class="s_gray3">감점합계</td>
                          <td>{{player.tableinfo[0].minusall}}</td>
                        </tr>
  
                        <tr v-if="player.tabletype=='2P'">
                          <td rowspan="4" class="s_gray1 bd">1단계</td>
                          <td colspan="2" class="s_gray2 s_border">소요시간</td>
                          <td>{{player.tableinfo[0].timeall1}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='2P'">
                          <td colspan="2" class="s_gray2 s_border">시간감점</td>
                          <td>{{player.tableinfo[0].timeminus1}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='2P'">
                          <td colspan="2" class="s_gray2 s_border">장애감점</td>
                          <td>{{player.tableinfo[0].disminus1}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='2P'">
                          <td colspan="2" class="s_gray3">감점합계</td>
                          <td>{{player.tableinfo[0].minusall1}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='2P'">
                          <td rowspan="4" class="s_gray1">2단계</td>
                          <td colspan="2" class="s_gray2 s_border">소요시간</td>
                          <td>{{player.tableinfo[0].timeall2}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='2P'">
                          <td colspan="2" class="s_gray2 s_border">시간감점</td>
                          <td>{{player.tableinfo[0].timeminus2}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='2P'">
                          <td colspan="2" class="s_gray2 s_border">장애감점</td>
                          <td>{{player.tableinfo[0].disminus2}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='2P'">
                          <td colspan="2" class="s_gray3">감점합계</td>
                          <td>{{player.tableinfo[0].minusall2}}</td>
                        </tr>
  
                        <tr v-if="player.tabletype=='C'">
                          <td colspan="2" class="s_gray2 s_border">소요시간</td>
                          <td>{{player.tableinfo[0].timeall}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='C'">
                          <td colspan="2" class="s_gray2 s_border">벌초</td>
                          <td>{{player.tableinfo[0].minustime}}</td>
                        </tr>
                        <tr v-if="player.tabletype=='C'">
                          <td colspan="2" class="s_gray3">총 소요시간</td>
                          <td>{{player.tableinfo[0].totaltime}}</td>
                        </tr>
  
                        <tr v-if="player.tabletype=='MA' || player.tabletype=='MB'">
                          <td colspan="2" class="s_gray3">총비율</td>
                          <td>{{player.tableinfo[0].judgeall}}</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                  <div class="recordTable">
                    <table>
                      <thead>
                        <th colspan="3">{{playerGameRestart(player.name)}} 실시간</th>
                      </thead>
                      <tbody>
                        <tr>
                          <td rowspan="2" class="s_gray1">순위</td>
                          <td class="s_gray2 s_border">부별</td>
                          <td>{{Number(player.tableinfo[0].rankingpart)<0?'-':player.tableinfo[0].rankingpart}}</td>
                        </tr>
                        <tr>
                          <td class="s_gray2">전체</td>
                          <td>{{Number(player.tableinfo[0].rankingall)<0?'-':player.tableinfo[0].rankingall}}</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
  
                <button class="gameBoard__btn" v-bind:class="{on: key==showtableno}" v-if="player.status=='경기종료' || player.status=='E' || player.status=='R'" @click="showRecord(key)">
                  <span v-if="key!=showtableno" class="gameBoard__btnRank">{{Number(player.tableinfo[0].rankingall)<1?'-':player.tableinfo[0].rankingall+'위'}}</span>
                  <span class="gameBoard__btnTxt">기록 
                    <img v-if="key==showtableno" src="http://img.sportsdiary.co.kr/images/SD/icon/arrow_down_@3x.png" class="gameBoard__btnIcon "/>
                    <img v-else src="http://img.sportsdiary.co.kr/images/SD/icon/arrow_down_white_@3x.png" class="gameBoard__btnIcon "/>
                  </span>
                </button>
                <button class="gameBoard__btn" v-if="player.status=='경기예정'" @click="giveUp(player.time, player.event, [player.name, player.div])"><span class="gameBoard__btnTxt">기권 신청</span></button>
                <button class="gameBoard__btn" v-if="player.status=='W'" @click="giveupCancel(player.status)"><span class="gameBoard__btnTxt">기권 취소</span></button>
              </li>
  
            </ul>
          </div>
        </div>

      </div>
    </div>
  </div>
  <!-- // gameDetail popup -->

  <!-- giveup popup -->
  <div class="l_upLayer giveupPopup [ _overLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox l_riding__pop [ _overLayer__box ]">
      <div class="l_upLayer__wrapTit">
        <h1 class="l_upLayer__tit popupHeader [ _overLayer__title ]">경기기권신청</h1>
        <button class="l_upLayer__close [ _overLayer__close ]" @click="closePopup('secondpop')">닫기</button>
      </div>
      <div class="l_upLayer__wrapCont popupContent [ _overLayer__wrap ]">
        <!-- <p v-if="loading">loading...</p> -->
        <div class="l_popinfo__top">
          <p class="l_popinfo__title">{{player_list.no}} {{player_list.title}} {{giveup_popinfo[0]}} {{giveup_popinfo[1]}}</p>
        </div>

        <div class="l_popinfo__content">
          <p class="giveupInfo">
            상기 종목에 대하여 기권을 신청합니다.<br><br>
            또한, 기권시 발생하는 모든 결과에 대해서 책임질 것을 서약합니다.<br><br>
            기권 신청후 신청 취소는 전체경기 시작 전 마장마술(2시간) / 장애물(1시간) 전까지 신청 가능합니다.<br><br>
            또한, 심판에게 사유서 미제출시 불이익이 발생할 수 있습니다.
          </p>
          <div class="m_layerBtns">
            <button class="m_layerBtn s_cancel" @click="closePopup('secondpop')">취소</button>
            <button class="m_layerBtn s_confirm" @click="giveupOk">확인</button>
          </div>
        </div>

      </div>
    </div>
  </div>
  <!-- // giveup popup -->


  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->

</div>
<script>
  axios.defaults.headers.get["Cache-Control"]="no-cache";// 뒤로가기로 돌아온 화면에서 axios가 캐시 지우고 다시 로딩
  let app=new Vue({
    el:"#app",
    data:{
      game_title:"",// 대회명
      game_top_info:[],// 경기 현황판
      status_rotate_no:0,// 현황판 몇 번 돌렸나?
      status_rotate:null,// 현황판 돌리는 클래스

      game_delay_time:120000,// 현황판 없을 때 파일 불러와보는 시간
      game_delay_ori:60000,// 처음 현황판 갱신 시간
      game_delay:60000,// 현황판 갱신 시간
      game_now:null,//
      game_auto_refresh:undefined,// 경기 현황판 자동새로고침

      refresh_player_list:false,// 일정에서 경기 선택해서 나온 팝업에서 새로 고침

      game_day:[],// 경기 날짜들
      game_day_cur:null,// 오늘 날짜
      game_day_show:[],// 보여지는 날짜들
      game_schedule:[],// 경기 일정
      game_day_active_no:undefined,// 오늘 선택

      search_list:[],// 검색되는 목록
      search_txt:"",// 검색하고 선택된 단어
      keyword:"",// 검색어
      nokeyword:true,// 검색어가 없을 때(true)
      layer:undefined,// 팝업
      layer2:undefined,// 팝업2
      placeholder:"선수명, 마명을 입력하세요.",

      player_list:[],// 경기에 참가하는 선수 목록
      showtableno:undefined,// 경기종료된 선수의 기록 목록 번호
      giveup_popinfo:[],// 기권 신청하는 선수 정보
      gnos:undefined,// 검색한 사람(들)의 경기날짜

      loading_days:false,
      loading_pop:false,

      yy:null,// 연
      mm:null,// 월
      dd:null,// 일
      tidx:136,//
      gnoval:[],// 일정에서 경기 선택해서 나온 팝업에서 새로 고침할 때 사용되는 값이 저장되는 곳
      fei_238_2_2:false,// 장애물 FEI 238.2.2 인지 확인


      name:null,
      grade:"일반",
      login_chk:false,// 로그인여부
    },
    computed:{},
    methods:{
      placeholderChange:function(txt){
        this.placeholder=txt;
      },
      // 대회명
      gameTitle:function(){
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63000","tidx":"'+this.tidx+'"}').then(response=>{
          this.game_title=response.data.jlist[0].title;
          if(this.game_title==undefined){
            location.href="../main/index.asp";
          }
        },(error)=>{
          console.log("error. gameTitle");
          console.log(error);
        });
      },
      // 경기 현황판
      gameStatus:function(){
        // 돌리기
        if(this.status_rotate_no>0){
          this.status_rotate="on";
        }

        // let temp_no=Math.floor(Math.random()*4);// 확인용##################
        // axios.get("testMatch_top_"+(temp_no+1)+".html?"+Number(new Date())).then(response=>{//Number(new Date())는 cache 방지용
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63500","tidx":"'+this.tidx+'"}').then(response=>{
          this.game_top_info=response.data.jlist[0];
          // 돌리기 전 상태로
          setTimeout(()=>{
            if(this.status_rotate_no>0){
              this.status_rotate="s_notran";
            }
          },230);
        },(error)=>{
          console.log("error. gameTitle");
          console.log(error);
        });
        //
        this.status_rotate_no=this.status_rotate_no+1;

      },
      // 경기 현황판 다시 로드
      gameStatusRefresh:function(){
        // 돌아가는 도중엔 클릭 안되게
        if(this.status_rotate!="on"){
          this.gameStatus();
          cancelAnimationFrame(this.game_auto_refresh);
          this.game_auto_refresh=requestAnimationFrame(function(){app.gameStatusAutoRefresh()});
          if(this.game_top_info.status!=""){
            this.game_delay=this.game_delay_ori;
          }else{
            this.game_delay=this.game_delay_time;
          }
        }
      },
      // 경기 현황판 자동 새로고침
      gameStatusAutoRefresh:function(next){
        this.game_now=new Date().getTime();
        if(next==undefined) next=this.game_now+this.game_delay;
        if(this.game_now>next){
          next=this.game_now+this.game_delay;
          this.gameStatus();
        }
        if(this.game_auto_refresh!=undefined){
          cancelAnimationFrame(this.game_auto_refresh);
        }
        this.game_auto_refresh=requestAnimationFrame(function(){app.gameStatusAutoRefresh(next)});
        if(this.game_top_info.status!=""){
          this.game_delay=this.game_delay_ori;
        }else{
          this.game_delay=this.game_delay_time;
        }
      },
      // 현재 날짜 표시
      dayChoice:function(key,actno,day,md){
        if(actno==undefined){
          if(day==md){
            return true;
          }
        }else{
          if(key==actno){
            return true;
          }
        }

        // 오늘 날짜에 경기가 없으면 경기 있는 처음 날짜 표시
        if(this.game_day_cur==day && this.game_day_active_no==undefined){
          this.game_day_active_no=0;
        }
        // console.log("key:"+key+".  actno:"+actno+".  day:"+day+".  md:"+md+".  game_day_cur:"+this.game_day_cur+".      game_day_active_no : "+this.game_day_active_no);
      },
      // 경기 날짜
      gameDay:function(url,popsearch,gnos){
        this.loading_days=true;
        this.game_day=[];
        // axios.get("testMatch_day.html").then(response=>{//####
        axios.get(url).then(response=>{
          this.game_day=response.data.jlist;
          if(gnos){
            this.game_day_cur=this.game_day[0].day;
            this.game_day_active_no=0;
          }

          // 보여지는 날짜들 모아보기
          for(var i in this.game_day){
            this.game_day_show[i]=this.game_day[i].day;
          }
          this.gameSchedule(this.game_day_show[this.game_day_show.indexOf(this.mm+"/"+this.dd)], this.game_day_active_no, popsearch,gnos);
        },(error)=>{
          console.log("error. gameDay");
          console.log(error);
        });
      },
      // 경기 일정
      gameSchedule:function(day,activeno, popsearch,gnos){
        // console.log("day : "+day+"    game_day_active_no : "+this.game_day_active_no+"    game_day_cur : "+this.game_day_cur);

        cancelAnimationFrame(this.game_auto_refresh);
        this.game_auto_refresh=requestAnimationFrame(function(){app.gameStatusAutoRefresh()});

        // 처음 불러올 때. ex) 오늘이 3월 25일인데 데이터가 3월 20일만 있는걸 불러오게 될 때, 3월 20일이 선택되어지게...
        if(day==undefined){
          day=this.game_day_show[0];
          this.game_day_active_no=0;
        }

        let url;
        // 검색한 선수명, 마명의 목록
        if(popsearch=="popsearch"){
          url='http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63100","tidx":"'+this.tidx+'","gno":"'+gnos+'"}';
          
          axios.get(url).then(response=>{
            this.loading_days=false;
            this.game_schedule=response.data.jlist;
          },(error)=>{
            console.log("error. gameSchedule. 1. : ");
            console.log(error);
          });
        }
        // 오늘 날짜가 아니면 처음거
        else{
          // 같은날짜 클릭안되게
          if(this.game_day_cur!=day){
            //
            this.game_day_active_no=activeno;
            this.loading_days=true;
            this.game_schedule=[];
            // axios.get("testMatch_1.html").then(response=>{//####
            // axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63100","tidx":"'+this.tidx+'","getDate":"2019-03-20"}').then(response=>{
            if(this.gnos==undefined) this.gnos="";
            // if(this.game_day_cur==null){
            //   url='http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63100","tidx":"'+this.tidx+'"}';
            // }else{
              url='http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63100","tidx":"'+this.tidx+'","getDate":"'+(this.yy+'-'+day.split('/')[0]+'-'+day.split('/')[1])+'","gno":"'+this.gnos+'"}';
            // }
            this.game_day_cur=day;
          
            axios.get(url).then(response=>{
              this.loading_days=false;
              this.game_schedule=response.data.jlist;
            },(error)=>{
              console.log("error. gameSchedule. 2. : ");
              console.log(error);
            });
          }
        }
      },

      // popup
      openSearching:function(popdiv,etc){
        if(etc!=undefined){
          if(etc[0]=="playerlist"){
            // this.loadPlayerList("testMatchPlayerlist_1.html?"+Number(new Date()));
            // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63400","tidx":"136","gno":"1"}
            this.gnoval=etc[1];
            this.loadPlayerList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63400","tidx":"'+this.tidx+'","gno":"'+etc[1]+'"}');
          }
        }

        //
        console.log(popdiv);
        if(popdiv==".gameDetailPopup" || popdiv==".searchPopup"){
          this.layer=new OverLayer({
            overLayer:$(popdiv),
            emptyHTML:"정보를 불러오고 있습니다.",
            errorHTML:"",
          });
          this.layer.on("beforeOpen",function(){
            history.pushState("list2", null, null)
          });
          history.replaceState("list2", null, null);
          // this.layer.on("beforeClose",function(){
          //   // history.pushState("list", null, null)
          //   history.replaceState("list2", null, null);
          // });
          // history.replaceState("list", null, null);
          this.layer.open();
        }else if(popdiv==".giveupPopup"){
          this.layer2=new OverLayer({
            overLayer:$(popdiv),
            emptyHTML:"정보를 불러오고 있습니다.",
            errorHTML:"",
          });
          this.layer2.on("beforeOpen",function(){
            history.pushState("list3", null, null)
          });
          history.replaceState("list3", null, null);
          // this.layer2.on("beforeClose",function(){
          //   // history.pushState("list1", null, null);
          //   history.replaceState("list3", null, null);
          // });
          // history.replaceState("list", null, null);
          this.layer2.open();
        }
        // console.log("=========="+this.layer.status+"_   window.history.state : "+window.history.state);
      },
      // 팝업 닫을 때
      closePopup:function(txt){
        if(txt=="secondpop"){
          this.layer2.on("beforeClose",function(){
            history.pushState("list22", null, null)
          });
          history.replaceState("list2", null, null);
          this.layer2.close();
        }else{
          this.layer.close();
        }

        if(txt=="noname"){
          this.keyword="";
        }else{
          this.showtableno=undefined;// 팝업 닫을 때 경기 종료된 선수의 기록이 열려 있을 경우 닫히게
        }
      },

      //검색버튼 누를 때 선택된 내용이 화면에 보여지게
      popupSearchOption:function(){
        this.placeholderChange(this.keyword);

        if(this.nokeyword){
          this.keyword="";
          alert("입력한 선수명 또는 마명이 없습니다.");
        }else{
          if(this.keyword===""){
            // alert("선수명 또는 마명을 입력하세요.");
            this.gnos=undefined;
            this.game_day_cur=null;
            this.game_day_active_no=0;
            this.gameDay('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63200","tidx":"'+this.tidx+'"}');
          }else{
            // 검색어에 맞는 경기가 여러개 일 때. 해당값을 "gno":"1,21,3,44"... 이렇게 보냄
            if(this.keyword.length<2){
              this.keyword="";
              alert("검색어는 최소 2글자 이상 입력해주세요.");
              return;
            }else{
              let gnoall="";
              for(len in this.search_list){
                gnoall=gnoall+(this.search_list[len].gno)+",";
              }
              this.gnos=gnoall.substr(0,gnoall.lastIndexOf(","));
              this.gameDay('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63200","tidx":"'+this.tidx+'","gno":"'+this.gnos+'"}', "popsearch", gnoall.substr(0,gnoall.lastIndexOf(",")));
            }
          }
          //this.game_day_active_no=undefined;////////////////////////////////

          this.search_txt=this.keyword;
          this.layer.close();
          this.keyword="";// 검색 후 그대로 보이게 해달래서
        }
      },
      // 검색어 검색
      searchList:function(url){
        this.search_list=[];
        this.nokeyword=true;
        axios.get(url).then(response=>{
          this.search_list=response.data.jlist;
          if(this.search_list!="nodata"){
            this.nokeyword=false;
          }
        },(error)=>{
          console.log("error. searchList :")
          console.log(error);
        });
      },
      // 텍스트 입력
      inputKeyup:function(e){
        // v-model="keyword" 대신 v-on:input="keyword==$event.target.value" 사용함. IME를 요구하는 언어가 제대로 업데이트 되기 위해서.
        if(e.keyCode===13){
          this.popupSearchOption();
          e.target.blur();
        }else if(e.keyCode!==13){
          // 검색어를 적다가 지워서 값이 없으면("") 전체가 보여지기 때문에
          if(this.keyword==" ") this.keyword="";
          if(this.keyword!=""){
            this.searchList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63300","tidx":"'+this.tidx+'","searchtxt":"'+this.keyword+'"}');
          }
        }
      },
      // 미리보기 단어 선택
      popupSearchChoice:function(txt,gno){
        this.placeholderChange(txt);

        this.layer.close();
        this.search_txt=txt;
        this.keyword="";// 검색 후 그대로 보이게 해달래서
        // this.keyword=txt;// 검색 후 그대로 보이게 해달래서

        this.gameDay('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63200","tidx":"'+this.tidx+'","gno":"'+gno+'"}', "popsearch", gno);
        this.search_list=[];
      },

      // 일정에서 경기 선택 시
      loadPlayerList:function(url){
        this.loading_pop=true;
        this.player_list=[];
        axios.get(url).then(response=>{
          this.loading_pop=false;
          this.refresh_player_list=false;
          this.player_list=response.data.jlist[0];

          // 장애물 FEI 238.2.2 인지 확인
          if(this.player_list.title.replace(/ /g,"").match("FEI238.2.2")!=null){
            this.fei_238_2_2=true;
          }else{
            this.fei_238_2_2=false;
          }
        },(error)=>{
          console.log("error. loadPlayerList");
          console.log(error);
        });
      },
      // 일정에서 경기 선택해서 나온 팝업에서 새로 고침
      refreshPlayerList:function(){
        this.showtableno=undefined;
        this.refresh_player_list=true;
        setTimeout(()=>{
          this.loadPlayerList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63400","tidx":"'+this.tidx+'","gno":"'+this.gnoval+'"}');
        },350);
      },

      // 검색된 이름
      highlightTxt:function(name){
        if(name!=undefined){
          let txt=name.replace(/ \/ /g,''),
              stxt=this.search_txt.replace(/ : /g,''),
              cls=txt.match(stxt)!=null && this.search_txt!='' ? "s_searching" : "";
          return cls;
        }
      },
    
      // 선수 상태
      playerPopClass:function(txt){
        let cls;
        if(txt=="경기예정"){
          cls="s_schedule";
        }else if(txt=="경기종료"){
          cls="s_giveup";
        }else if(txt=="경기중"){
          cls="s_ing";
        }else if(txt=="E"){
          cls="s_giveup_e";
        }else if(txt=="W" || txt=="R"){
          cls="s_giveup_rw";
        }else if(txt=="D"){
          cls="s_giveup_d";
        }
        return cls;
      },
      playerStatus:function(txt){
        let tle;// 기권(W):경기전,  기권(R):진행중,  실권(E),  실격(D)
        if(txt=="E") tle="실권(E)";
        else if(txt=="D") tle="실격(D)";
        else if(txt=="W") tle="기권(W)";
        else if(txt=="R") tle="기권(R)";
        else tle=txt;
        return tle;
      },
      // 1경기, 2경기, 재경기, 결승
      playerGameRestart:function(txt){
        // player.name.indexOf("재경기")>-1?'재경기':''
        let prevTxt="";
        if(txt.indexOf("1경기")>-1){
          prevTxt="1경기";
        }else if(txt.indexOf("2경기")>-1){
          prevTxt="2경기";
        }else if(txt.indexOf("재경기")>-1){
          prevTxt="재경기";
        }else if(txt.indexOf("결승")>-1){
          prevTxt="결승";
        }else{
          prevTxt="";
          this.fei_238_2_2? prevTxt="본경기" : "";
        }
        return prevTxt;
      },
      // 기록 보기
      showRecord:function(keyno){
        if(this.showtableno==keyno){
          this.showtableno=undefined;
        }else{
          this.showtableno=keyno;
        }
      },
      // 기권 신청
      giveUp:function(time,evt,giveupinfo){
        let h=time.split(":")[0], m=time.split(":")[1],
            game_time=Number(h)*60+Number(m),// 경기 시간
            cur_time=(new Date().getHours()*60)+new Date().getMinutes(),// 현재 시간
            game_time60=game_time-60,// 현재 시간에서 1시간 전(장애물)
            game_time120=game_time-120;// 현재 시간에서 2시간 전(마장마술)
        // console.log("gametime : "+game_time+"______curtime : "+cur_time+"_____ gametime60 : "+game_time60+"_____ gametime120 : "+game_time120);

        // 2시간전
        if(evt=="마장마술"){
          if(game_time>cur_time){
            if(cur_time>=game_time120){
              alert("경기시작 2시간 전까지만 기권 신청 및 취소 신청이 가능합니다.\n기권 및 기권취소를 원하시면 현장에 문의해주시기 바랍니다.")
            }else{
              this.openSearching(".giveupPopup");
            }
          }else{
            console.log("마장마술 경기시간 지남");
          }
        }
        // 1시간전
        else if(evt=="장애물"){
          if(game_time>cur_time){
            if(cur_time>=game_time60){
              alert("경기시작 1시간 전까지만 기권 신청이 가능합니다.\n기권을 원하시면 현장에 문의해 주시기 바랍니다.")
            }else{
              this.openSearching(".giveupPopup");
            }
          }else{
            console.log("장애물 경기시간 지남");
          }
        }
        // 기권한 선수 정보(이름/말이름, 소속)
        if(giveupinfo!=undefined){
          this.giveup_popinfo=giveupinfo;
        }
      },
      // 기권 신청 확인
      giveupOk:function(){
        // let form=new FormData();
        // form.append("id",this.userID);
        // form.append("pwd",this.userPwd);
        // axios.post(url, form).then(response=>{
        //   console.log("response : "+JSON.stringify(response, null, 2));
        // }).catch(error=>{
        //   console.log("failed : "+error);
        // });

        this.layer2.on("beforeClose",function(){
          history.pushState("list22", null, null)
        });
        history.replaceState("list2", null, null);
        
        let giveupchk=confirm("기권 신청후 신청 취소는 전체경기 시작 전 마장마술(2시간) / 장애물(1시간) 전까지 신청 가능합니다.");
        if(giveupchk==true){
          console.log("기권 신청 확인. 넘기는 값?이 있어야 할듯?");
          this.layer2.close();
        }else{
          this.layer2.close();
        }
      },
      // 기권 취소
      giveupCancel:function(status){
        // 기권(W):경기전,  기권(R):진행중,  실권(E),  실격(D)
        console.log("기권 취소. 넘기는 값?이 있어야 할듯??");
      },
    },
    created:function(){
      if(navigator.userAgent.indexOf("isAppVer")>0){
        document.body.classList.add("webview");
      }

      let now=new Date();
      this.yy=now.getFullYear();
      this.mm=(now.getMonth()+1)>9? now.getMonth()+1 : "0"+(now.getMonth()+1);
      this.dd=now.getDate()>9? now.getDate() : "0"+now.getDate();

      // 위에서 tidx는 지정한 이유는, 이 파일을 바로 열었을 때의 확인용 값
      let urlparam_tidx=location.href.indexOf("tidx=");
      if(urlparam_tidx>0){
        let param_tidx=location.href.substr(urlparam_tidx+5);// +5는 t i d x = 다음의 위치
        this.tidx=param_tidx;
      }
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }

      let referrer=document.referrer || "./match-sch.asp";
      // let referrer=location.href || "./match-sch.asp";
      // history.replaceState("list", null, null);
      history.replaceState("list2", null, null);
      window.onpopstate=(evt)=>{
        console.log("location: " + document.location + ", state: " + JSON.stringify(evt.state)+",  window history state : "+history.state);
        if(history.state=="list2"){
          this.layer.close();
          console.log("layer close");
        }else if(history.state=="list3"){
          this.layer2.close();
          console.log("layer2 close");
        }else{
          location.href=referrer;
        }
      }
      // this.layer=new OverLayer({
      // //   // overLayer:$(popdiv),
      // //   // emptyHTML:"정보를 불러오고 있습니다.",
      // //   // errorHTML:"",
      // });
      // this.layer.on("beforeOpen",function(){history.pushState("view", null, null)});
      // this.layer.on("beforeClose",function(){history.pushState("list", null, null)});
      

      this.gameTitle();// 대회명
      this.gameStatus();// 경기 현황판
      this.gameStatusAutoRefresh();
      this.gameDay('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63200","tidx":"'+this.tidx+'"}');// 경기 날짜
    },
  });
</script>
</body>
</html>
<!-- <% 'AD_DBClose() %> -->
