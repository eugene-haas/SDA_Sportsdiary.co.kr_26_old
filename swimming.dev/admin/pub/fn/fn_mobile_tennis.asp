<%

Function findpaytype(ByVal pidx1, ByVal pidx2, ByVal arrat, ByVal acctotal, ByVal reqidx)
  Dim ct,pidxA,pidxB,payflag,vaccno,attridx
  If IsArray(arrat) Then
    For ct = LBound(arrat, 2) To UBound(arrat, 2)
      payflag = arrat(0,ct)
      pidxA = arrat(1,ct)
      pidxB = arrat(2,ct)
  	vaccno = arrat(3,ct) '입금완료된 가상계좌번호
  	attridx = arrat(4,ct)

  	If isnull(pidxA) = True Or pidxA = "" Then
  		pidxA = 0
  	End if
  	If isnull(pidxB) = True Or pidxB = "" Then
  		pidxB = 0
  	End if

  	If reqidx = "" Or isnull(reqidx) = True then

  		If CDbl(pidxA) = CDbl(pidx1) or CDbl(pidxB) = CDbl(pidx2) Then
  		  If CDbl(acctotal) = 0 Then
  			  findpaytype = payflag
  		  else
  			  If vaccno = "" Or isNull(vaccno) = True Then
  				  findpaytype = payflag
  			  Else
  				  If vaccno = "1" Then
  					  findpaytype = payflag
  				  else
  					  findpaytype = "V"
  				  End if
  			  End If
  		  End If

  		  Exit for
  		End If

  	Else
  		If CDbl(attridx) = CDbl(reqidx) Then

  		  If CDbl(acctotal) = 0 Then
  			  findpaytype = payflag
  		  else
  			  If vaccno = "" Or isNull(vaccno) = True Then
  				  findpaytype = payflag
  			  Else
  				  If vaccno = "1" Then
  					  findpaytype = payflag
  				  else
  					  findpaytype = "V"
  				  End if
  			  End If
  		  End If

  		  Exit for

  		End if
  	End if

    Next
  End If
End Function

function setTeamLink(ByVal t1, ByVal t2,ByVal t3,ByVal t4)
  Dim tn
  If t1 <> "" Then
    tn = t1
  End If
  If t2 <> "" Then
    If tn = "" then
      tn = t2
    else
      tn = tn & "`~" & t2
    End if
  End If
  If t3 <> "" Then
    If tn = "" then
      tn = t3
    else
      tn = tn & "`~" & t3
    End if
  End If
  If t4 <> "" Then
    If tn = "" then
      tn = t4
    else
      tn = tn & "`~" & t4
    End if
  End If
  setTeamLink = tn
End function

'테니스 대회 진행시 코트 지정할때 푸시발송
Sub sendPush( ByVal title, ByVal contents, ByVal useridarr )
  Dim appkey, appsecret, SQL , invalue,i
  appkey = "ZDMQQISOP4X1VON2KCI2H45ODC2JQFPU"
  appsecret = "6KAsLgV1SVCfaaltZuI5X7aJJXVhUkJg"

  If IsArray(useridarr) Then
    For i = 0 To ubound(useridarr)
      If useridarr(i) <> "" then
        SQL = " INSERT INTO FingerPush.dbo.TBL_FINGERPUSH_QUEUE(appkey,appsecret,msgtitle,msgcontents,identify,mode,senddate,wdate,udate)  "
        SQL =SQL & " values ('" & appkey & "','" & appsecret & "','" & title & "','"&contents&"','" & useridarr(i) & "', 'STOS',getdate(),getdate(),getdate()) "
        Call db.execSQLRs(SQL , null, ConStr)
      End if
    Next
  End if
End Sub
'테니스 대회 진행시 코트 지정할때 푸시발송



'공통 함수
'게임키 레벨키 받아서 검색
Function listBoo()
  Dim SQL, rs
  SQL = "select MAX(TeamGb) as temgb,teamgbnm from tblRGameLevel where delyn='N' group by teamgbnm"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If rs.EOF Then
    listBoo = 0
  else
    listBoo = rs.GetRows()
  End if
End function


'부목록 생성
Sub booinsert(ByVal pidx)
  Dim ar, insertvalue, teamgb,teamgbNm,SQL,bRS

  SQL = "select MAX(TeamGb) as temgb,teamgbnm from tblRGameLevel where delyn='N' group by teamgbnm"
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If rs.EOF Then
    bRS = 0
  else
    bRS = rs.GetRows()
  End if

  If IsArray(bRS) Then
    For ar = LBound(bRS, 2) To UBound(bRS, 2)
      teamgb = bRS(0, ar)
      teamgbNm = bRS(1, ar)
      If CDbl(ar) = 0 Then
        insertvalue = " ("&pidx&",'"&teamgb&"','"&teamgbNm&"') "
      Else
        insertvalue = insertvalue &" ,("&pidx&",'"&teamgb&"','"&teamgbNm&"') "
      End if
    Next
    SQL = "INSERT INTO sd_TennisRPoint (PlayerIDX,teamgb,teamGbNm) VALUES " & insertvalue
    Call db.execSQLRs(SQL , null, ConStr)
  End If

End Sub





'대회 등릅
Function findGrade(ByVal gradeno)
  Dim titleGrade
  Select Case gradeno
  Case "2" : titleGrade = "GA"
  Case "1" : titleGrade = "SA"
  Case "3" : titleGrade = "A"
  Case "4" : titleGrade = "B"
  Case "5" : titleGrade = "C"
  Case "6" : titleGrade = "D" '단체
  Case "7" : titleGrade = "E" '이벤트 -- 랭킹포인트 반영안됨
  Case "8" : titleGrade = "비랭킹" '비랭킹 -- 랭킹포인트 반영안됨
  End Select
  findGrade = titleGrade
End function


'대회 그룹
Function findcode(ByVal c_arrRs ,ByVal c_titleCode,ByVal c_titlegrade)
    dim R_titleCode
    If IsArray(arrRS) Then
        For arr = LBound(c_arrRs, 2) To UBound(c_arrRs, 2)
            if c_arrRs(0, arr)  =c_titleCode and  c_arrRs(1, arr)  = c_titlegrade then
              R_titleCode = c_arrRs(2, arr)
            end if
        Next
    end if
    findcode = R_titleCode
end Function


'빈소팅 번호 찾기
Function tempno(ByVal arrSt, ByVal i)
  Dim tempsortno,ar,sortno
  tempsortno = False

  If IsArray(arrSt) Then
    For ar = LBound(arrSt, 2) To UBound(arrSt, 2)
      sortno = arrSt(0, ar)
      If CDbl(sortno) = CDbl(i) Then
        tempsortno = true
        Exit for
      End if
    Next
  End If

  If tempsortno = True Then
    tempno = 0
  Else
    tempno = i
  End if
End function


'쉬트목록가져오기
Function getSheetName(conn)
  Dim i
  Set oADOX = CreateObject("ADOX.Catalog")
  oADOX.ActiveConnection = conn
  ReDim sheetarr(oADOX.Tables.count)
  i = 0
  For Each oTable in oADOX.Tables
    sheetarr(i) = oTable.Name
    i = i + 1
  Next
  getSheetName = sheetarr
End function

Function fc_tryoutGroupSplit(groupcnt, jooDivision)
joarrcnt = Fix(groupcnt/jooDivision)
joarrcntMod = (groupcnt Mod jooDivision)

if joarrcntMod > 0 Then
  joarrcnt = joarrcnt + 1
End IF

Dim no,jono,totalarr,cntno,reversetoggle,startno
'Response.write "최대 행 : "  & jooDivision & "<br>"
'Response.write "최대 열 : "  & joarrcnt & "<br>"
ReDim totalarr(jooDivision, joarrcnt)
ReDim cntno(jooDivision)

'Response.write "(행, 열) : " & "(" & jooDivision & "," & joarrcnt  & ")"  & "<br>"
For i = 1 To ubound(cntno)
  cntno(i) = 1
Next

reversetoggle = 0
j = 1

For i = 1 To groupcnt
  If i > 1 And (i Mod jooDivision) = 1  Then
    j = j + 1
    If reversetoggle  = 0 then
      reversetoggle  = 1
      startno = CDbl( i + jooDivision -1)
    Else
      reversetoggle  = 0
    End if
  End If

  If reversetoggle  = 0 Then
    jono = i
  Else
    'Response.write "j : " & j <> jooDivision  & "<br>"
    jono = startno
    'jono = startno
    startno = startno - 1
  End if

  If (i mod jooDivision) = 0 Then
    no = jooDivision
    'Response.write "no" & no & "<br>"
  Else
    no = i mod jooDivision
    'Response.write "no :" & no & "<br>"
  End if

  'Response.write "no" & no & "<br>"
  'Response.write "no" & i mod jooDivision & "<br>"

  ckarr = cntno(no)
  totalarr(no , ckarr) = jono
  'Response.write "(no,charr): " & "(" & no & "," & ckarr & ")"  & "<br>"
  cntno(no) = CDbl(cntno(no)) + 1
Next

fc_tryoutGroupSplit = totalarr
End Function

Function fc_tryoutGroupMerge(groupcnt, jooDivision, jooArea)

Dim tryoutNum : tryoutNum = 1
ReDim tryoutResult(groupcnt)


joarrcnt = Fix(groupcnt/jooDivision)
joarrcntMod = (groupcnt Mod jooDivision)

if joarrcntMod > 0 Then
  joarrcnt = joarrcnt + 1
End IF

maxgroupCnt = jooDivision * joarrcnt


'Response.Write "조 : " & groupcnt & "<br>"
'Response.Write "나눈 조 : " & jooDivision & "<br>"
'Response.Write "영역  : " & jooArea & "<br>" & "<br>"

joarr = fc_tryoutGroupSplit(maxgroupCnt,jooDivision)

'For i = 1 To ubound(joarr)
'	For  n = 1 To joarrcnt
'		Response.write joarr(i, n) & ","
'	Next
'		Response.write "<br>"
'next

'시작 위치
StartPosition = 1
RowIndex = ubound(joarr,1)
ColumnIndex = ubound(joarr,2)
TotalData =  RowIndex * ColumnIndex
'Response.Write "<br>"
'Response.Write "배열 행  : " &  RowIndex & "<br>"
'Response.Write "배열 열  : " &  ColumnIndex & "<br>" & "<br>"



For i = 1 To jooDivision
  if(i mod jooArea) = 0 then
    'Response.write "jooArea : " & i  & "<br>"
    EndPosition = i
    reversetoggle = 0
    'Response.write "StartPosition : " & StartPosition  & "<br>"
    'Response.write "EndPosition : " & EndPosition & "<br>"

    For columnI = 1 To ColumnIndex
          If Cdbl(columnI) > 1 Then
          IF(reversetoggle = 0) Then
            reversetoggle = 1
            startNo = EndPosition
          ElseIF(reversetoggle = 1) Then
            reversetoggle = 0
          End IF
        End If

      For j = StartPosition To EndPosition

        'Response.write "j : " &  j & "<br>"
        'Response.write "j의 EndPosition 나머지 구하기 : " & (j Mod EndPosition) & "<br>"
        if(reversetoggle = 1) Then
          'Response.write "startNo : " & startNo & "<br>"
          'Response.write "(j, columnI) : " & "(" & startNo & "," & columnI  & ")"  & "<br>"
          Data = joarr(startno,columnI)
          if( Data <> "" and Data <= groupcnt) Then
            'Response.write Data & "<bR>"
            tryoutResult(tryoutNum) = Data
            'Response.Write tryoutNum & "<br>"
            tryoutNum =tryoutNum  + 1
          ENd IF
          startNo	 = startNo - 1
        Else
          'Response.write "(j, columnI) : " & "(" & j & "," & columnI  & ")"  & "<br>"
          'Response.write joarr(j,columnI) & "<bR>"
          Data = joarr(j,columnI)
          if( Data <> "" and Data <= groupcnt) Then
            'Response.write Data & "<bR>"
            tryoutResult(tryoutNum) = Data
            'Response.Write tryoutNum & "<br>"
            tryoutNum =tryoutNum  + 1
          ENd IF
        End IF
        'Response.write "reversetoggle : " & reversetoggle & "<br>"
      Next
    Next

    StartPosition = EndPosition + 1
  End If
Next

'Response.Write "여기?" & ubound(tryoutResult)
' 나뉘어 떨어지지 않은 나머지
If (jooDivision mod jooArea) <> 0 Then

    StartPosition = EndPosition + 1
    EndPosition = jooDivision

    reversetoggle = 0
    For columnI = 1 To ColumnIndex


          If Cdbl(columnI) > 1 Then
          IF(reversetoggle = 0) Then
            reversetoggle = 1
            startNo = EndPosition
          ElseIF(reversetoggle = 1) Then
            reversetoggle = 0
          End IF
        End If

      For j = StartPosition To EndPosition

        if(reversetoggle = 1) Then
          'Response.write joarr(startno,columnI) & "<bR>"
          Data = joarr(startno,columnI)
          if( Data <> "" and Data <= groupcnt) Then
            tryoutResult(tryoutNum) = Data
            tryoutNum =tryoutNum  + 1
          END IF
          startNo	 = startNo - 1
        Else

          Data = joarr(j,columnI)

          if( Data <> "" and Data <= groupcnt) Then
            tryoutResult(tryoutNum) = Data
            tryoutNum =tryoutNum  + 1
          END IF
          'Response.write joarr(j,columnI) & "<bR>"
        End IF

      Next
    Next

End if
fc_tryoutGroupMerge = tryoutResult
End Function

Function itemList( racketOnwer )
  If IsArray(ItemListRS) Then
    For ar = LBound(ItemListRS, 2) To UBound(ItemListRS, 2)
      itemIDX = ItemListRS(0, ar)
      itemNum = ItemListRS(1, ar)
      itemName = ItemListRS(2, ar)
      %><option value="<%= itemIDX %>" <%If itemName = racketOnwer then%>selected<%End if%>><%= itemName %></option><%
    Next
  End If
End function


Function t_ing(ByVal rcourtidx, winidx)
  If CDbl(rcourtidx) = 0 Then
    t_ing = ""
  else
    If winidx = "" Or winidx = "0" Or isnull(winidx) = true Then
      t_ing = "class='playing'"
    else
      t_ing = "class='finish'"
    End if
  End if
End function

Function t_winchk(ByVal winidx,ByVal midx1,ByVal midx2)

  If winidx = "" Or winidx = "0" Or isnull(winidx) = true Then
    t_winchk = array("","","승","승")
  Else
    If CDbl(midx1) = CDbl(winidx) then
      t_winchk = array(" win","","승","패")
    ElseIf CDbl(midx2) = CDbl(winidx) then
      t_winchk = array(""," win","패","승")
    else
      t_winchk = array("","","승","승")
    End If
  End if

End Function

'게임결과 정보
Function findResult(ByVal m1idx, ByVal m2idx ,ByVal rrs)
	Dim gresult(8),ar,m1_idx,m2_idx,r_idx,g_state,c_no,win_idx
	'결과및 코트
	If IsArray(rrs) Then
		For ar = LBound(rrs, 2) To UBound(rrs, 2)
		  m1_idx = rrs(2,ar)
		  m2_idx = rrs(3,ar) '게임상대
		  r_idx = rrs(4,ar) '결과인덱스
		  g_state = rrs(5,ar) '게임상태
		  c_no  = rrs(7,ar)
		  win_idx = rrs(9,ar)
      t1_score = rrs(10,ar)
      t2_score = rrs(11,ar)

		  If CDbl(m1_idx) = CDbl(m1idx) And CDbl(m2_idx) = CDbl(m2idx) Then
			gresult(1) = r_idx
			gresult(2) = g_state
			gresult(3) = c_no
			gresult(4) = win_idx
      gresult(5) = t1_score
      gresult(6) = t2_score
			findResult = gresult
			Exit for
		  End if
		Next
	Else
		gresult(1) = 0
		gresult(2) = 0 '게임상태 ( 2, 진행 , 1, 종료)
		gresult(3) = 0
		gresult(4) = 0
		findResult = gresult
	End If

	If gresult(1) = "" Then
		gresult(1) = 0
		gresult(2) = 0 '게임상태 ( 2, 진행 , 1, 종료)
		gresult(3) = 0
		gresult(4) = 0
		findResult = gresult
	End if
End function


%>
