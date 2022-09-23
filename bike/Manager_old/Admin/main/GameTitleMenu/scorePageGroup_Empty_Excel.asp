<!-- #include file="../../dev/dist/config.asp"-->
<!-- #include file="../../classes/JSON_2.0.4.asp" -->
<!-- #include file="../../classes/JSON_UTIL_0.1.1.asp" -->
<!-- #include file="../../classes/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
	Dim GameLevelDtlIDX	: GameLevelDtlIDX 		= fInject(Request("GameLevelDtlIDX"))
	Dim TeamGameNum		    : TeamGameNum 		    = fInject(Request("TeamGameNum"))	
	Dim GameNum		: GameNum 		= fInject(Request("GameNum"))
  Dim GroupGameGb		: GroupGameGb 		= fInject(Request("GroupGameGb"))
	Dim TempNum	: TempNum		= fInject(Request("TempNum"))
	Dim IsPrint	: IsPrint		= fInject(Request("IsPrint"))


  Dim DEC_GameLevelDtlIDX	: DEC_GameLevelDtlIDX 		= crypt.DecryptStringENC(GameLevelDtlIDX)
  Dim DEC_TeamGameNum		    : DEC_TeamGameNum 		    = crypt.DecryptStringENC(TeamGameNum)
  Dim DEC_GameNum		: DEC_GameNum 		= crypt.DecryptStringENC(GameNum)
  Dim DEC_GroupGameGb	: DEC_GroupGameGb     = crypt.DecryptStringENC(GroupGameGb)
  Dim DEC_TempNum	: DEC_TempNum		= crypt.DecryptStringENC(TempNum)
	Dim DEC_IsPrint	: DEC_IsPrint		= IsPrint



  Function SetJumsu(strGameLevelDtlidx, strTeamGameNum, strGameNum, strTourneyGroupIDX)

      MSQL = " SELECT ISNULL(SUM(SetPoint1),0) AS SetPoint1,"
      MSQL = MSQL & " ISNULL(SUM(SetPoint2),0) AS SetPoint2,"
      MSQL = MSQL & " ISNULL(SUM(SetPoint3),0) AS SetPoint3,"
      MSQL = MSQL & " ISNULL(SUM(SetPoint4),0) AS SetPoint4,"
      MSQL = MSQL & " ISNULL(SUM(SetPoint5),0) AS SetPoint5,"
      
      If SetNum = "1" Then
          MSQL = MSQL & " ISNULL(SUM(SetPoint1),0) AS NowSetPoint"
      ElseIf SetNum = "2" Then
          MSQL = MSQL & " ISNULL(SUM(SetPoint2),0) AS NowSetPoint"
      ElseIf SetNum = "3" Then
          MSQL = MSQL & " ISNULL(SUM(SetPoint3),0) AS NowSetPoint"
      ElseIf SetNum = "4" Then
          MSQL = MSQL & " ISNULL(SUM(SetPoint4),0) AS NowSetPoint"
      ElseIf SetNum = "5" Then
          MSQL = MSQL & " ISNULL(SUM(SetPoint5),0) AS NowSetPoint"
      Else
          MSQL = MSQL & " '-' AS NowSetPoint"
      End If

      MSQL = MSQL & " FROM"
      MSQL = MSQL & "  ("
      MSQL = MSQL & "  SELECT CASE WHEN SetNum = '1' THEN Jumsu ELSE 0 END AS SetPoint1,"
      MSQL = MSQL & "  CASE WHEN SetNum = '2' THEN Jumsu ELSE 0 END AS SetPoint2,"
      MSQL = MSQL & "  CASE WHEN SetNum = '3' THEN Jumsu ELSE 0 END AS SetPoint3,"
      MSQL = MSQL & "  CASE WHEN SetNum = '4' THEN Jumsu ELSE 0 END AS SetPoint4,"
      MSQL = MSQL & "  CASE WHEN SetNum = '5' THEN Jumsu ELSE 0 END AS SetPoint5"
      MSQL = MSQL & "  FROM KoreaBadminton.dbo.tblTourney A"
      MSQL = MSQL & "  LEFT JOIN KoreaBadminton.dbo.tblGameResultDtl B ON B.TourneyGroupIDX = A.TourneyGroupIDX AND B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
      MSQL = MSQL & "  WHERE A.DelYN = 'N'"
      MSQL = MSQL & "  AND B.DelYN = 'N'"
      MSQL = MSQL & "  AND B.GameLevelDtlidx = '" & strGameLevelDtlidx & "'"
      MSQL = MSQL & "  AND B.TeamGameNum = '" & strTeamGameNum & "'"
      MSQL = MSQL & "  AND B.GameNum = '" & strGameNum & "'"
      MSQL = MSQL & "  AND B.TourneyGroupIDX = '" & strTourneyGroupIDX & "'"

      MSQL = MSQL & "  ) AS A"

      Set MRs = Dbcon.Execute(MSQL)

      Set fn_oJSONoutput_ct = jsArray()
      Set fn_oJSONoutput_ct = jsObject()

      If Not (MRs.Eof Or MRs.Bof) Then

          Do Until MRs.Eof

            fn_oJSONoutput_ct("SetPoint1") = MRs("SetPoint1")
            fn_oJSONoutput_ct("SetPoint2") = MRs("SetPoint2")
            fn_oJSONoutput_ct("SetPoint3") = MRs("SetPoint3")
            fn_oJSONoutput_ct("SetPoint4") = MRs("SetPoint4")
            fn_oJSONoutput_ct("SetPoint5") = MRs("SetPoint5")
            fn_oJSONoutput_ct("NowSetPoint") = MRs("NowSetPoint")
                
            MRs.MoveNext
          Loop

      Else
        fn_oJSONoutput_ct("SetPoint1") = "0"
        fn_oJSONoutput_ct("SetPoint2") = "0"
        fn_oJSONoutput_ct("SetPoint3") = "0"
        fn_oJSONoutput_ct("SetPoint4") = "0"
        fn_oJSONoutput_ct("SetPoint5") = "0" 
        fn_oJSONoutput_ct("NowSetPoint") = "0"

      End If

      SetJumsu =  toJSON(fn_oJSONoutput_ct)

      MRs.Close

  End Function  	

	titleSQL = "(select top 1 gametitlename from tblGameTitle where gametitleidx = C.GameTitleIDX ) as gametitleName "

  LSQL = " SELECT A.Team AS LTeam, A.TeamDtl AS LTeamDtl, B.Team AS RTeam, B.TeamDtl AS RTeamDtl,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.Team,'Team') AS LTeamNM, "
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(B.Team,'Team') AS RTeamNM,"

  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.Sex, 'PubCode') AS SexName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.PlayType, 'PubCode') AS PlayTypeName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.TeamGb, 'TeamGb') AS TeamGbName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.Level, 'Level') AS LevelName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.LevelJooName,'PubCode') AS LevelJooName, D.LevelJooNum, C.LevelJooNum AS LevelJooNumDtl, C.LevelDtlName, C.GameLevelDtlIDX, "
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(C.GameType,'PubCode') AS GameTypeName, "
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(C.PlayLevelType,'PubCode') AS PlayLevelTypeName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(D.GroupGameGb,'PubCode') AS GroupGameGbName,"
  LSQL = LSQL & " KoreaBadminton.dbo.FN_NameSch(A.StadiumIDX,'StadiumIDX') AS StadiumName,"
  LSQL = LSQL & " C.PlayLevelType,"
  LSQL = LSQL & " D.GameType, C.GameType AS GameTypeDtl, A.StadiumNum, C.TotRound, A.[ROUND] AS GameRound,"
  LSQL = LSQL & " E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultNM, E.Jumsu AS LJumsu, E.TotalPoint AS LTotalPoint,"
  LSQL = LSQL & " F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultNM, F.Jumsu AS RJumsu, F.TotalPoint AS RTotalPoint,"
	LSQL = LSQL & titleSQL
  LSQL = LSQL & " FROM tblTourneyTeam A"
  LSQL = LSQL & " INNER JOIN tblTourneyTeam B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum"
  LSQL = LSQL & " INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
  LSQL = LSQL & " INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
  LSQL = LSQL & " LEFT JOIN ("
  LSQL = LSQL & "   SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu, TotalPoint"
  LSQL = LSQL & "   FROM KoreaBadminton.dbo.tblGroupGameResult"
  LSQL = LSQL & "   WHERE DelYN = 'N'"
  LSQL = LSQL & "   ) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.Team + E.TeamDtl = A.Team + A.TeamDtl"
  LSQL = LSQL & " LEFT JOIN ("
  LSQL = LSQL & "   SELECT GameLevelDtlidx, TeamGameNum, GameNum, Team, TeamDtl, Result, Jumsu, TotalPoint"
  LSQL = LSQL & "   FROM KoreaBadminton.dbo.tblGroupGameResult"
  LSQL = LSQL & "   WHERE DelYN = 'N'"
  LSQL = LSQL & "   ) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = A.TeamGameNum AND F.Team + F.TeamDtl = B.Team + B.TeamDtl "
  LSQL = LSQL & " WHERE A.DelYN = 'N'"
  LSQL = LSQL & " AND B.DelYN = 'N'"
  LSQL = LSQL & " AND A.ORDERBY < B.ORDERBY"
  LSQL = LSQL & " AND A.GameLevelDtlIDX  = '" & DEC_GameLevelDtlIDX & "'"
  LSQL = LSQL & " AND A.TeamGameNum = '" & DEC_TeamGameNum & "'"
 
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
    LTeam = LRs("LTeam")
    LTeamDtl = LRs("LTeamDtl")
    LTeamNM = LRs("LTeamNM")
    LResultNM = LRs("LResultNM")
    LTotalPoint = LRs("LTotalPoint")
    LJumsu = LRs("LJumsu")

    RTeam = LRs("RTeam")
    RTeamDtl = LRs("RTeamDtl")
    RTeamNM = LRs("RTeamNM")
    RResultNM = LRs("RResultNM")
    RTotalPoint = LRs("RTotalPoint")  
    RJumsu = LRs("RJumsu")

    SexName = LRs("SexName")
    PlayTypeName = LRs("PlayTypeName")
    TeamGbName = LRs("TeamGbName")
    LevelName = LRs("LevelName")
    LevelJooName = LRs("LevelJooName")
    LevelJooNum = LRs("LevelJooNum")
    LevelJooNumDtl = LRs("LevelJooNumDtl")
    PlayLevelType = LRs("PlayLevelType")
    GroupGameGbName = LRs("GroupGameGbName")
    StadiumNum = LRs("StadiumNum")
    TotRound = LRs("TotRound")
    GameRound = crypt.EncryptStringENC(LRs("GameRound"))

    StadiumName = LRs("StadiumName")

		GameTitleName = LRs("GameTitleName")
  End If

  LRs.Close

	'경기결과페이지에서 오면 경기결과 찍기, 그외 안찍기
	If DEC_IsPrint = "0" Then
		LResultNM = ""
		RResultNM = ""
	End If


  '예선일떄..
  If PlayLevelType = "B0100001" Then
      StrLevelName = SexName & " " & PlayTypeName & " " & TeamGbName & " " & LevelName & " " & LevelJooName & " " & LevelJooNum & " " & LevelJooNumDtl & "조" 
  '본선일때
  Else
      StrLevelName = SexName & " " & PlayTypeName & " " & TeamGbName & " " & LevelName & " " & LevelJooName & " " & LevelJooNum
  End If

  strjson = JSON.stringify(oJSONoutput)
  'Response.Write strjson
  'Response.write "`##`"
  'Response.Write "LSQL : " & LSQL & "<BR/>"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<!-- Generated by PHPExcel - http://www.phpexcel.net -->
<html style="font-family: Calibri, Arial, Helvetica, sans-serif;font-size: 11pt;background-color: white;">
  <head>
	  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	  <meta name="author" content="prettybora">
	  <meta name="company" content="LG">
		<script>
			/*
			var initBody;

			function beforePrint(){
				boxes = document.body.innerHTML;
				document.body.innerHTML = box.innerHTML;
			}

			function afterPrint(){
				document.body.innHTML = boxes;
			}



			window.onbeforeprint = beforePrint;
			window.onafterPrint = afterPrint;
			*/

			function onPrintClick(){
				window.print();
			}			
		</script>
  </head>

  <body style="left-margin: 0.2362204724409449in;right-margin: 0.2362204724409449in;top-margin: 0.7480314960629921in;bottom-margin: 0.7480314960629921in;">
<style>
@page { left-margin: 0.2362204724409449in; right-margin: 0.2362204724409449in; top-margin: 0.7480314960629921in; bottom-margin: 0.7480314960629921in; }
body { left-margin: 0.2362204724409449in; right-margin: 0.2362204724409449in; top-margin: 0.7480314960629921in; bottom-margin: 0.7480314960629921in; }
@media print { #noprint { display:none !important; }}
</style>
<script>
    var initBody;
    function beforePrint()
    {
        initBody = document.body.innerHTML;
        document.body.innerHTML = div_page.innerHTML;
    }
    function afterPrint()
    {
        document.body.innerHTML = initBody;
    }
    function pageprint()
    {
        window.onbeforeprint = beforePrint;
        window.onafterprint = afterPrint;
        window.print();
    }
</script>

	<div class="noprint">
		<a href="#" onclick="pageprint()"> 인쇄하기</a>
	</div>
	<div id="div_page">
	<table id="DP_PrintArea" border="0" cellpadding="0" cellspacing="0" id="sheet0" class="sheet0" style="width: 1200px;border-collapse: collapse;page-break-after: always;">
		<col class="col0" style="width: 16.94444425pt;">
		</col><col class="col1" style="width: 16.94444425pt;">
		</col><col class="col2" style="width: 62pt;">
		</col><col class="col3" style="width: 62pt;">
		</col><col class="col4" style="width: 62pt;">
		</col><col class="col5" style="width: 62pt;">
		</col><col class="col6" style="width: 62pt;">
		</col><col class="col7" style="width: 62pt;">
		</col><col class="col8" style="width: 62pt;">
		</col><col class="col9" style="width: 62pt;">
		</col><col class="col10" style="width: 62pt;">
		</col><col class="col11" style="width: 62pt;">
		</col><col class="col12" style="width: 62pt;">
		</col><col class="col13" style="width: 62pt;">
		</col><col class="col14" style="width: 62pt;">
		</col><col class="col15" style="width: 62pt;">
		</col><col class="col16" style="width: 62pt;">
		</col><col class="col17" style="width: 62pt;">
		</col><tbody>
		  <tr class="row0" style="height: 21.2pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1 style24 null" style="vertical-align: middle;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #FF0000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;"></td>
			<td class="column2">&nbsp;</td>
			<td class="column3">&nbsp;</td>
			<td class="column4">&nbsp;</td>
			<td class="column5">&nbsp;</td>
			<td class="column6">&nbsp;</td>
			<td class="column7">&nbsp;</td>
			<td class="column8">&nbsp;</td>
			<td class="column9">&nbsp;</td>
			<td class="column10">&nbsp;</td>
			<td class="column11">&nbsp;</td>
			<td class="column12">&nbsp;</td>
			<td class="column13">&nbsp;</td>
			<td class="column14">&nbsp;</td>
			<td class="column15">&nbsp;</td>
			<td class="column16">&nbsp;</td>
			<td class="column17">&nbsp;</td>
		  </tr>
		  <tr class="row1" style="height: 21.2pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1 style37 null" style="vertical-align: middle;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #3F3F3F;font-family: '맑은 고딕';font-size: 16pt;background-color: white;"></td>
			<td class="column2 style42 s style42" colspan="9" style="text-align: left;vertical-align: middle;padding-left: 0px;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #3F3F3F;font-family: '맑은 고딕';font-size: 13pt;background-color: white;">
				<%=gametitleName%>
				<%=StrLevelName%>
				<%
				If PlayLevelType = "B0100001" Then
					Response.Write " 예선" & LevelDtlJooNum & "조"
				ElseIf PlayLevelType = "B0100002" Then
					Response.Write " 본선"
				Else
					Response.Write "-"
				End If        
				%> 				
			</td>
			<td class="column11">&nbsp;</td>
			<td class="column12 style40 s" style="text-align: center;vertical-align: middle;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #3F3F3F;font-family: '맑은 고딕';font-size: 16pt;background-color: white;"><!--No.<%=DEC_tTempNum%>--></td>
			<td class="column13">&nbsp;</td>
			<td class="column14 style37 s" style="text-align: left;vertical-align: middle;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #3F3F3F;font-family: '맑은 고딕';font-size: 16pt;background-color: white;"><%=StadiumNum%>코트</td>
			<td class="column15">&nbsp;</td>
			<td class="column16 style37 s" style="text-align: left;vertical-align: middle;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #3F3F3F;font-family: '맑은 고딕';font-size: 16pt;background-color: white;"><%=DEC_TeamGameNum%>경기</td>
			<td class="column17">&nbsp;</td>
		  </tr>
		  <tr class="row2" style="height: 21.2pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1 style37 null" style="vertical-align: middle;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #3F3F3F;font-family: '맑은 고딕';font-size: 16pt;background-color: white;"></td>
			<td class="column2">&nbsp;</td>
			<td class="column3">&nbsp;</td>
			<td class="column4">&nbsp;</td>
			<td class="column5">&nbsp;</td>
			<td class="column6">&nbsp;</td>
			<td class="column7">&nbsp;</td>
			<td class="column8">&nbsp;</td>
			<td class="column9">&nbsp;</td>
			<td class="column10">&nbsp;</td>
			<td class="column11">&nbsp;</td>
			<td class="column12">&nbsp;</td>
			<td class="column13">&nbsp;</td>
			<td class="column14">&nbsp;</td>
			<td class="column15">&nbsp;</td>
			<td class="column16">&nbsp;</td>
			<td class="column17">&nbsp;</td>
		  </tr>
		  <tr class="row3" style="height: 21.2pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1 style30 null" style="vertical-align: middle;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #903C39;font-family: '맑은 고딕';font-size: 12pt;background-color: white;"></td>
			<td class="column2">&nbsp;</td>
			<td class="column3">&nbsp;</td>
			<td class="column4">&nbsp;</td>
			<td class="column5">&nbsp;</td>
			<td class="column6">&nbsp;</td>
			<td class="column7">&nbsp;</td>
			<td class="column8">&nbsp;</td>
			<td class="column9">&nbsp;</td>
			<td class="column10">&nbsp;</td>
			<td class="column11">&nbsp;</td>
			<td class="column12">&nbsp;</td>
			<td class="column13">&nbsp;</td>
			<td class="column14">&nbsp;</td>
			<td class="column15">&nbsp;</td>
			<td class="column16">&nbsp;</td>
			<td class="column17">&nbsp;</td>
		  </tr>
		  <tr class="row4" style="height: 30pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1">&nbsp;</td>
			<td class="column2 style61 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #FFFFFF;font-family: '맑은 고딕';font-size: 12pt;background-color: #27405E;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;border-right: 2px solid #000000 !important;">소속</td>
			<td class="column3 style50 s style51" colspan="5" style="text-align: center;vertical-align: middle;border-left: none #000000;border-right: 2px solid #27405E !important;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 12pt;background-color: white;border-bottom: 2px solid #27405E !important;border-top: 2px solid #27405E !important;">
				<%=LTeamNM%>
				<%
					If LTeamDtl <> "0" Then
						Response.Write LTeamDtl
					End If
				%>
			</td>
			<td class="column8 style25 null" style="vertical-align: middle;text-align: center;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 12pt;background-color: white;"></td>
			<td class="column9">&nbsp;</td>
			<td class="column10">&nbsp;</td>
			<td class="column11 style49 s style50" colspan="5" style="text-align: center;vertical-align: middle;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 12pt;background-color: white;border-left: 2px solid #27405E !important;border-bottom: 2px solid #27405E !important;border-top: 2px solid #27405E !important;">
				<%=RTeamNM%>
				<%
					If RTeamDtl <> "0" Then
						Response.Write RTeamDtl
					End If
				%>			
			</td>
			<td class="column16 style61 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #FFFFFF;font-family: '맑은 고딕';font-size: 12pt;background-color: #27405E;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;border-right: 2px solid #000000 !important;">소속</td>
			<td class="column17">&nbsp;</td>
		  </tr>
		  <tr class="row5" style="height: 9.949999999999999pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1">&nbsp;</td>
			<td class="column2">&nbsp;</td>
			<td class="column3">&nbsp;</td>
			<td class="column4">&nbsp;</td>
			<td class="column5">&nbsp;</td>
			<td class="column6">&nbsp;</td>
			<td class="column7">&nbsp;</td>
			<td class="column8">&nbsp;</td>
			<td class="column9">&nbsp;</td>
			<td class="column10">&nbsp;</td>
			<td class="column11">&nbsp;</td>
			<td class="column12">&nbsp;</td>
			<td class="column13">&nbsp;</td>
			<td class="column14">&nbsp;</td>
			<td class="column15">&nbsp;</td>
			<td class="column16">&nbsp;</td>
			<td class="column17">&nbsp;</td>
		  </tr>
		  <tr class="row6" style="height: 21.2pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1 style59 s style60" rowspan="2" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 2px solid #000000 !important;border-right: 1px solid #000000 !important;">No</td>
			<td class="column2 style45 s style47" colspan="2" rowspan="2" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;">선수명</td>
			<td class="column4 style54 s style56" colspan="5" style="text-align: center;vertical-align: middle;border-right: 2px solid #000000 !important;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-left: 1px solid #000000 !important;border-bottom: 1px solid #000000 !important;border-top: 2px solid #000000 !important;">결과</td>
			<td class="column9 style52 s style53" rowspan="2" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 2px solid #000000 !important;border-right: 2px solid #000000 !important;">종목</td>
			<td class="column10 style57 s style58" colspan="5" style="text-align: center;vertical-align: middle;border-right: 1px solid #000000 !important;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-left: 2px solid #000000 !important;border-bottom: 1px solid #000000 !important;border-top: 2px solid #000000 !important;">결과</td>
			<td class="column15 style45 s style48" colspan="2" rowspan="2" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 2px solid #000000 !important;">선수명</td>
			<td class="column17">&nbsp;</td>
		  </tr>
		  <tr class="row7" style="height: 21.2pt;">
			<td class="column0">&nbsp;</td>
			<td class="column4 style16 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;">3게임</td>
			<td class="column5 style16 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;">2게임</td>
			<td class="column6 style16 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;">1게임</td>
			<td class="column7 style17 s" style="text-align: center;vertical-align: middle;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;">승/패</td>
			<td class="column8 style17 s" style="text-align: center;vertical-align: middle;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;">승자서명</td>
			<td class="column10 style26 s" style="text-align: center;vertical-align: middle;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;">승자서명</td>
			<td class="column11 style16 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;">승/패</td>
			<td class="column12 style39 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;">1게임</td>
			<td class="column13 style39 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;">2게임</td>
			<td class="column14 style39 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;">3게임</td>
			<td class="column17">&nbsp;</td>
		  </tr>

      <%
        LSQL = " SELECT CCC.GameTitleIDX, CCC.GameLevelDtlIDX, CCC.TeamGameNum, CCC.GameNum, CCC.TeamGb, CCC.Level, CCC.LTourneyGroupIDX , CCC.RTourneyGroupIDX,"
        LSQL = LSQL & " 	CCC.TeamGbNM, CCC.LevelNM, CCC.GameTypeNM,"
        LSQL = LSQL & " 	CCC.LResult, CCC.LResultType, CCC.LResultNM, ISNULL(CCC.LJumsu,0) AS LJumsu,"
        LSQL = LSQL & " 	CCC.RResult, CCC.RResultType, CCC.RResultNM, ISNULL(CCC.RJumsu,0) AS RJumsu,"
        LSQL = LSQL & " 	CCC.GameStatus, CCC.[ROUND], CCC.Sex,"
        LSQL = LSQL & " 	CCC.TempNum, CCC.TurnNum, CCC.GroupGameGb,"
        LSQL = LSQL & " 	CCC.LPlayer1, CCC.LPlayer2, CCC.Rplayer1, CCC.Rplayer2, CCC.LTeam1, CCC.LTeam2, CCC.RTeam1, CCC.RTeam2, CCC.StadiumNum, CCC.StadiumIDX,"
        LSQL = LSQL & " 	CCC.GameDay, CCC.LevelJooNum, CCC.LevelDtlJooNum, CCC.LevelDtlName, dbo.FN_NameSch(CCC.StadiumIDX, 'StadiumIDX') AS StadiumName, PlayLevelType, LevelJooName,"
        LSQL = LSQL & " 	CCC.Win_TourneyGroupIDX, CCC.LGroupJumsu, CCC.RGroupJumsu, CCC.LDtlJumsu, CCC.RDtlJumsu, CCC.SignData, dbo.FN_GameType(CCC.LTourneyGroupIDX,CCC.RTourneyGroupIDX) AS RowGameType"			
        LSQL = LSQL & " FROM "
        LSQL = LSQL & " ("
        LSQL = LSQL & " 	SELECT "
        LSQL = LSQL & " 	BBB.GameTitleIDX, BBB.GameLevelDtlIDX, BBB.TeamGameNum, BBB.GameNum, BBB.TeamGb, BBB.Level, BBB.LTourneyGroupIDX , BBB.RTourneyGroupIDX,"
        LSQL = LSQL & " 	BBB.TeamGbNM, BBB.LevelNM, BBB.GameTypeNM,"
        LSQL = LSQL & " 	BBB.LResult, BBB.LResultType, BBB.LResultNM, BBB.LJumsu,"
        LSQL = LSQL & " 	BBB.RResult, BBB.RResultType, BBB.RResultNM, BBB.RJumsu,"			
        LSQL = LSQL & " 	BBB.GameStatus, BBB.[ROUND], BBB.Sex,"
        LSQL = LSQL & " 	ROW_NUMBER() OVER(ORDER BY CONVERT(BIGINT,ISNULL(BBB.TurnNum,'0')), CONVERT(BIGINT,ISNULL(BBB.TeamGameNum,'0')) ASC, CONVERT(BIGINT,ISNULL(BBB.GameNum,'0'))) AS TempNum, TurnNum, PlayLevelType, GroupGameGb, StadiumNum, StadiumIDX,"
        LSQL = LSQL & " 	GameDay, LevelJooNum, LevelDtlJooNum, LevelDtlName, LevelJooName,"
        LSQL = LSQL & " 	LPlayer1, LPlayer2, Rplayer1, Rplayer2, LTeam1, LTeam2, RTeam1, RTeam2,"
        LSQL = LSQL & " 	BBB.Win_TourneyGroupIDX, BBB.LGroupJumsu, BBB.RGroupJumsu, BBB.LDtlJumsu, BBB.RDtlJumsu, BBB.SignData"			
        LSQL = LSQL & " 	FROM"
        LSQL = LSQL & " 	("
        LSQL = LSQL & " 		SELECT AA.GameTitleIDX, AA.GameLevelDtlIDX, AA.TeamGameNum, AA.GameNum, AA.TeamGb, AA.Level, AA.LTourneyGroupIDX , AA.RTourneyGroupIDX,"
        LSQL = LSQL & " 		AA.TeamGbNM, AA.LevelNM, AA.GameTypeNM,"
        LSQL = LSQL & " 		AA.LResult, AA.LResultType, AA.LResultNM, AA.LJumsu,"
        LSQL = LSQL & " 		AA.RResult, AA.RResultType, AA.RResultNM, AA.RJumsu,"
        LSQL = LSQL & " 		AA.GameStatus, AA.[ROUND], AA.Sex, AA.TurnNum, AA.PlayLevelType, AA.GroupGameGb, AA.StadiumNum, AA.StadiumIDX, AA.GameDay, AA.LevelJooNum, AA.LevelDtlJooNum, AA.LevelDtlName, AA.LevelJooName, AA.SignData,"
        LSQL = LSQL & " 		AA.TourneyGroupIDX AS Win_TourneyGroupIDX, AA.LGroupJumsu, AA.RGroupJumsu, AA.LDtlJumsu, AA.RDtlJumsu,"
        LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN LEFT(LPlayers,CHARINDEX('|',LPlayers)-1) ELSE LPlayers END  AS LPlayer1, "
        LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LPlayers) > 0 THEN RIGHT(LPlayers,CHARINDEX('|',REVERSE(LPlayers))-1) ELSE '' END  AS LPlayer2, "
        LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN LEFT(RPlayers,CHARINDEX('|',RPlayers)-1) ELSE RPlayers END AS RPlayer1, "
        LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RPlayers) > 0 THEN RIGHT(RPlayers,CHARINDEX('|',REVERSE(RPlayers))-1) ELSE '' END  AS RPlayer2, "
        LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN LEFT(LTeams,CHARINDEX('|',LTeams)-1) ELSE LTeams END AS LTeam1, "
        LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',LTeams) > 0 THEN RIGHT(LTeams,CHARINDEX('|',REVERSE(LTeams))-1) ELSE '' END AS LTeam2, "
        LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN LEFT(RTeams,CHARINDEX('|',RTeams)-1) ELSE RTeams END AS RTeam1, "
        LSQL = LSQL & " 		CASE WHEN CHARINDEX('|',RTeams) > 0 THEN RIGHT(RTeams,CHARINDEX('|',REVERSE(RTeams))-1) ELSE '' END AS RTeam2"
        LSQL = LSQL & " 		FROM"
        LSQL = LSQL & " 		("
        LSQL = LSQL & " 		    SELECT A.GameTitleIDX, A.GameLevelDtlIDX, A.TeamGameNum, A.GameNum, A.TeamGb, A.Level, CONVERT(VARCHAR(10),A.TourneyGroupIDX) AS LTourneyGroupIDX, CONVERT(VARCHAR(10),B.TourneyGroupIDX) AS RTourneyGroupIDX, "
        LSQL = LSQL & " 		    KoreaBadminton.dbo.FN_NameSch(A.TeamGb,'TeamGb') AS TeamGbNM, KoreaBadminton.dbo.FN_NameSch(A.Level,'Level') AS LevelNM,"
        LSQL = LSQL & " 		    KoreaBadminton.dbo.FN_NameSch(D.PlayType,'PubCode') AS GameTypeNM,"
        LSQL = LSQL & " 		    E.Result AS LResult, dbo.FN_NameSch(E.Result, 'PubType') AS LResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS LResultNM, E.Jumsu AS LJumsu,"
        LSQL = LSQL & " 		    F.Result AS RResult, dbo.FN_NameSch(F.Result, 'PubType') AS RResultType, dbo.FN_NameSch(F.Result, 'PubCode') AS RResultNM, F.Jumsu AS RJumsu,"
        LSQL = LSQL & " 		    E.Result, dbo.FN_NameSch(E.Result, 'PubType') AS ResultType, dbo.FN_NameSch(E.Result, 'PubCode') AS ResultNM, E.Jumsu,"
        LSQL = LSQL & " 		    KoreaBadminton.dbo.FN_GameStatus(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS GameStatus, A.[ROUND], C.PlayLevelType, A.ORDERBY, dbo.FN_NameSch(D.Sex, 'PubCode') AS Sex,"
        LSQL = LSQL & " 		    A.TurnNum, D.GroupGameGb, A.StadiumNum, A.StadiumIDX, A.GameDay, D.LevelJooNum, C.LevelJooNum AS LevelDtlJooNum, C.LevelDtlName, dbo.FN_NameSch(D.LevelJooName,'Pubcode') AS LevelJooName, G.SignData,"
        LSQL = LSQL & " 				KoreaBadminton.dbo.FN_WinGroupIDX(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum) AS TourneyGroupIDX,"
        LSQL = LSQL & " 				KoreaBadminton.dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, A.TourneyGroupIDX) AS LGroupJumsu, "
        LSQL = LSQL & " 				KoreaBadminton.dbo.FN_GroupJumsu(A.GameLevelDtlidx, A.TeamGameNum, A.GameNum, B.TourneyGroupIDX) AS RGroupJumsu, "
        LSQL = LSQL & " 				KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, A.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS LDtlJumsu, "
        LSQL = LSQL & " 				KoreaBadminton.dbo.FN_1GameWinPoint(A.GameLevelDtlidx, B.TourneyGroupIDX, A.TeamGameNum, A.GameNum) AS RDtlJumsu "
        
        LSQL = LSQL & " 		    ,STUFF(("
        LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
        LSQL = LSQL & " 		    			SELECT  '|'   + UserName "
        LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
        LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "

        LSQL = LSQL & " 						AND GameLevelDtlidx = AAA.GameLevelDtlidx"
        LSQL = LSQL & " 						AND DelYN = 'N'"

        LSQL = LSQL & " 		    			FOR XML PATH('')  "
        LSQL = LSQL & " 		    			)  "
        LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
        LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
        LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"

        LSQL = LSQL & " 					AND DelYN = 'N'"

        LSQL = LSQL & " 		    		),1,1,'') AS LPlayers"
        LSQL = LSQL & " 		    ,STUFF(("
        LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
        LSQL = LSQL & " 		    			SELECT  '|'   + UserName "
        LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
        LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "

        LSQL = LSQL & " 						AND GameLevelDtlidx = AAA.GameLevelDtlidx"
        LSQL = LSQL & " 						AND DelYN = 'N'"

        LSQL = LSQL & " 		    			FOR XML PATH('')  "
        LSQL = LSQL & " 		    			)  "
        LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
        LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
        LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"

        LSQL = LSQL & " 					AND DelYN = 'N'"

        LSQL = LSQL & " 		    		),1,1,'') AS RPlayers"
        LSQL = LSQL & " "
        LSQL = LSQL & " 		    ,STUFF((		"
        LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
        LSQL = LSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
        LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer " 
        LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "

        LSQL = LSQL & " 						AND GameLevelDtlidx = AAA.GameLevelDtlidx"
        LSQL = LSQL & " 						AND DelYN = 'N'"

        LSQL = LSQL & " 		    			FOR XML PATH('')  "
        LSQL = LSQL & " 		    			)  "
        LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
        LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
        LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = A.TourneyGroupIDX"

        LSQL = LSQL & " 					AND DelYN = 'N'"

        LSQL = LSQL & " 		    		),1,1,'') AS LTeams"
        LSQL = LSQL & " 		    ,STUFF((		"
        LSQL = LSQL & " 		    		SELECT  DISTINCT (  "
        LSQL = LSQL & " 		    			SELECT  '|'   + dbo.FN_NameSch(Team,'Team')"
        LSQL = LSQL & " 		    			FROM    KoreaBadminton.dbo.tblTourneyPlayer  "
        LSQL = LSQL & " 		    			WHERE   TourneyGroupIDX    = AAA.TourneyGroupIDX  "

        LSQL = LSQL & " 						AND GameLevelDtlidx = AAA.GameLevelDtlidx"
        LSQL = LSQL & " 						AND DelYN = 'N'"

        LSQL = LSQL & " 		    			FOR XML PATH('')  "
        LSQL = LSQL & " 		    			)  "
        LSQL = LSQL & " 		    		FROM    KoreaBadminton.dbo.tblTourneyPlayer AAA  "
        LSQL = LSQL & " 		    		WHERE AAA.GameLevelDtlidx = A.GameLevelDtlidx"
        LSQL = LSQL & " 		    		AND AAA.TourneyGroupIDX = B.TourneyGroupIDX"

        LSQL = LSQL & " 					AND DelYN = 'N'"

        LSQL = LSQL & " 		    		),1,1,'') AS RTeams"
        LSQL = LSQL & " "
        LSQL = LSQL & " 		    FROM tblTourney A"
        LSQL = LSQL & " 		    INNER JOIN tblTourney B ON B.GameLevelDtlidx = A.GameLevelDtlidx AND B.TeamGameNum = A.TeamGameNum AND B.GameNum = A.GameNum"
        LSQL = LSQL & " 		    INNER JOIN tblGameLevelDtl C ON C.GameLevelDtlidx = A.GameLevelDtlidx"
        LSQL = LSQL & " 		    INNER JOIN tblGameLevel D ON D.GameLevelidx = C.GameLevelidx"
        LSQL = LSQL & " 		    	LEFT JOIN ("
        LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
        LSQL = LSQL & " 		    		FROM KoreaBadminton.dbo.tblGameResult"
        LSQL = LSQL & " 		    		WHERE DelYN = 'N'"
        LSQL = LSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
        LSQL = LSQL & " 		    		) AS E ON E.GameLevelDtlidx = A.GameLevelDtlidx AND E.TeamGameNum = A.TeamGameNum AND E.GameNum = A.GameNum AND E.TourneyGroupIDX = A.TourneyGroupIDX    "
        LSQL = LSQL & " 		    	LEFT JOIN ("
        LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
        LSQL = LSQL & " 		    		FROM KoreaBadminton.dbo.tblGameResult"
        LSQL = LSQL & " 		    		WHERE DelYN = 'N'"
        LSQL = LSQL & " 		    		GROUP BY GameLevelDtlidx, TeamGameNum, GameNum, TourneyGroupIDX, Result, Jumsu"
        LSQL = LSQL & " 		    		) AS F ON F.GameLevelDtlidx = B.GameLevelDtlidx AND F.TeamGameNum = B.TeamGameNum AND F.GameNum = B.GameNum AND F.TourneyGroupIDX = B.TourneyGroupIDX    "			
        LSQL = LSQL & " 		    	LEFT JOIN ("
        LSQL = LSQL & " 		    		SELECT GameLevelDtlidx, TeamGameNum, GameNum, SignData"
        LSQL = LSQL & " 		    		FROM KoreaBadminton.dbo.tblGameSign"
        LSQL = LSQL & " 		    		WHERE DelYN = 'N' "
        LSQL = LSQL & " 		    		) AS G ON G.GameLevelDtlidx = A.GameLevelDtlidx AND G.TeamGameNum = A.TeamGameNum AND G.GameNum = A.GameNum  "			          
        LSQL = LSQL & " 		    WHERE A.DelYN = 'N'"
        LSQL = LSQL & " 		    AND B.DelYN = 'N'"
        LSQL = LSQL & " 		    AND C.DelYN = 'N'"
        LSQL = LSQL & " 		    AND D.DelYN = 'N'"
        LSQL = LSQL & " 		    AND A.ORDERBY < B.ORDERBY"
        LSQL = LSQL & " 			AND A.GameLevelDtlidx = '" & DEC_GameLevelDtlIDX & "'"
        LSQL = LSQL & " 		    AND A.TeamGameNum = '" & DEC_TeamGameNum & "'"
        LSQL = LSQL & " 		) AS AA"
        LSQL = LSQL & " 		WHERE GameLevelDtlIDX IS NOT NULL"
        LSQL = LSQL & " 	) AS BBB"
        LSQL = LSQL & " ) AS CCC"
        LSQL = LSQL & " WHERE CCC.GameLevelDtlIDX IS NOT NULL"    
        'Response.Write "LSQL : " & LSQL & "<BR/>"
        Set LRs = Dbcon.Execute(LSQL)

        i = 1

        If Not (LRs.Eof Or LRs.Bof) Then
          Do Until LRs.Eof        

					Set fn_oJSONoutput_LJumsu = jsArray()
					Set fn_oJSONoutput_RJumsu = jsArray()

					'경기결과페이지에서 오면 경기결과 찍기, 그외 안찍기
					If DEC_IsPrint = "1" Then
						fn_oJSONoutput_LJumsu = SetJumsu(DEC_GameLevelDtlIDX, DEC_TeamGameNum, LRs("GameNum"), LRs("LTourneyGroupIDX"))
						fn_oJSONoutput_RJumsu = SetJumsu(DEC_GameLevelDtlIDX, DEC_TeamGameNum, LRs("GameNum"), LRs("RTourneyGroupIDX"))			
						Win_TourneyGroupIDX = LRs("Win_TourneyGroupIDX")
						LResultType = LRs("LResultType")
						RResultType = LRs("RResultType")
						SignData = LRs("SignData")
					Else
						fn_oJSONoutput_LJumsu = "{""SetPoint1"":"""",""SetPoint2"":"""",""SetPoint3"":"""",""SetPoint4"":"""",""SetPoint5"":"""",""NowSetPoint"":""-""}"
						fn_oJSONoutput_RJumsu = "{""SetPoint1"":"""",""SetPoint2"":"""",""SetPoint3"":"""",""SetPoint4"":"""",""SetPoint5"":"""",""NowSetPoint"":""-""}"
						Win_TourneyGroupIDX = ""
						LResultType = ""
						RResultType = ""
						SignData = ""					
					End If					


					Set JSON_LJumsu = JSON.Parse(fn_oJSONoutput_LJumsu)
					Set JSON_RJumsu = JSON.Parse(fn_oJSONoutput_RJumsu)					
      %>   
		  <tr class="row8" style="height: 35pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1 style12 n" style="text-align: center;vertical-align: middle;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 2px solid #000000 !important;border-right: 1px solid #000000 !important;"><%=i%></td>
			<td class="column2 style13 null" style="vertical-align: middle;text-align: center;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;"><%=LRs("LPlayer1")%></td>
			<td class="column3 style13 null" style="vertical-align: middle;text-align: center;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;"><%=LRs("LPlayer2")%></td>
			<td class="column4 style14 null" style="vertical-align: middle;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;" align="center">&nbsp;</td>
			<td class="column5 style14 null" style="vertical-align: middle;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;" align="center">&nbsp;</td>
			<td class="column6 style14 null" style="vertical-align: middle;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;" align="center">&nbsp;</td>
			<td class="column7 style18 null" align="center" style="vertical-align: middle;border-top: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;">
			
			</td>
			<td class="column8 style18 null" align="center" style="vertical-align: middle;border-top: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;">

			</td>
			<td class="column9 style21 s" style="text-align: center;vertical-align: middle;border-top: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 2px solid #000000 !important;border-right: 2px solid #000000 !important;"><%=LRs("RowGameType")%></td>
			<td class="column10 style28 null" style="vertical-align: middle;text-align: center;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;">
		
			</td>
			<td class="column11 style14 null" align="center" style="vertical-align: middle;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;">
        					
			</td>
			<td class="column12 style14 null" style="vertical-align: middle;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;" align="center">&nbsp;</td>
			<td class="column13 style14 null" style="vertical-align: middle;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;" align="center">&nbsp;</td>
			<td class="column14 style14 null" style="vertical-align: middle;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;" align="center">&nbsp;</td>
			<td class="column15 style13 null" style="vertical-align: middle;text-align: center;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 1px solid #000000 !important;"><%=LRs("RPlayer1")%></td>
			<td class="column16 style15 null" style="vertical-align: middle;text-align: center;border-top: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 1px solid #000000 !important;border-left: 1px solid #000000 !important;border-right: 2px solid #000000 !important;"><%=LRs("RPlayer2")%></td>
			<td class="column17">&nbsp;</td>
		  </tr>
      <%


					Set fn_oJSONoutput_LJumsu = Nothing
					Set fn_oJSONoutput_RJumsu = Nothing

					fn_oJSONoutput_LJumsu = ""
					fn_oJSONoutput_RJumsu = ""

					Set JSON_LJumsu = Nothing
					Set JSON_RJumsu = Nothing

							i = i + 1
            LRs.MoveNext
          Loop 
        End If
      %>


		 
		  <tr class="row13" style="height: 42pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1">&nbsp;</td>
			<td class="column2">&nbsp;</td>
			<td class="column3">&nbsp;</td>
			<td class="column4 style34 s" style="text-align: center;vertical-align: middle;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: #F2F2F2;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;">&nbsp;-</td>
			<td class="column5 style34 s" style="text-align: center;vertical-align: middle;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: #F2F2F2;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;">&nbsp;-</td>
			<td class="column6 style34 s" style="text-align: center;vertical-align: middle;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: #F2F2F2;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;">&nbsp;-</td>
			<td class="column7 style32 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;border-right: 2px solid #000000 !important;">승자팀<br>
체크</td>
			<td class="column8 style31 null" align="center" style="vertical-align: middle;border-left: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-right: 2px solid #000000 !important;">

			</td>
			<td class="column9 style29 s" style="text-align: center;vertical-align: middle;border-top: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-left: 2px solid #000000 !important;border-right: 2px solid #000000 !important;">총점<br>
합계</td>
			<td class="column10 style33 null" align="center" style="vertical-align: middle;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;">
			
			</td>
			<td class="column11 style32 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: white;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;border-right: 2px solid #000000 !important;">승자팀<br>
체크</td>
			<td class="column12 style34 s" style="text-align: center;vertical-align: middle;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: #F2F2F2;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;">&nbsp;-</td>
			<td class="column13 style34 s" style="text-align: center;vertical-align: middle;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: #F2F2F2;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;">&nbsp;-</td>
			<td class="column14 style38 s" style="text-align: center;vertical-align: middle;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 10pt;background-color: #F2F2F2;border-bottom: 2px solid #000000 !important;border-top: 2px solid #000000 !important;border-left: 2px solid #000000 !important;border-right: 2px solid #000000 !important;">&nbsp;-</td>
			<td class="column15">&nbsp;</td>
			<td class="column16">&nbsp;</td>
			<td class="column17">&nbsp;</td>
		  </tr>
		  <tr class="row14" style="height: 21.2pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1">&nbsp;</td>
			<td class="column2">&nbsp;</td>
			<td class="column3">&nbsp;</td>
			<td class="column4">&nbsp;</td>
			<td class="column5">&nbsp;</td>
			<td class="column6">&nbsp;</td>
			<td class="column7">&nbsp;</td>
			<td class="column8">&nbsp;</td>
			<td class="column9">&nbsp;</td>
			<td class="column10">&nbsp;</td>
			<td class="column11">&nbsp;</td>
			<td class="column12">&nbsp;</td>
			<td class="column13">&nbsp;</td>
			<td class="column14">&nbsp;</td>
			<td class="column15">&nbsp;</td>
			<td class="column16">&nbsp;</td>
			<td class="column17">&nbsp;</td>
		  </tr>
		  <tr class="row15" style="height: 21.2pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1">&nbsp;</td>
			<td class="column2">&nbsp;</td>
			<td class="column3">&nbsp;</td>
			<td class="column4">&nbsp;</td>
			<td class="column5">&nbsp;</td>
			<td class="column6">&nbsp;</td>
			<td class="column7">&nbsp;</td>
			<td class="column8">&nbsp;</td>
			<td class="column9">&nbsp;</td>
			<td class="column10">&nbsp;</td>
			<td class="column11">&nbsp;</td>
			<td class="column12">&nbsp;</td>
			<td class="column13">&nbsp;</td>
			<td class="column14">&nbsp;</td>
			<td class="column15">&nbsp;</td>
			<td class="column16">&nbsp;</td>
			<td class="column17">&nbsp;</td>
		  </tr>
		  <tr class="row16" style="height: 21.2pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column2 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column3 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column4 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column5 style43 s style43" colspan="2" style="text-align: center;vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 14pt;background-color: white;border-bottom: 2px solid #000000 !important;">Umpire :</td>
			<td class="column7 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column8 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column9 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column10 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column11 style43 s style43" colspan="3" style="text-align: center;vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 14pt;background-color: white;border-bottom: 2px solid #000000 !important;">Referee:</td>
			<td class="column14 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column15 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column16 style41 null" style="vertical-align: middle;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;border-bottom: 2px solid #000000 !important;"></td>
			<td class="column17 style36 null" style="vertical-align: middle;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;color: #000000;font-family: '맑은 고딕';font-size: 11pt;background-color: white;"></td>
		  </tr>
		  <tr class="row17" style="height: 54pt;">
			<td class="column0">&nbsp;</td>
			<td class="column1 style44 s style44" colspan="16" style="text-align: center;vertical-align: middle;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 24pt;background-color: white;">BADMINTON KOREA ASSOCIATION</td>
			<td class="column17 style35 null" style="vertical-align: middle;border-bottom: none #000000;border-top: none #000000;border-left: none #000000;border-right: none #000000;font-weight: bold;color: #000000;font-family: '맑은 고딕';font-size: 36pt;background-color: white;"></td>
		  </tr>
		</tbody>
	</table>
	</div>
  </body>
</html>


<%
  'Response.END
  'Response.Buffer = True
  'Response.ContentType = "application/vnd.ms-excel"
  'Response.CacheControl = "public"
  'Response.AddHeader "Content-disposition","attachment;filename=score.xls"
%>
