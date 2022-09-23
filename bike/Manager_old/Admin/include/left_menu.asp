<!-- S: main -->

<div class="main">
<!-- S : left-navi navi left-navi 네비게이션 -->
<div id="left-navi">
  <%        
      iLoginID = Request.Cookies("UserID")
      iLoginID = decode(iLoginID,0)
     

      LCnt = 0
      iType = "2"
      LSQL = "EXEC AdminMember_Menu_S '" & iType & "','','','" & iLoginID & "','','','','',''"
      'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
      'response.End
      
      Set LRs = DBCon.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then

        Do Until LRs.Eof

            LCnt = LCnt + 1
            iRoleDetailGroup1 = LRs("RoleDetailGroup1")
            iRoleDetailGroup1Nm = LRs("RoleDetailGroup1Nm")
    %>
  <!-- S: depth -->
  <div class="depth">
    <h2><%=iRoleDetailGroup1Nm %></h2>
    <!-- S: depth-2 -->
    <ul class="depth-2" id="RG1_<%=iRoleDetailGroup1 %>">
    </ul>
    <!-- E: depth-2 --> 
  </div>
  <!-- E: depth -->
  <%
      		LRs.MoveNext
        Loop

      End If
      	 LRs.close



        LCnt1 = 0

        iType = "3"

        LSQL = "EXEC AdminMember_Menu_S '" & iType & "','','','" & iLoginID & "','','','','',''"
        'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        'response.End
          
        Set LRs = DBCon.Execute(LSQL)
        If Not (LRs.Eof Or LRs.Bof) Then

        Do Until LRs.Eof
              LCnt1 = LCnt1 + 1
              iRoleDetailGroup1 = iRoleDetailGroup1&"^"&LRs("RoleDetailGroup1")&""
              iRoleDetailGroup1Nm = iRoleDetailGroup1Nm&"^"&LRs("RoleDetailGroup1Nm")&""
              iRoleDetailGroup2 = iRoleDetailGroup2&"^"&LRs("RoleDetailGroup2")&""
              iRoleDetailGroup2Nm = iRoleDetailGroup2Nm&"^"&LRs("RoleDetailGroup2Nm")&""
            LRs.MoveNext
          Loop
        End If
        	LRs.close



        LCnt2 = 0

        iType = "4"

        LSQL = "EXEC AdminMember_Menu_S '" & iType & "','','','" & iLoginID & "','','','','',''"
        'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
        'response.End
          
        Set LRs = DBCon.Execute(LSQL)

        If Not (LRs.Eof Or LRs.Bof) Then

        Do Until LRs.Eof

			LCnt2 = LCnt2 + 1
			iRoleDetail_2 = iRoleDetail_2&"^"&LRs("RoleDetail")&""
			iRoleDetailNm_2 = iRoleDetailNm_2&"^"&LRs("RoleDetailNm")&""
			iRoleDetailGroup1_2 = iRoleDetailGroup1_2&"^"&LRs("RoleDetailGroup1")&""
			iRoleDetailGroup1Nm_2 = iRoleDetailGroup1Nm_2&"^"&LRs("RoleDetailGroup1Nm")&""
			iRoleDetailGroup2_2 = iRoleDetailGroup2_2&"^"&LRs("RoleDetailGroup2")&""
			iRoleDetailGroup2Nm_2 = iRoleDetailGroup2Nm_2&"^"&LRs("RoleDetailGroup2Nm")&""
			iLink_2 = iLink_2&"^"&LRs("Link")&""
			iPopupYN_2 = iPopupYN_2&"^"&LRs("PopupYN")&""

			LRs.MoveNext
        Loop                
      End If
        LRs.close

	%>
  <% if LCnt1 > 0 then %>
  <script type="text/javascript">

        function openInNewTab(url) {
            var win = window.open(url, '_blank');
            win.focus();
        }

        var LCnt1 = Number("<%=LCnt1%>");

        if (LCnt1 > 0) {

          var iRoleDetailGroup1 = "<%=iRoleDetailGroup1%>";
          var iRoleDetailGroup1Nm = "<%=iRoleDetailGroup1Nm%>";
          var iRoleDetailGroup2 = "<%=iRoleDetailGroup2%>";
          var iRoleDetailGroup2Nm = "<%=iRoleDetailGroup2Nm%>";

          var iRoleDetailGroup1arr = iRoleDetailGroup1.split("^");
          var iRoleDetailGroup1Nmarr = iRoleDetailGroup1Nm.split("^");
          var iRoleDetailGroup2arr = iRoleDetailGroup2.split("^");
          var iRoleDetailGroup2Nmarr = iRoleDetailGroup2Nm.split("^");

          for (var i = 1; i < LCnt1 + 1; i++) {

            var iHtmlSum2 = "";

            iHtmlSum2 = iHtmlSum2 + '<li><a href="#" class="menu-btn">' + iRoleDetailGroup2Nmarr[i] + '</a><ul class="depth-3" id="RG2_' + iRoleDetailGroup2arr[i] + '"></ul></li>';

            $('#RG1_' + iRoleDetailGroup1arr[i] + '').append(iHtmlSum2);

          }

          var LCnt2 = Number("<%=LCnt2%>");

          if (LCnt2 > 0) {

            var iRoleDetail_2 = "<%=iRoleDetail_2%>";
            var iRoleDetailNm_2 = "<%=iRoleDetailNm_2%>";
            var iRoleDetailGroup1_2 = "<%=iRoleDetailGroup1_2%>";
            var iRoleDetailGroup1Nm_2 = "<%=iRoleDetailGroup1Nm_2%>";
            var iRoleDetailGroup2_2 = "<%=iRoleDetailGroup2_2%>";
            var iRoleDetailGroup2Nm_2 = "<%=iRoleDetailGroup2Nm_2%>";
            var iLink_2 = "<%=iLink_2%>";
            var iPopupYN_2 = "<%=iPopupYN_2%>";
            

            var iRoleDetail_2arr = iRoleDetail_2.split("^");
            var iRoleDetailNm_2arr = iRoleDetailNm_2.split("^");
            var iRoleDetailGroup1_2arr = iRoleDetailGroup1_2.split("^");
            var iRoleDetailGroup1Nm_2arr = iRoleDetailGroup1Nm_2.split("^");
            var iRoleDetailGroup2_2arr = iRoleDetailGroup2_2.split("^");
            var iRoleDetailGroup2Nm_2arr = iRoleDetailGroup2Nm_2.split("^");
            var iLink_2arr = iLink_2.split("^");
            var iPopupYN_2arr = iPopupYN_2.split("^");

            for (var i = 1; i < LCnt2 + 1; i++) {

              var iHtmlSum2 = "";

              //iHtmlSum2 = iHtmlSum2 + '<li><a href="javascript:;" onclick="javascript:fn_Link(&#39;' + iLink_2arr[i] + '&#39;)">' + iRoleDetailNm_2arr[i] + '</a></li>';


              if (iPopupYN_2arr[i] == "Y") {
                  iHtmlSum2 = iHtmlSum2 + '<li><a href="' + iLink_2arr[i] + '" target="_blank">' + iRoleDetailNm_2arr[i] + '</a></li>';
              }
              else {
                  iHtmlSum2 = iHtmlSum2 + '<li><a href="javascript:;" onclick="javascript:fn_Link(&#39;' + iLink_2arr[i] + '&#39;)">' + iRoleDetailNm_2arr[i] + '</a></li>';
              }

              $('#RG2_' + iRoleDetailGroup2_2arr[i] + '').append(iHtmlSum2);

            }

          }

        }
      </script>
  <%
	 Else
	 	response.write "<div>설정된 메뉴정보가 없습니다.</div>"
	 
	  end if 
%>
</div>
<!-- E : left-navi --> 
