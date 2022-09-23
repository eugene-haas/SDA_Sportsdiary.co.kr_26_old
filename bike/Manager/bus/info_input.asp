<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->
<%
req = request("req")
If req <> "" Then
  Set dbI = new clsDBHelper
  Dim inputbusIdx
  Set oJSONoutput = JSON.Parse(req)
  inputTitleIdx = oJSONoutput.get("titleIdx")
  inputbusIdx = oJSONoutput.get("busidx")

  SQL =       " select BusIdx, TitleIdx, StartLocation, StartDate, StartTime, Destination , BusMemberLimit, BusFare "
  SQL = SQL & " from tblBikeBusList a where a.DelYN = 'N' and BusIdx = '"& inputbusIdx &"' "
  Set rsI = dbI.ExecSQLReturnRs(SQL, Null, B_ConStr)
  If Not rsI.eof Then
    rsBusIdx = rsI("BusIdx")
    rsTitleIdx = rsI("TitleIdx")
    rsStartLocation = rsI("StartLocation")
    rsStartDate = rsI("StartDate")
    rsStartTime = rsI("StartTime")
    rsDestination = rsI("Destination")
    rsBusMemberLimit = rsI("BusMemberLimit")
    rsBusFare = rsI("BusFare")
  End If

End If

Set db = new clsDBHelper
SQL = " SELECT TitleIdx, TitleName FROM tblBikeTitle WHERE DelYN = 'N'"
Set rsTH = db.ExecSQLReturnRs(SQL, Null, B_ConStr)
If Not rsTH.eof Then
  arrRsTH = rsTH.getRows()
  Set rsTH = nothing
End If

%>
<div class="form-group">
  <div class="col-sm-1">
    <label class="control-label">대회</label>
  </div>
  <div class="col-sm-3">
    <select id="titleIdx" class="form-control">
      <option value="">=대회선택=</option>
      <%
        If IsArray(arrRsTH) Then
          For t = 0 To Ubound(arrRsTH, 2)
            titleIdx   = arrRsTH(0, t)
            titleName      = arrRsTH(1, t)
            %>
              <option value="<%=titleIdx%>" <% If CStr(titleIdx) = CStr(rsTitleIdx) Then %>selected<% End If %>><%=titleName%></option>
            <%
          Next
        End If
      %>
    </select>
  </div>

  <div class="col-sm-1">
    <label class="control-label">출발장소</label>
  </div>
  <div class="col-sm-3">
    <input type="text" id="StartLocation" placeholder="출발장소를 입력하세요." value="<%=rsStartLocation%>" class="form-control">
  </div>

  <div class="col-sm-1">
    <label class="col-sm-1 control-label">도착장소</label>
  </div>
  <div class="col-sm-3">
    <input type="text" id="Destination" placeholder="도착장소를 입력하세요." value="<%=rsDestination%>" class="form-control">
  </div>
</div>

<div class="form-group">
  <div class="col-sm-1 ">
    <label class="control-label">출발날짜</label>
  </div>
  <div class="col-sm-3">
    <div class="input-group input-group-half [ _date ]" id="">
      <input type="text" class="form-control" placeholder="출발날짜" id="StartDate" value="<%=rsStartDate%>">
      <span class="input-group-addon">
        <span class="glyphicon glyphicon-calendar"></span>
      </span>
    </div>

    <div class="input-group input-group-half [ _time ]" id="">
      <input type="text" class="form-control" placeholder="시간" id="StartTime" value="<%=rsStartTime%>">
      <span class="input-group-addon">
        <span class="glyphicon glyphicon-time"></span>
      </span>
    </div>
  </div>

  <div class="col-sm-1 ">
    <label class="control-label">정원</label>
  </div>
  <div class="col-sm-3">
    <input type="text" id="BusMemberLimit" placeholder="정원을 입력하세요." value="<%=rsBusMemberLimit%>" class="form-control">
  </div>


  <div class="col-sm-1">
    <label class="control-label">승차비</label>
  </div>
  <div class="col-sm-3">
    <input type="text" id="BusFare" placeholder="승차비를 입력하세요." value="<%=rsBusFare%>" class="form-control">
  </div>
</div>

<div class="btn-group pull-right" role="group" aria-label="...">
  <a href="#" class="btn btn-primary" id="titleInsert" onclick="accessBus('insert')" accesskey="i">등록<span>(I)</span></a>
  <a href="#" class="btn btn-primary" id="titleEdit" onclick="accessBus('update', '<%=inputbusIdx%>')" accesskey="e">수정<span>(E)</span></a>
  <a href="#" class="btn btn-danger" id="titleDelete" onclick="accessBus('delete', '<%=inputbusIdx%>')" accesskey="r">삭제<span>(R)</span></a>
</div>

<div id="address_layer" style="position:fixed; top:0; width:400px; height:500px; z-index: 100000; display:none; -webkit-overflow-scrolling:touch; overflow:hidden;"></div>
