var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_MAKE = 200;// sendform index를 포함해서.
  mx.CMD_TESTTITLE = 210; //심사지명 저장
  mx.CMD_MAKELIST = 220; //새로운 순서항목추가
  mx.CMD_MAKELIST2 = 230; //과목리스트 추가

  mx.CMD_DELORDER = 340;//순서삭제
  mx.CMD_DELORDER2 = 350;//순서삭제2
  mx.CMD_INPUT = 400;
  mx.CMD_NOCHANGE = 401; //순서변경
  mx.CMD_SAVE = 500; //저장
  mx.CMD_DEL = 501; //삭제

  mx.CMD_DATAGUBUN = 10000;


////////////////////////////////////////



mx.ajaxurl = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','ming') + "/reqStandard.asp";
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
    case 100: return;   break; //메시지 없슴
	}
  }

  switch (Number(reqcmd)) {
  case mx.CMD_SAVE : //저장
  this.OnSendForm( reqcmd, jsondata, htmldata, sender );   break;

  case mx.CMD_INPUT: return; break;
  
  case mx.CMD_MAKELIST2 :this.OnaAddTr( reqcmd, jsondata, htmldata, sender );   break;	//과목리스트 추가
  case mx.CMD_MAKELIST:this.OnAddList( reqcmd, jsondata, htmldata, sender );   break;		//새로운 순서 항목추가



  case mx.CMD_DEL:this.OnReLoadList( reqcmd, jsondata, htmldata, sender ); break;   //삭제

  case mx.CMD_NOCHANGE :
  case mx.CMD_TESTTITLE:
  case mx.CMD_DELORDER : //순서삭제  
  case mx.CMD_DELORDER2 : //순서삭제2
  case mx.CMD_MAKE:this.OnReLoad( reqcmd, jsondata, htmldata, sender );   break;
  }

};


//생성하고 편집 index 설정하기
	mx.setSave = function(testtype){
		/*
		저장요청한 위치를 받아온다.
		각값을 보내서 저장(업데이트 하고 ) 
		receive에서 index 설정한 후에 
		px.goSubmit( {'F1':[0,1,2] , 'F2':[$('#F1_0').val(),$('#F1_1').val(),$('#F1_2').val()],'F3':[]} , 'jgstandardW.asp')
		*/
		var obj = {};
		obj.CMD = mx.CMD_MAKE;
		obj.Y = $('#F1_0').val();
		obj.GB = $('#F1_1').val();
		obj.GBNM = $('#F1_1  option:selected').text();
		obj.RCLASS = $('#F1_2').val();
		obj.RCLASSHELP = $('#mk_g0').val();
		obj.TITLE = $('#mk_g1').val();
		obj.TM = $('#mk_g2').val();
		obj.TESTTYPE = testtype;
		mx.SendPacket(null, obj);
	};

	mx.OnReLoadList =  function(cmd, packet, html, sender){
		px.goSubmit( {'F1':[0,1] , 'F2':[$('#F1_0').val(),0],'F3':[],'PN':packet.PN} , 'jgstandard.asp');
	};


	mx.OnReLoad =  function(cmd, packet, html, sender){
		px.goSubmit( {'F1':[0,1,2,3,4] , 'F2':[$('#F1_0').val(),$('#F1_1').val(),$('#F1_2').val(), packet.TESTTYPE ,packet.e_idx],'F3':[]} , 'jgstandardW.asp');
	};

	mx.OnSendForm =  function(cmd, packet, html, sender){
		px.goSubmit( {'F1':[0,1,2,3,4] , 'F2':[$('#F1_0').val(),$('#F1_1').val(),$('#F1_2').val(), packet.TESTTYPE ,packet.e_idx],'F3':[]} , 'jgstandard.asp');
	};

	mx.goManage = function(yy,teamgb,classstr, idx){
		px.goSubmit( {'F1':[0,1,2,3,4] , 'F2':[yy,teamgb,classstr, 1 ,idx],'F3':[]} , 'jgstandardW.asp');	
	};


	mx.setSaveTestTitle = function(idx,testtype){ //심사지명저장
		if ( $('#mk_g0').val() == '' || idx == '')	{ //help 선택이 되어있지 않다면 
			return;
		}
		var obj = {};
		obj.CMD = mx.CMD_TESTTITLE;
		obj.IDX = idx;
		obj.TITLE = $('#mk_g1').val();
		obj.TM = $('#mk_g2').val();
		obj.TESTTYPE = testtype;
		mx.SendPacket(null, obj);
	};

	mx.addTrOrder = function(idx, testtype){
		var obj = {};
		obj.CMD = mx.CMD_MAKELIST;
		obj.IDX = idx;
		obj.TESTTYPE = testtype;
		obj.NO  = Number($("input[name=nos1_"+idx+"]:last" ).val()) + 1;
		mx.SendPacket(null, obj);
	};
	
	mx.OnAddList = function(cmd, packet, html, sender){

		if (Number(packet.TESTTYPE) == 3){

		var addOrderText =  '<tr name="trOrder">'+
			'<td scope="col"><input type="text" name = "nos1_'+packet.e_idx+'" value="'+packet.NO+'" class="itxtbox"></td>'+
			'<td scope="row"><input type="text" name="vmax" value="" class="itxtbox" onkeyup="this.value=mx.numCheck(event,this.value,'+packet.e_idxs1+',5)" maxlength="4"></td>'+
			'<td>회시</td>'+
			'<td scope="row"><input type="text" name="vdog" value="" class="itxtbox" onkeyup="this.value=mx.numCheck(event,this.value,'+packet.e_idxs1+',6)" maxlength="4"></td>'+
			'<td>%</td>'+
			'<td scope="row">'+
			'	<a class="btn btn-primary" name="delOrder" onclick="mx.deltrOrder(this,'+packet.e_idx+','+packet.e_idxs1+','+packet.TESTTYPE+')">삭제</a>'+
			'</td>'+
		'</tr>';
		}
		else{

		var addStaffText =  '<tr style="height:50px;" name="trStaff'+packet.e_idxs1+'">'+
			'	<td scope="row" style="width:60px;"><input type="text" value="" class="itxtbox" onblur="mx.inputData(7,this.value,'+packet.e_idxs2+')" maxlength="15"><input type="hidden" name="nos2_'+packet.e_idxs1+'" value="'+packet.nos1+'"></td>'+
			'	<td scope="row" style="width:200px;">'+
			'		<textarea class="itxtarea" onblur="mx.inputData(1,this.value,'+packet.e_idxs2+')"></textarea>'+
			'	</td>'+
			'	<td scope="row" style="width:200px;">'+
			'		<textarea class="itxtarea" onblur="mx.inputData(2,this.value,'+packet.e_idxs2+')"></textarea>'+
			'	</td>'+
			'	<td scope="row" style="width:5px;">'+
			'		<a class="btn btn-primary" name="delStaff" onclick="mx.deltr(this,'+packet.e_idx+','+packet.e_idxs1+','+packet.e_idxs2+','+packet.TESTTYPE+')">삭제</a>'+
			'	</td>'+
			'</tr>';



		var addOrderText =  '<tr name="trOrder">'+
			'<td scope="col"><input type="text" name = "nos1_'+packet.e_idx+'" value="'+packet.NO+'" class="itxtbox"></td>'+

			'<td style="padding:0px;">'+
			'	<table class="tbl_tspaper" cellspacing="0" cellpadding="0">'+

			'	<tr style="height:50px;" name="trStaff'+packet.e_idxs1+'">'+
			'		<td>순서</td>'+
			'		<td scope="row" colspan="3"  style="text-align:left;padding-left:5px;"><a href="javascript:mx.addTr('+packet.e_idx+','+packet.e_idxs1+','+packet.TESTTYPE+');" class="btn btn-primary">추가</a></td>'+
			'	</tr>'+
				addStaffText + 
			'	</table>'+
			'</td>'+

			'<td scope="row"><input type="text" name="vmax" value="" class="itxtbox" onkeyup="this.value=mx.numCheck(event,this.value,'+packet.e_idxs1+',5)" maxlength="4"></td>'+
			'<td scope="row"><input type="text" name="vdog" value="" class="itxtbox" onkeyup="this.value=mx.numCheck(event,this.value,'+packet.e_idxs1+',6)" maxlength="4"></td>'+
			
			'<td scope="row">'+
			'		<textarea class="itxtarea" onblur="mx.inputData(3,this.value,'+packet.e_idxs1+')"></textarea>'+
			'</td>'+
			'<td scope="row"  >'+
			'		<textarea class="itxtarea" onblur="mx.inputData(4,this.value,'+packet.e_idxs1+')"></textarea>'+
			'</td>'+
			'<td scope="row"  >'+
			'	<a class="btn btn-primary" name="delOrder" onclick="mx.deltrOrder(this,'+packet.e_idx+','+packet.e_idxs1+','+packet.TESTTYPE+')">삭제</a>'+
			'</td>'+
		'</tr>';
		}


        var trHtml = $( "tr[name=trOrder]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
        trHtml.after(addOrderText); //마지막 trStaff명 뒤에 붙인다.	
	};

	mx.deltrOrder = function(btnobj,idx,idxs1,testtype){
		if ($(btnobj).parent().parent().parent().children().length > 1){

			//var trHtml = $(btnobj).parent().parent();
	        //trHtml.remove(); //tr 테그 삭제
			var obj = {};
			obj.CMD = mx.CMD_DELORDER;
			obj.IDX = idx;
			obj.IDXS1 = idxs1;
			obj.TESTTYPE = testtype;
			mx.SendPacket(null, obj); 
			//순서번호 때문에 새로고침하는게 좋겠어
		}
	};

	//순서항목추가
	mx.addTr = function(idx,idxs1,testtype){
		var obj = {};
		obj.CMD = mx.CMD_MAKELIST2;
		obj.IDX = idx;
		obj.IDXS1 = idxs1;
		obj.TESTTYPE = testtype;
		obj.NO  = Number($("input[name=nos2_"+idxs1+"]:last" ).val()) + 1;
		mx.SendPacket(null, obj);
	};

	mx.OnaAddTr = function(cmd, packet, html, sender){

		var addStaffText =  '<tr style="height:50px;" name="trStaff'+packet.e_idxs1+'">'+
		'	<td scope="row" style="width:60px;"><input type="text" value="" class="itxtbox"  onblur="mx.inputData(7,this.value,'+packet.e_idxs2+')" maxlength="15"><input type="hidden" name="nos2_'+packet.e_idxs1+'" value="'+packet.nos1+'"></td>'+
		'	<td scope="row" style="width:200px;">'+
		'		<textarea class="itxtarea" onblur="mx.inputData(1,this.value,'+packet.e_idxs2+')"></textarea>'+
		'	</td>'+
		'	<td scope="row" style="width:200px;">'+
		'		<textarea class="itxtarea" onblur="mx.inputData(2,this.value,'+packet.e_idxs2+')"></textarea>'+
		'	</td>'+
		'	<td scope="row" style="width:5px;">'+
		'		<a class="btn btn-primary" name="delStaff" onclick="mx.deltr(this,'+packet.e_idx+','+packet.e_idxs1+','+packet.e_idxs2+','+packet.TESTTYPE+')">삭제</a>'+
		'	</td>'+

		'</tr>';

        var trHtml = $( "tr[name=trStaff"+packet.e_idxs1+"]:last" ); //last를 사용하여 trStaff라는 명을 가진 마지막 태그 호출
        trHtml.after(addStaffText); //마지막 trStaff명 뒤에 붙인다.	
	};

	mx.deltr =  function(btnobj,idx,idxs1,idxs2,testtype){
		if ($(btnobj).parent().parent().parent().children().length > 2){
			//var trHtml = $(btnobj).parent().parent();
	        //trHtml.remove(); //tr 테그 삭제
			var obj = {};
			obj.CMD = mx.CMD_DELORDER2;
			obj.IDX = idx;
			obj.IDXS1 = idxs1;
			obj.IDXS2 = idxs2;
			obj.TESTTYPE = testtype;
			mx.SendPacket(null, obj); 
		}
	};


	//각데이터 저장
	mx.inputData = function(boxno,inputvalue, idx){
		var obj = {};
		obj.CMD = mx.CMD_INPUT;
		obj.BOXNO = boxno;
		obj.INPUT = inputvalue;
		obj.IDX = idx;
		mx.SendPacket(null, obj); 		
	};


	//최고점, 계수 = 최고점 * 계수 총합
	mx.sumValue = function(nm){
		var nlen = $("input[name="+nm+"]").length;
		var sum = 0;
		var vdog = 0;
		var vmax = 0;
		var linesum = 0; //tr 최고점 * 계수
		for (var i = 0; i < nlen ; i ++ )	{
			if (nm == "vmax"){
				if($("input[name="+nm+"]")[i].value != "" ){
					if ($("input[name=vdog]")[i].value != ''){
						vdog = parseInt($("input[name=vdog]")[i].value);
					}
					linesum = 	parseInt($("input[name="+nm+"]")[i].value) * vdog;
					sum += linesum;
				}
			}
			else{
				if($("input[name="+nm+"]")[i].value != "" ){
					sum += parseInt($("input[name="+nm+"]")[i].value);
				}
			}
		}
		return sum;
	};

	mx.numCheck = function(event, inputvalue ,idx , boxno) { //boxno input(tr) 박스 번호
		if (inputvalue == "E")	{ //실권
			var inputvalue = 200;
		}
		else{
			var inputvalue = inputvalue.replace(/[^.0-9]/g,'');
		}
		event = event || window.event;
		var sum = 0;
		//console.log(event.which);
		var keyID = (event.which) ? event.which : event.keyCode;
		if( (( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ))  || keyID == 8  || keyID == 190 || keyID == 16){ //E 백스페이스 

			if (inputvalue < 200){
				if (boxno == 5){
					sum = mx.sumValue('vmax');
					$("#maxsum").text(sum);
				}
				else{
					sum = mx.sumValue('vmax');
					$("#maxsum").text(sum);

					sum = mx.sumValue('vdog');			
					$("#dogsum").text(sum);
				}
			}

			var obj = {};
			obj.CMD = mx.CMD_INPUT;
			obj.BOXNO = boxno;
			obj.INPUT = inputvalue;
			obj.IDX = idx;
			mx.SendPacket(null, obj); 


			if (inputvalue == 200){
				inputvalue = "E";
			}
			return inputvalue;
		}
		else{
			if (inputvalue == 200){
				inputvalue = "E";
			}
			return inputvalue;
		}
	};


	mx.noChange = function(event, inputvalue ,idx , idxs1, testtype) { 
		var inputvalue = inputvalue.replace(/[^0-9]/g,'');
		event = event || window.event;
		var sum = 0;
		//console.log(event.which);
		var keyID = (event.which) ? event.which : event.keyCode;
		var maxno  = Number($("input[name=nos1_"+idx+"]:last" ).val());
		if (Number(inputvalue) > maxno ){
			inputvalue = maxno;
		}

		if( (( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ))  || keyID == 8 ){

			if (inputvalue == ""){
				return inputvalue;
			}
			else{
				var obj = {};
				obj.CMD = mx.CMD_NOCHANGE;
				obj.INPUT = inputvalue;
				obj.IDX = idx;
				obj.IDXS1 = idxs1;
				obj.TESTTYPE = testtype;
				mx.SendPacket(null, obj); 
				return inputvalue;
			}
		}
		else{
			return inputvalue;
		}
	};


	mx.tab = function(idx,testtype){
		px.goSubmit( {'F1':[0,1,2,3,4] , 'F2':[$('#F1_0').val(),$('#F1_1').val(),$('#F1_2').val(), testtype,idx],'F3':[]} , 'jgstandardW.asp');
	};


	//편집 최종저장
	mx.save = function(idx, testtype){
		var obj = {};
		obj.CMD = mx.CMD_SAVE;
		obj.IDX = idx;
		obj.TESTTYPE = testtype;
		mx.SendPacket(null, obj); 	
	};


	//편집 최종저장
	mx.del = function(idx,pn, yy){
			if(confirm ("정말 삭제하시겠습니까?")){
				var obj = {};
				obj.CMD = mx.CMD_DEL;
				obj.IDX = idx;
				obj.PN = pn;
				mx.SendPacket(null, obj); 	
		  }
	};