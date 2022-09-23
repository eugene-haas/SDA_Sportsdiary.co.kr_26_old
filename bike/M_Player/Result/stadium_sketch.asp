<!-- #include file="../Library/header.bike.asp" -->
<%
  HostIDX = request("HostIDX")
  if HostIDX = "" then HostIDX = 1
  TitleIDX = request("TitleIDX")
  StartDate = request("StartDate")
%>


<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
</head>
<body>
<div id="app" class="l stadiumSketch" v-clock>

  <!-- #include file="../include/gnb.asp" -->

  <div class="l_header [ _header ]">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">대회사진</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">

    <!-- <img src="http://img.sportsdiary.co.kr/images/SD/img/prepare_page_@3x.png" style="width:100%;vertical-align:middle;"/> -->

    <div class="m_searchTags">
      <div class="m_searchTags__infoBox">
        <p class="m_searchTags__infoTxt">{{searchLayer.data.selectedAge}}<span>&#44;</span></p>
        <p class="m_searchTags__infoTxt">{{selectedTitleName}}</p>
        <button class="m_searchTags__btn" @click="openSearchLayer"><div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png"></div></button>
      </div>
    </div>

    <div class="photoList [ _photoList ]" :class="{s_noData: !isLoading && totalCount == 0}">
      <a class="photoList__item" v-for="(img, key) in imgList"
        :href="'./stadium_sketch_detail.asp?HostIDX=' + qs.hostIdx + '&TitleIDX=' + (searchLayer.data.selectedTitle || '') + '&TitleYear=' + searchLayer.data.selectedAge + '&pageNo=' + img.page + '&imgIdx=' + img.idx">
        <img :src="img.thumbnail">
      </a>
      <button class="photoList__more" v-if="!isLoading && (totalCount && totalCount !== imgList.length)" @click="getImages">더보기</button>
    </div>

  </div>

  <!-- search popup -->
  <div class="l_upLayer [ _overLayer _searchLayer ]">
    <div class="l_upLayer__backdrop [ _overLayer__backdrop ]"></div>
    <div class="l_upLayer__contBox m_searching__area [ _overLayer__box ]">

      <div class="m_searchPopup__header">
        <button class="m_searchPopup__close" @click="closeSearchLayer"><img src="http://img.sportsdiary.co.kr/images/SD/icon/popup_x_@3x.png" alt="닫기"></button>
      </div>

      <div class="l_upLayer__wrapCont m_searchPopup__cont [ _overLayer__wrap ]">
        <div class="m_searchPopup__control no_search">
          <button class="m_searchPopup__fliter">필터</button>
          <button type="button" class="m_searchPopup__submit s_blue" @click="searching"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt="조회"></button>
        </div>
        <div class="m_searchPopup__panelWrap s_filtering [ _sliderWrap ]">

          <div class="m_searchPopup__panel">
            <p class="m_searchPopup__cehckTit">기간</p>

            <div class="m_searchPopup__checkWrap">
              <div class="m_searchPopup__checkGroup">

                <span v-for="(age, index) in searchLayer.data.ages">
                  <input type="radio" name="search_age" hidden class="s_activeBlue" :id="'age' + index" :value="age" v-model="searchLayer.data.selectedAge" @change="changeAge">
                  <label :for="'age' + index">{{age}}</label>
                </span>

              </div>
            </div>

            <p class="m_searchPopup__cehckTit">대회명</p>
            <div class="m_searchPopup__checkWrap">

              <div class="m_searchPopup__checkGroup" v-for="(titles, index) in searchLayer.data.titles" v-if="titles.length !== 0">
                <span v-for="title in titles">
                  <!-- <input type="radio" name="search_game_name" hidden :id="(title.titleIdx) ? title.titleIdx : 0" :value="title.titleIdx" v-model="searchLayer.selectedTitle"><label :for="(title.titleIdx) ? title.titleIdx : 0">{{title.titleName}}</label> -->
                  <input type="radio" name="search_game_name" hidden class="s_activeBlue" :id="title.titleIdx" :value="title.titleIdx" v-model="searchLayer.data.selectedTitle">
                  <label :for="title.titleIdx"><p>{{title.titleName}}</P></label>
                </span>
              </div>

            </div>
          </div>

        </div>
      </div>

    </div>
  </div>
  <!-- // search popup -->

  <loader :loading="loading"></loader>

</div>

<!-- #include file="../include/loader2.asp" -->

<script>
  var vm = new Vue({
    mixins: [mixInLoader],
    el:'#app',
    data: {
      qs:{},
      isLoading: false,
      imgList: [],
      pageNo: 0,
      totalCount: null,
      searchLayer: {
        el: {},
        data: {
          ages: [],
          titles: [],
          selectedAge: '',
          selectedTitle: 0,
          tempAge: '',
          tempTitle: 0,
          tempTitles: [],
        },
        tempData: {}
      },
    },
    methods: {
      openSearchLayer: function(){
        this.searchLayer.el.open();
        this.searchLayer.tempData = {...this.searchLayer.data};
      },
      closeSearchLayer: function(){
        this.searchLayer.el.close();
        this.searchLayer.data = {...this.searchLayer.tempData};
      },
      changeAge: function(){
        this.r_titleList({titleIdx: ''})
      },
      searching: function(){
        this.initImgList();
        this.getImages();
        this.searchLayer.el.close();
      },
      initImgList: function(){
        this.pageNo = 0;
        this.imgList = [];
        this.totalCount = null;
      },
      getImages: function(){
        if(this.pageNo == 0) this.isLoading = true;
        this.r_imgList()
        .then(()=>{
          if(this.pageNo == 0) this.isLoading = false;
          this.pageNo++;
        })
      },
      replaceHistory: function(){
        let state = {
          hostIdx: this.qs.hostIdx,
          titleIdx: (this.searchLayer.data.selectedTitle || ''),
          startDate: this.searchLayer.data.selectedAge,
          pageNo: this.pageNo,
          totalCount: this.totalCount,
          imgList: this.imgList,
          scrollTop: window.pageYOffset || document.documentElement.scrollTop,
          scrollLeft: window.pageXOffset || document.documentElement.scrollLeft,
          searchLayer: { data: this.searchLayer.data },
        }

        history.replaceState(state, this.pageNo, history.href);
      },
      r_imgList: function(p){
        // if(this.pageNo == 0) this.isLoading = true;

        let params = Object.assign({
          hostIdx: this.qs.hostIdx,
          titleIdx: this.searchLayer.data.selectedTitle || '',
          titleYear: this.searchLayer.data.selectedAge,
          pageSize: 8,
          pageNumber: Number(this.pageNo) + 1,
        },p)

        return axios({
          url:'../ajax/Board/image/list_R.asp',
          method:'get',
          params: params
        })
        .then(response=>{
          this.imgList = this.imgList.concat(response.data.list)
          this.totalCount = response.data.totalCount;

          // if(this.pageNo == 0) this.isLoading = false;
          // this.pageNo++;

        })
      },
      // 검색옵션리스트
      r_titleList: function(p){

        let params = Object.assign({
          hostIdx: this.qs.hostIdx,
          titleIdx: this.searchLayer.data.selectedTitle,
          titleYear: this.searchLayer.data.selectedAge,
        }, p);

        console.log(params)

        return axios({
          url: '../ajax/Board/title_list_R.asp',
          method: 'get',
          params: params
        })
        .then(response=>{
          this.searchLayer.data.ages = response.data.year;
          let array = [[], [], [], [], []];
          response.data.titles.forEach(function(item, index){ array[index%5].push(item); });
          this.searchLayer.data.titles = array;

          this.searchLayer.data.selectedTitle = response.data.titles[0].titleIdx;

          return response
        })
      },

    },
    computed: {
      selectedTitleName: function(){
        for(let i=0, ii=this.searchLayer.data.titles.length; i<ii; i++){
          let titleGroup = this.searchLayer.data.titles[i];

          for(let i=0, ii=titleGroup.length; i<ii; i++){
            let title = titleGroup[i];
            if(title.titleIdx == this.searchLayer.data.selectedTitle) return title.titleName;
          }
        }
      }
    },
    created: function(){
      window.addEventListener('pageshow', (event)=>{
        // BFCache
        if(event.persisted || (window.performance && window.performance.navigation.type == 2)){
          this.qs.hostIdx = history.state.hostIdx;
          this.qs.titleIdx = history.state.titleIdx;

          this.totalCount = history.state.totalCount;
          this.imgList = history.state.imgList;
          this.pageNo = history.state.pageNo;

          this.searchLayer.data = history.state.searchLayer.data

          document.documentElement = document.body.scrollTop = history.state.scrollTop;

        }
        // 일반 페이지 진입
        else{
          this.qs.hostIdx = '<%=HostIDX%>';
          // titleIdx 없을시 get parameter 넘길때는 '', 스크립트에서 사용할때는 0
          this.qs.titleIdx = '<%=TitleIDX%>' || 0;

          this.r_titleList()
          .then(response=>{
            this.searchLayer.data.selectedAge = '<%=StartDate%>' || moment().format('YYYY');
            this.searchLayer.data.selectedTitle = this.qs.titleIdx || response.data.titles[0].titleIdx;
          })
          .then(()=>{
            this.initImgList();
            return this.getImages()
          })

        }
      })

      this.$on('updated', debounce(this.replaceHistory, 100))
      window.addEventListener('scroll', debounce(this.replaceHistory, 150));
    },
    mounted: function(){
      var photoList = document.querySelector('._photoList')
      photoList.style.minHeight = `calc(100vh - ${photoList.offsetTop}px)`;

      this.searchLayer.el = new OverLayer({
        overLayer: $("._searchLayer"),
        emptyHTML: "정보를 불러오고 있습니다.",
        errorHTML: "",
      });
    },
    updated: function(){
      this.$nextTick(()=>{ this.$emit('updated'); })
    },
  })
</script>

<!-- #include file="../Library/sub_config.asp" -->

</body>
</html>
