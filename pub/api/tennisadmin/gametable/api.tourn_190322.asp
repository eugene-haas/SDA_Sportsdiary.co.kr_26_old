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
poptitle = "<span class='tit'>" & title & " " & teamnm & " (" & areanm & ")  본선 대진표</span>"
resetflag = oJSONoutput.RESET 'ok를 받으면 sortNo를 0으로 업데이트 한다.

onemore = oJSONoutput.ONEMORE


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
    bigo= htmlDecode(   Replace(rs("bigo") ,vbCrLf ,"\n"  ))
    bigo = Replace(bigo ,vbCr ,"\n")
    bigo = Replace(bigo ,vbLf ,"\n")

    endround = rs("endround")         '진행될 최종라운드
    joocnt = rs("joocnt")             '예선에 생성된 조수
    lastroundmethod = rs("lastroundmethod") '최종라운드 방식 1 리그 2 토너먼트
    poptitle = poptitle & " <span class='txt'>- 모집: " & entrycnt &" , - 신청 : " &  attmembercnt & " - 코트수 : " & courtcnt & "</span>"
        if bigo <>"" then 
        'poptitle = poptitle & " <p><span style='color:blue'> ※공지글※</span><p><p<span>"&bigo&"</span><p>"
        end if 

    If Left(levelno,3) = "200" Then
      joinstr = " left "
      singlegame =  true
    Else
      joinstr = " left "
      singlegame = false
    End if
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


'기본정보#####################################

'재추첨############## 사용하지 않음
  If resetflag = "ok" And aaaaa = "11111111111111111111111" Then
  SQL = "delete from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and Round > 1 and  (( Round =1 and userName = '부전') or ( playerIDX = 1))"
    Call db.execSQLRs(SQL , null, ConStr)
    
    SQL = "delete FROM sd_tennisResult where  gubun = 1 and  GameTitleIDX = "&tidx&"  and level = "& levelno & " "
    Call db.execSQLRs(SQL , null, ConStr)

    
    strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1"
    SQL = "update sd_TennisMember set sortno = 0,gubun=2,areaChanging='N' WHERE delYN = 'N' and " & strWhere 
    Call db.execSQLRs(SQL , null, ConStr)
  End if
'재추첨############## 사용하지 않음

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
  End if
End if


'최종라운드
tn_last_rd = false
'If lastroundcheck = "007" Then
If lastroundcheck = "007" And  areanm = "최종라운드"  Then
  tn_last_rd = True

  SQL = "select max(tryoutgroupno) from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and delYN = 'N' "
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

  
  '예선총명수로 참가자 명수 확정
    strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (0, 1)  and DelYN = 'N' "
    SQL = "SELECT  COUNT(*) as gcnt,max(tryoutgroupno) from "&strtable&" where "&strWhere
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    tcnt = 0
    attmembercnt = 0
    joono = 1

    If CDbl(rs(0)) > 0 Then
      attmembercnt = rs("gcnt")     '총참가자(sorting 마지막 번호)
      joono = rs(1)             '마지막조번호
      tcnt = CDbl(joono) * 2        '토너먼트 총참가자
    End If
    
    If CDbl(joono) = CDbl(lastjoono) Then
    
    Else '크거나 작다면 예선에서 조가 줄었거나 커진경우 ( sortno 초기화)
      SQL = " Update tblRGameLevel Set lastjoono = "&joono&" where DelYN = 'N' and  RGameLevelidx = " & idx
      'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

      strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1"
      SQL = "Update sd_TennisMember  Set sortNo = 0 WHERE delYN = 'N' and " & strWhere 
      'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    End if
  '예선총명수로 참가자 명수 확정


    'endround 2 , 4 ,8 , 16, 32, 64
    Select Case CDbl(endround) '진행될 마지막 라운드
    Case 1,2 : hideRDcnt = 0
    Case 4 : hideRDcnt = 1
    Case 8 : hideRDcnt = 2
    Case 16 : hideRDcnt = 3
    Case 32 : hideRDcnt = 4
    Case 64 : hideRDcnt = 5
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
  End if
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
    strwhere = " a.GameTitleIDX = "&tidx&" and  a.gamekey3 = "&levelno&" and a.tryoutgroupno > 0 and a.gubun = 1 and a.t_rank in (1,2)"
    strsort = " order by a.tryoutgroupno asc, a.t_rank asc" '결과순
    strAfield = " a. gamememberIDX, a.userName , a.tryoutgroupno, a.tryoutsortno, a.teamAna , a.teamBNa , a.tryoutstateno, a.t_rank,a.key3name "
    strBfield = " b.partnerIDX, b.userName, b.teamANa  , b.teamBNa , b.positionNo     ,a.rndno1,a.rndno2,a.place "
    strfield = strAfield &  ", " & strBfield 
    SQL = "select max(a.tryoutgroupno) from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere 
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    If rs.eof Then
	maxgno = 0
	else
	maxgno = rs(0) '편성완료된
	If isnull(maxgno) = True Then
		maxgno = 0		
	End if
	End if
    
    SQL = "select "& strfield &" from  " & strtable & " as a "& joinstr &" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


    If Not rs.EOF Then 
    arrL = rs.getrows()
    End If


  '#############################

  '소팅번호 부여
  '#############
    '   strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1"
    '   SQL = "SELECT sortno FROM sd_TennisMember  WHERE delYN = 'N' and " & strWhere & " order by sortNO asc"
    '   Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    '
    '   If Not rs.EOF Then 
    '     arrSt = rs.getrows()
    '   End If
    '
    '   '빈소팅 번호 찾기
    '   reDim temsortnoarr(drowCnt)
    '   tempi= 0
    '   For i = 1 To drowCnt
    '     tempsortno = tempno(arrST, i) '공통함수에 fn_tennis.asp
    '     If tempsortno > 0 then
    '       temsortnoarr(tempi) = tempsortno
    '       tempi = tempi + 1
    '     End if
    '   next

    
    '최대값 보다 크다면 모두 0으로 초기화
    strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and DelYN = 'N' and Round = 1"
    SQL = "update " &strtable&   " set gubun=0 where " & strWhere & " and sortNo > "& drowCnt
    'Call db.execSQLRs(SQL , null, ConStr)

    '=============

    Sub updateSortNo(ByVal arrRS, ByVal rank, ByVal rndno1, ByVal rndno2, ByVal joono, ByVal midx ,arrBYE) '추첨룰, 1,2위, 랜덤번호1, 랜덤번호 2, 예선조번호,  대진인덱스 , 바이자리정보
      Dim i, r_orderno , r_sortno, r_joono, r_abc,    SQL,rs,winner,nextSortNo,insertfield,insertvalue,nextgubun,newmidx
	  Dim n, bye 'b_orderno , b_sortno, b_joono

      If IsArray(arrRS) Then 'rullmake info
		For i = LBound(arrRS, 2) To UBound(arrRS, 2) 
          r_orderno = arrRS(0, i) 
          r_sortno = arrRS(1, i) 
          r_joono  = arrRS(2, i) 
		  r_abc = arrRS(7,i) '경기진행 조ABC

          If CDbl(rndno1) > 0 or CDbl(rndno2) > 0 Then '복사가 정상적으로 되었다면

          If  CDbl(r_orderno) = Cdbl(rank) Then

      SQL = "update sd_TennisMember set sortno = 0 where " & strWhere & " and playerIDX  > 1   and sortNo = " & r_sortno
      Call db.execSQLRs(SQL , null, ConStr)

      Select Case CDbl(r_orderno) 
            Case 1
              If CDbl(r_joono)  = CDbl(rndno1) Then
                SQL = "delete from sd_TennisMember where " & strWhere & " and playerIDX  in (0,1)  and sortNo = " & r_sortno '바이나, 빈값인경우 지우고
                Call db.execSQLRs(SQL , null, ConStr)
                SQL = "update sd_TennisMember set sortno = " & r_sortno & ",ABC = '"& r_abc &"' where gameMemberIDX = " & midx
                Call db.execSQLRs(SQL , null, ConStr)

					'####################################
						If CDbl(r_sortno) Mod 2 = 0  Then '짝확인하기
							winner = "right"
							nextSortNo = Fix(CDbl(r_sortno) /2)

							If IsArray(arrBYE) Then
								For n = LBound(arrBYE, 2) To UBound(arrBYE, 2) 
								  b_sortno = arrBYE(1, n)
									If CDbl(r_sortno) -1 = CDbl(b_sortno) Then
									  bye = true
									  'Exit for
									End if
								Next
							End if

						Else
							nextSortNo = Fix( (CDbl(r_sortno)+1) / 2)
							winner = "left"
				
							If IsArray(arrBYE) Then
								For n = LBound(arrBYE, 2) To UBound(arrBYE, 2) 
								  b_sortno = arrBYE(1, n)
									If CDbl(r_sortno) + 1 = CDbl(b_sortno) Then
									  bye = true
									  'Exit for
									End if
								Next
							End If
					
						End If
				
						If bye= True Then '상대가 bye 라면 자동진출

							insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,winIDX,winResult  " 
							insertvalue = " "&midx&","&midx&",1,1,getdate(),'운영자','ADMIN','"&tidx&"',"&Left(levelno,5)&",'"&teamnm&"',"&levelno& "," & midx& ",'" & winner & "' "
							SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
							Call db.execSQLRs(SQL , null, ConStr)

							'//기존거 삭제 --
							SQL = "Delete From sd_TennisMember Where GameTitleIDX = "&tidx&" And gamekey3 = "&levelno&"  And Round = 2 And sortno = " & nextSortNo
							Call db.execSQLRs(SQL , null, ConStr)

							'다음 라운드 부전맴버 insert * 구분2 준비 상태 구분 3 경기 시작상태
							insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,Round,SortNo,ABC "
							selectfield = " 3 ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,2,"&nextSortNo&" , '"&r_abc&"'  "
							selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & midx

							SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
							Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
							newmidx = rs(0)

							'파트너 insert
							insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
							selectfield =  " "&newmidx&",PlayerIDX,userName,TeamANa,TeamBNa "
							SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & midx
							Call db.execSQLRs(SQL , null, ConStr)
						End if
					'####################################		
				Exit for            
              End if
            Case 2
              If CDbl(r_joono)  = CDbl(rndno2) Then
                SQL = "delete from sd_TennisMember where " & strWhere & " and playerIDX  in (0,1)  and sortNo = " & r_sortno
                Call db.execSQLRs(SQL , null, ConStr)

                SQL = "update sd_TennisMember set sortno = " & r_sortno  & ",ABC = '"& r_abc &"'  where gameMemberIDX = " & midx
                Call db.execSQLRs(SQL , null, ConStr)


				'If USER_IP = "118.33.86.240" Then
					'####################################
						If CDbl(r_sortno) Mod 2 = 0  Then '짝확인하기
							winner = "right"
							nextSortNo = Fix(CDbl(r_sortno) /2)

							If IsArray(arrBYE) Then
								For n = LBound(arrBYE, 2) To UBound(arrBYE, 2) 
								  b_sortno = arrBYE(1, n)
									If CDbl(r_sortno) -1 = CDbl(b_sortno) Then
									  bye = true
									  'Exit for
									End if
								Next
							End if

						Else
							nextSortNo = Fix( (CDbl(r_sortno)+1) / 2)
							winner = "left"
				
							If IsArray(arrBYE) Then
								For n = LBound(arrBYE, 2) To UBound(arrBYE, 2) 
								  b_sortno = arrBYE(1, n)
									If CDbl(r_sortno) + 1 = CDbl(b_sortno) Then
									  bye = true
									  'Exit for
									End if
								Next
							End If
					
						End If
				
						If bye= True Then '상대가 bye 라면 자동진출

							insertfield = " gameMemberIDX1,gameMemberIDX2,stateno,gubun,set1end,recorderName,preresult,GameTitleIDX,gamekey3,gamekeyname,Level,winIDX,winResult  " 
							insertvalue = " "&midx&","&midx&",1,1,getdate(),'운영자','ADMIN','"&tidx&"',"&Left(levelno,5)&",'"&teamnm&"',"&levelno& "," & midx& ",'" & winner & "' "
							SQL = "INSERT INTO sd_TennisResult ("&insertfield&") values("&insertvalue&")"
							Call db.execSQLRs(SQL , null, ConStr)

							'보낼 라운드에 3이 있으면 gubun = 3 이고 없으면 2로
							'SQL = "select top 1 gubun from sd_TennisMember where gubun > 2 and GameTitleIDX = "&tidx&" And gamekey3 = "&levelno&"  And Round = 2"
							'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
							'If rs.eof Then
							'	nextgubun = 2
							'Else
							'	nextgubun = 3
							'End if

							'//기존거 삭제 --
							SQL = "Delete From sd_TennisMember Where GameTitleIDX = "&tidx&" And gamekey3 = "&levelno&"  And Round = 2 And sortno = " & nextSortNo
							Call db.execSQLRs(SQL , null, ConStr)

							'다음 라운드 부전맴버 insert * 구분2 준비 상태 구분 3 경기 시작상태
							insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,Round,SortNo, ABC "
							selectfield = " 3 ,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,tryoutgroupno,key3name,2,"&nextSortNo&", '"&r_abc&"'  "
							selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & midx

							SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"
							Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
							newmidx = rs(0)

							'파트너 insert
							insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "
							selectfield =  " "&newmidx&",PlayerIDX,userName,TeamANa,TeamBNa "
							SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & midx
							Call db.execSQLRs(SQL , null, ConStr)
						End if
					'####################################		
				'End If
				
				
				Exit for
              End if
            Case 0 '부전자리

            End Select 
          End If
          End if
        Next
      End If
    End Sub

    jooidx = CStr(tidx) & CStr(levelno) '생성된 추첨룰이 있다면

	'바이자리 정보 가져오기
	SQL = "Select orderno,sortno,joono,mxjoono,idx     ,gang,round,ABC from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' and orderno = 0"
    Set rsbye = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rsbye.eof Then
      arrBYE = rsbye.GetRows()
	End if


	'추첨룰 가져오기 (본선 룰 다시 가져오기)
    SQL = "Select orderno,sortno,joono,mxjoono,idx     ,gang,round,ABC from sd_TennisKATARullMake where mxjoono = '" & jooidx & "' "
    Set rsrndno = db.ExecSQLReturnRS(SQL , null, ConStr)

'If USER_IP = "118.33.86.240" Then

'	Call rsdrow(rsrndno)
'   Set rsrndno = db.ExecSQLReturnRS(SQL , null, ConStr)
'End if


    If rsrndno.eof then	' 본선대진룰이 생성되지 않았어용 생성후 사용해 주세용. 위에서 체크하고 있어요 암꺼도 하지말아요. 결과 9090 검색
		'      SQL = "select orderno,sortno,joono,mxjoono,idx from sd_TennisKATARull where mxjoono = " & joono '마지막조번호
		'      Set rsrndno = db.ExecSQLReturnRS(SQL , null, ConStr)
		'
		'      If Not rsrndno.EOF Then 
		'      arrRND = rsrndno.GetRows()
		'      End If
    Else
      arrRND = rsrndno.GetRows()    
    End if

    '진출자중 소팅번호가 0인게 있다면 
    SQL = "SELECT top 1 sortno FROM sd_TennisMember  WHERE delYN = 'N' and GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and Round = 1 and playerIDX > 1 and sortNo = 0"
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    If Not rs.eof Then
        strwhere = " GameTitleIDX = "&tidx&" and  gamekey3 = "&levelno&" and gubun in (2,3)  and Round = 1 and playerIDX > 1 and sortNo = 0" 
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
        If CDbl(tidx) <> 32 then
        Call updateSortNo(arrRND,  rank, rndno1,rndno2,joono, midx, arrBYE)
        End if
      rs.movenext
      n = n + 1
      Loop
      Set rs = Nothing
    End if

	'예선 조번호 찾기
	SQL = "select  tryoutgroupno,max(rndno1)as r1,MAX(rndno2) as r2 from sd_TennisMember where gubun in (0,1) and  GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & "  group by tryoutgroupno "
    Set rsj = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rsj.eof then
	arrJ = rsj.GetRows() 
	End if

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


'부전 -- 두개의 중복 소팅번호가 있다면 --를 지워라@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  '중복부전제거
  strwhere = " GameTitleIDX = " & tidx & " and  gamekey3 = " & levelno  & " and  gubun in (2,3)  and DelYN='N'"
  SQL = "select gamememberIDX,round,sortno from sd_TennisMember where " & strwhere & " and PlayerIDX in (0,1) and round = 1  order by round, sortno "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  i = 1
  Do Until rs.eof
    b_sortno = rs("sortno")
    
    If b_sortno = presortno Then
      If i = 1 Then
        delmidx = rs("gamememberIDX")
      Else
        delmidx = delmidx & "," & rs("gamememberIDX")
      End if
      i = i + 1
    End if
    presortno = b_sortno


  rs.movenext
  Loop

  If delmidx <> "" then
    SQL = "delete from sd_TennisMember where gameMemberIDX in ("&delmidx&")"
    Call db.execSQLRs(SQL , null, ConStr)
  End if
  
  
 If overlapdel = True then
    '1라운드 총갯수가 넘는다면 
    SQL = "select a.gameMemberIDX from sd_TennisMember  a  inner join ( "
    SQL = SQL & " Select round,SortNo ,COUNT(*) a,GameTitleIDX ,gamekey3 from sd_TennisMember " 
    SQL = SQL & " where Round= 1 and GameTitleIDX = "&tidx&" and gamekey3= "&levelno&"  and PlayerIDX in (0,1) group  by round,SortNo,GameTitleIDX ,gamekey3 having COUNT(*)>=2  "
    SQL = SQL & ") b  on a.GameTitleIDX = b.GameTitleIDX  and a.gamekey3 = b.gamekey3  and a.Round = b.Round  and a.SortNo = b.SortNo  and a.PlayerIDX = 1  "
    Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
    
    If Not rs.eof then
    xx = 1
    Do Until rs.eof
      If xx = 1 then
      delwhere = rs(0)
      Else
      delwhere = delwhere & "," & rs(0)
      End if
    xx = xx + 1
    rs.movenext
    loop

    SQL = "Delete From sd_TennisMember Where gameMemberIDX In ("&delwhere&") and playerIDX = 1 and  Round= 1 and GameTitleIDX = "&tidx&" and gamekey3= "& levelno
    Call db.execSQLRs(SQL , null, ConStr)
    End If
  End if



  '상태값을 맞춘다 (앱 화면 갯수 틀림 방지)
  strWhere = " GameTitleIDX = "&tidx&" and gamekey3 = "& levelno & " and gubun in (2,3)  and DelYN = 'N' and Round = 1"
  SQL = "SELECT max(gubun) FROM  " &strtable&   " where " & strWhere
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If isNull(rs(0)) = false Then
    SQL = "Update sd_TennisMember Set gubun = "&rs(0)&" where " & strWhere
    Call db.execSQLRs(SQL , null, ConStr)
  End if
'부전 -- 두개의 중복 소팅번호가 있다면 --를 지워라@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


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

'본선 정보, 스코어 정보 function
'#############################
  Sub drowCourt(ByVal rd, ByVal sno)
    Dim selectstr, userstr,usercolor,strjson,usecourt,courtstate,m,c,i
    Dim r_rdno,r_sno,r_idx,r_stateno,resultIDX,r_court,r_courtno
    
    If IsArray(arrRS) Then
      For i = LBound(arrRS, 2) To UBound(arrRS, 2) 
        r_rdno = arrRS(0, i) 
        r_sno = arrRS(1, i)
        r_idx = arrRS(4, i)
        r_stateno = arrRS(5, i)
        r_court = arrRS(7, i)
        If rd = r_rdno And sno = r_sno Then
          resultIDX = r_idx
          r_courtno = r_court
          Exit for
        End if
      Next
    End if
    %>
    <select id="c_<%=rd%>_<%=sno%>" style="width:100px;"  onchange='mx.SetCourt(<%=strjson%>)'>
    <%
    If resultIDX = "" Then
      resultIDX = 0
    End if
    oJSONoutput.SCIDX = resultIDX
    oJSONoutput.POS = "c_" & rd & "_" & sno
    strjson = JSON.stringify(oJSONoutput)   

    For m = 1 To courtcnt
      selectstr = ""
      usestr = ""
      usecolor = ""

      If IsArray(useCourtRS) Then
        For c = LBound(useCourtRS, 2) To UBound(useCourtRS, 2) 
          usecourt = useCourtRS(0, c) 
          courtstate =  useCourtRS(1, c) 
          If m = CDbl(usecourt) And m <> CDbl(r_courtno)  then
            If courtstate = "1" Then
            usestr = "종료"
            usecolor = " style='color:red'"
            else
            usestr = "사용"     '사용중
            usecolor = " style='color:orange'"
            End if
          End If
          If m = CDbl(r_courtno) Then
            selectstr = "selected"  '선택된
            usestr = "선택"     '선택중
            usecolor = " style='color:green'"
          End if
        Next
      End If

      %><option value="<%=m%>" <%=selectstr%> <%=usecolor%>><%=m%>번 <%=usestr%></option><%
    Next

    %>
    </select> 
  <!-- <a href='javascript:mx.SetCourt(<%=strjson%>)' class="btn_a" style="text-align:center;width:50px;">OK</a> -->
  <%
  End sub
  
  Sub tournInfo(ByVal arrRS , ByVal rd , ByVal sortno, ByVal arrRT, ByVal endround, ByVal arrJ)
    Dim ar ,m1idx,m1name,m1teamA,m1teamB,mrd,msortno,m2name,m2teamA,m2teamB,mgubun,marchange
    Dim chkmember,nextround,nr,nextmember,nr_m1name,m1pidx,nr_sortno,temp_sortno,nr_playeridx
    Dim mrndno1,mrndno2,mrndno,mtrank,mtryoutgroupno,chocolor
	Dim aj , a_j, a_r1, a_r2

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

			%>
            <div id="no_<%=rd%>_<%=sortno%>" style="flex:1;height:100%;background:<%If mchange = "Y"  then%>#99A5DF<%else%><%=chocolor%><%End if%>;">
            <%
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
            %>      
          <%If k_joono = "0" then%>
			  <span style="font-size:9px;color:blue;font-weight:bold;">B</span><br> <!-- <%'=k_sortno%><span style="font-size:9px;">번</span> -->

		  <%else%>

			  <%=k_joono%><span style="font-size:9px;">추</span><br>
      
			  <%If k_orderno = "1" then%>
				  <span style="color:red"><%=k_orderno%></span><span style="font-size:9px;">위</span><br>
			  <%else%>
				  <%=k_orderno%><span style="font-size:9px;">위</span><br>
			  <%End if%>

			  <!-- <%'=k_sortno%><span style="font-size:9px;">번</span> -->
		  
		  <%End if%>

            </div>
            <%End if%>

            <div class="tourney_ctr_btn" id="cell_<%=rd%>_<%=sortno%>" style="flex:10;height:100%;background:<%If mchange = "Y"  then%>#E0E7EF<%else%>#E5E5E5<%End if%>;
      <%If rd <> "1" then%>
      background-image:url('http://tennis.sportsdiary.co.kr/images/tennis/adimg/line.png');
      background-repeat:no-repeat;
      background-position:left center;
      <%End if%>">



            <a name="<%=m1name%>_<%=rd%>"></a><a name="mark_<%=rd%>_<%=sortno%>"></a>
      
      <ul class="team clearfix">
    <li>  
        <%If mgubun = "3" Or CDbl(rd) > 1 Then '고정%>
          <%If m1name = "부전" then%>
          <span style="color:blue;" class="player">Bye</span>
          <%ElseIf m1name = "--" then%>

          <%else%>
          <span class="player"><%'=mtryoutgroupno%> <%=Left(m1name,4)%>&nbsp;<%=Left(m2name,4)%></span>
          <%End if%>
        <%else%>
          <%If m1name = "부전" then%>
          <a href='javascript:mx.tournChangeSelectArea(<%=strjson%>)'><span style="color:blue;" class="player">Bye</span></a>
          <%else%>
          <a href='javascript:mx.tournChangeSelectArea(<%=strjson%>)'><span class="player"><%'=mtryoutgroupno%> <%=Left(m1name,4)%>&nbsp;<%=Left(m2name,4)%></span></a>
          <%End if%>
        <%End if%>
      </li></ul>

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

        <div class="chk_win_lose" >
          <%If m1name <> "부전"   And nextmember =  False And CDbl(m1pidx) > 1  then%>

            <%If CDbl(rd) > 1 then%>
            <a href='javascript:mx.SetTournGameCanCel(<%=strjson%>)' class="btn_a btn_cancel" ><span class="txt" style="font-size:18px;">취소</span></a>
            <%End if%>

            <%If rd < endround then%>
            <a href='javascript:mx.SetTournGameResult(<%=strjson%>)' class="btn_a btn_win"><span class="txt" style="font-size:18px;">승</span></a>
            <%End if%>
          
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
												%><span class="winnercell" style="background:green;font-size:18px;"><%=a_j%>조 <%=k_orderno%>위</span><%
										End if
									ElseIf k_orderno = "2" Then
										If CStr(k_joono) =  CStr(a_r2) Then
												%><span class="winnercell" style="background:green;font-size:18px;"><%=a_j%>조 <%=k_orderno%>위</span><%
										End if
									End If
								End if
						  Next
						  
						End if
					%>

				 <%else%>
				 <span class="winnercell" style="background:green;font-size:18px;">빈자리</span>
				 <%End if%>



            <%else%>

				<span class="winnercell" style="font-size:15px;">승리</span>
            <%End if%>
            <%End if%>
          <%End if%>
          <%
          nextmember = False
          %>
          <%End if%>
      </div>


            </div>
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
        %>
        <div id="no_<%=rd%>_<%=sortno%>" style="flex:1;height:100%;background:#C7E61D;"><%=sortno%></div>         
        <div id="cell_<%=rd%>_<%=sortno%>" style="flex:10;height:100%;"><a href='javascript:mx.tournChangeSelectArea(<%=strjson%>)'>빈박스</a></div><%
      End if

    End If
  End Sub
  
  Function gubunColor(ByVal arrRS, ByVal rd)
    Dim ar,mgcolor
    If IsArray(arrRS) Then
      mgcolor = "green"
      For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
        mrd         = arrRS(4, ar) 
        mgubun      = arrRS(9, ar) 

        If CDbl(rd) = CDbl(mrd) Then
            If mgubun = "3" Then '편성후 (하나라도 편성 안된걸 기준으로 찾자.)
              mgcolor = "#965F41"
              Exit for
            End if
        End If
      Next
    End If

    gubunColor = mgcolor
  End function

'  Function gubunColor(ByVal arrRS, ByVal rd)
	'    Dim ar,mgcolor
	'    If IsArray(arrRS) Then
	'      mgcolor = "#965F41"
	'      For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
	'        mrd         = arrRS(4, ar) 
	'        mgubun      = arrRS(9, ar) 
	'
	'        If CDbl(rd) = CDbl(mrd) Then
	'            If mgubun = "2" Then '편성후 (하나라도 편성 안된걸 기준으로 찾자.)
	'              mgcolor = "green"
	'              Exit for
	'            End if
	'        End If
	'      Next
	'    End If
	'
	'    gubunColor = mgcolor
'  End function
'#############################



    dim Dicgubun
    Set Dicgubun = Server.CreateObject("Scripting.Dictionary")

    


''타입 석어서 보내기
Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson
Response.write "`##`"


'#############################################

If tn_last_rd = False Then
'부전 결과 자동라운드 생성 >  페이지 호출
' If onemore = "notok" then
  'reqstr = "?REQ={""CMD"":20000,""IDX"":"""&tidx&""",""S1"":""tn001001"",""S2"":"&Left(levelno,3)&",""S3"":"&levelno&",""TT"":1,""SIDX"":0}"
  'source = Stream_BinaryToString( GetHTTPFile("http://tennis.sportsdiary.co.kr/pub/ajax/reqtennis.asp"&reqstr) , "utf-8" )
  'Response.write source
'End if
End if

%>
<!-- 헤더 코트s -->
  <div class='modal-header game-ctr'>
    <button type='button' class='close' data-dismiss='modal' aria-hidden='true'>×</button>
    <h3 id='myModalLabel'><%=levelno%>-- <%=poptitle%></h3>
  </div>
<!-- 헤더 코트e -->

<!-- 헤더 코트e -->
<div class='modal-body game-ctr' style="padding-bottom:0px;">
  <!-- S: top_control -->
  <div class="top_control">
    <%strjson = JSON.stringify(oJSONoutput)%>

    <!-- S: league_tab -->
    <div class="league_tab clearfix">
    <div class="pull-left">
        <a href="javascript:$('#loadmsg').text('&nbsp;새로 고침 중.....');mx.tournament(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel');" class = "btn_a btn btn_tab on">본선대진표</a>
        <a href="javascript:mx.tournament_ing(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel')" class="btn_a btn btn_tab">본선경기진행</a>

        <a href='javascript:mx.initCourt(<%=strjson%>)' class="btn btn_func" style="margin-left:20px;">코트 관리</a>
        
      <%If tn_last_rd = False then%>
        <% If CDbl(tidx) <> 32 then%>
          <a href='javascript:mx.initResetRull(<%=strjson%>)' class="btn btn_func" style="margin-left:10px;">새로고침 (본선대진 다시적용)</a>
        <%else%>
          <a href='javascript:alert("이노코스마배 막아둠")' class="btn btn_func" style="margin-left:10px;">새로고침 (본선대진 다시적용)</a>
        <%End if%>
      <%End if%>
      </div>

      <div class="pull-right">
        <input type="text" placeholder="검색어를 입력해 주세요." class="search_btn" onkeydown="if(event.keyCode == 13){mx.docfindstr('search_btn','realTimeContents span span','#realTimeContents' , 'table3');}" name="text-12" id="text-12" value="">

    <a href="javascript:mx.league(<%=idx%>,'<%=teamnm%>','<%=areanm%>','0')" class="btn_a btn btn_tab change_type">
          <span class="txt">예선</span>
          <span class="ic_deco"><i class="fa fa-angle-right" aria-hidden="true"></i></span>
        </a>
      <button id="reloadbtn" onclick="$('#loadmsg').text('&nbsp;로딩 중.....');mx.tournament(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel');"  style=" display:none;">새로고침</button><!-- 안보임 내부적으로 클릭사용 --> 
      </div>
  </div>
    <!-- E: league_tab -->
    
    <!-- S: sel_box -->
    <div class="sel_box" style="padding-left:320px;height:47px;">
    <p class="tit"></p>
      <select id="roundsel" onchange="javascript:$('#loadmsg').text('&nbsp;라운드 조회 중.....');window.toriScroll=0;mx.tournament(<%=idx%>,'<%=teamnm%>','<%=areanm%>','roundsel')" style="float:left;">
            <option value="0">전체</option>
             <%
                For i = 1 To depthCnt
          If i = 1 then
          roundcnt = Fix(drowCnt)
          Else
          roundcnt = Fix(roundcnt/2)
          End if

                    roundNM= Cstr(roundcnt)&"강"

                    if  roundcnt =2 then 
                        roundNM="준결승"
                    end if 
                    if  roundcnt <2 then 
                        roundNM="결승"
                    end if 

                    selectedstr =""
                    if  Cdbl(roundsel) =  Cdbl(roundcnt) then 
                        selectedstr = "selected"
                    end if 
          %>
                   <option value="<%=roundcnt %>"  <%=selectedstr %>  ><%=roundNM%></option>
               <%
                next
               %>
        </select>

    </div>
    <!-- E: sel_box -->
  </div>
  <!-- E: top_control -->
</div>
<!-- E: game-ctr -->



<div class='modal-body tourn-modal-body'>
  <!-- S: scroll_box -->
  <div class="scroll_box tourn_box"  id="drowbody">
    <table border="0" style="width: 100%">
   <tbody>
    <tr>


<%If tn_last_rd = False Then%>
  <%'예선#################%>
    <%
      sub tryoutTN(ByVal g_no, ByVal arrj)
	  Dim str1,str2,r1,r2

            If IsArray(arrL) Then

				For ar = LBound(arrL, 2) To UBound(arrL, 2)  '소트는 그룹 , 랭킹으로 되어있슴
					aname   = arrL(1, ar) 
					sortno    = arrL(3, ar) 
					groupno = arrL(2, ar) 
					bname   = arrL(10, ar) 
					rankno    = arrL(7, ar) 
					rndno1    = arrL(14, ar) 
					rndno2    = arrL(15, ar) 

					If CDbl(g_no) = CDbl(groupno) And (CDbl(rankno) = 1 Or CDbl(rankno) = 2) Then '같은 그룹 찍기
					  If CDbl(rankno) = 1 Then '1등
						str1 = "<td style=""color:red;"">"&rndno1&"</td>"
						str1 = str1 & "<td><a href=""#"&aname&"_1"" class=""btn_a btn_updateMember"" style=""width:100%;"">"&Left(aname,5)&"<br>"&Left(bname,5)&"</a></td>"
					  End if

					  If CDbl(rankno) = 2 Then
						str2 = "<td>"&rndno2&"</td>"
						str2 = str2 & "<td><a href=""#"&aname&"_1"" class=""btn_a btn_updateMember"" style=""width:100%;"">"&Left(aname,5)&"<br>"&Left(bname,5)&"</a></td>"
					  End If
					Else
						If CDbl(g_no) = CDbl(groupno) Then
							r1 = rndno1
							r2 = rndno2
						End if
					End If
				Next
				
				Response.write "<td>"&g_no&"</td>"
				If str1 = "" Then
					Response.write"<td style=""color:red;"">"&r1&"</td><td></td>"
				else
					Response.write str1
				End If
				
				If str2 = "" Then
					Response.write"<td>"&r2&"</td><td></td>"
				else
					Response.write str2
				End If
				
            End If   
      End sub	
	%>
      <td style="width: 300px;" valign="top">
        <div class="title_scroll">
        <table width="300" class="table-list game-ctr" id="gametable" style="margin-top:0px;">
            <thead><tr><th>조</th><th  colspan="2">1위</th><th  colspan="2">2위</th></tr></thead>
        <tbody>
	<%
		If IsChangeJoo = true Then '조나누기상태라면

			  For n = 1 To ubound(jorder)
				If IsArray(arrL) Then
				  For ar = LBound(arrL, 2) To UBound(arrL, 2) 
					g_no = arrL(2,ar) '조
					If CDbl(jorder(n)) = CDbl(g_no) then
					  Response.write "<tr>"
					  Call tryoutTN(g_no, arrj)
					  Response.write "</tr>"
					End if
				  Next
				End if    
			  next

		Else
			  For n = 1 To maxgno
				If IsArray(arrL) Then
				  For ar = LBound(arrL, 2) To UBound(arrL, 2) 
					g_no = arrL(2,ar) '조
					If CDbl(n) = CDbl(g_no) then
					  Response.write "<tr>"
					  Call tryoutTN(g_no, arrj)
					  Response.write "</tr>"
					End if
				  Next

				End if  
			  Next
		End If
	%>
        </tbody>
      </table>
      </div>
    </td>
  <%'예선#################%>
<%End if%>






    <td style="width:3px;font-size:3px;"></td>

  <%'본선#################%>    
  <td>
          <div>
      <table class="tourney_admin table_header <%=drowCnt%>" id ="tourney_admin" border="0" style="width:100%;" ><!-- height:<%=Fix(drowCnt * 74)%>px; -->
      <thead>
      <tr>
      <%
      For i = 1 To depthCnt
          If i = 1 then
          roundcnt = Fix(drowCnt)
          Else
          roundcnt = Fix(roundcnt/2)
          End if

          if cdbl(roundsel) = cdbl(roundcnt) or cdbl(roundsel)/2 = cdbl(roundcnt) or (Cdbl(roundsel)<=4 and cdbl(roundsel) >= cdbl(roundcnt))  or cdbl(roundsel)=0 then 
          %>
          <th style="padding:2px">
          <%
          oJSONoutput.T_ATTCNT = roundcnt
          oJSONoutput.T_NOWRD = i
          oJSONoutput.T_RDID = "set_Round_"&i
          oJSONoutput.S3KEY = levelno
          strjson = JSON.stringify(oJSONoutput)         
          rdcolor = gubunColor(arrT,i)

          If rdcolor = "green" then
            btnstr = "편성완료"
          Else
            btnstr = "재편성"
          End if
          %>


          <a href='javascript:window.toriScroll=0;mx.tornGameIn(<%=strjson%>)' class="btn_a btn_func" data-collap="<%=depthcollap %>" id="set_Round_a<%=i %>"><%=roundcnt%>&nbsp;<%=btnstr%></a>
          </th>
          <%
          end if 
      Next
      %>
      </tr>
      </thead>
    </table>  
    </div>

    <div class="tourney_container tourn_scroll_area" id="realTimeContents">
    <table class="tourney_admin <%=drowCnt%>" id ="tourney_admin" border="0" style="width:100%;" >
            <tbody>
                    <tr>
                    <%For i = 1 To depthCnt
        If i = 1 then
          roundcnt = Fix(drowCnt)
        Else
          roundcnt = Fix(roundcnt/2)
        End If
                        
            if cdbl(roundsel) = cdbl(roundcnt) or cdbl(roundsel)/2 = cdbl(roundcnt) or (Cdbl(roundsel)<=4 and cdbl(roundsel) >= cdbl(roundcnt))  or cdbl(roundsel)=0 then
              %>
              <td id="<%=i%>_row" style="padding:0px;">
              <%
              For n = 1 To roundcnt
                If i Mod 2 = 1 Then '홀수 라운드
                    If n Mod 2 = 1 Then '홀수 줄
                    btncss = "border-bottom:3px dotted #7F7F7F;"
                    Else
                    btncss = "border-bottom:4px solid #000;"
                    End If
                Else '짝수 라운드
                    If n Mod 2 = 1 Then '홀수 줄
                    btncss = "border-bottom:3px dotted #7F7F7F;"
                    Else
                    btncss = "border-bottom:4px solid #000;"
                    End If
                End if
                  %>
                  <div style="<%If i = 1 then%>border-left:1px solid #000;<%End if%>width:100%;border-right:1px solid <%=gubunColor(arrT,i)%>;padding:0px;margin:0px;<%=btncss%>">
                  <%' 행 열을 가진 함수호출 내용 가져와 서 그림%>
                  <%Call tournInfo(arrT, i, n, arrRS, depthCnt, arrj)%>
                  </div>
              <%
              Next
              %>
               </td>
            <%
                        end if 
                    Next
                    %>
                    </tr>
            </tbody>
        </table>
    </div>
  </td>
  <%'본선#################%>
    </tr>
   </tbody>
</table>

  <br><br><br>
  </div>
  <!-- E: scroll_box -->
</div>


<%
db.Dispose
Set db = Nothing
%>
