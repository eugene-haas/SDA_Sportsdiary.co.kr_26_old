var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;


  mx.CMD_GETRELAYINFO = 21000; 
  mx.CMD_GETRELAYINFOORDER = 21100;


 mx.CMD_LGMAKE = 70000;
 mx.CMD_TNMAKE = 777;
 mx.CMD_PLAYERPOP = 22000;
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/riding/mobile/reqRiding.asp";
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

mx.IsJsonString = function(str) {
	try {
		var json = JSON.parse(str);
	return (typeof json === 'object');
	} catch (e) {
		return false;
	}
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
      if (mx.IsJsonString(data)){
			jsondata = JSON.parse(data);
      }
	  else{
	      htmldata = data;
	  }
    }
  }
  else{
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( mx.IsJsonString(data) ){
    switch (Number(jsondata.result))  {
    case 0: break;
    case 1: alert('데이터가 존재하지 않습니다.');return;  break;
    case 2: alert('동일한 데이터가 존재합니다.');return;  break;
    case 3: alert('지도자로 등록된 사용자가 아닙니다. 대한 체육회에 등록 후 이용하여 주십시오.');return;  break;
    case 8: alert(jsondata.msg);return;  break;
    case 100: return;   break; //메시지 없슴
	return;   break;
	}
  }

  switch (Number(reqcmd)) {
	case mx.CMD_DELKIND : return; break;

	case mx.CMD_GAMEINPUT:	window.location.reload();	break;

	case mx.CMD_GETRELAYINFO:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_GETRELAYINFOORDER:	this.OndrowHTML2( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_TNMAKE : 
	if(jsondata.CALLTYPE == "make") { location.reload();    break;}
	else{  this.OnShowTourn( reqcmd, jsondata, htmldata, sender ); break; }

	case mx.CMD_PLAYERPOP : 	this.OnplayerPOP( reqcmd, jsondata, htmldata, sender );		break;

  
  }
};


//요청##################################################################
	//릴레이 상세정보 보기
	mx.vobj = "";
	mx.getRelayInfo = function(vobj, tidx,gbidx,gno,tm,tit){
		var obj = {};
		obj.CMD = mx.CMD_GETRELAYINFO;
		//alert(1);
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.GNO = gno;
		obj.TM = tm;
		obj.TITLE = tit;
		mx.vobj = vobj;

		//$('#m1').removeClass('on');
		//$('#m2').removeClass('on');
		//$('#m1').addClass('on');
		mx.SendPacket(vobj, obj);	
	};

	mx.getRelayInfoOrder = function(vobj, tidx,gbidx,gno,tm,tit){
		var obj = {};
		obj.CMD = mx.CMD_GETRELAYINFOORDER;
		//alert(1);
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.GNO = gno;
		obj.TM = tm;
		obj.TITLE = tit;
		mx.vobj = vobj;
		//$('#m1').removeClass('on');
		//$('#m2').removeClass('on');
		//$('#m2').addClass('on');
		mx.SendPacket(vobj, obj);	
	};
	
	//부의 출전선수 팝업창 오픈
	mx.showplayer = function(midx,hnm){
			var obj = {};
			obj.CMD = mx.CMD_PLAYERPOP;
			obj.MIDX = midx;
			obj.HNM = hnm;
			mx.SendPacket(null, obj);	
	};


	//대진표 생성
	mx.makeGameTable = function(tidx,gbidx,tabletype,calltype){
		
		mx.ajaxurl = "/pub/ajax/riding/reqBooControl.asp";
		var obj = {};
		obj.TABLETYPE = tabletype;
		if(Number(tabletype) == 1 ){
			obj.CMD = mx.CMD_LGMAKE;
		}
		else{
			obj.CMD = mx.CMD_TNMAKE;		
		}
		obj.TIDX = tidx;
		obj.LNO = gbidx;
		obj.TNO = $('#tableno').val(); //참가자수
		obj.CALLTYPE = calltype;

		mx.SendPacket('tournament2', obj);			
		mx.ajaxurl = "/pub/ajax/riding/mobile/reqRiding.asp";
	};	


//응답##################################################################

mx.OndrowHTML =  function(cmd, packet, html, sender){

$('#relaypop').html(html);

				  sender.layer=new OverLayer({
					overLayer:$(".relayPop"),
					emptyHTML:"정보를 불러오고 있습니다.",
					errorHTML:"",
				  });
				  sender.layer.on("beforeOpen",function(){
					history.pushState("list2", null, null)
				  });
				  history.replaceState("list2", null, null);
				  sender.layer.open();
};


mx.OndrowHTML2 =  function(cmd, packet, html, sender){
	$('#relaypop').html(html);
};



mx.OnplayerPOP = function(cmd, packet, html, sender){
	$('#relayattmember').html(html);
	$('#realyplayerpop').show();
};


mx.tablejsondata = "";
mx.OnShowTourn =  function(cmd, packet, html, sender){

	 mx.tablejsondata = packet;

	
      var tournament2 = new Tournament();
	  
	  tournament2.setOption({
        blockBoardWidth: 220, // integer board 너비
        blockBranchWidth: 40, // integer 트리 너비
        blockHeight : 80, // integer 블럭 높이(board 간 간격 조절)
        branchWidth : 2, // integer 트리 두께
        branchColor : '#a9afbf', // string 트리 컬러
        roundOf_textSize : 60, // integer 배경 라운드 텍스트 크기
        scale : 'decimal', // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
        board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
    		el:document.getElementById('tournament2') // element must have id
    	});

      tournament2.setStyle('#tournament2');
	  tournament2.boardInner = function(data){
		var Lwincolor = "";
		var Rwincolor = "";	

		var Lnm = data.teamnmL;
		var Rnm = data.teamnmR;
		//var Lteamnm = data.LteamAna;
		//var Rteamnm = data.RteamAna;

		if (data.LWL == 'W'){
			Lwincolor = "style='background:orange;'";
		}
		if (data.RWL == 'W'){
			Rwincolor = "style='background:orange;'";
		}


		if (Lnm == '--' || Lnm == null ){
			Lnm = "";
		}
		if (Rnm == '--' || Rnm == null ){
			Rnm = "";
		}

		//		if (Lteamnm == null){
		//			Lteamnm = "";
		//		}
		//		if (Rteamnm == null){
		//			Rteamnm = "";
		//		}
		
		if (Lnm == '' || Rnm == '' || Lnm == '부전' || Rnm == '부전'){
			var makebtn = '';
		}
		else{
			var makebtn = '';
			//var makebtn = '<button type="button" class="btn btn-block btn-default" onclick="mx.setResultWindow('+data.idx+')">결과입력</button>';
		}

        var html = [
          '<p class="ttMatch ttMatch_first"  '+Lwincolor+'>',
            '<span class="ttMatch__score"><!--'+data.scoreL+'--></span>',
            '<span class="ttMatch__playerWrap">',
              '<span class="ttMatch__playerInner"  >',
                '<span class="ttMatch__player"><a href="javascript:mx.showplayer('+data.midxL+',null)">'+Lnm+'</a></span>',
                '<span class="ttMatch__belong">'+makebtn+'</span>',
              '</span>',
            '</span>',
          '</p>',
          '<p class="ttMatch ttMatch_second" '+Rwincolor+'>',
            '<span class="ttMatch__score"><!--'+data.scoreR+'--></span>',
            '<span class="ttMatch__playerWrap">',
              '<span class="ttMatch__playerInner"   >',
                '<span class="ttMatch__player"><a href="javascript:mx.showplayer('+data.midxR+',null)">'+Rnm+'</a></span>',
                '<span class="ttMatch__belong"></span>',
              '</span>',
            '</span>',
          '</p>'
        ].join('');

    		return html;
    	}

      tournament2.draw({
        roundOf:packet.TotalRound,
		data:  packet
      });

};	




////////////////////////////////////////////////////////////////


