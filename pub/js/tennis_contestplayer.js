var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_AUTOCOMPLETE = 100;

	mx.CMD_RESTOREPLAYER = 300; //복구
	mx.CMD_REFUND = 334;// 환불상태변경

	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_CONTESTAPPEND = 30000; //대회정보 더보기
	mx.CMD_GAMEINPUT = 30001;
	mx.CMD_GAMEINPUTEDIT = 30002; //수정
	mx.CMD_GAMEINPUTEDITOK = 30003;
	mx.CMD_GAMEINPUTDEL = 30004;// 삭제
	mx.CMD_FIND1 = 30005;
	mx.CMD_FIND2 = 30006;

	mx.CMD_GAMEAUTO = 30007;
	mx.CMD_FINDPLAYER = 30008;

	mx.CMD_DELPLAYER = 30009;
	mx.CMD_SETPLAYER = 30010;
	mx.CMD_REQUESTMANINFO = 30011;

	mx.CMD_PAYSTATE = 200;	//입금상태 변경
	mx.CMD_ATTDELMEMBERLIST = 31000; //참가신청취소 명단

	mx.CMD_RANKPOINT = 30011;


	mx.CMD_PLAYEREDITOK = 50001;

  mx.CMD_ACCTINFO =30027; //결제정보

    mx.CMD_REFUNDINFO = 301; //환불계좌정보 저장
  mx.CMD_REFUNDWIN = 30028; //관리자 결제자 취소시 정보입력
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

//동일한 패킷이 오는경우 (막음 처리해야겠지)
mx.ajaxurl = "/pub/ajax/reqTennisContestPlayer.asp";
mx.SendPacket = function( sender, packet){
	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = mx.ajaxurl;
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	//setTimeout( function(){ reqdone = true; }, timeout );

    //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
	//	apploading("AppBody", "로딩 중 입니다.");
	//}

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){
				//if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
				//	$('#AppBody').oLoader('hide');
				//}

				mx.ReceivePacket( reqcmd, mx.HttpData( xhr, datatype ), sender );
				return true;
			}
			xhr = null;
		}
	};
	console.log(JSON.stringify( packet  ) );
	xhr.send( strdata );
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
		switch (Number(jsondata.result))	{
		case 0:	break;
		case 1:	alert('데이터가 존재하지 않습니다.');return; 	break;
		case 2:	alert('이미 신청된 사용자가 있습니다.');return; 	break;
		case 3:	alert('등록되지 않은 선수가 존재합니다.');return; 	break;
		case 4:	alert('신청 내역이 존재하지 않습니다.');return; 	break;
		case 5:	alert('예선 등록 취소 후 선수를 변경할 수 있습니다.');return; 	break;

		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case mx.CMD_GAMEAUTO:
	case mx.CMD_GAMEINPUT:	this.OnBeforeHTML( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_CONTESTAPPEND:	this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_SETPLAYER:



	case mx.CMD_GAMEINPUTEDITOK:
	case mx.CMD_FINDPLAYER:
	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_DELPLAYER:
	case mx.CMD_GAMEINPUTDEL:	this.OndelHTML( reqcmd, jsondata, htmldata, sender );		break;

	case mx.CMD_RANKPOINT:
	case mx.CMD_ATTDELMEMBERLIST:
	case mx.CMD_REQUESTMANINFO: this.OnRequestManInfo( reqcmd, jsondata, htmldata, sender );		break;


	case mx.CMD_REFUNDWIN:
	case mx.CMD_ACCTINFO:this.OnModalUpdateMember( reqcmd, jsondata, htmldata, sender );   break;

	case mx.CMD_PAYSTATE: return; break;

	case mx.CMD_PLAYEREDITOK: 	this.OndrowHTML2( reqcmd, jsondata, htmldata, sender );		break;
	case mx.CMD_REFUND : 	alert('상태가 변경되었습니다.');location.reload();		break;
	case mx.CMD_RESTOREPLAYER: 	alert('복구되었습니다.');location.reload();		break;


	case mx.CMD_REFUNDINFO:this.OnChangeReload( reqcmd, jsondata, htmldata, sender ); break;
	}
};

mx.OnChangeReload =  function(cmd, packet, html, sender){
	//$("#reloadbtn").click();
	alert("적용 되었습니다."); //선수 교체 또는 신규팀등록
	//$('#Modaltest').modal('hide');
	location.reload();
};




mx.OnModalUpdateMember =  function(cmd, packet, html, sender){
  document.getElementById(sender).innerHTML = html;
  //mx.initPlayer(); //익스문제로 여기서하믄 안되욤...
  $('#'+sender).modal('show');
};

mx.OndrowHTML2 =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	alert("수정이 완료되었습니다.");
};


mx.OnRequestManInfo =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
};


////////////////////////////////////////////////
mx.delPlayer = function(lineidx,playeridx){
	var obj = {};
	obj.CMD = mx.CMD_DELPLAYER;
	obj.IDX = lineidx;
	obj.PIDX = playeridx;
	//mx.SendPacket('player_'+obj.IDX, obj);
	mx.SendPacket('titlelist_'+obj.IDX, obj);
};
mx.setPlayer = function(lineidx){
	var obj = {};
	obj.CMD = mx.CMD_SETPLAYER;
	obj.IDX = lineidx;
	mx.SendPacket('player_'+obj.IDX, obj);
};

mx.restorePlayer = function(lineidx){
	var obj = {};
	obj.CMD = mx.CMD_RESTOREPLAYER;
	obj.IDX = lineidx;
	mx.SendPacket('player_'+obj.IDX, obj);
};



////////////////////////////////////////////////

mx.OnPopClose= function(cmd, packet, html, sender){
	$(sender).modal('toggle');
};

mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if( cmd = mx.CMD_GAMEINPUTEDITOK  || cmd == mx.CMD_FINDPLAYER  ||  cmd == mx.CMD_GAMEINPUTEDIT ){
		mx.init();
	}
};

mx.OndelHTML =  function(cmd, packet, html, sender){
	$("#"+sender).remove();
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
	if( cmd == mx.CMD_GAMEAUTO && packet.AutoNo > 0){
		$("#autono").val(packet.AutoNo);
		mx.SendPacket(null, packet);
	}
};

mx.contestMore = function(idx){

	var moreinfo = localStorage.getItem('MOREINFO'); //다음

	if (moreinfo == null)	{
		var nextkey = 2;
	}
	else{
		moreinfo = JSON.parse(moreinfo);
		var nextkey = moreinfo.NKEY;
	}
	var parmobj = {'CMD':mx.CMD_CONTESTAPPEND,'NKEY':nextkey,"IDX":idx };
	parmobj.LevelNo = mx.gameinfo.LEVELNO;
	mx.SendPacket('contest', parmobj);
};



mx.auto_frm = function(boonm){
	var obj = {};
	obj.CMD = mx.CMD_GAMEAUTO;

	obj.AutoNo =	$("#autono").val();
	obj.TitleIDX = mx.gameinfo.IDX;
	obj.Title = mx.gameinfo.TITLE;
	obj.TeamIDX = mx.gameinfo.TEAMIDX;
	obj.LevelNo = mx.gameinfo.LEVELNO;
	obj.BOONM = boonm;

	mx.SendPacket(null, obj);
};

mx.entryListFilter = function(value){

	if(value == "Y") {
		value = 1
	}
	else if (value =="N") {
		value = 2
	}
	else{
		value = 0
	}

	var ref = "./contestplayer.asp?idx="+mx.gameinfo.IDX + "&teamidx=" + mx.gameinfo.TEAMIDX + "&entrylist=" + value;

	location.href=ref;

};


mx.input_frm = function(boonm){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUT;

	obj.TitleIDX = mx.gameinfo.IDX;
	obj.Title = mx.gameinfo.TITLE;
	obj.TeamIDX = mx.gameinfo.TEAMIDX;
	obj.LevelNo = mx.gameinfo.LEVELNO;
	obj.BOONM = boonm;

	obj.p1idx = $("#p1idx").val();
	obj.p1name = $("#p1name").val();
	obj.p1sex = $("#p1sex").val();
	obj.p1_birth = $("#p1_birth").val();
	obj.p1grade = $("#p1grade").val();
	obj.p1phone = $("#p1phone").val();
	obj.p1team1 = $("#p1team1").val();
	obj.p1team2 = $("#p1team2").val();
	obj.p1team1txt = $("#p1team1 option:selected").text();
	obj.p1team2txt = $("#p1team2 option:selected").text();

	obj.p2idx = $("#p2idx").val();
	obj.p2name = $("#p2name").val();
	obj.p2sex = $("#p2sex").val();
	obj.p2_birth = $("#p2_birth").val();
	obj.p2grade = $("#p2grade").val();
	obj.p2phone = $("#p2phone").val();
	obj.p2team1 = $("#p2team1").val();
	obj.p2team2 = $("#p2team2").val();
	obj.p2team1txt = $("#p2team1 option:selected").text();
	obj.p2team2txt = $("#p2team2 option:selected").text();

	obj.p1rpoint =  $("#p1rpoint").val();
	obj.p2rpoint =  $("#p2rpoint").val();

	if (obj.p1idx == "" || obj.p2idx == ""){
		alert("등록된 선수를 검색해 주세요.");
		return;
	}

	mx.SendPacket(null, obj);
};


mx.update_frm = function(boonm){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTEDITOK;
	obj.IDX		=	$("#attidx").val();

	if (obj.IDX	 == ''){
		alert("대상을 선택해 주세요.");
		return;
	}

	obj.TitleIDX = mx.gameinfo.IDX;
	obj.Title = mx.gameinfo.TITLE;
	obj.TeamIDX = mx.gameinfo.TEAMIDX;
	obj.LevelNo = mx.gameinfo.LEVELNO;
	obj.BOONM = boonm;
	obj.p1idx = $("#p1idx").val();
	obj.p1name = $("#p1name").val();
	obj.p1sex = $("#p1sex").val();
	obj.p1_birth = $("#p1_birth").val();
	obj.p1grade = $("#p1grade").val();
	obj.p1phone = $("#p1phone").val();
	obj.p1team1 = $("#p1team1").val();
	obj.p1team2 = $("#p1team2").val();
	obj.p1team1txt = $("#p1team1 option:selected").text();
	obj.p1team2txt = $("#p1team2 option:selected").text();
	obj.p2idx = $("#p2idx").val();
	obj.p2name = $("#p2name").val();
	obj.p2sex = $("#p2sex").val();
	obj.p2_birth = $("#p2_birth").val();
	obj.p2grade = $("#p2grade").val();
	obj.p2phone = $("#p2phone").val();
	obj.p2team1 = $("#p2team1").val();
	obj.p2team2 = $("#p2team2").val();
	obj.p2team1txt = $("#p2team1 option:selected").text();
	obj.p2team2txt = $("#p2team2 option:selected").text();

	obj.p1rpoint =  $("#p1rpoint").val();
	obj.p2rpoint =  $("#p2rpoint").val();

	mx.SendPacket('titlelist_'+obj.IDX, obj);

	if (obj.p1idx == "" || obj.p2idx == ""){
		alert("등록된 선수를 검색해 주세요.");
		return;
	}
};


mx.del_frm = function(){
	var obj = {};

	obj.CMD = mx.CMD_GAMEINPUTDEL;
	obj.IDX		=	$("#attidx").val();
	obj.TitleIDX = mx.gameinfo.IDX;
	obj.Title = mx.gameinfo.TITLE;
	obj.TeamIDX = mx.gameinfo.TEAMIDX;
	obj.LevelNo = mx.gameinfo.LEVELNO;

	if (obj.IDX	 == ''){
		alert("대상을 선택해 주세요.");
		return;
	}

	mx.SendPacket('titlelist_'+obj.IDX, obj);
};

mx.input_edit = function(idx){
	var obj = {};
	obj.CMD = mx.CMD_GAMEINPUTEDIT;
	obj.IDX = idx;
	obj.TitleIDX = mx.gameinfo.IDX;
	obj.Title = mx.gameinfo.TITLE;
	obj.TeamIDX = mx.gameinfo.TEAMIDX;
	obj.LevelNo = mx.gameinfo.LEVELNO;
	obj.temnm = mx.gameinfo.TEAMNM;
	obj.levelnm = mx.gameinfo.LEVELNM;

	localStorage.setItem('GAMEINFO', JSON.stringify( mx.gameinfo  ));
	mx.SendPacket('gameinput_area', obj);
};

mx.gameinfo;
$(document).ready(function(){
		localStorage.removeItem('MOREINFO');
		var gameinfo = localStorage.getItem('GAMEINFO');
		mx.gameinfo = JSON.parse(gameinfo);

		if (mx.gameinfo == '' || mx.gameinfo == null){ //바로들어왔을때 처리
			location.href="./contest.asp";
		}

		mx.init();
});

mx.init = function(){

    $( "#p1name" ).autocomplete({
		source : function( request, response ) {
			// alert("Sval" + request.term)
			// alert("TIDX" + mx.gameinfo.IDX)
			// alert("LIDX" + mx.gameinfo.LEVELNO)

			$.ajax(
				{
						type: 'post',
						url: "/pub/ajax/reqTennisContestPlayerFind.asp",
						dataType: "json",
						//request.term = $("#autocomplete").val()
						data: { "REQ" : JSON.stringify({"CMD":mx.CMD_AUTOCOMPLETE, "SVAL":request.term, "TIDX":mx.gameinfo.IDX,"LIDX":mx.gameinfo.LEVELNO}) },
						success: function(data) {
								//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                                console.log(data);
								response(
										$.map(data, function(item) {
                                        console.log(item);
												return {
														label: item.data + item.teamTitle,
														value: item.data,
														uidx:item.uidx,
														urpoint:item.urpoint
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
						// 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생 파인트 새로고침
			var obj = {};
			obj.CMD = mx.CMD_FINDPLAYER;
			obj.UIDX = ui.item.uidx;
			obj.URPOINT = ui.item.urpoint;
			obj.LevelNo = mx.gameinfo.LEVELNO;
			obj.Team1 = mx.gameinfo.team1;
			obj.Team2 = mx.gameinfo.team2;
			obj.player = 1;
			obj.TitleIDX = mx.gameinfo.IDX;
			obj.Title = mx.gameinfo.TITLE;
			obj.TeamIDX = mx.gameinfo.TEAMIDX;
			obj.temnm = mx.gameinfo.TEAMNM;
			obj.levelnm = mx.gameinfo.LEVELNM;
			mx.SendPacket('player1', obj);

        }
    });


	$( "#p2name" ).autocomplete({
		source : function( request, response ) {
             $.ajax({
                    type: 'post',
                    url: "/pub/ajax/reqTennisContestPlayerFind.asp",
                    dataType: "json",
                    //request.term = $("#autocomplete").val()
					data: { "REQ" : JSON.stringify({"CMD":mx.CMD_AUTOCOMPLETE, "SVAL":request.term, "TIDX":mx.gameinfo.IDX,"LIDX":mx.gameinfo.LEVELNO}) },
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
			obj.CMD = mx.CMD_FINDPLAYER;
			obj.UIDX = ui.item.uidx;
			obj.URPOINT = ui.item.urpoint;
			obj.LevelNo = mx.gameinfo.LEVELNO;
			obj.player = 2;
			obj.TitleIDX = mx.gameinfo.IDX;
			obj.Title = mx.gameinfo.TITLE;
			obj.TeamIDX = mx.gameinfo.TEAMIDX;
			obj.temnm = mx.gameinfo.TEAMNM;
			obj.levelnm = mx.gameinfo.LEVELNM;
			mx.SendPacket('player2', obj);
        }
    });
};


mx.requestManInfo = function(idx)
{
	var obj ={};
	obj.IDX = idx;
	obj.CMD = mx.CMD_REQUESTMANINFO;
	mx.SendPacket('myModal', obj);
};


mx.attDelList = function(tidx, levelno)
{
	var obj ={};
	obj.TIDX = tidx;
	obj.KEY3 = levelno;
	obj.CMD = mx.CMD_ATTDELMEMBERLIST;
	mx.SendPacket('myModal', obj);
};



mx.payCheck = function(idx){
	var obj ={};
	obj.IDX = idx;
   if ( $("#paystate_"+idx).is(":checked") == true ) {
	   obj.CHK = 'Y';
   }
   else{
		obj.CHK = 'N';
   }
	obj.CMD = mx.CMD_PAYSTATE;
	mx.SendPacket('paystate_'+idx, obj);
};

/////////////////////////////////////////////////
mx.RankingPoint = function(idx, name,tidx,levelno,ptype){
	mx.ajaxurl = "/pub/ajax/reqTennisMakePlayer.asp";
	var obj = {};
	obj.CMD = mx.CMD_RANKPOINT;
	obj.IDX = idx;

	obj.LEVELNO = mx.gameinfo.LEVELNO;
	obj.TIDX = mx.gameinfo.IDX;
	obj.TITLE = mx.gameinfo.TITLE;
	obj.PTYPE = ptype; //player1,2 구분용
	obj.NAME = name;
	mx.SendPacket('myModal', obj);
	mx.ajaxurl = "/pub/ajax/reqTennisContestPlayer.asp";
};


mx.playeredit = function(pidx,tidx,levelno,ptype){
	mx.ajaxurl = "/pub/ajax/reqTennisMakePlayer.asp";
	var obj = {};
	obj.CMD = mx.CMD_PLAYEREDITOK;

	obj.pidx = pidx;
	obj.tidx = tidx;
	obj.levelno = levelno;
	if (!ptype) {
		obj.ptype = 1;
	} else {
		obj.ptype = ptype;
	}
	obj.pname = $("#u_name").val();
	obj.boo = $("#u_boo").val();
	obj.psex = $("#u_sex").val();

	obj.pbirth = $("#u_birth").val();
	obj.phone = $("#u_phone").val();

	obj.pteam1 = $("#u_team1nm").val();
	obj.pteam2 = $("#u_team2nm").val();


	mx.SendPacket('rankplayerinfo', obj);
	mx.ajaxurl = "/pub/ajax/reqTennisContestPlayer.asp";
};

mx.reFund = function(ridx){
  if (!confirm("환불 상태를 변경하시겠습니까?")) {
	return;
  }
	var obj ={};
	obj.ridx = ridx;
	obj.CMD = mx.CMD_REFUND;
	mx.SendPacket('myModal', obj);


};



mx.AcctInfo = function (idx,tidx,levelno){
  mx.ajaxurl = "/pub/ajax/reqTennisAcct.asp";
  mx.tidx = tidx;
  mx.levelno = levelno;
  var obj ={};
  obj.IDX = idx;
  obj.CMD = mx.CMD_ACCTINFO;
  mx.SendPacket("Modaltest", obj);
  mx.ajaxurl = "/pub/ajax/reqTennisContestPlayer.asp";
};


//환불정보창
mx.refundWin = function (ridx,midx){
  mx.ajaxurl = "/pub/ajax/reqTennisAcct.asp";
  var obj ={};
  obj.RIDX = ridx;
  obj.MIDX = midx;
  obj.CMD = mx.CMD_REFUNDWIN;
  mx.SendPacket("Modaltest", obj);
  mx.ajaxurl = "/pub/ajax/reqTennisContestPlayer.asp";
};

mx.chek_form_pass_data = function() {
  var ridx = $("#req_idx").val();
  var midx = $("#m_idx").val();
  var uname = $("#inbankname").val();
  var ubank =  $("#inbank").val();
  var uacct =  $("#inbankacc").val();

   if (!uname) { alert("이름을 입력해 주십시오."); $("#inbankname").focus(); return; }
   if (!ubank) { alert("은행명을 입력해 주십시오."); $("#inbank").focus(); return; }
   if (!uacct) { alert("환불계좌를 입력해 주십시오."); $("#inbankacc").focus(); return; }

	var obj = {};
	obj.CMD = mx.CMD_REFUNDINFO;
	obj.ridx = ridx;
	obj.midx = midx;
	obj.uname = uname;
	obj.ubank = ubank;
	obj.uacct = uacct;
	mx.SendPacket(null, obj);


};
