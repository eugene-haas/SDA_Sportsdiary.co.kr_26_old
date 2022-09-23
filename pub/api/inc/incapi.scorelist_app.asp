<%'################################################################################################%>
<%

	strfield = " rcIDX,resultIDX,midx,name,leftscore,rightscore,gameend,servemidx,servemname,   setno,gameno,playsortno, skill1,skill2,skill3 "
	SQL = "select "& strfield &" from  sd_TennisResult_record where resultIDX = " & gameidx & " order by rcIDX asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    startsc=0
	Set gamescore =Server.CreateObject("Scripting.Dictionary")
	If Not rs.EOF Then
		arrRSasc = rs.GetRows()
		leftscno = startsc
		rightscno = startsc

		For ar = LBound(arrRSasc, 2) To UBound(arrRSasc, 2)  '점수
			leftscore = arrRSasc(4, ar)
			rightscore = arrRSasc(5, ar)
			gameend = arrRSasc(6, ar)
			gameno = arrRSasc(10, ar)

			If gameend = "1" Then
				If leftscore > rightscore Then
					leftscno = leftscno + 1
				Else
					rightscno = rightscno + 1
				End If

				gamescore.ADD  gameno, leftscno & " : "& rightscno

			End if
		Next
	End if


	strfield = " rcIDX,resultIDX,midx,name,leftscore,rightscore,gameend,servemidx,servemname,   setno,gameno,playsortno, skill1,skill2,skill3,score_postion "
	SQL = "select "& strfield &" from  sd_TennisResult_record where resultIDX = " & gameidx & "and (leftscore > 0 or rightscore > 0)  order by rcIDX desc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	If Not rs.EOF Then
		arrRS = rs.GetRows()
	End if

	If IsArray(arrRS) Then

	ReDim wincolor(UBound(arrRS, 2))

		preleftscore = 0
		prerightscore = 0

		For ar = UBound(arrRS, 2) To  LBound(arrRS, 2) Step -1
			midx = arrRS(2, ar)
			leftscore = arrRS(4, ar)
			rightscore = arrRS(5, ar)

			If CDbl(leftscore) > CDbl(preleftscore)  Then '역순 점수감소
				wincolor(ar)  = "orange"
			Else
				If CDbl(rightscore) < CDbl(prerightscore) then
					wincolor(ar)  = "green"
				Else
					'wincolor(ar)  = Split(tuserkey(midx),"#$")(1) '서브넣은 선수꺼
				End if
			End If

			preleftscore = leftscore
			prerightscore = rightscore
		Next

		colorno = UBound(arrRS, 2)
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

			rcIDX = arrRS(0, ar)
			resultIDX = arrRS(1, ar)
			midx = arrRS(2, ar)
			name = arrRS(3, ar)
			leftscore = arrRS(4, ar)
			rightscore = arrRS(5, ar)
			gameend = arrRS(6, ar)
			servemidx = arrRS(7, ar)
			servemname = arrRS(8, ar)
			setno = arrRS(9, ar)
			gameno = arrRS(10, ar)
			playsortno = arrRS(11, ar)
			skill1 = arrRS(12, ar)
			skill2 = arrRS(13, ar)
			skill3 = arrRS(14, ar)
			sc_position = arrRS(15, ar)
            right_sc=0
            left_sc=0

			If CDbl(gameno) > 10   Then  '타이브레이크 시작위치
				left_sc = leftscore
				right_sc = rightscore
			Else

				Select Case rightscore
					Case "0": right_sc = "0"
					Case "1": right_sc = "15"
					Case "2": right_sc = "30"
					Case "3": right_sc = "40"
					Case Else : right_sc = "40"
				End Select

				Select Case leftscore
					Case "0": left_sc = "0"
					Case "1": left_sc = "15"
					Case "2": left_sc = "30"
					Case "3": left_sc = "40"
					Case Else : left_sc = "40"
				End Select

				If CDbl(leftscore) >= 3 And CDbl(rightscore) >= 3 then
					If CDbl(leftscore) = CDbl(rightscore) Then
						left_sc = 40
						right_sc = 40
					Else
						If CDbl(leftscore) > CDbl(rightscore) Then
							left_sc = "AD"
							right_sc = 40
						Else
							left_sc = 40
							right_sc = "AD"
						End if
					End If
				End if
			End if


			winpos = sc_position
			If skill1 = "OUT" Or skill1 = "NET" Then
				If sc_position = "left" then
					winpos = "right"
				Else
					winpos = "left"
				End If
			End if

			If CDbl(Split(tuser(0),"#$")(0)) = CDbl(midx) Or CDbl(Split(tuser(1),"#$")(0)) = CDbl(midx) Then
				changemidx = Split(tuser(2),"#$")(0)
				changemname = Split(tuser(2),"#$")(1)
			Else
				changemidx = Split(tuser(0),"#$")(0)
				changemname = Split(tuser(0),"#$")(1)
			End if
			%>

			<%If gameend = "1" then%>
            <div class="summary-rec" id="rcend_<%=rcIDX%>">
              <ul>
                <li class="round"><%=gameno%>경기</li>
                <li><%=Split(tuser(0),"#$")(1)%>,<%=Split(tuser(1),"#$")(1)%></li>
                <li class="score"><span><%=gamescore(gameno)%></span></li>
				<li><%=Split(tuser(2),"#$")(1)%>,<%=Split(tuser(3),"#$")(1)%></li>
			  </ul>
            </div>
			<%End if%>
            <%
                TeamCss =""
                if  Split(tuser(0),"#$")(1) = name or Split(tuser(1),"#$")(1) = name then
                    TeamCss ="base_team"
                else
                    TeamCss ="other_team"
                end if
             %>

            <ul class="point-list" id="rc_<%=rcIDX%>">
              <li>
                <span class="name <%=TeamCss %>"><%=name%> </span>
                <span class="serve on">
                <%If midx = servemidx then%>
                <img src="/tennis/SD_OS/images/tournerment/public/tennis_ball_on@3x.png" alt="서브" style=" width:11px;" >
                <%else %>
                <img src="http://img.sportsdiary.co.kr/sdapp/liveScore/binball@3x.png" alt="서브" style=" width:11px;" >
                <%End if%>
                </span>


                <span class="score <%If winpos = "left" then%> me <%else%> you <%End if%>  <%=TeamCss %>  "   ><%If gameend = "1" then%>GAME WIN<%else%><%=left_sc%> : <%=right_sc%><%End if%></span>
                <span><%=skill1%> <%If skill2 <> "" or skill3 <> "" then%> / <%End if%> </span>
                <%If skill2 <> "" and skill2 <> "기타" then%> <span>  <%=skill2%> <%If skill3 <> ""  then%> / <%End if%>  </span> <%End if%>
                <%If skill3 <> "" and skill3 <> "기타" then%> <span>  <%=skill3%> </span><%End if%>
              </li>
            </ul>
			<%
			colorno = colorno - 1
		Next
	End If


Set skilldef = nothing
Set tuser = Nothing
Set tuserkey = Nothing
Set gamescore = Nothing

db.Dispose
Set db = Nothing
%>
