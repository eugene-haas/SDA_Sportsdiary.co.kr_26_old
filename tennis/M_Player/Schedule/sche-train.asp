<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
check_login()
TrRerdDate=Replace(fInject(Request("TrRerdDate")),"-","")
TrRerdDate=left(TrRerdDate,4)&"-"&mid(TrRerdDate,5,2)&"-"&right(TrRerdDate,2)
TrRerdDateTrs= FormatDateTime(TrRerdDate,1)
%>
<script type="text/javascript">
    $(document).ready(function () {
        var TrRerdDate = "<%=TrRerdDate %>";
        var TrRerdDateTrs = "<%=TrRerdDateTrs %>";
        $("#SearchDate").val(TrRerdDate);

        //데이터 조회 일괄 처리
        $.ajax({
            url: "sche-train_JSON.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                TrRerdDate: TrRerdDate
            },
            success: function (retDATA) {
                if (retDATA == "]") {
                    //alert("일지 내용이 없습니다. 작성 페이지로 이동 합니다.");
                    //$(location).attr('href', "../Train/Train.asp?TrRerdDate=" + TrRerdDate );
                } else {
                    var retDATAobj = eval(retDATA);
                    $(".date").text("훈련날짜 : " + TrRerdDateTrs);

                    $("#sub-title").append(" <li><span class='title'>컨디션 &nbsp;: </span> <span class='txt'>&nbsp;" + retDATAobj[0].MentlNm + "</span>  </li>");
                    $("#sub-title").append(" <li><span class='title'>훈련참석(부상) 체크 &nbsp;: </span> <span class='txt'>&nbsp;" + retDATAobj[0].AdtInTpNm + "</span>  </li>");

                    if (retDATAobj[0].AdtInTp != "A") {
                        $("#sub-title").append(" <li><span class='title'>사유 &nbsp;: </span> <span class='txt'>&nbsp;" + retDATAobj[0].AdtMIdNm + "</span>  </li>");
                    }
                    if (retDATAobj[0].bigo != "") {
                        //$("#sub-title").append(" <li class='injury clearfix'><span class='title'>부상부위 &nbsp;: </span> <span class='txt'>&nbsp;" + retDATAobj[0].bigo + "</span>  </li>");
                        $("#sub-title").append(" <li class='train_goal clearfix'><span class='title'>부상부위 : </span> <span class='txt'>&nbsp;" + retDATAobj[0].bigo + "</span>  </li>");
                    }

                    if (retDATAobj[0].TgtNm != "") {
                        var srt = retDATAobj[0].TgtNm.split(",");
                        var TgtNmSp = "";
                        for (var i = 0; i < srt.length; i++) {
                            if (i < srt.length && i > 0) {
                                TgtNmSp = " " + TgtNmSp + "<br>";
                            }
                            TgtNmSp = TgtNmSp + "<span class='txt'>&nbsp;" + srt[i] + "</span>";
                        }
                        $("#sub-title").append("<li class='train_goal clearfix'><span class='title'>훈련목표 &nbsp;: </span>" + TgtNmSp + "</li>");
                    }

                    $("#p_TrRerdIDX").val(retDATAobj[0].TrRerdIDX);
                    $("#p_TrRerdDate").val(retDATAobj[0].TrRerdDate);

                    $("#p_MentlCd").val(retDATAobj[0].MentlCd);
                    $("#p_AdtFistCd").val(retDATAobj[0].AdtFistCd);
                    $("#p_AdtInTp").val(retDATAobj[0].AdtInTp);
                    $("#p_AdtMidCd").val(retDATAobj[0].AdtMidCd);
                    //.replace(/<br\s*[\/]?>/gi, "\n")

                    //console.log(retDATAobj[0].AdtWell.replace(/\n/g, '<br>'));
                    //                    $("#p_AdtWell").val(retDATAobj[0].AdtWell.replace(/\n/g, '<br>'));
                    //                    $("#p_AdtNotWell").val(retDATAobj[0].AdtNotWell.replace(/\n/g, '<br>'));
                    //                    $("#p_AdtMyDiay").val(retDATAobj[0].AdtMyDiay.replace(/\n/g, '<br>'));
                    //                    $("#p_AdtAdvice").val(retDATAobj[0].AdtAdvice.replace(/\n/g, '<br>'));
                    //                    $("#p_AdtAdviceRe").val(retDATAobj[0].AdtAdviceRe.replace(/\n/g, '<br>'));

                    //                    $("#p_AdtWellCkYn").val(retDATAobj[0].AdtWellCkYn);
                    //                    $("#p_AdtNotWellCkYn").val(retDATAobj[0].AdtNotWellCkYn);
                    //                    $("#p_AdtMyDiayCklYn").val(retDATAobj[0].AdtMyDiayCklYn);
                    //                    $("#p_AdtAdviceCkYn").val(retDATAobj[0].AdtAdviceCkYn);
                    //                    $("#p_AdtAdviceReCkYn").val(retDATAobj[0].AdtAdviceReCkYn);

                    $.ajax({
                        url: "sche-train-select.asp",
                        type: 'POST',
                        dataType: 'html',
                        data: {
                            TrRerdDate: TrRerdDate
                        },
                        success: function (retDATA) {
                            $("#public-train").html(retDATA);

                            //console.log(retDATA);
                        }, error: function (xhr, status, error) {
                            if (error != '') {
                                alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                            }
                        }
                    });

                    chage_search_idx(TrRerdDate);

                }
            }, error: function (xhr, status, error) {
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
        });

        //닫기
        $(".btn-left,.btn-back").on({
            "click": function (e) {
                e.preventDefault();
                var SeqSerch = $("#SeqSerch").val();
                SeqSerch++;
                $("#SeqSerch").val(SeqSerch);
                console.log(SeqSerch);
                if (document.referrer.indexOf("sportsdiary.co.kr") > 0) {
                    if (document.referrer.indexOf("train.asp") > 0) {
                        if (SeqSerch <= 1) {
                            //history.back(-1);
                            document.location.href = "../Schedule/sche-calendar.asp?SearchDate=" + $("#SearchDate").val();
                        }
                    } else {
                        history.back(-1);
                    }
                }
                else { document.location.href = "../Main/index.asp"; }
            }
        });
        //수정
        $(".btn-right").on({
            "click": function (e) {
                e.preventDefault();

                var tblSvcTrRerd = "";

                var TrRerdDate = $("#p_TrRerdDate").val(); //측정날짜
                var condition = $("#p_MentlCd").val();     //심리적상태 체크
                var btn_select = $("#p_AdtFistCd").val(); //훈련참석여부
                var train_check = $("#p_AdtInTp").val(); //정상?일부
                var train_check_select = $("#p_AdtMidCd").val(); //사유

                /*훈련일자/심리적상태/참석여부/참석유형/참석중분류/메모리*5/메모리체크*5 */
                tblSvcTrRerd = "" + TrRerdDate + "|" + condition + "|" + btn_select + "|" + train_check + "|" + train_check_select + "|";

                var url = "/Train/train.asp?TrRerdDate=" + TrRerdDate;
                $(location).attr('href', url);



                /*메모리*/
                /*
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

                //                var AdtWell = $("#AdtWell").val();//.replace(/\n/g, '<br>');
                //                var AdtNotWell = $("#AdtNotWell").val(); //.replace(/\n/g, '<br>');
                //                var AdtMyDiay = $("#AdtMyDiay").val(); //.replace(/\n/g, '<br>');
                //                var AdtAdvice = $("#AdtAdvice").val(); //.replace(/\n/g, '<br>');
                //                var AdtAdviceRe = $("#AdtAdviceRe").val(); //.replace(/\n/g, '<br>');

                var AdtWell = document.getElementById("AdtWell").value; //.replace(/\n/g, '<br>');
                var AdtNotWell = document.getElementById("AdtNotWell").value; //.replace(/\n/g, '<br>');
                var AdtMyDiay = document.getElementById("AdtMyDiay").value; //.replace(/\n/g, '<br>');
                var AdtAdvice = document.getElementById("AdtAdvice").value; //.replace(/\n/g, '<br>');
                var AdtAdviceRe = document.getElementById("AdtAdviceRe").value; //.replace(/\n/g, '<br>');

                tblSvcTrRerd = tblSvcTrRerd + AdtWell + "|" + AdtNotWell + "|" + AdtMyDiay + "|" + AdtAdvice + "|" + AdtAdviceRe + "|";
                tblSvcTrRerd = tblSvcTrRerd + AdtWell_chk + "|" + AdtNotWell_chk + "|" + AdtMyDiay_chk + "|" + AdtAdvice_chk + "|" + AdtAdviceRe_chk + "|";

                //훈련평가 --값
                var tranin_question = "";
                //훈련평가
                //document.getElementsByName("tranin-question01").length
                var question = "tranin-question";
                var question_name = "";

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
                tranin_question = tranin_question + chek + "|";
                }
                }

                if (chek <= 0) {
                document.getElementById("tranin-question").focus();
                alert(" " + i + "번째 훈련평가를 마무리 하여 주시기 바랍니다.");
                return false;
                }
                }
                var tblSvcTrRerdAsmt = tranin_question;

                if (tblSvcTrRerd != "") {
                tblSvcTrRerd = tblSvcTrRerd.substring(0, tblSvcTrRerd.length - 1);
                }
                if (tblSvcTrRerdAsmt != "") {
                tblSvcTrRerdAsmt = tblSvcTrRerdAsmt.substring(0, tblSvcTrRerdAsmt.length - 1);
                }

                console.log("훈련일지" + tblSvcTrRerd);
                console.log("훈련평가" + tblSvcTrRerdAsmt);

                $.ajax({
                url: "../Ajax/Train_sche_OK.asp",
                type: 'POST',
                dataType: 'html',
                data: {
                tblSvcTrRerd: tblSvcTrRerd,
                tblSvcTrRerdAsmt: tblSvcTrRerdAsmt
                },
                success: function (retDATA) {
                if (retDATA) {
                if (retDATA == "TRUE") {
                alert("수정되었습니다.");
                //  history.back();
                } else {
                alert("일시적인 오류 입니다. \r다시 시도해주시기 바랍니다.");
                }
                }
                }, error: function (xhr, status, error) {
                alert("오류발생! - 시스템관리자에게 문의하십시오!");
                }
                });
                */
            }
        });
        //end
    });

    //기본값 조회
    function chage_search_idx(TrRerdDate) {
        $.ajax({
            url: "../select/train_idx.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                TrRerdDate: TrRerdDate
            },
            success: function (retDATA) {
                $("#divTrRerdIDX").html(retDATA);


                //5. 훈련평가
                chage_search("tranin-question", TrRerdDate);

                //6. 메모리 //tblSvcTrRerd
                chage_search("memory", TrRerdDate);



            }, error: function (xhr, status, error) {
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
        });

    }

    //기본값 조회
    function chage_search(id_value, TrRerdDate) {

        //console.log($("#p_TrRerdIDX").val());
        var I_id
        if (id_value=="memory") {
            I_id = "memory_sch";
        } else if (id_value == "tranin-question") {
            I_id = "tranin-question_sch";
        }
        else {
            I_id = id_value;
        }

        console.log(id_value);

        $.ajax({
            url: "../select/train_Search.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                id: I_id,
                TrRerdDate: TrRerdDate,

                p_TrRerdIDX: $("#p_TrRerdIDX").val(),
                p_AdtWell: $("#p_AdtWell").val(),
                p_AdtNotWell: $("#p_AdtNotWell").val(),
                p_AdtMyDiay: $("#p_AdtMyDiay").val(),
                p_AdtAdvice: $("#p_AdtAdvice").val(),
                p_AdtAdviceRe: $("#p_AdtAdviceRe").val(),

                p_AdtWellCkYn: $("#p_AdtWellCkYn").val(),
                p_AdtNotWellCkYn: $("#p_AdtNotWellCkYn").val(),
                p_AdtMyDiayCklYn: $("#p_AdtMyDiayCklYn").val(),
                p_AdtAdviceCkYn: $("#p_AdtAdviceCkYn").val(),
                p_AdtAdviceReCkYn: $("#p_AdtAdviceReCkYn").val()
            },
            success: function (retDATA) {

                console.log(id_value);
                //console.log(retDATA);
                $("#" + id_value).html(retDATA);


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
</script>
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>훈련일지</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub sche train">
        <input type=hidden id ="SeqSerch" />
        <input type=hidden id ="SearchDate" />
        <input type="hidden" name="p_TrRerdIDX"id="p_TrRerdIDX" value="" >
        <input type="hidden" name="p_TrRerdDate"id="p_TrRerdDate" value="">
        <input type="hidden" name="p_MentlCd"id="p_MentlCd" value="">
        <input type="hidden" name="p_AdtFistCd"id="p_AdtFistCd"   value="">
        <input type="hidden" name="p_AdtInTp"id="p_AdtInTp"   value="">
        <input type="hidden" name="p_AdtMidCd"id="p_AdtMidCd"   value="">

   <div id="divTrRerdIDX">
   </div>

    <h2 class="date">훈련날짜 : </h2>
    <!-- S: 기본정보 -->
    <section class="basic-info">
      <h3 class="sub-title">기본정보</h3>
      <ul id ="sub-title"> </ul>
    </section>
    <!-- E: 기본정보 -->
    <!-- S: 공식훈련 내용 -->
    <section id="public-train" class="public-train"> </section>
    <!-- E: 공식훈련 내용 -->
    <!-- S: 개인훈련 내용 -->
    <!-- E: 개인훈련 내용 -->
    <!-- S : 훈련평가 -->
    <h2>훈련평가</h2>
    <table id="tranin-question" class="navy-top-table">
      <thead>
        <tr>
          <th rowspan="2">평가 내용</th>
          <th colspan="3">만족도</th>
        </tr>
        <tr>
          <th>상</th>
          <th>중</th>
          <th>하</th>
        </tr>
        <tbody>
          <tr>
            <td><label for="tranin-question01">1.훈련의 목표와 의도에 맞게 훈련이 되었나요?</label></td>
            <td><input type="radio" id="tranin-question01-1" name="tranin-question01" checked /></td>
            <td><input type="radio" id="tranin-question01-2" name="tranin-question01" /></td>
            <td><input type="radio" id="tranin-question01-3" name="tranin-question01" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question02">2.체력적인 만족도는?</label></td>
            <td><input type="radio" id="tranin-question02-1" name="tranin-question02" checked /></td>
            <td><input type="radio" id="tranin-question02-2" name="tranin-question02" /></td>
            <td><input type="radio" id="tranin-question02-3" name="tranin-question02" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question03">3.기술적인 만족도는?</label></td>
            <td><input type="radio" id="tranin-question03-1" name="tranin-question03" checked /></td>
            <td><input type="radio" id="tranin-question03-2" name="tranin-question03" /></td>
            <td><input type="radio" id="tranin-question03-3" name="tranin-question03" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question04">4.훈련의 양이 충분했나요?</label></td>
            <td><input type="radio" id="tranin-question04-1" name="tranin-question04" checked /></td>
            <td><input type="radio" id="tranin-question04-2" name="tranin-question04" /></td>
            <td><input type="radio" id="tranin-question04-3" name="tranin-question04" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question05">5.훈련의 질에 만족하나요?</label></td>
            <td><input type="radio" id="tranin-question05-1" name="tranin-question05" checked /></td>
            <td><input type="radio" id="tranin-question05-2" name="tranin-question05" /></td>
            <td><input type="radio" id="tranin-question05-3" name="tranin-question05" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question06">6.준비운동,정리운동은 잘 했나요?</label></td>
            <td><input type="radio" id="tranin-question06-1" name="tranin-question06" checked /></td>
            <td><input type="radio" id="tranin-question06-2" name="tranin-question06" /></td>
            <td><input type="radio" id="tranin-question06-3" name="tranin-question06" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question07">7.훈련에 집중할 수 있는 환경이였나요?</label></td>
            <td><input type="radio" id="tranin-question07-1" name="tranin-question07" checked /></td>
            <td><input type="radio" id="tranin-question07-2" name="tranin-question07" /></td>
            <td><input type="radio" id="tranin-question07-3" name="tranin-question07" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question08">8.식사,수면,휴식 등 자기관리가 잘 되었나요?</label></td>
            <td><input type="radio" id="tranin-question08-1" name="tranin-question08" checked /></td>
            <td><input type="radio" id="tranin-question08-2" name="tranin-question08" /></td>
            <td><input type="radio" id="tranin-question08-3" name="tranin-question08" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question09">9.최고의 선수가 되겠다는 의지가 강했나요?</label></td>
            <td><input type="radio" id="tranin-question09-1" name="tranin-question09" checked /></td>
            <td><input type="radio" id="tranin-question09-2" name="tranin-question09" /></td>
            <td><input type="radio" id="tranin-question09-3" name="tranin-question09" /></td>
          </tr>
          <tr>
            <td><label for="tranin-question10">10.스스로 최선을 다했다고 생각하나요?</label></td>
            <td><input type="radio" id="tranin-question10-1" name="tranin-question10" checked /></td>
            <td><input type="radio" id="tranin-question10-2" name="tranin-question10" /></td>
            <td><input type="radio" id="tranin-question10-3" name="tranin-question10" /></td>
          </tr>
        </tbody>
      </thead>
    </table>
    <!-- E : 훈련평가 -->
    <!-- S : 메모리 -->
    <h2>메모리</h2>
    <ul id="memory" class="memory">
      <li>
        <a href="#" class="sw-char" onClick="memoryChk('memory-txt01',1); return false;"><span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt01"  name ="memory-txt" value="1"><label for="memory-txt01">잘된점</label></a>
        <p><textarea id="AdtWell" placeholder="잘된점을 입력하세요"></textarea></p>
      </li>
      <li>
       <a href="#" class="sw-char" onClick="memoryChk('memory-txt02',2); return false;" ><span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt02"  name ="memory-txt" value="2" ><label for="memory-txt02">보완점</label></a>
        <p><textarea id="AdtNotWell" placeholder="보완점을 입력하세요."></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char"  onclick="memoryChk('memory-txt03',3); return false;"><span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt03"  name ="memory-txt"  value="3"><label for="memory-txt03">나의일기</label></a>
        <p><textarea id="AdtMyDiay" placeholder="나만의 일기를 작성해 보세요. (비공개)"></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char"  onclick="memoryChk('memory-txt04',4); return false;"><span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt04"  name ="memory-txt"  value="4"><label for="memory-txt04">지도자상담</label></a>
        <p><textarea id="AdtAdvice" placeholder="코치님 또는 감독님에게 하고 싶은 말을 입력하세요."></textarea></p>
      </li>
      <li>
        <a href="#" class="sw-char"  onclick="memoryChk('memory-txt05',5); return false;"><span class="icon-off-favorite">★</span>
        <input type="checkbox" id="memory-txt05"  name ="memory-txt" value="5" ><label for="memory-txt05">지도자답변</label></a>
        <p><textarea id="AdtAdviceRe"></textarea></p>
      </li>
    </ul>
    <!-- E : 메모리 -->
    <div class="container btn-list train-btn clearfix">
      <a href="#" class="btn-left">닫기</a>
      <a href="#" class="btn-right">수정</a>
    </div>
  </div>
  <!-- E : sub -->
  <!-- S: 경기상세입력 누락 알림 modal -->
  <div class="modal fade" id="" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">부상부위</div>
        <div class="modal-body">
          <ul class="tab-menu type3">
            <li class="on"><a href="#">부상부위(앞)</a></li>
            <li><a href="#">부상부위(뒤)</a></li>
          </ul>
          <div class="tabc">
            <div class="dist-cont">
              <img src="http://img.sportsdiary.co.kr/sdapp/stats/injury-front.jpg" alt="부상부위 이미지 앞" />
            </div>
          </div>
          <div class="tabc" style="display:none">
            <div class="dist-cont">
              <img src="http://img.sportsdiary.co.kr/sdapp/stats/injury-back.jpg" alt="부상부위 이미지 뒤" />
            </div>
          </div>
        </div>
      </div>
      <!-- ./ modal-content -->
    </div> <!-- ./modal-dialog -->
  </div>
  <!-- E : 경기상세입력 누락 알림 modal -->
  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
