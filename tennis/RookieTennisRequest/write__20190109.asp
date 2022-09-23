<!-- #include virtual = "/pub/header.RookieTennis.asp" -->
<!--#include file = "./include/config_top.asp" -->
    <!--#include file = "./include/config_bot.asp" -->

    <%
    Set db = new clsDBHelper

    ChekMode  = fInject(Request("ChekMode"))
    if  ChekMode = 0 then
        CMD= 300
    else
        CMD= 300
    end if

    ridx  = fInject(Request("ridx")) '참가신청 인덱스
    Years     = fInject(Request("Years"))
    Months     = fInject(Request("Months"))
    GameTitleIDX     = fInject(Request("GameTitleIDX"))
    IDX     = fInject(Request("IDX"))
    GameTitleName  = fInject(Request("GameTitleName"))
    TeamGb  = fInject(Request("TeamGb"))
    TeamGbNm  = fInject(Request("TeamGbNm"))
    levelno  = fInject(Request("levelno"))
    levelNm  = fInject(Request("levelNm"))
    EntryCntGame  = fInject(Request("EntryCntGame"))

    If GameTitleIDX = "" Then
        Response.redirect "./list.asp"
        Response.end
    End if


    ''대회 정보 검색
    %>

    <script src="/pub/js/rookietennis/tennis_Request.js<%=CONST_JSVER%>" type="text/javascript"></script>
    <script type="text/javascript">

    	var Now = new Date();
        var NowTime = Now.getFullYear();
        var m = Now.getMonth() + 1;
        if (m < 10) {
            NowTime += '-0' + m;
        } else {
            NowTime += '-' + m;
        }
        NowTime += '-' + Now.getDate();


        function chk_frm(val) {
            var sf = document.frm_in;
            if (val == 0) {
                chek_form_data(val);
                $(".refundform").css("display", "");

    				$("#FormDelete").css("display", "none");
                    $("#FormUpdate").css("display", "none");
                    if (!$("#attname").val()) { $("#attname").val($("#p1name").val()); }
                    if (!$("#attphone").val()) { $("#attphone").val($("#p1phone").val()); }
                    if (!$("#attphone1").val()) { $("#attphone1").val($("#p1phone1").val()); }
                    if (!$("#attphone2").val()) { $("#attphone2").val($("#p1phone2").val()); }
                    if (!$("#attphone3").val()) { $("#attphone3").val($("#p1phone3").val()); }
                    if (!$("#inbankname").val()) { $("#inbankname").val($("#p1name").val()); }
            }
            else if (val == 2) {            //수정
                chek_form_data(val);
                $("#FormDelete").css("display", "none");
                $("#FormUpdate").css("display", "");

                $(".refundform").css("display", "none");
            }
            else if (val == 1 ) {
                //삭제
                $("#aTcommit").click();
                $("#FormDelete").css("display","");
                $("#FormUpdate").css("display","none");

                $(".refundform").css("display", "");

            } else if (val == 10) {
                //대회목록
                sf.action = "./list.asp" + ver;
                sf.submit();
            } else if (val == 11) {
                //참가신청목록
                sf.action = "./list.asp" + ver;
                sf.submit();
            } else if (val == 12) {
                //참가신청목록
                sf.action = "./info_list.asp" + ver;
                sf.submit();
            } else if (val == 20) {
                //선수정보 수정 요청
                $("#aT_player_update").click();
                var obja = {};
                obja.CMD = mx_player.CMD_player_bbsEditor;
                obja.idx = bbsidx;
                obja.tidx = $("#GameTitleIDX").val();
                obja.levelno = $("#levelno").val();
                obja.ridx = $("#ridx").val();
                mx_player.SendPacket("Modal_ContentsList", obja, mx_player.ajaxURL);
            } else if (val == 21) {
                //선수정보 수정 저장
                var obja = {};
                obja.CMD = mx_player.CMD_player_bbsEditorOK;
                obja.idx = bbsidx;
                obja.tidx = $("#GameTitleIDX").val();
                obja.levelno = $("#levelno").val();
                obja.ridx = $("#ridx").val();
                obja.CONTENTS = $("#playeredit").val();
                mx_player.SendPacket("Modal_ContentsList", obja, mx_player.ajaxURL);
                $("#aT_player_update").click();
            } else if (val == 999) {
                //참가신청내역
                sf.action = "./info_list.asp" + ver;
                sf.submit();
            } else if (val == 888) {
                //참가신청 완료 후 확인창 이동
                sf.action = "./write_ok.asp" + ver;
                sf.submit();
            }


    		else if(val == 'lvl1' || val == 'lvl2'){ //레벨모달
    			var sf = document.frm_in;
    			if (sf.levelno.value == "") {
    				$("#levelno").focus();
    				alert("출전부서를 선택 해주시기 바랍니다."); return;
    			}

    			mx_player.targetlevelID = val;
    			if ( $("#levelno").val().substr(0,5) == "20101" || $("#levelno").val().substr(0,5) == "20104" ) {
    				//타이틀 변경
    	           	// $('#myModal_level').show();
                  $('#myModal_level').modal('show');
    			}
    			if (  $("#levelno").val().substr(0,5) == "20102" || $("#levelno").val().substr(0,5) == "20105") {
    				//타이틀 변경
    	            $("##lvlm2btn").click();
    			}
    		}

        }

         //case "1111": 실제 존재해서 풀었슴...
        function PhoneP(object) {
            var cheker = "N";
            switch (object.value) {
                case "1004":
                case "0001":
                case "1234":
                case "0000":
                    cheker = "Y";
                    break;

            }

            if (cheker == "Y") {
                alert("해당 번호  "+object.value+" 는 사용 할 수 없습니다.");
                object.value = "";
                maxLengthCheck(object);
            } else {
                var numPattern = /([^0-9])/;
                var numPattern = object.value.match(numPattern);
                if(numPattern != null){
                    alert("숫자만 입력해 주세요!");
                    object.value = "";
                    object.focus();
                }
            }
        }

        function maxLengthCheck(object) {
            if (object.value.length > object.maxLength) {
                object.value = object.value.slice(0, object.maxLength);
            }
            //번호 체크
            PhoneP(object);
            if (object.id.indexOf("p1phone") >= 0) {
                /*참가자 정보 1 */
                if (!$("#p1phone2").val() || !$("#p1phone3").val()) {
                    $("#p1phone").val("");
                } else {
                    $("#p1phone").val($("#p1phone1").val() + $("#p1phone2").val() + $("#p1phone3").val());
                    $("#attname").val($("#p1name").val());
                    $("#attphone").val($("#p1phone").val());
                    $("#attphone1").val($("#p1phone1").val());
                    $("#attphone2").val($("#p1phone2").val());
                    $("#attphone3").val($("#p1phone3").val());
                    $("#inbankname").val($("#p1name").val());
                }
            }
            if (object.id.indexOf("p2phone") >= 0) {
                /*참가자 정보 2  파트너*/
                if (!$("#p2phone2").val() || !$("#p2phone3").val()) {
                    $("#p2phone").val("");
                } else {
                    $("#p2phone").val($("#p2phone1").val() + $("#p2phone2").val() + $("#p2phone3").val());
                }
            }
            if (object.id.indexOf("attphone") >= 0) {
                /*신청자*/
                if (!$("#attphone2").val() || !$("#attphone3").val()) {
                    $("#attphone").val("");
                } else {
                    $("#attphone").val($("#attphone1").val() + $("#attphone2").val() + $("#attphone3").val());
                }
            }
        }

        function chek_form_data(val) {
            console.log("chek_form_data");
            var sf = document.frm_in;
            if (sf.levelno.value == "") {
                $("#levelno").focus();
                alert("출전부서를 선택 해주시기 바랍니다."); return;
            }

            if (sf.p1name.value != '' && sf.p2name.value != '' && sf.p1name.value == sf.p2name.value) {
                if (sf.p1phone.value != '' && sf.p2phone.value != '' && sf.p1phone.value == sf.p2phone.value) {
                    alert("참가자 와 파트너의 이름이 동일합니다."); return;
                }
            }
            if (sf.p1phone.value != '' && sf.p2phone.value != '' && sf.p1phone.value == sf.p2phone.value) {
                alert("참가자 와 파트너의 핸드폰 번호가 동일합니다."); return;
            }

            /*참가자 정보 1 */
            if (!frm_in.p1name.value) { alert("참가자 이름이 없습니다."); $("#p1name").focus(); return; }

            if (!frm_in.p1phone2.value || !frm_in.p1phone3.value) {
                alert("참가자 연락처가 없습니다.");
                $("#p1phone1").attr("disabled", false);
                $("#p1phone2").attr("disabled", false);
                $("#p1phone3").attr("disabled", false);
                if (!frm_in.p1phone2.value) { $("#p1phone2").focus(); return; }
                if (!frm_in.p1phone3.value) { $("#p1phone3").focus(); return; }
            }


    		//@@@@@@@@@@@@@@@@@@@@@@@
            if ($('#p1team1txt').val() == '' ) {
                alert("기본클럽명을 입력하여 주십시오."); return;
            }
            if ($('#sidogb1').val() == '' ) {
                alert("거주지역을 선택하여 주십시오."); return;
            }
            if ($('#googun1').val() == '' ) {
                alert("시군구를 선택해 주십시오."); return;
            }
            if ($('#goyear1').val() == '' ) {
                alert("테니스시작년도를 선택해주십시오."); return;
            }
            if ($('#gomonth1').val() == '' ) {
                alert("테니스시작월을 선택해주십시오."); return;
            }
            if ($('#lvl1').val() == '' ) {
                alert("테니스레벨을 선택해주십시오."); return;
            }
            if ($('#prize1').val() == '' ) {
                alert("참가상품을 선택해주십시오."); return;
            }
    		//@@@@@@@@@@@@@@@@@@@@@@@



            /*참가자 정보 2  파트너*/
    		if ($('#p2midx').val()  =='') {
                alert("파트너를 검색 후 선택하여 주십시오."); $("#p2name").focus(); return;
    		}
    		if (!frm_in.p2phone2.value || !frm_in.p2phone3.value) {
    			$("#p2phone1").attr("disabled", false);
    			$("#p2phone2").attr("disabled", false);
    			$("#p2phone3").attr("disabled", false);
    			alert("참가자 연락처가 없습니다.");
    			if (!frm_in.p2phone2.value) { $("#p2phone2").focus(); return; }
    			if (!frm_in.p2phone3.value) { $("#p2phone3").focus(); return; }
    		}

    		//@@@@@@@@@@@@@@@@@@@@@@@
            if ($('#p2team1txt').val() == '' ) {
                alert("기본클럽명을 입력하여 주십시오."); return;
            }
            if ($('#sidogb2').val() == '' ) {
                alert("거주지역을 선택하여 주십시오."); return;
            }
            if ($('#googun2').val() == '' ) {
                alert("시군구를 선택해 주십시오."); return;
            }
            if ($('#goyear2').val() == '' ) {
                alert("테니스시작년도를 선택해주십시오."); return;
            }
            if ($('#gomonth2').val() == '' ) {
                alert("테니스시작월을 선택해주십시오."); return;
            }
            if ($('#lvl2').val() == '' ) {
                alert("테니스레벨을 선택해주십시오."); return;
            }
            if ($('#prize2').val() == '' ) {
                alert("참가상품을 선택해주십시오."); return;
            }
    		//@@@@@@@@@@@@@@@@@@@@@@@


            $("#aTcommit").click();
        }

        function chek_form_pass_data(val) {
            console.log("chek_form_pass_data");
            var sf = document.frm_in;
            if (val != 1) {
                /*신청자*/
                if (!frm_in.attname.value) { alert("신청자 이름이 없습니다."); $("#attname").focus(); return; }
                if (!frm_in.attphone2.value || !frm_in.attphone3.value) { alert("신청자 연락처가 없습니다."); if (!frm_in.attphone2.value) { $("#attphone2").focus(); } else { $("#attphone3").focus(); } return; }

    			/*입금정보*/
                //if (!frm_in.inbankname.value) { alert("입금자 이름이 없습니다."); $("#inbankname").focus(); return; }
            }

            /* 비밀번호*/
            if (!frm_in.attpwd.value) { alert("비밀번호를 입력해주세요."); $("#attpwd").focus(); return; }

            if (val == 0) {
                savedata(val);
            } else {
                if (val == 2) {
                    if (confirm("참가신청 내용을 수정 하시겠습니까?")) {
                        CheckPwd(val);
                    }

                } else {
    			   if( $("#inbank").length > 0 ){
    	               if (!frm_in.inbankname.value) { alert("이름을 입력해 주십시오."); $("#inbankname").focus(); return; }
    				   if (!frm_in.inbank.value) { alert("은행명을 입력해 주십시오."); $("#inbank").focus(); return; }
    				   if (!frm_in.inbankacc.value) { alert("환불계좌를 입력해 주십시오."); $("#inbankacc").focus(); return; }
    			   }

    				if (confirm("참가신청 내용을 삭제 하시겠습니까? \n\n삭제된 신청내역은 복구 되지 않습니다.")) {
                        CheckPwd(val);
                    }
                }
            }
        }
        function CheckPwd(val) {
            console.log("CheckPwd");
            //비밀번호 체크 확인시 페이지 이동
            var obja = {};
            obja.CMD = mx_player.CMD_PLAYER_Pwd_ok;
            obja.IDX = $("#GameTitleIDX").val();
            obja.levelno = $("#levelno").val();
            obja.ridx = $("#ridx").val();
            obja.StrPwd = $("#attpwd").val();
            obja.action = val;
            mx_player.SendPacket("", obja, mx_player.ajaxURL);

        }
        function DataDelete() {
            console.log("DataDelete");

            var sf = document.frm_in;
            var obja = {};
            obja.CMD = mx_player.CMD_PLAYERDEL;
            obja.ridx = $("#ridx").val();
            obja.tidx = $("#GameTitleIDX").val();
            obja.levelno = $("#levelno").val();
            obja.key1 = "";
            obja.pidx = $("#p1idx").val();

    	   if( $("#inbank").length > 0 ){
    			obja.inbankname = $("#inbankname").val();
    			obja.inbank = $("#inbank").val();
    			obja.inbankacc = $("#inbankacc").val();
    	   }

    		mx_player.SendPacket("", obja, mx_player.ajaxURL);

        }

        function savedata(val) {
            console.log("savedata");
            var sf = document.frm_in;
            //저장 api
            var obja = {};
            if (val == 0) {
                obja.CMD = mx_player.CMD_PLAYERREG;
            } else {
                obja.CMD = mx_player.CMD_PLAYERUDATE;
            }

            obja.ridx = $("#ridx").val();
            obja.tidx = $("#GameTitleIDX").val();
            obja.teamgb = $("#TeamGb").val();
            obja.teamgbNm = $("#TeamGbNm").val();
            obja.levelno = $("#levelno").val();
            obja.levelNm = $("#levelNm").val();

            /*신청자*/
            obja.attname = frm_in.attname.value;


            if ($("#attphone").val() == "") {
                obja.attphone = $("#attphone1").val() + frm_in.attphone2.value + frm_in.attphone3.value;
            } else {
                obja.attphone = $("#attphone").val();
            }

            obja.attpwd = frm_in.attpwd.value;
            obja.attask = frm_in.attask.value; //건의

            /*환불 정보*/
            obja.inbankdate = NowTime;
            obja.inbankname = frm_in.inbankname.value;

            /*참가자 정보 1 */
            obja.p1idx = frm_in.p1idx.value;
            obja.p1name = frm_in.p1name.value;
            if (!frm_in.p1idx.value) {
                obja.p1phone = $("#p1phone1").val() + frm_in.p1phone2.value + frm_in.p1phone3.value;
            } else {
                obja.p1phone = $("#p1phone").val();
            }
            obja.p1team1 = frm_in.p1team1.value;
            obja.p1team1txt = frm_in.p1team1txt.value;
            obja.p1team2 = frm_in.p1team2.value;
            obja.p1team2txt = frm_in.p1team2txt.value;

            obja.p1grade = $('#lvl1').val(); //레벨
    		obja.sidogb1 = $('#sidogb1').val() + "_" + $('#sidogb1  option:selected').text(); //거주
            obja.googun1 = $('#googun1').val();
            obja.goyear1 = $('#goyear1').val(); //구력
            obja.gomonth1 = $('#gomonth1').val();
            obja.prize1 = $('#prize1').val(); //상품

            /*참가자 정보 2  파트너*/
    		obja.p2midx = $('#p2midx').val(); //회원번호
    		obja.p2idx = frm_in.p2idx.value;
            obja.p2name = frm_in.p2name.value;
            if (!frm_in.p2idx.value) {
                obja.p2phone = $("#p2phone1").val() + frm_in.p2phone2.value + frm_in.p2phone3.value;
            } else {
                obja.p2phone = $("#p2phone").val();
            }

            obja.p2team1 = frm_in.p2team1.value;
            obja.p2team1txt = frm_in.p2team1txt.value;
            obja.p2team2 = frm_in.p2team2.value;
            obja.p2team2txt = frm_in.p2team2txt.value;

            obja.p2grade = $('#lvl2').val(); //레벨
    		obja.sidogb2 = $('#sidogb2').val() + "_" + $('#sidogb2  option:selected').text(); //거주
    		obja.googun2 = $('#googun2').val();
            obja.goyear2 = $('#goyear2').val(); //구력
            obja.gomonth2 = $('#gomonth2').val();
            obja.prize2 = $('#prize2').val(); //상품

            if (!$("#ridx").val() && $("#ChekMode").val() == "0") {
                //저장  /pup/api/mobile/api.apply.asp
                mx_player.SendPacket("", obja, mx_player.ajaxURL);
            } else if ($("#ridx").val() && $("#ChekMode").val() == "1") {
                //수정  /pup/api/mobile/api.apply.asp
                mx_player.SendPacket("", obja, mx_player.ajaxURL);
            }
            else {
                console.log("저장실패");
            }
        }
    </script>

    <%
    if ridx <> "" and ChekMode=1 then
        SQL ="select EntryCntGame,cfg,SUBSTRING(cfg,2,1)Ch_i,SUBSTRING(cfg,3,1)Ch_u,SUBSTRING(cfg,4,1)Ch_d from tblRGameLevel where GameTitleIDX = '"&GameTitleIDX&"' and level='"&levelno&"' and  delYN='N' "
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
        If Not rs.EOF Then
            cfg = Rs("cfg")
            Ch_i = Rs("Ch_i")
            Ch_u = Rs("Ch_u")
            Ch_d = Rs("Ch_d")
        End if
    End if

    If levelno = "" Then
    	acctotal = 0
    else
    		SQL = " select b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame "
    		SQL = SQL &" ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt ,b.cfg, max(b.fee) as fee, max(b.fund) as fund "
    		SQL = SQL &" ,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d , d.lmsSendChk ,count(s.gameMemberIDX) MemberCnt"
    		SQL = SQL &"  from tblRGameLevel b  "
    		SQL = SQL &"  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "
    		SQL = SQL &"  inner join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' and d.RequestIDX= "&ridx
    		SQL = SQL &"  left JOIN sd_TennisMember s on d.GameTitleIDX = s.GameTitleIDX and d.Level = s.gamekey3 and s.DelYN='N' and d.P1_PlayerIDX= s.PlayerIDX and isnull(Round,0)=0"
    		SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&GameTitleIDX&"' and c.LevelNm not like '%최종%'  "
    		SQL = SQL &"  and  c.Level='"&levelno&"'"
    		SQL = SQL &"  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,b.cfg,   d.lmsSendChk "
    		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    		If Not rs.EOF Then
    			MemberCnt = rs("MemberCnt")
    			fee = rs("fee")
    			fund = rs("fund")
    			acctotal = CDbl(fee) + CDbl(fund)
    		End if
    End if

    If acctotal > 0 then
    	SQL = "Select VACCT_NO from TB_RVAS_MAST where CUST_CD = '" & ridx & "' "
    	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    	If Not rs.eof Then
    		acct = rs(0)
    	End If

    	'입금완료여부확인
    	SQL = "Select VACCT_NO from TB_RVAS_LIST where CUST_CD = '" & ridx & "' and STAT_CD = '0' and ERP_PROC_YN = 'N' " '현장입금 체크가 아니라면
    	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    	If Not rs.eof Then
    		vaccno = rs(0)
    		payok = "ok"
    	Else
    		vaccno = 0
    	End If
    End if


    '대회정보##############################
    SQL = " select top 1 GameTitleName,convert(date,GameS)GameS,convert(date,GameE)GameE,titleGrade,gameprize from sd_TennisTitle  where DelYN='N' and GameTitleIDX= '"&GameTitleIDX&"' "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    If Not Rs.Eof Then
    	gamegrade = findGrade(rs("titleGrade"))
    	gamegrade = gamegrade '&"그룹"
    	GameTitleName=rs("GameTitleName")
    	gameprize = rs("gameprize")
    end if

    '출전부서##############################
    SQL = " select b.GameType, b.TeamGb,case left(b.cfg,1) when 'Y' then b.TeamGbNm +'(B)' else b.TeamGbNm end  TeamGbNm,c.Level,c.LevelNm "
    SQL = SQL &"  ,case when isnull(c.LevelNm,'')='' then '' when c.LevelNm='없음' then '' else c.LevelNm end LevelNm "
    SQL = SQL &"  ,GameDay,GameTime,EntryCntGame"
    SQL = SQL &" ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt ,b.cfg"
    SQL = SQL &" ,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d"
    SQL = SQL &"  from tblRGameLevel b  "
    SQL = SQL &"  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "
    SQL = SQL &"  left join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' "
    SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&GameTitleIDX&"' and c.LevelNm not like '%최종%'  "
    if levelno <>"" and ridx <>"" then
    SQL = SQL &"  and  c.Level='"&levelno&"'"
    end if
    SQL = SQL &"  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,b.cfg  "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.EOF Then
    	arrA = rs.GetRows()
    End if

    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    'Call rsdrow(rs)

    '참가신청정보############################
    if ridx <>"" and  ChekMode = 1 then
    	SQL=""
    	SQL = SQL&"  select RequestIDX,SportsGb,GameTitleIDX,Level,EnterType,UserPass,UserName,isnull(UserPhone,'')UserPhone,txtMemo,PaymentDt,PaymentNm "
    	SQL = SQL&" ,P1_PlayerIDX,P1_UserName,P1_Team,P1_TeamNm,P1_Team2,P1_TeamNm2,isnull(P1_UserPhone,'') P1_UserPhone, P1_prizekey ,P2_PlayerIDX,P2_UserName,P2_Team,P2_TeamNm,P2_Team2,P2_TeamNm2,isnull(P2_UserPhone,'') P2_UserPhone,P2_prizekey "
    	SQL = SQL&"  from tblGameRequest as a "
    	SQL = SQL&"  where RequestIDX='"&ridx&"'  and DelYN = 'N' "
    	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    	If Not(Rs.Eof Or Rs.Bof) Then
    		'p1boo = rs("p1boo")
    		'p2boo = rs("p2boo")

    		UserName =Rs("UserName")
    		UserPhone =Rs("UserPhone")
    		txtMemo =Rs("txtMemo")
    		PaymentDt =Rs("PaymentDt")
    		PaymentNm =Rs("PaymentNm")
    		UserPass =Rs("UserPass")

    		UserPhone = replace(UserPhone,"-","")
    		UserPhone1 = left(UserPhone,3)
    		if len(UserPhone)>=11 then
    			UserPhone2 = mid(UserPhone,4,4)
    			UserPhone3 = right(UserPhone,4)
    		else
    			UserPhone2 = mid(UserPhone,4,3)
    			UserPhone3 = right(UserPhone,4)
    		end if

    		P1_PlayerIDX =Rs("P1_PlayerIDX")
    		P1_UserName =Rs("P1_UserName")
    		P1_Team =Rs("P1_Team")
    		P1_TeamNm =Rs("P1_TeamNm")
    		P1_Team2 =Rs("P1_Team2")
    		P1_TeamNm2 =Rs("P1_TeamNm2")
    		P1_UserPhone = replace(Rs("P1_UserPhone"),"-","")
    		P1_UserPhone1 = left(P1_UserPhone,3)

    		if len(P1_UserPhone)>=11 then
    			P1_UserPhone2 = mid(P1_UserPhone,4,4)
    			P1_UserPhone3 = right(P1_UserPhone,4)
    		else
    			P1_UserPhone2 = mid(P1_UserPhone,4,3)
    			P1_UserPhone3 = right(P1_UserPhone,4)
    		end If

    		P1_sex  = strSex(Cookies_sdSex)
    		P1_b = Cookies_sdBth

    		P1_prize = rs("P1_prizekey")
    		P2_prize = rs("P2_prizekey")


    		P2_PlayerIDX =Rs("P2_PlayerIDX")
    		P2_UserName =Rs("P2_UserName")
    		P2_Team =Rs("P2_Team")
    		P2_TeamNm =Rs("P2_TeamNm")
    		P2_Team2 =Rs("P2_Team2")
    		P2_TeamNm2 =Rs("P2_TeamNm2")
    		P2_UserPhone = replace(Rs("P2_UserPhone"),"-","")
    		P2_UserPhone1 = left(P2_UserPhone,3)

    		if len(P2_UserPhone)>=11 then
    			P2_UserPhone2 = mid(P2_UserPhone,4,4)
    			P2_UserPhone3 = right(P2_UserPhone,4)
    		else
    			P2_UserPhone2 = mid(P2_UserPhone,4,3)
    			P2_UserPhone3 = right(P2_UserPhone,4)
    		end If

    		'2팀 추가정보
    		SQL = "Select memberIDx,birthday,sex,sidogu,gamestartyymm,userLevel from tblPlayer where playerIDX = " &  P2_PlayerIDX
    		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    		P2_memberidx  = rs("memberIDx")
    		P2_sex  =  strSex(rs("sex"))
    		P2_b = rs("birthday")
    		P2_sidogu = rs("sidogu")
    		P2_gamestartyymm = rs("gamestartyymm")
    		P2_userLevel = rs("userLevel")


    	end if
    Else

    		'가장최근 참가신청 검색해서 정보 가져옴

    		'없다면
    		UserName =Cookies_sdNm

    		userPnoarr = phonesplit(Cookies_sdPhone)
    		UserPhone1 = userPnoarr(0)
    		UserPhone2 = userPnoarr(1)
    		UserPhone3 = userPnoarr(2)
    		UserPhone = userPnoarr(3) ' - 뺀 전체


    		P1_PlayerIDX = Cookies_pidx
    		P1_UserName =UserName

    		P1_UserPhone = UserPhone
    		P1_UserPhone1 = UserPhone1
    		P1_UserPhone2 = UserPhone2
    		P1_UserPhone3 = UserPhone3

    		P1_sex  = strSex(Cookies_sdSex)
    		P1_b = Cookies_sdBth

    		P1_Team =Cookies_t1code
    		P1_TeamNm =Cookies_t1name
    		P1_Team2 =Cookies_t2code
    		P1_TeamNm2 = Cookies_t2name
    end if


    '사은품##############################
    SQL = "Select name,sex,size,idx from sd_gamePrize where gubun = 3  and delYN = 'N' and name = '"&gameprize&"' order by sex "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If Not rs.EOF Then
    	arrG = rs.GetRows()
    End if

    '시도 정보############################
    SQL = "Select sido,sidonm from tblSidoInfo where delYN = 'N' "
    Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

    If Not rs.EOF Then
    	arrSD = rs.GetRows()
    End If

    If P2_sidogu <> "" then
    	SQL = "Select GuGunNm from tblGugunInfo where delYN = 'N' and Sido = (select top 1 sido from tblSidoInfo where Sido = '"&Split(P2_sidogu,"_")(0)&"' )"
    	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
    	If Not rs.EOF Then
    		arrGG = rs.GetRows()
    	End If
    End if


    %>
<body id="AppBody">
    <!-- S: sub-header -->
    <div class="sd-header sd-header-sub">
        <!-- #include file="./include/sub_header_arrow.asp" -->
        <h1>참가신청서 작성</h1>
        <!-- #include file="./include/sub_header_right.asp" -->
    </div>
    <!-- E: sub-header -->

    <!-- S: main -->
    <button id="aT_player_update" class="green_btn" data-toggle="modal" data-target="#myModal_game" style="display:none;"></button>
    <button id="aTcommit_game" class="green_btn" data-toggle="modal" data-target="#myModal_game" style="display:none;">모집요강</button>
    <button id="aTcommit" class="green_btn" data-toggle="modal" data-target="#myModal" style=" display:none;">신청완료</button>

    <form method="post" name="frm_in" id="frm_in">
        <input  type="hidden" name="Years" id="Years" value="<%=Years %>"/>
        <input  type="hidden" name="Months" id="Months" value="<%=Months %>"/>
        <input  type="hidden" name="ChekMode" id="ChekMode" value="<%=ChekMode %>"/>
        <input  type="hidden" name="CMD" id="CMD" value="<%=CMD %>"/>
        <input  type="hidden" name="ridx" id="ridx" value="<%=ridx %>"/>
        <input  type="hidden" name="TitleIDX" id="TitleIDX" value="<%=GameTitleIDX %>"/>
        <input  type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX %>"/>
        <input  type="hidden" name="GameTitleName" id="GameTitleName" value="<%=GameTitleName %>"/>
        <input  type="hidden"  name="TeamGb" id="TeamGb" value="<%=TeamGb %>"/>
        <input  type="hidden"  name="TeamGbNm" id="TeamGbNm" value="<%=TeamGbNm %>"/>
        <input  type="hidden"  name="levelNm"  id="levelNm"value="<%=levelNm %>"/>
        <input  type="hidden"  name="Fnd_Kw"  id="Fnd_Kw"value=""/>

        <!-- <h1 class="page_title">
            <a href="javascript:chk_frm(11);" class="" >
                <i class="fa fa-angle-left" aria-hidden="true"></i>
            </a>
            <span class="name">참가신청서 작성</span>
        </h1> -->



        <div class="l_apply application">

            <div class="sd_subTit s_blue02">
                <h3 class="sd_subTit__tit">[<%=gamegrade%>] <%=GameTitleName %></h3>
            </div>

            <!-- <div class="deposit_info"><span class="big_title">[<%=gamegrade%>] <%=GameTitleName %></span></div> -->

            <div class="notice">
                <p class="notice__txt s_empahsis"><i class="fa fa-exclamation-circle" aria-hidden="true"></i><span>조회된 이름은 있으나 새로운 클럽으로 출전을 희망하는 선수는  '선수정보 변경요청' 버튼을 클릭 후 수정사항을 적어주세요.</span></p>
                <p class="notice__txt"><i class="fa fa-exclamation-circle" aria-hidden="true"></i><span>입력하신 참가자(파트너 포함) 휴대폰 번호를 통해 참가선수 본인 확인 절차가 진행됩니다. </span></p>
            </div>

        	<%If CDbl(acctotal) > 0 Then '금액이 0이상인 경우만%>
        		<%if Cdbl(MemberCnt)> 0 then %>
        		<div class="noticeDeposit">
        			<p class="noticeDeposit__txt">
        				<span class="noticeDeposit__lable">가상계좌 번호</span>
        				<span><%=acct%> KEB하나은행</span>
        			</p>
        			<p class="noticeDeposit__txt">
        				<span class="noticeDeposit__lable">참가비 금액</span>
        				<span><%=acctotal%>원</span>
                        <%If payok="ok" then%><span class="noticeDeposit__emphasis">입금완료</span><%End if%>
        			</p>
        		</div>
        		<%End if%>
        	<%End if%>

            <div class="t_horizon t_mg15"></div>

            <!-- s: 참가자 정보 & 파트너 정보 -->
            <div class="participant_info">
                <dl>
                    <dd>
                        <div class="info_list">
                        <ul>
                                <li>
                                    <span class="l_name">출전부서</span>
                                    <span class="r_con">

        								<%
        								'Call getrowsdrow(arra)
        								%>

        								<select class="ipt select_1" id="levelno" name="levelno">
            								<option value="">::부서를 선택하세요::</option>
        									<%
        									If IsArray(arrA) Then
        										For ar = LBound(arrA, 2) To UBound(arrA, 2)
        											gamelevel = arrA(3, ar)
        											gamelevelnm = arrA(2,ar)
        											gamearea = arrA(4,ar)
        											gamercnt = arrA(9,ar)
        											gameentrycnt = arrA(8,ar)
        											gameCh_i = arrA(11,ar)
                                                    if ChekMode = 0 and ridx ="" then
        												if gameCh_i ="Y" then
        													%><option value="<%=gamelevel%>" <%If levelno = gamelevel then%>selected<%End if%>><%=gamelevelnm%><%if gamearea <>"" then  %>(<%=gamearea%>)<%end if%> <%=gamercnt%>/<%=gameentrycnt%></option><%
        												End if
        											Else
        												%><option value="<%=gamelevel%>" <%If levelno = gamelevel then%>selected<%End if%>><%=gamelevelnm%><%if gamearea <>"" then  %>(<%=gamearea%>)<%end if%> <%=gamercnt%>/<%=gameentrycnt%></option><%
        											End if
        										Next

        									End if
        									%>
                                        </select>
                                    </span>
                                </li>
                        </ul>
                        </div>
                    </dd>
                </dl>

                <dl id="ContentsList">

        			<!-- s: 참가자정보  ---------------------------------------------------------------------------------------------------------------------->
                    <dd>
                        <p class="c_title">참가자 정보</p>
                        <div class="info_list">
                            <ul>
                                <li>
                                    <span class="l_name">이 름</span>
                                    <span class="r_con">
        								<input  type="hidden"  name="p1idx" id="p1idx" value="<%=P1_PlayerIDX %>"/>
        								<input type="text" class="ipt input_1" id="p1name" name="p1name" value="<%=P1_UserName %>"  readonly/>
        								<ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-user" ></ul>
                                    </span>
                                </li>
                                <li>
                                    <span class="l_name">휴대폰번호</span>
                                    <span class="r_con">
                                        <input  type="hidden"  name="p1phone" id="p1phone" value="<%=P1_UserPhone %>"/>
                                        <select class="ipt col_1" id="p1phone1" name="p1phone1"  disabled>
                                            <option value="010" <%if P1_UserPhone1 ="010" then %> selected<%end if %> >010</option>
                                            <option value="011" <%if P1_UserPhone1 ="011" then %> selected<%end if %> >011</option>
                                            <option value="016" <%if P1_UserPhone1 ="016" then %> selected<%end if %> >016</option>
                                            <option value="017" <%if P1_UserPhone1 ="017" then %> selected<%end if %> >017</option>
                                            <option value="018" <%if P1_UserPhone1 ="018" then %> selected<%end if %> >018</option>
                                            <option value="019" <%if P1_UserPhone1 ="019" then %> selected<%end if %> >019</option>
                                        </select>
                                        <span class="divn">-</span>
                                        <input type="password" class="ipt col_1" id="p1phone2" name="p1phone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);"onfocus="this.select()" autocomplete="off" value="<%=P1_UserPhone2 %>" disabled/>
                                        <span class="divn">-</span>
                                        <input type="number" class="ipt col_1" id="p1phone3" name="p1phone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off" value="<%=P1_UserPhone3 %>" disabled
        								onblur = "mx_player.ChkPhoneNum('p1phone1','p1phone2','p1phone3')" />
                                    </span>
                                </li>
                                <li>
                                    <span class="l_name">생일/성별</span>
                                    <span class="r_con" id="p1b">
        							<%=p1_b %>&nbsp;&nbsp;&nbsp;[<%=P1_sex %>]
                                    </span>
                                </li>
                                <li>
                                    <span class="l_name">기본클럽</span>
                                    <span class="r_con">
                                        <input  type="hidden"  name="p1team1" id="p1team1" value="<%=P1_Team%>"/>
                                        <input type="text" class="ipt input_1" id="p1team1txt" name="p1team1txt"  placeholder=":: 기본소속명을 입력(1개 클럽) ::"
                                         onkeyup="fnkeyup(this);" autocomplete="off" value="<%=P1_TeamNm %>" <%If P1_Team <> "" then%>disabled<%End if%>/>
                                        <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-team" ></ul>
                                    </span>
                                </li>
                                <li>
                                    <span class="l_name">기타클럽</span>
                                    <span class="r_con">
                                        <input  type="hidden"  name="p1team2" id="p1team2" value="<%=P1_Team2 %>"/>
                                        <input type="text" class="ipt input_1" id="p1team2txt" name="p1team2txt"  placeholder=":: 기타소속명을 입력(1개 클럽) ::" onkeyup="fnkeyup(this);"  autocomplete="off" value="<%=P1_TeamNm2 %>"  <%If P1_Team2 <> "" then%>disabled<%End if%>/>
                                    </span>
                                </li>

        						<li>
            						<span class="l_name">거주지역</span>
            						<span class="r_con" id="sidogb1span">
            							<%sdno = 1%>
            							<!-- #include virtual = "/pub/html/rookieTennisAdmin/common/html.sido.asp" -->
            						</span>
        						</li>


        						<li>
            						<span class="l_name">테니스구력</span>
            						<span class="r_con">
            							<select  id="goyear1" <%If Cookies_gamestartyymm <> "" then%>disabled<%End if%>>
            								<option value="">=년=</option>
            								<%For y = year(date) To CDbl(year(date)) -10 Step -1 %>
            									<option value="<%=y%>"  <%If Left(Cookies_gamestartyymm,4) = CStr(y) then%>selected<%End if%>><%=y%></option>
            								<%next%>
            							</select>

            							<select  id="gomonth1"  <%If Cookies_gamestartyymm <> "" then%>disabled<%End if%>>
            								<option value="">=월=</option>
            								<%For m = 1 To 12%>
            									<option value="<%=m%>" <%If right(Cookies_gamestartyymm,2) = addZero(m) then%>selected<%End if%>><%=addZero(m)%></option>
            								<%next%>
            							</select>
            						 <br> ※ 구력은 자동으로 갱신되며 수정은 불가합니다. 테니스 시작한 정보를 정확하게 입력해주세요.
            						</span>


        						</li>

        						<li>
        							<span class="l_name">테니스레벨</span>
        							<span class="r_con">
        								<%If Cookies_playerlevel = "" then%>
        								<input id="lvl1" type="text"  disabled onclick="chk_frm('lvl1')">
        								<button id="lvlm1" class="green_btn" type="button" onclick="chk_frm('lvl1')" >레벨선택</button>
        								<%else%>
        								<input id="lvl1" type="text" value="<%=Cookies_playerlevel%>" disabled>
        								<%End if%>
        							</span>
        						</li>

        						<%If IsArray(arrG) Then%>
        						<li>
        							<span class="l_name">참가상품</span>
        							<span class="r_con" id = "gameprize">
        									<select  id="prize1" class="ipt select_1" >
        										<option value="">=참가상품=</option>
        										<%
        											For ar = LBound(arrG, 2) To UBound(arrG, 2)
        												gnm = arrG(0, ar)
        												gsex = arrG(1, ar)
        													If gsex = "1" Then
        															gsex = "남"
        													Else
        															gsex = "여"
        													End if
        												gsize = arrG(2, ar)
        												gpidx = arrG(3, ar)
        												%><option value="<%=gpidx%>" <%If CStr(gpidx) = P1_prize then%>selected<%End if%>><%=gnm%>&nbsp;[<%=gsex%>]&nbsp;<%=gsize%></option><%
        											i = i + 1
        											Next
        										%>
        									</select>

        							</span>
        						</li>
        						<%End if%>



                            </ul>
                        </div>
                    </dd>
                    <!-- e: 참가자정보 ---------------------------------------------------------------------------------------------------------------------->




                    <!-- s: 파트너정보  ---------------------------------------------------------------------------------------------------------------------->
                    <dd>
                        <p class="c_title">파트너 정보</p>
                        <div class="info_list">
                            <ul>
                                <li>
                                    <span class="l_name">이 름</span>
                                    <span class="r_con">

        								<input  type="hidden"  name="p2midx" id="p2midx" value="<%=P2_MemberIDX %>"/>
        								<input  type="hidden"  name="p2idx" id="p2idx" value="<%=P2_PlayerIDX %>"/>
                                        <input type="text" class="ipt input_1" id="p2name" name="p2name" autocomplete="off" placeholder=":: 이름을 입력하세요 ::"  onkeyup="fnkeyup(this);"    value="<%=P2_UserName %>"/>
                                    </span>
                                </li>
                                <li>
                                    <span class="l_name">생일/성별</span>
                                    <span class="r_con" id="p2b">
        							<%=p2_b %>&nbsp;&nbsp;&nbsp;[<%=P2_sex %>]
        							</span>
                                </li>

                                <li>
                                    <span class="l_name">휴대폰번호</span>
                                    <span class="r_con">
                                        <input  type="hidden"  name="p2phone" id="p2phone" value="<%=P2_UserPhone %>"/>
                                        <select class="ipt col_1" id="p2phone1" name="p2phone1" disabled/>
                                            <option value="010" <%if P2_UserPhone1 ="010" then %> selected<%end if %> >010</option>
                                            <option value="011" <%if P2_UserPhone1 ="011" then %> selected<%end if %> >011</option>
                                            <option value="016" <%if P2_UserPhone1 ="016" then %> selected<%end if %> >016</option>
                                            <option value="017" <%if P2_UserPhone1 ="017" then %> selected<%end if %> >017</option>
                                            <option value="018" <%if P2_UserPhone1 ="018" then %> selected<%end if %> >018</option>
                                            <option value="019" <%if P2_UserPhone1 ="019" then %> selected<%end if %> >019</option>
                                        </select>
                                        <span class="divn">-</span>
                                        <input type="password" class="ipt col_1" id="p2phone2" name="p2phone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off"value="<%=P2_UserPhone2 %>" disabled/>
                                        <span class="divn">-</span>
                                        <input type="number" class="ipt col_1" id="p2phone3" name="p2phone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off"value="<%=P2_UserPhone3 %>" disabled
        								onchange = "mx_player.ChkPhoneNum('p2phone1','p2phone2','p2phone3')" />
                                    </span>
                                </li>


        						<li>
                                    <span class="l_name">기본클럽</span>
                                    <span class="r_con">
                                        <input  type="hidden"  name="p2team1" id="p2team1" value="<%=P2_Team %>"/>
                                        <input type="text" class="ipt input_1" id="p2team1txt" name="p2team1txt"  placeholder=":: 기본소속명을 입력(1개 클럽) ::" onkeyup="fnkeyup(this);"  autocomplete="off"  value="<%=P2_TeamNm %>" <%If P2_Team <> "" then%>disabled<%End if%>/>
                                    </span>
                                </li>
                                <li>
                                    <span class="l_name">기타클럽</span>
                                    <span class="r_con">
                                        <input  type="hidden"  name="p2team2" id="p2team2" value="<%=P2_Team2 %>"/>
                                        <input type="text" class="ipt input_1" id="p2team2txt" name="p2team2txt"  placeholder=":: 기타소속명을 입력(1개 클럽) ::" onkeyup="fnkeyup(this);"  autocomplete="off"  value="<%=P2_TeamNm2 %>" <%If P2_Team2 <> "" then%>disabled<%End if%>/>
                                    </span>
                                </li>


        						<li>
        						<span class="l_name">거주지역</span>
        						<span class="r_con" id="sidogb2span">
        							<%sdno = 2%>
        							<!-- #include virtual = "/pub/html/rookieTennisAdmin/common/html.sido.asp" -->
        						</span>
        						</li>

        						<li>
        						<span class="l_name">테니스구력</span>
        						<span class="r_con"  id="gym2">

        							<%If P2_sidogu <> "" then%>
        								<select  id="goyear2" disabled>
        									<option value="">=년=</option>
        									<%For y = year(date) To CDbl(year(date)) -10 Step -1 %>
        										<option value="<%=y%>" <%If CStr(y) = Left(P2_gamestartyymm,4) then%>selected<%End if%>><%=y%></option>
        									<%next%>
        								</select>
        								<select  id="gomonth2" disabled>
        									<option value="">=월=</option>
        									<%For m = 1 To 12%>
        										<option value="<%=m%>" <%If addZero(m) = right(P2_gamestartyymm,2) then%>selected<%End if%>><%=addZero(m)%></option>
        									<%next%>
        								</select>
        								<br> ※ 구력은 자동으로 갱신되며 수정은 불가합니다. 테니스 시작한 정보를 정확하게 입력해주세요.
        							<%else%>
        								<select  id="goyear2">
        									<option value="">=년=</option>
        									<%For y = year(date) To CDbl(year(date)) -10 Step -1 %>
        										<option value="<%=y%>"><%=y%></option>
        									<%next%>
        								</select>
        								<select  id="gomonth2">
        									<option value="">=월=</option>
        									<%For m = 1 To 12%>
        										<option value="<%=m%>"><%=m%></option>
        									<%next%>
        								</select>
        								<br> ※ 구력은 자동으로 갱신되며 수정은 불가합니다. 테니스 시작한 정보를 정확하게 입력해주세요.
        							<%End if%>
        						</span>
        						</li>

        						<li>
        							<span class="l_name">테니스레벨</span>
        							<span class="r_con">
        								<%If P2_userLevel = "" then%>
        								<input id="lvl2" type="text"  disabled onclick="chk_frm('lvl2')">
        								<button id="lvlm2" class="green_btn" type="button" onclick="chk_frm('lvl2')" >레벨선택</button>
        								<%else%>
        								<input id="lvl2" type="text" value="<%=P2_userLevel%>" disabled>
        								<button id="lvlm2" class="green_btn" type="button" onclick="chk_frm('lvl2')" style="display:none;">레벨선택</button>
        								<%End if%>
        							</span>
        						</li>

        						<%If IsArray(arrG) Then%>
        						<li>
        							<span class="l_name">참가상품</span>
        							<span class="r_con" id = "gameprize">
        									<select  id="prize2" class="ipt select_1" >
        										<option value="">=참가상품=</option>
        										<%
        											For ar = LBound(arrG, 2) To UBound(arrG, 2)
        												gnm = arrG(0, ar)
        												gsex = arrG(1, ar)
        													If gsex = "1" Then
        															gsex = "남"
        													Else
        															gsex = "여"
        													End if
        												gsize = arrG(2, ar)
        												gpidx = arrG(3, ar)
        												%><option value="<%=gpidx%>" <%If CStr(gpidx) = P2_prize then%>selected<%End if%>><%=gnm%>&nbsp;[<%=gsex%>]&nbsp;<%=gsize%></option><%
        											i = i + 1
        											Next
        										%>
        									</select>

        							</span>
        						</li>
        						<%End if%>

        					</ul>
                        </div>
                    </dd>
                    <!-- e: 파트너정보  ---------------------------------------------------------------------------------------------------------------------->


                </dl>
            </div>

            <!-- e: 참가자 정보 & 파트너 정보 -->
            <!-- s: 버튼 리스트 -->
            <% if ChekMode = 0 then  %>
            <div class="btn_list" style="text-align:right;text-align:right;">
                <a href="javascript:chk_frm('20');" class="red_btn">선수정보 수정 요청</a>
                <a href="javascript:chk_frm('0');"  class="big_btn green_btn"  >신청완료</a>
            </div>
            <!-- s: 버튼리스트 -->
            <%else %>
            <!-- s: 버튼 리스트 -->
            <div class="s_btn_list">
                <a href="javascript:chk_frm('20');" class="red_btn">선수정보 수정 요청</a>
                <a href="javascript:chk_frm('12');" class="black_btn">참가신청내역</a>
                <a  <% if Ch_u ="Y" then  %> href="javascript:chk_frm('1');" <% else  %> href="javascript:alert('참가신청 취소는 마감 되었습니다.');"<% end if  %> class="yello_btn" >신청삭제</a>
                <a <% if Ch_d ="Y" then  %> href="javascript:chk_frm('2');" <% else  %> href="javascript:alert('참가신청 수정이 마감 되었습니다.');" <% end if  %>class="green_btn">수정하기</a>
            </div>
            <%end if  %>
            <!-- s: 버튼리스트 -->
            <!-- s: 대회 참가신청 절차 -->
            <div class="apply_step">
                <h3 class="tit">대회 참가신청 절차</h3>
                <p>
                    <img src="imgs/write/step_img.png" alt="" />
                </p>
            </div>
            <!-- e: 대회 참가신청 절차 -->

        </div>

        <div class="modal fade write_moal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title">대회신청 정보</h4>
                    </div>
                    <div class="modal-body">
                        <!-- s: 대회참가비 입금정보 -->
                        <div class="deposit_info">
                            <ul>
                                <li class="reqer">
                                    <span class="l_name">신청자 이름</span>
                                    <span class="r_con">
                                        <input type="text" class="ipt input_1 ui-autocomplete-input" id="attname" name="attname" placeholder=":: 이름을 입력하세요 ::"  autocomplete="off" value="<%=UserName %>"
                                          readonly>
                                    </span>
                                </li>
                                <li>
                                    <span class="l_name">휴대폰 번호</span>
                                    <span class="r_con">
                                        <input  type="hidden"  name="attphone" id="attphone" value="<%=UserPhone %>"/>
                                        <select class="ipt col_1" id="attphone1" name="attphone1" readonly>
                                            <option value="010" <%if UserPhone1 ="010" then %> selected<%end if %> >010</option>
                                            <option value="011" <%if UserPhone1 ="011" then %> selected<%end if %> >011</option>
                                            <option value="016" <%if UserPhone1 ="016" then %> selected<%end if %> >016</option>
                                            <option value="017" <%if UserPhone1 ="017" then %> selected<%end if %> >017</option>
                                            <option value="018" <%if UserPhone1 ="018" then %> selected<%end if %> >018</option>
                                            <option value="019" <%if UserPhone1 ="019" then %> selected<%end if %> >019</option>
                                        </select>
                                        <span class="divn">-</span>
                                        <input type="password" class="ipt col_1 phone_line" id="attphone2" name="attphone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);" value="<%=UserPhone2 %>" readonly>
                                        <span class="divn">-</span>
                                        <input type="number" class="ipt col_1 phone_line" id="attphone3" name="attphone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" value="<%=UserPhone3 %>"  readonly>
                                    </span>
                                </li>


        	<%If payok = "ok" then%>
        						<li class="refundform">
                                <div class="text_box">
                                    <p class="red_font"><i class="fa fa-exclamation-circle" aria-hidden="true"></i>
                                        <span>환불 할 계좌 정보를 입력해 주십시오. </span>
                                    </p>
                                </div>
                                </li>
        						<li  class="refundform">
                                    <span class="l_name">환불정보</span>
                                    <span class="r_con">
                                        <input type="text" class="ipt input_1" style="width:48%;" id="inbankname" name="inbankname" value=""  onkeyup="fnkeyup(this);" maxlength="10"   placeholder=":: 이름 ::"  autocomplete="off">
                                        <input type="text" class="ipt input_1" style="width:50%;" id="inbank" name="inbank" value=""  onkeyup="fnkeyup(this);"   placeholder=":: 은행 ::"  maxlength="8" autocomplete="off">
                                    </span>
        						</li>
        						<li  class="refundform">
        							<span class="l_name">환불계좌</span>
        							<span class="r_con">
                                        <input type="text" class="ipt input_1" id="inbankacc" name="inbankacc" value=""  onkeyup="fnkeyup(this);"   placeholder=":: 계좌 ::" maxlength="20"  autocomplete="off">
                                    </span>
                                </li>

        	<%else%>
        						<li>
                                <div class="text_box">
                                    <p class="red_font"><i class="fa fa-exclamation-circle" aria-hidden="true"></i>
                                        <span>입금자명을 통해 입금 확인 절차가 진행됩니다. </span>
                                    </p>
                                </div>
                                </li>
                                <li>
                                    <span class="l_name">입금자명</span>
                                    <span class="r_con">
                                        <input type="text" class="ipt input_1" id="inbankname" name="inbankname" value="<%=PaymentNm %>"  onkeyup="fnkeyup(this);"   placeholder=":: 이름을 입력하세요 ::"  autocomplete="off">
                                    </span>
                                </li>
        	<%End if%>



                            </ul>
                            <!-- s: 기타 건의내용 -->
                            <div class="etx_con">
                                <span class="big_title">기타 건의내용</span>
                                <textarea id="attask" name="attask"  placeholder=":: 기타 건의 내용 작성 란 입니다. ( 코트 배정 및 조편성 내용은 반영 되지 않습니다.) ::"><%=txtMemo %></textarea>
                            </div>
                            <!-- e: 기타 건의내용 -->

        					<!-- 파트너가 수정할수도 있으므로 살리자 -->
                            <div class="etx_con">
                                    <ul>
                                        <li>
                                        <p class="red_font"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> <span>이게시물의 비밀번호를 입력하십시오.</span> </p>
                                        </li>
                                        <li>
                                            <span class="l_name">비밀 번호</span>
                                        <span class="r_con">
                                            <input type="text" id="attpwd" name="attpwd" maxlength="20" class="ipt input_1" value="<%=UserPass %>" autocomplete="off"  onkeyup="fnkeyup(this);" >
                                        <input style="display:none" type="text" name="fakeusernameremembered"/>
                                        <input style="display:none" type="password" name="fakepasswordremembered"/>
                                        </span>
                                        </li>
                                    </ul>
                            </div>


                            <div class="btn_list">
                                <% if ChekMode = 0 then  %>
                                <a href="javascript:chek_form_pass_data(0);" class="green_btn" id="FormInsert" >신청하기</a>
                            <!-- s: 버튼리스트 -->
                                <%else %>
                            <!-- s: 버튼 리스트 -->
                                <a href="javascript:chek_form_pass_data(1);" class="yello_btn" id="FormDelete" >신청삭제</a>
                                <a href="javascript:chek_form_pass_data(2);" class="green_btn" id="FormUpdate" >수정하기</a>
                                <%end if  %>
                            </div>
                        </div>
                        <!-- e: 대회참가비 입금정보 -->
                    </div>
                </div>
            </div>
        </div>

    </form>

    <!-- 모달 -->
    <div class="modal fade write_moal" id="myModal_game" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh">
        <div class="modal-dialog" style="margin-top:-200px;top:50%;">
            <div class="modal-content"  style="width:100%;overflow-x:scroll;height:430px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">선수정보 변경 요청</h4>
                </div>
                <div class="modal-body">
                    <div class="deposit_info">
                        <div class="etx_con">

                            <div class="l_apply">
                                 <div class="participant_info">
                                    <dl>
                                        <dd>
                                             <div id="Modal_ContentsList" > </div>
                                        </dd>
                                    </dl>
                                 </div>
                            </div>
                        </div>

                        <div class="btn_list" style="text-align:center;">
                            <a href="javascript:chk_frm('21');" class="green_btn" >변경요청</a>
                            <a class="green_btn" class='close' data-dismiss='modal' aria-hidden='true'>닫기</a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!--  !@# 1star -->
    <div class="modal fade l_modalLevel" id="myModal_level" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <div class="levelHeader">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">×</span> </button>
              <h2 class="levelHeaderTit">테니스 레벨 NTRP 선택</h2>
              <p class="levelHeaderTxt">
                <span>
                  ＊본인에 해당하는 항목에 체크해주시기 바랍니다.<span class="emphasis">(중복선택불가)</span><br />
                  ＊선택항목은 참가신청기간 중 수정/변경이 가능합니다.
                </span>
              </p>
            </div>
          </div>

          <div class="modal-body">
            <div class="m_levelTbl">
              <h3 class="m_levelTbl__cap s_1star">★ 1STAR</h3>
              <table>
                <thead>
                  <tr class="m_level__tr">
                    <th class="m_level__td"> 등급 </th>
                    <th colspan="2" class="m_level__col"> 내용 </th>
                    <th class="m_level__col"> 체크 </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="s_level"> 1.0 </td>
                    <td colspan="2" class="s_content"> 테니스를 막 시작한 단계. </td>
                    <td rowspan="1" class="s_check">
                      <label class="m_levelTbl__lableCheck">
                        <input type="radio" name="a" value= "1.0" class="m_levelTbl__check" hidden /><span></span>
                      </label>
                    </td>
                  </tr>
                  <tr>
                    <td class="s_level"> 1.5 </td>
                    <td colspan="2" class="s_content"> 경험이 부족하고 공을 넘기기 급급함. </td>
                    <td rowspan="1" class="s_check">
                      <label class="m_levelTbl__lableCheck">
                        <input type="radio" name="a" value= "1.5"  class="m_levelTbl__check" hidden /><span></span>
                      </label>
                    </td>
                  </tr>
                  <tr>
                    <td rowspan="5" class="s_level"> 2.0 </td>
                    <td class="s_category"> 포핸드 </td>
                    <td class="s_content"> 완벽하지 않은 스윙, 방향 조절이 어렵다. </td>
                    <td rowspan="5" class="s_check">
                      <label class="m_levelTbl__lableCheck">
                        <input type="radio" name="a" value= "2.0" class="m_levelTbl__check" hidden /><span></span>
                      </label>
                    </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 백핸드 </td>
                    <td class="s_content"> 백핸드를 기피. 제대로 맞추지 못함. 그립문제가 생김. 완벽한 스윙불가. </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 서브/리턴 </td>
                    <td class="s_content"> 완벽하지 못한 서브동작. 빈번한 더블폴트. 일정하지 못한 토스. 서브리턴시 잦은 실수. </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 발리 </td>
                    <td class="s_content"> 네트플레이를 꺼림. 백발리를 기피함. 풋워크가 제대로 안됨. </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 경기타입 </td>
                    <td class="s_content"> 단식, 복식의 기본 위치에는 익숙하지만 자주 정위치에서 벗어남. </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="m_btnWrap">
              <a href="javascript:mx_player.SelectLevel()" class="m_btnWrap__btn s_confirm" >확인</a>
            </div>
          </div>





        </div>
      </div>
    </div>

    <!--  !@# 2star -->
    <div class="modal fade l_modalLevel" id="myModal_level2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
      <div class="modal-dialog">
        <div class="modal-content">

          <div class="modal-header">
            <div class="levelHeader">
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">닫기</button>
              <h2 class="levelHeaderTit">테니스 레벨 NTRP 선택</h2>
              <p class="levelHeaderTxt">
                <span class="levelHeaderTxtInner">
                  ＊본인에 해당하는 항목에 체크해주시기 바랍니다.<span class="emphasis">(중복선택불가)</span><br />
                  ＊선택항목은 참가신청기간 중 수정/변경이 가능합니다.
                </span>
              </p>
            </div>
          </div>

          <div class="modal-body">
            <div class="m_levelTbl">
              <h3 class="m_levelTbl__cap s_2star">★★ 2STAR</h3>
              <table>
                <thead>
                  <tr class="m_level__tr">
                    <th class="m_level__td"> 등급 </th>
                    <th colspan="2" clas s="m_level__col"> 내용 </th>
                    <th class="m_level__col"> 체크 </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td rowspan="6" class="s_level"> 2.5 </td>
                    <td class="s_category"> 포핸드 </td>
                    <td class="s_content"> 자세가 잡혀가는 단계. </td>
                    <td rowspan="6" class="s_check">
                      <label class="m_levelTbl__lableCheck">
                        <input type="radio" name="a" value= "2.5" class="m_levelTbl__check" hidden /><span></span>
                      </label>
                    </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 백핸드 </td>
                    <td class="s_content"> 그립과 준비동작에 문제가 있고, 백핸드 쪽으로 온 볼을 포핸드로 돌아서서 치려고 함. </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 서브/리턴 </td>
                    <td class="s_content"> 풀스윙을 시도하고, 느린속도의 서브를 넣을 수 있지만 토스가 불일정함. 느린서브는 제대로 리턴 불가.</td>
                  </tr>
                  <tr>
                    <td class="s_category"> 발리 </td>
                    <td class="s_content"> 네트플레이가 익숙하지 못함. 특히 백핸드는 더욱 익숙하지 못함. 종종 포핸드 면으로 백발리를 시도함. </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 경기타입 </td>
                    <td class="s_content"> 느린 공의 짧은 랠리는 가능. 코트의 수비 범위가 좁고 복식을 할 때 처음 위치에서 움직이지 않음. </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 고급기술 </td>
                    <td class="s_content"> 의도적으로 로브를 띄울 수 있으나 정확성이 부족함. 스매싱은 볼을 맞출 수 있는 수준임. </td>
                  </tr>
                  <tr>
                    <td rowspan="5" class="s_level"> 3.0 </td>
                    <td class="s_category"> 포핸드 </td>
                    <td class="s_content"> 의도하는 방향으로 어느 정도 공을 보낼 수는 있으나, 깊이 조절 능력이 부족함. </td>
                    <td rowspan="5" class="s_check">
                      <label class="m_levelTbl__lableCheck">
                        <input type="radio" name="a" value= "3.0"  class="m_levelTbl__check" hidden /><span></span>
                      </label>
                    </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 백핸드 </td>
                    <td class="s_content"> 준비동작이 제대로 됨. 평범한 속도의 공에 대하여 어느 정도 꾸준히 칠 수 있음. </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 서브/리턴 </td>
                    <td class="s_content"> 서브의 리듬에 대해서 터득하기 시작함. 볼의 스피드를 줄 경우 실수가 종종 발생함. 리턴을 꾸준히 잘함.</td>
                  </tr>
                  <tr>
                    <td class="s_category"> 발리 </td>
                    <td class="s_content"> 포발리는 안정적이지만 백발리는 아직 실수가 많음. 낮거나 옆으로 빠지는 공에 대해 대처를 못함. </td>
                  </tr>
                  <tr>
                    <td class="s_category"> 경기타입 </td>
                    <td class="s_content"> 평범한 속도의 공은 꾸준히 랠리를 할 수 있음. 파트너와 각각 전위, 후위의 형태로 운영을 하되 후위에서 네트로 대쉬할 때 제대로 실행을 못함. </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div class="m_btnWrap">
              <a class="m_btnWrap__btn s_confirm" >확인</a>
            </div>
          </div>

        </div>
      </div>
    </div>

<!-- E: main -->
<!--#include file = "./include/foot.asp" -->
