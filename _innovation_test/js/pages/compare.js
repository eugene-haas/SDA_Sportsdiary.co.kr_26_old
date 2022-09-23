const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
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
               }
            ]
         },
      ],
   },
   created: function() {},
   mounted: function() {
      this.makeChart_compare();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            go input
         ---------------------------------------------------------------------------------- */
      goInput: function(match) {
         const path = '/game_manager/pages/input.asp';
         // if(header.user_info.C_CDA === "E2"){
         //    path = '/game_manager/pages/input_diving.asp';
         // }
         const pack = {};
         pack.etc_obj = {
            lidx: match.lidx
         };
         cm_fn.goto_url(path, pack);
      },
      /* -----------------------------------------------------------------------------------
            탭 선택
         ---------------------------------------------------------------------------------- */
      handleChangeSelGroup: function(){
         if (this.sel_group_l !== null && this.sel_group_r !== null) {
            this.updateChart();
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
      updateChart: function(){
         this.resetChart(this.compareChart);
         this.compareChart.data.datasets.forEach((dataset, idx) => {
            const cnt_info = idx === 0?this.getResLeft:this.getResRight;
            const data = [
               cnt_info.sub1,
               cnt_info.sub2,
               cnt_info.sub3,
               cnt_info.sub4,
               cnt_info.sub5,
            ];
            dataset.data = data;
            dataset.label = cnt_info.name;
         });
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
                  label: '대한축구협회',
                  data: [
                     20, 65, 45, 96, 57,
                  ],
                  borderColor: "#0A5DBD",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }, {
                  label: '대한야구소프트볼협회',
                  data: [
                     44, 42, 26, 78, 87,
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
            type: 'radar',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                    let delay = 0;
                    if (context.type === 'data' && context.mode === 'default') {
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
         this.compareChart = new Chart(document.getElementById('compareChart'), config);
      },
      /* -----------------------------------------------------------------------------------
            req match list
         ---------------------------------------------------------------------------------- */
      reqMatchList: function() {
         const path = '/game_manager/ajax/api/api.SWIM_300.asp';
         const params = {};
         axios.post(path, params).then(function(res) {
            log(res);
            if (String(res.data.result) !== E_API_STATUS_SUCCESS) {
               alert('리스트 조회 실패');
               return;
            }
            this.match_list = cm_fn.copyObjEx(res.data.list, []);
         }.bind(this));
      }
   },
   computed: {
      getResLeft: function(){
         if(this.sel_group_l === null)return null;
         return this.res_list[0].cnt_list.find(function(obj){
            return obj.seq === this.sel_group_l;
         }.bind(this));
      },
      getResRight: function(){
         if(this.sel_group_r === null)return null;
         return this.res_list[0].cnt_list.find(function(obj){
            return obj.seq === this.sel_group_r;
         }.bind(this));
      }
   },
});
