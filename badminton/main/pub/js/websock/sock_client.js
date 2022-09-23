/* ========================================================================================= 
    Purpose : WebSocket Client
    Make    : 2019. 04.24
    Author  :                                                                 By Aramdry
   ========================================================================================= */

   JCMD = function () {}    
   /* ----------------------------------------------------------------------------------- */
   // server side 
   JCMD.JUDGE_ENTER              = 10            // 심판이 입장했다. 방의 초기값 생성 
   JCMD.JUDGE_SCORE              = 11            // 심판이 점수를 수정했다.        
   JCMD.JUDGE_STARTGAME          = 12            // 게임이 시작되었다.    
   JCMD.JUDGE_ENDGAME            = 13            // 게임이 종료 되었다.   
   JCMD.JUDGE_SETCHANGE          = 14            // 셋트가 변경되었다. 
   JCMD.USER_ENTER               = 20000         // User가 입장했다. Client Socket 초기값 생성 

   /* ----------------------------------------------------------------------------------- */
   // client side
   JCMD.SCORE_INFO          = 21            // Score Info 
   JCMD.STARTGAME           = 22            // Start Game
   JCMD.ENDGAME             = 23            // End Game
   JCMD.SETCHANGE           = 24            // Set Change

   JCMD.JOINROOM            = 30            // Join Room 
   JCMD.EXISTJUDGE          = 31            // 심판이 이미 존재한다. 

   JCMD.SVR_FULL            = 100            // 서버가 최대 인원이다. 입장불가. 
   JCMD.GAME_OVER           = 101            // 게임이 종료 되었다. SOCKET CLOSE할 것이다. 


	CON = function () {}
	CON.DEV_TEST		= 0;

	CON.PORT        	= 8337;
   CON.TEST_PORT    	= 9000;
   CON.WSADDR      	= "ws://49.247.9.88:";
   CON.TEST_WSADDR   = "ws://203.239.137.151:";

   CON.SOCK_CONNECTING     = 0;            // 연결이 수립되지 않은 상태입니다.
   CON.SOCK_OPEN           = 1;            // 연결이 수립되어 데이터가 오고갈 수 있는 상태입니다.
   CON.SOCK_CLOSING        = 2;            // 연결이 닫히는 중 입니다.
   CON.SOCK_CLOSED         = 3;            // 연결이 종료되었거나, 연결에 실패한 경우입니다.

   // **아래 정의된 함수 호출시 유의점 
   // $(function () {} 정의의 의미가 Document OnReady 이후에 활성화          
   // OnReady가 된 다음에 호출하여야 한다.  OnReady 이전에 호출시 not Defined Message를 받는다. 
$(function () {         

   var connection = null, bIsOpen = false;
	var levelIdx = "", teamGNum = "", gameNum = "", bTeamGame = false; 
	var strAddr = (CON.DEV_TEST == 1) ? (CON.TEST_WSADDR + CON.TEST_PORT) : (CON.WSADDR + CON.PORT);

   console.log("socket_client start :" + strAddr);

   
   init_sock = function(_levelIdx, _teamGNum, _gameNum, _bTeamGame) {      
      levelIdx = _levelIdx;
      teamGNum = _teamGNum;
      gameNum = _gameNum;
      bTeamGame = _bTeamGame;

      console.log("call init");
      var strLog = utx.strPrintf("levelIdx = {0}, teamGNum = {1}, gameNum = {2}, bTeamGame = {4}", 
                  levelIdx,teamGNum,gameNum,bTeamGame);
      console.log(strLog);

      // if user is running mozilla then use it's built-in WebSocket
      window.WebSocket = window.WebSocket || window.MozWebSocket;
      // if browser doesn't support WebSocket, just show
      // some notification and exit
      if (!window.WebSocket) {
         console.log("'Sorry, but your browser doesn\'t support WebSocket.'");
         return;
      }
		// open connection		
      connection = new WebSocket(strAddr);
      connection.onopen = function () {

         console.log("connection.onopen");
         bIsOpen = true; 
         onOpenConnection();
         connection.send(JSON.stringify({ "CMD": JCMD.JUDGE_ENTER, "LEVELIDX": levelIdx, "TEAMGNUM": teamGNum, "GAMENUM": gameNum, "TEAMGAME": bTeamGame} ));
      };

      connection.onclose = function () {
         console.log("connection.onclose");

         bIsOpen = false;
         connection = null; 
         onCloseSock(); 
      }
      
      connection.onerror = function (error) {
         // just in there were some problems with connection...
         console.log("connection.onerror");
         setTimeout(function() {
            console.log("Sorry, but there\'s some problem with your connection or the server is down.'");
         }, 0);        
      };

      // most important part - incoming messages
      connection.onmessage = function (msgObj) {

         console.log("connection.onmessage");
         setTimeout(function() {        
            var jsonObj = null, strMsg; 
            try {
               jsonObj = JSON.parse(msgObj.data);
            } catch (e) {
               console.log('Invalid JSON: ', msgObj.data);
               return;
            }

            onSockMessage(jsonObj); 
            jsonObj = null; 
         }, 0);   
      };
   }

   send_msg = function(strMsg, cmd) { 
      if(!bIsOpen) return;                // onopen event 전이다. send 하지 못한다.     
      if( connection == undefined || connection == null) return; 
      if(connection.readyState != CON.SOCK_OPEN) return false; 

      var strLog; 
      strLog = utx.strPrintf("send_msg bIsOpen = {0}, readyState = {1}, msg = {2}", bIsOpen,connection.readyState, strMsg);
      console.log(strLog);
      connection.send(JSON.stringify({ "CMD": cmd, "LEVELIDX": levelIdx, "TEAMGNUM": teamGNum, "GAMENUM": gameNum, "TEAMGAME": bTeamGame, "DATA": strMsg} ));          
   }

   close_sock = function() {
      if( connection == undefined || connection == null) return; 
      console.log("close_sock");
      connection.close();
      connection = null; 
      bIsOpen = false;   
   }
   
});