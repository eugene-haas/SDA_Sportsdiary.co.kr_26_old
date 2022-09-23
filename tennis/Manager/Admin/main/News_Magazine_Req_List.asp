<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
  
  Dim iTotalCount, iTotalPage, LCnt0 '페이징
  LCnt0 = 0

  Dim LCnt, NowPage, PagePerData '리스트
  LCnt = 0

  iDivision = "4"                   ' 1 : 뉴스 2 : 공지 3 : 계간유도 4 : 전체 뉴스/공지
  iLoginID = decode(fInject(Request.cookies("UserID")),0)

  NowPage = fInject(Request("i2"))  ' 현재페이지
  PagePerData = global_PagePerData  ' 한화면에 출력할 갯수
  BlockPage = global_BlockPage      ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

  'Request Data
	iStatus = fInject(Request("iStatus"))
	iSearchText = fInject(Request("iSearchText"))
	iSearchCol = fInject(Request("iSearchCol"))

	isyear = fInject(Request("isyear"))
	selss = fInject(Request("selss"))
	ieyear = fInject(Request("ieyear"))
	seles = fInject(Request("seles"))

  If Len(NowPage) = 0 Then
		NowPage = 1
	End If

	if(Len(iStatus) = 0) Then iStatus = "" ' 구분
	if(Len(iSearchCol) = 0) Then iSearchCol = "D" ' 검색 구분자
	if(Len(iSearchText) = 0) Then iSearchText = "" ' 검색어

	if(Len(isyear) = 0) Then

		iStartPosition = ""
		isyear = ""
		selss = ""

	else

		iStartPosition = isyear&"_"&selss

	end if

	if(Len(ieyear) = 0) Then

		iEndPosition = ""
		ieyear = ""
		seles = ""

	else

		iEndPosition = ieyear&"_"&seles

	end if

  iType = "2"				' 1:조회, 2:총갯수, 2:전체조회(출력용)
	iProgressYN = ""	' 현재사용안함

  LSQL = "EXEC Subscription_Board_Search_Admin_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iProgressYN & "','" & iStartPosition & "','" & iEndPosition & "','','','" & iStatus & "','" & iSearchCol & "','" & iSearchText & "','" & iLoginID & "'"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = DBCon4.Execute(LSQL)
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
        iTotalCount = LRs("TOTALCNT")
        iTotalPage = LRs("TOTALPAGE")
      LRs.MoveNext
		Loop
	End If
  LRs.close
%>

  <script type="text/javascript">

  	var selSearchValue01 = "<%=isyear%>";
  	var selSearchValue02 = "<%=selss%>";
  	var selSearchValue03 = "<%=ieyear%>";
  	var selSearchValue04 = "<%=seles%>";

  	var selSearchValue1 = "<%=iStatus%>";
    var selSearchValue = "<%=iSearchCol%>";
    var txtSearchValue = "<%=iSearchText%>";

    function WriteLink(i2) {

    	post_to_url('./News_Magazine_Req_Write.asp', { 'i2': i2, 'iType': '1' });

    }

    function ReadLink(i1, i2) {
      //location.href = 'cmRead.asp?i1=' + i1 + '&i2=' + i2; 
      //post_to_url('./cmRead.asp', { 'i1': i1, 'i2': i2 });

      //./Community_Motion_Read.asp

      //alert(i1 + " , " + i2);
    	post_to_url('./News_Magazine_Req_Write.asp', { 'i1': i1, 'i2': i2, 'iType': '2', 'iStatus': selSearchValue1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue });
    }

    function PagingLink(i2) {

      //location.href = 'cmList.asp?i2=' + i2;
    	post_to_url('./News_Magazine_Req_List.asp', { 'i2': i2, 'iStatus': selSearchValue1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'isyear': selSearchValue01, 'selss': selSearchValue02, 'ieyear': selSearchValue03, 'seles': selSearchValue04 });
    }

    function fn_selSearch() {

    	selSearchValue1 = document.getElementById('selSearch1').value;
      selSearchValue = document.getElementById('selSearch').value;
      txtSearchValue = document.getElementById('txtSearch').value;

      selSearchValue01 = document.getElementById('isyear').value;
      selSearchValue02 = document.getElementById('selss').value;
      selSearchValue03 = document.getElementById('ieyear').value;
      selSearchValue04 = document.getElementById('seles').value;

      post_to_url('./News_Magazine_Req_List.asp', { 'i2': 1, 'iStatus': selSearchValue1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'isyear': selSearchValue01, 'selss': selSearchValue02, 'ieyear': selSearchValue03, 'seles': selSearchValue04 });
    }

    function fn_selSearchXls() {
    	post_to_url('./News_Magazine_Req_List_Xls.asp', { 'i2': 1, 'iStatus': selSearchValue1, 'iSearchCol': selSearchValue, 'iSearchText': txtSearchValue, 'isyear': selSearchValue01, 'selss': selSearchValue02, 'ieyear': selSearchValue03, 'seles': selSearchValue04 });
    }

    function isyear_chg() {

    	var iisyear = $('#isyear').val();

    	if (iisyear == "") {

    		var ihtml01 = "";

    		ihtml01 = '<select id="selss" name="selss" class="title_select">';
    		ihtml01 = ihtml01 + '	<option value="">시작호</option>';
    		ihtml01 = ihtml01 + '</select>';

    		$('#divselss').html(ihtml01);
    	}
    	else {

    		var iType = "1";
    		var CType = "";
    		var CSubType = "";
    		var CPosition = "S";

    		//alert(CSubType);

    		var strAjaxUrl = "./Ajax/News_Magazine_Req_List.asp";
    		$.ajax({
    			url: strAjaxUrl,
    			type: 'POST',
    			dataType: 'html',
    			data: {
    				iType: iType,
    				CType: CType,
    				CSubType: CSubType,
    				CPosition: CPosition
    			},
    			async: false,
    			success: function (retDATA) {
    				//alert(retDATA);
    				if (retDATA) {
    					$('#divselss').html(retDATA);
    				} else {
    					$('#divselss').html("");
    				}
    			}, error: function (xhr, status, error) {
    				if (error != "") {
    					alert("오류발생! - 시스템관리자에게 문의하십시오!");
    					return;
    				}
    			}
    		});

    	}

    }

    function ieyear_chg() {

    	var iieyear = $('#ieyear').val();

    	if (iieyear == "") {

    		var ihtml02 = "";

    		ihtml02 = '<select id="seles" name="seles" class="title_select">';
    		ihtml02 = ihtml02 + '	<option value="">종료호</option>';
    		ihtml02 = ihtml02 + '</select>';

    		$('#divseles').html(ihtml02);
    	}
    	else {

    		var iType = "1";
    		var CType = "";
    		var CSubType = "";
    		var CPosition = "E";

    		//alert(CSubType);

    		var strAjaxUrl = "./Ajax/News_Magazine_Req_List.asp";
    		$.ajax({
    			url: strAjaxUrl,
    			type: 'POST',
    			dataType: 'html',
    			data: {
    				iType: iType,
    				CType: CType,
    				CSubType: CSubType,
    				CPosition: CPosition
    			},
    			async: false,
    			success: function (retDATA) {
    				if (retDATA) {
    					$('#divseles').html(retDATA);
    				} else {
    					$('#divseles').html("");
    				}
    			}, error: function (xhr, status, error) {
    				if (error != "") {
    					alert("오류발생! - 시스템관리자에게 문의하십시오!");
    					return;
    				}
    			}
    		});

    	}

    }

  </script>


   <section>
    <div id="content">

		<!-- S: 네비게이션 -->
		<div	class="navigation_box">
			유도소식 > 계간유도 > 구독신청/내역조회
		</div>
		<!-- E: 네비게이션 -->
    <div class="search_top community">
			<div class="search_box">
				<select id="selSearch1" name="selSearch1" class="title_select">
					<option value="">상태</option>
					<%
							' 리스트 조회
							iType = "1"
							CType = "Subscription_State"
							CSubType = ""

							LCnt1 = 0

							LSQL = "EXEC CodePropertyName_Search_Type_STR '" & iType & "','" & CType & "','" & CSubType & "'"
							'response.Write "LSQL="&LSQL&"<br>"
							'response.End
  
							Set LRs = DBCon4.Execute(LSQL)
										
							If Not (LRs.Eof Or LRs.Bof) Then
								Do Until LRs.Eof
										'LCnt1 = LCnt1 + 1
					%>
					<option value="<%=LRs("Code") %>"><%=LRs("Name") %></option>
					<%
								LRs.MoveNext
							Loop
							End If

							LRs.close
					%>
				</select>
				<select id="selSearch" name="selSearch" class="title_select">
					<option value="D">입금자명</option>
					<option value="N">신청자명</option>
				</select>

				<select name="isyear" id="isyear" class="title_select" onchange="javascript:isyear_chg();">
					<option value="">시작년도</option>
					<option value="2010">2010년</option>
					<option value="2011">2011년</option>
					<option value="2012">2012년</option>
					<option value="2013">2013년</option>
					<option value="2014">2014년</option>
					<option value="2015">2015년</option>
					<option value="2016">2016년</option>
					<%
						Dim iSYear, iSYear_no
						iSYear = Year(Now())
						iSYear_no = iSYear - 2016

						For i = 1 To iSYear_no
					%>
					<option value="<%= 2016 + i %>"><%= 2016 + i %>년</option>
					<%
						Next
					%>
					<option value="<%= 2016 + iSYear_no + 1 %>"><%= 2016 + iSYear_no + 1 %>년</option>
				</select>
				<div id="divselss">
				<select id="selss" name="selss" class="title_select">
					<option value="">시작호</option>
				</select>
				</div>

				<select name="ieyear" id="ieyear" class="title_select" onchange="javascript:ieyear_chg();">
					<option value="">종료년도</option>
					<option value="2010">2010년</option>
					<option value="2011">2011년</option>
					<option value="2012">2012년</option>
					<option value="2013">2013년</option>
					<option value="2014">2014년</option>
					<option value="2015">2015년</option>
					<option value="2016">2016년</option>
					<%
						Dim iEYear, iEYear_no
						iEYear = Year(Now())
						'iEYear = 2018
						iEYear_no = iEYear - 2016

						For i = 1 To iEYear_no
					%>
					<option value="<%= 2016 + i %>"><%= 2016 + i %>년</option>
					<%
						Next
					%>
					<option value="<%= 2016 + iEYear_no + 1 %>"><%= 2016 + iEYear_no + 1 %>년</option>
					<option value="<%= 2016 + iEYear_no + 2 %>"><%= 2016 + iEYear_no + 2 %>년</option>
					<option value="<%= 2016 + iEYear_no + 3 %>"><%= 2016 + iEYear_no + 3 %>년</option>
					<option value="<%= 2016 + iEYear_no + 4 %>"><%= 2016 + iEYear_no + 4 %>년</option>
				</select>
				<div id="divseles">
				<select id="seles" name="seles" class="title_select">
					<option value="">종료호</option>
				</select>
				</div>

				<input type="text" id="txtSearch" name="txtSearch" class="title_input in_2"/>
				<a href="javascript:;" id="btnselSearch" name="btnselSearch" onclick="javascript:fn_selSearch();" class="btn_skyblue">검색</a>
				<a href="javascript:;" id="btnselSearchXls" name="btnselSearchXls" onclick="javascript:fn_selSearchXls();" class="btn_green"><i class="fa fa-file-excel-o" aria-hidden="true"></i>엑셀저장</a>
			</div>
      <div class="btn_list right">
        <!--<input type="button" id="btnselSearch" name="btnselSearch" value="검색" onclick="javascript:fn_selSearch();" />-->
		  </div>
      <br />
     <!-- 
        S : 내용 시작
     -->
    <table class="table-list">
      <caption>대회 리스트</caption>
      <colgroup>
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
        <col width="*" />
      </colgroup>
      <thead>
        <tr>
          <th scope="col">순번</th>
					<th scope="col">신청자명</th>
          <th scope="col">입금자명</th>
					<th scope="col">상태</th>
          <th scope="col">구독기간</th>
        </tr>
      </thead>
      <tbody id="gametitlelist">

					

          <%
            ' 리스트 조회
            iType = "1"

            LSQL = "EXEC Subscription_Board_Search_Admin_STR '" & NowPage & "','" & PagePerData & "','" & BlockPage & "','" & iType & "','" & iProgressYN & "','" & iStartPosition & "','" & iEndPosition & "','','','" & iStatus & "','" & iSearchCol & "','" & iSearchText & "','" & iLoginID & "'"
	          'response.Write "LSQL="&LSQL&"<br>"
            'response.End
  
            Set LRs = DBCon4.Execute(LSQL)
										
            If Not (LRs.Eof Or LRs.Bof) Then
		          Do Until LRs.Eof
                  LCnt = LCnt + 1
        %>
        <tr style="cursor:pointer" onclick="javascript:ReadLink('<%=encode(LRs("MSeq"),0) %>','<%=NowPage %>');">
          <td><%=LRs("Num") %></td>
					<td><%=LRs("Name") %></td>
          <td><%=LRs("DepositorName") %></td>
					<td><%=LRs("StatusName") %></td>
          <td><%=LRs("StartYear") %>년 <%=LRs("StartSectionName") %> ~ <%=LRs("EndYear") %>년 <%=LRs("EndSectionName") %></td>
        </tr>
        <%
			        LRs.MoveNext
		        Loop
        %>

        <%
						Else
				%>
					<!--게시판에 데이터가 없는 경우-->
				<tr>
					<td colspan="5">
							<div>등록된 게시물이 없습니다.</div>
						</td>
				</tr>
        <%
          End If
  
          LRs.close
  
          JudoKorea_DBClose()
        %>

      </tbody>
    </table>

    <%
			if LCnt > 0 then
		%>
      <!--#include file="../dev/dist/judoPaging_Admin.asp"-->
		<%
			End If
		%>

    <!-- E : 내용 시작 -->
    <!--<div class="btn_list right">
			<a href="javascript:;" onclick="javascript:WriteLink('<%=NowPage %>');" class="btn_skyblue"><span class="icon_pen">글쓰기</span></a>
		</div>-->


    </div>
  <section>

    <script type="text/javascript">

    	//var iNowYear = new Date();
    	//alert(iNowYear.getFullYear());
    	//$('#isyear').val(iNowYear.getFullYear());
    	//$('#ieyear').val(iNowYear.getFullYear() + 1);

      $("#txtSearch").val(txtSearchValue);
      $("#selSearch").val(selSearchValue);
      $("#selSearch1").val(selSearchValue1);

      $("#isyear").val(selSearchValue01);
      $("#ieyear").val(selSearchValue03);

      if ($("#isyear").val() != "") {
      	isyear_chg();
      	$("#selss").val(selSearchValue02);
      }

      if ($("#ieyear").val() != "") {
      	ieyear_chg();
      	$("#seles").val(selSearchValue04);
      }

    </script>
<!--#include file="footer.asp"-->
