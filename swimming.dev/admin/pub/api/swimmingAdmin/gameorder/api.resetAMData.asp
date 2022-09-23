<%
'#############################################
'순서에서 오전순서 제거
'#############################################
	'request
	If hasown(oJSONoutput, "LIDX") = "ok" then
		lidx = oJSONoutput.LIDX
	End if


	Set db = new clsDBHelper

	gubunQuery = " and tryoutgameingS > 0 " '오전오후를 구분하기 위해 넣는다.


	SQL = "Select top 1 Gametitleidx, cdc,tryoutgamedate,gameno from tblRGameLevel where RgameLevelIDX = " & lidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr) 
	tidx = rs(0)
	cdc = rs(1)
	dateam = rs(2)
	delgameno = rs(3)

	SQL = "Select min(tryoutgamestarttime),max(tryoutgamestarttime) from tblRGameLevel where gametitleidx= '"&tidx&"' and cdc = '"&cdc&"' and tryoutgamedate = '"&dateam&"' "&gubunQuery&" "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr) 
	timeammin = rs(0) '다음 설정값 시간이 될값.....
	timeammax = rs(1)


	'시간 없데이트 할 데이터들.....(오전과 오후가 구분되어야한다)
	SQL = "select top 1 tryoutgamestarttime,tryoutgameingS  from tblRGameLevel where gametitleidx = "&tidx&" and tryoutgamedate = '"&dateam&"'  and tryoutgamestarttime > '"&timeammax&"' "&gubunQuery&"  order by gameno,tryoutgameingS "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr) 
	If Not rs.EOF Then
		ar = rs.GetRows()
	End If


	'Call getrowsdrow(ar)

	'오전 이후 데이터 날짜를 업데이트 하고...
	If IsArray(ar) Then 
		For ari = LBound(ar, 2) To UBound(ar, 2)
			tm = ar(0, ari)

			If ari = 0 Then
				addtmvalue =  DATEDIFF("n", dateam & " " & timeammin & ":00" , dateam & " " & tm & ":00")
			End If
		Next 

		If tm <> "" Then
			strwhere = " where gametitleidx = "&tidx&" and tryoutgamedate = '"&dateam&"'  and tryoutgamestarttime > '"&timeammax&"'  "&gubunQuery&" "
			setvalue = " left(CONVERT(VARCHAR(8), DATEADD(minute, -"&addtmvalue&", convert(char(10), tryoutgamedate,23) + ' ' + tryoutgamestarttime + ':00'), 108),5) "

			'아래것들 순서 당기기
			SQL = "Update tblRGameLevel Set tryoutgamestarttime = "&setvalue&" " &  strwhere
			Call db.execSQLRs(SQL , null, ConStr) 	
		End If
		
	End If


	'선택된 정보 초기화
	updatefld = " gubunam=0 ,tryoutgamedate = null ,tryoutgamestarttime = null ,tryoutgameingS = '0' ,gameno= '0',joono='0' " '오전초기화할 데이터
	SQL = "update tblRGameLevel Set "& updatefld & " where gametitleidx = '"&tidx&"' and cdc = '"&cdc&"' and tryoutgamedate = '"&dateam&"' "&gubunQuery&" "
	Call db.execSQLRs(SQL , null, ConStr)


	'#####################################################################
	'삭제할데이터의 gameno 값보다 큰아이들을 순서대로 만들어서 업데이트 /오전 오후 각각
	'#####################################################################
	'오전 업데이트 
	SQL = "update A Set A.gameno = A.gnum  from ( select gameno,("&delgameno&" -1 + RANK() OVER (Order By gameno asc)) AS gnum  from tblRGameLevel where delyn = 'N' and gametitleidx = '"&tidx&"' and  (gameno > "&delgameno&" and  tryoutgamedate = '"&dateam&"')  ) A "
	Call db.execSQLRs(SQL , null, ConStr) 	

	'오후 업데이트
	SQL = " update A Set A.gameno2 = A.gnum from  ( select gameno2, ((select max(gameno) from tblRGameLevel where delyn = 'N' and gametitleidx = '"&tidx&"' and tryoutgamedate = '"&dateam&"' )+ RANK() OVER (Order By gameno2 asc)) AS gnum from tblRGameLevel where delyn = 'N' and gametitleidx = '"&tidx&"' and finalgamedate = '"&dateam&"' )  A "
	Call db.execSQLRs(SQL , null, ConStr) 	
	'#####################################################################





	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	'SQL = "Select  "&setvalue&"  from tblRGameLevel  "&strwhere
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr) 
	'Call rsdrow(rs)


  db.Dispose
  Set db = Nothing
%>


