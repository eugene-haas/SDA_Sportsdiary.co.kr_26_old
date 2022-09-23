
<!-- <section class="l_modal-layer">
   <div class="l_modal">

   </div>
</section> -->
<!-- <div id="modal" v-clock>
   <section class="m_modal-layer t_alert" :class="{s_show: alert_obj.show}">
      <div v-html="alert_obj.html" class="m_modal" :style="{'text-align': alert_obj.option.textAlign}">

      </div>
   </section>
   <section class="m_modal-layer t_tooltip" :class="{s_show: tooltip_obj.show}">
      <div v-html="tooltip_obj.html" class="m_modal" :style="{'text-align': tooltip_obj.option.textAlign}">
      </div>
   </section>
</div>
<script defer>
   let modal = new Vue({
      name: 'modal',
      el: "#modal",
      data: {
         /* -----------------------------------------------------------------------
            메인 변수
            ------------------------------------------------------------------------*/
         alert_obj: {
            show: false,
            html: '',
            option: {}
         },
         tooltip_obj: {
            show: false,
            html: '',
            option: {}
         },
      },
      methods: {
         /* -----------------------------------------------------------------------------------
               alert 호출
               modal.alert(html, {
                  textAlign: 'center'// text 정렬 'left', 'center', 'right'
               });으로 호출
            ---------------------------------------------------------------------------------- */
         alert: function(html, option){
            if (typeof html !== 'string') {
               error('$modal.alert error : text가 string이 아닙니다.');
               return;
            }
            option = option||{
               duration: (html.length * 60) + 400,
               textAlign: 'left',
            };
            if (typeof option !== 'object') {
               error('$modal.alert error : option이 object가 아닙니다.');
               return;
            }
            option.duration = option.duration||html.length * 60;
            option.textAlign = option.textAlign||'left';

            this.alert_obj.show = true;
            this.alert_obj.html = html;
            this.alert_obj.option = option;

            let that = this;
            setTimeout(function(){
               that.alert_obj.show = false;
            }, option.duration)
         },
         /* -----------------------------------------------------------------------------------
               tooltip 호출
               modal.tooltip(html, {
                  textAlign: 'center'// text 정렬 'left', 'center', 'right'
               });으로 호출
            ---------------------------------------------------------------------------------- */
         tooltip: function(html, option){
            if (typeof html !== 'string') {
               error('$modal.tooltip error : text가 string이 아닙니다.');
               return;
            }
            option = option||{
               duration: 3000,
               textAlign: 'left',
            };
            if (typeof option !== 'object') {
               error('$modal.tooltip error : option이 object가 아닙니다.');
               return;
            }
            option.duration = option.duration||html.length * 60;
            option.textAlign = option.textAlign||'left';

            this.tooltip_obj.show = true;
            this.tooltip_obj.html = html;
            this.tooltip_obj.option = option;

            let that = this;
            setTimeout(function(){
               that.tooltip_obj.show = false;
            }, option.duration)
         }
      }
   });
</script> -->
