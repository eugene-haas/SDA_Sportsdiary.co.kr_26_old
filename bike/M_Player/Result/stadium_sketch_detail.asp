<!-- #include file="../Library/header.bike.asp" -->
<%
  HostIDX = request("HostIDX")
  if HostIDX = "" then HostIDX = 1
  TitleIDX = request("TitleIDX")
  TitleYear = request("TitleYear")
  StartDate = request("StartDate")
  pageNo = request("pageNo")
  imgIdx = request("imgIdx")
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
</head>
<body>
<div id="app" class="l stadiumSketchDetail" v-clock>

  <!-- #include file="../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">대회사진</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_subTitle">
      <h2 class="m_subTitle__title">{{title}}</h2>
    </div>

    <div class="swiper">
      <div class="swiper-container">
        <div class="swiper-wrapper">
          <!-- It is important to set "left" style prop on every slide -->
          <div class="swiper-slide swiper__slide" v-for="(slide, index) in virtualData.slides" :key="index" :style="{left: `${virtualData.offset}px`}">
            <img :src="slide.originImage" class="swiper__slideImg" />
          </div>
        </div>
      </div>

      <a v-if="!appleDevice" :href="downUrl" class="swiper__download" >다운로드</a>

      <p class="swiper__info">* 아이폰 및 안드로이드 기종에 따라 다운로드가 일부 제한적일 수 있습니다.</p>
      <p class="swiper__info">* 해당 이미지는 다운로드 시 고화질로 보실 수 있습니다.</p>

    </div>

  </div>

  <loader :loading="loading"></loader>

</div>

<!-- #include file="../include/loader2.asp" -->

<script>

  const axios2 = axios.create({})

  var vm = new Vue({
    mixins: [mixInLoader],
    el: '#app',
    data: {
      qs: {},
      title: '',
      downUrl: '',
      pages: [],
      swiper: undefined,
      slides: [],
      virtualData: {
        slides: [],
      },
      appleDevice: false,
      tempImgIdx: 0,
    },
    methods:{
      r_imgList: function(p){

        let params = Object.assign({
          hostIdx: this.qs.hostIdx,
          titleIdx: this.qs.titleIdx,
          titleYear: this.qs.titleYear,
          pageSize: 8,
          pageNumber: Number(this.pageNo) + 1,
        }, p);

        return axios({
          url:'../ajax/Board/image/list_R.asp',
          method:'get',
          params: params
        })

      },
      u_viewCount: function(p){

        let params = Object.assign({
          imageIdx: 0,
        },p)

        return axios2({
          url: '../ajax/Board/Image/view_count_W.asp',
          method: 'get',
          params: params
        })
        .then(response=>{
          // console.log(response.data)
        })

      },
    },
    created: function(){
      this.qs.hostIdx = '<%=HostIDX%>';
      this.qs.titleIDX = '<%=TitleIDX%>';
      this.qs.titleYear = '<%=TitleYear%>';
      this.qs.pageNo = Number('<%=pageNo%>') || 0;
      this.qs.imgIdx = Number('<%=imgIdx%>') || 0;

      this.pageNo = this.qs.pageNo;

      if(/iPhone|iPad|iPod/i.test(navigator.userAgent)) this.appleDevice=true;


      axios.all([
        this.r_imgList({pageNumber: this.pageNo - 1}),
        this.r_imgList({pageNumber: this.pageNo}),
        this.r_imgList({pageNumber: this.pageNo + 1})
      ])
      .then(
        axios.spread((r1, r2, r3)=>{

          if(r1.data.list.length !== 0) this.pages.push(r1.config.params.pageNumber);
          if(r2.data.list.length !== 0) this.pages.push(r2.config.params.pageNumber);
          if(r3.data.list.length !== 0) this.pages.push(r3.config.params.pageNumber);

          this.slides = [...r1.data.list, ...r2.data.list, ...r3.data.list];
        })
      )
      .then(()=>{

        this.$nextTick(()=>{
          let vm = this;
          vm.swiper = new Swiper('.swiper-container', {
            virtual: {
              slides: vm.slides,
              cache: true,
              addSlidesBefore: 0,
              addSlidesAfter: 0,
              renderExternal(data) {
                // assign virtual slides data
                vm.virtualData = data;
              },
            },
          });

          vm.swiper.on('touchStart', function(){
            vm.tempImgIdx = vm.slides[vm.swiper.activeIndex].idx;
          })

          vm.swiper.on('transitionStart', function(){
            this.allowTouchMove=false;
          })

          vm.swiper.on('transitionEnd', function(){
            if(vm.tempImgIdx !== vm.slides[vm.swiper.activeIndex].idx){
              vm.title = vm.slides[vm.swiper.activeIndex].contentsTitle;
              vm.downUrl = '../ajax/Board/Image/download.asp?hostIdx=' + vm.qs.hostIdx + '&fileName=' + vm.slides[vm.swiper.activeIndex].originImage;
              vm.u_viewCount({imageIdx: vm.slides[vm.swiper.activeIndex].idx})
            }

            Promise.resolve()
            .then(()=>{
              if(vm.swiper.activeIndex == 0){
                return vm.r_imgList({pageNumber: vm.pages[0] - 1})
                .then(response=>{
                  if(response.data.list.length !== 0) vm.pages.unshift(response.config.params.pageNumber);
                  response.data.list.forEach((item, index, array)=>{ vm.swiper.virtual.prependSlide(item) })
                })
              }
              else if(vm.swiper.activeIndex == vm.slides.length-1){
                return vm.r_imgList({pageNumber: vm.pages[vm.pages.length - 1] + 1})
                .then(response=>{
                  if(response.data.list.length !== 0) vm.pages.push(response.config.params.pageNumber);
                  response.data.list.forEach((item, index, array)=>{ vm.swiper.virtual.appendSlide(item) })
                })
              }

            })
            .then(()=>{
              this.allowTouchMove=true;
            })

          })

          let targetIndex = this.slides.findIndex(item => { return item.idx == this.qs.imgIdx });
          targetIndex = (targetIndex === -1) ? 1 : targetIndex;
          vm.swiper.slideTo(targetIndex, 0);
          vm.title = vm.slides[vm.swiper.activeIndex].contentsTitle;
          vm.downUrl = '../ajax/Board/Image/download.asp?hostIdx=' + vm.qs.hostIdx + '&fileName=' + vm.slides[vm.swiper.activeIndex].originImage;
          vm.u_viewCount({imageIdx: vm.slides[vm.swiper.activeIndex].idx})

        })
      });
    },
  })

</script>

<!-- #include file="../Library/sub_config.asp" -->

</body>
</html>
