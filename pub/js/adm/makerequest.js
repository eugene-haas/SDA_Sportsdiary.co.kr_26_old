var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_DATAGUBUN = 10000;
	mx.CMD_MAKEJSON = 100;
	mx.CMD_INPUT = 200;
	mx.CMD_SELECTTBL = 300; //테이블검색쿼리 가져오기

	mx.CMD_INPUTEDIT = 20000;
////////////////////////////////////////

mx.ajaxurl = "/pub/ajax/adm/reqJson.asp";
mx.ajaxtype = "POST";
mx.dataType = "text";


mx.SendPacket = function( sender, packet){
    console.log( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
	//var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var strdata = "REQ=" + encodeURIComponent( px.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
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


mx.ReceivePacket = function( reqcmd, data, sender ){
  var jsondata = null;
  var htmldata = null;
  var resdata = null;

  if ( Number(reqcmd) > mx.CMD_DATAGUBUN  ){
    if ( data.indexOf("`##`") !== -1 ){//json + html
      resdata = data.split( "`##`" );
      jsondata =  resdata[0];
      if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
        htmldata = resdata[1];
    }
    else{ //html
      htmldata = data;
    }
  }
  else{//json
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( jsondata !='' && jsondata != null){
		//case 2:	mx.splashmsg('동일한 내용이 존재 합니다.',1500);return; 	break;
		switch (Number(jsondata.result)){
		case 0: break;
		case 1: alert('데이터가 존재하지 않습니다.');return;  break;
		case 100: return;   break; //메시지 없슴
		}
  }

	if (sender == "inputurltype"){
		//console.log(data);

	  if ( Number(reqcmd) > mx.CMD_DATAGUBUN  ){ //html 형태..
		  htmldata = data;
		  $('#mk_g3').val(htmldata);
	  }
	  else{//json
		if(typeof data == 'string'){jsondata = JSON.parse(data);}
		else{jsondata = data;}
		var jsonPrint = JSON.stringify(jsonData,null, 4);
		  $('#mk_g3').val(jsonPrint);
	  }

	  

	}
	else{
		switch (Number(reqcmd))	{
		case mx.CMD_SELECTTBL : this.OnQuery( reqcmd, jsondata, htmldata, sender );    break;
		case mx.CMD_INPUTEDIT:  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;

		case mx.CMD_INPUT : location.reload(); break;
		case mx.CMD_MAKEJSON:	this.OnReqJSON( reqcmd, jsondata, htmldata, sender );		break;
		}
	}

};

//request function////////////////////////////////////////////
mx.OnQuery =  function(cmd, packet, html, sender){
	console.log(packet.Q);
	mx.setLine(packet.Q);
};

mx.OnReqJSON = function(cmd, packet, html, sender){
	var jsonDataVal = packet.reqjson;
	var jsonData = JSON.parse	(jsonDataVal);
	var jsonPrint = JSON.stringify(jsonData,null, 4);
	$('#'+sender).val(jsonPrint);
};


mx.OnAppendHTML =  function(cmd, packet, html, sender){
	if ( packet.NO == "_end" ){return;}

	$('#'+sender).append(html);
	$("#sc_body").scrollTop($("#sc_body")[0].scrollHeight);
	mx.SendPacket('listcontents', packet);
};


mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if(cmd == mx.CMD_INPUTEDIT){
		mx.setLine($('#mk_g2').val());
		mx.getJson();
	}
};






//response.ajax //////////////////////////////////////////////
mx.selectTbl = function(){ //테이블 검색해서 기본쿼리 가져오기
	var obj = {};
	obj.CMD = mx.CMD_SELECTTBL;
	obj.tblnm = $('#selectTabelList').val();
	mx.SendPacket(null, obj);	
};

mx.getJson = function(){

	if (px.chkValue($('#mk_g1').val(), "입력값을 넣어  ") == false){
		return;
	}

	var packet=  JSON.parse($('#mk_g1').val());
	var querystr = $('#mk_g2').val().toLowerCase();

	packet.Q = px.strReplaceAll(px.strReplaceAll(querystr,'\n',' '), '\t',' ');

	packet.CMD = mx.CMD_MAKEJSON;
	packet.LINECNT = $('#mk_g0').val();

	$("#mk_g2").val(querystr);
	mx.SendPacket('mk_g3', packet);	
};

mx.getUrlJson = function(){

	if (px.chkValue($('#mk_g1').val(), "입력값을 넣어  ") == false){
		return;
	}

	var packet=  JSON.parse($('#mk_g1').val());
	var requrl = $('#mk_g2_2').val().toLowerCase();
	mx.SendPacketEx('inputurltype', packet, requrl);	 //mk_g3
};



mx.input_frm = function(){
	var obj = {};
	obj.CMD = mx.CMD_INPUT;

	obj.mx_0 = $("#F1").val(); //db
	obj.mx_1 = $("#mk_g0").val(); //라인수
	obj.mx_2 = $("#mk_g1").val(); //입력
	
	if( $("#inputdiv1").css("display") != "none" ) {   
		obj.mx_3 = px.strReplaceAll(px.strReplaceAll($("#mk_g2").val(),'\n',''), '\t',''); // 쿼리
	}
	else{
		obj.mx_3 = $("#mk_g2").val();
	}


	obj.mx_4 = px.strReplaceAll(px.strReplaceAll($("#mk_g3").val(),'\n',''), '\t',''); //아웃풋
	obj.mx_5 = $("#mk_g4").val();
	obj.mx_6 = $("#mk_g5").val();

	obj.CNT = 7;

	if (px.chkValue(obj.mx_2, "입력값을 넣어 ") == false){
		return;
	}

	if (px.chkValue(obj.mx_3, "입력값을 넣어 ") == false ){
		return;
	}

	if (px.chkValue(obj.mx_4, "전송 후 출력값을 생성해 ") == false){
		return;
	}
	if (px.chkValue(obj.mx_5, "제목을 입력해 ") == false){
		return;
	}
	if (px.chkValue(obj.mx_6, "사용 URL을 입력해 ") == false){
		return;
	}

	//console.log(obj);
	
	mx.SendPacket('contest', obj);
};


//불러오기
mx.input_edit = function(idx){
	var obj = {};
	obj.CMD = mx.CMD_INPUTEDIT;
	obj.IDX = idx;
	mx.SendPacket('gameinput_area', obj);
};


//utill //////////////////////////////////////////////////////////////
mx.setLine = function(instr){

   if(instr != '' && instr.indexOf("\n") == -1 ) {
		instr = px.strReplaceAll(instr.toLowerCase(), 'select', 'select\n\t' );
		instr = px.strReplaceAll(instr.toLowerCase(), 'from', '\nfrom\n\t' );
		instr = px.strReplaceAll(instr.toLowerCase(), 'where', '\nwhere\n\t' );
		instr = px.strReplaceAll(instr.toLowerCase(), 'order by ', '\norder by\n\t' );
		instr = px.strReplaceAll(instr.toLowerCase(), 'group by ', '\ngroup by\n\t' );
		$("#mk_g2").val(instr);

   }
};

mx.makeJson = function(instr){

   if(instr != '' && instr.indexOf(":") == -1 ) {
		// 배열을 선언한다.
		var dataArr = new Array();
		var arrval = "";
		
		// 객체 생성
		var dataObj = new Object();
		arrval = instr.split(",");
		for (var i = 0; i < arrval.length ;i++ )
		{
			 eval("dataObj.mx_"+i+" = arrval["+i+"]" );
		}

		dataObj.CNT = i; //param count
		// 배열 생성된 객체 삽입
		//dataArr.push(dataObj) ;

		// json 형태의 문자열로 만든다.
		var jsonData = JSON.stringify(dataObj);
		$("#mk_g1").val(jsonData);
		console.log(jsonData);
   }
};

mx.tabInput = function(tabno){
		$('#inputtab1').attr('class','btn btn-default');
		$('#inputtab2').attr('class','btn btn-default');
		$('#inputtab' + tabno).attr('class','btn btn-primary');

		$('#inputdiv1').hide();
		$('#inputdiv2').hide();
		$('#inputdiv' + tabno).show();


	if (tabno == 1)	{

	}
	else{

	}
};