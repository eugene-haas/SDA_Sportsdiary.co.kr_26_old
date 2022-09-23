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
      cate_list: [],
      deductScore_list: [],
      gun_list: [],
      gunScore_list: [],
      totalScore_list: [],


      totalChart: null,
      cateChart1: null,
      cateChart2: null,
      cateChart3: null,
      cateChart4: null,
      cateChart5: null,
      deductChart: null,
   },
   created: function() {
      this.initEvalList();
   },
   mounted: function() {

   },
   methods: {
      /* -----------------------------------------------------------------------------------
            init eval list
         ---------------------------------------------------------------------------------- */
      initEvalList: function() {
         const path = "/api/ajax/mgr_viewer/total_eval/group_eval_init.asp";
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

            this.reqEvalData();
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            req option data
         ---------------------------------------------------------------------------------- */
      reqEvalData: function() {
         const path = "/api/ajax/mgr_viewer/total_eval/group_eval.asp";
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
            this.cate_list = cm_fn.copyObjEx(res.data.cate_info, []);
            this.gunScore_list = cm_fn.copyObjEx(res.data.group_point_info, []);
            this.totalScore_list = cm_fn.copyObjEx(res.data.total_info, []);

            this.deductScore_list = cm_fn.copyObjEx(res.data.subtract_info, []);
            this.$nextTick(function(){
               if (this.totalScore_list.length) {
                  this.makeChart_total();
                  this.makeChart_cate1();
                  this.makeChart_cate2();
                  this.makeChart_cate3();
                  this.makeChart_cate4();
                  this.makeChart_cate5();
                  this.makeChart_deduct();

                  this.updateChart();
               } else {
                  if (this.totalChart instanceof Chart) {
                     this.totalChart.destroy();
                  }
                  if (this.cateChart1 instanceof Chart) {
                     this.cateChart1.destroy();
                  }
                  if (this.cateChart2 instanceof Chart) {
                     this.cateChart2.destroy();
                  }
                  if (this.cateChart3 instanceof Chart) {
                     this.cateChart3.destroy();
                  }
                  if (this.cateChart4 instanceof Chart) {
                     this.cateChart4.destroy();
                  }
                  if (this.cateChart5 instanceof Chart) {
                     this.cateChart5.destroy();
                  }
                  if (this.deductChart instanceof Chart) {
                     this.deductChart.destroy();
                  }
               }
            });
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            차트 초기화
         ---------------------------------------------------------------------------------- */
      resetChart: function(chart) {
         chart.data.datasets.forEach((dataset, idx) => {
            dataset.data = [];
         });
         chart.update();
      },
      /* -----------------------------------------------------------------------------------
            차트 업데이트
         ---------------------------------------------------------------------------------- */
      updateChart: function() {
         this.resetChart(this.totalChart);
         this.totalChart.data.labels = [];

         this.resetChart(this.cateChart1);
         this.resetChart(this.cateChart2);
         this.resetChart(this.cateChart3);
         this.resetChart(this.cateChart4);
         this.resetChart(this.cateChart5);
         this.resetChart(this.deductChart);
         this.cateChart1.data.labels = [];
         this.cateChart2.data.labels = [];
         this.cateChart3.data.labels = [];
         this.cateChart4.data.labels = [];
         this.cateChart5.data.labels = [];
         this.deductChart.data.labels = [];

         for (let i = 0; i < this.gun_list.length; i++) {
            const gun_info = this.gun_list[i];
            const totalScore_info = this.totalScore_list.find(function(obj){
               return obj.eval_group_cd === gun_info.eval_group_cd;
            }) || null;
            const deductScore_info = this.deductScore_list.find(function(obj){
               return obj.eval_group_cd === gun_info.eval_group_cd;
            }) || null;
            this.totalChart.data.datasets[0].data.push(totalScore_info && totalScore_info.total_point);
            this.deductChart.data.datasets[0].data.push(deductScore_info && deductScore_info.subtract_point);


            for (let j = 0; j < this.cate_list.length; j++) {
               const cate_info = this.cate_list[j];
               const gunScore_info = this.gunScore_list.find(function(obj){
                  return obj.eval_group_cd === gun_info.eval_group_cd && obj.eval_cate_cd === cate_info.eval_cate_cd;
               }) || null;
               this["cateChart"+cate_info.eval_cate_cd].label = cate_info.eval_cate + "("+ cate_info.base_point +")";
               this["cateChart"+cate_info.eval_cate_cd].data.datasets[0].data.push(gunScore_info && gunScore_info.ave_point);
               this["cateChart"+cate_info.eval_cate_cd].data.labels.push(gun_info.eval_group + "군");
            }
            this.totalChart.data.labels.push(gun_info.eval_group + "군");
            this.deductChart.data.labels.push(gun_info.eval_group + "군");
         }
         this.totalChart.update();
         this.cateChart1.update();
         this.cateChart2.update();
         this.cateChart3.update();
         this.cateChart4.update();
         this.cateChart5.update();
         this.deductChart.update();
      },
      /* -----------------------------------------------------------------------------------
            전체 차트
         ---------------------------------------------------------------------------------- */
      makeChart_total: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: "종합",
                  data: [
                     0,0,0,0,0
                  ],
                  borderColor: "#6978ff",
                  backgroundColor: "rgba(105, 160, 255, 0.6)",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent"
               }
            ]
         };
         const config = {
            type: "radar",
            data: data,
            options: {
               layout: {
                  padding: {
                     top: 20,
                     bottom: 20
                  }
               },
               scales: {
                  r: {
                     title: {
                        display: true
                     },
                     angleLines: {
                        display: true
                     },
                     max: 100,
                     min: 0,
                     // suggestedMin: 50,
                     pointLabels: {
                        font: {
                           size: 14
                        }
                     },
                     ticks: {
                        stepSize: 10,
                        font: {
                           size: 0
                        }
                     }
                  }
               },
               responsive: false,
               plugins: {
                  legend: {
                     display: false
                  },
                  tooltip: {
                     usePointStyle: true,
                     callbacks: {
                        labelColor: function(ctx) {
                           const chart = ctx.chart;
                           const datasetIndex = ctx.datasetIndex;
                           const borderColor = chart.legend.legendItems[datasetIndex].strokeStyle;
                           const backgroundColor = chart.legend.legendItems[datasetIndex].strokeStyle;

                           return {borderColor: borderColor, backgroundColor: backgroundColor};
                        }
                     }
                  },
                  datalabels: {
                     align: "start",
                     color: "#222222",
                     font: {
                        weight: "bold"
                     },
                     padding: 8
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
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_cate1: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: "비전전략(15)",
                  data: [
                     0,0,0,0,0
                  ],
                  backgroundColor: [
                     "#96C1D4", "#9896D4", "#C896D4", "#D496A5", "#D4C696"
                  ],
                  barThickness: 20
               }
            ]
         };
         if (this.cateChart1 instanceof Chart) {
            this.cateChart1.destroy();
         }
         this.cateChart1 = new Chart(document.getElementById("cateChart1"), {
            type: "bar",
            data: data,
            options: {
               dataCenter: true, // /js/library/Chart/chart.js:7619 에 추가
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        // delay = context.datasetIndex * 100;
                        delay = context.dataIndex * 200;
                     }
                     return delay;
                  }
               },
               indexAxis: "y",
               layout: {
                  padding: {
                     top: 30,
                     bottom: 20,
                  }
               },
               scales: {
                  x: {
                     display: false,
                  },
                  y: {
                     max: 15,
                     grid: {
                        display: false
                     },
                  }
               },
               responsive: false,
               plugins: {
                  legend: {
                     display: false
                  },
                  datalabels: {
                     color: "#4B4B4B",
                     font: {
                        weight: "bold",
                        size: 15
                     }
                  }
               }
            }
         });
      },
      /* -----------------------------------------------------------------------------------
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_cate2: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: "조직운영(20)",
                  data: [
                     0,0,0,0,0
                  ],
                  backgroundColor: [
                     "#96C1D4", "#9896D4", "#C896D4", "#D496A5", "#D4C696"
                  ],
                  barThickness: 16
               }
            ]
         };
         if (this.cateChart2 instanceof Chart) {
            this.cateChart2.destroy();
         }
         this.cateChart2 = new Chart(document.getElementById("cateChart2"), {
            type: "bar",
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        // delay = context.datasetIndex * 100;
                        delay = context.dataIndex * 200 + 500;
                     }
                     return delay;
                  }
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
                     }
                  },
                  y: {
                     max: 20,
                     min: 0,
                     grid: {
                        drawBorder: false
                     }
                  }
               },
               responsive: false,
               plugins: {
                  legend: {
                     display: false
                  },
                  datalabels: {
                     anchor: "end",
                     align: "top",
                     color: "#4B4B4B",
                     font: {
                        weight: "bold",
                        size: 15
                     }
                  }
               }
            }
         });
      },

      /* -----------------------------------------------------------------------------------
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_cate3: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: "주요사업(40)",
                  data: [
                     0,0,0,0,0
                  ],
                  backgroundColor: [
                     "#96C1D4", "#9896D4", "#C896D4", "#D496A5", "#D4C696"
                  ],
                  barThickness: 24
               }
            ]
         };
         if (this.cateChart3 instanceof Chart) {
            this.cateChart3.destroy();
         }
         this.cateChart3 = new Chart(document.getElementById("cateChart3"), {
            type: "bar",
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        // delay = context.datasetIndex * 100;
                        delay = context.dataIndex * 200 + 1000;
                     }
                     return delay;
                  }
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
                     }
                  },
                  y: {
                     max: 40,
                     min: 0,
                     grid: {
                        drawBorder: false
                     }
                  }
               },
               responsive: false,
               plugins: {
                  legend: {
                     display: false
                  },
                  datalabels: {
                     anchor: "end",
                     align: "top",
                     color: "#4B4B4B",
                     font: {
                        weight: "bold",
                        size: 15
                     }
                  }
               }
            }
         });
      },

      /* -----------------------------------------------------------------------------------
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_cate4: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: "단체자율성(15)",
                  data: [
                     0,0,0,0,0
                  ],
                  borderColor: "#ED7D31",
                  pointRadius: 4,
                  pointBackgroundColor: "#ED7D31"
               }
            ]
         };
         if (this.cateChart4 instanceof Chart) {
            this.cateChart4.destroy();
         }
         this.cateChart4 = new Chart(document.getElementById("cateChart4"), {
            type: "line",
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        // delay = context.datasetIndex * 100;
                        delay = context.dataIndex * 200 + 1500;
                     }
                     return delay;
                  }
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
                  },
                  y: {
                     suggestedMax: 15,
                     min: 0,
                     ticks: {
                        stepSize: 3
                     },
                     grid: {
                        drawBorder: false
                     }
                  }
               },
               responsive: false,
               plugins: {
                  legend: {
                     display: false
                  },
                  datalabels: {
                     display: false
                  }
               }
            }
         });
      },

      /* -----------------------------------------------------------------------------------
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_cate5: function() {
         var pointImage1 = new Image();
         pointImage1.src = "/images/chart/ga.svg";
         var pointImage2 = new Image();
         pointImage2.src = "/images/chart/na.svg";
         var pointImage3 = new Image();
         pointImage3.src = "/images/chart/da.svg";
         var pointImage4 = new Image();
         pointImage4.src = "/images/chart/ra.svg";
         var pointImage5 = new Image();
         pointImage5.src = "/images/chart/ma.svg";
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: "인권 및 윤리(10)",
                  data: [
                     9, 8, 7, 5, 10
                  ],
                  backgroundColor: [
                     "#96C1D4", "#9896D4", "#C896D4", "#D496A5", "#D4C696"
                  ],
                  borderWidth: 0,
                  pointRadius: 4,
               }
            ]
         };
         const chartAreaBorder = {
           id: "chartAreaBorder",
           beforeDraw(chart, args, options) {
             const {ctx, chartArea: {left, top, width, height}} = chart;
             ctx.save();
             ctx.strokeStyle = options.borderColor;
             ctx.lineWidth = options.borderWidth;
             ctx.setLineDash(options.borderDash || []);
             ctx.lineDashOffset = options.borderDashOffset;
             ctx.strokeRect(left, top, width, height);
             ctx.restore();
           }
         };
         if (this.cateChart5 instanceof Chart) {
            this.cateChart5.destroy();
         }
         this.cateChart5 = new Chart(document.getElementById("cateChart5"), {
            type: "line",
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        // delay = context.datasetIndex * 100;
                        delay = context.dataIndex * 200 + 2000;
                     }
                     return delay;
                  }
               },
               layout: {
                  padding: {
                     top: 30,
                     bottom: 20,
                     left: 0,
                     right: 0,
                  }
               },
               scales: {
                  x: {
                     ticks: {},
                     grid: {
                        display: false,
                     },
                     offset: true,
                  },
                  y: {
                     suggestedMax: 10 * 1.2,
                     min: 0,
                     ticks: {
                        stepSize: 1,
                        display: false,
                     },
                     grid: {
                        drawBorder: false,
                        tickLength: 0,
                     },
                  }
               },
               responsive: false,
               plugins: {
                  legend: {
                     display: false
                  },
                  tooltip: {
                     usePointStyle: false
                  },
                  datalabels: {
                     display: false
                  },
                  chartAreaBorder: {
                    borderColor: "#D8D8D8",
                    borderWidth: 1,
                 },
               }
            },
            plugins: [
               {
                  afterDraw: function(chart) {
                     chart.getDatasetMeta(0).data[0].options.pointStyle = pointImage1;
                     chart.getDatasetMeta(0).data[1].options.pointStyle = pointImage2;
                     chart.getDatasetMeta(0).data[2].options.pointStyle = pointImage3;
                     chart.getDatasetMeta(0).data[3].options.pointStyle = pointImage4;
                     chart.getDatasetMeta(0).data[4].options.pointStyle = pointImage5;
                  }
               },
               chartAreaBorder
            ]
         });
      },
      /* -----------------------------------------------------------------------------------
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_deduct: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: "공정 및 인권 위반 사례(-α)",
                  data: [
                     0,0,0,0,0
                  ],
                  backgroundColor: [
                     "#96C1D4", "#9896D4", "#C896D4", "#D496A5", "#D4C696"
                  ],
                  barThickness: 16
               }
            ]
         };
         if (this.deductChart instanceof Chart) {
            this.deductChart.destroy();
         }
         this.deductChart = new Chart(document.getElementById("deductChart"), {
            type: "bar",
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        // delay = context.datasetIndex * 100;
                        delay = context.dataIndex * 200 + 2500;
                     }
                     return delay;
                  }
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
                     }
                  },
                  y: {
                     grid: {
                        drawBorder: false
                     }
                  }
               },
               responsive: false,
               plugins: {
                  legend: {
                     display: false
                  },
                  datalabels: {
                     anchor: "end",
                     align: "top",
                     color: "#4B4B4B",
                     font: {
                        weight: "bold",
                        size: 15
                     }
                  }
               }
            }
         });
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
   },
});
