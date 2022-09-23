function MadalPrintimg(TargetID,PringtingTargetID) {
    html2canvas($("#" + TargetID), {
        onrendered: function (canvas) {
            var maxheight = canvas.height;
            if (canvas.height > 2300) {
                maxheight = 2040;
            } else {
                maxheight = 900;
            }
            $("#" + PringtingTargetID).append("<p style='text-align:center'><img src=" + canvas.toDataURL("image/png") + " align='middle' style='max-height:" + maxheight + "px;  margin: 0 auto;'></p>");
        }
    });
}

function SectionPrintimg() {
    $("#SectionPrintimg").html("");

    html2canvas($("#tourney_title"), {
        onrendered: function (canvas) {
            $("#SectionPrintimg").append("<img src=" + canvas.toDataURL("image/png") + "  style='width:110%; height:auto; padding-right: 20px;  margin: 0 auto; overflow: hidden;' >");
            //$("#SectionPrintimg").append("<h2 class='stage-title row' >" + $("#tourney_title").html() + "</h2>");
            html2canvas($("#input-select"), {
                onrendered: function (canvas) {
                    $("#SectionPrintimg").append("<img src=" + canvas.toDataURL("image/png") + "  style='width:110%;  height:auto;  margin: 0 auto; overflow: hidden;' >");
                }
            });


            html2canvas($("#DP_MedalList"), {
                onrendered: function (canvas) {
                    $("#SectionPrintimg").append("<img src=" + canvas.toDataURL("image/png") + " style='width: 110%;  height:auto; margin: 0 auto; overflow: hidden;' >");
                    html2canvas($(".tourney-mode.tourney-result"), {
                        onrendered: function (canvas) {

                            var maxheight = canvas.height;
                            if (canvas.height > 2300) {
                                maxheight = 2100;
                            } else {
                                maxheight = 1020;
                            }
                            console.log(maxheight);
                            console.log(canvas.height);

                            $("#SectionPrintimg").append("<p style='text-align:center'><img src=" + canvas.toDataURL("image/png") + " align='middle' style='max-height:" + maxheight + "px;  margin: 0 auto;'></p>");
                        }
                    });

                    html2canvas($("#DP_natfinal_tourney"), {
                        onrendered: function (canvas) {
                            var maxheight = canvas.height;
                            if (canvas.height > 2300) {
                                maxheight = 2100;
                            } else {
                                maxheight = 1020;
                            }
                            $("#SectionPrintimg").append("<p style='text-align:center'><img src=" + canvas.toDataURL("image/png") + " align='middle' style='max-height:" + maxheight + "px;  margin: 0 auto;'></p>");
                        }
                    });

                    html2canvas($("#list_league"), {
                        onrendered: function (canvas) {
                            var maxheight = canvas.height;
                            if (canvas.height > 2300) {
                                maxheight = 2100;
                            } else {
                                maxheight = 1020;
                            }
                            $("#SectionPrintimg").append("<p style='text-align:center'><img src=" + canvas.toDataURL("image/png") + " align='middle' style='max-height:" + maxheight + "0px; margin: 0 auto;'></p>");
                        }
                    });

                    html2canvas($("#DP_IJF_tourney"), {
                        onrendered: function (canvas) {
                            var maxheight = canvas.height;
                            if (canvas.height > 2300) {
                                maxheight = 2100;
                            } else {
                                maxheight = 1020;
                            }
                            $("#SectionPrintimg").append("<p style='text-align:center'><img src=" + canvas.toDataURL("image/png") + " align='middle' style='max-height:" + maxheight + "0px; margin: 0 auto;'></p>");
                        }
                    });

                }
            });
        }
    });
}

/*상세기록지 image*/
function Enter_Score_Print() {
    $("#Enter_Score_Print").html("");
    $EnterScore = $(".a4");

    for (var i = 0; i < $EnterScore.length; i++) {
        html2canvas($EnterScore[i], {
            onrendered: function (canvas) {
                $("#Enter_Score_Print").append("<div class='a4'><img src=" + canvas.toDataURL("image/png") + "  ></div>");
            }
        });
    }

}


/*대진표 인쇄 설정*/
function SectionPrintClick(FileN, fileD) {
    setTimeout(function () {

        if (FileN == "SectionPrintimg") {
            var $BtnDanger = $(".btn.btn-danger");
            if ($BtnDanger.length <= 0) {

                $BtnDanger = $(".btn.btn-primary");
                if ($BtnDanger.length <= 0) {
                    return false;
                }
            }
            var C_gametype = $("#game-type option:selected").text();
            var C_TeamGb = $("#TeamGb option:selected").text();
            var C_SexLevel = $("#SexLevel option:selected").text();
            var C_GameTitleIDX = $("#GameTitleIDX option:selected").text().replace("(종료)", "");
            C_GameTitleIDX = C_GameTitleIDX.replace("(예정)", "");
            C_GameTitleIDX = C_GameTitleIDX.replace("(진행중)", "");

            var mywindow = window.open('', '대진표 출력'
                                        , 'width=0, height=0, left=0, top=0, toolbar=0, location=0, directories=0, status=0, menubar=0, resizable=0'
                                        );
            mywindow.document.write('<html><head> <title>' + C_GameTitleIDX + "_" + C_gametype + "_" + C_TeamGb + "_" + C_SexLevel + '</title></head><body>');
            mywindow.document.write($("#" + FileN).html());
            mywindow.document.write('</body></html>');
            mywindow.document.close();
            mywindow.focus();

            mywindow.print();
            mywindow.close();
        } else if (FileN == "SectionEnterCorePrintimg") {
            /*상세 기록 조회 창*/
            if (fileD == "popup") {
                $("#Enter_Score_Print_new").html("");
                var checkimg = false;
                var load = true;
                var $a4 = $(".a4");
                if ($a4.length <= 0) {
                    load = false;
                } else {
                    load = true;
                }


                //리스트의 순서 
                var chekc = $("input[id*=check_]");
                chekc.each(function () {
                    // 리스트에서 체크 된 내용 확인
                    if ($(this).is(":checked")) {
                        var imgidx = "#CanvasImg_" + $(this).next().val();

                        // 실제 이미지 있는지 확인
                        if ($(imgidx).length <= 0) {
                            checkimg = false;
                            load = true;
                        } else {
                            checkimg = true;
                            load = true;
                        }
                    }
                });


                //오류 메이지
                if (checkimg) {
                    if (load) {

                    } else {
                        alert(" 출력내용을 불러오는중 입니다. ");
                        return false;
                    }
                } else {
                    if (load) {
                        alert(" 출력내용을 불러오는중 입니다. ");
                        return false;

                    } else {
                        alert("출력 내용이 없습니다.");
                        return false;
                    }
                }


                var C_gametype = $("#game-type option:selected").text();
                var C_TeamGb = $("#TeamGb option:selected").text();
                var C_SexLevel = $("#SexLevel option:selected").text();
                var C_GameTitleIDX = $("#GameTitleIDX option:selected").text().replace("(종료)", "");
                C_GameTitleIDX = C_GameTitleIDX.replace("(예정)", "");
                C_GameTitleIDX = C_GameTitleIDX.replace("(진행중)", "");
                C_GameTitleIDX = C_GameTitleIDX.replace(".", "");

                var mywindow = window.open('', '상세기록 출력', 'width=800, height=1000, left=0, top=0, toolbar=0, location=0, directories=0, status=0, menubar=0, resizable=0');
                mywindow.document.write('<html><head> <title>' + C_GameTitleIDX + "_" + C_gametype + "_" + C_TeamGb + "_" + C_SexLevel + '</title></head><body>');

                if (checkimg) {
                    chekc.each(function () {
                        // 리스트에서 체크 된 내용 확인
                        if ($(this).is(":checked")) {
                            var imgidx = "#CanvasImg_" + $(this).next().val();
                            mywindow.document.write($(imgidx).html());
                        }
                    });
                }


                //이미지 출력 
                mywindow.document.write('</body></html>');
                mywindow.document.close();
                mywindow.focus();
                mywindow.print();
                mywindow.close();
            }
            else if (fileD == "print") {

            }

        } else if (FileN == "madalprint") {
            //MadalPrintimg("list_body", "madalprint"); 
            if (fileD == "print") {

                var s_frm = document.s_frm;
                window.open('', 'PrintingMedal', 'width=1000, height=400, left=0, top=0, toolbar=0, location=0, directories=0, status=0, menubar=0, resizable=0');
                s_frm.action = "select/PrintingMedal.asp";
                s_frm.target = "PrintingMedal";
                s_frm.method = "post";
                s_frm.submit();
            }
            else {

            }
        }

    }, 1000);

}
/*대진표 인쇄 설정*/



/*상세 기록지 인쇄 설정*/
function EnterScorePrint(FileID, FileCount, InnerID) {
    /*S: FileCount : one  한장 팝업 출력*/
    if (FileCount == "one") {

        var WPrint = $.when( 
            setTimeout(function () {
                var tw = window.open('', 'popup_window', 'width=1400, height=900, left=0, top=0, toolbar=0,scrol=0, location=0, directories=0, status=0, menubar=0, resizable=0');
                // 출력 팝업 호출
                var frm = document.forms["form_" + FileID];
                frm.action = "EnterScore_print1.asp";
                frm.target = "popup_window"; 
                frm.submit();
            }, 0));
            WPrint.done(function () {
             
            });
        //출력 내용 저장 log
    }
    /*E: FileCount : one  한장 팝업 출력*/


    /*S: FileCount : check 체크*/

    if (FileCount == "check") {

        if ($("#check_" + FileID).is(":checked")) {
            FileCount = "check";
            /*FileCount : check 체크 내용 저장*/

            var WPrint = $.when(
            setTimeout(function () {
                //var tw = window.open('', 'popup_window', 'width=1400, height=900, left=0, top=0, toolbar=0,scrol=0, location=0, directories=0, status=0, menubar=0, resizable=0');
                // 출력 팝업 호출
                var frm = document.forms["form_" + FileID];
                frm.action = "EnterScore_print.asp";
                frm.target = "Enter_Score_Print_Fr" + FileID; 
                frm.submit();


            }, 0));
            WPrint.done(function () {
                
            });
            //출력 내용 저장 log



            //출력 내용 저장
        } else {
            FileCount = "uncheck";
            /*FileCount : uncheck 체크 내용 삿제*/
            $("#CanvasImg_" + FileID).remove();
            //출력 내용 삭제
        }

    }

    /*E: FileCount : check 체크*/


    /*S: FileCount : all  전체 팝업 출력*/
    if (FileCount == "all") {


        //저장한내용 출력

        //체크 된 내용 확인

        //출력 창 오픈

        //출력 내용 저장 log

    }
    /*E: FileCount : all  전체 팝업 출력*/
}
/*상세 기록지 인쇄 설정*/
