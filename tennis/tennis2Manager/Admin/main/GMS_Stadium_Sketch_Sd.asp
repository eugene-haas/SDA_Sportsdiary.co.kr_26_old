<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<link href="./css/lib/bootstrap.min.css" rel="stylesheet" type="text/css" />
<script src="../front/dist/js/bootstrap.min.js" type="text/javascript"></script>
 <%
 
	Search_GameTitleIDX     = fInject(Request("Search_GameTitleIDX"))
  Search_TeamGbIDX		= fInject(Request("Search_TeamGbIDX"))

	Response.write " Search_GameTitleIDX  : " &Search_GameTitleIDX&"<br>"
	response.write " Search_TeamGbIDX  : " &Search_GameTitleIDX&"<br>"
	
	SportsGb="tennis"
  EnterType="A"

	IF Len(currPage) = 0 Then currPage = 1

	dim BlockPage     : BlockPage     = 10  '페이지
	dim B_PSize       : B_PSize       = 10 '페이지내 보여지는 목록카운트
	
	NowPage = fInject(Request("i2"))  ' 현재페이지
	PagePerData = 10 ' 한화면에 출력할 갯수
	'BlockPage = 10      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

	if(NowPage = 0) Then NowPage = 1

    if Search_Years="" then 
        YNSQL = "SELECT LEFT(CONVERT(NVARCHAR,GETDATE(),112),4) Years"
        Set YNRs = Dbcon7.Execute(YNSQL)
    
        If Not(YNRs.Eof Or YNRs.Bof) Then 
	        Search_Years =YNRs("Years")
        End If 
    End If 

%>
<script type="text/javascript">
    function chk_frm(val) {
        var sf = document.search_frm;

        if (val == "FND") {
            sf.action = "./GMS_Stadium_Sketch_Sd.asp";
            sf.submit();
        } 
    }

    function WriteLink(i2) {

    	post_to_url('./GMS_Stadium_Sketch_Write_Sd.asp', { 'i2': i2, 'iType': '1' });

    }
	function PagingLink(i2){
		post_to_url('./GMS_Stadium_Sketch_Sd.asp', { 'i2': i2, 'Search_GameTitleIDX': '<%=Search_GameTitleIDX%>', 'Search_TeamGbIDX': '<%=Search_TeamGbIDX%>' });
	}
  function chk_Submit(valType, valIDX, chkPage){
    if(chkPage != "") $("#currPage").val(chkPage);

    if(valType == "VIEW"){
      $("#idx").val(valIDX);   
      $('form[name=search_frm]').attr('action',"./GMS_Stadium_sketch_view_Sd.asp");     
      $('form[name=search_frm]').submit(); 
    }
    else if(valType == "DEL"){
      if($("#list_CHK:checked").length == 0) {
        alert("삭제하고자 하는 정보를 선택하여 주세요.");  
        return;
      }
      else{
        if(confirm("선택하신 정보를 삭제하시겠습니까?")){
          $("#act").val(valType);     
          $('form[name=search_frm]').attr('action',"./noticeBoard.asp");     
          $('form[name=search_frm]').submit(); 
        }
        else{
          return; 
        }
      }
    }
    else{
      $("#act").val("");  //초기화  
      $('form[name=search_frm]').attr('action',"./noticeBoard.asp");   
      $('form[name=search_frm]').submit(); 
    }   
  }


 function on_select_year(this_is)
  {
	var strAjaxUrl="GMS_Stadium_sketch_tennisTitle_Sd.asp?get_year="+this_is.value;
	//location.href = strAjaxUrl;
	//location.href = strAjaxUrl
	//alert(strAjaxUrl);
		var retDATA="";
		//alert(strAjaxUrl);
		 $.ajax({
			 type: 'GET',
			 url: strAjaxUrl,
			 dataType: 'html',
			 success: function(retDATA) {
				if(retDATA)
					{
						document.getElementById("Search_GameTitleIDX_div").innerHTML =retDATA;
					}
			 }
		 }); //close $.ajax(

  }

</script>
<%
    ''컨트롤 조회
    Dim JSONarr()
    'if  Search_Years <> ""  and Search_GameTitleIDX<>"" then 
					
	ControlSql ="  exec Stadium_Sketch_admin_total_count @PAGESIZE ='"&B_PSize&"',@GameTitleIDX='"&Search_GameTitleIDX&"',@TeamGbIDX='"&Search_TeamGbIDX&"'"

  'Response.write "ControlSqlControlSqlControlSqlControlSqlControlSql : "&ControlSql

	SET CRs = DBCon7.Execute(ControlSql)  
		iTotalCount = CRs(0)
		iTotalPage = CRs(1)

		ControlSql ="  EXEC Stadium_Sketch_admin_list @PAGE	='"&NowPage&"', @PAGESIZE ='"&B_PSize&"',@GameTitleIDX='"&Search_GameTitleIDX&"',@TeamGbIDX='"&Search_TeamGbIDX&"'"

	'Response.WRITE "ControlSqlControlSqlControlSqlControlSqlControlSql : "&ControlSql
        Set Rs = Dbcon7.Execute(ControlSql)

    'end if 

 %>
	<section>		
		<div id="content">
			<div class="loaction">
				<strong>경기관리</strong> &gt; 현장스케치 - SD
			</div>
		<form method="post" name="search_frm" id="search_frm" action="GMMT_MatchList_Movie.asp"> 
		<input type="hidden" name="idx" id="idx" value="<%=IDX%>" />
		<div class="sch">
			<table class="sch-table">
				<caption>검색조건 선택 및 입력</caption>
				<colgroup>
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
					<col width="50px" />
					<col width="*" />
					<col width="70px" />
					<col width="*" />
				</colgroup>				 
				<tbody>
					<tr>
                       
						<th scope="row"><label for="competition-name-2">대회선택</label></th>
						<td>
							<select name="Search_Year" id="Search_Year" style="width:15%;" onchange="javascript:on_select_year(this);">
								<% For year_i = 2017 To year(date) %>
									<option value="<%=year_i%>" <% If year_i =year(date) Then %> selected<% End If %>><%= year_i%></option>
								<% next%>
							</select>
							<span id="Search_GameTitleIDX_div">
								<select name="Search_GameTitleIDX" id="Search_GameTitleIDX" onchange="chk_frm('FND');" style="width:80%;">
									<option value="">=대회선택=</option>
									<%
											GSQL = "EXEC Stadium_Sketch_GameTitleName_list "
											
											Set GRs = Dbcon7.Execute(GSQL)
											If Not(GRs.Eof Or GRs.Bof) Then 
												Do Until GRs.Eof 
													%>
													<option value="<%=GRs("GameTitleIDX")%>" <%If CStr(GRs("GameTitleIDX")) = CStr(Search_GameTitleIDX) Then %>selected<%End If%>><%=GRs("GameTitleName")%></option>
													<%
													GRs.MoveNext
												Loop 
											End If 
									%>
								</select>
							</span>
						</td>		
						<th scope="row">종별선택</th>
						<td id="sel_Search_TeamGb">
							<select id="Search_TeamGbIDX" name="Search_TeamGbIDX" onchange="chk_frm('FND');">
							
							<%
								GSQL2 = "EXEC Stadium_Sketch_TeamGbInfo_list  "

								Set GSQL2_rs = Dbcon7.Execute(GSQL2)
							%>
								<option value="">::종별선택::</option>
								<option value="" selected>전체</option>
			                 <%  
								If Not(GSQL2_rs.Eof Or GSQL2_rs.Bof) Then 
									Do Until GSQL2_rs.Eof 
							            %>
							            <option value="<%=GSQL2_rs("TeamGbIDX")%>" <%If CStr(GSQL2_rs("TeamGbIDX")) = CStr(Search_TeamGbIDX) Then %>selected<%End If%>><%=GSQL2_rs("teamgbNM")%></option>
							            <%
										GSQL2_rs.MoveNext
									Loop 
								End If 
							%>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		</form>
		<!-- S : 리스트 -->
		<table class="table-list">
			<caption>대회 리스트</caption>
			<colgroup>
				<col style="width:10%" />
				<col width="width:40%" />
				<col style="width:20%" />
				<col style="width:10%" />
				<col style="width:10%" />
				<col style="width:10%" />
			</colgroup>
			<thead>
				<tr>
				    <th scope="col">No</th>
					<th scope="col">대회</th>
                    <th scope="col">종별</th>
					<th scope="col">작성자</th>
					<th scope="col">작성일</th>
					<th scope="col">조회수</th>
				</tr>
			</thead>
			<tbody>
            <%			
				
				cnt = 1 
				IF NOT(Rs.Bof OR Rs.Eof) Then      
				Do Until Rs.Eof 

			
			%>
                <tr>
                    <th scope="col"><%= RS("IDX") %></th>
					<th scope="col">
						<a href="javascript:chk_Submit('VIEW', '<%=rs("Idx")%>', '<%=currPage%>');">
							<%=rs("gametitlename")%>
						</a>
					</th>
                    <th scope="col"><%=rs("teamgbnm") %></th>
					<th scope="col"><%=rs("username")%></th>
					<th scope="col"><%=Left(Replace(rs("writeday"),"-","."),10) %></th>
					<th scope="col"><%=rs("viewcnt")%></th>
                </tr>
            <%
					cnt = cnt + 1   

				Rs.MoveNext
				Loop 

				Rs.Close
				SET Rs = Nothing
				End IF             
			%>
			</tbody>
		</table>
		 <!-- 이전/다음 : 시작 ---------->
		<ul class="pagination">
		<%
			Dim iTemp, iLoop
			iLoop = 1
			iTemp = Int((NowPage - 1) / BlockPage) * BlockPage + 1
			
			'Response.Write("페이징.asp iTemp : " & iTemp & "<br/>")
			'Response.Write("페이징.asp iTotalPage : " & iTotalPage& "<br/>")
			'Response.Write("페이징.asp iLoop: " & iLoop & "<br/>")
			'<li class="prev"><a href="#"><span>이전</span></a></li>

			If iTemp = 1 Then
					Response.Write "<li class=""prev""><a href='javascript:;' class='fa fa-angle-left'></a></li>"
			Else 
					Response.Write"<li class=""prev""><a href='javascript:;' onClick = 'javascript:PagingLink(" & iTemp - BlockPage & ")' class='fa fa-angle-left'></a></li>"
			End If
			
			IF( LCnt > 0 ) Then
				Do Until iLoop > BlockPage Or iTemp > iTotalPage
						If iTemp = CInt(NowPage) Then
								'Response.Write "[" & temp &"]&nbsp;" 
								Response.Write "<li class=""active""><a href='javascript:;'>" & iTemp &"</a></li>"
						Else
								 Response.Write"<li><a href='javascript:;'  onClick='javascript:PagingLink(" & iTemp & ")'>" & iTemp &"</a></li>"
								'Response.Write"<a href='javascript:;'>["& temp &"]</a>&nbsp;"
						End If
						iTemp = iTemp + 1
						iLoop = iLoop + 1
				Loop
			Else
				Response.Write "<li class=""active""><a href='javascript:;'>" & iTemp &"</a></li>"
			End IF

			If iTemp > iTotalPage Then
					Response.Write "<li class=""next""><a href='javascript:;' class='fa fa-angle-right'></a></li>"
					'Response.Write"<a href='javascript:;' onClick = 'javascript:PagingLink(" & temp - blockPageCount & ")'><IMG src=""../images/btn_prev.jpg"" width=""20"" height=""20"" align=""middle""></a>&nbsp;"
					'Response.Write "<IMG src=""../images/btn_next.jpg"" width=""20"" height=""20"" align=""middle"">"
			Else
					Response.Write "<li class=""next""><a href='javascript:;' onClick='javascript:PagingLink(" & iTemp & ")' class='fa fa-angle-right'></a></li>"
					'Response.Write"<a href='javascript:;' onClick='javascript:PagingLink(" & temp & ")'><IMG src=""../images/btn_next.jpg"" width=""20"" height=""20"" align=""middle""></a>"
			End If
		%>
		</ul>

		<div class="btn_list right" style="margin-top:-30px;">
			<a href="javascript:;" onclick="javascript:WriteLink('<%=NowPage %>');" class="btn_skyblue"><span class="icon_pen">등록</span></a>
		</div>
		<!-- E : 리스트 -->
		</div>
	<section>
<!--#include file="footer.asp"-->