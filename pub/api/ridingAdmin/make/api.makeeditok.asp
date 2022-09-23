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

		idx = reqarr(0) 'idx

		p_1 = reqarr(1)
		p_2 = reqarr(2)
		p_3 = reqarr(3)
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


	  '나외 다른것들과 중목확인##
	  SQL = "Select idx from tblRealPersonNo where idx  <> "&idx&" and useyear = '"&rullyear&"' and  teamgb= '"&teamgb&"' and delyn = 'N'"
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If Not rs.eof Then
		Call oJSONoutput.Set("result", "10" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.write "`##`"	  
	    Response.end
	  End if




	updatefield = " useyear ='"&rullyear&"' ,TeamGb='"&teamgb&"',TeamGbNm='"&teamgbnm&"',realcnt='"&realcnt&"' "
	SQL = "update  tblRealPersonNo Set   " & updatefield & " where idx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)


  db.Dispose
  Set db = Nothing
%>
 <!-- #include virtual = "/pub/html/riding/makeinfolist.asp" -->