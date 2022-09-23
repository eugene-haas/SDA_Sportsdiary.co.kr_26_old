<!-- #include file="../Library/header.bike.asp" -->
<%
  HostIDX = request("HostIDX")
  if HostIDX = "" then HostIDX = 1
  movieIdx = request("movieIdx")
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
      <h1 class="m_header__tit">경기영상</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>
  </div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <template v-for="movie in movieList">

    <div class="m_subTitle">
      <h2 class="m_subTitle__title">{{movie.titleName}}</h2>
    </div>

    <div class="movieList" >
      <div>
        <div class="movieList__movie">
          <!-- "https://www.youtube.com/embed/"+url.substr(url.lastIndexOf("=")+1); -->
          <iframe width="100%" height="100%" :src="'https://www.youtube.com/embed/' + movie.link" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </div>
        <div class="movieList__info">
          <p class="movieList__title">{{movie.contentsTitle}}</p>
          <p class="movieList__sno">조회수 {{movie.viewCount}}회</p>
        </div>
      </div>
    </div>

    </template>

  </div>

  <loader :loading="loading"></loader>

</div>

<!-- #include file="../include/loader2.asp" -->

<script>

  var vm = new Vue({
    mixins: [mixInLoader],
    el: '#app',
    data: {
      qs: {},
      movieList: []
    },
    methods: {
      r_movieList: function(p){

        let params = Object.assign({
          hostIdx: this.qs.hostIdx,
          videoIdx: this.qs.movieIdx
        }, p)

        console.log(params)

        return axios({
          url: '../ajax/Board/video/list_R.asp',
          method: 'get',
          params: params
        })
        .then(response=>{
          console.log(response.data)
          this.movieList = response.data.list;
        })
      },
      u_viewCount: function(p){
        let params = Object.assign({
          videoIdx: this.qs.movieIdx,
        },p)
        console.log(params)

        return axios({
          url: '../ajax/Board/Video/view_count_W.asp',
          method: 'get',
          params: params
        })
        .then(response=>{
          console.log(response.data)
        })
      }
    },
    created: function(){
      this.qs.hostIdx = '<%=HostIDX%>';
      this.qs.movieIdx = '<%=movieIdx%>';

      this.u_viewCount()
      .then(()=>{
        return this.r_movieList()
      })

    }
  })
  
</script>

<!-- #include file="../Library/sub_config.asp" -->

</body>
</html>
