<%
   Dim ReqParam, initscriptstr, page_no, scrollTop, search_obj, etc_obj
   ReqParam = request("p")

   If(ReqParam <> "") Then
      Set jsonObj = JSON.Parse(ReqParam)
      page_no = JsonObj.get("page_no")
      scrollTop = JsonObj.get("scrollTop")
      search_obj = JSON.Stringify(JsonObj.get("search_obj"))
      etc_obj = JSON.Stringify(JsonObj.get("etc_obj"))
      Set jsonObj = Nothing
   End If
   if IsEmpty(search_obj) Then
      search_obj = "''"
   End If
   if IsEmpty(etc_obj) Then
      etc_obj = "''"
   End If
   initscriptstr = initscriptstr & "/* ==================================================================================" & vbCrlf
   initscriptstr = initscriptstr & "      /include/asp_setting/receiveParams.asp 에서 만든 전역변수 선언문" & vbCrlf
   initscriptstr = initscriptstr & "      전역 변수 (수정 x, g_etc_obj 를 활용하세요.)" & vbCrlf
   initscriptstr = initscriptstr & "   ================================================================================== */" & vbCrlf
   initscriptstr = initscriptstr & "const g_page_no = Number('" & page_no & "'); // 페이지 번호" & vbCrlf
   initscriptstr = initscriptstr & "const g_scrollTop = Number('" & scrollTop & "'); // 페이지 스크롤값" & vbCrlf
   initscriptstr = initscriptstr & "const g_search_obj = " & search_obj & "||{}; // 검색 조건 obj" & vbCrlf
   initscriptstr = initscriptstr & "const g_etc_obj = " & etc_obj & "||{}; // 기타 params"
%>
