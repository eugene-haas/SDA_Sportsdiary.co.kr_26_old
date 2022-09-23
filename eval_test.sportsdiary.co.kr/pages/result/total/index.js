const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      eval_list: [],
      sel_eval: null,

      gun_list: [],
      type_list: [],
      cate_list: [],
      subcate_list: [],
      item_list: [],
      score_list: [],
   },
   created: function() {
      this.initEvalList();
   },
   mounted: function() {
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            req print
         ---------------------------------------------------------------------------------- */
      reqPrint: function(){
         let iframe = document.querySelector('#iframeReview');
         if (iframe === null) {
            iframe = document.createElement("iframe");
            document.body.querySelector('.l_wrap').appendChild(iframe);
         }
         iframe.id = 'iframeReview';
         iframe.name = 'iframeReview';
         iframe.src = "";
         iframe.style.visibility = "hidden";
         iframe.style.position = "absolute";
         iframe.contentWindow.document.write(`
            <head>
               ${iframeHead}
               <style>
                  .l_print{padding:44px 36px!important;width:1200px;transform: scale(calc(793.688 / 1200));transform-origin:left top;background:#F8F8F9!important;}
               </style>
            </head>
            <body onload="window.print()">
               <div class="l_print" style="height:${1122.52 * (1200/793.688)}px;">
                  ${this.$refs.tbl.outerHTML}
               </div>
            </body>
         `);
         iframe.contentWindow.document.close();
      },
      /* -----------------------------------------------------------------------------------
            init eval list
         ---------------------------------------------------------------------------------- */
      initEvalList: function() {
         const path = "/api/ajax/mgr_viewer/result/result_all_init.asp";
         const params = {};
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.eval_list = cm_fn.copyObjEx(res.data.list_info, []);
            if (0 < this.eval_list.length) {
               this.sel_eval = this.eval_list[0].eval_table_idx;
            }
            this.reqTotalTblData();
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            req total table data
         ---------------------------------------------------------------------------------- */
      reqTotalTblData: function() {
         const path = "/api/ajax/mgr_viewer/result/result_all.asp";
         const params = {
            eval_table_idx: this.sel_eval,
         };
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.gun_list = cm_fn.copyObjEx(res.data.group_info, []);
            this.type_list = cm_fn.copyObjEx(res.data.type_info, []);
            this.cate_list = cm_fn.copyObjEx(res.data.cate_info, []);
            this.subcate_list = cm_fn.copyObjEx(res.data.subcate_info, []);
            this.item_list = cm_fn.copyObjEx(res.data.item_info, []);

            this.score_list = cm_fn.copyObjEx(res.data.eval_point_info, []);

            this.cate_list = this.getSetCateList();
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            cate_list > subcate_list > item_list 인 배열 생성
         ---------------------------------------------------------------------------------- */
      getSetCateList: function(){
         const cate_list_temp = cm_fn.copyObjEx(this.cate_list, []);
         const subcate_list_temp = cm_fn.copyObjEx(this.subcate_list, []);
         const item_list_temp = cm_fn.copyObjEx(this.item_list, []);
         const setSubTotalMap = function(item_info, subTotal_map){
            const gun_list = this.getSetGunList;
            for (let i = 0; i < gun_list.length; i++) {
               const gun_info = gun_list[i];
               subTotal_map[gun_info.eval_group_cd] = subTotal_map[gun_info.eval_group_cd] || {};
               const gunSubTotal_obj = subTotal_map[gun_info.eval_group_cd];

               const type_list = gun_info.type_list;
               for (let j = 0; j < type_list.length; j++) {
                  const type_info = type_list[j];
                  const score = this.getScore(item_info.eval_item_idx, gun_info.eval_group_cd, type_info.eval_type_cd, item_info.sum_point === '0') || 0;
                  gunSubTotal_obj[type_info.eval_type_cd] = gunSubTotal_obj[type_info.eval_type_cd] || 0;
                  gunSubTotal_obj[type_info.eval_type_cd] += score;
                  gunSubTotal_obj[type_info.eval_type_cd] = Number(gunSubTotal_obj[type_info.eval_type_cd].toFixed(2));
               }
            }
            return subTotal_map;
         }.bind(this);
         const list = [];
         for (let i = 0; i < cate_list_temp.length; i++) {
            const cate_info = cate_list_temp[i];
            let subTotal_map = {};
            let item_cnt = 0;
            const subcate_list = subcate_list_temp.filter(function(obj){
               return obj.eval_cate_cd === cate_info.eval_cate_cd;
            }.bind(this));
            const subcate_len = subcate_list.length;
            for (let j = 0; j < subcate_len; j++) {
               const subcate_info = subcate_list[j];
               const item_list = item_list_temp.filter(function(obj){
                  return obj.eval_cate_cd === cate_info.eval_cate_cd
                        && obj.eval_subcate_cd === subcate_info.eval_subcate_cd;
               }.bind(this));
               const item_len = item_list.length;
               item_cnt = item_cnt + item_len;
               for (let k = 0; k < item_len; k++) {
                  const item_info = item_list[k];
                  subTotal_map = setSubTotalMap(item_info, subTotal_map);
               }
               subcate_info.item_list = item_list;
            }
            cate_info.item_len = item_cnt;
            cate_info.total_map = subTotal_map;
            cate_info.subcate_list = subcate_list;
            list.push(cate_info);
         }
         return list;
      },
      /* -----------------------------------------------------------------------------------
            스코어 조회
         ---------------------------------------------------------------------------------- */
      getScore: function(eval_item_idx, eval_group_cd, eval_type_cd, isDeduct){
         const score = this.getScoreMap[eval_item_idx]
            && this.getScoreMap[eval_item_idx][eval_group_cd]
            && this.getScoreMap[eval_item_idx][eval_group_cd][eval_type_cd]
            && Number(this.getScoreMap[eval_item_idx][eval_group_cd][eval_type_cd].ave_val);
         if (isDeduct === true) {
            return Number('-' + score);
         }
         return score;
      },
      /* -----------------------------------------------------------------------------------
            종합 스코어 조회
         ---------------------------------------------------------------------------------- */
      getTotalScore: function(eval_group_cd, eval_type_cd){
         return this.getTotalScoreMap[eval_group_cd]
            && this.getTotalScoreMap[eval_group_cd][eval_type_cd];
      },
   },
   computed: {
      /* -----------------------------------------------------------------------------------
            선택된 평가 반환
         ---------------------------------------------------------------------------------- */
      getSelEvalInfo: function(){
         return this.eval_list.find(function(obj){
            return obj.eval_table_idx === this.sel_eval;
         }.bind(this)) || null;
      },
      /* -----------------------------------------------------------------------------------
            점수들 맵핑
            item > type 형태로 2차원 맵핑
         ---------------------------------------------------------------------------------- */
      getScoreMap: function(){
         const score_map = {};
         const score_list = this.score_list;
         const score_len = score_list.length;
         for (let i = 0; i < score_len; i++) {
            const score_info = score_list[i];
            score_map[score_info.eval_item_idx] = score_map[score_info.eval_item_idx] || {};
            score_map[score_info.eval_item_idx][score_info.eval_group_cd] = score_map[score_info.eval_item_idx][score_info.eval_group_cd] || {};
            score_map[score_info.eval_item_idx][score_info.eval_group_cd][score_info.eval_type_cd] = score_info;
         }
         return score_map;
      },
      /* -----------------------------------------------------------------------------------
            소계 점수들
            gun > type 형태로 2차원 맵핑
         ---------------------------------------------------------------------------------- */
      getTotalScoreMap: function(){
         const total_map = {};
         for (let i = 0; i < this.cate_list.length; i++) {
            const cate_info = this.cate_list[i];
            for (const eval_group_cd in cate_info.total_map) {
               let gun_total = 0;
               const gunSubTotal_obj = cate_info.total_map[eval_group_cd];
               total_map[eval_group_cd] = total_map[eval_group_cd] || {};
               const gunTotal_obj = total_map[eval_group_cd];
               gunTotal_obj["total"] = gunTotal_obj["total"] || 0;
               for (const eval_type_cd in gunSubTotal_obj) {
                  const sub_score = gunSubTotal_obj[eval_type_cd];
                  gunTotal_obj[eval_type_cd] = gunTotal_obj[eval_type_cd] || 0;
                  gunTotal_obj[eval_type_cd] += sub_score;
                  gunTotal_obj[eval_type_cd] = Number(gunTotal_obj[eval_type_cd].toFixed(2));
                  gun_total += sub_score;
               }
               gunTotal_obj["total"] += gun_total;
               gunTotal_obj["total"] = Number(gunTotal_obj["total"].toFixed(2));
            }
         }
         return total_map;
      },
      /* -----------------------------------------------------------------------------------
            gun_list > type_list 인 배열 생성
         ---------------------------------------------------------------------------------- */
      getSetGunList: function(){
         const list = [];
         const gun_list = this.gun_list;
         const gun_len = gun_list.length;
         for (let i = 0; i < gun_len; i++) {
            const gun_info = gun_list[i];
            const type_list = this.type_list.filter(function(obj){
               return obj.eval_group_cd === gun_info.eval_group_cd;
            }.bind(this));
            gun_info.type_list = type_list;
            list.push(gun_info);
         }
         return list;
      },
   }
});
