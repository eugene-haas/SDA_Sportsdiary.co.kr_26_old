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
<div id="app" class="l gamevideo" v-clock>

  <!-- #include file="../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 class="m_header__tit">대회영상</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">

    <!-- <img src="http://img.sportsdiary.co.kr/images/SD/img/prepare_page_@3x.png" style="width:100%;vertical-align:middle;"/> -->

    <div class="m_searchTags">
      <div class="m_searchTags__infoBox">
        <template v-if="searchLayer.data.mode == 'filter'">
          <p class="m_searchTags__infoTxt">{{searchLayer.data.selectedAge}}<span>&#44;</span></p>
          <p class="m_searchTags__infoTxt">{{selectedTitleName}}<span>&#44;</span></p>
          <p class="m_searchTags__infoTxt">{{selectedEventName}}</p>
        </template>
        <template v-else>
          <p class="m_searchTags__infoTxt">{{searchLayer.data.keyword}}</p>
        </template>
        <button class="m_searchTags__btn" @click="openSearchLayer"><div class="m_img"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png"></div></button>
      </div>
    </div>

    <div class="movieList [ _movieList ]" :class="{s_noData: !isLoading && totalCount == 0}">

      <a v-for="movie in movieList"
        :href="'./gamevideo_detail.asp?HostIDX=' + qs.hostIdx + '&movieIdx=' + movie.idx">
        <div class="movieList__img">
          <img :src="movie.thumbnail">
        </div>
        <div class="movieList__info">
          <p class="movieList__title">{{movie.contentsTitle}}</p>
          <p class="movieList__sno">조회수 {{movie.viewCount}}회</p>
        </div>
      </a>
      <button class="movieList__more" v-if="!isLoading && (totalCount && totalCount !== movieList.length)" @click="getMovies">더보기</button>

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

        <div class="m_searchPopup__control">
          <button class="m_searchPopup__fliter" :class="{s_search: searchLayer.data.mode == 'search'}" @click="searchLayer.data.mode = 'filter'; searchLayer.data.keyword = ''">필터</button>

          <input type="text" placeholder="영상제목을 입력해주세요." class="m_searchPopup__input s_ignore"
            :class="{s_search: searchLayer.data.mode == 'search'}" @click="searchLayer.data.mode = 'search'"
            :value="searchLayer.data.keyword" @input="searchLayer.data.keyword=$event.target.value"
            @keyup="getSearchWords">

          <button type="button" class="m_searchPopup__submit s_blue" @click="searching"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_@3x.png" alt="조회"></button>
        </div>

        <div class="m_searchPopup__panelWrap s_filtering" :class="{s_searching: searchLayer.data.mode == 'search'}">

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
                  <input type="radio" name="search_game_name" hidden class="s_activeBlue" :id="title.titleIdx" :value="title.titleIdx" v-model="searchLayer.data.selectedTitle" @change="changeTitle">
                  <label :for="title.titleIdx"><p>{{title.titleName}}</P></label>
                </span>
              </div>
            </div>

            <p class="m_searchPopup__cehckTit">종목</p>
            <div class="m_searchPopup__checkWrap">
              <div class="m_searchPopup__checkGroup">
                <span v-for="(event, index) in searchLayer.data.events">
                  <input type="radio" name="search_event_name" hidden class="s_activeBlue" :id="'event_' + event.index" :value="event.index" v-model="searchLayer.data.selectedEvent">
                  <label :for="'event_' + event.index"><p>{{event.eventName}}</P></label>
                </span>
              </div>
            </div>


          </div>

          <div class="m_searchPopup__panel">
            <button class="m_searchPopup__listname" v-for="(word, index) in searchLayer.data.wordList" @click="bindKeyword(index);searching()">
              {{word.contentsTitle}}
              <span class="icon__search_add"><img src="http://img.sportsdiary.co.kr/images/SD/icon/search_add_@3x.png"></span>
            </button>
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
    el: '#app',
    data: {
      qs: {},
      isLoading: false,
      pageNo: 0,
      movieList: [],
      totalCount: null,
      searchLayer: {
        el: {},
        data: {
          mode: 'filter',
          ages: [],
          titles: [],
          events: [],
          selectedAge: '',
          selectedTitle: 0,
          selectedEvent: 0,
          keyword: '',
          wordList: []
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
        .then(()=>{
          return this.r_eventList()
        })
      },
      changeTitle: function(){
        this.r_eventList()
      },
      searching: function(){
        this.initMovieList();
        this.getMovies();
        this.searchLayer.el.close();
      },
      bindKeyword: function(index){
        this.searchLayer.data.keyword = this.searchLayer.data.wordList[index].contentsTitle;
      },
      initMovieList: function(){
        this.pageNo = 0;
        this.movieList = [];
        this.totalCount = null;
      },
      getMovies: function(){
        if(this.pageNo == 0) this.isLoading = true;

        if(this.searchLayer.data.mode == 'filter'){
          var p = {
            searchText: ''
          };
        }
        else{
          var p = {
            titleIdx: '',
            pageSize: 8,
            pageNumber: Number(this.pageNo) + 1,
            titleYear: '',
            eventDetailType: '',
            searchText: this.searchLayer.data.keyword,
          };
        }

        this.r_movieList(p)
        .then(()=>{
          if(this.pageNo == 0) this.isLoading = false;
          this.pageNo++;
        })
      },
      getSearchWords: function(){
        if(this.searchLayer.data.keyword == '') return;
        this.$emit('searching');
      },
      replaceHistory: function(){

        let state = {
          hostIdx: this.qs.hostIdx,
          titleIdx: (this.searchLayer.data.selectedTitle || ''),
          startDate: this.searchLayer.data.selectedAge,
          pageNo: this.pageNo,
          totalCount: this.totalCount,
          movieList: this.movieList,
          scrollTop: window.pageYOffset || document.documentElement.scrollTop,
          scrollLeft: window.pageXOffset || document.documentElement.scrollLeft,
          searchLayer: { data: this.searchLayer.data },
        }

        history.replaceState(state, this.pageNo, history.href);

      },
      r_movieList: function(p){

        let params = Object.assign({
          hostIdx: this.qs.hostIdx,
          titleIdx: this.searchLayer.data.selectedTitle,
          pageSize: 8,
          pageNumber: Number(this.pageNo) + 1,
          titleYear: this.searchLayer.data.selectedAge,
          eventDetailType: this.selectedEventName,
          searchText: this.searchLayer.data.keyword,
        }, p)

        console.log(params)

        return axios({
          url: '../ajax/Board/video/list_R.asp',
          method: 'get',
          params: params
        })
        .then(response=>{
          this.movieList = this.movieList.concat(response.data.list);
          this.totalCount = response.data.totalCount;
        })

      },
      // 검색옵션리스트
      r_titleList: function(p){
        let params = Object.assign({
          hostIdx: this.qs.hostIdx,
          titleIdx: this.searchLayer.data.selectedTitle,
          titleYear: this.searchLayer.data.selectedAge,
        }, p);

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
      r_eventList: function(p){
        let params = Object.assign({
          titleIdx: this.searchLayer.data.selectedTitle
        }, p)

        return axios({
          url: '../ajax/Board/video/event_list_R.asp',
          method: 'get',
          params: params
        })
        .then(response=>{
          this.searchLayer.data.events = response.data.list.map((item, index)=>{
            return {
              index: index,
              eventName: item
            }
          });
          this.searchLayer.data.selectedEvent = this.searchLayer.data.events[0].index;
        })

      },
      r_searchWords: function(p){
        let params = Object.assign({
          hostIdx: this.qs.hostIdx,
          searchText: this.searchLayer.data.keyword
        })
        console.log(params)

        return axios({
          url: '../ajax/Board/Video/search_list_R.asp',
          method: 'get',
          params: params
        })
        .then(response=>{
          console.log(response.data)
          this.searchLayer.data.wordList = response.data.list
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
      },
      selectedEventName: function(){
        for(let i=0, ii=this.searchLayer.data.events.length; i<ii; i++){
          let event = this.searchLayer.data.events[i];
          if( event.index == this.searchLayer.data.selectedEvent) return event.eventName;
        }
      },
    },
    created: function(){
      window.addEventListener('pageshow', (event)=>{
        // BFCache
        if(event.persisted || (window.performance && window.performance.navigation.type == 2)){
          this.qs.hostIdx = history.state.hostIdx;
          this.qs.titleIdx = history.state.titleIdx;
          this.totalCount = history.state.totalCount;
          this.movieList = history.state.movieList;
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

            return this.r_eventList()
          })
          .then(()=>{
            this.initMovieList();
            return this.getMovies();
          })
        }
      })


      this.$on('updated', debounce(this.replaceHistory, 100))
      this.$on('searching', debounce(this.r_searchWords, 300))
      window.addEventListener('scroll', debounce(this.replaceHistory, 150));
    },
    mounted: function(){
      var movieList = document.querySelector('._movieList');
      movieList.style.minHeight = `calc(100vh - ${movieList.offsetTop}px)`;
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
