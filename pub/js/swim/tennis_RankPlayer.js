var ver = "?ver=4"
var bbsidx = localStorage.getItem('bbsEditoridx');
if (!bbsidx) {
    bbsidx = 0;
}
//객체(이벤트 처리)
var mx_Rankplayer = mx_Rankplayer || {};
////////////////////////////////////////
mx_Rankplayer.CMD_PageMove = 1; //'페이지이동 
mx_Rankplayer.CMD_PointUpdate = 10; //' 포인트 수정
mx_Rankplayer.CMD_Pointinsert = 20; //' 포인트 수정


mx_Rankplayer.CMD_title_search = 40; //' 대회검색
mx_Rankplayer.CMD_player_search = 50; //' 선수명검색

mx_Rankplayer.CMD_DATAGUBUN = 10000;
mx_Rankplayer.CMD_drowHTML = 11001; //' Inner html 
mx_Rankplayer.CMD_AppendHTML = 12001; //'appen html
mx_Rankplayer.CMD_RemoveHTML = 13001; //' remove html 

////////////////////////////////////////


/**
* S :공통 ajax 호출 처리 로직
* 추가 : 2017-11-06 김주영
*/
mx_Rankplayer.IsHttpSuccess = function (r) {
    try {
        return (!r.status && location.protocol == "file:" || (r.status >= 200 && r.status < 300) || r.status == 304 || navigator.userAgent.indexOf("Safari") >= 0 && typeof r.status == "undefined");
    }
    catch (e) {

    }
    return false;
};

mx_Rankplayer.HttpData = function (r, type) {
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
mx_Rankplayer.SendPacket = function (sender, packet, TargetUrl) {
    var datatype = "mix";
    var timeout = 500;
    var reqcmd = packet.CMD;
    var reqdone = false; //Closure
    var url = mx_Rankplayer.defultUrl + TargetUrl;
    var strdata = "REQ=" + encodeURIComponent(JSON.stringify(packet));
    var xhr = new XMLHttpRequest();
    xhr.open("POST", url);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    setTimeout(function () { reqdone = true; }, timeout);

    $("#LoadingBar").html("<div style='text-align:center;'><p><img src='./imgs/ownageLoader/loader4.gif' style='max-width:30px;'/></p></div>").show();

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && !reqdone) {
            if (mx_Rankplayer.IsHttpSuccess(xhr)) {
                mx_Rankplayer.ReceivePacket(reqcmd, mx_Rankplayer.HttpData(xhr, datatype), sender, packet);
            }
            xhr = null;
        }
    };
    console.log(JSON.stringify(packet));
    xhr.send(strdata);
};

mx_Rankplayer.ReceivePacket = function (reqcmd, data, sender, packet) {// data는 response string
    var rsp = null;
    var callback = null;
    var resdata = null;

    var jsondata = null;
    var htmldata = null;

    if (Number(reqcmd) > mx_Rankplayer.CMD_DATAGUBUN) {
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
    mx_Rankplayer.ReceiveData = obj;

    if (jsondata != '' && jsondata != null) {
        switch (Number(jsondata.result)) {
            case 0: console.log("완료"); break;
            case 1: alert("오류 발생"); return; break;
            case 3: alert(jsondata.msg); return; break;
            case 4: alert(jsondata.msg); console.log(jsondata); break;
        }
    }




    mx_Rankplayer.OnBeforeHTML(reqcmd, jsondata, htmldata, sender);
    switch (Number(reqcmd)) {
        case mx_Rankplayer.CMD_drowHTML: this.OndrowHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_Rankplayer.CMD_AppendHTML: this.OnAppendHTML(reqcmd, jsondata, htmldata, sender); break;
        case mx_Rankplayer.CMD_RemoveHTML: this.OnRemoveHTML(reqcmd, jsondata, htmldata, sender); break;
    }
    mx_Rankplayer.OnAfterHTML(reqcmd, jsondata, htmldata, sender);
};

mx_Rankplayer.defultUrl = "/pub/api/" +location.hostname.split(".")[0].toLowerCase() + "/RankPlayer/";
//mx_Rankplayer.defultUrl = "/pub/api/tennisadmin/RankPlayer/";
$(document).ready(function () {
    $("#LoadingBar").hide();
    mx_Rankplayer.TableSearch(1);

    mx_Rankplayer.init();
});

//조회
mx_Rankplayer.TableSearch = function (Nkey) {
    var obj = {};
    //기본처리 방법
    if (Nkey == 1) {
        obj.CMD = mx_Rankplayer.CMD_drowHTML;
    } else {
        obj.CMD = mx_Rankplayer.CMD_AppendHTML;
    }
    //후처리 방법 없으면 빈값
    obj.subCMD = mx_Rankplayer.sub_CMD_TableSearch;
    obj.groupcode = "";// $("#groupcode").val();
    obj.groupgrade = $("#gamegrade").val();  
    obj.gametitle = $("#gametitle").val();
    obj.teamGb = $("#teamgb").val();
    obj.userName = $("#userName").val();
    obj.NKEY = Nkey; 

    mx_Rankplayer.SendPacket("contest", obj, "api.tableselect.asp");
};

mx_Rankplayer.TrSelect = function (key) {
    var obj = {};
    //기본처리 방법
    obj.CMD = mx_Rankplayer.CMD_drowHTML;
    //후처리 방법 없으면 빈값
    obj.subCMD = "";
    obj.inputkey = key;
    obj.groupcode = ""; 
    obj.groupgrade = $("#gamegrade").val();
    obj.gametitle = $("#gametitle").val();
    obj.teamGb = $("#teamgb").val();
    obj.userName = $("#userName").val();
    obj.NKEY = 1;

    mx_Rankplayer.SendPacket("gameinput_insert_Contents", obj, "api.tableselect.asp");
};

mx_Rankplayer.changePoint = function (val) {
    var inputId = val.id;
    var inputkey = val.id.split("_")[1];
    var inputval = val.value;

    if (isNaN(inputval) == true) {
        val.value = $("#onPoint_" + inputkey).html();
        return false;
    } else {
        //수정 
        var obj = {};
        obj.CMD = mx_Rankplayer.CMD_PointUpdate;
        obj.subCMD = mx_Rankplayer.sub_CMD_PointIn;
        obj.inputkey = inputkey;
        obj.inputval = inputval;
        obj.defultval = $("#onPoint_" + inputkey).html();
        mx_Rankplayer.SendPacket("", obj, "api.PointUpdate.asp");
    }
};

//그리기
mx_Rankplayer.OndrowHTML = function (cmd, packet, html, sender) {
    document.getElementById(sender).innerHTML = html;
}; 

//추가 그리기
mx_Rankplayer.OnAppendHTML = function (cmd, packet, html, sender) {
    $('#' + sender).append(html);
};

//html remove
mx_Rankplayer.OnRemoveHTML = function (cmd, packet, html, sender) {
    $('#' + sender).remove();
};


//선처리(추후 수정)
mx_Rankplayer.OnBeforeHTML = function (cmd, packet, html, sender) {

};

mx_Rankplayer.sub_CMD_TableSearch = 1; //조회 후 더보기 ( 다음 번호 ) 처리 
mx_Rankplayer.sub_CMD_PointIn = 2; //조회 후 더보기 ( 다음 번호 ) 처리 
mx_Rankplayer.sub_CMD_insertTr_clear = 3; //등록창 초기화

//후처리(추후 수정)
mx_Rankplayer.OnAfterHTML = function (cmd, packet, html, sender) {
    if (packet.subCMD == mx_Rankplayer.sub_CMD_TableSearch) {
        $("#NKEY").val(packet.NKEY);
        if (packet.lastpage == "_ing") {
            $("#morebox").show();
            $("#NKEY1").prop("href", "javascript:mx_Rankplayer.TableSearch($('#NKEY').val());");
        } else {
            $("#morebox").hide();
            $("#NKEY1").prop("href", "javascript:;");
        }
        $("#nownum").html(packet.intNowCnt);
        $("#totnum").html(packet.intTotalCnt);
        $("#nowcnt").html(packet.nowKEY);
        $("#totcnt").html(packet.intTotalPage);
    }
    else if (packet.subCMD == mx_Rankplayer.sub_CMD_PointIn) {
        if (packet.result == "0") {
            $("#onPoint_" + packet.inputkey).html(packet.inputval);
            alert("포인트가 변경 되었습니다.");
        } else {
            $("#upPoint_" + packet.inputkey).html(packet.defultval);
        }
    }
    else if (packet.subCMD == mx_Rankplayer.sub_CMD_insertTr_clear) {
        $("#gametitle").val(packet.i_titlename);
        $("#teamgb").val(packet.i_teamGb);
        $("#userName").val(packet.i_playername);
        mx_Rankplayer.TableSearch(1);
    }
};

/**
* E : ajax 
**/
var INFO_Request = INFO_Request = JSON.parse(localStorage.getItem('INFO_Request'));

if (!INFO_Request) {
    INFO_Request = {};
}


mx_Rankplayer.btnSaveOpen = function (idxx) {
//    if (idxx == 1) {
//        $("#gameinput_insert").show();
//        $("#btnsaveOpen").prop("href", "javascript:mx_Rankplayer.btnSaveOpen(2);").html("등록창 닫기(C)");
//    } else {
//        $("#gameinput_insert").hide();
//        $("#btnsaveOpen").prop("href", "javascript:mx_Rankplayer.btnSaveOpen(1);").html("등록창 열기(O)");
//    }

    mx_Rankplayer.btnSaveInputDefult();

}


mx_Rankplayer.btnDelete = function (key) {
    var obj = {};
    //기본처리 방법
    obj.CMD = mx_Rankplayer.CMD_RemoveHTML;
    //후처리 방법 없으면 빈값
    obj.subCMD = "";
    obj.inputkey = key;
    if (confirm("삭제 하시겠습니까? ")) {
       mx_Rankplayer.SendPacket("Point_tr_" + key, obj, "api.PointDel.asp");
    }
}

function fnkeyup(obj) {
    if (obj.id == "i_point") {
        var numPattern = /([^0-9])/;
        var numPattern = obj.value.match(numPattern);
        if (numPattern != null) {
            alert("숫자만 입력해 주세요!");
            obj.value = "";
            obj.focus();
        }
    } else {
        if (obj.id == "i_titlename") {
            $("#i_groupcode").val("");
            $("#i_groupcodeName").val("");
            $("#i_groupgrade").val("");
            $("#i_titleidx").val("");
            $("#i_titlegubun").val("");
        } else if (obj.id == "i_playername") {
            $("#i_playeridx").val("");
        }
        mx_Rankplayer.init();
    }
}
mx_Rankplayer.btnSave = function () {
    var i_groupcode = $("#i_groupcode").val();
    var i_groupcodeName = $("#i_groupcodeName").val();

    var i_groupgrade = $("#i_groupgrade").val();

    var i_titleidx = $("#i_titleidx").val();
    var i_titlename = $("#i_titlename").val();
    var i_titlegubun = $("#i_titlegubun").val();

    var i_teamGb = $("#i_teamGb").val();
    var i_teamGbName = $("#i_teamGb option:selected").text();  
    
    var i_rank = $("#i_rank").val();
    var i_playername = $("#i_playername").val();
    var i_playeridx = $("#i_playeridx").val();
    var i_point = $("#i_point").val();

    if (!i_groupcode || !i_groupgrade || !i_titleidx || !i_titlename) { $("#i_titlename").val("").focus(); alert("대회명 검색결과를 선택 하여 주시기 바랍니다."); return; }
    if (!i_teamGb) { $("#i_teamGb").focus(); alert("부(경기유형)을 선택 해주세요"); return; }
    if (!i_rank) { $("#i_rank").focus(); alert("랭크(순위)를 입력 해주세요"); return; }
    if (!i_playeridx || !i_playername) { $("#i_playername").val("").focus(); alert("선수명 검색 결과를 선택 하여 주시기 바랍니다."); return; }
    if (!i_point) { $("#i_point").focus(); alert("포인트가 없습니다."); return; }


    var obj = {};
    //기본처리 방법
    obj.CMD = mx_Rankplayer.CMD_Pointinsert;
    //후처리 방법 없으면
    obj.subCMD = mx_Rankplayer.sub_CMD_insertTr_clear;
    obj.i_groupcode = i_groupcode;
    obj.i_groupcodeName = i_groupcodeName;
    obj.i_groupgrade = i_groupgrade;
    obj.i_titleidx = i_titleidx;
    obj.i_titlename = i_titlename;
    obj.i_teamGb = i_teamGb;
    obj.i_teamGbName = i_teamGbName; 
    obj.i_rank = i_rank;
    obj.i_playername = i_playername;
    obj.i_playeridx = i_playeridx;
    obj.i_point = i_point;
    obj.i_titlegubun = i_titlegubun;

    mx_Rankplayer.SendPacket("", obj, "api.PointInsert.asp");

}

mx_Rankplayer.btnSaveInputDefult = function () {
    $("#i_groupcodeName").val("");
    $("#i_groupcode").val(""); 
    $("#i_groupgrade").val("");
    $("#i_titlename").val("");
    $("#i_titleidx").val("");
    $("#i_teamGb").val(""); 
    $("#i_rank").val("");
    $("#i_playername").val("");
    $("#i_playeridx").val("");
    $("#i_point").val("");
    $("#i_titlegubun").val("");
}



mx_Rankplayer.init = function () {
    $("#gametitle,#i_titlename").autocomplete({
        //조회를 위한 최소글자수
        minLength: 1,
        autoFocus: false,
        focus: function (event, ui) {
            return false;
        },
        source: function (request, response) {
            //기본처리 방법
            $.ajax({
                type: 'post',
                url: mx_Rankplayer.defultUrl + "api.find.asp",
                dataType: "json",
                data: { "REQ": JSON.stringify({ "CMD": mx_Rankplayer.CMD_title_search, "varStr": request.term, "gubun": "title", "subgubun": "search" }) },
                success: function (data) {
                    response(
                            $.map(data, function (item) {
                                if (typeof item.GameTitleName == "undefined") { }
                                else {
                                    return {
                                        label: item.GameTitleName,
                                        value: item.GameTitleName,
                                        GameTitleIDX: item.GameTitleIDX,
                                        GameTitleName: item.GameTitleName,
                                        titleCode: item.titleCode,
                                        titleCodeName: item.titleCodeName,
                                        titleGrade: item.titleGrade,
                                        titleGradeName: item.titleGradeName,
                                        titlegubun: item.titlegubun
                                    }
                                }
                            })
                        )
                }, error: function (request, status, error) { }
            });
        },
        select: function (event, ui) {
            var tid = event.target.id;
            if (tid == "gametitle") {
                $("#gamegrade").val(ui.item.titleGrade);
            } else if (tid == "i_titlename") {
                $("#i_groupcodeName").val(ui.item.titleCodeName);
                $("#i_groupcode").val(ui.item.titleCode);
                $("#i_groupgrade").val(ui.item.titleGrade);
                $("#i_titleidx").val(ui.item.GameTitleIDX);
                $("#i_titlegubun").val(ui.item.titlegubun);
            }
        }
    });

    $("#i_playername").autocomplete({
        //조회를 위한 최소글자수
        minLength: 1,
        autoFocus: false,
        focus: function (event, ui) {
            return false;
        },
        source: function (request, response) {
            //기본처리 방법
            $.ajax({
                type: 'post',
                url: mx_Rankplayer.defultUrl + "api.find.asp",
                dataType: "json",
                data: { "REQ": JSON.stringify({ "CMD": mx_Rankplayer.CMD_title_search, "varStr": request.term, "gubun": "player" }) },
                success: function (data) {
                    response(
                            $.map(data, function (item) {
                                if (typeof item.UserName == "undefined") { }
                                else {
                                    return {
                                        label: item.UserName + "(***-****-" + item.UserPhone + ")" + "[t1:" + item.TeamNm + "/t2:" + item.Team2Nm + "]",
                                        value: item.UserName,
                                        PlayerIDX: item.PlayerIDX,
                                        UserName: item.UserName,
                                        UserPhone: item.UserPhone,
                                        belongBoo: item.belongBoo,
                                        Team: item.Team,
                                        TeamNm: item.TeamNm,
                                        Team2: item.Team2,
                                        Team2Nm: item.Team2Nm
                                    }
                                }
                            })
                        )
                }, error: function (request, status, error) { }
            });
        },
        select: function (event, ui) {
            var tid = event.target.id;
            if (tid == "userName") {
            } else if (tid == "i_playername") {
                $("#i_playeridx").val(ui.item.PlayerIDX);
            }
        }
    });

}