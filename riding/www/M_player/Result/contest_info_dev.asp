<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
	<!-- #include file="../include/config.asp" -->
</head>
<body>
<div id="app" class="l contestInfo" v-cloak>

  <!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
  		<h1 class="m_header__tit">대회요강</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>

		<!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>

  <!-- S: main -->
  <div class="l_content m_scroll [ _content _scroll ]">
    <a onclick="alert('sportsdiary://urlblank=http://upload.sportsdiary.co.kr/sportsdiary/RDN01/2019/소년체육대회_마복마구행위허용여부.pdf')" class="btn-right" target="_blank">ios&안드 새창</a>
    <a href="http://upload.sportsdiary.co.kr/sportsdiary/RDN01/2019/소년체육대회_마복마구행위허용여부.pdf" class="btn-right" target="_blank">ios&안드 새창</a>

    <br />

    <!-- <iframe id="iframe" name="iframe"
      scrolling="auto"
      src="http://upload.sportsdiary.co.kr/sportsdiary/RDN01/2019/소년체육대회_마복마구행위허용여부.pdf"
      width="100%" height="100%" ></iframe> -->


    <iframe id="theFrame" src="http://riding.sportsdiary.co.kr/소년체육대회_마복마구행위허용여부.pdf" allow="fullscreen"  type='application/pdf' width="100%" height="100%"  style="overflow: scroll; min-height: 600px;" frameborder="0" scrolling="yes"></iframe>
    <!-- <iframe id="theFrame" src="http://riding.sportsdiary.co.kr/m_player/result/gamevideo.asp" allow="fullscreen"  type='application/pdf' width="100%" height="100%"  style="overflow: scroll; min-height: 600px;" frameborder="0" scrolling="yes"></iframe> -->

    <!-- <div style="width:300px;margin:auto;background:blue;">
      <object type="application/pdf" data="http://upload.sportsdiary.co.kr/sportsdiary/RDN01/2019/소년체육대회_마복마구행위허용여부.pdf?#page=2" style="transform-origin:left top;width:100%;height:5000px"></object>
    </div> -->

    <!-- <canvas id="the-canvas"></canvas> -->

    <div id="example1">

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
      // contestTitle:"농림축산식품부장관배 전국승마대회",
      contestTitle:"",
      addFile:false,// 첨부 파일이 있는지
      addFileView:false,// 첨부 파일 목록이 화면에 보이는지
      addFileList:[],//다운로드 파일들
      contest_info:"",// 대회 내용
      loading:false,// data불러왔는지 유무

      tidx:null,


      name:null,
      grade:"일반",
      login_chk:false,// 로그인여부
    },
    computed:{},
    methods:{
      // 첨부파일 가져오기
      addFileData:function(url){
        axios.get(url).then(response=>{
          this.addFileList=response.data.jlist;
          this.addFile=true;

          // 첨부파일 위치
          this.$nextTick(function(){
            // let addfilebox=document.querySelector(".l_contest_file__list");
						let addfilebox=document.querySelector("._fileList");
            addfilebox.setAttribute("style", "margin-top:-"+addfilebox.clientHeight+"px");
          });
        });
      },

      // 첨부파일 보기
      addFileShow:function(){
        // let addfilebox=document.querySelector(".l_contest_file__list");
				let addfilebox=document.querySelector("._fileList");
        if(this.addFileView){
          this.addFileView=false;
          addfilebox.classList.remove("s_on");
          addfilebox.setAttribute("style", "margin-top:-"+addfilebox.clientHeight+"px");
        }else{
          this.addFileView=true;
          addfilebox.classList.add("s_on");
          addfilebox.setAttribute("style", "margin-top:0px");
        }
      },
      // 파일 전체 받기
      fileDownAll:function(){
        let alldown=document.createElement("a");
        alldown.setAttribute("download","download");
        alldown.style.display="none";
        document.body.appendChild(alldown);
        for(var i=0;i<this.addFileList.length;i++){
          alldown.setAttribute("href", this.addFileList[i].file);
          alldown.click();
        }
        document.body.removeChild(alldown);
      },

      // 대회명
      gameTitle:function(){
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"63000","tidx":"'+this.tidx+'"}').then(response=>{
          this.contestTitle=response.data.jlist[0].title;
        },(error)=>{
          console.log("error. gameTitle");
          console.log(error);
        });
      },
      // 대회 내용
      gameInfo:function(){
        this.loading=true;
        // axios.get('testcontestinfo2.html').then(response=>{
        axios.get('http://riding.sportsdiary.co.kr/pub/ajax/riding/mobile/reqRiding.asp?req={"CMD":"62100","tidx":"'+this.tidx+'"}').then(response=>{
          this.contest_info=response.data;
          this.loading=false;
        },(error)=>{
          console.log("error. gameInfo");
          console.log(error);
        });
      }
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


      // 위에서 tidx는 지정한 이유는, 이 파일을 바로 열었을 때의 확인용 값
      let urlparam_tidx=location.href.indexOf("tidx=");
      if(urlparam_tidx>0){
        let param_tidx=location.href.substr(urlparam_tidx+5);// +5는 t i d x = 다음의 위치
        this.tidx=param_tidx;
      }

      // 첨부파일 위치
      // let addfilebox=document.querySelector(".l_contest_file__list");
			// let addfilebox=document.querySelector("._fileList");
      // addfilebox.setAttribute("style", "margin-top:0");
    },
    mounted:function(){
      if(this.$cookies.get("SD")!=null){
        this.name=this.$cookies.get("SD").substr(this.$cookies.get("SD").indexOf("UserName")+9, Math.abs((this.$cookies.get("SD").indexOf("UserBirth")-1)-(this.$cookies.get("SD").indexOf("UserName")+9)));
        this.login_chk=true;
      }else{
        this.login_chk=false;
      }
      // 첨부파일
      // this.addFileData("testContestinfo.html");// 확인용 json

      this.gameTitle();// 대회명
      this.gameInfo();// 내용


      console.log(window.frames[0].document)






      document.getElementById("theFrame").contentWindow.onload = function() {

        // alert($('#theFrame').contents())
        alert($('#theFrame').contents().find('body').html())

        alert('lo')
        var sheet = document.createElement('style');
        var css = `img{width:100%;}body{background-color:red;}`;
        sheet.innerHTML = css;
        this.document.head.appendChild(sheet);

        this.document.getElementsByTagName("img")[0].style.width="100%";
      };


    },
  });
</script>
</body>
</html>
