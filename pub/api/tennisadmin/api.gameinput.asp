<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	'gyear = oJSONoutput.GameYear
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
	codegrade = oJSONoutput.CODEGRADE

	code_grade = Split(codegrade,"_")
	titlecode = code_grade(0)
	titlegrade = code_grade(1)


	cfg = tie & gdeuce


	gyear = Left(sdate,4)

    
    viewMatchYN="N"
    if MatchYN>=1 then 
        viewMatchYN="Y"
    end if 

	Set db = new clsDBHelper


		SQL = "Update tblGameHost Set makegamecnt = makegamecnt + 1 where hostname = '"&hostname&"' " 
		Call db.execSQLRs(SQL , null, ConStr)


		insertfield = " GameTitleName,GameS,GameE, GameYear, GameArea,EnterType,GameRcvDateS,GameRcvDateE,ViewYN,stateNo,ViewState,cfg,hostname,MatchYN,titlecode,titlegrade "
		insertvalue = " '"&title&"','"&sdate&"','"&edate&"','"&gyear&"','"&area&"','"&entertype&"','"&rcvs&"','"&rcve&"','"&ViewYN&"','"&MatchYN&"','"&ViewState&"','"&cfg&"','"&hostname&"','"&viewMatchYN&"', "&titlecode&", "&titlegrade&" "

		SQL = "SET NOCOUNT ON INSERT INTO sd_TennisTitle ( "&insertfield&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		idx = rs(0)

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



  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
	<!-- #include virtual = "/pub/html/tennisAdmin/gameinfolist.asp" -->