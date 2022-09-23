<template id="appLoader">
  <div class="m_loader" v-if="loading">

    <div class="m_loadingbar">
      <div class="m_loadingbar__img"><img src="http://img.sportsdiary.co.kr/images/SD/img/riding_loader_@3x.gif" alt="" style="width:100%;"></div>
      <p style="margin-top:10px;color:#888888;font-size:16px;line-height:20px;letter-spacing:-0.02em;text-align:center;">불러오는 중 입니다.</p>
    </div>

  </div>
</template>

<style scoped>
  .m_loader{position:fixed;width:100vw;height:100vh;top:0;left:0;right:0;bottom:0;margin:auto;z-index:10000;}
  .m_loadingbar{position:absolute;top:0;left:0;width:100%;height:100%;}
  .m_loadingbar__img{width:3.5rem;height:3.57rem;margin:42vh auto 0 auto;}
</style>

<script>
Vue.component("loader", {
  template:"#appLoader",
  props:{
    loading:{
      type:Boolean,
      default:true
    },
  }
})

const loaderEvent=new Vue();

var mixInLoader={
  data:{
    loading:false,
  },
  methods:{
    showLoader:function(){
      this.loading=true;
    },
    hideLoader:function(){
      this.loading=false;
    },
  },
  created:function(){
    loaderEvent.$on("beforeRequest", this.showLoader);
    loaderEvent.$on("responseOrError", this.hideLoader);
  }
}

axios.interceptors.request.use(
  config=>{
    loaderEvent.$emit("beforeRequest");
    return config;
  },
  error=>{
    loaderEvent.$emit("responseOrError");
    return Promise.reject(error);
  }
);
axios.interceptors.response.use(
  response=>{
    // setTimeout(()=>{
    loaderEvent.$emit("responseOrError");
    // },250)
    return response;
  },
  error=>{
    loaderEvent.$emit("responseOrError");
    return Promise.reject(error);
  }
);
</script>
