<!-- #include virtual = "/pub/header.ridingadmin.asp" -->
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=3">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge, chrome=1">
    <title>Tournament Tree</title>
  
    <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-3.1.1.min.js"></script>

	<script type="text/javascript">
	<!--


//ajax 기보 형태 샘플
/*
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

//동일한 패킷이 오는경우 (막음 처리해야겠지)
mx.SendPacket = function( sender, packet){
	var datatype = "mix";
	var timeout = 5000;
	var reqcmd = packet.CMD;
	var reqdone = false;//Closure
	var url = "/pub/ajax/reqTennisContest.asp";
	var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
	var xhr = new XMLHttpRequest();
	xhr.open( "POST", url );
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	//mx.loading(); 로딩시작

	xhr.onreadystatechange = function(){
		if( xhr.readyState == 4 && !reqdone ){
			if( mx.IsHttpSuccess( xhr ) ){
				//로딩종료
				//받은후 실행코드
				//mx.ReceivePacket( reqcmd, mx.HttpData( xhr, datatype ), sender );
				return true;
			}
			xhr = null;
		}
	};
	console.log(JSON.stringify( packet  ) );
	xhr.send( strdata );
};
*/
///////////////////////////////












		var mx =  mx || {};
		////////////////////////////////////////
		  mx.CMD_JSON = 100;
		  mx.CMD_DATAGUBUN = 10000;
		  mx.CMD_HTML = 20000;
		////////////////////////////////////////

		mx.ajaxurl = "/pub/ajax/reqSample.asp";
		mx.ajaxtype = "POST";
		mx.dataType = "text";

		mx.SendPacket = function( sender, packet){
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
			  htmldata = data;
		  }
		  else{
			jsondata = JSON.parse(data);
		  }

		  if( jsondata !='' && jsondata != null){
			switch (Number(jsondata.result)){
			case 0: break;
			case 1: alert('데이터가 존재하지 않습니다.');return;  break;
			case 100: return;   break; //메시지 없슴
			}
		  }

		  switch (Number(reqcmd)) {
		  case mx.CMD_JSON :
		  case mx.CMD_HTML :  this.OndrowHTML( reqcmd, jsondata, htmldata, sender );   break;
		  }
		};


		//요청
		mx.reqJson = function(sender){ //sender  >> targetid or sender
			obj = {};
			obj.CMD = mx.CMD_JSON;
			obj.A = 100;
			obj.B = 200;
			mx.SendPacket(sender, obj);
		};

		mx.reqHtml = function(sender){ //sender  >> targetid or sender
			obj = {};
			obj.CMD = mx.CMD_HTML;
			obj.A = 100;
			obj.B = 200;
			mx.SendPacket(sender, obj);
		};


		//응답
		mx.OndrowHTML =  function(cmd, packet, html, sender){
			$('#'+sender).html(html);
			if (html == null ){
				$('#'+sender).html(JSON.stringify(packet));
			}
			//document.getElementById(sender).innerHTML = html;
		};
	//-->
	</script>


  </head>
  <body>

    <h3>AJAX 샘플</h3>
    <div class="domid" id="domid"></div>


	<input type="button" value ="json" onclick="mx.reqJson('domid')">
	<input type="button" value ="html" onclick="mx.reqHtml('domid')">



  </body>
</html>

