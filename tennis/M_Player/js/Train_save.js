function SaveData0() {
    var TrRerdDate = document.getElementById("datetimepicker1").value; //측정날짜
    if (confirm("날짜 : " + TrRerdDate + " 훈련 일지 내용을 수정 하시겠습니까?")) {
        $(".btnUpateTrai").hide();
        $(".btnSaveTrai").show();

        $("#condition").attr("disabled", false);
    }
}

function SaveData1() {

    if (PlayerReln == "A" || PlayerReln == "B" || PlayerReln == "Z") {
        return false;
    }

    //에러체크
    /*훈련일지 start*/
    var tblSvcTrRerd = "";
    var TrRerdDate = document.getElementById("datetimepicker1").value; //측정날짜
    var condition = document.getElementById("condition").value;      //심리적상태 체크
        if (condition == 0) {
            alert("심리적상태를 선택하여 주시기 바랍니다."  );
            document.getElementById("condition").focus();
            return false;
        }
    var btn_select = $('#btn-select').val(); //훈련참석여부 
    var train_check = "A"; //정상?일부
    if (document.getElementsByName("train_check")[1].checked) { train_check = "B";    }
    if (btn_select==2) {train_check = "C";}

    var train_check01_select = document.getElementById("train-check01-select").value; //일부불참사유
    var train_check02_select = document.getElementById("train-check02-select").value; //불참사유

    /*훈련일자/심리적상태/참석여부/참석유형/참석중분류/메모리*5/메모리체크*5 */
    tblSvcTrRerd = "" + TrRerdDate + "|"  +condition + "|"  +btn_select + "|"  +train_check + "|";

    if (btn_select == 1) {
        if (train_check == "A") {
            tblSvcTrRerd = tblSvcTrRerd + "1|";
        } else {
            if (train_check01_select==0) {
                alert("불참사유를 선택하여 주시기 바랍니다.");
                document.getElementById("train_check01_select").focus();
                return false;
            }
            tblSvcTrRerd = tblSvcTrRerd + train_check01_select + "|";
        }
    } else {
        if (train_check02_select == 0) {
            alert("불참사유를 선택하여 주시기 바랍니다.");
            document.getElementById("train_check02_select").focus();
            return false;
        }
        tblSvcTrRerd = tblSvcTrRerd + train_check02_select + "|";
    }

   

    /*부상부위 START*/
    var tblSvcTrRerdJury = "";
    if (btn_select == 1) {
        //일부참석사유
        if (train_check == "B") {
            //부상 체크
            //부상부위 선택
            tblSvcTrRerdJury = "Y";
        } else {
            tblSvcTrRerdJury = "N";
        }
    } else {
        //부상 체크
        //부상부위 선택
        tblSvcTrRerdJury = "Y";
    }

    if (tblSvcTrRerdJury == "Y") {
        var InjuryArea = document.getElementsByName("InjuryArea");
        var countInjury = 0;
        tblSvcTrRerdJury="";
        for (var i = 0; i < InjuryArea.length; i++) {
            if (InjuryArea[i].checked) {
                countInjury = countInjury + 1;
                tblSvcTrRerdJury = tblSvcTrRerdJury + InjuryArea[i].value + "|"
            }
        }
    }

    //tblSvcTrRerdJury = tblSvcTrRerdJury.substring(0, tblSvcTrRerdJury.length - 1)
    /*부상부위 END*/

    /*메모리*/
    var memory_txt = "";
    memory_txt = document.getElementsByName("memory-txt");

    var AdtWell_chk = "N";
    var AdtNotWell_chk = "N";
    var AdtMyDiay_chk = "N";
    var AdtAdvice_chk = "N";
    var AdtAdviceRe_chk = "N";
    for (var i = 0; i < memory_txt.length; i++) {
        if (memory_txt[i].checked) {
            switch (i) {
                case 0:
                    AdtWell_chk = "Y";
                    break;
                case 1:
                    AdtNotWell_chk = "Y";
                    break;
                case 2:
                    AdtMyDiay_chk = "Y";
                    break;
                case 3:
                    AdtAdvice_chk = "Y";
                    break;
                case 4:
                    AdtAdviceRe_chk = "Y";
                    break;
            }  
        }
    }
    var AdtWell = document.getElementById("AdtWell").value;//.replace(/\n/g, '<br>');
    var AdtNotWell = document.getElementById("AdtNotWell").value; //.replace(/\n/g, '<br>');
    var AdtMyDiay = document.getElementById("AdtMyDiay").value; //.replace(/\n/g, '<br>');
    var AdtAdvice = document.getElementById("AdtAdvice").value; //.replace(/\n/g, '<br>');
    var AdtAdviceRe = document.getElementById("AdtAdviceRe").value; //.replace(/\n/g, '<br>');
    
    if (AdtWell == "") {
        AdtWell = "";
    }
    if (AdtNotWell == "") {
        AdtNotWell = "";
    }
    if (AdtMyDiay == "") {
        AdtMyDiay = "";
    }
    if (AdtAdvice == "") {
        AdtAdvice = "";
    }
    if (AdtAdviceRe=="") {
        AdtAdviceRe = "";
    }


    tblSvcTrRerd = tblSvcTrRerd + AdtWell + "|" + AdtNotWell + "|" + AdtMyDiay + "|" + AdtAdvice + "|" + AdtAdviceRe + "|";
    tblSvcTrRerd = tblSvcTrRerd + AdtWell_chk + "|" + AdtNotWell_chk + "|" + AdtMyDiay_chk + "|" + AdtAdvice_chk + "|" + AdtAdviceRe_chk + "|";
    /*훈련일지 end*/


    /*훈련목표*/
    var tblSvcTrRerdTgt = "";
    train_goal_list = document.getElementsByName("train-goal-list");      //훈련목표
    for (var i = 0; i < train_goal_list.length; i++) {
        if (train_goal_list[i].checked) {
            tblSvcTrRerdTgt = tblSvcTrRerdTgt + train_goal_list[i].value + "|";
        }
    }

    if (tblSvcTrRerdTgt=="") {
        alert("훈련목표를 선택하여 주시기 바랍니다.");
        document.getElementsByName("train-goal-list").focus();
        return false;
    }

    /*훈련목표 end*/
   
    /*공식 훈련정보*/
    var tblSvcTrRerdTrai = "";
    var bg_navy = document.getElementById("bg-navy1");
    var id = "";
    
    var bg_navyseq = "";
    var PceCd = "";
    var TrailHour = "";
    var TraiFistCd = "";
    var MidCdselect = "";
    var target;
    var target_len;
 
    for (var i = 1; i < 5; i++) {
        if (i > 0) {
             bg_navyseq = document.getElementById("bg-navy" + i).value;
             PceCd = document.getElementById("PceCd" + i).value;
            TrailHourH = document.getElementById("TrailHour" + i+"Hour").value;
            TrailHourM = document.getElementById("TrailHour" + i + "Min").value;
            TrailHour = Number(TrailHourH) + Number(TrailHourM);
             TraiFistCd = document.getElementById("TraiFistCd" + i).value;
             var wrap_display = $("#official-train-wrap" + i).css("display");
             if (wrap_display=="block") {
                 if (bg_navyseq != "0") {
                     if (PceCd == "0") { document.getElementById("PceCd" + i).focus(); alert("훈련장소를 선택하여 주시기 바랍니다.."); return false; }
                     //if (TrailHour == "0.0") { document.getElementById("TrailHour" + i).focus(); alert("훈련시간을 선택하여 주시기 바랍니다."); return false; }
                     if (TraiFistCd == "0") { document.getElementById("TraiFistCd" + i).focus(); alert("훈련유형을 선택하여 주시기 바랍니다."); return false; }

                     tblSvcTrRerdTrai = tblSvcTrRerdTrai + i + "|" + bg_navyseq + "|" + PceCd + "|" + TrailHour + "|" + TraiFistCd + "|";

                     target = $("#MidCdselect" + i).find('li');
                     target_le = target.length;

                     for (var t = 0; t < target_le; t++) {
                         var tagid = target[t].id.replace("MidCdselect" + i + TraiFistCd + i, "").replace(TraiFistCd + i, "").replace("MidCdselect" + i, "").replace("MidCdselect", "");
                         tagid = tagid.replace("MidCdselect" + i + TraiFistCd + i, "").replace(TraiFistCd + i, "").replace("MidCdselect" + i, "").replace("MidCdselect", "");
                         MidCdselect = MidCdselect + "(" + tagid + ")";
                     }
                     tblSvcTrRerdTrai = tblSvcTrRerdTrai + MidCdselect + "!";
                     tagid = "";
                     MidCdselect = "";
                     bg_navyseq = "";
                     PceCd = "";
                     TrailHour = "";
                     TraiFistCd = "";
                 }
             }
        }
     }
     //console.log(tblSvcTrRerdTrai);
  
     /*공식 훈련정보 end*/

     /*개인 훈련정보 */
     var tblSvcTrRerdTrai_person = "";
     var bg_orseq = "";
     var PceCdp = "";
     var TrailHourP = "";
     var TraiFistCdP = "";
     var MidCdselect = "";

     var target;
     var target_len;
     for (var i = 0; i < 2; i++) {
         if (i > 0) {
             bg_orseq = document.getElementById("bg-or" + i).value;
             PceCdp = document.getElementById("PceCdp" + i).value;
             TrailHourPH = document.getElementById("TrailHourP" + i + "Hour").value;
             TrailHourPM = document.getElementById("TrailHourP" + i + "Min").value;
             TrailHourP = Number(TrailHourPH) + Number(TrailHourPM);
             TraiFistCdP = document.getElementById("TraiFistCdP" + i).value;
             if (bg_orseq != "0") {
                 if (PceCdp == "0") { document.getElementById("PceCdp" + i).focus(); alert("훈련장소를 선택하여 주시기 바랍니다.."); return false; }
                 if (TrailHourP == "0.0") { document.getElementById("TrailHourP" + i).focus(); alert("훈련시간을 선택하여 주시기 바랍니다."); return false; }
                 if (TraiFistCdP == "0") { document.getElementById("TraiFistCdP" + i).focus(); alert("훈련유형을 선택하여 주시기 바랍니다."); return false; }
                 tblSvcTrRerdTrai_person = tblSvcTrRerdTrai_person + i + "|" + bg_orseq + "|" + PceCdp + "|" + TrailHourP + "|" + TraiFistCdP + "|";

                 target = $("#MidCdselectPerson" + i).find('li');
                 target_le = target.length;

                 for (var t = 0; t < target_le; t++) {
                     var tagid = target[t].id.replace("MidCdselectPerson" + i + TraiFistCdP + i, "").replace(TraiFistCdP + i, "").replace("MidCdselectPerson" + i, "").replace("MidCdselectPerson", "");
                         tagid = tagid.replace("MidCdselectPerson" + i + TraiFistCdP + i, "").replace(TraiFistCdP + i, "").replace("MidCdselectPerson" + i, "").replace("MidCdselectPerson", "");
                         MidCdselect = MidCdselect + "(" + tagid + ")";
                     }

                     tblSvcTrRerdTrai_person = tblSvcTrRerdTrai_person + MidCdselect + "!";

                     tagid = "";
                     MidCdselect = "";

                     bg_orseq = "";
                     PceCdp = "";
                     TrailHourP = "";
                     TraiFistCdP = "";
             }
         }
     }

     /*개인 훈련정보 end*/


    //훈련평가 --값
    var tranin_question   = "";
    //훈련평가
    //document.getElementsByName("tranin-question01").length
    var question = "tranin-question";
    var question_name = "";

    var j = "0001";
    for (var i = 1; i < 11; i++) {
        if (i < 10) {
            j = "000" + i;
        } else {
            j = "00"+i;
        }
        question_name = question + j;
        var chek = 0;

        for (var c = 0; c < document.getElementsByName(question_name).length; c++) {
            if (document.getElementsByName(question_name)[c].checked) {
                chek = document.getElementsByName(question_name)[c].value;

                tranin_question = tranin_question + chek + "|";
            }             
        }

        if (chek <= 0) {
            document.getElementById("tranin-question").focus();
            alert(" "+i+"번째 훈련평가를 마무리 하여 주시기 바랍니다.");
            return false;
        }
    }
    var tblSvcTrRerdAsmt = tranin_question;
    /*훈련평가 end*/

    if (tblSvcTrRerd != "") {
        tblSvcTrRerd = tblSvcTrRerd.substring(0, tblSvcTrRerd.length - 1);
    }
    if (tblSvcTrRerdTgt != "") {
        tblSvcTrRerdTgt = tblSvcTrRerdTgt.substring(0, tblSvcTrRerdTgt.length - 1);
    }

    if (tblSvcTrRerdJury != "") {
        tblSvcTrRerdJury = tblSvcTrRerdJury.substring(0, tblSvcTrRerdJury.length - 1);
    }

    if (tblSvcTrRerdTrai != "") {
        tblSvcTrRerdTrai = tblSvcTrRerdTrai.substring(0, tblSvcTrRerdTrai.length - 1);
    }

    if (tblSvcTrRerdTrai_person != "") {
        tblSvcTrRerdTrai_person = tblSvcTrRerdTrai_person.substring(0, tblSvcTrRerdTrai_person.length - 1);
    }
    if (tblSvcTrRerdAsmt != "") {
        tblSvcTrRerdAsmt = tblSvcTrRerdAsmt.substring(0, tblSvcTrRerdAsmt.length - 1);
    }



    var p_TEAMTRAI = $("#p_TEAMTRAI").val();
    if (p_TEAMTRAI == "Y") {
       // tblSvcTrRerdTrai = "";
    }


    console.log("훈련일지" + tblSvcTrRerd);
    console.log("훈련목표" + tblSvcTrRerdTgt);
    console.log("부상부위" + tblSvcTrRerdJury);
    console.log("공식훈련" + tblSvcTrRerdTrai);
    console.log("개인훈련" + tblSvcTrRerdTrai_person);
    console.log("훈련평가" + tblSvcTrRerdAsmt);

   // return false;

    //훈련일지
    //     tblSvcTrRerd
    //훈련목표
    //     tblSvcTrRerdTgt
    //공식훈련
    //     tblSvcTrRerdTrai
    //개인훈련
    //     tblSvcTrRerdPTrai
    //훈련평가
    //     tblSvcTrRerdAsmt
    //부상부위
    //     tblSvcTrRerdJury

    //저장- 중분류 숫자 파악 후 처리
    var strAjaxUrl = "/M_Player/Ajax/Train_OK.asp";
    $.ajax({
        url: strAjaxUrl,
        type: 'POST',
        dataType: 'html',
        data: {
            tblSvcTrRerd: tblSvcTrRerd,
            tblSvcTrRerdTgt: tblSvcTrRerdTgt,
            tblSvcTrRerdTrai: tblSvcTrRerdTrai,
            tblSvcTrRerdPTrai: tblSvcTrRerdTrai_person,
            tblSvcTrRerdAsmt: tblSvcTrRerdAsmt,
            tblSvcTrRerdJury: tblSvcTrRerdJury
        },
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
        success: function (retDATA) {
            if (retDATA) {
                if (retDATA == "TRUE") {
                    alert("저장되었습니다.");
                    location.href = "/M_Player/Schedule/sche-train.asp?TrRerdDate=" + $("#datetimepicker1").val();
                } else {
                    alert("잘못된 접근입니다.");
                }
            }
        }, error: function (xhr, status, error) {
            if (error != '') {
                alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
            }
        }
    });

}
