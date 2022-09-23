<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
	If request("test") = "t" Then
		REQ ="{""CMD"":30001,""PARR"":[""국제대회임"",""http://www.naver.com"",""인도"",""뉴델리"",""2020-07-17"",""2020-07-30""]}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	Set oJSONoutput = JSON.Parse( join(array(REQ)) )
	CMD = oJSONoutput.Get("CMD")

'#############################################
'저장
'#############################################

	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR
	End if
	
	Set db = new clsDBHelper 
		tablename = "home_gameTitle"
		insertfield = " title,gameurl,nationNM,cityNM,sdate,edate,gameyear,gamemonth "

		For i = 0 To oJSONoutput.PARR.length-1 '받은거 기준 (입력값 준비)
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case 4 
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
					gameS = Split(reqArr.Get(i),"-")
					gameSY = gameS(0)
					gameSM = gameS(1)
			Case 5 '마지막에서 다넣어주자.
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"','"&gameSY&"' ,'"&gameSM&"' "
			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "SET NOCOUNT ON INSERT INTO "&tablename&" ( "&insertfield&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>