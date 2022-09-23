<%
'######################
'참가신청완료
'######################

'REQ = "{"pg":1,"tidx":23,"name":"참가신청","subtype":"1","chkgame":"116,루키:117,CAT3:118,루키:","bikeidx":"4571","marriage":"Y","job":"JOB02","bloodtype":"A","career":"CR001","brand":"BR001","gamegift":"S","CMD":200}"


	If hasown(oJSONoutput, "tidx") = "ok" then
		tidx = oJSONoutput.tidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End If	

	If hasown(oJSONoutput, "subtype") = "ok" Then '개인 , 단체 1,2
		subtype = oJSONoutput.subtype
		If CDbl(subtype) = 1 then
			subtypestr = "개인"
		Else
			subtypestr = "단체"
		End if
	End If
	If hasown(oJSONoutput, "chkgame") = "ok" Then '신청정보   116,루키:117,CAT3:118,루키:  (부에 키값(levelno), 선수등급)
		chkgame = oJSONoutput.chkgame
	End If


	If hasown(oJSONoutput, "bikeidx") = "ok" Then 'bike.tblmember.MemberIDX
		bikeidx = oJSONoutput.bikeidx
	Else
        Call oJSONoutput.Set("result", "1" ) '데이터없슴
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.end
	End if	
	If hasown(oJSONoutput, "marriage") = "ok" Then '결혼유무 N Y
		marriage = oJSONoutput.marriage
	End If
	If hasown(oJSONoutput, "job") = "ok" Then '직업코드
		jobcode = oJSONoutput.job
	End if	
	If hasown(oJSONoutput, "bloodtype") = "ok" then
		bloodtype = oJSONoutput.bloodtype
	End if	
	If hasown(oJSONoutput, "career") = "ok" Then '자전거 경력
		career = oJSONoutput.career
	End if	
	If hasown(oJSONoutput, "brand") = "ok" Then '사용중인 브렌드
		brand = oJSONoutput.brand
	End if	
	If hasown(oJSONoutput, "gamegift") = "ok" Then '사은품
		gamegift = oJSONoutput.gamegift
	End if	

	'동의관련
	If hasown(oJSONoutput, "adult") = "ok" Then '성인미성인 Y N 부모 동의 문자 발송여부
		adult = oJSONoutput.adult
	End if	
	If hasown(oJSONoutput, "agree") = "ok" Then 
		agree = oJSONoutput.agree
	End if	

	If hasown(oJSONoutput, "p_nm") = "ok" Then 
		p_nm = oJSONoutput.p_nm
	End if	
	If hasown(oJSONoutput, "p_phone") = "ok" Then 
		p_phone = oJSONoutput.p_phone
	End if	
	If hasown(oJSONoutput, "p_relation") = "ok" Then 
		p_relation = oJSONoutput.p_relation
	End if	



	If hasown(oJSONoutput, "attmidx") = "ok" Then 'sd_bikeAttmember 키값 (팀맴버동의때사용)
		attmidx = oJSONoutput.attmidx
	End If
	If hasown(oJSONoutput, "LVLIDX") = "ok" Then
		levelIDX = oJSONoutput.LVLIDX
	End if

	'##############################
	Set db = new clsDBHelper

	fieldstr = "MemberIDX,userID,UserName,userPhone,birthday,sex,email,zipcode,address "
	SQL = "select " & fieldstr & " from tblMember where MemberIDX = " & Cookies_midx 
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

	If Not rs.eof Then
	Uidx = rs("MemberIDX")
	userID		= rs("userID")
	UserName		= rs("UserName")
	userPhone		= rs("userPhone")
	birthday		= rs("birthday")
	sex		= LCase(rs("sex"))
	email		= rs("email")
	zipcode		= rs("zipcode")
	address				= rs("address")
	End if

	'전체정보 조회#################
	strWhere = "   a.DelYN = 'N' and b.attmidx = "  & attmidx
	tablename = " sd_bikeLevel as a INNER JOIN v_bikeGame_attm as b ON a .titleIDX = b.titleIDX and a.levelIDX = b.levelno "
	tablename = tablename & " INNER JOIN sd_bikeRequest as c ON b.ridx = c.requestIDX "

	strFieldName = "a.titleIDX,a.levelIDX,a.detailtitle,a.gameday,a.booNM,b.gameidx,b.attmidx,b.playeridx,b.gubun,b.groupno,b.myagree,b.myadult,b.p_agree,b.teamtitle,b.pgrade "
	strFieldName = strFieldName & ",c.paymentstate,c.paymentname,c.attmoney,b.playeridx,c.playeridx as reqpidx,c.requestIDX "
	'strFieldName = "*"
	SQL = "Select top 1 " & strFieldName & " from "&tablename&" where " & strWhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		pidx = rs("playeridx")
		gameidx = rs("gameidx")
		groupno = rs("groupno")
	End if

	'변경내용수정#################
	'SQL = "update tblMember Set MarriageGb = '"&marriage&"' ,Job = '"&jobcode&"' , BloodType = '"&bloodtype&"' , BikeCareer= '"&career&"' , BikeBrand = '"&brand&"' where PlayerReln='R' and PlayerIDX =  " & pidx 
	SQL = "update tblMember Set MarriageGb = '"&marriage&"' ,Job = '"&jobcode&"' , BloodType = '"&bloodtype&"' , BikeCareer= '"&career&"' , BikeBrand = '"&brand&"' where MemberIDX = " & cbike_midx
	Call db.execSQLRs(SQL , null, ConStr)

	'동의 정보 업데이트#################
	SQL = "Update sd_bikeAttMember Set brand='"&brand&"',myagree='Y',p_nm='"&p_nm&"',p_phone='"&p_phone&"',p_relation='"&p_relation&"',giftcode='"&gamegift&"' where attmidx = " & attmidx
	Call db.execSQLRs(SQL , null, ConStr)


	'발송여부확인#################
	If adult = "N" Then
		lmsstr = "*보호자*,"&p_nm&","&p_phone& "^"
		Call oJSONoutput.Set("lms", lmsstr ) '발송정보 아이디,이름,전화번호
		Call oJSONoutput.Set("gameidx", gameidx )
		Call oJSONoutput.Set("gno", Groupno )
	End if		
		
		







	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>						
