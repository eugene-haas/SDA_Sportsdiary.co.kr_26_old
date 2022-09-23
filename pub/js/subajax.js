
//객체(이벤트 처리)
var mx_player =  mx_player || {};
mx_player.CMD_DATAGUBUN = 10000;

/**
* S :공통 ajax 호출 처리 로직
* 추가 : 2017-11-06 김주영
*/
mx_player.IsHttpSuccess = function( r ){
    try{
    return ( !r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined" );
    }
    catch(e){

    }
return false;
};
  
mx_player.HttpData = function( r, type ){
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
mx_player.SendPacket = function( sender, packet,TargetUrl){
    var defer = $.Deferred();

    var datatype = "mix";
    var timeout = 5000;
    var reqcmd = packet.CMD;
    var reqdone = false;//Closure
    var url = TargetUrl;
    var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
    var xhr = new XMLHttpRequest();
    xhr.open( "POST", url );
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    //setTimeout( function(){ reqdone = true; }, timeout );
    xhr.onreadystatechange = function(){
    if( xhr.readyState == 4 && !reqdone ){
        if( mx_player.IsHttpSuccess( xhr ) ){
            defer.resolve(mx_player.ReceivePacket( reqcmd, mx_player.HttpData( xhr, datatype ), sender ));
        }
        xhr = null;
    }
    };
    console.log(JSON.stringify( packet  ) );
    xhr.send( strdata );
     
    return defer.promise();
};

mx_player.ReceivePacket = function (reqcmd, data, sender) {// data는 response string
    var rsp = null;
    var callback = null;
    var resdata = null;

    var jsondata = null;
    var htmldata = null;

    if (Number(reqcmd) > mx_player.CMD_DATAGUBUN) {
        if (data.indexOf("`##`") !== -1) {
            resdata = data.split("`##`");
            jsondata = resdata[0];

            if (jsondata != '') { jsondata = JSON.parse(jsondata); }
            htmldata = resdata[1];
        }
        else {
            htmldata = data;
            try {
                jsondata = JSON.parse(data);
            }
            catch (ex) {

            }
        }
    }
    else {
        if (typeof data == 'string') { jsondata = JSON.parse(data); }
        else { jsondata = data; }
    }

    var obj = {};
    obj.htmldata = htmldata;
    obj.jsondata = jsondata; 
    mx_player.ReceiveData = obj;
    return obj;
};

//그리기
mx_player.OndrowHTML =  function(cmd, packet, html, sender){
    document.getElementById(sender).innerHTML = html;
};
    
//추가 그리기
mx_player.OnAppendHTML =  function(cmd, packet, html, sender){
    $('#'+sender).append(html);
};

//삭제
mx_player.OndelHTML =  function(cmd, packet, html, sender){
    $("#"+sender).remove();
};

//선처리(추후 수정)
mx_player.OnBeforeHTML =  function(cmd, packet, html, sender){
      
};
//후처리(추후 수정)
mx_player.OnAfterHTML = function (cmd, packet, html, sender) {

};

/**
* E : ajax 
*/
    