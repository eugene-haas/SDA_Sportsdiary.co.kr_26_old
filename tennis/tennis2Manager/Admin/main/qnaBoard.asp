<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->

<%
  '질문과 답변 목록페이지
  
  dim SportsGb    : SportsGb      = "tennis"
  
  dim currPage      : currPage        = fInject(Request("currPage"))
  dim fnd_KeyWord   : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))
  dim fnd_KeyWordType : fnd_KeyWordType   = fInject(Request("fnd_KeyWordType"))
  dim act       : act       = request("act")
  
  dim BlockPage     : BlockPage     = 10  '페이지
  dim B_PSize       : B_PSize       = 10  '페이지내 보여지는 목록카운트
  
  dim TotCount, TotPage
  dim CSearch
  dim CSQL, CRs
  
  IF Len(currPage) = 0 Then currPage = 1
  
  '답변글 정보 조회
    FUNCTION RE_CONTENTS(IDX)
    
    LSQL =  "     SELECT COUNT(*)  "
    LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblSvcQnA] "
    LSQL = LSQL & " WHERE SportsGb = '"&SportsGb&"' "
    LSQL = LSQL & "     AND DelYN = 'N' "
    LSQL = LSQL & "     AND ReQnAIDX =  "&IDX
    
    SET LRs = DBCon5.Execute(LSQL)
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
      CASE 1  : CSearch = " AND Title like '%"&fnd_KeyWord&"%' "
      CASE 2  : CSearch = " AND Contents like '%"&fnd_KeyWord&"%' "
      CASE 3  : CSearch = " AND (Title like '%"&fnd_KeyWord&"%' OR Contents like '%"&fnd_KeyWord&"%') "
    END SELECT
  End IF
   
  CSQL =  "       SELECT COUNT(*) "
  CSQL = CSQL & "   ,CEILING(CAST(COUNT(*) AS FLOAT)/"&B_PSize&") " 
  CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcQnA]" 
  CSQL = CSQL & " WHERE DelYN = 'N' " 
  CSQL = CSQL & "   AND SportsGb = '"&SportsGb&"' "
  CSQL = CSQL & "   AND ReQnAIDX = 0 "&CSearch  
  
  
  SET CRs = DBCon5.Execute(CSQL) 
    TotalCount = CRs(0)
    TotalPage = CRs(1)
    
  CSQL =  "       SELECT TOP "&currPage * B_PSize
  CSQL = CSQL & "     QnAIDX  "
  CSQL = CSQL & "     ,CASE QnAType WHEN 'P' THEN '선수APP' WHEN 'C' THEN '팀매니저APP' END QnATypeNm"  
  CSQL = CSQL & "     ,MemberIDX  "
  CSQL = CSQL & "     ,ReQnAIDX  "
  CSQL = CSQL & "     ,UserName  "
  CSQL = CSQL & "     ,Title  "
  CSQL = CSQL & "     ,Contents  "
  CSQL = CSQL & "     ,WriteDate  " 
  CSQL = CSQL & "     ,ViewCnt  "
  CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcQnA] "
  CSQL = CSQL & " WHERE DelYN = 'N' "
  CSQL = CSQL & "   AND SportsGb = '"&SportsGb&"' " 
  CSQL = CSQL & "     AND ReQnAIDX = 0 "&CSearch
  CSQL = CSQL & " ORDER BY WriteDate DESC "
  
'  response.Write "CSQL="&CSQL&"<br>"
  
  SET CRs = DBCon5.Execute(CSQL)
%>
<script>
  function chk_Submit(valType, valIDX, chkPage){
    
    if(chkPage != "") $("#currPage").val(chkPage);

    if(valType == "VIEW"){
      $("#CIDX").val(valIDX);   
      $('form[name=s_frm]').attr('action',"./qnaViewBoard.asp");     
      $('form[name=s_frm]').submit(); 
    }
    else{
      $("#act").val("");  //초기화  
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
<section class="qnaBoard">
  <div id="content">
<form name="s_frm" method="post">
  <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="CIDX" id="CIDX" />
    <input type="hidden" name="act" id="act" />
  <!-- S: main container -->
  
     <div class="navigation_box">커뮤니티 &gt;  게시판 &gt; 질문과 답변</div>
      <br />
    <div class="search_top community">
        <div class="search_box">
         <select name="fnd_KeyWordType" id="fnd_KeyWordType">
                  <option value="1">제목</option>
                  <option value="2">내용</option>
                  <option value="3">제목 + 내용</option>
          </select>
                <input type="text" class="title_input in_2" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
                <a href="javascript:chk_Submit('FND','','');" class="btn btn-basic">검색</a>
        </div>
        </div>

  
    
        <table class="table-list notice-list basic-table">
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
          
          Title     = ReplaceTagReText(CRs("Title"))
          QnAIDX    = CRs("QnAIDX")
          QnATypeNm   = CRs("QnATypeNm")
          UserName  = CRs("UserName")
          ViewCnt   = CRs("ViewCnt")
          WriteDate   = CRs("WriteDate")
          
          IF fnd_KeyWord <> "" Then Title = replace(Title, fnd_KeyWord, "<font color='#ff0000'><strong>"&fnd_KeyWord&"</strong></font>")
            %>
            <tr>
              
              <td><%=totalcount - (currPage - 1) * B_Psize - cnt+1%></td>
              <td><%=QnATypeNm%></td>
              <td class="name">
                <a href="javascript:chk_Submit('VIEW','<%=QnAIDX%>','<%=currPage%>');"><%=Title%></a>
                <%
        
        IF RE_CONTENTS(QnAIDX) = TRUE Then response.Write "<span class='ic-re'>답변완료</span>"         
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
        
           
          </tbody>
        </table>

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
          response.Write "<li class=""first""><a href=""javascript:chk_Submit('LIST','',1);""><i class='fa fa-angle-left'></i><i class='fa fa-angle-left'></i></a></li>"
          response.Write "<li class=""prev""><a href=""javascript:chk_Submit('LIST','','"&currPage-1&"');"" class='fa fa-angle-left'></a></li>"
        End IF
      Else
        response.Write "<li class=""first""><a href=""javascript:chk_Submit('LIST','',1);""><i class='fa fa-angle-left'></i><i class='fa fa-angle-left'></i></a></li>"
        response.Write "<li class=""prev""><a href=""javascript:chk_Submit('LIST','','"&intTemp - BlockPage&"');"" class='fa fa-angle-left'></a></li>"
      End IF
      
      Do Until intLoop > BlockPage Or intTemp > TotalPage
        
        IF intTemp = CInt(currPage) Then
          response.Write "<li class=""active""><a href=""#"">"&intTemp&"</a></li>"
        Else
          response.Write "<li><a href=""javascript:chk_Submit('LIST','','"&intTemp&"');"">"&intTemp&"</a></li>"
        End If
        
        intTemp = intTemp + 1
        intLoop = intLoop + 1 
        
      Loop  
      
      IF intTemp > TotalPage Then
        IF cint(currPage) < cint(TotalPage) Then
          response.Write "<li class=""next""><a href=""javascript:chk_Submit('LIST','','"&currPage+1&"');"" class='fa fa-angle-right'></a></li>"
          response.Write "<li class=""last""><a href=""javascript:chk_Submit('LIST','','"&TotalPage&"');""><i class='fa fa-angle-right'></i><i class='fa fa-angle-right'></i></a></li>"
        Else
          response.Write "<li class=""next""><a href=""#"" class='fa fa-angle-right'></a></li>"
          response.Write "<li class=""last""><a href=""#""><i class='fa fa-angle-right'></i><i class='fa fa-angle-right'></i></a></li>"
        End IF
      Else
        response.Write "<li class=""next""><a href=""javascript:chk_Submit('LIST','','"&intTemp&"');"" class='fa fa-angle-right'></a></li>"
        response.Write "<li class=""last""><a href=""javascript:chk_Submit('LIST','','"&intTemp&"');""><i class='fa fa-angle-right'></i><i class='fa fa-angle-right'></i></a></li>"
      End IF 
      
      response.Write "</ul>"
      End IF
	  %>
        <!-- E: pagination -->

  </form>
  </div>
</section>
<!--#include file="footer.asp"-->