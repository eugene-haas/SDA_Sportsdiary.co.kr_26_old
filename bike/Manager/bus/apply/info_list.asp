<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
req = request("req")

titleIdx = ""
busidx = ""
searchtxt = ""
If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  titleIdx = oJSONoutput.titleIdx
  busidx = oJSONoutput.busidx
  searchtxt = oJSONoutput.searchtxt
End If

if PN = "" then PN = 1

intPageNum = PN
intPageSize = 10
blockSize = 10

whereSql = ""

if titleIdx <> "" Then
  whereSql = whereSql & " and c.TitleIdx = '"& titleIdx &"' "
end if

if busidx <> "" then
  whereSql = whereSql & " and b.BusIdx = '"& busidx &"' "
end if

if searchtxt <> "" Then
  whereSql = whereSql & " and (d.UserID like '%"& searchtxt &"%' or d.UserName like '%"& searchtxt &"%') "
end if

sqlcount = "select "
sqlcount = sqlcount & " count(a.BusApplyIdx) "
sqlcount = sqlcount & " from tblBikeBusApply a "
sqlcount = sqlcount & " inner join tblBikeBusList b on a.BusIdx = b.BusIdx and b.DelYN = 'N' "
sqlcount = sqlcount & " inner join tblBikeTitle c on b.TitleIdx = c.TitleIdx and c.DelYN = 'N' "
sqlcount = sqlcount & " inner join SD_Member.dbo.tblMember d on a.MemberIdx = d.MemberIDX and d.DelYN = 'N' "
sqlcount = sqlcount & " left join tblBikePayment e on a.PaymentIdx = e.PaymentIdx and e.DelYN = 'N' "
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
sql = sql & " 	rank() over (order by BusApplyIdx) as ranks "
sql = sql & " 	,c.TitleName "
sql = sql & " 	,d.UserID "
sql = sql & " 	,d.UserName "
sql = sql & " 	,d.Sex "
sql = sql & " 	,d.Birthday "
sql = sql & " 	,d.UserPhone "
sql = sql & " 	,b.StartLocation "
sql = sql & " 	,e.PaymentState "
sql = sql & " 	,b.BusFare "
sql = sql & " 	,e.PaymentAccount "
sql = sql & " 	,e.PayDate "
sql = sql & " 	from tblBikeBusApply a "
sql = sql & " 	inner join tblBikeBusList b on a.BusIdx = b.BusIdx and b.DelYN = 'N' "
sql = sql & " 	inner join tblBikeTitle c on b.TitleIdx = c.TitleIdx and c.DelYN = 'N' "
sql = sql & " 	inner join SD_Member.dbo.tblMember d on a.MemberIdx = d.MemberIDX and d.DelYN = 'N' "
sql = sql & " 	left join tblBikePayment e on a.PaymentIdx = e.PaymentIdx and e.DelYN = 'N' "
sql = sql & " 	where a.DelYN = 'N' "& whereSql &" "
sql = sql & " ) table1 where ranks between "& spage+1 &" and "& epage &" order by ranks desc"
'response.write sql
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
        <th>아이디</th>
        <th>선수</th>
        <th>성별</th>
        <th>생년월일</th>
        <th>연락처</th>
        <th>출발장소</th>
        <th>입금여부</th>
        <th>입금액</th>
        <th>가상계좌정보</th>
        <th>가상계좌SMS</th>
        <th>입금일시</th>
      </tr>
    </thead>

    <tbody>
<%
if isnull(list) = false then
  for i = LBound(list,2) to ubound(list,2)
%>
      <tr>
        <td><%=list(0,i)%></td> <!-- 번호 -->
        <td><%=list(1,i)%></td> <!-- 대회명 -->
        <td><%=list(2,i)%></td> <!-- 아이디 -->
        <td><%=list(3,i)%></td> <!-- 선수 -->
        <td><%=GetGenderStr(list(4,i))%></td> <!-- 성별 -->
        <td><%=list(5,i)%></td> <!-- 생년월일 -->
        <td><%=list(6,i)%></td> <!-- 연락처 -->
        <td><%=list(7,i)%></td> <!-- 출발장소 -->
        <td><%=GetPaymentStateStr(list(8,i))%></td> <!-- 입금여부 -->
        <td><%=list(9,i)%></td> <!-- 입금액 -->
        <td><%=list(10,i)%></td> <!-- 가상계좌정보 -->
        <td><button>발송</button></td> <!-- 가상계좌SMS -->
        <td><%=Getdatechk(list(11,i))%></td> <!-- 입금일시 -->
      </tr>
<%
  Next
Else
%>
      <tr>
        <td colspan="13" align="center">리스트를 찾을수 없습니다.</td> <!-- 번호 -->
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
