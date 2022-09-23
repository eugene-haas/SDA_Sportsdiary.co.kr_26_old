
<% 
'//////// 대진표 라운드 수정 /////
	
	rTitleIDX = oJSONoutput.TitleIDX
	ridx = oJSONoutput.idx
	rlevelno = oJSONoutput.levelno
	rgubun = oJSONoutput.gubun

    '기존 위치
	r1round = cint(oJSONoutput.gno)
	r1sortno = cint(oJSONoutput.SortNo)
	r1p1idx = oJSONoutput.p1idx

    '변경될곳
	r2Round = cint(oJSONoutput.Rround)
	r2SortNo = cint(oJSONoutput.RsortNo)
	r2PlayerIDX1 = oJSONoutput.RPlayerIDX1
    %>
    <span> 
    <%
       ' Response.Write " rTitleIDX : " & rTitleIDX & " <br>"
       ' Response.Write " ridx : " & ridx & " <br>"
       ' Response.Write " rlevelno : " & rlevelno & " <br>"
       ' Response.Write " rgubun : " & rgubun & " <br>"
       ' Response.Write " r1round : " & r1round & " <br>"
       ' Response.Write " r1sortno : " & rTitleIDX & " <br>"
       ' Response.Write " r1p1idx : " & r1p1idx & " <br>"
       ' Response.Write " r2Round : " & r2Round & " <br>"
       ' Response.Write " r2SortNo : " & r2SortNo & " <br>"
       ' Response.Write " r2PlayerIDX1 : " & r2PlayerIDX1 & " <br>"
        
     %>
    </span>
    <%


    Set db = new clsDBHelper

    ' 예선 에서 선택
    if r1round= 0 then 

        sql =" update sd_TennisMember "
        sql = sql & " set SortNo ='"&r2SortNo&"' "
        sql = sql & " where GameTitleIDX = '"&rTitleIDX&"'  "
        sql = sql & " and gubun =2 "
        sql = sql & " and gamekey3='"&rlevelno&"' " 
        sql = sql & " and PlayerIDX='"&r1p1idx&"' " 
        sql = sql & " and Round='"&r2Round&"'"
        Call db.execSQLRs(SQL , null, ConStr)


        %> <span> 예선</span><span> <%=sql %></span><%

    else
    '본선에서 자리 바꿈

        ' 기존
        sql =" update sd_TennisMember "
        sql = sql & " set SortNo ='"&r1sortno&"' "
        sql = sql & " where GameTitleIDX = '"&rTitleIDX&"'  "
        sql = sql & " and gubun =2 "
        sql = sql & " and gamekey3='"&rlevelno&"' " 
        sql = sql & " and PlayerIDX='"&r2PlayerIDX1&"' " 
        sql = sql & " and Round='"&r2Round&"'"
        Call db.execSQLRs(SQL , null, ConStr)
        %> <span> 기존</span><span> <%=sql %></span><%

        '변경
        sql =" update sd_TennisMember "
        sql = sql & " set SortNo ='"&r2SortNo&"' "
        sql = sql & " where GameTitleIDX = '"&rTitleIDX&"'  "
        sql = sql & " and gubun =2 "
        sql = sql & " and gamekey3='"&rlevelno&"' " 
        sql = sql & " and PlayerIDX='"&r1p1idx&"' " 
        sql = sql & " and Round='"&r1round&"'"
       Call db.execSQLRs(SQL , null, ConStr)
       %> <span> 변경</span><span> <%=sql %></span><%

    end if 

        
  db.Dispose
  Set db = Nothing


 %>