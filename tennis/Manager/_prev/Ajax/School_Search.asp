<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	strtp = fInject(request("tp"))
	strkey = fInject(decode(request("key"),0))

	ViewCnt = "20"



	Search_Text = fInject(Request("Search_Text"))
	Level_Type  = fInject(Request("Level_Type"))

	If Search_Text = "" Then 
		Response.End
	End If 




	LSQL = "SELECT "
  LSQL = LSQL&" Top "&ViewCnt
	LSQL = LSQL&" SchIDX,"
	LSQL = LSQL&" SportsDiary.dbo.FN_PubName(Sido) AS Sido,"
	LSQL = LSQL&" SchoolName,"
	LSQL = LSQL&" TeamGb "
	LSQL = LSQL&" FROM SportsDiary.dbo.tblSchoolList "
	LSQL = LSQL&" WHERE SchoolName like '%"&Search_Text&"%'"

	If Trim(strkey) <> "" Then 
		LSQL = LSQL&" AND SchIDX < " & strkey
	End If 

	LSQL = LSQL&" ORDER BY SchIDX DESC "	
		
		Set LRs = Dbcon.Execute(LSQL)

	CntSQL = "SELECT "
  CntSQL = CntSQL &" Count(SchIDX) AS Cnt "
	CntSQL = CntSQL &" FROM SportsDiary.dbo.tblSchoolList "
	CntSQL = CntSQL &" WHERE DelYN='N'"
	CntSQL = CntSQL &" AND SchoolName like '%"&Search_Text&"%'" 	


	Set CRs = Dbcon.Execute(CntSQL)


	Dbclose()
	
	'다음조회 데이타는 행을 변경한다
	If Strtp = "N" Then 
	End If 



	If LRs.Eof Or LRs.Bof Then 
		Response.Write "null"
		Response.End
	Else 
		intCnt = 0

		Do Until LRs.Eof 
%>
	<tr>
		<th scope="row"><a href="javascript:chk_data('<%=LRs("SchIDX")%>','<%=LRs("SchoolName")%>','<%=LRs("TeamGb")%>','<%=Level_Type%>')" class="btn-list type2">선택 <i class="fa fa-caret-right" aria-hidden="true"></i></a></th>
		<td onclick="chk_data('<%=LRs("SchIDX")%>','<%=LRs("SchoolName")%>','<%=LRs("TeamGb")%>','<%=Level_Type%>')"><%=LRs("Sido")%></td>
		<td onclick="chk_data('<%=LRs("SchIDX")%>','<%=LRs("SchoolName")%>','<%=LRs("TeamGb")%>','<%=Level_Type%>')"><%=LRs("SchoolName")%></td>
	</tr>
<%
				'다음조회를 위하여 키를 생성한다.
				strsetkey = LRs("SchIDX")
			LRs.MoveNext

			intCnt = intCnt + 1

		Loop 
	End If 
%>
ㅹ<%=encode(strsetkey,0)%>ㅹ<%=strtp%>ㅹ<%=Crs("Cnt")%>ㅹ<%=intCnt%>
<%
		LRs.Close
   Set LRs = Nothing
   
   CRs.Close
   Set CRs = Nothing
%>
