<%
	If hasown(oJSONoutput, "FORMNO") = "ok" then
		fno = oJSONoutput.FORMNO
	End If

	If hasown(oJSONoutput, "SEQ") = "ok" then
		userid = oJSONoutput.SEQ
	End If

	If hasown(oJSONoutput, "F1") = "ok" then
		F1 = oJSONoutput.F1
	End If
	If hasown(oJSONoutput, "F2") = "ok" then
		F2 = oJSONoutput.F2
	End If



	Set db = new clsDBHelper

		title = "메뉴생성"
fieldstr = "order_seq,gl_pe,order_dt,order_nm,cm_hp,cm_tel,cm_fax,cm_num,cm_num_sub,cm_jong,cm_uptae,cm_pe,licensee_nm,cm_zip,cm_zip2,cm_addr,cm_addr_detl,memo,re_rtn_yn,re_sms_yn,re_sms_dt,re_email_yn,re_email_dt,grp1,grp2,grp3,grp4,grp5,grp6,cust_tp,online_id,online_pwd,cm_email,in_tp,in_ok,in_ok_dt,Event_in_ok,order_ban_yn,work_dt,work_nm,del_yn,uni_grp_cd,update_gubun,kb_gb,wel_group,PSNM_GUBUN,ManagerNum,cm_addr1,cm_addr2,search_text,SK_GProject,KB_Code,ADMIN_YN,ICBM_RANK,SERV_ST_DT,SERV_ED_DT,SERV_FIST_MNY,SERV_WEB_MNY,SERV_SVR_MNY,SER_STOP_YN,STATE_TP,LOGIN_DT_TM,OUT_DT,ONLINE_CD"

'	ORDER_SEQ = rs("ORDER_SEQ")
'	ONLINE_ID = rs("ONLINE_ID")

	SQL = "select top 10 * from IC_T_ORDER_CUST where online_id = '"&userid&"'   and gl_pe = '"&GL_PE&"'  and del_yn = 'N'  "
	Set rs = db.ExecSQLReturnRS(SQL , null,ConStr)


'		If Not rs.EOF Then
'			arrRS = rs.GetRows()
'		End If

'	Call rsdrow(rs)


	db.Dispose
	Set db = Nothing
%>


	  <div class="modal-dialog">
		<div class="modal-content">
		  <div class="modal-header">
			<h4 class="modal-title" id="myModalLabel"><%=title%>&nbsp;&nbsp;<a href="javascript:mn.writePop('dbhelp_modal',<%=fno%><%If seq<> "" then%>,<%=seq%><%End if%>)" class="white-btn">&nbsp;새로고침&nbsp;</a></h4>  
		  </div>
		  <div class="modal-body">

					<div class="table-box basic-table-box" id="w_form">
						
						<table cellspacing="0" cellpadding="0">
    						 <tr>
    							<th style="width:100%;" colspan="2">생성</th>
    						</tr> 

			<%
				Select Case CDbl(fno)
				Case 1
			%>
							<tr>
									<td style="width:50%;background:gray;color:white">대메뉴</td>
									<td style="width:50%;word-break:break-all;">
										<select  id="dep01"  class="sl_search" style="width:98%;" onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)">
										  <option value="">=대분류=</option>
											  <%
											  If IsArray(arrRS) Then
												  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
													  grp1 = arrRS(0, ar)
													  grp1nm = arrRS(1, ar)
													  grp1cnt =  arrRS(2, ar)
													  %><option value="<%=grp1nm%>" <%If grp1nm = fldname then%>selected<%End if%>><%=grp1nm%> [<%=grp1cnt%>]</option><%
												  i = i + 1
												  Next
											  End if
											  %>
											  <option value="insert">[추가생성]</option>
										</select>						  
									</td>
							</tr>

							<tr>
									<td style="width:30%;background:gray;color:white">중메뉴</td>
									<td style="width:70%;word-break:break-all;">
										<select  id= "dep02"  class="sl_search" style="width:98%;" disabled>
										  <option value="">=중메뉴 (대분류선택 후 활성화)=</option>
										</select>
									</td>
							</tr>
    						<tr>
									<td style="width:30%;background:gray;color:white">상세메뉴</td>
									<td style="width:70%;word-break:break-all;"><input type='text' id= "dep03" style="width:100%;" placeholder="중 메뉴 활성화 후 입력" disabled></td>
							</tr>
    						<tr>
									<td style="width:30%;background:gray;color:white">경로URL</td>
									<td style="width:70%;word-break:break-all;"><input type='text' id="mn_url"  style="width:100%;"></td>
							</tr>
							<tr>
									<td style="width:30%;background:gray;color:white">어드민권한</td>
									<td style="width:70%;word-break:break-all;">
										<select  id="ad_class"  class="sl_search" style="width:98%;"> <!-- onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)"> -->
										  <option value="">=권한등급=</option>
											  <%
											  If IsArray(arrC) Then
												  For ar = LBound(arrC, 2) To UBound(arrC, 2)
													  r_idx = arrC(0, ar)
													  r_nm = arrC(1, ar)
													  r_code =  arrC(2, ar)
													  %><option value="<%=r_code%>" <%If CStr(r_code) = CStr(aclass) then%>selected<%End if%>><%=r_nm%> [<%=r_code%>]</option><%
												  i = i + 1
												  Next
											  End if
											  %>
											  <!-- <option value="insert">[추가생성]</option> -->
										</select>	
									</td>
							</tr>
			<%Case 2'######################################################################################################################%>
							<%jsonstr = JSON.stringify(oJSONoutput)%>
							<tr>
									<td style="width:30%;background:gray;color:white">ERP 아이디검색</td>
									<td style="width:70%;word-break:break-all;">
										<input type="hidden" id="PF1" value="erpid">
										<input type="text" maxlength="20" id="PF2" style="width:50%;" onkeydown='if(event.keyCode == 13){mn.Search(<%=jsonstr%>,$("#PF1").val(), $("#PF2").val())}' placeholder="ERPID 입력" value="<%=F2%>" autocomplete="nope">
										<a href='javascript:mn.Search(<%=jsonstr%>,$("#PF1").val(), $("#PF2").val())' class="blue-btn" style="width:40%">검색</a>
										
									</td>
							</tr>						

							<tr>
									<td style="width:30%;background:gray;color:white">아이디/비번/이름</td>
									<td style="width:70%;word-break:break-all;">
										<input type='text' id="ad_id"  style="width:30%;float:left;" placeholder="ID 입력" value="<%If findid <> "" then%><%=findid%><%else%><%=a_rid%><%End if%>">
										<input type='password' id="ad_pwd"  style="width:30%;float:left;ime-mode:inactive;"  placeholder="PWD 입력"  value="<%If findpwd <> "" then%><%=findpwd%><%else%><%=a_rpwd%><%End if%>" autocomplete="new-password"><!-- 한글사용불가 -->
										<input type='text' id="ad_name"  style="width:38%;float:left;"   placeholder="NAME 입력"  value="<%If findname <> "" then%><%=findname%><%else%><%=a_rname%><%End if%>">
									</td>
							</tr>
							<tr>
									<td style="width:30%;background:gray;color:white">어드민권한/업체코드</td>
									<td style="width:70%;word-break:break-all;">
										<select  id="ad_class"  class="sl_search" style="width:45%;"> <!-- onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)"> -->
										  <option value="">=권한등급=</option>
											  <%
											  If IsArray(arrRS) Then
												  For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
													  r_idx = arrRS(0, ar)
													  r_nm = arrRS(1, ar)
													  r_code =  arrRS(2, ar)
													  %><option value="<%=r_code%>" <%If CStr(r_code) = CStr(a_rcode) then%>selected<%End if%>><%=r_nm%> [<%=r_code%>]</option><%
												  i = i + 1
												  Next
											  End if
											  %>
											  <!-- <option value="insert">[추가생성]</option> -->
										</select>


										<select  id="com_code"  class="sl_search" style="width:45%;"> <!-- onchange="mn.SelectDEP(1,'dep01','w_form',mn.CMD_INSERTDEP1)"> -->
										  <option value="">=업체코드=</option>
											  <%
											  If IsArray(arrComCode) Then
												  For ar = LBound(arrComCode, 2) To UBound(arrComCode, 2)
													  c_code = arrComCode(0, ar)
													  c_nm = arrComCode(1, ar)
													  If c_nm = "" Or isnull(c_nm) = true Then
														c_nm = c_code
													  End if
													  %><option value="<%=c_code%>" <%If CStr(c_code) = CStr(findcomcode) then%>selected<%End if%>><%=c_nm%></option><%
												  i = i + 1
												  Next
											  End if
											  %>
											  <!-- <option value="insert">[추가생성]</option> -->
										</select>



									</td>
							</tr>

    						<tr>
									<td style="background:gray;color:white" colspan="2">권한선택</td>
							</tr>
    						<tr>
									<td style="word-break:break-all;" colspan="2">
									
									
											  <%
											  'RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,RoleDetailGroup2Nm,RoleDetail,RoleDetailNm "
											  If IsArray(arrMn) Then

												  For ar = LBound(arrMn, 2) To UBound(arrMn, 2)
													  m_d1 = arrMn(0, ar)
													  m_d1nm = arrMn(1, ar)
													  m_d2 = arrMn(2, ar)
													  m_d2nm = arrMn(3, ar)
													  m_d3 = arrMn(4, ar)
													  m_d3nm = arrMn(5, ar)
													  chk_str = m_d1nm & m_d2nm

													  
													  
													  If (prechkstr <> "" And chk_str <> prechkstr) Or prechkstr = "" Then
														If (prechkstr <> "" And chk_str <> prechkstr) Then
														Response.write "</div>"
														End if
														%>
														<div style="width:100%;border-bottom: 1px dotted gray;text-align:left;padding:5px">
															<span class="white-btn" style="width:180px;text-align:left;padding:5px;"><%=m_d1nm%> _ <%=m_d2nm%></span>
														<%
													  End If
													  %>
													  
															<label class="gray-btn" style="width:180px;text-align:left;padding:5px;">
															<input type='checkbox' id="ad_name" name="ad_name" value="<%=m_d3%>"    
															<%
															If IsArray(arrChkRole) Then
															  For a = LBound(arrChkRole, 2) To UBound(arrChkRole, 2)
			  													  chkrole = arrChkRole(0, a)
																  If m_d3 = chkrole Then
																	%>checked<%
																  End if
															  Next
															End If
															%>
															> <%=m_d3nm%></label>
													  
													  <%
													  prechkstr = m_d1nm & m_d2nm

												  Next
											  End if
											  %>

									
									</td>
							</tr>


			<%End select%>

    					</table>



    				</div>

			<!-- E: list-tale -->
		  </div>
		  <div class="modal-footer">
			<a href="javascript:location.reload()" class="white-btn" >닫기</a>
			<%
				Select Case CDbl(fno)
				Case 1
			%>
			<a href="javascript:mn.writeOK(3,'dep03','w_form',mn.CMD_MENU_WOK)" class="navy-btn">생성</a> 
			<%Case 2%>
				<%If seq = "" then%>
					<a href="javascript:mn.adminWriteOK(mn.CMD_ADMIN_WOK)" class="navy-btn">생성</a> 
				<%else%>
					<a href="javascript:mn.adminEditOK(mn.CMD_ADMIN_EOK,<%=seq%>)" class="navy-btn">수정</a> 
				<%End if%>
			<%End Select %>
		  </div>
		</div>
	  </div>

