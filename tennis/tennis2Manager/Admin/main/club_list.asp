<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%  
' 	dim SportsGb    : SportsGb      = request.Cookies("SportsGb")
	dim SportsGb    : SportsGb      = "tennis"
	
	dim currPage    : currPage      = fInject(Request("currPage"))
	dim fnd_KeyWord : fnd_KeyWord   = fInject(Request("fnd_KeyWord"))
	dim act       	: act       	= request("act")
	
	dim BlockPage     : BlockPage     = 10  '페이지
	dim B_PSize       : B_PSize       = 10 '페이지내 보여지는 목록카운트
	
	dim TotCount, TotPage
	dim CSearch
	dim CSQL, CRs
	dim i
  	
	'삭제시
	IF act = "DEL" Then
	
		FOR i = 1 to request("list_CHK").count
			
			CSQL = "    UPDATE [SD_tennis].[dbo].[tblClubRequest]"
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & "   ,ModDate = GETDATE() "
			CSQL = CSQL & " WHERE SportsGb = '"&SportsGb&"' "
			CSQL = CSQL & "   AND ClubReqIDX = "&request("list_CHK")(i)
			
			DBCon5.Execute(CSQL)  
			
			response.Write "<script>$('#act').val('');</script>"
		
		NEXT
	
	End IF
  
  	IF Len(currPage) = 0 Then currPage = 1

	dim search(3)
	
	search(0) = "AreaGb"	'시/도
	search(1) = "AreaGbDt"	'시/군/구
	search(2) = "TeamNm"	'소속명
	search(3) = "ReqName"	'요청자명
	
	IF fnd_KeyWord <> "" Then
		For i = 0 To 3
			IF i = 0 Then
				CSearch = CSearch & " OR SD_tennis.dbo.FN_SidoName(AreaGb,'"&SportsGb&"') like N'%"&fnd_KeyWord&"%'"
			Else
				CSearch = CSearch & " OR "&search(i)&" like N'%"&fnd_KeyWord&"%'"
			End IF	
		Next
	
		CSearch = " AND (" & mid(CSearch, 5) & ")"
	End IF	
  
	CSQL = "    SELECT COUNT(*) "
	CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblClubRequest]" 
	CSQL = CSQL & " WHERE DelYN = 'N' " 
	CSQL = CSQL & "     AND SportsGb = '"&SportsGb&"'" &CSearch
	
	SET CRs = DBCon5.Execute(CSQL)  
		TotalCount = CRs(0)
		TotalPage = CRs(1)
	
	CSQL = "    SELECT TOP "&currPage * B_PSize&" ClubReqIDX "  
	CSQL = CSQL & "   	,ISNULL(TeamIDX, '') TeamIDX" 
	CSQL = CSQL & "   	,AreaGb "
	CSQL = CSQL & "   	,SD_tennis.dbo.FN_SidoName(AreaGb,'tennis') AreaGbNm"
	CSQL = CSQL & "   	,AreaGbDt "
	CSQL = CSQL & "   	,TeamNm "
	CSQL = CSQL & "   	,ReqName "
	CSQL = CSQL & "   	,CONVERT(CHAR(10),WriteDate, 102) WriteDate"
	CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblClubRequest]" 
	CSQL = CSQL & " WHERE DelYN = 'N' "
	CSQL = CSQL & "     AND SportsGb = 'tennis'" &CSearch
	CSQL = CSQL & " ORDER BY WriteDate DESC " 
  
	'response.Write CSQL
	SET CRs = DBCon5.Execute(CSQL)  
%>
<script>
  	function chk_Submit(valType, chkPage){
    
		if(chkPage != "") $("#currPage").val(chkPage);
	
		
		if(valType == "DEL"){
			if($("#list_CHK:checked").length == 0) {
				alert("삭제하고자 하는 정보를 선택하여 주세요.");  
				return;
			}
			else{
				if(confirm("선택하신 정보를 삭제하시겠습니까?")){
					$("#act").val(valType);     
					$('form[name=s_frm]').attr('action',"./club_list.asp");     
					$('form[name=s_frm]').submit(); 
				}
				else{
					return; 
				}
			}
		}
		else{
			$("#act").val("");  //초기화  
			$('form[name=s_frm]').attr('action',"./club_list.asp");   
			$('form[name=s_frm]').submit(); 
		}   
	}
  
</script>
<section class="noticeBoard">
  <div id="content">
    <form name="s_frm" method="post">
      <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
      <input type="hidden" name="act" id="act" />
      <!-- S: 네비게이션 -->
      <div class="navigation_box">경기운영관리 &gt; 경기관리 &gt; 신규소속생성요청</div>
      <!-- E: 네비게이션 -->
      <div class="search_top community">
        <div class="search_box">
          <input type="text" class="title_input in_2" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
          <a href="javascript:chk_Submit('FND','');" class="btn btn-basic">검색</a> <a href="javascript:chk_Submit('DEL','');" class="btn btn-redy">선택 삭제</a> 
          
        </div>
      </div>
      <br />
      <!-- S: article-bg -->
     
        <!-- S: board-list -->
        <table class="table-list notice-list basic-table">
          <thead>
            <tr>
              <th>선택</th>
              <th>번호</th>
              <th>구분</th>
              <th>시/도</th>
              <th>시/군/구</th>
              <th>소속명</th>
              <th>요청자</th>              
              <th>작성일</th>
            </tr>
          </thead>
          <tbody>
            <%
        IF (CRs.Eof Or CRs.Bof) Then 
      %>
            <tr>
              <td colspan="8">신규소속 생성요청한 글이 없습니다.</td>
            </tr>
            <%
      Else
        CRs.Move (currPage - 1) * B_PSize
        
        Do Until CRs.eof
          cnt = cnt + 1
          
          
        
          
          IF fnd_KeyWord <> "" Then Title = replace(Title, fnd_KeyWord, "<font color='#ff0000'><strong>"&fnd_KeyWord&"</strong></font>")
          %>
            <tr>
              <td><input type="checkbox" name="list_CHK" id="list_CHK" value="<%=CRs("ClubReqIDX")%>"></td>
              <td><%=totalcount - (currPage - 1) * B_Psize - cnt+1%></td>
              <td><%
			  IF CRs("TeamIDX") <> "" Then
				response.Write "완료"
			Else
				response.Write "미완료"	
			End IF	
			  %></td>
              <td><%=CRs("AreaGbNm")%></td>
              <td><%=CRs("AreaGbDt")%></td>
              <td><%=ReplaceTagReText(CRs("TeamNm"))%></td>
              <td><%=ReplaceTagReText(CRs("ReqName"))%></td>              
              <td><%=replace(left(CRs("WriteDate"),10), "-",".")%></td>
            </tr>
            <%
          CRs.Movenext
        Loop
      End IF
        CRs.Close
      SET CRs = Nothing
      %>
          </tbody>
        </table>
        <!-- E: board-list -->
        <!-- S: pagination -->
<%
		  
		  IF TotalCount > 0 Then
			response.Write "<ul class='pagination'>"
		
        dim intTemp
      dim intLoop : intLoop = 1
      
      intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
    
      IF intTemp = 1 Then
        IF currPage = 1 Then
          response.Write "<li class=""first""><a href=""#""><i class='fa fa-angle-left'></i><i class='fa fa-angle-left'></i></a></li>"
          response.Write "<li class=""prev""><a href=""#"" class='fa fa-angle-left'></a></li>"
        Else
          response.Write "<li class=""first""><a href=""javascript:chk_Submit('LIST',1);""><i class='fa fa-angle-left'></i><i class='fa fa-angle-left'></i></a></li>"
          response.Write "<li class=""prev""><a href=""javascript:chk_Submit('LIST','"&currPage-1&"');"" class='fa fa-angle-left'></a></li>"
        End IF
      Else
        response.Write "<li class=""first""><a href=""javascript:chk_Submit('LIST',1);""><i class='fa fa-angle-left'></i><i class='fa fa-angle-left'></i></a></li>"
        response.Write "<li class=""prev""><a href=""javascript:chk_Submit('LIST','"&intTemp - BlockPage&"');"" class='fa fa-angle-left'></a></li>"
      End IF
      
      Do Until intLoop > BlockPage Or intTemp > TotalPage
        
        IF intTemp = CInt(currPage) Then
          response.Write "<li class=""active""><a href=""#"">"&intTemp&"</a></li>"
        Else
          response.Write "<li><a href=""javascript:chk_Submit('LIST','"&intTemp&"');"">"&intTemp&"</a></li>"
        End If
        
        intTemp = intTemp + 1
        intLoop = intLoop + 1 
        
      Loop  
      
      IF intTemp > TotalPage Then
        IF cint(currPage) < cint(TotalPage) Then
          response.Write "<li class=""next""><a href=""javascript:chk_Submit('LIST','"&currPage+1&"');"" class='fa fa-angle-right'></a></li>"
          response.Write "<li class=""last""><a href=""javascript:chk_Submit('LIST','"&TotalPage&"');""><i class='fa fa-angle-right'></i><i class='fa fa-angle-right'></i></a></li>"
        Else
          response.Write "<li class=""next""><a href=""#"" class='fa fa-angle-right'></a></li>"
          response.Write "<li class=""last""><a href=""#""><i class='fa fa-angle-right'></i><i class='fa fa-angle-right'></i></a></li>"
        End IF
      Else
        response.Write "<li class=""next""><a href=""javascript:chk_Submit('LIST','"&intTemp&"');"" class='fa fa-angle-right'></a></li>"
        response.Write "<li class=""last""><a href=""javascript:chk_Submit('LIST','"&intTemp&"');""><i class='fa fa-angle-right'></i><i class='fa fa-angle-right'></i></a></li>"
      End IF 
	  
	  response.Write "</ul>"
      End IF
      %>
        <!-- E: pagination -->

      <!-- E: article-bg -->
    </form>
  </div>
</section>
<!--#include file="footer.asp"-->