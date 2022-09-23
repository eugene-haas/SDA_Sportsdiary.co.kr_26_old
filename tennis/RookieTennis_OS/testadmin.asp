<!-- #include virtual = "/pub/header.RookieTennis.asp" -->
<%=CONST_HTMLVER%>


<%
'If USER_IP <> "118.33.86.240" then
'Response.End
'End if
%>



<head>
<!-- #include virtual = "/pub/html/RookieTennis/html.head.asp" -->
    <style>
      #calendar {max-width: 100%; margin: 0 auto;}
      .fc h2 {font-size: 20px;}
      .fc-sun {color: #FF0000;}
      .fc-sat {color: blue;}
    </style>
    <!-- custom css -->

<script type="text/javascript">
<!--
var mx =  mx || {};
////////////////////////////////////////
	mx.CMD_A1 = 1;
	mx.CMD_A2 = 2;
	mx.CMD_A3 = 3;
	mx.CMD_A4 = 4;
	mx.CMD_A4 = 5;
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

//히스토리 저장/////////////////////////////////////////////////////////////////////////
mx.arrKey = ["CMD","PG",'SEQ',"IDX","T","R","SP","LVL","FT","SSTR","DN","NM","ST"]; //"PAGEC",'SEQ',"IDX","TID","REF","STEP","LVL","FINDTYPE","SEARCHSTR","DBNAME","이전다음 상태"
mx.historybackstr = null;

mx.CheckForHash = function(){ //백버튼 클릭시 위치로 이동
	if( document.location.hash && document.location.hash != mx.historybackstr  ){
		mx.historybackstr = document.location.hash;

		var HashLocationName = document.location.hash;
		HashLocationName = HashLocationName.replace("#","");

		var objkey = HashLocationName.split('^');
		var sendparam = {};
		var keylen = mx.arrKey.length;
		for ( var  i= 0 ;i < keylen ;i++ )	{
			if (objkey[i] != '')	{
				sendparam[mx.arrKey[i]] = objkey[i];
			}
		}
		var objlen = Object.keys(sendparam).length;
		if (objlen > 0 ){
			mx.SendPacket(null, sendparam);
		}
	}else{
		//첫페이지 불러오기
	}
};

mx.RenameAnchor = function (anchorid, anchorname){
	document.getElementById(anchorid).name = anchorname; //this renames the anchor
}

mx.RedirectLocation = function (anchorid, anchorname, HashName){
	mx.RenameAnchor(anchorid, anchorname);
	document.location = HashName;
};

mx.HashCheckInterval = setInterval("mx.CheckForHash()", 1000);
window.onload = mx.CheckForHash;
//히스토리 저장/////////////////////////////////////////////////////////////////////////

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


//동일한 패킷이 오는경우 (막음 처리?)
mx.SendPacket = function( sender, packet){

	//var objlen = Object.keys(packet).length;
	if ( (Number(packet.CMD) >= mx.CMD_DATAGUBUN && Number(packet.CMD) < mx.CMD_DATAGUBUN + 10000)  && sender != null){ //보이는 화면 만 히스토리에 저장
		var locstr='';
		var iskey = false;
		var keylen = mx.arrKey.length;
			
		for ( var  i= 0 ;i < keylen ;i++ )	{ //배열갯수만큼만 생성

			for (var key in packet) { //한개씩만 붙여나가자
				if (key == mx.arrKey[i])	{
					if (i == 0 ){
						locstr += packet[key];
						iskey = true;
						break;
					}
					else{
						locstr += '^' + packet[key];
						iskey = true;
						break;
					}
				}
				else{
					iskey = false;
					//locstr += '^';
					//break;
				}
			}
			if (iskey == false){
				locstr += '^';
			}

		}

		mx.RedirectLocation("LocationAnchor", packet.CMD, "#"+locstr);
		return;
	}




	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = "/pub/ajax/reqTestTennis.asp";
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	setTimeout( function(){ reqdone = true; }, timeout );

    if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
		apploading("AppBody", "로딩 중 입니다.");
	}

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){
			
				if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){				
					$('#AppBody').oLoader('hide');
				}

				mx.ReceivePacket( reqcmd, mx.HttpData( xhr, datatype ), sender );
				return true;
			}
			xhr = null;
		}
	};
	console.log(JSON.stringify( packet  ) );
	//return;
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

		//debug print
		if (jsondata.hasOwnProperty('debug') == true ){
			console.log("debug : " + jsondata.debug);
		}

		switch (Number(jsondata.result))	{
		case 0:	break;
		case 1:	alert('데이터가 존재하지 않습니다.');return; 	break;
		case 100:	return; 	break; //메시지 없슴
		}
	}

	this.Onupdate( reqcmd, jsondata, htmldata, sender );

	//switch (Number(reqcmd))	{
	//case mx.CMD_GAMESEARCH:	this.OndrowHTML( reqcmd, jsondata, htmldata, sender );		break;
	//}
};

//서브 지정
mx.Onupdate = function(cmd, packet, html, sender){
	alert("완료");
};	
//-->
</script>
    

</head>
<body  id="AppBody">

<!-- #include virtual = "/pub/html/RookieTennis/html.top.asp" -->

<!-- S: main -->
<div class="main container-fluid">
	<!-- #include file = "./body/testadmin.body.asp" -->
</div>
 <!-- E: main -->

<!-- #include virtual = "/pub/html/Rookietennis/html.footer.asp" -->	
 <script src="js/main.js"></script>
</body>
</html>