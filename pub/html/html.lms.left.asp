	<aside>
	<!-- left fulldown menu -->
  <nav class="nav" role="navigation">
    <ul class="nav__list">
	  <%
	  mno = request.cookies("mno")'선택된 메뉴번호
	  If mno = "" Then
		  mno = 0
	  End if

	  leftmenuarr = array("데이터베이스", "웹서비스","게시판","회원정보")

	 sm2 = ubound(leftmenuarr)

    Dim smenudata(4)
	Dim smenucmd(4)

    smenudata(0)="테이블 카운트|기본 구조"
    smenudata(1)="IIS정보"
    smenudata(2)="게시판"
    smenudata(3)="회원정보검색"

    smenucmd(0)="mx.CMD_TABLELIST|mx.CMD_DBBASIC"
    smenucmd(1)="mx.CMD_IISINFO"
    smenucmd(2)="mx.CMD_BOARD"
    smenucmd(3)="mx.CMD_USERINFO"



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
			  Response.write "<li><a href=""javascript:mx.SendPacket(this, {'CMD':"&dowcmd(x)&"})"">"& dowmu(x) &"</a></li>"
		Next
		%>
        </ul>
      </li>
	  <%next%>

    </ul>
  </nav>	
	
	</aside>

