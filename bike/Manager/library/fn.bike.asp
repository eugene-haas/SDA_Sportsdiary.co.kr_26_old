<%
  '===============================================================================
	' 나이구하기 ex) 대회idx, 회원idx 기준으로 성인여부 판단하기
	'===============================================================================

  Function GetAdultBasedOnTitle(titleIdx, memberidx, db)
    Dim birthDay, standDate
    SQL = " SELECT Birthday FROM SD_Member.dbo.tblMember WHERE MemberIdx = '"& memberIdx &"' "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      birthDay = rs(0)
    End If

    SQL = " SELECT ApplyStart FROM tblBikeTitle WHERE TitleIdx = '"& titleIdx &"' "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      standDate = rs(0)
    End If

    GetAdultBasedOnTitle = GetAdultYN(birthDay, standDate)
  End Function

  '===============================================================================
	' 나이구하기 ex) birthday = 19950103, standDate = 2018-04-02
	'===============================================================================

	Function GetAge(birthday, standDate)
		Dim standAge, birthOver

    ' 기준나이 현재년도 - 태어난 년도
    standAge = Cint(Left(standDate,4)) - CInt(Left(birthday,4))
    birthOver = Replace(Mid(standDate, 6, 10), "-", "") > Right(birthday,4)
    If birthOver = False Then
      standAge = standAge - 1
    End If

		GetAge = standAge
	End Function

  Function GetAdultYN(birthday, standDate)
    Dim adultAge
    adultAge = 19
    If GetAge(birthday, standDate) < adultAge Then
      GetAdultYN = "N"
    Else
      GetAdultYN = "Y"
    End If
  End Function

  Function GetSCRPName(star, category, rating)
    Dim Text, starText
    If star = 1 Then
      starText = "★(1star)"
    ElseIf star = 2 Then
      starText = "★★(2star)"
    ElseIf star = 3 Then
      starText = "★★★(3star)"
    End If

    Text = starText & " " & category
    If rating <> 0 Then
      Text = Text & " / " & rating
    End If

    GetSCRPName = Text
  End Function

  Function GetEventName(groupType, courseLength, eventDetailType)
    Dim eventName
    If groupType = "개인" Then
      eventName = eventDetailType
    Else
      eventName = courseLength & " " & eventDetailType
    End If

    GetEventName = eventName
  End Function

  Function SQLGetTeamReady(db, teamIdx)
    Dim NoneAddInfoCount, NoneParentInfoCount
    NoneAddInfoCount = 0
    NoneParentInfoCount = 0
    SQL =       " SELECT a.MemberIdx, ISNULL(CONVERT(VARCHAR(10), b.MemberIdx), 'N') addInfoState, ISNULL(c.AgreeYN, 'N') parentAgreeState "
    SQL = SQL & " FROM ( SELECT MemberIdx FROM tblBikeEventApplyInfo WHERE TeamIdx = "& teamIdx &" AND DelYN = 'N' "
	  SQL = SQL & "        UNION ALL "
    SQL = SQL & "        SELECT MemberIdx FROM tblBikeTeamInvite WHERE TeamIdx = "& teamIdx &" AND JoinYN = 'N' AND DelYN = 'N' ) a "
    SQL = SQL & " LEFT JOIN tblBikeApplyMemberInfo b ON a.MemberIdx = b.MemberIdx "
    SQL = SQL & " LEFT JOIN tblBikeParentInfo c ON a.MemberIdx = c.MemberIdx "
    SQL = SQL & " GROUP BY a.MemberIdx, b.MemberIdx, c.AgreeYN "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      arrTeamInfo = rs.getRows()
    End If

    If IsArray(arrTeamInfo) Then
      For i = 0 To Ubound(arrTeamInfo, 2)
        addInState = arrTeamInfo(1, i)
        parentSate = arrTeamInfo(2, i)

        If addInState = "N" Then
          NoneAddInfoCount = NoneAddInfoCount + 1
        End If

        If parentSate = "N" Then
          NoneParentInfoCount = NoneParentInfoCount + 1
        End If
      Next
    End If

    If NoneParentInfoCount = 0 And NoneParentInfoCount = 0 Then
      SQLGetTeamReady = "Y"
    Else
      SQLGetTeamReady = "N"
    End If
  End Function


  Function SQLGetTotalFee(db, memberIdx, eventIdx)
    SQL = " SELECT EntryFee, GroupType, CourseLength, EventDetailType FROM tblBikeEventList WHERE eventIdx IN ("& eventIdx &") AND GroupType = '개인' "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      arrSoloFee = rs.getRows()
    End If

    SQL = " SELECT EventIdx FROM tblBikeEventList WHERE eventIdx IN ("& eventIdx &") AND GroupType = '단체' "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      arrGroupEvent = rs.getRows()
    End If


    If IsArray(arrSoloFee) Then
      For s = 0 To Ubound(arrSoloFee, 2)
        fee             = arrSoloFee(0, s)
        groupType       = arrSoloFee(1, s)
        courseLength    = arrSoloFee(2, s)
        eventDetailType = arrSoloFee(3, s)
        totalFee = totalFee + Cdbl(fee)
        eventName = GetEventName(groupType, courseLength, eventDetailType)
      Next

    ' 개인 여러개 신청시에만 할인 해당됨
    discountFee = Cdbl(Ubound(arrSoloFee, 2)) * 10000
    totalFee = totalFee - discountFee
    End If

    If IsArray(arrGroupEvent) Then
      For g = 0 To Ubound(arrGroupEvent, 2)
        gEventIdx = arrGroupEvent(0, g)
        SQL =        " SELECT COUNT(*) FROM tblBikeEventApplyInfo  "
        SQL = SQL &  " WHERE TeamIdx = (SELECT TeamIdx FROM tblBikeEventApplyInfo WHERE MemberIdx = '"& memberIdx &"' AND DelYN = 'N' AND EventIdx = "& gEventIdx &")  "
        SQL = SQL &  " AND DelYN = 'N' "
        Set rs = db.Execute(SQL)
        If Not rs.eof Then
          groupMemberCount = rs(0)
        End If

        SQL = " SELECT EntryFee, GroupType, CourseLength, EventDetailType FROM tblBikeEventList WHERE EventIdx = "& gEventIdx &" "
        Set rs = db.Execute(SQL)
        If Not rs.eof Then
          fee             = rs(0)
          groupType       = rs(1)
          courseLength    = rs(2)
          eventDetailType = rs(3)
          eventName = GetEventName(groupType, courseLength, eventDetailType)
        End If

        groupFee = Cdbl(groupMemberCount) * Cdbl(fee)
        totalFee = totalFee + Cdbl(groupFee)
      Next
    End If

    SQLGetTotalFee = totalFee
  End Function


  ' 팀 정보삭제
  Function DeleteTeamInfo(db, eventApplyIdx, mode, teamMemberDel, cancelYN)

    ' 이미취소된 내역인지 확인
    SQL = " SELECT DelYN FROM tblBikeEventApplyInfo WHERE EventApplyIdx = "& eventApplyIdx &" "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      delState = rs(0)
      If delState = "Y" Then
        jsonStr = "{""return"": false, ""message"": ""이미삭제된 내역""}"
        Response.Write jsonStr
        Response.End
      End If
    Else
      Response.End
    End If

    ' eventidx, memberidx 가져오기
    SQL = " SELECT EventIdx, MemberIdx, TeamIdx FROM tblBikeEventApplyInfo WHERE EventApplyIdx = "& eventApplyIdx &" "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      eventIdx  = rs(0)
      memberIdx = rs(1)
      teamIdx   = rs(2)
    End If

    ' 팀원정보 가져오기
    ' 전체취소일때는 team멤버 전원취소
    If mode = "all" Then
      teamMemberDel = ""
    End If
    If teamMemberDel = "" Then
      SQL =  "SELECT MemberIdx FROM tblBikeTeamInvite WHERE DelYN = 'N' AND TeamIdx = "& teamIdx &" "
      Set rs = db.Execute(SQL)
      ' recordset array와 split array 형식이 달라서 똑같이 맞춰줌
      If Not rs.eof Then
        arrTeamMember = rs.getRows()
        If IsArray(arrTeamMember) Then
          For t = 0 To Ubound(arrTeamMember, 2)
            teamMemberDel = teamMemberDel & arrTeamMemberDel & arrTeamMember(0, t) & ","
          Next
          arrTeamMemberDel = Split(teamMemberDel, ",")
        End If
      End If
    ElseIf mode = "member" Then
      ' 팀원 삭제 리스트 나눠서 배열에 담기
      arrTeamMemberDel = Split(teamMemberDel & ",", ",")
    End If

    If cancelYN = "Y" Then
      updateQueryStr = " DelYN = 'Y', CancelYN = 'Y', CancelDate = GETDATE() "
    Else
      updateQueryStr = " DelYN = 'Y' "
    End If

    ' db 처리 시작
    If mode = "all" Then
      ' 1. 본인 취소
      SQL = " UPDATE tblBikeEventApplyInfo SET "& updateQueryStr &" WHERE EventApplyIdx = "& eventApplyIdx &" "
      Call db.Execute(SQL)

      ' 2. 팀명 비우기
      SQL = " UPDATE tblBikeTeam SET LeaderIdx = 0 WHERE TeamIdx = "& teamIdx &" "
      Call db.Execute(SQL)
    End If


    If mode = "all" Or mode = "member" Then
      ' 3. 팀원 삭제
      If IsArray(arrTeamMemberDel) Then
        For d = 0 To Ubound(arrTeamMemberDel) - 1
          teamMemberIdx = arrTeamMemberDel(d)
          If Cdbl(memberIdx) <> Cdbl(teamMemberIdx) Then
            ' 3-1 팀초대 테이블 삭제업데이트
            SQL = " UPDATE tblBikeTeamInvite SET DelYN = 'Y' WHERE MemberIdx = '"& teamMemberIdx &"' AND TeamIdx = "& teamIdx &" "
            Call db.Execute(SQL)

            ' 3-2 참가내역 테이블 삭제업데이트
            SQL = " UPDATE tblBikeEventApplyInfo SET "& updateQueryStr &" WHERE MemberIdx = '"& teamMemberIdx &"' AND TeamIdx = "& teamIdx &" "
            Call db.Execute(SQL)
          End If
        Next
      End If
    End If

  End Function

  ' 버스신청여부판단. 대회참가 - 결제까지 완료한 내역이 있으면 신청가능, 팀으로 참가는하는경우 팀장이 결제했다면 신청가능
  Function GetBusApplyAvailable(db, titleIdx, memberIdx)
    SQL =       " SELECT COUNT(*) FROM tblBikeEventApplyInfo a "
    SQL = SQL & " LEFT JOIN tblBikeEventList b ON a.EventIdx = b.EventIdx "
    SQL = SQL & " LEFT JOIN tblBikePayment c ON a.PaymentIdx = c.PaymentIdx "
    SQL = SQL & " WHERE a.MemberIdx = '"& memberIdx &"' AND b.TitleIdx = "& titleIdx &" AND c.PaymentState = 1 "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      applyCount = rs(0)
      If applyCount = 0 Then
        GetBusApplyAvailable = "N"
      Else
        GetBusApplyAvailable = "Y"
      End If
    End If
  End Function

  ' 문자보내기   핸드폰번호, 문자제목, 문자내용
  Function SendText(db, phoneNum, title, content)
    sendType    = 7
    sendFrom    = "02-704-0282"
    sitecode    = "BIKE01"

    If phoneNum <> "" Then
      SQL =       " INSERT INTO SD_TENNIS.dbo.t_send (sSubject,nSvcType,nAddrType,sAddrs,nContsType,sConts,sFrom,dtStartTime, sitecode)  "
      SQL = SQL & " VALUES ('"& title &"', "& sendType &", 0, '"& phoneNum &"', 0, "& content &", '"& sendFrom &"', GETDATE(), '"& sitecode &"') "
      Call db.Execute(SQL)
    End If
  End Function

  Function GetTextContent(db, kind, link, titleIdx, senderName)
    Dim text

    SQL = " SELECT TitleName FROM tblBikeTitle WHERE TitleIdx = "& titleIdx &" "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      titleName = rs("TitleName")
    End If

    If kind = "teamInvite" Then
      text =        "'안녕하십니까.' + Char(10)"
      text = text & "+ '스포츠다이어리입니다.' + Char(10)"
      text = text & "+ Char(10)"
      text = text & "+ '"& senderName &" 님이 신청하신' + Char(10) "
      text = text & "+ '["& titleName &"]' + Char(10)"
      text = text & "+ '대회 단체전 참가신청을 진행 중 입니다.' + Char(10)"
      text = text & "+ Char(10)"
      text = text & "+ '아래링크로 해당 정보를 입력해 주셔야 참가신청이 진행됩니다.' + Char(10)"
      text = text & "+  Char(10)"
      text = text & "+ '"& link &"'"

    ElseIf kind = "parentAgree" Then
      text =        "  '안녕하십니까.' + Char(10)"
      text = text & "+ '스포츠다이어리입니다.' + Char(10)"
      text = text & "+ Char(10)"
      text = text & "+ '귀하의 자녀에게' + Char(10)"
      text = text & "+ '["& titleName &"]' + Char(10)"
      text = text & "+ '대회 참가신청을 진행 중 입니다.' + Char(10)"
      text = text & "+ Char(10)"
      text = text & "+ '19세 미만은 보호자의 동의가 꼭 필요하여 아래링크로 동의해 주셔야 참가신청이 완료됩니다.' + Char(10)"
      text = text & "+ '아래링크로 해당 정보를 입력해 주셔야 참가신청이 진행됩니다.' + Char(10)"
      text = text & "+ Char(10)"
      text = text & "+ '"& link &"'"
    End If

    GetTextContent = text
    Set rs = nothing

  End Function

  Function GetPayTextContent(titleName, userName, accountNumber, depositPrice)
    text =        " '"& titleName &" 참가신청이 접수되었습니다.' + Char(10) "
    text = text & "+ ' - 신청자 : "& userName &"' + Char(10)"
    text = text & "+ ' - 은행명 : 하나은행' + Char(10)"
    text = text & "+ ' - 가상계좌 : "& accountNumber &"' + Char(10)"
    text = text & "+ ' - 참가비 : "& depositPrice &"' + Char(10)"

    GetPayTextContent = text
  End Function

  Function GetBusTextContent(titleName, busLocation, accountNumber, userName)

    text =        " '"& titleName &" 버스신청이 접수되었습니다.' + Char(10) "
    text = text & "+ ' - 신청자 : "& userName &"' + Char(10)"
    text = text & "+ ' - 출발장소 : "& busLocation &"' + Char(10)"
    text = text & "+ Char(10)"
    text = text & "+ ' - 은행명 : 하나은행' + Char(10)"
    text = text & "+ ' - 가상계좌 : "& accountNumber &"' + Char(10)"
    text = text & "+ ' - 참가비 : "& depositPrice &"' + Char(10)"

    GetBusTextContent = text
  End Function


  'gender return
  Function GetGenderStr(val)
    if val = "Man" Then
      GetGenderStr = "남"
    elseif val = "WoMan" Then
      GetGenderStr = "여"
    else
      GetGenderStr = "자웅동채"
    end if
  End Function

  '계좌 입금 YN
  Function GetPaymentStateStr(val)
    if val = "1" or val = "3" or val = "4" Then
      GetPaymentStateStr = "Y"
    elseif val = "0" or val = "2" Then
      GetPaymentStateStr = "N"
    else
      GetPaymentStateStr = "계좌를 발급하세요."
    end if
  End Function

  'date 1900 년 거르기
  Function Getdatechk(val)
    if left(val,4) = "1900" Then
      Getdatechk = ""
    else
      Getdatechk = val
    end if
  End Function

  FUNCTION IPHONEYN()

      If(Len(Request.ServerVariables("HTTP_USER_AGENT"))=0) Then
          strAgent = "NONE"
      Else
          strAgent = Request.ServerVariables("HTTP_USER_AGENT")
      End if

      mobile = Array("iPhone", "ipad", "ipod")

      imb = 0

      For Each n In mobile
          If (InStr(LCase(strAgent), LCase(n)) > 0) Then
              imb = imb + 1
          End If
      Next

      IPHONEYN = imb

  END FUNCTION


'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


Sub bikeAdminPaging (ByVal total_page, ByVal block_size, ByVal page, ByVal function_name, ByVal packet, ByVal url, ByVal listId)
	Dim max_page, min_page, i

	If page Mod block_size = 0 Then
		min_page = Int(page / block_size - 1) * block_size   +1
	Else
		min_page = Int(page / block_size) * block_size + 1
	End if

	If (min_page + block_size - 1) > total_page Then
		max_page = total_page
	Else
		max_page = min_page + block_size - 1
	End If

	Response.Write "<ul class='pagination'>" & vbcrlf

	If min_page > block_size Then
		Response.Write "<li class=""prev""><a href='javascript:" & function_name & "("&packet&", "& min_page-1 &", """& url &""", """& listId &""")'>&lt;</a></li>" & vbcrlf
	Else
		Response.Write "<li class=""prev""><a href='javascript:alert(""첫 페이지 입니다."");'>&lt;</a></li>" & vbcrlf
	End if

	For i = min_page To max_page
		If Int(i) = Int(page)  Then
			Response.Write "<li class=""active""><a href=""javascript:;"">" & i & "</a></li>" & vbcrlf
		Else
			Response.Write "<li><a href='javascript:"& function_name &"("&packet&", "& i &", """& url &""", """& listId &""");'>"& i &"</a></li>"& vbcrlf
		End if
	Next

	If max_page < total_page Then
		Response.Write "<li class=""next""><a onclick='"& function_name &"("&packet&", "& max_page + 1 &", """& url &""", """& listId &""")'>&gt;</a></li>" & vbcrlf
	Else
		Response.Write "<li class=""next""><a onclick='javascript:alert(""마지막 페이지 입니다."");' >&gt;</a></li>" & vbcrlf
	End If

	Response.Write "</ul>" & vbcrlf
End Sub

%>
