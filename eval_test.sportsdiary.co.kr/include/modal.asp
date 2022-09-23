<!-- S: 공통 모달창 영역 -->
<div id="AlertModal">
   <transition name="modal">
      <section class="l_modal-alert" v-show="show">
         {{text}}
      </section>
   </transition>
</div>
<!-- E: 공통 모달창 영역 -->
<script>
   const AlertModal = new Vue({
      name: "AlertModal",
      el: "#AlertModal",
      data: {
         show: false,
         timer: null,
         text: '',
         TIMEOUT: 800,
      },
      methods: {
         /* -----------------------------------------------------------------------------------
               모달창 호출
            ---------------------------------------------------------------------------------- */
         showModal: function(text){
            this.show = true;
            this.text = text;
            if (this.timer !== null) {
               clearTimeout(this.timer);
               this.timer = null;
            }
            this.timer = setTimeout(function(){
               this.show = false;
               this.timer = null;
            }.bind(this), this.TIMEOUT);
         }
      },
   });
</script>
