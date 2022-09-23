/*  =================================================================================== 
    Purpose : ajax와 통신하는 js 파일 UI Coupon (쿠폰 사용자 화면 )
    Make    : 2019.01.17
    Author  :                                                       By Aramdry
    =================================================================================== */

var adbadmt = adbadmt || {}

/*  =================================================================================== 
       쿠폰 페이지들을 이동한다. ( 쿠폰홈, 발급, 발급관리, 지도자 쿠폰 )
    =================================================================================== */
// Data 구분자 - ( html + json data ) 유무 
adbadmt.CMD_DATAGUBUN = 10000; // ( json + html data )

// ============================ Badminton
adbadmt.CMD_UTIL_MIN = 50000;

adbadmt.CMD_MAKETONAMENT_AMAUSER = 50001; // 대진표를 만든다. 
adbadmt.CMD_REGTONAMENT_AMAUSER = 50002; 	// 대진표를 등록한다 
adbadmt.CMD_JO_DIVIDE_AMAUSER = 50010; 	// 조를 나눈다

adbadmt.CMD_TEST_MAKETONAMENT_AMAUSER = 51001; // 개발단 테스트 대진표를 만든다. 
adbadmt.CMD_TEST_JO_DIVIDE_AMAUSER    = 51010; // 개발단 테스트 조를 나눈다. 

adbadmt.CMD_COPY_WEBPAGE = 51101; // Web Page를 복사한다. 

adbadmt.CMD_UTIL_MAX = 59999;

//  ===================================================================================        
//  ===================================================================================  
adbadmt.ajaxUrl = "../../Ajax/etc/req.util.asp";
adbadmt.ajaxType = "POST"
adbadmt.ajaxDataType = "text"

/*  ###################################################################################
        ajax system function 
    ################################################################################### */

/*  =================================================================================== 
       쿠폰 페이지들을 이동한다. ( 쿠폰홈, 발급, 발급관리, 지도자 쿠폰 )
    =================================================================================== */
adbadmt.goCpnPage = function(packet, gourl) {
    document.sform.p.value = JSON.stringify(packet);
    document.sform.action = gourl;
    document.sform.submit();
};

/*  =================================================================================== 
       
    =================================================================================== */
adbadmt.goPage = function(packet, pageno) {
    packet.PN = pageno;
    var gourl = location.href;

    document.ssform.p.value = JSON.stringify(packet);
    document.ssform.action = gourl;
    document.ssform.submit();
};

/*  =================================================================================== 
    // 쿠폰 메인 페이지 - 검색        
    =================================================================================== */
adbadmt.goSearch = function(packet, pageno, f1, f2, f3) {
    packet.F1 = f1;
    packet.F2 = f2;
    packet.F3 = f3;
    packet.PN = pageno;
    var gourl = location.href;

    document.cp_sform.p.value = JSON.stringify(packet);
    document.cp_sform.action = gourl;
    document.cp_sform.submit();
};

/*  =================================================================================== 
    // 쿠폰 발급 페이지 검색 
    =================================================================================== */
adbadmt.goSearchEx = function(packet, pageno) {
    packet.PN = pageno;
    var gourl = location.href;

    document.pub_sform.p.value = JSON.stringify(packet);
    document.pub_sform.action = gourl;
    document.pub_sform.submit();
};

/*  =================================================================================== 
    // Ajax Call 
    =================================================================================== */
adbadmt.SendEx = function(sender, packet, reqUrl) {
    var strData = "REQ=" + encodeURIComponent(JSON.stringify(packet));

    console.log(utx.strReplaceAll(JSON.stringify(packet), '\"', '\"\"'));

    $.ajax({
        url: reqUrl,
        type: adbadmt.ajaxType,
        data: strData,
        dataType: adbadmt.ajaxDataType,
        success: function(rcvData) {
            adbadmt.Receive(packet.CMD, rcvData, sender);
        }
    });
};


/*  =================================================================================== 
    // Ajax Call Response
    =================================================================================== */
adbadmt.Receive = function(reqcmd, rcvData, sender) {
    var jsondata = null,
        htmldata = null,
        resdata = null;
    var pos = 0;
    var cmd = Number(reqcmd);

    console.log("adbadmt.Receive cmd = " + reqcmd);
    console.log("adbadmt.Receive rcvData = " + rcvData);
    console.log("adbadmt.Receive ## = " + rcvData.indexOf("`##`"));
    console.log("adbadmt.Receive #!!# = " + rcvData.indexOf("`#!!#`"));

    if (cmd > adbadmt.CMD_DATAGUBUN) {
        if (rcvData.indexOf("`##`") !== -1) { //json + html
            if ((pos = rcvData.indexOf("`!!`")) !== -1) // dummy html + json + html 일경우 json + html만 추출한다. `!!` dummy html 경계
            {
                rcvData = rcvData.substring(pos + 4);
            }

            resdata = rcvData.split("`##`");
            jsondata = resdata[0];
            if (jsondata != '') jsondata = JSON.parse(jsondata);
            htmldata = resdata[1];
        } else if (rcvData.indexOf("`#!!#`") !== -1) { //html+json
            if ((pos = rcvData.indexOf("`!!`")) !== -1) // dummy html + html + json 일경우 json + html만 추출한다. `!!` dummy html 경계
            {
                rcvData = rcvData.substring(pos + 4);
            }

            resdata = rcvData.split("`#!!#`");
            jsondata = resdata[1];
            if (jsondata != '') jsondata = JSON.parse(jsondata);
            htmldata = resdata[0];
		  } else if(rcvData.indexOf('"state":' !== -1)) // json data
		  {
				if (jsondata != '') jsondata = JSON.parse(rcvData);
		  }
		  else { //html
            htmldata = rcvData;
        }
    } else { //json
        if (typeof rcvData == 'string') { jsondata = JSON.parse(rcvData); } else { jsondata = rcvData; }
    }

    if (jsondata != '' && jsondata != null) {
        switch (Number(jsondata.result)) {
            case 1:
                break;
            case 99:
                alert('데이터가 존재하지 않습니다.');
                return;
            case 100:
                return; //메시지 없슴
        }
    }

    console.log("Receve ... Display jsondata .. cmd = " + cmd);
    console.log(jsondata);
    if (jsondata != null) utx.printObj(jsondata);

    switch (cmd) {
		case adbadmt.CMD_MAKETONAMENT_AMAUSER:
			this.OnRcvMakeTonamentAmaUser(reqcmd, jsondata, htmldata, sender);
			break;
		case adbadmt.CMD_REGTONAMENT_AMAUSER:
			this.OnRcvRegTonamentAmaUser(reqcmd, jsondata, htmldata, sender);
			break;
		case adbadmt.CMD_TEST_MAKETONAMENT_AMAUSER:
			this.OnRcvMakeTonamentAmaUserTest(reqcmd, jsondata, htmldata, sender);
			break;		
		case adbadmt.CMD_TEST_JO_DIVIDE_AMAUSER:
			this.OnRcvJoDivideAmaUserTest(reqcmd, jsondata, htmldata, sender);
			break;
		case adbadmt.CMD_COPY_WEBPAGE:
			this.OnRcvCopyWebPage(reqcmd, jsondata, htmldata, sender);
			break;
            /*  =================================================================================== */
    }
};

/*  ###################################################################################
        Html Draw Function
    ################################################################################### */
adbadmt.OnDrawHTML = function(reqcmd, jsondata, html, sender) {
    console.log("OnDrawHTML = " + sender);

    $("#" + sender).html(html);
};

adbadmt.OnWriteBeforeHTML = function(reqcmd, jsondata, htmldata, sender) {
    ctx.writeHtmlBefore(sender, htmldata);
};

adbadmt.OndelCouponHTML = function(sender) {
    $("#" + sender).remove();
};
adbadmt.OnwritePop = function(cmd, packet, html, sender) {
    console.log("adbadmt.OnwritePop");

    if ($('#' + sender).length == 0) {
        document.body.innerHTML = "<div class='modal fade basic-modal coupon_modal' id='" + sender + "' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'></div>";
    }
    $('#' + sender).html(html);
    $('#' + sender).modal('show');
};
adbadmt.OnAppendHTML = function(cmd, packet, html, sender) {
    console.log("adbadmt.OnAppendHTML");

    $('#' + sender).append(html);
    $("body").scrollTop($("body")[0].scrollHeight);
};

/*  ###################################################################################
        request function 
    ################################################################################### */

/* ===================================================================================    
        Request Modify Reg Info
    =================================================================================== */
adbadmt.reqMakeTonamentAmaUser = function(sender, sendInfo, gameNum, gameNumDt, IsDoubleGame) {
	 console.log("reqMakeTonamentAmaUser");
	 
	 var strUrl = "../../Ajax/etc/api/db.ama.draw.asp"; 

    var obj = {};
    obj.CMD = adbadmt.CMD_MAKETONAMENT_AMAUSER;
    obj.SINFO = sendInfo;
    obj.GNUM = gameNum;
    obj.GDNUM = gameNumDt;
    obj.DBGAME = IsDoubleGame;

    adbadmt.SendEx(sender, obj, strUrl);
}

/* ===================================================================================    
        Request Send SMS
    =================================================================================== */
adbadmt.reqReGTonamentAmaUser = function(sender, gameNumDt, strGGroupIdx) {
    console.log("reqReGTonamentAmaUser");

    var obj = {};
    obj.CMD = adbadmt.CMD_REGTONAMENT_AMAUSER;
    obj.LevelDtl = gameNumDt;
    obj.RequestGroupIDX = strGGroupIdx;

    adbadmt.SendEx(sender, obj, adbadmt.ajaxUrl);
}

/* ===================================================================================    
         Test - develop version 분리 Request Modify Reg Info
     =================================================================================== */
adbadmt.reqMakeTonamentAmaUserTest = function(sender, sendInfo, gameNum, gameNumDt, IsDoubleGame) {
	var strUrl = "../../Ajax/etc/api/db.ama.draw.dev.asp";    

    var obj = {};
    obj.CMD = adbadmt.CMD_TEST_MAKETONAMENT_AMAUSER;
    obj.SINFO = sendInfo;
    obj.GNUM = gameNum;
    obj.GDNUM = gameNumDt;
    obj.DBGAME = IsDoubleGame;

    console.log(obj);
	 adbadmt.SendEx(sender, obj, strUrl);
	 
	 console.log("reqMakeTonamentAmaUserTest");
}

/* ===================================================================================    
		  Test - develop version 분리 
		  Ama Jo 자동 분배 
    =================================================================================== */
	 adbadmt.reqJoDivideAmaUserTest = function(sender, titleIdx, lvDtlIdx, joCount, IsDoubleGame) {
		var strUrl = "../../Ajax/etc/api/db.ama.jo.divide.asp";		
  
		var obj = {};
		obj.CMD = adbadmt.CMD_TEST_JO_DIVIDE_AMAUSER;
		obj.TITLEIDX = titleIdx;
		obj.LVDTL = lvDtlIdx;		
		obj.JOCOUNT = joCount;
		obj.DBGAME = IsDoubleGame;
  
		adbadmt.SendEx(sender, obj, strUrl);

		console.log("reqJoDivideAmaUserTest");
  }

/* ===================================================================================    
        Request Send SMS
    =================================================================================== */
adbadmt.reqCopyWebPage = function(sender, strUrl, strNewUrl, strName) {
    console.log("reqReGTonamentAmaUser");

    var obj = {};
    obj.CMD = adbadmt.CMD_COPY_WEBPAGE;
    obj.URL = strUrl;
    obj.NAME = strName;
    obj.NEWURL = strNewUrl;

    adbadmt.SendEx(sender, obj, adbadmt.ajaxUrl);
}

/*  ###################################################################################
       Req process After Receive From ajax
    ################################################################################### */

/*  =================================================================================== 
       Recv req Make Tonament AmaUser Draw
    =================================================================================== */
adbadmt.OnRcvMakeTonamentAmaUser = function(cmd, packet, html, sender) {

	var retCode, strGroupIdxs, strAryPos = "", IsDblGame, posData, strInfo;
	IsDblGame = 0; 
	console.log("adbadmt.OnRcvMakeTonamentAmaUser");
	console.log("패킷:" + packet);

	if (packet == null) {
		 alert("해당 대진에 참가팀이 없습니다. 참가팀을 등록해 주세요");
		 return;
	}

	if (utx.hasown(packet, "IsDblGame")) IsDblGame = parseInt(packet.IsDblGame);
	if (utx.hasown(packet, "strGroupIdx")) strGroupIdxs = packet.strGroupIdx;
	if (utx.hasown(packet, "posData")) {

	  posData = packet.posData; 
	  var i, len = posData.length; 

	  if(IsDblGame = 1) {

		  for(i = 0; i<len; i++) {
			  strAryPos += utx.sprintf("{0}, {1}, {2}, {3} / {4}, {5}, {6} <br>", 
					  i+1, posData[i].user1, posData[i].team1, posData[i].region1, posData[i].user2, posData[i].team2, posData[i].region2);
			  if(i && (i+1) % 4 == 0)	strAryPos += "<br>"
		  }

		  strAryPos += "<br><br><br>"
		  for(i = 0; i<len; i++) {
			  strAryPos += utx.sprintf("{0}, {1}, {2}, {3} <br>", i+1, posData[i].user1, posData[i].team1, posData[i].region1);
			  strAryPos += utx.sprintf("{0}, {1}, {2}, {3} <br>", i+1, posData[i].user2, posData[i].team2, posData[i].region2);
			  if(i && (i+1) % 4 == 0)	strAryPos += "<br>"
		  }

		  strAryPos += "<br><br><br>"
		  for(i = 0; i<len; i++) {
			  strAryPos += utx.sprintf("{0}, {1}, {2}, {3} <br>", i+1, posData[i].user1, posData[i].team1, posData[i].region1);		
			  if(i && (i+1) % 4 == 0)	strAryPos += "<br>"
		  }
	  }
	  else {
		  for(i = 0; i<len; i++) {
			  strAryPos = utx.sprintf("{0}, {1}, {2}, {3} <br>", i+1, posData[i].user, posData[i].team, posData[i].region);		
			  if(i && (i+1) % 4 == 0)	strAryPos += "<br>"
		  }
	  }
	  
  }

  strInfo = utx.sprintf("<br><br>{0}", strAryPos);
  adbadmt.OnAppendHTML(cmd, packet, strInfo, sender);
  if (strGroupIdxs != undefined) adbadmt.OnAppendHTML(cmd, packet, strGroupIdxs, "div_gGroupIdx");

};

// adbadmt.OnRcvMakeTonamentAmaUser = function(cmd, packet, html, sender) {

// 	var retCode, strGroupIdxs, sendInfo;
// 	console.log("adbadmt.OnRcvMakeTonamentAmaUser");
// 	console.log("패킷:" + packet);

// 	if (packet == null) {
// 		 alert("해당 대진에 참가팀이 없습니다. 참가팀을 등록해 주세요");
// 		 return;
// 	}

// 	if (utx.hasown(packet, "gGroupIdx")) strGroupIdxs = packet.gGroupIdx;
// 	if (utx.hasown(packet, "SINFO")) sendInfo = packet.SINFO;

// 	adbadmt.OnAppendHTML(cmd, packet, html, sender);
// 	if (strGroupIdxs != undefined) adbadmt.OnAppendHTML(cmd, packet, strGroupIdxs, sendInfo);
// };

/*  =================================================================================== 
       Recv req Regist Tonament AmaUser Draw
    =================================================================================== */
adbadmt.OnRcvRegTonamentAmaUser = function(cmd, packet, html, sender) {

    var retCode, strGroupIdxs, sendInfo, strMsg;
    console.log("adbadmt.OnRcvRegTonamentAmaUser");

    if (utx.hasown(packet, "result")) retCode = packet.result;

    switch (retCode) {
        case "1":
            strMsg = "대진표가 생성되었습니다.";
            break; // 다운로드 Count Over
        case "90":
            strMsg = "경기가 진행 중이거나 종료되어 대진 추첨을 진행할수 없습니다 .";
            break; // 쿠폰이 없거나, User Info가 없다.
    }

    alert(strMsg);
};

/*  =================================================================================== 
        Test - develop version 분리 Recv req Make Tonament AmaUser Draw
     =================================================================================== */
adbadmt.OnRcvMakeTonamentAmaUserTest = function(cmd, packet, html, sender) {

	 var retCode, strGroupIdxs, strAryPos = "", IsDblGame, posData, strInfo;
	 IsDblGame = 0; 
    console.log("adbadmt.OnRcvMakeTonamentAmaUserTest");
    console.log("패킷:" + packet);

    if (packet == null) {
        alert("해당 대진에 참가팀이 없습니다. 참가팀을 등록해 주세요");
        return;
    }

	 if (utx.hasown(packet, "IsDblGame")) IsDblGame = parseInt(packet.IsDblGame);
    if (utx.hasown(packet, "strGroupIdx")) strGroupIdxs = packet.strGroupIdx;
    if (utx.hasown(packet, "posData")) {

		posData = packet.posData; 
		var i, len = posData.length; 

		if(IsDblGame = 1) {

			for(i = 0; i<len; i++) {
				strAryPos += utx.sprintf("{0}, {1}, {2}, {3} / {4}, {5}, {6} <br>", 
						i+1, posData[i].user1, posData[i].team1, posData[i].region1, posData[i].user2, posData[i].team2, posData[i].region2);
				if(i && (i+1) % 4 == 0)	strAryPos += "<br>"
			}

			strAryPos += "<br><br><br>"
			for(i = 0; i<len; i++) {
				strAryPos += utx.sprintf("{0}, {1}, {2}, {3} <br>", i+1, posData[i].user1, posData[i].team1, posData[i].region1);
				strAryPos += utx.sprintf("{0}, {1}, {2}, {3} <br>", i+1, posData[i].user2, posData[i].team2, posData[i].region2);
				if(i && (i+1) % 4 == 0)	strAryPos += "<br>"
			}

			strAryPos += "<br><br><br>"
			for(i = 0; i<len; i++) {
				strAryPos += utx.sprintf("{0}, {1}, {2}, {3} <br>", i+1, posData[i].user1, posData[i].team1, posData[i].region1);		
				if(i && (i+1) % 4 == 0)	strAryPos += "<br>"
			}
		}
		else {
			for(i = 0; i<len; i++) {
				strAryPos = utx.sprintf("{0}, {1}, {2}, {3} <br>", i+1, posData[i].user, posData[i].team, posData[i].region);		
				if(i && (i+1) % 4 == 0)	strAryPos += "<br>"
			}
		}
		
	}

	strInfo = utx.sprintf("{0}<br><br>{1}", strGroupIdxs, strAryPos);
   adbadmt.OnAppendHTML(cmd, packet, strInfo, sender);
  //  if (strGroupIdxs != undefined) adbadmt.OnAppendHTML(cmd, packet, strGroupIdxs, sendInfo);
};

/*  =================================================================================== 
        Test - develop version 분리 Recv req Make Tonament AmaUser Draw
     =================================================================================== */
	  adbadmt.OnRcvJoDivideAmaUserTest = function(cmd, packet, html, sender) {

		var retCode, strGroupIdxs, strAryUser = "", IsDblGame, userData, strInfo, joNo = 0, curJo = 0;
		var cnt = 0; 
		IsDblGame = 0; 
		console.log("adbadmt.OnRcvMakeTonamentAmaUserTest");
		console.log("패킷:" + packet);
  
		if (packet == null) {
			 alert("해당 대진에 참가팀이 없습니다. 참가팀을 등록해 주세요");
			 return;
		}
  
		if (utx.hasown(packet, "IsDblGame")) IsDblGame = parseInt(packet.IsDblGame);		
		if (utx.hasown(packet, "userData")) {
  
			userData = packet.user; 
		  var i, len = userData.length; 
  
		  if(IsDblGame = 1) {
			for(i = 0; i<len; i++) {
				joNo = parseInt(userData[i].joNo); 

				if(curJo != joNo) 
				{
					if(curJo != 0) strAryUser += "<br><br>"; 
					curJo = joNo;		
					cnt = 0; 			  
				}
					
				cnt++; 
				strAryUser += utx.sprintf("{0}조 - {1}, {2}, {3}, {4} / {5}, {6}, {7}<br>", 
						userData[i].joNo, cnt, userData[i].MemberName, userData[i].TeamName, userData[i].RegionNm, userData[i+1].MemberName, userData[i+1].TeamName, userData[i+1].RegionNm);
				i++;
			}
		
			strAryUser += "<br><br><br><br>"; 

			  for(i = 0; i<len; i++) {
				  joNo = parseInt(userData[i].joNo); 

				  if(curJo != joNo) 
				  {
					  if(curJo != 0) strAryUser += "<br><br>"; 
					  curJo = joNo;		
					  cnt = 0; 			  
				  }
					  
				  cnt++; 
				  strAryUser += utx.sprintf("{0}조 - {1}, {2}, {3}, {4} <br>", userData[i].joNo, cnt, userData[i].MemberName, userData[i].TeamName, userData[i].RegionNm);
				  strAryUser += utx.sprintf("{0}조 - {1}, {2}, {3}, {4} <br><br>", userData[i+1].joNo, cnt, userData[i+1].MemberName, userData[i+1].TeamName, userData[i+1].RegionNm);		  
				  i++;
			  }
		  
			  strAryUser += "<br><br><br><br>"; 

			  for(i = 0; i<len; i++) {
				joNo = parseInt(userData[i].joNo); 

				if(curJo != joNo) 
				{
					if(curJo != 0) strAryUser += "<br><br>"; 
					curJo = joNo;		
					cnt = 0; 			  
				}
					
				cnt++; 
				strAryUser += utx.sprintf("{0}조 - {1}, {2}, {3}, {4}<br>", userData[i].joNo, cnt, userData[i].MemberName, userData[i].TeamName, userData[i].RegionNm);
				i++;
			}
		  }
		  else {
			  for(i = 0; i<len; i++) {
					joNo = parseInt(userData[i].joNo); 

					if(curJo != joNo) 
					{
						if(curJo != 0) strAryUser += "<br><br>"; 
						curJo = joNo;		
						cnt = 0; 			  
					}
						
					cnt++;
					strAryUser += utx.sprintf("{0}조 - {1}, {2}, {3}, {4}>", userData[i].joNo, cnt, userData[i].MemberName, userData[i].TeamName, userData[i].RegionNm);
			  }
		  }
		  
	  }
  
	  	strInfo = utx.sprintf("{0}<br><br>{1}", strGroupIdxs, strAryUser);  
		adbadmt.OnAppendHTML(cmd, packet, strInfo, sender);
  };

/*  =================================================================================== 
        Test - develop version 분리 Recv req Make Tonament AmaUser Draw
     =================================================================================== */
adbadmt.OnRcvCopyWebPage = function(cmd, packet, html, sender) {

    if (utx.hasown(packet, "result")) retCode = packet.result;

    switch (retCode) {
        case "1":
            strMsg = "WebPage복사가 성공하였습니다.";
            ctx.setTextboxVal("txt_newUrl", packet.NEWURL);
            break; // 
        case "90":
            strMsg = "WebPage복사중 문제가 발생했습니다.";
            break; // 
    }

    alert(strMsg);
};