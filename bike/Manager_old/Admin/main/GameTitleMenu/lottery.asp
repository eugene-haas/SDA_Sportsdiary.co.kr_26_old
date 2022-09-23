<!--#include file="../../dev/dist/config.asp"-->
<!--#include file="../../include/head.asp"-->

<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
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

'Response.Write "GameTitleIDX : " & GameTitleIDX & "<br/>"
'Response.Write "GroupGameGb : " & GroupGameGb & "<br/>"
'Response.Write "PlayType : " & PlayType & "<br/>"
'Response.Write "TeamGb : " & TeamGb & "<br/>"
'Response.Write "Level : " & Level & "<br/>"
'Response.Write "LevelDtl : " & LevelDtl & "<br/>"



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

%>
<style>
  #left-navi{display:none;}
  #header{display:none;}
</style>

<script>
  var locationStr;

</script>
<html>
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta charset="utf-8">
  <title>경기추첨</title>
  <!--[if IE]>
  <script type="text/javascript">
  document.createElement('header');document.createElement('aside');document.createElement('article');document.createElement('footer');</script>
  <![endif]-->
  <link href="/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css">

  <link rel="stylesheet" href="/css/fontawesome-all.css">
  <link href="/css/bootstrap.min.css" rel="stylesheet" media="screen">
  <script src="/js/bootstrap.min.js"></script>
  <link rel="stylesheet" href="/css/bmAdmin.css?ver=8">
  <link rel="stylesheet" href="/css/admin/admin.d.style.css">
  <script src="/ckeditor/ckeditor.js"></script>

<!-- <link rel="stylesheet" type="text/css" href="/css/style_bmtourney.css?v=2"> -->



<script>
    ////////////명령어////////////
        CMD_SELGAMETITLE = 1;
        CMD_SELGAMELEVEL= 2;
        CMD_LevelDtlList = 3;
        CMD_Tourneylottery = 5;
				CMD_Leaguelottery = 6;
				CMD_LeagueSave = 7;
				CMD_TourneySave = 8;		
				CMD_TourneyGang = 9;		
        CMD_RequestTeam = 10;
        CMD_RequestPlayer = 11;
        CMD_TourneyUpdate = 12;
        CMD_SEARCHGAMETITLE = 13;
    ////////////명령어////////////

    $(document).ready(function () {

        //경기일자
        //sel_GameTitle();
        
        //sel_PlayType();

        //sel_TeamGb();

        //sel_Level();

        initSearchControl();
        OnGameTitleChanged("C4F45D4766A741AF49900107ACE44658");
        cli_RequestLevelDtl('1328',this)

    });

    

  function initSearchControl()
  {
    $( "#strGameTtitle" ).autocomplete({
      source : function( request, response ) {
        $.ajax(
          {
              type: 'post',
              url: "../../Ajax/GameTitleMenu/searchGameTitle.asp",
              dataType: "json",
              data: { "REQ" : JSON.stringify({"CMD":CMD_SEARCHGAMETITLE, "SVAL":request.term}) },
              success: function(data) {
                  //서버에서 json 데이터 response 후 목록에 뿌려주기 위함
                  response(
                      $.map(data, function(item) {
                          return {
                              label: item.gameTitleName + "(" + item.gameS + "~" + item.gameE + ")" + ", 번호 : " + item.uidx,
                              value: item.gameTitleName,
                              tidx : item.uidx,
                              gameTitleName : item.gameTitleName,
                              crypt_tidx : item.crypt_uidx
                          }
                      })
                  );
              }
          }
        );
      },
          //조회를 위한 최소글자수
          minLength: 1,
          select: function( event, ui ) {
            var obj = {}
            obj.CMD = CMD_SEARCHGAMETITLE;
            obj.tIdx = ui.item.tidx;
            obj.crypt_tIdx = ui.item.crypt_tidx;
            obj.tGameTitleName = ui.item.gameTitleName;
            $("#selGameTitleIdx").val(obj.crypt_tIdx);
            OnGameTitleChanged(obj.crypt_tIdx);
            sel_LevelDtlList();

            
          }
      });
  }

   function OnGameTitleChanged(value)
    { 

        Url = "/Ajax/GameTitleMenu/OnGameTitleChangedLottery.asp"
        var packet = {};
        packet.CMD = CMD_SELGAMETITLE;
        packet.tGameTitleIdx = value;
        SendPacket(Url, packet);
    };


    function OnGameLevelChanged(packet)
    { 
    GroupGameGbValue = $(":input:radio[name=radioGroupGameGb]:checked").val();
    PlayTypeSexValue = $("#selPlayTypeSex").val();
    TeamGbValue = $("#selTeamGb").val();
    LevelValue = $("#selLevel").val();

    Url = "/Ajax/GameTitleMenu/OnGameTitleChangedLottery.asp"

    packet.CMD = CMD_SELGAMELEVEL;
    packet.tGroupGameGb = GroupGameGbValue;
    packet.tTeamGb = TeamGbValue;
    packet.tPlayTypeSex = PlayTypeSexValue;
    packet.tLevel = LevelValue;

    SendPacket(Url, packet);
    };    

    //대회명 SELECT BOX 불러오기
    function sel_LevelDtlList(){
        
        var packet = {};

        Url ="../../ajax/select/LevelDtlList.asp"

        packet.CMD = CMD_LevelDtlList;
        packet.GameTitleIDX = $("#selGameTitleIdx").val(); 
        packet.GroupGameGb = $(":input:radio[name=radioGroupGameGb]:checked").val();
        packet.PlayType = $("#selPlayTypeSex").val();
        packet.TeamGb = $("#selTeamGb").val();
        packet.Level = $("#selLevel").val();                


        SendPacket(Url, packet);
    };           

    //대회명 SELECT BOX 불러오기
    function prc_RequestTeam(idx, groupgamegb){
        
        var packet = {};

				if(groupgamegb == "B0030001"){
          Url ="../../ajax/select/RequestPlayer.asp";
					packet.CMD = CMD_RequestPlayer;
        	
				}
				else{
          Url ="../../ajax/select/RequestTeam.asp";
					packet.CMD = CMD_RequestTeam;					
				}

        packet.GameLevelDtlIDX = idx;

        $("#GameLevelDtlIDX").val(idx);

        SendPacket(Url, packet);
    };  

    //대회명 SELECT BOX 불러오기
    function cli_RequestLevelDtl(idx){
        
        var packet = {};

        Url ="../../ajax/select/TourneyGang.asp"

        packet.CMD = CMD_TourneyGang;
        packet.GameLevelDtlIDX = idx

        $("#GameLevelDtlIDX").val(idx);

        SendPacket(Url, packet);
    };  		

    function prc_Tourneylottery(totround, gametype, groupgamegb, gameleveldtlidx){

        var packet = {};

        Url ="../../ajax/GameTitleMenu/Tourney_Lottery.asp"

        packet.CMD = CMD_Tourneylottery;
        packet.TotRound = totround;
        packet.GameType = gametype;
        packet.GroupGameGb = groupgamegb;
        packet.GameLevelDtlIDX = gameleveldtlidx;
        SendPacket(Url, packet);
    }

    function prc_Leaguelottery(gameleveldtlidx, gametype, groupgamegb){

        var packet = {};

        if(groupgamegb == "B0030001"){
          Url ="../../ajax/GameTitleMenu/League_Lottery.asp"
          packet.CMD = CMD_Leaguelottery;
        }
        else{
          Url ="../../ajax/GameTitleMenu/LeagueTeam_Lottery.asp"
          packet.CMD = CMD_Leaguelottery;        
        }

				packet.GameLevelDtlIDX = gameleveldtlidx;
        packet.GameType = gametype;
        packet.GroupGameGb = groupgamegb;

        SendPacket(Url, packet);
 

    }		

    function cli_tourneysave(){

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

        console.log("str_Hidden_Data : " + str_Hidden_Data);

				//return;

				var packet = {};

        if ($("#GameType").val() == "B0040001") {
          if ($("#GroupGameGb").val() == "B0030001") {
            Url ="../../ajax/GameTitleMenu/LeagueSave.asp";
            packet.CMD = CMD_LeagueSave;
          }
          else{
        
            Url ="../../ajax/GameTitleMenu/LeagueTeamSave.asp";
            packet.CMD = CMD_LeagueSave;
          }
        }
        else {
          if ($("#GroupGameGb").val() == "B0030001") {
            Url ="../../ajax/GameTitleMenu/TourneySave.asp";
            packet.CMD = CMD_TourneySave;
          }
          else{
            Url ="../../ajax/GameTitleMenu/TourneyTeamSave.asp";
            packet.CMD = CMD_TourneySave;
          }
        }				

        
        packet.LevelDtl = $("#GameLevelDtlIDX").val();
        packet.RequestGroupIDX = str_Hidden_Data;
        packet.LeagueGameNum = $("#LeagueGameNum").val();					

        SendPacket(Url, packet);
 

    }		


    function cli_Request(str1, str2, idx) {

        $("#Select_STR1").val(str1);
        $("#Select_STR2").val(str2);
        $("#Select_GroupIDX").val(idx);

    }

    function cli_tourneyinsert(strgang, strnum, strgametype, that) {
    
        //$(that).find('.placeholder').hide();
        var num_TotRound = $("#TotRound").val();

        var groupGameGbValue = $("#GroupGameGb").val();
        if (groupGameGbValue == "B0030002") {
          Url ="../../ajax/GameTitleMenu/TourneyTeamUpdate.asp";
        }
        else {
          Url ="../../ajax/GameTitleMenu/TourneyUpdate.asp";
        }

        /*
        if ($("#Select_GroupIDX").val() != "") {
          console.log("0:" + num_TotRound);
          for (var i = 1; i <= num_TotRound; i++) {
            console.log("1:" + $("#Hidden_Data_" + strgang + "_" + i).val());
            console.log("2:" + $("#Select_GroupIDX").val());
            if ($("#Hidden_Data_" + strgang + "_" + i).val() == $("#Select_GroupIDX").val()) {
             
              selTourneyTeamIdx = $("#Hidden_Idx_" + strgang + "_" + strnum).val();
              selRequestIdx =$("#Select_GroupIDX").val();
              selGameLevelDtlIDX=  $("#GameLevelDtlIDX").val();

              if(confirm("이미 대진에 포함된 선수(팀) 입니다. 수정하시겠습니까?")) {
                if (selTourneyTeamIdx != "") {
                  var packet = {}; 
                  packet.CMD = CMD_TourneyUpdate;
                  packet.TourneyIdx = selTourneyTeamIdx;
                  packet.RequestIdx = selRequestIdx;
                  packet.LevelDtl = selGameLevelDtlIDX;
                  SendPacket(Url, packet);
                  console.log("packet" + packet);

                  $("#Hidden_Data_" + strgang + "_" + strnum).val($("#Select_GroupIDX").val());
                  $("#DP_UserName_" + strgang + "_" + strnum).html($("#Select_STR1").val() + "<br>" + $("#Select_STR2").val());

                  if (strgametype == "B0040001") {
                      cli_leagueinsert(strgang, strnum);
                  }

                  $("#Select_STR1").val(""); 
                  $("#Select_STR2").val("");
                  $("#Select_GroupIDX").val("");
                  
                  return;

                }
                else{
                  return;
                }
              }
            }
          }
        }
        */

          selTourneyTeamIdx = $("#Hidden_Idx_" + strgang + "_" + strnum).val();
          selRequestIdx =$("#Select_GroupIDX").val();
          selGameLevelDtlIDX=  $("#GameLevelDtlIDX").val();

          if (selTourneyTeamIdx != "") {
            
            var packet = {}; 
            packet.CMD = CMD_TourneyUpdate;

            packet.TourneyIdx = selTourneyTeamIdx;
            packet.RequestIdx = selRequestIdx;
            packet.LevelDtl = selGameLevelDtlIDX;
            
            SendPacket(Url, packet);
            console.log("packet" + packet);

            $("#Hidden_Data_" + strgang + "_" + strnum).val($("#Select_GroupIDX").val());
            $("#DP_UserName_" + strgang + "_" + strnum).html($("#Select_STR1").val() + "<br>" + $("#Select_STR2").val());

            if (strgametype == "B0040001") {
                cli_leagueinsert(strgang, strnum);
            }
          }
          else
          {
            //일단 토너먼트만 수정기능 있으므로..
            if(strgametype == "B0040002"){
              alert("먼저 상단에 대진저장을 눌러주세요");
            }
          }

        $("#Select_STR1").val(""); 
        $("#Select_STR2").val("");
        $("#Select_GroupIDX").val("");
    }

    
    function cli_leagueinsert(strgang, strnum) {
        $("#Hidden_Data_" + strgang + "_" + strnum).val();
        $("#DP_R_UserName_" + strgang + "_" + strnum).html($("#Select_STR1").val() + "<br>" + $("#Select_STR2").val());
    }

   

    ////////////Ajax Receive////////////   
    function OnReceiveAjax(CMD, dataType, htmldata, jsondata) {
    switch(CMD) {
      case CMD_SELGAMETITLE:

      if(dataType == "html")
      {
        $("#divGameLevelMenu").html(htmldata); 
        sel_LevelDtlList();
      }
      break;
      case CMD_SELGAMELEVEL:
      if(dataType == "html")
      {
        $("#divGameLevelMenu").html(htmldata); 
        sel_LevelDtlList();
      }
      break;

      case CMD_LevelDtlList:
      {
          $("#DP_LevelDtlList").html(htmldata);
      }break;

      case CMD_Tourneylottery:
      {
          $("#realTimeContents").html(htmldata);
      }break;        

      case CMD_Leaguelottery:
      {
			
        	$("#realTimeContents").html(htmldata);
      }break;  

      case CMD_LeagueSave:
      {
				if(jsondata.result == "0"){
					alert("리그 대진표등록이 완료되었습니다.");
				}
      }break;			
			case CMD_TourneySave:
      {
				if(jsondata.result == "0"){
					alert("토너먼트 대진표등록이 완료되었습니다.");
          cli_RequestLevelDtl(jsondata.LevelDtl);
				}
      }break;	

      case CMD_TourneyUpdate :
      {
        if(jsondata.result == "0"){
          //cli_RequestLevelDtl(jsondata.LevelDtl);
				}
        else if(jsondata.result == "1"){
          alert("대진저장을 먼저 눌러주세요.")
				}
        else if(jsondata.result == "2") {
           alert("단식 및 복식 경기에는 선수가 3명 이상 있을 수 없습니다.")
        }

      }	break;				

			case CMD_RequestTeam:
			{
					$("#DP_RequestGroup").html(htmldata);				
			}break;		   
			case CMD_RequestPlayer:
			{
					$("#DP_RequestGroup").html(htmldata);				
			}break;		             
			case CMD_TourneyGang:
      {
          
				$("#TotRound").val(jsondata.TotRound);
        $("#GangCnt").val(jsondata.GangCnt);
        $("#GameType").val(jsondata.GameType);
        $("#GroupGameGb").val(jsondata.GroupGameGb);

        //리그
        if(jsondata.GameType == "B0040001"){
						prc_RequestTeam(jsondata.GameLevelDtlIDX, jsondata.GroupGameGb);
            prc_Leaguelottery(jsondata.GameLevelDtlIDX,jsondata.GameType, jsondata.GroupGameGb);  
        }
        //토너먼트
        else{	
						prc_RequestTeam(jsondata.GameLevelDtlIDX, jsondata.GroupGameGb);
            prc_Tourneylottery(jsondata.TotRound, jsondata.GameType, jsondata.GroupGameGb, jsondata.GameLevelDtlIDX); 
            
        }               
          
      }break;					
        
			default:      
    }
    };
    ////////////Ajax Receive////////////        


</script>
</head>

<form name="Tourney_frm" method="post">
 <input type="hidden" name="TotRound" id="TotRound" value="<%=TotRound%>" >
 <input type="hidden" name="GangCnt" id="GangCnt" value="<%=GangCnt%>" >
 <input type="hidden" name="GameType" id="GameType" value="<%=GameType%>" >
 <input type="hidden" name="GroupGameGb" id="GroupGameGb" value="<%=GroupGameGb%>" >
 
 <input type="hidden" name="GameLevelDtlIDX" id="GameLevelDtlIDX" >
 <input type="hidden" name="Select_STR1" id="Select_STR1" >
 <input type="hidden" name="Select_STR2" id="Select_STR2" >
 <input type="hidden" name="Select_GroupIDX" id="Select_GroupIDX" >


<!-- S: content Game_operation -->
<div class="Game_operation">
  <h2 class="t_title">경기추첨</h2>

  <!-- S: competition_select -->
  <div class="competition_select">
  <%
    Admin_Authority = crypt.DecryptStringENC(Request.Cookies(global_HP)("Authority"))
    Admin_UserID = crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))
        IF (Admin_Authority <> "O") Then
          Dim tblGameTitleCnt :tblGameTitleCnt = 0
          LSQL = " SELECT GameTitleIDX, GameTitleName"
          LSQL = LSQL & " FROM tblGameTitle "
          LSQL = LSQL & " WHERE DelYN = 'N' and GameTitleIDX = '" & reqGameTitleIdx & "'" 
          Set LRs = Dbcon.Execute(LSQL)

          IF Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
              tblGameTitleCnt = tblGameTitleCnt + 1
              tGameTitleName = LRs("GameTitleName")
              LRs.MoveNext()
            Loop
          End If   
          LRs.Close         

          IF cdbl(tblGameTitleCnt) = 0 Then
            LSQL = " SELECT Top 1 GameTitleIDX, GameTitleName"
            LSQL = LSQL & " FROM tblGameTitle "
            LSQL = LSQL & " WHERE DelYN = 'N' " 
            LSQL = LSQL & " Order By WriteDate desc " 

            Set LRs = Dbcon.Execute(LSQL)

            IF Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
                crypt_ReqGameTitleIdx =  crypt.EncryptStringENC(LRs("GameTitleIDX"))
                tGameTitleName = LRs("GameTitleName")
                LRs.MoveNext()
              Loop
            End If   
            LRs.Close         
          End IF
    %>
    <input type="text" name="strGameTtitle" id="strGameTtitle" placeholder="검색할 대회명을 입력해 주세요." value="<%=tGameTitleName%>" style="width:750px">
    <input type="hidden" name="selGameTitleIdx" id="selGameTitleIdx" value="<%=crypt_ReqGameTitleIdx%>">
    <% Else%>

    
      <select id="selGameTitleIdx" name="selGameTitleIdx"  onchange="OnGameTitleChanged(this.value)">
          <% 
              Dim GameTitleIdxCnt : GameTitleIdxCnt = 0
              LSQL = " SELECT a.GameTitleIDX, a.GameTitleName"
              LSQL = LSQL & " FROM tblGameTitle a "
              LSQL = LSQL & " INNER JOIN tblAdminGameTitle d on d.AdminID = '" & Admin_UserID &"' And a.GameTitleIDX = d.GameTitleIDX " 
              LSQL = LSQL & " WHERE a.DelYN = 'N'" 
              Set LRs = Dbcon.Execute(LSQL)

              IF Not (LRs.Eof Or LRs.Bof) Then
                  Do Until LRs.Eof
                    GameTitleIdxCnt = GameTitleIdxCnt  + 1
                    tGameTitleIdx = LRs("GameTitleIDX")
                    crypt_tGameTitleIdx = crypt.EncryptStringENC(tGameTitleIdx)
                    tGameTitleName = LRs("GameTitleName")
              
                    IF(Len(reqGameTitleIdx) = 0 ) Then
                      IF (GameTitleIdxCnt = 1) Then
                        reqGameTitleIdx = tGameTitleIdx
                        crypt_reqGameTitleIdx = crypt.EncryptStringENC(reqGameTitleIdx)
                      End IF
                    End IF

                    If CDBL(reqGameTitleIdx) = CDBL(tGameTitleIdx)Then 
                      %>
                        <option value="<%=crypt_tGameTitleIdx%>" selected> <%=tGameTitleName%></option>
                      <% Else %>
                        <option value="<%=crypt_tGameTitleIdx%>" > <%=tGameTitleName%></option>
                      <%
                    End IF
                  LRs.MoveNext()
                Loop
              End If   
              LRs.Close         
          %>
      </select>
    <% End IF %>
  </div>
  <!-- E: competition_select -->

  <!-- s: 연선 조 순위 결과 -->
  <div class="ranking_result" id="divGameLevelMenu">
    <%
      '예선 본선 값 설정
      LSQL = " SELECT PubCode, PubName  "
      LSQL = LSQL & " FROM  tblPubcode "
      LSQL = LSQL & " WHERE DelYN = 'N' and PPubCode ='B003'"
      LSQL = LSQL & " ORDER BY OrderBy "
      
      Set LRs = DBCon.Execute(LSQL)
      IF NOT (LRs.Eof Or LRs.Bof) Then
        arryGroupGameGb = LRs.getrows()
      End If
    %>
    <label>
      <% If IsArray(arryGroupGameGb) Then
          For ar = LBound(arryGroupGameGb, 2) To UBound(arryGroupGameGb, 2) 
            tGroupGameGb    = arryGroupGameGb(0, ar) 
            crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
            tGroupGameGbName  = arryGroupGameGb(1, ar) 
            if(tGroupGameGbName = "개인전") Then
      %>
            <input type="radio" name="radioGroupGameGb" value="<%=crypt_tGroupGameGb%>"  onClick='OnGameLevelChanged(<%=strjson%>)' <% if reqGroupGameGb = tGroupGameGb Then %> Checked <%End IF%> >
            <span>개인전</span>
      <%
            END IF
          Next
        End If      
      %>
    </label>

    <label>
         <% If IsArray(arryGroupGameGb) Then
          For ar = LBound(arryGroupGameGb, 2) To UBound(arryGroupGameGb, 2) 
            tGroupGameGb    = arryGroupGameGb(0, ar) 
            crypt_tGroupGameGb = crypt.EncryptStringENC(tGroupGameGb)
            tGroupGameGbName  = arryGroupGameGb(1, ar) 

            if(tGroupGameGbName = "단체전") Then
              %>
                <input type="radio" name="radioGroupGameGb" value="<%=crypt_tGroupGameGb%>" onClick='OnGameLevelChanged(<%=strjson%>)' <% if reqGroupGameGb = tGroupGameGb Then %> Checked <%End IF%> >
                <span>단체전</span>
              <%
            END IF
          Next
        End If      
      %>
    </label>

    <select id="selPlayTypeSex" name="selPlayTypeSex"  onChange='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::종목 선택::</option>
      <%
          LSQL = " SELECT  Sex, PlayType, KoreaBadminton.dbo.FN_NameSch(Sex,'PubCode') AS SexName, KoreaBadminton.dbo.FN_NameSch(PlayType,'PubCode') AS PlayTypeName"
          LSQL = LSQL & " FROM tblGameLevel"
          LSQL = LSQL & " WHERE DelYN = 'N'"
          LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "'"
          LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
          LSQL = LSQL & " GROUP BY Sex, PlayType"
          
          Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
              Do Until LRs.Eof
              tSex = LRs("Sex")
              crypt_tSex = crypt.EncryptStringENC(tSex)
              tSexName= LRs("SexName")
              tPlayType = LRs("PlayType")
              crypt_tPlayType= crypt.EncryptStringENC(tPlayType)
              tPlayTypeName= LRs("PlayTypeName")

              IF (reqSex = tSex) and  (reqPlayType = tPlayType) Then %>
                <option value="<%=crypt_tSex%>|<%=crypt_tPlayType%>" selected><%=tSexName & tPlayTypeName%></option>
              <%Else%>
                <option value="<%=crypt_tSex%>|<%=crypt_tPlayType%>" ><%=tSexName & tPlayTypeName%></option>
              <%End IF
              LRs.MoveNext()
              Loop
            End If   
          LRs.Close        
          %>
    </select>

    <% 'Response.Write " LSQL : " & LSQL & "<BR/>"  %>
    <select id="selTeamGb" name="selTeamGb"  onChange='OnGameLevelChanged(<%=strjson%>)'>
        <option value="">::부서 선택::</option>
      <%
        LSQL = " SELECT a.TeamGb, KoreaBadminton.dbo.FN_NameSch(a.TeamGb,'TeamGb') AS TeamGbNm"
        LSQL = LSQL & " FROM tblGameLevel a"
        LSQL = LSQL & " inner Join tblTeamGbInfo b on a.TeamGb = b.TeamGb and b.DelYN = 'N'"
        LSQL = LSQL & " WHERE a.DelYN = 'N'"
        LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "'"
        LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "'"
        LSQL = LSQL & " AND Sex = '" & ReqSex & "'"
        LSQL = LSQL & " AND PlayType = '" & ReqPlayType & "'"
        LSQL = LSQL & " GROUP BY a.TeamGb, Sex"
        Set LRs = Dbcon.Execute(LSQL)
          If Not (LRs.Eof Or LRs.Bof) Then
            Do Until LRs.Eof
            tTeamGb = LRs("TeamGb")
            crypt_tTeamGb = crypt.EncryptStringENC(tTeamGb)

            IF (reqTeamGb = tTeamGb) Then
            %>
            <option value="<%=crypt_tTeamGb%>" selected ><%=LRs("TeamGbNM")%></option>
            <% ELSE  %>
            <option value="<%=crypt_tTeamGb%>" <%If TeamGb =  crypt.EncryptStringENC(LRs("TeamGb")) Then%>selected<%End If %>><%=LRs("TeamGbNM")%></option>
            <% END IF
              LRs.MoveNext()
            Loop
          End If   
          LRs.Close         
        %>
        
    </select>
    <%'Response.Write "LSQL :" & LSQL & "<bR>"%>
    <select  id="selLevel" name="selLevel"  onChange='OnGameLevelChanged(<%=strjson%>)'>
      <option value="">::종목 선택::</option>
        <% 
            LSQL = " SELECT Level, KoreaBadminton.dbo.FN_NameSch(Level,'Level') AS LevelNm , KoreaBadminton.dbo.FN_NameSch(leveljooName, 'PubCode') AS LevelJooNameNm, LevelJooName,LevelJooNum "
            LSQL = LSQL & " FROM tblGameLevel "
            LSQL = LSQL & " WHERE DelYN = 'N' "
            LSQL = LSQL & " AND UseYN = 'Y' "
            LSQL = LSQL & " AND GameTitleIDX = '" & reqGameTitleIdx & "' "
            LSQL = LSQL & " AND GroupGameGb = '" & reqGroupGameGb & "' "
            LSQL = LSQL & " AND Sex = '" & ReqSex & "' "
            LSQL = LSQL & " AND PlayType = '" & ReqPlayType & "' "
            LSQL = LSQL & " AND TeamGb = '" & reqTeamGb & "' "
            LSQL = LSQL & " AND Level <> '' "
            LSQL = LSQL & " GROUP BY Level, leveljooName, LevelJooNum"
            
             Set LRs = Dbcon.Execute(LSQL)
                IF Not (LRs.Eof Or LRs.Bof) Then
                Do Until LRs.Eof
                  tLevel = LRs("Level")
                  crypt_tLevel = crypt.EncryptStringENC(tLevel)
                  tLevelNM = LRs("LevelNm")

                  tLevelJooName = LRs("LevelJooName")
                  crypt_tLevelJooName = crypt.EncryptStringENC(tLevelJooName)

                  tLevelJooNameNm= LRs("LevelJooNameNm")

                  IF(tLevelJooNameNm = "미선택") Then
                    tLevelJooNameNm = ""
                  End IF

                  tLevelJooNum = LRs("LevelJooNum") 
                  IF (reqLevel = tLevel) AND (reqLevelJooName = tLevelJooName) And (reqLevelJooNum = tLevelJooNum) Then%>      
                    <option value="<%=crypt_tLevel%>|<%=crypt_tLevelJooName%>|<%=tLevelJooNum%>" selected> <%=tLevelNM & " " & tLevelJooNameNm & " " & tLevelJooNum%>조</option>
                  <%ELSE%>
                    <option value="<%=crypt_tLevel%>|<%=crypt_tLevelJooName%>|<%=tLevelJooNum%>"> <%=tLevelNM & " " & tLevelJooNameNm & " " & tLevelJooNum%>조</option>
                  <%
                  END IF
                    LRs.MoveNext()
                  Loop
                End If   
              LRs.Close %>
    </select>
    <a href="javascript:cli_tourneysave();" class="red_btn">대진저장<i class="fas fa-angle-right"></i></a>
  </div>
	
  <!-- e: 연선 조 순위 결과 -->

</div>
<!-- E: content Game_operation -->



<!-- S: content-wrap operate lottery -->
<div class="content-wrap operate lottery">
  <!-- S: drowbody -->
  <div id="drowbody">
      <!-- S: ctr-box -->
      <div class="ctr-box">
        <table class="table-list">
          <thead>
            <tr><th>대진표</th></tr>
          </thead>
        </table>

        <!-- S: scroll-box -->
        <div class="scroll-box">
          <table class="table-list sel-match" id="DP_LevelDtlList">
            <tbody>
            </tbody>
          </table>
        </div>
        <!-- E: scroll-box -->
      </div>
      <!-- E: ctr-box -->


      <!-- S: ctr-box -->
      <div class="ctr-box">
        <table class="table-list player-order">
          <thead>
            <tr>
              <th>순번</th>
              <th>참가대기 선수(팀)</th>
            <!--<th colspan="2">2위</th>-->
            </tr>
          </thead>
        </table>

        <!-- S: scroll-box -->
        <div class="scroll-box">
          <table class="table-list player-order" id="gametable">
            <tbody id="DP_RequestGroup">
              <!--S: 출전대기선수-->
              <!--E: 출전대기선수-->
            </tbody>
          </table>
        </div>
        <!-- E: scroll-box -->
      </div>
      <!-- E: ctr-box -->

    <div class="tourney-container lottery-50" id="realTimeContents">

        <!-- S: table-fix-head -->
          <table class="tourney_admin table-fix-head 64" id="tourney_admin">
            <thead>
              <tr>
                <th><a href="" class="btn_a btn_func" data-collap="" id="DP_Gang">-강</a></th>

              </tr>
            </thead>
          </table>
        
          <table class="table-fix-body">
            <tbody>
              <tr>


                <td id="DP_Td_1">
                        <!--
                        <div style="border-left:1px solid #000;width:100%;border-right:1px solid #965F41;padding:0px;margin:0px;border-bottom:3px dotted #7F7F7F;">
                            <div style="flex:1;height:100%;background:#FFFFFF;"></div>
            

                            <div class="tourney_ctr_btn redy" style="flex:10;height:100%;background:#EEEEE;" onclick="cli_tourneyinsert()">
                              <ul class="team clearfix">
                                <li>  
                                  <input type="text" name="Hidden_Data" id="Hidden_Data_">
                                  <span class="player" name="DP_UserName" id="DP_UserName_" style="font-size:13px;">
                                  </span>
                                  <span class="player" style="font-size:15px;">
                                  </span>
                                </li>
                              </ul>
                              <div class="chk_win_lose">
                              </div>
                            </div>
            
                        </div>
                        -->
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

  </div>
  <!-- E: scroll_box -->
</div>


</form>

<script>
	var $windowHeight = $(window).height(); /* 윈도창 높이 */
	var $rightTable = $(".content-wrap.operate .ctr-box .scroll-box");
	var $Gameoperation =$(".Game_operation").outerHeight(true);
	var $tableHead = $(".content-wrap.operate .table-head").outerHeight(true);
	var $operateMatch = $(".operate .match_sel").outerHeight(true);
	$rightTable.css("height",$windowHeight - $Gameoperation - $tableHead - $operateMatch -70);
  
</script>

</body>
</html>

