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
      sel_gun: null,
      group_list: [],
      sel_group: null,

      cate_list: [],

      statistics_list: [],
      group_info: null,


      totalChart: null,
      cateChart_list: [],

      isAuthD: Header.user_info.aAUTH === 'D',

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
         window.print();
      },
      /* -----------------------------------------------------------------------------------
            init eval list
         ---------------------------------------------------------------------------------- */
      initEvalList: function() {
         let path = "/api/ajax/mgr_viewer/report/eval_report_init.asp";
         let params = {};
         if (this.isAuthD) {
            path = "/api/ajax/mgr_viewer/association/report/eval_report_init.asp";
            params = {
               association_idx: String(Header.user_info.aGrpIDX),
            };
         }
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
            this.reqOptionData();
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            req option data
         ---------------------------------------------------------------------------------- */
      reqOptionData: function() {
         let path = "/api/ajax/mgr_viewer/report/eval_report_env.asp";
         let params = {
            eval_table_idx: this.sel_eval,
         };
         if (this.isAuthD) {
            path = "/api/ajax/mgr_viewer/association/report/eval_report.asp";
            params = {
               eval_table_idx: this.sel_eval,
               association_idx: String(Header.user_info.aGrpIDX),
            };
         }
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.gun_list = cm_fn.copyObjEx(res.data.group_info, []);
            if (0 < this.gun_list.length) {
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
            if (0 < this.group_list.length) {
               this.sel_group = this.group_list[0].association_idx;
            }

            this.cate_list = cm_fn.copyObjEx(res.data.cate_info, []);

            if (this.isAuthD) {
               this.statistics_list = cm_fn.copyObjEx(res.data.statistics_info, []);
               const group_info = cm_fn.copyObjEx(res.data.assoc_info[0], null);
               group_info.total_desc = cm_fn.htmlDecode(group_info.total_desc);
               this.group_info = group_info;
            }

            this.$nextTick(function(){
               if (this.cate_list.length) {
                  this.makeChart_total();
                  this.makeChart_cate();
                  if (this.isAuthD) {
                     this.updateChart();
                  } else {
                     this.reqReportData();
                  }
               } else {
                  this.statistics_list = [];
                  this.group_info = null;
                  if (this.totalChart instanceof Chart) {
                     this.totalChart.destroy();
                  }
                  for (var i = 0; i < this.cateChart_list.length; i++) {
                     if (this.cateChart_list[i] instanceof Chart) {
                        this.cateChart_list[i].destroy();
                     }
                  }
               }
            });
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            req report data
         ---------------------------------------------------------------------------------- */
      reqReportData: function() {
         const path = "/api/ajax/mgr_viewer/report/eval_report.asp";
         const params = {
            eval_table_idx: this.sel_eval,
            association_idx: this.sel_group,
         };
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.statistics_list = cm_fn.copyObjEx(res.data.statistics_info, []);
            const group_info = cm_fn.copyObjEx(res.data.assoc_info[0], null);
            group_info.total_desc = cm_fn.htmlDecode(group_info.total_desc);
            this.group_info = group_info;
            this.updateChart();
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            군 변경 시 event
         ---------------------------------------------------------------------------------- */
      handleChangeGun: function() {
         if (0 < this.getSetGroupList.length) {
            this.sel_group = this.getSetGroupList[0].association_idx;
         }
         this.reqReportData();
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
            statistics_list 에 따른 차트 업데이트
         ---------------------------------------------------------------------------------- */
      updateChart: function() {
         const group_title = this.getSelGroupInfo && this.getSelGroupInfo.association_name;
         const gun_name = this.getSelGroupInfo && this.getSelGroupInfo.eval_group;
         this.resetChart(this.totalChart);
         this.totalChart.data.datasets[0].label = group_title;
         this.totalChart.data.datasets[1].label = gun_name + "군평균";
         this.totalChart.data.datasets[2].label = "전체평균";
         this.totalChart.data.labels = [];
         for (let i = 0; i < this.cate_list.length; i++) {
            this.totalChart.data.labels.push(this.cate_list[i].eval_cate);
         }
         this.totalChart.data.datasets.forEach(function(dataset, idx){
            if (this.statistics_list.length) {
               const key = idx === 0 ? "percent_assoc" :
                           idx === 1 ? "percent_group" :
                           idx === 2 ? "percent_total" : "";
               const list = this.statistics_list;
               const data = [];
               for (var i = 0; i < list.length; i++) {
                  data.push(list[i][key]);
               }
               dataset.data = data;
            } else {
               dataset.data = null;
            }
         }.bind(this));
         this.totalChart.update();

         for (let i = 0; i < this.cateChart_list.length; i++) {
            const chart_obj = this.cateChart_list[i];
            this.resetChart(chart_obj);
            const statistics_info = this.statistics_list[i];
            if (statistics_info) {
               chart_obj.data.datasets[0].label = statistics_info.eval_cate + "("+ statistics_info.base_point +")";
               chart_obj.data.labels = [group_title, gun_name + "군평균", "전체평균"];
               chart_obj.data.datasets[0].data = [
                  statistics_info["point_assoc"],
                  statistics_info["point_group"],
                  statistics_info["point_total"],
               ];
            }
            chart_obj.update();
         }
      },
      /* -----------------------------------------------------------------------------------
            전체 차트
         ---------------------------------------------------------------------------------- */
      makeChart_total: function() {
         const data = {
            labels: [
               "", "", "", "", ""
            ],
            datasets: [
               {
                  label: "",
                  data: [
                     0,0,0,0,0
                  ],
                  borderColor: "#ff6969",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }, {
                  label: "",
                  data: [
                     0,0,0,0,0
                  ],
                  borderColor: "#75b1ff",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }, {
                  label: "",
                  data: [
                     0,0,0,0,0
                  ],
                  borderColor: "#949494",
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
                       delay = context.datasetIndex * 100;
                      // delay = context.dataIndex * 200 + context.datasetIndex * 100;
                    }
                    return delay;
                  },
                },
               layout: {
                  padding: {
                     top: 20,
                     bottom: 20
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
                           size: 10
                        }
                     },
                     ticks: {
                        beginAtZero: true,
                        min: 0,
                        showLabelBackdrop: false,
                        z: 9,
                        stepSize: 20
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
                  datalabels: {
                     display:false,
                  },
                  legend: {
                     position: "bottom",
                     labels: {
                        padding: 20,
                        boxWidth: 20,
                        boxHeight: 1,
                     },
                  }
               }
            }
         };
         if (this.totalChart instanceof Chart) {
            this.totalChart.destroy();
         }
         this.totalChart = new Chart(document.getElementById("totalChart"), config);
      },
      /* -----------------------------------------------------------------------------------
            카테고리별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_cate: function(){
         const backgroundColor_list = [
            [
                "#318FED",
                "#A5D3DC",
                "#D4D4D4",
            ],[
                "#DC7174",
                "#EBAFB0",
                "#D4D4D4",
            ],[
                "#A4BC7A",
                "#CFDCC5",
                "#D4D4D4",
            ],[
                "#8F31ED",
                "#C3A6E1",
                "#D4D4D4",
            ],[
                "#EDAE31",
                "#F1D398",
                "#D4D4D4",
            ],
         ]
         const getChart = function(idx, backgroundColor){
            const data = {
               labels: [
                  "", "", ""
               ],
               datasets: [
                  {
                     label: "",
                     data: [
                        0,0,0
                     ],
                    backgroundColor: backgroundColor,
                    barThickness: 36
                  },
               ]
            };
            if (this.cateChart_list[idx] instanceof Chart) {
               this.cateChart_list[idx].destroy();
            }
            return new Chart(document.getElementById("cateChart"+(idx+1)), {
               type: "bar",
               data: data,
               options: {
                  animation: {
                     delay: (context) => {
                       let delay = 0;
                       if (context.type === "data" && context.mode === "default") {
                          // delay = context.datasetIndex * 100;
                         delay = context.dataIndex * 200 + 400 * idx;
                       }
                       return delay;
                     },
                   },
                  layout: {
                     padding: {
                        top: 30,
                        bottom: 20
                     }
                  },
                  scales: {
                     x: {
                        grid: {
                           display: false
                        },
                        ticks: {
                           color: "#7D838D",
                           font: {
                              size: 12
                           },
                        },
                    },
                    y: {
                       ticks: {
                          display:false
                       },
                       grid: {
                          drawBorder: false,
                       },
                    }
                  },
                  responsive: false,
                  plugins: {
                     legend: {
                        display: false
                     },
                     datalabels: {
                        anchor: "end",
                        align : "top",
                        color: "#4B4B4B",
                        font: {
                           weight: "bold",
                           size: 15
                        },
                     }
                  },
               }
            });
         }.bind(this);
         for (let i = 0; i < this.cate_list.length; i++) {
            this.cateChart_list[i] = getChart(i, backgroundColor_list[i]);
         }
      },
      /* -----------------------------------------------------------------------------------
            통계값 조회
         ---------------------------------------------------------------------------------- */
      getStatisticsBasePoint: function(cate_idx){
         return this.statistics_list[cate_idx]
            && this.statistics_list[cate_idx].base_point;
      },
   },
   computed: {
      /* -----------------------------------------------------------------------------------
            선택된 군의 정보 반환
         ---------------------------------------------------------------------------------- */
      getSelGunInfo: function(){
         return this.gun_list.find(function(obj){
            return obj.eval_group_cd === this.sel_gun;
         }.bind(this)) || null;
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
            선택된 군에 속한 협회의 배열 반환
         ---------------------------------------------------------------------------------- */
      getSetGroupList: function(){
         return this.group_list.filter(function(obj){
            return obj.eval_group_cd === this.sel_gun;
         }.bind(this));
      },
   },
});
