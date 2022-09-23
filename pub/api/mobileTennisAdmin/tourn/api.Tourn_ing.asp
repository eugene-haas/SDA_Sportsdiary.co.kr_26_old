<%
'#############################################
'대진표 리그 화면 준비
'#############################################
'request
idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
poptitle = "<span class='tit'>" & title & " " & teamnm & " (" & areanm & ")  본선 진행 대진표</span>"
resetflag = oJSONoutput.RESET 'ok를 받으면 sortNo를 0으로 업데이트 한다.
onemore = oJSONoutput.ONEMORE

courtarea = oJSONoutput.COURTAREA '코트 장소 0 전체

If hasown(oJSONoutput, "roundSel") = "ok" then
  roundsel = oJSONoutput.roundSel 'select 라운드
  if roundsel ="" then
    roundsel=0
  end if
Else
  Call oJSONoutput.Set("roundSel", 0 )
  roundsel=0
End if


Call oJSONoutput.Set("T_M1IDX", 0 )
Call oJSONoutput.Set("T_M2IDX", 0 )
Call oJSONoutput.Set("T_SORTNO", 0 )
Call oJSONoutput.Set("T_RD", 0 )
Call oJSONoutput.Set("S3KEY", 0 )
Call oJSONoutput.Set("RIDX", 0 ) '결과테이블 인덱스
Call oJSONoutput.Set("NOWCTNO", 0 ) '현재 지정된 코트번호

Set db = new clsDBHelper

'기본정보#####################################
  strtable = "sd_TennisMember"
  strtablesub =" sd_TennisMember_partner "
  strtablesub2 = " tblGameRequest "
  strresulttable = " sd_TennisResult "

  SQL = " Select EntryCnt,attmembercnt,courtcnt,level,lastjoono,bigo,endRound,joocnt,lastroundmethod from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.eof then
    entrycnt = rs("entrycnt")         '참가제한인원수
    attmembercnt = rs("attmembercnt")   '참가신청자수
    courtcnt = rs("courtcnt")         '코트수
    levelno = rs("level")             '레벨
    lastjoono = rs("lastjoono")         '마지막에 편성된 max 조번호
    bigo= htmlDecode(   Replace(rs("bigo") ,vbCrLf ,"\n"  ))
    bigo = Replace(bigo ,vbCr ,"\n")
    bigo = Replace(bigo ,vbLf ,"\n")

    endround = rs("endround")         '진행될 최종라운드
    joocnt = rs("joocnt")             '예선에 생성된 조수
    lastroundmethod = rs("lastroundmethod") '최종라운드 방식 1 리그 2 토너먼트

    If Left(levelno,3) = "200" Then
      joinstr = " left "
      singlegame =  true
    Else
      joinstr = " left "
      singlegame = false
    End if
  End if
'기본정보#####################################
rs.close

'최종라운드
lastroundcheck = Right(levelno,3)
tn_last_rd = false

'If lastroundcheck = "007" Then
If lastroundcheck = "007" And  areanm = "최종라운드"  Then
  tn_last_rd = True
  SQL = "select max(tryoutgroupno) from sd_TennisMember where  GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and delYN = 'N' "
  Set rsm = db.ExecSQLReturnRS(SQL , null, ConStr)

  If isNull(rsm(0)) = False Then
    lastjoono = rsm(0)
  End if

  If CDbl(lastroundmethod) = 1 And CDbl(lastjoono) = 1 Then
    Call oJSONoutput.Set("result", 4001 ) '리그1 조로 편성되었습니다.
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.end
  End if

  If CDbl(lastroundmethod) = 1 And CDbl(lastjoono) > 1 Then
    tn_last_rd = False
  End if
End if

If tn_last_rd = False Then '최종라운드 토너먼트가 아니라면
    'endround 2 , 4 ,8 , 16, 32, 64
    Select Case CDbl(endround) '진행될 마지막 라운드
    Case 1,2 : hideRDcnt = 0
    Case 4 : hideRDcnt = 1
    Case 8 : hideRDcnt = 2
    Case 16 : hideRDcnt = 3
    Case 32 : hideRDcnt = 4
    Case 64 : hideRDcnt = 5
    Case 128 :  hideRDcnt = 6
	Case 256 :  hideRDcnt = 7 '일단넣어둠 없어서
    End Select
Else '최종라운드
  drowCnt = 4
  depthCnt = 3
End if

  '###################################
    jooidx = CStr(tidx) & CStr(levelno) '생성된 추첨룰이 있다면
    SQL = "Select top 1 orderno,sortno,joono,mxjoono,idx     ,gang,round from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.eof Then
        drowCnt=rs("gang")
        depthCnt = rs("round")
    depthCnt = CDbl(depthCnt - hideRDcnt)
  End if
  '###################################


If CDbl(levelno) = 20104001 And CDbl(tidx) = 32 Then
	drowCnt=128
	depthCnt = 8
	depthCnt = CDbl(depthCnt - hideRDcnt)
End If








 '짝지어진 팀들 날짜동일하게 업데이트 (장소도)
  strwhere = " GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno  & " and gubun >= 2  " 'TOURNSET 2 본선대기 3 본선입력완료
  strsort = " order by Round asc,SortNo asc"
  strfield = " gamememberIDX,Round, SortNo, writedate ,userName,CONVERT(CHAR(23),writedate, 21),playerIDX,place "

  SQL = "select "& strfield &" from  " & strtable & " where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  rscnt =  rs.RecordCount

  If Not rs.EOF Then
  arrT = rs.getrows()
  End If

  Sub setUpdateTime(ByVal arrT, ByVal rd, ByVal sortno)
    Dim ar ,midx,mrd,m1name,msortno,m2name,writeday,oddtime,eventime,addmidx,evenidx,writedatestr,oddstr,evenstr
	Dim upSQL,SQL,pidx,place
	Dim oddmidx,evenmidx

    If IsArray(arrT) Then

        For ar = LBound(arrT, 2) To UBound(arrT, 2)
          midx     = arrT(0, ar)
          mrd    = arrT(1, ar)
          msortno  = arrT(2, ar)
          writeday = arrT(3 ,ar)
          m1name   = arrT(4, ar)
          writedatestr = arrT(5 ,ar)
		  pidx = arrT(6 ,ar)
		  place = arrT(7 ,ar)

      If (place = "" Or isNull(place) = True) And CDbl(pidx) > 1 Then '복사안된 선수 복사.
        '업데이트
        upSQL = " select top 1 place from " & strtable & " where PlayerIDX = " & pidx & " and GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno  & " and gubun in (0,1) and delYN = 'N' "
        SQL = "update " & strtable & " Set place = ( "&upSQL&" ) where gamememberIDX = " & midx
        Call db.execSQLRs(SQL , null, ConStr)
      End if



          If CDbl(rd) = CDbl(mrd) And (CDbl(msortno) = CDbl(sortno) Or CDbl(msortno) = CDbl(sortno)-1) Then

            If m1name = "부전" Or  m1name = "--" Then
              'Response.write "준비안됨 <br>"
              Exit For
            End if

            If CDbl(msortno) = CDbl(sortno)-1 then
              '홀수번 생성시간 (없을수도 체크)
              oddmidx = midx
              oddtime = writeday
              oddstr = writedatestr
            Else
              evenmidx = midx
              eventime = writeday
              evenstr = writedatestr
              '짝수번 생성시간
            End if

            If CDbl(msortno) = CDbl(sortno) Then
              If oddtime = "" Or eventime = "" Then
                'Response.write "준비안됨2 <br>"
              Else
                If Cdate(oddtime) > CDate(eventime) Then
                  SQL = "update sd_TennisMember Set writedate = '"&oddstr&"' where gamememberIDX = " & evenmidx
                  Call db.execSQLRs(SQL , null, ConStr)
                Else
                  SQL = "update sd_TennisMember Set writedate = '"&evenstr&"' where gamememberIDX = " & oddmidx
                  Call db.execSQLRs(SQL , null, ConStr)
                End If
                  SQL = "update sd_TennisMember Set stateno = 1,place='"&place&"' where gamememberIDX in ( " & oddmidx & "," & evenmidx  & " ) "
                   Call db.execSQLRs(SQL , null, ConStr)
              End if
              'Response.write rd & "RD " & SQL & " " & m1name &" <br>"
              Exit for
            End If

          End If
         Next

    End If
  End sub

  '본선 강별  홀짝 정보의 생성을 늦은쪽으로 동기화 시킨다.
    For i = 1 To depthCnt
      If i = 1 then
        roundcnt = Fix(drowCnt)
      Else
        roundcnt = Fix(roundcnt/2)
      End If

      if cdbl(roundsel) = cdbl(roundcnt) or cdbl(roundsel)/2 = cdbl(roundcnt) or (Cdbl(roundsel)<=4 and cdbl(roundsel) >= cdbl(roundcnt))  or cdbl(roundsel)=0 then
          For n = 1 To roundcnt
            If n Mod 2 = 0 Then '짝수줄 만 호출
              Call setUpdateTime(arrT, i, n)
            End if
          next
      end if
    Next
 '짝지어진 팀들 날짜동일하게 업데이트



'본선 정보 쿼리 재호출 (이거 장소에 맞추어서)

  If courtarea = "0" then
    strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and stateno = 1 and a.gubun >= 2  " 'TOURNSET 2 본선대기 3 본선입력완료 (짝이 있다면 stateno = 1)
  Else
    strwhere = " a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and stateno = 1 and a.gubun >= 2  and place like '" & courtarea & "%' "
  End if

  strsort = " order by round asc,a.writedate asc,  SortNo asc"
  strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
  strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno,a.place,a.writedate, a.ABC "
  strfield = strAfield &  ", " & strBfield

  SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  rscnt =  rs.RecordCount

If USER_IP = "118.33.86.240" Then
'Response.write sql
' Call rsdrow(rs)
' Response.end
End if

  If Not rs.EOF Then
  arrT = rs.getrows()
  End If
'본선 정보 쿼리 재호출





'스코어 입력 정보 가져오기 ( 코트 정보를 가져와야 하는구나 여기부터 작업 ~~~~~
'#############################
  strwhere = " a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelno  & " and a.gubun >= 2  and b.delYN = 'N' " 'a.gubun 상태  0예선, 1 예선종료 gubun 2 본선 올라감 3 본선 대진표 설정완료 b.stateno 경기종료
  strsort = " order by  a.Round asc, a.SortNo asc"
  strAfield = "  a.gamememberIDX, a.Round , a.SortNo,b.courtno,b.waitcourtno  " '열 인덱스(기준)
  strBfield = " b.gameMemberIDX2 , b.resultIDX , b.stateno ,winResult,b.courtno,a.playerIDX " '인덱스 , 짝수 인덱스(대상) ,게임상태 ( 2, 진행 , 1, 종료)
  strfield = strAfield &  ", " & strBfield

  SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1   where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  'Call rsdrow(rs)
  'Response.end

  If Not rs.EOF Then
    arrRS = rs.GetRows() 'RIDX, CIDX, GSTATE
  End if

'#############################

'코트정보
'#############################
  SQL = "select idx,no,courtname,courtuse,courtstate,areaname,settime from sd_TennisCourt where gameTitleIDX = " & tidx & " and levelno = " & levelno & " and courtuse = 'Y'  order by areaname,idx "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql
'Call rsdrow(rs)
'Response.end

  If Not rs.EOF Then
    arrCT = rs.getrows()
  End If


  SQL = "select areaname,count(*) from sd_TennisCourt where gameTitleIDX = " & tidx & " and levelno = " & levelno & " and courtuse = 'Y'  group by areaname"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
    arrAR = rs.getrows()
  End If



'#############################


'function
'#############################
	Function chkResultTurn(arrRS, lsatdepth, chkrd, chkpidx ,ridx)
		Dim nextrd, pidx,ar, chk ,SQL

		nextrd = CDbl(chkrd) + 1

		If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
			pidx = arrRS(11, ar)
			If lsatdepth > nextrd Then
				'검사할필요없음.
				chk = "OK"
				Exit for
			Else
				If CStr(pidx) = CStr(chkpidx) Then
					'존재해 검사 끝
					chk = "OK"
					Exit for
				End If
			End if
		Next

			If chk = "" Then
				SQL = "delete from sd_tennisResult where resultIDX = " & ridx
				Call db.execSQLRs(SQL , null, ConStr)
				'결과값 지워 ridx delete
				chkResultTurn =  True
			Else
				chkResultTurn =  False
			End If

		End if

	End Function

'########
	'm1pidx      = arrRS(11, ar)  가 다음 라운드에 존해하지는 조사해보자.
	'For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 에서 다음 라운드 pidx 가 있난 찾아보는 펑션을 만들면 되지 않을까 ...... 다음 라운드는 mrd + 1 '마지막 라운드
	'depthno 진행될 마지막 라운드 번호
	'	nextrd = CDbl(rd) + 1
	'	If depthno > nextrd Then
			'검사하지마
	'	Else
			'm1pidx 가 있는지 보자
	'		If rd = nextrd Then
	'			If pidx = m1pidx Then
					'있네 검사끝
	'				Exit For
	'			else
					'없어 결과를 지워 (업데이트 할라다가 ) 깨끗이 지워 (ridx 받아와야겠다_
	'			End if
	'		End If
	'	End if
	'Next
'########





  waitorderno = 1

  Sub tournInfo_ing(ByVal arrRS , ByVal rd , ByVal sortno, ByVal arrRT, ByVal rdstr , ByVal crs , ByVal depthno) ' 대진표배열 , 라운드 , 소트, 스코어입력배열, 코트배열
    Dim ar ,at, ct, m1idx,m1name,mrd,msortno,m2idx,m2name,m1pidx,cnt,r_midx,r_stateno,ridx
    Dim chkpass,chkcnt
    Dim waitmode, ct_idx, ct_no, ct_courtname, ct_courtstate,rcourtidx,waitcourtidx           ,tst,tst2,ct_courtarea,playerplace
    Dim wdate,hh,mm,ss,ct_courtsettime,settimecolor, abc
    settimecolor = "#47A5EC" '매칭되었을때 색

    chkpass = True

    If IsArray(arrRS) Then
    cnt = 1
    chkcnt = 0 '짝이 있는지

    For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
	  m1pidx      = arrRS(11, ar)
      m1idx       = arrRS(0, ar)
      m1name      = arrRS(1, ar)
      mrd         = arrRS(4, ar)
      msortno     = arrRS(5, ar)

      If isnumeric(msortno) = False Then
      Exit sub
      End if
      'Response.write msortno &"--"
      'Response.end

      If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno)-1 Then
      m1idx = m1idx
	  m1pidx = m1pidx
      End If
      If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno) Then
      m2idx = m1idx
      End if

      '출력 조건 검사
        If CDbl(rd) = CDbl(mrd) And (CDbl(msortno) = CDbl(sortno) Or CDbl(msortno) = CDbl(sortno)-1) Then
      chkcnt = chkcnt + 1
      If m1name = "부전" Or  m1name = "--" Or m1name = "" Then
        chkpass = False
        Exit For
      End If

      '종려된 경기인지 확인 --여기서 다음라운드에 등록되었는지 확인하고 진짜종료되었는지 확인 (여기 인덱스가 다음 라운드에 있는지 확인하고 없다면 삭제)

      If IsArray(arrRT) Then '결과테이블에서
        For at = LBound(arrRT, 2) To UBound(arrRT, 2)
        r_midx      = arrRT(0, at)  '1번맴버인덱스
        r_stateno      = arrRT(7, at)  ' 1경기종료
		'ridx = arrRT(6,at) '결과인덱스

        If CDbl(r_midx) = CDbl(m1idx) Then
          If CDbl(r_stateno) = 1  Then

				  'chkpass = chkResultTurn(arrRS, depthno, rd, m1pidx ,ridx)
				  'If chkpass = False Then
					'Exit For
				  'Else
					' rcourtidx = arrRT(3, at)
					'waitcourtidx = arrRT(4,at)
				 'End if

				  chkpass = False
				  Exit For

          Else '진행중
			  rcourtidx = arrRT(3, at)
			  waitcourtidx = arrRT(4,at)
			  ridx = arrRT(6,at) '결과인덱스
          'Response.write rcourtidx & "#################<br>"
          End if
        End if
        Next
      End if

      End if
    Next
     End If

     '------------------------
    If ridx = "" Then
    ridx = 0
    End If
    If rcourtidx = "" Then
    rcourtidx = 0
    End If

    'If chkpass = False Then
    'Response.write tst & " - " & tst2 & "<br>"
    If chkpass = True And chkcnt > 1 then
    If IsArray(arrRS) Then
      cnt = 1
    For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
      m1pidx      = arrRS(11, ar)
      m1idx       = arrRS(0, ar)
      m1name      = arrRS(1, ar)
      mrd         = arrRS(4, ar)
      msortno     = arrRS(5, ar)
      m2name      = arrRS(6, ar)
      playerplace  = arrRS(16,ar)
      wdate = arrRS(17, ar)
	    abc = arrRS(18,ar) '조(장소구분) 구분 영문
      hh = hour(wdate)
      mm = minute(wdate)
      ss = Second(wdate)

      If IsArray(crs) Then
        For ct = LBound(crs, 2) To UBound(crs, 2)
          ct_idx = crs(0,ct)
          ct_courtsettime = crs(6,ct)

          If CDbl(rcourtidx) > 0 And CDbl(rcourtidx) = CDbl(ct_idx) Then
            If isdate(ct_courtsettime) = True Then
              settimecolor = "green" '매칭시간
              hh = hour(ct_courtsettime)
              mm = minute(ct_courtsettime)
              ss = Second(ct_courtsettime)
            End If
          End If
        Next
      End If

      If CDbl(rd) = CDbl(mrd) And (CDbl(msortno) = CDbl(sortno) Or CDbl(msortno) = CDbl(sortno)-1) Then

      If  CDbl(cnt) = 1 then%>
      <li class="tryout-match__list clear <%If rcourtidx > 0 then%>s_on<%End if%>" >
        <div class="tryout-match__list__header">
          <h3>대기순번 <em><%=waitorderno%></em></h3>
          <span>지정/매칭 <strong style="color:<%=settimecolor%>"><%=hh%>:<%=mm%>:<%=ss%></strong></span>
          <span><em><%=rdstr%></em>강</span>
        </div>
        <%
        oJSONoutput.T_M1IDX = m1idx
        oJSONoutput.T_M2IDX = m2idx
        oJSONoutput.T_RD = rd
        oJSONoutput.T_SORTNO = sortno
        oJSONoutput.S3KEY = levelno
        oJSONoutput.RIDX = ridx
        oJSONoutput.NOWCTNO = rcourtidx '현재코트인덱스
        strjson = JSON.stringify(oJSONoutput)
        %>
        <div class="tryout-match__list__selc_header"><span><strong><%=abc%></strong> 코트</span></div>
        <div class="tryout-match__list__selc-box selc-box">
          <select id="gcourt_<%=rd%>_<%=sortno%>"  onchange='mx.tourn_court("<%=rd%>_<%=sortno%>",<%=strjson%>)' style="width:85%;">
              <%
                waitmode = "yes"
                If IsArray(crs) Then
                  For ct = LBound(crs, 2) To UBound(crs, 2)
                    ct_idx = crs(0,ct)
                    ct_no = crs(1,ct)
                    ct_courtname = crs(2,ct)
                    ct_courtstate = crs(4,ct)
                    ct_courtarea = crs(5,ct)
                    ct_courtsettime = crs(6,ct)

                    If CDbl(rcourtidx) > 0 And CDbl(rcourtidx) = CDbl(ct_idx) Then
                      '코트 지정시간
                      If isdate(ct_courtsettime) = True Then
                        settimecolor = "green" '매칭시간
                        hh = hour(ct_courtsettime)
                        mm = minute(ct_courtsettime)
                        ss = Second(ct_courtsettime)
                      End If

                      Response.write "<option value='"&ct_idx&"' selected>"& ct_courtarea & "&nbsp;" & ct_courtname&"</option>"
                      waitmode = "no"
                    Else
                      If CDbl(ct_courtstate) = 0 Then '사용가능한 코트
                        Response.write "<option value='"&ct_idx&"'>"& ct_courtarea & "&nbsp;" & ct_courtname&"</option>"
                      End if
                    End if
                  Next
                End If
              %>
              <option <%If waitmode = "yes" then%>selected<%End if%> value="0">대기중</option>
          </select>
        </div>

        <%
        waitorderno = waitorderno + 1
        End If
        %>

        <%If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno)-1 then%>
          <div class="tryout-match__list__result">
            <div class="tryout-match__list__result__selc-box">
              <select id="scoreA_<%=m1idx%>">
                <option value="0" selected>-</option>
                <option value="0">0</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
                <option value="9">9</option>
                <option value="10">10</option>
              </select>
            </div>
            <h4><%=Left(m1name,4)%><br><%=Left(m2name,4)%></h4>
            <button type="button" name="button"
              onclick='mx.tourn_win("<%=Left(m1name,4)%>,<%=Left(m2name,4)%>",<%=m1idx%>,<%=strjson%>)'
            >
            </button>
          </div>
        <%End if%>

        <%If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno) then%>
          <div class="tryout-match__list__result">
            <div class="tryout-match__list__result__selc-box">
              <select id="scoreB_<%=m2idx%>">
                <option value="0">-</option>
                <option value="0">0</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
                <option value="9">9</option>
                <option value="10">10</option>
              </select>
            </div>
            <h4><%=Left(m1name,4)%><br><%=Left(m2name,4)%></h4>
            <button type="button" name="button"
              onclick='mx.tourn_win("<%=Left(m1name,4)%>,<%=Left(m2name,4)%>",<%=m2idx%>,<%=strjson%>)'
            >
            </button>
          </div>
        <%End if%>

      <%If cnt = 2 then%>
      </li>
      <%End if%>

      <%
      If cnt = 2 then
        Exit For
      End If

      cnt = CDbl(cnt) + 1
      End If
    Next

    End If
    End if

  End Sub
'#############################
%>

<header class="header clear">
  <div class="header__side-con">
    <button class="header__side-con__btn" type="button" name="button">대회정보관리</button>
    <a href="./mobile_index.asp" class="header__side-con__btn header__btn-home t_ico"><img src="./Images/mobile_ico_home.svg" alt="홈"></a>
    <button onclick="closeModal()" class="header__side-con__btn header__btn-cancel t_ico"><img src="./Images/mobile_ico_close.svg" alt="닫기"></a>
  </div>
  <h1 class="header__main-con"><%=poptitle%></h1>
  <div class="header__side-con">
    <button class="header__side-con__btn header__btn-reset t_ico" id="reloadbtn"
      onclick="mx.tournament_ing(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel')">
      <img src="./Images/mobile_ico_reset.svg" alt="새로고침" >
    </button>
  </div>
</header>
<div class="l_modal__con tryout-match">
  <div class="tryout-match__seach">
    <div class="tryout-match__seach__selc-box selc-box">
      <h2><strong class="hide">코트명 선택</strong></h2>
      <select id="court_areaname" onchange="mx.tournament_ing(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel')">
      <option value="0" <%If courtarea = "0" then%>selected<%End if%>>코트명 선택</option>
        <%
        If IsArray(arrAR) Then
          For ar = LBound(arrAR, 2) To UBound(arrAR, 2)
              areaname  = arrAR(0, ar)
              areacnt = arrAR(1,ar)

              If courtarea = Left(areaname,Len(courtarea)) Then
              areaselected = "selected"
              Else
              areaselected = ""
              End if
              Response.write "<option value="""&areaname&""" "&areaselected&">" & areaname & " (" & areacnt &  ")</option>"
          Next
        End if
        %>
      </select>
    </div>
    <div class="tryout-match__seach__selc-box selc-box">
      <h2><strong class="hide">진행중</strong></h2>
      <select name="" onchange="mx.change_tourn_list(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel', $(this))">
        <option value="ing" selected>진행중</option>
        <option value="end">완료</option>
      </select>
    </div>
    <button type="button" name="button" onclick="mx.tournament_table(<%=idx%>,'<%=teamnm%>','<%=areanm%>')">대진표</button>
  </div>
  <h2><strong class="hide">리스트 시작</strong></h2>
  <ul>

      <%'본선#################%>
      <%
          If IsArray(arrT) Then

            For ar = LBound(arrT, 2) To UBound(arrT, 2)
              m1idx     = arrT(0, ar)
              m1name    = arrT(1, ar)
              mrd     = arrT(4, ar)
              msortno   = arrT(5, ar)

              If isnumeric(msortno) = True then
              If CDbl(msortno) Mod 2 = 0 then

                Select Case CDbl(mrd)
                Case 1 : roundcnt = Fix(drowCnt)
                Case 2 : roundcnt = Fix(drowCnt/2)
                Case 3 : roundcnt = Fix(drowCnt/2/2)
                Case 4 : roundcnt = Fix(drowCnt/2/2/2)
                Case 5 : roundcnt = Fix(drowCnt/2/2/2/2)
                Case 6 : roundcnt = Fix(drowCnt/2/2/2/2/2)
                Case 7 : roundcnt = Fix(drowCnt/2/2/2/2/2/2)
                Case 8 : roundcnt = Fix(drowCnt/2/2/2/2/2/2/2)
                Case 9 : roundcnt = Fix(drowCnt/2/2/2/2/2/2/2/2)
                Case 10 : roundcnt = Fix(drowCnt/2/2/2/2/2/2/2/2/2)
                End Select

              Call tournInfo_ing(arrT, mrd, msortno, arrRS, roundcnt,arrCT ,depthCnt ) ' 대진표배열 , 라운드 , 소트, 스코어입력배열, 코트배열 ,진행될 마지막 라운드 번호
              End If
              End if
            Next

          End if
      %>
      <%'본선#################%>
  </ul>
</div>





<%
db.Dispose
Set db = Nothing
%>
