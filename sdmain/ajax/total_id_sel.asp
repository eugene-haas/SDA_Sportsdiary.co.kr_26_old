<!--#include file="../Library/ajax_config.asp"-->
<%
	'=========================================================================================
	'����ȸ�� ID ������ ���� ȸ������ ī��Ʈ ��ȸ
	'=========================================================================================
	dim UserName	: UserName  	= fInject(Trim(Request("UserName")))
	dim UserBirth	: UserBirth  	= fInject(Trim(Request("UserBirth")))
	dim join_IDX 	: join_IDX 		= fInject(Trim(Request("join_IDX")))

	dim SD_UserID	: SD_UserID		= request.Cookies("SD")("UserID")

	dim CSQL, CRs
	dim str_Cookie()	'��Ű����

	IF join_IDX = "" Or UserName = "" OR UserBirth = "" Then
		Response.Write "FALSE|200"
		Response.End
	Else
		On Error Resume Next

		DBcon.BeginTrans()
		DBcon3.BeginTrans()

		'-----------------------------------------------------------------------------------------
		'STEP1. ���õ� ������ ������ ���� ó��
		'-----------------------------------------------------------------------------------------
		CSQL = " 		DELETE [SD_Member].[dbo].[tblMember]"
		CSQL = CSQL & " WHERE DelYN = 'N'"
		CSQL = CSQL & "		AND UserName = '"&UserName&"' "
		CSQL = CSQL & "		AND Birthday = '"&UserBirth&"' "
		CSQL = CSQL & "		AND UserID <> '"&join_IDX&"' "

		DBCon3.Execute(CSQL)
		ErrorNum = ErrorNum + DBCon3.Errors.Count

   		'-----------------------------------------------------------------------------------------
   		'���� 145�� ����
		'STEP2. ���վ��̵�[SD_UserID] ������Ʈ
		'-----------------------------------------------------------------------------------------
		CSQL = " 		UPDATE [SportsDiary].[dbo].[tblMember]"
		CSQL = CSQL & " SET SD_UserID = '"&join_IDX&"' "
		CSQL = CSQL & " WHERE DelYN = 'N'"
		CSQL = CSQL & "		AND UserName = '"&UserName&"' "
		CSQL = CSQL & "		AND Birthday = '"&UserBirth&"' "

		DBCon.Execute(CSQL)
		ErrorNum = ErrorNum + DBCon.Errors.Count

   		'-----------------------------------------------------------------------------------------
		'STEP3. ���վ��̵� ����  SD_GameIDSET value[Y] update
   		'-----------------------------------------------------------------------------------------
		CSQL = " 		UPDATE [SportsDiary].[dbo].[tblMember]"
		CSQL = CSQL & " SET SD_GameIDSET = 'Y' "
        CSQL = CSQL & "     ,SD_UserID = '"&join_IDX&"'"
		CSQL = CSQL & " WHERE DelYN = 'N'"
		CSQL = CSQL & "		AND UserName = '"&UserName&"' "
		CSQL = CSQL & "		AND Birthday = '"&UserBirth&"' "
		CSQL = CSQL & "		AND UserID = '"&join_IDX&"' "

		DBCon.Execute(CSQL)
		ErrorNum = ErrorNum + DBCon.Errors.Count

		'-----------------------------------------------------------------------------------------
		'STEP4. ���վ��̵� ������ ������ �̿� ������ ���� SD_GameIDSET value[N] update
		'-----------------------------------------------------------------------------------------
		CSQL = " 		UPDATE [SportsDiary].[dbo].[tblMember]"
		CSQL = CSQL & " SET SD_GameIDSET = 'N' "
        CSQL = CSQL & "     ,SD_UserID = '"&join_IDX&"'"
		CSQL = CSQL & " WHERE DelYN = 'N'"
		CSQL = CSQL & "		AND UserName = '"&UserName&"' "
		CSQL = CSQL & "		AND Birthday = '"&UserBirth&"' "
		CSQL = CSQL & "		AND UserID <> '"&join_IDX&"' "

		DBCon.Execute(CSQL)
		ErrorNum = ErrorNum + DBCon.Errors.Count

		IF ErrorNum > 0 Then
			DBCon.RollbackTrans()
			DBCon3.RollbackTrans()

			Response.Write "FALSE|66"

		Else

			DBCon.CommitTrans()
			DBCon3.CommitTrans()

			'�α��� �� ���վ��̵� ������ ���� ��Ű�����մϴ�.
			IF SD_UserID <> "" Then
	            'dim MemberIDX, UserName, UserPhone, Birthday, Sex, UserPassGb

				'ȸ��DB ��ȸ�Ͽ� ��Ű���� Sportsdiary.dbo.tblMember
				LSQL =  " 		SELECT MemberIDX "
				LSQL = LSQL & " 	,UserName"
				LSQL = LSQL & " 	,replace(UserPhone,'-','') UserPhone"
				LSQL = LSQL & " 	,Birthday"
				LSQL = LSQL & " 	,Sex"
                LSQL = LSQL & " 	,ISNULL(UserPassGb,'') UserPassGb"     '�ӽú��й�ȣ ����
				LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember]"
				LSQL = LSQL & " WHERE DelYN = 'N'"
				LSQL = LSQL & "		AND UserID = '"&join_IDX&"' "

				SET LRs = DBCon3.Execute(LSQL)
				IF Not(LRs.Eof Or LRs.Bof) Then

					MemberIDX 	= LRs("MemberIDX")
					UserName 	= LRs("UserName")
					UserPhone 	= LRs("UserPhone")
					Birthday 	= LRs("Birthday")
					Sex 		= LRs("Sex")
                    UserPassGb 	= LRs("UserPassGb")

					response.Cookies("SD").Domain = ".sportsdiary.co.kr"
					response.Cookies("SD").path = "/"

					response.Cookies("SD")("UserID")    	= join_IDX					'������ID
					response.Cookies("SD")("UserName")  	= UserName					'�����ڸ�
					response.Cookies("SD")("UserBirth")  	= encode(BirthDay, 0)		'��������
					response.Cookies("SD")("MemberIDX")  	= encode(MemberIDX, 0)		'MemberIDX
					response.Cookies("SD")("UserPhone")  	= encode(UserPhone, 0)		'Phone
					response.Cookies("SD")("Sex")  			= Sex						'����

                    IF UserPassGb <> "" Then response.Cookies("SD")("UserPassGb") = encode(UserPassGb, 0)     '�ӽú��й�ȣ ����[Y:�ӽú��й�ȣ �߱��� ����]

'					'/sdmain/Libary/common_function.asp
'					str_Cookie(1) = SET_INFO_COOKIE(join_IDX, "judo", request.Cookies("SD")("SaveIDYN"))		'��Ű����(����)
'					str_Cookie(2) = SET_INFO_COOKIE(join_IDX, "tennis", request.Cookies("SD")("SaveIDYN"))		'��Ű����(�״Ͻ�)

                    '�� ������ ���ΰ��������� �Ǿ� �ִٸ� �ش� �������� ��Ű�� �����մϴ�.
                    '	../Libary/ajax_config.asp
                    '	LIST_SPORTSTYPE	 = |SD|judo|tennis|bike...  [|SD] ���� ���� ���ڻ���

                    dim txt_SportsGb : txt_SportsGb = split(mid(LIST_SPORTSTYPE, 4, len(LIST_SPORTSTYPE)), "|")

                    redim str_Cookie(Ubound(txt_SportsGb))

                    FOR i = 1 To Ubound(txt_SportsGb)
                        str_Cookie(i) = SET_INFO_COOKIE(join_IDX, txt_SportsGb(i), request.Cookies("SD")("SaveIDYN")) '�� ������ ��Ű����
                    NEXT


				End IF
					LRs.Close
				SET LRs = Nothing

			End IF

			'�α��� ���� �ʰ� [ȸ������>�������� üũ������(combin_check.asp)]���� �Ѿ��� ����
			Response.Write "TRUE|"&SD_UserID


		End IF

		DBClose()
		DBClose3()

	End If
%>
