<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->

  <link rel="stylesheet" href="http://sdmain.sportsdiary.co.kr/sdmain/css/library/swiper.min.css">
  <script src="http://sdmain.sportsdiary.co.kr/sdmain/js/library/swiper.min.js"></script>
</head>
<body>
<div id="app" class="l stadium_sketch_detail" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
  		<h1 class="m_header__tit">현장스케치</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>

    <!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>

  <!-- S: main -->
  <div class="l_content m_scroll stadium_sketch sd-main-A [ _content _scroll ]">
    <p class="m_matchTit">{{stadium_sketch_gametitle}}</p>

    <div class="sd_photo_detail">
      <div class="sd_photoViewer__swiper [ _photoViewer__swiper swiper-container  ]">
        <div class="[ swiper-wrapper ]">
            <!-- <div v-for="(imgurl,key) in sketch_detail_list" class="sd_photoViewer__slide [ swiper-slide ]">
              <img v-bind:src="imgurl" class="sd_photoViewer__img">
            </div> -->
        </div>
      </div>
      <a v-if="!appleDevice" v-bind:href="download_link" class="sd_photoViewer__download [ _download ]" download="download">다운로드</a>
      <p class="sd_photoViewer__info">* 아이폰 및 안드로이드 기종에 따라 다운로드가 일부 제한적일 수 있습니다.</p>
      <p class="sd_photoViewer__info">* 해당 이미지는 다운로드 시 고화질로 보실 수 있습니다.</p>
    </div>
  </div>
  <!-- E: main -->

	<!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</div>

<script>
  axios.defaults.headers.get["Cache-Control"]="no-cache";// 뒤로가기로 돌아온 화면에서 axios가 캐시 지우고 다시 로딩
  let app=new Vue({
    el:"#app",
    data:{
      stadium_sketch_gametitle:"",// 대회명
      title_tidx:null,//

      loading:false,// data불러왔는지 유무
      sketch_detail_list:[],// 불러온 data가 연결되는 곳
      sketch_no:0,// 현장스케치에서 선택한 이미지 번호가 연결되는 곳
      sketch_PN_page:null,//현재 불러오는 data의 페이지 수
      sketch_PN:0,// 현재 불러오는 data 파일의 번호(몇번째인지)
      sketch_PN_ori_r:0,//
      sketch_PN_ori_l:0,//
      sketch_tidx:131,//
      sketch_len:null,// 불러오는 상세 이미지가 있는 json데이터의 수
      sketch_basic_len:10,// json data 기본 개수
      list_left_end:false,// prev불러오기 끝
      list_right_end:false,// next 불러오기 끝

      // swiper viewer
      swiper_viewer:undefined,

      download_link:"",// 현재 이미지 다운로드 받는 경로
      appleDevice:false,// 애플 기기는 안됨

      
      name:null,
      grade:"일반",
      login_chk:false,// 로그인여부
    },
    computed:{},
    methods:{
      // 대회명
      gameTitle:function(){
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63000","tidx":"'+this.title_tidx+'"}').then(response=>{
          this.stadium_sketch_gametitle=response.data.jlist[0].title;
        },(error)=>{
          console.log("error. gameTitle");
          console.log(error);
        });
      },
      // 목록
      sketchDetail:function(url){
        // http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"136","PN":"4"}
        this.loading=true;
        axios.get(url).then(response=>{
          this.loading=false;

          let urls=response.data.jlist, imgs="";
          this.sketch_len=urls.length;

          // 대회명
          this.title_tidx=urls[0].tidx;
          this.gameTitle();

          //
          let div="";
          for(var i=0;i<this.sketch_len;i++){
            this.sketch_detail_list.push(urls[i].link);

            div+='<div class="sd_photoViewer__slide [ swiper-slide ]"><img src="'+urls[i].link+'" class="sd_photoViewer__img"></div>';
          }

          // swiper
          this.$nextTick(function(){
            $(".swiper-wrapper").append(div);
            this.swiperSlide();
          });
        });
      },
      // add slide
      sketchDetailAdd:function(url,pre){
        this.loading=true;
        axios.get(url).then(response=>{
          this.loading=false;

          let urls=response.data.jlist, imgs="", past_list_len;
          past_list_len=this.sketch_detail_list.length;

          let div="";
          for(var i=0;i<urls.length;i++){
            if(pre=="prepend"){
              this.sketch_detail_list.unshift(urls[i].link);
            }else{
              this.sketch_detail_list.push(urls[i].link);
            }
            div+='<div class="sd_photoViewer__slide [ swiper-slide ]"><img src="'+urls[i].link+'" class="sd_photoViewer__img"></div>';
          }

          this.$nextTick(function(){
            if(pre=="prepend"){// 이전으로 추가
              this.swiper_viewer.prependSlide(div);
              this.sketch_no=this.sketch_basic_len;
            }else{// 다음으로 추가
              this.swiper_viewer.appendSlide(div);
              this.sketch_no=past_list_len-1;
            }
            this.swiper_viewer.slideTo(this.sketch_no, 0);// 순서에 맞는 이미지가 보여지게
          });
        });
      },

      // swiper
      swiperSlide:function(prenex){
        let swiperWrapper=document.querySelector(".swiper-wrapper"),
            firstx, dir;// 방향

        // 첫페이지의 처음 이미지를 선택해서 왔을 때
        if(this.sketch_no==1 && this.sketch_PN==1){
          this.download_link=this.sketch_detail_list[0];
        }
        // 로딩한 파일의 마지막 이미지를 선택해서 왔을 때, 다음 파일의 이미지 불러오기
        if(this.sketch_no==10 && this.sketch_PN<this.sketch_PN_page){
          this.sketch_PN=this.sketch_PN+1;
          this.sketchDetailAdd('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"'+this.sketch_tidx+'","PN":"'+this.sketch_PN+'"}');
        }
        // 로딩한 파일의 처음 이미지를 선택해서 왔을 때, 이전 파일의 이미지 불러오기
        if(this.sketch_no==1 && this.sketch_PN>1){
          this.sketch_PN=this.sketch_PN-1;
          this.sketchDetailAdd('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"'+this.sketch_tidx+'","PN":"'+this.sketch_PN+'"}', "prepend");
        }

        this.swiper_viewer=new Swiper("._photoViewer__swiper",{
          autoHeight:true,
          speed:200,
          on:{
            touchStart:function(e){//console.log("touchstart");
              firstx=e.changedTouches[0].clientX;
              this.allowTouchMove=true;
            },
            touchMove:function(e){
              if(firstx-e.changedTouches[0].clientX<0){
                dir="l";
              }else if(firstx-e.changedTouches[0].clientX>0){
                dir="r";
              }
            },
            // slideChange:function(){console.log("slideChange");},
            transitionStart:function(){//console.log("transitionStart");
              this.allowTouchMove=false;
            },
            // slideChangeTransitionStart:function(){console.log("slide [Change] TransitionStart");},
            // slideNextTransitionStart:function(){console.log("slide [Next] Transition = Start");},
            // slidePrevTransitionStart:function(){console.log("slide [Prev] Transition = Start");},
            transitionEnd:function(){//console.log("transitionEnd");
              app.sketch_no=this.activeIndex+1;
            },
            slideNextTransitionEnd:function(){//console.log("slide [Next] Transition = End");
              app.download_link=$(".swiper-slide").eq(this.activeIndex).find("img").attr("src");
              if(dir=="r"){
                // console.log("n : "+this.activeIndex+"___"+app.sketch_detail_list.length);
                if(this.activeIndex==app.sketch_detail_list.length-1){
                  if(app.sketch_PN==app.sketch_PN_page){
                    app.list_right_end=true;
                    return;
                  }

                  // 다음 파일
                  if(app.sketch_PN<app.sketch_PN_ori_r){
                    app.sketch_PN=app.sketch_PN_ori_r+1;
                  }else{
                    app.sketch_PN=app.sketch_PN+1;
                  }
                  if(app.sketch_PN>=1 && app.sketch_PN<app.sketch_PN_page+1 && !app.list_right_end){
                    app.sketchDetailAdd('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"'+app.sketch_tidx+'","PN":"'+app.sketch_PN+'"}');
                  }
                }
                this.allowTouchMove=true;
              }
            },
            slidePrevTransitionEnd:function(){//console.log("slide [Prev] Transition = End");
              app.download_link=$(".swiper-slide").eq(this.activeIndex).find("img").attr("src");
              if(dir=="l"){
                // console.log("p : "+this.activeIndex+"___"+app.sketch_detail_list.length);
                if(this.activeIndex==0){
                  if(app.sketch_PN==1){
                    app.list_left_end=true;
                    return;
                  }

                  // 이전 파일
                  if(app.sketch_PN>app.sketch_PN_ori_l){
                    app.sketch_PN=app.sketch_PN_ori_l-1;
                  }else{
                    app.sketch_PN=app.sketch_PN-1;
                  }
                  if(app.sketch_PN>0 && app.sketch_PN<=app.sketch_PN_page && !app.list_left_end){
                    app.sketchDetailAdd('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"'+app.sketch_tidx+'","PN":"'+app.sketch_PN+'"}', "prepend");
                  }
                }
                this.allowTouchMove=true;
              }
            },
          }
        });
        this.swiper_viewer.slideTo((this.sketch_no)-1, 0);// 현장스케치에서 선택한 이미지가 보여지게
      }
    },
    created:function(){
      if(navigator.userAgent.indexOf("isAppVer")>0){
        document.body.classList.add("webview");
      }
      
      let imginfo=(location.href.substr(location.href.indexOf("?")+1)).split("-");
      this.sketch_tidx=Number(imginfo[0]);
      this.sketch_PN=Number(imginfo[1]);
      this.sketch_PN_ori_l=this.sketch_PN_ori_r=this.sketch_PN;
      this.sketch_no=Number(imginfo[2]);
      // console.log("sketch_tidx : "+this.sketch_tidx+"__ sketch_PN : "+this.sketch_PN+"__ sketch_no : "+this.sketch_no);

      if(/iPhone|iPad|iPod/i.test(navigator.userAgent)){this.appleDevice=true;}
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }

      axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"'+this.sketch_tidx+'","PN":"","PT":"Y"}').then(response=>{// 페이지 수
        this.sketch_PN_page=Number(response.data.jlist[0].page);
        this.sketchDetail('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"80000","tidx":"'+this.sketch_tidx+'","PN":"'+this.sketch_PN+'"}');// json
      });
    },
  });
</script>
</body>
</html>
