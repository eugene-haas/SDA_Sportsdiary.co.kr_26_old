<%
'#############################################
'대진표 리그 화면 준비
'#############################################

'request

'룰생성후 사용가능 룰을 먼저 생성해주세요.....
'룰이 변경되었을 경우에 대한 처리 (룰 다시 반영 버튼 필요) 룰반영 버튼 ( 새로 고침 버튼 필요)

idx = oJSONoutput.IDX
tidx = oJSONoutput.TitleIDX
title = oJSONoutput.Title
teamnm = oJSONoutput.TeamNM
areanm = oJSONoutput.AreaNM
poptitle = "<span class='tit'>" & teamnm & " (" & areanm & ")</span>"
'resetflag = oJSONoutput.RESET 'ok를 받으면 sortNo를 0으로 업데이트 한다.
'onemore = oJSONoutput.ONEMORE


If hasown(oJSONoutput, "roundSel") = "ok" then
  roundsel = oJSONoutput.roundSel 'select 라운드
  if roundsel ="" then
    roundsel=0
  end if
Else
  Call oJSONoutput.Set("roundSel", 0 )
  roundsel=0
End if


Call oJSONoutput.Set("T_MIDX", 0 )
Call oJSONoutput.Set("T_SORTNO", 0 )
Call oJSONoutput.Set("T_DIVID", 0 )

Call oJSONoutput.Set("T_ATTCNT", 0 )
Call oJSONoutput.Set("T_NOWRD", 0 )
Call oJSONoutput.Set("T_RDID", 0 )
Call oJSONoutput.Set("S3KEY", 0 )

Call oJSONoutput.Set("SCIDX", 0 ) '결과테이블 인덱스
Call oJSONoutput.Set("POS", 0 )

Set db = new clsDBHelper



'기본정보#####################################
  strtable = "sd_TennisMember"
  strtablesub =" sd_TennisMember_partner "
  strtablesub2 = " tblGameRequest "
  strresulttable = " sd_TennisResult "


  SQL = " Select EntryCnt,attmembercnt,courtcnt,level,lastjoono,bigo,endRound,joocnt,lastroundmethod,JooDivision,JooArea from   tblRGameLevel  where    DelYN = 'N' and  RGameLevelidx = " & idx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.eof then
    entrycnt = rs("entrycnt")         '참가제한인원수
    attmembercnt = rs("attmembercnt")   '참가신청자수
    courtcnt = rs("courtcnt")         '코트수
    levelno = rs("level")             '레벨
  oJSONoutput.S3KEY = levelno
    lastjoono = rs("lastjoono")         '마지막에 편성된 max 조번호

    endround = rs("endround")         '진행될 최종라운드
    joocnt = rs("joocnt")             '예선에 생성된 조수
    lastroundmethod = rs("lastroundmethod") '최종라운드 방식 1 리그 2 토너먼트
    poptitle = poptitle '& " <span class='txt'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"

      joinstr = " left "
  End If

  '조나누기 관련##
    JooDivision = rs("JooDivision")'예선조나누기
    JooArea = rs("JooArea")
    endgroup = joocnt

    if(Cdbl(JooDivision) <> 1) Then
      jorder = fc_tryoutGroupMerge(endgroup,JooDivision, JooArea)
      IsChangeJoo =True
    End If
  '조나누기 관련##

rs.close
'기본정보#####################################



'최종라운드
lastroundcheck = Right(levelno,3)
If lastroundcheck = "007" And  areanm = "최종라운드"  Then
else
  jooidx = CStr(tidx) & CStr(levelno) '생성된 추첨룰이 있다면 최종라운드가 아니라면
  SQL = "Select orderno,sortno,joono,mxjoono,idx     ,gang,round,ABC from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If rs.eof then
    Call oJSONoutput.Set("result", "9090" ) '본선대진룰이 생성되지 않음
    strjson = JSON.stringify(oJSONoutput)
    Response.Write strjson
    Response.End
  End If
  rs.close
End If



'최종라운드
tn_last_rd = false
If lastroundcheck = "007" And  areanm = "최종라운드"  Then
  tn_last_rd = True

  SQL = "select max(tryoutgroupno) from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and delYN = 'N' "
  Set rsm = db.ExecSQLReturnRS(SQL , null, ConStr)

  If isNull(rsm(0)) = False Then
    lastjoono = rsm(0)
  End If
  rsm.close

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

  '예선총명수로 참가자 명수 확정
	SQL = "SELECT top 1 joocnt from tblRGameLevel where gametitleidx ='"&tidx&"' and level = '"&levelno&"' and delYN='N' "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    t_joocntStr = 0
	tcnt = 0
	If Not rs.eof Then
		t_joocntStr = rs(0)
		tcnt = CDbl(rs(0)) * 2
	End If
	rs.close

	teststr = tcnt
  '예선총명수로 참가자 명수 확정

    'endround 2 , 4 ,8 , 16, 32, 64
    Select Case CDbl(endround) '진행될 마지막 라운드
		Case 1,2 : hideRDcnt = 0
		Case 4 : hideRDcnt = 1
		Case 8 : hideRDcnt = 2
		Case 16 : hideRDcnt = 3
		Case 32 : hideRDcnt = 4
		Case 64 : hideRDcnt = 5
		Case 128 : hideRDcnt = 6
    End Select

  '강수 계산##############
		if tcnt <=2 then
		drowCnt = 2
		depthCnt = 2
		elseif tcnt >2 and tcnt <=4 then
		drowCnt = 4
		depthCnt = 3
		elseif tcnt >4 and tcnt <=8 then
		drowCnt=8
		depthCnt = 4
		elseif tcnt >8 and  CDbl(tcnt) <=16 then
		drowCnt=16
		depthCnt = 5
		elseif tcnt >16 and  tcnt <=32 then
		drowCnt=32
		depthCnt = 6
		elseif tcnt >32 and  tcnt <=64 then
		drowCnt=64
		depthCnt = 7
		elseif tcnt >64 and  tcnt <=128 then
		drowCnt=128
		depthCnt = 8
		elseif tcnt >128 and  tcnt <=256 then
		drowCnt=256
		depthCnt = 9
		end if
   '###################################
    jooidx = CStr(tidx) & CStr(levelno) '생성된 추첨룰이 있다면
    SQL = "Select top 1 orderno,sortno,joono,mxjoono,idx     ,gang,round,ABC from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.eof Then
        drowCnt=rs("gang")
        depthCnt = rs("round")
	End If
	rs.close
   '###################################

    If CDbl(levelno) = 20104001 And CDbl(tidx) = 32 Then
        drowCnt=128
        depthCnt = 8
    End If

  '동운배 신인부 예외처리
      If usechk = True then
      If CDbl(levelno) = 20104006 And CDbl(tidx) = 4 Then
        drowCnt=128
        depthCnt = 8
        joono =  1080
        End If

        If CDbl(levelno) = 20104002 And CDbl(tidx) = 4 Then
        drowCnt=64
        depthCnt = 7
        joono = 1048
        End If
      End if
    '동운배 신인부 예외처리

  '강수 계산##############

    depthCnt = CDbl(depthCnt - hideRDcnt)

  '예선정보
  '#############################
	maxgno = t_joocntStr

    strwhere = " a.GameTitleIDX = '"&tidx&"' and  a.gamekey3 = '"&levelno&"' and a.tryoutgroupno > 0 and a.gubun = '1' and a.t_rank in ('1','2')"
    strsort = " order by a.tryoutgroupno asc, a.t_rank asc" '결과순
    strAfield = " a. gamememberIDX, a.userName , a.tryoutgroupno, a.tryoutsortno, a.teamAna , a.teamBNa , a.tryoutstateno, a.t_rank,a.key3name "
    strBfield = " b.partnerIDX, b.userName, b.teamANa  , b.teamBNa , b.positionNo     ,a.rndno1,a.rndno2,a.place "
    strfield = strAfield &  ", " & strBfield

    SQL = "select "& strfield &" from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    If Not rs.EOF Then
    arrL = rs.getrows()
    End If
	rs.close


  '#############
  '소팅번호 부여
  '#############



    '아래함수 변수로 사용
    strWhere = " GameTitleIDX = '"&tidx&"' and gamekey3 = '"& levelno & "' and gubun in (2,3)  and DelYN = 'N' and Round = '1' "
    '=============

		jooidx = CStr(tidx) & CStr(levelno) '생성된 추첨룰이 있다면
		'바이자리 정보 가져오기
		SQL = "Select orderno,sortno,joono,mxjoono,idx     ,gang,round,ABC from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' and orderno = 0"
		Set rsbye = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rsbye.eof Then
		  arrBYE = rsbye.GetRows()
		End If
		rsbye.close

		'추첨룰 가져오기 (본선 룰 다시 가져오기)
		SQL = "Select orderno,sortno,joono,mxjoono,idx     ,gang,round,ABC from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
		Set rsrndno = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rsrndno.eof then
		  arrRND = rsrndno.GetRows()
		End If
		rsrndno.close


		'If dlrjtms = "여기서편성하는거그만" Then '예선에서 자리잡읍시다.

			'진출자중 소팅번호가 0인게 있다면
			SQL = "SELECT top 1 sortno FROM sd_TennisMember  WHERE delYN = 'N' and GameTitleIDX = '"&tidx&"' and gamekey3 = '"& levelno & "' and gubun in (2,3)  and Round = 1 and playerIDX > 1 and sortNo = 0"
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.eof Then
			  strwhere = " GameTitleIDX = "&tidx&" and  gamekey3 = "&levelno&" and gubun in (2,3)  and Round = 1 and playerIDX > 1 and sortNo = 0 and delYN = 'N' "
			  SQL = "SELECT gameMemberIDX , userName,t_rank,rndno1,rndno2,tryoutgroupno,gubun FROM  " &strtable&   " where " & strWhere & " and sortNo = 0  ORDER BY gameMemberIDX ASC"
			  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			  n = 0
			  Do Until rs.EOF
				 midx = rs("gameMemberIDX")
				 rank = rs("t_rank")
				 rndno1 = rs("rndno1")
				 rndno2 = rs("rndno2")
				 joono = rs("tryoutgroupno")
				 gubun = rs("gubun")
				 username = rs("username")

			  rs.movenext
			  n = n + 1
			  Loop
			  rs.close
			  Set rs = Nothing
			End if

			'예선 조번호 찾기
			SQL = "select  tryoutgroupno,max(rndno1)as r1,MAX(rndno2) as r2 from sd_TennisMember where gubun in (0,1) and  GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & "  group by tryoutgroupno "
			Set rsj = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rsj.eof then
			arrJ = rsj.GetRows()
			End If
			rsj.close
		'End if
	'#############




Else '최종라운드
 '선수 명수 확인 4이면
  SQL = "select max(sortno) from " &strtable&   " where GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and DelYN = 'N' and Round = 1"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  If Not rs.eof Then
	lastmaxsno = rs(0)
  Else
	lastmaxsno = 4
  End If
  rs.close

  If CDbl(lastmaxsno) > 4 Then
  drowCnt = 8    '4강에서 추첨을 다시한다 그래서 4강고정 (8강그리고 4강에서 다시 편성가능하다록?)
  depthCnt = 4
  Else
	  If CDbl(lastmaxsno) = 4 Then
		  drowCnt = 4
		  depthCnt = 3
	  Else
		  drowCnt = 2
		  depthCnt = 2
	  End if
  End if

  '만약 8강이라면 어떻게 처리해야할까?
End if





'본선정보
'#############################
  strwhere = " a.delYN = 'N' and a.GameTitleIDX = " & tidx & " and  a.gamekey3 = " & levelno  & " and gubun >= "&TOURNSET&"  " 'TOURNSET 2 본선대기 3 본선입력완료
  strsort = " order by a.Round asc,a.SortNo asc"

  strAfield = " a. gamememberIDX, a.userName,a.teamAna, a.teamBNa, a.Round, a.SortNo  "
  strBfield = " b.userName, b.teamAna, b.teamBNa,a.gubun,a.areaChanging,a.PlayerIDX,a.rndno1,a.rndno2,t_rank,tryoutgroupno "
  strfield = strAfield &  ", " & strBfield

  SQL = "select "& strfield &" from  " & strtable & " as a left JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
  rscnt =  rs.RecordCount

  If Not rs.EOF Then
  arrT = rs.getrows()
  End If
'#############################


'스코어 입력 정보 가져오기
'#############################
  strwhere = " a.GameTitleIDX = " & tidx & " and a.gamekey3 = " & levelno  & " and a.gubun >= "&TOURNSET&" " 'a.gubun 상태  0예선, 1 예선종료 gubun 2 본선 올라감 3 본선 대진표 설정완료
  strsort = " order by  a.Round asc, a.SortNo asc"
  strAfield = " a.Round , a.SortNo , a. gamememberIDX  " '열 인덱스(기준)
  strBfield = " b.gameMemberIDX2 , b.resultIDX , b.stateno ,winResult,b.courtno,a.playerIDX " '인덱스 , 짝수 인덱스(대상) ,게임상태 ( 2, 진행 , 1, 종료)
  strfield = strAfield &  ", " & strBfield

  SQL = "select "& strfield &" from  " & strtable & " as a INNER JOIN " & strresulttable & " as b ON a.gameMemberIDX = b.gameMemberIDX1   where " & strwhere & strsort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.EOF Then
    arrRS = rs.GetRows() 'RIDX, CIDX, GSTATE
  End if

'#############################



  Sub tournInfo2(ByVal arrRS , ByVal rd , ByVal sortno, ByVal arrRT, ByVal endround, ByVal arrJ)
    Dim ar ,m1idx,m1name,m1teamA,m1teamB,mrd,msortno,m2name,m2teamA,m2teamB,mgubun,marchange
    Dim chkmember,nextround,nr,nextmember,nr_m1name,m1pidx,nr_sortno,temp_sortno,nr_playeridx
    Dim mrndno1,mrndno2,mrndno,mtrank,mtryoutgroupno,chocolor
	Dim aj , a_j, a_r1, a_r2

	'부전승 올림 처리 2019.3.28 by bsh
	Dim nextSortNo,insertfield,insertvalue,selectfield,selectSQL,newmidx

	chkmember = False
    nextmember = False '다음 라운드 진출여부
    temp_sortno = 0

    If IsArray(arrRS) Then

      For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
        m1pidx      = arrRS(11, ar)
        m1idx       = arrRS(0, ar)
        m1name      = arrRS(1, ar)
        m1teamA     = arrRS(2, ar)
        m1teamB     = arrRS(3, ar)
        mrd         = arrRS(4, ar)
        msortno     = arrRS(5, ar)
        m2name      = arrRS(6, ar)
        m2teamA     = arrRS(7, ar)
        m2teamB     = arrRS(8, ar)
        mgubun      = arrRS(9, ar)
        mchange     = arrRs(10,ar)
        nextround   = CDbl(mrd) + 1

        mrndno1     = arrRs(12,ar)
        mrndno2     = arrRs(13,ar)
        mtrank      = arrRs(14,ar)
        mtryoutgroupno = arrRs(15,ar)
        If CDbl(mtrank) = 1 Then
          mrndno = mrndno1
        Else
          mrndno = mrndno2
        End if



        If CDbl(rd) = CDbl(mrd) And CDbl(msortno) = CDbl(sortno) Then
          chkmember = true
          '화면 그림
            oJSONoutput.T_MIDX = m1idx
            oJSONoutput.T_NOWRD = rd
            oJSONoutput.T_SORTNO = sortno
            oJSONoutput.T_DIVID = "cell_"&rd&"_"&sortno
            oJSONoutput.S3KEY = levelno
            strjson = JSON.stringify(oJSONoutput)
            %>
            <%If CDbl(rd) = 1 then%>
			<%
			If CDbl(sortno) <= 16 Then
				chocolor = "#C7E61D"
			elseif CDbl(sortno) > 16 And CDbl(sortno) <= 32 then
				chocolor = "#FFF9E1"
			elseif CDbl(sortno) > 32 And CDbl(sortno) <= 48 Then
				chocolor = "#C7E61D"
			elseif CDbl(sortno) > 48 And CDbl(sortno) <= 64 Then
				chocolor = "#FFF9E1"
			elseif CDbl(sortno) > 64 And CDbl(sortno) <= 80 Then
				chocolor = "#C7E61D"
			elseif CDbl(sortno) > 80 And CDbl(sortno) <= 96 Then
				chocolor = "#FFF9E1"
			elseif CDbl(sortno) > 96 And CDbl(sortno) <= 112 Then
				chocolor = "#C7E61D"
			elseif CDbl(sortno) > 112 And CDbl(sortno) <= 128 Then
				chocolor = "#FFF9E1"
			elseif CDbl(sortno) > 128 And CDbl(sortno) <= 114 Then
				chocolor = "#C7E61D"
			Else
				chocolor = "#FFF9E1"
			End if


            '최종 라운드가 아니라면 자동 소팅 적용##############
            If tn_last_rd = False Then
                For k = LBound(arrRND, 2) To UBound(arrRND, 2)

                  if  arrRND(1, k) = CDbl(sortno ) Then
                      k_orderno = arrRND(0, k)
                      k_sortno = arrRND(1, k)
                      k_joono  = arrRND(2, k)
                      Exit for
                  End If
                Next
            End If
            '최종 라운드가 아니라면 자동 소팅 적용##############
            
            End If
            %>


              <%If mgubun = "3" Then '편성완료라면%>
                <%
                  '다음 라운드 진출자로 등록 되었는지 확인
                  temp_sortno = 0
                  For nr = LBound(arrRS, 2) To UBound(arrRS, 2)
                    nr_mrd  = arrRS(4, nr)
                    nr_sortno = arrRS(5, nr)
                    nr_m1name   = arrRS(1, nr)
                    nr_playeridx =  arrRS(11, nr)

                    If CDbl(sortno) Mod 2 = 1 Then
                      temp_sortno = CDbl(sortno) +1
                    Else
                      temp_sortno = sortno
                    End If
                    temp_sortno = Fix(CDbl(temp_sortno) /2)

                    If  CDbl(temp_sortno) = CDbl(nr_sortno) And CDbl(nr_mrd) = CDbl(nextround)  Then '다음 라운드 소트 번호에 값이 있다면
                      If CDbl(nr_playeridx) = 1 Then
                      else
                        nextmember = True
                        Exit For
                      End if
                    End If
                    temp_sortno = 0
                  next

                  Call oJSONoutput.Set("result", 0 )
                  strjson = JSON.stringify(oJSONoutput)
                %>

<%
'###################################################################################################

			'다음라운드 빈자리, 1라운드, 소팅번호가 짝수일때만,
			'홀수짝궁의 playeridx 값이 1인지 내가 1인지 체크해서 부전승이라고 판단되면 sortno를 0으로 바꾼다.

	        'm1pidx      = arrRS(11, ar)
	        'm1idx       = arrRS(0, ar)
'			Dim nextSortNo,insertfield,insertvalue,selectfield,selectSQL,newmidx

			'If USER_IP = "118.33.86.240" Then
				If nextmember =  False Then '다음라운드 빈자리
					If CStr(rd) = "1" Then '1라운드이고

						If CDbl(sortno) > 0 And CDbl(sortno) Mod 2 = 0 Then '짝수 소팅번호

								nextSortNo = Fix(CDbl(sortno) /2)	'짝수

								If (CDbl(arrRS(11, ar -1)) > 1 And  CDbl(m1pidx) = 0)  Then '홀수승  부전은 pidx 0 '--' pidx 1
									'Response.write  "짝꿍 부전승처리 또는 sortno 0으로 변경"

									'tidx , levelno 글로벌변수 winner 짝수 right 홀수 left
									insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,winIDX,winResult  "
									insertvalue = " "&arrRS(0, ar -1)&","&arrRS(0, ar -1)&",1,1,getdate(),'운영자','ADMIN','"&tidx&"',"&Left(levelno,5)&",'"&teamnm&"',"&levelno& "," & arrRS(0, ar -1)& ",'left' "
									SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
									Call db.execSQLRs(SQL , null, ConStr)

									'//기존거 삭제 --
									SQL = "Delete From sd_TennisMember Where GameTitleIDX = "&tidx&" And gamekey3 = "&levelno&"  And Round = 2 And sortno = '" & nextSortNo & "'"
									Call db.execSQLRs(SQL , null, ConStr)

									'다음 라운드 부전맴버 insert * 구분2 준비 상태 구분 3 경기 시작상태
									insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,Round,SortNo,ABC "
									selectfield = " 3 ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,2,"&nextSortNo&" ,ABC  "
									selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & arrRS(0, ar -1)

									SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
									Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
									newmidx = rs(0)

									'파트너 insert
									insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
									selectfield =  " "&newmidx&",PlayerIDX,userName,TeamANa,TeamBNa "
									SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & arrRS(0, ar -1)
									Call db.execSQLRs(SQL , null, ConStr)

								End If

								If (CDbl(arrRS(11, ar -1)) = 0 And  CDbl(m1pidx) > 1) Then '짝수승
									'Response.write "나 부전승처리 또는 sortno 0으로 변경"

									'tidx , levelno 글로벌변수 winner 짝수 right 홀수 left
									insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,winIDX,winResult  "
									insertvalue = " "&m1idx&","&m1idx&",1,1,getdate(),'운영자','ADMIN','"&tidx&"',"&Left(levelno,5)&",'"&teamnm&"',"&levelno& "," & m1idx& ",'left' "
									SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
									Call db.execSQLRs(SQL , null, ConStr)


									'//기존거 삭제 --
									SQL = "Delete From sd_TennisMember Where GameTitleIDX = "&tidx&" And gamekey3 = "&levelno&"  And Round = 2 And sortno = '" & nextSortNo & "'"
									Call db.execSQLRs(SQL , null, ConStr)

									'다음 라운드 부전맴버 insert * 구분2 준비 상태 구분 3 경기 시작상태
									insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,Round,SortNo,ABC "
									selectfield = " 3 ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,2,"&nextSortNo&" ,ABC  "
									selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & m1idx

									SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
									Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
									newmidx = rs(0)

									'파트너 insert
									insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
									selectfield =  " "&newmidx&",PlayerIDX,userName,TeamANa,TeamBNa "
									SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & m1idx
									Call db.execSQLRs(SQL , null, ConStr)

								End if


								'로그==============================================================
								'Response.write "짝꿍 "  & arrRS(11, ar -1)  & " - " & arrRS(0, ar - 1)  & "<br>" 'pidx midx
								'Response.write "나 "  & m1pidx  & " - " & m1idx  & "<br>"

						End if
					End if
				End if
			'End If

'###################################################################################################
%>




          <%If m1name <> "부전"   And nextmember =  False And CDbl(m1pidx) > 1  then%>

          <%else%>

            <%If nr_m1name = m1name And m1name <> "부전"  Then '진출자라면%>
            <%If nr_m1name = "--" then%>


				 <%If CDbl(rd) = 1 then%>

					<%
						If IsArray(arrJ) And isnull(k_joono) = false Then

						  For aj = LBound(arrJ, 2) To UBound(arrJ, 2)
		                    a_j  = arrJ(0, aj) '예선조번호
		                    a_r1  = arrJ(1, aj) '예선 1등 추첨번호
		                    a_r2  = arrJ(2, aj) '예선 2등 추첨번호
								If isnull(a_r1) = False And isnull(a_r2) = False then
									If k_orderno = "1" Then '조1등
										If CStr(k_joono) =  CStr(a_r1) Then

										End if
									ElseIf k_orderno = "2" Then
										If CStr(k_joono) =  CStr(a_r2) Then

										End if
									End If
								End if
						  Next

						End if
					%>

				 <%else%>

				 <%End if%>



            <%else%>

			
			<%End if%>
            <%End if%>
          <%End if%>
          <%
          nextmember = False
          %>
          <%End if%>

            <%
          Exit for
        End if
      Next

      If chkmember = False And CDbl(rd) = 1 And CDbl(mgubun)= 2 Then '편성완료 전이라면
        oJSONoutput.T_MIDX = 0
        oJSONoutput.T_SORTNO = sortno
        oJSONoutput.T_DIVID = "cell_"&rd&"_"&sortno
        oJSONoutput.S3KEY = levelno
        strjson = JSON.stringify(oJSONoutput)
      End if

    End If
  End Sub

	'#############################################
	'    dim Dicgubun
	'    Set Dicgubun = Server.CreateObject("Scripting.Dictionary")
	'#############################################


	For i = 1 To depthCnt
	  If i = 1 then
	  roundcnt = Fix(drowCnt)
	  Else
	  roundcnt = Fix(roundcnt/2)
	  End if

	  if cdbl(roundsel) = cdbl(roundcnt) or cdbl(roundsel)/2 = cdbl(roundcnt) or (Cdbl(roundsel)<=4 and cdbl(roundsel) >= cdbl(roundcnt))  or cdbl(roundsel)=0 then

	  oJSONoutput.T_ATTCNT = roundcnt
	  oJSONoutput.T_NOWRD = i
	  oJSONoutput.T_RDID = "set_Round_"&i
	  oJSONoutput.S3KEY = levelno
	  strjson = JSON.stringify(oJSONoutput)

	  end if
	Next

	For i = 1 To depthCnt

		If i = 1 then
		  roundcnt = Fix(drowCnt)
		Else
		  roundcnt = Fix(roundcnt/2)
		End If

		if cdbl(roundsel) = cdbl(roundcnt) or cdbl(roundsel)/2 = cdbl(roundcnt) or (Cdbl(roundsel)<=4 and cdbl(roundsel) >= cdbl(roundcnt))  or cdbl(roundsel)=0 then

			For n = 1 To roundcnt

				Call tournInfo2(arrT, i, n, arrRS, depthCnt, arrj)

			Next

		end If
		
	Next

Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>
