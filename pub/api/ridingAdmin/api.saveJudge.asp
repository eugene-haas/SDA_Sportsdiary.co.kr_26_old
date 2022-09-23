<%
'#############################################
'선수변경창
'#############################################
	Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "ANM") = "ok" Then  'BEMCH    A(스튜어드, sit-in , shadow)
		anm = oJSONoutput.ANM
	End If
	If hasown(oJSONoutput, "TYPENO") = "ok" Then  '구분 1 심판 2 스크라이버,   A:1,2,3
		typeno = oJSONoutput.TYPENO
	End If
	If hasown(oJSONoutput, "TIDX") = "ok" Then 
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "RIDX") = "ok" Then  'tblRGameLevel.RGameLevelidx
		ridx = oJSONoutput.RIDX
	End If


	If hasown(oJSONoutput, "PIDXS") = "ok" Then 
		pidxs = oJSONoutput.PIDXS
	End If

	If hasown(oJSONoutput, "NMS") = "ok" Then 
		nms = oJSONoutput.NMS
	End If


	Select Case anm
	Case "B","E","M","C","H"
		Select Case  typeno
		Case "1" '심판
			selectnm = "심판"
			'Bpidx,Epidx,Mpidx,Cpidx,Hpidx,'Bname,Ename,Mname,Cname,Hname
			upstr = anm & "pidx = '" & pidxs & "' , " & anm & "name = '"&nms&"' "
		Case "2" '스크라이버
			selectnm = "스크라이버"
			'Bpidx_s,Epidx_s,Mpidx_s,Cpidx_s,Hpidx_s,Bname_s,Ename_s,Mname_s,Cname_s,Hname_s,
			upstr = anm & "pidx_s = '" & pidxs & "' , " & anm & "name_s = '"&nms&"' "
		End Select 
		

	'etcAidx,etcBidx,etcCidx,etcAname,etcBname,etcCname
	Case "A"
		Select Case  typeno
		Case "1" '스튜어드
			selectnm = "스튜어드"
			upstr = "etcAidx = '" & pidxs & "' , etcAname = '"&nms&"' "
		Case "2" 'Sit-in
			selectnm = "Sit-in"
			upstr = "etcBidx = '" & pidxs & "' , etcBname = '"&nms&"' "
		Case "3" 'shadow
			selectnm = "shadow"
			upstr = "etcCidx = '" & pidxs & "' , etcCname = '"&nms&"' "
		End Select 
	End Select 

	SQL = "update tblRGameLevel set  "&upstr&" where  RGameLevelidx = "   & ridx
	Call db.execSQLRs(SQL , null, ConStr)


  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing

%>
