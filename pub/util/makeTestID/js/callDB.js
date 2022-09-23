
var cdb = cdb || {}

// ============================  
// Data 구분자 - ( html + json data ) 유무 
cdb.CMD_DATAGUBUN                       = 10000;        // ( json + html data )

cdb.CMD_REG_TESTID                      = 50001;             // Regist Test ID 


cdb.ajaxUrl = "/study_src/ajax/reqAjax.asp"
cdb.ajaxType = "Post"
cdb.ajaxDataType = "Text"

/*  =================================================================================== 
    // Ajax Call 
    =================================================================================== */
    cdb.SendEx = function(sender, packet, reqUrl){
        var strData = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );    
        console.log( utx.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );	
    
        $.ajax({
            url : reqUrl, 
            type : cdb.ajaxType,
            data : strData, 
            dataType : cdb.ajaxDataType, 
            success: function(rcvData) {
                cdb.Receive(packet.CMD, rcvData, sender);
            }             
        });
    };

/*  =================================================================================== 
    // Ajax Call Response
    =================================================================================== */
    cdb.Receive = function(reqcmd, rcvData, sender){
        var jsondata = null, htmldata = null, resdata = null; 
        var cmd = Number(reqcmd); 
    
        console.log("cdb.Receive cmd = " + reqcmd); 
    //    console.log("cdb.Receive rcvData = " + rcvData); 
        console.log("cdb.Receive ## = " + rcvData.indexOf("`##`")); 
    
        if ( cmd > cdb.CMD_DATAGUBUN  ){
            if ( rcvData.indexOf("`##`") !== -1 ){//json + html
              resdata = rcvData.split( "`##`" );
              jsondata =  resdata[0];
              if( jsondata !=''){ jsondata = JSON.parse(jsondata);}
                htmldata = resdata[1];
            }
            else{ //html
              htmldata = rcvData;
            }
        }
        else{//json
            if(typeof rcvData == 'string'){jsondata = JSON.parse(rcvData);}
            else{jsondata = rcvData;}
        }
        
        if( jsondata !='' && jsondata != null){
            switch (Number(jsondata.result)){
                case 1: break;
                case 99: alert('데이터가 존재하지 않습니다.');return; 
                case 100: return;  //메시지 없슴
            }
        }

        if( jsondata != null) utx.printObj(jsondata); 
    
        switch(cmd) {
            case cdb.CMD_REG_TESTID: this.OnRegTestID( reqcmd, jsondata, htmldata, sender );  break;     //Test ID 등록
        }            
    };

    cdb.OnAppendHTML = function(cmd, packet, html, sender){
        console.log("cdb.OnAppendHTML"); 
            
        $('#'+sender).append(html);
        $("body").scrollTop($("body")[0].scrollHeight);
    };

    cdb.ReqTestID = function(sender, nSex)
    {
        var obj = {};
        obj.CMD     = cdb.CMD_REG_TESTID;
        obj.POS     = 0; 
        obj.SEX    = nSex; 

        cdb.SendEx(sender, obj, cdb.ajaxUrl);
    }

    cdb.OnRegTestID = function(cmd, packet, html, sender){
        var retCode, strUserID, strLog;
        var pos = 0; 
        
        if( utx.hasown(packet,"result") ) retCode = packet.result;   
        if( utx.hasown(packet,"ID") ) strUserID = packet.ID;        
        if( utx.hasown(packet,"POS") ) pos = packet.POS;

        strLog = utx.strPrintf("OnRegTestID.. pos = {0}", pos); 
        console.log(strLog);     
        
        switch(retCode)
        {
            case "1" : strLog = utx.strPrintf("'{0}'님 아이디 등록<br>", strUserID); break; 
            case "61": strLog = "Error  : 시스템이 응답하지 않습니다. 잠시후에 다시 등록하세요. <br>"; break; 
        }
        
        if(strLog != undefined) cdb.OnAppendHTML(cmd, packet, strLog, sender); 

        if(100-1 == pos) {            
            strLog = "<br>************* 아이디 등록이 완료 되었습니다!<br>";
            cdb.OnAppendHTML(cmd, packet, strLog, sender);        
            return; 
        }
        
        // 아이디를 다 보낼때 까지 Loop를 돈다. 
        pos = Number(pos)+1; 
        packet.POS       = pos;  
        cdb.SendEx(sender, packet, cdb.ajaxUrl);   
    };