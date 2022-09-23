<template id="beatLoader">
  <div class="m_loader" v-show="loading">
    <div class="m_spinner">
      <div class="m_spinner__beat s_odd" v-bind:style="spinnerStyle"></div>
      <div class="m_spinner__beat s_even" v-bind:style="spinnerStyle"></div>
      <div class="m_spinner__beat s_odd" v-bind:style="spinnerStyle"></div>
    </div>
  </div>
</template>
<script>
  Vue.component('loader', {
    template: '#beatLoader',
    props:{
      loading: {
        type: Boolean,
        default: true
      },
      color: {
        type: String,
        default: '#005895'
      },
      size: {
        type: String,
        default: '15px'
      },
      margin: {
        type: String,
        default: '2px'
      },
      radius: {
        type: String,
        default: '100%'
      }
    },
    data () {
      return {
        spinnerStyle: {
          backgroundColor: this.color,
          height: this.size,
          width: this.size,
          margin: this.margin,
          borderRadius: this.radius
        }
      }
    }
  })
</script>
<style>
  .m_loader{position:absolute;width:100vw;height:100vh;top:0;left:0;right:0;bottom:0;margin:auto;z-index:10000;background-color:rgba(255,255,255,0.05);}
  .m_spinner{position:absolute;top:30vh;margin:auto;left:0;right:0;text-align:center;}
  .m_spinner__beat{
      -webkit-animation: v-beatStretchDelay 0.7s infinite linear;
              animation: v-beatStretchDelay 0.7s infinite linear;
      -webkit-animation-fill-mode: both;
  	          animation-fill-mode: both;
      display: inline-block;
  }

  .m_spinner__beat.s_odd{animation-delay: 0s;}
  .m_spinner__beat.s_even{animation-delay: 0.35s;}

  @-webkit-keyframes v-beatStretchDelay{
      50%{
          -webkit-transform: scale(0.75);
                  transform: scale(0.75);
          -webkit-opacity: 0.2;
                  opacity: 0.2;
      }
      100%{
          -webkit-transform: scale(1);
                  transform: scale(1);
          -webkit-opacity: 1;
                  opacity: 1;
      }
  }
  @keyframes v-beatStretchDelay{
      50%{
          -webkit-transform: scale(0.75);
                  transform: scale(0.75);
          -webkit-opacity: 0.2;
                  opacity: 0.2;
      }
      100%{
          -webkit-transform: scale(1);
                  transform: scale(1);
          -webkit-opacity: 1;
                  opacity: 1;
      }
  }
</style>
