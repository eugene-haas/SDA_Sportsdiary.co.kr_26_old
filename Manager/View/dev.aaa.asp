<!--#include virtual="/Manager/Library/config.asp"-->
<%
  '대회번호
  GameTitleIDX = fInject(Request("GameTitleIDX"))
  '개인전단체전구분
  GameType = fInject(Request("GameType"))
  If GameType = "" Then 
    GameType = "sd040001"
  End If  
  '소속구분
  TeamGb     = fInject(Request("TeamGb"))
  '성별구분
  Sex_Select = fInject(Request("Sex_Select"))
  '체급 
  Level      = fInject(Request("Level"))
  'Response.Write Sex_Select&"aaaa"
  
  '데이터 선택이 다된 경우에는 조회
  If GameTitleIDX <> "" And GameType <> "" And TeamGb <>  "" And Sex_Select <> "" Then 
    PSQL = "select RGameLevelIDX from tblRGameLevel where gametitleidx='"&GameTitleIDX&"' and level='"&Level&"'"
    Set PRs = Dbcon.Execute(PSQL)
      If Not(PRs.Eof Or PRs.Bof) Then  
        RGemLevelIDX = PRs("RGameLevelIDX")
      End If 
  Else 
    RGemLevelIDX = ""
  End If 

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
make_box("sel_TeamGb","TeamGb","","TeamGb2")      
make_box("sel_Search_Sex","Sex","","Sex_Select_Change")
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
  if(document.getElementById("TeamGb").value!="" && document.getElementById("Sex").value !=""){
    make_box_level("sel_Level","Level","","Level_Check",document.getElementById("TeamGb").value,document.getElementById("Sex").value)
  }
}


//검색체크
function chk_search(){
  var sf = document.search_frm;
  if(sf.GameTitleIDX.value==""){
    alert("대회를 선택해 주세요.");
    sf.GameTitleIDX.focus();
    return false;
  }
  if(sf.TeamGb.value==""){
    alert("소숙구분을 선택해 주세요.");
    sf.TeamGb.focus();
    return false; 
  }
  if(sf.Sex.value==""){
    alert("성별을 선택해 주세요.");
    sf.Sex.focus();
    return false;   
  }
  if(sf.Level.value==""){
    alert("체급을 선택해 주세요.");
    sf.Level.focus();
    return false;     
  }
  sf.action="aaa.asp"
  sf.submit();
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
    <div class="main main-input container-fluid">
      <h2 class="stage-title row" id="tourney_title" class="stage-title row">2016 회장기 전국 유도대회</h2>
      <!-- S: input-select -->
      <div class="input-select ent-sel row">
        <!-- S: tab-menu -->
        <!--검색영역 S-->
        <form name="search_frm" method="post">
        <div class="enter-type tab-menu">
          <ul class="clearfix">
            <li class="game-type" id="sel_GameTitle">
            <!--대회명-->
            <select id="GameTitleIDX">
                <option value="">::대회명::</option>
              </select>
            <!--대회명-->
            </li>
            <li class="game-type">
              <label ><span><img src="../tablet/images/tournerment/tourney/icon-private@3x.png" alt width="18" height="18"></span><span class="type-text">개인전</span><input type="radio" name="GameType" <%If GameType = "sd040001" Then %>checked<%End If%> value="sd040001" ></label>
            </li>
            <li class="game-type">
              <label ><span><img src="../tablet/images/tournerment/tourney/icon-group@3x.png" alt width="16" height="21"></span><span class="type-text">단체전</span><input type="radio" name="GameType" <%If GameType = "sd040002" Then %>checked<%End If%>value="sd040002"></label>
            </li>
            <li class="type-sel" id="sel_TeamGb">
              <select id="TeamGb">
                <option value="">::소속구분선택::</option>
              </select>
            </li>
            <li class="type-sel" id="sel_Search_Sex">
              <select id="Sex">
                <option value="Man">남자</option>
                <option value="WoMan">여자</option>
              </select>
            </li>
            <li class="type-sel" id="sel_Level">
              <select id="Level" onclick="alert('소속 성별 선택후 체급을 선택해 주세요.');">
                <option value="">::체급선택::</option>
              </select>
            </li>
            <li class="btn-list">
              <button type="button" id="search" class="btn btn-warning btn-search" onclick="chk_search();">조 회</button>
            </li>
            <li class="btn-list">
              <button type="button" id="search" class="btn btn-warning btn-search">저장</button>
            </li>
          </ul>
        </div>
        </form>
        <!--검색영역 E-->
        <!-- E: tab-menu -->
      </div>
      <!-- E: input-select -->
    <!-- E: main -->

    <!-- S: tourney-main -->
    <div class="tourney-main hidden-main">
      <h3 class="stit">대진표 입력하기</h3>
      <!-- S: tourney-->
      <div class="tourney clearfix">
        <!-- S: left-side -->
        <div class="left-side clearfix">
          <!-- S: match-list -->
          <div class="match-list">
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-01</span>
                  <span class="player-name-input"><input type="text" /></span>
                  <!--<span class="player-school">서울체육중학교</span>-->
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-02</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-03</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-04</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-05</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-06</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S : match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-07</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-08</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-09</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-10</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-11</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-12</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-13</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-14</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-15</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-16</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-17</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-18</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-19</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-20</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-21</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-22</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-23</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-24</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-25</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-26</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-27</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-28</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-29</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-30</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-31</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-32</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-33</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-34</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-35</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-36</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-37</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-38</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-39</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-40</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-41</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-42</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-43</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-44</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-45</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-46</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-47</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-48</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-49</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-50</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-51</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-52</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-53</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-54</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-55</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-56</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-57</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-58</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-59</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-60</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
             <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-61</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-62</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
             <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">L-63</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">L-64</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
          </div>
          <!-- E: match-list -->
          <!-- S: round-1 -->
          <div class="round-1">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="2" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="3" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="4" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="5" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="6" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="7" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="8" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="9" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="10" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="11" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="12" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="13" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="14" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="15" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="16" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="17" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="18" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="19" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="20" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="21" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="22" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="23" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="24" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="25" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="26" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="27" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="28" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="29" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="30" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="31" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="32" class="in_count">
            </div>
          </div>
          <!-- E: round-1 -->

          <!-- S: round-2 -->
          <div class="round-2">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="2" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="3" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="4" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="5" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="6" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="7" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="8" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="9" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="10" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="11" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="12" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="13" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="14" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="15" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="16" class="in_count">
            </div>
          </div>
          <!-- E: round-2 -->

          <!-- S: round-3 -->
          <div class="round-3">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="2" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="3" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="4" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="5" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="6" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="7" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="8" class="in_count">
            </div>
          </div>
          <!-- E: round-3 -->
          <!-- S: round-4 -->
          <div class="round-4">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="2" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="3" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="4" class="in_count">
            </div>
          </div>
          <!-- E: round-4 -->
          <!-- S: round-5 -->
          <div class="round-5">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="2" class="in_count">
            </div>
          </div>
          <!-- E: round-5 -->
          <!-- S: round-6 -->
          <div class="round-6">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
          </div>
          <!-- E: round-6 -->
        </div>
        <!-- E: left-side -->

          <!-- S : match-input-result 460 x 800 -->

          <div class="match-input-result">
            <div class="inner">
              <ul class="top">
                <li>시드</li>
                <li>선수이름</li>
                <li>팀이름</li>
              </ul>
              <div class="list">
              <%
                '--------------------------------------------------------------------------------------------------------------------------------------------------------
                '선수 리스트 --------------------------------------------------------------------------------------------------------------------------------------------
                '--------------------------------------------------------------------------------------------------------------------------------------------------------
                If RGemLevelIDX <> "" Then 
                  LSQL = "select PlayerIDX,UserName,SportsDiary.dbo.FN_SchoolName(SchIDX) AS SchName from tblrplayermaster  where gametitleidx='"&GameTitleIDX&"' and RgameLevelIDX='"&RGemLevelIDX&"' Order By UserName"
                  Set LRs = Dbcon.Execute(LSQL)

                  If Not(LRs.Eof Or LRs.Bof) Then 
                    Do Until LRs.Eof 
              %>
                <dl>
                  <dt></dt>
                  <dd onclick="chk_player('<%=LRs("UserName")%>','<%=LRs("PlayerIDX")%>')"><%=LRs("UserName")%></dd>
                  <dd onclick="chk_player('<%=LRs("UserName")%>','<%=LRs("PlayerIDX")%>')"><%=LRs("SchName")%></dd>
                </dl>
              <%
                      LRs.MoveNext
                    Loop 
                  End If 
                End If 
                '--------------------------------------------------------------------------------------------------------------------------------------------------------
                '선수 리스트 --------------------------------------------------------------------------------------------------------------------------------------------
                '--------------------------------------------------------------------------------------------------------------------------------------------------------
              %>                
              </div>
            </div>
          </div>
          <!-- E : match-input-result 800 x 800 -->

        <!-- S: right-side -->
        <div class="right-side">
          <!-- S: match-list -->
          <div class="match-list">
            <!-- S: match -->
            <div class="match">
              <!-- S: 관리자용 -->
              <!-- <div class="player-info admin">
                <span class="player-name">
                  <select name="">
                    <option value="">유도왕</option>
                    <option value="">김이박최조</option>
                    <option value="">손발연호</option>
                  </select>
                </span>
                <span class="player-id">
                  <select name="">
                    <option value="">3011</option>
                    <option value="">301</option>
                    <option value="">30135</option>
                  </select>
                </span>
                <span class="player-school">
                  <select name="">
                    <option value="">서울 체육 고등학교</option>
                    <option value="">미국 캘리포니아 국립 과학 영재고</option>
                    <option value="">몽골 울란바토르 주립 체육대학교</option>
                    <option value="">오스트레일리아 시드니 시립 외국어 영재고</option>
                    <option value="">대구 체육 스페셜 고등학교</option>
                  </select>
                </span>
              </div> -->
              <!-- E: 관리자용 -->
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-01</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-02</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-03</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-04</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-05</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-06</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S : match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-07</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-08</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-09</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-10</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-11</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-12</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-13</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-14</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-15</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-16</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-17</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-18</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-19</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-20</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-21</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-22</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-23</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-24</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-25</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-26</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-27</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-28</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-29</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-30</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-31</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-32</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-33</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-34</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-35</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-36</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-37</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-38</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-39</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-40</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-41</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-42</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-43</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-44</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-45</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-46</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-47</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-48</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-49</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-50</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-51</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-52</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-53</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-54</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-55</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-56</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-57</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-58</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-59</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-60</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-61</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-62</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
            <!-- S: match -->
            <div class="match">
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-white">R-63</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="player-num-blue">R-64</span>
                  <span class="player-name-input"><input type="text" /></span>
                </div>
              </div>
            </div>
            <!-- E: match -->
          </div>
          <!-- E: match-list -->
          <!-- S: round-1 -->
          <div class="round-1">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="2" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="3" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="4" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="5" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="6" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="7" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="8" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="9" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="10" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="11" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="12" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="13" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="14" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="15" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="16" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="17" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="18" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="19" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="20" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="21" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="22" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="23" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="24" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="25" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="26" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="27" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="28" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="29" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="30" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="31" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="32" class="in_count">
            </div>
          </div>
          <!-- E: round-1 -->

          <!-- S: round-2 -->
          <div class="round-2">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="2" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="3" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="4" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="5" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="6" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="7" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="8" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="9" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="10" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="11" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="12" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="13" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="14" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="15" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="16" class="in_count">
            </div>
          </div>
          <!-- E: round-2 -->

          <!-- S: round-3 -->
          <div class="round-3">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="2" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="3" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="4" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="5" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="6" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="7" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="8" class="in_count">
            </div>
          </div>
          <!-- E: round-3 -->
          <!-- S: round-4 -->
          <div class="round-4">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="2" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="3" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="4" class="in_count">
            </div>
          </div>
          <!-- E: round-4 -->
          <!-- S: round-5 -->
          <div class="round-5">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
            <div class="line-div">
              <input type="text" value="2" class="in_count">
            </div>
          </div>
          <!-- E: round-5 -->
          <!-- S: round-6 -->
          <div class="round-6">
            <div class="line-div">
              <input type="text" value="1" class="in_count">
            </div>
          </div>
          <!-- E: round-6 -->
        </div>
        <!-- E: right-side -->
      </div>
      <!-- E: tourney-->

      <!-- S: Winner  result Modal -->
        <div class="modal fade round-1-res" id="round-1-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <!-- S: modal-header -->
              <div class="modal-header">
                <h4 class="modal-title" id="modal-title">SCORE</h4>
              </div>
              <!-- E: modal-header -->
              <div class="modal-body">
                <table class="table result-table">
                  <caption class="sr-only">경기 결과 요약</caption>
                  <thead>
                    <tr>
                      <th colspan="2">신재진</th>
                      <th colspan="1">구분</th>
                      <th colspan="2">김영석</th>
                    </tr>
                  </thead>
                  <tbody>
                      <td></td>
                      <td></td>
                      <th>한판</th>
                      <td></td>
                      <td></td>
                    </tr>
                    <tr>
                      <td>한팔 빗당겨치기</td>
                      <td>  </td>
                      <th>절반</th>
                      <td></td>
                      <td></td>
                    </tr>
                    <tr>
                      <td>뒤허리안아 메치기</td>
                      <td>1</td>
                      <th>유효</th>
                      <td>1</td>
                      <td>기타 누으며 메치기</td>
                    </tr>
                    <tr>
                      <td></td>
                      <td></td>
                      <th>지도</th>
                      <td></td>
                      <td></td>
                    </tr>
                  </tbody>
                </table>
                <div class="record">
                  <ul>
                    <li class="mine">
                        [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">누으며메치기</span>
                    </li>
                    <li class="mine recent">
                        [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">절반 손기술(한팔 빗당겨치기)</span>
                    </li>
                    <li class="opponent">
                        [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 상대 </span>: <span class="skill">허리기술(허리띄기)</span>
                    </li>
                    <li class="opponent recent">
                        [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 상대 </span>: <span class="skill">유효 누으며 메치기(기타 누으며 메치기)</span>
                    </li>
                    <li class="opponent">
                        [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 상대 </span>: <span class="skill">손기술(한소매 업어치기)</span>
                    </li>
                    <li class="mine">
                        [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">유효 허리기술(뒤허리안아 메치기)</span>
                    </li>
                    <li class="mine">
                        [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">유효 허리기술(뒤허리안아 메치기)</span>
                    </li>
                    <li class="mine">
                        [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">유효 허리기술(뒤허리안아 메치기)</span>
                    </li>
                    <li class="opponent">
                        [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">유효 허리기술(뒤허리안아 메치기)</span>
                    </li>
                    <li class="opponent">
                        [<span class="record-time">01:00~00:01</span>]<span class="record-type"> 본인 </span>: <span class="skill">유효 허리기술(뒤허리안아 메치기)</span>
                    </li>
                  </ul>
                </div>
                <!-- E: record -->
              </div>
              <!-- E: modal-body -->
              <!-- S: modal footer -->
             <div class="modal-footer">
               <span class="ins_group">
                <label for="ins_code">협회코드 입력</label>
                <input type="text" id="ins_code" class="ins_code">
              </span>
              <a href="#repair-modal" role="button" class="btn btn-repair" data-toggle="modal" data-target="#repair-modal">수정하기</a>
              <a href="#" role="button" class="btn btn-close" data-dismiss="modal">닫기</a>
            </div>
            <!--E: modal-footer -->
          </div><!-- modal-content -->
        </div> <!-- modal-dialog -->
      </div>
      <!-- E: Winner-1 result Modal -->

      <!-- S: repair Modal
      <div class="modal fade" id="repair-modal" tabindex="-1" role="dialog" aria-labelledby="repair-title" aria-hidden="true">
        S: modal-dialog
        <div class="modal-dialog">
          S: modal-content
          <div class="modal-content">
            S: modal-header
            <div class="modal-header">
              <h4 class="repair-title" id="repair-title">수정하기</h4>
            </div>
            E: modal-header
            S: modal-body
            <div class="modal-body">
              ...
            </div>
            E: modal-body
            S: modal-footer
            <div class="modal-footer">
              <a href="#" role="button" class="btn btn-repair">저장하기</a>
              <a href="#" role="button" class="btn btn-close" data-dismiss="modal">취소</a>
            </div>
            E: modal-footer
          </div>
          E: modal-content
        </div>
        E: modal-dialog
      </div>
      E: repair Modal -->
    <!-- custom.js -->
    <script src="js/main.js"></script>
  </body>
</html>