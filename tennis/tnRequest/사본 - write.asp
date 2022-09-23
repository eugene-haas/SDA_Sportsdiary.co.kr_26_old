<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<%
ChekMode  = fInject(Request("ChekMode"))
if  ChekMode = 0 then 
    CMD= 300    
else
    CMD= 300
end if 
 
ridx  = fInject(Request("ridx"))
Years     = fInject(Request("Years"))
Months     = fInject(Request("Months")) 
GameTitleIDX     = fInject(Request("GameTitleIDX"))
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

'Response.Write "<br> ridx :" & ridx
'Response.Write "<br> ChekMode :" & ChekMode
'Response.Write "<br> GameTitleIDX :" & GameTitleIDX
'Response.Write "<br> GameTitleName :" & GameTitleName
'Response.Write "<br> TeamGb :" & TeamGb
'Response.Write "<br> TeamGbNm :" & TeamGbNm
'Response.Write "<br> levelno :" & levelno
'Response.Write "<br> levelNm :" & levelNm

''대회 정보 검색
%>  
<link href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.min.js"></script> 
<!--<script src="/ckeditor/ckeditor.js"></script>-->
<script src="/pub/js/tennis_Request.js?ver=2" type="text/javascript"></script>
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
        if (val == 0 ) {
            chek_form_data(val);
            $("#FormDelete").css("display", "none");
            $("#FormUpdate").css("display", "none");
        }
        else if (val == 2) {
            //수정
            chek_form_data(val);
            $("#FormDelete").css("display", "none");
            $("#FormUpdate").css("display", "");
        }
        else if (val == 1 ) {
            //삭제
            $("#aTcommit").click();
            $("#FormDelete").css("display","");
            $("#FormUpdate").css("display","none");

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
            mx_player.SendPacket("Modal_ContentsList", obja, "/pub/ajax/mobile/reqTennisatt.asp");
        } else if (val == 21) {
            //선수정보 수정 저장
            var obja = {};
            obja.CMD = mx_player.CMD_player_bbsEditorOK;
            obja.idx = bbsidx;
            obja.CONTENTS = $("#playeredit").val(); 
            mx_player.SendPacket("Modal_ContentsList", obja, "/pub/ajax/mobile/reqTennisatt.asp");
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

    function PhoneP(object) {
        var cheker = "N";
        switch (object.value) {
            case "1004":
            case "0001": 
            case "1111":
            case "1234":
            case "0000":
                cheker = "Y";
                break;

        }

        if (cheker == "Y") {
            alert("해당 번호  "+object.value+" 는 사용 할 수 없습니다.");
            object.value = "";
            maxLengthCheck(object);
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
            $("#p1phone").val($("#p1phone1").val() + $("#p1phone2").val() + $("#p1phone3").val());
            if (!$("#p1phone2").val() && !$("#p1phone3").val()) {
                $("#p1phone").val("");
            } 
        }
        if (object.id.indexOf("p2phone") >= 0) {
            /*참가자 정보 2  파트너*/
            $("#p2phone").val($("#p2phone1").val() + $("#p2phone2").val() + $("#p2phone3").val());
            if (!$("#p2phone2").val() && !$("#p2phone3").val()) {
                $("#p2phone").val("");
            }
        }
        if (object.id.indexOf("attphone") >= 0) {
            /*신청자*/
            $("#attphone").val($("#attphone1").val() + $("#attphone2").val() + $("#attphone3").val());
            if (!$("#attphone2").val() && !$("#attphone3").val()) {
                $("#attphone").val("");
            }
        }
    }

    function chek_form_data(val) {
        console.log("chek_form_data");
        var sf = document.frm_in;

		if( sf.p1name.value  != '' && sf.p2name.value != '' && sf.p1name.value  == sf.p2name.value){
			alert("참가자 와 파트너의 이름이 동일합니다."); return ;
		}
		if( sf.p1phone.value  != '' && sf.p2phone.value != '' && sf.p1phone.value  == sf.p2phone.value){
			alert("참가자 와 파트너의 핸드폰 번호가 동일합니다."); return ;
		}

		/*참가자 정보 1 */
        if (!frm_in.p1name.value) { alert("참가자 이름이 없습니다."); $("#p1name").focus(); return ; }
        if (!frm_in.p1phone.value) {
            if (!frm_in.p1phone2.value || !frm_in.p1phone3.value) {
                alert("참가자 연락처가 없습니다.");
                $("#p1phone1").attr("disabled", false);
                $("#p1phone2").attr("disabled", false);
                $("#p1phone3").attr("disabled", false);
                if (!frm_in.p1phone2.value) { $("#p1phone2").focus(); } else { $("#p1phone3").focus(); } return;
            }
        }
        /*참가자 정보 2  파트너*/
        if (!frm_in.p2name.value) { alert("파트너 이름이 없습니다."); $("#p2name").focus(); return ; }
        if (!frm_in.p2phone.value) {
            if (!frm_in.p2phone2.value || !frm_in.p2phone3.value) {
                alert("참가자 연락처가 없습니다.");
                $("#p2phone1").attr("disabled", false);
                $("#p2phone2").attr("disabled", false);
                $("#p2phone3").attr("disabled", false);
                if (!frm_in.p2phone2.value) { $("#p2phone2").focus(); } else { $("#p2phone3").focus(); } return;
            }
        }

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
        mx_player.SendPacket("", obja, "/pub/ajax/mobile/reqTennisatt.asp");

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
        mx_player.SendPacket("", obja, "/pub/ajax/mobile/reqtennisatt.asp");

    }

    function savedata(val) {
        console.log("savedata");
            var sf = document.frm_in;
            //저장 api 
            var obja = {};
            if (val==0) {
                obja.CMD = mx_player.CMD_PLAYERREG;
            } else {
                obja.CMD = mx_player.CMD_PLAYERUDATE;
            } 

            obja.ridx = $("#ridx").val();
            obja.tidx = $("#GameTitleIDX").val();
            obja.teamgb= $("#TeamGb").val();
            obja.teamgbNm = $("#TeamGbNm").val();
            obja.levelno = $("#levelno").val();
            obja.levelNm = $("#levelNm").val();

            /*신청자*/
            obja.attname = frm_in.attname.value;
            obja.attphone = $("#attphone1").val() + frm_in.attphone2.value + frm_in.attphone3.value;
            obja.attpwd = frm_in.attpwd.value;
            obja.attask = frm_in.attask.value;

            /*입금정보*/
            obja.inbankdate = NowTime;
            obja.inbankname = frm_in.inbankname.value;

            /*참가자 정보 1 */
            //참가자 중복 체크

            //$("#Fnd_Kw").val(frm_in.p1name.value);
            obja.p1idx = frm_in.p1idx.value;
            obja.p1name = frm_in.p1name.value;
            obja.p1grade = "";
            if (!frm_in.p1idx.value) {
                obja.p1phone = $("#p1phone1").val() + frm_in.p1phone2.value + frm_in.p1phone3.value;
            } else {
                obja.p1phone = $("#p1phone").val();
            }
            obja.p1team1 = frm_in.p1team1.value;
            obja.p1team1txt = frm_in.p1team1txt.value;
            obja.p1team2 = frm_in.p1team2.value;
            obja.p1team2txt = frm_in.p1team2txt.value;

            /*참가자 정보 2  파트너*/
            //파트너 중복 체크

            obja.p2idx = frm_in.p2idx.value;
            obja.p2name = frm_in.p2name.value;
            obja.p2grade = "";
            if (!frm_in.p2idx.value) {
                obja.p2phone = $("#p2phone1").val() + frm_in.p2phone2.value + frm_in.p2phone3.value;
            } else {
                obja.p2phone = $("#p2phone").val();
            }

            obja.p2team1 = frm_in.p2team1.value;
            obja.p2team1txt = frm_in.p2team1txt.value;
            obja.p2team2 = frm_in.p2team2.value;
            obja.p2team2txt = frm_in.p2team2txt.value;

            if (!$("#ridx").val() && $("#ChekMode").val() == "0") {
                //저장  /pup/api/mobile/api.apply.asp
                mx_player.SendPacket("", obja, "/pub/ajax/mobile/reqtennisatt.asp");
            } else if ($("#ridx").val() && $("#ChekMode").val() == "1") {
                //수정  /pup/api/mobile/api.apply.asp
                mx_player.SendPacket("", obja, "/pub/ajax/mobile/reqtennisatt.asp");
            }
            else {
                console.log("저장실패");
            }
    }


    $(document).ready(function () {
        if ($("#ridx").val() && $("#ChekMode").val() == 1) {
            var obja = {};
            obja.CMD = mx_player.CMD_Request_Edit_s;
            obja.IDX = $("#GameTitleIDX").val();
            obja.levelno = $("#levelno").val();
            obja.ridx = $("#ridx").val();
            obja.ChekMode = $("#ChekMode").val();
            console.log(obja);
            mx_player.SendPacket("ContentsList", obja, "/pub/ajax/mobile/reqTennisatt.asp");
        }
    });
</script>

<%
if ridx <> "" and ChekMode=1 then
    SQL ="select EntryCntGame,cfg,SUBSTRING(cfg,2,1)Ch_i,SUBSTRING(cfg,3,1)Ch_u,SUBSTRING(cfg,4,1)Ch_d from tblRGameLevel where GameTitleIDX = '"&GameTitleIDX&"' and level='"&levelno&"' and  delYN='N' "
    Set Rs = Dbcon.Execute(SQL)
    If Not rs.EOF Then 
    Do Until rs.eof
        cfg = Rs("cfg")
        Ch_i = Rs("Ch_i")
        Ch_u = Rs("Ch_u")
        Ch_d = Rs("Ch_d")
    rs.movenext
    Loop
    End if
End if
%>
<title>KATA Tennis 대회 참가신청</title>
 
<body class="lack_bg" id="AppBody">
<!-- S: header -->
<!-- #include file = "./include/header.asp" -->
<!-- E: header -->
<!-- S: main -->
   
<button id="aT_player_update" class="green_btn" data-toggle="modal" data-target="#myModal_game"  style=" display:none;"></button>
<button id="aTcommit_game" class="green_btn" data-toggle="modal" data-target="#myModal_game"  style=" display:none;">모집요강</button>
<button id="aTcommit" class="green_btn" data-toggle="modal" data-target="#myModal"  style=" display:none;">신청완료</button>

<div class="modal fade write_moal" id="myModal_game" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
	<div class="modal-dialog" style="margin-top:-200px;top:50%;">
		<div class="modal-content"  style="width:100%;overflow-x:scroll;height:400px;"> 
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
<form method="post" name="frm_in" id="frm_in" >  
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
<h1 class="page_title">
	<a href="javascript:chk_frm(11);" class="" >
		<i class="fa fa-angle-left" aria-hidden="true"></i> 
	</a>  <span class="name">참가신청서 작성</span></h1>
<div class="l_apply">
	<!-- s: 타이틀 박스 -->
	<div class="top_title_box">
		<h1 class="apply_title"><%=GameTitleName %></h1>
		<p class="d_date">
            <%
            SQL = " select  convert(date,GameS)GameS,convert(date,GameE)GameE from sd_TennisTitle  where DelYN='N' and GameTitleIDX= '"&GameTitleIDX&"' "
            Set Rs = Dbcon.Execute(SQL)
            If Not(Rs.Eof Or Rs.Bof) Then 
            Do Until Rs.Eof   
            %>
            <span><%=Rs("GameS") %><span>(<%=weekDayName(weekDay(Rs("GameS"))) %>)</span></span>
			<em>~</em>
			<span><%=Rs("GameE") %><span>(<%=weekDayName(weekDay(Rs("GameE"))) %>)</span></span>
            <%
            Rs.MoveNext
            Loop 
            end if 
            %>
		</p>
       <!-- s: 버튼 리스트 -->
        <% if ChekMode = 0 then  %>
	    <div class="btn_list">
		    <a href="javascript:chk_frm('10');" class="gray_btn">대회목록</a>
		    <a href="javascript:chk_frm('12');" class="black_btn">참가신청내역</a>
		    <!--<a href="javascript:chk_frm('0');"  class="green_btn"  >신청완료</a>-->
				<a href="javascript:chk_frm('20');" class="red_btn">선수정보 수정 요청</a>
	    </div>
	    <!-- s: 버튼리스트 -->
        <%else %>
	    <!-- s: 버튼 리스트 -->
	    <div class="s_btn_list">
		    <a href="javascript:chk_frm('10');" class="gray_btn">대회목록</a>
		    <a href="javascript:chk_frm('12');" class="black_btn">참가신청내역</a> 
            <% if Ch_u ="Y" then  %>
		        <a href="javascript:chk_frm('1');" class="yello_btn"  >신청삭제</a>
            <% end if  %>
            <% if Ch_d ="Y" then  %>
		        <a href="javascript:chk_frm('2');" class="green_btn"  >수정하기</a>
            <% end if  %>
	    </div>
        <%end if  %>
	    <!-- s: 버튼리스트 -->
	</div>
	<!-- e: 타이틀 박스 -->
	<!-- s: 출전종목 박스 -->
	<div class="list_section_1">
		<ul> 
            <li>
	        <!-- s: 중요문구 -->
	            <div class="text_box">
		            <p class="red_font">
                        <i class="fa fa-exclamation-circle" aria-hidden="true"></i>
                        <span>  참가지 이름을 검색하고 해당 클럽의 이름을 선택해주세요.(참가자 핸드폰번호 뒷자리 확인) </span>
                     </p>
                    <p class="">
                        <i class="fa fa-exclamation-circle" aria-hidden="true"></i>
                        <span>  만약 조회된 이름이 없으면 '선수등록'을 클릭하여 이름입력을 완성해주세요.  </span>
                    </p>
                    <p class="red_font">
                        <i class="fa fa-exclamation-circle" aria-hidden="true"></i>
                        <span>  조회된 이름은 있으나 새로운 클럽으로 출전을 희망하는 선수는  '선수정보 변경요청' 버튼을 클릭 후 수정사항을 반드시 적어주세요.</span>
                    </p> <!--red_font-->
		<!--            <p class="">
			            <i class="fa fa-exclamation-circle" aria-hidden="true"></i>
			            <span> *(단, 선수이름과 전화번호가 동일한 정보로 한번이라도 대회참가를 한 선수는 추가생성이 불가하므로 </span>
                        <span>   클럽명을 바꾸고자 할 때에는 KATA 사무국(0505-555-0055) 또는 이정우 사무국장(010-6390-5910)에게 문의하셔서 변경하신 후 다시 참가 신청을 하시기 바랍니다.)</span>
		            </p>-->
                   
		            <p class="">
			            <i class="fa fa-exclamation-circle" aria-hidden="true"></i>
			            <span>입력하신 참가자(파트너 포함) 휴대폰 번호를 통해 참가선수 본인 확인 절차가 진행됩니다. </span>
		            </p>
                    <!--
		            <p class="red_font"><i class="fa fa-exclamation-circle" aria-hidden="true"></i>
                        <span>핸드폰번호는 뒷자리만 노출 됩니다. </span>
                    </p> -->
                     
	            </div>
	        <!-- e: 중요문구 -->
            </li>
		</ul>
	</div>
	<!-- e: 출전종목 박스 -->
	<!-- s: 참가자 정보 & 파트너 정보 -->
    <div class="deposit_info">
	    <span class="big_title">대회신청 </span>
    </div>
	<div class="participant_info">
        <dl>
            <dd>
            	<div class="info_list"> 
                <ul>
			            <li>
				            <span class="l_name">출전부</span>
				            <span class="r_con">
                                    <%
                                    SQL = " select b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame "  
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
                                     %> 
					            <select class="ipt select_1" id="levelno" name="levelno">
                                    <%
                                        i = 0
                                        Set Rs = Dbcon.Execute(SQL)
                                        If Not(Rs.Eof Or Rs.Bof) Then 
                                        Do Until Rs.Eof  
                                            if ChekMode = 0 and ridx ="" then 
                                                if Rs("Ch_i") ="Y" then
                                                    i=i+1
                                                %>
						                        <option value="<%=Rs("Level") %>" <% if levelno =Rs("Level") then %> selected<% end if  %> ><%=Replace(Rs("TeamGbNm"),"부","")%>-<%=Rs("LevelNm") %> <%=Rs("RequestCnt") %>/<%=Rs("EntryCntGame") %></option>
                                                <%
                                                end if 
                                            else
                                            %>
						                    <option value="<%=Rs("Level") %>" <% if levelno =Rs("Level") then %> selected<% end if  %> ><%=Replace(Rs("TeamGbNm"),"부","")%><%=Rs("LevelNm") %> <%=Rs("RequestCnt") %>/<%=Rs("EntryCntGame") %></option>
                                            <%
                                            end if 
                                        Rs.MoveNext
                                        Loop  
                                        end if 

                                     %> 
					            </select>
                                <%
                                    if ChekMode = 0 and i = 0 then 
                                    %>
                                        <script type="text/javascript">
                                            alert("참가신청 기간이 아닙니다.");
                                            location.href = "./list.asp";
                                        </script>  
                                    <%
                                    end if 
                                 %>
				            </span>
			            </li>
                </ul>
                </div>
            </dd>
        </dl>
		<dl id="ContentsList">
			<!-- s: 참가자정보 -->
			<dd>

				<p class="c_title">참가자 정보 </p>
				<div class="info_list">
					<ul> 
						<li>
							<span class="l_name">이 름</span>
							<span class="r_con">
                                <input  type="hidden"  name="p1idx" id="p1idx" value=""/> 
								<input type="text" class="ipt input_1" id="p1name" name="p1name" autocomplete="off" placeholder=":: 이름을 입력하세요 ::"  onfocus="this.select()" />
                                <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-user" ></ul>
							</span> 
						</li>
						<!--<li>
							<span class="l_name">등 급</span>
							<span class="r_con">
								<select class="ipt select_1" id="p1grade" name="p1grade">
									<option value="">선택</option>
									<option value="A" selected="">A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="E">E</option>
									<option value="F">F</option>
								</select>
							</span>
						</li>-->
						<li>
							<span class="l_name">대표소속</span>
							<span class="r_con">
                <input  type="hidden"  name="p1team1" id="p1team1" value=""/> 
								<input type="text" class="ipt input_1" id="p1team1txt" name="p1team1txt"  placeholder=":: 대표소속명을 입력하세요 ::" autocomplete="off" />
                                <ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-team" ></ul>
							</span>
						</li>
                        <li>
							<span class="l_name">추가소속</span>
							<span class="r_con">
                                <input  type="hidden"  name="p1team2" id="p1team2" value=""/> 
								<input type="text" class="ipt input_1" id="p1team2txt" name="p1team2txt"  placeholder=":: 추가소속명을 입력하세요 ::" autocomplete="off"/> 
							</span>
                        </li>
						<li>
							<span class="l_name">핸 드 폰</span>
							<span class="r_con"> 
                                <input  type="hidden"  name="p1phone" id="p1phone" value=""/> 
					            <select class="ipt col_1" id="p1phone1" name="p1phone1">
						            <option value="010">010</option>
						            <option value="011">011</option>
						            <option value="016">016</option>
						            <option value="017">017</option>
						            <option value="018">018</option>
						            <option value="019">019</option>
					            </select>
								<span class="divn">-</span>
								<input type="password" class="ipt col_1" id="p1phone2" name="p1phone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);"onfocus="this.select()" autocomplete="off"/>
								<span class="divn">-</span>
								<input type="number" class="ipt col_1" id="p1phone3" name="p1phone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off"/>
							</span>
						</li>
					</ul>
				</div>
			</dd>
			<!-- e: 참가자정보 -->
			<!-- s: 파트너정보 -->
			<dd>
				<p class="c_title">파트너 정보</p>
				<div class="info_list">
					<ul>
						<li>
							<span class="l_name">이 름</span>
							<span class="r_con">
                                <input  type="hidden"  name="p2idx" id="p2idx" value=""/> 
								<input type="text" class="ipt input_1" id="p2name" name="p2name" autocomplete="off" placeholder=":: 이름을 입력하세요 ::"   onfocus="this.select()"/>
							</span>
						</li>
			<!--			<li>
							<span class="l_name">등 급</span>
							<span class="r_con">
								<select class="ipt select_1" id="p2grade" name="p2grade">
									<option value="">선택</option>
									<option value="A" selected="">A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="E">E</option>
									<option value="F">F</option>
								</select>
							</span>
						</li>-->
						<li>
							<span class="l_name">대표소속</span>
							<span class="r_con">
                                <input  type="hidden"  name="p2team1" id="p2team1" value=""/> 
								<input type="text" class="ipt input_1" id="p2team1txt" name="p2team1txt"  placeholder=":: 대표소속명을 입력하세요 ::" autocomplete="off" onfocus="this.select()"/>
							</span>
						</li>
                        <li>
							<span class="l_name">추가소속</span>
							<span class="r_con">
                                <input  type="hidden"  name="p2team2" id="p2team2" value=""/> 
								<input type="text" class="ipt input_1" id="p2team2txt" name="p2team2txt"  placeholder=":: 추가소속명을 입력하세요 ::" autocomplete="off" onfocus="this.select()"/> 
							</span>
                        </li> 
						<li>
							<span class="l_name">핸 드 폰</span>
							<span class="r_con"> 
                                <input  type="hidden"  name="p2phone" id="p2phone" value=""/> 
					            <select class="ipt col_1" id="p2phone1" name="p2phone1"/>
						            <option value="010">010</option>
						            <option value="011">011</option>
						            <option value="016">016</option>
						            <option value="017">017</option>
						            <option value="018">018</option>
						            <option value="019">019</option>
					            </select>
								<span class="divn">-</span>
								<input type="password" class="ipt col_1" id="p2phone2" name="p2phone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off"/>
								<span class="divn">-</span>
								<input type="number" class="ipt col_1" id="p2phone3" name="p2phone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" onfocus="this.select()" autocomplete="off"/>
							</span>
						</li>
					</ul>
				</div>
			</dd>
			<!-- e: 파트너정보 -->
		</dl>
	</div>
	<!-- e: 참가자 정보 & 파트너 정보 -->
	<!-- s: 버튼 리스트 -->
    <% if ChekMode = 0 then  %>
	<div class="btn_list">
		<a href="javascript:chk_frm('10');" class="gray_btn">대회목록</a>
		<a href="javascript:chk_frm('12');" class="black_btn">참가신청내역</a>
		<a href="javascript:chk_frm('0');"  class="green_btn"  >신청완료</a>
	</div>
	<!-- s: 버튼리스트 -->
    <%else %>
	<!-- s: 버튼 리스트 -->
	<div class="s_btn_list">
		<a href="javascript:chk_frm('10');" class="gray_btn">대회목록</a>
		<a href="javascript:chk_frm('12');" class="black_btn">참가신청내역</a>
        <% if Ch_u ="Y" then  %>
		    <a href="javascript:chk_frm('1');" class="yello_btn">신청삭제</a>
        <% end if  %>
        <% if Ch_d ="Y" then  %>
		    <a href="javascript:chk_frm('2');" class="green_btn">수정하기</a>
        <% end if  %>
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
<!--<ul>
<li>
	<span class="l_name">입금일자</span>
	<span class="r_con">
		<input type="text" class="ipt input_1" placeholder="ex) 2017.01.01" id="inbankdate" name="inbankdate" value="">
	</span>
</li>
</ul>-->
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
		                        <input type="text" class="ipt input_1 ui-autocomplete-input" id="attname" name="attname" placeholder=":: 이름을 입력하세요 ::"  autocomplete="off" value=""    onfocus="this.select()">
	                        </span>
                        </li>
                        <li>
	                        <span class="l_name">휴대폰 번호</span>
	                        <span class="r_con">
                                <input  type="hidden"  name="attphone" id="attphone" value=""/> 
		                        <select class="ipt col_1" id="attphone1" name="attphone1">
			                        <option value="010">010</option>
			                        <option value="011">011</option>
			                        <option value="016">016</option>
			                        <option value="017">017</option>
			                        <option value="018">018</option>
			                        <option value="019">019</option>
		                        </select>
		                        <span class="divn">-</span>
		                        <input type="password" class="ipt col_1 phone_line" id="attphone2" name="attphone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);" value=""onfocus="this.select()" autocomplete="off">
		                        <span class="divn">-</span>
		                        <input type="number" class="ipt col_1 phone_line" id="attphone3" name="attphone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" value=""onfocus="this.select()" autocomplete="off">
	                        </span>
                        </li>
                        <li>
	                    <!-- s: 중요문구 -->
	                    <div class="text_box">
		                    <p class="red_font"><i class="fa fa-exclamation-circle" aria-hidden="true"></i>
                                <span>입금자명을 통해 입금 확인 절차가 진행됩니다. </span>
                            </p> 
	                    </div>
	                    <!-- e: 중요문구 -->
                        </li> 
			            <li>
				            <span class="l_name">입금자명</span>
				            <span class="r_con">
					            <input type="text" class="ipt input_1" id="inbankname" name="inbankname" value="" onfocus="this.select()"  placeholder=":: 이름을 입력하세요 ::"  autocomplete="off">
				            </span>
			            </li>
		            </ul>
	                <!-- s: 기타 건의내용 -->
	                <div class="etx_con">
		                <span class="big_title">기타 건의내용</span>
		                <textarea id="attask" name="attask"  placeholder=":: 기타 건의 내용 작성 란 입니다. ( 코트 배정 및 조편성 내용은 반영 되지 않습니다.) ::"></textarea>
	                </div>
	                <!-- e: 기타 건의내용 -->
                         
	                <div class="etx_con"> 
                            <ul>
                                <li>   
                                <p class="red_font"><i class="fa fa-exclamation-circle" aria-hidden="true"></i> <span>이게시물의 비밀번호를 입력하십시오.</span> </p> 
                                </li>
                                <li>
                                    <span class="l_name">비밀 번호</span>
	                            <span class="r_con">
                                    <input type="password" id="attpwd" name="attpwd" maxlength="20" class="ipt input_1" value="" autocomplete="off" onfocus="this.select()" >
							    <input style="display:none" type="text" name="fakeusernameremembered"/>
							    <input style="display:none" type="password" name="fakepasswordremembered"/>
                                </span>
                                </li>
                            </ul>
	                </div>
					<div class="btn_list">
						<% if ChekMode = 0 then  %> 
						<a href="javascript:chek_form_pass_data(0);" class="green_btn" id="FormInsert" >신청완료</a>
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
<!-- E: main -->
<!--#include file = "./include/mfoot.asp" -->