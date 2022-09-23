const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      sel_group: null,
      group_list: [
         "대한축구협회",
         "대한야구소프트볼협회",
         "대한태권도협회",
         "대한골프협회",
         "대한민국농구협회",
         "대한민국배구협회",
         "대한배드민턴협회",
         "대한자전거연맹",
         "대한사격연맹",
         "대한스키협회",
         "대한육상연맹",
         "대한체조협회",
         "대한탁구협회",
         "대한테니스협회",
         "대한펜싱협회",
         "대한핸드볼협회",
         "대한빙상경기연맹"
      ],
      res_list: [
         {
            type: E_TYPE_ALL,
            cnt_list: [
               {
                  type: E_TYPE_VISION,
                  name: STRMAP_TYPE[E_TYPE_VISION] + "(" + STRMAP_TYPE_SCORE[E_TYPE_VISION] + ")",
                  score: "12.4",
                  subScore: "82.6",
                  gunScore: "10.2",
                  subGunScore: "68",
                  totalScore: "7.9",
                  subTotalScore: "52.7"
               }, {
                  type: E_TYPE_ORG,
                  name: STRMAP_TYPE[E_TYPE_ORG] + "(" + STRMAP_TYPE_SCORE[E_TYPE_ORG] + ")",
                  score: "15.5",
                  subScore: "77.5",
                  gunScore: "14.7",
                  subGunScore: "73.9",
                  totalScore: "14.9",
                  subTotalScore: "74.5"
               }, {
                  type: E_TYPE_BUSINESS,
                  name: STRMAP_TYPE[E_TYPE_BUSINESS] + "(" + STRMAP_TYPE_SCORE[E_TYPE_BUSINESS] + ")",
                  score: "28.6",
                  subScore: "71.5",
                  gunScore: "25.5",
                  subGunScore: "63.8",
                  totalScore: "20.2",
                  subTotalScore: "50.5"
               }, {
                  type: E_TYPE_AUTONOMY,
                  name: STRMAP_TYPE[E_TYPE_AUTONOMY] + "(" + STRMAP_TYPE_SCORE[E_TYPE_AUTONOMY] + ")",
                  score: "10.6",
                  subScore: "70.7",
                  gunScore: "10.7",
                  subGunScore: "71.3",
                  totalScore: "7.2",
                  subTotalScore: "48"
               }, {
                  type: E_TYPE_ETHICS,
                  name: STRMAP_TYPE[E_TYPE_ETHICS] + "(" + STRMAP_TYPE_SCORE[E_TYPE_ETHICS] + ")",
                  score: "6.6",
                  subScore: "66",
                  gunScore: "7.5",
                  subGunScore: "75",
                  totalScore: "7.5",
                  subTotalScore: "75"
               }
            ]
         }, {
            type: E_TYPE_BUSINESS,
            cnt_list: [
               {
                  type: E_TYPE_BUSINESS_LIFE,
                  name: STRMAP_TYPE_BUSINESS[E_TYPE_BUSINESS_LIFE] + "(" + STRMAP_TYPE_BUSINESS_SCORE[E_TYPE_BUSINESS_LIFE] + ")",
                  score: "9.1",
                  subScore: "75.4",
                  score1: "3.6",
                  score2: "5.5",
                  gunScore: "9.3",
                  subGunScore: "77.6",
                  gunScore1: "3.21",
                  gunScore2: "6.1",
                  totalScore: "6.6",
                  subTotalScore: "54.9",
                  totalScore1: "2.69",
                  totalScore2: "3.9"
               }, {
                  type: E_TYPE_BUSINESS_PRO,
                  name: STRMAP_TYPE_BUSINESS[E_TYPE_BUSINESS_PRO] + "(" + STRMAP_TYPE_BUSINESS_SCORE[E_TYPE_BUSINESS_PRO] + ")",
                  score: "15.0",
                  subScore: "83.3",
                  score1: "6.2",
                  score2: "8.8",
                  gunScore: "14.7",
                  subGunScore: "81.7",
                  gunScore1: "5.5",
                  gunScore2: "9.2",
                  totalScore: "10.0",
                  subTotalScore: "55.6",
                  totalScore1: "4.4",
                  totalScore2: "5.6"
               }, {
                  type: E_TYPE_BUSINESS_SCHOOL,
                  name: STRMAP_TYPE_BUSINESS[E_TYPE_BUSINESS_SCHOOL] + "(" + STRMAP_TYPE_BUSINESS_SCORE[E_TYPE_BUSINESS_SCHOOL] + ")",
                  score: "3.5",
                  subScore: "70.0",
                  score1: "1.3",
                  score2: "2.2",
                  gunScore: "3.4",
                  subGunScore: "68.0",
                  gunScore1: "1.2",
                  gunScore2: "2.2",
                  totalScore: "1.9",
                  subTotalScore: "38.0",
                  totalScore1: "0.6",
                  totalScore2: "1.3"
               }, {
                  type: E_TYPE_BUSINESS_VIRTUOUS,
                  name: STRMAP_TYPE_BUSINESS[E_TYPE_BUSINESS_VIRTUOUS] + "(" + STRMAP_TYPE_BUSINESS_SCORE[E_TYPE_BUSINESS_VIRTUOUS] + ")",
                  score: "2.1",
                  subScore: "42.0",
                  score1: "1.3",
                  score2: "0.8",
                  gunScore: "3.5",
                  subGunScore: "70.0",
                  gunScore1: "2.1",
                  gunScore2: "1.4",
                  totalScore: "2.8",
                  subTotalScore: "56.0",
                  totalScore1: "1.6",
                  totalScore2: "1.2"
               }
            ]
         }
      ],
      tab_list: [
         {
            value: E_TYPE_ALL,
            name: "전체"
         }, {
            value: E_TYPE_VISION,
            name: "1.비전전략"
         }, {
            value: E_TYPE_ORG,
            name: "2.조직운영"
         }, {
            value: E_TYPE_BUSINESS,
            name: "3.주요사업"
         }, {
            value: E_TYPE_AUTONOMY,
            name: "4.단체자율성"
         }, {
            value: E_TYPE_ETHICS,
            name: "5.인권 및 윤리"
         }
      ],
      sel_tab: 0,
      totalChart: null,
      detailChart01: null,
      detailChart02: null,
      detailBarChart: null
   },
   created: function() {},
   mounted: function() {
      this.makeChart_total();
      this.makeChart_detail01();
      this.makeChart_detail02();
      this.makeChart_bar();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            체육단체 선택
         ---------------------------------------------------------------------------------- */
      reqGroup: function(idx) {
         this.sel_group = idx;
         this.sel_tab = E_TYPE_ALL;
         this.updateChart();
      },
      /* -----------------------------------------------------------------------------------
            탭 선택
         ---------------------------------------------------------------------------------- */
      handleChangeTab: function(idx) {
         this.sel_tab = idx;
         this.updateChart();
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
         const setData = function(dataset, idx){
            const key = idx === 0 ? "subScore" :
                        idx === 1 ? "subGunScore" :
                        idx === 2 ? "subTotalScore" : "";
            const list = this.getRes.cnt_list;
            const data = [];
            for (var i = 0; i < list.length; i++) {
               data.push(list[i][key]);
            }
            dataset.data = data;
         }.bind(this);
         const setBarData = function(dataset, idx) {
            const key = idx === 0 ? "score" :
                        idx === 1 ? "gunScore" :
                        idx === 2 ? "gunScore" : "";
            const list = this.getRes.cnt_list;
            const data = [];
            for (var i = 0; i < list.length; i++) {
               data.push(list[i][key + '1']);
               data.push(list[i][key + '2']);
            }
            dataset.data = data;
         }.bind(this);
         if (this.sel_tab === E_TYPE_ALL) {
            this.resetChart(this.totalChart);
            this.totalChart.data.datasets.forEach(setData);
            this.totalChart.update();
         } else {
            this.resetChart(this.detailChart01);
            this.resetChart(this.detailChart02);
            this.resetChart(this.detailBarChart);
            this.detailChart01.data.datasets.forEach(setData);
            this.detailChart02.data.datasets.forEach(setData);
            this.detailBarChart.data.datasets.forEach(setBarData);
            this.detailChart01.update();
            this.detailChart02.update();
            this.detailBarChart.update();
         }
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
                  label: '대한축구협회',
                  data: [
                     20, 65, 45, 96, 57
                  ],
                  borderColor: "#0B5EBE",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent"
               }, {
                  label: '가군평균',
                  data: [
                     44, 42, 26, 78, 87
                  ],
                  borderColor: "#ED7D31",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent"
               }, {
                  label: '전체평균',
                  data: [
                     44, 42, 26, 78, 87
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
            type: 'radar',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === 'data' && context.mode === 'default') {
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
                           weight: 'medium'
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
         this.totalChart = new Chart(document.getElementById('totalChart'), config);
      },
      /* -----------------------------------------------------------------------------------
            세부항목 차트
         ---------------------------------------------------------------------------------- */
      makeChart_detail01: function() {
         const data = {
            labels: [
               "생활체육", "전문체육", "학교체육", "선순환체계"
            ],
            datasets: [
               {
                  label: '대한축구협회',
                  data: [
                     20, 65, 45, 96
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
            type: 'radar',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === 'data' && context.mode === 'default') {
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
         this.detailChart01 = new Chart(document.getElementById('detailChart01'), config);
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
                  label: '대한축구협회',
                  data: [
                     20, 65, 45, 96
                  ],
                  borderColor: "#0B5EBE",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }, {
                  label: '가군평균',
                  data: [
                     44, 42, 26, 78
                  ],
                  borderColor: "#ED7D31",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }, {
                  label: '전체평균',
                  data: [
                     64, 42, 28, 45
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
            type: 'radar',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === 'data' && context.mode === 'default') {
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
         this.detailChart02 = new Chart(document.getElementById('detailChart02'), config);
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
                  label: '대한축구협회',
                  data: [
                     20,
                     65,
                     45,
                     96,
                     65,
                     45,
                     96,
                     96
                  ],
                  backgroundColor: "#0B5EBE",
                  barThickness: 14
               }, {
                  label: '가군평균',
                  data: [
                     20,
                     65,
                     45,
                     96,
                     65,
                     45,
                     96,
                     96
                  ],
                  backgroundColor: "#ED7D31",
                  barThickness: 14
               }, {
                  label: '전체평균',
                  data: [
                     20,
                     65,
                     45,
                     96,
                     65,
                     45,
                     96,
                     96
                  ],
                  backgroundColor: "#AEAEAE",
                  barThickness: 14
               }
            ]
         };
         const config = {
            type: 'bar',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === 'data' && context.mode === 'default') {
                        // delay = context.datasetIndex * 100;
                        delay = context.dataIndex * 200 + context.datasetIndex * 100;
                     }
                     return delay;
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
                     anchor: 'end',
                     align: 'top',
                     color: '#2C4674',
                     font: {
                        weight: 'bold',
                        size: 9
                     }
                  }
               }
            }
         };
         this.detailBarChart = new Chart(document.getElementById('detailBarChart'), config);
      },
      /* -----------------------------------------------------------------------------------
            req match list
         ---------------------------------------------------------------------------------- */
      // reqMatchList: function() {
      //    const path = '/game_manager/ajax/api/api.SWIM_300.asp';
      //    const params = {};
      //    axios.post(path, params).then(function(res) {
      //       log(res);
      //       if (String(res.data.result) !== E_API_STATUS_SUCCESS) {
      //          alert('리스트 조회 실패');
      //          return;
      //       }
      //       this.match_list = cm_fn.copyObjEx(res.data.list, []);
      //    }.bind(this));
      // }
   },
   computed: {
      getRes: function() {
         if (this.sel_tab === E_TYPE_ALL) {
            return this.res_list[0];
         } else {
            return this.res_list[1];
         }
      }
   }
});
