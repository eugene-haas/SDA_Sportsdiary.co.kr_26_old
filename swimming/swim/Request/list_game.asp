<!-- #include virtual = "/pub/header.swim.asp" -->


<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->
<%
  Set db = new clsDBHelper


Years     = fInject(Request("Years"))
Months     = fInject(Request("Months"))
GameTitleIDX     = fInject(Request("GameTitleIDX"))
GameTitleName     = fInject(Request("GameTitleName"))
ChekMode     = fInject(Request("ChekMode"))

if Years="" then
    Years=year(date)
End If

today = Date()
%>

<link href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<%'<script src="/ckeditor/ckeditor.js"></script>%>
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.min.js"></script>
<script src="/pub/js/swim/tennis_Request.js<%=CONST_JSVER%>" type="text/javascript"></script>

<script type="text/javascript">
    function chk_frm(val, vsGu) {
        var sf = document.search_frm;

        if (val == "FND") {
            sf.action = "./list_game.asp" + ver;
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

            if (val == 0) {
                sf.action = "./list.asp" + ver;
                obja.GameTitleIDX = "";
                obja.GameTitleName = "";
                obja.tidx = "";
                obja.title = "";
                obja.Years = "";
                obja.Months = "";
                $("#ChekMode").val(0);
                obja.ChekMode = $("#ChekMode").val();
            }
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
                sf.action = "./info_list.asp" + ver;
                $("#ChekMode").val(1);
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
<h1 class="page_title">
	<a href="javascript:chk_frm(0,'');" class="" >
		<i class="fa fa-angle-left" aria-hidden="true"></i>
	</a>대회일정</h1>
<button id="aTcommit_game" class="green_btn" data-toggle="modal" data-target="#myModal_game"  style="display:none;">신청완료</button>
<div class="l_apply_list">
	<!-- s: 검색 -->
    <form method="post" name="search_frm" id="search_frm" >
    	<div class="search_box">
    		<ul>
    			<li class="li_search_box">
    				<select id="Years" name="Years" class="r_con"  onchange="javascript:chk_frm('FND',0);" >
    				<% SQL = " select GameYear    From sd_TennisTitle   where  isnull(GameYear,'')<>'' and ViewYN='Y' group by GameYear  ORDER BY GameYear DESC "
    					Set yrs = db.ExecSQLReturnRS(SQL , null, ConStr)
    					If Not(YRs.Eof Or YRs.Bof) Then
    						Do Until YRs.Eof  %>
    								<option value="<%=YRs("GameYear")%>" <%If YRs("GameYear") = Years Then %>selected<% Years= YRs("GameYear") %><% End If%> >  <%=YRs("GameYear")%> 년</option> <%
    					    YRs.MoveNext
    						Loop
    					End If
    				 %>
    				</select>
    			</li>
    			<li class="li_search_box">
    				<select id="Months" name="Months" class="r_con"  onchange="javascript:chk_frm('FND',0);" >
    						<option value="" <%if Months = "" then %> selected  <%end if%> >:: 전체 ::</option>
    					 <%for i=1 to 12
    							 if i <10 then
    								Month_1 = "0"&i
    							 else
    								Month_1 = ""&i
    							 end if
    					 %>
    						<option value="<%=Month_1 %>" <%if Month_1 = Months then %> selected  <%end if%> > <%=Month_1 %> 월</option>
    					 <%next %>
    				</select>
                     <input  type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX %>"/>
                     <input  type="hidden" name="GameTitleName" id="GameTitleName" value="<%=GameTitleName %>"/>
                     <input  type="hidden" name="ChekMode" id="ChekMode" value="<%=ChekMode %>"/>
    			</li>
    		</ul>
    	</div>
    </form>
	<!-- e: 검색 -->
	<!-- s: 대회 리스트 -->
	<div class="competition_list">
		<dl>
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

            SQL = " select convert(date ,a.GameS)GameS " & _
                       "  ,convert(date ,a.GameE)GameE " & _
                       "  ,a.GameRcvDateS,a.GameRcvDateE " & _
                       "  ,left(convert(date ,a.GameS),7) GameSm,left(convert(date ,a.GameE),7) GameEm" & _
                       "  ,a.GameTitleIDX,a.stateNo,a.GameTitleName,a.GameYear,a.GameArea,a.SidoCode,a.EnterType,a.GameTitleLevel" & _
                       "  ,a.ViewYN,a.MatchYN,a.ViewState,a.cfg,a.hostname,a.titleCode,a.titleGrade,isnull(a.summary,'')summary " & _
                       "  from sd_TennisTitle a" & _
                       "  where a.DelYN='N'  and ViewState='Y'  and a.GameRcvDateE <> '' " 'and  a.ViewYN='Y'

            ' response.Write SQL
            if Months="" then
            SQL=SQL& "  and a.GameYear='"&Years &"' "
            else
            SQL=SQL& "  and (left(convert(date ,a.GameS),7)<='"&Years&"'+'-'+'"&Months&"' and left(convert(date ,a.GameE),7)>='"&Years&"'+'-'+'"&Months&"' ) "
            end if
            SQL=SQL& " order by GameS"

            if  cdbl(month(date))>=10 then
                SQL=SQL& " desc"
            end if


            GameSm=""
			Set yrs = db.ExecSQLReturnRS(SQL , null, ConStr)

            If Not(YRs.Eof Or YRs.Bof) Then
	            Do Until YRs.Eof
					gamercvdate  =  YRs("GameRcvDateE")

                if GameSm<> YRs("GameSm") then
                    GameSmStr=  Split(YRs("GameSm"),"-")
                %>
                    <dd>
                        <p class="list_titlemonth"> <%=GameSmStr(0) %>년 <%=GameSmStr(1) %>월</p>
                    </dd>
                <%
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
					<p class="list_title"><%=YRs("GameTitleName") %>
                        <input type="hidden"  id="GameTitleName_<%=YRs("GameTitleIDX") %>" name="GameTitleName_<%=YRs("GameTitleIDX") %>" value="<%=YRs("GameTitleName") %>" />
                        <% if YRs("ViewYN") ="Y" then  %>
						<i class="fa fa-angle-right" aria-hidden="true"></i>
                        <% end if  %>
					</p>
					<div class="list_box">
						<ul>
							<li>
								<span class="l_name"></span>
								<span class="r_con">
                                <% if YRs("ViewState") ="Y" and (Cdbl(ch_i)+Cdbl(ch_reqc))>0 then  %>
                                        <% if Cdbl(ch_i) >0 then  %>
											<a href="javascript:chk_frm('3','<%=YRs("GameTitleIDX") %>');" class="green_btn">신청하기 </a>
                                        <% end if  %>

                                        <% if Cdbl(ch_reqc) >0 then  %>
                                            <a href="javascript:chk_frm('4','<%=YRs("GameTitleIDX") %>');" class="yellow_btn">신청내역</a>
                                        <% end if  %>
                                <% end if  %>
                                <% if YRs("summary") <>"" then  %>
                                    <a href="javascript:Search_summary('<%=YRs("GameTitleIDX") %>','<%=YRs("GameTitleName") %>');" class="yellow_btn">대회요강</a>
                                <% end if  %>
								</span>
							</li>
						</ul>
					</div>
			    </dd>

                <%
	            YRs.MoveNext
	            Loop
            Else
                %>
			    <dd>
				    <p class="list_titlemonth"><%=Years %>년</p>
				    <p class="list_title"></p>
                    <div class="list_box">
						<ul>
							<li>
								<span class="l_name"></span>
								<span class="r_con"></span>
							</li>
                        </ul>
                    </div>
			    </dd>
                <%
            End If
            %>
		</dl>
		<!--<a href="#" class="more_btn">더보기</a>-->
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
