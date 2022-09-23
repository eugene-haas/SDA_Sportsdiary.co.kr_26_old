<%
	'----------------------------------------------------------------------
	'@description
	'	딜상품삭제 (기한만료, 완판
	'@param
	'	(string) value : db, Constr 디비객체, 디비 접속Str CD 상점 번호
	'----------------------------------------------------------------------

		Sub delCartSQL(ByRef db, ByRef ConStr, ByVal CD)
			Dim SQL
			SQL = "delete from IC_T_ONLINE_cart where GD_SEQ in ( "
			SQL = SQL & "		Select a.SEQ from IC_T_GDS_INFO as a inner join IC_T_ONLINE_GDS as b on a.SEQ = b.GD_SEQ  "
			SQL = SQL & "		WHERE a.GD_NM in (Select  GD_NM from IC_T_GDS_INFO "
			SQL = SQL & "								Where SEQ In (SELECT GOOD_SEQ	FROM SD_T_DEAL_PRODUCT WHERE (GETDATE() > END_DATE OR (GOOD_CNT - dbo.SD_FN_GET_SALE_CNT(GOOD_SEQ) <= 0)) and DELETE_YN='N') "
			SQL = SQL & "								and DEL_YN = 'N') "
			SQL = SQL & "		and a.DEL_YN = 'N' and b.DEL_YN = 'N' and b.ONLINE_CD = '"&CD&"'    ) "
			SQL = SQL & "	and ONLINE_CD = '"&CD&"' "
'Response.write sql
			Call db.execSQLRs(SQL , null, ConStr)
		End Sub

		Sub delViewLogSQL(ByRef db, ByRef ConStr, ByVal CD)
			Dim SQL
			SQL = "delete from tblViewLog where GD_SEQ in ( "
			SQL = SQL & "		Select a.SEQ from IC_T_GDS_INFO as a inner join IC_T_ONLINE_GDS as b on a.SEQ = b.GD_SEQ  "
			SQL = SQL & "		WHERE a.GD_NM in (Select GD_NM from IC_T_GDS_INFO "
			SQL = SQL & "								Where SEQ In (SELECT GOOD_SEQ	FROM SD_T_DEAL_PRODUCT WHERE GETDATE() > END_DATE And  GOOD_CNT - dbo.SD_FN_GET_SALE_CNT(GOOD_SEQ) <= 0 and DELETE_YN='N') "
			SQL = SQL & "								and DEL_YN = 'N') "
			SQL = SQL & "		and a.DEL_YN = 'N' and b.DEL_YN = 'N' and b.ONLINE_CD = '"&CD&"'    ) "
			SQL = SQL & "	and ONLINE_CD = '"&CD&"' "
			Call db.execSQLRs(SQL , null, ConStr)
		End Sub


		function smsReturnSQL(ByVal SMS_Recive_No, ByVal SMS_Contents)
			Dim SQL, SMS_Send_No
			SMS_Send_No = "15990282" '발송자전화번호
			SQL = "INSERT INTO ITEMCENTER.DBO.T_SEND "
			SQL = SQL & "(  SSUBJECT ,NSVCTYPE ,NADDRTYPE ,SADDRS ,NCONTSTYPE ,SCONTS ,SFROM ,DTSTARTTIME ) "
			SQL = SQL & " VALUES (  '결제완료' ,3 ,0 ,'" & Replace(SMS_Recive_No,"-","") & "' ,0 ,'" & SMS_Contents & "' ,'" & SMS_Send_No & "'  ,GETDATE() ) "

			smsReturnSQL = SQL
		End function

    Function checkDealEndSQL(ByRef db, ByRef ConStr, ByVal CD, ByVal GD_SEQ)
      Dim SQL
      SQL = "	Select a.SEQ from IC_T_GDS_INFO as a inner join IC_T_ONLINE_GDS as b on a.SEQ = b.GD_SEQ  "
      SQL = SQL & "		WHERE a.GD_NM in (Select  GD_NM from IC_T_GDS_INFO "
      SQL = SQL & "								Where SEQ In (SELECT GOOD_SEQ	FROM SD_T_DEAL_PRODUCT WHERE (GETDATE() > END_DATE OR (GOOD_CNT - dbo.SD_FN_GET_SALE_CNT(GOOD_SEQ) <= 0)) and DELETE_YN='N') "
      SQL = SQL & "								and DEL_YN = 'N') "
      SQL = SQL & "		and a.DEL_YN = 'N' and b.DEL_YN = 'N' and b.ONLINE_CD = '"&CD&"'"
      SQL = SQL & "	  and ONLINE_CD = '"&CD&"' and b.GD_SEQ in ("& GD_SEQ &") "
' Response.write sql
      Set rsC = db.ExecSQLReturnRS(SQL , null, ConStr)
      If Not rsC.eof Then
        checkDealEndSQL = true
      End If

    End Function

%>
