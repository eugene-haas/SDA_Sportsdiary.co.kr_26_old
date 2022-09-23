
const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/
      modal_review: {
         show: false,
         sel_cate: null,
         review_list: [],
      },
      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      eval_list: [],
      sel_eval: g_etc_obj.sel_eval || null,
      gun_list: [],
      sel_gun: g_etc_obj.sel_gun || null,
      group_list: [],
      sel_group: g_etc_obj.sel_group || null,
      cate_list: [],
      subcate_list: [],
      typeItem_list: [],
      rater_list: [],
      score_list: [],

      isAuthD: Header.user_info.aAUTH === 'D',//협회 로그인
      isAuthC: Header.user_info.aAUTH === 'C',//평가자 로그인
   },
   created: function() {
      this.initEvalList();
      window.reqPrintReview2 = this.reqPrintReview2;
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
                  .l_print{padding:44px 36px!important;width:1100px;transform: scale(calc(793.688 / 1100));transform-origin:left top;background:#F8F8F9!important;}
               </style>
            </head>
            <body onload="window.print()">
               <div class="l_print" style="height:${1122.52 * (1100/793.688)}px;">
                  ${this.$refs.tbl.outerHTML}
               </div>
            </body>
         `);
         iframe.contentWindow.document.close();
      },
      /* -----------------------------------------------------------------------------------
            req print review
         ---------------------------------------------------------------------------------- */
      reqPrintReview: function(){
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
            </head>
            <body onload="parent.reqPrintReview2()">
               <div class="l_print">
                  <ol>
                     <li class="l_print__page">
                        <div id="contents" class="m_review">
                           ${this.getSelCateList.map(function(cate_info){
                              return `
                              <h2 class="m_review__cate m_review__cate--sm">
                              ${cate_info.eval_cate_order}. ${cate_info.eval_cate}
                              </h2>
                              ${cate_info.subcate_list.map(function(subcate_info){
                                 return `
                                 <h3 class="m_review__title m_review__title--sm">
                                 ${subcate_info.eval_cate_order}.${subcate_info.eval_subcate_order} ${subcate_info.eval_subcate}
                                 </h3>
                                 ${subcate_info.typeItem_list.map(function(typeItem_info){
                                    if (Number(typeItem_info.eval_type_cd) !== E_EVAL_TYPE_ABSOLUTE) {
                                       return '';
                                    }
                                    return `
                                    <div class="m_review__item" >
                                    <div class="m_space">
                                    <h4 class="m_review__title-sub m_review__cate--sm">
                                    ${typeItem_info.eval_cate_order}.${typeItem_info.eval_subcate_order}.${typeItem_info.eval_item_order} ${typeItem_info.eval_item}
                                    </h4>
                                    ${!this.isAuthC && !this.isAuthD?`
                                       <span class="m_review__info m_space__right">
                                       평가 : <span class="m_review__text">${this.getRaterNames(typeItem_info.rater_list, ", ")}</span>
                                    </span>
                                    `:''}
                                    </div>
                                    ${this.getReview(typeItem_info.item_type_idx).map(function(desc_info){
                                       return `<p class="m_review__contents m_review__contents--p">${desc_info.eval_desc}</p>`
                                    }.bind(this)).join('') || `<p class="m_review__contents m_review__contents--p">미등록</p>`}
                                    </div>
                                    `
                                 }.bind(this)).join('')}
                                 `
                              }.bind(this)).join('')}
                              `
                           }.bind(this)).join('')}
                        </div>
                     </li>
                  </ol>
               </div>
            </body>
         `);
         iframe.contentWindow.document.close();
      },
      /* -----------------------------------------------------------------------------------
            req print review
         ---------------------------------------------------------------------------------- */
      reqPrintReview2: function(){
         let iframe = document.querySelector('#iframeReview');
         const contents = iframe.contentWindow.document.querySelector("#contents");
         const childrenList = contents.children;
         let iframe2 = document.querySelector('#iframeReview2');
         if (iframe2 === null) {
            iframe2 = document.createElement("iframe");
            document.body.querySelector('.l_wrap').appendChild(iframe2);
         }
         iframe2.id = 'iframeReview2';
         iframe2.name = 'iframeReview2';
         iframe2.src = "";
         iframe2.style.visibility = "hidden";
         iframe2.style.position = "absolute";
         const titleStr = `평가점수 의견 - ${this.getSelGroupInfo.association_name}(${this.getSelEvalInfo.eval_title})`;

         const pageList = [];
         const itemList = [];
         let pageHeight = 0;
         for (let i = 0; i < childrenList.length; i++) {
            // console.log(pageHeight, childrenList[i].outerHeight, childrenList[i].innerHTML)
            pageHeight += childrenList[i].outerHeight;
            if (820 < pageHeight) {
               pageList.push(itemList.slice());
               itemList.length = 0;
               pageHeight = 0;
               pageHeight += childrenList[i].outerHeight;
            }
            itemList.push(childrenList[i].outerHTML);
         }
         if (itemList.length !== 0) {
            pageList.push(itemList.slice());
            itemList.length = 0;
            pageHeight = 0;
         }
         iframe2.contentWindow.document.write(`
            <head>
               ${iframeHead}
            </head>
            <body onload="window.print()">
               <div class="l_print">
                  <ol>
                     ${pageList.map(function(item_list, idx){
                        return `
                        <li class="l_print__page">
                           <div class="l_print__header">
                              <span>
                                 ${titleStr}
                              </span>
                              <span class="l_print__paging">
                                 페이지 ${idx+1}/${pageList.length}
                              </span>
                           </div>
                           <div class="m_review">
                              ${item_list.join('')}
                           </div>
                        </li>
                        `
                     }).join('')}
                  </ol>
               </div>
            </body>
         `);
         iframe2.contentWindow.document.close();
      },
      /* -----------------------------------------------------------------------------------
            통계 보기
         ---------------------------------------------------------------------------------- */
      goStatistics: function(){
         cm_fn.goto_url("/pages/result/table/statistics/index.asp", {
            etc_obj: {
               association_name: this.getSelGroupInfo.association_name,
               eval_group: this.getSelGroupInfo.eval_group,
               sel_eval: this.sel_eval,
               sel_gun: this.sel_gun,
               sel_group: this.sel_group,
            },
         });
      },
      /* -----------------------------------------------------------------------------------
            init eval list
         ---------------------------------------------------------------------------------- */
      initEvalList: function() {
         let path = "/api/ajax/mgr_viewer/result/result_all_init.asp";
         let params = {};
         if (this.isAuthD) {
            path = "/api/ajax/mgr_viewer/association/result/result_init.asp";
            params = {
               association_idx: String(Header.user_info.aGrpIDX),
            };
         } else if (this.isAuthC) {
            path = "/api/ajax/mgr_viewer/eval_staff/result/result_init.asp";
            params = {
               eval_member_idx: String(Header.user_info.aIDX),
            };
         }
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.eval_list = cm_fn.copyObjEx(res.data.list_info, []);
            if (0 < this.eval_list.length && this.sel_eval === null) {
               this.sel_eval = this.eval_list[0].eval_table_idx;
            }
            this.reqTblData();
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            req table data
         ---------------------------------------------------------------------------------- */
      reqTblData: function() {
         let path = "/api/ajax/mgr_viewer/result/result.asp";
         let params = {
            eval_table_idx: this.sel_eval,
         };
         if (this.isAuthD) {
            path = "/api/ajax/mgr_viewer/association/result/result.asp";
            params = {
               eval_table_idx: this.sel_eval,
               association_idx: String(Header.user_info.aGrpIDX),
            };
         } else if (this.isAuthC) {
            path = "/api/ajax/mgr_viewer/eval_staff/result/result.asp";
            params = {
               eval_table_idx: this.sel_eval,
               eval_member_idx: String(Header.user_info.aIDX),
            };
         }
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.gun_list = cm_fn.copyObjEx(res.data.group_info, []);
            if (0 < this.gun_list.length && this.sel_gun === null) {
               this.sel_gun = this.gun_list[0].eval_group_cd;
            }
            this.group_list = cm_fn.copyObjEx(res.data.association_info, []);
            if (this.isAuthD) {
               this.group_list.push({
                  association_idx: String(Header.user_info.aGrpIDX),
                  association_name: Header.user_info.aGrpNM,
                  eval_group: this.getSelGunInfo.eval_group,
                  eval_group_cd: this.getSelGunInfo.eval_group_cd,
               });
            }
            if (0 < this.group_list.length && this.sel_group === null) {
               this.sel_group = this.group_list[0].association_idx;
            }

            this.cate_list = cm_fn.copyObjEx(res.data.cate_info, []);
            this.subcate_list = cm_fn.copyObjEx(res.data.subcate_info, []);
            this.typeItem_list = cm_fn.copyObjEx(res.data.item_type_info, []);
            this.rater_list = cm_fn.copyObjEx(res.data.member_info, []);

            this.gun_list = this.getSetGunList();

            if (this.isAuthD) {
               this.score_list = cm_fn.copyObjEx(res.data.eval_point_info, []);
            } else {
               this.reqScoreData();
            }
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            req score data
         ---------------------------------------------------------------------------------- */
      reqScoreData: function() {
         let path = "/api/ajax/mgr_viewer/result/association_eval_point.asp";
         let params = {
            eval_table_idx: this.sel_eval,
            association_idx: this.sel_group,
         };
         if (this.isAuthC) {
            path = "/api/ajax/mgr_viewer/eval_staff/result/eval_point.asp";
            params = {
               eval_table_idx: this.sel_eval,
               association_idx: this.sel_group,
               eval_member_idx: String(Header.user_info.aIDX),
            };
         }
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.score_list = cm_fn.copyObjEx(res.data.eval_point_info, []);
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            군 변경 시 event
         ---------------------------------------------------------------------------------- */
      handleChangeGun: function() {
         if (0 < this.getSetGroupList.length) {
            this.sel_group = this.getSetGroupList[0].association_idx;
         }
         this.reqScoreData();
      },
      /* -----------------------------------------------------------------------------------
            평가점수 의견 모달창 열기
         ---------------------------------------------------------------------------------- */
      openModal_review: function(){
         let path = "/api/ajax/mgr_viewer/result/association_eval_desc.asp";
         let params = {
            eval_table_idx: this.sel_eval,
            association_idx: this.sel_group,
         };
         if (this.isAuthC) {
            path = "/api/ajax/mgr_viewer/eval_staff/result/eval_desc.asp";
            params = {
               eval_table_idx: this.sel_eval,
               association_idx: this.sel_group,
               eval_member_idx: String(Header.user_info.aIDX),
            };
         }
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("평가점수 의견 조회 실패");
               return;
            }
            const review_list = cm_fn.copyObjEx(res.data.eval_desc_info, []);
            for (var i = 0; i < review_list.length; i++) {
               review_list[i].eval_desc = cm_fn.htmlDecode(review_list[i].eval_desc);
            }
            this.modal_review.review_list = review_list;
            this.modal_review.sel_cate = "";
            this.modal_review.show = true;
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            평가점수 의견 모달창 닫기
         ---------------------------------------------------------------------------------- */
      closeModal_review: function(){
         this.modal_review.show = false;
      },
      /* -----------------------------------------------------------------------------------
            group_list > cate_list > subcate_list > typeItem_list > rater_list 인 배열 생성
         ---------------------------------------------------------------------------------- */
      getSetGunList: function(){
         const gun_list_temp = cm_fn.copyObjEx(this.gun_list, []);
         const cate_list_temp = cm_fn.copyObjEx(this.cate_list, []);
         const subcate_list_temp = cm_fn.copyObjEx(this.subcate_list, []);
         const typeItem_list_temp = cm_fn.copyObjEx(this.typeItem_list, []);
         const rater_list_temp = cm_fn.copyObjEx(this.rater_list, []);

         const list = [];
         for (let i = 0; i < gun_list_temp.length; i++) {
            const gun_info = gun_list_temp[i];
            const cate_list = cate_list_temp.filter(function(obj){
               return obj.eval_group_cd === gun_info.eval_group_cd;
            }.bind(this));
            const cate_len = cate_list.length;

            for (let j = 0; j < cate_len; j++) {
               const cate_info = cate_list[j];
               const subcate_list = subcate_list_temp.filter(function(obj){
                  return obj.eval_group_cd === gun_info.eval_group_cd
                        && obj.eval_cate_cd === cate_info.eval_cate_cd;
               }.bind(this));
               const subcate_len = subcate_list.length;

               let typeItem_cnt = 0;
               for (let k = 0; k < subcate_len; k++) {
                  const subcate_info = subcate_list[k];
                  const typeItem_list = typeItem_list_temp.filter(function(obj){
                     return obj.eval_group_cd === gun_info.eval_group_cd
                           && obj.eval_cate_cd === cate_info.eval_cate_cd
                           && obj.eval_subcate_cd === subcate_info.eval_subcate_cd;
                  }.bind(this));
                  const typeItem_len = typeItem_list.length;
                  typeItem_cnt = typeItem_cnt + typeItem_len;

                  for (let l = 0; l < typeItem_len; l++) {
                     const typeItem_info = typeItem_list[l];
                     const rater_list = rater_list_temp.filter(function(obj){
                        return obj.item_type_idx === typeItem_info.item_type_idx;
                     }.bind(this));

                     typeItem_info.rater_list = rater_list;
                  }

                  subcate_info.typeItem_list = typeItem_list;

               }

               cate_info.typeItem_cnt = typeItem_cnt;
               cate_info.subcate_list = subcate_list;
            }

            gun_info.cate_list = cate_list;
            list.push(gun_info);
         }
         return list;
      },
      /* -----------------------------------------------------------------------------------
            평가자 이름 표시
         ---------------------------------------------------------------------------------- */
      getRaterNames: function(rater_list, joinStr){
         const list = [];
         const rater_len = rater_list.length;
         for (let i = 0; i < rater_len; i++) {
            list.push(rater_list[i].eval_member);
         }
         return list.join(joinStr);
      },
      /* -----------------------------------------------------------------------------------
            스코어 조회
         ---------------------------------------------------------------------------------- */
      getScore: function(item_type_idx, isDeduct){
         const score = this.getScoreMap[item_type_idx]
            && Number(this.getScoreMap[item_type_idx].ave_val);
         if (isDeduct === true) {
            return Number('-' + score);
         }
         return score;
      },
      /* -----------------------------------------------------------------------------------
            스코어 조회
         ---------------------------------------------------------------------------------- */
      getTotalScore: function(eval_cate_cd){
         return this.getTotalScoreMap[eval_cate_cd]
            && Number(this.getTotalScoreMap[eval_cate_cd]);
      },
      /* -----------------------------------------------------------------------------------
            의견 조회
         ---------------------------------------------------------------------------------- */
      getReview: function(item_type_idx){
         return this.getReviewMap[item_type_idx] || [];
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
            선택한 협회의 의견들
         ---------------------------------------------------------------------------------- */
      getReviewMap: function(){
         const review_map = {};
         const review_list = this.modal_review.review_list;
         const review_len = review_list.length;
         for (let i = 0; i < review_len; i++) {
            const review_info = review_list[i];
            review_map[review_info.item_type_idx] = review_map[review_info.item_type_idx] || [];
            review_map[review_info.item_type_idx].push(review_info);
         }
         return review_map;
      },
      /* -----------------------------------------------------------------------------------
            선택한 협회의 점수들
         ---------------------------------------------------------------------------------- */
      getScoreMap: function(){
         const score_map = {};
         const score_list = this.score_list;
         const score_len = score_list.length;
         for (let i = 0; i < score_len; i++) {
            const score_info = score_list[i];
            score_map[score_info.item_type_idx] = score_info;
         }
         return score_map;
      },
      /* -----------------------------------------------------------------------------------
            선택한 협회의 점수들
         ---------------------------------------------------------------------------------- */
      getTotalScoreMap: function(){
         const score_map = {};
         let total_score = 0;
         for (let i = 0; i < this.getSelCateList.length; i++) {
            const cate_info = this.getSelCateList[i];
            const subcate_list = cate_info.subcate_list;
            const subcate_len = subcate_list.length;
            let total_cate_score = 0;
            for (let j = 0; j < subcate_len; j++) {
               const typeItem_list = subcate_list[j].typeItem_list;
               const typeItem_len = typeItem_list.length;
               for (let k = 0; k < typeItem_len; k++) {
                  const typeItem_info = typeItem_list[k];
                  const score = this.getScore(typeItem_info.item_type_idx, typeItem_info.sum_point === '0') || null;
                  if (!score) continue;
                  total_cate_score = total_cate_score + score;
               }
            }
            total_score = total_score + total_cate_score;
            score_map[cate_info.eval_cate_cd] = total_cate_score.toFixed(2);
         }
         score_map["total"] = total_score.toFixed(2);
         return score_map;
      },
      /* -----------------------------------------------------------------------------------
            선택된 군의 cate 배열 반환
         ---------------------------------------------------------------------------------- */
      getSelCateList: function(){
         const gun_info = this.gun_list.find(function(obj){
            return obj.eval_group_cd === this.sel_gun;
         }.bind(this));
         if (gun_info === undefined) return [];
         return gun_info.cate_list || [];
      },
      /* -----------------------------------------------------------------------------------
            선택된 군의 정보 반환
         ---------------------------------------------------------------------------------- */
      getSelGunInfo: function(){
         return this.gun_list.find(function(obj){
            return obj.eval_group_cd === this.sel_gun;
         }.bind(this)) || null;
      },
      /* -----------------------------------------------------------------------------------
            선택된 군에 속한 협회의 배열 반환
         ---------------------------------------------------------------------------------- */
      getSetGroupList: function(){
         return this.group_list.filter(function(obj){
            return obj.eval_group_cd === this.sel_gun;
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            선택된 협회의 정보 반환
         ---------------------------------------------------------------------------------- */
      getSelGroupInfo: function(){
         return this.group_list.find(function(obj){
            return obj.association_idx === this.sel_group;
         }.bind(this)) || null;
      },
      /* -----------------------------------------------------------------------------------
            선택된 카테고리의 정보 반환
         ---------------------------------------------------------------------------------- */
      getSelCateListOfReviewModal: function(){
         if (this.modal_review.sel_cate === "") {
            return this.getSelCateList;
         }
         return this.getSelCateList.filter(function(obj){
            return obj.eval_cate_cd === this.modal_review.sel_cate;
         }.bind(this));
      },
   }
});
