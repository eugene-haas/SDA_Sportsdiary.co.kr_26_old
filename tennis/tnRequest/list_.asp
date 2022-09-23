<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<%
Years     = fInject(Request("Years"))
Months     = fInject(Request("Months"))
GameTitleIDX     = fInject(Request("GameTitleIDX"))
 
'Response.Write "<br> Years :" & Years
'Response.Write "<br> Months :" & Months
'Response.Write "<br> GameTitleIDX :" & GameTitleIDX

if Years="" then 
	Years = year(date)
'    YNSQL = "SELECT LEFT(CONVERT(NVARCHAR,GETDATE(),112),4) Years"
'    Set YNRs = Dbcon.Execute(YNSQL)
'    If Not(YNRs.Eof Or YNRs.Bof) Then 
'	    Years =YNRs("Years")
'    End If 
End If 
 
today = Date()
%>

<link href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<script src="/ckeditor/ckeditor.js"></script>
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.min.js"></script> 
<script src="/pub/js/tennis_Request.js" type="text/javascript"></script>
<script type="text/javascript">
    function chk_frm(val, vsGu) {
         var sf = document.search_frm;
        if (val == "FND") {
            sf.action = "./list.asp";
        } else {  
            $("#GameTitleIDX").val(vsGu);

            if (val == 1) {
                sf.action = "./write.asp";
            }

            if (val == 2) {
                sf.action = "./list_repair.asp";
            }

            if (val == 3) {
                sf.action = "./list_repair.asp";
            }
        }
        sf.submit();
    }

    function Search_summary(vsGu, vsGuNm) {
        //Modal_ContentsList
        /*내용 조회*/

        var obja = {};
        obja.CMD = mx_player.CMD_EDITOR;
        obja.tidx = vsGu;
        obja.title = vsGuNm;
		
        mx_player.SendPacket("Modal_ContentsList", obja, "/pub/ajax/mobile/reqTennisatt.asp");
		$("#yoyo").click();
        //$("#aTcommit").click();
    }
</script>
<title>KATA Tennis 대회 참가신청</title>
</head>
<body class="lack_bg">

<!-- S: header -->
<!-- #include file = "./include/header.asp" -->
<!-- E: header -->
<!-- S: main -->
<h1 class="page_title">대회정보</h1>
<button id="aTcommit" class="green_btn" data-toggle="modal" data-target="#myModal"  style=" display:none;">신청완료</button>
<div class="l_apply_list">
	<!-- s: 검색 -->
    <form method="post" name="search_frm" id="search_frm" > 
	<div class="search_box">
		<ul>
			<li class="li_search_box"> 
				<select id="Years" name="Years" class="r_con"  onchange="javascript:chk_frm('FND',0);" >
				<% YEARSQL = " select GameYear    From sd_TennisTitle   where  isnull(GameYear,'')<>'' group by GameYear  ORDER BY GameYear DESC "
					Set YRs = Dbcon.Execute(YEARSQL)
					If Not(YRs.Eof Or YRs.Bof) Then 
						Do Until YRs.Eof  %>
								<option value="<%=YRs("GameYear")%>" <%If YRs("GameYear") = Years Then %>selected<% Years= YRs("GameYear")  
								End If
								%> >  <%=YRs("GameYear")%> 년</option> <%
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
			</li> 
		</ul>
	</div>
    </form>
	<!-- e: 검색 -->
	<!-- s: 대회 리스트 -->
	<div class="competition_list">
		<dl>
            <%
            YEARSQL = " select convert(date ,GameS)GameS " & _ 
                       "  ,convert(date ,GameE)GameE " & _ 
                       "  ,GameRcvDateS,GameRcvDateE " & _ 
                       "  ,left(convert(date ,GameS),7) GameSm,left(convert(date ,GameE),7) GameEm" & _ 
                       "  ,GameTitleIDX,stateNo,GameTitleName,GameYear,GameArea,SidoCode,EnterType,GameTitleLevel" & _ 
                       "  ,ViewYN,MatchYN,ViewState,cfg,hostname,titleCode,titleGrade,summary" & _ 
                       "  from sd_TennisTitle " & _ 
                       "  where DelYN='N' and  ViewYN='Y'  "

            if Months="" then 
            YEARSQL=YEARSQL& "  and GameYear='"&Years &"' "
            else
            YEARSQL=YEARSQL& "  and (left(convert(date ,GameS),7)<='"&Years&"'+'-'+'"&Months&"' and left(convert(date ,GameE),7)>='"&Years&"'+'-'+'"&Months&"' ) " 
            end if 


            YEARSQL=YEARSQL& " order by GameS"
            GameSm=""
            Set YRs = Dbcon.Execute(YEARSQL)
            If Not(YRs.Eof Or YRs.Bof) Then 
	            Do Until YRs.Eof  
					gamercvdate  =  YRs("GameRcvDateE")

                if GameSm<> YRs("GameSm") then 
                    GameSmStr=  Split(YRs("GameSm"),"-")
                %>
                    <dd>
                        <p class="list_titlemonth"> <%=GameSmStr(0) %> 년 <%=GameSmStr(1) %> 월</p>
                    </dd>
                <%
                end if 
                GameSm = YRs("GameSm")
                %>
			    <dd>
					<!-- 버튼 안보임 -->
                    <% if YRs("ViewYN") ="Y" then  %> 
                    <a href="javascript:chk_frm('3','<%=YRs("GameTitleIDX") %>');">  
                     <% end if  %>
							<p class="list_title"><%=YRs("GameTitleName") %>
                             <% if YRs("ViewYN") ="Y" then  %> 
								<i class="fa fa-angle-right" aria-hidden="true"></i>
                             <% end if  %>
							</p>
							<div class="list_box">
								<ul> 
									<li>
										<span class="l_name">장소</span>
										<span class="r_con"><%=YRs("GameArea") %> </span>
									</li>  

									<li>
										<span class="l_name">대회 기간</span><span class="r_con"><%=YRs("GameS") %> ~ <%=YRs("GameE") %></span>
									</li>
                                    <% if YRs("ViewYN") ="Y" then  %> 
									<li>
										<span class="l_name">참가 신청</span>
										<span class="r_con">
											<a href="#">참가신청</a>
										</span>
									</li>
									<li>
										<span class="l_name">대회요강</span>
										<span class="r_con">
											<a href="#">대회요강</a>
										</span>
									</li>
                                     <% end if  %>
								</ul>
							</div>
			    </dd>

                <% if YRs("summary") <>""  then%>
                <!-- <dd>
					<span class="r_con">  
                        <span class="ic_deco">
					        <i class="fa fa-search"></i> <a href="javascript:Search_summary('<%=YRs("GameTitleIDX") %>','<%=YRs("GameTitleName") %>');" class="">대회요강</a>
				        </span>
                    </span> 
                </dd> -->
                <%end if %>
                <%
	            YRs.MoveNext
	            Loop 
            Else
                %>
			    <dd>
				    <p class="list_title"> </p>
			    </dd>
                <%
            End If   
            %>
		</dl>
		<!--<a href="#" class="more_btn">더보기</a>-->
	</div>
	<!-- e: 대회 리스트 -->
</div>
<div class="modal fade write_moal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
	<div class="modal-dialog">
		<div class="modal-content" id="Modal_ContentsList"> </div>
	</div>
</div>
<!-- E: main -->
<!--#include file = "./include/foot.asp" -->
