<!-- #include virtual = "/pub/header.swim.asp" -->
<!DOCTYPE html>
<html lang="ko-KR">
<head>
    <!--#include file = "./include/head.asp" -->
    
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

    <script src="/pub/js/swim/tennis_Request.js<%=CONST_JSVER%>" type="text/javascript"></script>
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

			if (val == 0) { //신청완료

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
                //$("#aT_player_update").click();
                var obja = {};
                obja.CMD = mx_player.CMD_player_bbsEditor;

                console.log(obja.CMD)

                obja.idx = bbsidx;
                obja.tidx = $("#GameTitleIDX").val();
                obja.levelno = $("#levelno").val();
                obja.ridx = $("#ridx").val();
                mx_player.SendPacket("Modal_ContentsList", obja, mx_player.ajaxURL);
				$('#myModal_game').modal('show');
                //console.log(mx_player.ajaxURL);

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


			if ( $("input:checkbox[id='agree02']").is(":checked") == false  )
			{
				alert('서약서 내용 확인 후, 동의해 주시기 바랍니다');
				return;
			}


			if (sf.levelno.value == "") {
                $("#levelno").focus();
                alert("출전부서를 선택 해주시기 바랍니다."); return;
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
                alert("단체명을 입력하여 주십시오."); return;
            }
            if ($('#sidogb1').val() == '' ) {
                alert("소재지를 선택하여 주십시오."); return;
            }
            if ($('#googun1').val() == '' ) {
                alert("소재지 시군구를 선택해 주십시오."); return;
            }
    		//@@@@@@@@@@@@@@@@@@@@@@@



            /*단체장 지도자*/
    		if ( !frm_in.jangname.value ) {
				alert("단체장명을 입력해주십시오.");
    			$("#jangname").focus(); return;
			}


    		if ( !frm_in.readername.value ) {
				alert("지도자명을 입력해주십시오..");
    			$("#readername").focus(); return;
			}
			if (!frm_in.readerphone2.value || !frm_in.readerphone3.value) {
    			$("#readerphone1").attr("disabled", false);
    			$("#readerphone2").attr("disabled", false);
    			$("#readerphone3").attr("disabled", false);
    			alert("지도자 연락처가 없습니다.");
    			if (!frm_in.readerphone2.value) { $("#readerphone2").focus(); return; }
    			if (!frm_in.readerphone3.value) { $("#readerphone3").focus(); return; }
    		}

            $("#aTcommit").click();
        }

        function chek_form_pass_data(val) {
            console.log("chek_form_pass_data");
            var sf = document.frm_in;
            if (val != 1) {
                /*신청자*/
                if (!frm_in.attname.value) { alert("신청자 이름이 없습니다."); $("#attname").focus(); return; }
                if (!frm_in.attphone2.value || !frm_in.attphone3.value) {
                    alert("신청자 연락처가 없습니다.");
                    if (!frm_in.attphone2.value) {
                        $("#attphone2").focus();
                    } else {
                        $("#attphone3").focus();
                    }
                    return;
                }

    			/*입금정보*/
                if (!frm_in.inbankname.value) { alert("입금자 이름이 없습니다."); $("#inbankname").focus(); return; }
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

		function typeChange(typeno){
			if(typeno == 1 ){ //단체
				$('#sh_01').show();
				$('#sh_02').show();
				$('#sh_03').show();
				$('#sh_04').show();

				$("#p1team1").val('');
				$("#p1team1txt").val('');
				$("#jangname").val('');

				$("#readername").val('');
				$("#readerphone2").val('');
				$("#readerphone3").val('');

			}
			else{
				$('#sh_01').hide();
				$('#sh_02').hide();
				$('#sh_03').hide();
				$('#sh_04').hide();

				$("#p1team1").val('ATE0003083');
				$("#p1team1txt").val('개인');
				$("#jangname").val('개인');
				$("#readername").val('개인');
				$("#readerphone2").val('0909');
				$("#readerphone3").val('0909');
			}
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

    		obja.sidogb1 = $('#sidogb1').val() + "_" + $('#sidogb1  option:selected').text(); //거주
            obja.googun1 = $('#googun1').val();
            obja.prize1 = $('#prize1').val(); //상품

            /*단체장 지도자*/
            obja.jangname = frm_in.jangname.value;
            obja.readername = frm_in.readername.value;
            obja.readerphone = $("#readerphone1").val() + frm_in.readerphone2.value + frm_in.readerphone3.value;

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

'    If acctotal > 0 then
'    	SQL = "Select VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_MAST where CUST_CD = '" & Left(sitecode,2) & ridx & "' and sitecode = '"&sitecode&"'"
'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'		If Not rs.eof Then
'    		acct = rs(0)
'    	End If
'
'    	'입금완료여부확인   '현장입금 체크가 아니라면
'	   	SQL = "Select VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_LIST where CUST_CD = '" & Left(sitecode,2) & ridx & "' and STAT_CD = '0' and ERP_PROC_YN = 'N'  "
'    	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'    	If Not rs.eof Then
'    		vaccno = rs(0)
'    		payok = "ok"
'    	Else
'    		vaccno = 0
'    	End If
'    End if

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
		SQL = SQL &"  and  c.Level='"&levelno&"' "
		end if
		SQL = SQL &"  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,b.cfg  "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrA = rs.GetRows()
		End if


'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'		Call rsdrow(rs)

    '참가신청정보############################
		if ridx <>"" and  ChekMode = 1 then
			SQL=""
			SQL = SQL&"  select RequestIDX,SportsGb,GameTitleIDX,Level,EnterType,UserPass,UserName,isnull(UserPhone,'')UserPhone,txtMemo,PaymentDt,PaymentNm "
			SQL = SQL&" ,P1_PlayerIDX,P1_UserName,P1_Team,P1_TeamNm,P1_Team2,P1_TeamNm2,isnull(P1_UserPhone,'') P1_UserPhone, P1_prizekey , a.jangname,a.readername,a.readerphone,addr "
			SQL = SQL&"  from tblGameRequest as a "
			SQL = SQL&"  where RequestIDX='"&ridx&"'  and DelYN = 'N' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


			If Not(Rs.Eof Or Rs.Bof) Then

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

				jangname = rs("jangname")
				readername = rs("readername")
				readerphone = rs("readerphone")
				readerPnoarr = phonesplit(readerphone)
				readerphone1 = readerPnoarr(0)
				readerphone2 = readerPnoarr(1)
				readerphone3 = readerPnoarr(2)
				addr = rs("addr") ' 소재지정보

				If addr <> "" Then
					sg = Split(addr,"_")
					s_sidono1 = sg(0)
					s_gugun1 = sg(2)
				End if
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

		If addr <> "" then
			SQL = "Select GuGunNm from tblGugunInfo where delYN = 'N' and Sido = (select top 1 sido from tblSidoInfo where Sido = '"&Split(addr,"_")(0)&"' )"
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
			If Not rs.EOF Then
				arrGG = rs.GetRows()
			End If
		End if


    %>
</head>
<body id="AppBody">
<div class="l">

  <div class="l_header">

    <div class="m_header">
      <!-- #include file="./include/header_back.asp" -->
      <h1 class="m_header__tit">참가신청서 작성</h1>
    </div>

  </div>

  <button id="aT_player_update" class="green_btn" data-toggle="modal" data-target="#myModal_game" style="display:none;"></button>
  <button id="aTcommit_game" class="green_btn" data-toggle="modal" data-target="#myModal_game" style="display:none;">모집요강</button>
  <button id="aTcommit" class="green_btn" data-toggle="modal" data-target="#myModal" style="display:none;">신청완료</button>

  <!-- S: main -->
  <div class="l_content m_scroll applicationWrite [ _content _scroll ]">
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

        <div class="sd_subTit s_blue02">
            <h3 class="sd_subTit__tit"><%=GameTitleName %></h3>
        </div>

        <div class="m_infoTxt">
            <p class="m_infoTxt__txt">*조회된 이름은 있으나 새로운 단체명으로 출전을 희망하는 선수는  '선수정보 변경요청' 버튼을 클릭 후 수정사항을 적어주세요.</p>
            <p class="m_infoTxt__txt s_empahsis">*입력하신 참가자 휴대폰 번호를 통해 참가내역이 전송됩니다.</p>
        </div>


    	<%If CDbl(acctotal) > 0 Then '금액이 0이상인 경우만%>
    		<%if Cdbl(MemberCnt)> 0 then %>
    		<div class="m_noticeDeposit">
    			<p class="m_noticeDeposit__txt">
    				<span class="m_noticeDeposit__lable">가상계좌 번호</span>
    				<span><%=acct%> KEB하나은행</span>
    			</p>
    			<p class="m_noticeDeposit__txt">
    				<span class="m_noticeDeposit__lable">참가비 금액</span>
    				<span><%=acctotal%>원</span>
                    <%If payok="ok" then%><span class="m_noticeDeposit__emphasis">입금완료</span><%End if%>
    			</p>
    		</div>
    		<%End if%>
    	<%End if%>


      <style>
        .guide{margin:0 15px;}
        .guide__wrap{height:120px;padding:19px 10px 21px 10px;margin-bottom:8px;background-color:#f2f2f2;color:#666666;}
        .guide__inner{height:100%;overflow-y:scroll;}
        .guide__tit{margin-bottom:17px;font-size:16px;letter-spacing:-0.02em;line-height:16px;text-align:center;}
        .guide__txt{font-size:14px;}
        .guide__label{display:table;position:relative;vertical-align:middle;}
        .guide__check{
          position:absolute;top:0;left:0;
          margin:0 !important;
          -webkit-appearance:checkbox;
          appearance:checkbox;
        }
        .guide__labelTxt{display:inline-block;padding-left:20px;margin-top:-2px; font-size:14px;letter-spacing:-0.02em;line-height:20px;color:#333333;}
      </style>

      <div class="guide">
        <div class="guide__wrap">
          <div class="guide__inner">
            <h4 class="guide__tit">서 약 서</h4>
            <p class="guide__txt">
              &lt;&lt;서약&gt;&gt;<br />
              나는 본 대회 참가에 있어서 대회 주최자(송파구수영연합회)가 정하는 대회 규정 및 안전 수칙을 준수하고 다음에 제시하는 사항을 이해하고 승낙하고 대회에 참가하겠습니다.
              <br /><br />
              <경기 특성의 이해와 안전 확보><br />
              1. 나는 오픈워터수영 또는 이와 관련하는 스포츠 경험이 있고 경기자의 몸 상태가 급격히 변화하는 경우가 있음을 인식하는 동시에, 대회장이 돌발적인 환경 변화가 일어날 수 있는 야외 등으로 이루어져 있기 때문에 우발적 사고가 날 수 있어 스스로, 안전에 충분히 주의하면서 경기에 임하지 않으면 안 된다는 것을 이해하고 있습니다.
              <br /><br />
              <건강 상태의 자기 신고><br />
              2. 나의 건강 상태는 최근 1년간 의사의 건강 진단 결과 건강임이 확인되었으며, 대회 참가에 문제를 일으키는 일은 예상되지 않습니다. 또 특이 체질 등으로 대회 의료팀이 긴급 의료를 위해서 알아 두면 좋은 것이 있는 경우에는 사전에 주최자에게 서면으로 신고합니다. 또한 대회 주최자의 요청이 있으면 건강 진단서 또는 부하 심전도 증명서 등 필요한 서류를 제출합니다.
              <br /><br />
              <자기 관리 책임과 응급 처치의 승낙><br />
              3. 나는 참가자 개인의 자각과 책임에서 안전과 건강에 충분한 주의를 기울여 대회에 참가합니다. 또 대회 개최 중에 내가 부상하고 사고를 당하거나 또는 질병이 생기는 경우에는 주최자가 지정하는  의사가 나에 대한 응급처치를 승낙하고 그 응급 처치 방법 및 결과에 대해서 이의를 제기하지 않습니다.
              <br /><br />
              <부상 및 사망 사고 보상 범위><br />
              4. 나는 경기 중 및 부대 행사 개최 중에 부상 후유증이 발생하는 경우 또는 사망한 경우에 있어서도 그 원인 여하를 묻지 않고, 송파구수영연맹 및 대회에 관련된 모든 대회 관계자에 대한 책임의 일체를 면제하겠습니다. 또 나에 대한 보상은 대회 주최자가 계약한 보험의 범위 내인 것을 승낙합니다.
              나 자신, 나의 유언집행자, 관계인, 상속인, 친척 등의 누구로부터도, 내가 입은 일체의 상해에 대해 배상청구, 소송 제기 및 이를 위한 변호사 비용 등의 지불 청구를 하지 않을 것을 서약합니다.
              <br /><br />
              <면책 사항><br />
              5. 천재 또는 기상 상황과 녹조 등 불가항력의 사유에 의해서 안전 확보 때문에 대회 중단 또는 경기 내용 변경이 있었을 경우에 있어서, 대회 참석자 소요 비용(참가비 포함) 환급 청구를 하지 않는 것을 승낙합니다. 또 행사 기간에 자신의 경기 용구의 분실, 파손 또는 도난에 대해서는 대회 주최자의 중대과실이 있는 경우를 제외하고는 대회 주최자에 대한 보상을 요구하지 않을 것을 승낙합니다.
              <br /><br />
              <초상권 및 개인 정보 취급><br />
              6. 나의 초상, 이름, 주소, 나이, 경기력 및 자기소개 등의 개인 정보가 대회 팸플릿, 결과, 대회와 관련홍보물, 보도 및 미디어에 두고 사용되는 것을 승낙하고, 대회 주최자 및 관할 경기 단체가 제작  하는 표시 인쇄물, 비디오 및 정보 미디어 등의 상업적 이용을 승낙합니다.
              <br /><br />
              <친족 등의 승낙><br />
              7. 나의 가족, 친족 및 보호자는 본 서약서에 근거하여 대회의 내용을 이해하고 대회 참가를 승낙하고 있습니다.
              <br /><br />
              <본 서약서에 규정되지 않는 사항에 대해서><br />
              8. 본 서약서 이외의 것에 대해서는 송파구수영연합회의 운영과 대회 규정대로 해결하는 것을 승낙 합니다.
            </p>
          </div>
        </div>
        <label class="guide__label">
          <input type="checkbox" id="agree02" class="guide__check" style="" />
          <span class="guide__labelTxt">위의 서약서 내용을 확인하고, 충분히 인지하였습니다.</span>
        </label>
      </div>

        <div class="m_horizon mgt9 mgb15 mgl15 mgr15"></div>

        <!-- s: 참가자 정보 & 파트너 정보 -->
        <!-- <div class="applicationWrap"> -->
        <div class="m_applicationForm s_outline">

            <ul>

			<li class="m_applicationForm__item">
                    <span class="m_applicationForm__label">출전부서</span>
                    <span class="m_applicationForm__inputWrap" id="attboo">
					<!-- #include virtual = "/pub/html/swimAdmin/common/html.choiceboo.asp" -->
                    </span>
                </li>
            </ul>

            <!-- s: 참가자정보  ---------------------------------------------------------------------------------------------------------------------->
            <h4 class="m_applicationForm__tit"> 참가자정보 </h4>
            <ul>
                <li class="m_applicationForm__item">
                    <span class="m_applicationForm__label">이 름</span>
                    <span class="m_applicationForm__inputWrap">
                        <input  type="hidden" name="p1idx" id="p1idx" value="<%=P1_PlayerIDX %>" />
                        <input type="text" class="m_applicationForm__input" id="p1name" name="p1name" value="<%=P1_UserName %>" readonly />
                        <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-user"></ul>
                    </span>
                </li>

                <li class="m_applicationForm__item">
                    <span class="m_applicationForm__label">휴대폰번호</span>
                    <span class="m_applicationForm__inputWrap">
                        <input type="hidden" name="p1phone" id="p1phone" value="<%=P1_UserPhone %>"/>
                        <select class="m_applicationForm__select s_phone" id="p1phone1" name="p1phone1"  disabled>
                            <option value="010" <%if P1_UserPhone1 ="010" then %> selected<%end if %> >010</option>
                            <option value="011" <%if P1_UserPhone1 ="011" then %> selected<%end if %> >011</option>
                            <option value="016" <%if P1_UserPhone1 ="016" then %> selected<%end if %> >016</option>
                            <option value="017" <%if P1_UserPhone1 ="017" then %> selected<%end if %> >017</option>
                            <option value="018" <%if P1_UserPhone1 ="018" then %> selected<%end if %> >018</option>
                            <option value="019" <%if P1_UserPhone1 ="019" then %> selected<%end if %> >019</option>
                        </select>
                        <span class="m_applicationForm__txt s_phone">-</span>
                        <input type="password" class="m_applicationForm__input s_phone" id="p1phone2" name="p1phone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);"onfocus="this.select()" autocomplete="off" value="<%=P1_UserPhone2 %>" disabled/>
                        <span class="m_applicationForm__txt s_phone">-</span>
                        <input type="number" class="m_applicationForm__input s_phone" id="p1phone3" name="p1phone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off" value="<%=P1_UserPhone3 %>" disabled onblur="mx_player.ChkPhoneNum('p1phone1','p1phone2','p1phone3')" />
                    </span>
                </li>

                <li class="m_applicationForm__item">
                    <span class="m_applicationForm__label">생일/성별</span>
                    <span class="m_applicationForm__inputWrap" id="p1b">
                        <span class="m_applicationForm__txt"> <%=p1_b %>&nbsp;&nbsp;&nbsp;[<%=P1_sex %>] </span>
                    </span>
                </li>



                <li class="m_applicationForm__item">
                  <div class="m_applicationForm__tabWrap" id="chkgubun">
                    <input type="radio" class="m_applicationForm__tabRadio" name="gtype" id="gt01" hidden checked> <label for="gt01" class="m_applicationForm__tab" onmousedown="typeChange(1)">단체</label>
			              <input type="radio" class="m_applicationForm__tabRadio" name="gtype" id="gt02" hidden> <label for="gt02" class="m_applicationForm__tab" onmousedown="typeChange(2)">개인</label>
                  </div>
                </li>


                <li class="m_applicationForm__item" id="sh_01"><!-- show hide 대상 1 -->
                    <span class="m_applicationForm__label">단체명</span>
                    <span class="m_applicationForm__inputWrap">
                        <input type="hidden" name="p1team1" id="p1team1" value="<%=P1_Team%>"/>
                        <input type="text" class="m_applicationForm__input" id="p1team1txt" name="p1team1txt"  placeholder=":: 단체명 입력 ::"
                         onkeyup="fnkeyup(this);" autocomplete="off" value="<%=P1_TeamNm %>" />
                        <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-team" ></ul>
                    </span>
                </li>



                <li class="m_applicationForm__item">
                    <span class="m_applicationForm__label">소재지</span>
                    <span class="m_applicationForm__inputWrap s_residence" id="sidogb1span">
                        <%sdno = 1%>
                        <!-- #include virtual = "/pub/html/swimAdmin/common/html.sido.asp" -->
                    </span>
                </li>




			<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
                <li class="m_applicationForm__item"  id="sh_02"><!-- show hide 대상 2 -->>
                    <span class="m_applicationForm__label">단체장</span>
                    <span class="m_applicationForm__inputWrap">
                        <input type="text" class="m_applicationForm__input" id="jangname" name="jangname" value="<%=jangname %>" />
                        <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-user"></ul>
                    </span>
                </li>

                <li class="m_applicationForm__item" id="sh_03">
                    <span class="m_applicationForm__label">지도자</span>
                    <span class="m_applicationForm__inputWrap">
                        <input type="text" class="m_applicationForm__input" id="readername" name="readername" value="<%=readername %>" />
                        <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-user"></ul>
                    </span>
                </li>

                <li class="m_applicationForm__item" id="sh_04">
                    <span class="m_applicationForm__label">지도자휴대폰</span>
                    <span class="m_applicationForm__inputWrap">
                        <input type="hidden" name="readerphone" id="readerphone" value="<%=readerphone %>"/>
                        <select class="m_applicationForm__select s_phone" id="readerphone1" name="readerphone1"  >
                            <option value="010" <%if readerphone1 ="010" then %> selected<%end if %> >010</option>
                            <option value="011" <%if readerphone1 ="011" then %> selected<%end if %> >011</option>
                            <option value="016" <%if readerphone1 ="016" then %> selected<%end if %> >016</option>
                            <option value="017" <%if readerphone1 ="017" then %> selected<%end if %> >017</option>
                            <option value="018" <%if readerphone1 ="018" then %> selected<%end if %> >018</option>
                            <option value="019" <%if readerphone1 ="019" then %> selected<%end if %> >019</option>
                        </select>
                        <span class="m_applicationForm__txt s_phone">-</span>
                        <input type="number" class="m_applicationForm__input s_phone" id="readerphone2" name="readerphone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);"onfocus="this.select()" autocomplete="off" value="<%=readerphone2 %>" />
                        <span class="m_applicationForm__txt s_phone">-</span>
                        <input type="number" class="m_applicationForm__input s_phone" id="readerphone3" name="readerphone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off" value="<%=readerphone3 %>"  />
                    </span>
                </li>





                <%If IsArray(arrG) Then%>
                <li class="m_applicationForm__item">
                    <span class="m_applicationForm__label">참가상품</span>
                    <span id="gameprize" class="m_applicationForm__inputWrap">
                        <select  id="prize1" class="m_applicationForm__input" >
                            <%If UBound(arrG, 2) > 1 then%>
						<option value="">=참가상품=</option>
						<%End if%>
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
                                    %><option value="<%=gpidx%>" <%If CStr(gpidx) = P1_prize then%>selected<%End if%>><%=gnm%>&nbsp;<%=gsize%></option><%
                                i = i + 1
                                Next
                            %>
                        </select>
                    </span>
                </li>
                <%End if%>
            </ul>
            <!-- e: 참가자정보 ---------------------------------------------------------------------------------------------------------------------->


		<input type="hidden" id="ptn_undefined" class="ml-10" name="ptn_undefined"  checked>

        </div>
        <!-- e: 참가자 정보 & 파트너 정보 -->


        <!-- s: 버튼 리스트 -->
        <% if ChekMode = 0 then  %>
        <div class="m_reqBtnWrap">
            <a href="javascript:chk_frm('20');" class="m_reqBtnWrap__btn s_modify">선수정보 수정 요청</a>
            <a href="javascript:chk_frm('0');"  class="m_reqBtnWrap__btn s_result">신청완료</a>
        </div>
        <%else %>
        <div class="m_reqBtnWrap">
            <a href="javascript:chk_frm('20');" class="m_reqBtnWrap__btn2 s_modify">선수정보 수정 요청</a>
            <a href="javascript:chk_frm('12');" class="m_reqBtnWrap__btn2 s_apply">참가신청내역</a>

            <a <% if Ch_u ="Y" then  %> href="javascript:chk_frm('1');" <% else  %> href="javascript:alert('참가신청 취소는 마감 되었습니다.');"<% end if  %> class="m_reqBtnWrap__btn2 s_del">신청삭제</a>
            <a <% if Ch_d ="Y" then  %> href="javascript:chk_frm('2');" <% else  %> href="javascript:alert('참가신청 수정이 마감 되었습니다.');" <% end if  %>class="m_reqBtnWrap__btn2 s_result">수정하기</a>
        </div>
        <%end if  %>
        <!-- e: 버튼리스트 -->

        <!-- s: 대회 참가신청 절차 -->
        <div class="applyStep">
            <h3 class="applyStep__tit">대회 참가신청 절차</h3>
            <div class="applyStep__imgWrap">


                <!-- <img src="<%=IHOME%>swim_img_info.png" alt="" class="applyStep__img" /> -->
                <img src="http://img.sportsdiary.co.kr/images/SD/img/swim_img_info_@3x.png" alt="" class="applyStep__img" />


            </div>
        </div>
        <!-- e: 대회 참가신청 절차 -->

        <!-- 대회신청 정보 모달 -->
        <div class="modal fade m_reqModal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header m_reqModal__header">
                        <button type="button" class="m_reqModal__close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
                        <h2 class="m_reqModal__tit">대회신청 정보</h2>
                    </div>
                    <div class="modal-body reqInfoModal">

                        <div class="m_applicationForm">

                            <!-- s: 대회참가비 입금정보 -->
                            <ul>
                                <li class="m_applicationForm__item">
                                    <span class="m_applicationForm__label">신청자이름</span>
                                    <span class="m_applicationForm__inputWrap">
                                        <input type="text" class="m_applicationForm__input ui-autocomplete-input" id="attname" name="attname" placeholder=":: 이름을 입력하세요 ::"  autocomplete="off" value="<%=UserName %>"
                                          readonly>
                                    </span>
                                </li>
                                <li class="m_applicationForm__item">
                                    <span class="m_applicationForm__label">휴대폰번호</span>
                                    <span class="m_applicationForm__inputWrap">
                                        <input type="hidden" name="attphone" id="attphone" value="<%=UserPhone %>"/>
                                        <select class="m_applicationForm__select s_phone" id="attphone1" name="attphone1" readonly>
                                            <option value="010" <%if UserPhone1 ="010" then %> selected<%end if %> >010</option>
                                            <option value="011" <%if UserPhone1 ="011" then %> selected<%end if %> >011</option>
                                            <option value="016" <%if UserPhone1 ="016" then %> selected<%end if %> >016</option>
                                            <option value="017" <%if UserPhone1 ="017" then %> selected<%end if %> >017</option>
                                            <option value="018" <%if UserPhone1 ="018" then %> selected<%end if %> >018</option>
                                            <option value="019" <%if UserPhone1 ="019" then %> selected<%end if %> >019</option>
                                        </select>
                                        <span class="m_applicationForm__txt s_phone">-</span>
                                        <input type="password" class="m_applicationForm__input s_phone" id="attphone2" name="attphone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);" value="<%=UserPhone2 %>" readonly>
                                        <span class="m_applicationForm__txt s_phone">-</span>
                                        <input type="number" class="m_applicationForm__input s_phone" id="attphone3" name="attphone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" value="<%=UserPhone3 %>"  readonly>
                                    </span>
                                </li>

        	                    <%If payok = "ok" then%>
        						<li class="m_applicationForm__item">
                                    <div class="notice s_in">
                                        <p class="notice__txt2 s_empahsis"><i class="fa fa-exclamation-circle" aria-hidden="true"></i>
                                            <span>환불 할 계좌 정보를 입력해 주십시오. </span>
                                        </p>
                                    </div>
                                </li>
        						<li class="m_applicationForm__item">
                                    <span class="m_applicationForm__label">환불정보</span>
                                    <span class="m_applicationForm__inputWrap">
                                        <input type="text" class="m_applicationForm__input s_refundInfo" id="inbankname" name="inbankname" value=""  onkeyup="fnkeyup(this);" maxlength="10"   placeholder=":: 이름 ::"  autocomplete="off">
                                        <input type="text" class="m_applicationForm__input s_refundInfo" id="inbank" name="inbank" value=""  onkeyup="fnkeyup(this);"   placeholder=":: 은행 ::"  maxlength="8" autocomplete="off">
                                    </span>
        						</li>
        						<li class="m_applicationForm__item">
        							<span class="m_applicationForm__label">환불계좌</span>
        							<span class="m_applicationForm__inputWrap">
                                        <input type="text" class="m_applicationForm__input" id="inbankacc" name="inbankacc" value=""  onkeyup="fnkeyup(this);"   placeholder=":: 계좌 ::" maxlength="20"  autocomplete="off">
                                    </span>
                                </li>

        	                    <%else%>

        						<li class="m_applicationForm__item">
                                    <p class="m_applicationForm__txt s_empahsis"> <i class="fa fa-exclamation-circle" aria-hidden="true"></i>입금자명을 통해 입금 확인 절차가 진행됩니다. </p>
                                </li>

                                <li class="m_applicationForm__item">
                                    <span class="m_applicationForm__label">입금자명</span>
                                    <span class="m_applicationForm__inputWrap">
                                        <input type="text" class="m_applicationForm__input" id="inbankname" name="inbankname" value="<%=PaymentNm %>"  onkeyup="fnkeyup(this);"   placeholder=":: 이름을 입력하세요 ::"  autocomplete="off">
                                    </span>
                                </li>

        	                    <%End if%>
                            </ul>
                            <h4 class="m_applicationForm__tit">기타 건의내용</h4>
                            <ul>
                                <li class="m_applicationForm__item">
                                    <textarea id="attask" name="attask" class="m_applicationForm__textarea" placeholder=":: 기타 건의 내용 작성 란 입니다. ::"><%=txtMemo %></textarea>
                                </li>
                            </ul>

        					<!-- 파트너가 수정할수도 있으므로 살리자 -->
                            <ul>
                                <li class="m_applicationForm__item">
                                    <p class="m_applicationForm__txt s_empahsis"><i class="fa fa-exclamation-circle" aria-hidden="true"></i>이게시물의 비밀번호를 입력하십시오.</p>
                                </li>
                                <li class="m_applicationForm__item">
                                    <span class="m_applicationForm__label">비밀 번호</span>
                                    <span class="m_applicationForm__inputWrap">
                                        <input type="text" id="attpwd" name="attpwd" maxlength="20" class="m_applicationForm__input" value="<%=UserPass %>" autocomplete="off"  onkeyup="fnkeyup(this);" >
                                        <input style="display:none" type="text" name="fakeusernameremembered"/>
                                        <input style="display:none" type="password" name="fakepasswordremembered"/>
                                    </span>
                                </li>
                            </ul>
                            <!-- e: 대회참가비 입금정보 -->
                        </div>

                        <!-- s: 버튼 리스트 -->
                        <div class="m_reqModal__btnWrap">
                            <% if ChekMode = 0 then  %>
                            <a href="javascript:chek_form_pass_data(0);" class="m_reqModal__btn s_apply" id="FormInsert" >신청하기</a>

                            <%else %>

                            <a href="javascript:chek_form_pass_data(1);" class="m_reqModal__btn s_del" id="FormDelete" >신청삭제</a>
                            <a href="javascript:chek_form_pass_data(2);" class="m_reqModal__btn s_modify" id="FormUpdate" >수정하기</a>
                            <%end if  %>
                        </div>
                        <!-- e: 버튼 리스트 -->
                    </div>
                </div>
            </div>
        </div>

    </form>
  </div>
  <!-- e: main -->


  <!-- 선수정보 변경 요청 모달 -->
  <div class="modal fade m_reqModal" id="myModal_game" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh">
      <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header m_reqModal__header">
                  <button type="button" class="m_reqModal__close" data-dismiss="modal" aria-label="close"> <span aria-hidden="true">&times;</span> </button>
                  <h2 class="m_reqModal__tit">선수정보 변경 요청</h2>
              </div>
              <div class="modal-body infoModifyModal">
                  <div class="m_infoTxt">
                      <p class="m_infoTxt__txt">*선수정보수정요청 완료후에도 기존정보로 참가신청이 가능합니다.</p>
                      <!-- <p class="m_infoTxt__txt s_empahsis">*선수명과 전화번호 미 입력시 변경 불가합니다.반드시 이름과 전화번호를 입력해주세요.</p> -->
                  </div>

                  <div id="Modal_ContentsList" class="infoModify"></div>

                  <div class="m_reqModal__btnWrap">
                      <a class="m_reqModal__btn s_close" data-dismiss="modal" aria-hidden="true">닫기</a>
                      <a href="javascript:chk_frm('21');" class="m_reqModal__btn s_confirm" >변경요청</a>
                  </div>
              </div>

          </div>
      </div>
  </div>

  <!--  레벨 모달 -->
  <div class="modal fade m_reqModal" id="myModal_level" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh">
      <div class="modal-dialog">
          <div class="modal-content">
              <div class="modal-header m_reqModal__header">
                  <button type="button" class="m_reqModal__close" data-dismiss="modal" aria-label="close"> <span aria-hidden="true">×</span> </button>
                  <h2 class="m_reqModal__tit">테니스 레벨 NTRP 선택</h2>
              </div>


              <div class="modal-body levelModal">

                  <div class="m_infoTxt">
                      <p class="m_infoTxt__txt">＊본인에 해당하는 항목에 체크해주시기 바랍니다.<span class="m_infoTxt__emphasisTxt">(중복선택불가)</span></p>
                      <p class="m_infoTxt__txt">＊선택항목은 참가신청기간 중 수정/변경이 가능합니다.</p>
                  </div>

                  <!-- 1star -->
                  <div class="levelTbl"  id="1starchk">
                      <h3 class="levelTbl__cap s_1star">★ 1STAR</h3>
                      <table>
                          <thead>
                              <tr>
                                  <th> 등급 </th>
                                  <th colspan="2"> 내용 </th>
                                  <th> 체크 </th>
                              </tr>
                          </thead>
                          <tbody>
                              <tr>
                                  <td class="s_level"> 1.0 </td>
                                  <td colspan="2" class="s_content"> 테니스를 막 시작한 단계. </td>
                                  <td rowspan="1" class="s_check">
                                      <label class="levelTbl__lableCheck">
                                          <input type="radio" name="a" value= "1.0" class="levelTbl__check" hidden /><span></span>
                                      </label>
                                  </td>
                              </tr>
                              <tr>
                                  <td class="s_level"> 1.5 </td>
                                  <td colspan="2" class="s_content"> 경험이 부족하고 공을 넘기기 급급함. </td>
                                  <td rowspan="1" class="s_check">
                                      <label class="levelTbl__lableCheck">
                                          <input type="radio" name="a" value= "1.5"  class="levelTbl__check" hidden /><span></span>
                                      </label>
                                  </td>
                              </tr>
                              <tr>
                                  <td rowspan="5" class="s_level"> 2.0 </td>
                                  <td class="s_category"> 포핸드 </td>
                                  <td class="s_content"> 완벽하지 않은 스윙, 방향 조절이 어렵다. </td>
                                  <td rowspan="5" class="s_check">
                                      <label class="levelTbl__lableCheck">
                                          <input type="radio" name="a" value= "2.0" class="levelTbl__check" hidden /><span></span>
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

                  <!-- 2star -->
                  <div class="levelTbl" id="2starchk">
                      <h3 class="levelTbl__cap s_2star">★★ 2STAR</h3>
                      <table>
                          <thead>
                              <tr>
                                  <th> 등급 </th>
                                  <th colspan="2"> 내용 </th>
                                  <th> 체크 </th>
                              </tr>
                          </thead>
                          <tbody>
                              <tr>
                                  <td rowspan="6" class="s_level"> 2.5 </td>
                                  <td class="s_category"> 포핸드 </td>
                                  <td class="s_content"> 자세가 잡혀가는 단계. </td>
                                  <td rowspan="6" class="s_check">
                                      <label class="levelTbl__lableCheck">
                                          <input type="radio" name="a" value="2.5" class="levelTbl__check" hidden /><span></span>
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
                                  <label class="levelTbl__lableCheck">
                                      <input type="radio" name="a" value="3.0"  class="levelTbl__check" hidden /><span></span>
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


                  <div class="m_reqModal__btnWrap">
                      <a href="javascript:mx_player.SelectLevel(<%=GameTitleIDX%>)" class="m_reqModal__btn s_confirm" >확인</a>
                  </div>
              </div>

          </div>
      </div>
  </div>


<!-- E: main -->
<!--#include file = "./include/foot.asp" -->

</div>
</body>
</html>
<!--#include file = "./include/sub_config.asp" -->