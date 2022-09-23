<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->
<%
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
tidx = request("tidx")

whereSql = ""
if tidx <> "" Then
  whereSql = whereSql & " and TitleIdx = '"& tidx &"'"
Else
  whereSql = whereSql & " and TitleIdx = '0'"
end if

busSql = "select BusIdx,StartLocation from tblBikeBusList where DelYN = 'N' "& whereSql &" "
set busRs = db.execute(busSql)
response.clear
%>
<select id="busidx" class="form-control">
  <%
  if not busRs.eof Then
  %>
  <option value="">전체</option>
  <%
    do until busRs.eof
  %>
  <option value="<%=busRs("BusIdx")%>"><%=busRs("StartLocation")%></option>
  <%
      busRs.movenext
    loop
  Else
  %>
  <option value="">검색할 버스가 없습니다.</option>
  <%
  end if
  set busRs = nothing
  %>
</select>
