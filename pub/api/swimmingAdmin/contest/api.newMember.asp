<%
'#############################################

'대회생성저장

'#############################################
	'request
	If hasown(oJSONoutput, "RIDX") = "ok" Then  
		ridx = chkStrRpl(oJSONoutput.RIDX,"")
	End If
	If hasown(oJSONoutput, "PIDX") = "ok" Then  
		pidx = chkStrRpl(oJSONoutput.PIDX,"")
	End If


	Set db = new clsDBHelper 

		'테이블 만들어서 팀코드 에 선수들 4명 이상을 랜덤하게 넣자. 최종 4명 선택하겠지 (request테이블 서브에)
		SQL = "insert into tblGameRequest_r (requestIDX,kskey,playeridx,username,team,teamnm,userClass,sex)  (Select top 6 '"&ridx&"',kskey,playeridx,username,team,teamnm,userClass,sex from tblPlayer where delyn = 'N' and playerIDX = '"&pidx&"'  )"
		Call db.execSQLRs(SQL , null, ConStr)


		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>