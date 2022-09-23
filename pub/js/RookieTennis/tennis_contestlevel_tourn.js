//onclick="mx.changeSelectArea(1171,this,4,3,{"CMD":"30009","IDX":2113,"TitleIDX":78,"Title":"김주영테스트","TeamNM":"개나리부","AreaNM":"부천","JONO":3,"GAMEMEMBERIDX":1164,"PLAYERIDX":14604,"PLAYERIDXSub":13705,"S3KEY":"20101001","GUBUN":0,"ExitYN1":"Y","ExitYN2":"Y"})"
    //경기 결과 입력
mx.tornGameIn = function (packet, rowSeq) {
    //라운드 별 재편성 // 완료 // 상태 변경
    console.log(packet);

    if (rowSeq == 1) {
        var $tourney_admin = $("#tourney_admin").find(".in");
        if ($tourney_admin.length >= 1) {
            alert("수정 중인 작업이 있습니다.");
            $("#tourney_admin").focus();
            $tourney_admin.focus();
            return false;
        }

        if ($("#gametable").find(".off").length > 0) {
            alert("1라운드 편성이 완료 되지 않았습니다.");
            return false;
        }
    }

    mx.SendPacket("set_Round" + rowSeq, packet);


    var $Tdrow = $("#" + rowSeq + "_row").find("a");
    if (packet.GUBUN == 2) {
        //재편성
        $Tdrow.show();

        $("#" + rowSeq + "_row").addClass("btn-gray");

    } else {
        //완료
        $Tdrow.hide();

        $("#" + rowSeq + "_row").removeClass("btn-gray");

    }
};

    //예선 선택
mx.trySel = function (e, idxno, levelno, gameMemberIDX, checkId) {
    var targetobj = document.getElementById("drag_" + checkId);
    var $tourney_admin = $("#tourney_admin").find(".in");
    var $trysel = $("#sel_" + checkId);
    var $trysel_act = $("#gametable").find(".act");

    var Rselid = $tourney_admin.attr("id");
    var $Rsel = $("#gametable").find("." + Rselid);

    //선택 후 처리
    //이전 위치로 이동
    $("#tourney_admin").focus();
    $tourney_admin.focus();

    //이전 선택된 값 변경
    $trysel_act.removeClass("on").removeClass("act").addClass("off").show();
    $("#"+Rselid+"_view").show()
    //최종 선택된 값 상태 값 변경
    $trysel.addClass("act").hide();

    //라운드 표시(비활성화)


    //본선 대진표 1라운드 이동


    //기존 선택된 값 변경
    $Rsel.removeClass("on").removeClass("act").removeClass(Rselid).addClass("off").show();
};
 

    //본선 선택
mx.tornSel = function (e, idxno, levelno, gameMemberIDX, checkId) {
    var targetobj = document.getElementById(checkId);
    var $trysel_act = $("#gametable").find(".act");

    var $tornsel_act_input = $("#" + checkId + "_input").find("input");
    var $tornsel_act_view = $("#" + checkId + "_view").find(".contents");

    if ($("#" + checkId).hasClass("off")) {
        if ($("#" + checkId).hasClass("in")) {
            //입력 - > 저장 

            //저장 처리
            var obj = {};
            obj.CMD = mx.CMD_RoundEdit;

            obj.TitleIDX = $trysel_act.find("input").eq(0).val();
            obj.idx = $trysel_act.find("input").eq(1).val();
            obj.levelno = $trysel_act.find("input").eq(2).val();
            obj.p1idx = $trysel_act.find("input").eq(3).val();
            obj.gno = 0;
            obj.sortno = 0;

            obj.gubun = $tornsel_act_input.eq(0).val();
            obj.RTitleIDX = $tornsel_act_input.eq(1).val();
            obj.Rlevelno = $tornsel_act_input.eq(2).val();
            obj.Rround = $tornsel_act_input.eq(3).val();
            obj.RsortNo = $tornsel_act_input.eq(4).val();
            obj.Rstateno = $tornsel_act_input.eq(5).val();
            obj.RgameResult = $tornsel_act_input.eq(6).val();
            obj.RPlayerIDX1 = $tornsel_act_input.eq(7).val();
            obj.RPlayerIDX2 = $tornsel_act_input.eq(8).val();

            console.log($tornsel_act_view);
            console.log(obj);
            //db 연결
            mx.SendPacket("sqlquery", obj);

            //정보 반영
            //예선
            //경기결과
            //$("#drag_" + obj.gno + "_" + obj.sortno).find(".tryFinsh").eq(1).html("");
            //본선라운드
            //$("#drag_" + obj.gno + "_" + obj.sortno).find(".tournRound").eq(1).html("Round :" + obj.Round + "(" + obj.SortNo + ")");

            //대진
            $tornsel_act_view.eq(2).html($trysel_act.find("input").eq(6).val());
            $tornsel_act_view.eq(3).html($trysel_act.find("input").eq(11).val());
            $tornsel_act_view.eq(4).html("");

            //취소 처리

            //선택 된 예선 정보 상태 변경
            $trysel_act.removeClass("off").removeClass("act").addClass("on").addClass(checkId).hide();

            //상태값 변경
            $("#" + checkId).text("수정").removeClass("in").removeClass("off").addClass("on");
            $("#gametable").find(".off").hide();

        } else {
            //입력 - > 선택

            //다른 입력자 선택 했는지 체크
            var $tourney_admin = $("#tourney_admin").find(".in");
            console.log($tourney_admin);

            if ($tourney_admin.length >= 1) {
                alert("수정 중인 작업이 있습니다.");
                $("#tourney_admin").focus();
                $tourney_admin.focus();
                return false;
            }

            if ($("#gametable").find(".off").length <= 0) {
                alert("선택가능한 팀이 없습니다.");
                return false;
            }

            //기존 선택 취소
            var $Rsel = $("#gametable").find("." + checkId);
            $Rsel.removeClass("on").removeClass("act").removeClass(checkId).addClass("off").show();

            //입력 위치 라운드 정보 저장


            //예선 선택 버튼 활성화
            //라운드 미선택자 만 활성화(하이라이트)
            $("#gametable").find(".off").show();

            //이전위치로 이동
            $("#gametable").focus();
            $("#gametable").find(".off").eq(0).focus();

            $("#" + checkId).text("완료");
            $("#" + checkId).addClass("in");
        }
    } else {
        if ($("#" + checkId).hasClass("in")) {
            //수정 -> 저장

            //수정 //저장 처리

            //저장 처리
            var obj = {};
            obj.CMD = mx.CMD_RoundEdit;
            obj.TitleIDX = $trysel_act.find("input").eq(0).val();
            obj.idx = $trysel_act.find("input").eq(1).val();
            obj.levelno = $trysel_act.find("input").eq(2).val();
            obj.p1idx = $trysel_act.find("input").eq(3).val();
            obj.gno = 0;
            obj.sortno = 0;

            obj.gubun = $tornsel_act_input.eq(0).val();
            obj.RTitleIDX = $tornsel_act_input.eq(1).val();
            obj.Rlevelno = $tornsel_act_input.eq(2).val();
            obj.Rround = $tornsel_act_input.eq(3).val();
            obj.RsortNo = $tornsel_act_input.eq(4).val();
            obj.Rstateno = $tornsel_act_input.eq(5).val();
            obj.RgameResult = $tornsel_act_input.eq(6).val();
            obj.RPlayerIDX1 = $tornsel_act_input.eq(7).val();
            obj.RPlayerIDX2 = $tornsel_act_input.eq(8).val();

            console.log($tornsel_act_input);
            console.log(obj);
            //db 연결
            mx.SendPacket("sqlquery", obj);

            //예선
            //경기결과
            //$("#drag_" + obj.gno + "_" + obj.sortno).find(".tryFinsh").eq(1).html("");
            //본선라운드
            //$("#drag_" + obj.gno + "_" + obj.sortno).find(".tournRound").eq(1).html("Round :" + obj.Round + "(" + obj.SortNo + ")");


            //대진
            $tornsel_act_view.eq(2).html($trysel_act.find("input").eq(6).val());
            $tornsel_act_view.eq(3).html($trysel_act.find("input").eq(11).val());
            $tornsel_act_view.eq(4).html("");

            //취소 처리


            //선택 된 예선 정보 상태 변경
            $trysel_act.removeClass("off").removeClass("act").addClass("on").addClass(checkId).hide();

            //버튼 변경 상태값 변경
            $("#" + checkId).text("수정");
            $("#" + checkId).removeClass("in");
            $("#gametable").find(".off").hide();

        } else {
            // 수정 -> 선택 

            //다른 입력자 선택 했는지 체크
            var $tourney_admin = $("#tourney_admin").find(".in");
            console.log($tourney_admin);
            if ($tourney_admin.length >= 1) {
                alert("수정 중인 작업이 있습니다.");
                $("#tourney_admin").focus();
                $tourney_admin.focus();
                return false;
            }

            //기존 선택 취소
            var $Rsel = $("#gametable").find("." + checkId);
            $Rsel.removeClass("on").removeClass("act").removeClass(checkId).addClass("off").show();


            //저장 처리
            var obj = {};
            obj.CMD = mx.CMD_RoundEdit;
            obj.TitleIDX = $tornsel_act_input.eq(1).val();
            obj.idx = $tornsel_act_input.eq(1).val();
            obj.levelno = $tornsel_act_input.eq(2).val();
            obj.p1idx = $tornsel_act_input.eq(7).val();
            obj.gno = $tornsel_act_input.eq(3).val();
            obj.sortno = 0;

            obj.gubun = $tornsel_act_input.eq(0).val();
            obj.RTitleIDX = $tornsel_act_input.eq(1).val();
            obj.Rlevelno = $tornsel_act_input.eq(2).val();
            obj.Rround = $tornsel_act_input.eq(3).val();
            obj.RsortNo = 0;
            obj.Rstateno = $tornsel_act_input.eq(5).val();
            obj.RgameResult = $tornsel_act_input.eq(6).val();
            obj.RPlayerIDX1 = $tornsel_act_input.eq(7).val();
            obj.RPlayerIDX2 = $tornsel_act_input.eq(8).val();

            console.log($tornsel_act_input);
            console.log($tornsel_act_input);
            console.log(obj);
            //db 연결
            mx.SendPacket("sqlquery", obj);

            //대진
            $tornsel_act_view.eq(2).html("");
            $tornsel_act_view.eq(3).html("");
            $tornsel_act_view.eq(4).html("");

            //예선 대진표에서 기존 선택자 표시

            //수정 위치 라운드 정보 저장

            //라운드 미선택자 만 활성화(하이라이트)
            $("#gametable").find(".off").show();

            //이전 위치로 이동
            $("#gametable").focus();
            $("#gametable").find(".off").eq(0).focus();

            //버튼 변경 및 상태 값 변경
            $("#" + checkId).text("완료");
            $("#" + checkId).addClass("in");
        }
    }
};


