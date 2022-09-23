var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;
  mx.CMD_SETRELOAD = 100;
  mx.CMD_CRAPENO = 101;
  mx.CMD_SETPRICE = 200;

  mx.CMD_SETPOINTWIN = 20000;
  mx.CMD_SETPOINT = 300;
  mx.CMD_EDIT = 50002; //내용불러오기
////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/reqresult.asp";
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
    case 12: alert('상장번호가 마지막 번호보다 작습니다.');return;  break;
    case 100: return;   break; //메시지 없슴
    }
  }

  switch (Number(reqcmd)) {
  case mx.CMD_CRAPENO: 
  case mx.CMD_SETRELOAD :	location.reload(); return;
	break;

  case mx.CMD_SETPRICE:    this.OnPrice( reqcmd, jsondata, htmldata, sender );    break;//장애물기준및 배치정보 내용 입력
  case mx.CMD_SETPOINTWIN:    this.OnPointwin( reqcmd, jsondata, htmldata, sender );    break;
  case mx.CMD_SETPOINT:    this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );    break;

	case mx.CMD_EDITOK:
	case mx.CMD_EDIT:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;  
  }
};


	mx.input_edit = function(idx, el){
		$( "#listcontents tr").css( "background-color", "white" );  
		$( "#titlelist_" + idx ).css( "background-color", "#BFBFBF" ); 

		var children=el.children();
		for(var i=0;i<children.length;i++){
			//console.log(children[i].innerText);
			switch(i){
			case 2 : $('#c_info0').html($('#crape_'+idx).val()); break;
			case 1 : $('#c_info1').html('상장'); break;
			case 3 : $('#c_info2').html(children[i].innerText); break;
			case 11 : $('#c_info3').html(children[i].innerText); break;
			case 14 : $('#c_info4').html(children[i].innerText); break;
			case 16 : $('#c_info5').html(children[i].innerText); break; //부순위
			case 6 : $('#c_info6').html(children[i].innerText); break;
			case 8 : $('#c_info7').html(children[i].innerText); break;
			case 7 : $('#c_info8').html(children[i].innerText); break;
			case 15 : $('#c_info9').html(children[i].innerText); break;
			case 18 : $('#c_info10').html(children[i].innerText); break;
			}
		}
	};


	mx.makeCrapePrint = function(){
		var children;
		var chkval=[],x=0,trarr=[],trstr;
		$("input[name=chk]:checked").each(
			function() {
				chkval[x] =  $(this).val();
				tr_el = $(this).parent().parent();
				children = tr_el.children();

				for(var i = 0;i<children.length;i++){ //td 위치의 각값을 가져다가 넣자.
					//console.log(children[i].innerText);
					switch(i){
					case 2 : trstr = $( '#crape_'+chkval[x] ).val(); break;
					case 1 : trstr +=  ','+'상장'; break;
					case 3 : trstr +=  ','+children[i].innerText; break;
					case 11 : trstr +=  ','+children[i].innerText; break;
					case 14 : trstr +=  ','+children[i].innerText; break;
					case 16 : trstr +=  ','+children[i].innerText; break; //부순위
					case 6 : trstr +=  ','+children[i].innerText; break;
					case 8 : trstr +=  ','+children[i].innerText; break;
					case 7 : trstr +=  ','+children[i].innerText; break;
					case 15 : trstr +=  ','+children[i].innerText; break;
					case 18 : trstr +=  ','+children[i].innerText; break;
					}
				}

				trarr[x] = trstr;
				x++;

			}
		);

		var obj = {};
		obj.IDXARR = chkval;
		obj.TRARR = trarr;
		obj.JANG = localStorage.getItem('cert_president');
		obj.CONTENTS = localStorage.getItem('cert_content');

		px.Print(obj, 'crapeprint.asp');
			
		//console.log(chkval);
		//console.log(trarr);
	};



//요청##################################################################
	mx.makeCrapeNo = function(startvalue){
		if (startvalue.length != 8 ){
			alert("년도 4자리 상장마지막고유번호+1 중복되지 않도록 입력해주십시오.");
			return;
		}
		var obj = {};
		obj.CMD = mx.CMD_CRAPENO;
		obj.SVAL = startvalue;
		obj.IDXARR = JSON.parse($('#idxarr').val());
		console.log(obj.IDXARR);
		mx.SendPacket(null, obj);	
	};


	mx.setPriceMoney= function(sender, pricemoney, idx , pidx, hidx){
		var obj = {};
		obj.CMD = mx.CMD_SETPRICE;
		obj.IDX = idx;
		obj.PIDX = pidx;
		obj.HIDX = hidx;
		obj.DEFVAL = sender.defaultValue;
		obj.PM = pricemoney;
		mx.SendPacket(sender, obj);
	};


	mx.setPointWin = function(tidx, gbidx,teamgb,ordertype,kgame){
		var obj = {};
		obj.CMD = mx.CMD_SETPOINTWIN;
		obj.TIDX = tidx;
		obj.GBIDX = gbidx;
		obj.TEAMGB = teamgb;
		obj.ORDERTYPE = ordertype;
		obj.KGAME = kgame;
		mx.SendPacket(null, obj);
	};

//응답##################################################################
	mx.OndrowHTML =  function(cmd, packet, html, sender){
		document.getElementById(sender).innerHTML = html;
	};
	
	mx.OnAppendHTML =  function(cmd, packet, html, sender){
		$('#'+sender).append(packet.PRINT);
		$("#"+sender).scrollTop($("#"+sender)[0].scrollHeight);
		if (packet.ING == -1 ){
			alert("포인트가 모두 반영되었습니다.");
			//창닫기 reload 아래리스트 반영 보여줘야함
		}else{
			mx.SendPacket('showmsg', packet);
		}
	};


	mx.OnPrice = function(cmd, packet, html, sender){
		sender.style.borderColor  = 'red';	
	};

	mx.OnPointwin = function(cmd, packet, html, sender){
		document.getElementById("rcmodalcontents").innerHTML = html;
		$('#recordInputModal').show();
		//포인트 적용 시작 
		packet.CMD = mx.CMD_SETPOINT;
		packet.ING = 0; //시작위치니까
		packet.PRINT = '';
		mx.SendPacket('showmsg', packet);
	};

/////////////////////////////////////////////////////////
//클릭위치로 돌려놓기
$(document).ready(function(){
	$("#sc_body").scrollTop(localStorage.getItem('scrollpostion'));

	$("#sc_body").click(function(event){
		window.toriScroll = $("#sc_body").scrollTop();
		localStorage.setItem('scrollpostion',window.toriScroll);
		console.log(window.toriScroll);
	});
});




