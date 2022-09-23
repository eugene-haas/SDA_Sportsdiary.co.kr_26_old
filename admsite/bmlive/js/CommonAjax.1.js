
SendPacket = function( sender, packet){
  
  var datatype = "mix";
  var timeout = 5000;
  var reqcmd = packet.CMD;
  var reqdone = false;//Closure
  var url = "/ajax/ReqAjax.asp";
  var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
  var xhr = new XMLHttpRequest();
  xhr.open( "POST", url );
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  setTimeout( function(){ reqdone = true; }, timeout );
  xhr.onreadystatechange = function(){
    if( xhr.readyState == 4 && !reqdone ){
      
      if(IsHttpSuccess( xhr ) ){
        alert("success Receieve")
        ReceivePacket( reqcmd, HttpData( xhr, datatype ), sender );
        return true;
      }
      xhr = null;
    }
  };
  console.log(JSON.stringify( packet  ) );
  xhr.send( strdata );
};

ReceivePacket = function( reqcmd, data, sender ){// data는 response string
  alert(data)
  var rsp = null;
  var callback = null;
  var jsondata = null;
  var htmldata = null;
  var resdata = null;
  
  //HTML이랑 JSON 구분해서 받는 로직
  if ( Number(reqcmd) > mx.CMD_DATAGUBUN  ){
    if ( data.indexOf("`##`") !== -1 ){
      resdata = data.split( "`##`" );
      jsondata =  resdata[0];
      if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
        htmldata = resdata[1];
    }   
    else{

      htmldata = data;   
      try{
        jsondata = JSON.parse(data); 
      }
      catch(ex)
      {
        
      }
    }
  }
  else{
   
    if(typeof data == 'string'){jsondata = JSON.parse(data);}
    else{jsondata = data;}
  }

  if( jsondata !='' && jsondata != null){
    OnErrorMessage(jsondata.Message)
  }
  
  OnReLoad( reqcmd, jsondata, htmldata, sender );  
};


function OnErrorMessage(msg){
  alert(msg);
}


IsHttpSuccess = function( r ){
	try{
		return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
	}
	catch(e){
    alert("Error IsHttpSuccess")

  }
	return false;
};

HttpData = function( r, type ){
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