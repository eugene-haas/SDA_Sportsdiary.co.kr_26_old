var mx =  mx || {};
////////////////////////////////////////
  mx.CMD_DATAGUBUN = 10000;
  mx.CMD_SETPLYER = 40000;
  mx.CMD_DELPN = 50000;
  mx.CMD_COPYPHONENO = 60000;
  mx.CMD_MERGETABLE = 70000;
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

//동일한 패킷이 오는경우 (막음 처리해야겠지)
mx.SendPacket = function( sender, packet){
  var datatype = "mix";
  var timeout = 5000;
  var reqcmd = packet.CMD;
  var reqdone = false;//Closure
  var url = "/pub/ajax/reqTennisTool.asp";
  var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
  var xhr = new XMLHttpRequest();
  xhr.open( "POST", url );
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  setTimeout( function(){ reqdone = true; }, timeout );

    //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){
  //  apploading("AppBody", "로딩 중 입니다.");
  //}

  xhr.onreadystatechange = function(){
    if( xhr.readyState == 4 && !reqdone ){
      if( mx.IsHttpSuccess( xhr ) ){
      
        //if ( Number(packet.CMD) >= mx.CMD_DATAGUBUN  ){       
        //  $('#AppBody').oLoader('hide');
        //}

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
    switch (Number(jsondata.result))  {
    case 0: break;
    case 1: alert('데이터가 존재하지 않습니다.');return;  break;
    case 100: return;   break; //메시지 없슴
    }
  }

  switch (Number(reqcmd)) {
  case mx.CMD_MERGETABLE:
  case mx.CMD_COPYPHONENO: 
  case mx.CMD_SETPLYER:  this.OnAppendHTML( reqcmd, jsondata, htmldata, sender );    break;
  case mx.CMD_DELPN:  this.OnAppendHTML2( reqcmd, jsondata, htmldata, sender );    break;
  }
};

mx.OnAppendHTML2 =  function(cmd, packet, html, sender){
  $('#'+sender).append(html);
  document.getElementById(sender).scrollTop = document.getElementById(sender).scrollHeight;
};

mx.OnAppendHTML =  function(cmd, packet, html, sender){
  $('#'+sender).append(html);
  document.getElementById(sender).scrollTop = document.getElementById(sender).scrollHeight;
  //if ( Number(packet.NKEY) > 0 ) {return;}
  if ( Number(mx.LASTRS) === Number(packet.NKEY)+1 ) {return;}
  if(Number(packet.NKEY) === 0){$('#'+sender).html('');}
  mx.SendPacket(sender, packet);
};

mx.SHEETNO = '';
mx.FNM = '';
mx.LASTRS = 0;

mx.setPlayer = function(nkey){
  var obj = {};
  obj.CMD = mx.CMD_SETPLYER;
  obj.NKEY = nkey;
  mx.SendPacket('updatelog', obj);
};


mx.delPn = function(nkey){
  var obj = {};
  obj.CMD = mx.CMD_DELPN;
  obj.NKEY = nkey;
  mx.SendPacket('updatelog', obj);
};

mx.copyPhoneNo = function(nkey){
  var obj = {};
  obj.CMD = mx.CMD_COPYPHONENO;
  obj.NKEY = nkey;
  mx.SendPacket('updatelog', obj);
};


mx.mergeTable = function(nkey){
  var obj = {};
  obj.CMD = mx.CMD_MERGETABLE;
  obj.NKEY = nkey;
  mx.SendPacket('updatelog', obj);
};