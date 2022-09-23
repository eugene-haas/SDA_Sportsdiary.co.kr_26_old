<!-- S: left-gnb -->
<div class="left-gnb">
  <!-- S: top-content -->
  <div class="top-content">
    <!-- S: user-name -->
    <div class="user-name">
      <p class="profile-img">
        <img src="/admin/images/profill-img.png" alt="">
      </p>
      <div class="r-con">
        <p class="p-name">

          <%=Request.Cookies("UserName")%> 님

        </p>
      </div>
    </div>
    <!-- E: user-name -->

    <%
			IF UserID <> "" and AdminYN = "Y" Then
		%>
    <!-- S: login-btn -->
    <div class="login-btn">
      <a href="javascript:;" onclick="javascript:chk_logout_Admin();" class="btn btn-primary">로그아웃</a>
    </div>
    <!-- E: login-btn -->
    <% Else %>
    <% End IF %>
    
  </div>
  <!-- E: top-content -->
  <!-- S: left-menu -->
  <div class="left-menu">
    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">

      <%
						
      	iLoginID = Request.Cookies("UserID")
      	'iLoginID = decode(iLoginID,0)
        iLoginID = crypt.DecryptStringENC(iLoginID)
      
      	LCnt = 0
      
      	iType = "2"
      
      	LSQL = "EXEC AdminMember_Menu_S '" & iType & "','','','" & iLoginID & "','','','','',''"
      	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
      	'response.End
      		
      	Set LRs = DBCon7.Execute(LSQL)
      
      	If Not (LRs.Eof Or LRs.Bof) Then
      
      		Do Until LRs.Eof
      
      				LCnt = LCnt + 1
      				iRoleDetailGroup1 = LRs("RoleDetailGroup1")
      				iRoleDetailGroup1Nm = LRs("RoleDetailGroup1Nm")
      %>
      <!-- S: <%=iRoleDetailGroup1Nm %> -->
      <div class="panel panel-default">
        
        <div class="panel-heading" role="tab" id="HD1_<%=iRoleDetailGroup1 %>">
          <h4 class="panel-title">
            <a class="collapsed" id="topdp1_<%=iRoleDetailGroup1 %>" data-toggle="collapse" data-parent="#accordion" href="#RG1_<%=iRoleDetailGroup1 %>" aria-expanded="false" aria-controls="RG1_<%=iRoleDetailGroup1 %>">
              <%=iRoleDetailGroup1Nm %>
            </a>
          </h4>
        </div>

        <div id="RG1_<%=iRoleDetailGroup1 %>" class="panel-collapse collapse" role="tabpanel" aria-labelledby="HD1_<%=iRoleDetailGroup1 %>">
          <div class='panel-body'>
            <ul id="RG1ul_<%=iRoleDetailGroup1 %>">

            </ul>
          </div>
        </div>
        
      </div>
      <!-- E: <%=iRoleDetailGroup1Nm %> -->
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
      		
      	Set LRs = DBCon7.Execute(LSQL)
      
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
      		
      	Set LRs = DBCon7.Execute(LSQL)
      
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
      
      			LRs.MoveNext
      		Loop
      					
      	End If
      
      	LRs.close


        LCnt3 = 0
      
      	iType = "6"
      
      	LSQL = "EXEC AdminMember_Menu_S '" & iType & "','','','" & iLoginID & "','','" & RoleType & "','','',''"
      	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
      	'response.End
      		
      	Set LRs = DBCon7.Execute(LSQL)
      
      	If Not (LRs.Eof Or LRs.Bof) Then
      
      	Do Until LRs.Eof
      
      				LCnt3 = LCnt3 + 1
      				iRoleDetail_3 = LRs("RoleDetail")
      				iRoleDetailGroup1_3 = LRs("RoleDetailGroup1")
      				iRoleDetailGroup2_3 = LRs("RoleDetailGroup2")
      
      			LRs.MoveNext
      		Loop
      					
      	End If
      
      	LRs.close

      %>

    </div>
  </div>
  <!-- E: left-menu -->
</div>
<!-- E: left-gnb -->

<% if LCnt1 > 0 then %>

<script type="text/javascript">

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

      iHtmlSum2 = iHtmlSum2 + '<li><p class="depth-2" id="dp1_' + iRoleDetailGroup1arr[i] + '_' + iRoleDetailGroup2arr[i] + '">' + iRoleDetailGroup2Nmarr[i] + '</p><div class="depth-2-con" id="dp2_' + iRoleDetailGroup1arr[i] + '_' + iRoleDetailGroup2arr[i] + '"><ul id="RG2_' + iRoleDetailGroup2arr[i] + '"></ul></div></li>';

			$('#RG1ul_' + iRoleDetailGroup1arr[i] + '').append(iHtmlSum2);

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

			var iRoleDetail_2arr = iRoleDetail_2.split("^");
			var iRoleDetailNm_2arr = iRoleDetailNm_2.split("^");
			var iRoleDetailGroup1_2arr = iRoleDetailGroup1_2.split("^");
			var iRoleDetailGroup1Nm_2arr = iRoleDetailGroup1Nm_2.split("^");
			var iRoleDetailGroup2_2arr = iRoleDetailGroup2_2.split("^");
			var iRoleDetailGroup2Nm_2arr = iRoleDetailGroup2Nm_2.split("^");
			var iLink_2arr = iLink_2.split("^");

			for (i = 1; i < LCnt2 + 1; i++) {

				iHtmlSum2 = "";

				iHtmlSum2 = iHtmlSum2 + '<li><a href="javascript:;" id="lstdp1_' + iRoleDetail_2arr[i] + '" onclick="javascript:fn_Link(&#39;' + iLink_2arr[i] + '&#39;)">' + iRoleDetailNm_2arr[i] + '</a></li>';

				$('#RG2_' + iRoleDetailGroup2_2arr[i] + '').append(iHtmlSum2);

			}

    }

    var LCnt3 = Number("<%=LCnt3%>");

    if (LCnt3 > 0) {

      var iRoleType = "<%=RoleType%>";

      var iRoleDetail_3 = "<%=iRoleDetail_3%>";
      var iRoleDetailGroup1_3 = "<%=iRoleDetailGroup1_3%>";
      var iRoleDetailGroup2_3 = "<%=iRoleDetailGroup2_3%>";

      $('#topdp1_' + iRoleDetailGroup1_3).attr('class', '');

      $('#RG1_' + iRoleDetailGroup1_3).attr('class', 'panel-collapse collapse in');
      $('#RG1_' + iRoleDetailGroup1_3).attr('aria-expanded', 'true');
      
      $('#dp1_' + iRoleDetailGroup1_3 + '_' + iRoleDetailGroup2_3).attr('class', 'depth-2 off');
      //$('#dp1_' + iRoleDetailGroup1_3 + '_' + iRoleDetailGroup2_3).removeClass('on');

      
      $('#dp2_' + iRoleDetailGroup1_3 + '_' + iRoleDetailGroup2_3).attr('class', 'depth-2-con on');
      $('#dp2_' + iRoleDetailGroup1_3 + '_' + iRoleDetailGroup2_3).attr('style', 'display: block');

      $('#lstdp1_' + iRoleType).attr('style', 'color: #2882c1');

    }

	}

</script>

<% end if %>