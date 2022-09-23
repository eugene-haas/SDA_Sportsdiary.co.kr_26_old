const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      totalChart: null,
      typeChart1: null,
      typeChart2: null,
      typeChart3: null,
      typeChart4: null,
      typeChart5: null
   },
   created: function() {},
   mounted: function() {
      this.makeChart_total();
      this.makeChart_type1();
      this.makeChart_type2();
      this.makeChart_type3();
      this.makeChart_type4();
      this.makeChart_type5();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            go input
         ---------------------------------------------------------------------------------- */
      goInput: function(match) {
         const path = '/game_manager/pages/input.asp';
         const pack = {};
         pack.etc_obj = {
            lidx: match.lidx
         };
         cm_fn.goto_url(path, pack);
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
            전체 차트
         ---------------------------------------------------------------------------------- */
      makeChart_total: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: '종합',
                  data: [
                     88.9, 83.9, 81.6, 77.7, 75.7
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
            type: 'radar',
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
                     align: 'start',
                     color: '#222222',
                     font: {
                        weight: 'bold'
                     },
                     padding: 8
                  }
               }
            }
         };
         this.totalChart = new Chart(document.getElementById('totalChart'), config);
      },
      /* -----------------------------------------------------------------------------------
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_type1: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: '비전전략(15)',
                  data: [
                     14, 12.5, 11.9, 11.5, 11.3
                  ],
                  backgroundColor: [
                     '#96C1D4', '#9896D4', '#C896D4', '#D496A5', '#D4C696'
                  ],
                  barThickness: 20
               }
            ]
         };
         this.typeChart1 = new Chart(document.getElementById('typeChart1'), {
            type: 'bar',
            data: data,
            options: {
               dataCenter: true,
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === 'data' && context.mode === 'default') {
                        // delay = context.datasetIndex * 100;
                        delay = context.dataIndex * 200;
                     }
                     return delay;
                  }
               },
               indexAxis: 'y',
               layout: {
                  padding: {
                     top: 30,
                     bottom: 20
                  }
               },
               scales: {
                  x: {
                     display: false
                  },
                  y: {
                     max: 15,
                     min: 0,
                     grid: {
                        display: false
                     }
                  }
               },
               responsive: false,
               plugins: {
                  legend: {
                     display: false
                  },
                  datalabels: {
                     color: '#4B4B4B',
                     font: {
                        weight: 'bold',
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
      makeChart_type2: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: '조직운영(20)',
                  data: [
                     18, 17, 16.5, 15.9, 15.4
                  ],
                  backgroundColor: [
                     '#96C1D4', '#9896D4', '#C896D4', '#D496A5', '#D4C696'
                  ],
                  barThickness: 16
               }
            ]
         };
         this.typeChart2 = new Chart(document.getElementById('typeChart2'), {
            type: 'bar',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === 'data' && context.mode === 'default') {
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
                     anchor: 'end',
                     align: 'top',
                     color: '#4B4B4B',
                     font: {
                        weight: 'bold',
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
      makeChart_type3: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: '주요사업(40)',
                  data: [
                     34, 33, 32, 31, 29
                  ],
                  backgroundColor: [
                     '#96C1D4', '#9896D4', '#C896D4', '#D496A5', '#D4C696'
                  ],
                  barThickness: 24
               }
            ]
         };
         this.typeChart3 = new Chart(document.getElementById('typeChart3'), {
            type: 'bar',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === 'data' && context.mode === 'default') {
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
                     anchor: 'end',
                     align: 'top',
                     color: '#4B4B4B',
                     font: {
                        weight: 'bold',
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
      makeChart_type4: function() {
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: '단체자율성(15)',
                  data: [
                     13.9, 13.4, 13.2, 11.8, 12.7
                  ],
                  borderColor: "#ED7D31",
                  pointRadius: 4,
                  pointBackgroundColor: "#ED7D31"
               }
            ]
         };
         this.typeChart4 = new Chart(document.getElementById('typeChart4'), {
            type: 'line',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === 'data' && context.mode === 'default') {
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
                     }
                  },
                  y: {
                     max: 15,
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
      makeChart_type5: function() {
         var pointImage1 = new Image();
         pointImage1.src = '/innovation_test/images/chart/ga.svg';
         var pointImage2 = new Image();
         pointImage2.src = '/innovation_test/images/chart/na.svg';
         var pointImage3 = new Image();
         pointImage3.src = '/innovation_test/images/chart/da.svg';
         var pointImage4 = new Image();
         pointImage4.src = '/innovation_test/images/chart/ra.svg';
         var pointImage5 = new Image();
         pointImage5.src = '/innovation_test/images/chart/ma.svg';
         const data = {
            labels: [
               "가군", "나군", "다군", "라군", "마군"
            ],
            datasets: [
               {
                  label: '인권 및 윤리(10)',
                  data: [
                     9, 8, 7, 5, 10
                  ],
                  backgroundColor: [
                     '#96C1D4', '#9896D4', '#C896D4', '#D496A5', '#D4C696'
                  ],
                  borderWidth: 0,
                  pointRadius: 4,
               }
            ]
         };
         this.typeChart5 = new Chart(document.getElementById('typeChart5'), {
            type: 'line',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                     let delay = 0;
                     if (context.type === 'data' && context.mode === 'default') {
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
                     max: 10 * 1.2,
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
                  }
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
               }
            ]
         });
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
   }
});
