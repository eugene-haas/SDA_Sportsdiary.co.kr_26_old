/* -----------------------------------------------------------------------------------
      수정 이력
    · 2021-01-06(날짜) : M1(수정 코드)
        : 수정사유 by chansoo
        : 삭제함수 : 없음
        : 수정함수 : getStrRegionInfo
   ----------------------------------------------------------------------------------- */

const vm = new Vue({
   el: "#vue_app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/
      madal_gameInfo: {
         show: false,
      },
      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      gameTab_list : [],
      sel_gameTab :4,//대진표

      focus: false,
      player_list: [],
      match_list: [],
   },
   created: function() {
      // /app/include/head_sports 유도 대회 정보 탭
      this.gameTab_list = window.m_gameTab_list||[];
      this.inItTournamentData();
   },
   mounted: function() {
   },
   methods: {
      /* -----------------------------------------------------------------------------------
              init 대진표 정보
           ---------------------------------------------------------------------------------- */
      inItTournamentData: function(){
         // 리그
         // const path = '/app/api/mgr_tournament/tournament_leagure.asp';
         // const params = {
         //    gameLevelIdx: "8223"
         // };
         const path = '/app/api/mgr_tournament/tournament.asp';
         const params = {
            gameLevelIdx: "9223"
         };
         axios.post(path, params).then(function(res) {
            log(res);
            if (res.data.errorcode !== "SUCCESS") {
               return;
            }
            this.player_list = cm_fn.copyObjEx(res.data.player_info, []);
            this.match_list = cm_fn.copyObjEx(res.data.game_info, []);
            this.setTournamentHTML();
         }.bind(this));
      },
         /* -----------------------------------------------------------------------------------
                 토너먼트 형식 대진표 그리기
              ---------------------------------------------------------------------------------- */
      setTournamentHTML: function(){
         const match_map = {};
         const match_list = this.match_list.reverse();
         const tournament_cnt = 64; // 전체 강수
         const tournament_virtical_cnt = Math.log2(tournament_cnt); // 라운드 개수
         const cnt_list = [];
         for (var i = 0; i < tournament_virtical_cnt; i++) {
            cnt_list.push(0);
         }
         const getTournamentInfo = function(depth){
            const round = tournament_cnt / Math.pow(2, depth) * 2;
            const match_info = (function(){
               if (depth === 1) { // 첫 라운드면 child가 null인 객체로 생성
                  return {
                     round: round,
                     match: null,
                     child: null,
                  };
               }
               return {
                  round: round, // 강수
                  match: null, // 진행 경기
                  child: {
                     left: getTournamentInfo(depth-1),
                     right: getTournamentInfo(depth-1),
                  },
               };
            })();
            const gameNum = (tournament_cnt - (round/2)) - (cnt_list[depth-1]); // 예상 게임 넘버
            ++cnt_list[depth-1];
            match_map[gameNum] = match_info;
            return match_info;
         }
         const tournament_obj = getTournamentInfo(tournament_virtical_cnt);

         let player_idx = 0;
         let match_idx = 0;
         for (const i in match_map) {
            if (match_map[i].child === null) {
               const player_info = this.player_list[player_idx];
               player_idx = player_idx + 1;
               if (player_info.unearned_win === "1"){
                  match_map[i].match = '부전승 - ' + player_info.user_name;
               } else {
                  match_map[i].match = match_list[match_idx];
                  match_idx = match_idx + 1;
                  player_idx = player_idx + 1;
               }
            } else {
               match_map[i].match = match_list[match_idx];
               match_idx = match_idx + 1;
            }
         }
         console.log(match_map, tournament_obj)
         const classes = function(class_obj){
            let classNameStr = '';
            for (var key in class_obj) {
               if (class_obj[key]) {
                  classNameStr = classNameStr + ' ' + key;
               }
            }
            return classNameStr;
         }
         const getDataStr = function(obj){
            return `data-player_l="${obj.match.l_PlayerIdx || null}" data-player_r="${obj.match.r_PlayerIdx || null}"`;
         }
         const getTournamentHTML = function(tournament_info, className){
            if (tournament_info.child === null) {
               return `
               <li class="m_tour-list ${className || ''}" ${getDataStr(tournament_info)}>
                  <ol class="m_tour-list__con">
                     ${typeof tournament_info.match === 'string'?`
                        <li class="m_tour-list t_unearned-win t_win">
                           <div class="m_tour-list__player t_unearned-win">
                              ${tournament_info.match}
                           </div>
                        </li>
                     `:`
                        <li class="m_tour-list ${classes({
                              t_win: tournament_info.match.win_part === "2",
                           })}" data-player_r="${tournament_info.match.r_PlayerIdx}">
                           <div class="m_tour-list__player">
                              ${tournament_info.match.r_playerName}
                           </div>
                        </li>
                        <li class="m_tour-list ${classes({
                              t_win: tournament_info.match.win_part === "1",
                           })}" data-player_l="${tournament_info.match.l_PlayerIdx}">
                           <div class="m_tour-list__player">
                              ${tournament_info.match.l_playerName}
                           </div>
                        </li>
                     `}
                  </ol>
                  ${typeof tournament_info.match === 'string'?`
                  `:`
                     <div class="m_tour-list__header">
                     ${tournament_info.match.gameNum || ''}
                     </div>
                  `}
               </li>
               `
            }
            return `
               <li class="m_tour-list ${className || ''}" ${getDataStr(tournament_info)}>
                  <ol class="m_tour-list__con">
                     ${getTournamentHTML(tournament_info.child.right, classes({
                        t_win: tournament_info.match.win_part === "1"
                     }))}
                     ${getTournamentHTML(tournament_info.child.left, classes({
                        t_win: tournament_info.match.win_part === "2"
                     }))}
                  </ol>
                  <div class="m_tour-list__header">
                     ${tournament_info.match.gameNum}
                  </div>
               </li>
            `
         };
         this.$refs.Tournament.innerHTML = `
            <ol>
               ${getTournamentHTML(tournament_obj.child.right, classes({
                  t_left: true,
                  t_win: tournament_obj.match.win_part === "1",
               }))}
               ${getTournamentHTML(tournament_obj.child.left, classes({
                  t_right: true,
                  t_win: tournament_obj.match.win_part === "2",
               }))}
            </ol>
            <div class="m_tournament__con__header">
               ${tournament_obj.match.gameNum}
            </div>
            <div class="m_tournament__con__main ${classes({
               't_win-l': tournament_obj.match.l_result !== '',
               't_win-r': tournament_obj.match.r_result !== '',
            })}" ${getDataStr(tournament_obj)}>
               ${tournament_obj.match.gameNum}
            </div>
         `;
         this.$nextTick(function(){
            const el_list = document.querySelectorAll('[data-player_l="22871"], [data-player_r="22871"]');
            for (var i = 0; i < el_list.length; i++) {
               el_list[i].classList.add('s_focus');
            }
         });
      },
      /* -----------------------------------------------------------------------------------
              메인페이지로 이동
           ---------------------------------------------------------------------------------- */
      console: function() {
         log('console');
         const path = 'http://sdmain.sportsdiary.co.kr/sdmain/ajax/Login_OK.asp';
         const params = {
            UserID: 'chansoo1280',
            UserPass: '1234qwer',
            saveid: 'Y'
         };
         this.$http(path, params, function(res) {
            log(this.text)
         });
      }
   }
});
