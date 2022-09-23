var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_DATAGUBUN = 10000;

	mx.CMD_SELECTGB2 = 50002; //대분류검색
	mx.CMD_SELECTSIDO = 50001; //시도로 구군검색

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

mx.loading = function(){
	var width = $(window).width();
	var height = $(window).height();
	 
	//화면을 가리는 레이어의 사이즈 조정
	$(".backLayer").width(width);
	$(".backLayer").height(height);
	 
	//화면을 가리는 레이어를 보여준다 (0.5초동안 30%의 농도의 투명도)
	$(".backLayer").fadeTo(500, 0.3);
	 
	//팝업 레이어 보이게
	var loadingDivObj = $("#loadingDiv");
	loadingDivObj.css("top", $(document).height()/2-0);
	loadingDivObj.css("left",$(document).width()/2-0);
	loadingDivObj.fadeIn(500);
};

//esc키 누르면 화면 잠김 해제
$(document).keydown(function(event){
	if(event.which=='27'){
		$("#loadingDiv").fadeOut(300);
		$(".backLayer").fadeOut(1000);
	}
});

 //윈도우가 resize될때마다 backLayer를 조정
 $(window).resize(function(){
	var width = $(window).width();
	var height = $(window).height();
	$(".backLayer").width(width).height(height);
});


mx.ajaxurl = "/pub/ajax/ksports/reqKsports.asp"; 
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


	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){
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
		case 2:	alert('중복된 데이터가 존제합니다.');return; 	break;
		case 100:	return; 	break; //메시지 없슴
		}
	}

	switch (Number(reqcmd))	{
	case 	mx.CMD_SELECTSIDO:
	case mx.CMD_SELECTGB2: this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	}
};


mx.SelectGb = function() {
  var GbVal = $("#sportsgb").val();
	  var obj = {};
	  obj.CMD = mx.CMD_SELECTGB2;
	  obj.GB = GbVal;
	  mx.SendPacket('ul_3', obj);  
};

mx.SelectSido = function() {
	  var GbVal = $("#sidogb").val();
	  var obj = {};
	  obj.CMD = mx.CMD_SELECTSIDO;
	  obj.GB = GbVal;
	  mx.SendPacket('ul_2', obj);  
};

//drow///////////////
mx.OndrowHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	if( cmd == mx.CMD_E){
		mx.init();
	}
};

mx.OnModal =  function(cmd, packet, html, sender){
  document.getElementById(sender).innerHTML = html;
  $('#'+sender).modal('show');
};

//drow///////////////


mx.SetDate = function(sender, inputvalue){
  if (inputvalue != ""){
  	if ( $("#" + sender).is(":checked") == true ){
	  $("#" + sender).click();
	}
  }
  else{
  	if ( $("#" + sender).is(":checked") == false ){
	  $("#" + sender).click();
	}  
  }
};

mx.SetDateAll = function(sender){
  	if ( $("#" + sender).is(":checked") == true ){
		$("#GameS").val('');	  
		$("#GameE").val('');
	}
};

mx.SetVodAll = function(sender){
  	if ( $("#" + sender).is(":checked") == true ){
		$("#vodYN").val('').prop("selected", true);	  
	}
	else{
		$("#vodYN").val('Y').prop("selected", true);	  	
	}
};

$(document).ready(function(){
	mx.init();
}); 



mx.init = function(){
	$(function() {
		$( "#GameS" ).datepicker({ 
				 changeYear:true,
				 changeMonth: true, 
				 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'], 
				 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				 showMonthAfterYear:true,
				 showButtonPanel: true, 
				 currentText: '오늘 날짜', 
				 closeText: '닫기', 
				 dateFormat: "yy-mm-dd"	
		});

		$( "#GameE" ).datepicker({ 
				 changeYear:true,
				 changeMonth: true, 
				 dayNamesMin: ['일','월', '화', '수', '목', '금', '토'], 
				 monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
				 showMonthAfterYear:true,
				 showButtonPanel: true, 
				 currentText: '오늘 날짜', 
				 closeText: '닫기', 
				 dateFormat: "yy-mm-dd"	
		});
	});
};

mx.searchPlayer = function(pageno, targeturl){
	var obj ={};
	obj.pg = pageno;

	obj.SDATE        			=	$("#GameS").val();
	obj.EDATE			 		=	$("#GameE").val();

	if ( $("#on-off-term").is(":checked") == true ) {
	   obj.DATEALL = 'Y';		
	}
	else{
	   obj.DATEALL = 'N';			
	}
	obj.SIDO	         			=	$("#sidogb  option:selected").text();
	if ($("#sidogb").val() == ''){
		obj.SIDO = '';
	}
	
	obj.GUGUN		         	=	$("#googun").val();
	obj.STADIUM         		=	$("#stadium").val();
	obj.SGB        				=	$("#sportsgb").val();
	obj.SGBSUB			 		=	$("#sportssubgb").val();
	obj.VODYN			 		=	$("#vodYN").val();

	if ( $("#on-off-vod").is(":checked") == true ) {
	   obj.VODALL = 'Y';
	}
	else{
	   obj.VODALL = 'N';	
	}

	obj.TITLE              	=	$("#gametitle").val();

	if (targeturl == undefined){
		document.sform.action = "ksearch.asp";
	}
	else{
		document.sform.action = targeturl;
	}
	document.sform.p.value =   JSON.stringify( obj  );
	document.sform.submit();
};


