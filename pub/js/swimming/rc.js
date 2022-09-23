var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;

  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_FINDBOODETAIL = 11000; //부세부종목 불러오기

  mx.CMD_GAMEINPUT = 301;
  mx.CMD_GAMEINPUTEDIT = 30002;
  mx.CMD_GAMEINPUTEDITOK = 303;
  mx.CMD_GAMEINPUTDEL = 304;

  mx.CMD_FINDTEAM = 30009;
  mx.CMD_FINDPLAYER = 30008;
  mx.CMD_FINDBOO = 11001; //부
  mx.CMD_GETLIST = 310000; //목록불러오기
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqRC.asp";
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
    case 2: alert('동일한 데이터가 존재합니다.');return;  break;
    case 3: alert('참가신청 자가 있어 수정및 삭제가 불가능 합니다.');return;  break;
    case 100: return;   break; //메시지 없슴
	/*새로고침*/
	if ( $("#tryouting").length > 0 ) { $('#tryouting').click();}
	if ( $("#tourning").length > 0 ) { $('#tourning').click();}
	return;   break;

	}
  }

  switch (Number(reqcmd)) {
	case mx.CMD_FINDBOO:
	case mx.CMD_GETLIST:	
	case mx.CMD_FINDBOODETAIL:  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;

	case mx.CMD_GAMEINPUTDEL:
	case mx.CMD_GAMEINPUTEDITOK: 
	case mx.CMD_GAMEINPUT:	 $('#getlist').click(); 	break; //리스트 생성 가져오기 버튼 클릭

	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
  }
};


//요청##################################################################
	mx.input_frm = function(lastno){

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUT;
		//종목 개인[단체] 성별 부서 세부종목
		obj.PARR = new Array();

		var allidarr = [];
		for (var x = 0;x < lastno ;x++ ){
			allidarr[x] = "mk_g" + x;
		}
		
		
		//단체
		if ($('#mk_g11').val() == 'T'){
			obj.KSKEY2 = $('#kskey2').val();
			obj.KSKEY3 = $('#kskey3').val();
			obj.KSKEY4 = $('#kskey4').val();

			obj.PIDX2 = $('#pidx2').val();
			obj.PIDX3 = $('#pidx3').val();
			obj.PIDX4 = $('#pidx4').val();

			obj.UNM2 = $('#unm2').val();
			obj.UNM3 = $('#unm3').val();
			obj.UNM4 = $('#unm4').val();
		}



		var chkboxidarr = []; //체크박스의 아이디들
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
		
		var msgarr = [];
		for (var x = 0;x < lastno ;x++ ){
			msgarr[x] = "";
		}
		//체크할항목
		msgarr[0] = "대회코드를 입력해 ";
		msgarr[1] = "대회명을 입력해 ";
		msgarr[2] = "장소를 입력해 ";
		msgarr[3] = "수립일을 입력해 ";
		msgarr[4] = "이름을 입력해 ";
		msgarr[5] = "소속을 입력해 ";
		msgarr[7] = "기록을 입력해 ";
		msgarr[8] = "순위를 입력해 ";
		msgarr[16] = "팀을 검색한후 선택해 ";
		msgarr[17] = "선수명을 검색한후 선택해 ";

		var passarrno = []; //체크메시지 통과여부 플레그 0패스 1체크
		for (var x = 0;x < lastno ;x++ ){
			passarrno[x] = 0;
		}
		//체크할항목
		passarrno[0] = 1;
		passarrno[1] = 1;
		passarrno[2] = 1;
		passarrno[3] = 1;
		passarrno[4] = 1;
		passarrno[5] = 1;
		passarrno[7] = 1;
		passarrno[8] = 1;
		passarrno[16] = 1;
		passarrno[17] = 1;

		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					return;
				}
			}
		}

//		if( $('#mk_g17').val() == ''){
//			alert('선수명을 검색한후 선택해 주십시오.');
//			return;
//		}
//		if( $('#mk_g16').val() == ''){
//			alert('팀을 검색한후 선택해 주십시오.');
//			return;
//		}


		mx.SendPacket(null, obj);
	};


	mx.input_select = function(idx){
		$( "#contest tr").css( "background-color", "white" );
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" );
	};



	mx.input_edit = function(idx){
		$( "#contest tr").css( "background-color", "white" );
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" );

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDIT;
		obj.IDX = idx;
		mx.SendPacket('gameinput_area', obj);
	};

	mx.update_frm = function(lastno){
		if($('#e_idx').val() ==  undefined ){
			alert("목록에서 대상을 선택해 주세요.");
			return;
		}

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTEDITOK;
		//종목 개인[단체] 성별 부서 세부종목
		obj.PARR = new Array();

		var allidarr = [];
		for (var x = 0;x < lastno ;x++ ){
			allidarr[x] = "mk_g" + x;
		}
		allidarr[x] = "e_idx";

		//단체
		if ($('#mk_g11').val() == 'T'){
			obj.KSKEY2 = $('#kskey2').val();
			obj.KSKEY3 = $('#kskey3').val();
			obj.KSKEY4 = $('#kskey4').val();

			obj.PIDX2 = $('#pidx2').val();
			obj.PIDX3 = $('#pidx3').val();
			obj.PIDX4 = $('#pidx4').val();

			obj.UNM2 = $('#unm2').val();
			obj.UNM3 = $('#unm3').val();
			obj.UNM4 = $('#unm4').val();
		}



		var chkboxidarr = []; //체크박스의 아이디들
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
		
		var msgarr = [];
		for (var x = 0;x < lastno ;x++ ){
			msgarr[x] = "";
		}
		//체크할항목
		msgarr[0] = "대회코드를 입력해 ";
		msgarr[1] = "대회명을 입력해 ";
		msgarr[2] = "장소를 입력해 ";
		msgarr[3] = "수립일을 입력해 ";
		msgarr[4] = "이름을 입력해 ";
		msgarr[5] = "소속을 입력해 ";
		msgarr[7] = "기록을 입력해 ";
		msgarr[8] = "순위를 입력해 ";
		msgarr[16] = "팀을 검색한후 선택해 ";
		msgarr[17] = "선수명을 검색한후 선택해 ";

		var passarrno = []; //체크메시지 통과여부 플레그 0패스 1체크
		for (var x = 0;x < lastno ;x++ ){
			passarrno[x] = 0;
		}
		//체크할항목
		passarrno[0] = 1;
		passarrno[1] = 1;
		passarrno[2] = 1;
		passarrno[3] = 1;
		passarrno[4] = 1;
		passarrno[5] = 1;
		passarrno[7] = 1;
		passarrno[8] = 1;
		passarrno[16] = 1;
		passarrno[17] = 1;


		for (var i = 0;i< obj.PARR.length ;i++ ){
			if (passarrno[i] == 1){
				if (px.chkValue(obj.PARR[i], msgarr[i]) == false){
					$("#"+allidarr[i]).focus();
					return;
				}
			}
		}
		mx.SendPacket(null, obj);
	};


	mx.del_frm = function(){
		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUTDEL;
		obj.IDX =	$("#e_idx").val();

		if (obj.IDX == undefined){
			alert("목록에서 대상을 선택해 주세요.");
			return;
		}

		if (confirm('대상을 삭제하시겠습니까?')) {
			mx.SendPacket('titlelist_'+obj.IDX, obj);
		} else {
			return;
		}
	};





	mx.dateChange = function(dateval){
		if (datestr.length == 8 ){
			var datestr = dateval.substring(0,4) + "/" + dateval.substring(5,2) + "/" + dateval.substring(7,2);
			$('#mk_g3').val(datestr);
		}
	};


	mx.init = function(){
		$('#mk_g3').datepicker({format: 'yyyy-mm-dd',locale:'KO',autoclose: true});	


			$( "#mk_g4" ).autocomplete({
				source : function( request, response ) {

					 $.ajax({
							type: mx.ajaxtype,
							url: mx.ajaxurl,
							dataType: "json",
							data: { "REQ" : JSON.stringify({"CMD":mx.CMD_FINDPLAYER, "SVAL":request.term})  },
							success: function(data) {
								//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
								console.log( px.strReplaceAll(JSON.stringify( data  ), '\"', '\"\"') );
								response(
									$.map(data, function(item) {
										return {
											label: item.username + ' '  + item.teamnm + ' (' + item.userclass + ') ' + item.birthday,
											value: item.username,
											team:item.teamnm,
											pidx:item.playeridx,
											teamcode:item.team,
											kskey:item.kskey,
											uclass:item.userclass,
											sex:item.sex,
											sido:item.sido,
											sidocode:item.sidocode
										}
									})
								);
							}
					   });
					},
				//조회를 위한 최소글자수
				minLength: 2,
				select: function( event, ui ) {
					// 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생
					$('#mk_g15').val(ui.item.kskey);
					$('#mk_g16').val(ui.item.teamcode);
					$('#mk_g17').val(ui.item.pidx);

					$('#mk_g18').val(ui.item.sex);
					$('#mk_g19').val(ui.item.sido);
					$('#mk_g20').val(ui.item.sidocode);

					$('#mk_g5').val(ui.item.team);
					//$('#mk_g6').val(ui.item.uclass).prop("selected",true); 현재선수의 학년정보는 안불러오도록 요청(김정연)

				}
			});

			//####################단체
				$( "#unm2" ).autocomplete({
					source : function( request, response ) {

						 $.ajax({
								type: mx.ajaxtype,
								url: mx.ajaxurl,
								dataType: "json",
								data: { "REQ" : JSON.stringify({"CMD":mx.CMD_FINDPLAYER, "SVAL":request.term})  },
								success: function(data) {
									//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
									console.log( px.strReplaceAll(JSON.stringify( data  ), '\"', '\"\"') );
									response(
										$.map(data, function(item) {
											return {
												label: item.username + ' '  + item.teamnm + ' ' + item.userclass,
												value: item.username,
												team:item.teamnm,
												pidx:item.playeridx,
												teamcode:item.team,
												kskey:item.kskey,
												uclass:item.userclass,
												sex:item.sex,
												sido:item.sido,
												sidocode:item.sidocode
											}
										})
									);
								}
						   });
						},
					//조회를 위한 최소글자수
					minLength: 2,
					select: function( event, ui ) {
						// 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생
						$('#kskey2').val(ui.item.kskey);
						$('#pidx2').val(ui.item.pidx);
					}
				});


				$( "#unm3" ).autocomplete({
					source : function( request, response ) {

						 $.ajax({
								type: mx.ajaxtype,
								url: mx.ajaxurl,
								dataType: "json",
								data: { "REQ" : JSON.stringify({"CMD":mx.CMD_FINDPLAYER, "SVAL":request.term})  },
								success: function(data) {
									//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
									console.log( px.strReplaceAll(JSON.stringify( data  ), '\"', '\"\"') );
									response(
										$.map(data, function(item) {
											return {
												label: item.username + ' '  + item.teamnm + ' ' + item.userclass,
												value: item.username,
												team:item.teamnm,
												pidx:item.playeridx,
												teamcode:item.team,
												kskey:item.kskey,
												uclass:item.userclass,
												sex:item.sex,
												sido:item.sido,
												sidocode:item.sidocode
											}
										})
									);
								}
						   });
						},
					//조회를 위한 최소글자수
					minLength: 2,
					select: function( event, ui ) {
						// 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생
						$('#kskey3').val(ui.item.kskey);
						$('#pidx3').val(ui.item.pidx);
					}
				});

				$( "#unm4" ).autocomplete({
					source : function( request, response ) {

						 $.ajax({
								type: mx.ajaxtype,
								url: mx.ajaxurl,
								dataType: "json",
								data: { "REQ" : JSON.stringify({"CMD":mx.CMD_FINDPLAYER, "SVAL":request.term})  },
								success: function(data) {
									//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
									console.log( px.strReplaceAll(JSON.stringify( data  ), '\"', '\"\"') );
									response(
										$.map(data, function(item) {
											return {
												label: item.username + ' '  + item.teamnm + ' ' + item.userclass,
												value: item.username,
												team:item.teamnm,
												pidx:item.playeridx,
												teamcode:item.team,
												kskey:item.kskey,
												uclass:item.userclass,
												sex:item.sex,
												sido:item.sido,
												sidocode:item.sidocode
											}
										})
									);
								}
						   });
						},
					//조회를 위한 최소글자수
					minLength: 2,
					select: function( event, ui ) {
						// 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생
						$('#kskey4').val(ui.item.kskey);
						$('#pidx4').val(ui.item.pidx);
					}
				});

			//####################단체



			//####################################
		   $( "#mk_g5" ).autocomplete({
				source : function( request, response ) {

					 $.ajax({
							type: mx.ajaxtype,
							url: mx.ajaxurl,
							dataType: "json",
							data: { "REQ" : JSON.stringify({"CMD":mx.CMD_FINDTEAM, "SVAL":request.term})  },
							success: function(data) {
								//서버에서 json 데이터 response 후 목록에 뿌려주기 위함
								console.log( px.strReplaceAll(JSON.stringify( data  ), '\"', '\"\"') );
								response(
									$.map(data, function(item) {
										return {
											label: item.teamnm + '(성별:'+item.sexno+') 등록:' + item.teamregdt  ,
											value: item.teamnm,
											sido:item.sido,
											team:item.team,
											cda:item.sexno,
											cdanm:item.teamregdt

										}
									})
								);
							}
					   });
					},
				//조회를 위한 최소글자수
				minLength: 2,
				select: function( event, ui ) {
					// 만약 검색리스트에서 선택하였을때 선택한 데이터에 의한 이벤트발생
					$('#mk_g16').val(ui.item.team );
				}
			});

	
	};





	mx.setTeamGb = function(){
		var obj = {};
		obj.CMD = mx.CMD_FINDBOODETAIL;
		obj.GBCD =$('#mk_g10').val();
		mx.SendPacket('boodetail', obj);
	};

	mx.setBoo = function(){
		var obj = {};
		obj.CMD = mx.CMD_FINDBOO;
		obj.SEXNO =$('#mk_g12').val();
		mx.SendPacket('boo', obj);
	};


	mx.getlist = function(domid){
		var obj = {};
		obj.CMD = mx.CMD_GETLIST;
		mx.SendPacket(domid, obj);
	};

	mx.setPGtype = function(){
		if( $('#mk_g11').val() == 'I'){
			$('#teammember').hide();
			var obj = {};
			obj.CMD = mx.CMD_FINDBOODETAIL;
			obj.GBCD =$('#mk_g10').val();
			obj.ITGUBUN = "I";
			mx.SendPacket('boodetail', obj);
		}
		else{
			$('#teammember').show();		
			var obj = {};
			obj.CMD = mx.CMD_FINDBOODETAIL;
			obj.GBCD =$('#mk_g10').val();
			obj.ITGUBUN = "T";
			mx.SendPacket('boodetail', obj);


		}
	};
//응답##################################################################


mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if (cmd == mx.CMD_GAMEINPUTEDIT ){
		mx.init();
	}
};

$(document).ready(function(){
		mx.init();
});


////////////////////////////////////////////////////////////////


