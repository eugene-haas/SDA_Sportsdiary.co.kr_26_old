<!-- #include virtual = "/pub/header.RookieTennis.asp" -->
<!DOCTYPE html>
<html lang="ko-KR">
<head>
    <!--#include file = "./include/head.asp" -->

    <%
    Set db = new clsDBHelper


    if  ChekMode = 0 then
        CMD= 300
    else
        CMD= 300
    end if
    ChekMode  = fInject(Request("ChekMode"))
    ridx  = fInject(Request("ridx"))
    Years     = fInject(Request("Years"))
    Months     = fInject(Request("Months"))
    GameTitleIDX     = fInject(Request("GameTitleIDX"))
    GameTitleName  = fInject(Request("GameTitleName"))
    TeamGb  = fInject(Request("TeamGb"))
    TeamGbNm  = fInject(Request("TeamGbNm"))
    levelno  = fInject(Request("levelno"))
    levelNm  = fInject(Request("levelNm"))
    EntryCntGame  = fInject(Request("EntryCntGame"))

    If GameTitleIDX = "" Then
        Response.redirect "./list.asp"
        Response.end
    End if
    If ridx = "" Then
        Response.redirect "./list.asp"
        Response.end
    End if

'GameTitleIDX = 119
'ridx = 37110
'levelno = 20104009

    ''대회 정보 검색

    if ridx <> "" and ChekMode=1 then
        SQL ="select EntryCntGame,cfg,SUBSTRING(cfg,2,1)Ch_i,SUBSTRING(cfg,3,1)Ch_u,SUBSTRING(cfg,4,1)Ch_d from tblRGameLevel where GameTitleIDX = '"&GameTitleIDX&"' and level='"&levelno&"' and  delYN='N' "
    	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

        If Not rs.EOF Then
        Do Until rs.eof
            cfg = Rs("cfg")
            Ch_i = Rs("Ch_i")
            Ch_u = Rs("Ch_u")
            Ch_d = Rs("Ch_d")
        rs.movenext
        Loop
        End if
    End if

    %>

    <script src="/pub/js/rookietennis/tennis_Request.js<%=CONST_JSVER%>" type="text/javascript"></script>
    <script>
        var Now = new Date();
        var NowTime = Now.getFullYear();
        var m = Now.getMonth() + 1;
        if (m < 10) {
            NowTime += '-0' + m;
        } else {
            NowTime += '-' + m;
        }
        NowTime += '-' + Now.getDate();

        function chk_frm(val) {
            var sf = document.frm_in;

            if (val == 0) {
                sf.action = "./info_list.asp?GameTitleIDX="+$("#GameTitleIDX").val() + "&levelno=" + $("#levelno").val() ;
            }
            else if (val == 2) {
                //수정
                chek_form_data(val);
                $("#FormDelete").css("display", "none");
                $("#FormUpdate").css("display", "");
            }
            else if (val == 1) {
                //삭제
                $("#aTcommit").click();
                $("#FormDelete").css("display", "");
                $("#FormUpdate").css("display", "none");
            } else if (val == 10) {
                //대회목록
                sf.action = "./list.asp" + ver;
            } else if (val == 11) {
                //참가신청목록
                sf.action = "./list.asp" + ver;
            } else if (val == 12) {
                //참가신청목록
                sf.action = "./info_list.asp" + ver;
            } else if (val == 999) {
                //참가신청내역
                sf.action = "./info_list.asp" + ver;
            } else if (val == 888) {
                //참가신청 완료 후 확인창 이동
                sf.action = "./write_ok.asp" + ver;
            }
            sf.submit();

        }

        $(document).ready(function () {
            var obja = {};
            obja.CMD = mx_player.CMD_Request_Edit_s1; //화면그림
            obja.IDX = $("#GameTitleIDX").val();
            obja.levelno = $("#levelno").val();
            obja.ridx = $("#ridx").val();
            obja.ChekMode = $("#ChekMode").val();
            mx_player.SendPacket("ContentsList", obja, mx_player.ajaxURL);
        });
    </script>
</head>
<body id="AppBody">
<div class="l">

  <div class="l_header">

    <!-- S: sub-header -->
    <div class="m_header">
        <!-- #include file="./include/header_back.asp" -->
        <h1 class="m_header__tit">참가신청서</h1>
        <!-- #include file="./include/header_home.asp" -->
    </div>
    <!-- E: sub-header -->

  </div>

    <!-- S: main -->
	<iframe name="hiddenFrame1" style="display:none"></iframe>
	<iframe name="hiddenFrame2" style="display:none"></iframe>
	<iframe name="hiddenFrame3" style="display:none"></iframe>
    <div id="SmsFormSubmit"></div>

    <div class="l_content m_scroll application [ _content _scroll ]">

        <form method="post" name="frm_in" id="frm_in">
            <input  type="hidden" name="Years" id="Years" value="<%=Years %>"/>
            <input  type="hidden" name="Months" id="Months" value="<%=Months %>"/>
            <input  type="hidden" name="ChekMode" id="ChekMode" value="<%=ChekMode %>"/>
            <input  type="hidden" name="CMD" id="CMD" value="<%=CMD %>"/>
            <input  type="hidden" name="ridx" id="ridx" value="<%=ridx %>"/>
            <input  type="hidden" name="TitleIDX" id="TitleIDX" value="<%=GameTitleIDX %>"/>
            <input  type="hidden" name="GameTitleIDX" id="GameTitleIDX" value="<%=GameTitleIDX %>"/>
            <input  type="hidden" name="GameTitleName" id="GameTitleName" value="<%=GameTitleName %>"/>
            <input  type="hidden"  name="TeamGb" id="TeamGb" value="<%=TeamGb %>"/>
            <input  type="hidden"  name="TeamGbNm" id="TeamGbNm" value="<%=TeamGbNm %>"/>
            <input  type="hidden"  name="levelNm"  id="levelNm"value="<%=levelNm %>"/>
            <input  type="hidden"  name="Fnd_Kw"  id="Fnd_Kw"value=""/>



            <%
            SQL = " select b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame "
            SQL = SQL &" ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt ,b.cfg, max(b.fee) as fee, max(b.fund) as fund "
            SQL = SQL &" ,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d , d.lmsSendChk ,count(s.gameMemberIDX)MemberCnt"
            SQL = SQL &"  from tblRGameLevel b  "
            SQL = SQL &"  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "
            SQL = SQL &"  inner join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' and d.RequestIDX= "&ridx
            SQL = SQL &"  left JOIN sd_TennisMember s on d.GameTitleIDX = s.GameTitleIDX and d.Level = s.gamekey3 and s.DelYN='N' and d.P1_PlayerIDX= s.PlayerIDX and isnull(Round,0)=0"
            SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&GameTitleIDX&"' and c.LevelNm not like '%최종%'  "
            SQL = SQL &"  and  c.Level='"&levelno&"'"
            SQL = SQL &"  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,b.cfg,   d.lmsSendChk "
            Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


            If Not rs.EOF Then
            	MemberCnt = rs("MemberCnt")
            	fee = rs("fee")
            	fund = rs("fund")
            	acctotal = CDbl(fee) + CDbl(fund)
            End if


            If CDbl(acctotal) > 0 Then '금액이 0이상인 경우만
        		SQL = "Select VACCT_NO from TB_RVAS_MAST where CUST_CD = '" &Left(sitecode,2) &  ridx & "' and sitecode = '"&sitecode&"' "
        		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

        		If Not rs.eof Then
        			acct = rs(0)
        		End if
        		%>

        		<%if Cdbl(MemberCnt)<=0 then %>

			<div class="guideTxt">
				<p class="guideTxt__competitionName">"<%=GameTitleName %>"</p>
				<p class="guideTxt__txt"><span class="guideTxt__emphasis">참가 신청이 완료</span> 되었습니다.</p>
                <p class="guideTxt__txt"><span class="guideTxt__emphasis">대기팀</span>으로 등록 되었습니다.</p>
			</div>

        		<%else%>

            <div class="guideTxt">
				<p class="guideTxt__competitionName">"<%=GameTitleName %>"</p>
				<p class="guideTxt__txt"><span class="guideTxt__emphasis">참가 신청이 완료</span> 되었습니다.</p>
			</div>
            <div class="m_noticeDeposit">
                <p class="m_noticeDeposit__txt">
					<span class="m_noticeDeposit__lable">가상계좌 번호</span>
					<span><%=acct%>&nbsp;<%=CONST_BANKNM%></span>
				</p>
				<p class="m_noticeDeposit__txt">
					<span class="m_noticeDeposit__lable">참가비 금액</span>
					<span><%=acctotal%>원</span>
				</p>
            </div>

        		<%End if%>
            <%else%>
           <!-- S: 참가신청 완료 -->
            <div class="guideTxt">
                <p class="guideTxt__competitionName">"<%=GameTitleName %>"</p>
                <p class="guideTxt__txt"><span class="guideTxt__emphasis">참가 신청이 완료</span> 되었습니다.</p>
                <%
                    SQL = " select  convert(date,GameS)GameS,convert(date,GameE)GameE from sd_TennisTitle  where DelYN='N' and GameTitleIDX= '"&GameTitleIDX&"' "
        			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

                    If Not(Rs.Eof Or Rs.Bof) Then
                    Do Until Rs.Eof
                %>
        		<p class="guideTxt__date"><%=Replace(Rs("GameS"),"-","/") %><span>(<%=weekDayName(weekDay(Rs("GameS"))) %>) ~ <%=Replace(Rs("GameE"),"-","/") %><span>(<%=weekDayName(weekDay(Rs("GameE"))) %>)</p>
                <%
                    Rs.MoveNext
                    Loop
                    end if
                %>
        	</div>
            <!-- E: 참가신청 완료 -->
            <%End if%>

        	<!-- s: 참가자 정보 & 파트너 정보 -->
            <div class="sd_subTit s_blue02">
                <h3 class="sd_subTit__tit">대회 신청 내역 확인</h3>
            </div>

        	<div class="m_applicationForm s_outline">
                <ul>
    	            <li class="m_applicationForm__item">
    		            <span class="m_applicationForm__label">출전부</span>
    		            <span class="m_applicationForm__inputWrap">
                        <%
                            SQL = " select b.GameType, b.TeamGb,case left(b.cfg,1) when 'Y' then b.TeamGbNm +'(B)' else b.TeamGbNm end  TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame "
                            SQL = SQL &" ,sum(case when isnull(d.P1_PlayerIDX,'')=''  then 0 else 1 end ) RequestCnt ,b.cfg"
                            SQL = SQL &" ,SUBSTRING(b.cfg,2,1)Ch_i,SUBSTRING(b.cfg,3,1)Ch_u,SUBSTRING(b.cfg,4,1)Ch_d"
                            SQL = SQL &"  from tblRGameLevel b  "
                            SQL = SQL &"  inner join tblLevelInfo c on b.SportsGb = c.SportsGb and b.TeamGb = c.TeamGb and b.Level = c.Level and c.DelYN='N' "
                            SQL = SQL &"  left join tblGameRequest d on b.GameTitleIDX = d.GameTitleIDX and b.Level = d.Level and d.DelYN='N' "
                            SQL = SQL &"  where b.DelYN='N' and b.GameTitleIDX='"&GameTitleIDX&"' and c.LevelNm not like '%최종%'  "
                            if levelno <>"" and ridx <>"" then
                            SQL = SQL &"  and  c.Level='"&levelno&"'"
                            end if
                            SQL = SQL &"  group by  b.GameType, b.TeamGb,b.TeamGbNm,c.Level,c.LevelNm ,GameDay,GameTime,EntryCntGame,b.cfg  "
                        %>
    			            <select class="m_applicationForm__select" id="levelno" name="levelno" disabled>
                            <%
                                i = 0
    							Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

                                If Not(Rs.Eof Or Rs.Bof) Then
                                Do Until Rs.Eof
                                    if ChekMode = 0 and ridx ="" then
                                        if Rs("Ch_i") ="Y" then
                                            i=i+1
                                        %>
    			                        <option value="<%=Rs("Level") %>" <% if levelno =Rs("Level") then %> selected<% end if  %> ><%=Rs("TeamGbNm") %>(<%=Rs("LevelNm") %>) <%=Rs("RequestCnt") %>/<%=Rs("EntryCntGame") %></option>
                                        <%
                                        end if
                                    else
                                    %>
    			                    <option value="<%=Rs("Level") %>" <% if levelno =Rs("Level") then %> selected<% end if  %> ><%=Rs("TeamGbNm") %>(<%=Rs("LevelNm") %>) <%=Rs("RequestCnt") %>/<%=Rs("EntryCntGame") %></option>
                                    <%
                                    end if
                                Rs.MoveNext
                                Loop
                                end if

                             %>
    			            </select>
                            <%
                                if ChekMode = 0 and i = 0 then
                                %>
                                    <script type="text/javascript">
                                        //alert("참가신청 기간이 아닙니다.");
                                        //location.href = "./list.asp" + ver;
                                    </script>
                                <%
                                end if
                             %>
    		            </span>
    	            </li>
                </ul>
                <h4 class="m_applicationForm__tit"> 신청자 정보 </h4>
	            <ul>
                    <li class="m_applicationForm__item">
                        <span class="m_applicationForm__label">신청자 이름</span>
                        <span class="m_applicationForm__inputWrap">
	                        <input type="text" class="m_applicationForm__input ui-autocomplete-input" id="attname" name="attname" placeholder=":: 이름을 입력하세요 ::"  autocomplete="off" value=""    onfocus="this.select()" disabled>
                        </span>
                    </li>
                    <li class="m_applicationForm__item">
                        <span class="m_applicationForm__label">휴대폰 번호</span>
                        <span class="m_applicationForm__inputWrap">
                            <input type="hidden" name="attphone" id="attphone" value=""/>
	                        <select class="m_applicationForm__select s_phone" id="attphone1" name="attphone1" disabled>
		                        <option value="010">010</option>
		                        <option value="011">011</option>
		                        <option value="016">016</option>
		                        <option value="017">017</option>
		                        <option value="018">018</option>
		                        <option value="019">019</option>
	                        </select>
	                        <span class="m_applicationForm__txt s_phone">-</span>
	                        <input type="password" class="m_applicationForm__input s_phone" id="attphone2" name="attphone2" max="9999" maxlength="4" oninput="maxLengthCheck(this);" value=""onfocus="this.select()" autocomplete="off" disabled>
	                        <span class="m_applicationForm__txt s_phone">-</span>
	                        <input type="number" class="m_applicationForm__input s_phone" id="attphone3" name="attphone3" max="9999" maxlength="4" oninput="maxLengthCheck(this);" value=""onfocus="this.select()" autocomplete="off" disabled>
                        </span>
                    </li>
		            <li class="m_applicationForm__item">
			            <span class="m_applicationForm__label">입금자명</span>
			            <span class="m_applicationForm__inputWrap">
				            <input type="text" class="m_applicationForm__input" id="inbankname" name="inbankname" value="" readonly  placeholder=":: 이름을 입력하세요 ::"  autocomplete="off">
			            </span>
		            </li>
	            </ul>
                <h4 class="m_applicationForm__tit">기타 건의내용</h4>
                <ul>
                    <li class="m_applicationForm__item">
                        <textarea id="attask" name="attask" class="m_applicationForm__textarea" readonly></textarea>
                    </li>
                </ul>
                <div id="ContentsList"> </div>
        	</div>
        	<!-- e: 참가자 정보 & 파트너 정보 -->

        	<!-- s: 버튼 리스트 -->
        	<div class="te_reqBtnWrap">
                <a href="javascript:chk_frm('0');" class="te_reqBtnWrap__btn s_viewDetail">신청내역 보기</a>
        		<a href="javascript:chk_frm('10');" class="te_reqBtnWrap__btn s_apply2">신청완료</a>
        	</div>
        	<!-- s: 버튼리스트 -->

        </form>
    </div>

    <!-- E: main -->
    <!--#include file = "./include/foot.asp" -->

</div>
</body>
</html>
