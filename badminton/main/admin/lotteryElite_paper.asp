<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>배드민턴 경기기록지</title>
  <link rel="stylesheet" href="../../css/admin/common/font.css">
  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css">
  <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>
  <style>
    .lotteryMatch{ position:absolute; width:100%; height:44px; margin:auto; box-sizing:border-box; overflow:hidden;
  		border-color:#f2f2f2; border-style:solid;
  		display:flex;
  		opacity:0.5;
  	}
  	.lotteryMatch.s_selected{border:2px solid #ff8300;}

  	/* !@# */
  	.lotteryMatch.s_filled{opacity:1;}

  	.lotteryMatch_first{ bottom:50%;
  		border-width:0 0 1px 0;
  		border-radius:4px 4px 0 0;
  	}
  	.lotteryMatch_second{ top:50%;
  		border-width:1px 0 0 0;
  		border-radius:0 0 4px 4px;
  	}

  	.lotteryMatch__seedWrap{
  		display:block;
  		width:20%;
  		height:100%; text-align:left; text-indent:5px; font-size:13px; letter-spacing:-0.05em; line-height:26px;
  		background-color:#dbe1e8;
  	}
  	.lotteryMatch__playerWrap{
  		display:flex;flex-direction:column;justify-content:center;
  		width:80%;
  		height:100%;padding:0 4px;box-sizing:border-box;text-align:left;
  		background-color:#b3c1d1;
  		background-color:#b6c3d2;
  	}
  	.lotteryMatch__playerInner{
  		width:100%;display:block;white-space:nowrap;text-overflow:ellipsis;overflow:hidden;
  	}
  	.lotteryMatch__player{display:inline;font-size:13px;font-weight:700;line-height:18px;}
  	.lotteryMatch__belong{display:inline;font-size:12px;line-height:18px;}
  </style>
</head>
<body>
  <div id="tournamentTree" class="bottom-list">

    대진표자리

  </div>
  <script>
    var tournament = new Tournament();
  	tournament.setOption({
  		blockBranchWidth : 30,
  		blockBoardWidth : 180,
  		blockHeight : 50,
  		branchWidth : 2,
  		branchColor : '#dddddd',
  		roundOf_textSize: 10,
  		scale: 1,
  		board:false,
  		el:document.getElementById('tournamentTree')
  	});
    tournament.setStyle();
  	tournament.boardInner = function(data){
  		var Lplayer, Lteam, Rplayer, Rteam;
  		var Lselected, Rselected, LplayerNo, RplayerNo;

  		var l_player1, l_player2, l_team1, l_team2,
  				r_player1, r_player2, r_team1, r_team2;

  		if(data){
  			matchNo = data.matchNo;

  			Lplayer = data.Lplayer.split(','),
  			Lteam = data.Lteam.split(','),
  			Rplayer = data.Rplayer.split(','),
  			Rteam = data.Rteam.split(',');

  			l_player1 = (Lplayer[0]) ? Lplayer[0] : '',
  			l_team1 = (Lteam[0]) ? Lteam[0] : '',
  			l_player2 = (Lplayer[1]) ? Lplayer[1] : '',
  			l_team2 = (Lteam[1]) ? Lteam[1] : '',

  			r_player1 = (Rplayer[0]) ? Rplayer[0] : '',
  			r_player2 = (Rplayer[1]) ? Rplayer[1] : '',
  			r_team1 = (Rteam[0]) ? Rteam[0] : '',
  			r_team2 = (Rteam[1]) ? Rteam[1] : '';

  			Lfilled = data.Lfilled ? 's_filled' : '',
  			Rfilled = data.Rfilled ? 's_filled' : '',

  			Lselected = data.Lselected ? 's_selected' : '',
  			Rselected = data.Rselected ? 's_selected' : '';

  			// 재고.....
  			LplayerNo = data.LplayerNo + 1,
  			RplayerNo = data.RplayerNo + 1;

  		}

  		var html = [
  			'<p class="lotteryMatch lotteryMatch_first [ _match ] '+ Lselected + ' ' + Lfilled + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2) +'">',
  				'<span class="lotteryMatch__seedWrap">'+LplayerNo+'</span>',
  				'<span class="lotteryMatch__playerWrap">',
  					'<span class="lotteryMatch__playerInner">',
  						'<span class="lotteryMatch__player [ _player1 ]">'+l_player1+'</span>',
  						'<span class="lotteryMatch__belong [ _belong1 ]">'+l_team1+'</span>',
  					'</span>',
  					'<span class="lotteryMatch__playerInner">',
  						'<span class="lotteryMatch__player [ _player2 ]">'+l_player2+'</span>',
  						'<span class="lotteryMatch__belong [ _belong2 ]">'+l_team2+'</span>',
  					'</span>',
  				'</span>',
  			'</p>',
  			'<p class="lotteryMatch lotteryMatch_second [ _match ] '+ Rselected + ' ' + Rfilled + '" data-match-no="'+matchNo+'" data-player-no="'+ (matchNo * 2 + 1) +'">',
  				'<span class="lotteryMatch__seedWrap">'+RplayerNo+'</span>',
  				'<span class="lotteryMatch__playerWrap">',
  					'<span class="lotteryMatch__playerInner">',
  					'<span class="lotteryMatch__player [ _player1 ]">'+r_player1+'</span>',
  						'<span class="lotteryMatch__belong [ _belong1 ]">'+r_team1+'</span>',
  					'</span>',
  					'<span class="lotteryMatch__playerInner">',
  						'<span class="lotteryMatch__player [ _player2 ]">'+r_player2+'</span>',
  						'<span class="lotteryMatch__belong [ _belong2 ]">'+r_team2+'</span>',
  					'</span>',
  				'</span>',
  			'</p>'
  		].join('');
  		return html;
  	}

    var matchData = [
      // {
      // 	LentryOrder: "0",
      // 	Lfilled: true,
      // 	Lplayer: "김정구, 김정구2",
      // 	LplayerNo: 0,
      // 	LplayerPositionNo: 0,
      // 	Lselected: false,
      // 	Lteam: "한체대",
      // 	RentryOrder: "5",
      // 	Rfilled: true,
      // 	Rplayer: "최최최, 최최최2",
      // 	RplayerNo: 1,
      // 	RplayerPositionNo: 1,
      // 	Rselected: false,
      // 	Rteam: "한체대1",
      // 	matchNo: 0,
      // },
      // {
      // 	LentryOrder: "1",
      // 	Lfilled: true,
      // 	Lplayer: "김김김1, 김김김2",
      // 	LplayerNo: 2,
      // 	LplayerPositionNo: 0,
      // 	Lselected: false,
      // 	Lteam: "한체대2",
      // 	RentryOrder: "2",
      // 	Rfilled: true,
      // 	Rplayer: "이이이1, 이이이2",
      // 	RplayerNo: 3,
      // 	RplayerPositionNo: 1,
      // 	Rselected: true,
      // 	Rteam: "한체대2",
      // 	matchNo: 1,
      // },
      // {
      // 	LentryOrder: undefined,
      // 	Lplayer: "",
      // 	LplayerNo: 4,
      // 	LplayerPositionNo: 0,
      // 	Lselected: false,
      // 	Lteam: "",
      // 	RentryOrder: undefined,
      // 	Rplayer: "",
      // 	RplayerNo: 5,
      // 	RplayerPositionNo: 1,
      // 	Rselected: false,
      // 	Rteam: "",
      // 	matchNo: 2,
      // },
      // {
      // 	LentryOrder: undefined,
      // 	Lplayer: "",
      // 	LplayerNo: 6,
      // 	LplayerPositionNo: 0,
      // 	Lselected: false,
      // 	Lteam: "",
      // 	RentryOrder: undefined,
      // 	Rplayer: "",
      // 	RplayerNo: 7,
      // 	RplayerPositionNo: 1,
      // 	Rselected: false,
      // 	Rteam: "",
      // 	matchNo: 3,
      // }
    ];

    var roundOf = 8;

    // 빈 대진표 data 생성
    for(var i=0, ii=roundOf/2; i<ii; i++){
      matchData.push({
        matchNo:i,
        Lplayer:'', Lteam:'', LplayerNo:(i*2), LplayerPositionNo:0, LentryOrder:undefined,
        Rplayer:'', Rteam:'', RplayerNo:(i*2 + 1), RplayerPositionNo:1, RentryOrder:undefined
      });
    };

    tournament.draw({
      roundOf:roundOf,
      data: {
        round_1 : matchData
      },
    });
  </script>
</body>
</html>
