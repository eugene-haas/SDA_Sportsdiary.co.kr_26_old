<!-- left fulldown menu -->
  <nav class="nav" role="navigation">
    <ul class="nav__list">
	  <%
		Select Case PAGENAME
		Case "contest.asp","player.asp","team.asp"
		mno = 1
		Case "contestlevel.asp"
		mno = 0
		Case "findcontestplayer.asp", "findcontestplayer_dev.asp", "checkagreement.asp", "findcontestcancelplayer.asp"
		mno = 2
		Case Else
		mno = 0
		End Select 

	  'mno = request.cookies("mno")'선택된 메뉴번호
	  If mno = "" Then
		  mno = 0
	  End if

If CDbl(ADGRADE) > 500 then
	  leftmenuarr = array("대회관리", "대회신청관리")
Else
	  leftmenuarr = array("대회관리")
End if

	 sm2 = ubound(leftmenuarr)

    Dim smenudata(6)
	Dim smenucmd(6)


'If CDbl(ADGRADE) > 500 then
	smenudata(0)="대회정보관리|선수관리|팀관리|대회등급관리"
	smenucmd(0)="./contest.asp|./player.asp|./team.asp|./titleCode.asp|"
	smenudata(1)="대회신청정보|신청취소자정보|대회신청정보(개발)|부모동의확인"
	smenucmd(1)="./findcontestplayer.asp|./findcontestcancelplayer.asp|./findcontestplayer_dev.asp|./checkAgreement.asp|"
'Else
'	smenudata(0)="대회정보관리"
'	smenucmd(0)="./contest.asp"
'End if


	  For n = 0 To sm2
		dowmu = Split(smenudata(n),"|")
		dowcmd = Split(smenucmd(n),"|")

	  %>
	  <li>
        <input id="group-<%=n+1%>" type="checkbox" hidden  <%If n = Cdbl(mno-1) then%>checked<%End if%>/>
        <label for="group-<%=n+1%>"><span class="fa fa-angle-right"></span> <%=leftmenuarr(n)%></label>
        <ul class="group-list">
		<%
		linkno = 0		  
		For x = 0 To ubound(dowmu)
			  Response.write "<li><a href="""&dowcmd(x)&""">"& dowmu(x) &"</a></li>"			
		Next
		%>
        </ul>
      </li>
	  <%next%>
    </ul>


	

	<!-- <a href="/gamerull3.asp?tidx=28&ridx=20105001"  >(신)본선대진생성</a> -->

<%
'#################################
If USER_IP = "118.33.86.240" Then
	If CDbl(ADGRADE) > 500 then
	%>
		<!-- <hr width="100%" style="margin:0;padding:0;">
		<a href="rank2017.asp"  >랭킹포인트업로드</a> -->
	<%
	End if
End if%>

 
  <%If USER_IP = "118.33.86.240" Then%>
	<!-- <a href="tennisDbCenter.asp"   >테이블백업</a> -->
  <%End if%>

  </nav>	