<!--#include virtual="/Manager/Library/config.asp"-->
<%
	Dim ReturnSTR()
	Dim Count : Count = 1
	Dim strGameNum
	
	'대회번호
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	'개인전단체전구분
	GameType = fInject(Request("GameType"))


'	Response.wRITE GameType

	If GameType = "" Then 
		GameType = "sd040001"
	End If 	
	'소속구분
	TeamGb     = fInject(Request("TeamGb"))
	'성별구분
	Sex = fInject(Request("Sex"))
	'체급 
	Level      = fInject(Request("Level"))
	'Response.Write Level

	
	

	
	If GameType = "sd040001" Then 
	'======================================================================================================
	'개인전일경우 =========================================================================================
	'======================================================================================================
		If GameTitleIDX <> "" And GameType <> "" And TeamGb <>  "" And Level <> ""  Then 
			'해당체급의 참여자 명단 카운트
			CntSQL = "SELECT COUNT(*) AS Cnt "
			CntSQL = CntSQL&" FROM SportsDiary.dbo.tblRPlayerMaster PM "
			CntSQL = CntSQL&" JOIN  SportsDiary.dbo.tblRGameLevel RL  "
			CntSQL = CntSQL&" ON PM.RGameLevelIDX = RL.RGameLevelIDX "
			CntSQL = CntSQL&" WHERE RL.GameTitleIDX='"&GameTitleIDX&"'"
			CntSQL = CntSQL&" AND RL.GroupGameGb = '"&GameType&"'"
			CntSQL = CntSQL&" AND RL.TeamGb='"&TeamGb&"'"
			'CntSQL = CntSQL&" AND RL.Sex='"&Sex&"'"
			CntSQL = CntSQL&" AND PM.SportsGb = 'judo'"
			CntSQL = CntSQL&" AND RL.Level='"&Level&"'"		
			CntSQL = CntSQL&" AND PM.DelYN='N'"
			CntSQL = CntSQL&" AND RL.DelYN='N'"
'Response.Write CntSQL

			Set CntRs = Dbcon.Execute(CntSQL)

			
			'해당체급 경기의 강수를 체크해서 업데이트 
			UpSQL = "Update SportsDiary.dbo.tblRGameLevel "
			UpSQL = UpSQL&" SET TotRound = '"&chk_TotRound(CntRs("Cnt"))&"'"
			UpSQL = UpSQL&" WHERE GameTitleidx='"&GameTitleIDX&"'"
			UpSQL = UpSQL&" AND GroupGameGb = '"&GameType&"'"
			UpSQL = UpSQL&" AND TeamGb = '"&TeamGb&"'"
			'UpSQL = UpSQL&" AND Sex = '"&Sex&"'"
			UpSQL = UpSQL&" AND Level='"&Level&"'" 
			UpSQL = UpSQL&" AND DelYN='N'"
			'Response.Write UpSQL
			
			Dbcon.Execute(UpSQL)

			PlayerCnt = CntRs("Cnt")
			TotRound = chk_TotRound(CntRs("Cnt"))
			
			'총부전승의 갯수 구함
			UnearnedCnt = TotRound - PlayerCnt

			PSQL = "SELECT "
			PSQL = PSQL&" RGameLevelIDX "
			PSQL = PSQL&" FROM SportsDiary.dbo.tblRGameLevel "
			PSQL = PSQL&" WHERE GameTitleidx='"&GameTitleIDX&"'"
			PSQL = PSQL&" AND GroupGameGb = '"&GameType&"'"
			PSQL = PSQL&" AND TeamGb = '"&TeamGb&"'"
			'PSQL = PSQL&" AND Sex = '"&Sex&"'"
			PSQL = PSQL&" AND Level='"&Level&"'" 
			PSQL = PSQL&" AND DelYN='N'"
			'Response.Write PSQL
			'Response.End

			Set PRs = Dbcon.Execute(PSQL)
				If Not(PRs.Eof Or PRs.Bof) Then  
					RGameLevelIDX = PRs("RGameLevelIDX")
				End If 

			CntRs.Close
			PRs.Close

			Set CntRs = Nothing 
			Set PRs   = Nothing 
		Else 
			TotRound     = 0
			PlayerCnt    = 0
			RGameLevelIDX = ""
		End If 
	ElseIf GameType = "sd040002" Then 
	'======================================================================================================
	'단체전일경우 =========================================================================================
	'======================================================================================================
			'해당체급의 참여자 명단 카운트
			CntSQL = "SELECT COUNT(*) AS Cnt "
			CntSQL = CntSQL&" FROM SportsDiary.dbo.tblRGameGroupSchoolMaster PM "
			CntSQL = CntSQL&" JOIN  SportsDiary.dbo.tblRGameLevel RL  "
			CntSQL = CntSQL&" ON PM.RGameLevelIDX = RL.RGameLevelIDX "
			CntSQL = CntSQL&" WHERE RL.GameTitleIDX='"&GameTitleIDX&"'"
			CntSQL = CntSQL&" AND RL.GroupGameGb = '"&GameType&"'"
			CntSQL = CntSQL&" AND RL.TeamGb='"&TeamGb&"'"
			CntSQL = CntSQL&" AND PM.SportsGb = 'judo'"
			'CntSQL = CntSQL&" AND RL.Sex='"&Sex&"'"
			CntSQL = CntSQL&" AND PM.DelYN='N'"
			CntSQL = CntSQL&" AND RL.DelYN='N'"

			Set CntRs = Dbcon.Execute(CntSQL)

			
			'해당체급 경기의 강수를 체크해서 업데이트 
			UpSQL = "Update SportsDiary.dbo.tblRGameLevel "
			UpSQL = UpSQL&" SET TotRound = '"&chk_TotRound(CntRs("Cnt"))&"'"
			UpSQL = UpSQL&" WHERE GameTitleidx='"&GameTitleIDX&"'"
			UpSQL = UpSQL&" AND GroupGameGb = '"&GameType&"'"
			UpSQL = UpSQL&" AND TeamGb = '"&TeamGb&"'"
			'UpSQL = UpSQL&" AND Sex = '"&Sex&"'"
			UpSQL = UpSQL&" AND DelYN='N'"
			'Response.Write UpSQL
			
			Dbcon.Execute(UpSQL)

			PlayerCnt = CntRs("Cnt")
			TotRound = chk_TotRound(CntRs("Cnt"))
			
			'총부전승의 갯수 구함
			UnearnedCnt = TotRound - PlayerCnt

			PSQL = "SELECT "
			PSQL = PSQL&" RGameLevelIDX "
			PSQL = PSQL&" FROM SportsDiary.dbo.tblRGameLevel "
			PSQL = PSQL&" WHERE GameTitleidx='"&GameTitleIDX&"'"
			PSQL = PSQL&" AND GroupGameGb = '"&GameType&"'"
			PSQL = PSQL&" AND TeamGb = '"&TeamGb&"'"
			'PSQL = PSQL&" AND Sex = '"&Sex&"'"
			PSQL = PSQL&" AND DelYN='N'"
			'Response.Write PSQL
			'Response.End

			Set PRs = Dbcon.Execute(PSQL)
				If Not(PRs.Eof Or PRs.Bof) Then  
					RGameLevelIDX = PRs("RGameLevelIDX")
				End If 

			CntRs.Close
			PRs.Close

			Set CntRs = Nothing 
			Set PRs   = Nothing 
		Else 
			TotRound     = 0
			PlayerCnt    = 0
			RGameLevelIDX = ""
	End If 

'Response.End
%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=Edge, Chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>스포츠 다이어리</title>
<meta name="apple-mobile-web-app-title" content="스포츠 다이어리">
<link rel="stylesheet" type="text/css" href="../tablet/css/library/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="../tablet/css/app.css">
<link rel="stylesheet" href="../tablet/css/bootstrap.css">
<link rel="stylesheet" href="../tablet/css/fullcalendar.css">
<link rel="stylesheet" href="../tablet/css/fullcalendar.min.css">
<link rel="stylesheet" href="../tablet/css/fullcalendar.print.css">
<link rel="stylesheet" href="../tablet/css/fullcalendar_test.css">
<link rel="stylesheet" href="../tablet/css/pop-style.css">
<link rel="stylesheet" type="text/css" href="../tablet/css/style.css">
<script src="../tablet/js/library/jquery-1.12.2.min.js"></script>
<!--상태바 관련-->
<script type="text/javascript" src="/Manager/Script/common.js"></script>
<!--상태바 관련-->
<script>
//소속구분셀렉트박스
make_box("sel_TeamGb","TeamGb","<%=TeamGb%>","TeamGb2")			
//make_box("sel_Search_Sex","Sex","<%=Sex%>","Sex_Select_Change")
make_box("sel_GameTitle","GameTitleIDX","<%=GameTitleIDX%>","GameTitle")

/*성별체크 클릭시 hidden_insert S*/
function chk_sex(obj){
	document.getElementById("Sex").value = obj;
	/*소속및 성별 체크*/
	if(document.getElementById("TeamGb").value!="" && document.getElementById("Sex").value !=""){
		chk_level();
	}
}
/*성별체크 클릭시 hidden_insert E*/
function chk_level(){
	if(document.getElementById("TeamGb").value!=""){
		make_box_level("sel_Level","Level","<%=Level%>","Level_Check",document.getElementById("TeamGb").value,'')

	}
}

//검색체크
function chk_search(){
	var sf = document.search_frm;
	var result_chkleague;

	var strLeagueType;
	var strSex;

	if(sf.GameTitleIDX.value==""){
		alert("대회를 선택해 주세요.");
		sf.GameTitleIDX.focus();
		return false;
	}
	if(sf.TeamGb.value==""){
		alert("소속구분을 선택해 주세요.");
		sf.TeamGb.focus();
		return false;	
	}
	/*단체전일경우 체급 체크 안함*/
	if(sf.GameType[0].checked){
		if(sf.Level.value==""){
			alert("체급을 선택해 주세요.");
			sf.Level.focus();
			return false;			
		}
	}
	/*단체전일경우 체급 체크 안함*/

	result_chkleague = check_league();

	if(result_chkleague == "error"){
		strLeagueType = "";
		strSex = "";
	}
	else{

		var arr_chkleague =  result_chkleague.split("|");

		strLeagueType = arr_chkleague[0];
		strSex = arr_chkleague[1];	
	}

	document.getElementById("Sex").value = strSex;



	if(strLeagueType == "sd043001"){
		sf.action="TournamentInfo_league.asp";
	}
	else if(strLeagueType == "sd043002"){
		sf.action="TournamentInfo.asp";	
	}
	sf.submit();
}
</script>
<script>
//대진표 입력관련 스크립트
function chk_player(obj,obj2,no){
	//참가선수수
	var playercnt = "<%=PlayerCnt%>"
	//현재 선택된 선수 셀렉트 클래스 적용
	for (i=1;i<playercnt;i++){
		
	}

	

	//현재 선택된 선수명 히든처리
	document.getElementById("sel_playername").value = obj;
	document.getElementById("sel_playeridx").value = obj2;
}

//대진표리스트->입력데이터 이동
function input_data(obj,obj2){
	var spidx    = document.getElementById("sel_playeridx")
	var spname   = document.getElementById("sel_playername")
	var obj2idx  = document.getElementById(obj2);
	//시드히든테이블
	var seed   = document.getElementById("seed")


	//alert(obj.disabled);
	//alert("a");

	//중복입력값 체크 
	var GameType      = "<%=GameType%>";	
	var totcnt = "<%=TotRound%>"
	for(i=1;i<=totcnt;i++){
		//개인전일때만 체크
		if(GameType=="sd040001"){
			if(document.getElementById("hidden_data"+i).value==spidx.value){
				if(spidx.value!=""){
					alert("이미 대진등록된 선수입니다.");
					spidx.value = "";
					spname.value = "";
					return false;
				}
			}
		}
		//개인전일때만 체크
	}	

	if(spidx.value!=""){
		obj.value = spname.value;
		obj2idx.value = spidx.value;
		
		//시드선수 Disable 처리 작업중======================================================================
		obj.disabled = true;
		obj2idx.disabled = true;
		if(seed.value==""){
			seed.value = obj2idx.value+",";
		}else{
			seed.value = seed.value+obj2idx.value+",";			
		}		
		document.getElementById("seed"+obj2idx.value).innerHTML = "시드"
		//시드선수 Disable 처리 작업중======================================================================


		chk_pair()
		chk_round2()
		//값 초기화
		spidx.value = "";
		spname.value = "";
	}else{
		//값이 있는데 다시 클릭했을경우
		if(obj2.value!=""){
			if(confirm("해당 선수를 삭제하시겠습니까?")){
				//기존 입력 데이터 reset
				obj.value="";
				obj2idx.value ="";
			}
		}
	}
}




//대진표 랜덤
	var ck = 1;
function random_player(){
		var totcnt       = "<%=TotRound%>";
		var gametitleidx = "<%=GameTitleIDX%>";
		var RGameLevelIDX = "<%=RGameLevelIDX%>";
		var GameType      = "<%=GameType%>";
		var seed          = document.getElementById("seed").value;
		//alert(totcnt);
		//alert(gametitleidx);
		//alert(RGameLevelIDX);
		//alert(seed);
		if(gametitleidx==""){
			return;
		}
		if(RGameLevelIDX==""){
			return;
		}
		if(GameType=="sd040001"){
			var strAjaxUrl = "/Manager/Ajax/random_Player.asp";
		}else{
			var strAjaxUrl = "/Manager/Ajax/random_School.asp";
		}
		var retDATA="";
		 $.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',				
			data: {
				totcnt: totcnt  ,
				gametitleidx : gametitleidx ,
				rgamelevelidx : RGameLevelIDX , 
				seed          : seed
			},		
			success: function(retDATA) {
				if(retDATA){					
					array_Data = retDATA.split("|")
					
					//input box의 수대로 for문
					k = 1
					j = 0
					for(k=1;k<=totcnt;k++){
						if(document.getElementById("Player"+k).disabled == false){
							arr_Input = array_Data[j].split(",")
							document.getElementById("Player"+k).value = arr_Input[0];
							document.getElementById("hidden_data"+k).value = arr_Input[1];
							j = j + 1
						}

					} 
					ck = ck+1;
					
					if(ck != 10){
						random_player()
					}
					
					if(ck == 10){
						ck = 1;
						return 1;
					}
					
					for(k=1;k<=20000;k++){  //속도조절
						
					}
					chk_pair();
					chk_round2();
				}else{
					alert("error")
				}
			}, error: function(xhr, status, error){						
				alert ("오류발생! - 시스템관리자에게 문의하십시오!");			
			}
		});	
}


//추첨 버튼 
function random_start(){
		random_player();
}
function radom_reset(){
	var totcnt = "<%=TotRound%>"
	if(confirm("대진표를 초기화 하시겠습니까?")){
		/*
		for(i=1;i<=totcnt;i++){
			document.getElementById("hidden_data"+i).value = "";
			document.getElementById("Player"+i).value = "";
		}
		*/
		
		var sf = document.search_frm;
		sf.action="TournamentInfo.asp"
		sf.submit();
	}
}

function chk_save(){
	var sf = document.search_frm;
	if(sf.GameType[0].checked){
		if(confirm("해당 대진표를 저장하시겠습니까?")){
			sf.action = "League_ok.asp"			
			sf.submit();
		}
	}else if(sf.GameType[1].checked){
		if(confirm("해당 대진표를 저장하시겠습니까?")){
			sf.action = "SchoolLeague_ok.asp"			
			sf.submit();


		}	
	}
}


function check_league(){



		var gametitleidx = document.getElementById("GameTitleIDX").value;
		var teamgb = document.getElementById("TeamGb").value;
		var level = document.getElementById("Level").value;
		var gametype = $("input[type=radio][name=GameType]:checked").val();
	
		var strAjaxUrl = "/Manager/Ajax/check_league.asp";

		var strReturn = "";

		var retDATA="";
		 $.ajax({
			url: strAjaxUrl,
			type: 'POST',
			dataType: 'html',				
			async: false,		
			data: {
				gametitleidx: gametitleidx  ,
				teamgb : teamgb ,
				level : level , 
				gametype : gametype
			},		
			success: function(retDATA) {

				console.log(retDATA);
				
				if(retDATA){					
					
					strReturn = retDATA;

				}else{
					strReturn = "error";
				}
			}, error: function(xhr, status, error){						
				strReturn = "error";			
			}
		});	

		return strReturn;
}
</script>
</head>
<body>
    <!-- S: header -->
    <div class="header container-fluid">
      <div class="row">
        <div class="pull-left">
					<!--
          <a href="calendar.html" role="button" class="prev-btn">
            <span class="icon-prev"><i class="fa fa-angle-left" aria-hidden="true"></i></span>
            <span class="prev-txt">경기 입력 조회</span>
          </a>
					-->
        </div>
        <div class="pos-center">
          <h1 class="logo">
            <img src="../tablet/images/tournerment/header/judo-logo@3x.png" alt="대한유도회" width="140" height="37">
          </h1>
        </div>
        <div class="pull-right">
          <span class="sd-logo"><img src="../tablet/images/tournerment/header/logo@3x.png" alt="스포츠 다이어리" width="100" height="32"></span>
          <!--<a href="index.html" role="button" class="home-link"><span class="icon-home"><i class="fa fa-home" aria-hidden="true"></i></span></a>-->
        </div>
      </div>
    </div>
    <!-- E: header -->
    <!-- S: main -->
		<form name="search_frm" method="post">
		<input type="hidden" name="seed" id="seed">
    <div class="main main-input container-fluid">
      <h2 class="stage-title row" id="sel_GameTitle" class="stage-title row">
				<select id="GameTitleIDX">
					<option value="">::대회명::</option>
				</select>
			</h2>
      <!-- S: input-select -->
      <div class="input-select ent-sel row">
        <!-- S: tab-menu -->
				<!--검색영역 S-->
				
        <div class="enter-type tab-menu">
          <ul class="clearfix">
						<li class="game-type">
						<!--대회명-->
						
						<!--대회명-->
						</li>
            <li class="game-type">
              <label ><span><img src="../tablet/images/tournerment/tourney/icon-private@3x.png" alt width="18" height="18"></span><span class="type-text">개인전</span><input type="radio" name="GameType" <%If GameType = "sd040001" Then %>checked<%End If%> value="sd040001" ></label>
            </li>
            <li class="game-type">
              <label ><span><img src="../tablet/images/tournerment/tourney/icon-group@3x.png" alt width="16" height="21"></span><span class="type-text">단체전</span><input type="radio" name="GameType" <%If GameType = "sd040002" Then %>checked<%End If%> value="sd040002"></label>
            </li>
            <li class="type-sel" id="sel_TeamGb">
              <select id="TeamGb">
                <option value="">::소속구분선택::</option>
              </select>
            </li>
						<!--
            <li class="type-sel" id="sel_Search_Sex">
              <select id="Sex">
                <option value="Man">남자</option>
                <option value="WoMan">여자</option>
              </select>
            </li>
						-->
						<input type="hidden" name="Sex" id="Sex" value="<%=Sex%>">
            <li class="type-sel" id="sel_Level">
							<%
								If GameTitleIDX <> "" And GameType <> "" And TeamGb <>  "" And Level <> "" Then 									
										LSQL = "SELECT"
										LSQL = LSQL&" Level"
										LSQL = LSQL&" ,LevelNm"
										LSQL = LSQL&" FROM SportsDiary.dbo.tblLevelInfo"
										LSQL = LSQL&" WHERE SportsGb='judo'"
										LSQL = LSQL&" AND DelYN='N'"
										LSQL = LSQL&" AND TeamGb = '"&TeamGb&"'"
										LSQL = LSQL&" ORDER BY Orderby ASC"	
										Set LRs = Dbcon.Execute(LSQL)
										'Response.Write LSQL
									
							%>
							<select name="Level" id="Level">"
								<option value=''>==선택==</option>
								<%
									If Not (LRs.Eof Or LRs.Bof) Then 
										Do Until LRs.Eof 
								%>			 								
								<option value="<%=LRs("Level")%>" <%If Level = LRs("Level") Then%>selected<%End If%>><%=LRs("LevelNm")%></option>	
								<%
											LRs.MoveNext
										Loop 
									End If 
								%>
              </select>
							<%
								Else								
							%>
              <select id="Level" onclick="alert('소속 성별 선택후 체급을 선택해 주세요.');">
                <option value="">::체급선택::</option>
              </select>
							<%
								End If 
							%>

            </li>
            <li class="btn-list">
              <button type="button" id="search" class="btn btn-warning btn-search" onclick="chk_search();">조 회</button>
            </li>
            <li class="btn-list">
              <button type="button" id="search" class="btn btn-warning btn-search" onclick="chk_save();">대진저장</button>
            </li>
          </ul>
        </div>
				<!--검색영역 E-->
        <!-- E: tab-menu -->
      </div>
      <!-- E: input-select -->
    <!-- E: main -->
		<!---------------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------->
		<%
			If TotRound > 0 And PlayerCnt > 0 Then 
		%>
		<!---------------------------------------------------------------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------->
		<input type="hidden" name="sel_playeridx" id="sel_playeridx">
		<input type="hidden" name="sel_playername" id="sel_playername">
		<input type="hidden" name="RGameLevelIDX" id="RGameLevelIDX" value="<%=RGameLevelIDX%>" />
		<!--1라운드 정식 경기수-->
		<input type="text" name="TotRound" id="TotRound" value="<%=TotRound%>" />
		<input type="text" name="pair_cnt" id="pair_cnt" value="0">
    <!-- S: tourney-main -->
    <div class="tourney-main hidden-main">
      <!-- S: tourney-->
      <div class="tourney clearfix">
				<h3 class="stit"><!--대진표 입력하기<input type="button" value="추첨" onclick="random_start();"><input type="button" value="초기화" onclick="radom_reset()"></h3>-->
        <!-- S: left-side -->
				<div class="league" >
					<!-- S : 리그전 -->
					<!--
					<div class="top-league">
							<input type="text" name="player_cnt" id="player_cnt" value="<%=player_cnt%>"/>
							<input type="button" value="생성" onclick="chk_cnt()" />
					</div>
					
					<h3>초등부 남자 1조</h3>
					-->
					<%

						'개인전 
						If GameType = "sd040001" Then
							USQL = " SELECT PlayerIDX, UserName, Team, TeamDtl, Level, SportsDiary.Dbo.FN_TeamNm(SportsGb, TeamGb, Team) AS TeamNm"
							USQL = USQL&" FROM SportsDiary.dbo.tblRPlayerMaster"
							USQL = USQL&" WHERE DelYN = 'N'"
							USQL = USQL&" AND GameTitleIDX = '" & GameTitleIDX & "'"
							USQL = USQL&" AND GroupGameGb = '" & GameType & "'"
							USQL = USQL&" AND TeamGb = '" & TeamGb & "'"
							USQL = USQL&" AND Level = '" & Level & "'"
							USQL = USQL&" AND DelYN = 'N'"
							USQL = USQL&" ORDER BY NEWID()"	
						Else
							USQL = " SELECT '' AS PlayerIDX, '' AS UserName, Team, TeamDtl, Level, SportsDiary.Dbo.FN_TeamNm(SportsGb, TeamGb, Team) AS TeamNm"
							USQL = USQL&" FROM SportsDiary.dbo.tblRGameGroupSchoolmaster"
							USQL = USQL&" WHERE DelYN = 'N'"
							USQL = USQL&" AND GameTitleIDX = '" & GameTitleIDX & "'"
							USQL = USQL&" AND GroupGameGb = '" & GameType & "'"
							USQL = USQL&" AND TeamGb = '" & TeamGb & "'"
							USQL = USQL&" AND DelYN = 'N'"
							USQL = USQL&" ORDER BY NEWID()"
						End If

						Set URs = Dbcon.Execute(USQL)
						If Not(URs.Bof Or URs.Eof) Then

							Arr_Player = URs.Getrows()
							Cnt_Arr_Player = UBound(Arr_Player,2)
							ReDim ReturnSTR(Cnt_Arr_Player)

							For i = 0 To Cnt_Arr_Player
								ReturnSTR(i) = Arr_Player(0,i) & "," & Arr_Player(1,i) & "," & Arr_Player(2,i) & "," & Arr_Player(3,i) & "," & Arr_Player(4,i) & "," & Arr_Player(5,i) 
							Next
						End If


						If Cnt_Arr_Player <> "" Then 		
					%>
					<!--테이블생성-->
					<table border="1">
						<tr>
							<td>제1조</td>
							<%
								'해당되는 선수수만큼 Loop
								For i = 0 To Cnt_Arr_Player
							%>
									<!--선수명-->
									<td width="100px;">
										<%If GameType = "sd040001" Then%>
											<p class="player-name"><span><%=Arr_Player(1,i)%></span> </p>
											<p class="player-school"><%=Arr_Player(5,i)%></p>
										<%Else%>
											<p class="player-name"><span><%=Arr_Player(5,i)%></span> </p>
										<%End If%>
									</td>
									<!--선수명-->
							<%
								Next
								
							%>
						</tr>
						<!--하위 데이터-->
						<%
							For i = 0 To Cnt_Arr_Player
						%>	
						<tr>
							<!--선수명-->
							<td width="100px;">
								<%If GameType = "sd040001" Then%>
									<p class="player-name"><span><%=Arr_Player(1,i)%></span> </p>
									<p class="player-school"><%=Arr_Player(5,i)%></p>
								<%Else%>
									<p class="player-name"><span><%=Arr_Player(5,i)%></span> </p>
								<%End If%>
							</td>
							<!--선수명-->
							<%
								'경기수 만큼 loop 
							%>
							<%
								For j = 0 To Cnt_Arr_Player 
							%>
								<!--경기진행-->
								<%
									If i <> j  Then 
								%>
								<!-- 경기입력 -->
								<td class="write">
									<%If GameType = "sd040001" Then%>
										<p class="player-name"><%=Arr_Player(1,i)%> vs <%=Arr_Player(1,j)%></p>
									<%Else%>
										<p class="player-name"><%=Arr_Player(5,i)%> vs <%=Arr_Player(5,j)%></p>
									<%End If%>

									<%
										If i < j Then
											ReturnSTR(i) = ReturnSTR(i) & "," & Count
											ReturnSTR(j) = ReturnSTR(j) & "," & Count
										
									%>
										<!--<BR>경기순번 : <%=Count%>-->
									<%
											Count = Count + 1
										End If
									%>
								</td>

								<%
									Else 
								%>
								<!--경기미진행-->
								<td class="no"></td>
								<%
									End If 
								%>
							<%
								Next
								
							%>
						</tr>
						<%
							Next
							
						%>
						<!--하위 데이터-->
					</table>
					<%
						End If 
					%>
					<!-- E : 리그전 -->
				</div>
      </div>			
      <!-- E: tourney-->
			<%
			For i=0 To UBound(ReturnSTR,1)
				If i = 0 Then
					strGameNum = strGameNum & Mid(ReturnSTR(i),1)
				Else
					strGameNum = strGameNum & "|" & Mid(ReturnSTR(i),1)
				End If
			Next

			%>
				<input type="hidden" name="GameNum" value="<%=strGameNum%>">
			</form>
		<%
			Else 
		%>
			<span>등록된 경기 정보가 없습니다.</span>
		<%
			End If 
		%>
    
    <!-- 스티키 스크립트 -->
    <script src="../js/sticky.js"></script>
    <style>
      .league { font-family: 'Noto KR Bold'; padding-top:30px; padding-bottom:40px; text-align:center; background:#eeeff4;}
      .top-league { margin-bottom:30px;}
      .top-league input { height:23px; border:1px solid #aaa;}
      .league-tab { display:inline-block; overflow:hidden; margin:0; padding:0; background:#f0f0f0; border:1px solid #d5d5d5; border-radius:3px;}
      .league-tab li { float:left; width:99px; text-align:center; background: url('images/tournerment/score/bar.png') no-repeat 0 50%; background-size:2px 21px;}
      .league-tab li:first-child { font-weight:bold; background:none;}
      .league-tab li a { display:block; width:100%; padding:6px 0; color:#777; font-size:16px;}
      .league-tab li.on a,
      .league-tab li a:hover,
      .league-tab li a:active,
      .league-tab li a:focus { color:#2e6fa9;}
      .league .color-guide .guide-cont { margin-bottom:20px; border:1px solid #747b82;}

      .league table td .player-name { font-size:16px;}
      .league table td .player-name span { vertical-align:top; line-height:20px;}
      .league p { margin:0;}
      .league h3 { display:inline-block; text-align:left; margin:0; padding: 0 0 15px 13px; font-size: 22px; font-weight: bold; color: #333; background: url(images/tournerment/stat/icon_tit.png) no-repeat 0 3px;}

      .league table { margin:0 auto 30px; border:1px solid #aaa;  background:#eeeff4;}
      .league table td { width:123px; padding:10px 0; line-height:1.2; text-align:center; font-size:16px !important; font-weight:bold; background:#fff;}
      .league table tr:first-child td { height:58px; font-size:20px; background:#e2e2e2;}
      .league table tr:first-child td .player-name { margin:0; color:#333; font-size:20px;}
      .league table tr:first-child td .player-school { margin:0; color:#fd5500; font-size:16px; font-weight:normal;}
      .league table tr:first-child td:first-child { color:#fff; font-size:20px !important; background:#2e6fa9;}
      .league table td:first-child { font-size:20px; background:#d3e0eb; }
      .league table td:first-child .player-name { font-size:20px;}
      .league table td:first-child .player-school { margin:0; color:#fd5500; font-size:16px; font-weight:normal;}
      .league table td .win { color:#2e6da7;}
      .league table td .lose { color:#fd5500;}

      .league table td.no { color:#fff; background:#616971;}
      .league table td.write { background:#eeeff4 !important;}
      .league table td.disabled { color:#888;}

      .league table td.score { border-left:3px solid #aaa;}
      .league table td.rank { border-right:3px solid #aaa;}

      .league table tr:first-child td.score,
      .league table tr:first-child td.rank { border-top:3px solid #aaa;}
      .league table tr:last-child td.score,
      .league table tr:last-child td.rank { border-bottom:3px solid #aaa;}

      .btn-result { margin-top:6px; padding: 0 12px; height: 22px; color: #fff !important; font-size: 15px;vertical-align: top; line-height:22px; font-weight: 900; border: 1px solid #7f8690; background: #98a1ae; background: -moz-linear-gradient(top, #98a1ae 0%, #7f8690 100%); background: linear-gradient(to bottom, #98a1ae 0%,#7f8690 100%); filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#98a1ae', endColorstr='#7f8690',GradientType=0 );}

      .btn-write { margin-top: 6px; padding: 0 12px; height: 22px; color: #4d4d4d; font-size: 15px; vertical-align: top;  line-height:22px; font-weight: 900; border: 1px solid #a2a2a2; background: #fdfdfd; /* Old browsers */ background: -moz-linear-gradient(top, #fdfdfd 0%, #c8c8c8 100%); /* FF3.6-15 */ background: -webkit-linear-gradient(top, #fdfdfd 0%,#c8c8c8 100%); /* Chrome10-25,Safari5.1-6 */ background: linear-gradient(to bottom, #fdfdfd 0%,#c8c8c8 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */ filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fdfdfd', endColorstr='#c8c8c8',GradientType=0 ); /* IE6-9 */ }

      .btn-save-finish { display:block; margin:0 auto; padding:0; color: #fff !important; width: 248px; height: 40px; line-height: 40px; font-family: 'Noto KR Bold'; font-size: 20px; background: -moz-linear-gradient(top, #ff6500 0%, #ff3800 100%); background: -webkit-linear-gradient(top, #ff6500 0%,#ff3800 100%); background: linear-gradient(to bottom, #ff6500 0%,#ff3800 100%); filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ff6500', endColorstr='#ff3800',GradientType=0 ); border: 1px solid #ff530d;}

    .league .sign-list { float:none; width:775px; 
    height:107px; margin:20px auto; padding:3px 0px 0 0; background:#bbc4cf; /*border:3px solid #bbc4cf;*/}
    </style>
  </body>
</html>
