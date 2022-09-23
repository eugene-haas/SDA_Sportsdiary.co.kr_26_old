<script>
// /app/include/aside.asp 에서 사용합니다.
   window.g_lnb_list = [
      {
         title: '대회정보',
         show: true,
         list: [
            {
               title: '대회일정/결과',
               href: '/app/pages/judo/game/list.asp',
            },
            {
               title: '선수전적',
               href: '',
            },
            {
               title: '경기기록실',
               href: '',
            },
            {
               title: '대회영상모음',
               href: '',
            },
            {
               title: 'SDA TV',
               href: '',
            }
         ]
      },
      {
         title: '자료실',
         list: [
            {
               title: 'SD 뉴스',
               href: '',
            },
            {
               title: 'SD 칼럼',
               href: '',
            },
            {
               title: '단체정보 조회',
               href: '',
            },
            {
               title: '공지사항',
               href: '',
            },
            {
               title: '팀 공지사항',
               href: '',
            }
         ]
      },
      {
         title: '고객지원',
         list: [
            {
               title: '자주하는 질문',
               href: '',
            },
            {
               title: 'QnA',
               href: '',
            }
         ]
      }
   ];
   const g_gameTab_list = [
      {
         name: '대회요강',
         path: '/pages/judo/game/info/index.asp',
         idx: 1,
      },{
         name: '참가자 명단',
         path: '/pages/judo/game/info/attend_list/index.asp',
         idx: 2,
      },{
         name: '참가신청 확인',
         path: '/pages/judo/game/info/attend_confirm/index.asp',
         idx: 3,
      },{
         name: '대회 일정표',
         path: '/pages/judo/game/info/schedule/index.asp',
         idx: 4,
      },{
         name: '대진표',
         path: '/pages/judo/game/info/tournament/index.asp',
         idx: 5,
      },{
         name: '경기순서/현황',
         path: '/pages/judo/game/info/lookup/index.asp',
         idx: 6,
      },{
         name: '대회결과',
         path: '/pages/judo/game/info/result/index.asp',
         idx: 7,
      },
   ];
   //
   // window.g_nav_list = [
   //    {
   //       title: '대회일정/결과',
   //       type: 'slide',
   //       backPath: '/app/pages/judo/index.asp',
   //       list: [
   //
   //       ]
   //    }, {
   //       title: '선수 전적',
   //       type: 'tree',
   //       list: [
   //          {
   //             str: '전적',
   //             path: '/app/pages/judo/player/record/profile.asp',
   //             list: [
   //                {
   //                   str: '선수프로필',
   //                   path: '/app/pages/judo/player/record/profile.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },{
   //                   str: '입상현황',
   //                   path: '/app/pages/judo/player/record/winner.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },{
   //                   str: '대회영상모음',
   //                   path: '/app/pages/judo/player/record/video.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },{
   //                   str: '대회영상 즐겨찾기',
   //                   path: '/app/pages/judo/player/record/video_mark.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },
   //             ],
   //          },{
   //             str: '대회득실점',
   //             path: '/app/pages/judo/player/goals/list_score.asp',
   //             list: [
   //                {
   //                   str: '점수별',
   //                   path: '/app/pages/judo/player/goals/list_score.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },{
   //                   str: '기술별',
   //                   path: '/app/pages/judo/player/goals/list_technic.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },{
   //                   str: '시간대별',
   //                   path: '/app/pages/judo/player/goals/list_time.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },
   //             ],
   //          },
   //       ]
   //    }, {
   //       title: '경기기록실',
   //       type: 'tree',
   //       list: [
   //          {
   //             str: '성적조회',
   //             path: '/app/pages/judo/record/lookup/result.asp',
   //             list: [
   //                {
   //                   str: '대회결과',
   //                   path: '/app/pages/judo/record/lookup/result.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },{
   //                   str: '입상자(소속)조회',
   //                   path: '/app/pages/judo/record/lookup/winner.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },{
   //                   str: '체급별입상현황',
   //                   path: '/app/pages/judo/record/lookup/list_weight.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },
   //             ],
   //          },{
   //             str: '순위',
   //             path: '/app/pages/judo/record/rank/winning_rate.asp',
   //             list: [
   //                {
   //                   str: '경기승률',
   //                   path: '/app/pages/judo/record/rank/winning_rate.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },{
   //                   str: '메달순위',
   //                   path: '/app/pages/judo/record/rank/medal.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },{
   //                   str: '메달합계',
   //                   path: '/app/pages/judo/record/rank/total_medal.asp',
   //                   backPath: '/app/pages/judo/index.asp',
   //                },
   //             ],
   //          },
   //       ]
   //    },
   // ];

</script>
