<!--#include file = "./include/config_top.asp" -->
<!--#include file = "./include/config_bot.asp" -->
<!--#include file = "./Library/ajax_config.asp"-->
<!-- #include virtual = "/pub/fn/fn_tennis.asp" -->
<%

ChekMode  = fInject(Request("ChekMode"))
Years     = fInject(Request("Years"))
Months     = fInject(Request("Months")) 
GameTitleIDX     = fInject(Request("GameTitleIDX"))
GameTitleName  = fInject(Request("GameTitleName"))
TeamGb  = fInject(Request("TeamGb"))
TeamGbNm  = fInject(Request("TeamGbNm"))
levelno  = fInject(Request("levelno"))
levelNm  = fInject(Request("levelNm"))
EntryCntGame  = fInject(Request("EntryCntGame"))

ridx  = fInject(Request("ridx"))
pidx  = fInject(Request("pidx"))
Fnd_Kw  = fInject(Request("Fnd_Kw"))
NKEY    = fInject(Request("NKEY"))

tidx= fInject(Request("tidx"))

if  GameTitleIDX = "" then 
    if tidx <> "" then 
        GameTitleIDX =tidx
    end if 
end if 
 

if NKEY <=0 then  
    NKEY =1 
end if 
  
if Years="" then 
    Years=year(date)
End If 
ChekMode = 1
 
If GameTitleIDX = "" Then 
'Response.redirect "./list.asp"
'Response.end
End if

'Response.Write "<br> ChekMode :" & ChekMode
'Response.Write "<br> GameTitleIDX :" & GameTitleIDX
'Response.Write "<br> GameTitleName :" & GameTitleName
'Response.Write "<br> TeamGb :" & TeamGb
'Response.Write "<br> TeamGbNm :" & TeamGbNm
'Response.Write "<br> levelno :" & levelno
'Response.Write "<br> levelNm :" & levelNm
'Response.Write "<br> EntryCntGame :" & EntryCntGame
'Response.Write "<br> ridx :" & ridx
'Response.Write "<br> pidx :" & pidx
'Response.Write "<br> Fnd_Kw :" & Fnd_Kw

%>
<link href="http://code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="http://code.jquery.com/ui/1.10.4/jquery-ui.min.js"></script> 
<script src="/pub/js/tennis_Request.js?ver=10" type="text/javascript"></script>
<script type="text/javascript">
    function chk_frm(val, ridx) {
        var sf = document.frm_in;
        if (val == 0) {
            sf.action = "./list.asp" + ver;
            sf.submit();
        } else if (val == 1) {
            sf.action = "./list.asp" + ver;
            sf.submit();
        } else if (val == "FND") {
            sf.action = "./info_list.asp" + ver;
            $("#Years").val($("#Years_sel").val());
            $("#GameTitleIDX").val("");
            $("#levelno").val("");
            $("#NKEY").val(1);
            sf.submit();
        } else if (val == "FndName") {
            /*리스트 이름 검색 */
            $("#NKEY").val(1);
            $("#Years").val($("#Years_sel").val());
            $("#GameTitleIDX").val($("#GameTitleIDX_sel").val());
            $("#levelno").val($("#levelno_sel").val());
            search_Request_Player(0, 1);
        } else if (val == "Fndyears") {
            /*리스트 이름 검색 */
            $("#NKEY").val(1);
            $("#Years").val($("#Years_sel").val());
            $("#GameTitleIDX").val("");
            $("#levelno").val("");

            var obja = {};
            obja.CMD = mx_player.CMD_Search_game;
            $("#Years").val($("#Years_sel").val());
            obja.Years = $("#Years_sel").val();
            obja.IDX = ""; 
            mx_player.SendPacket("GameTitleIDX_sel", obja, "/pub/ajax/mobile/reqTennisatt.asp");

        } else if (val == "FndGame") {
            /*리스트 이름 검색 */
            $("#NKEY").val(1);
            $("#Years").val($("#Years_sel").val());
            $("#GameTitleIDX").val($("#GameTitleIDX_sel").val());
            $("#levelno").val($("#levelno_sel").val());
            search_Request_Player(0, 1);

            var obja = {};
            obja.CMD = mx_player.CMD_Search_level;
            obja.IDX = $("#GameTitleIDX_sel").val();
            mx_player.SendPacket("levelno_sel", obja, "/pub/ajax/mobile/reqTennisatt.asp");

        }   else if (val == "FndPwd") {
            /*패스워드 입력창 */
            $("#aTcommit").click();
            var str = ridx;
            var strSt = ridx.split("|");
            $("#GameTitleIDX").val(strSt[0]); 
            $("#TeamGb").val(strSt[1]);
            $("#levelno").val(strSt[2]);
            $("#ridx").val(strSt[3]);
            $("#Ch_i").val(strSt[4]);
            $("#Ch_u").val(strSt[5]);
            $("#Ch_d").val(strSt[6]); 
        } else if (val == "FndWrite") {
            /*신청내역 보기 (수정 )  */
            //비밀번호 체크 확인시 페이지 이동
            var obja = {};
            obja.CMD = mx_player.CMD_PLAYER_Pwd_check;
            obja.IDX = $("#GameTitleIDX").val();
            obja.GameTitleIDX = $("#GameTitleIDX").val();
            obja.levelno = $("#levelno").val();
            obja.ridx = $("#ridx").val();
            obja.StrPwd = $("#StrPwd").val();
            obja.Ch_i = $("#Ch_i").val();
            obja.Ch_u = $("#Ch_u").val();
            obja.Ch_d = $("#Ch_d").val();

            mx_player.SendPacket("", obja, "/pub/ajax/mobile/reqTennisatt.asp");
        } else if (val == "FndAddList") {
            /*리스트 추가 조회 더보기*/
            $("#NKEY").val(ridx);
            $("#ErrorMs").remove();
            search_Request_Player(1, ridx);
        }
    }

    function checkLevel() {
        if (!$("#GameTitleIDX_sel").val()) {
            alert("대회를 선택 해주세요.");
            $("#GameTitleIDX_sel").focus();
        }
    }

    /*자동 완성 이름*/
    $(document).ready(function () {
        search_Request_Player(0, 1);
    });

    function search_Request_Player(val,nkey) {
        /*내용 조회*/
        var obja = INFO_Request;
        if (val == 0) {
            obja.CMD = mx_player.CMD_CONTESTAPPEND;
        } else {
            obja.CMD = mx_player.CMD_CONTESTAPPENDAdd;
            $(".more_btn").remove();
        }
        obja.NKEY = nkey;
        obja.IDX = $("#GameTitleIDX").val();
        obja.levelno = $("#levelno").val();
        obja.pidx = $("#pidx").val();
        obja.Fnd_Kw = $("#Fnd_K").val();
        obja.Years = $("#Years").val();
        obja.NKEY = $("#NKEY").val();

        console.log(obja);
        
        //Contentslist 
        //FndAddList
        mx_player.SendPacket("Contentslist", obja, "/pub/ajax/mobile/reqTennisatt.asp");
    }

    function search_Request_Player_key() {
        $("#pidx").val("");
        $("#Fnd_Kw").val($("#Fnd_K").val());
    }
    function Search_summary(vsGu, vsGuNm) {
        //Modal_ContentsList
        /*내용 조회*/

        var obja = {};
        obja.CMD = mx_player.CMD_EDITOR;
        obja.tidx = vsGu;
        obja.title = vsGuNm; 
        mx_player.SendPacket("Modal_ContentsList", obja, "/pub/ajax/mobile/reqTennisatt.asp");
        $("#aTcommit_game").click();
    }

</script>
<title>KATA Tennis 대회 참가신청내역 </title>

</head>
<body class="lack_bg" id="AppBody">
<!-- S: header -->
<!-- #include file = "./include/header.asp" -->
<!-- E: header -->
<!-- S: main -->

<h1 class="page_title">
	<a href="javascript:chk_frm(0,'');" class="" >
		<i class="fa fa-angle-left" aria-hidden="true"></i> 
	</a>
    <span class="name">신청내역 검색</span>
</h1>
<button id="aTcommit" class="green_btn" data-toggle="modal" data-target="#myModal"  style=" display:none;">신청완료</button>
<button id="aTcommit_game" class="green_btn" data-toggle="modal" data-target="#myModal_game"  style=" display:none;">모집요강</button>
<ul class="ui-autocomplete ui-front ui-menu ui-widget ui-widget-content ui-corner-all" id="ui-user" ></ul> 
<form method="post" name="frm_in" id="frm_in" >  
    <input  type="hidden" name="Years" id="Years" value="<%=Years %>"/> 
    <input  type="hidden" name="Months" id="Months" value="<%=Months %>"/> 
    <input  type="hidden" name="ChekMode" id="ChekMode" value="<%=ChekMode %>"/> 
    <input  type="hidden" name="tidx" id="tidx" value="<%=GameTitleIDX %>"/>
    <input  type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX %>"/> 
    <input  type="hidden" name="GameTitleName" id="GameTitleName" value="<%=GameTitleName %>"/> 
    <input  type="hidden"  name="TeamGb" id="TeamGb" value="<%=TeamGb %>"/> 
    <input  type="hidden"  name="TeamGbNm" id="TeamGbNm" value="<%=TeamGbNm %>"/> 
    <input  type="hidden"  name="levelno"  id="levelno"value="<%=levelno %>"/>    
    <input  type="hidden"  name="levelNm"  id="levelNm"value="<%=levelNm %>"/>  
    <input  type="hidden"  name="EntryCntGame"  id="EntryCntGame"value="<%=EntryCntGame %>"/>  
    <input  type="hidden" name="CMD" id="CMD" value="<%=CMD %>"/>  
    <input  type="hidden" name="ridx" id="ridx" value="<%=ridx %>"/>  
    <input  type="hidden" name="pidx" id="pidx" value="<%=pidx %>"/>  
    <input  type="hidden" name="Fnd_Kw" id="Fnd_Kw" value="<%=Fnd_Kw %>"/>  
    <input  type="hidden" name="NKEY" id="NKEY" value="<%=NKEY %>"/>  
    <input  type="hidden" name="Ch_i" id="Ch_i" value=""/>  
    <input  type="hidden" name="Ch_u" id="Ch_u" value=""/>  
    <input  type="hidden" name="Ch_d" id="Ch_d" value=""/>  
</form>
<div class="attend_list">
  <!--<a href="javascript:Search_summary('<%=GameTitleIDX %>','<%=GameTitleName %>');" class="list_btn">대회요강보기</a>-->
 
	<div class="competition_list">
         <dl>
			<dd>
	            <!-- s: 검색 -->
	            <div class="search_box">
		            <ul>
			            <li class="li_search_box"> 
				            <select id="Years_sel" name="Years_sel" class="r_con"  onchange="javascript:chk_frm('Fndyears',0);" >
				            <% YEARSQL = " select GameYear  From sd_TennisTitle   where  SportsGb='tennis' and isnull(GameYear,'')<>'' and ViewYN='Y' and delyn='N' " 
                               ' if GameTitleIDX <>"" then
                               '     YEARSQL = YEARSQL &" and GameTitleIDX='"&GameTitleIDX&"'"
                               ' end if
                                YEARSQL = YEARSQL &" group by GameYear  ORDER BY GameYear DESC "
                    
					            Set YRs = Dbcon.Execute(YEARSQL)
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
				            <span class="r_con">
                                    <% 
                                    SQL = " select GameTitleIDX,GameTitleName,GameYear,titleCode,titleGrade,GameS  from View_game_title_list " 
                                    SQL = SQL &" where 1=1 and ViewYN ='Y'"
                                    'if GameTitleIDX <>"" then
                                       ' SQL = SQL &" and GameTitleIDX='"&GameTitleIDX&"'"
                                    'end if

                                    if Years <>"" then
                                        SQL = SQL &" and GameYear='"&Years&"' "
                                    end if
                                    SQL = SQL &"  group by GameTitleIDX,GameTitleName,GameYear,titleCode,titleGrade,GameS "  
                                    SQL = SQL &"  order by GameYear desc,GameS ,GameTitleIDX"  
                                     %>
					            <select class="ipt select_1" id="GameTitleIDX_sel" name="GameTitleIDX_sel" onchange="javascript:chk_frm('FndGame',0);"> 
						           <%'if GameTitleIDX =""  then  %>
                                    <option value="" >:: 대회 전체 조회 ::</option>
                                   <%'end if  

                                    Set Rs = Dbcon.Execute(SQL)
                                    If Not(Rs.Eof Or Rs.Bof) Then 
                                    Do Until Rs.Eof  

                                        titleGradeNm = findGrade(rs("titleGrade") )
                                        if titleGradeNm <> "" then 
                                            titleGradeNm  =titleGradeNm '&"그룹"
                                        end if 
                                     %> 
						              <option value="<%=Rs("GameTitleIDX") %>" <%if Cstr(GameTitleIDX) =Cstr(Rs("GameTitleIDX")) then %> selected <%end if %>>[<%=titleGradeNm  %>]<%=Rs("GameTitleName") %></option>
                                     <%
                                    Rs.MoveNext
                                    Loop 
                                    end if 
                                     %> 
					            </select>
				            </span>
                        </li>
			            <li class="li_search_box"> 
				            <span class="r_con">
                                    
					            <select class="ipt select_1" id="levelno_sel" name="levelno_sel" onclick="checkLevel();"  onchange="javascript:chk_frm('FndName',0);"> <!--onchange="javascript:chk_frm('FndName',0);"-->
						            <option value="" >:: 부서 전체 조회 ::</option>
                                    <%
                                    if  GameTitleIDX <>"" then 
                                    SQL = " select b.GameType, b.TeamGb,case left(b.cfg,1) when 'Y' then b.TeamGbNm +'(B)' else b.TeamGbNm end  TeamGbNm,c.Level  "  & _ 
                                           " ,case when isnull(c.LevelNm,'')='' then '' when c.LevelNm='없음' then '' else c.LevelNm end LevelNm "  & _ 
                                           " ,GameDay,GameTime,EntryCntGame "  & _ 
                                           " ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt "  & _ 
                                           "  from tblRGameLevel b  "  & _ 
                                           "  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "  & _ 
                                           "  left join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' "  & _ 
                                           "  where b.DelYN='N'  and c.LevelNm not like '%최종%'  " & _ 
                                           "   and('"&GameTitleIDX&"'='' or '"&GameTitleIDX&"'is null or b.GameTitleIDX='"&GameTitleIDX&"')"  & _ 
                                           "  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame ,left(b.cfg,1) "
                           
                                        Set Rs = Dbcon.Execute(SQL)
                                        If Not(Rs.Eof Or Rs.Bof) Then 
                                        Do Until Rs.Eof  
                                     %>
						                <option value="<%=Rs("Level") %>" <%if levelno =Rs("Level") then %> selected <%end if %>><%=replace(Rs("TeamGbNm"),"부","") %><%if Rs("LevelNm") <>"" then  %>(<%=Rs("LevelNm") %>)<%end if%> <%=Rs("RequestCnt") %>/<%=Rs("EntryCntGame") %></option>
                                     <%
                                        Rs.MoveNext
                                        Loop 
                                        end if 
                                     end if 
                                     %> 
					            </select>
				            </span>
                        </li>
			            <li class="li_search_box">
				            <span class="ic_deco">
					            <i class="fa fa-search"></i>
				            </span>
				            <input type="text" placeholder="이름을 검색하세요" id="Fnd_K" name="Fnd_K" value="<%If Fnd_Kw <> "" then%><%=Fnd_Kw %><%End if%>"   
                             onkeyup="fnkeyup(this);"   
                             autocomplete="off" />
                            <!-- onkeyup="javascript:chk_frm('FndName',0);" -->
                            <!-- onkeyup="search_Request_Player_key()"-->
							<!-- fake fields are a workaround for chrome autofill getting the wrong fields -->
							<input style="display:none" type="text" name="fakeusernameremembered"/>
							<input style="display:none" type="password" name="fakepasswordremembered"/>
                            <a href="javascript:chk_frm('FndName',0);" class="">검색</a>
                            <a href="javascript:chk_frm('1','');" class="green_btn">신청하기</a> 
                        </li> 
		            </ul>
	            </div>
	            <!-- e: 검색 -->
                
            </dd>
        </dl>
    </div>

</div>
<div class="info_list">
	<!-- s: 참가자 정보 리스트 -->
	<div class="competition_list">
		<dl id="Contentslist"></dl> 
		<!--<a href="javascript:chk_frm('FndAddList','');" class="more_btn" id="FndAddList">더보기</a>-->
	</div>
	<!-- e: 참가자 정보 리스트 -->
	<!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh">
		<div class="modal-dialog">
			<div class="modal-content" >
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" >비밀번호</h4>
				</div>
				<div class="modal-body">
					<div class="in_list">
 						<input type="password"  maxlength="15" id="StrPwd" autocomplete="new-password" value=""    /> 
						<a href="javascript:chk_frm('FndWrite','');">확인</a>
					</div>
					<p>이게시물의 비밀번호를 입력하십시오.</p>
				</div>
			</div>
		</div>
	</div>
	<!-- Modal -->
    <div class="modal fade write_moal" id="myModal_game" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="flesh" >
	    <div class="modal-dialog" style="margin-top:-200px;top:50%;">
		    <div class="modal-content" id="Modal_ContentsList" style="width:100%;overflow-x:scroll;height:400px;"> </div>
	    </div>
    </div>
</div>
<!-- E: main -->
<!--#include file = "./include/foot.asp" -->
