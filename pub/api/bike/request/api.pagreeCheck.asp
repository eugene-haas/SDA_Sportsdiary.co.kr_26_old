<%
'request
	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	If hasown(oJSONoutput, "LVLIDX") = "ok" then
		levelIDX = oJSONoutput.LVLIDX
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	
	If hasown(oJSONoutput, "GN") = "ok" then
		gubun = oJSONoutput.GN
	End If	

	If hasown(oJSONoutput, "ridx") = "ok" then
		ridx = oJSONoutput.ridx
	End If	
'request

'참가신청인경우
'{"pg":1,"tidx":23,"LVLIDX":0,"ridx":1,"groupno":0,"name":"참가종목선택","mysex":"man","BOONM":"남자부","subtype":"2","chkgame":"121,CAT4:","bikeidx":"9","marriage":"Y","job":"JOB02","bloodtype":"B","career":"CR004","brand":"BR006","gamegift":"S","CMD":20030,"agree":"Y","adult":"N","teamnm":"oooo","teamlist":"mujerk,bnbnbn,sjh12355,","p_nm":"0000","p_phone":"010-0000-0000","p_relation":"모","sendcnt":3,"lmsno":3,"lms":"12816,이수진,010-6787-8723^12817,최정화,010-9001-4717^*보호자*,0000,010-0000-0000^","gameidx":1395,"result":"0"}

	Set db = new clsDBHelper


	'상세내역 쿼리 #################

If levelIDX = "0" Then
	SQL = "select levelno from sd_bikeRequest where requestIDX = " & ridx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	levelIDX = rs(0)
End if

	strWhere = " a.DelYN = 'N'  and  b.PlayerIDX = " & cbike_pidx  & " and  a.titleIDX = "&tidx &" and b.levelno = "&levelIDX '진행중인것만
	tablename = " sd_bikeLevel as a INNER JOIN v_bikeGame_attm as b ON a .titleIDX = b.titleIDX and a.levelIDX = b.levelno "

	strFieldName = " a.levelIDX, a.titleIDX, a.levelno, a.detailtitle,a.gameday, a.entertype,a.booNM,a.sex, "
	strFieldName = strFieldName &  " b.pgrade,b.gubun,b.groupno,b.p_agree,b.myadult,b.myagree,b.writeDay,b.ridx,b.gameidx"
	'strFieldName = "*"

	'***설명임 지우지 말것 ***
	'sd_bikeTitle.Gstate  0, 준비대기중, 1, 신청진행중  2, 신청완료
	'sd_bikeGame.gubun = 0 진행중, 1 확정 ,2 취소 (경기에 관해서 동의완료, 입금완료로 업데이트)
	'sd_bikeAttMember.groupno 0 단체전, 증가숫자 개인전 신청 묶음 번호
	'sd_bikeAttMember.p_agree 부모동의 완료 여부
	'sd_bikeAttMember.myagree 내동의여부
	'***설명임 지우지 말것 ***

	SQL = "Select " & strFieldName & " from "&tablename&" where " & strWhere & " order by a.levelIDX desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	If Not rs.eof then
		arrATT = rs.GetRows()		
	End if

	If IsArray(arrATT) Then
		For ar = LBound(arrATT, 2) To UBound(arrATT, 2) 
			cr_groupno = arrATT(10, ar)
			cr_p_agree = arrATT(11,ar)
			cr_ridx = arrATT(15,ar)
			cr_gidx = arrATT(16,ar)

		Next
	End If

	SQL = "select myadult,myagree,p_agree from sd_bikeAttMember where gameidx = " & cr_gidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	totaladult = "Y" '미성년여부
	totalpagree = "Y" '보호자 동의
	totalagree = "Y" '동의여부
	paystate = "N" '결제여부

	Do Until rs.eof 
		m_adult = rs("myadult")
		m_agree = rs("myagree")
		m_pagree = rs("p_agree")

		If m_agree = "N" Then
			totalagree = "N"
		End If
		
		If m_adult = "N" Then
			totaladult = "N" '미성년자 있슴..
			If m_pagree = "N" Then '부모동의 완료 안되었슴.
				totalpagree = "N"
			End if
		End if
	rs.movenext
	Loop	

	'신청자인지 확인
	fieldstr = " requestIDX,titleidx,levelno,gameidx,subtype,entertype, playerIDX,username,teamnm,paymentstate,groupno "
	SQL = "Select "&fieldstr&" from sd_bikeRequest where playerIDX = " & cbike_pidx & " and titleIDX = " & tidx & " and levelno = " & levelIDX
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If rs.eof Then
		'팀원 
		attMember = "N"
	Else
		'신청자
		attMember = "Y"
	End if


'		totaladult = "Y" '미성년여부
'		totalpagree = "Y" '보호자 동의
'		totalagree = "N" '동의여부
'		paystate = "N" '결제여부


'totalpagree = "Y"

	Call oJSONoutput.Set("PA", totalpagree )
	Call oJSONoutput.Set("ATTM", attMember )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"


	db.Dispose
	Set db = Nothing
%>
<div class="after-consent"  id="y19">
  <p class="txt">19세 미만 보호자 동의 확인</p>
</div>
 