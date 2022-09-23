<!--#include virtual="/Manager/Common/common_header.asp"-->
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	'질문과 답변 목록페이지
	
	dim SportsGb		: SportsGb			= request.Cookies("SportsGb")
	
	dim currPage   		: currPage    		= fInject(Request("currPage"))
	dim fnd_KeyWord  	: fnd_KeyWord    	= fInject(Request("fnd_KeyWord"))
	dim fnd_KeyWordType : fnd_KeyWordType   = fInject(Request("fnd_KeyWordType"))
	dim act				: act				= request("act")
	
	dim BlockPage   	: BlockPage 		= 10	'페이지
	dim B_PSize   		: B_PSize 			= 10	'페이지내 보여지는 목록카운트
	
	dim TotCount, TotPage
	dim CSearch
	dim CSQL, CRs
	
	IF Len(currPage) = 0 Then currPage = 1
	
	'답변글 정보 조회
  	FUNCTION RE_CONTENTS(IDX)
    
		LSQL =  "   	SELECT COUNT(*)  "
		LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblSvcQnA] "
		LSQL = LSQL & " WHERE SportsGb = '"&SportsGb&"' "
		LSQL = LSQL & "     AND DelYN = 'N' "
		LSQL = LSQL & "     AND ReQnAIDX =  "&IDX
	  
		SET LRs = Dbcon.Execute(LSQL)
		IF LRs(0) > 0 Then
			RE_CONTENTS = TRUE
		Else
			RE_CONTENTS = FALSE	
		End IF
			LRs.Close
		SET LRs = Nothing
  
  	END FUNCTION
  
	'키워드검색 조건
	IF fnd_KeyWordType <>"" Then
		SELECT CASE fnd_KeyWordType
			CASE 1	: CSearch = " AND Title like '%"&fnd_KeyWord&"%' "
			CASE 2	: CSearch = " AND Contents like '%"&fnd_KeyWord&"%' "
			CASE 3	: CSearch = " AND (Title like '%"&fnd_KeyWord&"%' OR Contents like '%"&fnd_KeyWord&"%') "
		END SELECT
	End IF
	 
	CSQL =  "       SELECT COUNT(*) "
	CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
	CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcQnA]" 
	CSQL = CSQL & " WHERE DelYN = 'N' " 
	CSQL = CSQL & "   AND SportsGb = '"&SportsGb&"' "
	CSQL = CSQL & "   AND ReQnAIDX = 0 "&CSearch  
	
	
	SET CRs = Dbcon.Execute(CSQL) 
		TotalCount = CRs(0)
		TotalPage = CRs(1)
		
	CSQL =  "       SELECT TOP "&currPage * B_PSize
	CSQL = CSQL & "   	QnAIDX  "
	CSQL = CSQL & "   	,CASE QnAType WHEN 'P' THEN '선수APP' WHEN 'C' THEN '팀매니저APP' END QnATypeNm"	
	CSQL = CSQL & "     ,MemberIDX  "
	CSQL = CSQL & "     ,ReQnAIDX  "
	CSQL = CSQL & "     ,UserName  "
	CSQL = CSQL & "     ,Title  "
	CSQL = CSQL & "     ,Contents  "
	CSQL = CSQL & "     ,WriteDate  " 
	CSQL = CSQL & "     ,ViewCnt  "
	CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblSvcQnA] "
	CSQL = CSQL & " WHERE DelYN = 'N' "
	CSQL = CSQL & " 	AND SportsGb = '"&SportsGb&"' "	
	CSQL = CSQL & "     AND ReQnAIDX = 0 "&CSearch
	CSQL = CSQL & " ORDER BY WriteDate DESC "
	
'	 response.Write "CSQL="&CSQL&"<br>"
	
	SET CRs = Dbcon.Execute(CSQL)
%>
<link rel="stylesheet" href="../css/lib/bootstrap.min.css">
<script src="../js/library/bootstrap.min.js"></script>
<script>
	function chk_Submit(valType, valIDX, chkPage){
		
		if(chkPage != "") $("#currPage").val(chkPage);

		if(valType == "VIEW"){
			$("#CIDX").val(valIDX);   
			$('form[name=s_frm]').attr('action',"./qnaViewBoard.asp");     
			$('form[name=s_frm]').submit(); 
		}
		else{
			$("#act").val(""); 	//초기화  
			$('form[name=s_frm]').attr('action',"./qnaBoard.asp");		
			$('form[name=s_frm]').submit(); 
		}
	}
	
	$(document).ready(function(){
		var fnd_KeyWordType = "<%=fnd_KeyWordType%>";
		
		if(fnd_KeyWordType != ""){
			$("#fnd_KeyWordType").val(fnd_KeyWordType);   	
		}
		
	});
</script>    
<body>
<form name="s_frm" method="post">
	<input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="CIDX" id="CIDX" />
    <input type="hidden" name="act" id="act" />
  <!-- S: main container -->
  <div class="main container board col-12">
    <section class="container">
      <div class="row">
        <div class="loaction">
          <strong>게시판 관리</strong> > Q&amp;A 게시판
        </div>
      </div>
    </section>
    <!-- S: top row -->
    <div class="top row clearfix">
      <!-- S: 최근 기간 선택 -->
      <!-- <div class="sel-date">
        <select name="" class="darkgray">
          <option value="">최근 1주일</option>
          <option value="">최근 1개월</option>
          <option value="">최근 3개월</option>
        </select>
      </div> -->
      <!-- E: 최근 기간 선택 -->
      <!-- S: 조회 앞 날짜 -->
     <!--  <div class="sel-date">
       <input type="date" class="day-btn" name="SDate" id="SDate" maxlength="10" value>
     </div>
     E: 조회 앞 날짜
     <span class="wave">~</span>
     S: 조회 뒷 날짜
      <div class="sel-date">
       <input type="date" class="day-btn" name="EDate" id="EDate" maxlength="10" value>
     </div> -->
      <!-- E: 조회 뒷 날짜 -->
    </div>
    <!-- E: top row -->

    <!-- S: article-bg -->
    <div class="article-bg">
      <!-- S: board-list -->
       <div id="board-contents" class="article-frame community board-list">
       <table class="table-list notice-list qna-table basic-table">
          <thead>
            <tr>
             
              <th>번호</th>
              <th>구분</th>
              <th>제목</th>
              <th>작성자</th>
              <th>작성일</th>
              <th>조회수</th>
            </tr>
          </thead>
          <tbody>
		   <%
            If Not(CRs.Eof Or CRs.Bof) Then 
				
				CRs.Move (currPage - 1) * B_PSize
				
				Do Until CRs.eof
				
					cnt = cnt + 1  
					
					Title 		= ReplaceTagReText(CRs("Title"))
					QnAIDX 		= CRs("QnAIDX")
					QnATypeNm 	= CRs("QnATypeNm")
					UserName 	= CRs("UserName")
					ViewCnt 	= CRs("ViewCnt")
					WriteDate 	= CRs("WriteDate")
					
					IF fnd_KeyWord <> "" Then Title = replace(Title, fnd_KeyWord, "<font color='#ff0000'><strong>"&fnd_KeyWord&"</strong></font>")
            %>
            <tr>
              
              <td><%=totalcount - (currPage - 1) * B_Psize - cnt+1%></td>
              <td><%=QnATypeNm%></td>
              <td>
              	<a href="javascript:chk_Submit('VIEW','<%=QnAIDX%>','<%=currPage%>');"><%=Title%></a>
              	<%
				
				IF RE_CONTENTS(QnAIDX) = TRUE Then response.Write "<span class='ic-re'>Re</span>"					
				If DateDiff("H", CRs("WriteDate"), Now())<24 Then response.Write "<span class='ic-new'>N</span>"
				
				%>
              </td>
              <td><%=UserName%></td>
              <td><%=replace(left(WriteDate,10), "-",".")%></td>
              <td><%=ViewCnt%></td>
            </tr>
            <%
	    	        CRs.movenext
    	        Loop  
            Else  
            
            %>
            <tr>
              <td colspan="6">등록된 글이 없습니다.</td>
            </tr>
            <%
            
            End IF  
            
            	CRs.Close
            SET CRs = Nothing
          
           %>
        
            <!--
            <tr>
              <td><input type="checkbox"></td>
              <td>3</td>
              <td><a href="writeBoard.asp">마크업 입니다.</a></td>
              <td>아무개</td>
              <td>17.06.27</td>
              <td>3</td>
            </tr>
            <tr>
              <td><input type="checkbox"></td>
              <td>2</td>
              <td><a href="writeBoard.asp">마크업 입니다.</a></td>
              <td>누구게</td>
              <td>17.06.25</td>
              <td>10</td>
            </tr>
            <tr>
              <td><input type="checkbox"></td>
              <td>1</td>
              <td><a href="writeBoard.asp">마크업 입니다.</a></td>
              <td>어떻게</td>
              <td>17.06.01</td>
              <td>7</td>
            </tr>
            -->
          </tbody>
        </table>
      </div>
      <!-- E: board-list -->
      <!-- S: board-btm-list -->
      <%
	  dim intTemp
	  
	  intTemp = Int((currPage - 1) / BlockPage) * BlockPage + 1
	  %>
        <div class="board-btm-list">
          <!-- S: pagination -->
          <ul class="pagination">
          <%
			If intTemp = 1 Then
			%>
            <li><a href="#" aria-label="Previous"><span aria-hidden="true">&lt;</span></a></li>
            <%
			Else 
			%>
            <li><a href="javascript:chk_Submit('LIST','','<%=intTemp - BlockPage%>');" aria-label="Previous"><span aria-hidden="true">&lt;</span></a></li>
            <%
			End If  
			
			dim intLoop : intLoop = 1
			
			
			Do Until intLoop > BlockPage Or intTemp > TotalPage
			
				If intTemp = CInt(currPage) Then
				%>
                <li class="active"><a href="#"><span><%=intTemp%></span></a></li>
                <%
				Else
				%>
                <li><a href="javascript:chk_Submit('LIST','','<%=intTemp%>');"><span><%=intTemp%></span></a></li>
                <%
				End If
				
				intTemp = intTemp + 1
				intLoop = intLoop + 1
				
			Loop
			
			IF intTemp > TotalPage Then
			%>
            <li><a href="#" aria-label="Next"><span aria-hidden="true">&gt;</span></a></li>
            <%
			Else
			%>
            <li><a href="javascript:chk_Submit('LIST','','<%=intTemp%>');" aria-label="Next"><span aria-hidden="true">&gt;</span></a></li>
            <%
			End IF
		  %>
            
          </ul>
          <!-- E: pagination -->

          <!-- S: btn-list -->
          <div class="btn-list">
            <!-- S: srch-field -->
            <div class="srch-field">
              <!-- S: 작성자 선택 -->
              <div class="sel-date srch-sel">
                <select name="fnd_KeyWordType" id="fnd_KeyWordType">
                  <option value="1">제목</option>
                  <option value="2">내용</option>
                  <option value="3">제목 + 내용</option>
                </select>
                <input type="text" class="txt-box" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
              </div>
              <!-- E: 작성자 선택 -->
              <!-- S: 검색 버튼 -->
              <div class="btn-cta">
                <a href="javascript:chk_Submit('FND','','');" class="btn btn-basic">검색</a>
              </div>
              <!-- E: 검색 버튼 -->
            </div>
            <!-- E: srch-field -->
          </div>
          <!-- E: btn-list -->
        </div>
        <!-- E: board-btm-list -->
    </div>
    <!-- E: article-bg -->
  </div>
  <!-- E: main container -->
  </form>
</body>