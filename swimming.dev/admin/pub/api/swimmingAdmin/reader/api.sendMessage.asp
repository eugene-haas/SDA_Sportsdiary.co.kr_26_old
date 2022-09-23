<%
'#############################################
'설정된 문자를 보낸다.
'#############################################

	'request
	If hasown(oJSONoutput, "PIDX") = "ok" Then
		pidx = oJSONoutput.get("PIDX")
	End If

	Set db = new clsDBHelper


	'공통 ###########################################
      SQL = "select sido,boonm,teamcode,message,chkyear  from tblMsgSend_cfg where adminid = '"&Cookies_aID&"' and delyn = 'N'  and mtype= '2' " '선수관리 1 리더관리 2
      Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

      if not rs.eof then
			swmsgkey = "korswim"
			sendphone = "024204236"

			sido = isnulldefault(rs("sido"),"") '시도코드
			teamcode = isnulldefault(rs("teamcode"),"") '소속팀코드
			
			
			message = replace(isnulldefault(rs("message"),""),"'","''") '문자내용
			chkyear = rs("chkyear") '해당년도

			titlemessage = "대한수영연맹"
			messageContents = Replace(message, vbcrLf,"\n")
			messageContents = Replace(message, vbLf,"\n")
			messageContents = Replace(message, vbCr,"\n")

			
'			if instr(message , vbCrLf)  > 0 or instr(message , vbLf)  > 0 Then
'				messageline =  split(message,vbLf)
'				titlemessage = messageline(0)
'				for i = 1 to ubound(messageline)
'					messageContents = messageContents & messageline(i) & chr(10)
'				Next
'			end If
			

			if sido <> "" Then
				sidowhere = " and SIDOCODE = '"&sido&"' "
			end if

			If chkyear <> "" Then
				yearwhere = " and  chkyear = '"&chkyear&"'  "
			End if

			if teamcode <> "" Then
				teamwhere = " and TEAM = '"&teamcode&"'  "
			end If
		end If
		


		'선수만 
		SQL = "Select username,userphone from tblreader where  (delyn='N'  and chkmsg = 'Y'  )  "

		'팀
		If teamcode <> ""  then
			SQL = SQL & "  or (delyn='N'  " & teamwhere & " and chkyear = '"&chkyear&"'  ) "
		End If

		If sido <> ""  then
			SQL = SQL & "  or (delyn='N'  " & sidowhere & " and chkyear = '"&chkyear&"' )  "
		End If

'Response.write sql
'Response.end


		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrR = rs.GetRows()
	    End If

'Call getrowsDrow(arrR)
'Response.write sql
'Response.end




		'문자전송
		CSQL = ""
		If IsArray(arrR) Then
			i = 1
			For ari = LBound(arrR, 2) To UBound(arrR, 2)
				p_unm = arrR(0, ari)
				p_pno = arrR(1, ari)

				 'insert
		        CSQL = CSQL & " INSERT INTO SD_tennis.dbo.T_SEND (SSUBJECT ,NSVCTYPE,NADDRTYPE,SADDRS ,NCONTSTYPE,SCONTS,SFROM,DTSTARTTIME, sUserID	) "
		        CSQL = CSQL & " VALUES ('"&titlemessage&"',7,0,'" & p_pno & "',0,'" & messageContents & "','"&sendphone&"',GETDATE(), '"&swmsgkey&"' )" '& "<br>"


				if i mod 200 = 0 Then
      			Call db.execSQLRs(CSQL , null, ConStr)
	            CSQL = ""
	         end if

			i = i + 1
			next
		end if

		if CSQL <> "" then
			Call db.execSQLRs(CSQL , null, ConStr)

'Response.write CSQL
'Response.end

			CSQL = ""
		end If
		


      '설정값들 초기화
		SQL = "update tblMsgSend_cfg set delyn = 'Y' where adminid = '"&Cookies_aID&"' and delyn = 'N'  and mtype= '2' " '선수관리 1 리더관리 2
		SQL = SQL & " update tblreader set chkmsg = 'N' where delyn = 'N' and chkmsg = 'Y' " '내가 체크한것만 지울수 있나.
		Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing


%>
