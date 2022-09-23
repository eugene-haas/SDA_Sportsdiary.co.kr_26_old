<%

	iLCnt2 = 0

	iiType = "4"

	LSQL = "EXEC AdminMember_Menu_S '" & iiType & "','','','" & iLoginID & "','','','','',''"
	'response.Write "LSQL=LSQL=LSQL=LSQL=LSQL=LSQL=LSQL="&LSQL&"<br>"
	'response.End
		
	Set LRs = DBCon7.Execute(LSQL)

	If Not (LRs.Eof Or LRs.Bof) Then

	Do Until LRs.Eof

				iLCnt2 = iLCnt2 + 1
				iiRoleDetail_2 = iiRoleDetail_2&"^"&LRs("RoleDetail")&""
				'iRoleDetailNm_2 = iRoleDetailNm_2&"^"&LRs("RoleDetailNm")&""
				'iRoleDetailGroup1_2 = iRoleDetailGroup1_2&"^"&LRs("RoleDetailGroup1")&""
				'iRoleDetailGroup1Nm_2 = iRoleDetailGroup1Nm_2&"^"&LRs("RoleDetailGroup1Nm")&""
				'iRoleDetailGroup2_2 = iRoleDetailGroup2_2&"^"&LRs("RoleDetailGroup2")&""
				'iRoleDetailGroup2Nm_2 = iRoleDetailGroup2Nm_2&"^"&LRs("RoleDetailGroup2Nm")&""
				'iLink_2 = iLink_2&"^"&LRs("Link")&""

			LRs.MoveNext
		Loop
					
	End If

	LRs.close

	if instr(iiRoleDetail_2,RoleType) = 0 then

		response.Write "<script type='text/javascript'>chk_logout_Admin1();</script>"
		response.End

	end if
		
%>