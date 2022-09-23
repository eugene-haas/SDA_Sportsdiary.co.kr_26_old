<!--#include virtual="/Manager/Library/config.asp"-->
<%
  '대회번호
  GameTitleIDX = fInject(Request("GameTitleIDX"))
  '개인전단체전구분
  GameType = fInject(Request("GameType"))


' Response.wRITE GameType

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



'총경기수는 TotRound 이다
If TotRound > 0 And PlayerCnt > 0 Then 
  '한쪽에 뿌려져야할 경기수를 TotRound / 2

	If TotRound = "2" Then 
	  HalfRound = 2
	Else 
	  HalfRound = TotRound / 2    
	End If 
  


  If  UnearnedCnt>0 Then 
    '4강 부전승 순서
    If TotRound = 2 Then 
      Unearned = "2"
    ElseIf TotRound = 4 Then 
      Unearned = "4,2"
    '8강 부전승 순서  
    ElseIf TotRound = 8 Then 
      Unearned = "8,4,6,2"
    '16강 부전승 순서 
    ElseIf TotRound = 16 Then 
      Unearned = "16,8,12,4,14,6,10,2"
    '32강 부전승 순서 
    ElseIf TotRound = 32 Then 
      Unearned = "32,16,24,8,28,12,20,4,30,14,22,6,26,10,18,2"
    ElseIf TotRound = 64 Then 
      Unearned = "64,32,48,16,56,24,40,8,60,28,44,12,52,20,36,4,62,30,46,14,54,22,38,6,58,26,42,10,50,18,34,2"
    ElseIf TotRound = 128 Then 
      Unearned = "128,64,96,32,112,48,80,16,120,56,88,24,104,40,72,8,124,60,92,28,108,44,76,12,116,52,84,20,100"
      Unearned  = Unearned&",36,68,4,126,62,94,30,110,46,78,14,118,54,86,22,102,38,70,6,122,58,90,26,106,42,74,10,114,50,82,18,98,34,66,2"

'     Unearned = "2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2"
'     Unearned  = Unearned&",2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2"
    End If 

    Array_Unearned  = Split(Unearned,",")
    Unearned_Number = ""


    For i = 0 To UnearnedCnt-1
      If i = 0 Then 
        Unearned_Number = Unearned_Number & Array_Unearned(i)
      Else
        Unearned_Number = Unearned_Number &","& Array_Unearned(i)
      End If 
    Next      

    'Response.Write Unearned_Number
    'Response.End
  End If 
End If 
'Response.Write RGameLevelIDX
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
    sf.action="tournamentInfo.asp"
    sf.submit();
  }
}


//부전승이 아닌 일반경기수 체크
function chk_pair(){
  var pair_cnt = 0
  var totcnt = "<%=TotRound%>"

  for(i=1;i<=totcnt;i++){
    result = i % 2
    if(result == 1){
      x = (i+1)

      if(document.getElementById("Player"+i).value!="" && document.getElementById("hidden_data"+x).value!=""){
        pair_cnt = pair_cnt + 1
        document.getElementById("R1_Num"+(x/2)).value = pair_cnt;
        document.getElementById("pair_cnt").value = pair_cnt;               
      }
    }
  }
}


function chk_round2(){
  var r1_cnt = document.getElementById("pair_cnt").value;
  var r2_cnt = document.getElementById("R2_Cnt").value;
  var r3_cnt = document.getElementById("R3_Cnt").value;
  var r4_cnt = document.getElementById("R4_Cnt").value;
  var r5_cnt = document.getElementById("R5_Cnt").value; 
  var r6_cnt = document.getElementById("R6_Cnt").value; 
  if(Number(r2_cnt)>1){
    for(i=1;i<=r2_cnt;i++){
      document.getElementById("R2_Num"+i).value = Number(r1_cnt)+i;
    }
  }
  if(Number(r3_cnt)>1){
    for(i=1;i<=r3_cnt;i++){
      document.getElementById("R3_Num"+i).value = Number(r1_cnt)+Number(r2_cnt)+i;
    }
  }
  if(Number(r4_cnt)>1){
    for(i=1;i<=r4_cnt;i++){
      document.getElementById("R4_Num"+i).value = Number(r1_cnt)+Number(r2_cnt)+Number(r3_cnt)+i;
    }
  }
  if(Number(r5_cnt)>1){
    for(i=1;i<=r5_cnt;i++){
      document.getElementById("R5_Num"+i).value = Number(r1_cnt)+Number(r2_cnt)+Number(r3_cnt)+Number(r4_cnt)+i;
    }
  }
  if(Number(r6_cnt)>1){
    for(i=1;i<=r6_cnt;i++){
      document.getElementById("R6_Num"+i).value = Number(r1_cnt)+Number(r2_cnt)+Number(r3_cnt)+Number(r4_cnt)+Number(r5_cnt)+i;
    }
  }
}


function chk_round2_reset(){
  var r1_cnt = document.getElementById("R1_Cnt").value;
  var r2_cnt = document.getElementById("R2_Cnt").value;
  var r3_cnt = document.getElementById("R3_Cnt").value;
  var r4_cnt = document.getElementById("R4_Cnt").value;
  var r5_cnt = document.getElementById("R5_Cnt").value; 
  var r6_cnt = document.getElementById("R6_Cnt").value; 


  
  for(i=1;i<=r1_cnt;i++){
    document.getElementById("R1_Num"+i).value = "";
  }

  if(Number(r2_cnt)>1){
    for(i=1;i<=r2_cnt;i++){
      document.getElementById("R2_Num"+i).value = "";
    }
  }
  if(Number(r3_cnt)>1){
    for(i=1;i<=r3_cnt;i++){
      document.getElementById("R3_Num"+i).value = "";
    }
  }
  if(Number(r4_cnt)>1){
    for(i=1;i<=r4_cnt;i++){
      document.getElementById("R4_Num"+i).value = "";
    }
  }
  if(Number(r5_cnt)>1){
    for(i=1;i<=r5_cnt;i++){
      document.getElementById("R5_Num"+i).value = "";
    }
  }
  if(Number(r6_cnt)>1){
    for(i=1;i<=r6_cnt;i++){
      document.getElementById("R6_Num"+i).value = "";
    }
  }
}


function chk_save(){
  var sf = document.search_frm;


  if(sf.GameType[0].checked){
    if(confirm("해당 대진표를 저장하시겠습니까?")){
      var totcnt = "<%=TotRound%>";
      for(k=1;k<=totcnt;k++){
        if(document.getElementById("Player"+k).disabled == true){
          document.getElementById("Player"+k).disabled = false;
          document.getElementById("hidden_data"+k).disabled = false;
        }       
      } 

      if(totcnt=="2"){
        sf.action = "Tournament2_ok.asp"    
      }else if(totcnt=="4"){
        sf.action = "Tournament4_ok.asp"    
      }else if(totcnt=="8"){
        sf.action = "Tournament8_ok.asp"    
      }else if(totcnt=="16"){
        sf.action = "Tournament16_ok.asp"   
      }else if(totcnt=="32"){
        sf.action = "Tournament32_ok.asp"   
      }else if(totcnt=="64"){
        sf.action = "Tournament64_ok.asp"   
      }else if(totcnt=="128"){
        sf.action = "Tournament128_ok.asp"    
      }
      sf.submit();
    }
  }else if(sf.GameType[1].checked){
    if(confirm("해당 대진표를 저장하시겠습니까?")){
      var totcnt = "<%=TotRound%>";

      for(k=1;k<=totcnt;k++){
        if(document.getElementById("Player"+k).disabled == true){
          document.getElementById("Player"+k).disabled = false;
          document.getElementById("hidden_data"+k).disabled = false;
        }       
      } 

      if(totcnt=="2"){
        sf.action = "SchoolTournament2_ok.asp"    
      }else if(totcnt=="4"){
        sf.action = "SchoolTournament4_ok.asp"    
      }else if(totcnt=="8"){
        sf.action = "SchoolTournament8_ok.asp"    
      }else if(totcnt=="16"){
        sf.action = "SchoolTournament16_ok.asp"   
      }else if(totcnt=="32"){
        sf.action = "SchoolTournament32_ok.asp"   
      }else if(totcnt=="64"){
        sf.action = "SchoolTournament64_ok.asp"   
      }else if(totcnt=="128"){
        sf.action = "SchoolTournament128_ok.asp"    
      }
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
    <input type="text" name="R1_Cnt" id="R1_Cnt" value=<%=TotRound/2%>>
    <input type="text" name="R2_Cnt" id="R2_Cnt" value=<%=TotRound/4%>>
    <input type="text" name="R3_Cnt" id="R3_Cnt" value=<%=TotRound/8%>>
    <input type="text" name="R4_Cnt" id="R4_Cnt" value=<%=TotRound/16%>>
    <input type="text" name="R5_Cnt" id="R5_Cnt" value=<%=TotRound/32%>>
    <input type="text" name="R6_Cnt" id="R6_Cnt" value=<%=TotRound/64%>>
    <!-- S: tourney-main -->
    <div class="tourney-main hidden-main">
      <!-- S: tourney-->
      <div class="tourney clearfix">
        <h3 class="stit">대진표 입력하기<input type="button" value="추첨" onclick="random_start();"><input type="button" value="초기화" onclick="radom_reset()"></h3>
        <!-- S: left-side -->
        <div class="left-side clearfix">
          <!-- S: match-list -->
          <div class="match-list">
            <!-- S: match -->
             <% 
              For i = 1 To HalfRound
                '도복색 설정
                If i Mod 2 = 1 Then  
                  Response.Write "<div class='match'>"
                  player_class="player-num-white"
                  
                Else
                  player_class="player-num-blue"      
                End If 
            %>
        
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="<%=player_class%>">L-<%=AddZero(i)%></span>
                  <%
                    Array_Unearned_Number = Split(Unearned_Number,",")                    
                    css_disabled = ""
                    For x = 0 To Ubound(Array_Unearned_Number)
                    
                      If i = CInt(Array_Unearned_Number(x)) Then 
                        css_disabled = "disabled='disabled'"                      
                      End If                    
                    Next
                  %>
                  <span class="player-name-input"><input type="text" name="Player<%=i%>" id="Player<%=i%>" <%=css_disabled%> readonly onclick="input_data(this,'hidden_data<%=i%>')" /></span>
                  <input type="hidden" name="hidden_data<%=i%>" id="hidden_data<%=i%>" <%=css_disabled%>>
                  <!--<span class="player-school">서울체육중학교</span>-->
                </div>
              </div>
              <%
                css_diabled = ""
              %>


            <%
                If i Mod 2 = 0 Then  
                  Response.Write "</div>"
                End If 
              Next
            %>
            <!-- E: match -->           
          </div>
          <!-- E: match-list -->
          <!-- S: round-1 -->
          <%
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          %>
          <div class="round-1">
            <%
              For R1_1 = 1 To HalfRound/2
            %>
            <div class="line-div">
              <input type="text" value="" id="R1_Num<%=R1_1%>" name="R1_Num<%=R1_1%>"  class="in_count" readonly >
            </div>
            <%
                'R1_1 = R1_1 + 1
              Next              
            %>           
          </div>
          <%
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          %>
          <!-- E: round-1 -->
          <%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %>
          <!-- S: round-2 -->
          <%
            If HalfRound/4 >= 1 Then 
          %>
          <div class="round-2">
            <%
              For R2_1 = 1 To HalfRound/4
            %>
            <div class="line-div">
              <input type="text" name="R2_Num<%=R2_1%>" id="R2_Num<%=R2_1%>" class="in_count" readonly>
            </div>
            <%
              Next              
              
            %>            
          </div>
          <%
            End If 
          %>
          <!-- E: round-2 -->
          <%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %>
          <!-- S: round-3 -->
          <%
            If HalfRound/8 >= 1 Then 
          %>
          <div class="round-3">
            <%              
              For R3_1 = 1 To HalfRound/8
            %>
            <div class="line-div">
              <input type="text" name="R3_Num<%=R3_1%>" id="R3_Num<%=R3_1%>" class="in_count" readonly>
            </div>
            <%
              Next          
              
            %>            
          </div>
          <%
            End If 
          %>
          <!-- E: round-3 -->
          <!-- S: round-4 -->
          <%
            If HalfRound/16 >= 1 Then
          %>
          <div class="round-4">
            <%
              
              For R4_1 = 1 To HalfRound/16
            %>
            <div class="line-div">
              <input type="text" name="R4_Num<%=R4_1%>" id="R4_Num<%=R4_1%>" class="in_count" readonly>
            </div>
            <%
              Next              
              
            %>  
          </div>
          <%
            End If 
          %>
          <!-- E: round-4 -->
          <!-- S: round-5 -->
          <%
            If HalfRound/32 >= 1 Then
          %>
          <div class="round-5">
            <%
              
              For R5_1 = 1 To HalfRound/32
            %>
            <div class="line-div">
              <input type="text" name="R5_Num<%=R5_1%>" id="R5_Num<%=R5_1%>" class="in_count" readonly>
            </div>
            <%
              Next  

            %>              
          </div>
          <%
            End If 
          %>
          <!-- E: round-5 -->
          <!-- S: round-6 -->
          <%
            If HalfRound/64 >= 1 Then
          %>
          <div class="round-6">
            <%
              
              For R6_1 = 1 To HalfRound/64
            %>
            <div class="line-div">
              <input type="text" name="R6_Num<%=R6_1%>" id="R6_Num<%=R6_1%>" value="1" class="in_count" readonly>
            </div>
            <%
              Next
            %>
          </div>
          <%
            End If 
          %>
          <!-- E: round-6 -->
          </div>
          <!-- E: left-side -->

          <!-- S : match-input-result 800 x 800 -->
          <%
            '--------------------------------------------------------------------------------------------------------------------------------------------------------
            '개인전 선수 리스트 --------------------------------------------------------------------------------------------------------------------------------------------
            '--------------------------------------------------------------------------------------------------------------------------------------------------------
            If GameType = "sd040001" Then 
              If RGameLevelIDX <> "" Then 
                LSQL = "select PlayerIDX,UserName,SportsDiary.dbo.FN_TeamCodeReturnTeamNm('judo',Team) AS TeamNm from tblrplayermaster  where gametitleidx='"&GameTitleIDX&"' and RgameLevelIDX='"&RGameLevelIDX&"' AND DelYN='N' Order By UserName"
                'Response.Write LSQL
                'Response.End

                Set LRs = Dbcon.Execute(LSQL)
                
                
                If Not(LRs.Eof Or LRs.Bof) Then             
                  k = 1
          %>
          <div class="match-input-result sticky">
            <div class="inner">
              <ul class="top">
                <li>시드</li>
                <li>선수이름</li>
                <li>팀이름</li>
              </ul>
              <div class="list">
              <%
                    Do Until LRs.Eof 
              %>
                <dl id="No<%=k%>" class="clearfix">
                  <dt id="seed<%=LRs("PlayerIDX")%>"></dt>
                  <dd onclick="chk_player('<%=LRs("UserName")%>','<%=LRs("PlayerIDX")%>','<%=k%>')"><%=LRs("UserName")%></dd>
                  <dd onclick="chk_player('<%=LRs("UserName")%>','<%=LRs("PlayerIDX")%>','<%=k%>')"><%=LRs("TeamNm")%></dd>
                </dl>
              <%
                      k = k + 1
                      LRs.MoveNext
                    Loop 
                End If 
                
              %>                
              </div>
            </div>
          </div>
          <%
              End If 
            '--------------------------------------------------------------------------------------------------------------------------------------------------------
            '개인전 선수 리스트 --------------------------------------------------------------------------------------------------------------------------------------------
            '--------------------------------------------------------------------------------------------------------------------------------------------------------






            ElseIf GameType = "sd040002" Then 
              '--------------------------------------------------------------------------------------------------------------------------------------------------------
              '단체전 소속 리스트 -------------------------------------------------------------------------------------------------------------------------------------
              '--------------------------------------------------------------------------------------------------------------------------------------------------------
              If RGameLevelIDX <> "" Then 
                  LSQL = "select Team,SchoolName,SportsDiary.dbo.FN_SchoolName(SchIDX) AS SchName from SportsDiary.dbo.tblRGameGroupSchoolMaster"
                  LSQL = LSQL&" WHERE Gametitleidx='"&GameTitleIDX&"' and RgameLevelIDX='"&RGameLevelIDX&"' AND DelYN='N' Order By SchoolName"
                  'Response.Write LSQL

                  Set LRs = Dbcon.Execute(LSQL)
                  
                  
                  If Not(LRs.Eof Or LRs.Bof) Then             
                    k = 1
            %>
            <div class="match-input-result sticky">
              <div class="inner">
                <ul class="top">
                  <li>시드</li>
                  <li>소속이름</li>
                </ul>
                <div class="list">
                <%
                      Do Until LRs.Eof 
                %>
                  <dl id="No<%=k%>" class="">
                    <dt id="seed<%=LRs("Team")%>"></dt>
                    <dd onclick="chk_player('<%=LRs("SchoolName")%>','<%=LRs("Team")%>','<%=k%>')"><%=LRs("SchoolName")%></dd>
                  </dl>
                <%
                        k = k + 1
                        LRs.MoveNext
                      Loop 
                  End If 
                  
                %>                
                </div>
              </div>
            </div>
            <%
                End If 
              '--------------------------------------------------------------------------------------------------------------------------------------------------------
              '단체전 소속 리스트 -------------------------------------------------------------------------------------------------------------------------------------
              '--------------------------------------------------------------------------------------------------------------------------------------------------------
            End If 

          %>
          <!-- E : match-input-result 800 x 800 -->
        <!-- S: right-side -->
        <div class="right-side">
          <!-- S: match-list -->
          <div class="match-list">
            <!-- S: match -->
            <% 
              For k = i To TotRound
                '도복색 설정
                If k Mod 2 = 1 Then  
                  Response.Write "<div class='match'>"
                  player_class="player-num-white"
                  
                Else
                  player_class="player-num-blue"      
                End If 
            %>
              
              <div class="player-info" tabindex="0">
                <div class="player-input-wrap">
                  <span class="<%=player_class%>">R-<%=AddZero(k)%></span>
                  <%                    
                    Array_Unearned_Number = Split(Unearned_Number,",")                    
                    css_diabled = ""
                    For x = 0 To Ubound(Array_Unearned_Number)
                    
                      If k = CInt(Array_Unearned_Number(x)) Then 
                        css_diabled = "disabled"                      
                      End If                    
                    Next                  
                  %>
                  <span class="player-name-input"><input type="text" name="Player<%=k%>" id="Player<%=k%>" <%=css_diabled%> readonly onclick="input_data(this,'hidden_data<%=k%>')" /></span>
                  <input type="hidden" name="hidden_data<%=k%>" id="hidden_data<%=k%>">
                  <!--<span class="player-school">서울체육중학교</span>-->
                </div>
              </div>
              <%
                css_diabled = ""
              %>
            <%
                If k Mod 2 = 0 Then  
                  Response.Write "</div>"
                End If 
              Next
            %>
            <!-- E: match -->            
          </div>
          <!-- E: match-list -->
          <!-- S: round-1 -->
          <%
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          %>
          <div class="round-1">
            <%
              
              For R1_2 = R1_1 To TotRound/2
            %>
            <div class="line-div">
              <input type="text"  value="" id="R1_Num<%=R1_2%>" name="R1_Num<%=R1_2%>" class="in_count" readonly>
            </div>
            <%
                'R1_2 = R1_2 + 1
              Next              
            %>           
          </div>
          <%
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          ''''''''''''''''''''''''''''''''''''''''''   Round 1 '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
          %>
          <!-- E: round-1 -->
          <%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %>
          <!-- S: round-2 -->
          <%
            If HalfRound/4 >= 1 Then 
          %>
          <div class="round-2">
            <%
              For R2_2 = R2_1 To TotRound/4
            %>
            <div class="line-div">
               <input type="text" name="R2_Num<%=R2_2%>" id="R2_Num<%=R2_2%>" class="in_count" readonly>
            </div>
            <%
              Next              
            %>            
          </div>
          <%
            End If 
          %>
          <!-- E: round-2 -->
          <%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   Round 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %>
          <!-- S: round-3 -->
          <%
            If HalfRound/8 >= 1 Then 
          %>
          <div class="round-3">
            <%
              For R3_2 = R3_1 To TotRound/8
            %>
            <div class="line-div">
               <input type="text" name="R3_Num<%=R3_2%>" id="R3_Num<%=R3_2%>" class="in_count" readonly>
            </div>
            <%
              Next              
            %>            
          </div>
          <%
            End If 
          %>
          <!-- E: round-3 -->
          <!-- S: round-4 -->
          <%
            If HalfRound/16 >= 1 Then 
          %>
          <div class="round-4">
            <%
              For R4_2 = R4_1 To TotRound/16
            %>
            <div class="line-div">
               <input type="text" name="R4_Num<%=R4_2%>" id="R4_Num<%=R4_2%>" class="in_count" readonly>
            </div>
            <%
              Next                            
            %>  
          </div>
          <%
            End If 
          %>
          <!-- E: round-4 -->
          <!-- S: round-5 -->
          <%
            If HalfRound/32 >= 1 Then 
          %>
          <div class="round-5">
            <%
              For R5_2 = R5_1 To TotRound/32
            %>
            <div class="line-div">
               <input type="text" name="R5_Num<%=R5_2%>" id="R5_Num<%=R5_2%>" class="in_count" readonly>
            </div>
            <%
              Next                  
            %>  
           <%
            End If 
           %> 
          </div>
          <!-- E: round-5 -->
          <!-- S: round-6 -->
          <%
            If HalfRound/62 >= 1 Then 
          %>
          <div class="round-6">
            <%
              For R6_2 = R6_1 To TotRound/64
            %>
            <div class="line-div">
               <input type="text" name="R6_Num<%=R6_2%>" id="R6_Num<%=R6_2%>" class="in_count" readonly>
            </div>
            <%
              Next                  
            %> 
          </div>
          <%
            End If 
          %>
          <!-- E: round-6 -->
          </div>
        <!-- E: right-side -->
      </div>      
      <!-- E: tourney-->
      </form>
    <%
      Else 
    %>
      <span>등록된 경기 정보가 없습니다.</span>
    <%
      End If 
    %>
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
    <!-- 스티키 스크립트 -->
    <script src="../js/sticky.js"></script>
    <script>
      (function($){
        function arrH(){
          var $searchBtn = $('#searchBtn');
          var $tourney = $('.tourney');
          var $matchList = $('.match-list').first();
          var $matchInputResult = $('.match-input-result .inner');
          var matchInputResultH = $matchInputResult.outerHeight();

          setTourneyH();


          function setTourneyH(){
            var h = $matchList.height();
            if ($tourney.outerHeight(true) > matchInputResultH) {
              h = matchInputResultH;
            }
            $tourney.css({
              'height' : h + 280
            }); // css end
          }; // setTourneyH end

        }; // arrH end
        arrH();
      })(jQuery);
    </script>
  </body>
</html>
