<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
Dim TotalCount : TotalCount = 0
Set db = new clsDBHelper

req = request("req")
If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  PN            = oJSONoutput.get("PN")
Else
  Set oJSONoutput = JSON.Parse("{}")
End If

' S:페이징 설정값
If PN = "" Then
  PN = 1
End If
pageSize = 1000
blockSize = 10
' E:페이징 설정값

SQL =       " SELECT * FROM ( "
SQL = SQL & " SELECT TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY WriteDate DESC) RowNum, * FROM ( "
SQL = SQL & " SELECT COUNT(*) OVER(PARTITION BY 1) TotalCount "
SQL = SQL & "     ,  a.TitleIdx, b.HostCode, TitleName, c.SidoNm, StartDate, EndDate "
SQL = SQL & "     ,  ApplyOpenYN, CalendarOpenYN, MatchTableOpenYN, OpenYN, Summary, TitleRule, EventRule, a.WriteDate,a.tableimg,a.resultimg "
SQL = SQL & " FROM tblBikeTitle a "
SQL = SQL & " LEFT JOIN tblBikeHostCode b ON a.HostIdx = b.Hostidx "
SQL = SQL & " LEFT JOIN tblSidoInfo c ON a.Sido = c.Sido "
SQL = SQL & " WHERE a.DelYN = 'N' "
SQL = SQL & " ) T1 "
SQL = SQL & " ORDER BY WriteDate DESC "
SQL = SQL & " ) T2 "
SQL = SQL & " WHERE RowNum BetWeen "& ((PN - 1) * pageSize) + 1 &" AND "& PN * pageSize &" "
Set rs = db.ExecSQLReturnRs(SQL, Null, B_ConStr)
If Not rs.eof Then
  TotalCount = rs("TotalCount")
  arrRs = rs.getRows()
End If

%>

<div class="btn-toolbar" role="toolbar" aria-label="btns">
  <a href="#" class="btn btn-link">전체 : <%=TotalCount%> 건</a>

  <div class="btn-group pull-right">
    <a href="" id="" class="btn btn-primary">버튼</a>
  </div>
</div>



<div class="table-responsive">
	<table cellspacing="0" cellpadding="0" class="table table-hover">
		<thead>
			<tr>
				<th>번호<span></span></th>
				<th>기간</th>
				<th>지역</th>
				<th>대회명</th>
				<th>참가신청/달력/대진표/대회노출</th>
        <th>경기유형관리</th>
				<th>대회요강</th>
        <th>대회규정</th>
        <th>종목설명</th>
        <th>대진표</th>
        <th>대회결과</th>
			</tr>
		</thead>

		<tbody>
      <%
        If IsArray(arrRs) Then
          For i = 0 To Ubound(arrRs, 2)
            TitleIdx          = arrRs(2, i)
            HostCode          = arrRs(3, i)
            TitleName         = arrRs(4, i)
            SidoNm            = arrRs(5, i)
            StartDate         = arrRs(6, i)
            EndDate           = arrRs(7, i)
            ApplyOpenYN       = arrRs(8, i)
            CalendarOpenYN    = arrRs(9, i)
            MatchTableOpenYN  = arrRs(10, i)
            OpenYN            = arrRs(11, i)
            Summary           = arrRs(12, i)
            TitleRule         = arrRs(13, i)
            EventRule         = arrRs(14, i)
			tableimg = arrRs(16,i)
			resultimg = arrrs(17,i)

            %>
            <tr class="title_row" data-title-idx=<%=TitleIdx%> onclick="selectTitle(<%=TitleIdx%>, $(this))">
              <td data-p="<%=encode("titleIdx=" & TitleIdx, 0)%>"><span><%=TitleIdx%></span></td>
              <td><span><%=StartDate%>~<%=EndDate%></span></td>
              <td><span><%=SidoNm%></span></td>
              <td><span><%=TitleName%></span></td>
              <td>
                <span>
                  <label class="switch" title="참가신청">
                    <input type="checkbox" data-open-state="<%=ApplyOpenYN%>" id="apply<%=TitleIdx%>" onclick="changeOpenState('apply', <%=TitleIdx%>)" value="" <% If ApplyOpenYN = "Y" Then %>checked<% End If %>>
                    <span class="slider round"></span>
                  </label>
                  <label class="switch" title="대회달력">
                    <input type="checkbox" data-open-state="<%=CalendarOpenYN%>" id="calendar<%=TitleIdx%>" onclick="changeOpenState('calendar', <%=TitleIdx%>)" value="" <% If CalendarOpenYN = "Y" Then %>checked<% End If %>>
                    <span class="slider round"></span>
                  </label>
                  <label class="switch" title="대진표">
                    <input type="checkbox" data-open-state="<%=MatchTableOpenYN%>" id="matchTable<%=TitleIdx%>" onclick="changeOpenState('matchTable', <%=TitleIdx%>)" value="" <% If MatchTableOpenYN = "Y" Then %>checked<% End If %>>
                    <span class="slider round"></span>
                  </label>

                  <label class="switch" title="대회노출">
                    <input type="checkbox" data-open-state="<%=OpenYN%>" id="open<%=TitleIdx%>" onclick="changeOpenState('open', <%=TitleIdx%>)" value="" <% If OpenYN = "Y" Then %>checked<% End If %>>
                    <span class="slider round"></span>
                  </label>
                </span>
              </td>
              <td><span><a href="event/info.asp?titleIdx=<%=TitleIdx%>" class="btn btn-default">부(경기유형)관리</a></span></td>
              <td><span><a href="#imageUploadModal" rel="modal:open" class="btn btn-default" id="summary<%=TitleIdx%>" data-img-path="<%=Summary%>" onclick="setFileInfo(<%=TitleIdx%>, 'summary')" >경기요강</a></span></td>
              <td><span><a href="#imageUploadModal" rel="modal:open" class="btn btn-default" id="titleRule<%=TitleIdx%>" data-img-path="<%=TitleRule%>" onclick="setFileInfo(<%=TitleIdx%>, 'titleRule')" >대회규정</a></span></td>
              <td><span><a href="#imageUploadModal" rel="modal:open" class="btn btn-default" id="eventRule<%=TitleIdx%>" data-img-path="<%=EventRule%>" onclick="setFileInfo(<%=TitleIdx%>, 'eventRule')" >종목설명</a></span></td>

              <td><span><a href="#imageUploadModal" rel="modal:open" class="btn btn-default" id="tableimg<%=TitleIdx%>" data-img-path="<%=tableimg%>" onclick="setFileInfo(<%=TitleIdx%>, 'tableimg')" >대진표</a></span></td>
			        <td><span><a href="#imageUploadModal" rel="modal:open" class="btn btn-default" id="resultimg<%=TitleIdx%>" data-img-path="<%=resultimg%>" onclick="setFileInfo(<%=TitleIdx%>, 'resultimg')" >대회결과</a></span></td>


			  <!-- <td onclick="event.cancelBubble=true;"><span><a href="javascript:mx.editor(<%=TitleIdx%>,'<%=TitleName%>')" rel="modal:open" class="btn btn-default" >대진표및결과</a></span></td> -->
			<!-- <td onclick="event.cancelBubble=true;"><a href="javascript:mx.editor(<%=TitleIdx%>,'<%=TitleName%>')" rel="modal:open" class="btn btn-default" >대진표및결과</a></td> -->

			</tr>
            <%
          Next
        End If
      %>
    </tbody>
	</table>
</div>






<div class="modal" id="imageUploadModal">
  <div class="form-horizontal">
    <div class="form-group">
      <div class="col-sm-2">
        <label class="control-label">대회</label>
      </div>
      <div class="col-sm-8">
        <input type="file" class="form-control" name="" value="" id="uploadImage" accept=".jpg, .jpeg, .png">
      </div>
      <input type="hidden" id="fileType" value="">
      <input type="hidden" id="titleIdx" value="">
      <a href="#none" onclick="saveFile();" class="btn btn-default">저장</a>      
      <div>
        <img src="" class="" id="viewImg" alt="">
      </div>
    </div>
  </div>
</div>

<nav>
  <div class="container-fluid text-center">
    <%
      tPage = totalPage(totalCount, pageSize)
      jsonStr = JSON.Stringify(oJSONoutput)
      Call bikeAdminPaging(tPage, blockSize, PN, "goPN", jsonStr, "info_list.asp", "infoList")
    %>
  </div>
</nav>
