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
      gun_list: [],
      sel_gun: null,

      leftCompare_info: {
         isNeedUpdate: false,
         sel_eval: null,
         group_list: [],
         sel_group: null,
         statistics_list: [],
         deduct_info: null,
      },
      rightCompare_info: {
         isNeedUpdate: false,
         group_list: [],
         sel_eval: null,
         sel_group: null,
         statistics_list: [],
         deduct_info: null,
      },

      compareChart: null,
      sel_group_l:null,
      sel_group_r:null,
      res_list: [
         {
            cnt_list: [
               {
                  seq: 1,
                  name: "대한축구협회",
                  score1: "12.4",
                  sub1: "82.6",
                  score2: "15.5",
                  sub2: "77.5",
                  score3: "28.6",
                  sub3: "71.5",
                  score4: "10.6",
                  sub4: "70.7",
                  score5: "6.6",
                  sub5: "66",
                  score6: "-2",
               },
               {
                  seq: 2,
                  name: "대한야구소프트볼협회",
                  score1: "14.1",
                  sub1: "94",
                  score2: "9.2",
                  sub2: "46",
                  score3: "22.1",
                  sub3: "52.3",
                  score4: "10.4",
                  sub4: "69.3",
                  score5: "3.36",
                  sub5: "33",
                  score6: "-1",
               }
            ]
         },
      ],
   },
   created: function() {
      this.initEvalList();

   },
   mounted: function() {
      this.makeChart_compare();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            req print
         ---------------------------------------------------------------------------------- */
      reqPrint: function(){
         if (this.leftCompare_info.statistics_list.length === 0 && this.rightCompare_info.statistics_list.length === 0) {
            alert('종목을 선택해주세요.');
            return;
         }
         window.print();
      },
      /* -----------------------------------------------------------------------------------
            init eval list
         ---------------------------------------------------------------------------------- */
      initEvalList: function() {
         const path = "/api/ajax/mgr_viewer/compare/compare_init.asp";
         const params = {};
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.eval_list = cm_fn.copyObjEx(res.data.list_info, []);
            if (0 < this.eval_list.length) {
               this.leftCompare_info.sel_eval = this.eval_list[0].eval_table_idx;
               this.rightCompare_info.sel_eval = this.eval_list[0].eval_table_idx;
            }
            this.gun_list = cm_fn.copyObjEx(res.data.group_info, []);
            if (0 < this.gun_list.length) {
               this.sel_gun = this.gun_list[0].eval_group_cd;
            }

            this.reqGroupList(E_POS_LEFT);
            this.reqGroupList(E_POS_RIGHT);
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            compare info 의 협회 리스트 조회
         ---------------------------------------------------------------------------------- */
      reqGroupList: function(idx) {
         const compare_info = idx === 0?this.leftCompare_info:this.rightCompare_info;
         const path = "/api/ajax/mgr_viewer/compare/association_list.asp";
         const params = {
            eval_table_idx: compare_info.sel_eval,
         };
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            compare_info.group_list = cm_fn.copyObjEx(res.data.association_info, []);
            compare_info.sel_group = null;
            compare_info.isNeedUpdate = false;
            compare_info.statistics_list = [];
            compare_info.deduct_info = null;
            this.updateChart(idx);
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            req compare chart data
         ---------------------------------------------------------------------------------- */
      reqCompareChartData: function(idx) {
         const compare_info = idx === 0?this.leftCompare_info:this.rightCompare_info;
         const path = "/api/ajax/mgr_viewer/compare/association_compare.asp";
         const params = {
            eval_table_idx: compare_info.sel_eval,
            association_idx: compare_info.sel_group,
         };
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            compare_info.statistics_list = cm_fn.copyObjEx(res.data.statistics_info, []);
            compare_info.deduct_info = cm_fn.copyObjEx(res.data.assoc_info[0], null);
            compare_info.isNeedUpdate = false;
            this.updateChart(idx);
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            군 변경 시 event
         ---------------------------------------------------------------------------------- */
      handleChangeGun: function() {
         this.leftCompare_info.sel_group = null;
         this.leftCompare_info.isNeedUpdate = false;
         this.leftCompare_info.statistics_list = [];
         this.leftCompare_info.deduct_info = null;
         this.updateChart(E_POS_LEFT);

         this.rightCompare_info.sel_group = null;
         this.rightCompare_info.isNeedUpdate = false;
         this.rightCompare_info.statistics_list = [];
         this.rightCompare_info.deduct_info = null;
         this.updateChart(E_POS_RIGHT);
      },
      /* -----------------------------------------------------------------------------------
            협회 변경 시 event
         ---------------------------------------------------------------------------------- */
      handleChangeGroup: function(idx) {
         const compare_info = idx === E_POS_LEFT?this.leftCompare_info:this.rightCompare_info;
         if (compare_info.sel_group) {
            this.reqCompareChartData(idx);
         } else {
            compare_info.isNeedUpdate = false;
            compare_info.statistics_list = [];
            compare_info.deduct_info = null;
            this.updateChart(idx);
         }
      },
      /* -----------------------------------------------------------------------------------
            차트 초기화
         ---------------------------------------------------------------------------------- */
      resetChart: function(chart){
         chart.data.datasets.forEach((dataset, idx) => {
            dataset.data = [];
         });
         chart.update();
      },
      /* -----------------------------------------------------------------------------------
            select 에 따른 차트 업데이트
         ---------------------------------------------------------------------------------- */
      updateChart: function(idx){
         const compare_info = idx === E_POS_LEFT?
            this.leftCompare_info:
            this.rightCompare_info;
         const data = [];
         const labels = [];
         for (var i = 0; i < compare_info.statistics_list.length; i++) {
            data.push(compare_info.statistics_list[i].percent_assoc);
            labels.push(compare_info.statistics_list[i].eval_cate);
         }
         if (this.compareChart.data.labels.length === 0 || (this.leftCompare_info.statistics_list.length && this.rightCompare_info.statistics_list.length)) {
            this.compareChart.data.labels = labels;
         }
         this.compareChart.data.datasets[idx].data = data;
         this.compareChart.data.datasets[idx].label = this.getSetGroupInfo(compare_info) && this.getSetGroupInfo(compare_info).association_name || "";
         this.compareChart.update();
      },
      /* -----------------------------------------------------------------------------------
            전체 차트
         ---------------------------------------------------------------------------------- */
      makeChart_compare: function() {
         const data = {
            labels: [
               "비전전략", "조직운영", "주요사업", "단체자율성", "인권 및 윤리",
            ],
            datasets: [
               {
                  label: null,
                  data: [
                  ],
                  borderColor: "#0A5DBD",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }, {
                  label: null,
                  data: [
                  ],
                  borderColor: "#ED7D31",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }
            ]
         };
         const config = {
            type: "radar",
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                    let delay = 0;
                    if (context.type === "data" && context.mode === "default") {
                       delay = context.dataIndex * 200 + context.datasetIndex * 200;
                      // delay = context.dataIndex * 200 + context.datasetIndex * 100;
                    }
                    return delay;
                  },
                },
               layout: {
                  padding: {
                     top: 20,
                     bottom: 20,
                     left:20,
                     right:20,
                  }
               },
               scales: {
                  r: {
                     angleLines: {
                        display: false
                     },
                     max: 100,
                     min: 0,
                     pointLabels: {
                        font: {
                           size: 14
                        }
                     },
                     ticks: {
                        beginAtZero: true,
                        suggestedMin: 0,
                        showLabelBackdrop: false,
                        z: 9,
                        stepSize: 20,
                        font: {
                           size: 10,
                        },
                     }
                  }
               },
               responsive: false,
               plugins: {
                  tooltip: {
                     usePointStyle: true,
                     callbacks: {
                        labelColor: function(ctx) {
                           const chart = ctx.chart;
                           const datasetIndex = ctx.datasetIndex;
                           const borderColor = chart.legend.legendItems[datasetIndex].strokeStyle;
                           const backgroundColor = chart.legend.legendItems[datasetIndex].strokeStyle;

                           return {borderColor: borderColor, backgroundColor: backgroundColor};
                        },
                     },
                  },
                  legend: {
                     position: "bottom",
                     labels: {
                        padding: 20,
                        boxWidth: 20,
                        boxHeight: 1
                     }
                  },
                  datalabels: {
                     display:false,
                  },
               }
            }
         };
         if (this.compareChart instanceof Chart) {
            this.compareChart.destroy();
         }
         this.compareChart = new Chart(document.getElementById("compareChart"), config);
      },
      /* -----------------------------------------------------------------------------------
            선택된 군에 속한 협회의 배열 반환
         ---------------------------------------------------------------------------------- */
      getSetGroupList: function(compare_list){
         return compare_list.group_list.filter(function(obj){
            return obj.eval_group_cd === this.sel_gun;
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            선택된 협회의 정보 반환
         ---------------------------------------------------------------------------------- */
      getSetGroupInfo: function(compare_list){
         return compare_list.group_list.find(function(obj){
            return obj.association_idx === compare_list.sel_group;
         }.bind(this)) || null;
      },
   },
   computed: {
   },
});
