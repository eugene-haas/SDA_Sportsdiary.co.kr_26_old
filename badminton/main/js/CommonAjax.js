SendPacket = function(Url, packet) {

  if(Url == ""){
    alert("Ajax Url이 없습니다.")
    return;
  }
  var strAjaxUrl = Url;
  var strdata = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
  $.ajax({
    url: strAjaxUrl,
    type: 'POST',
    dataType: 'html',
    data: strdata,
    success: function (data) {
      if(data) {
        htmldata = "";
        jsondata = "";
        dataType = "default"
        
        if (data.indexOf("`##`") !== -1 ){
          dataType = "html"
          resdata = data.split( "`##`" );
          //console.log(resdata)
          try{
            jsondata = JSON.parse(resdata[0]);
          }
          catch(ex)
          {
          }
          htmldata = resdata[1];

        }		
        else{

          dataType = "json"
          //alert(dataType + data)
          try{
            jsondata = JSON.parse(data);
          }
          catch(ex)
          {
          }
        }
        //console.log(htmldata);
       //console.log(jsondata);
        OnReceiveAjax(packet.CMD, dataType, htmldata, jsondata  );
      }
      else
      {
          alert("데이터가 현재 빈 값 : " + data )
      }

    }, error: function (xhr, status, error) { /*alert("aa:"+xhr+"bb:"+status+"cc"+error);*/
	    alert("data: " + data + "xhr: " + xhr+"status: " + status+ "error : " + error) ; 

      OnError(xhr, status, error);    
    }
  });
  //console.log(JSON.stringify(packet));
  console.log(strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );
};

var SendPacketSe = function (packet, Url) {
    var defer = $.Deferred();
    var strAjaxUrl = Url;
    $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        /*
        dataType: 'html',
        */
        data: packet,
        async: false,
        success: function (retDATA) {
            if (retDATA) {
                OnReceiveAjax(retDATA);
            }
            defer.resolve(retDATA);

        }, error: function (xhr, status, error) {
            OnError(xhr, status, error);
            defer.reject(xhr);
        }
    });
    return defer.promise();
};

OnError= function(xhr, status, error) {  

     if (error != "") { alert("조회중 에러발생 - ★시스템관리자에게 문의하십시오!★" + status + xhr); return; }

}

  // ===================   By Aramdry =================================  
  /*  =================================================================================== 
  replace All - 정규식 이용 , strSrc의 문자열 str1을 str2로 변환시킨다. 
  =================================================================================== */    
  strReplaceAll = function(strSrc, str1, str2) {        
    var regExp = new RegExp(str1, "g");
    strSrc = strSrc.replace( regExp, str2); 
    return strSrc; 
}

/* =================================================================================== 
      console log용 - obj을 입력받아 property를 출력한다. 
      asp에서는 호출할수 없다. ( console.log 사용)  ex) utx.printObj(objCoupon, "coupon Object"); 
  =================================================================================== */
  printObj = function (obj, strTitle) {
   if(strTitle == undefined || strTitle == null || strTitle == "" )
   {
       strTitle = obj.toString();
   }
   console.log("=============== " + strTitle + " ==============="); 
   
   for(var prop in obj) {
       console.log(" - " + prop + " : " + obj[prop]); 
   }

   console.log("======================================================"); 
  }

  // ===================   By Aramdry =================================