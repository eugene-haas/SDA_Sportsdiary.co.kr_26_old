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
GroupGameGb   =   fInject(Request("game-type"))
EnterType =   fInject(Request("EnterType"))
TeamGb   =   fInject(Request("TeamGb"))
Level   =   fInject(Request("Level"))
Sex   =   fInject(Request("Sex"))

if SportsGb="" then 
    SportsGb="judo"
end if

if gametype="" then 
    gametype="sd040001"
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

'Response.Write SportsGb & "\GameTitleIDX\" & GameTitleIDX & "\GameTitleName\" & GameTitleName & "\GroupGameGb\" & GroupGameGb & "\TeamGb\" & TeamGb & "\Level\" & Level & "\Sex\"&  Sex 
%>
<head>
    <title>대진표</title>
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
     <style>
       
      .btn-result { margin-top:6px; padding: 0 12px; height: 22px; color: #fff !important; font-size: 15px;vertical-align: top; line-height:22px; font-weight: 900; border: 1px solid #7f8690; background: #98a1ae; background: -moz-linear-gradient(top, #98a1ae 0%, #7f8690 100%); background: linear-gradient(to bottom, #98a1ae 0%,#7f8690 100%); filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#98a1ae', endColorstr='#7f8690',GradientType=0 );}

      .btn-write { margin-top: 6px; padding: 0 12px; height: 22px; color: #4d4d4d; font-size: 15px; vertical-align: top;  line-height:22px; font-weight: 900; border: 1px solid #a2a2a2; background: #fdfdfd; /* Old browsers */ background: -moz-linear-gradient(top, #fdfdfd 0%, #c8c8c8 100%); /* FF3.6-15 */ background: -webkit-linear-gradient(top, #fdfdfd 0%,#c8c8c8 100%); /* Chrome10-25,Safari5.1-6 */ background: linear-gradient(to bottom, #fdfdfd 0%,#c8c8c8 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */ filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fdfdfd', endColorstr='#c8c8c8',GradientType=0 ); /* IE6-9 */ }

      .btn-save-finish { display:block; margin:0 auto; padding:0; color: #fff !important; width: 248px; height: 40px; line-height: 40px; font-family: 'Noto KR Bold'; font-size: 20px; background: -moz-linear-gradient(top, #ff6500 0%, #ff3800 100%); background: -webkit-linear-gradient(top, #ff6500 0%,#ff3800 100%); background: linear-gradient(to bottom, #ff6500 0%,#ff3800 100%); filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ff6500', endColorstr='#ff3800',GradientType=0 ); border: 1px solid #ff530d;}

    
    </style>

    <script src="../../webtournament/www/js/global.js"></script>
    <script src="../js/jquery-1.12.2.min.js"></script> 
    <script src="js/bootstrap.js"></script>
    <script src="js/html2canvas.js"></script>
    <script src="js/tourney.js"></script>
    <script src="js/tourneyData.js"></script>
    <script src="js/tourney_print.js" type="text/javascript"></script>
    <script src="js/tourney_popup.js" type="text/javascript"></script>
</head>

<script type="text/javascript">
    var pageTitle = "대회일정";
    
    var GameYear = "<%=GameYear %>";
    var SportsGb = "<%=SportsGb %>";
    var GameTitleIDX = "<%=GameTitleIDX %>";
    var GameTitleName = "<%=GameTitleName %>";
    var GroupGameGb = "<%=GroupGameGb %>";
    var Level = "<%=Level %>";
    var TeamGb = "<%=TeamGb %>";
    var Sex = "<%=Sex %>";
    var EnterType = "<%=EnterType %>";
    var GameDay = "<%=GameDay %>";


    GameTitleName = GameTitleName.replace("(종료)", "");
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
    localStorage.setItem("Level", Level);
    localStorage.setItem("Sex", Sex);
    localStorage.setItem("SexLevel", Sex + "|" + Level);


    var PlayerGameNum = 1;
    var PlayerResultNum = 1;


    //댑스별로 상단에서 하단으로 내려오는 리스트 카운트하여 1/2 처리. 반드시 짝수여야 한다.(부전승은 2)
    var LLevelLineCount = 0;
    var RLevelLineCount = 0;

    var onLoad = function () {

        $("#tourney_title").html(localStorage.getItem("GameTitleName"));
        var PromiseInjuryGb = $.when(m_SelTeamCode_NowGame("#TeamGb", localStorage.getItem("TeamGb")));
        PromiseInjuryGb.done(function () { m_drLevelList_sum_NowGame("#SexLevel", $("#TeamGb").val(), ""); });

        localStorage.setItem("GroupGameGb", $('#game-type').val());

        if (TeamGb != "") {
            localStorage.setItem("TeamGb", TeamGb);
        } else {
            localStorage.setItem("TeamGb", $("#TeamGb").val());
        }

        if (Sex != "") {
            localStorage.setItem("Sex", Sex);
        } else {
            localStorage.setItem("Sex", $("#SexLevel option:selected").attr("data-sex"));
        }

        if (Level != "") {
            localStorage.setItem("Level", Level);
        } else {
            localStorage.setItem("Level", $("#SexLevel option:selected").attr("data-level"));
        }
        localStorage.setItem("SexLevel", $('#SexLevel').val());

    }

    function chk_frm_title() {
        var f = document.search_frm;
        f.GameDay.value = "";
        chk_frm();
    }

    function chk_frm() {
        jQuery("#SectionPrint").hide();

        var GameTitleName = $("#GameTitleIDX option:selected").text().replace("(종료)", "");
        GameTitleName = GameTitleName.replace("(예정)", "");
        GameTitleName = GameTitleName.replace("(진행중)", "");

        var f = document.search_frm;
        localStorage.setItem("GameTitleName", GameTitleName);
        localStorage.setItem("EnterType", $("#EnterType").val());
        f.submit();
    }
</script>
<body  onload="onLoad()" id="AppBody">

<!--조회 S-->
<!--년도-->
<!--대회정보-->
<!--대회일자-->
<!--조회 E-->
<!--대진표 표시-->

<section>
	<div id="content">
		<div class="loaction" id="loaction">
			<strong>대회관리</strong> &gt; 대진표
		</div>
	            <!-- S : top-navi-tp 접혔을 때-->
	    <div class="top-navi-tp">
			    <!-- S : sch 검색조건 선택 및 입력 -->
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
                                               ' YEARSQL =YEARSQL+ "  AND  GameS<=CONVERT(NVARCHAR,DATEADD(DAY,10,GETDATE()),112) "
                                                YEARSQL =YEARSQL+ " GROUP BY GameYear ORDER BY GameYear DESC"

	                                            Set YRs = Dbcon.Execute(YEARSQL)

	                                            If Not(YRs.Eof Or YRs.Bof) Then 
		                                            Do Until YRs.Eof 
                                                    %>
                                                    <option value="<%=YRs("GameYear")%>" <%If YRs("GameYear") = GameYear Then %>selected<% GameYear= YRs("GameYear")  
                                                    End If
                                                    %>
                                                    >
                                                    <%=YRs("GameYear")%></option>
                                                    <%
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
									            SSQL = "SELECT top 1 PubCode,PubName FROM Sportsdiary.dbo.tblPubcode WHERE DelYN='N' AND PPubCode='sd000'"
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
                                                    'GSQL = GSQL &"  AND  GameS<=CONVERT(NVARCHAR,DATEADD(DAY,10,GETDATE()),112)  "
                                                    GSQL = GSQL &" ORDER BY GameS DESC "

                                                   ' Response.Write GSQL
                                                    'AND MatchYN='Y'
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
							            <select id="GameDay" name="GameDay" onChange="chk_frm();">
								            <option value="">전체</option>
								            <%
									            If SportsGb<>"" And GameTitleIDX <> "" Then 
									            DSQL = "SELECT Distinct(GameDay) AS GameDay ,replace(CONVERT(NVARCHAR,GETDATE(),111),'/','-') dayToday FROM Sportsdiary.dbo.tblRgameLevel  WHERE DelYN='N' AND GameTitleIDX='"&GameTitleIDX&"' Order By GameDay"
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
                                                                  End If 
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
                                <tr  <% if GameTitleIDX ="" then %>  style="display: none;" <% end if %>  >
                                    <th scope="row"><label for="competition-name-2">구분</label></th>
                                    <td>
                                         <select id="game-type" name="game-type" class="srch-sel" data-native-menu="false"> 
                                          <%
									            If SportsGb<>"" And GameTitleIDX <> "" Then 
									            DSQL = "SELECT GroupGameGb,Sportsdiary.dbo.FN_PubName(GroupGameGb)GroupGameGbNm FROM Sportsdiary.dbo.tblRgameLevel WHERE DelYN='N' AND GameTitleIDX='"&GameTitleIDX&"' "
                                                
                                                if GameDay <>"" then
                                                    DSQL =DSQL& "and GameDay ='"&GameDay&"' "
                                                end if

                                                DSQL =DSQL& "group by GroupGameGb Order By GroupGameGb"

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
                                         <select id="TeamGb" name="TeamGb" class="srch-sel" data-native-menu="false"> </select>
                                    </td>
                                    <th scope="row"><label for="competition-name-2">체급</label></th>
                                    <td>
                                          <select id="SexLevel"  name="SexLevel" class="srch-sel" data-native-menu="false" <!--onchange="$('#search').click();"-->> </select>

                                          <input id="Sex"  name="Sex" type=hidden value="<%=Sex %>" />
                                          <input id="Level"  name="Level" type=hidden value="<%=Level %>" />
                                    </td>
                                     <th scope="row"> 
                                        <button type="button" id="search" class="btn btn-warning btn-search">조회</button>
                                    </th>

                                    <td>
                                        <button type="button" id="SectionPrint" class="btn btn-warning btn-search" onclick="SectionPrintClick('SectionPrintimg','print');" style="display:none;">대진표인쇄</button>
                                    </td>  
                                   <!-- <td>
                                        <button type="button" id="PrintEnterScore" class="btn btn-warning btn-search" onclick="SectionPrintClick('SectionEnterCorePrintimg','popup');" >상세기록지인쇄</button>
                                    </td> -->
                                </tr>
						    </tbody>
					    </table>
			        </div>
			    </form>
	    </div>
<form name="s_frm" method="post">

  <!-- S: sub sub-main -->
  <div class="sub sub-main tourney container-fluid">
    <h2 class="stage-title row" id="tourney_title"></h2>
    <!-- S: tourney-title -->
    <!-- S: input-select -->
      <!-- S: tab-menu -->
    <div class="input-select row ent-sel" id ="input-select" >
        <div class="enter-type tab-menu" > 
            <ul class="clearfix" >
                <li class="type-sel" >
                    <label style="font-size: 21px">구분 : <label id="gametype-Span"></label></label>
                </li> 
                <li class="type-sel" style="width: 300px">
                    <label style="font-size: 21px">소속 : <label id="TeamGb-Span"></label> </label>
                </li>
                <li class="type-sel" >
                     <label style="font-size: 21px">체급 : <label id="SexLevel-Span"></label> </label>
                </li>
            </ul>
        </div>
      <!-- E: tab-menu -->
    </div>
    <!-- E: input-select -->
    <!-- S: medal-tab -->
    <ul class="medal-tab row tourney-result" id="DP_MedalList"> </ul>
    <!-- E: medal-tab -->
    <!-- S: tab-panel -->
    <div class="tourney-img" style="display: block;" id="DP_tourney"><!--tab-panel tourney-img-->
    <!-- S: guide-txt -->
      <!-- E: guide-txt -->
      <div class="btn-guide">
        <ul>
          <li>
            <p id="sexLevelCheck">※ 체급을 선택해주세요.</p>
          </li>
        </ul>
      </div>
      <!-- S: tourney-mode -->
      <div class="tourney-mode tourney-result" >
        <!-- S: tourney-->
        <div class="tourney h-fix clearfix"><!--style="transform : scale(0.6);"-->
          <!-- S: left-side -->
          <div class="left-side clearfix">
            <!-- S: match-list -->
           <div  id="match_list_left" class="match-list"></div>
            <!-- E: match-list -->
           <!-- S: Round-1 -->
           <div id="round_01_left" class="round-1"></div>
            <!-- E: Round-1 -->
          
            <!-- S: Round-2 -->
           <div id="round_02_left" class="round-2"></div>
            <!-- E: Round-2 -->
          
            <!-- S: Round-3 -->
           <div id="round_03_left" class="round-3"></div>
            <!-- E: Round-3 -->
          
            <!-- S: Round-4 -->
             <div id="round_04_left" class="round-4"></div>
            <!-- E: Round-4 -->
          
            <!-- S: Round-5 -->
            <div id="round_05_left" class="round-5"></div>
            <!-- E: Round-5 -->
      
            <!-- S: Round-6 -->
            <div id="round_06_left" class="round-6"></div>
            <!-- E: Round-6 -->
      
            <!-- S: final-match -->
            <div class="final-match">
              <!-- S: final-div -->
              <div id="final_div" class="final-div">
            
              </div>
              <!-- E: final-div -->
            </div>
            <!-- E: final-match -->
          </div>
          <!-- E: left-side -->
          
          <!-- S: right-side -->
          <div class="right-side clearfix">
            <!-- S: match-list -->
            <div id="match_list_right" class="match-list"></div>
            <!-- E: match-list -->
            <!-- S: round-1 -->
            <div id="round_01_right" class="round-1"></div>
            <!-- E: round-1 -->
          
            <!-- S: Round-2 -->
            <div id="round_02_right" class="round-2"></div>
            <!-- E: Round-2 -->
            
            <!-- S: Round-3 -->
             <div id="round_03_right" class="round-3"></div>
            <!-- E: Round-3 -->
      
            <!-- S: Round-4 -->
           <div id="round_04_right" class="round-4"></div>
            <!-- E: Round-4 -->
          
            <!-- S: Round-5 -->
             <div id="round_05_right" class="round-5"></div>
            <!-- E: Round-5 -->
      
            <!-- S: Round-6 -->
           <div id="round_06_right" class="round-6"></div>
            <!-- E: Round-6 -->
      
          </div>
          <!-- E: right-side -->
        </div>
        <!-- E: tourney-->
      </div>
      <!-- E: tourney-mode -->
    </div>
    <!-- E: tab-panel -->
    <!-- S: container -->
    <div class="container">
      <!-- S: list_league -->
      <div id="list_league" class="list_league league"></div>
      <!-- E: list_league -->

      <div class="natfinal_tourney" id="DP_natfinal_tourney" style="display: none;">
          <!-- S: guide-txt -->
          <!-- E: guide-txt -->


          <!-- S: 최종평가전(승자)-->
          <div class="tourney 01 t-1 h-fix">
            <h2 class="tourney_tit"><span class="txt">대진</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div  id="match_list_left_natfinal_01" class="match-list" ></div>
              <!-- E: match-list -->
              
              <!-- S: Round-1 -->
              <div id="round_01_left_natfinal_01" class="round-1"></div>
              <!-- E: Round-1 -->
            
              <!-- S: Round-2 -->
              <div id="round_02_left_natfinal_01" class="round-2"></div>
              <!-- E: Round-2 -->
           
              <!-- S: Round-3 -->
              <div id="round_03_left_natfinal_01" class="round-3"></div>
              <!-- E: Round-3 -->
            
              <!-- S: Round-4 -->
              <div id="round_04_left_natfinal_01" class="round-4"></div>
              <!-- E: Round-4 -->
            
              <!-- S: Round-5 -->
              <div id="round_05_left_natfinal_01" class="round-5"></div>
              <!-- E: Round-5 -->

              <!-- S: Round-6 -->
              <div id="round_06_left_natfinal_01" class="round-6"></div>
              <!-- E: Round-6 -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_natfinal_01" class="final-div"></div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_natfinal_01" class="match-list"></div>
              <!-- E: match-list -->
              <!-- S: round-1 -->
              <div id="round_01_right_natfinal_01" class="round-1"></div>
              <!-- E: round-1 -->
            
              <!-- S: Round-2 -->
              <div id="round_02_right_natfinal_01" class="round-2"></div>
              <!-- E: Round-2 -->

              <!-- S: Round-3 -->
              <div id="round_03_right_natfinal_01" class="round-3"></div>
              <!-- E: Round-3 -->

              <!-- S: Round-4 -->
              <div id="round_04_right_natfinal_01" class="round-4"></div>
              <!-- E: Round-4 -->
            
              <!-- S: Round-5 -->
              <div id="round_05_right_natfinal_01" class="round-5"></div>
              <!-- E: Round-5 -->

              <!-- S: Round-6 -->
              <div id="round_06_right_natfinal_01" class="round-6"></div>
              <!-- E: Round-6 -->

            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 최종평가전(승자)-->

          <!-- S: 최종평가전(패자)-->
          <div class="tourney 02 t-2 h-fix" id="DP_natfinal_02">
            <h2 class="tourney_tit"><span class="txt">패자부활전</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div  id="match_list_left_natfinal_02" class="match-list" ></div>
              <!-- E: match-list -->
              
              <!-- S: Round-1 -->
              <div id="round_01_left_natfinal_02" class="round-1"></div>
              <!-- E: Round-1 -->
            
              <!-- S: Round-2 -->
              <div id="round_02_left_natfinal_02" class="round-2"></div>
              <!-- E: Round-2 -->
           
              <!-- S: Round-3 -->
              <div id="round_03_left_natfinal_02" class="round-3"></div>
              <!-- E: Round-3 -->
            
              <!-- S: Round-4 -->
              <div id="round_04_left_natfinal_02" class="round-4"></div>
              <!-- E: Round-4 -->
            
              <!-- S: Round-5 -->
              <div id="round_05_left_natfinal_02" class="round-5"></div>
              <!-- E: Round-5 -->

              <!-- S: Round-6 -->
              <div id="round_06_left_natfinal_02" class="round-6"></div>
              <!-- E: Round-6 -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_natfinal_02" class="final-div"></div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_natfinal_02" class="match-list"></div>
              <!-- E: match-list -->
              <!-- S: round-1 -->
              <div id="round_01_right_natfinal_02" class="round-1"></div>
              <!-- E: round-1 -->
            
              <!-- S: Round-2 -->
              <div id="round_02_right_natfinal_02" class="round-2"></div>
              <!-- E: Round-2 -->

              <!-- S: Round-3 -->
              <div id="round_03_right_natfinal_02" class="round-3"></div>
              <!-- E: Round-3 -->

              <!-- S: Round-4 -->
              <div id="round_04_right_natfinal_02" class="round-4"></div>
              <!-- E: Round-4 -->
            
              <!-- S: Round-5 -->
              <div id="round_05_right_natfinal_02" class="round-5"></div>
              <!-- E: Round-5 -->

              <!-- S: Round-6 -->
              <div id="round_06_right_natfinal_02" class="round-6"></div>
              <!-- E: Round-6 -->

            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 최종평가전(패자)-->

          <!-- E: 최종평가전(패자부활전 부전)-->
          <div class="tourney 03 t-3 h-fix" id="DP_natfinal_03">
            <h2 class="tourney_tit"><span class="txt">패자부활전 결승</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div id="match_list_left_natfinal_03" class="match-list">
                <div class="no-match">
                  <div class="player-info">
                    <span class="player-name" id="LPlayerName_natfinal_03"><!--허송림--></span>   
                    <span class="player-school" id="LSchoolName_natfinal_03"><!--서울체육고등학교--></span> 
                  </div>
                </div>
              </div>
              <!-- E: match-list -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_natfinal_03" class="final-div">
                  <div class="line-div" id="LineButton_natfinal_03"> 
                    <img src="images/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onclick="mov_enterscore(this);" data-id="13" data-whatever="01">13</a>
                  </div>
                </div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_natfinal_03" class="match-list">
                <div class="no-match"> <div class="player-info">
                  <span class="player-name" id="RPlayerName_natfinal_03"><!--박예진--></span>
                  <span class="player-school" id="RSchoolName_natfinal_03"><!--서울체육고등학교--></span>
                </div>
              </div>
            </div>
              <!-- E: match-list -->
            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 최종평가전(패자부활전 부전)-->

          <!-- E: 최종평가전(결승)-->
          <div class="tourney 03 t-4 h-fix" id="DP_natfinal_04">
            <h2 class="tourney_tit"><span class="txt">1,2위 결승</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div id="match_list_left_natfinal_04" class="match-list">
                <div class="no-match">
                  <div class="player-info">
                    <span class="player-name" id="LPlayerName_natfinal_04"><!--허송림--></span>   
                    <span class="player-school" id="LSchoolName_natfinal_04"><!--서울체육고등학교--></span> 
                  </div>
                </div>
              </div>
              <!-- E: match-list -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_natfinal_04" class="final-div">
                  <div class="line-div" id="LineButton_natfinal_04"> 
                    <img src="images/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onclick="mov_enterscore(this);" data-id="14" data-whatever="01">14</a>
                  </div>
                </div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_natfinal_04" class="match-list">
                <div class="no-match"> <div class="player-info">
                  <span class="player-name" id="RPlayerName_natfinal_04"><!--박예진--></span>
                  <span class="player-school" id="RSchoolName_natfinal_04"><!--서울체육고등학교--></span>
                </div>
              </div>
            </div>
              <!-- E: match-list -->
            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 최종평가전(결승)-->

          <!-- E: 최종평가전(결승재경기)-->
          <div class="tourney 03 t-5 h-fix" id="DP_natfinal_05">
            <h2 class="tourney_tit"><span class="txt">1,2위 결승 재경기</span></h2>
            <!-- S: left-side -->
            <div class="left-side clearfix">
              <!-- S: match-list -->
              <div id="match_list_left_natfinal_05" class="match-list">
                <div class="no-match">
                  <div class="player-info">
                    <span class="player-name" id="LPlayerName_natfinal_05"><!--허송림--></span>   
                    <span class="player-school" id="LSchoolName_natfinal_05"><!--서울체육고등학교--></span> 
                  </div>
                </div>
              </div>
              <!-- E: match-list -->

              <!-- S: final-match -->
              <div class="final-match">
                <!-- S: final-div -->
                <div id="final_div_natfinal_05" class="final-div">
                  <div class="line-div" id="LineButton_natfinal_05"> 
                    <img src="images/tournerment/02_final.png" alt=""> <a role="button" class="btn btn-primary btn-look" onclick="mov_enterscore(this);" data-id="15" data-whatever="01">15</a>
                  </div>
                </div>
                <!-- E: final-div -->
              </div>
              <!-- E: final-match -->
            </div>
            <!-- E: left-side -->
            
            <!-- S: right-side -->
            <div class="right-side">
              <!-- S: match-list -->
              <div id="match_list_right_natfinal_05" class="match-list">
                <div class="no-match"> <div class="player-info">
                  <span class="player-name" id="RPlayerName_natfinal_05"><!--박예진--></span>
                  <span class="player-school" id="RSchoolName_natfinal_05"><!--서울체육고등학교--></span>
                </div>
              </div>
            </div>
              <!-- E: match-list -->
            </div>
            <!-- E: right-side -->
          </div>
          <!-- E: 최종평가전(결승재경기)-->
        <!-- E: tourney-->
      </div>
    </div>
    <!-- E: container --> 
      <div id="SectionPrintimg"  style="display: none;">  </div> 
      <div id="SectionEnterCorePrintimg"  style="display: none;">  </div> 
  </div>

  <!-- E: sub sub-main board  -->
 
</form>

  <!-- S: film-modal -->
<div class="modal fade film-modal" id="show-score" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false"><div class="modal-backdrop fade in"></div>
<div class="modal-dialog">
  <div class="modal-content">
    <div class="modal-header clearfix">
      <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      <h3 class="center">SCORE</h3>
    </div>
    <div class="modal-body">
      <h4><span>한판승</span></h4>
       <div class="pracice-score" style="width: 100%">
      <!-- S: pop-point-display -->
              <div class="pop-point-display">
                <!-- S: display-board -->
                <div class="display-board clearfix">
                  <!-- S: point-display -->
                  <div class="point-display clearfix">
                    <ul class="point-title clearfix">
                      <li>선수</li> 
                      <li>한판</li>
                      <li>절반</li>
                      <!-- <li>유효</li> -->
                      <li>지도</li>
                      <li>반칙/실격/<br>부전/기권 승</li>
                      <li>양선수</li>
                    </ul>
                    <ul class="player-1-point player-point clearfix">
                      <li>
                        <a onClick="#">
                        <span class="disp-win"></span>
                        <span class="player-name" id="DP_Edit_LPlayer">홍길동</span>
                        <p class="player-school" id="DP_Edit_LSCName">충남체육고</p></a>
                      </li>
                      <li class="tgClass">
                       <a class="" onClick="#" name="a_jumsugb"><span class="score" id="LJumsuGb1">0</span></a>
                      </li>
                      <li class="tgClass">
                        <a class="" onClick="#" name="a_jumsugb"><span class="score" id="LJumsuGb2">0</span></a>
                      </li>
                      <!-- <li class="tgClass">
                        <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3">0</span></a>
                      </li> -->
                      <li class="tgClass">
                        <a class="" onClick="#" name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb4">0</span></a>
                      </li>
                      <li>
                         <select class="select-win select-box" id="DP_L_GameResult">
                          <option value="">선택</option>
                          <option value="">반칙</option>
                          <option value="">실격</option>
                          <option value="">부전</option>
                          <option value="">기권</option>
                        </select> 
                        <!--<a class="" onclick="#" name="a_jumsugb"><span class="result" id=""></span></a>-->
                      </li>
                      <!-- <li class="tgClass">
                        <a class="" onclick="#" name="a_jumsugb"><span class="both" id="LJumsuGb4">0</span></a>
                      </li> -->
                    </ul>
                    <p class="vs">vs</p>
                    <ul class="player-2-point player-point clearfix">
                      <li>
                        <a onClick="#">
                        <span class="disp-none"></span>
                        <span class="player-name" id="DP_Edit_RPlayer">이의준</span>
                        <p class="player-school" id="DP_Edit_RSCName">서울명덕초</p></a>
                      </li>
                      <li class="tgClass">
                        <a class="" onClick="#" name="a_jumsugb"><span class="score" id="RJumsuGb1">0</span></a>
                      </li>
                      <li class="tgClass">
                        <a class="" onClick="#" name="a_jumsugb"><span class="score" id="RJumsuGb2">0</span></a>
                      </li>
                      <!-- <li class="tgClass">
                        <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
                      </li> -->
                      <li class="tgClass">
                        <a class="" onClick="#" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb4">0</span></a>
                      </li>
                      <li>
                        <select class="select-win select-box" id="DP_R_GameResult">
                          <option value="">선택</option>
                          <option value="">반칙</option>
                          <option value="">실격</option>
                          <option value="">부전</option>
                          <option value="">기권</option>
                        </select> 
                        <!--<a class="" onclick="#" name="a_jumsugb"><span class="result" id=""></span></a>-->
                      </li>
                      <!-- <li class="tgClass">
                        <a class="" onclick="#" name="a_jumsugb"><span class="both" id="LJumsuGb4">0</span></a>
                      </li> -->
                    </ul>
                    <!-- E: point-display -->
                    <div class="player-match-option player-point">
                        <label for="player-match-option-01" class="tgClass default" id="LRResult_Lose"><input type="checkbox" id="player-match-option-01"><span>부전패</span></label>
                        <label for="player-match-option-02" class="tgClass draw" id="LRResult_Draw"><input type="checkbox" id="player-match-option-02"><span id="DP_DualResult_Text">무승부</span></label>
                      </div>
                  </div>
                  <!-- E: point-display -->
                  </div>
                <!-- E: display-board -->
              </div>
              <!-- E: pop-point-display -->
            </div>
          </div>
          <div class="container">
            <!-- S: 기록보기 record-box -->
            <div class="record-box panel"  id="DP_Record" style="display: block;">
                <!-- S: guide-txt -->
                <div class="guide-txt">
                  ※상세 기술의 경우 현장 기록관의 주관적인 판단에 의해 기록되므로 약간의 시각차가 있을 수 있습니다.
                </div>
                <!-- E: guide-txt -->
              <h3>득실기록</h3>
              <ul class="plactice-txt" id="DP_result-list">
                
              </ul>
            </div>
            <!-- E: 기록보기 record-box -->
            <!-- S: 영상보기 film-box -->
            <div class="film-box panel" id="DP_GameVideo" style="display: none;">
              <!--<iframe width="100%" height="260" src="https://www.youtube.com/embed/CtVHss3U3WA" frameborder="0" allowfullscreen></iframe>-->
            </div>
            <!-- E: 영상보기 film-box -->
          </div>

          <div class="modal-footer">
            <div class="btn-list flex">
              <button type="button" onClick="change_btn();" id="btn_movie" class="btn btn-orange btn-film" style="display: inline-block;"> <span class="ic-deco"><img src="../images/film-icon@3x.png" alt=""></span>영상보기</button> 
              <button type="button" onClick="change_btn();" id="btn_log" class="btn btn-orange btn-record" style="display: none;">기록보기</button>
              <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  <!-- E: film-modal -->

  <!-- S: Winner  result Modal -->
  <div class="modal fade round-res" id="groupshow-score" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <!-- S: modal-header -->
        <div class="modal-header chk-score">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title" id="modal-title">SCORE</h4>
        </div>
        <!-- E: modal-header -->
        <div class="modal-body group-modal">
          <h2><span class="left-arrow"><img src="../../webtournament/www/images/tournerment/tourney/yellow-larr.png" alt></span><span id="DP_WinGroup">송도고(27.5점) 승</span><span class="right-arrow"><img src="../../webtournament/www/images/tournerment/tourney/yellow-rarr.png" alt></span></h2>
          <!-- S: display-board -->
          <div class="display-board clearfix">
            <ul>
              <li class="win" id="DP_LSchoolName">송도고등학교</li>
              <li id="DP_LResult">3승0무2패(206.2)</li>
            </ul>
            <div class="v-s">
              VS
            </div>
            <ul class="away">
              <li  id="DP_RSchoolName">우석고등학교</li>
              <li id="DP_RResult">2승0무3패(200)</li>
            </ul>
          </div>
          <!-- E: display-board -->
          <!-- S:record -->
          <div class="record record-box" id="DP_GroupRecord">
             <div class="home-team" id="DP_LeftGroup">
               <ul class="title clearfix">
                 <li>선수명</li>
                 <li>체급항목</li>
                 <li>승패</li>
               </ul>
               <ul class="clearfix">
                 <li>배동현이</li>
                 <li>-55kg</li>
                 <li>승(절반승)</li>
               </ul>
               <ul class="clearfix">
                 <li>서현영</li>
                 <li>-60kg</li>
                 <li>승(유효승)</li>
               </ul>
               <ul class="clearfix">
                 <li>이승규</li>
                 <li>-100kg</li>
                 <li>-</li>
               </ul>
               <ul class="clearfix">
                 <li>전홍민</li>
                 <li>-81kg</li>
                 <li>-</li>
               </ul>
               <ul class="clearfix">
                 <li>임정렬</li>
                 <li>-73kg</li>
                 <li>승(유효승)</li>
               </ul>
               <ul class="clearfix">
                 <li>김영석</li>
                 <li>-81kg</li>
                 <li>승(유효승)</li>
               </ul>
               <ul class="clearfix">
                 <li>전홍민</li>
                 <li>-90kg</li>
                 <li>-</li>
               </ul>
             </div>
             <div class="v-s">
               VS
             </div>
             <div class="away-team" id="DP_RightGroup">
               <ul class="title clearfix">
                 <li>승패</li>
                 <li>체급항목</li>
                 <li>선수명</li>
               </ul>
               <ul class="clearfix">
                 <li>-</li>
                 <li>-81kg</li>
                 <li>이종우</li>
               </ul>
               <ul class="clearfix">
                 <li>-</li>
                 <li>-55kg</li>
                 <li>최종민</li>
               </ul>
               <ul class="clearfix">
                 <li>승(유효승)</li>
                 <li>-90kg</li>
                 <li>한수훈</li>
               </ul>
               <ul class="clearfix">
                 <li>승(한판승)</li>
                 <li>-73kg</li>
                 <li>김길모</li>
               </ul>
               <ul class="clearfix">
                 <li>-</li>
                 <li>-60kg</li>
                 <li>구준희</li>
               </ul>
               <ul class="clearfix">
                 <li>-</li>
                 <li>-73kg</li>
                 <li>최보라</li>
               </ul>
               <ul class="clearfix">
                 <li>승(유효승)</li>
                 <li>-90kg</li>
                 <li>최종민</li>
               </ul>
             </div>
          </div>

          <!-- E: record -->
          <!-- S: 영상보기 film-box -->
          <div class="film-box panel" id="DP_GroupGameVideo" style="display: none;"></div>

          <!-- E: 영상보기 film-box -->
           <!-- S: modal footer -->
           <div class="modal-footer">
              <div class="btn-list flex">
                <button type="button" onClick="changegroup_btn();" id="btn_groupmovie" class="btn btn-orange btn-film" style="display: block;">
                <span class="ic-deco">  <img src="../images/film-icon@3x.png" alt="" /></span>영상보기</button>
                <a href="#" onClick="changegroup_btn();" id="btn_grouplog" role="button" class="btn btn-orange btn-record" style="display:none">기록보기</a>
                <a href="#" role="button" class="btn btn-close btn-ins btn-default" data-dismiss="modal">닫기</a>
             </div>
           </div>
           <!--E: modal-footer -->
        </div>
       <!-- E: modal-body -->
      </div><!-- modal-content -->
    </div> <!-- modal-dialog -->
  </div>
   
    </div>
</section>
<script src="js/trans_film_rec.js"></script>
</body>