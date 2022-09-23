<!--#include virtual="/Manager/Library/config.asp"-->
<link rel="stylesheet" href="../css/matchInfo_style.css">
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
	TSQL = TSQL&" FROM Sportsdiary.dbo.tblGameTitle " 
	TSQL = TSQL&" WHERE DelYN='N'"
	TSQL = TSQL&" AND GameTitleIDX='"&GameTitleIDX&"'"

	Set TRs = Dbcon.Execute(TSQL)

	If Not(TRs.Eof Or TRs.Bof) Then 
		GameTitleName = TRs("GameTitleName")
		GameS         = TRs("GameS")
		GameE         = TRs("GameE")
		GameArea      = TRs("GameArea")
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
		TEamGbNm = LevelRs("TeamGbNm")
		
		If GroupGameGb = "sd040001" Then 
			GroupGameNm = "개인전"
		ElseIf GroupGameGb = "sd040002" Then 
			GroupGameNm = "단체전"
		End If 
		
		LevelNm = LevelRs("LevelNm")
			
	End If 
	'체급정보 선택==========================================================================================	

	'참가선수 카운팅========================================================================================
	CSQL = "SELECT "
	CSQL = CSQL&" Count(RplayerIDX) AS Cnt"
	CSQL = CSQL&" FROM SportsDiary.dbo.tblRPlayer"
	CSQL = CSQL&" WHERE DelYn = 'N'"
	CSQL = CSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"	
	CSQL = CSQL&" AND TeamGb = '"&TeamGb&"'"
	CSQL = CSQL&" AND Level = '"&Level&"'"
	CSQL = CSQL&" AND GroupGameGb = '"&GroupGameGb&"'"

	Set CRs = Dbcon.Execute(CSQL)

	LevelCnt = CRs("Cnt")
	'참가선수 카운팅========================================================================================
	


	If LevelCnt > 0 Then 

  '대진표의 높이
  Main_Width  = "1100"
  Main_Height = "750"


  TotGameCnt = "128"


  '128강일때 10
  If TotGameCnt = "128" Then 
    playerHeight="16px"
    spanHeight = "8px"
    tdWidth    = "11%"
    tdCnt      = "7"
  '64강일때  20
  ElseIf TotGameCnt = "64" Then 
    playerHeight="20px"
    spanHeight = "16px"
    tdWidth    = "13%"
    tdCnt      = "6"
  '32강일때  40
  ElseIf TotGameCnt = "32" Then 
    playerHeight="40px"
    spanHeight = "32px"
    tdWidth    = "16%"
    tdCnt      = "5"
  '16강일때  80
  ElseIf TotGameCnt = "16" Then 
    playerHeight="80px"
    spanHeight = "64px"
    tdWidth    = "20%"
    tdCnt      = "4"
  '8강일때   160
  ElseIf TotGameCnt = "8" Then 
    playerHeight="160px"
    spanHeight = "128px"
    tdWidth    = "26%"
    tdCnt      = "3"
  '4강일때   320
  ElseIf TotGameCnt = "4" Then 
    playerHeight="320px"
    spanHeight = "256px"
    tdWidth    = "40%"
    tdCnt      = "2"
  '2강일때   640
  ElseIf TotGameCnt = "2" Then 
    playerHeight="640px"
    spanHeight = "512px"
    tdWidth    = "80%"
    tdCnt      = "1"
  '1강일때   1280
  End If 
  
  '한쪽에 그려져야 하는 갯수
  halfCnt = TotGameCnt/2
%>
<table border="0" width="<%=Main_Width%>px" height="<%=Main_Height%>px">
  <tr>
    <td valign="top" height="100px;">
      <!--대회타이틀 및 일정 체급 참가선수 정보-->
      <table width="100%"  border="0">
				<tr>
					<td align="center"><font size="2"><b><%=GameTitleName%></b></font></td>
				</tr>
				<tr>
					<td align="center"><font size="1"><%=GameS%>~<%=GameE%>/<%=GameArea%></font></td>
				</tr>
				<tr>
					<td align="center"><font size="1"><%=TEamGbNm%> >  <%=GroupGameNm%> <%=LevelNm%></font></td>
				</tr>
				<tr>
					<td align="center"><font size="1">참가선수 : <%=LevelCnt%></font></td>
				</tr>
        <tr>
          <td align="left">
            <font size="1"><b>경기대진표</b></font>
            <hr>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="650px;" valign="top">
      <table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0" class="tourney_table">
        <tr>
          <td valign="middle" width="49%">
            <!-- 좌측 구분 선수 S -->
            <table border="0" height="50%" class="tourney left_side">
              <%
                '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
									'좌측선수정보셀렉트=========================================================
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
									LSQL = LSQL&" AND LeftRightGb = 'sd030001'"
									LSQL = LSQL&" order by RPlayerIDX "
									
									'Response.Write LSQL
									Set LRs = Dbcon.Execute(LSQL)								
									'Response.Write LSQL
									LeftTeam = ""	
									If Not(LRs.Eof Or LRs.Bof) Then 
										Do Until LRs.Eof 
											'선수명,팀명,부전여부
											LeftTeam = LeftTeam&LRs("UserName")&"|"&LRs("TeamNm")&"|"&LRs("UnearnWin")&","													
											LRs.MoveNext	
										Loop 
									End If 
									'좌측선수정보셀렉트=========================================================


								'Response.Write LeftTeam
								'강예구|JU018|sd042001,강현수|JU018|sd042001,구준현|JU019|sd042002,
								'해당경기수만큼 선수정보 뿌림
								x = 0 
								NoWrite = "N"
									'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&


                For i=1 To halfCnt     
								
								'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
									Array_LeftTeam = Split(LeftTeam,",")

									NewArray_LeftTeam = Split(Array_LeftTeam(x),"|")

									If NoWrite = "N" Then 
										UserName  = NewArray_LeftTeam(0)
										Team      = NewArray_LeftTeam(1)
										UnearnWin = NewArray_LeftTeam(2)
									End If 
		
									'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
              %>
              <tr class="arr_<%=i%>">
                <td height="<%=playerHeight%>" width="100px"  style="font-size:xx-small;"><%=Team%> <%=UserName%></td>
                <%

									'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
									'좌측선수정보==================
									If UnearnWin = "sd042002" Then 
										UserName = ""
										Team = ""
										NoWrite = "Y"		
										UnearnWin = ""
									Else										

										x = x + 1
										NoWrite = "N"
									End If
									'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
									
                  '16강경기일경우=====================================================================================================
                    If (i Mod 2 = 1) Then 
                      spanstyle = "display: block; border-top: 1px solid #000; border-right: 1px solid #000; height: 16px; margin-top: 16px;"
                    ElseIf  (i Mod 2 = 0) Then 
                      spanstyle = "display: block; border-bottom: 1px solid #000; border-right: 1px solid #000; height: 16px; margin-top: -16px;"
                    End If 
                %>
                <td width="11%"><span style="<%=spanstyle%>"></span></td>
                <%
                  '2Depth Line*********************************************8
                  If i= 1 Or i = 5 Or i = 9 Or i = 13 Or i = 17 Or i = 21 Or i = 25 Or i = 29 Or i= 33 Or i = 37 Or i = 41 Or i = 45 Or i = 49 Or i = 53 Or i = 57 Or i = 61  Then 
                %>
                <td width="11%" rowspan="2"><span style="display: block; border-top: 1px solid #000; border-right: 1px solid #000;  height: 32px; margin-top: 32px;"></span></td>
                <%
                  ElseIf i = 3 Or i = 7 Or i = 11 Or i = 15 Or i = 19 Or i = 23 Or i = 27 Or i = 31 Or i = 35 Or i = 39 Or i = 43 Or i = 47 Or i = 51 Or i = 55 Or i = 59 Or i = 63 Then 
                %>
                <td width="11%" rowspan="2"><span style="display: block; border-bottom: 1px solid #000; border-right: 1px solid #000;  height: 32px; margin-top: -32px;"></span></td>
                <%
                  End If                
                  '2Depth Line*********************************************8
                %>                
                <%
                  '3Depth*****************************
                  If i = 1 Or i = 9 Or i = 17 Or i = 25 Or i = 33 Or i = 41 Or i = 49 Or i = 57 Then 
                %>
                <td width="11%" rowspan="4"><span style="display: block; border-top: 1px solid #000; border-right: 1px solid #000; height: 64px; margin-top: 64px;"></span></td>                
                <%
                  ElseIf i = 5 Or i = 13 Or i = 21 Or i = 29 Or i = 37 Or i = 45 Or i = 53 Or i = 61 Then 
                %>
                <td width="11%" rowspan="4"><span style="display: block; border-bottom: 1px solid #000; border-right: 1px solid #000; height: 64px; margin-top: -64px;"></span></td>                
                <%
                  End If 
                  '3Depth*****************************
                %>
                <%
                  '4Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                  If i = 1 Or i =17 Or i = 33 Or i = 49 Then 
                %>
                <td width="11%" rowspan="8"><span style="display: block; border-top: 1px solid #000; border-right: 1px solid #000; height: 128px; margin-top: 128px;"></span></td>
                <%
                  ElseIf i = 9 Or i = 25 Or i = 41 Or i = 57 Then 
                %>
                <td width="11%" rowspan="8"><span style="display: block; border-bottom: 1px solid #000; border-right: 1px solid #000; height: 128px; margin-top: -128px;"></span></td>
                <%
                  End If 
                  '4Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                %>
                <%
                  '5Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                  If i = 1 Or i = 33 Then 
                %>
                <td width="11%" rowspan="16"><span style="display: block; border-top: 1px solid #000; border-right: 1px solid #000; height: 256px; margin-top: 256px;"></span></td>
                <%
                  ElseIf i = 17 Or i =49 Then 
                %>
                <td width="11%" rowspan="16"><span style="display: block; border-bottom: 1px solid #000; border-right: 1px solid #000; height: 256px; margin-top: -256px;"></span></td>
                <%
                  End If 
                  '5Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

                %>
                <%
                  '6Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                  If i = 1 Then 
                %>
                <td width="11%" rowspan="32"><span style="display: block; border-top: 1px solid #000; border-right: 1px solid #000; height: 512px; margin-top: 512px;"></span></td>
                <%
                  ElseIf i = 33 Then 
                %>
                <td width="11%" rowspan="32" class="left_32_bot"><span style="display: block; border-bottom: 1px solid #000; border-right: 1px solid #000; height: 512px; margin-top: -512px;"></span></td>
                <%
                  End If 
                  '6Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

                %>
                <%
                  '7Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                  If i = 1 Then 
                %>
                <td width="11%" rowspan="64" class="left_64_bot"><span style="display: block; border-bottom: 1px solid #000;  height: 1024px; margin-top: -1024px;"></span></td>                
                <%
                  End If 
                  '7Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                %>
              </tr>
              <%
                Next 
              %>
            </table>
            <!-- 좌측 구분 선수 E -->
          </td>       
          
          <td valign="middle" width="50%">
            <!-- 우측 구분 선수 S -->
            <table border="0" height="100%" class="tourney right_side">
							<%
								'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
									'우측선수정보셀렉트=========================================================
									RSQL = "SELECT "
									RSQL = RSQL&" Left(UserName,3) AS UserName"
									RSQL = RSQL&" ,Left(SportsDiary.dbo.Fn_TeamNm('judo',TeamGb,Team),5) As TeamNm"
									RSQL = RSQL&" ,UnearnWin"
									RSQL = RSQL&" ,LeftRightGb"
									RSQL = RSQL&" FROM SportsDiary.dbo.tblRPlayer"
									RSQL = RSQL&" WHERE DelYn = 'N'"
									RSQL = RSQL&" AND GameTitleIDX = '"&GameTitleIDX&"'"	
									RSQL = RSQL&" AND TeamGb = '"&TeamGb&"'"
									RSQL = RSQL&" AND Level = '"&Level&"'"
									RSQL = RSQL&" AND GroupGameGb = '"&GroupGameGb&"'"
									RSQL = RSQL&" AND LeftRightGb = 'sd030002'"
									RSQL = RSQL&" order by RPlayerIDX "
									
									Set RRs = Dbcon.Execute(RSQL)								
									'Response.Write LSQL
									RightTeam = ""	
									If Not(RRs.Eof Or RRs.Bof) Then 
										Do Until RRs.Eof 
											'선수명,팀명,부전여부
											RightTeam = RightTeam&RRs("UserName")&"|"&RRs("TeamNm")&"|"&RRs("UnearnWin")&","													
											RRs.MoveNext	
										Loop 
									End If 
									'우측선수정보셀렉트=========================================================								
									x = 0
									NoWrite = "N"
								'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
							%>
              <%
                '해당경기수만큼 선수정보 뿌림
                For i = 1 To halfCnt                  
              %>
              <tr class="arr_<%=i%>">
                <%
                  '7Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                  If i = 1 Then 
                %>
                <td width="11%" rowspan="64" class="right_64_bot"><span style="display: block; border-bottom: 1px solid #000;  height: 1024px; margin-top: -1024px;"></span></td>                
                <%
                  End If 
                  '7Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                %>
                <%
                  '6Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                  If i = 1 Then 
                %>
                <td width="11%" rowspan="32"><span style="display: block; border-top: 1px solid #000; border-left: 1px solid #000; height: 512px; margin-top: 512px;"></span></td>
                <%
                  ElseIf i = 33 Then 
                %>
                <td width="11%" rowspan="32" class="right_32_bot"><span style="display: block; border-bottom: 1px solid #000; border-left: 1px solid #000; height: 512px; margin-top: -512px;"></span></td>
                <%
                  End If 
                  '6Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                %>
                <%
                  '5Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                  If i = 1 Or i = 33 Then 
                %>
                <td width="11%" rowspan="16"><span style="display: block; border-top: 1px solid #000; border-left: 1px solid #000; height: 256px; margin-top: 256px;"></span></td>
                <%
                  ElseIf i = 17 Or i =49 Then 
                %>
                <td width="11%" rowspan="16"><span style="display: block; border-bottom: 1px solid #000; border-left: 1px solid #000; height: 256px; margin-top: -256px;"></span></td>
                <%
                  End If 
                  '5Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                %>      
                <%
                  '4Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                  If i = 1 Or i =17 Or i = 33 Or i = 49 Then 
                %>
                <td width="11%" rowspan="8"><span style="display: block; border-top: 1px solid #000; border-left: 1px solid #000; height: 128px; margin-top: 128px;"></span></td>
                <%
                  ElseIf i = 9 Or i = 25 Or i = 41 Or i = 57 Then 
                %>
                <td width="11%" rowspan="8"><span style="display: block; border-bottom: 1px solid #000; border-left: 1px solid #000; height: 128px; margin-top: -128px;"></span></td>
                <%
                  End If 
                  '4Depth$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                %>
                <%
                  '3Depth*****************************
                  If i = 1 Or i = 9 Or i = 17 Or i = 25 Or i = 33 Or i = 41 Or i = 49 Or i = 57 Then 
                %>
                <td width="11%" rowspan="4"><span style="display: block; border-top: 1px solid #000; border-left: 1px solid #000; height: 64px; margin-top: 64px;"></span></td>               
                <%
                  ElseIf i = 5 Or i = 13 Or i = 21 Or i = 29 Or i = 37 Or i = 45 Or i = 53 Or i = 61 Then 
                %>
                <td width="11%" rowspan="4"><span style="display: block; border-bottom: 1px solid #000; border-left: 1px solid #000; height: 64px; margin-top: -64px;"></span></td>               
                <%
                  End If 
                  '3Depth*****************************
                %>
                <%
                  '2Depth Line*********************************************8
                  If i= 1 Or i = 5 Or i = 9 Or i = 13 Or i = 17 Or i = 21 Or i = 25 Or i = 29 Or i= 33 Or i = 37 Or i = 41 Or i = 45 Or i = 49 Or i = 53 Or i = 57 Or i = 61  Then 
                %>
                <td width="11%" rowspan="2"><span style="display: block; border-top: 1px solid #000; border-left: 1px solid #000;  height: 32px; margin-top: 32px;"></span></td>
                <%
                  ElseIf i = 3 Or i = 7 Or i = 11 Or i = 15 Or i = 19 Or i = 23 Or i = 27 Or i = 31 Or i = 35 Or i = 39 Or i = 43 Or i = 47 Or i = 51 Or i = 55 Or i = 59 Or i = 63 Then 
                %>
                <td width="11%" rowspan="2"><span style="display: block; border-bottom: 1px solid #000; border-left: 1px solid #000;  height: 32px; margin-top: -32px;"></span></td>
                <%
                  End If                
                  '2Depth Line*********************************************8
                %>  
                <%
                  '16강경기일경우=====================================================================================================
                    If (i Mod 2 = 1) Then 
                      spanstyle = "display: block; border-top: 1px solid #000; border-left: 1px solid #000; height: 16px; margin-top: 16px;"
                    ElseIf  (i Mod 2 = 0) Then 
                      spanstyle = "display: block; border-bottom: 1px solid #000; border-left: 1px solid #000; height: 16px; margin-top: -16px;"
                    End If 
                %>
                <td width="11%"><span style="<%=spanstyle%>"></span></td>
								<%
									'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
									Array_RightTeam = Split(RightTeam,",")

									NewArray_RightTeam = Split(Array_RightTeam(x),"|")

									If NoWrite = "N" Then 
										UserName  = NewArray_RightTeam(0)
										Team      = NewArray_RightTeam(1)
										UnearnWin = NewArray_RightTeam(2)
									End If 									
									'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
								%>
                <td height="<%=playerHeight%>" width="100px"  style="font-size:xx-small;"><%=UserName%> <%=Team%></td>								
								<%									
									'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
									'Response.Write UnearnWin
									If UnearnWin = "sd042002" Then 
										UserName = ""
										Team = ""
										NoWrite = "Y"		
										UnearnWin = ""
									Else			
										x = x + 1
										NoWrite = "N"
									End If
									'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&									
								%>
              </tr>
              <%
                Next 
              %>
              
            </table>
            <!-- 우측 구분 선수 E -->
          </td>

        </tr>
      </table>
    </td>
  </tr>
</table>
<%
  End If 
%>
