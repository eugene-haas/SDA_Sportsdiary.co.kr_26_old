var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_LOGIN = 1; //로그인
  mx.CMD_LOGOUT = 2;
  mx.CMD_LOGCHECK = 3;
  mx.CMD_CAL = 4;
  mx.CMD_PCODE = 5;                                     //공통코드 호출
  mx.CMD_TEAMCODE = 6;                                    //팀코드
  mx.CMD_FINDSCORE = 7;                                   //스코어 입력 창으로 이동 없을경우 인서트 
  mx.CMD_RECORDER = 8;                                    //기록관입력
  mx.CMD_SAVECOURT = 9;                                 //코트 정보저장
  mx.CMD_MODECHANGE = 10;                               //코트정보 수정모드
  mx.CMD_SETPOINT = 11;                                   //포인트 입력
  mx.CMD_TEST = 12;                                       //테스트를 위해 설정된 값들을 초기화 시킨다
  mx.CMD_GAMEEND = 13;                                    //한게임 종료
  mx.SETSERVE = 15;                                       //두번째 서비스 설정
  mx.CMD_PRE = 16;                                        //이전단계로
  mx.CMD_ENTERSCOREEND = 17;                              //경기종료 버튼클릭
  mx.CMD_ENTERSCORESTOP = 21;                           //경기중단
  mx.CMD_ENTERSCORERESET = 22;                            //경기초기화
  mx.CMD_TEAMCODERALLY = 18;                              //대회별 생성된 팀코드
  mx.CMD_DELETESCORE = 19;                                //마지막 기록삭제
  mx.CMD_FINDMAINSCORE = 20;                              //스코어 입력 본선시작
  mx.CMD_RESET = 100;                                   //리셋 (1세트 노플레이 수정시)


  mx.CMD_DATAGUBUN = 10000;

  ////  app 대진표 연동

  mx.CMD_GAMESEARCH = 20000;                              //경기스코어 검색
  mx.CMD_SETSCORE = 20001;                                //경기스코어보기 / 수정
  mx.CMD_STATUSSEARCH = 20002;                          //현황보기 검색

  mx.CMD_GAMESEARCH_app = 20003; // '경기 대진표 조회(app)
  mx.CMD_ScoreBoard = 20004;  //'경기스코어 결과 조회(app)
  mx.CMD_ScoreDetailBoard = 20005; //'경기스코어 결과 상세조회(app)

  
  mx.CMD_ScoreBoardLive = 20006;  //'Live 경기스코어 결과 조회(app)
  mx.CMD_ScoreDetailBoardLive = 20007; //' Live 경기스코어 결과 상세조회(app)

  ////  홈페이지 대진표 연동

  mx.CMD_GAMESEARCH_Home = 20031; // '대진표 조회
  mx.CMD_GAMESEARCH_Result_Home = 20032; // '대회 결과 조회
  

  //////////////////////////
  mx.CMD_GAMEGRADEPERSON = 30000;                       //경기기록실 성적, 입상현황개인
  mx.CMD_GAMEGRADEPERSONAPPEND = 30001;                 //경기기록실 성적, 입상현황개인

  mx.CMD_GAMEGRADEGROUP = 30002;
  mx.CMD_GAMEGRADEGROUPAPPEND = 30003;
  mx.CMD_RANKINGRATE = 30004;                             //경기승률
  mx.CMD_RANKINGMEDAL = 30005;                            //메달순위
  mx.CMD_RANKINGMEDALTOTAL = 30006;                       //메달합계
  mx.CMD_ENTERSCORE = 30007;                              //스코어 입력 화면
  mx.CMD_SCORELIST = 30009;                               //포인트 기록화면 불러오기
  mx.CMD_CHANGESCORE = 30010;                           //경기승패 변경 다시 불러오기

  mx.CMD_COURTLIST = 30011;                               //코트 목록 불러오기 (지정상태 포함)
  mx.CMD_COURTNO = 30012;                               //코트 번호 지정하고 목록 다시 호출
  ////////////////////////////////////////


mx.IsHttpSuccess = function( r ){
  try{
    return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
  }
  catch(e){}
  return false;
};

mx.HttpData = function( r, type ){
  var ct = r.getResponseHeader( "Content-Type" );
  var data = !type && ct && ct.indexOf( "xml" ) >=0;
  data = type == "xml" || data ? r.responseXML : r.responseText;
  if( type == "script" ){
    eval.call( "window", data );
  }
  else if( type == "mix" ){
    if ( data.indexOf("$$$$") !== -1 ){
      var mixdata = data.split( "$$$$" );
      ( function () { eval.call("window", mixdata[0]); } () );
      data = mixdata[1];
    }
  }
  return data;
};

//히스토리 저장/////////////////////////////////////////////////////////////////////////
mx.arrKey = ["CMD","PG",'SEQ',"IDX","T","R","SP","LVL","FT","SSTR","DN","NM","ST"]; //"PAGEC",'SEQ',"IDX","TID","REF","STEP","LVL","FINDTYPE","SEARCHSTR","DBNAME","이전다음 상태"
mx.historybackstr = null;

mx.CheckForHash = function(){ //백버튼 클릭시 위치로 이동
  if( document.location.hash && document.location.hash != mx.historybackstr  ){
    mx.historybackstr = document.location.hash;

    var HashLocationName = document.location.hash;
    HashLocationName = HashLocationName.replace("#","");

    var objkey = HashLocationName.split('^');
    var sendparam = {};
    var keylen = mx.arrKey.length;
    for ( var  i= 0 ;i < keylen ;i++ )  {
      if (objkey[i] != '')  {
        sendparam[mx.arrKey[i]] = objkey[i];
      }
    }
    var objlen = Object.keys(sendparam).length;
    if (objlen > 0 ){
      mx.SendPacket(null, sendparam);
    }
  }else{
    //첫페이지 불러오기
  }
};

mx.RenameAnchor = function (anchorid, anchorname){
  document.getElementById(anchorid).name = anchorname; //this renames the anchor
}

mx.RedirectLocation = function (anchorid, anchorname, HashName){
  mx.RenameAnchor(anchorid, anchorname);
  document.location = HashName;
};

mx.HashCheckInterval = setInterval("mx.CheckForHash()", 1000);
window.onload = mx.CheckForHash;
//히스토리 저장/////////////////////////////////////////////////////////////////////////

//innerHTML 로딩 시점을 알기위해 추가
mx.waitUntil = function (fn, condition, interval) {
    interval = interval || 100;

    var shell = function () {
            var timer = setInterval(
                function () {
                    var check;

                    try { check = !!(condition()); } catch (e) { check = false; }

                    if (check) {
                        clearInterval(timer);
                        delete timer;
                        fn();
                    }
                },
                interval
            );
        };

    return shell;
};

mx.login = function(){
  if($("#UserID").val() == ""){
    alert("아이디를 입력하여 주십시오.");
    return;
  }

  if($("#UserPass").val() == ""){
    alert("패스워드를 입력하여 주십시오");
    return;
  }
  mx.SendPacket(null, {'CMD':mx.CMD_LOGIN,'ID':$("#UserID").val(),'PWD':$("#UserPass").val()})  
};

//동일한 패킷이 오는경우 (막음 처리?)
mx.SendPacket = function (sender, packet) {

    //var objlen = Object.keys(packet).length;
    if ((Number(packet.CMD) >= mx.CMD_DATAGUBUN && Number(packet.CMD) < mx.CMD_DATAGUBUN + 10000) && sender != null) { //보이는 화면 만 히스토리에 저장
        var locstr = '';
        var iskey = false;
        var keylen = mx.arrKey.length;

        for (var i = 0; i < keylen; i++) { //배열갯수만큼만 생성

            for (var key in packet) { //한개씩만 붙여나가자
                if (key == mx.arrKey[i]) {
                    if (i == 0) {
                        locstr += packet[key];
                        iskey = true;
                        break;
                    }
                    else {
                        locstr += '^' + packet[key];
                        iskey = true;
                        break;
                    }
                }
                else {
                    iskey = false;
                    //locstr += '^';
                    //break;
                }
            }
            if (iskey == false) {
                locstr += '^';
            }

        }

        mx.RedirectLocation("LocationAnchor", packet.CMD, "#" + locstr);
        return;
    }




    var datatype = "mix";
    var timeout = 5000;
    var reqcmd = packet.CMD;
    var reqdone = false; //Closure
    var url = "/pub/ajax/reqTennis.asp";
    var strdata = "REQ=" + encodeURIComponent(JSON.stringify(packet));
    var xhr = new XMLHttpRequest();
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    //setTimeout(function () { reqdone = true; }, timeout);

    if (Number(packet.CMD) >= mx.CMD_DATAGUBUN) {
        //apploading("AppBody", "로딩 중 입니다.");
    }

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && !reqdone) {
            if (mx.IsHttpSuccess(xhr)) {

                if (Number(packet.CMD) >= mx.CMD_DATAGUBUN) {
                    //$('#AppBody').oLoader('hide');
                }
 
                mx.ReceivePacket(reqcmd, mx.HttpData(xhr, datatype), sender);
                return true;
            }
            xhr = null;
        }
    };
    console.log(JSON.stringify(packet));
    //return;
    xhr.send(strdata);
};

mx.ReceivePacket = function( reqcmd, data, sender ){// data는 response string
  var rsp = null;
  var callback = null;
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  
  if ( Number(reqcmd) > mx.CMD_DATAGUBUN  ){
    if ( data.indexOf("`##`") !== -1 ){
      resdata = data.split( "`##`" );
      jsondata =  resdata[0];
      if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
        htmldata = resdata[1];
    }   
    else{
      htmldata = data;    
    }
  }
  else{
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( jsondata !='' && jsondata != null){

    //debug print
    if (jsondata.hasOwnProperty('debug') == true ){
      console.log("debug : " + jsondata.debug);
    }

    switch (Number(jsondata.result))  {
    case 0: break;
    case 1: alert('데이터가 존재하지 않습니다.');return;  break;
    case 50:  mx.confirm();return;  break;
    case 100: return;   break; //메시지 없슴
    }
  }

  switch (Number(reqcmd)) {
  case mx.CMD_LOGIN:  this.OnLogin( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_LOGOUT: this.OnLogout( reqcmd, jsondata, htmldata, sender );    break;
  case mx.CMD_LOGCHECK: this.OnLoginchk( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_STATUSSEARCH:
  case mx.CMD_GAMEGRADEPERSON:
  case mx.CMD_GAMEGRADEGROUP:
  case mx.CMD_RANKINGRATE:
  case mx.CMD_RANKINGMEDAL:
  case mx.CMD_RANKINGMEDALTOTAL:
  case mx.CMD_SCORELIST:
  case mx.CMD_CHANGESCORE:
  case mx.CMD_GAMESEARCH_Home:
  case mx.CMD_GAMESEARCH_Result_Home:
  case mx.CMD_GAMESEARCH_app:
  case mx.CMD_GAMESEARCH: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_GAMEGRADEGROUPAPPEND :
  case mx.CMD_GAMEGRADEPERSONAPPEND : this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );    break;


      
      
  case mx.CMD_ScoreBoardLive:
  case mx.CMD_ScoreDetailBoardLive:
  case mx.CMD_ScoreBoard:
  case mx.CMD_ScoreDetailBoard:
  case mx.CMD_SETSCORE: this.OnshowModal( reqcmd, jsondata, htmldata, sender );   break;

     
  case mx.CMD_FINDMAINSCORE:
  case mx.CMD_RESET:
  case mx.CMD_FINDSCORE:  this.OnPacket( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_RECORDER: this.OnPopClose( reqcmd, jsondata, htmldata, sender );    break;
  case mx.CMD_SAVECOURT:  this.OnsaveCourt( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_MODECHANGE: this.OnChangeMode( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_PRE:  this.OnPreLoad( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_DELETESCORE:  this.OndelLoad( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_ENTERSCORE: this.OnScore( reqcmd, jsondata, htmldata, sender );   break;
  //case mx.CMD_INPUTPOINT: this.OninputPoint( reqcmd, jsondata, htmldata, sender );    break;
  case mx.CMD_SETPOINT: this.OnsetPoint( reqcmd, jsondata, htmldata, sender );    break;
  case mx.CMD_TEST: this.OnShowMsg( reqcmd, jsondata, htmldata, sender );   break;
  case mx.CMD_GAMEEND:  this.OnGameEnd( reqcmd, jsondata, htmldata, sender );   break;
  case mx.SETSERVE: this.OnSetServe( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_ENTERSCORERESET:
  case mx.CMD_ENTERSCORESTOP:
  case mx.CMD_ENTERSCOREEND:  this.OnEnterGameEnd( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_TEAMCODERALLY:  this.OnLoadCode( reqcmd, jsondata, htmldata, sender );    break;

  case mx.CMD_COURTLIST:
  case mx.CMD_COURTNO:  this.OnCourtList( reqcmd, jsondata, htmldata, sender );   break;
  }
};


mx.OnCourtList = function(cmd, packet, html, sender){
  document.getElementById(sender).innerHTML = html;
};


// utill #############################################
  mx.replaceAll = function(str, searchStr, replaceStr){
    return str.split(searchStr).join(replaceStr);
  };

  mx.confirm = function(){
    $('.court_conf').modal('show');
  }
  
  //코트 다시그림
  mx.reDrowCourt = function(player){
    var courtposition = 'left';
    for(var i = 1 ; i <= player.length;i++){
      $('#courtidx_' + i).html(player[i-1].cidx);
      $('#court_' + i).html(player[i-1].cname);
      courtposition =  player[i-1].cteam;
      if (courtposition == 'left'){
        $('#court_' + i).attr('class', 'orange');
      }
      if (courtposition == 'right'){
        $('#court_' + i).attr('class', 'green');    
      }
    }
  };

  //서브 플레이어 구하기
  mx.findServePlayer = function(gameno){

    //서브공 순서에 맞추어 위치 표시해주기 (packet.GAMENO 게임종료되고 오니 ) 3서브부터 계산 1,2 서브는 수동으로 선택
    var svno = 1;
    if( arguments.length == 0 ) gameno = score.jsondata.GAMENO;


    var serveinfo = [];
    var pointno = 0;
    for(var i = 0 ; i < score.fplayers.length;i++){

        if (score.TIEBREAK == true){ //타이브레이크라면
          pointno = Number(score.jsondata.POINTNO);

          if( gameno %2 ==1 ){ //타이블레이크가 5점이라면
            gameno = gameno + 1;
          }

          svno = ( parseInt( gameno / 2) % 4) + 1;
          if (pointno == 0) {
            if( Number(score.fplayers[i].serve) == svno ){
              serveinfo[0] = score.fplayers[i].cidx;
              serveinfo[1] = score.fplayers[i].cname;
            }
          }
          else{
            
            svno = Number(svno) +  (pointno - parseInt( pointno / 2)) ; //첫번째 빼고 두번에 한번씩 바뀌어야한다
            if( svno > 4 ){
              svno = Number(svno)  % 4;
              if( svno == 0 ) svno = 4;
              if( Number(score.fplayers[i].serve) == svno ){
                serveinfo[0] = score.fplayers[i].cidx;
                serveinfo[1] = score.fplayers[i].cname;
              }         
            }
            else{
              if( Number(score.fplayers[i].serve) == svno ){
                serveinfo[0] = score.fplayers[i].cidx;
                serveinfo[1] = score.fplayers[i].cname;
              }
            }

            
//            if( pointno > 6){
//              svno = Number(svno) + ( parseInt( pointno / 2) % 4) + 1 ;
//              if( Number(score.fplayers[i].serve) == svno ){
//                serveinfo[0] = score.fplayers[i].cidx;
//                serveinfo[1] = score.fplayers[i].cname;
//              }
//            }
//            else{
//              svno = Number(svno) + parseInt( pointno / 2) + 1;
//              if( Number(score.fplayers[i].serve) == svno ){
//                serveinfo[0] = score.fplayers[i].cidx;
//                serveinfo[1] = score.fplayers[i].cname;
//              }
//            }

          
          }

        }
        else{
          if( Number(gameno) > 4){ //선수 4명이 다돌았을 경우 다시 시작  + 1해서 체크
            svno = Number(gameno)  % 4;
            if( svno == 0 ) svno = 4;
            if( Number(score.fplayers[i].serve) == svno ){
              serveinfo[0] = score.fplayers[i].cidx;
              serveinfo[1] = score.fplayers[i].cname;
            }
          }
          else{
            if( Number(score.fplayers[i].serve) == Number(gameno) ){
              serveinfo[0] = score.fplayers[i].cidx;
              serveinfo[1] = score.fplayers[i].cname;
            }
          }
        }
    }
    return serveinfo;
  };

  mx.pos = function(pos){
    if (pos == 0 ){
      return 'left_top';
    }
    else if(pos == 1){
      return 'right_top';
    }
    else if(pos == 2){
      return 'left_bottom';
    }
    else if(pos == 3){
      return 'right_bottom';
    }
  };

  //처음 기준(선수 셋팅한 기준) 으로 왼쪽 오른쪽이 바뀌었다면 왼쪽 오른쪽 점수 체인지
  mx.changeScore = function(){
    for(var i = 0 ; i < score.cplayers.length;i++){
      if( Number(score.cplayers[i].cidx) == Number(score.fplayers[0].cidx) ){
        if ( i == 0 || i == 2)  { //왼쪽으로 같은위치
          return "nochange";
        }
        else{
          return "change";
        }
      }
    }
  };

  //점수 스토리지에 업데이트
  mx.saveScore = function(lscore,rscore){
    //fplayers 0왼쪽 1오른쪽에만 넣어두자
    score.fplayers[0].score = lscore;
    score.fplayers[1].score = rscore;
    localStorage.setItem('FIRSTPLAYERS', JSON.stringify( score.fplayers  ));
  };
// utill #############################################


//서브 지정
mx.OnSetServe = function(cmd, packet, html, sender){

  localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));

  //서브 사용자 인덱스
  var serve = score.jsondata.SERVE;
  if( Number(score.jsondata.GAMENO) == 2 ){
    serve = score.jsondata.SERVE2;
  }

  //서브위치 저장 (위아래 바꿈 왼쪽 오른쪽에 따라서)
  var temp = score.fplayers;
  for(var i = 0 ; i < score.fplayers.length;i++){
    if( score.fplayers[i].cidx == serve ){ //1경기 또는 2경기의 서브와 같은 인덱스
        switch (mx.pos(i)){ //서브자 위치 //0,1,2,3  //2서브는 보호상태이니 그냥
        case "left_top": 
          if(Number(score.jsondata.GAMENO)  == 1){ 
          temp[0].serve = 1; //클릭 무조건 1
          temp[2].serve = 3;
          temp[1].serve = 0;
          temp[3].serve = 0;
          }else{temp[0].serve = 2;temp[2].serve = 4;} break;
        case "right_top": if(Number(score.jsondata.GAMENO) == 1){
          temp[1].serve = 1;
          temp[3].serve = 3;
          temp[0].serve = 0;
          temp[2].serve = 0;
          }else{temp[1].serve = 2;temp[3].serve = 4;} break;
        case "left_bottom": if(Number(score.jsondata.GAMENO) == 1){
          temp[2].serve = 1;
          temp[0].serve = 3;
          temp[1].serve = 0;
          temp[3].serve = 0;
          }else{temp[2].serve = 2;temp[0].serve = 4;}  break;
        case "right_bottom": if(Number(score.jsondata.GAMENO) == 1){ 
          temp[3].serve = 1; 
          temp[1].serve = 3 ;
          temp[0].serve = 0;
          temp[2].serve = 0;
          }else{temp[3].serve = 2;temp[1].serve = 4;}   break;
        }
    }
  }
  localStorage.setItem('FIRSTPLAYERS', JSON.stringify( temp  ));
  score.fplayers = temp;

  //cplayers 서브위치 동기화
  for(var i = 0 ; i < score.cplayers.length;i++){
      for(var n = 0 ; n < score.fplayers.length;n++){
        if( score.fplayers[n].cidx == score.cplayers[i].cidx ){
          score.cplayers[i].serve = score.fplayers[n].serve;
        }
      }
  }

  localStorage.setItem('COURTPLAYERS', JSON.stringify( score.cplayers  ));
  mx.servePosition(score.jsondata.POINTNO); //서브위치에 따라 변경

  if (  Number(score.jsondata.GAMENO) == 2 ){
    //첫서브 지정후 리시브 지정 
    score.modeChange();
  }
};


//대진표 에서 진입후 기본 정보 생성, 기존정보 클리어
mx.OnPacket =  function(cmd, packet, html, sender){
    if (packet.CMD == 100){
      packet.CMD = 20;
    }
    localStorage.setItem('REQ', JSON.stringify( packet  ));
    localStorage.removeItem('COURTPLAYERS');
    localStorage.removeItem('FIRSTPLAYERS');
    location.href = packet.targeturl;
};

//선수위치,스코어,서브 정보 생성 로컬스토리지 생성
mx.SetPlayers = function(packet){
  
  //기본 위치 정보
  var baseidx1 = $('#1_idx').text(); //상단에 표기된 인덱스
  var baseidx2 = $('#2_idx').text(); 
  var baseidx3 = $('#3_idx').text();  
  var baseidx4 = $('#4_idx').text();
  var left_gamescore = $('#left_gamescore').text();
  var right_gamescore = $('#left_gamescore').text();
  var c1,c2,c3,c4,cn1,cn2,cn3,cn4,gubun;

  //세팅된 코트 선수 정보
  if( packet == null){
    c1 =  $('#courtidx_1').text(); //(1,3) 짝  //코트에 인덱스 (ffplayers 디비저장된 인덱스)
    c2 =  $('#courtidx_2').text(); //(2,4) 짝
    c3 =  $('#courtidx_3').text();
    c4 =  $('#courtidx_4').text();
    cn1 =   $('#court_1').text();
    cn2 =   $('#court_2').text();
    cn3 =   $('#court_3').text();
    cn4 =   $('#court_4').text();
    gubun = score.jsondata.GN;
  }
  else{ //음..
    c1 =  packet.C1; //(1,3) 짝
    c2 =  packet.C2; //(2,4) 짝
    c3 =  packet.C3;
    c4 =  packet.C4;
    cn1 =   packet.CN1;
    cn2 =   packet.CN2;
    cn3 =   packet.CN3;
    cn4 =   packet.CN4;
    gubun = packet.GN;
  }

  //단식, 복식처리
  var leftmember = 'right';
  var rightmember = 'left';
  var leftscore = right_gamescore;
  var rightscore = left_gamescore;

  if ( Number(gubun) == 0 ){
    if( c1 == baseidx1 || c3 == baseidx1 ){
      leftmember = 'left';
      rightmember = 'right';
    }
  }
  else{
    if( c1 == baseidx1 || c1 == baseidx3 || c3 == baseidx1 || c3 == baseidx3 ){
      leftmember = 'left';
      rightmember = 'right';
      leftscore = left_gamescore;
      rightscore = right_gamescore;
    }
  }

  //서브순서 지정
  var sorder1 = 0;
  var sorder2 = 0;
  var sorder3 = 0;
  var sorder4 = 0;

  switch (Number(score.jsondata.SERVE)){ //선수 인덱스
  case Number(c1): sorder1 = 1;sorder3 = 3; break;
  case Number(c2): sorder2 = 1;sorder4 = 3; break;
  case Number(c3): sorder1 = 3;sorder3 = 1; break;
  case Number(c4): sorder2 = 3;sorder4 = 1; break;
  }

  switch (Number(score.jsondata.SERVE2)){
  case Number(c1): sorder1 = 2;sorder3 = 4; break;
  case Number(c2): sorder2 = 2;sorder4 = 4; break;
  case Number(c3): sorder1 = 4;sorder3 = 2; break;
  case Number(c4): sorder2 = 4;sorder4 = 2; break;
  }

  var courtplayers = [{'cidx':c1, 'cname':cn1,'cteam':leftmember,'score':leftscore,'serve':sorder1},{'cidx':c2, 'cname':cn2,'cteam':rightmember,'score':rightscore,'serve':sorder2},{'cidx':c3, 'cname':cn3,'cteam':leftmember,'score':leftscore,'serve':sorder3},{'cidx':c4, 'cname':cn4,'cteam':rightmember,'score':rightscore,'serve':sorder4}];
  var firstplayers = courtplayers;
  var fplayers = localStorage.getItem("FIRSTPLAYERS");  

  //리시브 조정된 위치로 재배치 (1,2 게임 저장할때 다시 조정 // 새로고침이나 불러올때는 기존것 참조 들어가면 안됨..)
  if (packet != null && fplayers!= null){
    if( Number(packet.GAMENO) == 2 ){
      score.fplayers = JSON.parse(fplayers);
      
      if(packet.RCPOS == 'left'){
        firstplayers = [courtplayers[1],score.fplayers[1],courtplayers[3],score.fplayers[3]];
      }
      if(packet.RCPOS == 'right'){
        firstplayers = [score.fplayers[0],courtplayers[0],score.fplayers[2],courtplayers[2]];     
      }

    }
  }

  localStorage.setItem('COURTPLAYERS', JSON.stringify( courtplayers  )); //현재배치된 위치


  if (fplayers == "" || fplayers== null || Number(score.jsondata.GAMENO) == 1 || Number(score.jsondata.GAMENO) == 2 ){ //2번에서 최종 저장하면 다시생성
    localStorage.setItem('FIRSTPLAYERS', JSON.stringify( firstplayers  )); //최초정해진 위치
  }

  score.cplayers = courtplayers;
  score.fplayers = firstplayers;
};

//경기입력 화면 불러오기 선수코트 배치 정보 생성
mx.OnScore= function(cmd, packet, html, sender){
  document.getElementById(sender).innerHTML = html;

  var cplayers = localStorage.getItem("COURTPLAYERS");
  var fplayers = localStorage.getItem("FIRSTPLAYERS");

  if (cplayers == null) {
    if (Number(score.jsondata.CMODE) > 0) {
      mx.waitUntil (mx.SetPlayers(null));//플레이어 정보 생성
      cplayers = localStorage.getItem("COURTPLAYERS");
      fplayers = localStorage.getItem("FIRSTPLAYERS");
      score.cplayers = JSON.parse(cplayers);
      score.fplayers = JSON.parse(fplayers);
      mx.waitUntil (mx.reloadCourt(3, null)); //초기진입, 이전단계 그대로 그리고 게임수 찾아서 넘겨주기
    }
  }
  else{
    score.cplayers = JSON.parse(cplayers);
    score.fplayers = JSON.parse(fplayers);
    //코트 현재 상태로 다시 그리기(새로 고침인경우)
    mx.waitUntil (mx.reloadCourt(1, null));
  }
};

//현재 상황 코트(서브, 점수) 다시그림
mx.reloadCourt =function(drowtype,gameno){

  if (gameno == null){ //새로 고침
    //gameno = $('#last_gameno').text(); //진행중인 게임번호
    gameno = score.jsondata.GAMENO;
  }


//  if ( (Number(gameno) == 1 && Number(score.jsondata.SERVE) > 0 ) || (Number(gameno) == 2 && Number(score.jsondata.SERVE2) > 0) ){ //시작이고 첫서브가 지정되어 리시브 지정순서라면
  if ( Number(gameno) == 2 && Number(score.jsondata.SERVE2) > 0 ){ //시작이고 첫서브가 지정되어 리시브 지정순서라면
    var serveinfo = mx.findServePlayer(); //서브선수 배열
    var serveidx = serveinfo[0];

    for(var i = 0 ; i < score.cplayers.length;i++){
      if( Number(score.cplayers[i].cidx) == Number(serveidx) ){ //선수는 (위 1,2  아래 3, 4)
        if (i == 0 || i== 2 ){ //현재위치
          var teampos = 'left';
        }
        else{
          var teampos = 'right';        
        }
      }
    }

    if (teampos == 'left'){
      $("#leftcourt").css("display", "none");
      $("#court_1").css("display", "block");

      $("#rightcourt").children("option").remove();
      $("#rightcourt").append("<option value='"+score.cplayers[1].cidx+"' selected>"+score.cplayers[1].cname+"</option>");
      $("#rightcourt").append("<option value='"+score.cplayers[3].cidx+"'>"+score.cplayers[3].cname+"</option>");
    }
    else{
      $("#rightcourt").css("display", "none");
      $("#court_2").css("display", "block");  

      $("#leftcourt").children("option").remove();
      $("#leftcourt").append("<option value='"+score.cplayers[0].cidx+"' selected>"+score.cplayers[0].cname+"</option>");
      $("#leftcourt").append("<option value='"+score.cplayers[2].cidx+"'>"+score.cplayers[2].cname+"</option>");
    } 
    //return;
  }



  //타이브레이크상태라면 2 , 3 세트의 경우 다시 작업하자..api.enter....에서 최종 셋트 번호를 가져와서...
  //##################################################
    var left_tiebreak = $("#left_breakscore").text();
    var right_tiebreak = $("#right_breakscore").text();
    var cidx1 = score.fplayers[0].cidx;  //현재 1번코트 인덱스
    var cidx2 = score.fplayers[1].cidx;  //현재 2번코트 인덱스

    if( score.TIEBREAK == true ){ //게임점수
      //점수 새로 그림
      $("#left_pt").html(left_tiebreak);
      $("#right_pt").html(right_tiebreak);
      mx.saveScore(left_tiebreak,right_tiebreak);

        if (drowtype == 3)  { //이전단계클릭시 처음 시작에서 

          if( Number(gameno) % 4 < 2 ){ //정위치시작
            drowtype = 1;
            if (parseInt(( Number(left_tiebreak) + Number( right_tiebreak) ) / 6) % 2  == 1){ 
              drowtype = 2;
            }
          }
          else{
            drowtype = 2;
            if (parseInt(( Number(left_tiebreak) + Number( right_tiebreak) ) / 6) % 2  == 1){ 
              drowtype = 1;
            }
          }

        }
        else{
          drowtype = 1;
        }
    }
    else{
      if( drowtype == 3){ //이전단계클릭시(플레이어 삭제시 초기코트에서)
        //if(Number(gameno) == 2 || Number(gameno) == 6 || Number(gameno) == 10){ //바뀔위치
        if( Number(gameno) == 0 || Number(gameno) % 4 < 2 ){ //바뀌었지만 정위치
          drowtype = 1;
        }
        else{
          drowtype = 2; //코트체인지
        }
      }
      else{
        drowtype = 1;
      }     
    }
  //##################################################

  if ( $("#left_pt").text() ==$("#right_pt").text() && Number($("#left_pt").text()) == 0 ){
    score.jsondata.POINTNO = 0;
    localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));
  }
  mx.changeCourt(drowtype, gameno); //코트체인지
};

//기술 입력 진행
mx.OnsetPoint =  function(cmd, packet, html, sender){
  //INNO  0,    1,2,3
  switch (Number(packet.INNO)){
  case 0: //이름입력호출
    $("#sk_shot").hide();
    $("#sk_course").hide();
    $("#sk_skillbox").hide();
    $("#sk_showarea").hide();

    $("#etcresult").show();
    $("#sk_player").show();
    ///////////////////////
     if (Number(score.jsondata.GAMENO) == 1 || Number(score.jsondata.GAMENO) == 2  ) {
      $("#servelink_1").css({ 'pointer-events': 'none' });
      $("#servelink_2").css({ 'pointer-events': 'none' });
      $("#servelink_3").css({ 'pointer-events': 'none' });
      $("#servelink_4").css({ 'pointer-events': 'none' });
     }
    mx.setScore(packet);    
    $("#logarea").html('');
    //이전단계비활성화
    $('#nextbtn_on').hide();
    $('#nextbtn_off').show();
  break;
  case 1: //1번스킬호출
    $("#etcresult").hide();
    $("#sk_player").hide();

    $("#sk_showarea").show();
    $("#sk_result").show();
    $("#sk_skillbox").show();
    $("#point_history").text("득점결과");
    $("#logarea").html("<span class='now'>"+packet.INVALUE.split('#$')[1]+"</span>");
    //이전단계 활성화
    $('#nextbtn_off').hide();
    $('#nextbtn_on').show();
  break;
  case 2: //이번스킬호출
    $("#etcresult").hide();
    $("#sk_player").hide();

    $("#sk_showarea").show();
    $("#sk_result").hide();

    //서브자가 아니라면 퍼스트서브, 세컨서브 막음
    if(Number(packet.SVIDX) == Number(packet.MIDX)){
      $("#shot_01").attr('class', 'btn btn-skill');
      $("#shot_05").attr('class', 'btn btn-skill');
    }
    else{
      $("#shot_01").attr('class', 'btn btn-skill off');
      $("#shot_05").attr('class', 'btn btn-skill off');
    }
    
    $("#sk_shot").css('display',"table-cell");
    $("#point_history").text("SHOT");
    $("#logarea").html( "<span>" + $("#logarea").text() + "</span><span class='now'>"+packet.INVALUE+"</span>");
    //$("#logarea").append("<span class='now'>"+packet.INVALUE+"</span>");
    //이전단계 활성화
    $('#nextbtn_off').hide();
    $('#nextbtn_on').show();
  break;
  case 3:  //삼번스킬호출
    $("#etcresult").hide();
    $("#sk_player").hide();

    $("#sk_showarea").show();
    $("#sk_shot").hide();
    $("#sk_course").css('display',"table-cell");
    //$("#logarea").append("<span class='now'>"+packet.INVALUE+"</span>");
    $("#point_history").text("COURSE");
    $("#logarea").html( mx.replaceAll( $("#logarea").html(),"now","a2" ) + "</span><span class='now'>"+packet.INVALUE+"</span>");
    //이전단계 활성화
    $('#nextbtn_off').hide();
    $('#nextbtn_on').show();
  break;
  } 
};


//듀스 옵션 체크
  //mx.chkDouceRull = function(leftscore, rightscore){
  //  //score.jsondata.DEUCEST;//0 기본룰 1노에드 2원듀스 노에드
  //  switch (Number(score.jsondata.DEUCEST)){
  //  case 0 :
  //    break;
  //  case 0 :
  //    break;
  //  case 0 :
  //    break;
  //  }
  //      //POINTNO:1
  //      //POS:"left"   클릭위치
  //      //RKEY:2159
  //      //LSCORE:1
  //      //RSCORE:0
  //      //SVIDX:"18"
//};

//한게임 종료처리로 내용보냄
mx.sendGameEnd = function(packet, req){
  var orignpos = 'right';
  for(var i = 0 ; i < score.fplayers.length;i++){
    if( Number(score.fplayers[i].cidx) == Number(packet.MIDX) ){ //왼쪽 오른쪽 중 어디가 이겼는지 확인
      orignpos = score.fplayers[i].cteam;
      if(packet.SK1 == 'NET' || packet.SK1 == 'OUT'){
        if (orignpos == 'left'){
          orignpos = 'right';
        }
        else{
          orignpos = 'left';        
        }
      }
    }
  }
  
  packet.CMD = mx.CMD_GAMEEND;
  packet.GN = req.GN;//예선 본선 구분 0 예선
  packet.ETYPE = req.ETYPE; //A E 아마추어 엘리트
  packet.P1 = req.P1; //선수1, 2 승패반영
  packet.P2 = req.P2;
  packet.POS = orignpos;
  packet.STARTSC = req.STARTSC;
  packet.TIESC = req.TIESC;
  packet.DEUCEST = req.DEUCEST;
  mx.SendPacket(null, packet); //한게임 종료처리
};


//점수 표시
mx.setScore = function(packet){
  score.jsondata.POINTNO = packet.POINTNO; //게임중 진행번호
  localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));

  //게임스코어 저장
  mx.saveScore(packet.LSCORE,packet.RSCORE);

  var l_score=0, r_scroe=0;
  var scoreposition = 'right';
  
  //점수표시//////////////////////////////////////////////// INNO = 1일때
  l_score = $("#left_pt").text(); //왼쪽 점수판
  r_score = $("#right_pt").text(); //오른쪽 점수판


  //현재 코트 위치로 왼쪽인지 오른쪽인지 //COURTPLAYERS    배열번호 : 현재 코트 위치 , cteam 최초위치
  for(var i = 0 ; i < score.cplayers.length;i++){
    if( Number(score.cplayers[i].cidx) == Number(packet.MIDX) ){ //배열위치에 선수와 , 클릭한 선수가 동일하다면
      if ( i == 0 || i == 2)  {
        scoreposition = 'left';
        if(packet.SK1 == 'NET' || packet.SK1 == 'OUT'){
          scoreposition = 'right';
        }
      }
      if ( i == 1 || i == 3)  {
        scoreposition = 'right';
        if(packet.SK1 == 'NET' || packet.SK1 == 'OUT'){
          scoreposition = 'left';
        }
      }
    }
  }


  if ( Number(packet.LSCORE) == -1) { //첫서브실패
    //passs
  }
  else{
    if( score.TIEBREAK == true ){ //게임점수

      //타이브레이크상태라면
      /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //서브공 순서에 맞추어 위치 표시해주기 (packet.GAMENO 게임종료되고 오니 ) 3서브부터 계산 1,2 서브는 수동으로 선택
        var serveinfo = mx.findServePlayer(); //서브선수 배열
        var serveidx = serveinfo[0];

        for(var i = 0 ; i < score.cplayers.length;i++){
          if( score.cplayers[i].cidx == serveidx ){ //선수는 (위 1,2  아래 3, 4)
            mx.setServe( i + 1);
          }
        }
        //mx.servePosition(score.jsondata.POINTNO); //서브위치 잡고

        //if( Number(score.jsondata.POINTNO) > 0  && Number(score.jsondata.POINTNO) % 2 == 0 ){//2번째마다 위치 변경
          //////////////////////////////////////////////////////////////////
          mx.playingServePosition(score.jsondata.POINTNO); //위치변경 table record psortno 
          //////////////////////////////////////////////////////////////////
        //}

        /////////////////////////////////////
        //타이브레이크인경우 2점마다 서브가 변경되므로 스코어 마다 매번 리시브 위치 조정
        if(Number(score.jsondata.POINTNO) % 2 == 1 || Number(score.jsondata.POINTNO) == 0 ){
          mx.recivePosition(); //리시브위치조정
        }

      //무저건 이점차이로 이겨야한다.
      if ( scoreposition == 'left'){ //눌린위치(스코어 얻은쪽)
        if( (Number(l_score) + 1) >=7 && (Number(l_score) + 1) - Number(r_score) >= 2 ){//먼저 7점 득점
          $("#left_pt").html( "0" );
          $("#right_pt").html( "0" );
          packet.TIELOSE = r_score; //타이브레이크 패자점수
          mx.sendGameEnd(packet, score.jsondata);

        }
        else{
          $("#left_pt").html( Number(l_score) + 1 );

          if( (Number(l_score) + 1 + Number(r_score)) % 6 == 0 ){
            mx.changeCourt(2 , parseInt((Number(l_score) + 1 + Number(r_score)) % 6 == 0 )  + 5 ); //코트체인지 + 서브 위치 조정 합이 6일때 마다 코트 체인지
          }
        }
      }
      else{
        if( (Number(r_score) + 1) >=7 && (Number(r_score) + 1) - Number(l_score) >= 2 ){//먼저 7점 득점
          $("#left_pt").html( "0" );
          $("#right_pt").html( "0" );
          packet.TIELOSE = l_score;
          mx.sendGameEnd(packet, score.jsondata);
        }
        else{
          $("#right_pt").html( Number(r_score) +1 );    
          if( (Number(r_score) + 1 + Number(l_score)) % 6 == 0 ){
            mx.changeCourt(2 , parseInt((Number(r_score) + 1 + Number(l_score)) / 6) + 5 ); //코트체인지 + 서브 위치 조정 합이 6일때 마다 코트 체인지
          }
        }
      }
    }
    else{
      packet.TIELOSE =0;
      //////////////////////////////////////////////////////////////////
      mx.playingServePosition(score.jsondata.POINTNO); //위치변경 recod psortno
      //////////////////////////////////////////////////////////////////

      var pageReLoad = false;
      var l_no = 0;
      var r_no = 0;
      //검증 후 다르면 페이지 새로고침
        switch(l_score){
        case "0": l_no = 0; break;
        case "15":  l_no = 1; break;
        case "30":  l_no = 2; break;
        case "40":
        case "AD":  l_no = 3; break;
        }
        switch(r_score){
        case "0": r_no = 0; break;
        case "15":  r_no = 1; break;
        case "30":  r_no = 2; break;
        case "40":
        case "AD":  r_no = 3; break;
        }
        if (l_no < 3 && r_no < 3 ){
          if( (Number(packet.LSCORE) == l_no && Number(packet.RSCORE) == Number(r_no) +1 ) || (Number(packet.LSCORE) == r_no && Number(packet.RSCORE) == Number(l_no) +1 )   || (Number(packet.RSCORE) == l_no && Number(packet.LSCORE) == Number(r_no) +1 ) || (Number(packet.RSCORE) == r_no && Number(packet.LSCORE) == Number(l_no) +1 )  ){

          }
          else{
            pageReLoad = true;
          }
        }
        if( (Number(packet.LSCORE) >= 3 && Number(packet.RSCORE) >= 3 )  ){
          if(l_no < 2 || r_no < 2){
            pageReLoad = true;
          }
        }     
        if( (Number(packet.LSCORE) >= 3 || Number(packet.RSCORE) >= 3 )  ){
          if(l_no < 2 && r_no < 2){
            pageReLoad = true;
          }
        }
        //나머지 경우는 어떻게 비교하지 ㅡㅡ+

        if (pageReLoad){
          location.href = './enter-Score.asp';
        }
        //packet.RSCORE       

      ///////////////////////////////     
      
      
      if ( scoreposition == 'left'){
        switch(l_score){
        case "0":
        $("#left_pt").html( "15" );
        break;
        case "15":
        $("#left_pt").html( "30" );
        break;
        case "30":
        $("#left_pt").html( "40" );
        break;
        case "40":
          //score.jsondata.DEUCEST;//0 기본룰 1노에드 2원듀스 노에드
          switch (Number(score.jsondata.DEUCEST)){
          case 0 :
              if (r_score == "40"){
                $("#left_pt").html( "AD" );
              }
              else if( r_score == "AD"){
                $("#right_pt").html( "40" );
              }
              else{
                $("#left_pt").html( "0" );
                $("#right_pt").html( "0" );
                mx.sendGameEnd(packet, score.jsondata);
              }
            break;
          case 1 :
              $("#left_pt").html( "0" );
              $("#right_pt").html( "0" );
              mx.sendGameEnd(packet, score.jsondata);
            break;
          case 2 : //원듀스 노에드?
              if( Number(packet.LSCORE) == 5 || Number(packet.RSCORE) == 5 ){
                $("#left_pt").html( "0" );
                $("#right_pt").html( "0" );
                mx.sendGameEnd(packet, score.jsondata);             
              }
              else{
                if (r_score == "40"){
                  $("#left_pt").html( "AD" );
                }
                else if( r_score == "AD"){
                  $("#right_pt").html( "40" );
                }
                else{
                  $("#left_pt").html( "0" );
                  $("#right_pt").html( "0" );
                  mx.sendGameEnd(packet, score.jsondata);
                }
              }
            break;
          }

        break;
        case 'AD': //이김 다음판으로
            $("#left_pt").html( "0" );
            $("#right_pt").html( "0" );
            mx.sendGameEnd(packet, score.jsondata);
        break;
        }
      }
      else{
        switch(r_score){
        case "0":
        $("#right_pt").html( "15" );
        break;
        case "15":
        $("#right_pt").html( "30" );
        break;
        case "30":
          $("#right_pt").html( "40" );
        break;
        case "40":
          //score.jsondata.DEUCEST;//0 기본룰 1노에드 2원듀스 노에드
          switch (Number(score.jsondata.DEUCEST)){
          case 0 :
              if (l_score == "40"){
                $("#right_pt").html( "AD" );
              }
              else if( l_score == "AD"){
                $("#left_pt").html( "40" );       
              }
              else{
                $("#left_pt").html( "0" );
                $("#right_pt").html( "0" );
                mx.sendGameEnd(packet, score.jsondata);
              }
            break;
          case 1 :
              $("#left_pt").html( "0" );
              $("#right_pt").html( "0" );
              mx.sendGameEnd(packet, score.jsondata);
            break;
          case 2 :
              if( Number(packet.LSCORE) == 5 || Number(packet.RSCORE) == 5 ){
                $("#left_pt").html( "0" );
                $("#right_pt").html( "0" );
                mx.sendGameEnd(packet, score.jsondata);             
              }
              else{
                if (l_score == "40"){
                  $("#right_pt").html( "AD" );
                }
                else if( l_score == "AD"){
                  $("#left_pt").html( "40" );       
                }
                else{
                  $("#left_pt").html( "0" );
                  $("#right_pt").html( "0" );
                  mx.sendGameEnd(packet, score.jsondata);
                }
              }
            break;
          }
        break;
        case 'AD': //이김 다음판으로
            mx.sendGameEnd(packet, score.jsondata);
        break;
        }     
      }
    
    }
  }

  //점수표시////////////////////////////////////////////////
};

//최종게임종료
mx.OnEnterGameEnd = function(cmd, packet, html, sender){
  //본선인경우 본선 대진표로 가도록 ~
  //location.href = "Enter-Score.asp";
  location.href = "RGameList.asp";
  //score.inputMainScore({'SCIDX':677,'P1':1771,P2:1769,'GN':1,'JONO':0,'RD':2,'GRND':8,'SNO':1});

};

//한게임종료 (발생 > 게임종료, 세트 종료, 코트 체인지, 서브체인지)
mx.OnGameEnd = function(cmd, packet, html, sender){
  score.jsondata.POINTNO = 0;
  score.jsondata.PRERESULT = packet.SETEND; //ING, LEFT, RIGHT, TIE
  score.jsondata.GAMENO = Number(score.jsondata.GAMENO) + 1;

  localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));

  if( packet.SETEND == 'LEFT' || packet.SETEND == 'RIGHT'){ //1  종료
    //REQ에 종료 넣음  다시 로드시 종료는?
    score.jsondata.GAMEEND = packet.SETEND;
    localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));
  }
  if( packet.SETEND == 'LEFT_TIE' ||  packet.SETEND == 'RIGHT_TIE'  ){ //타이브레이크 종료 7gamewin

  }

  if (score.jsondata.PRERESULT == 'ING' && Number(score.jsondata.GAMENO) + (Number(score.jsondata.STARTSC)*2) == Number(score.jsondata.TIESC)*2 + 1){//타이브레이크 시작
    score.TIEBREAK = true;
  }

  
  if( Number(score.jsondata.GAMENO) % 2 == 0) { //진행할 게임번호
    mx.changeCourt(2 , score.jsondata.GAMENO ); //코트체인지 + 서브 위치 조정
  }
  else{
    mx.changeCourt(1 , score.jsondata.GAMENO );
  }

  var left_set = $('#l_set'+packet.SETNO).text();
  var right_set = $('#r_set'+packet.SETNO).text();

  if(packet.POS == 'left'){
    var endsetscore = Number(left_set) + 1;
    $('#l_set'+packet.SETNO).html(Number(left_set) + 1);

    switch (endsetscore){       //세트 종료 //타이브레이크에서 승 (오른쪽에 패배한 점수 표시)         //세트에 점수 번경 total 스코어 변경
    case 7: 
        if( score.TIEBREAK == true){
          $('#right_tiebreak').html("("+packet.RSCORE+")");
        } 
        $('#left_settotal').html("1");
    break; 
    case 6:
      if( score.TIEBREAK == true){
        $('#right_tiebreak').html("("+packet.RSCORE+")");
      }
      if (score.jsondata.TIESC == 6) {
        if( Number(right_set) < 6 ){  //세트 종료
          $('#left_settotal').html("1");
        }
      }
      else{
        if( Number(right_set) < 5 ){  //세트 종료
          $('#left_settotal').html("1");
        }     
      }
    break;
    }
  }
  else{
    var endsetscore = Number(right_set) + 1;
    $('#r_set'+packet.SETNO).html(Number(right_set) + 1);

    switch (endsetscore){
    case 7: 
        if( score.TIEBREAK == true){
          $('#left_tiebreak').html("("+packet.LSCORE+")");
        }
        $('#right_settotal').html("1");
    break; 
    case 6:
      if( score.TIEBREAK == true){
        $('#left_tiebreak').html("("+packet.LSCORE+")");
      }
      if (score.jsondata.TIESC == 6) {
        if( Number(left_set) < 6 ){ //세트 종료
          $('#right_settotal').html("1");
        }
      }
      else{
        if( Number(left_set) < 5 ){ //세트 종료
          $('#right_settotal').html("1");
        }     
      }
    break;
    }
  }
};

//서브위치 변경
mx.setServe = function(no){
    if( Number(score.jsondata.S2KEY) == 200){ //단식
      for(var i= 1; i < 3;i++){
        $("#serve_" + i).attr('src', "images/tournerment/public/tennis_ball_off@3x.png");
      }
    }
    else{
      for(var i= 1; i < 5;i++){
        $("#serve_" + i).attr('src', "images/tournerment/public/tennis_ball_off@3x.png");
      }
    }
    $("#serve_" + no).attr('src', "images/tournerment/public/tennis_ball_on@3x.png");
};

//서브위치 초기화 2게임시작때 사용
mx.setServe2 = function(no){
    if( Number(score.jsondata.S2KEY) == 200){ //단식
      for(var i= 1; i < 3;i++){
        $("#serve_" + i).attr('src', "images/tournerment/public/tennis_ball_off@3x.png");
      }
    }
    else{
      for(var i= 1; i < 5;i++){
        $("#serve_" + i).attr('src', "images/tournerment/public/tennis_ball_off@3x.png");
      }
    }
};

//서브위치 조정 (처음 위치조정만)
mx.servePosition = function(pointno){ //pointno 포인트 득점 카운트 (gameend  = 1 > pointno = 0
  var courtposition = 'right';
  var temp = score.cplayers;

  switch (Number(score.jsondata.GAMENO)){
  case 1: var serveidx = score.jsondata.SERVE;    break;
  case 2:  var serveidx = score.jsondata.SERVE2;  break;
  default:
    var serveinfo = mx.findServePlayer(); //서브선수 배열
    var serveidx = serveinfo[0];
    break;
  }

  for(var i = 0 ; i < score.cplayers.length;i++){
    if( score.cplayers[i].cidx == serveidx ){ //선수는 (위 1,2  아래 3, 4)
      mx.setServe(i + 1);

      if (score.TIEBREAK == true){
        if( i == 2 ){ // 왼쪽 0번과 위치조정
          temp = [score.cplayers[2],score.cplayers[1],score.cplayers[0],score.cplayers[3]];         
        }
        if( i == 1 ){ // 3번과 위치조정
          temp = [score.cplayers[0],score.cplayers[3],score.cplayers[2],score.cplayers[1]];       
        }
      }
      else{
        if( i == 0 ){ // 왼쪽위치라면 2번과 위치조정
          temp = [score.cplayers[2],score.cplayers[1],score.cplayers[0],score.cplayers[3]]; 
        }
        if( i == 3 ){ // 오른쪽이라면 1번과 위치조정
          temp = [score.cplayers[0],score.cplayers[3],score.cplayers[2],score.cplayers[1]];
        }
      }
    }
  }

  localStorage.setItem('COURTPLAYERS', JSON.stringify( temp  ));
  score.cplayers = temp;

  //html 변경
  mx.reDrowCourt(temp);

  for(var i = 0 ; i < score.cplayers.length;i++){ //바꾼다음에 서브위치 조정
    if( score.cplayers[i].cidx == serveidx ){ //선수는 (위 1,2  아래 3, 4)
      mx.setServe(i + 1);
    }
  }
};

//게임 진행중 서브위치 조정 (리시브 기존 위치로)
mx.playingServePosition = function(pointno){ //pointno 포인트 득점 카운트 (gameend  = 1 > pointno = 0
  var courtposition = 'right';
  var temp = score.cplayers;
  var serveinfo = mx.findServePlayer(); //서브선수 배열
  var serveidx = serveinfo[0];

  for(var i = 0 ; i < score.cplayers.length;i++){
    if( score.cplayers[i].cidx == serveidx ){ //선수는 (위 1,2  아래 3, 4)
      mx.setServe(i + 1);

      if (score.TIEBREAK == true){
        //기준 서브자
        if( mx.pos(i).split("_")[0] == "left"){ //왼쪽 위치

          if( Number(pointno) == 0 ){
            if (mx.pos(i) == "left_bottom"){
              temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]];
            }
            else{
              temp = [score.cplayers[2],score.cplayers[1],score.cplayers[0],score.cplayers[3]];
            }         
          }
          else if(  Number(pointno) > 0 && Number(pointno) % 2 == 1 ){ //홀수 점수
            if (mx.pos(i) == 'left_bottom'){ //위(오른족)
              temp = [score.cplayers[2],score.cplayers[1],score.cplayers[0],score.cplayers[3]]; 
            }
            else{
              temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]];         
            }
          }
          else{ 
            if (mx.pos(i) == 'left_bottm'){ 
              temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]]; 
            }
            else{
              temp = [score.cplayers[2],score.cplayers[1],score.cplayers[0],score.cplayers[3]]; 
            }
          }
        }
        if( mx.pos(i).split("_")[0] == "right"){ //서브자 오른쪽 위치  아래부터 시작

          if( Number(pointno) == 0 ){
            if (mx.pos(i) == "right_bottom"){ //위에
              temp = [score.cplayers[0],score.cplayers[3],score.cplayers[2],score.cplayers[1]];
            }
            else{
              temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]];
            }         
          }
          else if(  Number(pointno) > 0  &&  Number(pointno) % 2 == 1){ //홀 
            if (mx.pos(i) == "right_bottom"){ //그대로
              temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]];
            }
            else{
              temp = [score.cplayers[0],score.cplayers[3],score.cplayers[2],score.cplayers[1]];
            }
          }
          else{  //짝수(오른쪽이니까)
            if (mx.pos(i) == "right_bottom"){  //서브가 오른족 아래에 있다면 (올려)
              temp = [score.cplayers[0],score.cplayers[3],score.cplayers[2],score.cplayers[1]];
            }
            else{
              temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]];
            }
          }
        }

      }
      else{
        if( mx.pos(i).split("_")[0] == "left"){ //서브자 왼쪽 위치
          
          if( Number(pointno) % 2 == 1 ){ //위로
            if (mx.pos(i) == 'left_top'){ //위에 있군
              temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]]; 
            }
            else{
              temp = [score.cplayers[2],score.cplayers[1],score.cplayers[0],score.cplayers[3]];         
            }
          }
          else{ //아래에 있어야지
            if (i == 0){ //위에 있군
              temp = [score.cplayers[2],score.cplayers[1],score.cplayers[0],score.cplayers[3]]; 
            }
            else{
              temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]]; 
            }
          }
        }
        if( i == 1  || i == 3){ //서브자 오른쪽 위치 
          
          if( Number(pointno) % 2 == 1){ //아래로
            if (i == 1){ //위에 있군
              temp = [score.cplayers[0],score.cplayers[3],score.cplayers[2],score.cplayers[1]];
            }
            else{
              temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]];
            }
          }
          else{ //위로 올려
            if (i == 1){ //위에 있군
              temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]];
            }
            else{
              temp = [score.cplayers[0],score.cplayers[3],score.cplayers[2],score.cplayers[1]];
            }
          }
        }
      }
    }
  }

  localStorage.setItem('COURTPLAYERS', JSON.stringify( temp  ));
  score.cplayers = temp;

  //html 변경
  mx.reDrowCourt(temp);

  for(var i = 0 ; i < score.cplayers.length;i++){ //바꾼다음에 서브위치 조정
    if( score.cplayers[i].cidx == serveidx ){ //선수는 (위 1,2  아래 3, 4)
      mx.setServe(i + 1);
    }
  }
};




//서브위치에 따른 리시브 위에 번호
mx.chkRecive = function(serveno){
  if( Number(serveno) == 1 || Number(serveno) == 3){
    return Number(score.jsondata.RECIVE2);
  }
  else{
    return Number(score.jsondata.RECIVE);
  }
};


//리시브 위치 html 변경 스토리지 저장 
mx.recivePosition = function(){
  var players = score.cplayers;
  var fplayers = score.fplayers;
  var temp = [];
  var firstrc = 'right', nowrc = 'left';      //지금리시브받는 팀 처음위칠, 현재위치

  var firstserve = score.jsondata.SERVE;
  var serveinfo = mx.findServePlayer();
  var serveidx = serveinfo[0];          //서브선수인덱스

  for(var i = 0 ; i < fplayers.length;i++){

    if( Number(fplayers[i].cidx) == Number(firstserve) ){//첫서브 위치에 반대로 리시브 시작 위치를 잡는다.
      if (mx.pos(i).split("_")[0] == 'right'){
        firstrc = 'left'; //리시브 기준위치는 서브의 반대. 둘다
      }
    }
  }

  for(var i = 0 ; i < players.length;i++){
    if( players[i].cidx == serveidx ){ 
      if( mx.pos(i).split("_")[0] == 'left' ){ //현재 서브인덱스위치
        nowrc = 'right'
      }
    }
  }

  if (firstrc == 'left'){   //처음리시브 왼쪽 ( 리시브위치 아래)
    if( nowrc == 'left'){
      if( mx.chkRecive(players[0].serve) == Number(players[0].cidx) ){
        temp = players;
      }
      else{
        temp = [players[2],players[1],players[0],players[3]];
      }
    }
    else{ //현재리시브는 오르쪽 (오른쪽꺼 변경)
      if( mx.chkRecive(players[1].serve) == Number(players[1].cidx) ){
        temp = [players[0],players[3],players[2],players[1]];
      }
      else{
        temp = players;
      }
    }
  }
  else{ //리시브 오른쪽이 고정 (리시브위치 위랑)
    if( nowrc == 'left'){ //현재리시브 왼쪽
      if( mx.chkRecive(players[0].serve) == Number(players[0].cidx) ){
        temp = [players[2],players[1],players[0],players[3]];
      }
      else{
        temp = players;
      }
    }
    else{ //리시브 오른쪽 (같은위치)
      if( mx.chkRecive(players[1].serve) == players[1].cidx ){
        temp = players;
      }
      else{
        temp = [players[0],players[3],players[2],players[1]];
      }
    }
  }


  //html 변경
  mx.reDrowCourt(temp);

  localStorage.setItem('COURTPLAYERS', JSON.stringify( temp  ));
  score.cplayers = temp;
};


//코트체인지
mx.changeCourt = function(drowtype, gameno, pointno){ //pointno 포인트 득점 카운트 (gameend  = 1 > pointno = 0
  var courtposition = 'right';
  switch (drowtype) {
  case 1: var temp = [score.cplayers[0],score.cplayers[1],score.cplayers[2],score.cplayers[3]]; break;
  case 2: var temp = [score.cplayers[1],score.cplayers[0],score.cplayers[3],score.cplayers[2]]; break; //코트체인지 좌우변경
  case 3:
  break;
  }

  //두번째 서브인 경우 첫서브 반대쪽 애들을 상대로 찾자...
  if (Number(gameno) == 2  && Number(score.jsondata.POINTNO) == 0 && Number(score.jsondata.SERVE2) == 0){
    var temp2;
    for(var i = 0 ; i < temp.length;i++){

      if( Number(temp[i].cidx) == Number(score.jsondata.SERVE) ){ //처음 코트체인지에 따라가기
        if (i == 0 || i == 2 ){ //왼쪽
          temp2 = [temp[2],temp[3],temp[0],temp[1]];  
        }
        else{
          temp2 = [temp[2],temp[3],temp[0],temp[1]];  
        }
      }
    }
    temp = temp2;
  }


  localStorage.setItem('COURTPLAYERS', JSON.stringify( temp  ));
  score.cplayers = temp;

  //html 변경
  mx.reDrowCourt(temp);

  //처음 기준으로 왼쪽 오른쪽이 바뀌었다면 왼쪽 오른쪽 점수 체인지 ? 
  //새로고침 
  //타이브레이크상테에서 코트 체인지가 발생했다면
  //init 되었을때는 이거가 맞는데.....타이브레이크에서 코트 체인지 되었을때는?
  var scoreposition = mx.changeScore();
  var temp_pt = $("#left_pt").text();
  if(scoreposition == 'change'){
    $("#left_pt").html($("#right_pt").text());
    $("#right_pt").html(temp_pt);
  }

  if (score.TIEBREAK == true && drowtype == 2){ //타이브레이크 코트 변경시 점수 좌우 변경
    
    for(var i = 0 ; i < score.cplayers.length;i++){
      if( score.cplayers[i].cidx == score.fplayers[0].cidx ){ //선수는 (위 1,2  아래 3, 4)
        if(mx.pos(i).split('_')[0] == 'left'){ //왼쪽
          $("#left_pt").html(score.fplayers[0].score);
          $("#right_pt").html(score.fplayers[1].score);
        }
        else{
          $("#left_pt").html(score.fplayers[1].score);
          $("#right_pt").html(score.fplayers[0].score);
        }
      }
    }   
  }


  if (Number(gameno) == 2)  {
    var firstserveinfo = mx.findServePlayer(1); //서브선수 배열
    var firstserveidx = firstserveinfo[0];
    var firstchange = 1;

    for(var i = 0 ; i < score.cplayers.length;i++){
      if( score.cplayers[i].cidx == firstserveidx ){ //처음 코트체인지에 따라가기
        mx.setServe2(i + 1);
        firstchange = i + 1;
      }
    }
    if (firstchange == 1 || firstchange == 3 ){
      $("#servelink_2").css({ 'pointer-events': 'auto' });
      $("#servelink_4").css({ 'pointer-events': 'auto' });  
    }
    else{
      $("#servelink_1").css({ 'pointer-events': 'auto' });
      $("#servelink_3").css({ 'pointer-events': 'auto' });
    }
  }


    //( 타이브레이크시 포인트점수로 구하자 현재순서를)
    if (score.TIEBREAK == true ){
        mx.playingServePosition(score.jsondata.POINTNO); //위치변경 recod psortno
    }
    else{
      mx.playingServePosition(score.jsondata.POINTNO); //위치변경 recod psortno   
    }

  if (Number(gameno) == 2  && Number(score.jsondata.POINTNO) == 0 ){//서브위치애들 리시브 위치에 놓고 시작

  }
  else{
    mx.recivePosition(); //리시브위치조정
  }
};













//########################################################





    /*
    mx.OnShowMsg =  function(cmd, packet, html, sender){
      if(Number(packet.MSHOW) == 1){
        score.splashmsg('저장정보가 삭제되었습니다.', 1000);
        location.href="RGameList.asp";
      }
    };
    */

    //변경된  위치로 선수 정보 표시
    /*
    mx.drowPlayer = function(){
      var serveno = score.jsondata.SERVE;
      if (serveno == "1") $("#courtplayer_1").html(score.cplayers[0].cname + "&nbsp;<span style='color:red;'>서브</span>");
      else $("#courtplayer_1").html(score.cplayers[0].cname);

      if (serveno == "2") $("#courtplayer_2").html(score.cplayers[1].cname + "&nbsp;서브");
      else $("#courtplayer_2").html(score.cplayers[1].cname);

      if (serveno == "3") $("#courtplayer_3").html(score.cplayers[2].cname + "&nbsp;서브");
      else $("#courtplayer_3").html(score.cplayers[2].cname);
      
      if (serveno == "4") $("#courtplayer_4").html(score.cplayers[3].cname + "&nbsp;서브");
      else $("#courtplayer_4").html(score.cplayers[3].cname);
    };
    */


    mx.OnPreLoad= function(cmd, packet, html, sender){
      //코트체인지 되었을수 있으니 스토리지 지우고  (코트 체인지가 다시 발생하는 문제를 해결)
      localStorage.removeItem('COURTPLAYERS');
      localStorage.removeItem('FIRSTPLAYERS');

      score.jsondata.SERVE = packet.SERVE;
      score.jsondata.SERVE2 = packet.SERVE2;
      score.jsondata.SETNO = packet.SETNO;
      score.jsondata.GAMENO = packet.GAMENO;
      score.jsondata.PRERESULT = packet.PRERESULT;
      score.jsondata.POINTNO = packet.POINTNO;
      localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));
      score.init();
    };

    mx.OndelLoad= function(cmd, packet, html, sender){
      localStorage.removeItem('COURTPLAYERS');
      localStorage.removeItem('FIRSTPLAYERS');

      score.jsondata.SERVE = packet.SERVE;
      score.jsondata.SERVE2 = packet.SERVE2;
      score.jsondata.SETNO = packet.SETNO;
      score.jsondata.GAMENO = packet.GAMENO;
      score.jsondata.PRERESULT = packet.PRERESULT;
      score.jsondata.POINTNO = packet.POINTNO;

      mx.saveScore(packet.LSCORE,packet.RSCORE);
      //타이블레이크 였다면 아닌상태로 만들자
      if ( Number(score.jsondata.GAMENO)+ (Number(score.jsondata.STARTSC)*2) != Number(score.jsondata.TIESC)*2 + 1) { //타이브레이크 상태 6: 6 > 13경기시작 
        score.TIEBREAK = false;
      }

      localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));
      score.init();
    };

    mx.OnChangeMode= function(cmd, packet, html, sender){
      //페이지 새로고침
      score.init();
    };

    //코트 정보 저장 (선수 정보 셋팅)
    mx.OnsaveCourt= function(cmd, packet, html, sender){

      //리시브 정보 붙이자 ㅡㅡ
    //  score.jsondata.RCPOS1 = packet.RCPOS;
    //  score.jsondata.RC1 = packet.RC1;
    //  score.jsondata.RC2 = packet.RC2;
    //
    //  score.jsondata.RCPOS1 = packet.RCPOS2;
    //  score.jsondata.RC3 = packet.RC3;
    //  score.jsondata.RC4 = packet.RC4;
      //두번째 리시브가 변경되었다면 
      if (Number(packet.GAMENO) == 2){
        if( Number(packet.RECIVE2) > 0 ){
          score.jsondata.RECIVE2 = packet.RECIVE2;
        }
      }
      localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));

      //기본 위치 정보
      mx.SetPlayers(packet);

      //코트번호, 코트종류
      //$("#T-courtno").attr("disabled", true);
      //$("#T-courtkind").attr("disabled", true);
      //$("#T-courtno").attr("class", "def");
      //$("#T-courtkind").attr("class", "def");

      //코트 플레이어 인덱스
      $("#leftcourt").css("display", "none");
      $("#rightcourt").css("display", "none");
      $("#court_1").css("display", "block");
      $("#court_2").css("display", "block");
      
      //서브시작정보
      if( Number(score.jsondata.GAMENO) != 2 ){
        $("#servelink_1").css({ 'pointer-events': 'auto' });
        $("#servelink_2").css({ 'pointer-events': 'auto' });
        $("#servelink_3").css({ 'pointer-events': 'auto' });
        $("#servelink_4").css({ 'pointer-events': 'auto' });
      }

      //코트 클릭
      $("#court_3").css({ 'pointer-events': 'auto' });
      $("#court_4").css({ 'pointer-events': 'auto' });

      $("#court_btn").html("<a href='javascript:score.modeChange()' class='btn-modify'>수정</a>");
    };

    mx.OnPopClose= function(cmd, packet, html, sender){
      $(sender).modal('toggle');
    };

    mx.OndrowHTML = function (cmd, packet, html, sender) {
        document.getElementById(sender).innerHTML = html;
        if (cmd == mx.CMD_SCORELIST) {
            $('#listpointbtn').hide();
            $('.point-board').animate({ "margin-right": '+=1273' });
        }
        if (cmd == mx.CMD_CHANGESCORE) {
            $("#l_set" + packet.SETNO).html(packet.leftsc);
            $("#r_set" + packet.SETNO).html(packet.rightsc);
        }

        if (cmd == mx.CMD_GAMESEARCH_app || cmd == mx.CMD_GAMESEARCH_Home || cmd == mx.CMD_GAMESEARCH_Result_Home) {
            if (packet) {
                //상단 가이드 처리 ( 라이브 스코어 표시 여부 ) 
                console.log(packet);

                //app 강수 별 화면 크기 설정 height : drd_No
                switch (packet.drd_No) {
                    case 0:
                    case 4:
                    case 8:
                    case 16:
                        $(".preli").css("height", "400px");
                        break;
                    case 128:
                        $("#scoregametable").css("height", "1700px");
                        $(".preli").css("height", "1700px");
                        $(".sub.sub-main.tourney.h-fix").css("height", "1700px");
                        break;
                    default:
                        if (packet.drd_No > 128) {
                            console.log(packet.drd_No);
                            console.log("128강 이상 설정일경우 처리 해야됨 추후");
                            $("#scoregametable").css("height", "2500px");
                            $(".preli").css("height", "2500px");
                            $(".sub.sub-main.tourney.h-fix").css("height", "2500px");
                        } else {
                            $("#scoregametable").css("height", "auto");
                            $(".preli").css("height", "auto");
                            $(".sub.sub-main.tourney.h-fix").css("height", "auto");
                        }
                        break;
                }
            } else {
                $("#scoregametable").css("height", "auto");
                $(".preli").css("height", "auto");
                $(".sub.sub-main.tourney.h-fix").css("height", "auto");
            }
        }
    };

    mx.OnAppendHTML =  function(cmd, packet, html, sender){
      $('#'+sender+' > tbody:last').append(html);
      $("body").scrollTop($("body")[0].scrollHeight);
    };

    mx.OnshowModal = function (cmd, packet, html, sender) {
        localStorage.setItem('REQ', JSON.stringify(packet));
        document.getElementById(sender).innerHTML = html;
        if (sender == "round-res") {
            $('#' + sender).modal('toggle');
        }
    };

    mx.OnLogin =  function(cmd, packet, html, sender){
      if (packet.logincheck ==  "1"){ //성공
        document.getElementById("DP_Login").style.display = "none";
        document.getElementById("DP_Logout").style.display = "block";
      }
      else{
        $('#login-modal').modal('toggle');
      }
    };
    mx.OnLogout =  function(cmd, packet, html, sender){
      //document.getElementById("DP_Logout").style.display = "none";
      //document.getElementById("DP_Login").style.display = "block";
      location.href = "index.asp";
    };

    mx.OnLoginchk =  function(cmd, packet, html, sender){

        if (packet.go == "0"){
          $('#advise-modal').modal('toggle');
          return;
        }
        else{
        localStorage.setItem("IntroIndex", packet.no);
        switch (packet.no){
        case "1":
          //apploading("AppBody", "경기스코어입력 화면으로 이동 중 입니다.");
          location.href = "Calendar.asp";
          break;
        case "2":
          //apploading("AppBody", "대회결과보기 화면으로 이동 중 입니다.");
          location.href = "Calendar.asp";
          break;
        case "3":
          //apploading("AppBody", "경기운영본부 화면으로 이동 중 입니다.");
          location.href = "Calendar.asp";
          break;
        case "4":
          //apploading("AppBody", "대회통계 화면으로 이동 중 입니다.");
          location.href = "stat-winner-state.asp";
          break;
        }
        }
    };



    //검색 코드 불러오기
    mx.OnLoadCode = function(cmd, packet, html, sender){

      var myArr = packet; //단식부 ,개인-복식, 단체전

      if (score.smenu == null || score.smenu == ""){
        localStorage.setItem('smenu', packet); //배열
        score.smenu = localStorage.getItem('smenu');
        //메뉴배치
        if( myArr[0] == 0){//단식부
          $("#TeamGb").children("option").remove();

          if( myArr[1] > 0){//개인복식
          $("#TeamGb").append("<option value='201' selected>복식</option>");
            score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
          }
          else{
            $("#_s1menu1").hide();
          }
        }
        else{
          $("#TeamGb").children("option").remove();
          $("#TeamGb").append("<option value='200' selected>단식</option>");
          if( myArr[1] > 0){//개인복식
            $("#TeamGb").append("<option value='201'>복식</option>");
          }
          score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
        }
        
        if( myArr[2] == 0){//단체부
          $("#_s1menu2").hide();
        }
      }

      else{
        //검색 매뉴 배치
        $(sender).children("option").remove();
        if (myArr.length > 0){
            for (var i = 0; i < myArr.length; i++)
            {
              if (i == 0 ){
                $(sender).append("<option value='" + myArr[i].TeamGb +"' selected>" +  myArr[i].TeamGbNm + "</option>");
              }
              else{
                $(sender).append("<option value='" + myArr[i].TeamGb +"'>" +  myArr[i].TeamGbNm + "</option>");       
              }
            }

            //스코어화면 백경우 원래위치로 
            if(localStorage.getItem("BackPage") == "enter-score"){
              var selectinfo = localStorage.getItem('searchinfo').split(','); //조회 저장 정보
              $("#SexLevel option[value=" + selectinfo[2]+ "]").attr('selected','selected');      
              localStorage.setItem('BackPage', ''); //원래대로
              score.gameSearch({'TT' : 2, 'SIDX' : selectinfo[5]});
            }
        }
      
      }
    };

//########################################################



    $(document).ready(function () {
        window.onpopstate = function (event) {
            $(".close").click();
            $('#round-res').modal("hide");
            $('#round-res-live').modal("hide");

            console.log("window.onpopstate myModal");
            $("#player_Ifram_MediaLink").attr("src", "");
            if (history.state == null) {

            } else {
                history.back();
            }
        };

        $('#round-res,#round-res-live').on('shown.bs.modal', function (e) {
            console.log("shown.bs.modal myModal");
            history.pushState({ page: 1, name: '팝업' }, '', '?popup');
        });

        $('#round-res,#round-res-live').on('hidden.bs.modal', function (e) {
            console.log(" hidden.bs.modal myModal");
            $("#player_Ifram_MediaLink").attr("src","");


            if (history.state == null) {

            } else {
                history.back();
            }
        });

    });