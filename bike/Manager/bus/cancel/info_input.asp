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
if titleIdx = "" then titleIdx = 0
titleSql = "select TitleIdx,TitleName from tblBikeTitle where DelYN = 'N'"
set titleRs = db.execute(titleSql)

busoption = ""
if titleIdx <> "" Then
  whereSql = whereSql & " and TitleIdx = '"& titleIdx &"'"
Else
  whereSql = whereSql & " and TitleIdx = '0'"
end if

busSql = "select BusIdx,StartLocation from tblBikeBusList where DelYN = 'N' "& whereSql &" "
set busRs = db.execute(busSql)
if not busRs.eof Then
  busoption = busoption & "<option value=''>전체</option>"
  do until busRs.Eof
    if CDbl(busRs("BusIdx")) = busidx then
      busoption = busoption & "<option value='"& busRs("BusIdx") &"'>"& busRs("StartLocation") &"</option>"
    Else
      busoption = busoption & "<option value='"& busRs("BusIdx") &"' selected>"& busRs("StartLocation") &"</option>"
    end if
    busRs.movenext
  Loop
Else
  busoption = busoption & "<option value=''>대회를 선택하세요.</option>"
end if
%>

<div class="form-group">

  <div class="col-sm-1">
    <label class="control-label">대회</label>
  </div>
  <div class="col-sm-2">
    <select id="gametitleidx" class="form-control" onchange="on_select_title(this)">
      <option value="">대회명을 선택하세요.</option>
<%
if not titleRs.eof Then
  do until titleRs.eof
%>
      <option value="<%=titleRs("TitleIdx")%>" <%if CDbl(titleRs("TitleIdx")) = CDbl(titleIdx) then response.write "selected"%>><%=titleRs("TitleName")%></option>
<%
    titleRs.movenext
  loop
end if

set titleRs = nothing
%>
    </select>
  </div>

  <div class="col-sm-1">
    <label class="control-label">출발장소</label>
  </div>
  <div class="col-sm-2" id="location_div">
    <select id="busidx" class="form-control">
      <%=busoption%>
    </select>
  </div>

  <div class="col-sm-1">
    <label class="control-label">이름/아이디</label>
  </div>

  <div class="col-sm-2">
    <div class="input-group">
      <input type="text" class="form-control" placeholder="검색할 이름 또는 아이디" id="searchtxt" value="<%=searchtxt%>">
      <span class="input-group-btn">
        <a class="btn btn-primary " href="javascript:busSearch();">검색</a>
      </span>
    </div>
  </div>

</div>
<form name="frm" id="frm"><input type="hidden" name="req" id="req"></form>
