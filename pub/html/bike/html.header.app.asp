<!-- S: back btn-->
<%Select Case PAGENAME %>
<%Case "request_competition_detail.asp","payment.asp","request_history.asp"%>
<a href="/bike/M_Player/main/index.asp" role="button" class="m_header__backBtn">이전</a>
<%Case "request_competition.asp"%>
<a href="/bike/m_player/request/request_history.asp" role="button" class="m_header__backBtn">이전</a>
<%Case "gameimg.asp" %>
<% If pno = 3 Then %>
<a href='javascript:mp.goPage({"pno":2,"seq":<%=seq%>}, "/bike/M_Player/Board/gameIMG.asp")' role="button" class="m_header__backBtn">이전</a>
<% ElseIf pno = 2 Then %>
<a href='javascript:mp.goPage(null, "/bike/M_Player/Board/gameIMG.asp")' role="button" class="m_header__backBtn">이전</a>
<% ElseIf pno = 1 Then %>
<a href='javascript:mp.goPage(null, "/bike/M_Player/main/index.asp")' role="button" class="m_header__backBtn">이전</a>
<% End If %>
<%Case else%>
<a href="javascript:history.back();" role="button" class="m_header__backBtn">이전</a>
<%End select%>
<!-- E: back btn -->

<h1 class="m_header__tit"><%=oJSONoutput.name%></h1>

<!-- S: home btn -->

<a href="/bike/m_player/main/index.asp" class="m_header__homeBtn">홈</a>

<!-- E: home btn -->
