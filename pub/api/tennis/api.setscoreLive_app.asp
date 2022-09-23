<%
	'request
	scIDX = oJSONoutput.SCIDX
	p1idx = oJSONoutput.P1
	p2idx = oJSONoutput.P2
	gubun = oJSONoutput.GN '0예선

	Call oJSONoutput.Set("result", "0" )

	'타입 석어서 보낼때 사용
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.write "`##`"

	'$$$$$$$$$$$$$$$$$$$$$$$$
	If s2key = "200" Then
		joinstr = " left "
		singlegame =  true
	Else
		joinstr = " inner "
		singlegame = False
	End if

	joinstr = " inner "
	singlegame = false

	Set db = new clsDBHelper


	'#################################
	'루키테니스 추가 항목
	'#################################
	If hasown(oJSONoutput, "sitegubun") = "ok" then
		sitegubun = oJSONoutput.sitegubun 'K S 카타 SD
	End if
	If sitegubun = "K" Or sitegubun = "" then
	Else
		ConStr =  RT_ConStr
	End If
	'#################################



    Lpint=0
    Rpint=0

    SqlPoint = "select max(gameno)gameno,servemidx,servemname,max(leftscore ) Lpoint,max(rightscore) Rpoint,sum(gameend)gameend ,playsortno" & _
               " from sd_TennisResult_record " & _
               " where resultIDX ='"&scIDX&"' and gameno in (select MAX(gameno) from sd_TennisResult_record where resultIDX ='"&scIDX&"' ) " & _
               " and ( leftscore >0 or rightscore >0)" & _
               " group by servemidx,servemname ,playsortno" & _
               " order by playsortno"
    Set rs = db.ExecSQLReturnRS(SqlPoint , null, ConStr)
	If Not rs.eof Then
        Do Until rs.eof
            servemidx = rs("servemidx")
            servemname = rs("servemname")
            gameend = rs("gameend")
            gameno= rs("gameno")

            Lpint = rs("Lpoint")
            Rpint = rs("Rpoint")

            if gameno >=11 then

            else
                if gameend= 0 then
                    if Lpint = 1 then
                        Lpint =15
                    elseif Lpint = 2 then
                        Lpint =30
                    elseif Lpint = 3 then
                        Lpint =40
                    end if

                    if Rpint = 1 then
                        Rpint =15
                    elseif Rpint = 2 then
                        Rpint =30
                    elseif Rpint = 3 then
                        Rpint =40
                    end if
                else
                    Lpint =""
                    Rpint =""
                end if
            end if

        rs.movenext
        loop
	End if


	strfield = " stateno, m1set1,m1set2,m1set3,m2set1,m2set2,m2set3,  m1set,m2set,tiebreakpt,set1end,set2end,set3end "
	SQL = "select "& strfield &" from  sd_TennisResult where resultIDX = " & scIDX
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

    'Response.Write SQL

	If Not rs.eof Then
		m1s1 = rs("m1set1")
		m1s2 = rs("m1set2")
		m1s3 = rs("m1set3")
		m2s1 = rs("m2set1")
		m2s2 = rs("m2set2")
		m2s3 = rs("m2set3")
		set1end = rs("set1end")
		set2end = rs("set2end")
		set3end = rs("set3end")

		m1set = rs("m1set")
		m2set = rs("m2set")
		tiebreakpt = rs("tiebreakpt")
		stateno = rs("stateno")
	End if
	'##################################################################

	strtable = " sd_TennisMember "
	strtablesub =" sd_TennisMember_partner "
	strwhere = "  a.gamememberIDX = " & p1idx & " or a.gamememberIDX = " & p2idx

	If gubun = "0" Then
	strsort = " order by a.tryoutsortno asc"
	else
	strsort = " order by a.SortNo asc"
	End If

	strAfield = " a. gamememberIDX, a.userName as aname ,a.teamAna as aATN, a.teamBNa as aBTN, a.Round as COL, a.SortNo as ROW,EnterType  "
	strBfield = " b.partnerIDX, b.userName as bname, b.teamAna as bATN , b.teamBNa as bBTN "
	strfield = strAfield &  ", " & strBfield

	SQL = "select "& strfield &" from  " & strtable & " as a "&joinstr&" JOIN " & strtablesub & " as b ON a.gameMemberIDX = b.gameMemberIDX  where " & strwhere & strsort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rscnt =  rs.RecordCount

   ' Response.Write SQL
%>

            <ul class="tn_board_table clearfix">
            <li class="set_line">
                <div class="board_header"></div>
                <div class="win"></div>
                <div class="pts">PTS</div>
                <div class="num">1</div>
                <div class="num">2</div>
                <div class="num">3</div>
            </li>
            <%

            i = 0
            Do Until rs.eof
		            m1idx = rs("gamememberIDX")
		            m2idx = rs("partnerIDX")
		            m1name = rs("aname")
		            m2name = rs("bname")
		            'gno = rs("groupno")
		            ateamname1 = rs("aATN")
		            ateamname2 = rs("aBTN")
		            bteamname1 = rs("bATN")
		            bteamname2 = rs("bBTN")
		            EnterType = rs("EnterType")
            %>
            <li>
              <div class="board_header">
                <!-- S: p_self -->
                <div class="p_self">
                  <% if  m1name=servemname  then %>
                  <span class="serve ic_deco"> <img src="../images/liveScore/ball@3x.png" alt="서브"> </span>
                  <%else %>
                  <span class="serve ic_deco"> <img src="../images/liveScore/binball@3x.png" alt="서브"> </span>
                  <% end if  %>
                  <span class="player"><%=m1name %></span>
                  <span class="team"><%=ateamname1 %><% if bteamname1 <>"" then %> ,<%=bteamname1 %> <% end if  %></span>
                </div>
                <!-- E: p_self -->
                <!-- S: p_pt -->
                <div class="p_pt">
                  <% if  m2name=servemname then  %>
                  <span class="serve ic_deco"><img src="../images/liveScore/ball@3x.png" alt="서브"></span>
                  <%else %>
                   <span class="serve ic_deco"> <img src="../images/liveScore/binball@3x.png" alt="서브"> </span>
                  <% end if  %>
                  <span class="player"><%=m2name %></span>
                  <span class="team"><%=ateamname2 %><% if bteamname2 <>"" then %> ,<%=bteamname2 %> <% end if  %></span>
                </div>
                <!-- E: p_pt -->
              </div>
              <!-- S: win -->
              <div class="win" rowspan="2">
                <div class="img_box">
                <!--  <img src="../images/modal/win_crown@3x.png" alt="win">-->
                <%if stateno= 1 or (stateno=2 and (gameend =1  and gameno>=11)) then %>
                    <%If i = 0 And CDbl(m1set) > (m2set) then%>
                    <img src="../images/modal/win_crown@3x.png" alt="win">
                    <%else %>
                        <%if i = 0 and  CDbl(m1set) = (m2set) and  Lpint > Rpint then %>
                             <img src="../images/modal/win_crown@3x.png" alt="win">
                        <%end if  %>
                    <%End if%>
				    <%If i = 1 And CDbl(m2set) > (m1set) then%>
                        <img src="../images/modal/win_crown@3x.png" alt="win">
                    <%else %>
                        <%if i = 1 And CDbl(m1set) = (m2set) and  Rpint > Lpint then %>
                             <img src="../images/modal/win_crown@3x.png" alt="win">
                        <%end if  %>
                    <%End if%>
                <%end if  %>
                </div>
              </div>
              <!-- E: win -->
                <!--servemidx servemname-->

            <%If i = 0 then%>
              <div class="pts"><%=Lpint %></div>
              <div class="num y"><%=m1s1%><%If m2s1= "7" then%><span class="small">(<%=tiebreakpt%>)</span><%End if%></div>
              <div class="num"><%If EnterType = "A" then%>-<%else%><%=m1s2%><%End if%></div>
              <div class="num y"><%If EnterType = "A" then%>-<%else%><%=m1s3%><%End if%></div>
			<%else%>
              <div class="pts"><%=Rpint %></div>
              <div class="num y"><%=m2s1%><%If m1s1= "7" then%><span class="small">(<%=tiebreakpt%>)</span><%End if%></div>
              <div class="num"><%If EnterType = "A" then%>-<%else%><%=m2s2%><%End if%></div>
              <div class="num y"><%If EnterType = "A" then%>-<%else%><%=m2s3%><%End if%></div>
			<%End if%>
            </li>
            <% if  i = 0 then  %>
            <li class="set_line">
              <div class="board_header"></div>
              <div class="win"></div>
              <div class="pts">PTS</div>
              <div class="num">1</div>
              <div class="num">2</div>
              <div class="num">3</div>
            </li>
            <% end if  %>
            <%
            i = i + 1
            rs.movenext
            loop

            If isdate(set1end) = true Then
	            set1time = hour(CDate(set1end))
	            set1minute = minute(CDate(set1end))

                if set1minute <10 then
                    set1minute = "0"&set1minute
                end if
            End If

            If EnterType = "E" then
	            If isdate(set2end) = true Then
		            set2time = hour(CDate(set2end))
		            set2minute = minute(CDate(set2end))
                    if set2minute <10 then
                        set2minute = "0"&set2minute
                    end if
	            End If
	            If isdate(set3end) = true Then
		            set3time = hour(CDate(set3end))
		            set3minute = minute(CDate(set3end))
                    if set3minute <10 then
                        set3minute = "0"&set3minute
                    end if
	            End If
            End if

           %>
            <li class="duration">
              <div class="board_header">
                <span class="ic_deco"><i class="fa fa-clock-o"></i></span>
                <span>Match Duration</span>
                <span><%=set1time%>:<%=set1minute%></span>
              </div>
              <div class="pts"></div>
              <div class="num"><%If EnterType = "E" then%><%=set2time%>:<%=set2minute%><%End if%></div>
              <div class="num"><%If EnterType = "E" then%><%=set3time%>:<%=set3minute%><%End if%></div>
              <div class="num"><%If EnterType = "A" then%><%=set1time%>:<%=set1minute%><%else%><%=set3time%>:<%=set3minute%><%End if%></div>
              <div class="num">

              </div>
            </li>
          </ul>
            <a href="javascript:score.showScoreLive({'SCIDX':<%=scIDX%>,'P1':<%=p1idx%>,P2:<%=p2idx%>,'GN':1,'JONO':0});" class="btn scorefresh" id="scorefresh">
                <i class="fa fa-repeat" aria-hidden="true"><span id="scorefreshCnt"> 10초 후 새로고침</span>  </i>
            </a>
<% if CMD ="20005" then  %>

		  <!-- S: record -->
		  <div class="record" id="DP_Record"  style="display:block">
			<h3>득실기록</h3>
			<!-- S: set-scroll -->
			<div class="set-scroll">
			  <!-- S: SET -->
			  <section>
                <%
	            strfield = " rcIDX,resultIDX,midx,name,leftscore,rightscore,gameend,servemidx,servemname,   setno,gameno,playsortno, skill1,skill2,skill3 "
	            SQL = "select "& strfield &" from  sd_TennisResult_record where resultIDX = " & scIDX & "  and gameend = 1 order by setno asc, rcIDX desc"
	            Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

                i = 0
                presetno = 0
                Do Until rs.eof

                setno = rs("setno")
                pname = rs("name")
                leftscore = rs("leftscore")
                rightscore = rs("rightscore")

                If leftscore > rightscore Then
	                wincolor = "orange"
                Else
	                wincolor = "green"
                End if

                skill1 = rs("skill1")
                skill2 = rs("skill2")
                skill3 = rs("skill3")
                %>

				<%If i = 0 Or presetno < setno then%>

				<%If presetno > 0 then%>
				</ul>
			  </section>
				<%End if%>


				<h4><%=setno%>SET</h4>
				<ul id="DP_result-list">
				<%End if%>

				  <li>
					<span><%=pname%></span>
					<span class="<%=wincolor%>">WIN</span>

					<span><%=skill1%> / </span>
					<span><%=skill2%><%If skill2 <> ""  then%> / <%End if%></span>
					<span><%=skill3%><%If skill3 <> "" then%> / <%End if%></span>
				  </li>
                <%
                presetno = setno
                i = i + 1
                rs.movenext
                loop
                %>
				</ul>
			  </section>
			  <!-- E: SET -->

            <%If EnterType = "E" then%>
            <%'2 3셋트 표시%>
            <%End if%>

			</div>
			<!-- E: set-scroll -->
		  </div>

    <% end if %>

<%
db.Dispose
Set db = Nothing
%>
