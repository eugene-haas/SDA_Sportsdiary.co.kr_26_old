<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.IDX
	title = oJSONoutput.GameTitleName
	hostname = oJSONoutput.HostCode '주최
	sdate = oJSONoutput.GameS
	edate = oJSONoutput.GameE

	area = oJSONoutput.GameArea
	rcvs = oJSONoutput.GameRcvS
	rcve = oJSONoutput.GameRcvE

	ViewYN = oJSONoutput.ViewYN
	MatchYN = oJSONoutput.MatchYN
	ViewState = oJSONoutput.ViewState	
	
	tie = oJSONoutput.TIE
	gdeuce= oJSONoutput.DUC
	entertype = oJSONoutput.ENTERTYPE
	cfg = tie & gdeuce
	gyear = Left(sdate,4)

	codegrade = oJSONoutput.CODEGRADE
	code_grade = Split(codegrade,"_")
	titlecode = code_grade(0)
	titlegrade = code_grade(1)



	If hasown(oJSONoutput, "bigo") = "ok" then
	gameprize= oJSONoutput.bigo
	End if

	If hasown(oJSONoutput, "chkrange") = "ok" then
	chkrange= oJSONoutput.chkrange
	End if

	Set db = new clsDBHelper


    viewMatchYN="N"
    if MatchYN>=1 then 
        viewMatchYN="Y"
    end if 

	updatefield = " GameTitleName ='"&title&"',GameS='"&sdate&"',GameE ='"&edate&"', GameYear ='"&gyear&"', GameArea ='"&area&"',EnterType ='"&entertype&"',GameRcvDateS ='"&rcvs&"',GameRcvDateE ='"&rcve&"',ViewYN ='"&ViewYN&"',stateNo ="&MatchYN&",ViewState ='"&ViewState&"',cfg ='"&cfg&"',hostname = '"&hostname&"',MatchYN='"&viewMatchYN&"',titlecode ="&titlecode&" ,titlegrade = "&titlegrade&", gameprize='"&gameprize&"' ,chkrange = '"&chkrange&"'  "
	strSql = "update  sd_TennisTitle Set   " & updatefield & " where GameTitleIDX = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)


	Select Case MatchYN '게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	Case "0" : MatchYN = "<span style='color:blue'>미노출</span>"
	Case "3" : MatchYN = "<span style='color:orange'>예선노출</span>"
	Case "4" : MatchYN = "예선마감"
	Case "5" : MatchYN = "본선노출"
	Case "6" : MatchYN = "본선마감"
	Case "7" : MatchYN = "결과노출"
	End Select

	Select Case titleGrade
	Case "1" : titleGrade = "SA"
	Case "2" : titleGrade = "GA"
	Case "3" : titleGrade = "A"
	Case "4" : titleGrade = "B"
	Case "5" : titleGrade = "C"
	Case "6" : titleGrade = "단체전"
	End Select 

  db.Dispose
  Set db = Nothing
%>

<!-- #include virtual = "/pub/html/swimAdmin/gameinfolist.asp" -->
