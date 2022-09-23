var ver = "?ver=4"
var bbsidx = localStorage.getItem('bbsEditoridx');
if (!bbsidx) {
    bbsidx = 0;
}
//객체(이벤트 처리)
var mx_Sms = mx_Sms || {};
////////////////////////////////////////
mx_Sms.CMD_PageMove = 1; //'페이지이동 
mx_Sms.CMD_SmsSend = 2; //' 문자 발송

mx_Sms.CMD_DATAGUBUN = 10000;
mx_Sms.CMD_drowHTML = 11001; //' Inner html 
mx_Sms.CMD_AppendHTML = 12001; //'appen html
mx_Sms.CMD_RemoveHTML = 13001; //' remove html 

mx_Sms.CMD_SMSLOG = 40000;
////////////////////////////////////////


/**
* S :공통 ajax 호출 처리 로직
* 추가 : 2017-11-06 김주영
*/
mx_Sms.IsHttpSuccess = function (r) {
    try {
        return (!r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined");
    }
    catch (e) {

    }
    return false;
};

mx_Sms.HttpData = function (r, type) {
    var ct = r.getResponseHeader("Content-Type");
    var data = !type && ct && ct.indexOf("xml") >= 0;
    data = type == "xml" || data ? r.responseXML : r.responseText;
    if (type == "script") {
        eval.call("window", data);
    }
    else if (type == "mix") {
        if (data.indexOf("$$$$") !== -1) {
            var mixdata = data.split("$$$$");
            (function () { eval.call("window", mixdata[0]); } ());
            data = mixdata[1];
        }
    }
    return data;
};

//동일한 패킷이 오는경우 (막음 처리해야겠지)
mx_Sms.SendPacket = function (sender, packet, TargetUrl) {
    var datatype = "mix";
    var timeout = 500;
    var reqcmd = packet.CMD;
    var reqdone = false; //Closure
    var url = mx_Sms.defultUrl + TargetUrl;
    var strdata = "REQ=" + encodeURIComponent(JSON.stringify(packet));
    var xhr = new XMLHttpRequest();
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    setTimeout(function () { reqdone = true; }, timeout);

    $("#LoadingBar").html("<div style='text-align:center;'><p><img src='./imgs/ownageLoader/loader4.gif' style='max-width:30px;'/></p></div>").show();

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && !reqdone) {
            if (mx_Sms.IsHttpSuccess(xhr)) {
                mx_Sms.ReceivePacket(reqcmd, mx_Sms.HttpData(xhr, datatype), sender, packet);
            }
            xhr = null;
        }
    };
    console.log(JSON.stringify(packet));
    xhr.send(strdata);
};

mx_Sms.ReceivePacket = function (reqcmd, data, sender, packet) {// data는 response string
    var rsp = null;
    var callback = null;
    var resdata = null;

    var jsondata = null;
    var htmldata = null;

    if (Number(reqcmd) > mx_Sms.CMD_DATAGUBUN) {
        if (data.indexOf("`##`") !== -1) {
            resdata = data.split("`##`");
            jsondata = resdata[0];
            htmldata = resdata[1];

            if (jsondata != '') { jsondata = JSON.parse(jsondata); }
        }
        else {
            try {
                htmldata = data;
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

    $("#LoadingBar").hide();
    var obj = {};
    obj.htmldata = htmldata;
    obj.jsondata = jsondata;
    mx_Sms.ReceiveData = obj;

    if (jsondata != '' && jsondata != null) {
        switch (Number(jsondata.result)) {
            case 0: console.log("완료"); break;
            case 1: alert("오류 발생"); return; break;
            case 3: alert(jsondata.msg); return; break;
            case 4: alert(jsondata.msg); console.log(jsondata); break;
        }
    }

    mx_Sms.OnBeforeHTML(reqcmd, jsondata, htmldata, sender);
    switch (Number(reqcmd)) {
        case mx_Sms.CMD_drowHTML: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_Sms.CMD_AppendHTML: this.OnAppendHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_Sms.CMD_RemoveHTML: this.OnRemoveHTML(reqcmd, jsondata, htmldata, sender); break;
		case mx_Sms.CMD_SMSLOG:	this.OnListHTML( reqcmd, jsondata, htmldata, sender );		break;
	}
   mx_Sms.OnAfterHTML(reqcmd, jsondata, htmldata, sender);
};

mx_Sms.OnListHTML =  function(cmd, packet, html, sender){
	document.getElementById(sender).innerHTML = html;
	$('#'+sender).modal('show');
};



mx_Sms.defultUrl = "/pub/api/sms/";
$(document).ready(function () {

        $('#SMS_Contents').keyup(function(){
            cut_80(this);
        });
	
	
	$("#LoadingBar").hide();
    mx_Sms.ControlSearch();
//    mx_Sms.TableSearch(1);
    mx_Sms.init();
});


    /**
     * 한글포함 문자열 길이를 구한다
     */
    function getTextLength(str) {
        var len = 0;
        for (var i = 0; i < str.length; i++) {
            if (escape(str.charAt(i)).length == 6) {
                len++;
            }
            len++;
        }
        return len;
    }

    function cut_80(obj){
        var text = $(obj).val();
        var leng = text.length;
        while(getTextLength(text) > 80){
            leng--;
            text = text.substring(0, leng);
        }
        $(obj).val(text);
        $('#bytes').text(getTextLength(text));
    }





//컨트롤조회
mx_Sms.ControlSearch = function () {
    var obj = {};
    obj.CMD = mx_Sms.CMD_drowHTML;
    //후처리 방법 없으면 빈값
    obj.subCMD = mx_Sms.sub_CMD_TableSearch;
    obj.GameYears = $("#GameYears").val();
    obj.gametitle = $("#gametitle").val();
    obj.teamGb = $("#teamgb").val();
    obj.Level = $("#Level").val();
    obj.userName = $("#userName").val();
    obj.PaymentType = $("#PaymentType").val();
    

    mx_Sms.SendPacket("gameinput_area", obj, "api.Control.asp");
};
//조회
mx_Sms.TableSearch = function (Nkey) {
    var obj = {};
    //기본처리 방법
    if (Nkey == 1) {
        obj.CMD = mx_Sms.CMD_drowHTML;
    } else {
        obj.CMD = mx_Sms.CMD_AppendHTML;
    }
    //후처리 방법 없으면 빈값
    obj.subCMD = "";
    obj.GameYears = $("#GameYears").val();
    obj.gametitle = $("#gametitle").val();
    obj.teamGb = $("#teamgb").val();
    obj.Level = $("#Level").val();
    obj.userName = $("#userName").val();
    obj.PaymentType = $("#PaymentType").val();

    mx_Sms.SendPacket("contest", obj, "api.tableselect.asp");
};
//전체 체크
mx_Sms.chekall = function () {
    var $trCheck = $("#contest").find("input[type=checkbox]");
    if ($("#allCheck").prop("checked")) { //해당화면에 전체 checkbox들을 체크해준다 
        $trCheck.prop("checked", true); // 전체선택 체크박스가 해제된 경우 
    } else { //해당화면에 모든 checkbox들의 체크를해제시킨다. 
        $trCheck.prop("checked", false);
    }
}

//문자 보내기조회
mx_Sms.SmsSend = function () {
    var obj = {};
    obj.CMD = mx_Sms.CMD_SmsSend;
    //후처리 방법 없으면 빈값
    obj.SMS_title = $("#SMS_title").val();
    obj.SMS_Contents = $("#SMS_Contents").val().replace("\r\n", "<br>");
    obj.SMS_Send_No = $("#SMS_Send_No").val();
    obj.Level = $("#Level").val();
    obj.SMS_dtStart = $("#SMS_dtStart").val();
    obj.SMS_dtStartTime = $("#SMS_dtStartTime").val();
    //체크 된 전화면호 배열 처리
    if (!$("#SMS_Send_No").val()) { alert("발신번호가  없습니다."); $("#SMS_Send_No").focus(); return; }
    if (!$("#SMS_Contents").val()) { alert("문자 내용이 없습니다."); $("#SMS_Contents").focus(); return; }
    if (!$("#SMS_Send_No").val()) { alert("발신번호가 없습니다."); $("#SMS_Send_No").focus(); return; }

    if ($("#SMS_dtStart").val() || $("#SMS_dtStartTime").val()) {
        if (!$("#SMS_dtStart").val() && $("#SMS_dtStartTime").val()) { alert("날짜를 입력해 주세요"); $("#SMS_dtStart").focus(); return; }
        if (!$("#SMS_dtStartTime").val() && $("#SMS_dtStart").val()) { alert("시간을 입력해 주세요1"); $("#SMS_dtStartTime").focus(); return; }
        if ($("#SMS_dtStart").val().indexOf("-") == -1 || $("#SMS_dtStart").val().length < 10) {
            alert("날짜를 입력해 주세요"); $("#SMS_dtStart").focus().val(""); return;
        }
        if ($("#SMS_dtStartTime").val().indexOf(":") == -1 || $("#SMS_dtStartTime").val().length < 5) {
            alert("시간을 입력해 주세요2"); $("#SMS_dtStartTime").focus().val(""); return;
        }
    }


    var StrPhonNum = "";
    var $trCheck = $("#contest").find("input[type=checkbox]");
    $trCheck.each(function () {
        if ($(this).prop("checked")) {
            var id = $(this).prop("id").replace("chek", "");
            var P1_UserPhone = $("#P1_UserPhone" + id).html();
            var P2_UserPhone = $("#P2_UserPhone" + id).html();

            if (P1_UserPhone && P1_UserPhone.length >= 10) {
                StrPhonNum += P1_UserPhone + "|";
            }

            if (P2_UserPhone && P2_UserPhone.length >= 10) {
                StrPhonNum += P2_UserPhone + "|";
            }
        }
    }); 
     
    if ($("#SMS_Recive_No").val() && $("#SMS_Recive_No").val().length>=10 ) {
        if (!StrPhonNum) {
            if (confirm("" + $("#SMS_Recive_No").val() + " 해당번호로 발송 하시겠습니까?")) {
                StrPhonNum += $("#SMS_Recive_No").val() + "|";
            } else {
                return;
            }
        } else {
            StrPhonNum += $("#SMS_Recive_No").val() + "|";
        }
    }  

    obj.SMS_Recive_No = StrPhonNum;
    if (!StrPhonNum) {
        alert("문자를 받는 대상이 없습니다.");
        return;
    } else {
        console.log("문자발송");
        mx_Sms.SendPacket("", obj, "api.smsInsert.asp");
    }
};
//그리기
mx_Sms.OndrowHTML = function (cmd, packet, html, sender) {
    document.getElementById(sender).innerHTML = html;
};

//추가 그리기
mx_Sms.OnAppendHTML = function (cmd, packet, html, sender) {
    $('#' + sender).append(html);
};

//html remove
mx_Sms.OnRemoveHTML = function (cmd, packet, html, sender) {
    $('#' + sender).remove();
};


//선처리(추후 수정)
mx_Sms.OnBeforeHTML = function (cmd, packet, html, sender) {

};

mx_Sms.sub_CMD_TableSearch = 1; //조회 후 더보기 ( 다음 번호 ) 처리 
mx_Sms.sub_CMD_PointIn = 2; //조회 후 더보기 ( 다음 번호 ) 처리 
mx_Sms.sub_CMD_insertTr_clear = 3; //등록창 초기화

//후처리(추후 수정)
mx_Sms.OnAfterHTML = function (cmd, packet, html, sender) {
	if (packet != null ){

	if(packet.hasOwnProperty("subCMD")){

		if (packet.subCMD == mx_Sms.sub_CMD_TableSearch) {
			packet.subCMD = "";
		   // mx_Sms.SendPacket("contest", packet, "api.tableselect.asp");
		}

	}

	}
};

/**
* E : ajax 
**/
mx_Sms.init = function () {
     $(function() {
        $( "#SMS_dtStart" ).datepicker({ 
             changeYear:true,
             changeMonth: true, 
             dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
             monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
             showMonthAfterYear:true,
             showButtonPanel: true, 
             currentText: '오늘 날짜', 
             closeText: '닫기', 
             dateFormat: "yy-mm-dd" 
        });


        $( "#SMS_dtStartTime" ).timepicker({ 
            showPeriodLabels: false
        });
  });
};



mx_Sms.LogList = function(pageno){
	var obj = {};
	obj.CMD = mx_Sms.CMD_SMSLOG;
	obj.PAGENO = pageno;
    mx_Sms.SendPacket("myModal", obj, "api.loglist.asp");
};


