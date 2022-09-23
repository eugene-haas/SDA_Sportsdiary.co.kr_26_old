$(document).ready(function () {
    var StimFistCd_h = $('#StimFistCd_h').val();
    make_box("StimFistCd", "0", StimFistCd_h, "StimFistCd") //측정항목전체

    var datetimepicker1_h = $('#datetimepicker1_h').val();

    if ($('#datetimepicker1').val() == "") {
        DateToday();
    }


    $('#StimFistCd').val(StimFistCd_h);
    Strength_serch();

    $("#guide-tip").hide();
    $(".exc-list").hide();
    $(".btn-full").hide();
});


//당일 날짜 변경 후 조회
function DateAfer() {
    var datetimepicker1_h = $('#datetimepicker1_h').val();
    var datetimepicker1 = $('#datetimepicker1').val();


    if (datetimepicker1_h == datetimepicker1) {
        $('#datetimepicker1_h').val(datetimepicker1);
        datetimepicker1_h = $('#datetimepicker1_h').val();
    } else {
        $('#datetimepicker1_h').val(datetimepicker1);
        datetimepicker1_h = $('#datetimepicker1_h').val();
    }

    Strength_serch();
}

 
//투데이 날짜 변경 후 조회
function DateToday() {
    var now = new Date();
    var year = now.getFullYear();
    var mon = (now.getMonth() + 1) > 9 ? '' + (now.getMonth() + 1) : '0' + (now.getMonth() + 1);
    var day = now.getDate() > 9 ? '' + now.getDate() : '0' + now.getDate();

    var chan_val = year + '-' + mon + '-' + day;

     $('#datetimepicker1').val(chan_val);;
     $('#datetimepicker1_h').val(chan_val);

     var datetimepicker1 = $('#datetimepicker1').val(); ;
     var datetimepicker1_h = $('#datetimepicker1_h').val();

    Strength_serch();
}



//대분류 콤보 박스 변경
function StimFistCd_serch() {
    var StimFistCd = document.getElementById("StimFistCd").value;
    $('#StimFistCd_h').val(StimFistCd);
    var datetimepicker1 = $('#datetimepicker1').val();
    var datetimepicker1_h = $('#datetimepicker1_h').val();
    $('#datetimepicker1_h').val(datetimepicker1);
    datetimepicker1_h = $('#datetimepicker1_h').val();
    var page_move = "";



    Strength_serch();
     
}

function Strength_serch() {
    var StimFistCd = $('#StimFistCd_h').val();
    var MIDT = 0;
    //전체 -대분류 - 중분류 
    switch (StimFistCd) {
        case "0":
            //전체조회
            //당일 데이터 존재 유무 
            //make_box("COUNT", StimFistCd , "0", "StimFistCd") //측정항목전체
            //'Y'세부내역 측정치 표시
            //모아보기
            //세부항목 조회
            Strength_serch_detail("leader", StimFistCd, document.getElementById("datetimepicker1").value);
            Strength_serch_detail("TEAMTRAI", "0", document.getElementById("datetimepicker1").value);


            $("#guide-tip").hide();
            $(".exc-list").hide();
            $(".btn-full").hide();
            $(".main-bg").show();

            break;
        default:

            $("#guide-tip").show();
            $(".exc-list").show();
            $(".btn-full").show();
            $(".main-bg").hide();

            Strength_serch_MidTIP();
            Strength_serch_detail("leader", "0", document.getElementById("datetimepicker1").value);
            Strength_serch_detail("TEAMTRAI", "0", document.getElementById("datetimepicker1").value);
            CHK_MID_COUNT("COUNT", StimFistCd, "0");
            Strength_serch_detail("exc-list", StimFistCd, document.getElementById("datetimepicker1").value);
            break;
    }
}

function Strength_serch_MidTIP() {
    $.ajax({
        url: "/M_Player/select/Strength_MidTIP.asp",
        type: 'POST',
        dataType: 'html',
        data: {
            StimFistCd: $('#StimFistCd_h').val()
        },
        success: function (retDATA) {
            $('#guide-tip').html(retDATA);
            // $('.set-collapse').arrHCollapse('.set-collapse');
            // var height = $("#guide-tip");
            // height.height(65);
            $('.tip-title a').on('click', function(){
                $(this).toggleClass('on');
            });
        }, error: function (xhr, status, error) {
            if (error != '') {
                alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
            }
        }
    });

}

function Strength_serch_detail(element, StimFistCd, StimMidCd) {
    var strAjaxUrl = "/M_Player/select/Strength_MidInfo.asp";
    var element = element;
    var StimFistCd = StimFistCd;
    var StimMidCd = StimMidCd;

    console.log(element);
    console.log(StimFistCd);
    console.log(StimMidCd);

    $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
            element: element,
            StimFistCd: StimFistCd,
            StimMidCd: StimMidCd
        },
        success: function (retDATA) {

            if (retDATA) {
                if (element == "leader") {
                    $("#LeaderIDX").val(retDATA);
                } else if (element == "TEAMTRAI") {
                    $("#p_TEAMTRAI").val(retDATA);

                    if ($("#p_TEAMTRAI").val() == "Y") {
                        $("#LeaderIDX").val("Y");
                    }
                }
                else {
                    $('.exc-list').html(retDATA);
                }
            }
            
            if (retDATA == null) {
                //조회종료 효과
                alert("조회 데이타가 없습니다!");
            }

            //연동 확인 readonly="readonly"
            //저장 차단 disabled="disabled" 
            if ($("#p_TEAMTRAI").val() == "Y") {
                $("#SEQ1").attr("readonly", "readonly");
                $("#SEQ2").attr("readonly", "readonly");
                $("#SEQ3").attr("readonly", "readonly");
                $("#SEQ4").attr("readonly", "readonly");

                //기록 저장

                $(".btn-full").html("지도자가 관리 중입니다. ");

            } else {
                if (PlayerReln == "A" || PlayerReln == "B" || PlayerReln == "Z") {
                    $("#SEQ1").attr("readonly", "readonly");
                    $("#SEQ2").attr("readonly", "readonly");
                    $("#SEQ3").attr("readonly", "readonly");
                    $("#SEQ4").attr("readonly", "readonly");
                    $(".btn-full").html("");
                } else {
                    $("#SEQ1").removeAttr("readonly");
                    $("#SEQ2").removeAttr("readonly");
                    $("#SEQ3").removeAttr("readonly");
                    $("#SEQ4").removeAttr("readonly");

                    $(".btn-full").html("기록 저장");
                }
            }

        }, error: function (xhr, status, error) {
            if (error != '') {
                alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
            }
        }
    });
}

function CHK_MID_COUNT(element, StimFistCd, StimMidCd) {
    var strAjaxUrl = "/M_Player/select/Strength_MidInfo.asp";
    var element = element;
    var StimFistCd = StimFistCd;
    var StimMidCd = StimMidCd;

    $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
            element: element,
            StimFistCd: StimFistCd,
            StimMidCd: StimMidCd
        },
        success: function (retDATA) {
            var strcut = retDATA.split("|");
            if (strcut[0] == "TRUE") {
                $('#COUNT').val(strcut[1]);
                var cnt = strcut[1];

                //세부내역 화면 그리기

                //데이터 조회

                for (var i = 1; i <= cnt; i++) {



                }
            }
        }, error: function (xhr, status, error) {
            if (error != '') {
                alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
            }
        }
    });
}
function SaveData() {
    //에러체크

    if ($("#LeaderIDX").val() == "Y") {
        alert("지도자가 관리 중입니다. 체력 측정 내용을 저장 할 수 없습니다.");
    } else if (PlayerReln == "A" || PlayerReln == "B" || PlayerReln == "Z") {
        return false;
    }
    else {
        var TrRerdDate = document.getElementById("datetimepicker1").value; //측정날짜
        var StimFistCd = document.getElementById("StimFistCd").value;      //측정항목
        var CNT = $("#COUNT").val();

        var LeaderIDX = $("#LeaderIDX").val();

        console.log($("#LeaderIDX").val());

        var StimData_1 = 0;
        var StimData_2 = 0;
        var StimData_3 = 0;
        var StimData_4 = 0;

        if ($("#SEQ1").val() > 0) {
            StimData_1 = $("#SEQ1").val();
        }
        if ($("#SEQ2").val() > 0) {
            StimData_2 = $("#SEQ2").val();
        }
        if ($("#SEQ3").val() > 0) {
            StimData_3 = $("#SEQ3").val();
        }
        if ($("#SEQ4").val() > 0) {
            StimData_4 = $("#SEQ4").val();
        }


        //    //저장- 중분류 숫자 파악 후 처리
        var strAjaxUrl = "/M_Player/Ajax/Strength_OK.asp";

        $.ajax({
            url: strAjaxUrl,
            type: 'POST',
            dataType: 'html',
            data: {
                TrRerdDate: TrRerdDate,
                StimFistCd: StimFistCd,
                StimData_1: StimData_1,
                StimData_2: StimData_2,
                StimData_3: StimData_3,
                StimData_4: StimData_4
            },
            success: function (retDATA) {

                if (retDATA) {
                    if (retDATA == "TRUE") {
                        alert("저장 되었습니다.");
                        Strength_serch();
                    } else {
                        alert('잘못된 접근입니다.');
                    }
                }
            }, error: function (xhr, status, error) {
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
        });
        return true;
    }
}



