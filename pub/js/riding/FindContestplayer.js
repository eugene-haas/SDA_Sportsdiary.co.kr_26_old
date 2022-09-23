var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;

  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
  mx.CMD_GAMEINPUT = 30001;
  mx.CMD_GAMEINPUTEDIT = 30002; //수정
  mx.CMD_GAMEINPUTEDITOK = 30003;
  mx.CMD_GAMEINPUTDEL = 30004;// 삭제

  mx.CMD_FIND1 = 30005;
  mx.CMD_FIND2 = 30006;

  mx.CMD_SETGAMENO = 50001; //게임번호변경
  mx.CMD_SETGAMENOSTR = 50002; //게임번호 출력용
  mx.CMD_LIMIT = 41000; //참가신청제한
  mx.CMD_LIMITOK = 41001;

  mx.CMD_PHS = 900;
  mx.CMD_HPS = 901;
  mx.CMD_GETLIMIT = 902;//참가자격제한 설정 가져오기
  mx.CMD_SETLIMIT = 903;//참가자격제한 설정, 취소

////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestFind.asp";
mx.ajaxtype = "POST";
mx.dataType = "text";

mx.SendPacket = function( sender, packet){
    console.log( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	$.ajax({url:mx.ajaxurl,type:mx.ajaxtype,data:strdata,dataType:mx.dataType,
	success: function(returnData){
		mx.ReceivePacket( packet.CMD, returnData, sender )
		}
	});
};

mx.SendPacketEx = function(sender, packet, reqUrl){
    var strData = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );

    console.log( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
    $.ajax({
        url : reqUrl, 
        type : mx.ajaxType,
        data : strData, 
        dataType : mx.ajaxDataType, 
        success: function(rcvData) {
			mx.ReceivePacket(packet.CMD, rcvData, sender);
        }             
    });
};

mx.ReceivePacket = function( reqcmd, data, sender ){// data는 response string

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
    switch (Number(jsondata.result))  {
    case 0: break;
    case 1: alert('데이터가 존재하지 않습니다.');return;  break;
    case 2: alert('편성조건에 만족하지 않습니다.');return;  break;
    case 3: alert('본선이 대진표가 완료된 경우 순위 변동을 할 수 없습니다..');return;  break;
    case 4: alert('본선이 대진표가 완료된 경우 추첨번호를 변경 할 수 없습니다.');return;    break; //메시지 없슴
    case 100: return;   break; //메시지 없슴
    case 101: mx.ChkIngGame(jsondata);   break; //메시지 없슴
    case 5: alert('본선이 대진표가 완료된 경우 추첨번호를 변경 할 수 없습니다.');    break;
    case 6: alert('중복된 데이터가 있습니다.'); return;   break;
    case 7: alert('수정시 세부종목이 변경될 수 없습니다.'); return;   break;
    case 8: alert('통합된 부서가 있습니다. 부별조정에서 해제 후 작업해 주십시오.'); return;   break;

	case 500: alert('편성인원이 입력된 조수보다 많습니다.'); return;   break;

	case 999: console.log(jsondata.SqlQuery);    break; //메시지 없슴
    case 10: alert('한글영문숫자로만기입해 주십시오.'); return;   break;
	case 4001: alert('리그 1조로 편성되었습니다..'); return;   break;
    case 4002: alert('숫자로만 폰번호를 입력해 주십시오.'); return;   break;
    case 4003: alert('이미 등록된 선수 입니다.'); return;   break;
    case 4004: alert('사용가능한 선수명 + 전화번호 입니다.'); return;   break;
    case 5000: alert('사용중인 코트입니다.');

	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}

	return;   break;
    case 5001: alert('예선에 편성완료된 조가 존재합니다.'); return;   break;
    case 9090: alert('본선시드배정이 생성되지 않았습니다.'); return;   break;
    case 9091: alert('편성된 선수중 존재하지않는 선수가 있습니다.'); return;   break;
    case 9092: alert('현재 자리에 생성정보가 있습니다. 새로고침하십시오.'); return;   break;
    case 9093: alert('이미 변경된 정보가 있습니다. 새로고침 후 이용해주세요.'); return;   break;
    case 1234: alert('입력중인 경기일수 있으니 테블릿에서 확인해주십시오. 결과처리도 테블릿에서 하여 주십시오.');    break; //경기종료 테블릿 입력 값이 존재하는경우
    }
  }

  switch (Number(reqcmd)) {

  case mx.CMD_INITRULL:
  case mx.CMD_SETCOURT:this.OnReLoad( reqcmd, jsondata, htmldata, sender );   break;

  }
};



//참가신청제한 #####################
	mx.OnChoiceCheck =  function(cmd, packet, html, sender){
		for (var i = 0; i < packet.idxlist.length ;i++ )
		{
			$("#chk_"+packet.idxlist[i]).css( "background-color", "#BFBFBF" );
		}
	};

	mx.OnLimit =  function(cmd, packet, html, sender){
		document.getElementById(sender).innerHTML = html;
		$('#'+sender).modal('show');
		//CKEDITOR.replace( 'editor1' );
	};

	mx.OnLimitOK =  function(cmd, packet, html, sender){
		alert("저장이 완료 되었습니다.");
	};


	mx.setLimitShow =  function(tidx,gametitle,ptype, gtype ,gbidx){
		var obj = {};
		obj.CMD = mx.CMD_LIMIT;
		obj.TIDX = tidx;
		obj.TITLE = gametitle;
		obj.PTYPE = ptype; //선수 말 1,2
		obj.GTYPE = gtype; //개인 단체 1,2
		obj.GBIDX = gbidx;
		mx.SendPacket('myModal', obj);
	};


	mx.setLimit =  function(tidx,gametitle,ptype, gtype){
		mx.targetLevel= "";
		var obj = {};
		obj.CMD = mx.CMD_LIMIT;
		obj.TIDX = tidx;
		obj.TITLE = gametitle;
		obj.PTYPE = ptype; //선수 말 1,2
		obj.GTYPE = gtype; //개인 단체 1,2
		mx.SendPacket('myModal', obj);
	};

	mx.setP_Hs = function(tidx,gbidx,gtype){ //gtype 개인 ,단체 (보내고끝 리턴 안받음)
		var obj = {};
		obj.CMD = mx.CMD_PHS;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.GTYPE = gtype; //개인 단체 1,2
		obj.VALUE = $('#phno_'+gbidx).val();

		mx.SendPacket('myModal', obj);	
	};
	mx.setH_Ps = function(tidx,gbidx,gtype){ //gtype 개인 ,단체
		var obj = {};
		obj.CMD = mx.CMD_HPS;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.GTYPE = gtype; //개인 단체 1,2
		obj.VALUE = $('#hpno_'+gbidx).val();
		mx.SendPacket('myModal', obj);		
	};



	//새로고침 할거 ...
	mx.targetLevel = "";
	mx.input_setcheck = function(tidx, gbidx,ptype,gtype){
		$( "#attchklist tr").css( "background-color", "#F5F5F5" ); 

		$( "#lvllist tr").css( "background-color", "#F5F5F5" ); 
		$( "#lvllist_" + tidx + "_"+ gbidx ).css( "background-color", "#BFBFBF" ); 
		mx.targetLevel = tidx + "_"+ gbidx;
		
		var obj = {};
		obj.CMD = mx.CMD_GETLIMIT;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.PTYPE = ptype; 
		obj.GTYPE = gtype; //개인 단체 1,2
		mx.SendPacket('myModal', obj);
	};

	mx.input_chk = function(seq,ptype,gtype){
		var chk = "N";
		if(mx.targetLevel == ""){
			alert('제한할 경기를 먼저선택해 주십시오.');
			return;
		}
		console.log(	$( "#chk_" + seq ).css( "background-color" ) ); 

		if ( $( "#chk_" + seq ).css( "background-color" ) == "rgb(245, 245, 245)" )
		{
			$( "#chk_" + seq ).css( "background-color", "#BFBFBF" );
			chk = 'Y';
		}
		else{
			$( "#chk_" + seq ).css( "background-color", "#F5F5F5" );
			chk = 'N';
		}


		var obj = {};
		obj.CMD = mx.CMD_SETLIMIT;
		obj.TARGETLEVEL = mx.targetLevel;
		obj.PTYPE = ptype; 
		obj.GTYPE = gtype; //개인 단체 1,2
		obj.IDX = seq;
		obj.CHK = chk;

		mx.SendPacket('myModal', obj);

	};


//참가신청제한 #####################




//요청##################################################################

	
	
	mx.SelectLevelGb = function(ingno) {
		var obj = {};
		obj.PARR = new Array();
		obj.CMD = mx.CMD_FIND1;
		obj.TitleIDX =mx.gameinfo.IDX;;
		obj.TITLE = mx.gameinfo.TITLE;
		var typechkbox = false;
		for (var i = 0 ; i <= ingno ;i++ ){
			obj.PARR[i] = $("#mk_g"+ i ).val();
		}


		var msgarr = ["","개인/단체를 선택해 ", "경기종목을 선택해 ","마종을 선택해 ","Class 를 선택해 ","Class 안내를 선택해 "]; //메시지
		var passarrno = [0,1,1,1,1,1]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		mx.SendPacket('level_form', obj);
	};


	mx.input_frm = function(){

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUT;
		obj.TIDX =mx.gameinfo.IDX;
		obj.TITLE = mx.gameinfo.TITLE;

		obj.PARR = new Array();

		var allidarr = ['mk_g0','mk_g1','mk_g2','mk_g3','mk_g4','mk_g5','mk_g6','mk_g7','mk_g8','mk_g9','mk_g10','mk_g11','mk_g12','mk_g13','mk_g14','mk_g15','mk_g16','mk_g17','mk_g18','mk_g19','mk_g20','mk_g21','mk_g22','mk_g23'];
		var chkboxidarr = ['mk_g12','mk_g14','mk_g16','mk_g18','mk_g20','mk_g22']; //체크박스의 아이디들
		var typechkbox = false;
		
		for (var i = 0;i< allidarr.length ;i++ ){
			typechkbox = false;
			for (var n = 0;n< chkboxidarr.length ;n++ ){
				if (allidarr[i] ==chkboxidarr[n]){ //체크박스라면
					typechkbox = true;
				}
			}

			if (typechkbox == true){
				if (  $("#"+allidarr[i]).is(":checked")  ){
					obj.PARR[i] = $("#"+allidarr[i]).val();
				}
				else{
					obj.PARR[i] = '';				
				}
			}
			else{
				obj.PARR[i] = $("#"+allidarr[i]).val();
			}

		}

		var msgarr = ["","개인/단체를 선택해 ", "경기종목을 선택해 ","마종을 선택해 ","Class 를 선택해 ","Class 안내를 선택해 ",  "","대회일자를 선택해 ", "대회시간을 선택해 ","신청시작일을 선택해 ","신청시작사간을 ","신청종료일을 선택해",  "신청종료시간을 선택해 ", "", "", "", "", "", ""]; //메시지
		var passarrno = [0,1,1,1,1,1,    1,1 ,1,1,1,1,    0,0, 0,0, 0,0, 0,0, 0,0, 0,0 ]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		//12 ~ 23까지중 체크가 모두 선택되지 않았을때 하나라도 입력하라고 표시
		mx.SendPacket('contest', obj);
	};

	mx.input_edit = function(idx,gameno){
		$( "#contest tr").css( "background-color", "white" ); 
		$( ".gametitle_" + gameno ).css( "background-color", "#BFBFBF" ); 

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDIT;
		obj.IDX = idx;
		obj.TitleIDX = mx.gameinfo.IDX;
		obj.Title = mx.gameinfo.TITLE;
		mx.SendPacket('gameinput_area', obj);
	};


	mx.update_frm = function(){

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDITOK;
		obj.TIDX =mx.gameinfo.IDX;
		obj.TITLE = mx.gameinfo.TITLE;

		obj.PARR = new Array();

		var allidarr = ['e_idx','mk_g0','mk_g1','mk_g2','mk_g3','mk_g4','mk_g5','mk_g6','mk_g7','mk_g8','mk_g9','mk_g10','mk_g11','mk_g12','mk_g13','mk_g14','mk_g15','mk_g16','mk_g17','mk_g18','mk_g19','mk_g20','mk_g21','mk_g22','mk_g23'];
		var chkboxidarr = ['mk_g12','mk_g14','mk_g16','mk_g18','mk_g20','mk_g22']; //체크박스의 아이디들
		var typechkbox = false;
		
		for (var i = 0;i< allidarr.length ;i++ ){
			typechkbox = false;
			for (var n = 0;n< chkboxidarr.length ;n++ ){
				if (allidarr[i] ==chkboxidarr[n]){ //체크박스라면
					typechkbox = true;
				}
			}

			if (typechkbox == true){
				if (  $("#"+allidarr[i]).is(":checked")  ){
					obj.PARR[i] = $("#"+allidarr[i]).val();
				}
				else{
					obj.PARR[i] = '';				
				}
			}
			else{
				obj.PARR[i] = $("#"+allidarr[i]).val();
			}

		}

		var msgarr = ["대상을 선택해 ", "","개인/단체를 선택해 ", "경기종목을 선택해 ","마종을 선택해 ","Class 를 선택해 ","Class 안내를 선택해 ",  "","대회일자를 선택해 ", "대회시간을 선택해 ","신청시작일을 선택해 ","신청시작사간을 ","신청종료일을 선택해",  "신청종료시간을 선택해 ", "", "", "", "", "", ""]; //메시지
		var passarrno = [1, 0,1,1,1,1,1,    1,1 ,1,1,1,1,    0,0, 0,0, 0,0, 0,0, 0,0, 0,0 ]; //체크메시지 통과여부 플레그 0패스 1체크

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					return;
				}
			}
		}
		//12 ~ 23까지중 체크가 모두 선택되지 않았을때 하나라도 입력하라고 표시
		mx.SendPacket('contest', obj);		
	};


	mx.del_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDEL;
		obj.IDX =  $("#e_idx").val();
		obj.GNO = $("#e_gno").val();

		if (obj.IDX == undefined){
			alert("대상을 선택해 주세요.");
			return;
		}

		if (confirm('대상을 삭제하시겠습니까?')) {
			mx.SendPacket('titlelist_'+obj.IDX, obj);
		} else {
			return;
		}	
	};


	mx.setGameNo = function(idx, cngval){
		//alert(orgval +"--"+ cngval);
		var obj = {};
		obj.CMD = mx.CMD_SETGAMENO;
		obj.IDX = idx;
		obj.TIDX =mx.gameinfo.IDX;;
		obj.GHANGEGNO = cngval;
		mx.SendPacket('contest', obj);
	};

	mx.setGameNoStr = function(idx, cngval){
		$( "#gamenostr_"+idx).css( "border-color", "blue" ); 
		//alert(orgval +"--"+ cngval);
		var obj = {};
		obj.CMD = mx.CMD_SETGAMENOSTR;
		obj.IDX = idx;
		obj.TIDX =mx.gameinfo.IDX;;
		obj.GHANGEGNO = cngval;
		mx.SendPacket('contest', obj);
	};




//응답##################################################################

mx.OndrowHTML2 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	//$("#drowbody").scrollTop(window.oriScroll);
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if( cmd == mx.CMD_GAMEINPUTEDIT ){
		mx.init();
	}
};

mx.OndelHTML =  function(cmd, packet, html, sender){
  var trgbstr = $( "#e_gno").val(); //gameno
  $( ".gametitle_" + trgbstr ).remove();
  if( cmd == mx.CMD_GAMEINPUTDEL){
    document.getElementById('gameinput_area').innerHTML = html;
    mx.init();
  }
};
































mx.OndrowHTML3 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
	if (cmd != mx.CMD_INITLAKET){
		$("#courtarea").scrollTop($("#courtarea")[0].scrollHeight);
	}
};



mx.OnChangeReload =  function(cmd, packet, html, sender){
	$("#reloadbtn").click();
	alert("적용 되었습니다."); //선수 교체 또는 신규팀등록
	$('#Modaltest').modal('hide');
};

mx.OnLastRoad =  function(cmd, packet, html, sender){
	$('#loadmsg').text('&nbsp;새로 고침 중.....');

	if (Number(packet.mclose) == 1){
	  $('#myModal').modal('hide');
	}

	mx.setLastRound(packet.IDX,packet.TeamNM,packet.AreaNM,packet.LevelNo);
};

////////////////////////////////////////////////////////////////
//결승라운드
////////////////////////////////////////////////////////////////
mx.setLastRound = function(idx,teamnm,areanm,levelno,rdtype){
  var obj = {};
  obj.CMD = mx.CMD_TOURNLASTROUND;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;
  if (rdtype == '' || rdtype == undefined) {
	  rdtype = 0;
  }
  obj.rdtype = rdtype;

  mx.SendPacket(null, obj);
  //mx.SendPacket('Modaltest', obj); //작은창
};

mx.OnlastRDProcess =  function(cmd, packet, html, sender){
  mx.players = packet;

  if (Number(packet.rdtype) > 0 ){
	  document.getElementById('myModal').innerHTML = html;
	  $('#myModal').modal('show');
  }
  else{
	  document.getElementById('ModallastRound').innerHTML = html;
	  $('#ModallastRound').modal('show');
  }
};

mx.lastMemberIn = function(idx,teamnm,areanm,levelno,midx){ //최종라운드 관련
  var obj = {};
  obj.CMD = mx.CMD_LASTIN;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;
  obj.midx = midx;
  mx.SendPacket(null, obj);
};

mx.lastMemberOut = function(idx,teamnm,areanm,levelno,midx){
  var obj = {};
  obj.CMD = mx.CMD_LASTOUT;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;
  obj.midx = midx;
  mx.SendPacket(null, obj);
};


mx.lastMemberIn2 = function(idx,teamnm,areanm,levelno,midx){
  var obj = {};
  obj.CMD = mx.CMD_LASTIN2;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;
  obj.midx = midx;
  mx.SendPacket(null, obj);
};

mx.lastMemberOut2 = function(idx,teamnm,areanm,levelno,midx){
  var obj = {};
  obj.CMD = mx.CMD_LASTOUT2;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.LevelNo = levelno;
  obj.midx = midx;
  mx.SendPacket(null, obj);
};



////////////////////////////////////////////////////////////////

mx.OnModalUpdateMember =  function(cmd, packet, html, sender){
  window.oriScroll = $("#drowbody").scrollTop();
  document.getElementById(sender).innerHTML = html;
  mx.gameinfo.LEVELNO = packet.S3KEY;
  localStorage.setItem('GAMEINFO', JSON.stringify( mx.gameinfo  ));

  //mx.initPlayer();
  $('#'+sender).modal('show');
};

mx.OnDrawingJoo = function(cmd, packet, htmldata, sender) {
  $("#JoonoBox_" + packet.JONO).html(htmldata);
  if(packet.ORIGINCMD == mx.CMD_SETCOURT_Try)
  {
    packet.CMD = mx.CMD_REFRESHGAMECOURT;

    mx.SendPacket(null, packet);
  }
};

mx.OnDrawingCourt=  function(cmd, packet, htmldata, sender) {

  $("#divGameCourt").html(htmldata);

};


mx.delayHTML = function(packet){
	alert("천천히");
}

mx.delayHTML2 = function(packet){
	//alert("점유하고 있는 번호인지 확인해주세요");
}

mx.setTourn  = function(packet){
  packet.CMD = mx.CMD_SETTOURN;
  mx.SendPacket(null, packet);
};

mx.makeBujun = function(packet){
  packet.CMD = mx.CMD_MAKETEMPPLAYER;
  mx.SendPacket('myModal', packet);
};


mx.ChkIngGame = function(packet){
  if (confirm("생성된 게임이 존재합니다. 삭제 후 다시 편성하시겠습니까?")) {
    mx.SendPacket("myModal", packet);
  } else {
    return;
  }
1};

mx.OnReLoadLeague = function(cmd, packet, html, sender){
  packet.CMD = mx.CMD_LEAGUE;
  mx.SendPacket('myModal', packet);
};


mx.OnReLoad =  function(cmd, packet, html, sender){
  //패킷 재정이 해서 다시 화면 호출
  var obj = {};

 if(cmd == mx.CMD_GAMEADDITIONFLAG || cmd == mx.CMD_CHANGESELECTAREA|| cmd == mx.CMD_FILLINGEMPTYENTRY || cmd == mx.CMD_RNDNOEDIT || cmd ==mx.CMD_SETLEAGUERANKING
 || cmd ==mx.CMD_SETCOURT_Try || cmd == mx.CMD_INPUTREGION || cmd == mx.CMD_JOODIVISION || cmd ==mx.CMD_JOOAREA)
  {
    obj.CMD = mx.CMD_LEAGUE;
  }
  else if ( (cmd >= mx.CMD_MAKETEMPPLAYER && cmd <= mx.CMD_SETTOURN)  ||  cmd == mx.CMD_SETTOURNJOO || cmd == mx.CMD_SETTOURNWINNER  || cmd == mx.CMD_GAMECANCEL || cmd ==  mx.CMD_INITRULL){
    obj.CMD = mx.CMD_TOURN;
	if (cmd == mx.CMD_SETTOURNJOO){
		obj.ONEMORE = packet.ONEMORE;
	}
	else{
		obj.ONEMORE = "notok";
	}
  }
  else{
    obj.CMD = cmd;
  }

if(packet.hasOwnProperty("roundSel")){
	  obj.roundSel = packet.roundSel;
}

if(packet.hasOwnProperty("IDX")){
	  obj.IDX = packet.IDX;
}

//if(packet.hasOwnProperty("RESET")){
	  obj.RESET = "notok";
//}

  obj.TitleIDX = packet.TitleIDX;
  obj.Title = packet.Title;
  obj.TeamNM = packet.TeamNM;
  obj.AreaNM = packet.AreaNM;
  obj.JONO = packet.JONO;
  obj.StateNo = packet.StateNo;
  mx.SendPacket('myModal',obj);
};

mx.OntableHTML =  function(cmd, packet, html, sender){
  mx.players = packet;

//	if ( cmd == mx.CMD_TOURN){
//	  $("#realTimeContents").scrollTop(window.toriScroll);
//	}

	if( cmd == mx.CMD_LEAGUE){
		  document.getElementById(sender).innerHTML = html;
		  $("#drowbody").scrollTop(window.oriScroll);
		  $('#'+sender).modal('show');
	}
	else if (cmd == mx.CMD_LEAGUEPRE){
		  document.getElementById(sender).innerHTML = html;
		  $('#'+sender).modal('show');
		  $('#opencourt').click();
	}
	else{
		  if (packet != null){
			  if (packet.hasOwnProperty('ONEMORE') == true){
					if (packet.ONEMORE =="ok"){
					  document.getElementById(sender).innerHTML = html;
					  $('#'+sender).modal('show');
					  packet.ONEMORE = "notok";
					  setTimeout(mx.SendPacket('myModal',packet), 3000);
					}else{
					  document.getElementById(sender).innerHTML = html;
					  $('#'+sender).modal('show');
					}
			  }
		  }
		  else{
			  document.getElementById(sender).innerHTML = html;
		  }
		  if( packet == null && cmd == mx.CMD_TOURN){ //본선진행
			  $("#t2_drowbody").scrollTop(window.t2oriScroll);
		  }
		  else{
			  $("#realTimeContents").scrollTop(window.toriScroll);
		  }
	}
};

mx.OnLevelModal =  function(cmd, packet, html, sender){

  document.getElementById(sender).innerHTML = html;

  $('#'+sender).modal('show');
};







mx.SetJoo = function(packet){
  packet.CMD = mx.CMD_SETJOO;
	packet.DELOK = 0;
  mx.SendPacket("myModal", packet);
};


mx.SetCourt_try = function(packet, COURTID){
    if ($("#court_"+COURTID).val()=="999") {
        alert("해당 코트는 사용 중입니다.");
    }
    packet.CMD = mx.CMD_SETCOURT_Try;
    packet.GN = 0; //예선
    packet.tryoutgroupno = COURTID; //예선 조
    packet.setCourtNo = $("#court_"+ COURTID).val(); //코트 번호
    mx.SendPacket("myModal", packet);
 };

mx.SetJooRule = function(idx,titleIdx,chkControl)
{
  var obj = {};

  obj.CMD = mx.CMD_SETJOORULE;
  obj.IDX = idx;
  obj.GAMETITLEIDX = titleIdx;

  if ( chkControl.checked == true ) {
    obj.CHKRULL = 1
  }
  else {
    obj.CHKRULL = 0
  }
  //console.log(obj)
  mx.SendPacket(null, obj);
};

mx.input_levelModal = function(IDX) {
  var obj = {};
  obj.CMD = mx.CMD_INPUTLEVEL;
  obj.IDX = IDX;

  mx.SendPacket("myModal", obj);
};



mx.ReloadLevel = function(cmd, packet, html, sender){
  //var obj = {};
	//obj.IDX = packet.GAMETITLEIDX;
	//obj.GAMETITLEIDX = packet.gametitle;
	//localStorage.setItem('GAMEINFO', JSON.stringify( obj  ));
	location.href="./contestlevel.asp?idx="+packet.GAMETITLEIDX ;
};

mx.inputRegion = function(packet){

  var joRegion = "";

  for (var i = 1; i <= packet.EndGroup ;i++)
  {
    var placeText = $('#place_'+i).val();

    if(i == packet.EndGroup)
      joRegion  = joRegion + i +"^"+ placeText;
    else
      joRegion  = joRegion + i +"^"+ placeText + "%";
  }

  if(joRegion.length > 0)
  {
    packet.CMD = mx.CMD_INPUTREGION;
    packet.JOREGION = joRegion

    mx.SendPacket(null, packet);
  }
};

mx.setJooDivision = function(packet) {
  var jooDivisionValue = $("#JooDivision").val();

  if( jooDivisionValue > packet.EndGroup ) {
    alert("현재 그룹개수보다 클 수 없습니다.");
  } else {
    packet.CMD = mx.CMD_JOODIVISION;
    packet.JooDivision = jooDivisionValue;
    mx.SendPacket(null, packet);
  }
};

mx.setJooArea = function(packet) {
  var jooAreaValue = $("#selJooArea").val();
  packet.CMD = mx.CMD_JOOAREA;
  packet.JooAreaValue = jooAreaValue;
  //alert(jooAreaValue);
  //console.log(packet);
  mx.SendPacket(null, packet);
};

mx.SetCourt = function(packet){
  var courtno = $('#'+packet.POS).val();
  if (confirm(courtno + "로 코트를 지정하시겠습니까?")) {
    packet.CMD = mx.CMD_SETCOURT;
    packet.GN = 0; //예선
    packet.COURTNO = courtno;
    mx.SendPacket("myModal", packet);
  } else {
    return;
  }
};

mx.SetGameRanking = function(packet){

  var rankno = $('#'+packet.POS).val();
  //if (confirm(rankno + "로 순위를 지정하시겠습니까?")) {
  packet.CMD = mx.CMD_SETRANKING;
  packet.GN = 0; //예선
  packet.RANKNO = rankno;
  //console.log(packet)
  mx.SendPacket("myModal", packet);
  /*
    } else {
    return;
  }
  */
};


mx.SetGameLeagueRanking = function(packet){

  var rankno = $('#'+packet.POS).val();
  //if (confirm(rankno + "로 순위를 지정하시겠습니까?")) {
  packet.CMD = mx.CMD_SETLEAGUERANKING;
  packet.GN = 0; //예선
  packet.RANKNO = rankno;

  mx.SendPacket("myModal", packet);
  /*
    } else {
    return;
  }
  */
};

mx.SetTournGameResult = function(packet){
    packet.CMD = mx.CMD_SETTOURNWINNER;
    packet.GN = 1; //본선
    window.toriScroll = $("#realTimeContents").scrollTop();
	console.log(window.toriScroll);
	mx.SendPacket("myModal", packet);
};


//승처리 취소
mx.SetTournGameCanCel = function(packet){
    packet.CMD = mx.CMD_GAMECANCEL;
    packet.GN = 1; //본선
    window.toriScroll = $("#realTimeContents").scrollTop();
	mx.SendPacket("myModal", packet);
};



mx.SetGameResult = function(packet){
  var msg = null;
  var resultno = $('#'+packet.POS).val();

  if(resultno == 0)
    return ;
  /*
  switch (Number(resultno)) {
    case 0:  alert('경기 결과를 선택해 주세요.'); return;  break; //판정결과 대기
    case 100: msg = "팀을 승자로 결정하시겠습니까?";   break; //승리
    case 1: msg = "팀을 부전승으로  결정하시겠습니까?";    break; //부전승
    case 2: msg = "팀을 기권승으로 결정하시겠습니까?";   break; //기권승
    case 3: msg = "팀을 실격승으로 결정하시겠습니까?";   break; //실격승
    case 4: msg = "팀 과 상대팀을 불참 처리 하시겠습니까?";   break; //양선수 불참
    case 5: msg = "팀 과 상대팀을 기권패 처리 하시겠습니까?";    break; //양선수 기권패
    case 6: msg = "팀 과 상대팀을 실격패 처리 하시겠습니까?";    break; //양선수 실격패
    case 1000: alert("1라운드만 편성이 가능합니다."); return;   break;
    case 1001: alert("변경 중 중복 번호가 발생하여 초기화 되었습니다."); return;   break;
    case 1002: alert("상위라운드 진출자가 있어 재편성 할 수 없습니다."); return;   break;
  }


  if (packet.WINIDX == packet.P1){
    msg = packet.P1NM + msg;
  }
  else{
    msg = packet.P2NM + msg;
  }
  */
  /*
  if (confirm(msg)) {
    */
    packet.CMD = mx.CMD_SETWINNER;
    packet.GN = 0; //예선
    packet.RTNO = resultno; //결과 번호
    mx.SendPacket("myModal", packet);
  /*
  } else {
    return;
  }
  */
};

mx.leagueJoo = function(packet){
  packet.CMD = mx.CMD_LEAGUEJOO;
  mx.SendPacket('myModal',packet);
};

mx.league_ing = function(packet){
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisLeague_ing.asp";
  packet.CMD = mx.CMD_LEAGUEJOO;
  mx.SendPacket('myModal',packet);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};

mx.league_court = function(tdid,packet){
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisLeague_ing.asp";
  packet.CMD = mx.CMD_LEAGUECOURT;
  packet.COURTNO = $("#gcourt_"+tdid).val();
  window.oriScroll = $("#drowbody").scrollTop();
  mx.SendPacket(tdid,packet);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};

mx.league_win = function(winidx,packet){
	if (!confirm( "처리 하시겠습니까?")) {
		return;
	}
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisLeague_ing.asp";
  packet.CMD = mx.CMD_LEAGUEWIN;
  packet.WINIDX = winidx;
  window.oriScroll = $("#drowbody").scrollTop();
  mx.SendPacket(null,packet);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};

///////////////////////////////////////////////////
mx.league = function(idx,teamnm,areanm,stateno){
  var obj = {};
  obj.CMD = mx.CMD_LEAGUE;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.StateNo = stateno;
  mx.SendPacket('myModal', obj);
};

mx.leaguepre = function(idx,teamnm,areanm,stateno){
  var obj = {};
  obj.CMD = mx.CMD_LEAGUEPRE;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.StateNo = stateno;
  mx.SendPacket('myModal', obj);
};


mx.tournament_ing = function(idx,teamnm,areanm,resetflag){
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisTourn_ing.asp";
  var obj = {};
  obj.CMD = mx.CMD_TOURN;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.ONEMORE = "notok";

   if (resetflag == "roundsel") {
    obj.roundSel = $("#roundsel").val();
  }else {
     obj.roundSel = "";
 }

  if (resetflag == "reset"){
	obj.RESET = "ok";
  }
  else{
	obj.RESET = "notok";
  }


  if (Number($('#court_areaname option:selected').val()) == 0 || $('#court_areaname option:selected').val() == undefined){ // 전체
	obj.COURTAREA = 0;
  }
  else{
	obj.COURTAREA = $('#court_areaname option:selected').val();
  }

  mx.SendPacket('myModal', obj);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};

mx.tournament_ing_end = function(idx,teamnm,areanm,resetflag){
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisTourn_ing.asp";
  var obj = {};
  obj.CMD = mx.CMD_TOURNEND;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.ONEMORE = "notok";

   if (resetflag == "roundsel") {
    obj.roundSel = $("#roundsel").val();
  }else {
     obj.roundSel = "";
 }

  if (resetflag == "reset"){
	obj.RESET = "ok";
  }
  else{
	obj.RESET = "notok";
  }


  if (Number($('#court_areaname option:selected').val()) == 0 || $('#court_areaname option:selected').val() == undefined){ // 전체
	obj.COURTAREA = 0;
  }
  else{
	obj.COURTAREA = $('#court_areaname option:selected').val();
  }

  mx.SendPacket('myModal', obj);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};



mx.tourn_waitcourt = function(tdid,packet){
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisTourn_ing.asp";
  packet.CMD = mx.CMD_TOURNWAITCOURT;
  packet.COURTNO = $("#waitcourt_"+tdid).val();
  window.t2oriScroll = $("#t2_drowbody").scrollTop();
  mx.SendPacket(tdid,packet);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};

mx.tourn_court = function(tdid,packet){
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisTourn_ing.asp";
  packet.CMD = mx.CMD_TOURNCOURT;
  packet.COURTNO = $("#gcourt_"+tdid).val();
  window.t2oriScroll = $("#t2_drowbody").scrollTop();
  mx.SendPacket(tdid,packet);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};

mx.tourn_win = function(teamstr,winidx,packet){
	if (!confirm( teamstr + "을 승리로 처리 하시겠습니까?")) {
		return;
	}
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisTourn_ing.asp";
  packet.CMD = mx.CMD_TOURNWIN;
  packet.WINIDX = winidx;
  packet.SCOREA = $("#scoreA_"+packet.T_M1IDX).val();
  packet.SCOREB = $("#scoreB_"+packet.T_M2IDX).val();
  window.t2oriScroll = $("#t2_drowbody").scrollTop();
  mx.SendPacket(null,packet);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};


mx.tournament = function(idx,teamnm,areanm,resetflag){
  var obj = {};
  obj.CMD = mx.CMD_TOURN;
  obj.IDX = idx;
  obj.TitleIDX = mx.gameinfo.IDX;
  obj.Title = mx.gameinfo.TITLE;
  obj.TeamNM = teamnm;
  obj.AreaNM = areanm;
  obj.ONEMORE = "notok";

   if (resetflag == "roundsel") {
    obj.roundSel = $("#roundsel").val();
  }else {
     obj.roundSel = "";
 }

  if (resetflag == "reset"){
	obj.RESET = "ok";
  }
  else{
	obj.RESET = "notok";
  }

  mx.SendPacket('myModal', obj);
  //$('#myModal').modal('show');
};

mx.update_rpoint = function(packet,memberIdx,rpoint){

    packet.CMD = mx.CMD_RPOINTEDIT;
    packet.GAMEMEMBERIDX = memberIdx;
    packet.RPOINT = rpoint;
    mx.SendPacket(null, packet);
    //$('#myModal').modal('show');
  };


  mx.update_seed = function(packet, idx, seed){
  packet.CMD = mx.CMD_SEEDEDIT;
  obj.IDX = idx;
  obj.SEED = seed;
  mx.SendPacket('seedFlag', obj);
  //$('#myModal').modal('show');
};

mx.update_rndno = function(packet, memberidx, str, rndno_obj){

//	var st1 = $('#rankL_'+ packet.JONO + '_1').val();
//	var st2 = $('#rankL_'+ packet.JONO + '_2').val();
//	var st3 = $('#rankL_'+ packet.JONO + '_3').val();

	var eqcnt = 0;
	var eqmsg  = '';
	if(Number(str) == 1){
//		if (st1 == "1" || st2 == "1" || st3 =="1"){}
//		else{
//			alert("1위를 먼저 지정하여 주십시오.");
//			rndno_obj.value=rndno_obj.defaultValue;
//			return;
//		}


		for (var i = 0;i< $('input[name="rndno1[]"]').length;i ++ )	{
			if ( $('input[name="rndno1[]"]')[i].value == rndno_obj.value ){
				eqcnt++;
			}
		}
	}
	if(Number(str) == 2){
//		if (st1 == "2" || st2 == "2" || st3 =="2"){}
//		else{
//			alert("2위를 먼저 지정하여 주십시오.");
//			rndno_obj.value=rndno_obj.defaultValue;
//			return;
//		}

		for (var i = 0;i< $('input[name="rndno2[]"]').length;i ++ )	{
			if ( $('input[name="rndno2[]"]')[i].value == rndno_obj.value ){
				eqcnt++;
			}
		}
	}

	if (eqcnt > 1 ){
		eqmsg = '[동일한 랜덤번호 존재] ';
	}

	if (confirm(eqmsg + packet.JONO+"조 "+str+"위의 추첨번호를 변경 하시겠습니까?"))
	{
	  packet.CMD = mx.CMD_RNDNOEDIT;
	  packet.MEMBERIDX = memberidx;
	  packet.STR = str;
	  packet.RNDNO = rndno_obj.value;
	  mx.SendPacket('rndno', packet);
	}
	else
	{
	  //rndno_obj.value=rndno_obj.defaultValue;
	}
};

mx.OnPopClose= function(cmd, packet, html, sender){
  $(sender).modal('toggle');
};





mx.OnAppendHTML =  function(cmd, packet, html, sender){
  if ( packet.lastchk == "_end" ){return;}
  packet.NKEY = Number(packet.NKEY) + 1;
  localStorage.setItem('MOREINFO', JSON.stringify( packet  ));
  $('#'+sender).append(html);
  $("body").scrollTop($("body")[0].scrollHeight);
};


mx.OnBeforeHTML =  function(cmd, packet, html, sender){
  if(html == '' ){
  alert("중복된 소속이 있습니다.");
  return;
  }
  $('.gametitle').first().before(html);
};

mx.contestMore = function(idx){

  var moreinfo = localStorage.getItem('MOREINFO'); //다음

  if (moreinfo == null) {
    var nextkey = 2;
  }
  else{
    moreinfo = JSON.parse(moreinfo);
    var nextkey = moreinfo.NKEY;
  }
  var parmobj = {'CMD':mx.CMD_CONTESTAPPEND,'NKEY':nextkey,"IDX":idx };
  mx.SendPacket('contest', parmobj);
};








mx.flagChange = function(packet, type, sender)
{

  packet.CMD = mx.CMD_GAMEADDITIONFLAG;
  packet.TYPE = type;

  if(sender.checked){
    packet.FLAGCHECK = "Y";
  }
  else{
    packet.FLAGCHECK = "N";
  }

  event.stopPropagation();

  mx.SendPacket(null, packet);
   //상위로 이벤트가 전파되지 않도록 중단한다.
};

mx.tornGameIn = function(packet){
  packet.CMD = mx.CMD_SETTOURNJOO;
  mx.SendPacket("myModal", packet);
};

mx.FillingEmptyEntry = function(packet) {
  packet.CMD = mx.CMD_FILLINGEMPTYENTRY;

  var gubunField = document.getElementById("diffGubun").value;

  if(gubunField == "Y"){
    if (!confirm("랭킹 순서대로 정렬되면 편성완료가 초기화됩니다. 하시겠습니까?")) {
        return;
    }
  }
  else
  {
    if (!confirm("랭킹 순서대로 정렬됩니다. 하시겠습니까?")) {
      return;
    }
  }

  mx.SendPacket(null, packet);
};



mx.search = function(){
	var chkH= "";
	 $('input:checkbox[name="chk"]').each(function() {
		 if(this.checked){
				chkH += this.value;
		  }
		  else{
				chkH += 'N';
		  }
	 });

	var f2arr = [$("#F1_0").val(),$("#F1_1").val(),$("#F1_2").val(),$("#F1_3").val(),chkH,$("#F1_5").val()];
	px.goSubmit( {'F1':[0,1,2,3,4,5] , 'F2':f2arr,'F3':[]} , 'findcontestplayer.asp' )
};


mx.setCheckToggle = function(){
        //클릭되었으면
        if($("#checkall").prop("checked")){
            //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 true로 정의
            $("input[name=chk]").prop("checked",true);
            //클릭이 안되있으면
        }else{
            //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 false로 정의
            $("input[name=chk]").prop("checked",false);
        }
};


mx.gameinfo;
$(document).ready(function(){
    mx.init();
});

mx.init = function(){

  $(function() {
		$('#GameDateWrap1').datetimepicker({format: 'YYYY-MM-DD',locale:'KO'});
		$('#GameDateWrap2').datetimepicker({format: 'YYYY-MM-DD',locale:'KO'});
	});

};

mx.showtrgroup = function(classname, trid, chkthis){
	var obj = $(chkthis);
    obj.hide();
    obj.next().show(); 

	$('.'+ classname).show();
};


mx.hidetrgroup = function(classname, trid, chkthis){
	var obj = $(chkthis);
    obj.hide();
    obj.prev().show();

	$('.'+ classname).hide();
	$('#'+ trid).show();
};






mx.find1 = function(){
  var obj = {};
  obj.CMD = mx.CMD_FIND1;
  obj.TitleIDX =mx.gameinfo.IDX;
  obj.TITLE = mx.gameinfo.TITLE;
  obj.FSTR = $("#GroupGameGb").val();
  obj.COURTCNT = $("#courtcnt").val();

  obj.StartSC =   $("#StartSC").val();
  obj.LastRnd =   $("#LastRnd").val();
  obj.VersusGb            = $("#VersusGb").val();
  obj.GameDate          = $("#GameDate").val();
  obj.GameTime          = $("#GameTime").val();
  obj.EntryCnt          = $("#entrycnt").val();

  mx.SendPacket('level_form', obj);

  $("#btnupdate").hide();

    $("#btndel").hide();
};

mx.find2 = function(){
  var obj = {};
  obj.CMD = mx.CMD_FIND2;
  obj.TitleIDX =mx.gameinfo.IDX;;
  obj.TITLE = mx.gameinfo.TITLE;
  obj.FSTR = $("#GroupGameGb").val();
  var teamGbVal = $("#TeamGb").val();

  if(teamGbVal == "insert" ) {
    var teamGbPrompt = prompt("생성할 부를 입력해주세요");

    if(teamGbPrompt != null && teamGbPrompt != "")  {
      obj.GROUPGAMEGB =teamGbPrompt;
      obj.CMD = mx.CMD_INSERTGROUPGAMEGB;
      mx.SendPacket('level_form', obj);
    }

    $('#TeamGb option')[0].selected = true;
    return;
  }

  obj.FSTR2 = teamGbVal
  obj.COURTCNT = $("#courtcnt").val();
  obj.StartSC =   $("#StartSC").val();
  obj.LastRnd =   $("#LastRnd").val();
  obj.LevelGb           = $("#LevelGb").val();
  obj.VersusGb            = $("#VersusGb").val();
  obj.GameDate          = $("#GameDate").val();
  obj.GameTime          = $("#GameTime").val();
  obj.EntryCnt          = $("#entrycnt").val();
  mx.SendPacket('level_form', obj);


  $("#btnupdate").hide();
    $("#btndel").hide();

};



mx.goplayer = function(idx,levelno,teamnm,levelnm){
  mx.gameinfo.TEAMIDX = idx;
  mx.gameinfo.LEVELNO = levelno;

  mx.gameinfo.TEAMNM = teamnm;
  mx.gameinfo.LEVELNM = levelnm;

  localStorage.setItem('GAMEINFO', JSON.stringify( mx.gameinfo  ));
  location.href="./contestplayer.asp?idx="+mx.gameinfo.IDX + "&teamidx=" + idx;
};



mx.initLaket = function (packet){ //코트생성 설정 수정등등
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisView.asp";
  packet.CMD = mx.CMD_INITLAKET;


	if(packet.hasOwnProperty("CST")){
	  if (packet.CST == "w"){
		  if($("#kcourtname").val() == ""){alert('지역명을 입력해 주십시오.');return;}
		  packet.CTNAME = $("#kcourtname").val();
	  }
	  else if(packet.CST == "e"){
		  if($("#ct_" + packet.CIDX).val() == ""){alert('지역명을 입력해 주십시오.');return;}
		  packet.CTNAME = $("#ct_" + packet.CIDX).val();
	  }
	  else if(packet.CST == "r"){
		  packet.CTNAME = $("#ct_" + packet.CIDX).val();
	  }
	  else{
		  packet.CTNAME = $("#kcourtname").val();
	  }
	}

  mx.SendPacket('LaketModal', packet);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};

mx.setLaket = function (titleidx, levelno, playeridx, itemIDX) {

	var obj = {};
	obj.CMD = mx.CMD_SETLAKET;
	obj.titleidx = titleidx;
	obj.levelno = levelno;
	obj.playeridx = playeridx;
	obj.itemIDX = itemIDX;
	console.log(obj);
	mx.SendPacket(null, obj);

};
//////////////////////////////////////////////////////////////////////

mx.initCourt = function (packet){ //코트생성 설정 수정등등
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisView.asp";
  packet.CMD = mx.CMD_INITCOURT;


	if(packet.hasOwnProperty("CST")){
	  if (packet.CST == "w"){
		  if($("#kcourtname").val() == ""){alert('지역명을 입력해 주십시오.');return;}
		  packet.CTNAME = $("#kcourtname").val();
	  }
	  else if(packet.CST == "e"){
		  if($("#ct_" + packet.CIDX).val() == ""){alert('지역명을 입력해 주십시오.');return;}
		  packet.CTNAME = $("#ct_" + packet.CIDX).val();
	  }
	  else if(packet.CST == "r"){
		  packet.CTNAME = $("#ct_" + packet.CIDX).val();
	  }
	  else{
		  packet.CTNAME = $("#kcourtname").val();
	  }
	}

  mx.SendPacket('Modaltest', packet);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};

mx.writeNotice = function(idx){
mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisView.asp";
  var obj = {};
  obj.CMD = mx.CMD_HTML01;
  obj.IDX = idx;
  mx.SendPacket('myModal',obj);
  mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};


mx.writeNoticeOK = function(idx){
	mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisView.asp";
	var obj = {};
	obj.CMD = mx.CMD_HTML01OK;
	obj.IDX = idx;
	var contents = $("#notice").val();
	if (contents == ''){
		return;
	}

	obj.CONTENTS = contents;
	mx.SendPacket('myModal', obj);
	mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
};
//////////////////////////////////////////////////////////////////////



//mx.goProceeding = function(idx,levelno,teamnm,levelnm){
//
//  mx.gameinfo.TEAMIDX = idx;
//  mx.gameinfo.LEVELNO = levelno;
//  mx.gameinfo.TEAMNM = teamnm;
//  mx.gameinfo.LEVELNM = levelnm;
//
//  localStorage.setItem('GAMEINFO', JSON.stringify( mx.gameinfo  ));
//  location.href="./proceeding.asp?idx="+mx.gameinfo.IDX + "&teamidx=" + idx;
//};



mx.SelectDivObject = null;
mx.SeelctDivObjectBackground = null;
mx.ChangeDivObject = null;
mx.SelectObject = {};
mx.ChangeObject = {};

mx.changeSelectArea = function(IDX, control, groupNo, sortNo, packet)
{
  packet.CMD = mx.CMD_CHANGESELECTAREA;


  if(event.target.tagName != "DIV")
    return;

  //첫 객체 선택
  if(mx.SelectDivObject == null )
  {
	mx.SelectDivObject = control;
	mx.SelectObject.IDX = IDX;
	mx.SelectObject.GROUPNO = groupNo;
	mx.SelectObject.SORTNO = sortNo;
	mx.SeelctDivObjectBackground = control.style.backgroundColor;
	control.style.backgroundColor ='#c7ecff'

  }
  else
  {
    // 같은 객체 선택
    if(mx.SelectDivObject == control)
    {
      mx.SelectDivObject = null;
      mx.SelectObject = null;
      mx.SelectObject = {};
      control.style.backgroundColor = mx.SeelctDivObjectBackground
    }
    else
    {
      //첫 객체와 다른 객체 선택 시 교환 작업
      mx.ChangeDivObject = control;
      mx.ChangeObject.IDX = IDX;
      mx.ChangeObject.GROUPNO = groupNo;
      mx.ChangeObject.SORTNO = sortNo;

      var title = mx.SelectObject.GROUPNO + "조" + " " + mx.SelectObject.SORTNO + "번에서 "
      title = title + mx.ChangeObject.GROUPNO + "조" + " " + mx.ChangeObject.SORTNO + "번으로 "
      title = title + " 바꾸시겠습니까? ";

      //교환
      if (confirm(title) == true){    //확인
		window.oriScroll = $("#drowbody").scrollTop();
		mx.SelectDivObject.style.backgroundColor =''
        mx.ChangeDivObject.style.backgroundColor =''
        packet.SELECTOBJECT = mx.SelectObject;
        packet.CHANGEOBJECT = mx.ChangeObject;
        mx.SelectObject = {};
        mx.ChangeObject = {};
        mx.SelectDivObject = null;
        mx.ChangeDivObject = null;
        mx.SendPacket(null, packet);

      }else{   //취소
        mx.SelectDivObject.style.backgroundColor =''
        mx.ChangeDivObject.style.backgroundColor =''
        mx.SelectObject = {};
        mx.ChangeObject = {};
        mx.SelectDivObject = null;
        mx.ChangeDivObject = null;
        return;
      }

    }
  }
};






////////////////////////////////////////////////////////////////////////////////
    mx.players = null;
    mx.initial = null;
    mx.dragSrcEl_ = null;

    //수정 모드
    mx.mod= function(e) {

    };
    //완료 모드
    mx.comp= function(e) {

    };
    //예선 선택
    mx.trySel= function(e,idxno,levelno,gameMemberIDX,checkId) {
        var targetobj = document.getElementById("drag_"+checkId);

          if ( targetobj.style.color =="red") {
                targetobj.style.color= 'black';
            }else {
                targetobj.style.color= 'red';
            }


        //체크
        var obj = {};
          obj.CMD = mx.CMD_TOURN;
          obj.IDX = idxno;
          obj.TitleIDX = mx.gameinfo.IDX;
          obj.level = levelno;
          obj.gameMemberIDX = gameMemberIDX;
          obj.checkId = checkId;

          console.log(obj);
    };
    //본선 선택
    mx.tornSel=function(e,idxno,levelno,gameMemberIDX,checkId) {
        var targetobj = document.getElementById(checkId);

          if ( targetobj.style.color =="red") {
                targetobj.style.color= 'black';
            }else {
                targetobj.style.color= 'red';
            }


        //체크
        var obj = {};
          obj.CMD = mx.CMD_TOURN;
          obj.IDX = idxno;
          obj.TitleIDX = mx.gameinfo.IDX;
          obj.level = levelno;
          obj.gameMemberIDX = gameMemberIDX;
          obj.checkId = checkId;

          console.log(obj);
    };










    mx.allowDrop= function(e) {
      if (e.preventDefault) {
        e.preventDefault(); // Allows us to drop.
      }
      e.dataTransfer.dropEffect = 'move';
      return;
    };

    mx.drag = function(e) {
      var targetobj = document.getElementById(e.target.id);
      e.dataTransfer.effectAllowed = 'move';
      e.dataTransfer.setData('text', targetobj.innerHTML);
      mx.dragSrcEl_ = document.getElementById(e.target.id);
      targetobj.style.color = 'red';
    };

    mx.drop = function(e) {
      var targetobj = document.getElementById(e.target.id);
      if (e.stopPropagation) {
        e.stopPropagation();
      }

      if (mx.dragSrcEl_ != targetobj) {
        var dragobjrow = mx.dragSrcEl_.id.split('_')[1];  //행1
        var dropobjrow = targetobj.id.split('_')[1];       //행2
        var dragobjcol = mx.dragSrcEl_.id.split('_')[2];   //열1
        var dropbjcol = targetobj.id.split('_')[2];        //열2
        var gamestart = false;

            if ( gamestart == false){ // //보이는 화면 변경 , 소팅번호변경
              mx.dragSrcEl_.innerHTML = targetobj.innerHTML;
              targetobj.innerHTML = e.dataTransfer.getData('text').trim();

              var dragcolno = mx.players[mx.dragSrcEl_.id.split('_')[2]].CO;
              var targetcolno = mx.players[targetobj.id.split('_')[2]].CO;

              var changedata1 = mx.players[mx.dragSrcEl_.id.split('_')[2]];
              var changedata2 = mx.players[targetobj.id.split('_')[2]];

              changedata1.CO = targetcolno;
              changedata2.CO = dragcolno;

              mx.players[mx.dragSrcEl_.id.split('_')[2]] = changedata2;
              mx.players[targetobj.id.split('_')[2]] = changedata1;
            }
      }
      return false;
    };


    mx.dragEnd = function(e) {
      var targetobj = document.getElementById(e.target.id);
      if (e.stopPropagation) {
        e.stopPropagation();
      }

      if (mx.dragSrcEl_ != targetobj) {
        var dragobjrow = mx.dragSrcEl_.id.split('_')[1];  //행1
        var dropobjrow = targetobj.id.split('_')[1];       //행2
        var dragobjcol = mx.dragSrcEl_.id.split('_')[2];   //열1
        var dropbjcol = targetobj.id.split('_')[2];        //열2
        var gamestart = false;


            if ( gamestart == false){ // //보이는 화면 변경 , 소팅번호변경
              mx.dragSrcEl_.innerHTML = targetobj.innerHTML;
              targetobj.innerHTML = e.dataTransfer.getData('text').trim();

              var dragcolno = mx.players[mx.dragSrcEl_.id.split('_')[2]].CO;
              var targetcolno = mx.players[targetobj.id.split('_')[2]].CO;

              var changedata1 = mx.players[mx.dragSrcEl_.id.split('_')[2]];
              var changedata2 = mx.players[targetobj.id.split('_')[2]];

              changedata1.CO = targetcolno;
              changedata2.CO = dragcolno;

              mx.players[mx.dragSrcEl_.id.split('_')[2]] = changedata2;
              mx.players[targetobj.id.split('_')[2]] = changedata1;
            }

      }
      return false;
    };

/**
 * 가로 아코디언
 * mx.Accordian
 * el = '.tourney_admin'
 */
mx.Accordian = function (el) {
  this._$tourneyAdm = null; /* el 담을 프로퍼티 */
  this._$toggleBtn = null; /* 이벤트를 발생시킬 버튼들 thead > .btn */
  this._$tourneyAdmTd = null; /* table의 td들 */

  this._actIdx = -1; /* 버튼 클릭시 해당 버튼의 index 값 */
  this._$column = null; /* 클릭한 버튼의 인덱스와 일치하는 td */
  this._$collapseTg = null; /* 줄어든 td 모음 */
  this._btnData = -1; /* 버튼의 data 담을 프로퍼티 */

  this._init(el);
  this._evt();
};

mx.Accordian.prototype._init = function(el){
  this._$tourneyAdm = $(el);
  this._$toggleBtn = $('thead .btn', this._$tourneyAdm);
  this._$tourneyAdmTd = $('td', this._$tourneyAdm);
}

mx.Accordian.prototype._evt = function() {
  var that = this;
  this._$toggleBtn.on('click', function(){
    that._actIdx = that._$toggleBtn.index(this); /* 클릭한 버튼의 인덱스 */
    this._btnData = $(this).data('collap'); // data-collap 속성 값
    that._execToggle(this._btnData); // collapse 기능 호출
  });
};

mx.Accordian.prototype._execToggle = function(btnData) {
  if (this._$collapseTg) { // 이전에 지정된 형태의 collapse가 있으면
    this._$collapseTg.removeClass('increase'); // 원상복구
  }

  this._$collapseTg = this._$tourneyAdmTd.filter('[rowspan='+btnData+']'); // collapse 새로 지정
  if (btnData == 1) {
    this._$collapseTg = this._$tourneyAdm.find('tr td:first-child');
    console.log(this._$collapseTg);
  }

  this._$collapseTg.addClass('increase') // 선택된 td들 늘리기
};


/**
 * on/off 버튼 구현
 */
mx.OnOffSwitch = function (el) {
  this._$tg = null; /* chk_btn */
  this._$swBtn = null; /* 스위치 할 버튼 */

  this._init(el);
  this._evt();

  $('.winnercell').parents('div').filter('div[id*="cell_"]').addClass('redy');
};

mx.OnOffSwitch.prototype._init = function(el) {
  this._$tg = $(el);
  this._$swBtn = $('.btn', this._$tg);
}

mx.OnOffSwitch.prototype._evt = function() {
  var that = this;
  this._$swBtn.on('click', function(){
    that._toggleBtn($(this))
  })
};

/**
 * _toggleBtn 버튼 구현
 * $this 는 클릭한 버튼
 */
mx.OnOffSwitch.prototype._toggleBtn = function($this) {
  if ($this.hasClass('on')) {
    $this.removeClass('on');
  } else {
    $this.addClass('on');
  }
};

mx.ChangeText = function(htmlobj, str) {

	if (htmlobj.value == "0")
	{
		htmlobj.value = "";
	}
};


mx.attCheck = function(idx, typeno,cfg){
	var chkobjid;
	var obj ={};
	obj.IDX = idx;
	switch (Number(typeno))
	{
	case 1:
	   chkobjid = "attins" + idx;
	   if ( $("#attins_"+idx).is(":checked") == true ) {
		   obj.CHK = 'Y';
	   }
	   else{
			obj.CHK = 'N';
	   }
		break;
	case 2:
	   chkobjid = "attedit" + idx;
	   if ( $("#attedit_"+idx).is(":checked") == true ) {
		   obj.CHK = 'Y';
	   }
	   else{
			obj.CHK = 'N';
	   }
		break;
	case 3:
	   chkobjid = "attdel" + idx;
	   if ( $("#attdel_"+idx).is(":checked") == true ) {
		   obj.CHK = 'Y';
	   }
	   else{
			obj.CHK = 'N';
	   }
		break;
	}

	obj.CFG = cfg;
	obj.TYPENO = typeno;
	obj.CMD = mx.CMD_ATTSTATE;
	mx.SendPacket(chkobjid, obj);
};

//선수교체 요청
mx.changePlayer = function(){
	var obj = {};
	obj.CMD = mx.CMD_CHANGEPLAYER;
	obj.ridx =  	$("#requestidx").val();
	obj.orgp1idx = 	$("#orgp1idx").val();
	obj.orgp2idx = $("#orgp2idx").val();
	obj.p1idx = $("#p1idx").val();
	obj.p2idx = $("#p2idx").val();

	if( Number(obj.orgp1idx) == Number(obj.p1idx) && Number(obj.orgp2idx) == Number(obj.p2idx) ){
		alert("참가신청자 이거나 변경된 정보가 없습니다.");
		return;
	}

	obj.tidx = mx.gameinfo.IDX;
	obj.levelno = mx.gameinfo.LEVELNO;
	mx.SendPacket('player1', obj);
};

//신규팀등록
mx.setTeam = function(lidx){
	var obj = {};
	obj.CMD = mx.CMD_SETTEAM;
	obj.lidx = lidx;
	obj.p1idx = $("#p1idx").val();
	obj.p2idx = $("#p2idx").val();
	obj.pos = $("#tryout_pos").val();
	if( obj.p1idx == '' || obj.p2idx == '' ){
		alert("등록할 선수를 검색해 주십시오.");
		return;
	}
	obj.tidx = mx.gameinfo.IDX;
	obj.levelno = mx.gameinfo.LEVELNO;
	mx.SendPacket('player1', obj);
};

//중복체크
mx.chkPlayer = function(){
	var obj = {};
	obj.CMD = mx.CMD_CHKPLAYER;
	obj.pname = $("#nname").val();
	obj.phone = $("#nphone").val();

	if( obj.pname == '' || obj.phone == '' ){
		alert("이름과 핸드폰번호를 입력해주세요.");
		return;
	}
	mx.SendPacket('player1', obj);
};

//선수생성
mx.setPlayer = function(){
	var obj = {};
	obj.CMD = mx.CMD_SETPLAYER;
	obj.pname = $("#nname").val();
	obj.pphone = $("#nphone").val();
	obj.pteam1 = $("#nteam1").val();
	obj.pteam2 = $("#nteam2").val();

	if( obj.pname == '' && obj.phone == '' ){
		alert("이름과 핸드폰번호를 입력해주세요.");
		return;
	}
	if( obj.team1 == '' || obj.team2 == '' ){
		alert("1개이상 클럽명을 기입해 주세요.");
		return;
	}

	obj.tidx = mx.gameinfo.IDX;
	obj.levelno = mx.gameinfo.LEVELNO;
	mx.SendPacket('player1', obj);
};



/*선수 정보 자동완성*/
mx.initPlayer = function(reloadchk){

    $( "#p1name" ).autocomplete({

		open: function(){
			setTimeout(function () {
				$('.ui-autocomplete').css('z-index', 1300);
			}, 0);
		},

		source : function( request, response ) {
			$.ajax(
				{
						type: 'post',
						url: "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestPlayerFind.asp",
						dataType: "json",
						//request.term = $("#autocomplete").val()
						data: { "REQ" : JSON.stringify({"CMD":mx.CMD_AUTOCOMPLETEALL, "SVAL":request.term, "TIDX":mx.gameinfo.IDX,"LIDX":mx.gameinfo.LEVELNO}) },
						success: function(data) {
								//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                                console.log(data);
								response(
										$.map(data, function(item) {
                                        console.log(item);
												return {
														label: item.data + item.teamTitle,
														value: item.data,
														uidx:item.uidx
												}
										})
								);
						}
				}

			);
		},

			//조회를 위한 최소글자수
			minLength: 1,
			select: function( event, ui ) {
			if( Number(ui.item.uidx) == 0 ){
				return;
			}
			// 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생 파인트 새로고침
			var obj = {};
			obj.CMD = mx.CMD_FINDPLAYER2;
			mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestPlayer.asp";
			obj.pidx = ui.item.uidx;
			obj.levelno = mx.gameinfo.LEVELNO;
			obj.playerno = 1;
			obj.tidx = mx.gameinfo.IDX;
			obj.levelnm = mx.gameinfo.LEVELNM;
			mx.SendPacket('player1', obj);
			mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
        }
    });


	$( "#p2name" ).autocomplete({

		open: function(){
			setTimeout(function () {
				$('.ui-autocomplete').css('z-index', 1300);
			}, 0);
		},

		source : function( request, response ) {
             $.ajax({
                    type: 'post',
                    url: "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestPlayerFind.asp",
                    dataType: "json",
                    //request.term = $("#autocomplete").val()
					data: { "REQ" : JSON.stringify({"CMD":mx.CMD_AUTOCOMPLETEALL, "SVAL":request.term, "TIDX":mx.gameinfo.IDX,"LIDX":mx.gameinfo.LEVELNO}) },
                    success: function(data) {
                        //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                        response(
                            $.map(data, function(item) {
                                return {
                                    label: item.data + item.teamTitle,
                                    value: item.data,
																		uidx:item.uidx,
																		urpoint:item.urpoint,
                                }
                            })
                        );
                    }
               });
            },

		//조회를 위한 최소글자수
        minLength: 1,
        select: function( event, ui ) {
            // 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생 파인트 새로고침
			var obj = {};
			mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestPlayer.asp";
			obj.CMD = mx.CMD_FINDPLAYER2;
			obj.pidx = ui.item.uidx;
			obj.levelno = mx.gameinfo.LEVELNO;
			obj.playerno = 2;
			obj.tidx = mx.gameinfo.IDX;
			obj.levelnm = mx.gameinfo.LEVELNM;
			mx.SendPacket('player2', obj);
			mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqTennisContestlevel.asp"; //원래대로
        }
    });
};

mx.updateJoocnt = function(obj,levelno){

var packet = {};
packet.CMD = mx.CMD_UPDATEJOOCNT;
packet.ID = obj.id;
packet.VALUE = obj.value;
packet.TIDX = mx.gameinfo.IDX;
packet.LEVELNO = levelno;

  if ( confirm("예선 조수를 변경 하시겠습니까?")  == false ) {
    obj.value = $("#h_" + packet.ID).val();
	return;
  }

	mx.SendPacket(null, packet);
};

mx.delTeam = function(packet){
  if ( confirm("참여팀을 삭제하시겠습니까?")  == false ) {
	return;
  }

  packet.CMD = mx.CMD_DELTEAM;
  mx.SendPacket(null, packet);
};



mx.findno = 0;
/////////////////////////////////////////
mx.searchAndHighlight = function(searchTerm, targetarea, selector ,findtype) {
	if (searchTerm) {
		var selector = selector || "#realTimeContents"; //use body as selector if none provided
		var searchTermRegEx = new RegExp(searchTerm, "ig");
		var matches = $(selector).text().match(searchTermRegEx);
		if (matches != null && matches.length > 0) {
			$('.highlighted').removeClass('highlighted'); //Remove old search highlights

			//Remove the previous matches
			$span = $('#'+targetarea+' span');
			$span.replaceWith($span.html());

			if (searchTerm === "&") {
				searchTerm = "&amp;";
				searchTermRegEx = new RegExp(searchTerm, "ig");
			}
			$(selector).html($(selector).html().replace(searchTermRegEx, "<span class='match'>" + searchTerm + "</span>"));
			$('.match:first').addClass('highlighted');


				if (mx.findno >= $('.match').length) mx.findno = 0;
				$('.match').removeClass('highlighted');
				$('.match').eq(mx.findno).addClass('highlighted');
				$('.ui-mobile-viewport').animate({
					scrollTop: $('.match').eq(mx.findno).offset().top
				}, 300);


			if ($('.highlighted:first').length) { //if match found, scroll to where the first one appears

				//$('#drowbody').scrollTop($('.highlighted:first').position().top); //#drowbody
				switch ( findtype )
				{
				case "table1":
				$('#drowbody').scrollTop($('.highlighted:first').parent().parent().parent().parent().parent().position().top - 90);
				mx.findno= Number(mx.findno) + 1;
				break;
				case "table2":
				$('#drowbody').scrollTop($('.highlighted:first').parent().parent().parent().parent().parent().parent().position().top - 135);
				mx.findno= Number(mx.findno) + 1;
				break;
				case "table3":
				$('#realTimeContents').scrollTop($('.highlighted:first').position().top -180);
				mx.findno= Number(mx.findno) + 1;
				break;
				case "table4":
				$('#t2_drowbody').scrollTop($('.highlighted:first').parent().parent().parent().parent().parent().parent().position().top - 135);
				mx.findno= Number(mx.findno) + 1;
				break;
				}


				//   var column = $('.highlighted:first').parent().parent().parent().parent().prop('cellIndex');
				//   var row = $('.highlighted:first').parent().parent().parent().parent().parent().position().top;//prop('rowIndex').
				//    alert([column, ',', row].join(''));
			}
			return true;
		}
	}
	return false;
};


mx.docfindstr = function(inputclassname, targetarea,selector, findtype){
	$(".highlighted").removeClass("highlighted").removeClass("match");
	if (  !mx.searchAndHighlight( $('.'+inputclassname).val(), targetarea ,selector, findtype)  ) {
	alert("검색한 내용이 존재 하지 않습니다.");
	}
};




mx.OnFocusOut = function(lastTabIndex, tabobj,classname, copvalue)
{
	var copvalue = copvalue || "";

	var currentElement = tabobj;
    var curIndex = currentElement.tabIndex;
    if(curIndex == lastTabIndex) {
        curIndex = 0;
    }
    var tabbables = $('.'+classname);
    for(var i=0; i<tabbables.length; i++) {
        if(tabbables[i].tabIndex == (curIndex+1)) {
            if( classname == 'tabarea' ){ //지역 내용 복사
				tabbables[i].value = copvalue;
			}
			tabbables[i].focus();
            break;
        }
    }
};

//본선대진룰 대진표에 다시반영 (바이자리, 빈자리, 위치제조정, 없는선수 정리 , 중복값 정리)
mx.initResetRull = function(packet){
    packet.CMD = mx.CMD_INITRULL;
	mx.SendPacket("myModal", packet);
};

/////////////////////////////////////////////////////////
