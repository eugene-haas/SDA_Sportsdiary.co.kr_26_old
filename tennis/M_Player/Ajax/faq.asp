<!--#include file="../Library/ajax_config.asp"-->
<%
'	Check_Login()

  dim FAPubCode : FAPubCode = fInject(request("FAPubCode"))

  dim CSQL, CRs

  dim cnt   : cnt   = 0


 	CSQL =  "   	SELECT A1.IDX IDX "
	CSQL = CSQL & "     ,A1.IDX2 IDX2 "
	CSQL = CSQL & "     ,A1.Title Title "
	CSQL = CSQL & "     ,A1.Contents Contents "
	CSQL = CSQL & "     ,A1.FAPubCode FAPubCode "
	CSQL = CSQL & " FROM ("
	CSQL = CSQL & "		SELECT FaqIDX IDX "
	CSQL = CSQL & "       	,ReFaqIDX IDX2 "
	CSQL = CSQL & "       	,Title Title "
	CSQL = CSQL & "       	,Contents Contents "
	CSQL = CSQL & "       	,FAPubCode FAPubCode "
	CSQL = CSQL & "     FROM [SD_tennis].[dbo].[tblSvcFaq] "
	CSQL = CSQL & "     WHERE DelYN = 'N' "
	CSQL = CSQL & "       	AND ReFaqIDX = 0 "
	CSQL = CSQL & "       	AND ViewYN = 'Y' "
	CSQL = CSQL & "       	AND (FAPubCode = 'FA01' OR FAPubCode = 'FA02') "
	CSQL = CSQL & "     UNION ALL "
	CSQL = CSQL & "     SELECT ReFaqIDX IDX "
	CSQL = CSQL & "       	,FaqIDX IDX2 "
	CSQL = CSQL & "       	,Title Title "
	CSQL = CSQL & "       	,Contents Contents "
	CSQL = CSQL & "       	,FAPubCode FAPubCode "
	CSQL = CSQL & "     FROM [SD_tennis].[dbo].[tblSvcFaq] "
	CSQL = CSQL & "     WHERE DelYN = 'N' "
	CSQL = CSQL & "       	AND ReFaqIDX <> 0 "
	CSQL = CSQL & "       	AND ViewYN = 'Y' "
	CSQL = CSQL & "       	AND (FAPubCode = 'FA01' OR FAPubCode = 'FA02') "
	CSQL = CSQL & " ) A1 "
	CSQL = CSQL & " ORDER BY A1.IDX DESC"
	CSQL = CSQL & "   	,A1.IDX2 "
	CSQL = CSQL & "   	,A1.FAPubCode"

	SET CRs = DBCon3.Execute(CSQL)
	IF Not(CRs.Eof Or CRs.Bof) Then
		Do Until CRs.eof


			IF Cint(CRs("IDX2")) = 0 Then
				FndData = FndData & "<div class='panel panel-default'>"
				FndData = FndData & "<a data-toggle='collapse' data-parent='.accordion' href='.faq"&CRs("IDX")&"' class='panel-title'>"
				FndData = FndData & " <p class='panel-ic-q'>Q</p>"
				FndData = FndData & " <p class='panel-txt-q'>"&ReplaceTagReText(CRs("Contents"))&"</p>"
				FndData = FndData & " <p class='ic-caret'><span class='caret'></span></p>"
				FndData = FndData & "</a>"
				FndData = FndData & "</div>"
			Else
				cnt = cnt + 1


				FndData = FndData & "<div class='faq"&CRs("IDX")&" panel-collapse collapse "

				IF cnt = 1 Then FndData = FndData & "in"

				FndData = FndData & "' role='tabpanel'>"

				FndData = FndData & " <div class='panel-body'>"
				FndData = FndData & "   <p class='panel-ic-a'>A</p>"
				FndData = FndData & "   <p class='panel-txt-a'>"&replace(ReplaceTagReText(CRs("Contents")), chr(10), "<br>")&"</p>"
				FndData = FndData & " </div>"
				FndData = FndData & "</div>"

			End IF

			CRs.movenext
		Loop
	Else
		response.Write "<div>등록된 정보가 없습니다</div>"
	End IF

		CRs.Close
	SET CRs = Nothing

	response.Write FndData


	DBClose3()

%>
