	<table style="width:100%;" border="0" cellpadding="0" cellspacing="0" >
	<tr>
		<td colspan="4" bgcolor="#1E2744" >&nbsp;</td>
	</tr>
	<tr bgcolor="#1E2744">
		<td style="width:34px" ></td>
		<td style="width:190px"><a href="javascript:main_move(0)"><img src="./images/top_mark.gif" border=0></a></td>
		<td style="width:1px"><img src="./images/top_bs1.gif" border="0"></td>
		
		<td align="right" valign="bottom">
			<table border="0" cellpadding="0" cellspacing="0">
				<tR><td align=right>	
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><img src="./images/top_bs4.gif" border=0></td>
							<td style="color:#ffffff;"><%=aem_data(1)%> <font color=#97C6FD>[<%=poslvname%>]</font></td>
							<td><img src="./images/top_bs5.gif" border=0></td>
							<td><a href="./login_pass.asp?inx=2"><img src="./images/btn_logout.gif" border=0></a></td>
							<td><img src="./images/spacer.gif" width=5 height=1></td>
						</tr>
					</table>
				</td></tr>
				<tR><td><img src="./images/spacer.gif" width=1 height=4></td></tr>
			</table>
		</td>
	</tr>
	<tr bgcolor="#1E2744">
		<td></td>
		<td colspan="2"><img src="./images/mtitle<%=iif(user_lev=3,"01",main_index)%>.gif"></td>

		<td valign="top" >
			<table width="100%" cellpadding="0" cellspacing="0" border="0"  background="./images/top_menu_bg.gif">
				<tr>
<%
					Dim enabmun(10)
					For i = 1 To 10
						If user_lev=3 Then
							Select Case i
								Case 2,4,5,7:enabmun(i)=false
								Case Else:enabmun(i)=true
							End Select
							If user_id = "kjlc_02" Then
								If InStr("3,6",CStr(i)) > 0 Then
									enabmun(i)=false
								End If
							End If
						Else
							If i = 10 Then 
								enabmun(i)=False
							Else
								enabmun(i)=true
							End If
							If (InStr(1,aem_data(7),"6") = 0 And user_lev=2) And i=8 Then enabmun(i)=False
						End if
					Next
					For i = 1 To 8 '상단메뉴 갯수 조정
						If enabmun(i)=True Then
%>
							<td><img src="./admin_images/tmnu<%=i%>_off.gif" border=0 onmouseover="this.src='./admin_images/tmnu<%=i%>_on.gif';" onmouseout="this.src='./admin_images/tmnu<%=i%>_off.gif';" onclick="javascript:main_move(<%=i%>);" style="cursor:pointer"></td>
<%
						End if
					Next
					If user_lev=3 Or (InStr(1,aem_data(7),"7") = 0 And user_lev=2) Then 
						enabmun(10)=False
					Else
						enabmun(10)=True
					End if					
%>
					<td width=100% align=right><img src="./images/tmnu10_off.gif" border=0 onmouseover="this.src='./images/tmnu10_on.gif';" onmouseout="this.src='./images/tmnu10_off.gif';" onclick="javascript:main_move(10);" style="cursor:pointer"></td>
				</tr>
			</table>
		</td>
	</tr>
	</table>
	<div style="height:5px;width:100%;"></div>