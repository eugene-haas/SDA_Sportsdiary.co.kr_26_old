

var score = score || {};

console.log(0);
console.log(score.smenu);

score.gameSearch = function (tabletype) {
    var gameidx = localStorage.getItem("GameTitleIDX"); //경기인덱스

    var searchstr1 = $('input:radio[name="game-type"]:checked').val();
    var searchstr2 = $("#TeamGb").val();
    var searchstr3 = $("#SexLevel").val();

    if (searchstr3 == '' || searchstr3 == undefined || searchstr3 == false) {
        alert("종목을 선택해 주세요.");
        return;
    }
    else {
        var tt, sidx; //sidx 조별 인덱스
        if (typeof tabletype == "object") {
            tt = tabletype.TT; //넘겨야할 TT값 설정( 스코어 ,결과 , 운영 에서 같은 ajax api 를 사용하므로 이를 구분할 값이 필요함
            sidx = tabletype.SIDX;
        }
        else {
            tt = tabletype;
            sidx = 0;
        }

        //백버튼적용을 위해 검색내용 저장
        localStorage.setItem('searchinfo', [searchstr1, searchstr2, searchstr3, gameidx, tt, sidx]);
        mx.SendPacket('DP_tourney', { 'CMD': mx.CMD_GAMESEARCH, 'IDX': gameidx, 'S1': searchstr1, 'S2': searchstr2, 'S3': searchstr3, 'TT': tt, 'SIDX': sidx });
    }
};




$(document).ready(function () {



    console.log("ready");
    console.log(score.smenu);



    score.smenu = null;
    mx.CMD_TEAMCODERALLY = 18; 														//대회별 생성된 팀코드
    mx.CMD_GAMESEARCH = 20000;


    console.log("ready");
    console.log(score.smenu); 												//경기스코어 검색

    //로딩시 컨트롤 셋팅
    //--개인/단체    -- 종별   -- 부 

    //조회 버튼

    //전체 // 라이브스코어

    //대진표 그리기

    //리스트 그리기

    //팝업 클릭시 
    //스코어입력 정보 삭제
    localStorage.removeItem('COURTPLAYERS');
    localStorage.removeItem('FIRSTPLAYERS');
    localStorage.removeItem('REQ');
    //스코어입력 정보 삭제

    localStorage.setItem("GroupGameGb", $("#game-type").val());
     
    $("#tourney_title").html(localStorage.getItem("GameTitleName"));
    score.settingSearch();


});


score.drLevelList = function (targetid, TeamGb, lineall) {

    console.log("drLevelList");
    console.log(targetid);
    console.log( TeamGb);
    console.log(lineall);


    var obj = {};
    obj.SportsGb = "tennis"; //localStorage.getItem("SportsGb");
    obj.GIDX = localStorage.getItem("GameTitleIDX");
    obj.TeamGb = TeamGb;
    obj.CMD = mx.CMD_TEAMCODERALLY;
    obj.LNALL = lineall;
    mx.SendPacket(targetid, obj, "/pub/ajax/reqTennis.asp");
};


score.settingSearch = function () {
    score.smenu = localStorage.getItem('smenu'); //메뉴항목 가져오기



    console.log(1);
    console.log(score.smenu);

    if (score.smenu == "" || score.smenu == undefined) { //메뉴가 구성되지 않았다면
        score.drLevelList("#SexLevel", $("#TeamGb").val(), 'setmenu');

        console.log(2);
    }
    else {
        console.log(3);

        //메뉴다시그리고######################
        if (score.smenu.split(",")[0] == 0) {//단식부
            $("#TeamGb").children("option").remove();
            if (score.smenu.split(",")[1] > 0) {//개인복식
                $("#TeamGb").append("<option value='201' selected>복식</option>");
            }
        }
        else {
            var teamgbval = $("#TeamGb option:selected").val();
            $("#TeamGb").children("option").remove();

            if (teamgbval = "200") {
                $("#TeamGb").append("<option value='200' selected>단식</option>");
            }
            else {
                $("#TeamGb").append("<option value='200'>단식</option>");
            }

            if (score.smenu.split(",")[1] > 0) {//개인복식
                if (teamgbval = "200") {
                    $("#TeamGb").append("<option value='201' selected>복식</option>");
                }
                else {
                    $("#TeamGb").append("<option value='201'>복식</option>");
                }
            }
        }

        score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
        //메뉴다시그리고######################

        //스코어입력페이징에서 이전페이지버튼 눌렀을시.. 기존SELECT 선택된값 선택
        if (localStorage.getItem("BackPage") == "enter-score") {
            var selectinfo = localStorage.getItem('searchinfo').split(','); //조회 저장 정보

            $("input:radio[name='game-type']:input[value='" + selectinfo[0] + "']").attr("checked", true);
            $("#TeamGb option[value=" + selectinfo[1] + "]").attr('selected', 'selected');

            score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
            mx.SendPacket('DP_tourney', { 'CMD': mx.CMD_GAMESEARCH, 'IDX': selectinfo[3], 'S1': selectinfo[0], 'S2': selectinfo[1], 'S3': selectinfo[2], 'TT': selectinfo[4], 'SIDX': selectinfo[5] })
            localStorage.setItem('BackPage', 'rgamelist');
        }
        else if (localStorage.getItem("BackPage") == "enter-score-tourn") {

            var selectinfo = localStorage.getItem('searchinfo').split(','); //조회 저장 정보

            $("input:radio[name='game-type']:input[value='" + selectinfo[0] + "']").attr("checked", true);
            $("#TeamGb option[value=" + selectinfo[1] + "]").attr('selected', 'selected');

            score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
            mx.SendPacket('DP_tourney', { 'CMD': mx.CMD_GAMESEARCH, 'IDX': selectinfo[3], 'S1': selectinfo[0], 'S2': selectinfo[1], 'S3': selectinfo[2], 'TT': selectinfo[4], 'SIDX': selectinfo[5] })
            localStorage.setItem('BackPage', 'rgamelist');

        }
        else {
            localStorage.setItem("GroupGameGb", $('input:radio[name="game-type"]:checked').val());
            localStorage.setItem('BackPage', 'rgamelist');
            score.drLevelList("#SexLevel", $("#TeamGb").val(), 'no');
        }
    }
};
