
$(document).ready(function () {

    if (getCookie("MemberIDX") == "") {
        alert("로그인정보가 없습니다.");
        chk_logout();
    }

    //    $(".input-group-addon").on("click", function (e) {
    //        $(location).attr('href', "../Schedule/sche-calendar.asp?SearchDate=" + $("#datetimepicker1").val());
    //    });
    $(".btn.btn-save").on("click", function (e) {




    });

    /*훈련 정상참석/ 일부참석 여부 */
    $("#train-check01").click(function () {
        var p_TEAMTRAI = $("#p_TEAMTRAI").val();
        if (p_TEAMTRAI == "Y") {
            alert("팀 매니저의 관리를 받고 있습니다. 출석 정보는 변경 할 수 없습니다.");
            return false;
        }

        $("#train-check01-select").hide();
        $("#train-check02-select").hide();
        $("#p_AdtInTp").val('A');
        $("#p_AdtMidCd").val(0);
        $("#p_AdtMidCd1").val(0);
        $('input:radio[name=train-check01-select]:input[value=0]').attr("checked", true);
        $('input:radio[name=train-check02-select]:input[value=0]').attr("checked", true);

        TRIAN_CHEK();
    });

    $("#train-check02").click(function () {
        var p_TEAMTRAI = $("#p_TEAMTRAI").val();
        if (p_TEAMTRAI == "Y") {
            alert("팀 매니저의 관리를 받고 있습니다. 출석 정보는 변경 할 수 없습니다.");
            return false;
        }

        $("#train-check01-select").show();
        $("#train-check02-select").show();
        $("#p_AdtInTp").val('B');
        $("#p_AdtMidCd1").val(0);
        $(".btn-or-pop").show();
        $('input:radio[name=train-check01-select]:input[value=0]').attr("checked", true);
        $('input:radio[name=train-check02-select]:input[value=0]').attr("checked", true);

        TRIAN_CHEK();
    });

    $("#datetimepicker1").on("change", function (e) {
        train_idx();
    });

    $("#TraiFistCd1").on("change", function (e) {
        //alert($(this).val());
    });

    $("#train-check01-select").on("change", function (e) {
        var p_TEAMTRAI = $("#p_TEAMTRAI").val();
        if (p_TEAMTRAI == "Y") {
            alert("팀 매니저의 관리를 받고 있습니다. 출석 정보는 변경 할 수 없습니다.");
            return false;
        }

        $("#p_AdtMidCd").val($(this).val());
        $("#p_AdtMidCd1").val(0);
        TRIAN_CHEK(); ;
    });
    $("#train-check01-select").on("click", function (e) {
        var p_TEAMTRAI = $("#p_TEAMTRAI").val();
        if (p_TEAMTRAI == "Y") {
            alert("팀 매니저의 관리를 받고 있습니다. 출석 정보는 변경 할 수 없습니다.");
            return false;
        }
    });
    $("#train-check02-select").on("change", function (e) {
        var p_TEAMTRAI = $("#p_TEAMTRAI").val();
        if (p_TEAMTRAI == "Y") {
            alert("팀 매니저의 관리를 받고 있습니다. 출석 정보는 변경 할 수 없습니다.");
            return false;
        }

        $("#p_AdtMidCd1").val($(this).val());
        $("#p_AdtMidCd").val(0);
        TRIAN_CHEK();
    });
    $("#train-check02-select").on("click", function (e) {
        var p_TEAMTRAI = $("#p_TEAMTRAI").val();
        if (p_TEAMTRAI == "Y") {
            alert("팀 매니저의 관리를 받고 있습니다. 출석 정보는 변경 할 수 없습니다.");
            return false;
        }
    });

    /*추후 수정 --팀메니저 연동*/
    $(".btn-navyline").click(function () {
        //        /*권한설정*/
        //        /*훈련 내역은 1개씩 중복 x*/
        //        var div = document.createElement('official-train-wrap3');

        //        div.innerHTML = document.getElementById('official-train-wrap1').innerHTML;
        //        document.getElementById('official-train-wrap').appendChild(div);
    });


    $(".btn-navy").click(function () {
        document.getElementById("datetimepicker1").value = document.getElementById("datetimepicker1").defaultValue;
    });


    $("input[name=memory-txt]:checkbox").each(function () {
        $(this).attr("checked", false);
    });


    //이전 페이지 체크

    var trainstatus = $("#trainstatus").val();

    console.log(trainstatus);

    var referrer = document.referrer;

    var strAjaxUrl = "/M_Player/select/train_idx.asp";
    var TrRerdDate = $("#datetimepicker1").val();
    if (trainstatus == 0) {

        //데이터 조회 일괄 처리 
        $.ajax({
            url: strAjaxUrl,
            type: 'POST',
            dataType: 'html',
            data: {
                TrRerdDate: TrRerdDate
            },
            success: function (retDATA) {
                document.getElementById("divTrRerdIDX").innerHTML = retDATA;

                //'심리적상태
                chage_search("condition");
                //훈련참석여부

                //부상 SELECT 정보
                chage_search("train-check01-select");
                chage_search("train-check02-select");
                //부상정보
                chage_search_JSON("injury-chk");

                //2. 목표 //tblSvcTrRerdTgt
                chage_search("train-goal-list");

                //3. 공식훈련
                chage_search("official-train-wrap");

                //4. 개인훈련
                chage_search("official-train-person");

                //5. 훈련평가 
                chage_search("tranin-question");

                //6. 메모리 //tblSvcTrRerd
                chage_search("memory");

                TRIAN_CHEK();


            }, error: function (xhr, status, error) {
                alert(status + "오류발생! - 시스템관리자에게 문의하십시오!" + error);
            }
        });
    }
});


//투데이 날짜 변경 후 조회
function DateToday() {
    var now = new Date();
    var year = now.getFullYear();
    var mon = (now.getMonth() + 1) > 9 ? '' + (now.getMonth() + 1) : '0' + (now.getMonth() + 1);
    var day = now.getDate() > 9 ? '' + now.getDate() : '0' + now.getDate();

    var chan_val = year + '-' + mon + '-' + day;

    $('#datetimepicker1').val(chan_val); 
    $('#datetimepicker1_h').val(chan_val);

    var datetimepicker1 = $('#datetimepicker1').val();
    var datetimepicker1_h = $('#datetimepicker1_h').val();

    train_idx();
}

//hiden 설정
function train_idx() {

    var strAjaxUrl = "/M_Player/select/train_idx.asp";
    var TrRerdDate = $('#datetimepicker1').val();

    //데이터 조회 일괄 처리
    $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
            TrRerdDate: TrRerdDate
        },
        success: function (retDATA) {
            document.getElementById("divTrRerdIDX").innerHTML = retDATA;

            //'심리적상태
            chage_search("condition");
            //훈련참석여부

            //부상 SELECT 정보
            chage_search("train-check01-select");
            chage_search("train-check02-select");
            //부상정보
            chage_search_JSON("injury-chk");

            //2. 목표 //tblSvcTrRerdTgt
            chage_search("train-goal-list");

            //3. 공식훈련
            chage_search("official-train-wrap");

            //4. 개인훈련
            chage_search("official-train-person");

            //5. 훈련평가 
            chage_search("tranin-question");

            //6. 메모리 //tblSvcTrRerd
            chage_search("memory");

            TRIAN_CHEK();

        }, error: function (xhr, status, error) {
            alert(status + "오류발생! - 시스템관리자에게 문의하십시오!" + error);
        }
    });
} 

//기본값 조회
function chage_search(id_value) {
    var strAjaxUrl = "/M_Player/select/train_Search.asp";
    var TrRerdDate = $('#datetimepicker1').val();
    var id = id_value;
    //데이터 조회 일괄 처리
    $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
            id: id_value,
            TrRerdDate: TrRerdDate,
            p_TrRerdIDX: document.getElementById("p_TrRerdIDX").value,
            p_MentlCd: document.getElementById("p_MentlCd").value,
            p_AdtFistCd: document.getElementById("p_AdtFistCd").value,
            p_AdtInTp: document.getElementById("p_AdtInTp").value,
            p_AdtMidCd: document.getElementById("p_AdtMidCd").value,
            p_AdtMidCd1: document.getElementById("p_AdtMidCd1").value,
            p_AdtWell: document.getElementById("p_AdtWell").value,
            p_AdtNotWell: document.getElementById("p_AdtNotWell").value,
            p_AdtMyDiay: document.getElementById("p_AdtMyDiay").value,
            p_AdtAdvice: document.getElementById("p_AdtAdvice").value,
            p_AdtAdviceRe: document.getElementById("p_AdtAdviceRe").value,
            p_AdtWellCkYn: document.getElementById("p_AdtWellCkYn").value,
            p_AdtNotWellCkYn: document.getElementById("p_AdtNotWellCkYn").value,
            p_AdtMyDiayCklYn: document.getElementById("p_AdtMyDiayCklYn").value,
            p_AdtAdviceCkYn: document.getElementById("p_AdtAdviceCkYn").value,
            p_AdtAdviceReCkYn: document.getElementById("p_AdtAdviceReCkYn").value,
            p_TEAMTRAI: document.getElementById("p_TEAMTRAI").value
        },
        success: function (retDATA) {

           // console.log(retDATA);
            document.getElementById(id).innerHTML = retDATA;
            // 하단 메뉴
            $('.footer .bottom-menu').polyfillPositionBottom('.footer .bottom-menu');
            // 상단 이동 버튼 TOP
            $('div.tops.btn-div').polyfillPositionBottom('div.tops.btn-div');
        }, error: function (xhr, status, error) {
            alert("오류발생! - 시스템관리자에게 문의하십시오!(" + id_value + "/xhr : " + xhr + " status : " + status + ")");
        }
    });
}


//부상부위 조회
function chage_search_JSON(id_value) {
    var strAjaxUrl = "/M_Player/select/train_Search.asp";
    var TrRerdDate = $('#datetimepicker1').val();
    var id = id_value;
    //데이터 조회 일괄 처리
    console.log(id);
    $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
            id: id_value,
            TrRerdDate: TrRerdDate,
            p_TrRerdIDX: document.getElementById("p_TrRerdIDX").value,
            p_MentlCd: document.getElementById("p_MentlCd").value,
            p_AdtFistCd: document.getElementById("p_AdtFistCd").value,
            p_AdtInTp: document.getElementById("p_AdtInTp").value,
            p_AdtMidCd: document.getElementById("p_AdtMidCd").value,
            p_AdtMidCd1: document.getElementById("p_AdtMidCd1").value,
            p_AdtWell: document.getElementById("p_AdtWell").value,
            p_AdtNotWell: document.getElementById("p_AdtNotWell").value,
            p_AdtMyDiay: document.getElementById("p_AdtMyDiay").value,
            p_AdtAdvice: document.getElementById("p_AdtAdvice").value,
            p_AdtAdviceRe: document.getElementById("p_AdtAdviceRe").value,
            p_AdtWellCkYn: document.getElementById("p_AdtWellCkYn").value,
            p_AdtNotWellCkYn: document.getElementById("p_AdtNotWellCkYn").value,
            p_AdtMyDiayCklYn: document.getElementById("p_AdtMyDiayCklYn").value,
            p_AdtAdviceCkYn: document.getElementById("p_AdtAdviceCkYn").value,
            p_AdtAdviceReCkYn: document.getElementById("p_AdtAdviceReCkYn").value
        },
        success: function (retDATA) {
            injury(retDATA);
        }, error: function (xhr, status, error) {
            alert("오류발생! - 시스템관리자에게 문의하십시오!");
        }
    });
}
function injury(data) {
    var retDATA = data;
    var retDATAobj = eval(retDATA);
    var len = retDATAobj.length;

    for (var i = 0; i < len; i++) {
        console.log( retDATAobj[i].injury_PubCode);
        
        var injury_PubCode = retDATAobj[i].injury_PubCode;
        var injury_PubName = retDATAobj[i].injury_PubName;
        var injury_CHEK = retDATAobj[i].injury_CHEK;
        var injury_Img_url = retDATAobj[i].injury_Img_url;
        //alert(injury_PubCode + "--" + injury_PubName + "--" + injury_CHEK + "--" + injury_Img_url);

        var bgUrl = "images/stats/injury";
        //앞배경
        var frontBg = $('.table_01').css('background-image');
        $('.table_01').css('background-image', frontBg.replace(injury_Img_url, bgUrl));
        frontBg = $('.table_01').css('background-image');
        $('.table_01').css('background-image', frontBg.replace(bgUrl, injury_Img_url));
        //뒤배경
        var BackBg = $('.table_02').css('background-image');
        $('.table_02').css('background-image', BackBg.replace(injury_Img_url, bgUrl));
        BackBg = $('.table_02').css('background-image');
        $('.table_02').css('background-image', BackBg.replace(bgUrl, injury_Img_url));

        
    }

    console.log($("#p_TEAMTRAI").val());

    //체크 이미지 
    for (var i = 0; i < len; i++) {
        var injury_PubCode = retDATAobj[i].injury_PubCode;
        var injury_PubName = retDATAobj[i].injury_PubName;
        var injury_CHEK = retDATAobj[i].injury_CHEK;
        var injury_Img_url = retDATAobj[i].injury_Img_url;

        var id_input = "InjuryArea" + (i+1);
        var id_tbody = "tbody_" + injury_PubCode;

        if (injury_CHEK == "Y") {
            $("#" + id_input).prop('checked', true);
            $("#" + id_tbody).addClass("on").show();
        } else {
            $("#" + id_input).prop('checked', false);
            $("#" + id_tbody).removeClass("on").hide();
        }

        var p_TEAMTRAI = $("#p_TEAMTRAI").val();
        if (p_TEAMTRAI == "Y") {
            $("#" + id_input).prop("disabled", "disabled");
            $(".btn.btn-save").attr("disabled", "").prop("disabled", "disabled");
        } else {
            $("#" + id_input).removeAttr("disabled");
            $(".btn.btn-save").attr("disabled", "").removeAttr("disabled");
        }
        //alert(injury_PubCode + "--" + injury_PubName + "--" + injury_CHEK + "--" + injury_Img_url + "--" + id_input);
    }
}




//1. 일지 이벤트

//메모리 이벤트
function memoryChk(id_name, seq) {

    var on = "icon-on-favorite";
    var off = "icon-off-favorite";

    if ($("input:checkbox[id=" + id_name + "]").is(":checked")) {
        $("input:checkbox[id=" + id_name + "]").prop("checked", false);
        $("#" + id_name).parent().find('span').removeClass(on);
        $("#" + id_name).parent().find('span').addClass(off);

    } else {
        $("input:checkbox[id=" + id_name + "]").prop("checked", true);
        $("#" + id_name).parent().find('span').removeClass(off);
        $("#" + id_name).parent().find('span').addClass(on);

    }
}


//2. 공식 훈련 일정 이벤트
//훈련대분류 변경 이벤트
function bgnavyChange(SEQ) {
    //대분류 중복 허용 x 
    //훈련대분류 시간대 변경시 나머지 조회 하여 경고 메시지 표시 
    var FIRSTID = "bg-navy" + SEQ;
    var midseq_select = document.getElementById(FIRSTID).value;
    for (var i = 1; i <= 4; i++) {
        var FIRSTID_a = "bg-navy" + i;
        midseq = document.getElementById(FIRSTID_a).value;
        if (FIRSTID != FIRSTID_a) {
            $("#" + FIRSTID_a).val(midseq).attr("visible", "disable");
            if (midseq_select == midseq) {
                $("#" + FIRSTID).val(0);
                if (midseq_select != 0) {
                    alert("이미 선택된 훈련입니다.");
                }
            } else {
                $("#" + FIRSTID).removeClass();
            }
        }
    }
}
//공식훈련추가
function officialtrainClick() {

    //name -on 조회
    //name -off 조회
    //순서대로 오픈 및 off -> on 변경 
    //off 가없으면 팝업 ( 추가 불가 통보 ) 

    var chekname = "N";

    for (var i = 1; i <= 4; i++) {
        var id = "official-train-wrap" + i;
        var name = $("#" + id).attr('name');
        var replaceName = name.replace(id + '-', '');
        if (chekname == "N") {
            if (replaceName == "off") {
                $("#" + id).attr("name", $("#" + id).attr('name').replace('-off', '-on'));
                chekname = "Y";
                $("#official-train-cog" + (i - 1)).hide();
                $("#official-train-P" + (i - 1)).hide();

                $("#" + id).show();
                $("#official-train-wrap" + i).focus();
            }
        }
    }

    if (chekname == "N") {
        alert("더이상 훈련을 추가 할수 없습니다.");
    }
}


//alert(FIRSTID_a + "_" + midseq);
//            $("select[id=" + FIRSTID_a + "]").attr("disable", true);

//훈련종류창열기
function officialTrainP(SEQ, fi, mi) {
   // alert(SEQ + "--" + fi + "--" + mi );
    //공식훈련대분류
    var bg_navy = "bg-navy" + SEQ;
    var PceCd = "PceCd" + SEQ;
    var TrailHour = "TrailHour" + SEQ;

    if (mi == "MidCdselect") {
        if ($("#" + bg_navy).val() == "0") { $("#" + bg_navy).focus(); alert("훈련구분을 선택하여 주시기 바랍니다.");$("#" + fi + SEQ).val(0);  return false; }
        if ($("#" + PceCd).val() == "0") { $("#" + PceCd).focus(); alert("훈련장소를 선택하여 주시기 바랍니다."); $("#" + fi + SEQ).val(0); return false; }
        if ($("#" + TrailHour).val() == "0") { $("#" + TrailHour).focus(); alert("훈련시간을 선택하여 주시기 바랍니다."); $("#" + fi + SEQ).val(0); return false; }
    } else {
        bg_navy = "bg-or" + SEQ;
        PceCd = "PceCdp" + SEQ;
        TrailHour = "TrailHourP" + SEQ;
        if ($("#" + bg_navy).val() == "0") { $("#" + bg_navy).focus(); alert("훈련구분을 선택하여 주시기 바랍니다."); $("#" + fi + SEQ).val(0); return false; }
        if ($("#" + PceCd).val() == "0") { $("#" + PceCd).focus(); alert("훈련장소를 선택하여 주시기 바랍니다."); $("#" + fi + SEQ).val(0); return false; }
        if ($("#" + TrailHour).val() == "0.0") { $("#" + TrailHour).focus(); alert("훈련시간을 선택하여 주시기 바랍니다."); $("#" + fi + SEQ).val(0); return false; }
    }

    var FIRSTID = fi + SEQ;
    //훈련유형
    var midseq = document.getElementById(FIRSTID).value;
    //훈련유형id
    var MIDID = FIRSTID + "Mid";
    //훈련유형옵션목록
    var len = document.getElementById(FIRSTID).length;
    //현재 선택값
    var index = $("#" + FIRSTID + " option").index($("#" + FIRSTID + " option:selected"));

    //훈련유형 0 일때
    if (midseq == 0) {
       // alert("훈련유형을 선택하여 주시기 바랍니다.");
        for (var i = 1; i < len; i++) {
            $("#" + MIDID + i).hide();
        }
        //선택버튼
        $("#" + mi + "Ok" + SEQ).hide();
        //선택 리스트 
        $("#" + mi + SEQ).hide();

        document.getElementById(FIRSTID).focus();
        return false;
    } else {
        for (var i = 1; i < len; i++) {
            if (index == i) {
                if ($("#" + MIDID + index).css("display") != "none") {
                    $("#" + MIDID + i).hide();
                    $("#" + mi + "Ok" + SEQ).hide();
                    //$("#" + mi + SEQ).hide();
                    } else {
                    $("#" + MIDID + i).show();
                    $("#" + mi + "Ok" + SEQ).show();
                    //$("#" + mi + SEQ).show();
                    }
            } else {
                $("#" + MIDID + i).hide();
            }
        }
    }
}




//훈련종류 선택 
function TraiFistCdMid(Pe, id, SEQ, fi, mi) {
    var ID = id;
    var className = $("#" + Pe + id).hasClass("on");
    //공식훈련대분류
    var FIRSTID = fi + SEQ;
    //훈련유형
    var midseq = document.getElementById(FIRSTID).value;
    //훈련유형id
    var MIDID = FIRSTID + "Mid";
    //훈련유형옵션목록
    var len = document.getElementById(FIRSTID).length;
    //현재 선택값
    var index = $("#" + FIRSTID + " option").index($("#" + FIRSTID + " option:selected"));

    var target;
    var target_len;
        
//    var tags = "<li id='" + mi + SEQ + id + "' >";
//    tags = tags + "<a href='#' onclick=TraiFistCdMid('" + Pe + "','" + id + "'," + SEQ + ",'" + fi + "','" + mi + "'); return false;>";
//    tags = tags + "<span class='btn-del-x'>x</span>" + $("#" + Pe + id).text() + "</a></li>";

    var tags = "<li id='" + mi + SEQ + id + "' >";
    tags = tags + "<a name='" + mi + SEQ + "' onclick=btndelx('" + mi + "','" + midseq + "'," + SEQ + ",'" + id.replace(midseq + SEQ, '') + "','" + fi + "');>";
    tags = tags + "<span class='btn-del-x'>x</span>" + $("#" + Pe + id).text() + "</a></li>";



    if (index != 0) {
        if (className) {
            //삭제
            $("#" +Pe+ id).removeClass("on");
            $("#" + mi + SEQ + midseq + SEQ + id.replace(midseq + SEQ, "")).remove();
        } else {
            //저장
            $("#" + Pe + id).addClass("on");
            $("#" + mi + SEQ).append(tags);
        }
    }


    if ($("#" + mi + SEQ).children().size()>0) {
        $("#" + mi + SEQ).show();
    } else {
        $("#" + mi + SEQ).hide();
    }



}
//훈련유형 변경시
function TraiFistCdChange(SEQ, fi, mi) {
    //공식훈련대분류
    var FIRSTID = fi + SEQ;
    //훈련유형
    var midseq = $("#" + FIRSTID).val();
    //훈련유형id
    var MIDID = FIRSTID + "Mid";
    //훈련유형옵션목록
    var len = $("#" + FIRSTID).length;
    //현재 선택값
    var index = $("#" + FIRSTID + " option").index($("#" + FIRSTID + " option:selected"));

    var mid = "Mid";
    if ($("#" + MIDID).val() == "TA") {
        mid = mid + "1";
    } else {
        mid = mid + "2";
    }

    if ($("#" + mi + SEQ).find("li").length>0) {
        for (var i = $("#" + mi + SEQ).find("li").length; i >=0 ; i--) {
            $("#" + mi + SEQ).find("li").eq(i).children("a").click();
        }
    }
    officialTrainP(SEQ, fi, mi);
}



function btndelx(MidCdseL, FistCdNA, cNA, MIDCDNA, fi) {
    $("#" + MidCdseL + cNA + FistCdNA + cNA + MIDCDNA).remove();
    var mid = "Mid";
    if (FistCdNA=="TA") {
        mid = mid + "1";
    } else {
        mid = mid + "2";
    }
    $("#" + fi + cNA + mid + FistCdNA + cNA + MIDCDNA).removeClass("on");


    $("#official-train-wrap" + (cNA + 1)).focus();
    $("#" + MidCdseL + cNA).focus();


    if ($("#" + MidCdseL + cNA).children().size() > 0) {
        $("#" + MidCdseL + cNA).show();
    } else {
        $("#" + MidCdseL + cNA).hide();
    }


}

//훈련종류 선택 완료시
function officialTrainSelectOk(SEQ, fi, mi) {
    //공식훈련대분류
    var FIRSTID = fi + SEQ;
    //훈련유형
    var midseq = document.getElementById(FIRSTID).value;
    //훈련유형id
    var MIDID = FIRSTID + "Mid";
    //훈련유형옵션목록
    var len = document.getElementById(FIRSTID).length;
    //현재 선택값
    var index = $("#" + FIRSTID + " option").index($("#" + FIRSTID + " option:selected"));

    $("#"+mi+"Ok" + SEQ).hide();
    $("#" + MIDID + index).hide();

    //MidCdselect1TB10000029

    //$("#" + mi + +SEQ).focus();
    //$("#" + FIRSTID).focus();
}



/*훈련 참석 / 훈련 불참석 여부 체크*/
function TrainonfBtn(seq) {
    var i = seq;
    var p_AdtFistCd = $("#p_AdtFistCd").val();
    var p_AdtInTp = $("#p_AdtInTp").val();
    var p_AdtMidCd = $("#p_AdtMidCd").val();

    var p_TEAMTRAI = $("#p_TEAMTRAI").val();
    if (p_TEAMTRAI == "Y") {
        i = $("#p_AdtFistCd").val();
        alert("팀 매니저의 관리를 받고 있습니다. 출석 정보는 변경 할 수 없습니다.");
        return false;
    }


    $('#btn-select').val(i);
    $("#p_AdtFistCd").val(i)

    if (i == 1) {
        $("#btn-select-on").removeClass();
        $("#btn-select-on").addClass("on");
        $("#btn-select-off").removeClass();

        $("#train-div01").show();
        $("#train-div02").hide();

        $(".btn-or-pop").hide();

        $("#train-check01").show();
        $("#train-check02").show();

    } else {
        $("#btn-select-off").removeClass();
        $("#btn-select-off").addClass("on");
        $("#btn-select-on").removeClass();


        $("#train-div01").hide();
        $("#train-div02").show();
        $(".btn-or-pop").show();


        $("#train-check01").hide();
        $("#train-check02").hide();
        $("#train-check01-select").hide();
        $("#train-check02-select").show();
    }

    TRIAN_CHEK();
}



//4. 기타
//상태값 반영
function TRIAN_CHEK() {
    var p_AdtFistCd = $("#p_AdtFistCd").val();
    var p_AdtInTp = $("#p_AdtInTp").val();
    var p_AdtMidCd = $("#p_AdtMidCd").val();
    var p_AdtMidCd1 = $("#p_AdtMidCd1").val();
    var p_TEAMTRAI = $("#p_TEAMTRAI").val();

    if (p_AdtFistCd == "") {
        if ($("#btn-select-on").hasClass("on")) {
            p_AdtFistCd = "1";
            $("#p_AdtFistCd").val(p_AdtFistCd)

            p_AdtInTp = "A";
            $("#p_AdtInTp").val(p_AdtInTp);

            p_AdtMidCd = 0;
            p_AdtMidCd1 = 0;
            $("#p_AdtMidCd").val(p_AdtMidCd);
            $("#p_AdtMidCd1").val(p_AdtMidCd1);

        } else {
            p_AdtFistCd = "1";
            $("#p_AdtFistCd").val(p_AdtFistCd)
            $("#btn-select-on").removeClass();
            $("#btn-select-on").addClass("on");
            $("#btn-select-off").removeClass();
            p_AdtMidCd = 0;
            $("#p_AdtMidCd").val(p_AdtMidCd);

        }
    }

    if (p_AdtFistCd == "1") {//참석
        //정상 ? 일부 
        $("#btn-select-on").removeClass();
        $("#btn-select-on").addClass("on");
        $("#btn-select-off").removeClass();

        $("#train-div01").show();
        $("#train-div02").hide();

        $(".btn-or-pop").hide();

        $("#train-check01").show();
        $("#train-check02").show();

        p_AdtMidCd1 = 0;
        $("#p_AdtMidCd1").val(p_AdtMidCd1);


        if (p_AdtInTp == "") {
            $("#p_AdtInTp").val("A");
            p_AdtInTp = "A";
            p_AdtMidCd = 0;
            $("#p_AdtMidCd").val(p_AdtMidCd);
        }

        if (p_AdtInTp == "A") {
            $("input:radio[name='train_check']:input[value='A']").attr("checked", true);
            $("#train-check01-select").hide();
            $(".btn-or-pop").hide();
        } else {
            $("input:radio[name='train_check']:input[value='B']").attr("checked", true);
            $("#train-check01-select").show();
            $(".btn-or-pop").show();


            if (p_AdtMidCd <= 2 && p_AdtMidCd > 0 ) {//|| (p_AdtMidCd ==5
                $(".btn-or-pop").show();
            } else {
                $(".btn-or-pop").hide();
            }
        }

        $("#train-check01-select").val(p_AdtMidCd);
        $("#train-check02-select").val(p_AdtMidCd1);
        $("#train-check02-select").hide();
        $("#official-train-wrap").show();
        //        $(".official-train-wrap").show();
        //        $("#official-train-person").show();

        $('#btn-select').val(p_AdtFistCd);
    } else { //불참석
        //부상여부 

        $("#btn-select-off").removeClass();
        $("#btn-select-off").addClass("on");
        $("#btn-select-on").removeClass();

        $("#train-div01").hide();
        $("#train-div02").show();
        $(".btn-or-pop").show();


        if ((p_AdtMidCd1 <= 2 && p_AdtMidCd1 > 0)) {
            $(".btn-or-pop").show();
        } else {
            $(".btn-or-pop").hide();
        }

        $("#train-check01-select").val(p_AdtMidCd);
        $("#train-check02-select").val(p_AdtMidCd1);

        //        $("#train-check01").hide();
        //        $("#train-check02").hide();
        //        $("#train-check01-select").hide();
        $("#train-check02-select").show();
        $("#train-check01-select").hide();
        $("#official-train-wrap").hide();
        $('#btn-select').val(p_AdtFistCd);
    }

    //개인훈련 리스트 표시
}


function array_chk(id_value) {
    var para2 = [];
    ajxurl: 'test_page.asp';

    $("input[name='" + id_value + "']:checked").each(function (i) {
        para2.push($(this).val());
    });

    var postData = { "para1": "para1", "chklist": para2 };

    $.ajax({
        url: ajxurl,
        type: 'post',
        timeout: 1000,
        data: postData,
        traditional: true,
        error: function () {
            alert('네트워크가 불안정합니다.');
        },
        success: function (obj) {
        }
    });
}





function myfunction() {
    $('#TraiFistCd1TraiMidCd1').click(function () {
        $(this).parent('li').toggleClass('on');
        e.preventDefault();
    });

    $('.btn-or-select').click(function () {
        console.log($('#TraiFistCd1TraiMidCd1 li').filter('.on').length);
        console.log($('#TraiFistCd1TraiMidCd2 li').filter('.on').length);
    });

    $('.btn-train-list').click(function () {
        $(this).parent('li').toggleClass('on');
        e.preventDefault();

    });

    $('.btn-or-select').click(function () {
        console.log($('#TraiFistCd1TraiMidCd2 li').filter('.on').length);
    });
}