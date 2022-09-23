<!-- #include virtual = "/pub/header.tennis.asp" -->
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/tennis/html.head.asp" -->

<script type="text/javascript">
<!--

  var score =  score || {};
  score.jsondata;
  score.cplayers;
  score.fplayers;
  score.TIEBREAK = false;
  score.playercnt = 4;

  //메시지색 일시적으로 변경
  score.splashcolor = function(obj, deltime){
    obj.style.color = 'orange';
    setTimeout(function(){obj.style.color = '#fff';},deltime);
  };

  //일시적으로 팝업 보여줌
  score.splashmsg = function(msg, deltime){
    $("#sf_msg").html(msg);
    $(".ipt-modal").modal('show');
    setTimeout(function(){$(".ipt-modal").modal('hide');},deltime);
  };


  //스코어변경
  score.changeScore = function(rkey,ckpos,skill1,midx,mname){
    var obj = {};
    obj.CMD = mx.CMD_CHANGESCORE;
    obj.RKEY = rkey;
    obj.SETNO = score.jsondata.SETNO;

    obj.SCIDX = score.jsondata.SCIDX;
    obj.GN = score.jsondata.GN; //예선 본선 구분
    obj.P1 = score.jsondata.P1;
    obj.P2 = score.jsondata.P2;
    obj.S2KEY = score.jsondata.S2KEY;
    obj.ETYPE =score.jsondata.ETYPE;
    obj.CKPOS = ckpos;
    obj.SKILL1 = skill1;
      obj.STARTSC = score.jsondata.STARTSC;
      obj.TIESC = score.jsondata.TIESC;
      obj.DEUCEST = score.jsondata.DEUCEST;

    //반대편 대표 선수를 보낸다.
    obj.MIDX = midx;
    obj.MNM = mname;

    mx.SendPacket('gamerc_area', obj);
  };

  //마지막 스코어 삭제
  score.delScoreList = function(rkey, rckey, winpos){
    var obj = {};
    obj.CMD = mx.CMD_DELETESCORE;
    obj.RKEY = rkey;
    obj.RCKEY = rckey;
    obj.SETNO = score.jsondata.SETNO;
    obj.WINPOS = winpos;

    obj.STARTSC = score.jsondata.STARTSC;
    obj.TIESC = score.jsondata.TIESC;
    obj.DEUCEST = score.jsondata.DEUCEST;

    mx.SendPacket('gamerc_area', obj);  
  };






  //스코어 입력
  score.enterScore_easy = function(lr , wincencel){ //왼쪽오른쪽, 승&취소

		if( score.jsondata.PRERESULT != "ING"){
			if (confirm('경기가 종료되었습니다. 계속 입력하시겠습니까?')) {
				score.jsondata.PRERESULT = "ING";
			} else {
				return;
			}
		}

		var packet = {};
		packet.CMD = mx.CMD_SETDPOINT;
		packet.SCIDX = score.jsondata.SCIDX;
		packet.POS = null; //왼쪽 오른쪽
		packet.SVNM = null;

		if (Number(score.jsondata.CMODE) == 1)  { //저장완료

			  if ( ( (Number(score.jsondata.GAMENO) == 1 &&  Number(score.jsondata.SERVE) == 0)  || (Number(score.jsondata.GAMENO) == 2 &&  Number(score.jsondata.SERVE2) == 0)   ) ){
				score.splashmsg('서브를 넣을  선수를 지정해 주십시오.',1500);
				return;
			  }
			  else{

				  if (lr == 'left'){
					  if(wincencel == 'win'){
							packet.MIDX = score.cplayers[0].cidx;
							packet.NM = score.cplayers[0].cname;
							var serveinfo = mx.findServePlayer();
							packet.SVIDX = serveinfo[0];  //서브 선수 인덱스       
							packet.SVNM = serveinfo[1]; //서브 선수 명
							//왼쪽 오른쪽구분
							for(var i = 0 ; i < score.fplayers.length;i++){
								if( score.fplayers[i].cidx == packet.MIDX ){
									packet.POS = score.fplayers[i].cteam; //맨처음 좌우 결정
								}
							}
							mx.SendPacket(null, packet); 
					  }
				  }
				  else{
					  if(wincencel == 'win'){
							packet.MIDX = score.cplayers[1].cidx;
							packet.NM = score.cplayers[1].cname;
							var serveinfo = mx.findServePlayer();
							packet.SVIDX = serveinfo[0];  //서브 선수 인덱스       
							packet.SVNM = serveinfo[1]; //서브 선수 명
							//왼쪽 오른쪽구분
							for(var i = 0 ; i < score.fplayers.length;i++){
								if( score.fplayers[i].cidx == packet.MIDX ){
									packet.POS = score.fplayers[i].cteam; //맨처음 좌우 결정
								}
							}
							mx.SendPacket(null, packet); 					  
					  }
				  }

			  }
		}
		else{
			  score.splashmsg('코트에 선수를 지정 후 저장해 주세요.',1500);    
		}

  };

























  //스코어 입력
  score.enterScore = function(inputvalue, no){

      //if( score.jsondata.propertyIsEnumerable('GAMEEND') ==  true){
      if( score.jsondata.PRERESULT != "ING"){
		//score.splashmsg('경기가 종료되었습니다. 경기종료 버튼을 눌러주세요.',1500);
        //return;               
		if (confirm('경기가 종료되었습니다. 계속 입력하시겠습니까?')) {
			score.jsondata.PRERESULT = "ING";
		} else {
			return;
		}

      }
    
      if (Number(score.jsondata.CMODE) == 1)  { //저장완료

      if ( Number(no) == 0  && ( (Number(score.jsondata.GAMENO) == 1 &&  Number(score.jsondata.SERVE) == 0)  || (Number(score.jsondata.GAMENO) == 2 &&  Number(score.jsondata.SERVE2) == 0)   ) ){
        score.splashmsg('서브를 넣을  선수를 지정해 주십시오.',1500);
        return;
      }
      else{
        if(no == 0 && inputvalue.length == 1 ){ //최초에 0~4로 넘어온다 지우지말자 사용한다.
          var playerinfo = score.cplayers[Number(inputvalue)].cidx  + '#$' +  score.cplayers[Number(inputvalue)].cname;
          inputvalue = playerinfo;
        }
        //if(no ==0 && inputvalue == undefined)

        var packet = {};
        packet.CMD = mx.CMD_SETPOINT;
        packet.SCIDX = score.jsondata.SCIDX;
        packet.INVALUE = inputvalue; //클릭값
        packet.INNO = no; //순서번호
        packet.POS = null; //왼쪽 오른쪽
        packet.SVNM = null;

        var serveinfo = mx.findServePlayer();
        packet.SVIDX = serveinfo[0];  //서브 선수 인덱스       
        packet.SVNM = serveinfo[1]; //서브 선수 명

        //왼쪽 오른쪽구분
        if (Number(no) == 0){ //INNO 업데이트 순서 0,1,2,3  이름, 스킬1 스킬2 스킬3 IN ACE 승 
          for(var i = 0 ; i < score.fplayers.length;i++){
            if( score.fplayers[i].cidx == inputvalue.split('#$')[0] ){
              packet.POS = score.fplayers[i].cteam; //맨처음 좌우 결정
            }
          }
        }

        mx.SendPacket(null, packet); 
      }

    }
    else{
      score.splashmsg('코트에 선수를 지정 후 저장해 주세요.',1500);    
    }
  };


  //기록관, 시작시간  저장
  score.startGame = function(){
    var startH = $("#startH").val();
    var startM = $("#startM").val();
    if($("#in_rcname").val() == ''){
      score.splashcolor(document.getElementById("rcpopmsg"), 1000)
    return;
    }
    score.jsondata.RNM = $("#in_rcname").val();
    localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));

    $("#rc_name").html(score.jsondata.RNM);
    mx.SendPacket('.start-modal', {'CMD':mx.CMD_RECORDER,'SCIDX':score.jsondata.SCIDX,'H':startH,'M':startM, 'RC':$("#in_rcname").val() });   
  };
  
  score.findPlayerIndex = function(cname){
    for(var i = 0 ; i < score.fplayers.length;i++){
      if( score.fplayers[i].cname == cname ){ //선수는 (위 1,2  아래 3, 4)
        return score.fplayers[i].cidx;
      }
    } 
  };
  
  score.findPlayerPos = function(cname){
    for(var i = 0 ; i < score.fplayers.length;i++){
      if( score.fplayers[i].cname == cname ){ //선수는 (위 1,2  아래 3, 4)
        return score.fplayers[i].cteam;
      }
    } 
  };

  //코트정보 저장
  score.saveCourt = function(){
    //코트번호, 종류
    var courtno = $("#T-courtno").val();
    var courtkind = $("#T-courtkind").val();
    score.jsondata.CRTNO = courtno;
    score.jsondata.CRTKND = courtkind;


    //선수 위치 인덱스 정보
    var cidx1 = $("#leftcourt").val(); //1코트 플레이어 인덱스
    var cidx2 = $("#rightcourt").val();   

    var cidx3 = $("#courtidx_3").text();
    var cidx4 = $("#courtidx_4").text();

    //선수명도 보내자
    var cname1 = $("#court_1").text();
    var cname2 = $("#court_2").text();    
    var cname3 = $("#court_3").text();    
    var cname4 = $("#court_4").text();

    if (Number(score.jsondata.GAMENO) == 2){
      //2번째꺼 삐뚤어진다 선수명으로 다시 찾자 ㅡㅡ+
      var cidx1 = score.findPlayerIndex(cname1);
      var cidx2 = score.findPlayerIndex(cname2);
      var cidx3 = score.findPlayerIndex(cname3);
      var cidx4 = score.findPlayerIndex(cname4);
    }

    //판정 정보
    var leftresult = $("#leftresult").val(); 
    var rightresult = $("#rightresult").val();

    score.jsondata.CMODE = 1; //저장완료
    localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));
    var obj = {'CMD':mx.CMD_SAVECOURT,'SCIDX':score.jsondata.SCIDX,'C1':cidx1,'C2':cidx2,'C3':cidx3, 'C4':cidx4, 'LT':leftresult,'RT':rightresult,'CTNO':courtno,'CTKD':courtkind,'CN1':cname1,'CN2':cname2,'CN3':cname3,'CN4':cname4 };
    
    obj.GAMENO = score.jsondata.GAMENO;
    obj.SERVE = score.jsondata.SERVE;
    obj.SERVE2 = score.jsondata.SERVE2;

	obj.RECIVE2 = 0;
	if (score.jsondata.GAMENO == 2){
		obj.RECIVE2 = score.tempRECIVE;
	}

    mx.SendPacket('enterscore', obj);
  };

  //코트정보 수정
  score.modeChange = function(){
    var sd = score.jsondata;
    
    if (  Number(sd.GAMENO) == 1 && Number(sd.POINTNO) == 0 ){
		//서브기록 삭제 완전 초기화해서 다시부름....	
		//var obj = {'CMD':mx.CMD_RESET,'SCIDX':sd.SCIDX};
		var obj = score.jsondata;
		obj.CMD = mx.CMD_RESET;
		obj.SERVE = 0;
		obj.SERVE2 = 0;
		obj.RECIVE = 0;
		obj.RECIVE2 = 0;
		obj.CMODE = 0;
		mx.SendPacket(null, obj);
		return;
	}

	
	//POINTNO 한게임에 게임진행번호
    //if ( ( Number(score.jsondata.GAMENO) == 1 ||  (Number(score.jsondata.GAMENO) == 2 )  && Number(score.jsondata.POINTNO) == 0  && Number(score.jsondata.SERVE2) > 0) ){
    if ( ( Number(sd.GAMENO) == 1 && Number(sd.POINTNO) == 0) ||  (Number(sd.GAMENO) == 2   && Number(sd.POINTNO) == 0) ){
      if(Number(sd.GAMENO) == 2   && Number(sd.POINTNO) == 0 && Number(sd.SERVE2) == 0){
        score.splashmsg('서브 선수를 지정해 주십시오.',1500);
        return;     
      }

      score.jsondata.CMODE = 2; //수정모드
      localStorage.setItem('REQ', JSON.stringify( score.jsondata  ));
      mx.SendPacket(null, {'CMD':mx.CMD_MODECHANGE,'SCIDX':score.jsondata.SCIDX});

    }
    else{
      score.splashmsg('게임이 진행 중 입니다.',1500);
      return;
    }
  };

  //기타판정 상대 판정 변경
  score.etcResult = function(obj){
    var gameresult = $('#'+obj.id).val();
    var tarvalue;
    var resulttext = ["::그 외 판정결과 선택::","부전승","기권승","실격승","양선수 불참","양선수 기권패","양선수 실격패","승"];
    var selectno;
    var rtlen = resulttext.length;
    
    switch (Number(gameresult)) {
    case 4: selectno= 4; break;
    case 5: selectno= 5; break;
    case 6: selectno= 6; break;
    }

    if( obj.id == 'leftresult'){
      tarvalue = $("#rightresult").val();
      if (Number(gameresult) > 3 || Number(tarvalue) > 3){
        $("#rightresult").children("option").remove();
        for (var i = 0;i < rtlen ;i++ ){
          if ( i ==  selectno ){
            $("#rightresult").append("<option value='"+i+"' selected>" +  resulttext[i] + "</option>");
          }else{
            $("#rightresult").append("<option value='"+i+"'>" +  resulttext[i] + "</option>");
          }
        }
      }
    }
    else{
      tarvalue = $("#leftresult").val();
      if (Number(gameresult) > 3 || Number(tarvalue) > 3){

        $("#leftresult").children("option").remove();
        for (var i = 0;i < rtlen ;i++ ){
          if ( i ==  selectno ){
            $("#leftresult").append("<option value='"+i+"' selected>" +  resulttext[i] + "</option>");
          }else{
            $("#leftresult").append("<option value='"+i+"'>" +  resulttext[i] + "</option>");
          }
        }

      }
    }
  };

  //코트 플레이어 정보변경
  score.tempRECIVE;
  score.setCourt = function(obj, tuserarr){

	var playeridx = $('#'+obj.id).val(); //선수인덱스
    
	////////////////////리시브
	if (   Number(score.jsondata.GAMENO) == 2  ){
		var temprecive = score.jsondata.RECIVE2;
		 if (Number(temprecive) == Number(playeridx) ){
			score.tempRECIVE = temprecive;
		 }
		else{
			score.tempRECIVE = playeridx;
		}
	}
	////////////////////리시브	
	
	var idx = $('#'+obj.id + ' option').index($('#'+obj.id + ' option:selected')); //선택된 인덱스 
    var targetidx;
    var selectno = null, partnerA = null, partnerB = null;

    if( obj.id == 'leftcourt'){
      targetidx = $('#rightcourt option').index($('#rightcourt option:selected'));
      switch (Number(idx)) {
      case 0: 
        if (Number(targetidx) == 0 || Number(targetidx) == 1){
          selectno= 2;partnerA =1;partnerB =3; 
        }
        else{
          partnerA =1;
        }
      break;
      case 1:
        if (Number(targetidx) == 0 || Number(targetidx) == 1){
          selectno= 2;partnerA =0;partnerB =3; 
        }
        else{
          partnerA =0;
        }
      break;
      case 2:
        if (Number(targetidx) == 2 || Number(targetidx) == 3){
          selectno= 0;partnerA =3;partnerB =1;
        }
        else{
          partnerA =3;
        }
      break;
      case 3:
        if (Number(targetidx) == 2 || Number(targetidx) == 3){
          selectno= 0;partnerA =2;partnerB =1;
        }
        else{
          partnerA =2;
        }
      break;
      }
    }
    else{
      targetidx = $('#leftcourt option').index($('#leftcourt option:selected'));
      switch (Number(idx)) {
      case 0:
        if (Number(targetidx) == 0 || Number(targetidx) == 1){
          selectno= 2;partnerA =3;partnerB =1;
        }
        else{
          partnerB =1;
        }
      break;
      case 1:
        if (Number(targetidx) == 0 || Number(targetidx) == 1){
          selectno= 2;partnerA =3;partnerB =0;
        }
        else{
          partnerB =0;
        }
      break;
      case 2:
        if (Number(targetidx) == 2 || Number(targetidx) == 3){
          selectno= 0;partnerA =1;partnerB =3;
        }
        else{
          partnerB =3;
        }
      break;
      case 3:
        if (Number(targetidx) == 2 || Number(targetidx) == 3){
          selectno= 0;partnerA =1;partnerB =2; 
        }
        else{
          partnerB =2;
        }
      break;
      }   
    }

    ///////////////////////////////////////////////////////
    if( Number(score.jsondata.S2KEY) == 200){ //단식
      //................  
    }else{ //복식
      if (obj.length == 2)  { // 셀렉트 박스 옵션 2개라면 리시브 결정 이라면///////////
        if( obj.id == 'leftcourt'){
          var temp1,temp2,temp3,temp4;

          temp1 = $("#courtidx_1").text();
          temp2 = $("#court_1").text();
          temp3 = $("#courtidx_3").text();
          temp4 = $("#court_3").text();
          $("#courtidx_1").html(temp3);
          $("#court_1").html(temp4);
          $("#courtidx_3").html(temp1);
          $("#court_3").html(temp2);        
        }
        else{
          temp1 = $("#courtidx_2").text();
          temp2 = $("#court_2").text();
          temp3 = $("#courtidx_4").text();
          temp4 = $("#court_4").text();
          $("#courtidx_2").html(temp3);
          $("#court_2").html(temp4);
          $("#courtidx_4").html(temp1);
          $("#court_4").html(temp2);    
        }
      } //리시브 결정 이라면//////////////////////////////////
      else{
        if( obj.id == 'leftcourt'){
          if (selectno == null){
            $("#courtidx_1").html(tuserarr[idx].split('#$')[0]);
            $("#court_1").html(tuserarr[idx].split('#$')[1]);
            $("#courtidx_3").html(tuserarr[partnerA].split('#$')[0]);
            $("#court_3").html(tuserarr[partnerA].split('#$')[1]);
          }
          else{
            $("#rightcourt").children("option").remove();
            for (var i = 0;i < 4 ;i++ ){
              if ( i ==  selectno ){
                $("#rightcourt").append("<option value='"+tuserarr[i].split('#$')[0]+"' selected>" +  tuserarr[i].split('#$')[1] + "</option>");
              }else{
                $("#rightcourt").append("<option value='"+tuserarr[i].split('#$')[0]+"'>" + tuserarr[i].split('#$')[1] + "</option>");
              }
            }
            $("#courtidx_1").html(tuserarr[idx].split('#$')[0]);
            $("#court_1").html(tuserarr[idx].split('#$')[1]);
            $("#courtidx_2").html(tuserarr[selectno].split('#$')[0]);
            $("#court_2").html(tuserarr[selectno].split('#$')[1]);
            $("#courtidx_3").html(tuserarr[partnerA].split('#$')[0]);
            $("#court_3").html(tuserarr[partnerA].split('#$')[1]);
            $("#courtidx_4").html(tuserarr[partnerB].split('#$')[0]);
            $("#court_4").html(tuserarr[partnerB].split('#$')[1]);  
            
            //좌우 변경 색도 변경 원래색상으로 그려준다.
            $("#court_1").attr("class", tuserarr[idx].split('#$')[2]);
            $("#court_2").attr("class", tuserarr[selectno].split('#$')[2]);
            $("#court_3").attr("class", tuserarr[partnerA].split('#$')[2]);
            $("#court_4").attr("class", tuserarr[partnerB].split('#$')[2]);
          }
        }
        else{
          if (selectno == null){
            $("#courtidx_2").html(tuserarr[idx].split('#$')[0]);
            $("#court_2").html(tuserarr[idx].split('#$')[1]);
            $("#courtidx_4").html(tuserarr[partnerB].split('#$')[0]);
            $("#court_4").html(tuserarr[partnerB].split('#$')[1]);
          }
          else{
            $("#leftcourt").children("option").remove();
            for (var i = 0;i < 4 ;i++ ){
              if ( i ==  selectno ){
                $("#leftcourt").append("<option value='"+tuserarr[i].split('#$')[0]+"' selected>" +  tuserarr[i].split('#$')[1] + "</option>");
              }else{
                $("#leftcourt").append("<option value='"+tuserarr[i].split('#$')[0]+"'>" + tuserarr[i].split('#$')[1] + "</option>");
              }
            }

            $("#courtidx_1").html(tuserarr[selectno].split('#$')[0]);
            $("#court_1").html(tuserarr[selectno].split('#$')[1]);
            $("#courtidx_2").html(tuserarr[idx].split('#$')[0]);
            $("#court_2").html(tuserarr[idx].split('#$')[1]);
            $("#courtidx_3").html(tuserarr[partnerA].split('#$')[0]);
            $("#court_3").html(tuserarr[partnerA].split('#$')[1]);
            $("#courtidx_4").html(tuserarr[partnerB].split('#$')[0]);
            $("#court_4").html(tuserarr[partnerB].split('#$')[1]);  

            //좌우 변경 색도 변경 원래색상으로 그려준다.
            $("#court_1").attr("class", tuserarr[selectno].split('#$')[2]);
            $("#court_2").attr("class", tuserarr[idx].split('#$')[2]);
            $("#court_3").attr("class", tuserarr[partnerA].split('#$')[2]);
            $("#court_4").attr("class", tuserarr[partnerB].split('#$')[2]);
          }
        }
      }
    }
  };

  //서브 정보 변경
  score.setServe = function(imgid){

    if (  Number(score.jsondata.GAMENO) == 1 ){ //&& Number(score.jsondata.SERVE) == 0
      if (score.hasOwnProperty('fplayers') == false ){
        score.splashmsg('선수 위치를 먼저 지정해 주십시오.',1500);
        return;
      }
    }

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

    $("#" + imgid).attr('src', "images/tournerment/public/tennis_ball_on@3x.png");

    if (  Number(score.jsondata.GAMENO) == 1 ){ //&& Number(score.jsondata.SERVE) == 0
      var posno  = imgid.split('_')[1];
	  score.jsondata.SERVE = $('#courtidx_'+ posno).text();

	  if (Number(posno) == 1 || Number(posno) == 3 ){ //비교를위해 top으로 저장
		  score.jsondata.RECIVE = $('#courtidx_2').text();
	  }
	  else{
		  score.jsondata.RECIVE = $('#courtidx_1').text();	  
	  }
	  var packet = {'CMD':mx.SETSERVE,'SERVE':score.jsondata.SERVE,'SCIDX':score.jsondata.SCIDX,'GAMENO':score.jsondata.GAMENO};
	  packet.RECIVE = score.jsondata.RECIVE;
	  mx.SendPacket(null, packet); 
	}

    if (   Number(score.jsondata.GAMENO) == 2  ){//&& Number(score.jsondata.SERVE2) == 0
      var posno  = imgid.split('_')[1];
	  score.jsondata.SERVE2 = $('#courtidx_'+ posno).text();

	  if (Number(posno) == 1 || Number(posno) == 3 ){
		  score.jsondata.RECIVE2 = $('#courtidx_2').text();
	  }
	  else{
		  score.jsondata.RECIVE2 = $('#courtidx_1').text();	  
	  }
			score.tempRECIVE = score.jsondata.RECIVE2;

	  var packet = {'CMD':mx.SETSERVE,'SERVE':score.jsondata.SERVE2,'SCIDX':score.jsondata.SCIDX,'GAMENO':score.jsondata.GAMENO};
	  packet.RECIVE = score.jsondata.RECIVE2;
	  mx.SendPacket(null, packet); 
    }
  };

  score.init = function(){
	
	var req = localStorage.getItem("REQ");
    score.jsondata = JSON.parse(req);

	if(Number(score.jsondata.GN) == 1){
		localStorage.setItem('BackPage','enter-score-tourn');	
	}
	else{
		localStorage.setItem('BackPage', 'enter-score'); //뒤로가기 경우 화면 유지
	}


    if (score.jsondata.PRERESULT == 'ING' && Number(score.jsondata.GAMENO)+ (Number(score.jsondata.STARTSC)*2) == Number(score.jsondata.TIESC)*2 + 1) { //타이브레이크 상태 6: 6 > 13경기시작 
      score.TIEBREAK = true;
    }
 
      //기록관 창 호출
      if (score.jsondata.RNM == '' || score.jsondata.RNM == null) {
        $('.start-modal').modal('show');
      }
	  score.tempRECIVE = score.jsondata.RECIVE2; 




      $("#DP_play-title").html(score.jsondata.GTITLE);
      $("#DP_play-division").html(score.jsondata.S1STR);
      $("#DP_play-s2").html(score.jsondata.S2STR);
      $("#DP_play-s3").html("<span>"+score.jsondata.S3STR+"</span>");

      if( Number(score.jsondata.GN) == 0){
        $("#DP_play-round").html("예선");
        $("#DP_play-num").html(score.jsondata.JONO+ "조");
      }
      else{
        $("#DP_play-round").html("본선");
        $("#DP_play-num").html(score.jsondata.JONO+ "강 " + score.jsondata.SNO + "경기");
      }

      $("#T-courtno").val(score.jsondata.CRTNO).attr("selected", "selected");
      $("#T-courtkind").val(score.jsondata.CRTKND).attr("selected", "selected");

      var packet = {'CMD':mx.CMD_ENTERSCORE,'SCIDX':score.jsondata.SCIDX,'P1':score.jsondata.P1,'P2':score.jsondata.P2,'GN':score.jsondata.GN, 'S2KEY':score.jsondata.S2KEY, 'ETYPE':score.jsondata.ETYPE };
      packet.STARTSC = score.jsondata.STARTSC;
      packet.TIESC = score.jsondata.TIESC;
      packet.DEUCEST = score.jsondata.DEUCEST;

      mx.SendPacket('enterscore', packet);  
  };


  $(document).ready(function(){
    score.init();
    //score.getCourtList();


	 if (window.history && window.history.pushState) {
		score.backbtn();
	  }


  }); 

	score.backbtn = function(){

		if (typeof history.pushState === "function") {
			history.pushState("jibberish", null, null);
			window.onpopstate = function () {
				history.pushState('newjibberish', null, null);

				// Handle the back (or forward) buttons here
				// Will NOT handle refresh, use onbeforeunload for this.
				//if( score.jsondata.PRERESULT == "ING" ){
					//var msg = '경기입력을 중단하시겠습니까?';	
					if (confirm('경기입력을 중단하시겠습니까? 화면이동을 할 경우 모든 입력 데이터가 초가화 됩니다.')) {
						score.gameReSetProcess();
					} else {
						return;
					}	
				//}
				//else{
				//	score.splashmsg('경기가 종료 되었습니다. 경기종료 버튼을 눌러주세요. ',1500);	
				//	return;
				//}

				//$('#result_msg').html(msg);
				//$('#result_winner').html('화면이동을 할 경우 모든 입력 데이터가 초가화 됩니다.');
				//$('#stopendokbtn').prop('href', 'javascript:javascript:score.gameReSetProcess();');
				//$('.confirm_end').modal('show');
			};
		}
		else {
			var ignoreHashChange = true;
			window.onhashchange = function () {
				if (!ignoreHashChange) {
					ignoreHashChange = true;
					window.location.hash = Math.random();

					// Detect and redirect change here
					// Works in older FF and IE9
					// * it does mess with your hash symbol (anchor?) pound sign
					// delimiter on the end of the URL
					//if( score.jsondata.PRERESULT == "ING" ){
						//var msg = '경기입력을 중단하시겠습니까?';	
						if (confirm('경기입력을 중단하시겠습니까? 화면이동을 할 경우 모든 입력 데이터가 초가화 됩니다.')) {
							score.gameReSetProcess();
						} else {
							return;
						}	
					//}
					//else{
					//	score.splashmsg('경기가 종료 되었습니다. 경기종료 버튼을 눌러주세요. ',1500);	
					//	return;
					//}

					//$('#result_msg').html(msg);
					//$('#result_winner').html('화면이동을 할 경우 모든 입력 데이터가 초가화 됩니다.');
					//$('#stopendokbtn').prop('href', 'javascript:javascript:score.gameReSetProcess();');
					//$('.confirm_end').modal('show');
				}
				else {
					ignoreHashChange = false;
				}
			};
		}		
	
	};

	score.gameReSetProcess = function(){
		var obj = {'CMD':mx.CMD_ENTERSCORERESET,'SCIDX':score.jsondata.SCIDX};
		mx.SendPacket(null, obj);	
	};



  //포인트 목록 리스트
  score.toggleBox = function(btnstate){
    if (btnstate == 'show'){
      //내용을 불러와서 붙인뒤 보여준다
      var obj = {'CMD':mx.CMD_SCORELIST,'SCIDX':score.jsondata.SCIDX,'P1':score.jsondata.P1,'P2':score.jsondata.P2,'GN':score.jsondata.GN, 'S2KEY':score.jsondata.S2KEY, 'ETYPE':score.jsondata.ETYPE };
        obj.STARTSC = score.jsondata.STARTSC;
        obj.TIESC = score.jsondata.TIESC;
        obj.DEUCEST = score.jsondata.DEUCEST;

       mx.SendPacket('gamerc_area', obj);
    }
    else{
      $('.point-board').animate({"margin-right": '-=1273'});  
      $('#listpointbtn').show();
    }
  };

  //이전단계 수정하고 새로고침하자. ㅡㅡ
  score.preState = function(){
     mx.SendPacket('null', {'CMD':mx.CMD_PRE,'SCIDX':score.jsondata.SCIDX});
  };









  score.gameEnd = function(){
	
	if( Number(score.jsondata.CMODE) == 0  || score.jsondata.CMODE == undefined) {
        score.splashmsg('저장 후 종료 버튼을 눌러 주십시오. ',1500);
		return;
	}

    //코트번호, 종류
    var courtno = $("#T-courtno").val();
    var courtkind = $("#T-courtkind").val();
    score.jsondata.CRTNO = courtno;
    score.jsondata.CRTKND = courtkind;

    //판정 정보
    var leftresult = $("#leftresult").val(); 
    var rightresult = $("#rightresult").val();
    var resulttext = ["::그 외 판정결과 선택::","부전승","기권승","실격승","양선수 불참","양선수 기권패","양선수 실격패","승"];
    var winteam = null;
    var msg = null;
    var wincolor = 'orange';
	var leftteam,rightteam;	

    //문구만들기
    if( score.fplayers[0].cteam == "left"){
       leftteam = score.fplayers[0].cname + ", " +  score.fplayers[2].cname;		
       rightteam = score.fplayers[1].cname + ", " +  score.fplayers[3].cname;
	}
	else{
       rightteam = score.fplayers[0].cname + ", " +  score.fplayers[2].cname;		
       leftteam = score.fplayers[1].cname + ", " +  score.fplayers[3].cname;
	}

	if( Number(leftresult) == 0 && Number(rightresult) == 0 ){
     $('#score_box').hide();
	  
	  switch (score.jsondata.PRERESULT ){
      case "ING":
        score.splashmsg('게임이 진행 중 입니다. ',1500);
        return;
        break;
      case "LEFT":
        msg = '경기가 종료되었습니다.'; //왼쪽오늘쪽 잘못들어간듯
        wincolor = 'orange';
        winteam = leftteam;
        break;
      case "RIGHT":
        msg = '경기가 종료되었습니다.';
        wincolor = 'green';
        winteam = rightteam;
	    break;
      case "LEFT_TIE":
        msg = '타이브레이크로 경기가 종료되었습니다.';
        wincolor = 'orange';
        winteam = leftteam;
        break;
      case "RIGHT_TIE":
        msg = '타이브레이크로 경기가 종료되었습니다.';
        wincolor = 'green';
        winteam = rightteam;
        break;
      }
    }
    else{
      //그외 판정결과가 아니라면
      switch (Number(leftresult)){
      case 0:
        //오른쪽
        switch (Number(rightresult)){
        case 1:
        case 2:
        case 3:
        case 7:
          //오른쪽 선수가 이김
          msg = resulttext[Number(rightresult)];
          wincolor = 'green';
		  winteam = rightteam;
	  	  if(Number(rightresult) == 7){
			  $('#score_box').show();
			  $('#rt_left_member').text(leftteam);
			  $('#rt_right_member').text(rightteam);
		  }
		  else{
			  $('#score_box').hide();		  
		  }
			

        break;
        }
      break;

      case 1:
      case 2:
      case 3:
	  case 7:
        //왼쪽선수가 이김
        msg = resulttext[Number(leftresult)];
        wincolor = 'orange';
        winteam = leftteam;
	  	if(Number(leftresult) == 7){  	    
			$('#score_box').show();
			$('#rt_left_member').text(leftteam);
			$('#rt_right_member').text(rightteam);
		}
		else{
			$('#score_box').hide();		
		}

      break;
      case 4:
      case 5:
      case 6:
        //양선수 모두 실격
        msg = resulttext[Number(leftresult)];
        wincolor = '';
        winteam = '양팀 선수 모두';
  	    $('#score_box').hide();
      break;
      }
    }

    $('#result_msg').html(msg);
    $('#result_winner').attr('class', 'winner ' + wincolor);
    $('#result_winner').html(winteam);

	     
     //처리 화면 가져오기
   	 $('#stopendokbtn').prop('href', 'javascript:score.gameEndProcess();');
	 $('.confirm_end').modal('show');
  };

  score.gameEndProcess = function(){ //경기종료 처리

    //코트번호, 종류
    var courtno = $("#T-courtno").val();
    var courtkind = $("#T-courtkind").val();
    score.jsondata.CRTNO = courtno;
    score.jsondata.CRTKND = courtkind;

    //판정 정보
    var leftresult = $("#leftresult").val(); 
    var rightresult = $("#rightresult").val();
    var resulttext = ["::그 외 판정결과 선택::","부전승","기권승","실격승","양선수 불참","양선수 기권패","양선수 실격패","승"];
    var winner = 'left';
	var leftscore = 0;
	var rightscore = 0;

    if( Number(leftresult) == 0 && Number(rightresult) == 0 ){
      $('#score_box').hide();

      switch (score.jsondata.PRERESULT ){
      case "LEFT":
      case "LEFT_TIE":
        winner ="left";
		break;
      case "RIGHT":
      case "RIGHT_TIE":
        winner ="right";
      break;
      }
    }
    else{
      //그외 판정결과가 아니라면
      switch (Number(leftresult)){
      case 0:
        //오른쪽
        switch (Number(rightresult)){
        case 1:
        case 2:
        case 3:
        case 7:
          //오른쪽 선수가 이김
          winner ="right";
		  leftscore = $("#rt_left_score").val();
		  rightscore = $("#rt_right_score").val();
        break;
        }
      break;
      case 1:
      case 2:
      case 3:
      case 7:
        //왼쪽선수가 이김
        winner ="left";
	    leftscore = $("#rt_left_score").val();
	    rightscore = $("#rt_right_score").val();
      break;
      case 4:
      case 5:
      case 6:
        //양선수 모두 실격
        winner ="tie";
      break;
      }
    }
    var obj = {'CMD':mx.CMD_ENTERSCOREEND,'SCIDX':score.jsondata.SCIDX,'LT':leftresult,'RT':rightresult,'CTNO':courtno,'CTKD':courtkind,'WINNER':winner};
	obj.LEFTSCORE = leftscore;
	obj.RIGHTSCORE = rightscore;
    obj.GIDX = score.jsondata.GIDX; //대회인덱스 
	obj.P1 = score.jsondata.P1;
    obj.P2 = score.jsondata.P2;
    obj.S2KEY = score.jsondata.S2KEY; //단복식 구분정보
    obj.S3KEY = score.jsondata.S3KEY; 
    obj.S3STR = score.jsondata.S3STR; 
    obj.JONO =  score.jsondata.JONO;  //예선조번호
    obj.GN = score.jsondata.GN; //예선 본선 구분

    if(Number(obj.GN) == 1){
		obj.GRND = score.jsondata.GRND;
		obj.RD = score.jsondata.RD;
	}
	
	
	mx.SendPacket(null, obj);
  };







//코트 목록 불러오기 (지정상태 포함)
score.getCourtList = function(){
//  var obj = {};
//  obj.CMD = mx.CMD_COURTLIST;
//  obj.SCIDX = score.jsondata.SCIDX;     //resultIDX , courtno
//  obj.GIDX = score.jsondata.GIDX;       //대회인덱스
//  obj.KEY3 = score.jsondata.S3KEY;      //최종레벨키
//  obj.COURTNO = score.jsondata.CRTNO; //선택된 코트번호
//  mx.SendPacket("game_courtno", obj);
};
//코트 번호 지정하고 목록 다시 호출
score.setCourtNo = function(chk){
//  var obj = {};
//  obj.CMD = mx.CMD_COURTNO;
//  obj.SCIDX = score.jsondata.SCIDX; //resultIDX , courtno
//  obj.GIDX = score.jsondata.GIDX;   //대회인덱스
//  obj.KEY3 = score.jsondata.S3KEY;  //최종레벨키
//  obj.COURTNO = $("#T-courtno").val();
//  obj.COURTTXT = $("#T-courtno option:selected").text();
//
//	if (chk == undefined){ //확인창 결정
//		obj.CHK = 0;
//	}
//	else{
//		obj.CHK = chk;	
//	}
//
//  mx.SendPacket("game_courtno", obj);
};


  score.gameStop = function(){
    var msg = '[경기 종료] 경기를 중단 하시겠습니까?';
	if( score.jsondata.PRERESULT == "ING" ){
        var msg = '경기를 중단 하시겠습니까?';
	}

    $('#result_msg').html(msg);
	$('#result_winner').html('지금까지의 기록은 저장됩니다.');
	$('#stopendokbtn').prop('href', 'javascript:javascript:score.gameStopProcess();');
     $('.confirm_end').modal('show');
  };



  score.gameStopProcess = function(){ //경기중단 처리
    var obj = {'CMD':mx.CMD_ENTERSCORESTOP,'SCIDX':score.jsondata.SCIDX};
    mx.SendPacket(null, obj);
  };


//-->
</script>
    

</head>
<body id="AppBody"  oncontextmenu="return false" ondragstart="return false" onselectstart="return false">

<!-- #include virtual = "/pub/html/tennis/html.top.asp" -->

<!-- S: main -->
<div class="main container-fluid">
  <!-- #include file = "./body/enterscore.body.asp" -->
</div>
 <!-- E: main -->

<!-- S: court_conf -->
<div class="modal fade court_conf">
  <!-- S: modal-dialog -->
  <div class="modal-dialog modal-sm">
    <!-- S: modal-content -->
    <div class="modal-content">
      <div class="modal-body">
        <p>해당 코트는 이미 사용 중입니다.</p>
        <!-- S: btn-list -->
        <div class="btn-list">
          <a href="javascript:$('.court_conf').modal('hide')" class="btn cancel" data-dismiss="modal">취소</a>
          <a href="javascript:score.setCourtNo(1);$('.court_conf').modal('hide');" class="btn confirm">확인</a>
        </div>
        <!-- E: btn-list -->
      </div>
    </div>
    <!-- E: modal-content -->
  </div>
  <!-- E: modal-dialog -->
</div>
<!-- E: court_conf -->

<!-- #include file = "./body/pop.recorder.asp" -->
<!-- #include file = "./body/pop.game_point.asp" -->

<!-- #include virtual = "/pub/html/tennis/html.footer.asp" -->  


    <script>
      //$('.court_conf').modal('show');
    </script>
</body>
</html>

