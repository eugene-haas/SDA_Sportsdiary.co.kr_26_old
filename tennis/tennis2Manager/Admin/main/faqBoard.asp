<!--#include file="../dev/dist/config.asp"-->
<!--#include file="head.asp"-->
<%
  '질문과 답변 목록페이지
  
' dim SportsGb    : SportsGb      = request.Cookies("SportsGb")
  dim SportsGb    : SportsGb      = "tennis"
  dim currPage      : currPage        = fInject(Request("currPage"))
  dim fnd_KeyWord   : fnd_KeyWord     = fInject(Request("fnd_KeyWord"))
  dim fnd_KeyWordType : fnd_KeyWordType   = fInject(Request("fnd_KeyWordType"))
  dim act       : act       = request("act")
  
  dim BlockPage     : BlockPage     = 10  '페이지
  dim B_PSize       : B_PSize       = 5 '페이지내 보여지는 목록카운트
  
  dim TotCount, TotPage
  dim CSearch
  dim CSQL, CRs
  dim txt_Re
  
  IF act = "DEL" Then
    
    FOR i = 1 to request("list_CHK").count
      
      CSQL = "    UPDATE [SD_tennis].[dbo].[tblSvcFAQ] "
      CSQL = CSQL & " SET DelYN = 'Y' "
      CSQL = CSQL & "   ,WorkDt = GETDATE() "
      CSQL = CSQL & " WHERE SportsGb = '"&SportsGb&"' "
      CSQL = CSQL & "   AND (FaqIDX = "&request("list_CHK")(i) & " OR ReFaqIDX = "&request("list_CHK")(i) &")"
      
      DBCon5.Execute(CSQL)  
      
      response.Write "<script>$('#act').val('');</script>"
      
    NEXT
    
  End IF
  
  IF Len(currPage) = 0 Then currPage = 1
  
  '답변글 정보 조회
    FUNCTION RE_CONTENTS(IDX)
    
    LSQL =  "     SELECT * "
    LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblSvcFaq] "
    LSQL = LSQL & " WHERE SportsGb = '"&SportsGb&"' "
    LSQL = LSQL & "     AND DelYN = 'N' "
    LSQL = LSQL & "     AND ReFaqIDX =  "&IDX
    
    SET LRs = DBCon5.Execute(LSQL)
    IF Not(LRs.Eof OR LRs.Bof) Then
      
      txt_Re = "      <tr>"
            txt_Re = txt_Re &"  <td  class=""name""><a href=""javascript:chk_Submit('VIEW', '"&IDX&"', '"&currPage&"');"">"
            txt_Re = txt_Re &"      <span class='ic-deco'>"
            txt_Re = txt_Re &"        <img src='./Images/ic_reply@3x.png' alt='답변'>"
            txt_Re = txt_Re &"      </span>"
      txt_Re = txt_Re &"    <span class='faq_reply'>"&replace(ReplaceTagReText(LRs("Contents")), fnd_KeyWord, "<font color='#ff0000'><strong>"&fnd_KeyWord&"</strong></font>")&"</span>"
            txt_Re = txt_Re &"    </a>"
            txt_Re = txt_Re &"  </td>"
            txt_Re = txt_Re &"</tr>"
      
      RE_CONTENTS = txt_Re

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
  CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcFaq]" 
  CSQL = CSQL & " WHERE DelYN = 'N' " 
  CSQL = CSQL & "   AND SportsGb = '"&SportsGb&"' "
  CSQL = CSQL & "   AND ReFaqIDX = 0 "&CSearch  
  
  
  SET CRs = DBCon5.Execute(CSQL) 
    TotalCount = CRs(0)
    TotalPage = CRs(1)
    
  CSQL =  "       SELECT TOP "&currPage * B_PSize
  CSQL = CSQL & "     FaqIDX  "
  CSQL = CSQL & "     ,CASE FAPubCode "
  CSQL = CSQL & "     WHEN 'FA01' THEN '전체' "
  CSQL = CSQL & "     WHEN 'FA02' THEN '선수' "
  CSQL = CSQL & "     WHEN 'FA03' THEN '선수보호자' "
  CSQL = CSQL & "     WHEN 'FA04' THEN '팀매니저' "
  CSQL = CSQL & "   END FAPubCodeNm " 
  CSQL = CSQL & "     ,ReFaqIDX  "
  CSQL = CSQL & "     ,WriteName UserName "
  CSQL = CSQL & "     ,Contents  "
  CSQL = CSQL & "     ,WriteDate  " 
  CSQL = CSQL & "     ,ViewCnt  "
  CSQL = CSQL & "     ,CASE ViewYN WHEN 'Y' THEN 'On' Else 'Off' END ViewYN  "	
  CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblSvcFaq] "
  CSQL = CSQL & " WHERE DelYN = 'N' "
  CSQL = CSQL & "   AND SportsGb = '"&SportsGb&"' " 
  CSQL = CSQL & "     AND ReFaqIDX = 0 "&CSearch
  CSQL = CSQL & " ORDER BY WriteDate DESC "
  
' response.Write "CSQL="&CSQL&"<br>"
  
  SET CRs = DBCon5.Execute(CSQL)
%>
<script>
  function chk_Submit(valType, valIDX, chkPage){
    
    if(chkPage != "") $("#currPage").val(chkPage);

    if(valType == "VIEW"){
      $("#CIDX").val(valIDX);   
      $('form[name=s_frm]').attr('action',"./faqWriteBoard.asp");     
      $('form[name=s_frm]').submit(); 
    }
    else if(valType == "DEL"){
      if($("#list_CHK:checked").length == 0) {
        alert("삭제하고자 하는 정보를 선택하여 주세요.");  
        return;
      }
      else{
        if(confirm("선택하신 정보를 삭제하시겠습니까?\n질문과 답변정보 모두 삭제됩니다.")){
          $("#act").val(valType);     
          $('form[name=s_frm]').attr('action',"./faqBoard.asp");     
          $('form[name=s_frm]').submit(); 
        }
        else{
          return; 
        }
      }
    }
    else{
      $("#act").val("");  //초기화  
      $('form[name=s_frm]').attr('action',"./faqBoard.asp");    
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
<section>
  <div id="content">
  <form name="s_frm" method="post">
    <input type="hidden" name="currPage" id="currPage" value="<%=currPage%>" />
    <input type="hidden" name="CIDX" id="CIDX" />
    <input type="hidden" name="act" id="act" />
    <!-- S: main container -->
    <div class="navigation_box"> 커뮤니티 &gt; 게시판 &gt; 자주하는 질문</div>
     <br />
    <!-- S: top row -->
    <div class="search_top community">
      <div class="search_box">
        <select name="fnd_KeyWordType" id="fnd_KeyWordType">
          <option value="2">내용</option>
          <!--
                  <option value="1">제목</option>
                  <option value="3">제목 + 내용</option>
                  -->
        </select>
        <input type="text" class="title_input in_2" name="fnd_KeyWord" id="fnd_KeyWord" value="<%=fnd_KeyWord%>" />
        <a href="javascript:chk_Submit('FND','','');" class="btn btn-basic">검색</a> <a href="javascript:chk_Submit('DEL','','');" class="btn btn-redy">선택 삭제</a> <a href="./faqWriteBoard.asp" class="btn btn-blue">글쓰기</a> 
        </div>
    </div>
    <!-- E: top row -->
    <!-- S: article-bg -->
   
      <!-- S: board-list -->
      <table class="table-list notice-list faqBoard basic-table">
        <thead>
          <tr>
            <th>선택</th>
            <th>번호</th>
            <th>구분</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
			<th>출력</th>  
          </tr>
        </thead>
        <tbody>
          <%
            If Not(CRs.Eof Or CRs.Bof) Then 
        
        CRs.Move (currPage - 1) * B_PSize
        
        Do Until CRs.eof
        
          cnt = cnt + 1  
          
          Contents    = ReplaceTagReText(CRs("Contents"))
          FaqIDX      = CRs("FaqIDX")
          ReFaqIDX    = CRs("ReFaqIDX")
          FAPubCodeNm   = CRs("FAPubCodeNm")
          UserName    = CRs("UserName")
          ViewCnt     = CRs("ViewCnt")
          WriteDate     = CRs("WriteDate")
		  ViewYN     = CRs("ViewYN")	 
          
          IF fnd_KeyWord <> "" Then Title = replace(Title, fnd_KeyWord, "<font color='#ff0000'><strong>"&fnd_KeyWord&"</strong></font>")
            %>
          <tr>
            <td rowspan="2"><input type="checkbox" name="list_CHK" id="list_CHK" value="<%=CRs("FaqIDX")%>"></td>
            <td rowspan="2"><%=totalcount - (currPage - 1) * B_Psize - cnt+1%></td>
            <td rowspan="2"><%=FAPubCodeNm%></td>
            <td class="name"><a href="javascript:chk_Submit('VIEW', '<%=CRs("FaqIDX")%>', '<%=currPage%>');"><%=Contents%></a></td>
            <td rowspan="2"><%=UserName%></td>
            <td rowspan="2"><%=replace(left(CRs("WriteDate"),10), "-",".")%></td>
			<td rowspan="2"><%=ViewYN%></td>	
          </tr>
          <%
          IF RE_CONTENTS(FaqIDX) <> "" Then response.Write RE_CONTENTS(FaqIDX)
      
                CRs.movenext
              Loop  
            Else  
            
            %>
          <tr>
            <td colspan="7">등록된 글이 없습니다.</td>
          </tr>
          <%
            
            End IF  
            
              CRs.Close
            SET CRs = Nothing
          
           %>
        </tbody>
      </table>
      <!-- E: board-list -->
      <!-- S: board-btm-list -->
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
          response.Write "<li class=""prev""><a href=""javascript:chk_Submit('LIST','','"&currPage-1&"');""><i class='fa fa-angle-left'></i></a></li>"
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
      <!-- E: board-btm-list -->
   
    <!-- E: article-bg -->
  </form>
</div>
</section>
<!--#include file="footer.asp"-->
