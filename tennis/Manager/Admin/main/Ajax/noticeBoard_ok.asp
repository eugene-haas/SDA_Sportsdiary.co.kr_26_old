<!--#include file="../Library/config.asp"-->
<%
	'공지사항 수정/삭제/작성 페이지
	dim BRPubCode   : BRPubCode 	= fInject(Request("BRPubCode"))
	dim CIDX 		: CIDX 			= fInject(request("CIDX"))
	dim Title   	: Title 		= ReplaceTagText(fInject(Request("Title")))
	dim Contents   	: Contents 		= ReplaceTagText(fInject(Request("Contents")))
	dim Notice   	: Notice 		= fInject(Request("Notice"))	
	dim act   		: act 			= fInject(Request("act"))
	dim SportsGb	: SportsGb		= fInject(Request("SportsGb"))
	dim UserID		: UserID 		= fInject(Request("UserID"))
	dim UserName	: UserName 		= fInject(Request("UserName"))

	IF UserName = "관리자" OR UserName = "" Then UserName = "스포츠다이어리"

	dim CSQL

	IF act = "" Then
		response.Write "FALSE|"
		response.End()
	ELSE

		SELECT CASE act
			CASE "WR"
				IF Title = "" OR Contents = "" OR BRPubCode = "" Then
					response.Write "FALSE|"
					response.End()
				ELSE
					CSQL =" INSERT INTO [SD_tennis].[dbo].[tblSvcNotice] ( "&_
							"	   [BRPubCode] "&_
							"	  ,[SportsGb] "&_
							"	  ,[Notice] "&_
							"	  ,[Title] "&_
							"	  ,[Contents] "&_
							"	  ,[UserID] "&_
							"	  ,[UserName] "&_
							"	  ,[WriteDate] "&_
							"	  ,[WorkDt] "&_
							"	  ,[DelYN] "&_
							"	  ,[ViewTp] "&_
							"	  ,[ViewCnt] "&_
							") VALUES( "&_
							"	 '"&BRPubCode&"' "&_
							"	,'"&SportsGb&"' "&_
							"	,'"&Notice&"' "&_
							"	,'"&Title&"' "&_
							"	,'"&Contents&"' "&_
							"	,'"&UserID&"' "&_
							"	,'"&UserName&"' "&_
							"	,GetDate() "&_
							"	,GetDate() "&_
							"	,'N' "&_
							"	,'A' "&_
							"	,0) "

					DBCon5.Execute(CSQL)

					response.Write "TRUE|66"
					response.End()

				END IF

			CASE "MOD"
				IF CIDX = "" Then
					response.Write "FALSE|"
					response.End()
				ELSE

					CSQL = "		UPDATE [SD_tennis].[dbo].[tblSvcNotice] "
					CSQL = CSQL & "	SET BRPubCode = '"&BRPubCode&"' "
					CSQL = CSQL & "		,Notice = '"&Notice&"' "
					CSQL = CSQL & "		,Title = '"&Title&"' "
					CSQL = CSQL & "		,Contents = '"&Contents&"' "
					CSQL = CSQL & "		,WorkDt = GetDate() "
					CSQL = CSQL & "	WHERE NtcIDX = '"&CIDX&"' "
					CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "

					DBCon5.Execute(CSQL)

					response.Write "TRUE|99"
					response.End()
				END IF

			CASE "DEL"
				IF CIDX = "" Then
					response.Write "FALSE|"
					response.End()
				ELSE

					CSQL = "		UPDATE [SD_tennis].[dbo].[tblSvcNotice] "
					CSQL = CSQL & "	SET DelYN = 'Y' "
					CSQL = CSQL & "		,WorkDt = GetDate() "
					CSQL = CSQL & "	WHERE NtcIDX = '"&CIDX&"' "
					CSQL = CSQL & "		AND SportsGb = '"&SportsGb&"' "

					DBCon5.Execute(CSQL)

					response.Write "TRUE|100"
					response.End()
				END IF

		END SELECT

	END IF

%>
