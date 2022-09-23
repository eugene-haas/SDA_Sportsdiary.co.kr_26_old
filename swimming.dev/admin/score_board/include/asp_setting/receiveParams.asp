<!--#include virtual="/score_board/ajax/_func/json2.asp"-->
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
%>
