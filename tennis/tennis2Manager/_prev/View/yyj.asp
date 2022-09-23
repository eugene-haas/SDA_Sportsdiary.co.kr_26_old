<!--#include virtual="/Manager/Library/config.asp"-->
<%
	'대회번호
	GameTitleIDX = "53" 'fInject(Request("GameTitleIDX"))

	'개인전단체전구분
  GameType = fInject(Request("GameType"))
  If GameType = "" Then 
		GameType = "sd040001" '개인전
		'GameType = "sd040002" '단체전
  End If  
	
	'소속구분
  TeamGb     = fInject(Request("TeamGb"))
	'남초부
	'TeamGb = "11001"
	'여초부
	'TeamGb = "11002"
	'남중부
	'TeamGb = "21001"
	'여중부
	'TeamGb = "21002"
	'남고부
	'TeamGb = "31001"
	'여고부
	TeamGb = "31002"
	'남대부
	'TeamGb = "41001"
	'여대부
	'TeamGb = "41002"
	'남일반
	'TeamGb = "51001"
	'여일반
	'TeamGb = "51002"


  '체급 
  Level      = fInject(Request("Level"))
	Level = "31002006"
  


	If GameType = "sd040001" Then 
  '======================================================================================================
  '개인전일경우 해당 체급 참가자 수 체크 후 해당 체급 경기의 강수 업데이트 처리==========================
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
      UpSQL = UpSQL&" AND Level='"&Level&"'" 
      UpSQL = UpSQL&" AND DelYN='N'"
      'Response.Write UpSQL
      
      Dbcon.Execute(UpSQL)

			'총참가자수
      PlayerCnt = CntRs("Cnt")
			'강수계산
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

	'Response.Write TotRound
	'Response.Write PlayerCnt
	
	'해당체급의 부전승 갯수 구하기
	NoMatchCnt = TotRound - PlayerCnt

	'부전승의 갯수가 0이상일경우 tblNoMatchInfo 테이블에서 부전승 칸의 값을 가지고 온다.
	If UnearnedCnt > 0 Then 
		USQL = "SELECT NoMatchNum FROM Sportsdiary.dbo.tblNoMatchInfo WHERE SportsGb='judo' AND TotRound='"&TotRound&"' AND NoMatchCnt='"&NoMatchCnt&"'"
		
		Set URs = Dbcon.Execute(USQL)

		If Not(URs.Eof Or URs.Bof) Then 
			NoMatchNum = URs("NoMatchNum")
		Else
			NoMatchNum = "0"
		End If 
	Else
		NoMatchNum = "0"
	End If 


	'한체급에 가장 많이 나온 학교 카운트
	CSQL = "SELECT TOP 1 COUNT(Team) AS Cnt "
	CSQL = CSQL&" FROM Sportsdiary.dbo.tblrplayermaster "
	CSQL = CSQL&" WHERE gametitleidx='"&GameTitleIDX&"'"
	CSQL = CSQL&" And DelYN='N'"
	CSQL = CSQL&" AND teamGb='"&TeamGb&"'"
	CSQL = CSQL&" AND Level='"&Level&"'"
	CSQL = CSQL&" Group by Team "
	CSQL = CSQL&" ORDER BY Cnt DESC"

	Set CRs = Dbcon.Execute(CSQL)

	'현재체급강수의 1라운드수
	ChkTot = TotRound/2

	Cnt = CRs("Cnt")


%>
<form name="frm" id="frm" method="post" >
<select name="Lottery_Type" id="Lottery_Type">
	<option value="무작위추첨">무작위추첨</option>
	<option value="1라운드제외">1라운드제외</option>
	<option value="동일학교라운드분배">동일학교라운드분배</option>
	<option value="시드추첨">시드추첨</option>
</select>
<input type="text" name="GameTitleIDX" id="GametitleIDX" value="<%=GameTitleIDX%>">
<input type="text" name="GameType" id="GameType" value="<%=GameType%>">
<input type="text" name="TeamGb" id="TeamGb" value="<%=TeamGb%>">
<input type="text" name="Level" id="Level" value="<%=Level%>">
<input type="text" name="TotRound" id="TotRound" value="<%=TotRound%>">
<input type="text" name="PlayerCnt" id="PlayerCnt" value="<%=PlayerCnt%>">
<input type="text" name="NoMatchCnt" id="NoMatchCnt" value="<%=NoMatchCnt%>">
<input type="text" name="NoMatchNum" id="NoMatchNum" value="<%=NoMatchNum%>">
<input type="text" name="ChkTot" id="ChkTot" value="<%=ChkTot%>">
<input type="text" name="Cnt" id="Cnt" value="<%=Cnt%>">

<input type="button" value="추첨" onclick="random_match();">
</form>
<script type="text/javascript">
function random_match(){
	var f = document.frm;
	if(f.TotRound.value > 0){

		if(f.Lottery_Type.value=="1라운드제외"){
			if(f.ChkTot.value < f.Cnt.value){
				if(confirm("라운드수 보다 참가자가 많은 학교가 있습니다.\n이경우 1라운드에 같은 학교가 추첨 될 수 있습니다.\n계속 진행하시겠습니까?")){
					f.action = "yyj_ok.asp"
					f.submit();									
				}
			}else{
				f.action = "yyj_ok.asp"
				f.submit();					
			}
		}else{
			f.action = "yyj_ok.asp"
			f.submit();		
		}
		
	}else{
		alert("참가자가 없습니다.");
	}
}
</script>
