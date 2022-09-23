<!--#include virtual="/Manager/Common/common_header_tourney.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%Response.cookies("GameTitleIDX")=  "" %>
<%
GameYear = fInject(Request("Search_GameYear"))
SportsGb  =   fInject(Request("SportsGb"))
GameTitleIDX  =   fInject(Request("GameTitleIDX"))
GameTitleName   =   fInject(Request("GameTitleName"))
gametype  =   fInject(Request("game-type"))
GameDay   =   fInject(Request("GameDay"))
GroupGameGb   =  fInject(Request("game-type"))
EnterType =   fInject(Request("EnterType"))
TeamGb   =   fInject(Request("TeamGb"))

if SportsGb="" then 
    SportsGb="judo"
end if

If SportsGb <> "" Then 
	GSQL = "SELECT EnterType ,case EnterType when 'A' then '아마추어' else '엘리트' end EnterTypeNm "
    GSQL = GSQL &" FROM Sportsdiary.dbo.tblGametitle  " 
    GSQL = GSQL &" WHERE ViewState='1' AND DelYN='N' AND GameYear='"&GameYear&"' AND GameTitleIDX='"&GameTitleIDX&"'  AND SportsGb='"&SportsGb&"' GROUP BY EnterType ORDER BY EnterType DESC "

	Set GRs = Dbcon.Execute(GSQL)

	If Not(GRs.Eof Or GRs.Bof) Then 
		Do Until GRs.Eof 
			EnterType= GRs("EnterType")  
		GRs.MoveNext
		Loop 
	End If 
End If 


if GameYear="" then 
    YNSQL = "SELECT LEFT(CONVERT(NVARCHAR,GETDATE(),112),4) GameYear"
    Set YNRs = Dbcon.Execute(YNSQL)
    
    If Not(YNRs.Eof Or YNRs.Bof) Then 
	    GameYear =YNRs("GameYear")
    End If 
End If 

 
'Response.Write SportsGb&"\GameYear\" &GameYear& "\GameTitleIDX\" & GameTitleIDX & "\GameTitleName\" & GameTitleName & "\GroupGameGb\" & GroupGameGb & "\TeamGb\" & TeamGb & "\Level\" & Level & "\Sex\"&  Sex  & "\SexLevel\"&  SexLevel 
'Response.Write "\RGameLevelidx\" &RGameLevelidx & "\RGameLevelidx\"
%>
<head>
    <title>입상현황</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="-1">
    <style>
    /* following three (cascaded) are equivalent to above three meta viewport statements */
    /* see http://www.quirksmode.org/blog/archives/2014/05/html5_dev_conf.html */
    /* see http://dev.w3.org/csswg/css-device-adapt/ */
        @-ms-viewport { width: 100vw ; min-zoom: 100% ; zoom: 100% ; }          @viewport { width: 100vw ; min-zoom: 100% zoom: 100% ; }
        @-ms-viewport { user-zoom: fixed ; min-zoom: 100% ; }                   @viewport { user-zoom: fixed ; min-zoom: 100% ; }
        /*@-ms-viewport { user-zoom: zoom ; min-zoom: 100% ; max-zoom: 200% ; }   @viewport { user-zoom: zoom ; min-zoom: 100% ; max-zoom: 200% ; }*/
    </style>

    <link href="css/bootstrap-theme.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.css" rel="stylesheet" type="text/css" />
      <!-- bootstrap popover -->
    <link href="css/tourney.css" rel="stylesheet" type="text/css" />
    <link href="../css/style.css" rel="stylesheet" type="text/css" />

    <script src="../../webtournament/www/js/global.js"></script>
    <script src="../js/jquery-1.12.2.min.js"></script> 
    <script src="js/bootstrap.js"></script>
    <script src="js/html2canvas.js"></script>
    <script src="js/tourneyData.js"></script>
    <script src="js/tourney_print.js" type="text/javascript"></script>
</head>

<script type="text/javascript">
    var pageTitle = "입상현황";
    
    var GameYear = "<%=GameYear %>";
    var SportsGb = "<%=SportsGb %>";
    var GameTitleIDX = "<%=GameTitleIDX %>";
    var GameTitleName = "<%=GameTitleName %>";
    var GroupGameGb = "<%=GroupGameGb %>";
    var TeamGb = "<%=TeamGb %>";
    var EnterType = "<%=EnterType %>";
    var GameDay = "<%=GameDay %>";

    GameTitleName = $("#GameTitleIDX option:selected").text().replace("(종료)", "");
    GameTitleName = GameTitleName.replace("(예정)", "");
    GameTitleName = GameTitleName.replace("(진행중)", "");

    localStorage.setItem("GameYear", GameYear);
    localStorage.setItem("GameTitleIDX", GameTitleIDX);
    localStorage.setItem("GameTitleName", GameTitleName);
    localStorage.setItem("SportsGb", SportsGb);
    localStorage.setItem("EnterType", EnterType);
    localStorage.setItem("GameDay", GameDay);
    localStorage.setItem("GroupGameGb", GroupGameGb);
    localStorage.setItem("TeamGb", TeamGb);

    var PlayerGameNum = 1;
    var PlayerResultNum = 1;

    //댑스별로 상단에서 하단으로 내려오는 리스트 카운트하여 1/2 처리. 반드시 짝수여야 한다.(부전승은 2)
    var LLevelLineCount = 0;
    var RLevelLineCount = 0;

    var onLoad = function () {
        var PromiseInjuryGb = $.when(m_SelTeamCode_NowGame("#TeamGb", localStorage.getItem("TeamGb")));
        PromiseInjuryGb.done(function () {
            var Searchlist = $.when(search());
             Searchlist.done(function () {});
        });
    }

    $(document).ready(function () {

        window.onpopstate = function (event) {
            if (!($("#show-score,#groupshow-score").hasClass('in'))) { return; }
            $("#show-score,#groupshow-score").modal("hide");
            console.log('hide this = ', this);
            if (history.state == null) {

            } else {

                history.back();
            }
        };

        $('#show-score,#groupshow-score').on('show.bs.modal', function (e) {

        });
        $('#show-score,#groupshow-score').on('hide.bs.modal', function (e) {
            if (history.state == null) {

            } else {

                history.back();
            }
        });


        $("#tourney_title").html(localStorage.getItem("GameTitleName"));

        localStorage.setItem("GroupGameGb", GroupGameGb);

        if (TeamGb != "") {
            localStorage.setItem("TeamGb", TeamGb);
        } else {
            localStorage.setItem("TeamGb", $("#TeamGb").val());
        }

        $("#game-type").change(function () {
            localStorage.setItem("GroupGameGb", $("#game-type").val());
            callRGameLevel();
        });

    });

    function search() {
        /*인쇄 헤더 설정*/ //구분//소속//체급
        var GameTitleName = $("#GameTitleIDX option:selected").text().replace("(종료)", "");
        GameTitleName = GameTitleName.replace("(예정)", "");
        GameTitleName = GameTitleName.replace("(진행중)", "");

        $("#tourney_title").html("<span class=''>" + GameTitleName + "</span>");
        /*인쇄 헤더 설정*/
        localStorage.setItem("TeamGb", $("#TeamGb").val());
    }


    function chk_frm_title() {
        $("#game-type").val("");
        $("#GameDay").val("");
        $("#TeamGb").val("");
        chk_frm();
    }
    function chk_frm_day() {
        $("#game-type").val("");
        $("#TeamGb").val("");
        chk_frm();
    }

    function chk_frm() {

        var GameTitleName = $("#GameTitleIDX option:selected").text().replace("(종료)", "");
        GameTitleName = GameTitleName.replace("(예정)", "");
        GameTitleName = GameTitleName.replace("(진행중)", "");

        $("#tourney_title").html(GameTitleName);
        var f = document.search_frm;

        localStorage.setItem("GameTitleName", GameTitleName);
        localStorage.setItem("EnterType", $("#EnterType").val());
        f.action = "";
        f.target = "";
        f.submit();
    }
</script>
<body  onload="onLoad()" id="AppBody">
<section>
	<div id="content">
		<div class="loaction" id="loaction">
			<strong>대회관리</strong> &gt; 입상현황
		출력</div>
	    <!-- S : top-navi-tp 접혔을 때-->
	    <div class="top-navi-tp">
			    <!-- S : sch 검색조건 선택 및 입력 -->
                <!--조회 S-->
			<form name="search_frm" method="post">
                <div class="sch">
					<table class="sch-table">
						<caption>검색조건 선택 및 입력</caption>
						<colgroup>
							<col width="70px" />
							<col width="*" />
							<col width="70px" />
							<col width="*" />
							<col width="70px" />
							<col width="*" />
							<col width="70px" />
							<col width="*" />
							<col width="70px" />
							<col width="*" />
							<col width="70px" />
							<col width="*" />
							<col width="70px" />
							<col width="*" />
							<col width="70px" />
							<col width="*" />
						</colgroup>						
						<tbody>
                            <tr>				
						        <th scope="row">대회년도</th>
						        <td id="sel_Search_GameYear">
							        <select id="Search_GameYear" name="Search_GameYear" onChange="chk_frm();">
                                        <%
                                        If SportsGb <> "" Then 
	                                        YEARSQL = " SELECT GameYear FROM Sportsdiary.dbo.tblGametitle "
                                            YEARSQL =YEARSQL+ " WHERE ViewState='1' AND DelYN='N'  AND SportsGb='"&SportsGb&"' "
                                            YEARSQL =YEARSQL+ "  AND  GameS<=CONVERT(NVARCHAR,DATEADD(DAY,1,GETDATE()),112) "
                                            YEARSQL =YEARSQL+ " GROUP BY GameYear ORDER BY GameYear DESC"
	                                        Set YRs = Dbcon.Execute(YEARSQL)

	                                        If Not(YRs.Eof Or YRs.Bof) Then 
		                                        Do Until YRs.Eof 
                                                %><option value="<%=YRs("GameYear")%>" <%If YRs("GameYear") = GameYear Then %>selected<% GameYear= YRs("GameYear")  
                                                End If %> > <%=YRs("GameYear")%></option> <%
			                                    YRs.MoveNext
		                                        Loop 
	                                        End If 
                                        End If 
                                        %>
							        </select>
						        </td>			
						        <th scope="row"><label for="competition-name-2">종목선택</label></th>
						        <td>
							        <select name="SportsGb" id="SportsGb" onChange="chk_frm();">
								        <%
									        SSQL = "SELECT PubCode,PubName FROM Sportsdiary.dbo.tblPubcode WHERE DelYN='N' AND PPubCode='sd000'"
									        Set sRs = Dbcon.Execute(SSQL)
									        If Not(SRs.Eof Or SRs.Bof) Then 
										        Do Until SRs.Eof 
								                    %>
								                    <option value="<%=SRs("PubCode")%>" <%If SRs("PubCode") = SportsGb Then %>selected<%End If%>><%=SRs("PubName")%></option>
								                    <%
											        SRs.MoveNext
										        Loop 
									        End If 
								        %>
							        </select>
						        </td>
						        <th scope="row"><label for="competition-name-2">대회선택</label></th>
						        <td>
							        <select name="GameTitleIDX" id="GameTitleIDX" onChange="chk_frm_title();">
								        <option value="">대회를 선택하여 주시기 바랍니다.</option>
								        <%
									        If SportsGb <> "" Then  
										        GSQL = "SELECT GameTitleIDX ,EnterType "
                                                GSQL = GSQL &" ,case when GameE<=CONVERT(NVARCHAR,GETDATE(),120) then '(종료)'  " 
                                                GSQL = GSQL &" when GameS<=CONVERT(NVARCHAR,GETDATE(),120) and GameE>=CONVERT(NVARCHAR,GETDATE(),120)  then '(진행중)' else '(예정)' end TitleTag   " 
                                                GSQL = GSQL &" ,GameTitleName   " 
                                                GSQL = GSQL &" FROM Sportsdiary.dbo.tblGametitle  " 
                                                GSQL = GSQL &" WHERE ViewState='1' AND MatchYN='Y'  AND DelYN='N'  AND GameYear='"&GameYear&"' AND SportsGb='"&SportsGb&"' "
                                                GSQL = GSQL &"  AND  GameS<=CONVERT(NVARCHAR,DATEADD(DAY,1,GETDATE()),120)  "
                                                GSQL = GSQL &" ORDER BY GameS DESC "

										        Set GRs = Dbcon.Execute(GSQL)

										        If Not(GRs.Eof Or GRs.Bof) Then 
											        Do Until GRs.Eof  
                                                    %>
								                        <option value="<%=GRs("GameTitleIDX")%>" <%If CStr(GRs("GameTitleIDX")) = CStr(GameTitleIDX) Then %>selected<% 
                                                            GameTitleName= GRs("GameTitleName")  
                                                            EnterType= GRs("EnterType")  
                                                        End If
                                                        %>><%=GRs("TitleTag")%><%=GRs("GameTitleName")%></option>
								                        <%
												        GRs.MoveNext
											        Loop 
										        End If 
									        End If 
								        %>
							        </select>
                                    <input type="hidden" id="GameTitleName" name="GameTitleName"  value="<%=GameTitleName %>"/>
						        </td>
						        <th scope="row"><label for="competition-name-2">대회일자</label></th>
						        <td >
							        <select id="GameDay" name="GameDay" onChange="chk_frm_day();">
								        <option value="">전체</option>
								        <%
									        If SportsGb<>"" And GameTitleIDX <> "" Then 
									        DSQL = "SELECT Distinct(A.GameDay) AS GameDay ,replace(CONVERT(NVARCHAR,GETDATE(),111),'/','-') dayToday "
                                            DSQL =DSQL&" FROM Sportsdiary.dbo.tblRgameLevel    A INNER JOIN tblGameScore B ON B.RGameLevelidx = A.RGameLevelidx "
                                            DSQL =DSQL&" WHERE A.DelYN='N' AND B.DelYN='N' AND A.GameTitleIDX='"&GameTitleIDX&"' Order By A.GameDay"
                                            selectGameDay =""
									        Set DRs = Dbcon.Execute(DSQL)
										        If Not(DRs.Eof Or DRs.Bof) Then 
											        Do Until DRs.Eof 
								                        %>
								                        <option value="<%=DRs("GameDay")%>" 
                                                        <%If CStr(DRs("GameDay")) = CStr(GameDay) Then %> selected <% selectGameDay=CStr(DRs("GameDay"))
                                                        else
                                                             if selectGameDay="" then 
                                                                If CStr(DRs("GameDay")) = CStr(DRs("dayToday")) Then 
                                                                %> selected <% selectGameDay=CStr(DRs("dayToday"))
                                                                End If 
                                                            end if
                                                        End If 
                                                        %>><%=DRs("GameDay")%></option>
								                        <%
												        DRs.MoveNext
											        Loop 
										        End If 
									        End If 

                                            GameDay = selectGameDay
								        %>
							        </select>
						        </td>
					        </tr>
                            <tr  <% if GameTitleIDX ="" then %>  style="display: none"    <% end if %>  >
                                <th scope="row"><label for="competition-name-2">구분</label></th>
                                <td>
                                        <select id="game-type" name="game-type" class="srch-sel" data-native-menu="false" onChange="chk_frm();"> 
                                        <option value="">::선택::</option>
                                        <%
									        If SportsGb<>"" And GameTitleIDX <> "" Then 
									        DSQL = "SELECT A.GroupGameGb,Sportsdiary.dbo.FN_PubName( A.GroupGameGb)GroupGameGbNm "
                                            DSQL =DSQL& " FROM Sportsdiary.dbo.tblRgameLevel   A INNER JOIN tblGameScore B ON B.RGameLevelidx = A.RGameLevelidx"
                                            DSQL =DSQL& " WHERE A.DelYN='N' AND B.DelYN='N' AND A.GameTitleIDX='"&GameTitleIDX&"' "
                                                
                                            if GameDay <>"" then
                                                DSQL =DSQL& "and A.GameDay ='"&GameDay&"' "
                                            end if

                                            DSQL =DSQL& "group by A.GroupGameGb Order By A.GroupGameGb"

									        Set DRs = Dbcon.Execute(DSQL)
										        If Not(DRs.Eof Or DRs.Bof) Then 
											        Do Until DRs.Eof 
								                        %>
								                        <option value="<%=DRs("GroupGameGb")%>" 
                                                        <%If CStr(DRs("GroupGameGb")) = CStr(GroupGameGb) Then %> selected 
                                                        <% End If %>><%=DRs("GroupGameGbNm")%></option>
								                        <%
												        DRs.MoveNext
											        Loop 
										        End If 
									        End If 
								        %>
                                    </select>
                                </td>
                                <th scope="row"><label for="competition-name-2">소속</label></th>
                                <td>
                                        <select id="TeamGb" name="TeamGb" class="srch-sel" data-native-menu="false" onChange="chk_frm();"> <option value="">::선택::</option></select>
                                </td>
                                <td>
                                    <button type="button" id="SectionPrint" class="btn btn-warning btn-search" onClick="SectionPrintClick('madalprint','print');" >인쇄</button>
                                </td>  
                            </tr>
						</tbody>
					</table>
			    </div>
			</form>
            <!--조회 E-->
	    </div>

    <form name="s_frm" method="post"> 
        <input type="hidden" id="S_GameYear" name="GameYear" value="<%=GameYear %>" />
        <input type="hidden" id="S_SportsGb" name="SportsGb" value="<%=SportsGb %>" />
        <input type="hidden" id="S_GameTitleIDX" name="GameTitleIDX" value="<%=GameTitleIDX %>" />
        <input type="hidden" id="S_GameTitleNamer" name="GameTitleName" value="<%=GameTitleName %>" />
        <input type="hidden" id="S_gametype" name="game-type" value="<%=gametype %>" />
        <input type="hidden" id="S_GameDay" name="GameDay" value="<%=GameDay %>" />
        <input type="hidden" id="S_GroupGameGb" name="GroupGameGb" value="<%=GroupGameGb %>" />
        <input type="hidden" id="S_EnterType" name="EnterTyper" value="<%=EnterType %>" />
        <input type="hidden" id="S_TeamGb" name="TeamGb" value="<%=TeamGb %>" />

        
    </form>
    
   <div id="list_body"> 
    <!-- S: tourney-title -->
        <div class="sub sub-main tourney container-fluid">
            <h2 class="stage-title row" id="tourney_title"></h2>
        </div>
    <!-- S: tourney-title -->
   
    <%
   strSql = "SELECT A.SportsGb,A.GameTitleIDX,Sportsdiary.dbo.FN_PubName(A.GroupGameGb) AS GroupGameGbName, Sportsdiary.dbo.FN_TeamGbNM(A.SportsGb, A.TeamGb) AS TeamGbName, A.TeamGb, A.GroupGameGb"
   strSql = strSql& " FROM tblRGameLevel A INNER JOIN tblGameScore B ON B.RGameLevelidx = A.RGameLevelidx "
   strSql = strSql& " WHERE a.SportsGb = '" &SportsGb&"'" 
   strSql = strSql& " AND a.GameTitleIDX = '" &GameTitleIDX&"'"        
   
   if GameDay<>"" then
   strSql = strSql&  " AND A.GameDay = '" &GameDay&"'"
   end if
    
   if GroupGameGb<>"" then
   strSql = strSql&  " AND A.GroupGameGb = '" &GroupGameGb&"'"
   end if

   if TeamGb<>"" then
   strSql = strSql&  " AND A.TeamGb = '" &TeamGb&"'"
   end if
    
   strSql = strSql& " AND A.DelYN = 'N'" 
   strSql = strSql& " AND B.DelYN = 'N'" 
   strSql = strSql& " GROUP BY A.SportsGb,A.GameTitleIDX,A.GroupGameGb, A.TeamGb"

    Set Rs = Dbcon.execute(strSql)
    If Not (Rs.Eof Or Rs.Bof) Then
    Do Until Rs.Eof 

    %>
    <!-- S: list_body --> 
    
    <div class="operating-medal">
        <h3 class="top-navi-tit">
    		<span class="circle_icon"></span>
    		<strong><%=Rs("TeamGbName") %></strong>
    		<strong>[<%=Rs("GroupGameGbName") %>]</strong>
    	</h3>
        
        <table class="table table-bordered table-striped operating-medal-table" style=" text-align:center">
			<caption>검색조건 선택 및 입력</caption>
			<colgroup>
				<col width="70px" />
				<col width="100px" />
				<col width="70px" />
				<col width="70px" />
				<col width="70px" />
				<col width="150px" />
				<col width="150px" />
				<col width="150px" />
				<col width="150px" />
			</colgroup>	
            <thead>
                <tr class="title">
                    <th>구분</th>
                    <th>대전방식</th>
                    <th>소속</th>
                    <th>성별</th>
                    <th>체급</th>
                    <th><span class="gold-medal"><img src="../../Webtournament/www/images/tournerment/stat/gold-medal.png" alt="" width="23" height="30"></span>금</th>
                    <th><span class="silver-medal"><img src="../../Webtournament/www/images/tournerment/stat/silver-medal.png" alt="" width="23" height="30"></span>은</th>
                    <th><span class="bronze-medal"><img src="../../Webtournament/www/images/tournerment/stat/bronze-medal.png" alt="" width="23" height="30"></span>동</th>
                    <th><span class="bronze-medal"><img src="../../Webtournament/www/images/tournerment/stat/bronze-medal.png" alt="" width="23" height="30"></span>동</th>
                </tr>
            </thead>
            <tbody>
                <% 
                if Rs("GroupGameGb")="sd040001" then

                DetSql = "SELECT Sportsdiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName, Sportsdiary.dbo.FN_TeamGbNm(SportsGb, TeamGb) AS TeamGbName, Sportsdiary.dbo.FN_LevelNm(SportsGb, TeamGb, Level) AS LevelName, Sex,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Gold)) AS GoldMedalName, MAX(GoldUserName) AS GoldUserName, MAX(GoldSCName) AS GoldSCName,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Silver)) AS SilverName, MAX(SilverUserName) AS SilverUserName, MAX(SilverSCName) AS SilverSCName,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Bronze1)) AS Bronze1Name, MAX(BronzeUserName1) AS BronzeUserName1, MAX(BronzeSCName1) AS BronzeSCName1,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Bronze2)) AS Bronze2Name, MAX(BronzeUserName2) AS BronzeUserName2, MAX(BronzeSCName2) AS BronzeSCName2,"
                DetSql =  DetSql& " Sportsdiary.dbo.FN_PubName(GameType) AS GameType,"
                DetSql =  DetSql& " GroupGameGb, TeamGb, Sex, Level"
                DetSql =  DetSql& " FROM "
                DetSql =  DetSql& " 	("
                DetSql =  DetSql& " 	SELECT B.GroupGameGb, A.TeamGb, A.Level, A.Sex, A.GameType,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN TitleResult ELSE '' END AS Gold,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN UserName ELSE '' END AS GoldUserName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS GoldSCName,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN TitleResult ELSE '' END AS Silver,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN UserName ELSE '' END AS SilverUserName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS SilverSCName,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN TitleResult ELSE '' END AS Bronze1,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN UserName ELSE '' END AS BronzeUserName1,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName1,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN TitleResult ELSE '' END AS Bronze2,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN UserName ELSE '' END AS BronzeUserName2,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName2,"
                DetSql =  DetSql& "     A.SportsGb"
                DetSql =  DetSql& " 	FROM tblRGameLevel A"
                DetSql =  DetSql& " 	INNER JOIN tblGameScore B ON B.RGameLevelidx = A.RGameLevelidx"
                DetSql =  DetSql& " 	INNER JOIN tblRPlayer C ON C.RGameLevelidx = B.RGameLevelidx AND C.PlayerIDX = B.PlayerIDX"
                DetSql =  DetSql& " 	WHERE A.SportsGb = '" & Rs("SportsGb") & "'"
                DetSql =  DetSql& "     AND A.GameTitleIDX = '" & Rs("GameTitleIDX") & "'"

               if GameDay<>"" then
               DetSql =  DetSql& " 	AND A.GameDay = '" & GameDay & "'"
               end if

                DetSql =  DetSql& " 	AND A.TeamGb = '" & Rs("TeamGb") & "'"
                DetSql =  DetSql& " 	AND B.GroupGameGb = '" & Rs("GroupGameGb") & "'"
                DetSql =  DetSql& " 	AND A.DelYN = 'N'"
                DetSql =  DetSql& " 	AND B.DelYN = 'N'"
                DetSql =  DetSql& " 	AND C.DelYN = 'N'"
                DetSql =  DetSql& " 	) AS AA"
                DetSql =  DetSql& " GROUP BY GroupGameGb, TeamGb, Level, Sex, GameType, SportsGb"

                else

                DetSql = "SELECT Sportsdiary.dbo.FN_PubName(GroupGameGb) AS GroupGameGbName, Sportsdiary.dbo.FN_TeamGbNm(SportsGb, TeamGb) AS TeamGbName, Sportsdiary.dbo.FN_LevelNm(SportsGb, TeamGb, Level) AS LevelName, Sex,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Gold)) AS GoldMedalName, MAX(GoldUserName) AS GoldUserName, MAX(GoldSCName) AS GoldSCName,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Silver)) AS SilverName, MAX(SilverUserName) AS SilverUserName, MAX(SilverSCName) AS SilverSCName,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Bronze1)) AS Bronze1Name, MAX(BronzeUserName1) AS BronzeUserName1, MAX(BronzeSCName1) AS BronzeSCName1,"
                DetSql =  DetSql& " MAX(Sportsdiary.dbo.FN_PubName(Bronze2)) AS Bronze2Name, MAX(BronzeUserName2) AS BronzeUserName2, MAX(BronzeSCName2) AS BronzeSCName2,"
                DetSql =  DetSql& " Sportsdiary.dbo.FN_PubName(GameType) AS GameType,"
                DetSql =  DetSql& " GroupGameGb, TeamGb, Sex, Level"
                DetSql =  DetSql& " FROM "
                DetSql =  DetSql& " 	("
                DetSql =  DetSql& " 	SELECT B.GroupGameGb, A.TeamGb, A.Level, A.Sex, A.GameType,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN TitleResult ELSE '' END AS Gold,"
                DetSql =  DetSql& " 	'' AS GoldUserName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034001' AND GameRanking = '1' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS GoldSCName,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN TitleResult ELSE '' END AS Silver,"
                DetSql =  DetSql& " 	'' AS SilverUserName,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034002' AND GameRanking = '2' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS SilverSCName,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN TitleResult ELSE '' END AS Bronze1,"
                DetSql =  DetSql& " 	'' AS BronzeUserName1,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '3' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName1,"
                DetSql =  DetSql& " 	CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN TitleResult ELSE '' END AS Bronze2,"
                DetSql =  DetSql& " 	'' AS BronzeUserName2,"
                DetSql =  DetSql& "     CASE WHEN TitleResult = 'sd034003' AND GameRanking = '4' THEN SportsDiary.dbo.FN_TeamNm(B.SportsGb, B.TeamGb, B.Team) ELSE '' END AS BronzeSCName2,"
                DetSql =  DetSql& "     A.SportsGb"
                DetSql =  DetSql& " 	FROM tblRGameLevel A"
                DetSql =  DetSql& " 	INNER JOIN tblGameScore B ON B.RGameLevelidx = A.RGameLevelidx"
                DetSql =  DetSql& " 	WHERE A.SportsGb = '" & Rs("SportsGb") & "'"
                DetSql =  DetSql& "     AND A.GameTitleIDX = '" & Rs("GameTitleIDX") & "'"

               if GameDay<>"" then
               DetSql =  DetSql& " 	AND A.GameDay = '" & GameDay & "'"
               end if

                DetSql =  DetSql& " 	AND A.TeamGb = '" & Rs("TeamGb") & "'"
                DetSql =  DetSql& " 	AND B.GroupGameGb = '" & Rs("GroupGameGb") & "'"
                DetSql =  DetSql& " 	AND A.DelYN = 'N'"
                DetSql =  DetSql& " 	AND B.DelYN = 'N'"
                DetSql =  DetSql& " 	) AS AA"
                DetSql =  DetSql& " GROUP BY GroupGameGb, TeamGb, Level, Sex, GameType, SportsGb"  

                end if

              
                %>
               <!-- <tr>
                    <td colspan=9>-->
                    <% 
                     ' Response.Write DetSql
                    %> 
                   <!-- </td>
                </tr>-->
                <%
                Set detailRs = Dbcon.execute(DetSql)
                If Not (detailRs.Eof Or detailRs.Bof) Then
                Do Until detailRs.Eof 
                %>
                <tr>	
                    <td><%=detailRs("GroupGameGbName") %></td>	
                    <td><%=detailRs("GameType") %></td>	
                    <td><%=detailRs("TeamGbName") %></td>	
                    <td class="<%=detailRs("Sex") %>"><% IF detailRs("Sex")="Man" then%>남자<%else %>여자<%end if %></td>	
                    <td><%=detailRs("LevelName") %></td>	
                    <td>		<p class="player"><%=detailRs("GoldUserName") %></p>		<p class="school">(<%=detailRs("GoldSCName") %>)</p>	</td>	
                    <td>		<p class="player"><%=detailRs("SilverUserName") %></p>		<p class="school">(<%=detailRs("SilverSCName") %>)</p>	</td>	
                    <td>		<p class="player"><%=detailRs("BronzeUserName1") %></p>		<p class="school">(<%=detailRs("BronzeSCName1") %>)</p>	</td>	
                    <td>		<p class="player"><%=detailRs("BronzeUserName2") %></p>		<p class="school">(<%=detailRs("BronzeSCName2") %>)</p>	</td>	
                </tr>
                <%
                detailRs.MoveNext
                Loop 
                End If 
                 %>
            </tbody>
        </table>
    </div>
    <!-- E: list_body -->
    <%
    Rs.MoveNext
    Loop 
    End If 
    %>
</div>
    
</div>
<div id="madalprint"  style="display: none;">  </div>  
</section>
<script src="js/trans_film_rec.js"></script>
</body>



				
                	








