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
      typeChart5: null,
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
            차트 초기화
         ---------------------------------------------------------------------------------- */
      resetChart: function(chart){
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
               "비전전략", "조직운영", "주요사업", "단체자율성", "인권 및 윤리"
            ],
            datasets: [
               {
                  label: '대한축구협회',
                  data: [
                     20, 65, 45, 96, 75
                  ],
                  borderColor: "#ff6969",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }, {
                  label: '가군평균',
                  data: [
                     44, 42, 26, 78, 73
                  ],
                  borderColor: "#75b1ff",
                  backgroundColor: "transparent",
                  pointRadius: 10,
                  pointBorderColor: "transparent",
                  pointBackgroundColor: "transparent",
               }, {
                  label: '전체평균',
                  data: [
                     64, 42, 28, 45, 74
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
            type: 'radar',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                    let delay = 0;
                    if (context.type === 'data' && context.mode === 'default') {
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
                     display: false
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
               "대한축구협회", "가군평균", "전체평균"
            ],
            datasets: [
               {
                  label: '비전전략(15)',
                  data: [
                     12.4, 10.2, 7.9
                  ],
                 backgroundColor: [
                     '#318FED',
                     '#A5D3DC',
                     '#D4D4D4',
                 ],
                 barThickness: 36
               },
            ]
         };
         this.typeChart1 = new Chart(document.getElementById('typeChart1'), {
            type: 'bar',
            data: data,
            options: {
               animation: {
                  delay: (context) => {
                    let delay = 0;
                    if (context.type === 'data' && context.mode === 'default') {
                       // delay = context.datasetIndex * 100;
                      delay = context.dataIndex * 200;
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
                        color: '#7D838D',
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
                     anchor: 'end',
                     align : 'top',
                     color: '#4B4B4B',
                     font: {
                        weight: 'bold',
                        size: 15
                     },
                  }
               },
            }
         });
      },
      /* -----------------------------------------------------------------------------------
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_type2: function() {
         const data = {
            labels: [
               "대한축구협회", "가군평균", "전체평균"
            ],
            datasets: [
               {
                  label: '조직운영(20)',
                  data: [
                     15.6, 14.7, 14.9
                  ],
                 backgroundColor: [
                     '#DC7174',
                     '#EBAFB0',
                     '#D4D4D4',
                 ],
                 barThickness: 36
               },
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
                        color: '#7D838D',
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
                     anchor: 'end',
                     align : 'top',
                     color: '#4B4B4B',
                     font: {
                        weight: 'bold',
                        size: 15
                     },
                  }
               },
            }
         });
      },

      /* -----------------------------------------------------------------------------------
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_type3: function() {
         const data = {
            labels: [
               "대한축구협회", "가군평균", "전체평균"
            ],
            datasets: [
               {
                  label: '주요사업(40)',
                  data: [
                     28.6, 25.5, 20.2
                  ],
                 backgroundColor: [
                     '#A4BC7A',
                     '#CFDCC5',
                     '#D4D4D4',
                 ],
                 barThickness: 36
               },
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
                        color: '#7D838D',
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
                     anchor: 'end',
                     align : 'top',
                     color: '#4B4B4B',
                     font: {
                        weight: 'bold',
                        size: 15
                     },
                  }
               },
            }
         });
      },
      /* -----------------------------------------------------------------------------------
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_type4: function() {
         const data = {
            labels: [
               "대한축구협회", "가군평균", "전체평균"
            ],
            datasets: [
               {
                  label: '단체자율성(15)',
                  data: [
                     10.6, 10.7, 7.2
                  ],
                 backgroundColor: [
                     '#8F31ED',
                     '#C3A6E1',
                     '#D4D4D4',
                 ],
                 barThickness: 36
               },
            ]
         };
         this.typeChart4 = new Chart(document.getElementById('typeChart4'), {
            type: 'bar',
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
                        color: '#7D838D',
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
                     anchor: 'end',
                     align : 'top',
                     color: '#4B4B4B',
                     font: {
                        weight: 'bold',
                        size: 15
                     },
                  }
               },
            }
         });
      },
      /* -----------------------------------------------------------------------------------
            타입별 차트
         ---------------------------------------------------------------------------------- */
      makeChart_type5: function() {
         const data = {
            labels: [
               "대한축구협회", "가군평균", "전체평균"
            ],
            datasets: [
               {
                  label: '인권 및 윤리(10)',
                  data: [
                     6.6, 7.5, 7.5
                  ],
                 backgroundColor: [
                     '#EDAE31',
                     '#F1D398',
                     '#D4D4D4',
                 ],
                 barThickness: 36
               },
            ]
         };
         this.typeChart5 = new Chart(document.getElementById('typeChart5'), {
            type: 'bar',
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
                  },
                },
               layout: {
                  padding: {
                     top: 30,
                     bottom: 20,
                  }
               },
               scales: {
                  x: {
                     grid: {
                        display: false,
                     },
                     ticks: {
                        color: '#7D838D',
                        font: {
                           size: 12,
                        },
                     },
                  },
                 y: {
                    ticks: {
                       display:false,
                    },
                    grid: {
                       drawBorder: false,
                    },
                 }
               },
               responsive: false,
               plugins: {
                  legend: {
                     display: false,
                  },
                  datalabels: {
                     anchor: 'end',
                     align : 'top',
                     color: '#4B4B4B',
                     font: {
                        weight: 'bold',
                        size: 15,
                     },
                  }
               },
            }
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
