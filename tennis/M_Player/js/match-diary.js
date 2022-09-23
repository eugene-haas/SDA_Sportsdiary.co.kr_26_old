
$(document).ready(function () {
    $(".prev-btn").on({
        "click": function (e) {
            e.preventDefault();
            var stat = $('.year').text().replace(" ", "").replace(/ /g, '').replace('년', '');
            var num = parseInt(stat, 10);
            num--;
            if (num <= 0) {
                alert('더이상 줄일 수 없습니다.');
                num = 1;
            }
            $("#year").val(num);
            $('.year').text(num + '년');
            idx();
        }
    });

    $(".next-btn").on({
        "click": function (e) {
            e.preventDefault();
            var stat = $('.year').text().replace(" ", "").replace(/ /g, '').replace('년', '');
            var num = parseInt(stat, 10);
            num++;
            if (num <= 0) {
                alert('더이상 줄일 수 없습니다.');
                num = 1;
            }
            $("#year").val(num);
            $('.year').text(num + '년');
            idx();
        }
    });


    $("#GameTitleIDX").on({
        "change": function () {
            setCookie("GameTitleIDX", $("#GameTitleIDX").val(), 1);
            idx();
        }
    });


    function setCookie(cName, cValue, cDay) {
        var expire = new Date();
        expire.setDate(expire.getDate() + cDay);
        cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
        if (typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
        document.cookie = cookies;
    }

    // 쿠키 가져오기
    function getCookie(cName) {
        cName = cName + '=';
        var cookieData = document.cookie;
        var start = cookieData.indexOf(cName);
        var cValue = '';
        if (start != -1) {
            start += cName.length;
            var end = cookieData.indexOf(';', start);
            if (end == -1) end = cookieData.length;
            cValue = cookieData.substring(start, end);
        }
        return unescape(cValue);
    }

    var GameTitleIDX_cookie = "";
    if (getCookie("GameTitleIDX") != "") {
        GameTitleIDX_cookie = getCookie("GameTitleIDX");
    } else {
        setCookie("GameTitleIDX", "", 1);
        GameTitleIDX_cookie = "";
    }



    //데이터 조회 일괄 처리 
    $.ajax({
        url: "../select/match_diary_select.asp",
        type: 'POST',
        dataType: 'html',
        data: {
            id: "GameTitleIDX",
            Tryear: $("#year").val(),
            GameTitleIDX: GameTitleIDX_cookie//$("#GameTitleIDX").val()
        },
        success: function (retDATA) {
            document.getElementById("GameTitleIDX").innerHTML = retDATA;

            //'심리적상태
            chage_search("condition");

            //'대회성적
            chage_search("GameTitle");
            // 평가 
            chage_search("match-question");

            //메모리 
            chage_search("memory");

        }, error: function (xhr, status, error) {
            if (error != '') {
                alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
            }
        }
    });


    //저장 
    $("#Match_save").on({
        "click": function () {

            var classCancle = $(".btn-full").attr("class");
            if (classCancle.indexOf("cancle") >= 0) {
                alert("대회 참가 내역이 없습니다.");
                return false;
            }

            //대회일지
            var tblSvcGameRerd = "";
            //대회평가
            var tblSvcGameAsmt = "";

            var GameTitleIDX = $("#GameTitleIDX").val();
            var MentlCd = $("#condition").val();

            if (MentlCd == 0) {
                alert("심리적 상태를 선택하여 주시기 바랍니다.");
                document.getElementById("condition").focus();
                return false;
            }

            var AdtWell = $("#AdtWell").val(); //.replace(/\n/g, '<br>');
            var AdtNotWell = $("#AdtNotWell").val(); //.replace(/\n/g, '<br>');
            var AdtMyDiay = $("#AdtMyDiay").val(); //.replace(/\n/g, '<br>');
            var AdtAdvice = $("#AdtAdvice").val(); //.replace(/\n/g, '<br>');
            var AdtAdviceRe = $("#AdtAdviceRe").val(); //.replace(/\n/g, '<br>'); //지도자 답변

             var AdtWellCkYn = "N";
            var AdtNotWellCkYn = "N";
            var AdtMyDiayCklYn = "N";
            var AdtAdviceCkYn = "N";
            var AdtAdviceReCkYn = "N";
            var memory_txt = document.getElementsByName("memory-txt");

            for (var i = 0; i < memory_txt.length; i++) {
                if (memory_txt[i].checked) {
                    switch (i) {
                        case 0:
                            AdtWellCkYn = "Y";
                            break;
                        case 1:
                            AdtNotWellCkYn = "Y";
                            break;
                        case 2:
                            AdtMyDiayCklYn = "Y";
                            break;
                        case 3:
                            AdtAdviceCkYn = "Y";
                            break;
                        case 4:
                            AdtAdviceReCkYn = "Y";
                            break;
                    }
                }
            }

            tblSvcGameRerd = "" + GameTitleIDX + "|" + MentlCd + "|" + AdtWell + "|" + AdtNotWell + "|" + AdtMyDiay + "|" + AdtAdvice + "|" + AdtAdviceRe + "|";
            tblSvcGameRerd = tblSvcGameRerd + AdtWellCkYn + "|" + AdtNotWellCkYn + "|" + AdtMyDiayCklYn + "|" + AdtAdviceCkYn + "|" + AdtAdviceReCkYn + "|";

            var question = "match-question";
            var question_name = "";
            var match_question = "";

            var j = "0001";
            for (var i = 1; i < 11; i++) {
                if (i < 10) {
                    j = "000" + i;
                } else {
                    j = "00" + i;
                }
                question_name = question + j;
                var chek = 0;

                for (var c = 0; c < document.getElementsByName(question_name).length; c++) {
                    if (document.getElementsByName(question_name)[c].checked) {
                        chek = document.getElementsByName(question_name)[c].value;
                        tblSvcGameAsmt = tblSvcGameAsmt + chek + "|";
                    }
                }

                if (chek <= 0) {
                    document.getElementById("match-question").focus();
                    alert(" " + i + "번째 훈련평가를 마무리하여 주시기 바랍니다.");
                    return false;
                }
            }

            tblSvcGameRerd = tblSvcGameRerd.substring(0, tblSvcGameRerd.length - 1);
            tblSvcGameAsmt = tblSvcGameAsmt.substring(0, tblSvcGameAsmt.length - 1);

            $.ajax({
                url: "/M_Player/Ajax/match-diary_OK.asp",
                type: 'POST',
                dataType: 'html',
                data: {
                    tblSvcGameRerd: tblSvcGameRerd,
                    tblSvcGameAsmt: tblSvcGameAsmt
                },
                success: function (retDATA) {
                    if (retDATA) {
                        if (retDATA == "TRUE") {
                            alert("저장 되었습니다.");
                            location.href = "../Schedule/sche-match.asp?GameTitleIDX=" + $("#GameTitleIDX").val();
                        } else {
                            alert("대회일지 저장오류발생! - 시스템관리자에게 문의하십시오!");
                        }
                    }
                }, error: function (xhr, status, error) {
                    if (error != '') {
                        alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                    }
                }
            });
        }
    });
});


function idx() {

    var GameTitleIDX_cookie = "";
    if (getCookie("GameTitleIDX") != "") {
        GameTitleIDX_cookie = getCookie("GameTitleIDX");
    } else {
        setCookie("GameTitleIDX", "", 1);
        GameTitleIDX_cookie = "";
    }
    //데이터 조회 일괄 처리 
    $.ajax({
        url: "../select/match_diary_select.asp",
        type: 'POST',
        dataType: 'html',
        data: {
            id: "GameTitleIDX",
            Tryear: $("#year").val(),
            GameTitleIDX: GameTitleIDX_cookie
        },
        success: function (retDATA) {
            document.getElementById("GameTitleIDX").innerHTML = retDATA;
            //'심리적상태
            chage_search("condition");
            //'대회성적
            chage_search("GameTitle");
            // 평가 
            chage_search("match-question");
            //메모리 
            chage_search("memory");

        }, error: function (xhr, status, error) {
            if (error != '') {
                alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
            }
        }
    });
}
function chage_search(id_value) {
    //데이터 조회 일괄 처리
    $.ajax({
        url: "../select/match_diary_select.asp",
        type: 'POST',
        dataType: 'html',
        data: {
            id: id_value,
            Tryear: $("#year").val(),
            GameTitleIDX: $("#GameTitleIDX").val()
        },
        success: function (retDATA) {
            document.getElementById(id_value).innerHTML = retDATA;
            if (id_value == "GameTitle") {
                //대회 결과 내역이 없습니다.
                if (retDATA.indexOf("대회 결과 내역이 없습니다") >= 0) {
                    console.log("대회 결과 내역이 없습니다");
                    $(".btn-full").removeClass("save");
                    $(".btn-full").addClass("cancle");
                } else {
                    $(".btn-full").removeClass("cancle");
                    $(".btn-full").addClass("save");
                }
            }
            // 하단 메뉴
            $('.footer .bottom-menu').polyfillPositionBottom('.footer .bottom-menu');
            // 상단 이동 버튼 TOP
            $('div.tops.btn-div').polyfillPositionBottom('div.tops.btn-div');
        }, error: function (xhr, status, error) {
            if (error != '') {
                alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
            }
        }
    });
}

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


function showfilmclick(p_idx,p_lev,p_grgb) {
    var url = "../MatchDiary/match-movie.asp?p_lev=" + p_lev;
    $(location).attr('href', url);

}