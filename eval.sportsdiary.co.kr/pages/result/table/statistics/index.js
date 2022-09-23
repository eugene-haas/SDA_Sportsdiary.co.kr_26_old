const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      init_obj: g_etc_obj,
      cate_list: [],
      sel_cate: null,
      deduct_info: null,
      subcate_list: [],
      item_list: [],
      tabBarStyle: {
         width: 0,
         left: "136.5px",
      },
      totalChart: null,
      detailChart01: null,
      detailChart02: null,
      detailBarChart01Wide: null,
      detailBarChart01: null,
      detailBarChart02: null,
      detailBarChart: null
   },
   created: function() {
      this.initCateList();
   },
   mounted: function() {
      this.makeChart_total();
      this.makeChart_detailBar01();
      this.makeChart_detailBar02();
      this.makeChart_detail01();
      this.makeChart_detail02();
      this.makeChart_bar();
      // chart
      const setChartZoom = function(){
         const chartWrap = this.$refs.chartWrap;
         const chartTbl = this.$refs.chartTbl;
         const chart = this.$refs.chart;
         const minWidth = 1280;
         const scaleVal = (chartWrap.offsetWidth / 1000)
         if (window.outerWidth > minWidth) {
            chart.style.transform = 'scale(' + scaleVal + ')';
            chartWrap.style.height = (577 * scaleVal) +'px';
            chartTbl.style.width = (460 * scaleVal) +'px';
         } else {
            chart.style.transform = null;
            chartWrap.style.height = null;
            chartTbl.style.width = null;
         }
      }.bind(this)
      window.addEventListener("DOMContentLoaded", setChartZoom);
      window.addEventListener('resize', setChartZoom);
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            req print
         ---------------------------------------------------------------------------------- */
      reqPrint: function(){
         window.print();
      },
      /* -----------------------------------------------------------------------------------
            리스트로 이동
         ---------------------------------------------------------------------------------- */
      goList: function(){
         cm_fn.goto_url("/pages/result/table/index.asp", {
            etc_obj: {
               sel_eval: this.init_obj.sel_eval,
               sel_gun: this.init_obj.sel_gun,
               sel_group: this.init_obj.sel_group,
            },
         });
      },
      /* -----------------------------------------------------------------------------------
            init cate list
         ---------------------------------------------------------------------------------- */
      initCateList: function() {
         const path = "/api/ajax/mgr_viewer/statistics/cate_statistics.asp";
         const params = {
            eval_table_idx: this.init_obj.sel_eval,
            association_idx: this.init_obj.sel_group,
         };
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("정보 조회 실패");
               return;
            }
            this.cate_list = cm_fn.copyObjEx(res.data.statistics_info, []);
            this.deduct_info = cm_fn.copyObjEx(res.data.subtract_info[0], null);
            this.sel_cate = E_TYPE_ALL;
            this.initSubCateList();

            this.$nextTick(function(){
               this.calcTabStyle();
               this.updateChart();
            });
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            init sub cate list
         ---------------------------------------------------------------------------------- */
      initSubCateList: function() {
         const path = "/api/ajax/mgr_viewer/statistics/subcate_statistics.asp";
         const params = {
            eval_table_idx: this.init_obj.sel_eval,
            association_idx: this.init_obj.sel_group,
         };
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("정보 조회 실패");
               return;
            }
            this.subcate_list = cm_fn.copyObjEx(res.data.statistics_info, []);
            this.item_list = cm_fn.copyObjEx(res.data.item_type_info, []);
            for (let i = 0; i < this.cate_list.length; i++) {
               const cate_info = this.cate_list[i];
               const subcate_list = this.subcate_list.filter(function(obj){
                  return obj.eval_cate_cd === cate_info.eval_cate_cd;
               }.bind(this));

               for (let j = 0; j < subcate_list.length; j++) {
                  const subcate_info = subcate_list[j];
                  const item_list = this.item_list.filter(function(obj){
                     return obj.eval_cate_cd === cate_info.eval_cate_cd && obj.eval_subcate_cd === subcate_info.eval_subcate_cd;
                  }.bind(this));
                  for (let k = 0; k < item_list.length; k++) {
                     const item_info = item_list[k];
                     item_info.showType = item_info.showType || false;
                     const nextItem_info = item_list[k + 1];
                     if (nextItem_info && item_info.eval_cate_cd === nextItem_info.eval_cate_cd
                        && item_info.eval_subcate_cd === nextItem_info.eval_subcate_cd
                        && item_info.eval_item_cd === nextItem_info.eval_item_cd) {
                        item_info.showType = true;
                        nextItem_info.showType = true;
                     }
                  }
                  subcate_info.item_list = item_list;
               }
               cate_info.subcate_list = subcate_list;
            }
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            탭바 가로사이즈 계산
         ---------------------------------------------------------------------------------- */
      calcTabStyle: function(){
         const sel_tab = Number(this.sel_cate);
         if (this.$refs.tabs === undefined) return;
         const tab_el = this.$refs.tabs[sel_tab||0];
         const tabWidth = tab_el.offsetWidth;
         this.tabBarStyle.width = tab_el.children[0].offsetWidth + "px";
         this.tabBarStyle.left = (tabWidth * (sel_tab+0.5)) + "px";
      },
      /* -----------------------------------------------------------------------------------
            탭 선택
         ---------------------------------------------------------------------------------- */
      handleChangeTab: function(eval_cate_cd) {
         this.sel_cate = eval_cate_cd;
         this.$nextTick(function(){
            this.calcTabStyle();
            this.updateChart();
         });
      },
      /* -----------------------------------------------------------------------------------
            차트 초기화
         ---------------------------------------------------------------------------------- */
      resetChart: function(chart) {
         chart.data.datasets.forEach(function(dataset, idx){
            dataset.data = [];
         });
         chart.update();
      },
      /* -----------------------------------------------------------------------------------
            sel_tab 에 따른 차트 업데이트
         ---------------------------------------------------------------------------------- */
      updateChart: function() {
         const label_list = [this.init_obj.association_name, this.init_obj.eval_group + "군평균", "전체평균"];
         if (this.sel_cate === E_TYPE_ALL) {
            this.resetChart(this.totalChart);
            this.totalChart.data.datasets.forEach(function(dataset, idx){
               const key = idx === 0 ? "percent_assoc" :
                           idx === 1 ? "percent_group" :
                           idx === 2 ? "percent_total" : "";
               const cate_list = this.cate_list;
               const data = [];
               for (let i = 0; i < cate_list.length; i++) {
                  data.push(cate_list[i][key]);
               }
               dataset.data = data;
            }.bind(this));
            this.totalChart.update();
            return;
         }
         const setData = function(dataset, idx){
            const key = idx === 0 ? "percent_assoc" :
                        idx === 1 ? "percent_group" :
                        idx === 2 ? "percent_total" : "";
            const cate_info = this.getSelCateInfo;
            const subcate_list = cate_info.subcate_list;
            const data = [];
            for (let i = 0; i < subcate_list.length; i++) {
               data.push(subcate_list[i][key]);
            }
            dataset.label = label_list[idx];
            dataset.data = data;
         }.bind(this);
         const setBarData = function(dataset, idx) {
            const key = idx === 0 ? "point_assoc" :
                        idx === 1 ? "point_group" :
                        idx === 2 ? "point_total" : "";
            const cate_info = this.getSelCateInfo;
            if (cate_info === null)return;
            const subcate_list = cate_info.subcate_list;
            const data = [];
            for (let i = 0; i < subcate_list.length; i++) {
               const subcate_info = subcate_list[i];
               for (let j = 0; j < subcate_info.item_list.length; j++) {
                  data.push(subcate_info.item_list[j][key]);
               }
            }
            dataset.label = label_list[idx];
            dataset.data = data;
         }.bind(this);
         const cate_info = this.getSelCateInfo;
         const subcate_list = cate_info.subcate_list;
         const labels = [];
         const barLabels = [];
         for (let i = 0; i < subcate_list.length; i++) {
            const subcate_info = subcate_list[i];
            labels.push(subcate_info.eval_subcate);
            for (let j = 0; j < subcate_info.item_list.length; j++) {
               barLabels.push(subcate_info.item_list[j].eval_item);
            }
            const labelStr = subcate_info.eval_cate_cd + "." + subcate_info.eval_subcate_cd + " " + subcate_info.eval_subcate;
            const dataList = [
               subcate_info.percent_assoc,
               subcate_info.percent_group,
               subcate_info.percent_total,
            ];
            if (subcate_list.length < 3) {
               if (i === 0) {
                  this.detailBarChart01.data.datasets[0].label = labelStr;
                  this.detailBarChart01.data.datasets[0].data = dataList;
                  this.detailBarChart01Wide.data.datasets[0].label = labelStr;
                  this.detailBarChart01Wide.data.datasets[0].data = dataList;
               } else if (i === 1) {
                  this.detailBarChart02.data.datasets[0].label = labelStr;
                  this.detailBarChart02.data.datasets[0].data = dataList;
               }
            }
         }
         this.detailChart01.data.labels = labels;
         this.detailChart02.data.labels = labels;
         this.detailBarChart.data.labels = barLabels;

         this.detailChart01.data.datasets.forEach(setData);
         this.detailChart02.data.datasets.forEach(setData);
         this.detailBarChart.data.datasets.forEach(setBarData);

         this.detailChart01.update();
         this.detailChart02.update();
         this.detailBarChart01Wide.update();
         this.detailBarChart01.update();
         this.detailBarChart02.update();
         this.detailBarChart.update();
      },
      /* -----------------------------------------------------------------------------------
            전체 차트
         ---------------------------------------------------------------------------------- */
      makeChart_total: function() {
         const data = {
            labels: [
               "비전전략", "조직운영", "주요사업", "단체자율성", "인권 및 윤리"
            ],
            datasets: [
               {
                  label: this.init_obj.association_name,
                  data: [
                     0,0,0,0,0
                  ],
                  borderColor: "#0B5EBE",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent"
               }, {
                  label: this.init_obj.eval_group + "군평균",
                  data: [
                     0,0,0,0,0
                  ],
                  borderColor: "#ED7D31",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent"
               }, {
                  label: "전체평균",
                  data: [
                     0,0,0,0,0
                  ],
                  borderColor: "#AEAEAE",
                  backgroundColor: "transparent",
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
               devicePixelRatio: 2,
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        delay = context.datasetIndex * 100;
                        // delay = context.dataIndex * 300 + context.datasetIndex * 100;
                     }
                     return delay;
                  }
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
                           size: 14
                        }
                     },
                     ticks: {
                        beginAtZero: true,
                        suggestedMin: 0,
                        showLabelBackdrop: false,
                        font: {
                           weight: "medium"
                        },
                        z: 9,
                        stepSize: 10
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
                     display: false
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
            세부항목 차트(2개 이하일 때)
         ---------------------------------------------------------------------------------- */
      makeChart_detailBar01: function() {
         const data = {
            labels: [this.init_obj.association_name, this.init_obj.eval_group + "군평균", "전체평균"],
            datasets: [
               {
                  label: "",
                  data: [
                     0,0,0
                  ],
                  backgroundColor: [
                     "#0B5EBE", "#ED7D31", "#AEAEAE"
                  ],
                  barThickness: 16
               }
            ]
         };
         const config = {
            type: "bar",
            data: data,
            options: {
               devicePixelRatio: 2,
               indexAxis: "y",
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        delay = context.datasetIndex * 100;
                        // delay = context.dataIndex * 300 + context.datasetIndex * 100;
                     }
                     return delay;
                  }
               },
               layout: {
                  padding: {
                     right:30,
                  }
               },
               scales: {
                  x: {
                     grid: {
                        display:false
                     },
                     ticks: {
                        display: false,
                     },
                  },
                  y: {
                     grid: {
                        display:false
                     },
                     ticks: {
                        display: false,
                     },
                  },
               },
               responsive: false,
               plugins: {
                  tooltip: {
                     usePointStyle: true,
                     callbacks: {
                        labelColor: function(ctx) {
                           const chart = ctx.chart;
                           const dataIndex = ctx.dataIndex;
                           const borderColor = chart.data.datasets[0].backgroundColor[dataIndex];
                           const backgroundColor = chart.data.datasets[0].backgroundColor[dataIndex];
                           return {borderColor: borderColor, backgroundColor: backgroundColor};
                        },
                     },
                  },
                  legend: {
                     position: "bottom",
                     align: "start",
                     labels: {
                        boxWidth:0,
                        font: {
                           size: 12,
                           weight: 500,
                           family: "NotoKR",
                           color: "#212121",
                        },
                        padding: 0,
                     },
                     onClick: null
                  },
                  datalabels: {
                     anchor: "end",
                     align: "right",
                     color: "#2C4674",
                     font: {
                        weight: "bold",
                        size: 9,
                     },
                  },
               }
            }
         };
         if (this.detailBarChart01 instanceof Chart) {
            this.detailBarChart01.destroy();
         }
         if (this.detailBarChart01Wide instanceof Chart) {
            this.detailBarChart01Wide.destroy();
         }
         this.detailBarChart01 = new Chart(document.getElementById("detailBarChart01"), config);
         this.detailBarChart01Wide = new Chart(document.getElementById("detailBarChart01Wide"), config);
      },
      /* -----------------------------------------------------------------------------------
            세부항목 차트(2개 이하일 때)
         ---------------------------------------------------------------------------------- */
      makeChart_detailBar02: function() {
         const data = {
            labels: [this.init_obj.association_name, this.init_obj.eval_group + "군평균", "전체평균"],
            datasets: [
               {
                  label: "",
                  data: [
                     0,0,0
                  ],
                  backgroundColor: [
                     "#0B5EBE", "#ED7D31", "#AEAEAE"
                  ],
                  barThickness: 16
               }
            ]
         };
         const config = {
            type: "bar",
            data: data,
            options: {
               devicePixelRatio: 2,
               indexAxis: "y",
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        delay = context.datasetIndex * 100;
                        // delay = context.dataIndex * 300 + context.datasetIndex * 100;
                     }
                     return delay;
                  }
               },
               layout: {
                  padding: {
                     right:30,
                  }
               },
               scales: {
                  x: {
                     grid: {
                        display:false
                     },
                     ticks: {
                        display: false,
                     },
                  },
                  y: {
                     grid: {
                        display:false
                     },
                     ticks: {
                        display: false,
                     },
                  },
               },
               responsive: false,
               plugins: {
                  tooltip: {
                     usePointStyle: true,
                     callbacks: {
                        labelColor: function(ctx) {
                           const chart = ctx.chart;
                           const dataIndex = ctx.dataIndex;
                           const borderColor = chart.data.datasets[0].backgroundColor[dataIndex];
                           const backgroundColor = chart.data.datasets[0].backgroundColor[dataIndex];
                           return {borderColor: borderColor, backgroundColor: backgroundColor};
                        },
                     },
                  },
                  legend: {
                     position: "bottom",
                     align: "start",
                     labels: {
                        boxWidth:0,
                        font: {
                           size: 12,
                           weight: 500,
                           family: "NotoKR",
                           color: "#212121",
                        },
                        padding: 0,
                     },
                     onClick: null,
                  },
                  datalabels: {
                     anchor: "end",
                     align: "right",
                     color: "#2C4674",
                     font: {
                        weight: "bold",
                        size: 9,
                     },
                  },
               }
            }
         };
         if (this.detailBarChart02 instanceof Chart) {
            this.detailBarChart02.destroy();
         }
         this.detailBarChart02 = new Chart(document.getElementById("detailBarChart02"), config);
      },
      /* -----------------------------------------------------------------------------------
            세부항목 차트
         ---------------------------------------------------------------------------------- */
      makeChart_detail01: function() {
         const data = {
            labels: [
               "조직역량 및 혁신", "협치역량 강화", "선순환체계"
            ],
            datasets: [
               {
                  label: "대한축구협회",
                  data: [
                     0,0,0,0
                  ],
                  borderColor: "#0B5EBE",
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
               devicePixelRatio: 2,
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        delay = context.datasetIndex * 100;
                        // delay = context.dataIndex * 300 + context.datasetIndex * 100;
                     }
                     return delay;
                  }
               },
               layout: {
                  // padding: {
                  //    top:20,
                  //    bottom:20,
                  // }
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
                           size: 12,
                           weight: 500,
                           family: "NotoKR"
                        },
                        color: "#212121",
                     },
                     ticks: {
                        beginAtZero: true,
                        suggestedMin: 0,
                        showLabelBackdrop: false,
                        z: 9,
                        stepSize: 20,
                        font: {
                           size: 10
                        }
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
                     display: false
                  },
                  datalabels: {
                     display: false
                  }
               }
            }
         };
         if (this.detailChart01 instanceof Chart) {
            this.detailChart01.destroy();
         }
         this.detailChart01 = new Chart(document.getElementById("detailChart01"), config);
      },
      /* -----------------------------------------------------------------------------------
            세부항목 차트
         ---------------------------------------------------------------------------------- */
      makeChart_detail02: function() {
         const data = {
            labels: [
               "생활체육", "전문체육", "학교체육", "선순환체계"
            ],
            datasets: [
               {
                  label: "대한축구협회",
                  data: [
                     0,0,0,0
                  ],
                  borderColor: "#0B5EBE",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }, {
                  label: "가군평균",
                  data: [
                     0,0,0,0
                  ],
                  borderColor: "#ED7D31",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }, {
                  label: "전체평균",
                  data: [
                     0,0,0,0
                  ],
                  borderColor: "#AEAEAE",
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
               devicePixelRatio: 2,
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        delay = context.datasetIndex * 100 + 100;
                        // delay = context.dataIndex * 300 + context.datasetIndex * 100;
                     }
                     return delay;
                  }
               },
               layout: {
                  // padding: {
                  //    top:20,
                  //    bottom:20,
                  // }
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
                        suggestedMin: 0,
                        showLabelBackdrop: false,
                        z: 9,
                        stepSize: 20,
                        font: {
                           size: 10
                        }
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
                     display: false
                  },
                  datalabels: {
                     display: false
                  }
               }
            }
         };
         if (this.detailChart02 instanceof Chart) {
            this.detailChart02.destroy();
         }
         this.detailChart02 = new Chart(document.getElementById("detailChart02"), config);
      },
      /* -----------------------------------------------------------------------------------
            세부항목 막대 차트
         ---------------------------------------------------------------------------------- */
      makeChart_bar: function() {
         const data = {
            labels: [
               "생활체육 활성화 - 적정성(5/12점)",
               "생활체육 활성화 - 성과 및 관리(7/12점)",
               "전문체육 활성화 - 적정성(7/12점)",
               "전문체육 활성화 - 성과 및 관리(11/12점)",
               "학교체육 활성화 - 적정성(2/12점)",
               "학교체육 활성화 - 성과 및 관리(3/12점)",
               "선순환체계 - 적정성(3/12점)",
               "선순환체계 - 성과 및 관리(2/12점)"
            ],
            datasets: [
               {
                  label: "대한축구협회",
                  data: [
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0
                  ],
                  backgroundColor: "#0B5EBE",
                  barThickness: 14
               }, {
                  label: "가군평균",
                  data: [
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                  ],
                  backgroundColor: "#ED7D31",
                  barThickness: 14
               }, {
                  label: "전체평균",
                  data: [
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                     0,
                  ],
                  backgroundColor: "#AEAEAE",
                  barThickness: 14
               }
            ]
         };
         const config = {
            type: "bar",
            data: data,
            options: {
               devicePixelRatio: 2,
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === "data" && context.mode === "default") {
                        // delay = context.datasetIndex * 100;
                        delay = context.dataIndex * 100 + context.datasetIndex * 50;
                     }
                     return delay;
                  }
               },
               layout: {
                  padding: {
                     top:20,
                  }
               },
               scales: {
                  x: {
                     display: false
                  },
                  y: {
                     max: 11,
                     display: false
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
                     color: "#2C4674",
                     font: {
                        weight: "bold",
                        size: 9,
                     },
                  },
               }
            }
         };
         if (this.detailBarChart instanceof Chart) {
            this.detailBarChart.destroy();
         }
         this.detailBarChart = new Chart(document.getElementById("detailBarChart"), config);
      },
   },
   computed: {
      /* -----------------------------------------------------------------------------------
            탭 리스트 반환
         ---------------------------------------------------------------------------------- */
      getTabList: function(){
         const tab_list = cm_fn.copyObjEx(this.cate_list, []);
         tab_list.unshift({
            eval_cate: "전체",
            eval_cate_cd: E_TYPE_ALL,
            idx: "0",
         });
         return tab_list;
      },
      /* -----------------------------------------------------------------------------------
            선택된 cate info 반환
         ---------------------------------------------------------------------------------- */
      getSelCateInfo: function(){
         return this.cate_list.find(function(obj){
            return obj.eval_cate_cd === this.sel_cate;
         }.bind(this)) || null;
      },
      /* -----------------------------------------------------------------------------------
            선택된 cate info의 item 개수 반환
         ---------------------------------------------------------------------------------- */
      getTotalItemCnt: function(){
         let cnt = 0;
         const cate_info = this.getSelCateInfo;
         if (cate_info === null) return cnt;
         const subcate_list = cate_info.subcate_list;
         for (let i = 0; i < subcate_list.length; i++) {
            cnt += subcate_list[i].item_list.length;
         }
         return cnt;
      },

   }
});
