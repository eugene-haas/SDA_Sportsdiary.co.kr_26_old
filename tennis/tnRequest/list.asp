<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<!-- #include virtual = "/pub/fn/fn_tennis.asp" --> 
<%
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
%>

<link href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<script src="/ckeditor/ckeditor.js"></script>
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.min.js"></script> 
<script src="/pub/js/tennis_Request.js?ver=10" type="text/javascript"></script>
<script type="text/javascript">
    function chk_frm(val, vsGu) {
        var sf = document.search_frm;

        if (val == "FND") {
            sf.action = "./list.asp" + ver;
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
        var obja = INFO_Request;
        obja.CMD = mx_player.CMD_EDITOR;
        obja.tidx = vsGu;
        obja.title = vsGuNm;
        localStorage.setItem('INFO_Request', JSON.stringify(obja));
        mx_player.SendPacket("Modal_ContentsList", obja, "/pub/ajax/mobile/reqTennisatt.asp");
		//$("#yoyo").click();
        $("#aTcommit_game").click();
    }
</script>
<title>KATA Tennis 대회 참가신청</title>
</head>
<body class="lack_bg" id="AppBody">

<!-- S: header -->
<!-- #include file = "./include/header.asp" -->
<!-- E: header -->
<!-- S: main -->
<h1 class="page_title">참가접수중인 대회</h1>
<button id="aTcommit_game" class="green_btn" data-toggle="modal" data-target="#myModal_game"  style=" display:none;">신청완료</button>
<div class="l_apply_list">
    <!-- s: 검색 -->
    <form method="post" name="search_frm" id="search_frm" > 
    <input  type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX %>"/> 
    <input  type="hidden" name="GameTitleName" id="GameTitleName" value="<%=GameTitleName %>"/>
    <input  type="hidden" name="ChekMode" id="ChekMode" value="<%=ChekMode %>"/>
    </form>
    <!-- e: 검색 -->
    <!-- s: 대회 리스트 -->
    <div class="competition_list">

        <dl>
            <%

            sql_ch =" select a.GameTitleIDX,count(b.RequestIDX) ReqCnt " 
            sql_ch =sql_ch&" ,sum(case when SUBSTRING(a.cfg,2,1)='Y' then 1 else 0 end) ch_i "
            sql_ch =sql_ch&" ,sum(case when SUBSTRING(a.cfg,3,1)='Y' then 1 else 0 end) ch_u "
            sql_ch =sql_ch&" ,sum(case when SUBSTRING(a.cfg,4,1)='Y' then 1 else 0 end) ch_d "
            sql_ch =sql_ch&" from tblRGameLevel a left join tblGameRequest b on a.SportsGb = b.SportsGb and a.Level =b.Level and b.DelYN='N' "
            sql_ch =sql_ch&" where a.DelYN='N'and a.SportsGb='tennis' "
            sql_ch =sql_ch&" group by a.GameTitleIDX "

            Set Rs = Dbcon.Execute(sql_ch)
            If Not Rs.EOF Then 
                arrM = Rs.GetRows()
            End if

            YEARSQL = " select SportsGb,GameTitleIDX,GameTitleName,GameYear,convert(date,GameS,112) GameSm,convert(date,GameE,112) GameEm,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,ViewState,hostname,titleCode,titleGrade,GameArea " & _ 
                      "  ,sum(convert(bigint,chek_1))chek_1,sum(convert(bigint,chek_2))chek_2,sum(convert(bigint,chek_3))chek_3,sum(convert(bigint,chek_4))chek_4  " & _ 
                      "    from dbo.View_game_title_list a  " & _ 
                      "    where 1=1 " & _ 
                      "    and a.SportsGb='tennis' " & _ 
                      "    group by SportsGb,GameTitleIDX,GameTitleName,GameYear,GameS,GameE,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,ViewState,hostname,titleCode,titleGrade,GameArea"
                      '"    and (isnull('"&Years &"','')='' or '"&Years &"' is null or a.GameYear='"&Years &"' ) " & _ 
                       
            YEARSQL = YEARSQL & " order by GameS "
            GameSm=""
            Months=""
            Set YRs = Dbcon.Execute(YEARSQL)

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
                <dd>
            <!-- 버튼 안보임 -->
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
            <% if (YRs("ViewYN") ="Y" AND YRs("GameTitleIDX") <> "276") then   %> 
                    <% if Cdbl(YRs("chek_2")) >0 then  
                        if Months ="" then 
                            Months =Cdbl(GameSmStr(1))
                        end if                  
                    %>
                    <p class="list_title">[<%=gamegrade %>] <%=YRs("GameTitleName") %>
                        <input type="hidden"  id="GameTitleName_<%=YRs("GameTitleIDX") %>" name="GameTitleName_<%=YRs("GameTitleIDX") %>" value="<%=YRs("GameTitleName") %>" />
                    </p>
                    <div class="list_box">
                        <ul>  
                            <li>
                                <span class="l_name"></span>
                                <span class="r_con" style="text-align:right;padding-right:10px;">
                                    <a href="javascript:chk_frm('3','<%=YRs("GameTitleIDX") %>');" class="sm_btn green_btn">신청하기 </a>
                                    <a href="javascript:chk_frm('4','<%=YRs("GameTitleIDX") %>');" class="sm_btn yellow_btn">신청목록</a>   <%' if Cdbl(ch_reqc) >0 then  %>  <%' end if  %>
                                    <% if InStr(sUserAgent,"ANDROID") >0 or InStr(sUserAgent,"IPHONE") >0 then  %>
                                    <a href="http://m.ikata.org/bbs/board.php?bo_table=apply_modi" class="sm_btn red_btn">변경요청</a>
                                    <%else%>
                                    <a href="http://ikata.org/board/bbs/board.php?bo_table=apply_modi" class="sm_btn red_btn">변경요청</a>
                                    <%end if  %>
                                    

									<%
									 sql = "Select summary from sd_tennisTitle where gametitleidx = " & YRs("GameTitleIDX")
									 Set Rs = Dbcon.Execute(sql)
									%>
									<a href="<%=rs(0)%>" target="_blank" class="sm_btn yellow_btn">요강보기</a>
									<!-- <a href="javascript:Search_summary('<%=YRs("GameTitleIDX") %>','<%=YRs("GameTitleName") %>');" class="sm_btn yellow_btn">요강보기</a> -->



                                </span>
                            </li>
                        </ul>
                    </div>
                  <% end if  %>
            <% end if  %>
                </dd>
                <%
                YRs.MoveNext
                Loop 
            End If   
            %>







  <%If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then%>
                <dd>
                    <p class="list_title">[E] TEST
                        <input type="hidden"  id="GameTitleName_25" name="GameTitleName_25" value="입력테스트" />
                    </p>
                    <div class="list_box">
                        <ul>  
                            <li>
                                <span class="l_name"></span>
                                <span class="r_con" style="text-align:right;padding-right:10px;">
                                    <a href="javascript:chk_frm('3','25');" class="sm_btn green_btn">신청하기 </a>
                                    <a href="javascript:chk_frm('4','25');" class="sm_btn yellow_btn">신청목록</a>
                                    <% if InStr(sUserAgent,"ANDROID") >0 or InStr(sUserAgent,"IPHONE") >0 then  %>
                                    <a href="http://m.ikata.org/bbs/board.php?bo_table=apply_modi" class="sm_btn red_btn">변경요청</a>
                                    <%else%>
                                    <a href="http://ikata.org/board/bbs/board.php?bo_table=apply_modi" class="sm_btn red_btn">변경요청</a>
                                    <%end if  %>
                                    

									<%
									 sql = "Select summary from sd_tennisTitle where gametitleidx = " & 25
									 Set Rs = Dbcon.Execute(sql)
									%>
									<!-- <a href="<%=rs(0)%>" target="_blank" class="sm_btn yellow_btn">요강보기</a> -->
									<a href="javascript:Search_summary('25','입력테스트');" class="sm_btn yellow_btn">요강보기</a> 


                                </span>
                            </li>
                        </ul>
                    </div>
                </dd>
<%End if%>










        </dl>
        <!-- <a href="#" class="more_btn">더보기</a>-->
    </div>
    <div class="competition_list">
        <dl>
            <dd>
                    <p class="">
                        <div class="list_box">
                            <ul>  
                                <li>
                                    <span class="l_name"></span>
                                    <span class="r_con" style="text-align:right;padding-right:10px;">
                                    <%
                                   

                                     if InStr(sUserAgent,"ANDROID") >0 or InStr(sUserAgent,"IPHONE") >0 then 
                                        %>  <a href="http://m.ikata.org/bbs/board.php?bo_table=program" class="green_btn">대회일정</a><%
                                     else
                                        %>  <a href="http://ikata.org/board/bbs/board.php?bo_table=program&year=<%=Years%>&month=<%=months%>" class="green_btn">대회일정</a><%
                                     end if 
                                     %>
                                    <!-- <a href="javascript:chk_frm('5','');" class="green_btn">대회일정</a> -->
                                    <a href="javascript:chk_frm('6','');" class="big_btn red_btn">전체신청목록보기</a>
                                    </span>
                                </li> 
                            </ul>
                        </div>

                    </p>
            </dd>
            <dd>
                <p>
                    <div class="list_section_1">
                    <ul> 
                        <li>
                            <div class="text_box match_change_list">


								
								
								<h3> 참가신청 관련 안내 </h3> 

								<p> <span>* 참가신청 내역변경 및 취소</span> </p> 
                                <p> <span>신청내역 수정 및 취소는 신청목록에서 해당 신청 건을 검색하여</span> </p> 
                                <p> <span>신청시 설정한 비밀번호를 입력하고  직접 수정, 삭제하셔야 하며</span> </p> 
                                <p> <span>자유게시판, 변경요청게시판 등에 올리신 요청글은 반영되지 않습니다.</span> </p> 
                                <p> <span></span> </p> 
                                <p class="phone_call mt_10"> <span>* 참가신청 및 입금관련 문의</span> </p> 
                                <p class="phone_call"> <span>이정우 KATA 사무국장 (010-6390-5910)</span> </p> 


                            </div>
                        </li>
                        </ul>
                    </div>
                </p>
            </dd>
        </dl>
    </div>
    <!-- e: 대회 리스트 -->
</div>
<div class="modal fade write_moal" id="myModal_game" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
    <div class="modal-dialog" style="margin-top:-200px;top:50%;">
        <div class="modal-content" id="Modal_ContentsList" style="width:100%;max-width:800px;left:0;right:0;margin:auto;overflow-x:scroll;height:400px;"> 
        </div>
    </div>
</div>
<!-- E: main -->
<!--#include file = "./include/foot.asp" -->
