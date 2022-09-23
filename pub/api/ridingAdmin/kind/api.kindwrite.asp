<%
'#############################################

'넌도 종목관리 생성

'DB SD_Riding 
'tblPubCode (코드 정의)
'년도별 등록된 코드값
'tblTeamGbInfo 

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		parr= oJSONoutput.PARR
		reqarr = Split(parr,",")		'//년도,    개인(단체), 종목,마종,    class, class안내

		p_1 = reqarr(0)
		p_2 = reqarr(1)
		p_3 = reqarr(2)
		p_4 = reqarr(3)
		p_5 = reqarr(4)
		p_6 = reqarr(5)
	End if

	Set db = new clsDBHelper 

	  SQL = "Select pubcodeIDX, pubcode,PubName,pubSubName,PPubCode,PPubName,orderby from tblPubCode where pubcodeIDX in ('"&p_2&"','"&p_3&"','"&p_4&"') order by pubcodeIDX"
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If Not rs.EOF Then
		arrPub = rs.GetRows()
	  End If



	If IsArray(arrPub) Then
		For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
			pubcodeidx = arrPub(0, ar)
			pubcode = arrPub(1, ar)
			PubName = arrPub(2, ar)
			PPubCode = arrPub(4, ar)
			orderby = arrPub(6,ar)

			If PPubCode = sitecode & "_1"  then
				sort1 = Orderby
				gb1 = pubcode
				pteamgbnm = pubname
			End If
			If PPubCode = sitecode & "_2"  then
				sort2 = Orderby
				gb2 = pubcode
				teamgbnm = pubname
			End If
			If PPubCode = sitecode & "_3"  then
				gb3 = pubcode
				levelnm = pubname				
			End if			
		Next
	End if

	rullyear = p_1
	pteamgb = gb1
	teamgb = gb1 & gb2
	levelno	= gb1 & gb2 & gb3
	classnm = p_5'LCase(p_5)
	classhelp = p_6'LCase(p_6)
	sortno = sort1 & sort2


	  '중목확인##
	  SQL = "Select TeamGbIDX from tblTeamGbInfo where useyear = '"&rullyear&"' and  pteamgb = '"&pteamgb&"' and teamgb= '"&teamgb&"' and levelno = '"&levelno&"' and ridingclass = '"&classnm&"' and ridingclasshelp = '"&classhelp&"'  and delYN = 'N' "
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If Not rs.eof Then
		Call oJSONoutput.Set("result", "10" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"	  
	    Response.end
	  End if




		insertfield = " useyear,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,levelno,levelNm,ridingclass,ridingclasshelp,Orderby "
		insertvalue = " '"&rullyear&"','"&pteamgb&"','"&pteamgbnm&"','"&teamgb&"','"&teamgbnm&"','"&levelno&"','"&levelnm&"','"&classnm&"','"&classhelp&"','"&sortno&"' "

		SQL = "SET NOCOUNT ON INSERT INTO tblTeamGbInfo ( "&insertfield&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
 <!-- #include virtual = "/pub/html/riding/kindinfolist.asp" -->