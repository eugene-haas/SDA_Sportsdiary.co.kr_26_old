<!-- #include file="../Library/header.bike.asp" -->
<%
  Count = request("Count")
%>


<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->

  <style>
    .filterWrap{position:fixed;width:50px;height:50px;bottom:10px;left:0;right:0;margin:auto;z-index:2000;}
    /* .filterLayer{position:relative;color:#fff;}
    .filterLayer.s_on{position:fixed;width:100vw;height:100vh;z-index:2000;} */

    .filterLayer__bg{position:fixed;border:0;width:50px;height:50px;left:0;right:0;bottom:10px;margin:auto;background-color:#FE7745;border-radius:50%;color:#fff;transition:all .6s linear;}
    .filterLayer__bg.s_on{width:100vw;height:100vh;border-radius:10px;bottom:0;}

    .filterOpenBtn{display:none;position:absolute;border:0;width:50px;height:50px;top:0;background-color:#FE7745;border-radius:50%;color:#fff;}
    .filterOpenBtn.s_on{display:block;}
    .filterCloseBtn{display:none;position:absolute;border:0;width:50px;height:50px;top:0;background-color:#FE7745;border-radius:50%;color:#fff;}
    .filterCloseBtn.s_on{display:block;}

    .filterContents{position:fixed;width:0;height:0;top:0;left:0;overflow:hidden;color:#fff;text-align:center;opacity:0.2;}
    .filterContents.s_on{position:fixed;width:100vw;height:100vh;top:0;left:0;transition:opacity 0.8s;opacity:1;}

  </style>
  <script>
    $(function(){
      $('.filterOpenBtn').on('click', function(){
        $('.filterLayer').addClass('s_on')
        $('.filterLayer__bg').addClass('s_on')
        $('.filterContents').addClass('s_on')
        $('.filterOpenBtn').removeClass('s_on')
        $('.filterCloseBtn').addClass('s_on')
      })
      $('.filterCloseBtn').on('click', function(){
        $('.filterLayer').removeClass('s_on')
        $('.filterLayer__bg').removeClass('s_on')
        $('.filterContents').removeClass('s_on')
        $('.filterOpenBtn').addClass('s_on')
        $('.filterCloseBtn').removeClass('s_on')
      })

    })

  </script>
</head>
<body>
<div id="app" class="l stadiumSketch">

  <!-- #include file="../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">대회사진</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">





    <!-- <img src="http://img.sportsdiary.co.kr/images/SD/img/prepare_page_@3x.png" style="width:100%;vertical-align:middle;"/> -->

    <div class="m_subTitle">
      <h2 class="m_subTitle__title">2019 SD랭킹 Cycle Championship 1차</h2>
    </div>


    <div class="filterWrap">
      <!-- <div class="filterLayer"> -->
        <div class="filterLayer__bg"></div>
        <div class="filterContents">
          <h2>contents</h2>

          <p>
            What is Lorem Ipsum?
            Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
          </p>
          <p>
            Why do we use it?
            It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
          </p>
        </div>
      <!-- </div> -->

      <button class="filterOpenBtn s_on">검색</button>
      <button class="filterCloseBtn">닫기</button>
    </div>


    <div class="photoList">

      <a href="./stadium_sketch_detail.asp" class="photoList__item" v-for="img in imgList">
        <img src="http://judo.sportsdiary.co.kr/m_player/upload/sketch/ListTN/ListTN_20193141132364.jpg" tabindex="-1" class="photoList__img">
      </a>

      <button class="photoList__more" @click="getMoreImgs()" style="display: block;">더보기</button>
    </div>

    <div>
      <button></button>
    </div>


  </div>
</div>

<script>
axios.defaults.headers.get["Cache-Control"] = 'public';
  // window.onpopstate = function(event) {
  //   alert("location: " + document.location + ", state: " + JSON.stringify(event.state));
  // };
  var vm = new Vue({
    el:'#app',
    data: {
      qs:{},
      imgList: [],
      count: 0,
      f1: '',
      f2: '',
    },
    methods: {
      r_imgList: function(){
        return axios({
          url:'./a.asp',
          method:'get',
          count: this.count,
          f1: '',
          f2: '',
        })
        .then(response=>{
          response.data.list.forEach(item=>{
            this.imgList.push(item)
          })
          history.replaceState({list:this.imgList}, this.count, 'http://bike.sportsdiary.co.kr/bike/TSM_Player/result/stadium_sketch.asp?count='+this.count)
          this.count++;
        })
      },
      getMoreImgs: function(){
        this.r_imgList()
      }
    },
    created() {
      this.qs.count = Number('<%=Count%>');
      if(!this.qs.count){
        this.r_imgList();
      }
      else{
        console.log('aaa')
        this.count = Number(this.qs.count) + 1;
        this.imgList = history.state.list;

      }

      console.log(this.qs.count)
      console.log(history)
      console.log(document.referrer);
    },
    mounted() {}
  })

</script>

</body>
</html>
