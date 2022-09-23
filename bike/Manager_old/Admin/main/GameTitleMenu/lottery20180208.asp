<!-- #include file="../../dev/dist/config.asp"-->
<% 
Dim LSQL, LRs
Dim i

Dim GameTitleIDX
Dim GroupGameGb
Dim Sex 
Dim PlayType
Dim TeamGb
Dim Level
Dim LevelJooName
Dim LevelJooNum

GameTitleIDX = Request("GameTitle")
GroupGameGb = Request("GroupGameGb")


PlayType = Request("PlayType")
TeamGb = Request("TeamGb")
Level = Request("Level")
LevelDtl = Request("LevelDtl")


If InStr(PlayType,"|") > 1 Then

    Arr_PlayType = Split(PlayType,"|")

    DEC_Sex = fInject(crypt.DecryptStringENC(Arr_PlayType(0)))
    DEC_PlayType = fInject(crypt.DecryptStringENC(Arr_PlayType(1)))

End if

If InStr(Level,"|") > 1 Then

    Arr_Level = Split(Level,"|")


    DEC_Level = fInject(crypt.DecryptStringENC(Arr_Level(0)))
    DEC_LevelJooName = fInject(crypt.DecryptStringENC(Arr_Level(1)))
    DEC_LevelJooNum = Arr_Level(2)

End if

DEC_GameTitleIDX = crypt.DecryptStringENC(GameTitleIDX)
DEC_GroupGameGb = crypt.DecryptStringENC(GroupGameGb)
DEC_TeamGb = crypt.DecryptStringENC(TeamGb)
DEC_LevelDtl = crypt.DecryptStringENC(LevelDtl)


'crypt.DecryptStringENC(oJSONoutput.NationType)

'crypt.EncryptStringENC("13")

LSQL = " SELECT TotRound,"
LSQL = LSQL & "  CASE WHEN TotRound = '512' THEN '9' "
LSQL = LSQL & "  WHEN TotRound = '256' THEN '8' "
LSQL = LSQL & "  WHEN TotRound = '128' THEN '7' "
LSQL = LSQL & "  WHEN TotRound = '64' THEN '6' "
LSQL = LSQL & "  WHEN TotRound = '32' THEN '5' "
LSQL = LSQL & "  WHEN TotRound = '16' THEN '4' "
LSQL = LSQL & "  WHEN TotRound = '8' THEN '3' "
LSQL = LSQL & "  WHEN TotRound = '4' THEN '2' "
LSQL = LSQL & "  WHEN TotRound = '2' THEN '1' "
LSQL = LSQL & "  Else '0' END AS GangCnt"
LSQL = LSQL & " FROM tblGameLeveldtl "
LSQL = LSQL & " WHERE DelYN = 'N'"
LSQL = LSQL & " AND GameLevelDtlidx = '" & DEC_LevelDtl & "'"

Set LRs = Dbcon.Execute(LSQL)

If Not (LRs.Eof Or LRs.Bof) Then

    TotRound = LRs("TotRound")
    GangCnt = LRs("GangCnt")

End If
%>
<html><head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta charset="utf-8">
  <title>Frameset</title>
  <!--[if IE]>
  <script type="text/javascript">
  document.createElement('header');document.createElement('aside');document.createElement('article');document.createElement('footer');</script>
  <![endif]-->
  <link href="/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css">
  <script src="/js/jquery-1.12.2.min.js"></script>
  <script src="/js/jquery-ui.min.js"></script>

  <link href="/css/bootstrap.min.css" rel="stylesheet" media="screen">
  <script src="/js/bootstrap.min.js"></script>

  <style>
  [draggable] {
    -moz-user-select: none;
    -khtml-user-select: none;
    -webkit-user-select: none;
    user-select: none;
    /* Required to make elements draggable in old WebKit */
    -khtml-user-drag: element;
    -webkit-user-drag: element;
  }
  </style>
  <link rel="stylesheet" href="/css/bmAdmin.css?ver=8">
  <script src="/ckeditor/ckeditor.js"></script><style>.cke{visibility:hidden;}</style>

  <link rel="stylesheet" type="text/css" href="/css/normalize-4.1.1.css">
  <link rel="stylesheet" type="text/css" href="/css/style_bmtourney.css?v=2">


<style>
	.highlighted{background-color: yellow;}
	.highlight{background-color: #fff34d;}
	
	/*
	 * Timepicker stylesheet
	 * Highly inspired from datepicker
	 * FG - Nov 2010 - Web3R 
	 *
	 * version 0.0.3 : Fixed some settings, more dynamic
	 * version 0.0.4 : Removed width:100% on tables
	 * version 0.1.1 : set width 0 on tables to fix an ie6 bug
	 */
	.ui-timepicker-inline { display: inline; }
	#ui-timepicker-div { padding: 0.2em; }
	.ui-timepicker-table { display: inline-table; width: 0; }
	.ui-timepicker-table table { margin:0.15em 0 0 0; border-collapse: collapse; }
	.ui-timepicker-hours, .ui-timepicker-minutes { padding: 0.2em;  }
	.ui-timepicker-table .ui-timepicker-title { line-height: 1.8em; text-align: center; }
	.ui-timepicker-table td { padding: 0.1em; width: 2.2em; }
	.ui-timepicker-table th.periods { padding: 0.1em; width: 2.2em; }

	/* span for disabled cells */
	.ui-timepicker-table td span {
		display:block;
		padding:0.2em 0.3em 0.2em 0.5em;
		width: 1.2em;

		text-align:right;
		text-decoration:none;
	}
	/* anchors for clickable cells */
	.ui-timepicker-table td a {
		display:block;
		padding:0.2em 0.3em 0.2em 0.5em;
	   /* width: 1.2em;*/
		cursor: pointer;
		text-align:right;
		text-decoration:none;
	}


	/* buttons and button pane styling */
	.ui-timepicker .ui-timepicker-buttonpane {
		background-image: none; margin: .7em 0 0 0; padding:0 .2em; border-left: 0; border-right: 0; border-bottom: 0;
	}
	.ui-timepicker .ui-timepicker-buttonpane button { margin: .5em .2em .4em; cursor: pointer; padding: .2em .6em .3em .6em; width:auto; overflow:visible; }
	/* The close button */
	.ui-timepicker .ui-timepicker-close { float: right }

	/* the now button */
	.ui-timepicker .ui-timepicker-now { float: left; }

	/* the deselect button */
	.ui-timepicker .ui-timepicker-deselect { float: left; }

</style>
<script src="//cdn.rawgit.com/fgelinas/timepicker/master/jquery.ui.timepicker.js"></script>
<script src="../../js/CommonAjax.js"></script>
<script>
    $(document).ready(function () {

        //경기일자
        //sel_GameTitle();
        
        //sel_PlayType();

        //sel_TeamGb();

        //sel_Level();

    });

    var sel_GameTitle = function () {

        var obj = {};

        obj.CMD = "GameTitle";

        //location.href = "../../ajax/select/GameTitle.asp?CMD=" + obj.CMD;

        SendPacketSe(obj, "../../ajax/select/GameTitle.asp");
    }

    var sel_PlayType = function () {

        var obj = {};

        obj.CMD = "PlayType";
        obj.GameTitleIDX = $("#GameTitle").val();
        obj.GroupGameGb = $(":input:radio[name=GroupGameGb]:checked").val();

        //location.href = "../../ajax/select/TeamGb.asp?CMD=" + obj.CMD +
        //"&GameTitleIDX=" + $("#GameTitle").val();

        SendPacketSe(obj, "../../ajax/select/PlayType.asp");
    }

    var sel_TeamGb = function () {

        var obj = {};

        obj.CMD = "TeamGb";
        obj.GameTitleIDX = $("#GameTitle").val();
        obj.GroupGameGb = $(":input:radio[name=GroupGameGb]:checked").val();
        obj.PlayType = $("#PlayType").val();

        //location.href = "../../ajax/select/TeamGb.asp?CMD=" + obj.CMD +
        //"&GameTitleIDX=" + $("#GameTitle").val();

        SendPacketSe(obj, "../../ajax/select/TeamGb.asp");
    }

    var sel_Level = function () {

        var obj = {};

        obj.CMD = "Level";
        obj.GameTitleIDX = $("#GameTitle").val();
        obj.GroupGameGb = $(":input:radio[name=GroupGameGb]:checked").val();
        obj.PlayType = $("#PlayType").val();
        obj.TeamGb = $("#TeamGb").val();

       /*
        location.href = "../../ajax/select/Level.asp?CMD=" + obj.CMD +
        "&GameTitleIDX=" + $("#GameTitle").val() +
        "&TeamGb=" + $("#TeamGb").val() +
        "&GroupGameGb=" + $(":input:radio[name=GroupGameGb]:checked").val();
       */

        SendPacketSe(obj, "../../ajax/select/Level.asp");
    }

    var sel_LevelDtl = function () {

        var obj = {};

        obj.CMD = "LevelDtl";
        obj.GameTitleIDX = $("#GameTitle").val();
        obj.GroupGameGb = $(":input:radio[name=GroupGameGb]:checked").val();
        obj.PlayType = $("#PlayType").val();
        obj.TeamGb = $("#TeamGb").val();
        obj.Level = $("#Level").val();

        /*
        location.href = "../../ajax/select/LevelDtl.asp?CMD=" + obj.CMD +
        "&GameTitleIDX=" + $("#GameTitle").val() +
        "&GroupGameGb=" + $(":input:radio[name=GroupGameGb]:checked").val() +
        "&PlayType=" + $("#PlayType").val() +
        "&TeamGb=" + $("#TeamGb").val() +
        "&Level=" + $("#Level").val();
        */

        SendPacketSe(obj, "../../ajax/select/LevelDtl.asp");
    }

    var cli_tourney = function () {
        location.href = "lottery.asp" +
        "?GameTitle=" + $("#GameTitle").val() +
        "&GroupGameGb=" + $(":input:radio[name=GroupGameGb]:checked").val() +
        "&PlayType=" + $("#PlayType").val() +
        "&TeamGb=" + $("#TeamGb").val() +
        "&Level=" + $("#Level").val() +
        "&LevelDtl=" + $("#LevelDtl").val();
    }

    var cli_tourneysave = function () {
        //console.log($("input[name=Hidden_Data]").val());

        var str_Hidden_Data = "";
        var select_length = 0;

        select_length = $("input[name=Hidden_Data]").length;

        console.log("그룹박스 수:" + $("input[name=Hidden_Data]").length);

        for (i = 0; i < select_length; i++) {

            if (i == 0) {
                str_Hidden_Data = $("input[name='Hidden_Data']").eq(i).val();
            }
            else {
                str_Hidden_Data += "," + $("input[name='Hidden_Data']").eq(i).val();
            }
        }

        var obj = {};

        obj.CMD = "TourneySave";
        obj.LevelDtl = "<%=DEC_LevelDtl%>";
        obj.RequestGroupIDX = str_Hidden_Data;


        /*
        location.href = "../../ajax/select/LevelDtl.asp?CMD=" + obj.CMD +
        "&GameTitleIDX=" + $("#GameTitle").val() +
        "&GroupGameGb=" + $(":input:radio[name=GroupGameGb]:checked").val() +
        "&PlayType=" + $("#PlayType").val() +
        "&TeamGb=" + $("#TeamGb").val() +
        "&Level=" + $("#Level").val();
        */

        window.open('about:blank').location.href = "../../ajax/GameTitleMenu/TourneySave.asp?CMD=" + obj.CMD +
        "&LevelDtl=" + obj.LevelDtl +
        "&RequestGroupIDX=" + obj.RequestGroupIDX;

        //SendPacketSe(obj, "../../ajax/select/LevelDtl.asp");
    }

    

    var cli_Request = function (str, idx) {

        $("#Select_STR").val(str);
        $("#Select_GroupIDX").val(idx);

    }

    var cli_tourneyinsert = function (strgang, strnum) {

        var num_TotRound = $("#TotRound").val();

        if ($("#Select_GroupIDX").val() != "") {

            console.log("0:" + num_TotRound);

            for (var i = 1; i <= num_TotRound; i++) {

                console.log("1:" + $("#Hidden_Data_" + strgang + "_" + i).val());
                console.log("2:" + $("#Select_GroupIDX").val());


                if ($("#Hidden_Data_" + strgang + "_" + i).val() == $("#Select_GroupIDX").val()) {
                    alert("이미 대진에 포함된 선수(팀) 입니다.");
                    return;
                }
            }

        }

        $("#Hidden_Data_" + strgang + "_" + strnum).val($("#Select_GroupIDX").val());
        $("#DP_UserName_" + strgang + "_" + strnum).html($("#Select_STR").val());

        $("#Select_STR").val("");
        $("#Select_GroupIDX").val("");

    }

    OnReceiveAjax = function (retdata) {

        var myArr = JSON.parse(retdata);

        if (myArr.CMD == "GameTitle") {


            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);


                $("#GameTitle").find("option").remove();

                for (var i = 0; i < dtlArr.length; i++) {
                    $("#GameTitle").append(new Option(dtlArr[i].GameTitleName, dtlArr[i].GameTitleIDX));

                }

            }
            else {
                $("#GameTitle").find("option").remove();
                $("#GameTitle").append(new Option("-", ""));
            }

            sel_PlayType();
            sel_TeamGb();
            sel_Level();
            sel_LevelDtl();

        }

        else if (myArr.CMD == "PlayType") {

            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                $("#PlayType").find("option").remove();

                for (var i = 0; i < dtlArr.length; i++) {
                    $("#PlayType").append(new Option(dtlArr[i].SexName + dtlArr[i].PlayTypeName, dtlArr[i].Sex + "|" + dtlArr[i].PlayType));

                }

            }
            else {
                $("#PlayType").find("option").remove();
                $("#PlayType").append(new Option("-", ""));
            }

            sel_TeamGb();
            sel_Level();
            sel_LevelDtl();

        }
        else if (myArr.CMD == "TeamGb") {


            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                $("#TeamGb").find("option").remove();

                for (var i = 0; i < dtlArr.length; i++) {
                    $("#TeamGb").append(new Option(dtlArr[i].TeamGbNM, dtlArr[i].TeamGb));

                }

            }
            else {
                $("#TeamGb").find("option").remove();
                $("#TeamGb").append(new Option("-", ""));
            }

            sel_Level();
            sel_LevelDtl();

        }
        else if (myArr.CMD == "Level") {

            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                $("#Level").find("option").remove();

                for (var i = 0; i < dtlArr.length; i++) {
                    $("#Level").append(new Option(dtlArr[i].LevelNM + " " + dtlArr[i].LevelJooNM + " " + dtlArr[i].LevelJooNum, dtlArr[i].Level + "|" + dtlArr[i].LevelJooName + "|" + dtlArr[i].LevelJooNum));

                }

            }
            else {
                $("#Level").find("option").remove();
                $("#Level").append(new Option("-", ""));
            }

        }

        else if (myArr.CMD == "LevelDtl") {

            if (myArr.RESULT != null) {

                var dtlArr = JSON.parse(myArr.RESULT);

                $("#LevelDtl").find("option").remove();

                for (var i = 0; i < dtlArr.length; i++) {
                    $("#LevelDtl").append(new Option(dtlArr[i].PlayLevelTypeNM + "[" + dtlArr[i].GameLevelDtlidx_DEV + "]", dtlArr[i].GameLevelDtlidx));

                }

            }
            else {
                $("#LevelDtl").find("option").remove();
                $("#LevelDtl").append(new Option("-", ""));
            }

        }
    }
</script>
</head>
<body width="100%">
<form name="Tourney_frm" method="post">

<!-- 헤더 코트s -->
  <div class="modal-header game-ctr">
    <!--<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>-->
    <h3 id="myModalLabel"><span class="tit">대진추첨</span> <span class="txt"><!--- 모집: 1 , - 신청 : 0 - 코트수 : 9--></span></h3>
  </div>
<!-- 헤더 코트e -->
<div class="modal-body game-ctr" style="padding-bottom:0px;">
  <!-- S: top_control -->
  <div class="top_control">
    <!-- S: league_tab -->
    <div class="league_tab clearfix">
	  <div class="pull-left">
        <select id="GameTitle" onchange="sel_PlayType();">
            <option value="">==<%="12333" & GameTitleIDX %>==</option>
        <% 
            LSQL = " SELECT GameTitleIDX, GameTitleName"
            LSQL = LSQL & " FROM tblGameTitle "
            LSQL = LSQL & " WHERE DelYN = 'N'"    

            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

	            Do Until LRs.Eof
        %>
            <option value="<%=crypt.EncryptStringENC(LRs("GameTitleIDX"))%>" <%If GameTitleIDX =  crypt.EncryptStringENC(LRs("GameTitleIDX")) Then%>selected<%End If %>><%=LRs("GameTitleName")%></option>
        <%
                    LRs.MoveNext()
	            Loop

            End If   
            
            LRs.Close         
        %>
        </select>
        
      </div>

      <div class="pull-right">

        <input type="radio" name="GroupGameGb" value="<%=crypt.EncryptStringENC("B0030001")%>" onchange="sel_PlayType();" <%If GroupGameGb = crypt.EncryptStringENC("B0030001") OR GroupGameGb = "" Then%>checked<%End If %>>
        <font color="#FFFFFF">개인전</font>

        &nbsp;

        <input type="radio" name="GroupGameGb" value="<%=crypt.EncryptStringENC("B0030002")%>" onchange="sel_PlayType();" <%If GroupGameGb = crypt.EncryptStringENC("B0030002") Then%>checked<%End If %>>
        <font color="#FFFFFF">단체전</font>

        &nbsp;

        <select id="PlayType" onchange="sel_TeamGb();">
            <option value="">==선택==</option>
        <% 
            LSQL = " SELECT  Sex, PlayType, KoreaBadminton.dbo.FN_NameSch(Sex,'PubCode') AS SexName, KoreaBadminton.dbo.FN_NameSch(PlayType,'PubCode') AS PlayTypeName"
            LSQL = LSQL & " FROM tblGameLevel"
            LSQL = LSQL & " WHERE DelYN = 'N'"
            LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"
            LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "'"
            LSQL = LSQL & " GROUP BY Sex, PlayType"

            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

	            Do Until LRs.Eof
        %>
            <option value="<%=crypt.EncryptStringENC(LRs("Sex"))%>|<%=crypt.EncryptStringENC(LRs("PlayType"))%>" <%If PlayType =  crypt.EncryptStringENC(LRs("Sex")) & "|" & crypt.EncryptStringENC(LRs("PlayType")) Then%>selected<%End If %>><%=LRs("SexName") & LRs("PlayTypeName")%></option>
        <%
                    LRs.MoveNext()
	            Loop

            End If   
            
            LRs.Close         
        %>
        </select>


        <select id="TeamGb" onchange="sel_Level();">
            <option value="">==선택==</option>
        <% 
            LSQL = " SELECT TEamGb, KoreaBadminton.dbo.FN_NameSch(TEamGb,'TeamGb') AS TeamGbNM"
            LSQL = LSQL & " FROM tblGameLevel"
            LSQL = LSQL & " WHERE DelYN = 'N'"
            LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "'"
            LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "'"
            LSQL = LSQL & " AND Sex = '" & DEC_Sex & "'"
            LSQL = LSQL & " AND PlayType = '" & DEC_PlayType & "'"
            LSQL = LSQL & " GROUP BY TEamGb, Sex"

            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

	            Do Until LRs.Eof
        %>
            <option value="<%=crypt.EncryptStringENC(LRs("TEamGb"))%>" <%If TeamGb =  crypt.EncryptStringENC(LRs("TeamGb")) Then%>selected<%End If %>><%=LRs("TeamGbNM")%></option>
        <%
                    LRs.MoveNext()
	            Loop

            End If   
            
            LRs.Close         
        %>
        </select>

        <select id="Level" onchange="sel_LevelDtl();">
            <option value="">==선택==</option>
        <% 
            LSQL = " SELECT Level, KoreaBadminton.dbo.FN_NameSch(Level,'Level') AS LevelNM , KoreaBadminton.dbo.FN_NameSch(leveljooName, 'PubCode') AS LevelJooNM, LevelJooName,"
            LSQL = LSQL & " LevelJooNum "
            LSQL = LSQL & " FROM tblGameLevel "
            LSQL = LSQL & " WHERE DelYN = 'N' "
            LSQL = LSQL & " AND UseYN = 'Y' "
            LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "' "
            LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "' "
            LSQL = LSQL & " AND Sex = '" & DEC_Sex & "' "
            LSQL = LSQL & " AND PlayType = '" & DEC_PlayType & "' "
            LSQL = LSQL & " AND TeamGb = '" & DEC_TeamGb & "' "
            LSQL = LSQL & " GROUP BY Level, leveljooName, LevelJooNum"


            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

	            Do Until LRs.Eof
        %>
            <option value="<%=crypt.EncryptStringENC(LRs("Level"))%>|<%=crypt.EncryptStringENC(LRs("LevelJooName"))%>|<%=LRs("LevelJooNum")%>" <%If Level =  crypt.EncryptStringENC(LRs("Level")) & "|" & crypt.EncryptStringENC(LRs("LevelJooName")) & "|" & LRs("LevelJooNum") Then%>selected<%End If %>><%=LRs("LevelNM") & " " & LRs("LevelJooNM") & " " & LRs("LevelJooNum")%></option>
        <%
                    LRs.MoveNext()
	            Loop

            End If   
            
            LRs.Close         
        %>
        </select>


        <select id="LevelDtl">
            <option value="">==선택==</option>
        <% 
            LSQL = " SELECT GameLevelidx"
            LSQL = LSQL & " FROM tblGameLevel "
            LSQL = LSQL & " WHERE DelYN = 'N' "
            LSQL = LSQL & " AND GameTitleIDX = '" & DEC_GameTitleIDX & "' "
            LSQL = LSQL & " AND GroupGameGb = '" & DEC_GroupGameGb & "' "
            LSQL = LSQL & " AND Sex = '" & DEC_Sex & "' "
            LSQL = LSQL & " AND PlayType = '" & DEC_PlayType & "' "
            LSQL = LSQL & " AND TeamGb = '" & DEC_TeamGb & "' "
            LSQL = LSQL & " AND Level = '" & DEC_Level & "' "
            LSQL = LSQL & " AND LevelJooName = '" & DEC_LevelJooName & "' "
            LSQL = LSQL & " AND LevelJooNum = '" & DEC_LevelJooNum & "' "


            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

	            Do Until LRs.Eof

                    shc_GameLevelidx = LRs("GameLevelidx")

	                LRs.MoveNext
	            Loop

            Else

            End If

            LRs.Close

            LSQL = " SELECT KoreaBadminton.dbo.FN_NameSch(PlayLevelType,'PubCode') AS PlayLevelTypeNM, GameLevelDtlidx "
            LSQL = LSQL & " FROM tblGameLevelDtl"
            LSQL = LSQL & " WHERE DelYN = 'N'"
            LSQL = LSQL & " AND GameLevelidx = '" & shc_GameLevelidx & "'"
            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then

	            Do Until LRs.Eof
        %>
            <option value="<%=crypt.EncryptStringENC(LRs("GameLevelDtlidx"))%>" <%If Leveldtl =  crypt.EncryptStringENC(LRs("GameLevelDtlidx")) Then%>selected<%End If %>><%=LRs("PlayLevelTypeNM") & "[" & LRs("GameLevelDtlidx") & "]"%></option>
        <%
                    LRs.MoveNext()
	            Loop

            End If   
            
            LRs.Close         
        %>
        </select>

	    <a href='#' onclick="cli_tourney()" class="btn btn_func" style="margin-left:10px;">조회</a>
        <a href='#' onclick="cli_tourneysave()" class="btn btn_func" style="margin-left:10px;">대진저장</a>
      </div>
	</div>
    <!-- E: league_tab -->
    
    <!-- S: sel_box -->
    <div class="sel_box" style="padding-left:320px;height:47px;">
	  <p class="tit"></p>
      <select id="roundsel" style="float:left;">
        <option>1라운드제외</option>
        <option>2라운드제외</option>
        <option>시드</option>
      </select>
      <input type="text" name="TotRound" id="TotRound" value="<%=TotRound%>" >
      <input type="text" name="GangCnt" id="GangCnt" value="<%=GangCnt%>" >
      <input type="text" name="Select_STR" id="Select_STR" >
      <input type="text" name="Select_GroupIDX" id="Select_GroupIDX" >
    </div>
    <!-- E: sel_box -->
  </div>
  <!-- E: top_control -->
</div>
<!-- E: game-ctr -->



<div class="modal-body tourn-modal-body">
  <!-- S: scroll_box -->
  <div class="scroll_box" id="drowbody">
    <table border="0" style="width: 100%">
   <tbody>
    <tr>

    <td style="width: 300px;">
      <div class="title_scroll">
      <table width="300" class="table-list game-ctr" id="gametable" style="margin-top:0px;">
        <thead>
          <tr><th>순번</th>
          <th colspan="2">1위</th>
          <!--<th colspan="2">2위</th></tr>-->
        </thead>
        <tbody>
          <!--S: 출전대기선수-->
          <% 
                      
            LSQL = " SELECT GameRequestGroupIDX,"
            LSQL = LSQL & " CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS Player1, "
            LSQL = LSQL & " CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS Player2, "
            LSQL = LSQL & " CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS Team1,"
            LSQL = LSQL & " CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS Team2"
            LSQL = LSQL & " FROM"
            LSQL = LSQL & " ("
            LSQL = LSQL & " SELECT A.GameRequestGroupIDX,"
            LSQL = LSQL & " STUFF(("
            LSQL = LSQL & "         SELECT  DISTINCT (  "
            LSQL = LSQL & "             SELECT  '|'   + MemberName "
            LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblGameRequestPlayer  "
            LSQL = LSQL & "             WHERE   DelYN = 'N' AND GameRequestGroupIDX    = AAA.GameRequestGroupIDX  "
            LSQL = LSQL & "             FOR XML PATH('')  "
            LSQL = LSQL & "             )  "
            LSQL = LSQL & "         FROM    KoreaBadminton.dbo.tblGameRequestPlayer AAA  "
            LSQL = LSQL & "         WHERE DelYN = 'N' AND AAA.GameRequestGroupIDX = A.GameRequestGroupIDX"
            LSQL = LSQL & "         ),1,1,'') AS LPlayers"
            LSQL = LSQL & " ,STUFF(("
            LSQL = LSQL & "         SELECT  DISTINCT (  "
            LSQL = LSQL & "             SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
            LSQL = LSQL & "             FROM    KoreaBadminton.dbo.tblGameRequestPlayer  "
            LSQL = LSQL & "             WHERE   DelYN = 'N' AND GameRequestGroupIDX    = AAA.GameRequestGroupIDX  "
            LSQL = LSQL & "             FOR XML PATH('')  "
            LSQL = LSQL & "             )  "
            LSQL = LSQL & "         FROM    KoreaBadminton.dbo.tblGameRequestPlayer AAA  "
            LSQL = LSQL & "         WHERE DelYN = 'N' AND AAA.GameRequestGroupIDX = A.GameRequestGroupIDX "
            LSQL = LSQL & "         ),1,1,'') AS LTeams"
            LSQL = LSQL & " FROM dbo.tblGameRequestGroup A"
            LSQL = LSQL & " INNER JOIN dbo.tblGameRequestTouney B ON B.RequestIDX = A.GameRequestGroupIDX"
            LSQL = LSQL & " WHERE A.DelYN = 'N'"
            LSQL = LSQL & " AND B.DelYN = 'N'"
            LSQL = LSQL & " AND B.GameLevelDtlIDX = '" & DEC_LevelDtl & "'"
            LSQL = LSQL & " ) AS AA"


            Set LRs = Dbcon.Execute(LSQL)

            If Not (LRs.Eof Or LRs.Bof) Then
                
                i = 1

	            Do Until LRs.Eof

                    '팀 및 선수명
                    strUserName = ""

                    If LRs("Player1") <> "" THen
                        strUserName =  LRs("Player1") & "(" & LRs("Team1")  & ")"
                    End If
                    
                    If LRs("Player2") <> "" THen
                        strUserName = strUserName & "<br>," & LRs("Player2") & "(" & LRs("Team2")  & ")"
                    End If
                   

          %>
          <tr>
            <td><%=i%></td>
            <td><span style="color:red;"></span></td>
            <td>[<%=LRs("GameRequestGroupIDX") %>]
                <a href="#" class="btn_a" style="width:100%;" onclick="cli_Request('<%=strUserName%>','<%=LRs("GameRequestGroupIDX")%>')">
                    <%=strUserName%>
                </a>
            </td>
            
            <!--<td>32</td>-->
            <!--<td><a href="#" class="btn_a btn_updateMember" style="width:100%;"></a></td>-->
          </tr>
          <%

                        i = i + 1
	                LRs.MoveNext
	            Loop

            Else

            End If

            LRs.Close
          %>

          <!--
          <tr>
            <td>2</td>
            <td><span style="color:red;">2</span></td>
            <td><a href="#고미주_1" class="btn_a btn_updateMember" style="width:100%;"> 고미주<br>윤소욱</a></td>
          
            <td>4</td>
            <td><a href="#김미희_1" class="btn_a btn_updateMember" style="width:100%;"> 김미희<br>이영주</a></td>
          </tr>
          -->
          <!--S: 출전대기선수-->
        </tbody>
      </table>
      </div>
    </td>
    <td style="width:3px;font-size:3px;"></td>
    <td class="tourney_container" id="realTimeContents">
    <% 
    Response.Write "강:" & TotRound
    Response.Write "갯수:" & GangCnt

    


    %>
          <table class="tourney_admin 64" id="tourney_admin" border="0" style="width:100%;height:4736px;">
            <thead>
              <tr>

<% 
BtnGang = Cint(TotRound)

For i = 1 To Cint(GangCnt) 

    Response.Write "<li>"

    If i > 1 Then
        BtnGang = Cint(BtnGang) / 2
    End If

    If i = 1 Then
        Response.Write "<th style='padding:2px'><a href='' class='btn_a btn_func' data-collap='' id='set_Round_a1'>" & BtnGang & "&nbsp;강</a></th>"
    Else
        If BtnGang = "2" Then
            Response.Write "<th style='padding:2px'><a href='' class='btn_a btn_func' data-collap='' id='set_Round_a1'>결승</a></th>"
        Else
            Response.Write "<th style='padding:2px'><a href='' class='btn_a btn_func' data-collap='' id='set_Round_a1'>" & BtnGang  & "&nbsp;강</a></th>"
        End If
    End If

    Response.Write "</li>"

Next
        

%>            <!--        
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="set_Round_a1">64&nbsp;강</a>
              </th>
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="A1">32&nbsp;강</a>
              </th>
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="A2">16&nbsp;강</a>
              </th>
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="A3">8&nbsp;강</a>
              </th>
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="A4">4&nbsp;강</a>
              </th>
              <th style="padding:2px">
              <a href='' class="btn_a btn_func" data-collap="" id="A5">2&nbsp;강</a>
              </th>
              -->
              </tr>
            </thead>

            <tbody>
              <tr>
<% 
TourneyRow = Cint(TotRound)

For i = 1 To Cint(GangCnt) 



    If i > 1 Then
        TourneyRow = Cint(TourneyRow) / 2
    End If
%>

			    <td id="DP_Td_<%=i%>" style="padding:0px;">
			    
                    <%
                      For j = 1 TO TourneyRow
                        If j MOD 2 = 1 THen
                    %>
			            <div style="border-left:1px solid #000;width:100%;border-right:1px solid #965F41;padding:0px;margin:0px;border-bottom:3px dotted #7F7F7F;">
                    <% 
                        Else
                    %>
                        <div style="border-left:1px solid #000;width:100%;border-right:1px solid #965F41;padding:0px;margin:0px;border-bottom:4px solid #000;">
                    <%
                        ENd If
			        %>
                            <div style="flex:1;height:100%;background:#FFFFFF;"><%=j%></div>
            

                            <div class="tourney_ctr_btn redy" style="flex:10;height:100%;background:#EEEEE;" onclick="cli_tourneyinsert('<%=i%>', '<%=j%>')">
                              <ul class="team clearfix">
	                            <li>  
                                  <% 
                                    '1라운드일때만 박스 생성
                                    If i = 1 Then
                                  %>
                                  <input type="text" name="Hidden_Data" id="Hidden_Data_<%=i%>_<%=j%>">
                                  <% 
                                    End If
                                  %>
                                  <span class="player" name="DP_UserName" id="DP_UserName_<%=i%>_<%=j%>" style="font-size:13px;">
                                  </span>
                                  <span class="player" style="font-size:15px;">
                                  </span>
                                </li>
                              </ul>
                              <div class="chk_win_lose">
                                <!--<span class="winnercell" style="font-size:18px;">승리</span>-->
                              </div>
                            </div>
            
			            </div>
                    <%Next%>
					
                    <!--	
				    <div style="border-left:1px solid #000;width:100%;border-right:1px solid #965F41;padding:0px;margin:0px;border-bottom:4px solid #000;">
								  
                       <div id="no_1_2" style="flex:1;height:100%;background:#C7E61D;">1<br>2<br> 2</div>
            

                       <div class="tourney_ctr_btn" id="cell_1_2" style="flex:10;height:100%;background:#E5E5E5;">
                         <a name="신은_1"></a><a name="mark_1_2"></a>
                         <ul class="team clearfix">
	                        <li>  
                              <span class="player" style="font-size:15px;">신은&nbsp;조혜경</span>
                            </li>
                         </ul>
                         <div class="chk_win_lose"></div>
                       </div>
                    </div>
					
                    -->	
		
			   </td>

<%

Next
%>
                <!--
			    <td id="1_row" style="padding:0px;">

			            <div style="border-left:1px solid #000;width:100%;border-right:1px solid #965F41;padding:0px;margin:0px;border-bottom:3px dotted #7F7F7F;">

                            <div id="no_1_1" style="flex:1;height:100%;background:#C7E61D;">1<br>1<br> 1</div>
            

                            <div class="tourney_ctr_btn redy" id="cell_1_1" style="flex:10;height:100%;background:#E5E5E5;">
                              <a name="김선영_1"></a><a name="mark_1_1"></a>
                              <ul class="team clearfix">
	                            <li>  
                                  <span class="player" style="font-size:15px;">김선영&nbsp;김점순</span>
                                </li>
                              </ul>
                              <div class="chk_win_lose">
                                <!--<span class="winnercell" style="font-size:18px;">승리</span>--
                              </div>
                            </div>
            
			            </div>

					
                    <!--	
				    <div style="border-left:1px solid #000;width:100%;border-right:1px solid #965F41;padding:0px;margin:0px;border-bottom:4px solid #000;">
								  
                       <div id="no_1_2" style="flex:1;height:100%;background:#C7E61D;">1<br>2<br> 2</div>
            

                       <div class="tourney_ctr_btn" id="cell_1_2" style="flex:10;height:100%;background:#E5E5E5;">
                         <a name="신은_1"></a><a name="mark_1_2"></a>
                         <ul class="team clearfix">
	                        <li>  
                              <span class="player" style="font-size:15px;">신은&nbsp;조혜경</span>
                            </li>
                         </ul>
                         <div class="chk_win_lose"></div>
                       </div>
                    </div>
					
                   
		
			   </td>
						
			   <td id="2_row" style="padding:0px;">
			   </td>
			   <td id="3_row" style="padding:0px;">
			   </td>
			   <td id="4_row" style="padding:0px;">
			   </td>
			   <td id="5_row" style="padding:0px;">
			   </td>
			   <td id="6_row" style="padding:0px;">
			   </td>
			   <td id="7_row" style="padding:0px;">
			   </td>
			 -->	
                    </tr>
            </tbody>
          </table>
        </td>
  
    </tr>
   </tbody>
</table>
  </div>
  <!-- E: scroll_box -->
</div>


</form>
</body>
</html>