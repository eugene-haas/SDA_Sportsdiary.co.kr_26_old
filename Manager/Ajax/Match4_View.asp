<!--#include virtual="/Manager/Library/config.asp"-->
<!-- #include file="./include/config.asp" -->
<%
	GameTitleIDx = fInject(Request("GameTitleIDx"))
	TeamGb       = fInject(Request("TeamGb"))
	Level        = fInject(Request("Level"))
	GroupGameGb  = fInject(Request("GroupGameGb"))

	'GameTitleIDx = "44"	
	'TeamGb       = "21001"
	'Level        = "21001002"
	'GroupGameGb  = "sd040001"

	'대회정보 선택==========================================================================================
	TSQL = "SELECT "
	TSQL = TSQL&" GameTitleName " 
	TSQL = TSQL&" ,GameS "
	TSQL = TSQL&" ,GameE "
	TSQL = TSQL&" ,GameArea"
	TSQL = TSQL&" ,HostCode"
	TSQL = TSQL&" FROM Sportsdiary.dbo.tblGameTitle " 
	TSQL = TSQL&" WHERE DelYN='N'"
	TSQL = TSQL&" AND GameTitleIDX='"&GameTitleIDX&"'"

	Set TRs = Dbcon.Execute(TSQL)

	If Not(TRs.Eof Or TRs.Bof) Then 
		GameTitleName = TRs("GameTitleName")
		GameS         = TRs("GameS")
		GameE         = TRs("GameE")
		GameArea      = TRs("GameArea")
		HostCode      = TRs("HostCode")
	End If 
	'대회정보 선택==========================================================================================
	
	'체급정보 선택==========================================================================================
	LevelSQL ="SELECT "
	LevelSQL = LevelSQL&" LevelNm"
	LevelSQL = LevelSQL&" ,SportsDiary.dbo.Fn_TeamGbNm('judo',TeamGb) As TeamGbNm "
	LevelSQL = LevelSQL&" FROM sportsdiary.dbo.tblLevelInfo "
	LevelSQL = LevelSQL&" WHERE DelYN='N'"
	LevelSQL = LevelSQL&" AND SportsGb='judo'"
	LevelSQL = LevelSQL&" AND Level = '"&Level&"'"

	Set LevelRs = Dbcon.Execute(LevelSQL)

	If Not(LevelRs.Eof Or LevelRs.Bof) Then 
		TeamGbNm = LevelRs("TeamGbNm")
		
		If GroupGameGb = "sd040001" Then 
			GroupGameNm = "개인전"
		ElseIf GroupGameGb = "sd040002" Then 
			GroupGameNm = "단체전"
		End If 
		
		LevelNm = LevelRs("LevelNm")
			
	End If 
	'체급정보 선택==========================================================================================	

	'참가선수 카운팅========================================================================================
		If GroupGameGb = "sd040001" Then 
			CSQL = "SELECT "
			CSQL = CSQL&" Count(RplayerIDX) AS Cnt"
			CSQL = CSQL&" FROM SportsDiary.dbo.tblRPlayer"
			CSQL = CSQL&" WHERE DelYn = 'N'"
			CSQL = CSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"	
			CSQL = CSQL&" AND TeamGb = '"&TeamGb&"'"
			CSQL = CSQL&" AND Level = '"&Level&"'"
			CSQL = CSQL&" AND GroupGameGb = '"&GroupGameGb&"'"		
		Else
			'단체전
			CSQL = "SELECT "
			CSQL = CSQL&" Count(RGameGroupSchoolIDX) AS Cnt"
			CSQL = CSQL&" FROM SportsDiary.dbo.tblRGameGroupSchool"
			CSQL = CSQL&" WHERE DelYn = 'N'"
			CSQL = CSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
			CSQL = CSQL&" AND TeamGb = '"&TeamGb&"'"
		End If 

	Set CRs = Dbcon.Execute(CSQL)

	LevelCnt = CRs("Cnt")
	'참가선수 카운팅========================================================================================
%>	
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <title><%=GroupGameNm%>_<%=TeamGbNm%>_<%=LevelNm%></title>
  <link rel="stylesheet" href="./include/css/style_print.css">
</head>
<body>
  <!-- S: header -->
  <div class="header">
    <div class="attend">[경기대진표] <span>참가선수: <%=LevelCnt%>명</span></div>
    <div class="title">
      <h1><%=GameTitleName%></h1>
      <p class="date"><%=GameS%> ~ <%=GameS%> / <%=GameArea%></p>
      <p class="team"><%=TeamGbNm%> > <%=GroupGameNm%> <%=LevelNm%></p> 
    </div>
  </div>
  <!-- E: header -->
  <!-- S: main -->
  <div class="main clearfix match4">
    <!-- S: left_side -->
    <div class="left_side">
			<%
				'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				'좌측선수정보셀렉트=========================================================
				If GroupGameGb = "sd040001" Then 
					LSQL = "SELECT "
					LSQL = LSQL&" Left(UserName,3) AS UserName"
					LSQL = LSQL&" ,Left(SportsDiary.dbo.Fn_TeamNm('judo',TeamGb,Team),5) As TeamNm"
					LSQL = LSQL&" ,UnearnWin"
					LSQL = LSQL&" ,LeftRightGb"
					LSQL = LSQL&" ,WriteDate"
					LSQL = LSQL&" FROM SportsDiary.dbo.tblRPlayer"
					LSQL = LSQL&" WHERE DelYn = 'N'"
					LSQL = LSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"	
					LSQL = LSQL&" AND TeamGb = '"&TeamGb&"'"
					LSQL = LSQL&" AND Level = '"&Level&"'"
					LSQL = LSQL&" AND GroupGameGb = '"&GroupGameGb&"'"
					LSQL = LSQL&" AND LeftRightGb = 'sd030001'"
					LSQL = LSQL&" order by RPlayerIDX "
									
				Else 
					LSQL = "SELECT " 
					LSQL = LSQL&" Left(SchoolName,3) AS UserName"
					LSQL = LSQL&" ,Left(SportsDiary.dbo.Fn_TeamNm('judo',TeamGb,Team),9) As TeamNm"
					LSQL = LSQL&" ,UnearnWin"
					LSQL = LSQL&" ,LeftRightGb"
					LSQL = LSQL&" ,WriteDate"
					LSQL = LSQL&" FROM SportsDiary.dbo.tblRGameGroupSchool"
					LSQL = LSQL&" WHERE DelYn = 'N'"
					LSQL = LSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
					LSQL = LSQL&" AND TeamGb = '"&TeamGb&"'"
					LSQL = LSQL&" AND LeftRightGb = 'sd030001'"
					LSQL = LSQL&" order by RGameGroupSchoolIDX "
				End if
				
				Set LRs = Dbcon.Execute(LSQL)               

					If Not(LRs.Eof Or LRs.Bof) Then 
						WriteDate = ""
						Do Until LRs.Eof 
						WriteDate = LRs("WriteDate")
				%>
      <table>
        <tr>
          <td><span class="player_school"><%=LRs("TeamNm")%></span> <%=LRs("UserName")%></td>
        </tr>
      </table>
			<%
						LRs.MoveNext
					Loop 
				End If              
			%>
    </div>
    <!-- E: left_side -->
    <!-- S: line_area -->
    <div class="line_area">
      <img src="../Images/print/line_match4.png" alt>
    </div>
    <!-- E: line_area -->
    <!-- S: right_side -->
    <div class="right_side">
      <%
				'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
				'좌측선수정보셀렉트=========================================================
				If GroupGameGb = "sd040001" Then 
					LSQL = "SELECT "
					LSQL = LSQL&" Left(UserName,3) AS UserName"
					LSQL = LSQL&" ,Left(SportsDiary.dbo.Fn_TeamNm('judo',TeamGb,Team),5) As TeamNm"
					LSQL = LSQL&" ,UnearnWin"
					LSQL = LSQL&" ,LeftRightGb"
					LSQL = LSQL&" FROM SportsDiary.dbo.tblRPlayer"
					LSQL = LSQL&" WHERE DelYn = 'N'"
					LSQL = LSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"	
					LSQL = LSQL&" AND TeamGb = '"&TeamGb&"'"
					LSQL = LSQL&" AND Level = '"&Level&"'"
					LSQL = LSQL&" AND GroupGameGb = '"&GroupGameGb&"'"
					LSQL = LSQL&" AND LeftRightGb = 'sd030002'"
					LSQL = LSQL&" order by RPlayerIDX "
									
				Else 
					LSQL = "SELECT " 
					LSQL = LSQL&" Left(SchoolName,3) AS UserName"
					LSQL = LSQL&" ,Left(SportsDiary.dbo.Fn_TeamNm('judo',TeamGb,Team),9) As TeamNm"
					LSQL = LSQL&" ,UnearnWin"
					LSQL = LSQL&" ,LeftRightGb"
					LSQL = LSQL&" FROM SportsDiary.dbo.tblRGameGroupSchool"
					LSQL = LSQL&" WHERE DelYn = 'N'"
					LSQL = LSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"  
					LSQL = LSQL&" AND TeamGb = '"&TeamGb&"'"
					LSQL = LSQL&" AND LeftRightGb = 'sd030002'"
					LSQL = LSQL&" order by RGameGroupSchoolIDX "
				End if
				
				Set LRs = Dbcon.Execute(LSQL)               

					If Not(LRs.Eof Or LRs.Bof) Then 
						Do Until LRs.Eof 
				%>
      <table>
        <tr>
          <td><%=LRs("UserName")%> <span class="player_school"><%=LRs("TeamNm")%></span></td>
        </tr>
      </table>
			<%
						LRs.MoveNext
					Loop 
				End If              
			%>
    </div>
    <!-- E: right_side -->
  </div>
  <!-- E: main -->
  <!-- S: semifinal -->
	<!--
  <div class="semifinal">
    <table>
      <thead>
        <tr>
          <td>3위 결정전</td>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>&nbsp;</td>
        </tr>
      </tbody>
    </table>
  </div>
	-->
  <!-- E: semifinal -->
  <!-- S: footer -->
  <div class="footer">
    <div class="bot_logo">
		<%
			'대한유도회
			If HostCode = "sd053001" Then 
		%>
    <img src="../Images/print/logo_kja.png" alt="대한유도회">
		<%	
			'한국초중고등학교유도연맹
			ElseIf HostCode ="sd053002" Then 
		%>
		<img src="../Images/print/logo_kjhs2.png" alt="한국초중고등학교연맹">
		<%
			'대학유도연맹
			ElseIf HostCode ="sd053003" Then 
		%>
		<img src="../Images/print/logo_kujf.png" alt="한국대학유도연맹">
		<%
			'실업유도연맹
			ElseIf HostCode ="sd053004" Then 
		%>
		<img src="../Images/print/logo_kijf.png" alt="한국실업유도연맹">
		<%
			Else
		%>
    <img src="../Images/print/logo_kja.png" alt="대한유도회">
		<%
			End If 
		%>
      <!--<img src="../Images/print/logo_kja.png" alt="대한유도회">-->
      <!-- <img src="../Images/print/logo_kijf.png" alt="한국실업유도연맹"> -->
      <!-- <img src="../Images/print/logo_kujf.png" alt="한국대학유도연맹"> -->
      <!-- <img src="../Images/print/logo_kjhs.png" alt="한국중고등학교연맹"> -->
    </div>
    <div class="print_date">
      Report Created : <%=WriteDate%><!--<%=NowYear%>년 <%=NowMonth%>월 <%=NowDay%>일 <%=NowHour%>:<%=NowMinute%>-->
    </div>
  </div>
  <!-- E: footer -->
</body>
</html>