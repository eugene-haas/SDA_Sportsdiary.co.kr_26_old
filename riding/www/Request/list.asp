<!-- #include virtual = "/pub/header.riding.asp" -->
<!DOCTYPE html>
<html lang="ko-KR">
<head>
    <!--#include file = "./include/config.asp" -->
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

'    If request.Cookies("SD") <> "" Then
'      Response.write 	Cookies_sdId & "<br>"
'      Response.write 	Cookies_sdBth & "<br>"
'      Response.write 	Cookies_sdNm & "<br>"
'      Response.write 	Cookies_sdPhone & "<br>"
'      Response.write 	Cookies_sdIdx & "<br>"
'      Response.write 	Cookies_sdSave & "<br>"
'      Response.write 	Cookies_sdSex & "<br>"
'	Response.write "<a href=""http://sdmain.sportsdiary.co.kr/sdmain/ajax/logout.asp"">로그아웃</a>"
'    End If
'	Response.write URL_HOST
  
    iLIUserID = Request.Cookies("SD")("UserID")
    iLIMemberIDX = Request.Cookies("SD")("MemberIDX")
    iLIMemberIDXd = decode(Request.Cookies("SD")("MemberIDX"),0)
    iLISportsGb = "tennis"

    LocateIDX_1 = "72"
  	'LocateIDX_2 = "71"
  	'LocateIDX_3 = "8"

    'response.Write iLIUserID&", "&iLIMemberIDX&", "&iLIMemberIDXd&", "&iLISportsGb

  %>

  <script src="js/common.js"></script>
    <script src="/pub/js/riding/tennis_Request.js<%=CONST_JSVER%>" type="text/javascript"></script>
    <script type="text/javascript">
        function chk_frm(val, vsGu) {

    		//로그인 처리
    		<%If Cookies_sdId  ="" then%>
    			location.href="http://sdmain.sportsdiary.co.kr/sdmain/login.asp";
    			return;
    		<%End if%>

			<%if Cookies_stateNo = "1" then  'tblPlayer.stateNO 상태 : 0 기본 / 1 박탈 /  원스타승급 100 승급  / 200 투스타 승급 /201( 투스타 승급박탈 ) %>
			//영구박탈자
			//alert("대회현장 조치에 따라 참가 자격이 박탈 되었습니다.");
			//return;
			<%end if%>

			<%if Cookies_stateNo = "201" then  'tblPlayer.stateNO 상태 : 0 기본 / 1 박탈 /  원스타승급 100 승급  / 200 투스타 승급 /201( 투스타 승급박탈 )%>
			//영구박탈자
			//alert("전전도 투스타 우승 3회로 더이상 대회에 참여하실수 없습니다.");
			//return;
			<%end if%>

			<%if Cookies_kata = "Y" then%>
			//카타참가자 여부확인
			//alert("KATA 참가이력자이 있어 참가가 불가 합니다.");
			//return;
			<%end if%>


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

                if (val == 3) {
                    sf.action = "./write.asp" + ver;
                    obja.ChekMode = $("#ChekMode").val();
                    $("#ChekMode").val(0);
                }

                if (val == 4) {
                    sf.action = "./info_list.asp" + ver + "&tidx=" + vsGu;
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
            var obja = INFO_Request;
            obja.CMD = mx_player.CMD_EDITOR;
            obja.tidx = vsGu;
            obja.title = vsGuNm;
            localStorage.setItem('INFO_Request', JSON.stringify(obja));
            mx_player.SendPacket("Modal_ContentsList", obja, mx_player.ajaxURL);

    		//$("#yoyo").click();
            $("#aTcommit_game").click();
        }
    </script>
</head>
<body id="AppBody">
    <button id="aT_player_update" class="green_btn" data-toggle="modal" data-target="#myModal_game2" style="display:none;"></button>
    <button id="aTcommit_game" class="green_btn" data-toggle="modal" data-target="#myModal_game" style="display:none;">신청완료</button>

    <!-- S: sub-header -->
    <div class="sd-header sd-header-sub">
        <!-- #include file="./include/sub_header_arrow.asp" -->
        <h1>참가접수중인 대회</h1>
        <!-- #include file="./include/sub_header_right.asp" -->
    </div>
    <!-- E: sub-header -->


    <!-- S: main -->
    <div class="entryCompetitionList sd-scroll [ _sd-scroll ]">

  <!-- S: main banner 01 -->
  <%
		  bnSource = Stream_BinaryToString( GetHTTPFile("http://tennis.sportsdiary.co.kr/pub/banner.asp?bntype=1&bngb=tennis&bnidx=72") , "utf-8" )
		  Response.write bnSource
  %>
  <!-- E: main banner 01 -->

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

                'Set Rs = Dbcon.Execute(sql_ch)
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
                          '"    and (isnull('"&Years &"','')='' or '"&Years &"' is null or a.GameYear='"&Years &"' ) " & _

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
                        <p class="competitionList__tit"><!-- [<%=gamegrade %>] --> <%=YRs("GameTitleName") %>
                            <input type="hidden" id="GameTitleName_<%=YRs("GameTitleIDX") %>" name="GameTitleName_<%=YRs("GameTitleIDX") %>" value="<%=YRs("GameTitleName") %>" />
                        </p>
                        <div class="competitionList__btnWrap">

                            <a href="javascript:chk_frm('3','<%=YRs("GameTitleIDX") %>');" class="competitionList__btn s_apply">신청하기 </a>
                            <a href="javascript:chk_frm('4','<%=YRs("GameTitleIDX") %>');" class="competitionList__btn s_result">신청내역</a>   <%' if Cdbl(ch_reqc) >0 then  %>  <%' end if  %>

							<% if InStr(sUserAgent,"ANDROID") >0 or InStr(sUserAgent,"IPHONE") >0 then  %>
                            <a href="javascript:chk_frm('20',<%=YRs("GameTitleIDX") %>);" class="competitionList__btn s_modify">변경요청</a>
							<!-- <a href="http://m.ikata.org/bbs/board.php?bo_table=apply_modi" class="sm_btn red_btn">변경요청</a> -->
                            <%else%>
                            <a href="javascript:chk_frm('20',<%=YRs("GameTitleIDX") %>);" class="competitionList__btn s_modify">변경요청</a>
							<!-- <a href="http://ikata.org/board/bbs/board.php?bo_table=apply_modi" class="sm_btn red_btn">변경요청</a> -->
                            <%end if  %>


							<%
							 SQL = "Select summary from sd_tennisTitle where gametitleidx = " & YRs("GameTitleIDX")
							 'Set Rs = Dbcon.Execute(sql)
				 		    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
							%>
							<!-- <a href="<%=rs(0)%>" target="_blank" class="sm_btn yellow_btn">요강보기</a> -->
							<!-- <a href="javascript:Search_summary('<%=YRs("GameTitleIDX") %>','<%=YRs("GameTitleName") %>');" class="competitionList__btn s_summary sm_btn yellow_btn">요강보기</a> -->
							<a href="http://tennis.sportsdiary.co.kr/tennis/TSM_Player/result/rookietennis_info_detail.asp" class="competitionList__btn s_summary sm_btn yellow_btn">요강보기</a>
                        </div>
                      <% end if  %>
                <% end if  %>
                    </li>
                    <%
                    YRs.MoveNext
                    Loop
                End If
                %>



            </ul>
            <!-- <a href="#" class="more_btn">더보기</a>-->
        </div>
        <!-- e: 대회 리스트 -->

        <div class="o_horizon"></div>

        <div class="te_reqBtnWrap">
            <%if InStr(sUserAgent,"ANDROID") >0 or InStr(sUserAgent,"IPHONE") >0 then%>
                <!--
				http://tennis.sportsdiary.co.kr/tennis/TSM_Player/Result/institute-search.asp?SearchDate=2019-01-23&GameTitleIDX=119
				list_game.asp?Years=<%=Years%>&Months=<%=months%>
				-->
				<a href="http://tennis.sportsdiary.co.kr/tennis/TSM_Player/Result/institute-search.asp" class="te_reqBtnWrap__btn s_schedule">대회일정</a>
            <%else%>
                <a href="http://tennis.sportsdiary.co.kr/tennis/TSM_Player/Result/institute-search.asp" class="te_reqBtnWrap__btn s_schedule">대회일정</a>
            <%end if%>

            <!-- <a href="javascript:chk_frm('5','');" class="green_btn">대회일정</a> -->
            <a href="javascript:chk_frm('6','');" class="te_reqBtnWrap__btn s_apply">전체신청내역보기</a>
        </div>

        <div class="o_horizon"></div>

        <div class="entryInfo">
            <h3 class="entryInfo__tit"> 대회참가신청 변경안내 </h3>
            <p class="entryInfo__txt s_indent"> <span>*SD랭킹 승마챔피언십 대회참가신청은 스포츠다이어리 회원가입이 필수입니다.</span> </p>
            <p class="entryInfo__txt s_indent"> <span>*파트너에게도 스포츠다이어리 회원가입을 권장바랍니다.</span> </p>
            <p class="entryInfo__txt s_indent"> <span>*파트너 변경 및 신청취소는 참가신청 기간중에만 가능합니다.</span> </p>

            <p class="entryInfo__txt s_indent"> <span>*대진추첨 이후 참가신청 취소 또는 대회당일 불참팀은 참가비 환불 불가합니다.</span> </p>
            <p class="entryInfo__txt s_indent"> <span>*신청내역확인시 신청자(참가자) 휴대폰번호 뒤4자리 입력바랍니다.</span> </p>
            <p class="entryInfo__txt s_indent"> <span>*참가비 입금후 신청취소를 할 경우 취소일부터 3일이내로 환불처리됩니다. (가상계좌시스템 확인 후 내용변경여부 있음)</span> </p>
            <p class="entryInfo__txt s_indent"> <span>*대회장에서의 추가신청 및 파트너변경은 불가합니다.</span> </p>
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
    <div class="modal fade te_reqModal" id="myModal_game" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh">
        <div class="modal-dialog">
            <div class="modal-content" >
                <div class="modal-header te_reqModal__header">
                    <button type="button" class="te_reqModal__close" data-dismiss="modal" aria-hidden='true'> <span aria-hidden="true">&times;</span> </button>
                    <h2 id='myModalLabel' class="te_reqModal__tit">대회요강</h2>
                </div>
                <div class="modal-body competitionSummaryModal">
                    <div id="Modal_ContentsList" class="summaryContent"></div>
                </div>
            </div>
        </div>
    </div>


    <!-- 선수정보 변경 요청 모달 -->
    <div class="modal fade te_reqModal" id="myModal_game2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header te_reqModal__header">
                    <button type="button" class="te_reqModal__close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button>
                    <h2 class="te_reqModal__tit">선수정보 변경 요청</h2>
                </div>
                <div class="modal-body infoModifyModal">
                    <div class="m_infoTxt">
                        <p class="m_infoTxt__txt">*선수정보수정요청 완료후에도 기존정보로 참가신청이 가능합니다.</p>
                        <p class="m_infoTxt__txt s_empahsis">*선수명과 전화번호 미 입력시 변경 불가합니다.반드시 이름과 전화번호를 입력해주세요.</p>
                    </div>

                    <div id="Modal_ContentsListP" class="infoModify"></div>

                    <div class="te_reqModal__btnWrap">
                        <a class="te_reqModal__btn s_close" data-dismiss="modal" aria-hidden="true">닫기</a>
                        <a href="javascript:chk_frm('21');" class="te_reqModal__btn s_confirm" >변경요청</a>
                    </div>

                </div>

            </div>
        </div>
    </div>



    <!-- E: main -->
    <!--#include file = "./include/foot.asp" -->

    <script>
      var $bxSlider = $('.bxslider:not(.modal-dialog .bxslider)');
      $bxSlider.each(function(index,element){
        var slider = $(element).bxSlider({
          pager: false,
          auto: true,
          pause: 3000,
          width: "auto",
          control:true,
          onSlideAfter: function() {
              slider.stopAuto();
              slider.startAuto();
          }
        });
      });
    </script>
</body>
</html>
