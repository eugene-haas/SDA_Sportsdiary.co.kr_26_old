<%
'#############################################

'년도 부별성립실인원 생성

'DB SD_Riding
'tblPubCode (코드 정의)
'년도별 등록된 코드값
'tblRealPersonNo 

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		parr= oJSONoutput.PARR
		reqarr = Split(parr,",")		'//년도, 종목,성립인원

		p_1 = reqarr(0)
		p_2 = reqarr(1)
		p_3 = reqarr(2)
	End if

	Set db = new clsDBHelper 

	  SQL = "Select pubcodeIDX, pubcode,PubName,pubSubName,PPubCode,PPubName,orderby from tblPubCode where pubcodeIDX = '"&p_2&"' order by pubcodeIDX"
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


			If PPubCode = sitecode & "_2"  then
				sort2 = Orderby
				gb2 = pubcode
				teamgbnm = pubname
			End If

		Next
	End if

	rullyear = p_1
	teamgb = "201" & gb2
	realcnt = p_3
	If realcnt = "" Then
		realcnt = 0
	End if

	  '중목확인##
	  SQL = "Select idx from tblRealPersonNo where useyear = '"&rullyear&"' and  teamgb= '"&teamgb&"' and delYN = 'N' "
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If Not rs.eof Then
		Call oJSONoutput.Set("result", "10" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"	  
	    Response.end
	  End if


		insertfield = " useyear,TeamGb,TeamGbNm,realcnt "
		insertvalue = " '"&rullyear&"','"&teamgb&"','"&teamgbnm&"','"&realcnt&"' "

		SQL = "SET NOCOUNT ON INSERT INTO tblRealPersonNo ( "&insertfield&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
 <!-- #include virtual = "/pub/html/riding/makeinfolist.asp" -->