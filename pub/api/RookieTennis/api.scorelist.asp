<%
	gameidx = oJSONoutput.SCIDX	'결과테이블 인덱스
	p1idx = oJSONoutput.P1				'맴버 1 인덱스
	p2idx = oJSONoutput.P2				'맴버 2 인덱스
	gubun = oJSONoutput.GN			'예선 구분 0
	s2key = oJSONoutput.S2KEY		'단식 복식 구분
	entertype = oJSONoutput.ETYPE '엘리트 E 아마추어 A

	startsc = oJSONoutput.STARTSC '시작점수
	tiesc = oJSONoutput.TIESC '타이블레이크룰 점수
	deucest = oJSONoutput.DEUCEST '듀스 상태 0: 기본룰 ,1: 노에드, 2: 1듀스 노에드

	If s2key = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " inner "
		singlegame = false
	End if  

	Set db = new clsDBHelper
	Set skilldef =Server.CreateObject("Scripting.Dictionary")
	'결과 다음 기술1
	skilldef.ADD  "IN", 2
	skilldef.ADD  "ACE", 2
	skilldef.ADD  "NET", 2
	skilldef.ADD  "OUT", 2

	'선수선택으로
	skilldef.ADD  "퍼스트서브", 0
	skilldef.ADD  "세컨서브", 0
	skilldef.ADD  "기타", 0
	skilldef.ADD  "스매싱", 0

	skilldef.ADD  "F.리턴", 3
	skilldef.ADD  "F.스트로크", 3
	skilldef.ADD  "F.발리", 3
	skilldef.ADD  "B.리턴", 3
	skilldef.ADD  "B.스트로크", 3
	skilldef.ADD  "B.발리", 3

	skilldef.ADD  "크로스", 0
	skilldef.ADD  "스트레이트", 0
	skilldef.ADD  "로브", 0
	skilldef.ADD  "역크로스", 0
	skilldef.ADD  "센터", 0
	skilldef.ADD  "쇼트", 0

	strtable = " sd_TennisMember "
	strtablesub =" sd_TennisMember_partner "
	strwhere = "  a.gamememberIDX = " & p1idx & " or a.gamememberIDX = " & p2idx

	If gubun = "0" Then
	strsort = " order by a.tryoutsortno asc"
	else
	strsort = " order by a.SortNo asc"
	End If


	strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aNTN, a.teamBNa as aBTN, a.Round as COL, a.SortNo as ROW  "
	strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN, b.positionNo "
	strfield = strAfield &  ", " & strBfield

	SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rs.RecordCount
	ReDim JSONarr(rscnt-1)

	i = 0
	Do Until rs.eof
		Set rsarr = jsObject() 
		rsarr("AID") = rs("gamememberIDX")
		rsarr("ANM") = rs("aname")
		'rsarr("GNO") = rs("groupno")

		rsarr("CO") = rs("COL")
		rsarr("RO") = rs("ROW")

		rsarr("ATANM") = rs("aNTN")
		rsarr("ATBNM") = rs("aBTN")
		rsarr("BID") = rs("partnerIDX")
		rsarr("BNM") = rs("bname")
		rsarr("BTANM") = rs("bATN")
		rsarr("BTBNM") = rs("bBTN")
		rsarr("PNO") = rs("positionNo") ' 파트너의 시작위치 정보 

		Set JSONarr(i) = rsarr
	  i = i + 1
	rs.movenext
	Loop

	teamcnt = Ubound(JSONarr)

	jsonstr = toJSON(JSONarr)
	Set ojson = JSON.Parse(jsonstr)

	'///////////////////////////////////////

      Set tuser =Server.CreateObject("Scripting.Dictionary")
      Set tuserkey =Server.CreateObject("Scripting.Dictionary")

      n = 0
      for i = 0 to teamcnt
        mem1idx = ojson.Get(i).AID
        mem2idx = ojson.Get(i).BID
        aname = ojson.Get(i).ANM
        bname = ojson.Get(i).BNM

        ateamA = ojson.Get(i).ATANM
        ateamB = ojson.Get(i).ATBNM
        bteamA = ojson.Get(i).BTANM
        bteamB = ojson.Get(i).BTBNM

        If i = 0 Then
          pcolor = "orange"
        Else
          pcolor = "green"
		End if

        'tuser = 키 : 0,1 값  idx _ name_color
		If singlegame =  True Then
			tuser.Add n, mem1idx & "#$" & aname  & "#$" & pcolor
			tuserkey.Add mem1idx , aname  & "#$" &  pcolor  
        Else
			tuser.Add n, mem1idx & "#$" & aname & "#$" & pcolor
			n = n + 1
			tuser.Add n, mem2idx & "#$" & bname & "#$" & pcolor
			n = n + 1

			tuserkey.Add mem1idx , aname  & "#$" & pcolor   
			tuserkey.Add mem2idx , bname  & "#$" & pcolor  
        End if
      Next
%>
<!-- #include virtual = "/pub/api/inc/incapi.scorelist.asp" -->