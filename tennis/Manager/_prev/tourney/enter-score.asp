<!--#include virtual="/Manager/Common/common_header_tourney.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->

<%Response.cookies("GameTitleIDX")=  "" %>
<%
GameYear = fInject(Request("Search_GameYear"))
SportsGb  =   fInject(Request("SportsGb"))
GameTitleIDX  =   fInject(Request("GameTitleIDX"))
GameTitleName   =   fInject(Request("GameTitleName"))
GameDay   =   fInject(Request("GameDay"))
GroupGameGb   =  fInject(Request("GroupGameGb"))
EnterType =   fInject(Request("EnterType"))
TeamGb   =   fInject(Request("TeamGb"))
Sex   =   fInject(Request("Sex"))
Level   =   fInject(Request("Level"))
SexLevel   =   fInject(Request("SexLevel"))
RGameLevelidx  =   fInject(Request("RGameLevelidx"))


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
    <title>상세기록조회</title>
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
        .Enter_Score_Print_Fr
        {
        width:1px;
        height:1px;
        border:0;
        }
    </style>

    <link href="css/bootstrap-theme.css" rel="stylesheet" type="text/css" />
    <link href="css/bootstrap.css" rel="stylesheet" type="text/css" />
      <!-- bootstrap popover -->
    <link href="css/tourney.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../Css/_enter-score.css">
     
    <script src="../../webtournament/www/js/global.js"></script>
    <script src="../Js/jquery-1.12.2.min.js" type="text/javascript"></script>
    <script src="js/html2canvas.js"></script>
    <script src="js/tourneyData.js"></script>
    <script src="js/tourney_print.js" type="text/javascript"></script>

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
    var SexLevel = "<%=SexLevel %>";

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
    localStorage.setItem("SexLevel", SexLevel);

    var PlayerGameNum = 1;
    var PlayerResultNum = 1;

    //댑스별로 상단에서 하단으로 내려오는 리스트 카운트하여 1/2 처리. 반드시 짝수여야 한다.(부전승은 2)
    var LLevelLineCount = 0;
    var RLevelLineCount = 0;

    var onLoad = function () {
        localStorage.setItem("GroupGameGb", GroupGameGb);
        var PromiseInjuryGb = $.when(m_SelTeamCode_NowGame("#TeamGb", TeamGb));
        PromiseInjuryGb.done(function () {

            localStorage.setItem("GameDay", $("#GameDay").val());
            localStorage.setItem("GroupGameGb", $("#GroupGameGb").val());
            localStorage.setItem("TeamGb", $("#TeamGb").val());


            if (SexLevel == "") {
                m_drLevelList_sum_NowGame("#SexLevel", $("#TeamGb").val(), '');
            } else {
                m_drLevelList_sum_NowGame("#SexLevel", $("#TeamGb").val(), SexLevel);
                search();
            }
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
         
        localStorage.setItem("GroupGameGb", GroupGameGb);

        if (TeamGb != "") {
            localStorage.setItem("TeamGb", TeamGb);
        } else {
            localStorage.setItem("TeamGb", $("#TeamGb").val());
        }

        if (localStorage.getItem("TeamGb") != "" && localStorage.getItem("Sex") != "") {
            if (localStorage.getItem("GroupGameGb") == "sd040002") {
                m_drLevelList_sum_NowGame("#SexLevel", localStorage.getItem("TeamGb"), "");
            } else {
                m_drLevelList_sum_NowGame("#SexLevel", localStorage.getItem("TeamGb"), localStorage.getItem("SexLevel"));
            }
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


        if (SexLevel != "") {
            localStorage.setItem("SexLevel", SexLevel);

            search();
        } else {
            localStorage.setItem("SexLevel", $('#SexLevel').val());
        }




        $("#GroupGameGb").change(function () {
            localStorage.setItem("GroupGameGb", $("#GroupGameGb").val());
            m_drLevelList_sum_NowGame("#SexLevel", $("#TeamGb").val(), "");
            callRGameLevel();
        });
        $("#TeamGb").change(function () {
            if ($("#TeamGb").val() != "") {
                localStorage.setItem("GroupGameGb", $("#GroupGameGb").val());
                m_drLevelList_sum_NowGame("#SexLevel", $("#TeamGb").val(), '');
            }
        });

        $("#BtnSearch").click(function () {
            search();
        });

    });

    function search() {

        Unchk_all();

        /*인쇄 초기화 설정*/ //구분//소속//체급
        $("#Enter_Score_Print").html("");
        $("#Enter_Score_Print_new").html("");
        /*인쇄 초기화 설정*/
        localStorage.setItem("TeamGb", $("#TeamGb").val());

        if (localStorage.getItem("GroupGameGb") == "sd040002") {
            $(".tourney-mode").addClass("group");

            $("#SexLevel option:eq(1)").attr("selected", "selected");

            if ($("#TeamGb option:selected").text().indexOf("남자") >= 0) {
                localStorage.setItem("Sex", "Man");
            } else {
                localStorage.setItem("Sex", "WoMan");
            }
            localStorage.setItem("Level", "");

        } else {
            $(".tourney-mode").removeClass("group");
            if ($("#SexLevel").val() == "") {
                alert("체급을 선택 하지 않았습니다.");
                $("#SexLevel").focus();
                return false;
            }


            if ($("#SexLevel").val() != "") {
                localStorage.setItem("SexLevel", $("#SexLevel").val());
                localStorage.setItem("Sex", $("#SexLevel option:selected").attr("data-sex"));
                localStorage.setItem("Level", $("#SexLevel option:selected").attr("data-level"));
                $("#sexLevelCheck").hide();
            }
        }
        wrapWindowByMask();
        //해당 체급 정보
        var GameType = $.when(SelectJsonData("checkgamelevel", "../../ajax/judo_os/GGameLevelInfo.ashx", "", "json"));
        GameType.done(function () {

            //상세기록 호출 //화면 그리기
            var dp_data = $.when(SelectJsonData("EnterScore", "select/EnterScoreListData.asp", "DP_tourney", "html"));
            dp_data.done(function () {

            });
        });
        closeWindowByMask();

    }



    function SelectJsonData(linkId, linkurl, cID, typeData) {
        if (typeData == "json") {
            var ajaxUrl = linkurl;
            var defer = $.Deferred();
            var obj = {};

            obj.GameYear = GameYear;
            obj.SportsGb = $("#SportsGb").val();
            obj.GameTitleIDX = $("#GameTitleIDX").val();
            obj.TeamGb = $("#TeamGb").val();
            obj.Sex = $("#SexLevel option:selected").attr("data-sex");
            obj.Level = $("#SexLevel option:selected").attr("data-level");
            obj.GroupGameGb = $("#GroupGameGb").val();
            obj.RGameLevelidx = localStorage.getItem("RGameLevelidx");
            obj.GameType = localStorage.getItem("GameType");
            obj.EnterType = localStorage.getItem("EnterType");

            var jsonData = JSON.stringify(obj);
            var strGameType = "";

            $.ajax({
                url: ajaxUrl,
                dataType: "text",
                type: 'post',
                data: jsonData,
                async: false,
                success: function (sdata) {
                    if (linkId == "checkgamelevel") {
                        var myArr = JSON.parse(sdata);
                        if (myArr.length > 0) {
                            strGameType = myArr[0].GameType
                            localStorage.setItem("GameYear", GameYear);
                            localStorage.setItem("RGameLevelidx", myArr[0].RGameLevelidx);
                            localStorage.setItem("GameType", myArr[0].GameType);
                            localStorage.setItem("HostCode", myArr[0].HostCode);
                            localStorage.setItem("PlayerCnt", myArr[0].PlayerCnt);
                            localStorage.setItem("AreaNameUseYN", myArr[0].AreaNameUseYN);
                        }
                    } else if (linkId == "EnterScore") {
                        $("#" + cID).html(sdata);
                    }

                    defer.resolve(sdata);
                },
                error: function (errorText) {
                    defer.reject(errorText);
                }
            });


            if (linkId == "checkgamelevel") {
                return strGameType;
            } else {
                return defer.promise();
            }
        } else {
            var ajaxUrl = linkurl;
            var defer = $.Deferred();

            $.ajax({
                url: ajaxUrl,
                dataType: "html",
                type: 'post',
                data: {
                    GameYear: GameYear,
                    SportsGb: $("#SportsGb").val(),
                    GameTitleIDX: $("#GameTitleIDX").val(),
                    TeamGb: $("#TeamGb").val(),
                    Sex: $("#SexLevel option:selected").attr("data-sex"),
                    Level: $("#SexLevel option:selected").attr("data-level"),
                    GroupGameGb: $("#GroupGameGb").val(),
                    RGameLevelidx: localStorage.getItem("RGameLevelidx"),
                    GameType: localStorage.getItem("GameType"),
                    EnterType: localStorage.getItem("EnterType"),
                    GameTitleName: $("#GameTitleName").val(),
                    TeamGbNm: $("#TeamGb option:selected").text(),
                    LevelNm: $("#SexLevel option:selected").text(),
                    GroupGameGbNm: $("#GroupGameGb option:selected").text()
                },
                async: false,
                success: function (sdata) {
                    $("#" + cID).html(sdata);
                    defer.resolve(sdata);
                },
                error: function (errorText) {
                    defer.reject(errorText);
                }
            });

            return defer.promise();
        }
    }



    function chk_frm_title() {
        var f = document.search_frm;
        $("#GameDay").val("");
        $("#GroupGameGb").val("");
        $("#TeamGb").val("");
        $("#SexLevel").val("");

        localStorage.setItem("GameDay", "");
        localStorage.setItem("GroupGameGb", "");
        localStorage.setItem("TeamGb", "");
        localStorage.setItem("Level", "");
        localStorage.setItem("Sex", "");
        localStorage.setItem("SexLevel", "");

        chk_frm();
    }


    function chk_frm() {

        $("#GroupGameGb").val("");
        $("#TeamGb").val("");
        $("#SexLevel").val("");

        localStorage.setItem("GroupGameGb", "");
        localStorage.setItem("TeamGb", "");
        localStorage.setItem("Level", "");
        localStorage.setItem("Sex", "");

        var GameTitleName = $("#GameTitleIDX option:selected").text().replace("(종료)", "");
        GameTitleName = GameTitleName.replace("(예정)", "");
        GameTitleName = GameTitleName.replace("(진행중)", "");

        var f = document.search_frm;
        localStorage.setItem("GameTitleName", GameTitleName);
        localStorage.setItem("EnterType", $("#EnterType").val());

        f.submit();

        Unchk_all();
    }

    function chk_all() {
        var chekc = $("input[id*=check_]");
        chekc.each(function () {

            // 리스트에서 체크 된 내용 확인
            var imgidx = "#CanvasImg_" + $(this).next().val();

            //전체 선택 
            if (!$(this).is(":checked")) {
                wrapWindowByMask();
                $(this).prop("checked", true);

                //출력물 호출
                var frm = document.forms["form_" + $(this).next().val()];
                frm.action = "EnterScore_print.asp";
                frm.target = "Enter_Score_Print_Fr" + $(this).next().val();
                frm.submit();
            }
        });

        $("#checkall").attr("onclick", "Unchk_all()").text("전체해제");
    }

    function Unchk_all() {
        var chekc = $("input[id*=check_]");
        chekc.each(function () {
            // 리스트에서 체크 된 내용 확인
            var imgidx = "#CanvasImg_" + $(this).next().val();

            //전체 선택 해제
            if ($(this).is(":checked")) {
                $(this).prop("checked", false);
                $(imgidx).remove();
            }
        });


        $("#checkall").attr("onclick", "chk_all()").text("전체선택"); ;
    }

    function loading() {
        // $('#loadingStr').text("※ 출력물 준비중 입니다. ※");

    }

    function loadingHide() {
        //  $('#loadingStr').text("");
        closeWindowByMask();
    }

    function wrapWindowByMask() {
        //화면의 높이와 너비를 구한다.
        var maskHeight = $(document).height();
        var maskWidth = window.document.body.clientWidth;

        var mask = "<div id='mask' style='position:absolute; z-index:9000; background-color:#000000; display:none; left:0; top:0;'></div>";
        var loadingImg = '';

        loadingImg += "<div id='loadingImg' style='position:absolute; left:50%; top:40%; display:none; z-index:10000;background:#000;color:#fff;padding:20px;border-radius:4px; width:350px; margin:0 auto; text-align:center;'>";
        loadingImg += " <p><h2>출력 준비중 입니다.</h2></p> <br><br><img src='images/ownageLoader/loader2.gif'/> </br>";
        loadingImg += "</div>";

        //화면에 레이어 추가
        $('body')
            .append(mask)
            .append(loadingImg)

        //마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다.
        $('#mask').css({
            'width': maskWidth
                , 'height': maskHeight
                , 'opacity': '0.5'
        });

        //마스크 표시
        $('#mask').show();

        //로딩중 이미지 표시
        $('#loadingImg').show();
    }

    function closeWindowByMask() {
        $('#mask, #loadingImg').hide();
        $('#mask, #loadingImg').remove();
    }

</script>
<body  onload="onLoad()" id="AppBody">
<section>
	<div id="content">
		<div class="loaction" id="loaction">
			<strong>대회관리</strong> &gt; 결과기록지 출력
		</div>
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
                                        <input type="hidden" id="GameTitleName"  value="<%=GameTitleName %>"/>
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
                                <tr  <% if GameTitleIDX ="" then %>  style="display: none"    <% end if %>  >
                                    <th scope="row"><label for="competition-name-2">구분</label></th>
                                    <td>
                                         <select id="GroupGameGb" name="GroupGameGb" class="srch-sel" data-native-menu="false"> 
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
                                         <select id="TeamGb" name="TeamGb" class="srch-sel" data-native-menu="false"> 
                                         
                                         
                                         
                                         </select>
                                    </td>
                                    <th scope="row"><label for="competition-name-2">체급</label></th>
                                    <td>
                                          <select id="SexLevel" name="SexLevel"  class="srch-sel" data-native-menu="false"> 
                                          
                                          
                                          </select>
                                    </td> 
                                     <th scope="row"> 
                                        <button type="button" id="BtnSearch" class="btn btn-warning btn-search"  >조회</button>
                                    </th>
                                </tr>
						    </tbody>
					    </table>
			        </div>
			    </form>
                <!--조회 E-->
	    </div>
        <!-- S: sub sub-main -->
        <div class="sub sub-main tourney container-fluid" id=".oLoader('hide');">
        
            <div>
                <span id="loadingStr"></span>
                <button type="button" class="btn btn-warning" id="checkall" onClick="chk_all();">전체선택</button>
                 <button type="button" id="PrintEnterScore" class="btn btn-warning btn-search" onClick="SectionPrintClick('SectionEnterCorePrintimg','popup');" >상세기록지인쇄</button>

            </div>
            <!--S:상세기록-->
            <div class="tourney-img" style="display: block;" id="DP_tourney"></div>
            <!--E:상세기록-->

            <!--S:체크내용 출력-->
            <div id="Enter_Score_Print"   style=" display:none">  </div> 
            <!--E:체크내용 출력-->

            <!--S:팝업출력 내용-->
            <div id="Enter_Score_Print_new"  style=" display:none">  </div> 
            <!--E:팝업출력 내용-->

        </div>
      <!-- E: sub sub-main board  -->
    </div>
</section>
<script src="js/trans_film_rec.js"></script>
</body>