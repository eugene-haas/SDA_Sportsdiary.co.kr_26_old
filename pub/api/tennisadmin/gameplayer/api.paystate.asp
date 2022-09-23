<%
'#############################################
'현장에서 입금체크할때 사용
'#############################################

'request
idx = oJSONoutput.IDX
chk = oJSONoutput.CHK

Set db = new clsDBHelper

SQL = "update tblGameRequest Set PaymentType = '"&chk&"' where RequestIDX = " & idx
Call db.execSQLRs(SQL , null, ConStr)


'==================================================
'금액을 가져오자.
SQL = "select (b.fee + b.fund) as accTotal from tblGameRequest as a inner join tblRGameLevel as b On a.gametitleidx = b.gametitleidx and a.level = b.level where a.RequestIDX = "&idx&" and  b.DelYN = 'N' "
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
If rs.eof Then
	acctotal = 0
else
	acctotal = rs(0)
End If

if CDbl(acctotal) > 0 then

	If chk = "Y" Then
		'가상계좌 정보 사용안함으로 변경
		SQL = "Update TB_RVAS_MAST Set ENTRY_IDNO = CUST_CD , CUST_CD = null  where  CUST_CD = '" & idx & "' "
		Call db.execSQLRs(SQL , null, ConStr)
	Else
		'가상계좌 정보 사용함으로 변경
		SQL = "Update TB_RVAS_MAST Set CUST_CD = ENTRY_IDNO, ENTRY_IDNO = null  where  ENTRY_IDNO = '" & idx & "' "
		Call db.execSQLRs(SQL , null, ConStr)
	End if


	Function datalen(datastr)
		If Len(datastr) = 1 Then
			datalen = "0" & datastr
		else
			datalen = datastr		
		End if
	End function

	SQL = "select VACCT_NO from TB_RVAS_LIST where CUST_CD = '" & idx & "' " '결제처리정보가 있다면
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If rs.eof Then
		If chk = "Y" Then '현장입금 플레그 
			infield = "TR_DATE,TR_SEQ,BANK_CD,ORG_CD,VACCT_NO,STAT_CD,CUST_CD,CUST_NM,TR_TIME,TR_AMT,IN_BANK_CD,IN_NAME,ENTRY_DATE,ENTRY_IDNO,ERP_PROC_YN"
			TRD = Replace(Date(),"-","")
			SQL = " select max(cast(TR_SEQ as int)) from TB_RVAS_LIST where TR_DATE = '" & TRD & "' "
			Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)			

			If isnull(rst(0)) = True then
				TR_SEQ = "1"
			Else
				TR_SEQ = CDbl(rst(0)) + 1
			End if

			BANK_CD = "000"
			ORG_CD = ""
			VACCT_NO = "1"
			CUST_CD = idx
			CUST_NM = "별도입금"
			TR_TIME = datalen(hour(time)) & datalen(minute(time)) & datalen(second(time))
			'TR_AMT = acctotal
			TR_AMT = 0
			IN_BANK_CD = "000"
			IN_NAME = "KATA"
			ENTRY_DATE = TRD & TR_TIME
			ENTRY_IDNO = "KATA"
			ERP_PROC_YN = "Y"

			SQL = "insert into TB_RVAS_LIST ("&infield&") values ('"&TRD&"',"&TR_SEQ&",'"&BANK_CD&"','"&ORG_CD&"','"&VACCT_NO&"','0','"&CUST_CD&"','"&CUST_NM&"','"&TR_TIME&"',"&TR_AMT&",'"&IN_BANK_CD&"','"&IN_NAME&"','"&ENTRY_DATE&"','"&ENTRY_IDNO&"','"&ERP_PROC_YN&"')"
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	Else
		If rs(0) = "1" Then '실입금이 아닌것만 지울것
			SQL = "Delete from  TB_RVAS_LIST where CUST_CD = '" & idx & "' "
			Call db.execSQLRs(SQL , null, ConStr)		
		Else
			'지우면 안됨..
		End if
	End if
End if

'#############################################

Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>


