<!--#include file="../Library/ajax_config.asp"-->
<%
	dim typeMenu   		: typeMenu 		= fInject(Request("typeMenu"))		'메뉴정보
	dim LedrAdvIDX   	: LedrAdvIDX 	= fInject(Request("LedrAdvIDX"))	'글IDX
	dim ReLedrAdvIDX   	: ReLedrAdvIDX 	= fInject(Request("ReLedrAdvIDX"))	'답변구분
	dim WriterID   		: WriterID 		= fInject(Request("WriterID"))		'글작성자
	dim UserID			: UserID		= decode(request.Cookies("UserID"),0)
	
	dim txtData		'버튼	
	dim LSQL, LRs
	
	IF ReLedrAdvIDX="" OR WriterID="" OR UserID="" Then
		response.End()
	End IF

	
'	RESPONSE.Write "LedrAdvIDX="&LedrAdvIDX&"<BR>"
'	RESPONSE.Write "ReLedrAdvIDX="&ReLedrAdvIDX&"<BR>"
'	RESPONSE.Write "typeMenu="&typeMenu&"<BR>"
'	RESPONSE.Write "UserID="&UserID&"<BR>"
	'=======================================================================================
	'CHK: 답변유무
	'=======================================================================================
	FUNCTION CHK_REPLYINFO(valIDX)
		dim REVALUE
		
		LSQL = " 		SELECT COUNT(*) "
		LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] "
		LSQL = LSQL & " WHERE DelYN = 'N' "
		LSQL = LSQL & "		AND ReplyType = 'T' "
		LSQL = LSQL & "		AND ReLedrAdvIDX <> 0 "
		LSQL = LSQL & "		AND ReLedrAdvIDX = "&valIDX
				
		SET LRs = Dbcon.Execute(LSQL)			
		IF LRs(0)>0 Then
			REVALUE = "TRUE"
		Else
			REVALUE = "FALSE"
		End IF	
			LRs.Close
		SET LRs = Nothing					
		
		CHK_REPLYINFO = REVALUE
		
	END FUNCTION
	'=======================================================================================

	
	'작성자인 경우
	IF WriterID = UserID Then	
		txtData = txtData &"<ul>"
		txtData = txtData &"	<li><a href=""javascript:chk_URL('LIST');"" class='btn show-list'>목록</a></li>"
		
		IF CHK_REPLYINFO(LedrAdvIDX) = "FALSE" Then
			txtData = txtData &"	<li><a href=""javascript:chk_URL('DEL');"" class='btn delete'>삭제</a></li>"
			txtData = txtData &"	<li><a href=""javascript:chk_URL('MOD');"" class='btn modify'>수정</a></li>"
		End IF		
		
		txtData = txtData &"</ul>"	
	Else
		
		SELECT CASE typeMenu
		
			'상담요청하기
			CASE "req_counsel" 	
				txtData = txtData &"<ul>"
				txtData = txtData &"	<li><a href=""javascript:chk_URL('LIST');"" class='btn show-list'>목록</a></li>"
				txtData = txtData &"</ul>"	
			'상담받기
			CASE "from_manager" 

				'팀매니저 질문인경우 부모 답변달기
				IF ReLedrAdvIDX = 0 Then
					txtData = txtData &"<ul>"
					txtData = txtData &"	<li><a href=""javascript:chk_URL('LIST');"" class='btn show-list'>목록</a></li>"
					
					LSQL =" 		SELECT * "					
					LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] " 
					LSQL = LSQL & " WHERE ReLedrAdvIDX = '"&LedrAdvIDX&"' "
					LSQL = LSQL & "		And DelYN = 'N' "
					LSQL = LSQL & "		And SportsGb = '"&SportsGb&"' "
					LSQL = LSQL & "		And UserID = '"&decode(request.Cookies("UserID"),0)&"'"
					
					SET LRs = Dbcon.Execute(LSQL)
					IF LRs.eof or LRs.bof	Then
						txtData = txtData &"	<li><a href=""javascript:chk_URL('REPLY');"" class='btn modify'>답변</a></li>"		
					End IF
						LRs.Close
					SET LRs = Nothing	
					
					txtData = txtData &"</ul>"	
				End IF
			
			'즐겨찾기
			CASE "favorite_counsel" 
				

				'상담요청글인 경우 답변달기
				IF ReLedrAdvIDX = 0 Then
					txtData = txtData &"<ul>"
					txtData = txtData &"	<li><a href=""javascript:chk_URL('LIST');"" class='btn show-list'>목록</a></li>"
					
					LSQL =	" 		SELECT * "					
					LSQL = LSQL & " FROM [Sportsdiary].[dbo].[tblSvcLedrAdv] " 
					LSQL = LSQL & " WHERE ReLedrAdvIDX='"&LedrAdvIDX&"' "
					LSQL = LSQL & "		And SportsGb='"&SportsGb&"' " 
					LSQL = LSQL & "		And UserID='"&decode(request.Cookies("UserID"),0)&"'"
					
					SET LRs = Dbcon.Execute(LSQL)
					IF LRs.eof or LRs.bof	Then
						
						txtData = txtData &"	<li><a href=""javascript:chk_URL('REPLY');"" class='btn modify'>답변</a></li>"		
					End IF
						LRs.Close
					SET LRs = Nothing	
					
					txtData = txtData &"</ul>"	
			 	ELSE
					
					txtData = txtData &"<ul>"
					txtData = txtData &"	<li><a href=""javascript:chk_URL('LIST');"" class='btn show-list'>목록</a></li>"
					txtData = txtData &"</ul>"		
				End IF
				
		END SELECT	
		
	End IF

	
	response.Write txtData

%>