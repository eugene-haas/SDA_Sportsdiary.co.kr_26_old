<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
	If request("test") = "t" Then
		REQ ="{""CMD"":200,""SVAL"":""김"",""PARM1"":""2020"",""SENDPRE"":""kor_""}"
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
	If hasown(oJSONoutput, "SVAL") = "ok" then
		findstr = oJSONoutput.get("SVAL")
	End If
	
	If hasown(oJSONoutput, "PARM1") = "ok" then
		yy = oJSONoutput.get("PARM1")
	End if
	
	Set db = new clsDBHelper 

'		tablename = "tblSimpleBoard"
'		strFieldName = " CATE,TITLE  "
'
'		For i = 0 To oJSONoutput.PARR.length-1 '받은거 기준 (입력값 준비)
'			Select Case i
'			Case 0
'				insertvalue	= " '"&reqArr.Get(i)&"' "
'			Case Else
'					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
'			End Select 
'		next

'		SQL = "SET NOCOUNT ON INSERT INTO "&tablename&" ( "&strFieldName&" ) VALUES " 'confirm 확인여부
'		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'		idx = rs(0)
'
'		Call oJSONoutput.Set("result", 0 )
'		strjson = JSON.stringify(oJSONoutput)
'		Response.Write strjson


	SQL = " select top 10 playeridx as idx,username as fa ,eng_nm as fb,team as fc,teamnm as fd,ksportsno as fe,sex as ff,birthday as fg from  tblplayer  where delYN = 'N'  and userType = 'P' and username like '"&findstr &"%' " 'and nowyear = '"&yy&"'
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	Response.write jsonTors_arr(rs)







  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>