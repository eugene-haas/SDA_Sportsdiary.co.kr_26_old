var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_AUTOCOMPLETE = 100;
  mx.CMD_AUTOCOMPLETEALL = 110;

  mx.CMD_DATAGUBUN = 10000;

  mx.CMD_FINDBOODETAIL = 11000; //부세부종목 불러오기

  mx.CMD_SETVAL = 100;
  mx.CMD_UIINPUT = 201;
  mx.CMD_GAMEINPUT = 301;
  mx.CMD_GAMEINPUTEDIT = 30002;
  mx.CMD_GAMEINPUTEDITOK = 303;
  mx.CMD_GAMEINPUTDEL = 304;
  mx.CMD_LINEDEL = 305;

  mx.CMD_FINDTEAM = 30008;

////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqQA.asp";
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
   case mx.CMD_SETVAL: return; break;

    case mx.CMD_FINDBOODETAIL:  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;

	case mx.CMD_LINEDEL:
	case mx.CMD_UIINPUT:
	case mx.CMD_GAMEINPUTDEL:
	case mx.CMD_GAMEINPUTEDITOK: 
	case mx.CMD_GAMEINPUT:	window.location.reload();	break;

	case mx.CMD_GAMEINPUTEDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
  }
};


//요청##################################################################
	mx.input_frm = function(lastno){

		var obj = {};
		obj.CMD = mx.CMD_GAMEINPUT;
		mx.SendPacket(null, obj);
	};

	mx.input_ui = function(idx){
		var obj = {};
		obj.CMD = mx.CMD_UIINPUT;
		obj.IDX = idx;
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

	mx.delLine= function(idx){
		var obj = {};
		obj.CMD = mx.CMD_LINEDEL;
		obj.IDX =	idx;

		if (confirm('대상을 삭제하시겠습니까?')) {
			mx.SendPacket(null, obj);
		} else {
			return;
		}
	};




	mx.setVal = function(inid,invalue){
		var obj = {};
		obj.CMD = mx.CMD_SETVAL;
		obj.DOMID = inid;
		obj.CLUMN = inid.split("_")[0] ;
		obj.IDX =  inid.split("_")[1] ;
		obj.INVAL = invalue;
		mx.SendPacket(null, obj);			
	};

//응답##################################################################


mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
};

$(document).ready(function(){

});


////////////////////////////////////////////////////////////////


//클릭위치로 돌려놓기
$(document).ready(function(){

        //var offset = $("#div" + seq).offset();
        $('html, body').animate({scrollTop : localStorage.getItem('scrollpostion')}, 400);
//document.body

//	$(document).scrollTop(localStorage.getItem('scrollpostion'));

	$(document).click(function(event){
		window.toriScroll = $(document).scrollTop();
		localStorage.setItem('scrollpostion',window.toriScroll);
		console.log(window.toriScroll);
	});
});


//$(window).scroll(function(){
//	var height = $(document).scrollTop();
//});
