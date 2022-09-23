/*  =================================================================================== 
    Purpose : ajax와 통신하는 js 파일 UI Coupon (쿠폰 사용자 화면 )
    Make    : 2019.01.17
    Author  :                                                       By Aramdry
    =================================================================================== */

    var badmt = badmt || {}

    /*  =================================================================================== 
           쿠폰 페이지들을 이동한다. ( 쿠폰홈, 발급, 발급관리, 지도자 쿠폰 )
        =================================================================================== */
        // Data 구분자 - ( html + json data ) 유무 
        badmt.CMD_DATAGUBUN                   = 10000;        // ( json + html data )
          
        // ============================ command
        badmt.CMD_BADMT_MIN                                   = 50000;
    
        badmt.CMD_SEARCH_REG_AMAUSER                        = 50001;             // 등록 리스트에서 아마추어 선수를 서치한다. 
        badmt.CMD_UPDATE_AMAUSER_INFO                       = 50002;             // 등록 리스트에서 아마추어 선수정보를 Update
        badmt.CMD_RESEND_SMS_AMAUSER                        = 50003;             // 재등록 할수 있도록 SMS를 재전송한다. 

        badmt.CMD_REQ_DIRECTREG_AMAINFO                     = 50004;             // 아마추어 Info를 바로 등록한다. 임시테이블에 
    
        badmt.CMD_BADMT_MAX                                   = 59999;
        
    //  ===================================================================================        
    //  ===================================================================================  
        badmt.aryDirect = new Array();                         // Direct Amature Regist.. 
        // ============================ Array var
    
        badmt.ajaxUrl = "ajax/req.badmt.asp";
        badmt.ajaxType = "POST"
        badmt.ajaxDataType = "text"
    
    /*  ###################################################################################
            ajax system function 
        ################################################################################### */
    
    /*  =================================================================================== 
           쿠폰 페이지들을 이동한다. ( 쿠폰홈, 발급, 발급관리, 지도자 쿠폰 )
        =================================================================================== */
    badmt.goCpnPage = function(packet, gourl){    
        document.sform.p.value =   JSON.stringify( packet  );
        document.sform.action = gourl;
        document.sform.submit();
    };
    
    /*  =================================================================================== 
           
        =================================================================================== */
    badmt.goPage = function(packet, pageno){
        packet.PN = pageno;
        var gourl = location.href;
    
        document.ssform.p.value =   JSON.stringify( packet  );
        document.ssform.action = gourl;
        document.ssform.submit();
    };
    
    /*  =================================================================================== 
        // 쿠폰 메인 페이지 - 검색        
        =================================================================================== */
    badmt.goSearch = function(packet, pageno,f1,f2,f3){
        packet.F1 = f1;
        packet.F2 = f2;
        packet.F3 = f3;
        packet.PN = pageno;
        var gourl = location.href;
        
        document.cp_sform.p.value =   JSON.stringify( packet  );
        document.cp_sform.action = gourl;
        document.cp_sform.submit();
    };
    
    /*  =================================================================================== 
        // 쿠폰 발급 페이지 검색 
        =================================================================================== */
    badmt.goSearchEx = function(packet, pageno){	
        packet.PN = pageno;
        var gourl = location.href;
    
        document.pub_sform.p.value =   JSON.stringify( packet  );
        document.pub_sform.action = gourl;
        document.pub_sform.submit();
    };
    
    /*  =================================================================================== 
        // Ajax Call 
        =================================================================================== */
    badmt.SendEx = function(sender, packet, reqUrl){
        var strData = "REQ=" + encodeURIComponent( JSON.stringify( packet  ) );
    
            console.log( utx.strReplaceAll(JSON.stringify( packet  ), '\"', '\"\"') );	
    
        $.ajax({
            url : reqUrl, 
            type : badmt.ajaxType,
            data : strData, 
            dataType : badmt.ajaxDataType, 
            success: function(rcvData) {
                badmt.Receive(packet.CMD, rcvData, sender);
            }             
        });
    };
    
    /*  =================================================================================== 
        // Ajax Call Response
        =================================================================================== */
    badmt.Receive = function(reqcmd, rcvData, sender){
        var jsondata = null, htmldata = null, resdata = null;
        var pos = 0; 
        var cmd = Number(reqcmd); 
    
        console.log("badmt.Receive cmd = " + reqcmd); 
        console.log("badmt.Receive rcvData = " + rcvData); 
        console.log("badmt.Receive ## = " + rcvData.indexOf("`##`")); 
    
        if ( cmd > badmt.CMD_DATAGUBUN  ){
            if ( rcvData.indexOf("`##`") !== -1 ){//json + html
                if( (pos = rcvData.indexOf("`!!`")) !== -1 )  // dummy html + json + html 일경우 json + html만 추출한다. `!!` dummy html 경계
                {
                    rcvData = rcvData.substring(pos+4);    
                }
    
                resdata = rcvData.split( "`##`" );
                jsondata =  resdata[0];
                if( jsondata !='') jsondata = JSON.parse(jsondata);
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
    
        console.log("Receve ... Display jsondata .. cmd = " + cmd); 
        console.log(jsondata); 
        if( jsondata != null) utx.printObj(jsondata); 
    
       switch(cmd) {
           case badmt.CMD_UPDATE_AMAUSER_INFO:   this.OnRcvUpdateAmaUser( reqcmd, jsondata, htmldata, sender );  break;     
           case badmt.CMD_RESEND_SMS_AMAUSER:   this.OnRcvResendSMS( reqcmd, jsondata, htmldata, sender );  break;     
           case badmt.CMD_REQ_DIRECTREG_AMAINFO:   this.OnRcvRegDirectInfo( reqcmd, jsondata, htmldata, sender );  break;     
           /*  =================================================================================== */
       }    
    };
    
    /*  ###################################################################################
            Html Draw Function
        ################################################################################### */
    badmt.OnDrawHTML =  function(reqcmd, jsondata, html, sender){
        console.log("OnDrawHTML = " + sender);         
    
        $("#"+sender).html(html);
    };
    
    badmt.OnWriteBeforeHTML =  function(reqcmd, jsondata, htmldata, sender ){
        ctx.writeHtmlBefore(sender, htmldata);
    };
    
    badmt.OndelCouponHTML =  function(sender){
        $("#"+sender).remove();
    };
    badmt.OnwritePop =  function(cmd, packet, html, sender){
        console.log("badmt.OnwritePop"); 
            
        if( $('#' + sender).length == 0 ){
            document.body.innerHTML = "<div class='modal fade basic-modal coupon_modal' id='"+sender+"' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'></div>";
        }
        $('#' + sender).html(html);
        $('#' + sender).modal('show');
    };
    badmt.OnAppendHTML = function(cmd, packet, html, sender){
        console.log("badmt.OnAppendHTML"); 
            
        $('#'+sender).append(html);
        $("body").scrollTop($("body")[0].scrollHeight);
    };
    
    /*  ###################################################################################
            request function 
        ################################################################################### */
    
    /* ===================================================================================    
            Request Modify Reg Info
        =================================================================================== */
        badmt.reqModRegInfo = function(sender, seq, name, birth, phone) {
            console.log("reqModRegInfo"); 
    
            var obj = {};
            obj.CMD = badmt.CMD_UPDATE_AMAUSER_INFO;    
            obj.SEQ = seq;
            obj.NAME = name;
            obj.BIRTH = birth; 
            obj.PHONE = phone;
            
            badmt.SendEx(sender, obj, badmt.ajaxUrl);
        }

    /* ===================================================================================    
            Request Send SMS
        =================================================================================== */
        badmt.reqResendSMS = function(sender, seq) {
            console.log("reqModRegInfo"); 
    
            var obj = {};
            obj.CMD = badmt.CMD_RESEND_SMS_AMAUSER;   
            obj.SEQ = seq;
            
            badmt.SendEx(sender, obj, badmt.ajaxUrl);
        }

    /* ===================================================================================    
            Insert Data For Direct Amature Regist ( 직접 등록 선수 데이터 배열에 넣기 )
        =================================================================================== */
        badmt.reqDirectReg = function(sender, aryData) {
            console.log(badmt.AddDataForDirectReg);     
            badmt.aryDirect.splice(0,badmt.aryDirect.length);
            badmt.aryDirect = aryData;

//            var len  = badmt.aryDirect.length;
//
//            for(i=0; i<len; i++)
//            {
//                strLog = utx.strPrintf("ary[{0}] = {1}<br>", i, badmt.aryDirect[i] );
//                document.write(strLog);
//            }            

            var obj = {};
            obj.CMD = badmt.CMD_REQ_DIRECTREG_AMAINFO;  
            obj.DINFO = badmt.aryDirect[0];
            obj.POS     = 0;
                    
            badmt.SendEx(sender, obj, badmt.ajaxUrl);
        }

        

    
    /*  ###################################################################################
           Req process After Receive From ajax
        ################################################################################### */
    
    /*  =================================================================================== 
           Recv req couponList for download  
           더보기 버튼 Hide , 쿠폰 List를 동적으로 Insert
        =================================================================================== */
        badmt.OnRcvUpdateAmaUser =  function(cmd, packet, html, sender){
    
            var retCode;
            console.log("badmt.OnRcvResendSMS"); 
    
            if( utx.hasown(packet, "result") ) retCode = packet.result;
            
            switch(retCode)
            {
                case "1": strMsg = "선수 정보 변경이 완료되었습니다."; break;       // 선수정보 셋팅 완료
                case "91": strMsg = "사용자 정보를 확인할수 없습니다. 1 \n 다시 시도해 주세요"; break;       // seq key가 값이 없다
                case "92": strMsg = "사용자 정보를 확인할수 없습니다. 2 \n 다시 시도해 주세요"; break;       // seq key로 해당 User를 찾지 못했다
                case "93": strMsg = "사용자 정보를 확인할수 없습니다. 3 \n 다시 시도해 주세요"; break;       // 인증된 User가 tblMember에 없다. 
                case "94": strMsg = "사용자 정보를 확인할수 없습니다. 4 \n 다시 시도해 주세요"; break;       // 인증된 User가 tblMemberHistory에 없다. 
            }

            console.log("badmt.OnRcvUpdateAmaUser msg = " + strMsg );

            if(strMsg != undefined && strMsg != "") 
            {
                alert(strMsg);
                if(retCode == 1 ) 
                {
                   location.reload(true);
                }
            }   
        };

    /*  =================================================================================== 
           Recv Resend SMS
        =================================================================================== */
        badmt.OnRcvResendSMS =  function(cmd, packet, html, sender){
    
            var retCode;
            console.log("badmt.OnRcvResendSMS"); 
    
            if( utx.hasown(packet, "result") ) retCode = packet.result;
            
            switch(retCode)
            {
                case "1": strMsg = "SMS 재전송 셋팅이 완료되었습니다."; break;       // 재전송 셋팅 완료
                case "91": strMsg = "사용자 정보를 확인할수 없습니다. 1 \n 다시 시도해 주세요"; break;       // seq key가 값이 없다
                case "92": strMsg = "사용자 정보를 확인할수 없습니다. 2 \n 다시 시도해 주세요"; break;       // seq key로 해당 User를 찾지 못했다
            }

            console.log("badmt.OnRcvReqCouponDown msg = " + strMsg );

            if(strMsg != undefined && strMsg != "") 
            {
                alert(strMsg);
                if(retCode == 1 ) 
                {
                   location.reload(true);
                }
            }             
        };

    /*  =================================================================================== 
       Recv req All Coupons download : 모든 쿠폰 다운로드 요청 
            Erorr code에 따른 Error 메시지 Box Display 
                Result 91: 다운로드 Count Over, Set Result 92: 다운로드 조건 불충분
            성공일 경우 해당하는 Download 성공 MsgBox Display   
    =================================================================================== */
    badmt.OnRcvRegDirectInfo =  function(cmd, packet, html, sender){
        var retCode, strMsg, strTitle, cp_seq, id_item;
        var pos = 0, len = badmt.aryDirect.length; 

        if( utx.hasown(packet, "result") ) retCode = packet.result;        
        if( utx.hasown(packet, "POS") ) pos = packet.POS;

        var strLog = utx.strPrintf("badmt.OnRcvReqCouponDown pos = {0}, len = {1}", )
        console.log(strLog); 
        
        strTitle = "SDA MALL"
        
        if(len-1 == pos) {
            badmt.aryDirect.splice(0,len);
            
            strMsg = "Direct Info 등록이 완료되었습니다.";    
            alert(strMsg);
            return; 
        }
        
        // 아이디를 다 보낼때 까지 Loop를 돈다. 
        pos = Number(pos)+1; 
        packet.POS      = pos;       
        packet.DINFO    = badmt.aryDirect[pos];   
        badmt.SendEx(sender, packet, badmt.ajaxUrl);
    };