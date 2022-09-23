<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
	<!-- #include file="../include/config.asp" -->
</head>
<body>
<div id="app" class="l gameVideoDetail" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
  		<h1 class="m_header__tit">경기영상</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>

		<!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>

  <!-- S: main -->
  <div class="l_content m_scroll [ _content _scroll ]">
		<p class="m_matchTit">{{gamemovie_title}}</p>

    <div class="gamemovie">
      <div class="m_loadingbar" v-if="loading" v-bind:class="{m_dflex: loading}">
        <div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt=""></div>
      </div>
      <div v-else>
        <div class="gamemovie__movie">
          <iframe width="100%" height="100%" v-bind:src="gameMovieUrl(gamemovie_url)" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </div>
        <p class="gamemovie__txt">{{gamemovie_txt}}</p>
        <p class="gamemovie__sno">조회수 {{gamemovie_sno}}회</p>
      </div>
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
      gamemovie_title:"",// 대회명
      gamemovie_txt:"",// 영상 제목
      gamemovie_url:"",// url 경로
      gamemovie_sno:null,// 조회수

      loading:false,// data불러왔는지 유무
      movie_data:[],//
      url_param:null,// 확인용 data url

      
      name:null,
      grade:"일반",
      login_chk:false,// 로그인여부
    },
    computed:{
    },
    methods:{
      // 목록
      gamemovieData:function(){
        this.loading=true;
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"70000","vidx":"'+this.url_param+'"}').then(response=>{
          this.loading=false;
          this.movie_data=response.data.jlist[0];
          // this.$nextTick(function(){});

          this.gamemovie_title=this.movie_data.title;
          this.gamemovie_url=this.movie_data.movieurl;
          this.gamemovie_txt=this.movie_data.txt;
          this.gamemovie_sno=this.movie_data.sno;
        });
      },
      gameMovieUrl:function(url){
        return "https://www.youtube.com/embed/"+url.substr(url.lastIndexOf("=")+1);
      }
    },
    created:function(){
      if(navigator.userAgent.indexOf("isAppVer")>0){
        document.body.classList.add("webview");
      }
      
      this.url_param=location.href.substr(location.href.indexOf("?")+1);// 확인용 - 경기영상에서 선택한 이미지 번호
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }

      this.gamemovieData();// 확인용 json
    },
  });
</script>
</body>
</html>
