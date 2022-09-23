<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<%
Years     = fInject(Request("Years"))
Months     = fInject(Request("Months")) 
GameTitleIDX     = fInject(Request("GameTitleIDX"))
TeamGb  = fInject(Request("TeamGb"))
levelno  = fInject(Request("levelno"))

'Response.Write "<br> Years :" & Years
'Response.Write "<br> Months :" & Months
'Response.Write "<br> GameTitleIDX :" & GameTitleIDX


''대회 정보 검색

%>

<link href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.min.js"></script> 
<script src="/pub/js/rookietennis/tennis_Request.js<%=CONST_JSVER%>" type="text/javascript"></script>

<script type="text/javascript">
    function chk_frm(val, vsGu) {
        var sf = document.search_frm;
        if (val == "ReturnList") {
            sf.action = "./list.asp";
        } else {
            $("#TeamGb").val($("#TeamGb_" + vsGu).val());
            $("#TeamGbNm").val($("#TeamGbNm_" + vsGu).val());
            $("#levelno").val($("#levelno_" + vsGu).val());
            $("#levelNm").val($("#levelNm_" + vsGu).val());
            $("#EntryCntGame").val($("#EntryCntGame_" + vsGu).val());
            $("#ChekMode").val(0);
            
            if (val == 1) {
                sf.action = "./write.asp";
            }
            if (val == 2) {
                sf.action = "./info_list.asp";
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

        mx_player.SendPacket("Modal_ContentsList", obja, mx_player.ajaxURL);
        $("#aTcommit_game").click();
    }

</script>
<title>KATA Tennis 대회 참가신청 </title>

</head>
<body class="lack_bg">
<!-- S: header -->
<!-- #include file = "./include/header.asp" -->
<!-- E: header -->
<!-- S: main --> 
<%
SQL = " select  GameTitleName from sd_TennisTitle  where DelYN='N' and GameTitleIDX= '"&GameTitleIDX&"' "
Set Rs = Dbcon.Execute(SQL)
If Not(Rs.Eof Or Rs.Bof) Then 
Do Until Rs.Eof  
    GameTitleName = Rs("GameTitleName")
Rs.MoveNext
Loop 
end if 
%>


<form method="post" name="search_frm" id="search_frm" >  
     <input  type="hidden" name="Years" id="Years" value="<%=Years %>"/> 
     <input  type="hidden" name="Months" id="Months" value="<%=Months %>"/> 
     <input  type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX %>"/> 
     <input  type="hidden" name="GameTitleName" id="GameTitleName" value="<%=GameTitleName %>"/> 
    <input  type="hidden"  name="TeamGb" id="TeamGb" value=""/> 
    <input  type="hidden"  name="TeamGbNm" id="TeamGbNm" value=""/> 
    <input  type="hidden"  name="levelno"  id="levelno"value=""/>   
    <input  type="hidden"  name="levelNm"  id="levelNm"value=""/>   
    <input  type="hidden"  name="EntryCntGame"  id="EntryCntGame"value=""/>   
    <input  type="hidden"  name="ChekMode"  id="ChekMode"value=""/>   
</form>

<button id="aTcommit_game" class="green_btn" data-toggle="modal" data-target="#myModal_game"  style=" display:none;">모집요강</button>
<h1 class="page_title">
	<a href="javascript:chk_frm('ReturnList',0);" class="" >
		<i class="fa fa-angle-left" aria-hidden="true"></i>
	</a>
    <span class="name"><%=GameTitleName  %></span>
</h1>
<a href="javascript:Search_summary('<%=GameTitleIDX %>','<%=GameTitleName %>');" class="yellow_btn">대회요강보기</a>
<a href="javascript:chk_frm('ReturnList',0);" class="top_more_btn">목록</a>
<div class="attend_list"> 

	<!-- e: 대회목록 가기 -->
	<!-- s: 대회 리스트 -->
	<div class="competition_list">
        <%
        
            SQL = " select a.GameTitleIDX,a.GameTitleName,b.GameType,p1.PubName,b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame  " & _ 
                    " from sd_TennisTitle a  " & _ 
                        " inner join tblRGameLevel b  " & _ 
                            " on a.GameTitleIDX = b.GameTitleIDX  " & _ 
                            " and a.SportsGb = b.SportsGb  " & _ 
                            " and b.DelYN='N'  " & _ 
                        " inner join tblLevelInfo c  " & _ 
                            " on b.SportsGb = c.SportsGb  " & _ 
                            " and b.TeamGb = c.TeamGb  " & _ 
                            " and b.Level = c.Level  " & _ 
                            " and c.DelYN='N'  " & _ 
                        " left join tblPubCode p1  " & _ 
                            " on b.GameType = p1.PubCode  " & _ 
                            " and b.SportsGb = p1.SportsGb  " & _ 
                            " and p1.DelYN='N'  " & _ 
                            " and p1.PPubCode ='sd04' " & _ 
                    " where a.DelYN='N' and a.GameTitleIDX='"&GameTitleIDX&"' " & _ 
                    " and c.LevelNm not like '%최종%'" & _ 
                " group by a.GameTitleIDX,a.GameTitleName,a.GameS,a.GameE,b.GameType,p1.PubName,b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame " & _ 
            " ORDER BY GameS DESC "
           ' Response.Write SQL
            Set Rs = Dbcon.Execute(SQL)
            If Not(Rs.Eof Or Rs.Bof) Then 
            Do Until Rs.Eof  
                %>
              <dl>
			    <dd>
				    <p class="list_title"><%=Rs("TeamGbNm") %>(<%=Rs("levelNm") %> - <%=Rs("EntryCntGame") %>팀)</p>
				    <div class="list_box">
					    <ul> 
						    <li>
							    <span class="l_name name_1">경기 일자</span>
							    <span class="r_con con_title" data-toggle="modal" data-target="#myModal" data-backdrop="static" ><%=Rs("GameDay") %></span>
						    </li>
						    <!--<li>
							    <span class="l_name name_1">문의사항</span>
							    <span class="r_con con_title" data-toggle="modal" data-target="#myModal" data-backdrop="static" > </span>
						    </li>-->
					    </ul>
				    </div>
				    <div class="dd_btn_box">
					    <a href="javascript:chk_frm('1','<%=Rs("Level") %>');" class="green_btn">참가신청</a>
					    <a href="javascript:chk_frm('2','<%=Rs("Level") %>');" class="yello_btn">참가신청내역</a>
				    </div> 
                    <input  type="hidden"  name="TeamGb" id="TeamGb_<%=Rs("Level") %>" value="<%=Rs("TeamGb") %>"/> 
                    <input  type="hidden"  name="TeamGbNm" id="TeamGbNm_<%=Rs("Level") %>" value="<%=Rs("TeamGbNm") %>"/> 
                    <input  type="hidden"  name="levelno"  id="levelno_<%=Rs("Level") %>"value="<%=Rs("Level") %>"/>   
                    <input  type="hidden"  name="levelNm"  id="levelNm_<%=Rs("Level") %>"value="<%=Rs("LevelNm") %>"/>   
                    <input  type="hidden"  name="EntryCntGame"  id="EntryCntGame_<%=Rs("Level") %>"value="<%=Rs("EntryCntGame") %>"/>  
                    
                     
			    </dd>
		    </dl>
                <%
            Rs.MoveNext
            Loop 
            end if 
         %> 
	</div>
	<!-- e: 대회 리스트 -->
</div>
<div class="modal fade write_moal" id="myModal_game" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
	<div class="modal-dialog">
		<div class="modal-content" id="Modal_ContentsList"> </div>
	</div>
</div>
<!-- E: main -->
<!--#include file = "./include/foot.asp" -->
