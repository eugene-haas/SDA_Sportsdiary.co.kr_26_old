var ver = "?ver=12"
var bbsidx = localStorage.getItem('bbsEditoridx');
if (!bbsidx) {
    bbsidx = 0;
}
//객체(이벤트 처리)
var mx_player = mx_player || {};
////////////////////////////////////////
mx_player.CMD_PageMove = 1; //'페이지이동
mx_player.CMD_AUTOCOMPLETE = 100;//'유저 검색
mx_player.CMD_PLAYSEARCH = 100;//'유저 검색

mx_player.CMD_MEMBERSEARCH = 102; //통합계정검색

mx_player.CMD_PLAYERFIND = 101; //'검색된 유저 정보 가져올때
mx_player.CMD_FIND_player_Name = 103; //'유저 검색
mx_player.CMD_TeamSEARCH = 200; //'팀조회 등록
mx_player.CMD_PLAYERREG = 300; //'참가신청 등록
mx_player.CMD_PLAYERUDATE = 301; //'참가신청 수정
mx_player.CMD_PLAYERDEL = 400; //'참가신청 취소

mx_player.CMD_PLAYER_Pwd_check = 500; //'패스워드 체크 페이지 이동 Write.asp
mx_player.CMD_PLAYER_Pwd_ok = 501; //'패스워드 체크 성공 체크

mx_player.CMD_DATAGUBUN = 10000;
mx_player.CMD_CONTESTAPPEND = 30000; //대회정보
mx_player.CMD_CONTESTAPPENDAdd = 30001; //대회정보 더보기

mx_player.CMD_Request_Edit_s = 30002; //'참가신청내역 상세 조회
mx_player.CMD_Request_Edit_s1 = 30003; //'참가신청내역 상세 조회
mx_player.CMD_EDITOR = 40000; //'모집요강 조회

mx_player.CMD_player_bbsEditor = 40001; //'선수정보 수정 요청 팝업
mx_player.CMD_player_bbsEditorOK = 40002; //'선수정보 수정 저장

mx_player.CMD_LMS_SEND = 50000; //''참가신청완료 및 문자 발송
mx_player.CMD_LMS_SEND_OK = 50001; //''참가신청완료 및 문자 발송

mx_player.CMD_Search_game = 70000; // 셀렉트 박스 대회 조회
mx_player.CMD_Search_level = 70001; // 셀렉트 박스 부 조회

mx_player.CMD_PHONECHK = 401; //폰번호 중복체크


mx_player.CMD_SELECTSIDO = 60001; //시도검색
mx_player.CMD_LEVELCHK = 60002; //레벨선택
////////////////////////////////////////
/**
* S :공통 ajax 호출 처리 로직
* 추가 : 2017-11-06 김주영
*/
mx_player.ajaxURL = "/pub/ajax/" +location.hostname.split(".")[0].toLowerCase().replace('admin','') + "/mobile/reqTennisatt.asp";


mx_player.IsHttpSuccess = function (r) {
    try {
        return (!r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined");
    }
    catch (e) {

    }
    return false;
};

mx_player.HttpData = function (r, type) {
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
mx_player.SendPacket = function (sender, packet, TargetUrl) {
    var datatype = "mix";
    var timeout = 4500;
    var reqcmd = packet.CMD;
    var reqdone = false; //Closure
    var url = TargetUrl;
	if (TargetUrl == undefined){
		url = mx_player.ajaxURL;
	}
    var strdata = "REQ=" + encodeURIComponent(JSON.stringify(packet));
    var xhr = new XMLHttpRequest();
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    setTimeout(function () { reqdone = true; }, timeout);

    $("#LoadingBar").html("<div style='text-align:center;'><p><img src='./imgs/ownageLoader/loader4.gif' style='max-width:30px;'/></p></div>").show();
    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && !reqdone) {
            if (mx_player.IsHttpSuccess(xhr)) {
                mx_player.ReceivePacket(reqcmd, mx_player.HttpData(xhr, datatype), sender, packet);
            }
            xhr = null;
        }
    };
    console.log(JSON.stringify(packet));
    xhr.send(strdata);
};

mx_player.ReceivePacket = function (reqcmd, data, sender, packet) {// data는 response string
    var rsp = null;
    var callback = null;
    var resdata = null;

    var jsondata = null;
    var htmldata = null;

    if (Number(reqcmd) > mx_player.CMD_DATAGUBUN) {
        try {
            if (data.indexOf("`##`") !== -1) {
                resdata = data.split("`##`");
                jsondata = resdata[0];
                htmldata = resdata[1];

                if (jsondata != '') { jsondata = JSON.parse(jsondata); }
            }
            else {

                htmldata = data;
                jsondata = JSON.parse(data);

            }
        }
        catch (ex) {
            $("#LoadingBar").hide();
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
    mx_player.ReceiveData = obj;

    if (jsondata != '' && jsondata != null) {
        switch (Number(jsondata.result)) {
            case 0: break;
            case 1: alert('데이터가 존재하지 않습니다.'); return; break;
            case 2: alert('이미 신청된 사용자가 있습니다.'); return; break;
            case 3: alert('등록되지 않은 선수가 존재합니다.'); return; break;
            case 4: alert('신청 내역이 존재하지 않습니다.'); return; break;
            case 5: alert('예선 등록 취소 후 선수를 변경할 수 있습니다.'); return; break;
            case 10: alert('등록할 수 없는 문자열이 있습니다.'); return; break;
            case 11: alert('비밀번호가 일치 하지 않습니다.'); return; break;
            case 31: alert('비밀번호가 일치 하지 않습니다.'); return; break;
            case 50: alert('이미참가신청되었습니다.'); return; break;
            case 52: alert('참가신청 마감 되었습니다.'); return; break;
            case 53: alert('참가신청 수정이 마감 되었습니다.'); return; break;
            case 54: alert('참가신청 취소는 마감 되었습니다.'); return; break;
            case 60: alert('참가신청 접수 되었습니다.'); break;
            case 61: alert('참가신청 수정 되었습니다.'); break;
            case 62: alert('참가신청 삭제 되었습니다.'); break;
            case 63: alert('인원수 제한으로 참가 대기로 접수 되었습니다.'); break;
            case 64: console.log("sns 발송 중지 /" + jsondata.lmsSendChk + "//" + jsondata.phI + "//" + jsondata.phI_seq); return; break;
            case 70: alert('선수정보 변경 요청이 완료 되었습니다.'); break;
            case 71: alert('선수정보 변경 요청이 수정 되었습니다.'); break;


            case 82: console.log("레벨조회"); break;
            case 83: console.log("레벨조회 실패"); break;

            case 96: alert('이미 접수된 참가자 입니다. 확인 후 다시 신청 해주시기 바랍니다.'); return; break;
            case 97: alert('참가자 이름이 없습니다.'); return; break;
            case 99: alert('이미 접수된 파트너 입니다. 확인 후 다시 신청 해주시기 바랍니다.'); return; break;

            case 100: return; break; //메시지 없슴
            case 999: console.log("참가 신청 중복사용자"); return; break;
            case 101: alert("등록된 전화번호 입니다. ");	$("#"+sender).focus().val(""); return; break;
        }
    }
    switch (Number(reqcmd)) {
        case mx_player.CMD_LEVELCHK:
		
		case mx_player.CMD_SELECTSIDO:
        case mx_player.CMD_Search_game: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_player.CMD_Search_level: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_player.CMD_AUTOCOMPLETE: this.findPlayer(reqcmd, jsondata, htmldata, sender); break;
        case mx_player.CMD_EDITOR: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_player.CMD_player_bbsEditor: this.OndrowHTML_editer(reqcmd, jsondata, htmldata, sender); break;
        case mx_player.CMD_Request_Edit_s: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_player.CMD_Request_Edit_s1: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_player.CMD_LMS_SEND: this.OnAppendHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_player.CMD_CONTESTAPPEND: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_player.CMD_CONTESTAPPENDAdd: this.OnAppendHTML(reqcmd, jsondata, htmldata, sender); break;

        case mx_player.CMD_PHONECHK: return; break;
	}

    //조회
    //저장 후 처리
    if (mx_player.CMD_player_bbsEditorOK == Number(reqcmd)) {
        //idx저장
        bbsidx = jsondata.idx;
        localStorage.setItem("bbsEditoridx", bbsidx);
    }

    if (mx_player.CMD_PLAYER_Pwd_check == Number(reqcmd)) {
        //페이지 이동
        var sf = document.frm_in;
        sf.ChekMode.value = 1;
        sf.action = "./write.asp";
        sf.submit();
    }
    if (mx_player.CMD_PLAYER_Pwd_ok == Number(reqcmd)) {
        //페이지 이동
        if (jsondata.action == "1") {
            //삭제
            DataDelete();
        } else if (jsondata.action == "2") {
            //수정
            savedata(jsondata.action);
        }
    }

    if (mx_player.CMD_PLAYERDEL == Number(reqcmd)) {
        //문자 발송
        alert("삭제되었습니다.");
        chk_frm(999);
    }

    if (mx_player.CMD_PLAYERUDATE == Number(reqcmd)) {
        //문자 발송
        $("#ridx").val(String(jsondata.ridx));
        $("#ChekMode").val(1);
        chk_frm(888);
    }
    if (mx_player.CMD_PLAYERREG == Number(reqcmd)) {
        //문자 발송
        $("#ridx").val(String(jsondata.ridx));
        $("#ChekMode").val(1);
        chk_frm(888);
    }

    if (mx_player.CMD_LMS_SEND == Number(reqcmd)) {
        var formid = String(jsondata.fromid);
        var frm = $("#" + formid);
        frm.target = "hiddenFrame";
        frm.submit();
    }

    if (mx_player.CMD_Request_Edit_s == Number(reqcmd) || mx_player.CMD_Request_Edit_s1 == Number(reqcmd)) {

        $("#attname").val(String(jsondata.UserName));
        $("#attphone").val(String(jsondata.UserPhone));
        $("#attphone1").val(String(jsondata.UserPhone1));
        $("#attphone2").val(String(jsondata.UserPhone2));
        $("#attphone3").val(String(jsondata.UserPhone3));
        $("#inbankname").val(String(jsondata.PaymentNm));
        $("#attask").val(String(jsondata.txtMemo));
        $("#attpwd").val(String(jsondata.UserPass));

        if (mx_player.CMD_Request_Edit_s1 == Number(reqcmd)) {

            $("#SmsFormSubmit").html("");
            //문자 발송
            var ph1 = $("#attphone").val();
            var ph1nm = $("#attname").val();
            var ph1bnm = $("#inbankname").val();

            var ph2 = $("#p1phone").val();
            var ph2idx = $("#p1idx").val();
            var ph2nm = $("#p1name").val();
            var ph2tnm = $("#p1team1txt").val();

            var obja = {};
            obja.CMD = mx_player.CMD_LMS_SEND;
            obja.tidx = $("#GameTitleIDX").val();
            obja.tidxNm = $("#GameTitleName").val();

            obja.TeamGb = $("#TeamGb").val();
            obja.TeamGbNm = $("#TeamGbNm").val();

            obja.levelno = $("#levelno").val();
            obja.levelNm = $("#levelNm").val();

            obja.ridx = $("#ridx").val();
            obja.ph1 = $("#attphone").val();
            obja.ph1nm = $("#attname").val();
            obja.ph1bnm = $("#inbankname").val();

            obja.ph2 = $("#p1phone").val();
            obja.ph2idx = $("#p1idx").val();
            obja.ph2nm = $("#p1name").val();
            obja.ph2tnm = $("#p1team1txt").val();

            if (ph2) {
                obja.phPhone = ph2;
                obja.phI = 2;
                obja.phI_seq = 1;

                if (ph2.length >= 10 && ph2.indexOf("*") == -1) {
                    mx_player.SendPacket("SmsFormSubmit", obja, mx_player.ajaxURL);
                }
            }


        } else {
            mx_player.init();
        }
    }
};

//그리기
mx_player.OndrowHTML = function (cmd, packet, html, sender) {
    document.getElementById(sender).innerHTML = html;
};
mx_player.OndrowHTML_editer = function (cmd, packet, html, sender) {
    document.getElementById(sender).innerHTML = html;
};

//추가 그리기
mx_player.OnAppendHTML = function (cmd, packet, html, sender) {
    $('#' + sender).append(html);
};

//선처리(추후 수정)
mx_player.OnBeforeHTML = function (cmd, packet, html, sender) {

};
//후처리(추후 수정)
mx_player.OnAfterHTML = function (cmd, packet, html, sender) {

};

/**
* E : ajax
**/
var INFO_Request = INFO_Request = JSON.parse(localStorage.getItem('INFO_Request'));

if (!INFO_Request) {
    INFO_Request = {};
}

$(document).ready(function () {
    $("#LoadingBar").hide();

    window.onpopstate = function (event) {
        $(".close").click();
        console.log("onpopstate");
        if (history.state == null) {
            //location.href = "./list.asp"
        } else {
            history.back();
        }
    };

    $('#myModal').on('shown.bs.modal', function (e) {
        history.pushState({ page: 1, name: '팝업' }, '', '?popup');
    });

    $('#myModal_game').on('shown.bs.modal', function (e) {
        history.pushState({ page: 1, name: '팝업' }, '', '?popup');
    });

    $('#myModal').on('hidden.bs.modal', function (e) {
        if (history.state == null) {
            //location.href = "./list.asp"
        } else {
            history.back();
        }
    });


});

function fnkeyup(obj) {
    var objid = obj.id;
	//빈값 체크 및 제거
    var values = obj.value;

	// 스페이스 체크
	checkSpace(values,objid);
	// 특수 문자가 있나 없나 체크
	checkSpecial(values,objid);

	mx_player.init();

    if (objid == "Fnd_K") {
        $("#pidx").val("");
        $("#Fnd_Kw").val("");
    }
}


function checkSpecial(str,valid) {
  //console.log("checkSpecial");
  var deny_char = /^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|+-ㅣ\u318D\u119E\u11A2\u2022\u2025a\u00B7\uFE55]+$/gi;
  var regExp = /\s/g;
  var SPECIAL_PATTERN = /[~!@#$%^&*\=,.'":/|<>?;{}]/gi;
  var intext = str.replace(regExp, "");

	// 특수 문자가 있나 없나 체크
	if (!deny_char.test(intext) && intext) {
		alert("영문자와 한글,숫자만을 입력하세요");

		if (SPECIAL_PATTERN.test(intext)==false)
		{
			$("#"+valid).focus().val("");
		}else{
			$("#"+valid).focus().val(intext.replace(SPECIAL_PATTERN, ""));
		}
		return;
	}

}

function checkSpace(str,valid) {
   var regExp = /\s/g;
	// 스페이스 체크
	if(regExp.test(str)) {
		alert(" 띄어쓰기는 사용 할 수 없습니다."); $("#"+valid).focus().val(str.replace(regExp, ""));
		return;
	}

}



mx_player.init = function () {
    /*이름 조회*/

    $("#Fnd_K").autocomplete({
        //조회를 위한 최소글자수
        minLength: 1,
        autoFocus: false,
        focus: function (event, ui) {
            return;
        },
        source: function (request, response) {
            $("#pidx").val("");
            $("#Fnd_Kw").val("");

            request.term = request.term.replace(/ /g, '').replace(/,/g, '');
           // $("#Fnd_K").val(request.term);

            var objval = $.trim(request.term);
            if (objval == "" || $.trim(objval) == "") {
                console.log("빈값");
                return;
            }

			console.log(  JSON.stringify({ "CMD": mx_player.CMD_FIND_player_Name, "SVAL": request.term, "tidx": $("#tidx").val(), "levelno": $("#levelno").val() })  );

            $.ajax({
                type: 'post',
                url: mx_player.ajaxURL,
                dataType: "json",
                data: { "REQ": JSON.stringify({ "CMD": mx_player.CMD_FIND_player_Name, "SVAL": request.term, "tidx": $("#tidx").val(), "levelno": $("#levelno").val() }) },
                success: function (data) {
                    response(
                                        $.map(data, function (item) {
                                            if (typeof item.name == "undefined") { }
                                            else {
                                                return {
                                                    label: item.name + "(" + item.phone + ")" + "(" + item.tm1 + ")",
                                                    value: item.name,
                                                    uidx: item.idx,
                                                    name: item.name,
                                                    tm1c: item.tm1c,
                                                    tm1: item.tm1,
                                                    phone: item.phone,
                                                    phone1: item.phone1
                                                }
                                            }
                                        })
                                    )
                }, error: function (request, status, error) { }
            });
        },
        select: function (event, ui) {
            /*참가자*/
            $("#pidx").val(ui.item.uidx);
            $("#Fnd_Kw").val(ui.item.name);
            $("#Fnd_K").val(ui.item.name);
        }
    });


    /*참가자*/
    $("#p1name").autocomplete({
        //조회를 위한 최소글자수
        minLength: 1,
        autoFocus: false,
        focus: function (event, ui) {
            return;
        },
        source: function (request, response) {
            $("#p1idx").val("");
            $("#p1team1txt").attr("disabled", false).val("");
//            $("#p1team2txt").attr("disabled", false).val("");
            $("#p1phone").val();
            $("#p1phone1").attr("disabled", false).val("010");
            $("#p1phone2").attr("disabled", false).val("");
            $("#p1phone3").attr("disabled", false).val("");
            var labelstr = "";

            request.term = request.term.replace(/ /g, '').replace(/,/g, '');
          //  $("#p1name").val(request.term);

            var objval = $.trim(request.term);
            if (objval == "" || $.trim(objval) == "") {
                console.log("빈값");
                return;
            } else if (!$("#levelno").val()) {
                $("#levelno").focus();
                alert("부서를 선택해주시기 바랍니다.");
                return;
            }
            $.ajax({
                type: 'post',
                url: mx_player.ajaxURL,
                dataType: "json",
                data: { "REQ": JSON.stringify({ "CMD": mx_player.CMD_PLAYSEARCH, "SVAL": request.term, "tidx": $("#GameTitleIDX").val(), "levelno": $("#levelno").val() }) },
                success: function (data) {
                    response(
                                        $.map(data, function (item) {
                                            // console.log(item);
                                            if (typeof item.name == "undefined") { }
                                            else {
                                                if (Number(item.idx) == 0 ) {
                                                    labelstr = "미가입";
                                                    item.name = request.term;
                                                }
                                                else {
                                                    labelstr = item.label;
                                                }

                                                return {
                                                    label: labelstr,
                                                    value: item.name,
                                                    uidx: item.idx,
                                                    name: item.name,
                                                    tm1c: item.tm1c,
                                                    tm1: item.tm1,
                                                    tm2c: item.tm2c,
                                                    tm2: item.tm2,
                                                    phone: item.phone,
                                                    phone1: item.phone1,
                                                    ReIDX1: item.ReIDX1,
                                                    ReIDX2: item.ReIDX2

                                                }
                                            }
                                        })
                                    )
                }, error: function (request, status, error) { }
            });
        },
        select: function (event, ui) {
            if (Number(ui.item.uidx) == 0) {
                $("#p1idx").val("");
                $("#p1team1").attr("disabled", false).val("");
                $("#p1team1txt").attr("disabled", false).val("");

                $("#p1phone").val("");
                $("#p1phone1").attr("disabled", false).val("010");
                $("#p1phone2").attr("disabled", false).val("");
                $("#p1phone3").attr("disabled", false).val("");
                // console.log(ui.item);
                return;
            }

            /*체크*/
            if (ui.item.ReIDX1 || ui.item.ReIDX2) {
                alert("해당 부에 기존 참가 신청정보가 있어 추가 참가 신청을 할 수 없습니다.");
                $("#p1idx").val("");
                $("#p1name").val("");
                $("#p1team1").attr("disabled", false).val("");
                $("#p1team1txt").attr("disabled", false).val("");
                $("#p1team2").attr("disabled", false).val("");
                $("#p1team2txt").attr("disabled", false).val("");
                $("#p1phone").val("");
                $("#p1phone1").attr("disabled", false).val("010");
                $("#p1phone2").attr("disabled", false).val("");
                $("#p1phone3").attr("disabled", false).val("");
            } else {
                /*참가자*/
                console.log(1112);
                $("#p1idx").val(ui.item.uidx);
                $("#p1name").val(ui.item.name);

                $("#p1team1").attr("disabled", true).val(ui.item.tm1c);
                $("#p1team1txt").attr("disabled", true).val(ui.item.tm1);

                $("#p1team2").attr("disabled", true).val(ui.item.tm2c);
                $("#p1team2txt").attr("disabled", true).val(ui.item.tm2);
                $("#p1phone").val(ui.item.phone1);
                var phoneStr = ui.item.phone.split("-");
                if (ui.item.phone1 != "") {
                    $("#p1phone1").attr("disabled", true).val(phoneStr[0]);
                    $("#p1phone2").attr("disabled", true).val(phoneStr[1]);
                    $("#p1phone3").attr("disabled", true).val(phoneStr[2]);
                } else {
                    $("#p1phone1").attr("disabled", false).val("010");
                    $("#p1phone2").attr("disabled", false).val("");
                    $("#p1phone3").attr("disabled", false).val("");
                }

                /*신청자*/
                $("#attname").val(ui.item.name);
                $("#attphone").val(ui.item.phone1);
                if (ui.item.phone1 != "") {
                    $("#attphone1").val(phoneStr[0]);
                    $("#attphone2").val(phoneStr[1]);
                    $("#attphone3").val(phoneStr[2]);
                } 

                /*입금자*/
                $("#inbankname").val(ui.item.name);
                $("#attpwd").val("");

            }
        }
    });

    /*파트너******************************************************************************/


    /*참가자 팀1*/
    $("#p1team1txt").autocomplete({
        minLength: 1,
        autoFocus: false,
        focus: function (event, ui) {
            return;
        },
        source: function (request, response) {

            $("#p1team1").val("");

            request.term = request.term.replace(/ /g, '').replace(/,/g, '');
         //   $("#p1team1txt").val(request.term);
            var objval = $.trim(request.term);
            if (objval == "" || $.trim(objval) == "") {
                console.log("빈값");
                return;
            }
            $.ajax({
                type: 'post',
                url: mx_player.ajaxURL,
                dataType: "json",
                data: { "REQ": JSON.stringify({ "CMD": mx_player.CMD_TeamSEARCH, "SVAL": request.term }) },
                success: function (data) {
                    response($.map(data, function (item) {
                        if (typeof item.TeamCode == "undefined" || typeof item.TeamName == "undefined") { }
                        else {
                            return {
                                label: item.TeamName + "(" + item.TeamCode + ")",
                                value: item.TeamName,
                                uidx: item.TeamCode,
                                name: item.TeamName,
								addr:item.addr,
								jangname:item.jangname
                            }
                        }
                    }))
                }, error: function (request, status, error) { }
            });
        },
        select: function (event, ui) {
			/*참가자*/
			$("#p1team1").val(ui.item.uidx);
			$("#p1team1txt").val(ui.item.name);

			var arr = ui.item.addr.split("_");
			$('#sidogb1span').html('<select  id="sidogb1" disabled><option value="'+arr[0]+'" >'+arr[1]+'</option></select><select  id="googun1" disabled><option value="'+arr[2]+'">'+arr[2]+'</option></select>');



			$("#jangname").val(ui.item.jangname);
        }
    });


};


mx_player.ptnUndefined = function(){
	if ($("#ptn_undefined").is(":checked") == true) {
		$("#p2name").attr( 'placeholder', '::  \'미정\'  신청완료해주세요 :: ' );
		$("#p2name").attr("readonly",true);
		$("#p2name").attr("disabled",true);
	}
	else{
		$("#p2name").attr( 'placeholder', ':: 이름을 입력하세요 ::' );
		$("#p2name").attr("readonly",false);
		$("#p2name").attr("disabled",false);
	}
};

mx_player.teamUndefined = function(ckboxid, txtid,hideid){
	if ($("#"+ckboxid).is(":checked") == true) {
		$("#"+txtid).attr( 'placeholder', '::  없음 :: ' );
		$("#"+txtid).attr("readonly",true);
		$("#"+txtid).attr("disabled",true);

		$("#"+hideid).val('');
		$("#"+txtid).val('');
	}
	else{
		$("#"+txtid).attr( 'placeholder', ':: 클럽명을 입력하세요 ::' );
		$("#"+txtid).attr("readonly",false);
		$("#"+txtid).attr("disabled",false);
	}
};


mx_player.chkBoo = function(){
	if ( $("#levelno").val().substr(0,5) == "20105") { //오픈부라면
		$("#p1openboornk").show();
		$("#p2openboornk").show();
	}
	else{
		$("#p1openboornk").hide();
		$("#p2openboornk").hide();
	}
};

mx_player.ChkPhoneNum = function(pnoid1,pnoid2,pnoid3){
   var no1 = $("#"+pnoid1).val();
   var no2 = $("#"+pnoid2).val();
   var no3 = $("#"+pnoid3).val();

   if (no2 == '' || no3== '' ){
	   return;
   }

   var pno = no1 + no2 + no3;
   var obj = {};
   obj.CMD = mx_player.CMD_PHONECHK;
   obj.PHONENO = pno;
   mx_player.SendPacket(pnoid3, obj, mx_player.ajaxURL);
};




///////////////////////////////////////////
mx_player.SelectSido = function(sdno) {
	  var GbVal = $("#sidogb"+sdno).val();
	  var obj = {};
	  obj.CMD = mx_player.CMD_SELECTSIDO;
	  obj.SDNO = sdno;
	  obj.GB = GbVal;
	  mx_player.SendPacket('sidogb' + sdno + 'span', obj);
};


mx_player.targetlevelID = 'lvl1';
mx_player.SelectLevel = function(tidx){
	if( $('input:radio[name=a]').is(':checked')  == false ){
		alert('항목중 한개를 선택해 주십시오.');
		return;
	}

	var mychoice = $(":input:radio[name=a]:checked").val();
	if( mx_player.targetlevelID  == "lvl2" ){
		$("#"+mx_player.targetlevelID).val(mychoice);
		$('#myModal_level').modal('hide');
		return;
	}
	else{	
		$("#"+mx_player.targetlevelID).val(mychoice);
		$('#myModal_level').modal('hide');

		var obj = {};
		obj.CMD = mx_player.CMD_LEVELCHK;
		obj.MYCHOICE = mychoice;
		obj.TIDX = tidx;
		mx_player.SendPacket('attboo', obj);
	}
};

mx_player.levelcheck = function(){
	if ( $('#lvl1').val() == "" && $('#lvl2').val() == ""  ){
		alert('레벨을 선택해 주십시오.');
		return;
	}
};

mx_player.levelSH = function(){
	if ( $("#levelno").val().substr(0,5) == "20101" || $("#levelno").val().substr(0,5) == "20104" ) { //1스타
		 $('#2starchk').hide();
	}
	else{ //투스타
		 $('#1starchk').hide();	
	}
};

mx_player.myinfocheck = function(){
	if ( $('#lvl1').val() == ""  ){
		alert('본인의 레벨을 먼저 선택해 주십시오.');return;
	}
	if ($("#levelno").val() == "") {
		alert("출전부서를 선택 해주시기 바랍니다."); return;
	}
};