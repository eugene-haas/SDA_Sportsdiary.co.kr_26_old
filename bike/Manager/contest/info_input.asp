<!-- #include virtual = "/pub/header.bike.asp" -->
<%
req = request("req")
If req <> "" Then
  Set dbI = new clsDBHelper
  Dim inputTitleIdx
  Set oJSONoutput = JSON.Parse(req)
  inputTitleIdx = oJSONoutput.titleIdx

  SQL =       " SELECT TitleHeadIdx, TitleName, Type, Sido "
  SQL = SQL & "     ,  GameAreaIdx, Address, AddressDetail, AddressZip "
  SQL = SQL & "     ,  StartDate, EndDate, ApplyStart, ApplyEnd "
  SQL = SQL & " FROM tblBikeTitle  "
  SQL = SQL & " WHERE TitleIdx = "& inputTitleIdx &" "
  Set rsI = dbI.ExecSQLReturnRs(SQL, Null, B_ConStr)
  If Not rsI.eof Then
    rsTitleHeadIdx   = rsI("TitleHeadIdx")
    rsTitleName      = rsI("TitleName")
    rsType           = rsI("Type")
    rsSido           = rsI("Sido")
    rsGameAreaIdx    = rsI("GameAreaIdx")
    rsAddress        = rsI("Address")
    rsAddressDetail  = rsI("AddressDetail")
    rsAddressZip     = rsI("AddressZip")
    rsStartDate      = rsI("StartDate")
    rsEndDate        = rsI("EndDate")
    rsApplyStart     = rsI("ApplyStart")
    rsApplyEnd       = rsI("ApplyEnd")
  End If

End If
%>


<%
Set db = new clsDBHelper
SQL = " SELECT TitleHeadIdx, HostCode, TitleName FROM tblBikeTitleHead WHERE HostCode = '"& GLOBAL_HOSTCODE &"'"
Set rsTH = db.ExecSQLReturnRs(SQL, Null, B_ConStr)
If Not rsTH.eof Then
  arrRsTH = rsTH.getRows()
  Set rsTH = nothing
End If

SQL = " SELECT HostIdx, HostCode, HostName FROM tblBikeHostCode WHERE DelYN = 'N' "
Set rsH = db.ExecSQLReturnRs(SQL, Null, B_ConStr)
If Not rsH.eof Then
  arrRsH = rsH.getRows()
  Set rsH = nothing
End If

SQL = " SELECT SidoIDX, Sido, SidoNm FROM tblSidoInfo WHERE DelYN = 'N' "
Set rsS = db.ExecSQLReturnRs(SQL, Null, B_Constr)
If Not rsS.eof Then
  arrSido = rsS.getRows()
  Set rsS = nothing
End If

SQL = " SELECT GameAreaIdx, GameAreaName FROM tblBikeGameArea WHERE DelYN = 'N' "
Set rsG = db.ExecSQLReturnRs(SQL, Null, B_Constr)
If Not rsG.eof Then
  arrGameArea = rsG.getRows()
  Set rsG = nothing
End If

%>
<div class="form-group">
  <div class="col-sm-1">
    <label class="control-label">대회</label>
  </div>
  <div class="col-sm-3">
    <select id="titleHead" class="form-control" onchange="addInput($(this), 'titleHead', '대회')">
      <option value="">=대회선택=</option>
      <%
        If IsArray(arrRsTH) Then
          For t = 0 To Ubound(arrRsTH, 2)
            titleHeadIdx   = arrRsTH(0, t)
            hostCode       = arrRsTH(1, t)
            titleName      = arrRsTH(2, t)
            %>
              <option value="" data-title-head-idx="<%=titleHeadIdx%>" data-host-code="<%=hostCode%>" <% If CStr(titleHeadIdx) = CStr(rsTitleHeadIdx) Then %>selected<% End If %>><%=titleName%></option>
            <%
          Next
        End If
      %>
      <option value="add">[추가생성]</option>
    </select>
  </div>

  <div class="col-sm-1">
    <label class="control-label">대회명</label>
  </div>
  <div class="col-sm-3">
    <input type="text" id="titleName" placeholder="대회명을 입력해주세요." value="<%=rsTitleName%>" class="form-control">
  </div>

  <div class="col-sm-1">
    <label class="col-sm-1 control-label">대회유형</label>
  </div>
  <div class="col-sm-3">
    <select id="titleType" class="form-control">
      <option value="">=선택=</option>
      <option value="엘리트" <% If CStr(rsType) = "엘리트" Then %>selected<% End If %>>엘리트</option>
      <option value="생활체육" <% If CStr(rsType) = "생활체육" Then %>selected<% End If %>>생활체육</option>
    </select>
  </div>
</div>

<div class="form-group">
  <div class="col-sm-1">
    <label class="control-label">대회지역</label>
  </div>
  <div class="col-sm-3">
    <select id="sido" class="form-control">
      <option value="">=지역선택=</option>
      <%
        If IsArray(arrSido) Then
          For s = 0 To Ubound(arrSido, 2)
            SidoIDX = arrSido(0, s)
            Sido    = arrSido(1, s)
            SidoNm  = arrSido(2, s)
            %>
              <option value="" data-sido-idx=<%=SidoIDX%> data-sido-num="<%=Sido%>" <% If CStr(Sido) = CStr(rsSido) Then %>selected<% End If %>><%=SidoNm%></option>
            <%
          Next
        End If
      %>
    </select>
  </div>


  <div class="col-sm-1">
    <label class="control-label">경기장명</label>
  </div>
  <div class="col-sm-3">
    <select id="gameArea" class="form-control" onchange="addInput($(this), 'gameArea', '경기장명')">
      <option value="">=경기장선택=</option>
      <%
        If IsArray(arrGameArea) Then
          For g = 0 To Ubound(arrGameArea, 2)
            GameAreaIdx  = arrGameArea(0, g)
            GameAreaName = arrGameArea(1, g)
            %>
              <option value="" data-game-area-idx="<%=GameAreaIdx%>" <% If Cdbl(GameAreaIdx) = Cdbl(rsGameAreaIdx) Then %>selected<% End If %>><%=GameAreaName%></option>
            <%
          Next
        End If
      %>
      <option value="add">[추가생성]</option>
    </select>
  </div>
</div>

<div class="form-group">
    <div class="col-sm-1 ">
      <label class="control-label">주소</label>
    </div>
    <div class="col-sm-3">
      <input type="text" id="address" placeholder="주소" value="<%=rsAddress%>" class="form-control" onclick="execDaumPostCode()">
    </div>

    <div class="col-sm-1 ">
      <label class="control-label">주소상세</label>
    </div>
    <div class="col-sm-3">
      <input type="text" id="addressDetail" placeholder="상세주소" value="<%=rsAddressDetail%>" class="form-control">
    </div>

    <div class="col-sm-1 ">
      <label class="control-label">우편번호</label>
    </div>
    <div class="col-sm-3">
      <input type="text" id="addressZip" placeholder="우편번호" value="<%=rsAddressZip%>" class="form-control">
    </div>

</div>

<div class="form-group">
  <div class="col-sm-1 ">
    <label class="control-label">대회일정</label>
  </div>
  <div class="col-sm-3">
    <div class="input-group input-group-half [ _date ]" id="">
      <input type="text" class="form-control" placeholder="시작일" id="gameStartDate" value="<%=rsStartDate%>">
      <span class="input-group-addon">
        <span class="glyphicon glyphicon-calendar"></span>
      </span>
    </div>

    <div class="input-group input-group-half [ _date ]" id="">
      <input type="text" class="form-control" placeholder="종료일" id="gameEndDate" value="<%=rsEndDate%>">
      <span class="input-group-addon">
        <span class="glyphicon glyphicon-calendar"></span>
      </span>
    </div>
  </div>

  <div class="col-sm-1 ">
    <label class="control-label">신청기간</label>
  </div>
  <div class="col-sm-3">
    <div class="input-group input-group-half [ _date ]" id="">
      <input type="text" class="form-control" placeholder="시작일" id="applyStartDate" value="<%=rsApplyStart%>">
      <span class="input-group-addon">
        <span class="glyphicon glyphicon-calendar"></span>
      </span>
    </div>

    <div class="input-group input-group-half [ _date ]" id="">
      <input type="text" class="form-control" placeholder="종료일" id="applyEndDate" value="<%=rsApplyEnd%>">
      <span class="input-group-addon">
        <span class="glyphicon glyphicon-calendar"></span>
      </span>
    </div>
  </div>


  <div class="col-sm-1">
    <label class="control-label">대회주최</label>
  </div>
  <div class="col-sm-3">
    <select id="host" class="form-control">
      <%
        If IsArray(arrRsH) Then
          For h = 0 To Ubound(arrRsH, 2)
            hostIdx   = arrRsH(0, h)
            hostCode  = arrRsH(1, h)
            hostName  = arrRsH(2, h)
            %>
              <option value="" data-host-code="<%=hostCode%>"><%=hostName%></option>
            <%
          Next
        End If
      %>
    </select>
  </div>
</div>

<div class="btn-group pull-right" role="group" aria-label="...">
  <a href="#" class="btn btn-primary" id="titleInsert" onclick="accessTitle('insert')" accesskey="i">등록<span>(I)</span></a>
  <a href="#" class="btn btn-primary" id="titleEdit" onclick="accessTitle('update', '<%=inputTitleIdx%>')" accesskey="e">수정<span>(E)</span></a>
  <a href="#" class="btn btn-danger" id="titleDelete" onclick="accessTitle('delete', '<%=inputTitleIdx%>')" accesskey="r">삭제<span>(R)</span></a>
</div>

<div id="address_layer" style="position:fixed; top:0; width:400px; height:500px; z-index: 100000; display:none; -webkit-overflow-scrolling:touch; overflow:hidden;"></div>
