<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.sw.asp" -->

   <link rel="stylesheet" href="http://sdmain.sportsdiary.co.kr/sdmain/css/library/swiper.min.css">
   <script src="http://sdmain.sportsdiary.co.kr/sdmain/js/library/swiper.min.js"></script>
</head>
<body <%=CONST_BODY%>>

<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>


<div id="app" class="l riding" v-cloak>

  <!-- #include virtual = "/include/gnb.asp" -->
  <div class="l_header">
    <div class="m_header">
      <!-- #include virtual = "/include/header_back.asp" -->
      <a href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp" class="m_header__logo">
        <img src="http://img.sportsdiary.co.kr//images/SD/logo/logo_@3x.png" class="m_header__logoImg" alt="스포츠다이어리">
      </a>
      <a class="m_header__gnbBtn [ _btnMenuOpen ]">메뉴</a>
    </div>
    <div class="m_mainTab">
      <ul>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('badminton');" class="m_mainTab__rink">배드민턴</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('judo');" class="m_mainTab__rink">유도</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('tennis');" class="m_mainTab__rink">테니스</a> </li>
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('riding');" class="m_mainTab__rink">승마</a> </li>
        <!-- <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('bike');" class="m_mainTab__rink">자전거</a> </li> -->
        <li class="m_mainTab__item"><a href="javascript:chk_TOPMenu_URL('swim');" class="m_mainTab__rink s_active">수영</a> </li>
      </ul>
    </div>
  </div>


  <div class="l_content m_scroll indexpage [ _content _scroll ] ">

    <!-- 대회일정/결과 -->
    <div class="m_board">
      <h3 class="m_board__tit">대회일정/결과<a href="../Result/institute-search.asp" class="m_board__calBtn" v-if="gameinfo_list!='nodata'">캘린더보기</a></h3>

      <!-- s_apply : 신청중,  s_dday : d-14,  s_ing : 경기중,  s_end : 경기완료 -->
      <div class="m_schedule__wrap" v-bind:class="{nodata: gameinfo_list=='nodata'}">
        <div v-if="gameinfo_list!='nodata'">
          <button v-for="(info,key) in gameinfo_list" @click="openPopup(info.id,info.poplink)" class="m_schedule__pop">
            <span class="m_schedule__info" v-bind:class="info.class">{{info.status}}<em v-if="info.status=='D-'">{{dDay(info.dday)}}</em></span>
            <p class="m_schedule__txt">{{info.title}}</p>
          </button>
        </div>
      </div>
    </div>
    <!-- // 대회일정/결과 -->

    <!-- 경기기록실 -->
    <div class="m_board">
       <h3 class="m_board__tit">경기기록실</h3>
       <div class="m_board__con">
          <button @click="openSearching('.searchPopup')" type="button">선수 조회</button>
          <button type="button" onclick="px.goSubmit({},'/Result/gamesin.asp');">신기록 보기</button>
       </div>

    </div>
    <!-- // 선수조회 -->



  <!-- search popup. 검색버튼 눌렀을 때 팝업 -->
  <div class="l_upLayer searchPopup t_test [ _overLayer _searchLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox m_searching__area [ _overLayer__box ]">

      <div class="m_searchPopup__header">
        <button class="m_searchPopup__close [ _overLayer__close ]" @click="closePopup('noname')"><img src="http://img.sportsdiary.co.kr/images/SD/icon/popup_x_@3x.png" alt="닫기"></button>
      </div>

      <div class="l_upLayer__wrapCont m_searchPopup__cont [ _overLayer__wrap ]">
        <div class="m_searchPopup__control">

			<!-- 검색어 입력하면 -->
          <input type="text" v-bind:placeholder="placeholder" class="m_searchPopup__input s_only [ _searchingInput ]" v-model="keyword" v-on:input="keyword=$event.target.value" @keyup="inputKeyup">
        </div>

        <div class="m_searchPopup__panelWrap [ _sliderWrap ] s_filtering">
          <div class="m_searchPopup__panel [ _panelGamemovieList ]">
              <!-- 해당 검색어가 포한된 선수명 나오는 부분 -->
            <div v-if="keyword!='' && search_list!='nodata'">
              <button class="m_searchPopup__listname s_only [ _searchName ]" v-for="(stxt,key) in search_list" @click="popupSearchChoice(stxt.title,stxt.pidx)">{{stxt.title}}<span class="icon__search_add"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_add_@3x.png"></span></button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- // search popup -->


  <!-- search popup -->
  <div class="l_upLayer [ _overLayer2 ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox l_riding__pop [ _overLayer__box ]">
      <div class="l_upLayer__wrapTit">
        <h1 class="l_upLayer__tit [ _overLayer__title ]">대회정보</h1>
        <button class="l_upLayer__close [ _overLayer__close ]" @click="closePopup">닫기</button>
      </div>
      <div class="l_upLayer__wrapCont [ _overLayer__wrap ]">


		<div class="m_loadingbar" v-if="loading" v-bind:class="{m_dflex: loading}">
          <div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt=""></div>
        </div>

		<div v-else>

		  <div class="l_popinfo__top">
            <p class="l_popinfo__title">{{popinfo_list.title}}</p>
            <p class="l_popinfo__titlecmt">{{popinfo_list.title_day}}</p>
          </div>
          <div class="l_popinfo__content">
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_loca"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/place_@3x.png" alt="장소"></span> 장소</p>
              <p class="l_popinfo__cmt">{{popinfo_list.location}}</p>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/host_@3x.png" alt="주최"></span> 주최</p>
              <p class="l_popinfo__cmt">
                <span>{{popinfo_list.host}}</span>
              </p>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/host_@3x.png" alt="주관"></span> 주관</p>
              <p class="l_popinfo__cmt">
                <span >{{popinfo_list.superviser}}</span>
              </p>
            </div>
            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/host_@3x.png" alt="후원"></span> 후원</p>
              <p class="l_popinfo__cmt">
                <span>{{popinfo_list.sponsor}}</span>
              </p>
            </div>

            <div class="l_popinfo__wrap">
              <p class="l_popinfo__txt icon_hss"><span class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/apply_@3x.png" alt="경기종목"></span> 경기종목</p>
              <p class="l_popinfo__cmt">
                <span>{{popinfo_list.cdanm}}</span>
              </p>
            </div>
            <div class="l_popinfo__links">
              <a class="l_popinfo__link" @click="poplink('contestinfo','',popinfo_list.tidx)">대회일정</a>
              <a class="l_popinfo__link" v-if="popinfo_list.attyn=='Y'" @click="poplink('attinfo','',popinfo_list.tidx)">참가신청 현황</a>
              <a class="l_popinfo__link" v-if="popinfo_list.matchyn=='Y'" @click="poplink('match','',popinfo_list.tidx)">대진표</a>
              <a class="l_popinfo__link" v-if="popinfo_list.matchyn=='Y'" @click="poplink('gameorder','',popinfo_list.tidx)">경기순서</a>
              <a class="l_popinfo__link" v-if="popinfo_list.matchyn=='Y'" @click="poplink('gameresult','',popinfo_list.tidx)">대회결과/신기록</a>
            </div>
            <div class="l_popinfo__footer">
               <h2>재정후원</h2>
               <ul class="l_popinfo__footer__logo-list">
                  <li>
                     <a href="https://www.mcst.go.kr/kor/main.jsp" target="_blank">
                        <img src="http://img.sportsdiary.co.kr/images/SD/logo/swimming/popup_logo_01.svg?ver=0.0.1" alt="문화체육관광부">
                     </a>
                  </li>
                  <li>
                     <a href="https://www.kspo.or.kr/kspo/main/main.do" target="_blank">
                        <img src="http://img.sportsdiary.co.kr/images/SD/logo/swimming/popup_logo_02.svg?ver=0.0.1" alt="국민체육진흥공단">
                     </a>
                  </li>
                  <li>
                     <a href="https://www.sports.or.kr/index.do" target="_blank">
                        <img src="http://img.sportsdiary.co.kr/images/SD/logo/swimming/popup_logo_03.svg?ver=0.0.1" alt="대한체육회">
                     </a>
                  </li>
               </ul>
               <span>본 사업은 문화체육관광부, 국민체육진흥공단, 대한체육회의 재정후원을 받고 있습니다.</span>
            </div>

          </div>


        </div>
      </div>
    </div>
  </div>
  <!-- // search popup -->


<%If Request.ServerVariables("REMOTE_ADDR") = "112.187.195.132" then%>
<!-- <a href="https://sw.sportsdiary.co.kr/pub/exer/share.asp">공유기능</a> -->
<%End if%>



    <!-- #include virtual = "/include/footer.asp" -->
  </div>
</div>








<script>
	//axios ajax 를 손쉽게 제어하는 라이브러리
	//swiper 슬라이더 라이브러리
  axios.defaults.headers.get["Cache-Control"]="no-cache";// 뒤로가기로 돌아온 화면에서 axios가 캐시 지우고 다시 로딩
  var app=new Vue({
    el:"#app",
    data:{
      reqURL : '/pub/ajax/swimming/reqMobile.asp',
	  name:null,
      grade:"일반",
      login_chk:false,// 로그인여부

      loading:false,// data불러왔는지 유무
      gameinfo_list:[],// 대회일정/결과
      gamevideo_list:[],// 경기영상
      fieldsketch_list:[],// 현장스케치
      popinfo_list:[],// 팝업 내용

      // 현장스케치 이미지 맞게 찾아가려고. 경기가 같으면 -1-1, -1-2, 경기가 다르면 -1-1, -1-1
      imgurls:[],//
      imgurlslen:2,//

      // swiper viewer
      swiper_viewer:undefined,
      // banners
      banners:[],//
      bannerloading:false,//

      layer:null,//


      search_list:[],// 검색되는 목록
      search_txt:"",// 검색하고 선택된 단어
      keyword:"",// 검색어
      nokeyword:true,// 검색어가 없을 때(true)
      layer:undefined,// 팝업
      layer2:undefined,// 팝업2
      placeholder:"선수 이름으로 검색해주세요.",

      player_list:[],// 경기에 참가하는 선수 목록
	},
    computed:{},



	methods:{
      // 검색된 단어가 input에 placeholder로
      placeholderChange:function(txt){
        this.placeholder=txt;
      },
	  // banners
      bannerView:function(){
        this.bannerloading=true;
        axios.get("../Result/testBanner.html").then(response=>{
          this.bannerloading=false;
          this.banners=response.data.jlist[0];

          this.$nextTick(()=>{
            this.swiperSlide(this.banners.banner.length, this.banners.delaytime);
          });
        },(error)=>{
          console.log("error. bannerView.");
          console.log(error);
        }).finally(()=>{
          console.log("finally");
        });
      },
      // swiper
      swiperSlide:function(len,delaytime){
        if(len>1){
          this.swiper_viewer=new Swiper("._bannerViewer__swiper",{
            autoHeight:true,
            speed:200,
            loop:true,
            autoplay:{
              delay:delaytime,
              disableOnInteraction:false,
            },
          });
        }else{
          this.swiper_viewer=new Swiper("._bannerViewer__swiper",{
            autoHeight:true,
            speed:200,
          });
        }
      },

      // 메인
      mainData:function(){
        this.loading=true;
        this.gameinfo_list=[];
        axios.get(this.reqURL + '?req={"CMD":"50000"}').then(response=>{
          this.loading=false;
          this.gameinfo_list=response.data.jlist[0].gameinfo;
        });
      },

      // popup
      openPopup:function(tidx,poplink){
        this.popupInfoList(tidx,poplink);
        this.layer2.open();
      },
      // 팝업 닫을 때 스크롤바 위로
      closePopup:function(){
        setTimeout(()=>{
          $(".l_upLayer__wrapCont").scrollTop(0);
        },230);
      },
      // 팝업 내용
      popupInfoList:function(tidx,poplink){
        this.loading=true;
        this.popinfo_list=[];
        axios.get(this.reqURL + '?req={"CMD":"62000","tidx":"'+tidx+'","poplink":"'+poplink+'"}').then(response=>{
          this.loading=false;
          this.popinfo_list=response.data.jlist[0];
        }).catch(error=>{
          console.log("error. popupInfoList.");
          console.log(error);
        }).finally(()=>{
          console.log("finally");
        });
      },
      // video url
      videoUrl:function(url){
        return "../result/gamevideo_detail.asp?"+url;
      },
      // sketch url
      sketchUrl:function(url,key){
        this.imgurls[key]=url;
        // console.log("url : "+url+"    key : "+key+"    imgurls[0] : "+this.imgurls[0]+"    imgurls[1] : "+this.imgurls[1]);
        if(key==1 && this.imgurls[0]==this.imgurls[1]){
          return "../result/stadium_sketch_detail.asp?"+url+"-1-2";
        }
        return "../result/stadium_sketch_detail.asp?"+url+"-1-1";
      },


      // popup########################################################
		  openSearching:function(popdiv,etc){
			this.orderlist="match";

			if(etc!=undefined){
			  if(etc[0]=="playerlist"){
				this.gnoval=etc[1];
				this.game_all_title2=etc[2];
				this.loadPlayerList('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63400","tidx":"'+this.tidx+'","gno":"'+etc[1]+'"}');
			  }
			}


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
			  this.layer.open();
			}else if(popdiv==".giveupPopup"){
			  this.layer=new OverLayer({
				overLayer:$(popdiv),
				emptyHTML:"정보를 불러오고 있습니다.",
				errorHTML:"",
			  });
			  this.layer.on("beforeOpen",function(){
				history.pushState("list3", null, null)
			  });
			  history.replaceState("list3", null, null);
			  this.layer.open();
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
			  alert("입력한 선수명이 없습니다.");
			}else{
			  if(this.keyword===""){
			  }else{
				// 검색어에 맞는 경기가 여러개 일 때. 해당값을 "gno":"1,21,3,44"... 이렇게 보냄
				if(this.keyword.length<2){
				  this.keyword="";
				  alert("검색어는 최소 2글자 이상 입력해주세요.");
				  return;
				}else{
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
		  inputKeyup:_.debounce(function(e){// 0.2초(200) 간격으로 검색
			// v-model="keyword" 대신 v-on:input="keyword==$event.target.value" 사용함. IME를 요구하는 언어가 제대로 업데이트 되기 위해서.
			if(e.keyCode===13){
			  this.popupSearchOption();
			  e.target.blur();
			}else if(e.keyCode!==13){
			  // 검색어를 적다가 지워서 값이 없으면("") 전체가 보여지기 때문에
			  if(this.keyword==" ") this.keyword="";
			  if(this.keyword!=""){
				this.searchList(this.reqURL + '?req={"CMD":"63300","tidx":"'+this.tidx+'","searchtxt":"'+this.keyword+'"}');
			  }
			}
		  },200),

		  // 미리보기 단어 선택
		  popupSearchChoice:function(txt,pidx){
			px.goSubmit({'PIDX':pidx},'/record/psearch.asp');
		  },
      // popup########################################################

    },
    created:function(){
      if(navigator.userAgent.indexOf("isAppVer")>0){
        document.body.classList.add("webview");
      }

      if(window.matchMedia("(orientation:landscape)").matches){
        $("html").addClass("landscape");
      }else{
        $("html").removeClass("landscape");
      }
      window.addEventListener("orientationchange", function(){
        if(window.matchMedia("(orientation:portrait)").matches){
          $("html").addClass("landscape");
        }else{
          $("html").removeClass("landscape");
        }
      },false);
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }

      let referrer=document.referrer || "./index.asp";
      history.replaceState("list", null, null);
      window.onpopstate=(evt)=>{
        if(evt.state=="list" && this.layer.status=="open"){
          this.layer.close();
        }else{
          location.href=referrer;
        }
      }

	  this.layer2=new OverLayer({
        overLayer:$("._overLayer2"),
        emptyHTML:"정보를 불러오고 있습니다.",
        errorHTML:"",
      });
      this.layer2.on("beforeOpen",function(){history.pushState("view",null,null)});
      this.layer2.on("beforeClose",function(){history.pushState("list",null,null)});

	  this.layer=new OverLayer({
        overLayer:$("._overLayer"),
        emptyHTML:"정보를 불러오고 있습니다.",
        errorHTML:"",
      });
      this.layer.on("beforeOpen",function(){history.pushState("view",null,null)});
      this.layer.on("beforeClose",function(){history.pushState("list",null,null)});



      this.mainData();// 확인용 json
      // this.bannerView();
    },
  })
</script>


</body>
</html>
