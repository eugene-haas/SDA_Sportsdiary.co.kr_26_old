var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;
////////////////////////////////////////

mx.CMD_TEAMATTMEMBER = 20000;
mx.CMD_TEAMLIST = 20010;
mx.CMD_CDALIST = 20020;
mx.CMD_GETATTMEMBER = 20030;
mx.CMD_GETMATCHTABLE = 20040;
mx.CMD_GETMATCHTABLEJOO = 20050;
mx.CMD_GETMATCHTABLEFIND = 20060;
mx.CMD_GETORDERTABLEFIND = 20070;
mx.CMD_GETRESULTTABLEFIND = 20080;
mx.CMD_GETRC = 20090;

mx.CMD_GETFINDTEAM = 120;
mx.CMD_GETFINDPLAYER = 130;
mx.CMD_GETPLAYERTABLE = 140;


mx.CMD_GAMEINRC = 13000; //게임결과 입력
mx.CMD_SECTIONINFO = 13001;//구간기록 팝업창
mx.CMD_TNMAKE = 700;

mx.ajaxurl = "/pub/ajax/swimming/reqMobile.asp";
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
  //if( jsondata !='' && jsondata != null){
		switch (Number(jsondata.result))  {
		case 0: break;
		case 1: alert('데이터가 존재하지 않습니다.');return;  break;
		case 2: alert('동일한 데이터가 존재합니다.');return;  break;
		case 5: alert('값이 부정확합니다.');return;  break;
		case 99: alert('아직 대회가 종료되지 않았습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
		case 12345: this.makeGameTable(jsondata.tidx,jsondata.levelno,jsondata.tabletype,jsondata.tableno,'drow',jsondata.openRC); break; //ajax롤 받았을때
		return;   break;
		}
  //}
  }

  switch (Number(reqcmd)) {
	case mx.CMD_TNMAKE : this.OnShowTourn( reqcmd, jsondata, htmldata, sender ); break; //토너먼트
	case mx.CMD_GAMEINRC:
    case mx.CMD_SECTIONINFO:
	//case mx.CMD_CHANGERANE:	window.location.reload();	break;
	case mx.CMD_GETRC:
	case mx.CMD_GETORDERTABLEFIND:
	case mx.CMD_GETMATCHTABLEFIND:
	case mx.CMD_GETRESULTTABLEFIND:
	case mx.CMD_GETMATCHTABLEJOO:
	case mx.CMD_GETMATCHTABLE:
	case mx.CMD_GETATTMEMBER :
	case mx.CMD_CDALIST:
	case mx.CMD_TEAMLIST:
	case mx.CMD_TEAMATTMEMBER: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
  }
};


//요청하기#####################
mx.popup = function(){
$('.l_upLayer').addClass( '_s_on' );
$('.l_upLayer__backdrop').addClass( '_s_on' );
$('.l_upLayer__contBox').addClass( '_s_on' );
};

mx.popClose = function(){
$('.l_upLayer').removeClass( '_s_on' );
$('.l_upLayer__backdrop').removeClass( '_s_on' );
$('.l_upLayer__contBox').removeClass( '_s_on' );
};

//토너먼트 대진표
mx.makeGameTable = function(tidx,levelno, tabletype, tableno, calltype,openrc){

	var obj = {};
	obj.TABLETYPE = tabletype;
	obj.CMD = mx.CMD_TNMAKE;
	obj.TIDX = tidx;
	obj.LNO = levelno;
	obj.TNO = tableno; //참가자수
	obj.CALLTYPE = calltype;
	obj.OPENRC = openrc; //결과노출여부

	mx.SendPacket('popcontents', obj);

};

//구간기록조회
mx.getSectionInfo = function(midx,ampm,rc,order,rane){
	var obj = {};
	obj.CMD = mx.CMD_SECTIONINFO;
	obj.IDX =midx;
    obj.AMPM = ampm;
    obj.RC = rc;
    obj.ORDER = order;
    obj.RANE = rane;
	mx.SendPacket('popcontents', obj);
};


//점수 표시
mx.showJumsoo = function(idx){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINRC;
	obj.IDX =idx;
	mx.SendPacket('popcontents', obj);
};


//신기록 검색
mx.getRC = function(tidx,rccode,boonm){
	var obj = {};
	obj.CMD = mx.CMD_GETRC;
	obj.TIDX =tidx;
	obj.RCCODE = rccode;
	obj.BOONM = boonm;
	mx.SendPacket('sw_gametable', obj);
};

//검색한 대상의 참가 대진표
mx.getMachGameNo = function(tidx,cda,pidx,dd,ampm){
	var obj = {};
	obj.CMD = mx.CMD_GETORDERTABLEFIND;
	obj.TIDX =tidx;
	obj.CDA = cda;
	obj.PIDX = pidx;
	obj.DD = dd;
	obj.AMPM = ampm;
	mx.SendPacket('sw_orderlist', obj);
};


//검색한 선수의 결과
mx.getPlayerResult  = function(tidx,cda,pidx){
	var obj = {};
	obj.CMD = mx.CMD_GETRESULTTABLEFIND;
	obj.TIDX =tidx;
	obj.CDA = cda;
	obj.PIDX = pidx;
	mx.SendPacket('sw_gametable', obj);
};



//검색한 대상의 참가 대진표
mx.getMachPlayer = function(tidx,cda,pidx){
	var obj = {};
	obj.CMD = mx.CMD_GETMATCHTABLEFIND;
	obj.TIDX =tidx;
	obj.CDA = cda;
	obj.PIDX = pidx;
	mx.SendPacket('sw_searchboo', obj);
};


//부별 대진표 조, 예/결
mx.getMachTab = function(tidx,findstr, joono, tabno){
	var obj = {};
	obj.CMD = mx.CMD_GETMATCHTABLEJOO;
	obj.TIDX =tidx;
	obj.LIDX = findstr.split('_')[0];
	obj.LNO = findstr.split('_')[1];
	obj.JOONO = joono;
	obj.TABNO = tabno; //1 ,3    4, 6 (화면다름)
	mx.SendPacket('sw_gametable', obj);
};

//부별 참가종목리스트 불러오기 match-sch.asp
mx.getMachList = function(tidx, cda){
	var obj = {};
	obj.CMD = mx.CMD_CDALIST;
	obj.TIDX =tidx;
	obj.CDA = cda;
	obj.SHOWTYPE = $('#showtype').val();
	mx.SendPacket('s_cdbc', obj);
};

//부별 대진표 불러오기 or 대회결과불러오기
mx.getMachTable = function(tidx,findstr,showtype,unm,pidx){ //showtype = 0 대회결과 요청
	var obj = {};
	if (findstr == ""){
		return;
	}
	obj.CMD = mx.CMD_GETMATCHTABLE;
	obj.TIDX =tidx;
	obj.LIDX = findstr.split('_')[0];
	obj.LNO = findstr.split('_')[1];
	obj.JOONO = $('#'+findstr).val();
	obj.UNM = unm;
	obj.PIDX = pidx;
	obj.SHOWTYPE = $('#showtype').val();
	mx.SendPacket('sw_gametable', obj);
};


//종목별 참가신청자 리스트
mx.getAttMember = function(tidx,it_levelno,pidx){
	var obj = {};
	if (it_levelno == "" && pidx == ""){
		return;
	}
	obj.CMD = mx.CMD_GETATTMEMBER;
	obj.TIDX =tidx;
	obj.ITGUBUN = it_levelno.split('_')[0];
	obj.LNO = it_levelno.split('_')[1];
	obj.PIDX = pidx;
	mx.SendPacket('sw_gametable', obj);
};

//팀별참가신청목록
mx.getAttList = function(tidx,team,clkobj){
	$(".sl_list").not(clkobj).next().slideUp(300);
	$(".sl_list").not(clkobj).parent().siblings().removeClass('s_on');

	var obj = {};
	obj.CMD = mx.CMD_TEAMATTMEMBER;
	obj.TIDX =tidx;
	obj.TEAM = team;
	mx.SendPacket(team, obj);
};

mx.getTeamList = function(tidx,sido,team){
	var obj = {};
	obj.CMD = mx.CMD_TEAMLIST;
	obj.TIDX =tidx;
	obj.SIDO = sido;
	obj.TEAM = team;
	mx.SendPacket('teamlist', obj);
};



//응답처리#####################
mx.OndrowHTML =  function(cmd, packet, html, sender){
	if(cmd == mx.CMD_GAMELIST || cmd == mx.CMD_GAMEBESTLIST || cmd == mx.CMD_GAMEEXLLIST ){
		if( $('#modalB').length == 0 ){
			$('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
		}
		document.getElementById("modalB").innerHTML = html;
		$('#modalB').modal('show');
	}
	else if (cmd == mx.CMD_GAMEINRC || cmd == mx.CMD_SECTIONINFO){
		$('#'+sender).html(html);
		mx.popup();
	}
	else{

		if(cmd == mx.CMD_TEAMATTMEMBER){
			if($('#'+sender).is(":visible") == false){
				document.getElementById(sender).innerHTML = html;
				//$('html, body').animate({scrollTop : 0}, 400);
				$('#'+sender).slideToggle(300);

				$('#'+sender).parent().toggleClass('s_on');

			}
		}
		else if(cmd == mx.CMD_GETMATCHTABLEFIND){
			document.getElementById(sender).innerHTML = html;
			$('#usercdbc').change();
		}
		else if (cmd == mx.CMD_GETRESULTTABLEFIND){
			document.getElementById(sender).innerHTML = html;
			//$('#usercdbc').change();
		}
		else{
			document.getElementById(sender).innerHTML = html;
		}
	}
};



//init
mx.CMD_SEARCH = mx.CMD_GETFINDPLAYER;
mx.pagenm = location.pathname.split('/').slice(-1)[0];
mx.init = function(){

		if ( $("#team_nm").length > 0 ) {
			$( "#team_nm" ).autocomplete({
				source : function( request, response ) {
					 $.ajax({
							type: mx.ajaxtype,
							url: mx.ajaxurl,
							dataType: "json",
							data: { "REQ" : JSON.stringify({"CMD":mx.CMD_GETFINDTEAM, "SVAL":request.term, "TIDX": $('#tidx').val()})  },
							success: function(data) {
								//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
								//console.log( px.strReplaceAll(JSON.stringify( data  ), '\"', '\"\"') );
								response(
									$.map(data, function(item) {
										return {
											label: item.teamnm + ' ' + item.cnt + '명',
											value: item.teamnm,
											tidx:item.tidx,
											team:item.team,
										}
									})
								);
							}
					   });
					},
				//조회를 위한 최소글자수
				minLength: 1,
				select: function( event, ui ) {
					mx.getTeamList(ui.item.tidx,'',ui.item.team);
				}
			});
		}

		if ( $("#player_nm").length > 0 ) {
			$( "#player_nm" ).autocomplete({
				source : function( request, response ) {

					switch (mx.pagenm) {
					case 'result.asp': mx.CMD_SEARCH = mx.CMD_GETFINDPLAYER;	break; //참가신청현황 ㅡㅡ파일명이 참...
					case 'gameresult.asp':
					case 'match-sch.asp': mx.CMD_SEARCH = mx.CMD_GETPLAYERTABLE; break;
					case 'gameorder.asp': mx.CMD_SEARCH = mx.CMD_GETPLAYERTABLE; break;
					case 'gameorder2.asp': mx.CMD_SEARCH = mx.CMD_GETPLAYERTABLE; break;
					}

					 $.ajax({
							type: mx.ajaxtype,
							url: mx.ajaxurl,
							dataType: "json",
							data: { "REQ" : JSON.stringify({"CMD":mx.CMD_SEARCH, "SVAL":request.term, "TIDX": $('#tidx').val(),"CDA": $('#CDA').val(),'DD':$('#selcMatchDate').val(),'AMPM':$('#ampm').val()})  },
							success: function(data) {
								//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
								console.log( px.strReplaceAll(JSON.stringify( data  ), '\"', '\"\"') );
								response(
									$.map(data, function(item) {
										return {
											label: item.unm + ' | ' + item.tnm,
											value: item.unm,
											tidx:item.tidx,
											pidx:item.pidx,
										}
									})
								);
							}
					   });
					},
				//조회를 위한 최소글자수
				minLength: 1,
				select: function( event, ui ) {
					switch (mx.pagenm) {
					case 'result.asp': mx.getAttMember(ui.item.tidx ,'' , ui.item.pidx);	break;
					case 'gameresult.asp': $('#sw_gametable').html('');mx.getPlayerResult(ui.item.tidx ,$('#CDA').val() , ui.item.pidx); break; //대회결과 선수조회
					case 'match-sch.asp': $('#sw_gametable').html('');mx.getMachPlayer(ui.item.tidx ,$('#CDA').val() , ui.item.pidx); break; //대진표

					case 'gameorder.asp':
					case 'gameorder2.asp': $('#sw_orderlist').html('');mx.getMachGameNo(ui.item.tidx ,$('#CDA').val() , ui.item.pidx, $('#selcMatchDate').val(), $('#ampm').val());break;
					}

				}
			});
		}
};






//클릭위치로 돌려놓기
$(document).ready(function(){
	mx.init();

	$('html, body').animate({scrollTop : localStorage.getItem('scrollpostion')}, 400);
	$(document).click(function(event){
		window.toriScroll = $(document).scrollTop();
		localStorage.setItem('scrollpostion',window.toriScroll);
		//console.log(window.toriScroll);
	});
});





////////////////////////////////////////////////////////////////////////////////////////////////////////
// radio, checkbox. id랑 for가 연결되게
function popupIdFor(idfor,no){
  return idfor+no;
}

// d-day 계산.  ex) dday=2019.03.19
function dDay(dday){
  let d_arr=dday.split(".");
  let current_day=new Date(),
      set_day=new Date(Number(d_arr[0]), Number(d_arr[1])-1, Number(d_arr[2])),
      gap=set_day.getTime()-current_day.getTime();
  let d_day=Math.ceil(gap/(60*1000*60*24));
  return d_day;
}

// : 추가
function addColon(txt){
  if(txt!=""){
    return ": "+txt;
  }
}

// 대회정보의 팝업 링크
function poplink(txt,len,tidx){
  if(txt=="appli"){// 참가신청
    if(len=="plan"){
      alert("참가신청 기간이 아닙니다.");
    }else if(len=="end"){
      alert("참가신청이 마감되었습니다.");
    }
  }else if(txt=="sketch"){// 현장스케치
    if(len==0 || len==undefined){
      alert("등록된 현장스케치 사진이 없습니다.");
    }else{
      location.href="../Result/stadium_sketch.asp?tidx="+tidx;
    }
  }else if(txt=="contestinfo"){// 대회일정
    location.href="../Result/contest_info.asp?tidx="+tidx;

  }else if(txt=="attinfo"){// 참가신청현황
    location.href="../Result/result.asp?tidx="+tidx;
  }else if(txt=="match"){//대진표
    location.href="../Result/match-sch.asp?tidx="+tidx;
  }else if(txt=="gameorder"){// 순서
      location.href="../Result/gameorder.asp?tidx="+tidx;
  }else if(txt=="gameresult"){// 결과/기록
      location.href="../Result/gameresult.asp?tidx="+tidx;
  }
}

//상단 종목 메인메뉴 URL
function chk_TOPMenu_URL(obj){
  switch(obj) {
    case 'badminton'  : $(location).attr('href', 'http://bmapp.sportsdiary.co.kr/badminton/M_player/page/institute-schedule.asp'); break;
    case 'judo'		: $(location).attr('href', 'http://judo.sportsdiary.co.kr/M_Player/Main/index.asp'); break;
    case 'tennis'   : $(location).attr('href', 'http://tennis.sportsdiary.co.kr/tennis/M_Player/main/index.asp'); break;
    case 'riding'  : $(location).attr('href', 'http://riding.sportsdiary.co.kr/m_player/main/index.asp'); break;
    case 'bike'     : $(location).attr('href', 'http://bike.sportsdiary.co.kr/bike/M_Player/main/index.asp'); break;
    case 'swim'     : $(location).attr('href', 'http://sw.sportsdiary.co.kr/main/index.asp'); break;
    default       	: $(location).attr('href', 'http://sdmain.sportsdiary.co.kr/sdmain/index.asp');
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
