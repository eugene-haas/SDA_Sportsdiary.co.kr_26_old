var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;

  
  mx.CMD_PAYCANCEL = 500;
  mx.CMD_SETOK = 550;
  mx.CMD_ATTINFO = 12000;
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/swimming/reqPaymanage.asp";
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
   case mx.CMD_SETOK : return; break;
   case mx.CMD_PAYCANCEL:	window.location.reload();	break;
  case mx.CMD_ATTINFO:  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );    break;
  }
};


//요청##################################################################
   mx.cancelOK = function(orderidx){
      if (confirm('취소요청을 완료하시겠습니까?')) {
         var obj = {};
         obj.CMD = mx.CMD_PAYCANCEL;
		 obj.OIDX = orderidx;
         mx.SendPacket(null, obj);
		} else {
			return;
		}
   };


   mx.attInfo = function(orderidx){
      var obj = {};
	  obj.CMD = mx.CMD_ATTINFO;
      obj.OIDX = orderidx;
	  mx.SendPacket(null, obj);
   };

   mx.SetOK = function(okid , okno){
	  var  okvalue = 0;
	  if(okno == 1){

		  if( $('#'+okid+'_1').attr('class') == 'btn btn-default')
			  { 
				  okvalue = 1;
				  $('#'+okid+'_1').attr('class','btn btn-primary');
				  $('#'+okid+'_2').attr('class','btn btn-default'); 
			  }
		  else
			  { 
				  $('#'+okid+'_1').attr('class','btn btn-default');
				  $('#'+okid+'_2').attr('class','btn btn-primary'); 
			  }
	  }
	  else {

		  if( $('#'+okid+'_2').attr('class') == 'btn btn-default')
			  { 
				  $('#'+okid+'_2').attr('class','btn btn-primary');
				  $('#'+okid+'_1').attr('class','btn btn-default');
			  }
		  else
			  { 
				  okvalue = 1;
				  $('#'+okid+'_2').attr('class','btn btn-default');
				  $('#'+okid+'_1').attr('class','btn btn-primary');
			  }
	  }

	  var obj = {};
	  obj.CMD = mx.CMD_SETOK;
	  obj.SEQ = okid;
	  obj.OK = okvalue;
	  mx.SendPacket(null, obj);
   };







//응답##################################################################

mx.OndrowHTML =  function(cmd, packet, html, sender){
	if(cmd == mx.CMD_ATTINFO ){
		if( $('#modalB').length == 0 ){
			$('body').append("<div id='modalB' class='modal fade basic-modal' data-backdrop='static' role='dialog' aria-labelledby='myModalLabel'></div>");
		}
		document.getElementById("modalB").innerHTML = html;
		$('#modalB').modal('show');		
	}
	else{
		document.getElementById(sender).innerHTML = html;	
	}
};



$(document).ready(function(){
		//mx.init();
});


////////////////////////////////////////////////////////////////
