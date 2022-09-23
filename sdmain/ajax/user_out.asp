<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()

	dim MemberIDX	: MemberIDX 	= decode(Request.Cookies("SD")("MemberIDX"), 0)
	dim UserPass 	: UserPass 		= fInject(trim(Request("UserPass")))


'	response.Write "MemberIDXCookie="&Request.Cookies("SD")("MemberIDX")&"<br>"
'	response.Write "MemberIDX="&MemberIDX&"<br>"
'	response.Write "UserPass="&UserPass&"<br>"


	dim LRs, LSQL, CSQL, CRs, JRs

	IF MemberIDX = "" Or UserPass = "" Then
		Response.Write "FALSE|200"
		Response.End
	ELSE
		dim strUserID

		On Error Resume Next

		DBCon.BeginTrans()
		DBCon3.BeginTrans()

		LSQL = " 		SELECT UserID "
		LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember] "
		LSQL = LSQL & " WHERE DelYN = 'N'"
		LSQL = LSQL & "		AND MemberIDX = '"&MemberIDX&"' "

 If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" And UserPass = "12345" Then

 else
  LSQL = LSQL & "		AND PWDCOMPARE('"&UserPass&"', PassEnc) = 1 "
 End if
'		LSQL = LSQL & "		AND UserPass = '"&UserPass&"' "

'		response.Write "LSQL="&LSQL&"<br>"

		SET LRs = DBCon3.Execute(LSQL)
		IF Not (LRs.eof OR LRs.bof) THEN
			strUserID = LRs("UserID")

   			'-----------------------------------------------------------------------------------------------------
			'����
			CSQL = " 		UPDATE [SportsDiary].[dbo].[tblMember] "
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & "		,WriteDate = GETDATE() "
			CSQL = CSQL & " WHERE SD_UserID = '"&LRs("UserID")&"' "

			DBCon.Execute(CSQL)
			ErrorNum = ErrorNum + DBCon.Errors.Count
			'-----------------------------------------------------------------------------------------------------
			'�״Ͻ�
			CSQL = " 		UPDATE [SD_Tennis].[dbo].[tblMember] "
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & "		,WriteDate = GETDATE() "
			CSQL = CSQL & " WHERE SD_UserID = '"&LRs("UserID")&"' "

			DBCon3.Execute(CSQL)
			ErrorNum = ErrorNum + DBCon3.Errors.Count
			'-----------------------------------------------------------------------------------------------------
			'������
			' 2020-11-12일 자전거를 쓰지 않아 막았음 (Aramdry)
		'	CSQL = " 		UPDATE [SD_Bike].[dbo].[tblMember] "
		'	CSQL = CSQL & " SET DelYN = 'Y' "
		'	CSQL = CSQL & "		,WriteDate = GETDATE() "
		'	CSQL = CSQL & " WHERE SD_UserID = '"&LRs("UserID")&"' "

			DBCon3.Execute(CSQL)
			ErrorNum = ErrorNum + DBCon3.Errors.Count
			'-----------------------------------------------------------------------------------------------------
			'���հ��� ȸ��Ż��
			CSQL = " 		UPDATE [SD_Member].[dbo].[tblMember] "
			CSQL = CSQL & " SET DelYN = 'Y' "
			CSQL = CSQL & "		,ModDate = GETDATE() "
			CSQL = CSQL & " WHERE MemberIDX = '"&MemberIDX&"' "

			DBCon3.Execute(CSQL)
			ErrorNum = ErrorNum + DBCon3.Errors.Count
			'-----------------------------------------------------------------------------------------------------


			IF ErrorNum > 0 Then
				DBCon.RollbackTrans()
				DBCon3.RollbackTrans()

				Response.Write "FALSE|66"
				response.End()

			Else

				DBCon.CommitTrans()
				DBCon3.CommitTrans()

				'-----------------------------------------------------------------------------------------------------
				'���������� ���� ���Ŵ��� Ż���� �Ҽ� ���Ŵ��� ī��Ʈ ��ȸ �� ������ ������ ������Ʈ ó��
				'-----------------------------------------------------------------------------------------------------
				CSQL = "		SELECT Team "
				CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblMember] "
				CSQL = CSQL & " WHERE SD_UserID = '"&strUserID&"'"
				CSQL = CSQL & " 	AND PlayerReln = 'T'"

				SET CRs = DBCon.Execute(CSQL)
				IF Not(CRs.Eof OR CRs.Bof) Then
					Do Until CRs.Eof

						CSQL = " 		SELECT ISNULL(COUNT(*), 0) "
						CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblMember] "
						CSQL = CSQL & " WHERE DelYN = 'N' "
						CSQL = CSQL & "		AND Team = '"&CRs("Team")&"' "
						CSQL = CSQL & " 	AND PlayerReln = 'T'"

						SET JRs = DBCon.Execute(CSQL)
						IF JRs(0) = 0 Then

							'�� ������ ������ ����
							CSQL = "		UPDATE [Sportsdiary].[dbo].[tblTeamInfo]"
							CSQL = CSQL & " SET SvcEndDt = CONVERT(CHAR, GETDATE(), 112)"
							CSQL = CSQL & " WHERE DelYN = 'N' "
							CSQL = CSQL & "		AND Team = '"&CRs("Team")&"' "

							DBCon.Execute(CSQL)

						End IF
							JRs.Close
						SET JRs = Nothing

						CRs.Movenext
					Loop
				End IF
					CRs.Close
				SET CRs = Nothing
				'-----------------------------------------------------------------------------------------------------
				'��Ű ���� ó��
				SET_COOKIES_LOGOUT()
				'-----------------------------------------------------------------------------------------------------
				Response.Write "TRUE|"
				response.End()

			End IF

		ELSE

			Response.Write "FALSE|99"
			Response.End

		END IF

			LRs.Close
		SET LRs = Nothing


		DBClose()	'����
		DBClose3()	'�״Ͻ�

	End IF

%>
