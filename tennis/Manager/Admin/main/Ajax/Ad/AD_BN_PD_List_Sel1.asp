<!--#include file="../../../dev/dist/config.asp"-->
<%

	iiNowPage = "1"
	iiPagePerData = "10"
	iiBlockPage = "10"
	iSportsGb = "tennis"

	iCateLocate1 = fInject(Request("vCateLocate1"))
	iCateLocate2 = ""
	iCateLocate3 = ""
	iCateLocate4 = ""

	iLocateGb = ""
	iViewYN = ""
	iSearchCol = "T"
	iSearchText = ""
	iSearchCol1 = "S2Y"

  ' 리스트 조회
  iiType = "1"
	iiDivision = "3"

  LSQL = "EXEC AD_tblADLocate_S '" & iiNowPage & "','" & iiPagePerData & "','" & iiBlockPage & "','" & iiType & "','" & iiDivision & "','" & iSportsGb & "','" & iCateLocate1 & "','" & iCateLocate2 & "','" & iCateLocate3 & "','" & iCateLocate4 & "','" & iLocateGb & "','" & iViewYN & "','" & iSearchCol & "','" & iSearchText & "','" & iSearchCol1 & "','','','','',''"
	'response.Write "LSQL=LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = DBCon6.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
%>
<option value="">전체-중분류</option>
<%
    Do Until LRs.Eof

			if LRs("CateLocate2") = "" then

			else
%>
        <option value="<%=LRs("CateLocate2") %>"><%=LRs("CateLocate2Nm") %></option>
<%
			end if

      LRs.MoveNext
    Loop
%>

<%
    Else
%>
<option value="">전체-중분류</option>
<%
  End If

  LRs.close

	DBClose()
%>
