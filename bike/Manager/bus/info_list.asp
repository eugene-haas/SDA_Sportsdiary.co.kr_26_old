<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
req = request("req")

titleIdx = ""
If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  PN = oJSONoutput.get("PN")
  titleIdx = oJSONoutput.get("titleIdx")
Else
  Set oJSONoutput = JSON.Parse("{}")
End If

if PN = "" then PN = 1

intPageNum = PN
intPageSize = 1
blockSize = 10

whereSql = ""

if titleIdx <> "" Then
  whereSql = whereSql & " and b.TitleIdx = '"& titleIdx &"' "
end if

sqlcount = "select "
sqlcount = sqlcount & " count(a.BusIdx) "
sqlcount = sqlcount & " from tblBikeBusList a "
sqlcount = sqlcount & " inner join tblBikeTitle b on a.TitleIdx = b.TitleIdx and b.DelYN = 'N' "
sqlcount = sqlcount & " where a.DelYN = 'N' "& whereSql &" "
'response.write sqlcount
Set rscount = db.execute(sqlcount)
iTotalCount = rscount(0)
set rscount = Nothing

spage = iTotalCount - (intPageNum*intPageSize)
epage = spage + intPageSize

if iTotalCount > 0 then
  tPage = totalPage(iTotalCount, intPageSize)
else
  tPage = 0
end if


sql = "select "
sql = sql & " * "
sql = sql & " from "
sql = sql & " ( "
sql = sql & " 	select "
sql = sql & " 	rank() over (order by busidx) ranks "
sql = sql & " 	,b.TitleName "
sql = sql & " 	,a.StartLocation "
sql = sql & " 	,a.StartDate "
sql = sql & " 	,a.StartTime "
sql = sql & " 	,a.Destination "
sql = sql & " 	,a.BusMemberLimit "
sql = sql & " 	,a.BusFare "
sql = sql & " 	,a.busidx "
sql = sql & " 	from tblBikeBusList a "
sql = sql & " 	inner join tblBikeTitle b on a.TitleIdx = b.TitleIdx and b.DelYN = 'N' "
sql = sql & " 	where a.DelYN = 'N' "& whereSql &" "
sql = sql & " ) table1 where ranks between "& spage+1 &" and "& epage &" order by ranks desc"
' response.write sql
list = null
set rs = db.execute(sql)
if not rs.eof then
  list = rs.GetRows()
end if
set rs = Nothing
%>

<div class="btn-toolbar" role="toolbar" aria-label="btns">
  <a href="#" class="btn btn-link">전체 : <%=iTotalCount%> 건</a>

  <div class="btn-group pull-right">
    <a href="" id="" class="btn btn-primary">버튼</a>
    <a class="btn btn-success">엑셀다운로드</a>
  </div>
</div>

<div class="table-responsive">
  <table cellspacing="0" cellpadding="0" class="table table-hover">
    <thead>
      <tr>
        <th>번호</th>
        <th>대회명</th>
        <th>출발장소</th>
        <th>출발날짜</th>
        <th>출발시간</th>
        <th>도착장소</th>
        <th>정원</th>
        <th>승차비</th>
      </tr>
    </thead>

    <tbody>
<%
if isnull(list) = false then
  for i = LBound(list,2) to ubound(list,2)
%>
      <tr class="title_row" data-title-idx=<%=list(8,i)%> onclick="selectTitle(<%=list(8,i)%>, $(this))">
        <td><%=list(0,i)%></td>
        <td><%=list(1,i)%></td>
        <td><%=list(2,i)%></td>
        <td><%=list(3,i)%></td>
        <td><%=left(list(4,i),5)%></td>
        <td><%=list(5,i)%></td>
        <td><%=list(6,i)%></td>
        <td><%=list(7,i)%></td>
      </tr>
<%
  Next
Else
%>
      <tr>
        <td colspan="8" align="center">리스트를 찾을수 없습니다.</td> <!-- 번호 -->
      </tr>
<%
end if
%>
    </tbody>
  </table>
</div>

<nav>
  <div class="container-fluid text-center">
    <%
      jsonStr = JSON.Stringify(oJSONoutput)
      Call bikeAdminPaging(tPage, blockSize, PN, "goPN", jsonStr, "info_list.asp", "infoList")
    %>
  </div>
</nav>
