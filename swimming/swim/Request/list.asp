<!-- #include virtual = "/pub/header.swim.asp" -->
<!DOCTYPE html>
<html lang="ko-KR">
<head>
    <!--#include file = "./include/head.asp" -->
    <%
    Set db = new clsDBHelper


    sUserAgent=Ucase(Request.ServerVariables("HTTP_USER_AGENT"))
    Years     = fInject(Request("Years"))
    Months     = fInject(Request("Months"))
    GameTitleIDX     = fInject(Request("GameTitleIDX"))
    GameTitleName     = fInject(Request("GameTitleName"))
    ChekMode     = fInject(Request("ChekMode"))

    if Years="" then
        Years=year(date)
    End If

    If Months = "" Then
        Months = month(date)
    End if

    today = Date()

    If request.Cookies("SD") <> "" Then
'      Response.write 	Cookies_sdId & "<br>"
'      Response.write 	Cookies_sdBth & "<br>"
'      Response.write 	Cookies_sdNm & "<br>"
'      Response.write 	Cookies_sdPhone & "<br>"
'      Response.write 	Cookies_sdIdx & "<br>"
'      Response.write 	Cookies_sdSave & "<br>"
'      Response.write 	Cookies_sdSex & "<br>"
'     'Cookies_stateNo = "101"
'
'	Response.write LCase(URL_HOST & URL_PATH)
	%><!-- <a href="http://sdmain.sportsdiary.co.kr/sdmain/ajax/logout.asp">로그아웃</a> --><%
    End If

    %>
    <script src="/pub/js/swim/tennis_Request.js<%=CONST_JSVER%>" type="text/javascript"></script>
    <script type="text/javascript">
        function chk_frm(val, vsGu) {

    		//로그인 처리
    		<%If Cookies_sdId  ="" then%>
    			location.href="http://sdmain.sportsdiary.co.kr/sdmain/login.asp";
    			return;
    		<%End if%>


    		var sf = document.search_frm;

            if (val == "FND") {
                sf.action = "./list.asp" + ver;


            } else if (val == 20) {
                //선수정보 수정 요청
                $("#aT_player_update").click();
                var obja = {};
                obja.CMD = mx_player.CMD_player_bbsEditor;
                obja.idx = bbsidx;
                obja.tidx = vsGu;//$("#GameTitleIDX").val();
                obja.levelno = "";//$("#levelno").val();
                obja.ridx = "";//$("#ridx").val();
                mx_player.SendPacket("Modal_ContentsListP", obja, mx_player.ajaxURL);
    			return;

            } else if (val == 21) {
                //선수정보 수정 저장
                var obja = {};
                obja.CMD = mx_player.CMD_player_bbsEditorOK;
                obja.idx = bbsidx;
                obja.tidx = vsGu;//$("#GameTitleIDX").val();
                obja.levelno = "";//$("#levelno").val();
                obja.ridx = "";//$("#ridx").val();
                obja.CONTENTS = $("#playeredit").val();
                mx_player.SendPacket("Modal_ContentsListP", obja, mx_player.ajaxURL);
                $("#aT_player_update").click();
    			return;



    		} else {
                $("#GameTitleIDX").val(vsGu);
                $("#GameTitleName").val($("#GameTitleName_" + vsGu).val());
                $("#ChekMode").val(0);

                var obja = {}; //INFO_Request;
                obja.CMD = mx_player.CMD_PageMove;
                obja.GameTitleIDX = $("#GameTitleIDX").val();
                obja.GameTitleName = $("#GameTitleName").val();
                obja.tidx = $("#GameTitleIDX").val();
                obja.title = $("#GameTitleName").val();
                obja.Years = $("#Years").val();
                obja.Months = $("#Months").val();

                if (val == 1) {
                    sf.action = "./write.asp" + ver;
                    $("#ChekMode").val(0);
                    obja.ChekMode = $("#ChekMode").val();
                }

                if (val == 2) {
                    sf.action = "./list_repair.asp" + ver;
                }

                if (val == 3) {
					<%'##################%>
					//alert("참가 신청기간이 아님니다.");
					//return;
					<%'##################%>
                    sf.action = "./write.asp" + ver;
                    obja.ChekMode = $("#ChekMode").val();
                    $("#ChekMode").val(0);
                }

                if (val == 4) {
                    sf.action = "./info_list.asp" + ver + "&tidx=" + vsGu;
                    $("#ChekMode").val(1);
                    obja.ChekMode = $("#ChekMode").val();
                }

                if (val == 5) {
                    sf.action = "./list_game.asp" + ver;
                    $("#ChekMode").val(1);
                    obja.ChekMode = $("#ChekMode").val();
                }

                if (val == 6) {
                    sf.action = "./info_list.asp" + ver;
                    $("#ChekMode").val(1);
                    obja.Years = "";
                    obja.Months = "";
                    obja.GameTitleIDX = "";
                    obja.GameTitleName = "";
                    obja.tidx = "";
                    obja.title = "";
                    obja.ChekMode = $("#ChekMode").val();
                }
                localStorage.setItem('INFO_Request', JSON.stringify(obja));
            }
            sf.submit();
        }

        function Search_summary(vsGu, vsGuNm) {
            //Modal_ContentsList
            /*내용 조회*/
            // var obja = INFO_Request;
            // obja.CMD = mx_player.CMD_EDITOR;
            // obja.tidx = vsGu;
            // obja.title = vsGuNm;
            // localStorage.setItem('INFO_Request', JSON.stringify(obja));
            // mx_player.SendPacket("Modal_ContentsList", obja, mx_player.ajaxURL);

    		//$("#yoyo").click();
            $("#aTcommit_game").click();
        }
    </script>
</head>
<body id="AppBody">
<div class="l">


    <button id="aT_player_update" class="green_btn" data-toggle="modal" data-target="#myModal_game2" style="display:none;"></button>
    <button id="aTcommit_game" class="green_btn" data-toggle="modal" data-target="#myModal_game" style="display:none;">신청완료</button>

    <div class="l_header">
      <div class="m_header">
        <!-- #include file="./include/header_back.asp" -->
        <h1 class="m_header__tit">참가접수중인 대회</h1>
      </div>
    </div>

    <!-- S: main -->
    <div class="l_content m_scroll entryCompetitionList [ _content _scroll ]">

        <!-- s: 검색 -->
        <form method="post" name="search_frm" id="search_frm" >
          <input  type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX %>"/>
          <input  type="hidden" name="GameTitleName" id="GameTitleName" value="<%=GameTitleName %>"/>
          <input  type="hidden" name="ChekMode" id="ChekMode" value="<%=ChekMode %>"/>
        </form>
        <!-- e: 검색 -->

        <!-- s: 대회 리스트 -->
        <div class="">

            <ul class="competitionList">
                <%

                SQL =" select a.GameTitleIDX,count(b.RequestIDX) ReqCnt "
                SQL =SQL&" ,sum(case when SUBSTRING(a.cfg,2,1)='Y' then 1 else 0 end) ch_i "
                SQL =SQL&" ,sum(case when SUBSTRING(a.cfg,3,1)='Y' then 1 else 0 end) ch_u "
                SQL =SQL&" ,sum(case when SUBSTRING(a.cfg,4,1)='Y' then 1 else 0 end) ch_d "
                SQL =SQL&" from tblRGameLevel a left join tblGameRequest b on a.SportsGb = b.SportsGb and a.Level =b.Level and b.DelYN='N' "
                SQL =SQL&" where a.DelYN='N'and a.SportsGb='tennis' "
                SQL =SQL&" group by a.GameTitleIDX "
    		    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
                If Not Rs.EOF Then
                    arrM = Rs.GetRows()
                End if

                SQL = " select SportsGb,GameTitleIDX,GameTitleName,GameYear,convert(date,GameS,112) GameSm,convert(date,GameE,112) GameEm,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,ViewState,hostname,titleCode,titleGrade,GameArea " & _
                          "  ,sum(convert(bigint,chek_1))chek_1,sum(convert(bigint,chek_2))chek_2,sum(convert(bigint,chek_3))chek_3,sum(convert(bigint,chek_4))chek_4  " & _
                          "    from dbo.View_game_title_list a  " & _
                          "    where 1=1 " & _
                          "    and a.SportsGb='tennis' " & _
                          "    group by SportsGb,GameTitleIDX,GameTitleName,GameYear,GameS,GameE,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,ViewState,hostname,titleCode,titleGrade,GameArea"
                SQL = SQL & " order by GameS "
                GameSm=""
                Months=""
                'Set YRs = Dbcon.Execute(YEARSQL)
    		    Set yrs = db.ExecSQLReturnRS(SQL , null, ConStr)

                If Not(YRs.Eof Or YRs.Bof) Then
                    Do Until YRs.Eof
                        gamercvdate  =  YRs("GameRcvDateE")
                        gamegrade = findGrade(YRs("titleGrade"))
                        gamegrade = gamegrade '&"그룹"
    					if GameSm<> YRs("GameSm") then
    						GameSmStr=  Split(YRs("GameSm"),"-")
    					end if
                    GameSm = YRs("GameSm")
                    %>
                    <%
                    ch_i=0
                    ch_u=0
                    ch_d=0
                    ch_reqc =0
                    If IsArray(arrM) Then '플레이어 1로만 구분
                        For arp = LBound(arrM, 2) To UBound(arrM, 2)
                            if Cdbl(YRs("GameTitleIDX")) = Cdbl(arrM(0, arp)) then
                                ch_reqc=ch_reqc +  Cdbl(arrM(1, arp))
                                ch_i =ch_i +  Cdbl(arrM(2, arp))
                                ch_u =ch_u +  Cdbl(arrM(3, arp))
                                ch_d =ch_d +  Cdbl(arrM(4, arp))
                            end if
                        Next
                    End if
                    %>
                <% if YRs("ViewYN") ="Y"  then   %>
                    <% if Cdbl(YRs("chek_2")) >0 then
                        if Months ="" then
                            Months =Cdbl(GameSmStr(1))
                        end if
                    %>
                    <li>
                        <p class="competitionList__tit">[<%=gamegrade %>] <%=YRs("GameTitleName") %>
                            <input type="hidden" id="GameTitleName_<%=YRs("GameTitleIDX") %>" name="GameTitleName_<%=YRs("GameTitleIDX") %>" value="<%=YRs("GameTitleName") %>" />
                        </p>
                        <div class="competitionList__btnWrap">

                            <a href="javascript:chk_frm('3','<%=YRs("GameTitleIDX") %>');" class="competitionList__btn s_apply">신청하기 </a>
                            <a href="javascript:chk_frm('4','<%=YRs("GameTitleIDX") %>');" class="competitionList__btn s_result">신청내역</a>   <%' if Cdbl(ch_reqc) >0 then  %>  <%' end if  %>

							<% if InStr(sUserAgent,"ANDROID") >0 or InStr(sUserAgent,"IPHONE") >0 then  %>
                            <a href="javascript:chk_frm('20',<%=YRs("GameTitleIDX") %>);" class="competitionList__btn s_modify">변경요청</a>
                            <%else%>
                            <a href="javascript:chk_frm('20',<%=YRs("GameTitleIDX") %>);" class="competitionList__btn s_modify">변경요청</a>
                            <%end if  %>


							<%
							 SQL = "Select summary from sd_tennisTitle where gametitleidx = " & YRs("GameTitleIDX")
				 		    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
							%>
							<a href="javascript:Search_summary('<%=YRs("GameTitleIDX") %>','<%=YRs("GameTitleName") %>');" class="competitionList__btn s_summary sm_btn yellow_btn">요강보기</a>

                        </div>
                      <% end if  %>
                <% end if  %>
                    </li>
                    <%
                    YRs.MoveNext
                    Loop
                End If
                %>


    <%If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240-" Then '테스트 대회보기%>
                    <li>
                        <p class="competitionList__title">[E] TEST
                            <input type="hidden"  id="GameTitleName_25" name="GameTitleName_25" value="입력테스트" />
                        </p>
                        <div class="competitionList__btnWrap">
                            <a href="javascript:chk_frm('3','25');" class="competitionList__btn s_apply">신청하기 </a>
                            <a href="javascript:chk_frm('4','25');" class="competitionList__btn s_result">신청내역</a>
                            <% if InStr(sUserAgent,"ANDROID") >0 or InStr(sUserAgent,"IPHONE") >0 then  %>
                            <a href="http://m.ikata.org/bbs/board.php?bo_table=apply_modi" class="competitionList__btn s_modify">변경요청</a>
                            <%else%>
                            <a href="http://ikata.org/board/bbs/board.php?bo_table=apply_modi" class="competitionList__btn s_modify">변경요청</a>
                            <%end if  %>


    						<%
    						 SQL = "Select summary from sd_tennisTitle where gametitleidx = " & 25
    						 Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    						%>
    						<!-- <a href="<%=rs(0)%>" target="_blank" class="sm_btn yellow_btn">요강보기</a> -->
    						<a href="javascript:Search_summary('25','입력테스트');" class="competitionList__btn s_summary">요강보기</a>
                        </div>
                    </li>
    <%End if%>


            </ul>
            <!-- <a href="#" class="more_btn">더보기</a>-->
        </div>
        <!-- e: 대회 리스트 -->

        <div class="m_horizon"></div>

        <div class="m_reqBtnWrap">
          <%if InStr(sUserAgent,"ANDROID") >0 or InStr(sUserAgent,"IPHONE") >0 then%>
			      <a href="http://tennis.sportsdiary.co.kr/tennis/TSM_Player/Result/institute-search.asp" class="m_reqBtnWrap__btn s_schedule" data-toggle="modal" data-target="#myModal_game3">대회일정</a>
          <%else%>
            <a href="http://tennis.sportsdiary.co.kr/tennis/TSM_Player/Result/institute-search.asp" class="m_reqBtnWrap__btn s_schedule" data-toggle="modal" data-target="#myModal_game3">대회일정</a>
          <%end if%>

          <a href="javascript:chk_frm('6','');" class="m_reqBtnWrap__btn s_apply">전체신청내역보기</a>
        </div>

        <div class="m_horizon"></div>

        <div class="entryInfo">
          <h3 class="entryInfo__tit"> 대회참가신청 안내 </h3>
          <p class="entryInfo__txt s_indent"> <span>*스포츠다이어리 APP에 회원가입을 해야 대회참가신청이 가능합니다.</span> </p>
          <p class="entryInfo__txt s_indent"> <span>*대회참가신청취소 및 변경요청은 참가신청 기간 내에만 가능합니다.</span> </p>
          <p class="entryInfo__txt s_indent"> <span>*참가비 입금 시, 입금자명을 입력해주시기바랍니다.</span> </p>
          <p class="entryInfo__txt s_indent"> <span>*신청내역이 확인안되는 동호인은 아래의 연락처로 문의바랍니다.</span> </p>

          <p class="entryInfo__txt">
            <span><문의전화></span><br />
            <span>스포츠다이어리 고객센터 : 02-704-0282</span><br />
            <span>운영시간 : 평일 9:00 ~ 18:00</span><br />
            <span>(점심시간 12:00 ~ 13:00)</span><br />
          </p>
        </div>

    </div>

    <!-- 대회 요강 모달 -->
    <div class="modal fade m_reqModal" id="myModal_game" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh">
        <div class="modal-dialog">
            <div class="modal-content" >
                <div class="modal-header m_reqModal__header">
                    <button type="button" class="m_reqModal__close" data-dismiss="modal" aria-hidden='true'> <span aria-hidden="true">&times;</span> </button>
                    <h2 id='myModalLabel' class="m_reqModal__tit">대회요강</h2>
                </div>
                <div class="modal-body competitionSummaryModal">
                    <div id="Modal_ContentsList" class="summaryContent">

                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_01.png?3" class="summaryContent__img"/>
                      <hr />
                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_02.png?3" class="summaryContent__img"/>
                      <hr />
                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_03.png?3" class="summaryContent__img"/>
                      <hr />
                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_04.png?3" class="summaryContent__img"/>
                      <hr />
                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_05.png?3" class="summaryContent__img"/>
                      <hr />
                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_06.png?3" class="summaryContent__img"/>
                      <hr />
                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_07.png?3" class="summaryContent__img"/>
                      <hr />
                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_08.png?3" class="summaryContent__img"/>
                      <hr />
                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_09.png?3" class="summaryContent__img"/>
                      <hr />
                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_10.png?3" class="summaryContent__img"/>
                      <hr />
                      <img src="http://img.sportsdiary.co.kr/images/etc/sw/sw_globalfestival_11.png?3" class="summaryContent__img"/>
                    </div>

                    <div class="m_reqModal__btnWrap">
                      <a class="m_reqModal__btn s_close" data-dismiss="modal" aria-hidden="true">닫기</a>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <!-- 선수정보 변경 요청 모달 -->
    <div class="modal fade m_reqModal" id="myModal_game2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header m_reqModal__header">
                    <button type="button" class="m_reqModal__close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
                    <h2 class="m_reqModal__tit">선수정보 변경 요청</h2>
                </div>
                <div class="modal-body infoModifyModal">
                    <div class="m_infoTxt">
                        <p class="m_infoTxt__txt">*선수정보수정요청 완료후에도 기존정보로 참가신청이 가능합니다.</p>
                        <!-- <p class="m_infoTxt__txt s_empahsis">*선수명과 전화번호 미 입력시 변경 불가합니다.반드시 이름과 전화번호를 입력해주세요.</p> -->
                    </div>

                    <div id="Modal_ContentsListP" class="infoModify"></div>

                    <div class="m_reqModal__btnWrap">
                        <a class="m_reqModal__btn s_close" data-dismiss="modal" aria-hidden="true">닫기</a>
                        <a href="javascript:chk_frm('21');" class="m_reqModal__btn s_confirm" >변경요청</a>
                    </div>

                </div>

            </div>
        </div>
    </div>

    <!-- 대회일정 모달 -->
    <div class="modal fade m_reqModal" id="myModal_game3" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header m_reqModal__header">
                    <button type="button" class="m_reqModal__close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
                    <h2 class="m_reqModal__tit">대회일정</h2>
                </div>
                <div class="modal-body scheduleModal">
                    <div id="">
                      <h3 class="schedule__header"><span class="schedule__headerTxt">2019년도 대회일정</span></h3>
                      <ul class="schedule__list">
                          <li class="schedule__item">
                              <h4 class="schedule__itemTit">5월</h4>
                              <div class="schedule__itemTxtWrap">
                                <p class="schedule__itemTxt">- 5.19(일) 제7회 송파구연맹회장기 수영대회</p>
                              </div>
                          </li>
                          <li class="schedule__item">
                              <h4 class="schedule__itemTit">8월</h4>
                              <div class="schedule__itemTxtWrap">
                                <p class="schedule__itemTxt">- 8.18(일) 글로벌 페스티벌 2019 한강크로스위밍챌린지 대회</p>
                              </div>
                          </li>
                          <li class="schedule__item">
                              <h4 class="schedule__itemTit">11월</h4>
                              <div class="schedule__itemTxtWrap">
                                <p class="schedule__itemTxt">- 11.3(일) 제4회 송파구청장기 수영대회</p>
                              </div>
                          </li>
                      </ul>

                    </div>
                    <div class="m_reqModal__btnWrap">
                        <a class="m_reqModal__btn s_close" data-dismiss="modal" aria-hidden="true">닫기</a>
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
