<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->
<script language="javascript">

    $(document).ready(function () {

        change_gametitle($("#sel_Year").val());

    });

    var change_gametitle = function (objval) {

        var obj = {};

        obj.CMD = "GameTitle";
        obj.GameYear = objval;

        //window.open('about:blank').location.href = "../../ajax/select/GameTitle.asp?CMD=" + obj.CMD + "&GameYear=" + obj.GameYear;

        SendPacketSe(obj, "../../ajax/select/GameTitle.asp");
    }

    var change_stadiumname = function () {

        var obj = {};

        obj.CMD = "StadiumName";
        obj.GameTitleIDX = $("#sel_GameTitle").val();
        obj.GameDay = $("#sel_GameDay").val();

        //window.open('about:blank').location.href = "../../ajax/select/StadiumName.asp?CMD=" + obj.CMD + "&GameTitleIDX=" + obj.GameTitleIDX + "&GameDay=" + obj.GameDay;

        console.log("?CMD=" + obj.CMD + "&GameTitleIDX=" + obj.GameTitleIDX + "&GameDay=" + obj.GameDay);

        SendPacketSe(obj, "../../ajax/select/StadiumName.asp");
    }

    var change_gameday = function () {


        var obj = {};

        obj.CMD = "GameDay";
        obj.GameTitleIDX = $("#sel_GameTitle").val();

        //window.open('about:blank').location.href = "../../ajax/select/GameDay.asp?CMD=" + obj.CMD + "&GameTitleIDX=" + obj.GameTitleIDX;

        SendPacketSe(obj, "../../ajax/select/GameDay.asp");

    }

    var change_stadiumnum = function () {

        var obj = {};

        obj.CMD = "StadiumNum";
        obj.GameTitleIDX = $("#sel_GameTitle").val();
        obj.GameDay = $("#sel_GameDay").val();
        obj.StadiumIDX = $("#sel_StadiumName").val();

        //window.open('about:blank').location.href = "../../ajax/select/StadiumCourt.asp?CMD=" + obj.CMD + "&StadiumIDX=" + obj.StadiumIDX;

        SendPacketSe(obj, "../../ajax/select/StadiumCourt.asp");
    }

    var chk_Submit = function (chkPage) {

        var obj = {};

        obj.CMD = "FrmSubmit";
        obj.GameTitleIDX = $("#sel_GameTitle").val();
        obj.GameDay = $("#sel_GameDay").val();
        obj.StadiumIDX = $("#sel_StadiumName").val();
        obj.StadiumNum = $("#sel_StadiumNum").val();
        obj.SearchKey = $("#SearchKey").val();
        obj.Searchkeyword = $("#Searchkeyword").val();

        if (chkPage != '') $('#currPage').val(chkPage);

        obj.currPage = $('#currPage').val();

        /*
        window.open('about:blank').location.href = "../../ajax/GameTitleMenu/List_Operate.asp?CMD=" + obj.CMD
        + "&GameTitleIDX=" + obj.GameTitleIDX
        + "&GameDay=" + obj.GameDay
        + "&StadiumIDX=" + obj.StadiumIDX
        + "&StadiumNum=" + obj.StadiumNum;
        */

        SendPacketSe(obj, "../../ajax/GameTitleMenu/List_Operate.asp");
    }

    var operate_excel = function () {

        var obj = {};

        obj.CMD = "OperateExcel";
        obj.GameTitleIDX = $("#sel_GameTitle").val();
        obj.GameDay = $("#sel_GameDay").val();
        obj.StadiumIDX = $("#sel_StadiumName").val();
        obj.StadiumNum = $("#sel_StadiumNum").val();
        obj.SearchKey = $("#SearchKey").val();
        obj.Searchkeyword = $("#Searchkeyword").val();

        location.href="./OperateList_Excel.asp?CMD=" + obj.CMD +
        "&CMD=" + obj.CMD +
        "&GameTitleIDX=" + obj.GameTitleIDX +
        "&GameDay=" + obj.GameDay +
        "&StadiumIDX=" + obj.StadiumIDX +
        "&StadiumNum=" + obj.StadiumNum +
        "&SearchKey=" + obj.SearchKey +
        "&Searchkeyword=" + obj.Searchkeyword;


    }

    var operate_excel_se = function () {

        var obj = {};

        obj.CMD = "OperateExcel";
        obj.GameTitleIDX = $("#sel_GameTitle").val();
        obj.GameDay = $("#sel_GameDay").val();
        obj.StadiumIDX = $("#sel_StadiumName").val();
        obj.StadiumNum = $("#sel_StadiumNum").val();
        obj.SearchKey = $("#SearchKey").val();
        obj.Searchkeyword = $("#Searchkeyword").val();

        location.href = "./OpExcel.asp?CMD=" + obj.CMD +
        "&CMD=" + obj.CMD +
        "&GameTitleIDX=" + obj.GameTitleIDX +
        "&GameDay=" + obj.GameDay +
        "&StadiumIDX=" + obj.StadiumIDX +
        "&StadiumNum=" + obj.StadiumNum +
        "&SearchKey=" + obj.SearchKey +
        "&Searchkeyword=" + obj.Searchkeyword;


    }

    OnReceiveAjax = function (retdata) {

        console.log(retdata);

        if (retdata.indexOf("`##`") != -1) {

            $("#board-contents").html(retdata);
        }
        else {

            var myArr = JSON.parse(retdata);

            if (myArr.CMD == "GameTitle") {


                if (myArr.RESULT != null) {

                    var dtlArr = JSON.parse(myArr.RESULT);


                    $("#sel_GameTitle").find("option").remove();

                    for (var i = 0; i < dtlArr.length; i++) {
                        $("#sel_GameTitle").append(new Option(dtlArr[i].GameTitleName, dtlArr[i].GameTitleIDX));

                    }

                }
                else {
                    $("#sel_GameTitle").find("option").remove();
                    $("#sel_GameTitle").append(new Option("-", ""));
                }

                change_gameday($("#sel_GameTitle").val());

            }

            else if (myArr.CMD == "GameDay") {


                if (myArr.RESULT != null) {

                    var dtlArr = JSON.parse(myArr.RESULT);


                    $("#sel_GameDay").find("option").remove();

                    for (var i = 0; i < dtlArr.length; i++) {
                        $("#sel_GameDay").append(new Option(dtlArr[i].GameDay, dtlArr[i].GameDay));

                    }

                }
                else {
                    $("#sel_GameDay").find("option").remove();
                    $("#sel_GameDay").append(new Option("-", ""));
                }


                change_stadiumname();

            }



            else if (myArr.CMD == "StadiumName") {


                if (myArr.RESULT != null) {

                    var dtlArr = JSON.parse(myArr.RESULT);


                    $("#sel_StadiumName").find("option").remove();

                    for (var i = 0; i < dtlArr.length; i++) {
                        $("#sel_StadiumName").append(new Option(dtlArr[i].StadiumName, dtlArr[i].StadiumIDX));

                    }

                }
                else {
                    $("#sel_StadiumName").find("option").remove();
                    $("#sel_StadiumName").append(new Option("-", ""));
                }

                change_stadiumnum();


            }

            else if (myArr.CMD == "StadiumNum") {


                if (myArr.RESULT != null) {

                    var dtlArr = JSON.parse(myArr.RESULT);

                    $("#sel_StadiumNum").find("option").remove();

                    /*
                    if (dtlArr[0].StadiumCourt != null) {
                    for (var i = 1; i <= Number(dtlArr[0].StadiumCourt); i++) {
                    $("#sel_StadiumNum").append(new Option(i + "코트", i));
                    }
                    }
                    */

                    for (var i = 0; i < dtlArr.length; i++) {
                        $("#sel_StadiumNum").append(new Option(dtlArr[i].StadiumNum + "코트", dtlArr[i].StadiumNum));

                    }

                }
                else {
                    $("#sel_StadiumNum").find("option").remove();
                    $("#sel_StadiumNum").append(new Option("-", ""));
                }


            }

            else if (myArr.CMD == "FrmSubmit") {


                if (myArr.RESULT != null) {

                    var dtlArr = JSON.parse(myArr.RESULT);

                    $("#sel_StadiumNum").find("option").remove();

                    /*
                    if (dtlArr[0].StadiumCourt != null) {
                    for (var i = 1; i <= Number(dtlArr[0].StadiumCourt); i++) {
                    $("#sel_StadiumNum").append(new Option(i + "코트", i));
                    }
                    }
                    */

                    for (var i = 0; i < dtlArr.length; i++) {
                        $("#sel_StadiumNum").append(new Option(dtlArr[i].StadiumNum + "코트", dtlArr[i].StadiumNum));

                    }

                }
                else {
                    $("#sel_StadiumNum").find("option").remove();
                    $("#sel_StadiumNum").append(new Option("-", ""));
                }


            }
        }







    }
</script> 
<!-- S : content gameTitle operate-list -->
  <div id="content" class="gameTitle operate-list">
    <!-- S: page_title -->
    <div class="page_title clearfix">
      <h2>경기진행순서 조회</h2>

      <!-- S: 네비게이션 -->
      <div  class="navigation_box">
        <span class="ic_deco">
          <i class="fas fa-angle-right fa-border"></i>
        </span>
        <ul>
          <li>대회정보</li>
          <li>대회관리</li>
          <li><a href="./OperateList.asp">경기진행순서 조회</a></li>
        </ul>
      </div>
      <!-- E: 네비게이션 -->

    </div>
    <!-- E: page_title -->

    <!-- S : sch 검색조건 선택 및 입력 -->
    <form name="s_frm" method="post">
      <input type="hidden" id="currPage" name="currPage" value="1" />
      <!-- S: registration_btn -->
      <div class="registration_btn">
        <a href="#" class="btn btn-add" onclick="operate_excel_se();">엑셀</a>
        <a href="#" class="btn btn-add" onclick="operate_excel();">엑셀다운로드</a>
      </div>
      <!-- E: registration_btn -->
      <!-- S: search_top -->
      <div class="search_top clearfix">
        <!-- S: search_box -->
        <div class="search_box">
          <!-- S: upper-line -->
          <div class="upper-line">
              <span class="sub-tit">년도</span>
              <select  id="sel_Year" class="title_select" name="sel_Year" onchange="change_gametitle();">
                       <%For i = 2018 TO Year(Date) + 1%>
                      <option value="<%=i%>"><%=i%>년도</option>
                       <%Next%>
                  </select>
                  <span class="sub-tit">대회명</span>
                  <select id="sel_GameTitle" class="long_select" name="sel_GameTitle" onchange="change_gameday();"></select>
                  <span class="sub-tit">일자</span>
                  <select id="sel_GameDay" class="title_select" name="sel_GameDay" onchange="change_stadiumname()">
                  </select>
                  <span class="sub-tit">경기장</span>
                  <select id="sel_StadiumName" class="title_select" name="sel_StadiumName" onchange="change_stadiumnum()">
                  </select>
                  <span class="sub-tit">코트</span>
                  <select id="sel_StadiumNum" class="title_select" name="sel_StadiumNum">
                  </select>
              </div>
              <!-- E: upper-line -->

              <!-- S: under-line -->
              <div class="under-line srch-word">
                <span class="sub-tit">검색어</span>
                <select id="SearchKey" class="title_select" name="SearchKey">
                  <option value="">==선택==</option>
                  <option value="UserName">선수명</option>
                  <option value="TeamNm">팀명</option>
                </select>
                <input type="text" name="Searchkeyword" id="Text2" value="<%=Searchkeyword%>" class="ipt-word" placeholder="키워드 검색 [제목, 내용]" autocomplete="off">
              </div>
              <!-- E: under-line -->

            <!-- S: r_search_btn -->
            <div class="r_search_btn">
              <a href="#" onclick="javascript:chk_Submit('1');" class="btn btn-search">검색</a>
            </div>
            <!-- E: r_search_btn -->
          </div>
          <!-- E: search_box -->
        </div>
        <!-- E: search_top -->
    
        <!-- S : 리스트형 20개씩 노출 -->
        <div id="board-contents" class="table-list-wrap"> 
          <!-- S : table-list --> 
          <!-- E : table-list --> 
        </div>
        <!-- E : 리스트형 20개씩 노출 --> 
    </form>
    <!-- E : sch 검색조건 선택 및 입력 --> 
  </div>
<!-- E : content gameTitle operate-list --> 

<!--#include file="../../include/footer.asp"-->